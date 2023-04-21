fire_capstone
==============================

Data Science Capstone Project to Analyze Wildfire impact on Pediatric Health in California

<html lang="en">
<head>
	<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- ><meta name="description" content="Start your development with Dorang landing page.">
    <meta name="author" content="Devcrud"> -->
    <title>Capstone | Fires and Mental Health in Kids</title>
    <!-- font icons -->
    <link rel="stylesheet" href="assets/vendors/themify-icons/css/themify-icons.css">

    <!-- Bootstrap + Dorang main styles -->
	<link rel="stylesheet" href="assets/css/dorang.css">

</head>
<body data-spy="scroll" data-target=".navbar" data-offset="40" id="home" class="dark-theme">
    
    <!-- page navbar -->
    <nav class="page-navbar" data-spy="affix" data-offset-top="10">
        <ul class="nav-navbar container">
			<li class="nav-item"><a href="#top" class="nav-link">Top</a></li>
            <li class="nav-item"><a href="#motivation" class="nav-link">Motivation</a></li>
            <li class="nav-item"><a href="#data" class="nav-link">Data</a></li>
            <li class="nav-item"><a href="#methodology" class="nav-link">Methodology</a></li>
			<li class="nav-item"><a href="#results" class="nav-link">Results</a></li>
			<li class="nav-item"><a href="#team" class="nav-link">Team</a></li>
           <!-- <li class="nav-item search">
                <a href="javascript:void(0)" class="nav-link search-toggle"><i class="ti-search"></i> Search</a>
                <div class="search-wrapper">
                    <form>
                        <input type="search" class="form-control" name="" placeholder="hit enter to search">
                    </form>
                </div>
            </li> -->
        </ul>
    </nav><!-- end of page navbar -->
	<!-- 
    <div class="theme-selector">
        <a href="javascript:void(0)" class="spinner">
            <i class="ti-paint-bucket"></i>
        </a>
        <div class="body">
            <a href="javascript:void(0)" class="light"></a>
            <a href="javascript:void(0)" class="dark"></a>
        </div>
    </div>  
		-->

    <!-- page header -->
    <header class="header">
        <div class="overlay"></div>
        <div class="header-content">
            <h1 class="header-title">Fire’s Immediate and Residual Effects on Youth Mental Health</h1>
			<div class="col-md-10 col-lg-8 m-auto">
            <p class="header-subtitle">Do fires cause an increase in mental health diagnoses in kids?</p>
			<p class="header-subtitle">Our capstone project examines the relationship between PM2.5 and the incidence of youth mental health diagnoses from 2000 			to 2016.</p>
		</div>
          <!-- <button class="btn btn-theme-color modal-toggle"><i class="ti-control-play text-danger"></i> Watch Video</button>
-->
        </div>
    </header><!-- end of page header -->

    <!-- 
    <div class="modalBox">
        <div class="modalBox-body">
            <iframe width="100%" height="450px" class="border-0" 
            src="https://www.youtube.com/embed/tgbNyZ7vqY?controls=0">
            </iframe>
        </div>          
    </div><!-- end of modal -->

    <!-- page container -->
    <div class="container page-container">
    	<div class="col-md-10 col-lg-8 m-auto">
            <h6 id="motivation" class="title mb-4 mt-2 pt-2">Motivation</h6>
            <p class="mb-5">Fires in California have become a major public safety and public health concern. Effects of wildfires on physiological health are well documented but there is little research that investigates and quantifies the causal effect of wildfires on mental health. </p>
			<p class="mb-5">Our mission is to understand the impact of wildfires on youth mental health to help public health officials and medical practitioners design better disaster responses that anticipate mental health needs in children after fires.
 		   </p>
   			<p class="mb-5">Below: Cumulative Acres Burned by Wildfires since 1991
    		   </p>
           </div>
		<div class="viz">
		<div class='tableauPlaceholder' id='viz1680761337307' style='position: relative'><noscript><a href='#'><img alt='California Wildfires ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Fi&#47;Fires_16785554770880&#47;CAMap&#47;1_rss.png' style='border: none' /></a></noscript><object class='tableauViz'  style='display:none;'><param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' /> <param name='embed_code_version' value='3' /> <param name='site_root' value='' /><param name='name' value='Fires_16785554770880&#47;CAMap' /><param name='tabs' value='no' /><param name='toolbar' value='yes' /><param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Fi&#47;Fires_16785554770880&#47;CAMap&#47;1.png' /> <param name='animate_transition' value='yes' /><param name='display_static_image' value='yes' /><param name='display_spinner' value='yes' /><param name='display_overlay' value='yes' /><param name='display_count' value='yes' /><param name='language' value='en-US' /></object></div>                <script type='text/javascript'>                    var divElement = document.getElementById('viz1680761337307');                    var vizElement = divElement.getElementsByTagName('object')[0];                    vizElement.style.width='100%';vizElement.style.height=(divElement.offsetWidth*0.75)+'px';                    var scriptElement = document.createElement('script');                    scriptElement.src = 'https://public.tableau.com/javascripts/api/viz_v1.js';                    vizElement.parentNode.insertBefore(scriptElement, vizElement);                </script>
 </div>


    <!-- page container -->
    <div class="container page-container">
    	<div class="col-md-10 col-lg-8 m-auto">
            <h6 id="data" class="title mb-4 mt-2 pt-2">Data</h6>
            <p class="mb-5">Our research focused on specific mental health related diagnosis categories encompassing anxiety, depression and self-harm for children under age 19.  
