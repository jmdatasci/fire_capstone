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
    echo "https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2022/MERRA2_400.tavgM_2d_slv_Nx.202212.nc4"
    echo
    exit 1
}

prompt_credentials
  detect_app_approval() {
    approved=`curl -s -b "$cookiejar" -c "$cookiejar" -L --max-redirs 5 --netrc-file "$netrc" https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2022/MERRA2_400.tavgM_2d_slv_Nx.202212.nc4 -w %{http_code} | tail  -1`
    if [ "$approved" -ne "302" ]; then
        # User didn't approve the app. Direct users to approve the app in URS
        exit_with_error "Please ensure that you have authorized the remote application by visiting the link below "
    fi
}

setup_auth_curl() {
    # Firstly, check if it require URS authentication
    status=$(curl -s -z "$(date)" -w %{http_code} https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2022/MERRA2_400.tavgM_2d_slv_Nx.202212.nc4 | tail -1)
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
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2002/MERRA2_300.tavgM_2d_slv_Nx.200206.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2002/MERRA2_300.tavgM_2d_slv_Nx.200205.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2002/MERRA2_300.tavgM_2d_slv_Nx.200204.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2002/MERRA2_300.tavgM_2d_slv_Nx.200203.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2002/MERRA2_300.tavgM_2d_slv_Nx.200202.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2002/MERRA2_300.tavgM_2d_slv_Nx.200201.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2001/MERRA2_300.tavgM_2d_slv_Nx.200112.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2001/MERRA2_300.tavgM_2d_slv_Nx.200111.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2001/MERRA2_300.tavgM_2d_slv_Nx.200110.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2001/MERRA2_300.tavgM_2d_slv_Nx.200109.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2001/MERRA2_300.tavgM_2d_slv_Nx.200108.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2001/MERRA2_300.tavgM_2d_slv_Nx.200107.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2001/MERRA2_300.tavgM_2d_slv_Nx.200106.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2001/MERRA2_300.tavgM_2d_slv_Nx.200105.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2001/MERRA2_300.tavgM_2d_slv_Nx.200104.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2001/MERRA2_300.tavgM_2d_slv_Nx.200103.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2001/MERRA2_300.tavgM_2d_slv_Nx.200102.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2001/MERRA2_300.tavgM_2d_slv_Nx.200101.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2000/MERRA2_200.tavgM_2d_slv_Nx.200012.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2000/MERRA2_200.tavgM_2d_slv_Nx.200011.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2000/MERRA2_200.tavgM_2d_slv_Nx.200010.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2000/MERRA2_200.tavgM_2d_slv_Nx.200009.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2000/MERRA2_200.tavgM_2d_slv_Nx.200008.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2000/MERRA2_200.tavgM_2d_slv_Nx.200007.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2000/MERRA2_200.tavgM_2d_slv_Nx.200006.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2000/MERRA2_200.tavgM_2d_slv_Nx.200005.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2000/MERRA2_200.tavgM_2d_slv_Nx.200004.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2000/MERRA2_200.tavgM_2d_slv_Nx.200003.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2000/MERRA2_200.tavgM_2d_slv_Nx.200002.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/2000/MERRA2_200.tavgM_2d_slv_Nx.200001.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1999/MERRA2_200.tavgM_2d_slv_Nx.199912.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1999/MERRA2_200.tavgM_2d_slv_Nx.199911.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1999/MERRA2_200.tavgM_2d_slv_Nx.199910.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1999/MERRA2_200.tavgM_2d_slv_Nx.199909.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1999/MERRA2_200.tavgM_2d_slv_Nx.199908.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1999/MERRA2_200.tavgM_2d_slv_Nx.199907.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1999/MERRA2_200.tavgM_2d_slv_Nx.199906.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1999/MERRA2_200.tavgM_2d_slv_Nx.199905.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1999/MERRA2_200.tavgM_2d_slv_Nx.199904.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1999/MERRA2_200.tavgM_2d_slv_Nx.199903.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1999/MERRA2_200.tavgM_2d_slv_Nx.199902.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1999/MERRA2_200.tavgM_2d_slv_Nx.199901.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1998/MERRA2_200.tavgM_2d_slv_Nx.199812.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1998/MERRA2_200.tavgM_2d_slv_Nx.199811.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1998/MERRA2_200.tavgM_2d_slv_Nx.199810.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1998/MERRA2_200.tavgM_2d_slv_Nx.199809.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1998/MERRA2_200.tavgM_2d_slv_Nx.199808.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1998/MERRA2_200.tavgM_2d_slv_Nx.199807.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1998/MERRA2_200.tavgM_2d_slv_Nx.199806.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1998/MERRA2_200.tavgM_2d_slv_Nx.199805.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1998/MERRA2_200.tavgM_2d_slv_Nx.199804.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1998/MERRA2_200.tavgM_2d_slv_Nx.199803.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1998/MERRA2_200.tavgM_2d_slv_Nx.199802.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1998/MERRA2_200.tavgM_2d_slv_Nx.199801.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1997/MERRA2_200.tavgM_2d_slv_Nx.199712.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1997/MERRA2_200.tavgM_2d_slv_Nx.199711.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1997/MERRA2_200.tavgM_2d_slv_Nx.199710.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1997/MERRA2_200.tavgM_2d_slv_Nx.199709.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1997/MERRA2_200.tavgM_2d_slv_Nx.199708.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1997/MERRA2_200.tavgM_2d_slv_Nx.199707.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1997/MERRA2_200.tavgM_2d_slv_Nx.199706.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1997/MERRA2_200.tavgM_2d_slv_Nx.199705.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1997/MERRA2_200.tavgM_2d_slv_Nx.199704.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1997/MERRA2_200.tavgM_2d_slv_Nx.199703.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1997/MERRA2_200.tavgM_2d_slv_Nx.199702.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1997/MERRA2_200.tavgM_2d_slv_Nx.199701.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1996/MERRA2_200.tavgM_2d_slv_Nx.199612.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1996/MERRA2_200.tavgM_2d_slv_Nx.199611.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1996/MERRA2_200.tavgM_2d_slv_Nx.199610.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1996/MERRA2_200.tavgM_2d_slv_Nx.199609.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1996/MERRA2_200.tavgM_2d_slv_Nx.199608.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1996/MERRA2_200.tavgM_2d_slv_Nx.199607.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1996/MERRA2_200.tavgM_2d_slv_Nx.199606.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1996/MERRA2_200.tavgM_2d_slv_Nx.199605.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1996/MERRA2_200.tavgM_2d_slv_Nx.199604.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1996/MERRA2_200.tavgM_2d_slv_Nx.199603.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1996/MERRA2_200.tavgM_2d_slv_Nx.199602.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1996/MERRA2_200.tavgM_2d_slv_Nx.199601.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1995/MERRA2_200.tavgM_2d_slv_Nx.199512.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1995/MERRA2_200.tavgM_2d_slv_Nx.199511.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1995/MERRA2_200.tavgM_2d_slv_Nx.199510.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1995/MERRA2_200.tavgM_2d_slv_Nx.199509.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1995/MERRA2_200.tavgM_2d_slv_Nx.199508.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1995/MERRA2_200.tavgM_2d_slv_Nx.199507.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1995/MERRA2_200.tavgM_2d_slv_Nx.199506.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1995/MERRA2_200.tavgM_2d_slv_Nx.199505.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1995/MERRA2_200.tavgM_2d_slv_Nx.199504.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1995/MERRA2_200.tavgM_2d_slv_Nx.199503.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1995/MERRA2_200.tavgM_2d_slv_Nx.199502.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1995/MERRA2_200.tavgM_2d_slv_Nx.199501.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1994/MERRA2_200.tavgM_2d_slv_Nx.199412.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1994/MERRA2_200.tavgM_2d_slv_Nx.199411.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1994/MERRA2_200.tavgM_2d_slv_Nx.199410.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1994/MERRA2_200.tavgM_2d_slv_Nx.199409.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1994/MERRA2_200.tavgM_2d_slv_Nx.199408.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1994/MERRA2_200.tavgM_2d_slv_Nx.199407.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1994/MERRA2_200.tavgM_2d_slv_Nx.199406.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1994/MERRA2_200.tavgM_2d_slv_Nx.199405.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1994/MERRA2_200.tavgM_2d_slv_Nx.199404.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1994/MERRA2_200.tavgM_2d_slv_Nx.199403.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1994/MERRA2_200.tavgM_2d_slv_Nx.199402.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1994/MERRA2_200.tavgM_2d_slv_Nx.199401.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1993/MERRA2_200.tavgM_2d_slv_Nx.199312.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1993/MERRA2_200.tavgM_2d_slv_Nx.199311.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1993/MERRA2_200.tavgM_2d_slv_Nx.199310.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1993/MERRA2_200.tavgM_2d_slv_Nx.199309.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1993/MERRA2_200.tavgM_2d_slv_Nx.199308.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1993/MERRA2_200.tavgM_2d_slv_Nx.199307.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1993/MERRA2_200.tavgM_2d_slv_Nx.199306.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1993/MERRA2_200.tavgM_2d_slv_Nx.199305.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1993/MERRA2_200.tavgM_2d_slv_Nx.199304.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1993/MERRA2_200.tavgM_2d_slv_Nx.199303.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1993/MERRA2_200.tavgM_2d_slv_Nx.199302.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1993/MERRA2_200.tavgM_2d_slv_Nx.199301.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1992/MERRA2_200.tavgM_2d_slv_Nx.199212.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1992/MERRA2_200.tavgM_2d_slv_Nx.199211.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1992/MERRA2_200.tavgM_2d_slv_Nx.199210.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1992/MERRA2_200.tavgM_2d_slv_Nx.199209.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1992/MERRA2_200.tavgM_2d_slv_Nx.199208.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1992/MERRA2_200.tavgM_2d_slv_Nx.199207.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1992/MERRA2_200.tavgM_2d_slv_Nx.199206.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1992/MERRA2_200.tavgM_2d_slv_Nx.199205.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1992/MERRA2_200.tavgM_2d_slv_Nx.199204.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1992/MERRA2_200.tavgM_2d_slv_Nx.199203.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1992/MERRA2_200.tavgM_2d_slv_Nx.199202.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1992/MERRA2_200.tavgM_2d_slv_Nx.199201.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1991/MERRA2_100.tavgM_2d_slv_Nx.199112.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1991/MERRA2_100.tavgM_2d_slv_Nx.199111.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1991/MERRA2_100.tavgM_2d_slv_Nx.199110.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1991/MERRA2_100.tavgM_2d_slv_Nx.199109.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1991/MERRA2_100.tavgM_2d_slv_Nx.199108.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1991/MERRA2_100.tavgM_2d_slv_Nx.199107.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1991/MERRA2_100.tavgM_2d_slv_Nx.199106.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1991/MERRA2_100.tavgM_2d_slv_Nx.199105.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1991/MERRA2_100.tavgM_2d_slv_Nx.199104.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1991/MERRA2_100.tavgM_2d_slv_Nx.199103.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1991/MERRA2_100.tavgM_2d_slv_Nx.199102.nc4
https://data.gesdisc.earthdata.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1991/MERRA2_100.tavgM_2d_slv_Nx.199101.nc4
EDSCEOF