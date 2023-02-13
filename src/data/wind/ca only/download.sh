#!/bin/bash

GREP_OPTIONS=''

cookiejar=$(mktemp cookies.XXXXXXXXXX)
netrc=$(mktemp netrc.XXXXXXXXXX)
chmod 0600 "$cookiejar" "$netrc"
function finish {
  rm -rf "$cookiejar" "$netrc"
}

trap finish EXIT
WGETRC="$wgetrc"

prompt_credentials() {
    echo "Enter your Earthdata Login or other provider supplied credentials"
    read -p "Username (jmeyer89): " username
    username=${username:-jmeyer89}
    read -s -p "Password: " password
    echo "machine urs.earthdata.nasa.gov login $username password $password" >> $netrc
    echo
}

exit_with_error() {
    echo
    echo "Unable to Retrieve Data"
    echo
    echo $1
    echo
    echo "https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2022/MERRA2_400.tavgM_2d_slv_Nx.202202.nc4"
    echo
    exit 1
}

prompt_credentials
  detect_app_approval() {
    approved=`curl -s -b "$cookiejar" -c "$cookiejar" -L --max-redirs 5 --netrc-file "$netrc" https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2022/MERRA2_400.tavgM_2d_slv_Nx.202202.nc4 -w %{http_code} | tail  -1`
    if [ "$approved" -ne "302" ]; then
        # User didn't approve the app. Direct users to approve the app in URS
        exit_with_error "Please ensure that you have authorized the remote application by visiting the link below "
    fi
}

setup_auth_curl() {
    # Firstly, check if it require URS authentication
    status=$(curl -s -z "$(date)" -w %{http_code} https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2022/MERRA2_400.tavgM_2d_slv_Nx.202202.nc4 | tail -1)
    if [[ "$status" -ne "200" && "$status" -ne "304" ]]; then
        # URS authentication is required. Now further check if the application/remote service is approved.
        detect_app_approval
    fi
}

setup_auth_wget() {
    # The safest way to auth via curl is netrc. Note: there's no checking or feedback
    # if login is unsuccessful
    touch ~/.netrc
    chmod 0600 ~/.netrc
    credentials=$(grep 'machine urs.earthdata.nasa.gov' ~/.netrc)
    if [ -z "$credentials" ]; then
        cat "$netrc" >> ~/.netrc
    fi
}

fetch_urls() {
  if command -v curl >/dev/null 2>&1; then
      setup_auth_curl
      while read -r line; do
        # Get everything after the last '/'
        filename="${line##*/}"

        # Strip everything after '?'
        stripped_query_params="${filename%%\?*}"

        curl -f -b "$cookiejar" -c "$cookiejar" -L --netrc-file "$netrc" -g -o $stripped_query_params -- $line && echo || exit_with_error "Command failed with error. Please retrieve the data manually."
      done;
  elif command -v wget >/dev/null 2>&1; then
      # We can't use wget to poke provider server to get info whether or not URS was integrated without download at least one of the files.
      echo
      echo "WARNING: Can't find curl, use wget instead."
      echo "WARNING: Script may not correctly identify Earthdata Login integrations."
      echo
      setup_auth_wget
      while read -r line; do
        # Get everything after the last '/'
        filename="${line##*/}"

        # Strip everything after '?'
        stripped_query_params="${filename%%\?*}"

        wget --load-cookies "$cookiejar" --save-cookies "$cookiejar" --output-document $stripped_query_params --keep-session-cookies -- $line && echo || exit_with_error "Command failed with error. Please retrieve the data manually."
      done;
  else
      exit_with_error "Error: Could not find a command-line downloader.  Please install curl or wget"
  fi
}