</p>
			
			<style type="text/css">
			.tg  {border-collapse:collapse;border-spacing:0;}
			.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
			  overflow:hidden;padding:10px 5px;word-break:normal;}
			.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
			  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
			.tg .tg-0pky{border-color:inherit;text-align:left;vertical-align:top}
			</style>
			<table class="tg">
			<thead>
			  <tr>
			    <th class="tg-0pky"><h5 class="card-title">Data</h5></th>
			    <th class="tg-0pky"><h5 class="card-title">Source</h5></th>
				<th class="tg-0pky"><h5 class="card-title">Rationale</h5></th>
			  </tr>
			</thead>
			<tbody>
  			<tr>
    			<td class="tg-0pky"><p class="mb-5">Mental Health Outcomes</p></td>
    			<td class="tg-0pky"><p class="mb-5">CA Department of Healh Care Access and Information</p></td>
    			<td class="tg-0pky"><p class="mb-5">Hospital visits for patients under 19 with medical diagnosis codes (anonymized), second stage outcome variable</p></td>
    		</tr>
			 <tr>
			    <td class="tg-0pky"><p class="mb-5">California Wildfire Perimeters</p></td>
			    <td class="tg-0pky"><p class="mb-5">CalFire</p></td>
				<td class="tg-0pky"><p class="mb-5">Wildfire data used in instrumental variable to calculate areas exposed to smoke and PM2.5</p></td>
			  </tr>
			  <tr>
  			    <td class="tg-0pky"><p class="mb-5">Air Pollution</p></td>
  			    <td class="tg-0pky"><p class="mb-5">University of Washington, Environmental Protection Agency</p></td>
  				<td class="tg-0pky"><p class="mb-5">PM2.5 amount is our first stage outcome variable</p></td>
  			  </tr>
			  </tr>
			  <tr>
  			    <td class="tg-0pky"><p class="mb-5">Wind Speed and Direction</p></td>
  			    <td class="tg-0pky"><p class="mb-5">NASA</p></td>
  				<td class="tg-0pky"><p class="mb-5">Wildfire smoke exposure is subject to wind direction.</p></td>
  			  </tr>
			  <tr>
  			    <td class="tg-0pky"><p class="mb-5">Socioeconomic Factors</p></td>
  			    <td class="tg-0pky"><p class="mb-5">US Census</p></td>
  				<td class="tg-0pky"><p class="mb-5">Percent population by age, education level, mean and median income</p></td>
  			  </tr>
			</tbody>
			</table>
			<p class="mb-5"></p>
			
			
		<p>
		</p>

    </div> <!-- end of page container -->

    <!-- page container -->
    <div class="container page-container">
    	<div class="col-md-10 col-lg-8 m-auto">
            <h6 id="methodology" class="title mb-4 mt-2 pt-2">Methodology</h6>
            <p class="mb-5">A simple approach would be to use a baseline OLS model, but due to unobserved factors not captured by our data, any estimates from this approach would be biased. Instead, we used a 2 stage least squares regression model to estimate causal effects.</p>
			<p class="mb-5">For the first stage model, we engineered a feature, or instrumental variable (IV), to predict PM2.5 across California zip codes over time. The IV is a function of wind direction and wind speed from a zip code to a wildfire, and controls for demographic factors like household income and population characteristic. There are two important assumptions for the IV: the instrument has a causal effect on the outcome variable (PM2.5), and the instrument affects medical diagnosis rates ONLY through PM2.5.</p>
			<p class="mb-5">For the second stage model, we use the estimates of PM2.5 derived from the first stage to estimate the causal effects on youth mental health diagnosis (outcome variable), which includes patients under age 19 diagnosed with anxiety, depression, or self-harm.
			</p>
			<img src="assets/imgs/2sls.png" class="card-img" alt="Two Stage Least Squares Framework">
        </div>

    </div> <!-- end of page container -->
	
    <!-- page container -->
    <div class="container page-container">
    	<div class="col-md-10 col-lg-8 m-auto">
            <h6 id="results" class="title mb-4 mt-2 pt-2">Results</h6>
			<h5> Stage 1 Model</h5>
            <p class="mb-5">Our goal for the stage one model was to predict PM2.5 using an instrumental variable. Below we can see the OLS model predictions (orange) mostly follow the actual values (blue) and the adjusted R-squared value is 0.77. Interaction terms were crucial to the model's ability to follow the spikes in PM2.5.</p>
			<img src="assets/imgs/stage1model.png" class="card-img" alt="Stage 1 Model">
			<p class="mb-5" > </p>
			<img src="assets/imgs/stage1.png" class="card-img" alt="Stage 1 Results">
			<p class="mb-5" > </p>
			<h5> Stage 2 Model</h5>
			<p class="mb-5" >Our stage 2 models by mental health diagnosis category showed there is a causal effect of PM2.5 on mental health diagnosis in children. The effects were similar across the three categories and magnitude of the effect varied by geography. </p>
			<img src="assets/imgs/stage1model.png" class="card-img" alt="Stage 1 Model">
			<p class="mb-5" > </p>
			<style type="text/css">
			.tg  {border-collapse:collapse;border-spacing:0;}
			.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
			  overflow:hidden;padding:10px 5px;word-break:normal;}
			.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
			  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
			.tg .tg-0pky{border-color:inherit;text-align:left;vertical-align:top}
			</style>
			<table class="tg">
			<thead>
			  <tr>
			    <th class="tg-0pky"><h5 class="card-title">Mental Health Outcome</h5></th>
			    <th class="tg-0pky"><h5 class="card-title">Impact of PM2.5&nbsp;&nbsp;&nbsp;</h5></th>
				<th class="tg-0pky"><h5 class="card-title">95% CI&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</h5></th>
				<th class="tg-0pky"><h5 class="card-title">Model Metrics</h5></th>
			  </tr>
			</thead>
			<tbody>
  			<tr>
    			<td class="tg-0pky"><p class="mb-5">Anxiety</p></td>
    			<td class="tg-0pky"><p class="mb-5">0.084</p></td>
    			<td class="tg-0pky"><p class="mb-5">[0.02, 1.4]</p></td>
				<td class="tg-0pky">
				<p>F-statistic: 35.58,</p> 
				<p>Prob (F-statistic): 0.00,</p>
				<p>R-squared: 70%</p>
				</td>
    		</tr>
			 <tr>
			    <td class="tg-0pky"><p class="mb-5">Depression</p></td>
			    <td class="tg-0pky"><p class="mb-5">0.071</p></td>
				<td class="tg-0pky"><p class="mb-5">[0.02, 1.3]</p></td>
				<td class="tg-0pky">
				<p>F-statistic: 24.04,</p> 
				<p>Prob (F-statistic): 0.00,</p>
				<p>R-squared: 62%</p>
				</td>
			  </tr>
			  <tr>
  			    <td class="tg-0pky"><p class="mb-5">Self-Harm</p></td>
  			    <td class="tg-0pky"><p class="mb-5">0.063</p></td>
  				<td class="tg-0pky"><p class="mb-5">[0.01, 1.2]</p></td>
				<td class="tg-0pky">
				<p>F-statistic: 21.7,</p> 
				<p>Prob (F-statistic): 0.00,</p>
				<p>R-squared: 58%</p>
				</td>
  			  </tr>
			</tbody>
			</table>
			<p class="mb-5"></p>
			<p class="mb-5" >Below: Interactive map of zip codes where PM2.5 had a postive, statistically significant causal effect on mental health diagnosis rate. Hover to see breakdown by anxiety, depression, and self-harm diagnosis.</p>
		</div>
	</div>
	
			<div class="viz">
			<div class='tableauPlaceholder' id='viz1682043578055' style='position: relative'><noscript><a href='#'><img alt='Dashboard 2 ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;St&#47;Stage2Coefficients&#47;Dashboard2&#47;1_rss.png' style='border: none' /></a></noscript><object class='tableauViz'  style='display:none;'><param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' /> <param name='embed_code_version' value='3' /> <param name='site_root' value='' /><param name='name' value='Stage2Coefficients&#47;Dashboard2' /><param name='tabs' value='no' /><param name='toolbar' value='yes' /><param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;St&#47;Stage2Coefficients&#47;Dashboard2&#47;1.png' /> <param name='animate_transition' value='yes' /><param name='display_static_image' value='yes' /><param name='display_spinner' value='yes' /><param name='display_overlay' value='yes' /><param name='display_count' value='yes' /><param name='language' value='en-US' /><param name='filter' value='publish=yes' /></object></div>                
			<script type='text/javascript'>                    var divElement = document.getElementById('viz1682043578055');                    var vizElement = divElement.getElementsByTagName('object')[0];                    if ( divElement.offsetWidth > 800 ) { vizElement.style.width='1000px';vizElement.style.height='827px';} else if ( divElement.offsetWidth > 500 ) { vizElement.style.width='1000px';vizElement.style.height='827px';} else { vizElement.style.width='100%';vizElement.style.height='727px';}                     var scriptElement = document.createElement('script');                    scriptElement.src = 'https://public.tableau.com/javascripts/api/viz_v1.js';                    vizElement.parentNode.insertBefore(scriptElement, vizElement);                </script>
			</div>