fetch_urls <<'EDSCEOF'
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2022/MERRA2_400.tavgM_2d_slv_Nx.202202.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2022/MERRA2_400.tavgM_2d_slv_Nx.202201.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2021/MERRA2_400.tavgM_2d_slv_Nx.202102.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2021/MERRA2_400.tavgM_2d_slv_Nx.202101.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2020/MERRA2_400.tavgM_2d_slv_Nx.202002.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2020/MERRA2_400.tavgM_2d_slv_Nx.202001.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2019/MERRA2_400.tavgM_2d_slv_Nx.201902.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2019/MERRA2_400.tavgM_2d_slv_Nx.201901.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2018/MERRA2_400.tavgM_2d_slv_Nx.201802.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2018/MERRA2_400.tavgM_2d_slv_Nx.201801.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2017/MERRA2_400.tavgM_2d_slv_Nx.201702.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2017/MERRA2_400.tavgM_2d_slv_Nx.201701.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2016/MERRA2_400.tavgM_2d_slv_Nx.201602.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2016/MERRA2_400.tavgM_2d_slv_Nx.201601.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2015/MERRA2_400.tavgM_2d_slv_Nx.201502.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2015/MERRA2_400.tavgM_2d_slv_Nx.201501.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2014/MERRA2_400.tavgM_2d_slv_Nx.201402.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2014/MERRA2_400.tavgM_2d_slv_Nx.201401.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2013/MERRA2_400.tavgM_2d_slv_Nx.201302.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2013/MERRA2_400.tavgM_2d_slv_Nx.201301.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2012/MERRA2_400.tavgM_2d_slv_Nx.201202.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2012/MERRA2_400.tavgM_2d_slv_Nx.201201.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2011/MERRA2_400.tavgM_2d_slv_Nx.201102.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2011/MERRA2_400.tavgM_2d_slv_Nx.201101.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2010/MERRA2_300.tavgM_2d_slv_Nx.201002.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2010/MERRA2_300.tavgM_2d_slv_Nx.201001.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2009/MERRA2_300.tavgM_2d_slv_Nx.200902.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2009/MERRA2_300.tavgM_2d_slv_Nx.200901.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2008/MERRA2_300.tavgM_2d_slv_Nx.200802.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2008/MERRA2_300.tavgM_2d_slv_Nx.200801.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2007/MERRA2_300.tavgM_2d_slv_Nx.200702.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2007/MERRA2_300.tavgM_2d_slv_Nx.200701.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2006/MERRA2_300.tavgM_2d_slv_Nx.200602.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2006/MERRA2_300.tavgM_2d_slv_Nx.200601.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2005/MERRA2_300.tavgM_2d_slv_Nx.200502.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2005/MERRA2_300.tavgM_2d_slv_Nx.200501.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2004/MERRA2_300.tavgM_2d_slv_Nx.200402.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2004/MERRA2_300.tavgM_2d_slv_Nx.200401.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2003/MERRA2_300.tavgM_2d_slv_Nx.200302.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2003/MERRA2_300.tavgM_2d_slv_Nx.200301.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2002/MERRA2_300.tavgM_2d_slv_Nx.200202.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2002/MERRA2_300.tavgM_2d_slv_Nx.200201.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2001/MERRA2_300.tavgM_2d_slv_Nx.200102.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2001/MERRA2_300.tavgM_2d_slv_Nx.200101.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2000/MERRA2_200.tavgM_2d_slv_Nx.200002.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2000/MERRA2_200.tavgM_2d_slv_Nx.200001.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1999/MERRA2_200.tavgM_2d_slv_Nx.199902.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1999/MERRA2_200.tavgM_2d_slv_Nx.199901.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1998/MERRA2_200.tavgM_2d_slv_Nx.199802.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1998/MERRA2_200.tavgM_2d_slv_Nx.199801.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1997/MERRA2_200.tavgM_2d_slv_Nx.199702.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1997/MERRA2_200.tavgM_2d_slv_Nx.199701.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1996/MERRA2_200.tavgM_2d_slv_Nx.199602.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1996/MERRA2_200.tavgM_2d_slv_Nx.199601.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1995/MERRA2_200.tavgM_2d_slv_Nx.199502.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1995/MERRA2_200.tavgM_2d_slv_Nx.199501.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1994/MERRA2_200.tavgM_2d_slv_Nx.199402.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1994/MERRA2_200.tavgM_2d_slv_Nx.199401.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1993/MERRA2_200.tavgM_2d_slv_Nx.199302.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1993/MERRA2_200.tavgM_2d_slv_Nx.199301.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1992/MERRA2_200.tavgM_2d_slv_Nx.199202.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1992/MERRA2_200.tavgM_2d_slv_Nx.199201.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1991/MERRA2_100.tavgM_2d_slv_Nx.199102.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1991/MERRA2_100.tavgM_2d_slv_Nx.199101.nc4
EDSCEOF