<!-- end of page container -->
			
    <!-- page container -->
    <div class="container page-container">
    	<div class="col-md-10 col-lg-8 m-auto">
            <h6 id="team" class="title mb-4 mt-2 pt-2">Team</h6>
	        
	        <!-- row -->
	        <div class="row mb-4">
	            <div class="col-md-4">
	                <a class="overlay-img">
	                    <img src="assets/imgs/philip.png" alt="">  
	                    <div class="overlay"></div> 
	                    <div class="des">
	                        <h1 class="title">Philip Denkabe</h1>
	                    </div>          
	                </a>
	            </div>
	            <div class="col-md-4">
	                <a class="overlay-img">
	                    <img src="assets/imgs/lawis.png" alt="">  
	                    <div class="overlay"></div> 
	                    <div class="des">
	                        <h1 class="title">Lawis Koh</h1>
	                    </div>          
	                </a>
	            </div>
	            <div class="col-md-4">
	                <a class="overlay-img">
	                    <img src="assets/imgs/joy.png" alt="">  
	                    <div class="overlay"></div> 
	                    <div class="des">
	                        <h1 class="title">Joy McGillin</h1>
	                    </div>          
	                </a>
	            </div>
	            <div class="col-md-4">
	                <a class="overlay-img">
	                    <img src="assets/imgs/jordan.png" alt="">  
	                    <div class="overlay"></div> 
	                    <div class="des">
	                        <h1 class="title">Jordan Meyer</h1>
	                    </div>          
	                </a>
	            </div>
	            <div class="col-md-4">
	                <a class="overlay-img">
	                    <img src="assets/imgs/liz.png" alt="">  
	                    <div class="overlay"></div> 
	                    <div class="des">
	                        <h1 class="title">Liz Nichols</h1>
	                    </div>          
	                </a>
	            </div>          
	        </div><!-- end of row -->

        </div>

    </div> <!-- end of page container -->

            <!-- footer -->
            <footer class="footer">
                <p class="infos">&copy; <script>document.write(new Date().getFullYear())</script></p>       
                <span>|</span>  
                <div class="links">
                    <a href="#top">Top</a>
                    <a href="#motivation">Motivation</a>
                    <a href="#data">Data</a>
					<a href="#methodology">Methodology</a>
					<a href="#results">Results</a>
					<a href="#team">Team</a>
                </div>
            </footer><!-- end of footer -->



    <!-- core  -->
    <script src="assets/vendors/jquery/jquery-3.4.1.js"></script>
    <script src="assets/vendors/bootstrap/bootstrap.bundle.js"></script>

    <!-- bootstrap affix -->
    <script src="assets/vendors/bootstrap/bootstrap.affix.js"></script>

    <!-- Dorang js -->
    <script src="assets/js/dorang.js"></script>

</body>
</html>
