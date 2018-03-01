---
layout: post
title: "Democratic Prospects for the 2018 Midterm"
excerpt: "I look at potentially close seats in the House and Senate for 2018."
#modified: 2016-02-22
tags: [pandas, python, d3.js, politics, data visualization]
comments: true
share: false

---


Below, I look at the prospects for each party in the 2018 election.  Overall, the House actually looks pretty good for Democrats, with many Republicans up for re-election in districts that Clinton won.  The Senate is a different story, with many Democrats running in states that Trump won by a considerable margin.  But who knows what will happen if the election becomes a referendum on Trump.

The data for this post come from [The DailyKos](https://docs.google.com/spreadsheets/d/1oRl7vxEJUUDWJCyrjo62cELJD2ONIVl-D9TSUKiK9jk/edit#gid=2132957126).  All the code for this post is available in a Jupyter notebook [here](http://nbviewer.jupyter.org/gist/psthomas/ed54ed0586f224544c5ad83763cb7267), including the interactive plots and tables.  I don't have an in-depth understanding of politics, so it's possible I'm missing some good indicators for midterm success.  Let me know if you have any ideas for additions.


# House Seats at Risk

The plot below shows the 2016 Deocratic presidential lead on the x-axis, and the 2016 Democratic House lead on the y-axis.  Any point near the x-axis was a close race, with those just above the axis won by Democrats and those just below won by Republicans.  Points in the top left quadrant are seats that are especially at risk for Democrats because Trump won these districts.  

In the bottom right are House Republican districts that were won by Clinton in the presidential race.  There seem to be more Republican House seats at risk in 2018, which could especially be dangerous for them if the election becomes a referendum on Trump.  


<!--<iframe src="{{site.url}}/vis/midterm_house.html" -->
<!--    style="width: 960px; height: 600px; display:block; width: 100%; margin: 25px auto; border: none"></iframe>-->

<iframe srcdoc="
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset=&quot;utf-8&quot;>
    <title>Zoom + Pan</title>
    <style>
    
    body {
      position: relative;
      width: 650px; /*960px*/
    }

    svg {font: 10px sans-serif;}

    rect {fill: #e5e5e5; }

    .label {
        font-size: 12px;
        /*stroke: #ddd;*/
        fill: #555;
    }

    .dot {
      stroke: #aaa;
      stroke-width: 0.5px;
      /*stroke: red;*/
      /*border: 1;*/
    }
    .dot:hover {fill-opacity: 0.4;}

    .axis path,
    .axis line {
      stroke: #fff; /*black;*/
      fill: none; 
      stroke-width: 1px;
    }
    
    #main-tick{
      fill: none;
      stroke: #777;  
      stroke-width: 1px;
      opacity: 1;
    }

    .buttons {
      position: absolute;
      right: 30px;
      top: 30px;
    }
    button {
      font: 16px sans-serif;
      display: block;
      border-radius: 0px;
      width: 25px;
      /*outline: none;*/
      /*outline:0;*/
      background-color: white;
      border: none;
    }
    
    button:hover {
      background-image:none;
      background-color:#d5d5d5;
    }
    
    button:focus{ 
    /*outline-color: #ddd;
    outline:none;
    outline: 1;*/
    outline-color: #b5b5b5;
    }
    
    div.tooltip {
      position: absolute;
      padding: 5px;
      font: 12px sans-serif;
      background: white;
      border: 0px;
      border-radius: 0px;
      pointer-events:none;
    }

    </style>
    </head>
    <body>
    
    <div class=&quot;buttons&quot;>
      <button data-zoom=&quot;+1&quot;>+</button>
      <button data-zoom=&quot;-1&quot;>-</button>
    </div>
    <script src=&quot;//d3js.org/d3.v3.min.js&quot;></script>
    <script>

    var margin = {top: 20, right: 20, bottom: 40, left: 40},  //40, 40
        width = 650 - margin.left - margin.right,  //650
        height = 515 - margin.top - margin.bottom;

    var keys = {&quot;last&quot;: 4, &quot;demlead_house2016&quot;: 12, &quot;first&quot;: 3, &quot;sum&quot;: 14, &quot;houserep_2016&quot;: 6, &quot;voting_age_pop&quot;: 11, &quot;clinton_2016&quot;: 8, &quot;pvi_2016&quot;: 10, &quot;party&quot;: 2, &quot;code&quot;: 1, &quot;housedem_2016&quot;: 5, &quot;demlead_pres2016&quot;: 13, &quot;district&quot;: 0, &quot;total_2016&quot;: 7, &quot;trump_2016&quot;: 9};
    var data = [[&quot;Nationwide&quot;,&quot;USA&quot;,&quot;240R-193D-2V&quot;,null,null,48.0,49.1,137098601.0,65853625.0,62985106.0,0.0,234562019.0,-1.1,2.09,0.99],[&quot;Alabama 1st&quot;,&quot;AL-01&quot;,&quot;Republican&quot;,&quot;Bradley&quot;,&quot;Byrne&quot;,0.0,96.4,303478.0,103364.0,192634.0,-16.2,515948.0,-96.4,-29.42,-125.82],[&quot;Alabama 2nd&quot;,&quot;AL-02&quot;,&quot;Republican&quot;,&quot;Martha&quot;,&quot;Roby&quot;,40.5,48.8,285664.0,94299.0,185505.0,-17.4,522837.0,-8.3,-31.93,-40.23],[&quot;Alabama 3rd&quot;,&quot;AL-03&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Rogers&quot;,32.9,66.9,288776.0,93300.0,188477.0,-18.0,523481.0,-34.0,-32.96,-66.96],[&quot;Alabama 4th&quot;,&quot;AL-04&quot;,&quot;Republican&quot;,&quot;Robert&quot;,&quot;Aderholt&quot;,0.0,98.5,290726.0,50722.0,233661.0,-33.3,521081.0,-98.5,-62.92,-161.42],[&quot;Alabama 5th&quot;,&quot;AL-05&quot;,&quot;Republican&quot;,&quot;Mo&quot;,&quot;Brooks&quot;,33.2,66.7,309937.0,97159.0,200571.0,-18.5,523079.0,-33.5,-33.37,-66.87],[&quot;Alabama 6th&quot;,&quot;AL-06&quot;,&quot;Republican&quot;,&quot;Gary&quot;,&quot;Palmer&quot;,25.4,74.5,329849.0,86116.0,233493.0,-24.2,517305.0,-49.1,-44.68,-93.78],[&quot;Alabama 7th&quot;,&quot;AL-07&quot;,&quot;Democratic&quot;,&quot;Terri&quot;,&quot;Sewell&quot;,98.4,0.0,293231.0,204586.0,83915.0,19.8,523546.0,98.4,41.15,139.55],[&quot;Alaska At-Large&quot;,&quot;AK-AL&quot;,&quot;Republican&quot;,&quot;Don&quot;,&quot;Young&quot;,36.0,50.3,318608.0,116454.0,163387.0,-9.5,521588.0,-14.3,-14.73,-29.03],[&quot;Arizona 1st&quot;,&quot;AZ-01&quot;,&quot;Democratic&quot;,&quot;Tom&quot;,&quot;O'Halleran&quot;,50.7,43.4,284973.0,132874.0,135928.0,-1.7,522309.0,7.3,-1.07,6.23],[&quot;Arizona 2nd&quot;,&quot;AZ-02&quot;,&quot;Republican&quot;,&quot;Martha&quot;,&quot;McSally&quot;,43.0,57.0,315839.0,156676.0,141196.0,1.5,558252.0,-14.0,4.9,-9.1],[&quot;Arizona 3rd&quot;,&quot;AZ-03&quot;,&quot;Democratic&quot;,&quot;Ra\u00fal&quot;,&quot;Grijalva&quot;,88.1,0.0,208934.0,130466.0,67952.0,14.6,497743.0,88.1,29.92,118.02],[&quot;Arizona 4th&quot;,&quot;AZ-04&quot;,&quot;Republican&quot;,&quot;Paul&quot;,&quot;Gosar&quot;,28.5,71.5,298483.0,82192.0,202043.0,-22.2,556383.0,-43.0,-40.15,-83.15],[&quot;Arizona 5th&quot;,&quot;AZ-05&quot;,&quot;Republican&quot;,&quot;Andy&quot;,&quot;Biggs&quot;,35.9,64.1,332093.0,121280.0,191432.0,-12.3,512943.0,-28.2,-21.12,-49.32],[&quot;Arizona 6th&quot;,&quot;AZ-06&quot;,&quot;Republican&quot;,&quot;David&quot;,&quot;Schweikert&quot;,37.9,62.1,338331.0,143571.0,177332.0,-6.4,554574.0,-24.2,-9.98,-34.18],[&quot;Arizona 7th&quot;,&quot;AZ-07&quot;,&quot;Democratic&quot;,&quot;Ruben&quot;,&quot;Gallego&quot;,75.2,24.7,164399.0,117958.0,37232.0,24.9,474491.0,50.5,49.1,99.6],[&quot;Arizona 8th&quot;,&quot;AZ-08&quot;,&quot;Republican&quot;,&quot;Trent&quot;,&quot;Franks&quot;,0.0,68.5,327325.0,120992.0,190163.0,-12.2,536590.0,-68.5,-21.13,-89.63],[&quot;Arizona 9th&quot;,&quot;AZ-09&quot;,&quot;Democratic&quot;,&quot;Kyrsten&quot;,&quot;Sinema&quot;,60.9,39.0,283863.0,155158.0,109123.0,7.6,549718.0,21.9,16.22,38.12],[&quot;Arkansas 1st&quot;,&quot;AR-01&quot;,&quot;Republican&quot;,&quot;Rick&quot;,&quot;Crawford&quot;,0.0,76.3,260717.0,78688.0,169438.0,-19.4,553023.0,-76.3,-34.81,-111.11],[&quot;Arkansas 2nd&quot;,&quot;AR-02&quot;,&quot;Republican&quot;,&quot;French&quot;,&quot;Hill&quot;,36.8,58.3,306974.0,127883.0,160782.0,-6.8,553609.0,-21.5,-10.72,-32.22],[&quot;Arkansas 3rd&quot;,&quot;AR-03&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;Womack&quot;,0.0,77.3,292163.0,89081.0,180921.0,-18.1,541997.0,-77.3,-31.43,-108.73],[&quot;Arkansas 4th&quot;,&quot;AR-04&quot;,&quot;Republican&quot;,&quot;Bruce&quot;,&quot;Westerman&quot;,0.0,74.9,270781.0,84842.0,173731.0,-18.3,555814.0,-74.9,-32.83,-107.73],[&quot;California 1st&quot;,&quot;CA-01&quot;,&quot;Republican&quot;,&quot;Doug&quot;,&quot;LaMalfa&quot;,40.9,59.1,313968.0,114727.0,176358.0,-11.7,555171.0,-18.2,-19.63,-37.83],[&quot;California 2nd&quot;,&quot;CA-02&quot;,&quot;Democratic&quot;,&quot;Jared&quot;,&quot;Huffman&quot;,76.9,23.1,344971.0,238157.0,80545.0,23.6,554173.0,53.8,45.69,99.49],[&quot;California 3rd&quot;,&quot;CA-03&quot;,&quot;Democratic&quot;,&quot;John&quot;,&quot;Garamendi&quot;,59.4,40.6,262086.0,138882.0,105860.0,5.6,525021.0,18.8,12.6,31.4],[&quot;California 4th&quot;,&quot;CA-04&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;McClintock&quot;,37.3,62.7,353388.0,138790.0,190924.0,-9.0,543649.0,-25.4,-14.75,-40.15],[&quot;California 5th&quot;,&quot;CA-05&quot;,&quot;Democratic&quot;,&quot;Mike&quot;,&quot;Thompson&quot;,76.9,23.1,305052.0,210950.0,74088.0,22.9,547233.0,53.8,44.87,98.67],[&quot;California 6th&quot;,&quot;CA-06&quot;,&quot;Democratic&quot;,&quot;Doris&quot;,&quot;Matsui&quot;,75.4,24.6,243910.0,168687.0,59549.0,22.8,520901.0,50.8,44.75,95.55],[&quot;California 7th&quot;,&quot;CA-07&quot;,&quot;Democratic&quot;,&quot;Ami&quot;,&quot;Bera&quot;,51.2,48.8,304118.0,159066.0,124249.0,5.0,521668.0,2.4,11.45,13.85],[&quot;California 8th&quot;,&quot;CA-08&quot;,&quot;Republican&quot;,&quot;Paul&quot;,&quot;Cook&quot;,37.7,62.3,232835.0,92234.0,127464.0,-9.1,504172.0,-24.6,-15.13,-39.73],[&quot;California 9th&quot;,&quot;CA-09&quot;,&quot;Democratic&quot;,&quot;Jerry&quot;,&quot;McNerney&quot;,57.4,42.6,238191.0,134719.0,90484.0,8.7,498183.0,14.8,18.57,33.37],[&quot;California 10th&quot;,&quot;CA-10&quot;,&quot;Republican&quot;,&quot;Jeff&quot;,&quot;Denham&quot;,48.3,51.7,239680.0,116335.0,109145.0,0.5,501640.0,-3.4,3.0,-0.4],[&quot;California 11th&quot;,&quot;CA-11&quot;,&quot;Democratic&quot;,&quot;Mark&quot;,&quot;DeSaulnier&quot;,72.1,27.9,312568.0,223559.0,70869.0,24.8,536843.0,44.2,48.85,93.05],[&quot;California 12th&quot;,&quot;CA-12&quot;,&quot;Democratic&quot;,&quot;Nancy&quot;,&quot;Pelosi&quot;,80.9,0.0,358774.0,309221.0,31158.0,39.7,614229.0,80.9,77.5,158.4],[&quot;California 13th&quot;,&quot;CA-13&quot;,&quot;Democratic&quot;,&quot;Barbara&quot;,&quot;Lee&quot;,90.8,9.2,334194.0,291926.0,22743.0,41.7,561936.0,81.6,80.55,162.15],[&quot;California 14th&quot;,&quot;CA-14&quot;,&quot;Democratic&quot;,&quot;Jackie&quot;,&quot;Speier&quot;,80.9,19.1,297743.0,229008.0,54229.0,29.7,553566.0,61.8,58.7,120.5],[&quot;California 15th&quot;,&quot;CA-15&quot;,&quot;Democratic&quot;,&quot;Eric&quot;,&quot;Swalwell&quot;,73.8,26.2,284536.0,198964.0,68808.0,23.2,525308.0,47.6,45.74,93.34],[&quot;California 16th&quot;,&quot;CA-16&quot;,&quot;Democratic&quot;,&quot;Jim&quot;,&quot;Costa&quot;,58.0,42.0,169964.0,98504.0,61813.0,10.3,478738.0,16.0,21.59,37.59],[&quot;California 17th&quot;,&quot;CA-17&quot;,&quot;Democratic&quot;,&quot;Ro&quot;,&quot;Khanna&quot;,100.0,0.0,248695.0,183801.0,50926.0,27.2,539199.0,100.0,53.43,153.43],[&quot;California 18th&quot;,&quot;CA-18&quot;,&quot;Democratic&quot;,&quot;Anna&quot;,&quot;Eshoo&quot;,71.1,28.9,335138.0,246015.0,67808.0,27.3,541587.0,42.2,53.17,95.37],[&quot;California 19th&quot;,&quot;CA-19&quot;,&quot;Democratic&quot;,&quot;Zoe&quot;,&quot;Lofgren&quot;,73.9,26.1,257624.0,187828.0,55371.0,26.1,521393.0,47.8,51.41,99.21],[&quot;California 20th&quot;,&quot;CA-20&quot;,&quot;Democratic&quot;,&quot;Jimmy&quot;,&quot;Panetta&quot;,70.8,29.2,256538.0,180486.0,59573.0,24.1,525025.0,41.6,47.13,88.73],[&quot;California 21st&quot;,&quot;CA-21&quot;,&quot;Republican&quot;,&quot;David&quot;,&quot;Valadao&quot;,43.3,56.7,133544.0,73773.0,52972.0,7.1,473659.0,-13.4,15.58,2.18],[&quot;California 22nd&quot;,&quot;CA-22&quot;,&quot;Republican&quot;,&quot;Devin&quot;,&quot;Nunes&quot;,32.4,67.6,240137.0,102292.0,125089.0,-6.1,499241.0,-35.2,-9.49,-44.69],[&quot;California 23rd&quot;,&quot;CA-23&quot;,&quot;Republican&quot;,&quot;Kevin&quot;,&quot;McCarthy&quot;,30.8,69.2,244864.0,88314.0,142351.0,-12.8,503535.0,-38.4,-22.07,-60.47],[&quot;California 24th&quot;,&quot;CA-24&quot;,&quot;Democratic&quot;,&quot;Salud&quot;,&quot;Carbajal&quot;,53.4,46.6,312160.0,176979.0,113887.0,9.7,553080.0,6.8,20.21,27.01],[&quot;California 25th&quot;,&quot;CA-25&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;Knight&quot;,46.9,53.1,273218.0,137491.0,119249.0,2.4,501767.0,-6.2,6.68,0.48],[&quot;California 26th&quot;,&quot;CA-26&quot;,&quot;Democratic&quot;,&quot;Julia&quot;,&quot;Brownley&quot;,60.4,39.6,292232.0,169083.0,105259.0,10.5,523593.0,20.8,21.84,42.64],[&quot;California 27th&quot;,&quot;CA-27&quot;,&quot;Democratic&quot;,&quot;Judy&quot;,&quot;Chu&quot;,67.4,32.6,264466.0,174544.0,74984.0,18.8,558942.0,34.8,37.65,72.45],[&quot;California 28th&quot;,&quot;CA-28&quot;,&quot;Democratic&quot;,&quot;Adam&quot;,&quot;Schiff&quot;,78.0,22.0,289254.0,208645.0,64607.0,25.2,582270.0,56.0,49.8,105.8],[&quot;California 29th&quot;,&quot;CA-29&quot;,&quot;Democratic&quot;,&quot;Tony&quot;,&quot;Cardenas&quot;,100.0,0.0,196196.0,152517.0,32963.0,31.1,512286.0,100.0,60.94,160.94],[&quot;California 30th&quot;,&quot;CA-30&quot;,&quot;Democratic&quot;,&quot;Brad&quot;,&quot;Sherman&quot;,72.6,27.4,302805.0,209149.0,77701.0,21.8,559607.0,45.2,43.41,88.61],[&quot;California 31st&quot;,&quot;CA-31&quot;,&quot;Democratic&quot;,&quot;Pete&quot;,&quot;Aguilar&quot;,56.1,43.9,228825.0,131960.0,83701.0,10.1,501208.0,12.2,21.09,33.29],[&quot;California 32nd&quot;,&quot;CA-32&quot;,&quot;Democratic&quot;,&quot;Grace&quot;,&quot;Napolitano&quot;,100.0,0.0,220046.0,146459.0,60921.0,19.5,521893.0,100.0,38.87,138.87],[&quot;California 33rd&quot;,&quot;CA-33&quot;,&quot;Democratic&quot;,&quot;Ted&quot;,&quot;Lieu&quot;,66.4,33.6,353897.0,239982.0,93706.0,20.8,568279.0,32.8,41.33,74.13],[&quot;California 34th&quot;,&quot;CA-34&quot;,&quot;Vacant (D)&quot;,&quot;Vacant&quot;,&quot;Vacant&quot;,100.0,0.0,184601.0,154259.0,19784.0,37.5,539883.0,100.0,72.85,172.85],[&quot;California 35th&quot;,&quot;CA-35&quot;,&quot;Democratic&quot;,&quot;Norma&quot;,&quot;Torres&quot;,72.4,27.6,188611.0,127757.0,50822.0,20.4,484975.0,44.8,40.79,85.59],[&quot;California 36th&quot;,&quot;CA-36&quot;,&quot;Democratic&quot;,&quot;Raul&quot;,&quot;Ruiz&quot;,62.1,37.9,237370.0,123795.0,103051.0,3.5,521859.0,24.2,8.74,32.94],[&quot;California 37th&quot;,&quot;CA-37&quot;,&quot;Democratic&quot;,&quot;Karen&quot;,&quot;Bass&quot;,100.0,0.0,276134.0,236621.0,26608.0,38.8,553286.0,100.0,76.05,176.05],[&quot;California 38th&quot;,&quot;CA-38&quot;,&quot;Democratic&quot;,&quot;Linda&quot;,&quot;S\u00e1nchez&quot;,70.5,29.5,248224.0,166224.0,68033.0,19.8,516385.0,41.0,39.56,80.56],[&quot;California 39th&quot;,&quot;CA-39&quot;,&quot;Republican&quot;,&quot;Ed&quot;,&quot;Royce&quot;,42.8,57.2,272471.0,140230.0,116782.0,3.4,530634.0,-14.4,8.61,-5.79],[&quot;California 40th&quot;,&quot;CA-40&quot;,&quot;Democratic&quot;,&quot;Lucille&quot;,&quot;Roybal-Allard&quot;,71.4,0.0,164714.0,135472.0,21077.0,35.4,478423.0,71.4,69.45,140.85],[&quot;California 41st&quot;,&quot;CA-41&quot;,&quot;Democratic&quot;,&quot;Mark&quot;,&quot;Takano&quot;,65.0,35.0,206961.0,126197.0,68526.0,13.7,490407.0,30.0,27.87,57.87],[&quot;California 42nd&quot;,&quot;CA-42&quot;,&quot;Republican&quot;,&quot;Ken&quot;,&quot;Calvert&quot;,41.2,58.8,268305.0,111103.0,143175.0,-7.4,502971.0,-17.6,-11.95,-29.55],[&quot;California 43rd&quot;,&quot;CA-43&quot;,&quot;Democratic&quot;,&quot;Maxine&quot;,&quot;Waters&quot;,76.1,23.9,234060.0,183434.0,39039.0,31.3,520049.0,52.2,61.69,113.89],[&quot;California 44th&quot;,&quot;CA-44&quot;,&quot;Democratic&quot;,&quot;Nanette&quot;,&quot;Barragan&quot;,100.0,0.0,197802.0,164251.0,24261.0,36.0,487334.0,100.0,70.77,170.77],[&quot;California 45th&quot;,&quot;CA-45&quot;,&quot;Republican&quot;,&quot;Mimi&quot;,&quot;Walters&quot;,41.4,58.6,325967.0,162449.0,144713.0,1.8,531667.0,-17.2,5.44,-11.76],[&quot;California 46th&quot;,&quot;CA-46&quot;,&quot;Democratic&quot;,&quot;Lou&quot;,&quot;Correa&quot;,100.0,0.0,180750.0,119762.0,50403.0,19.3,504841.0,100.0,38.37,138.37],[&quot;California 47th&quot;,&quot;CA-47&quot;,&quot;Democratic&quot;,&quot;Alan&quot;,&quot;Lowenthal&quot;,63.7,36.3,258320.0,161743.0,80162.0,15.7,533085.0,27.4,31.58,58.98],[&quot;California 48th&quot;,&quot;CA-48&quot;,&quot;Republican&quot;,&quot;Dana&quot;,&quot;Rohrabacher&quot;,41.7,58.3,317328.0,152035.0,146595.0,-0.2,561701.0,-16.6,1.71,-14.89],[&quot;California 49th&quot;,&quot;CA-49&quot;,&quot;Republican&quot;,&quot;Darrell&quot;,&quot;Issa&quot;,49.7,50.3,314011.0,159081.0,135576.0,2.9,541472.0,-0.6,7.49,6.89],[&quot;California 50th&quot;,&quot;CA-50&quot;,&quot;Republican&quot;,&quot;Duncan&quot;,&quot;Hunter&quot;,36.5,63.5,292878.0,115864.0,159822.0,-9.1,520756.0,-27.0,-15.01,-42.01],[&quot;California 51st&quot;,&quot;CA-51&quot;,&quot;Democratic&quot;,&quot;Juan&quot;,&quot;Vargas&quot;,72.8,27.2,205437.0,147603.0,46825.0,24.8,503460.0,45.6,49.06,94.66],[&quot;California 52nd&quot;,&quot;CA-52&quot;,&quot;Democratic&quot;,&quot;Scott&quot;,&quot;Peters&quot;,56.5,43.5,329258.0,191325.0,117057.0,10.9,560637.0,13.0,22.56,35.56],[&quot;California 53rd&quot;,&quot;CA-53&quot;,&quot;Democratic&quot;,&quot;Susan&quot;,&quot;Davis&quot;,67.0,33.0,310373.0,200237.0,91822.0,17.4,546096.0,34.0,34.93,68.93],[&quot;Colorado 1st&quot;,&quot;CO-01&quot;,&quot;Democratic&quot;,&quot;Diana&quot;,&quot;DeGette&quot;,67.9,27.7,402463.0,277790.0,93486.0,23.7,561585.0,40.2,45.79,85.99],[&quot;Colorado 2nd&quot;,&quot;CO-02&quot;,&quot;Democratic&quot;,&quot;Jared&quot;,&quot;Polis&quot;,56.9,37.2,471308.0,264925.0,164710.0,10.5,568934.0,19.7,21.26,40.96],[&quot;Colorado 3rd&quot;,&quot;CO-03&quot;,&quot;Republican&quot;,&quot;Scott&quot;,&quot;Tipton&quot;,40.3,54.6,377176.0,151057.0,195966.0,-7.6,549229.0,-14.3,-11.91,-26.21],[&quot;Colorado 4th&quot;,&quot;CO-04&quot;,&quot;Republican&quot;,&quot;Ken&quot;,&quot;Buck&quot;,31.7,63.5,402197.0,137779.0,230945.0,-13.7,522909.0,-31.8,-23.16,-54.96],[&quot;Colorado 5th&quot;,&quot;CO-05&quot;,&quot;Republican&quot;,&quot;Doug&quot;,&quot;Lamborn&quot;,30.9,62.3,371751.0,123508.0,212517.0,-14.4,539460.0,-31.4,-23.94,-55.34],[&quot;Colorado 6th&quot;,&quot;CO-06&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Coffman&quot;,42.6,50.9,380535.0,191103.0,157115.0,3.8,521204.0,-8.3,8.93,0.63],[&quot;Colorado 7th&quot;,&quot;CO-07&quot;,&quot;Democratic&quot;,&quot;Ed&quot;,&quot;Perlmutter&quot;,55.2,39.8,374616.0,192637.0,147645.0,5.5,540266.0,15.4,12.01,27.41],[&quot;Connecticut 1st&quot;,&quot;CT-01&quot;,&quot;Democratic&quot;,&quot;John&quot;,&quot;Larson&quot;,64.1,33.8,328774.0,195305.0,119395.0,10.9,550375.0,30.3,23.09,53.39],[&quot;Connecticut 2nd&quot;,&quot;CT-02&quot;,&quot;Democratic&quot;,&quot;Joe&quot;,&quot;Courtney&quot;,63.2,33.7,340758.0,165799.0,155975.0,0.4,559634.0,29.5,2.88,32.38],[&quot;Connecticut 3rd&quot;,&quot;CT-03&quot;,&quot;Democratic&quot;,&quot;Rosa&quot;,&quot;DeLauro&quot;,69.0,31.0,321837.0,179832.0,129968.0,6.9,563641.0,38.0,15.49,53.49],[&quot;Connecticut 4th&quot;,&quot;CT-04&quot;,&quot;Democratic&quot;,&quot;Jim&quot;,&quot;Himes&quot;,59.9,40.1,328198.0,195494.0,119976.0,10.9,536108.0,19.8,23.01,42.81],[&quot;Connecticut 5th&quot;,&quot;CT-05&quot;,&quot;Democratic&quot;,&quot;Elizabeth&quot;,&quot;Esty&quot;,58.0,42.0,322737.0,161142.0,147901.0,1.0,547324.0,16.0,4.1,20.1],[&quot;Delaware At-Large&quot;,&quot;DE-AL&quot;,&quot;Democratic&quot;,&quot;Lisa&quot;,&quot;Blunt Rochester&quot;,55.5,41.0,441590.0,235603.0,185127.0,4.9,692169.0,14.5,11.43,25.93],[&quot;Florida 1st&quot;,&quot;FL-01&quot;,&quot;Republican&quot;,&quot;Matt&quot;,&quot;Gaetz&quot;,30.9,69.1,380100.0,107063.0,256609.0,-21.7,541847.0,-38.2,-39.34,-77.54],[&quot;Florida 2nd&quot;,&quot;FL-02&quot;,&quot;Republican&quot;,&quot;Neal&quot;,&quot;Dunn&quot;,29.9,67.3,354948.0,108636.0,234991.0,-19.5,549325.0,-37.4,-35.6,-73.0],[&quot;Florida 3rd&quot;,&quot;FL-03&quot;,&quot;Republican&quot;,&quot;Ted&quot;,&quot;Yoho&quot;,39.8,56.6,351688.0,141362.0,197478.0,-9.4,544863.0,-16.8,-15.96,-32.76],[&quot;Florida 4th&quot;,&quot;FL-04&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Rutherford&quot;,27.6,70.2,421618.0,143675.0,261826.0,-15.7,548152.0,-42.6,-28.02,-70.62],[&quot;Florida 5th&quot;,&quot;FL-05&quot;,&quot;Democratic&quot;,&quot;Al&quot;,&quot;Lawson&quot;,64.2,35.8,312071.0,191194.0,111892.0,12.0,528480.0,28.4,25.41,53.81],[&quot;Florida 6th&quot;,&quot;FL-06&quot;,&quot;Republican&quot;,&quot;Ron&quot;,&quot;DeSantis&quot;,41.4,58.6,379804.0,151453.0,215941.0,-9.9,564224.0,-17.2,-16.98,-34.18],[&quot;Florida 7th&quot;,&quot;FL-07&quot;,&quot;Democratic&quot;,&quot;Stephanie&quot;,&quot;Murphy&quot;,51.5,48.5,363186.0,186658.0,160178.0,2.7,548186.0,3.0,7.29,10.29],[&quot;Florida 8th&quot;,&quot;FL-08&quot;,&quot;Republican&quot;,&quot;Bill&quot;,&quot;Posey&quot;,32.5,63.1,401911.0,151412.0,234648.0,-11.9,558439.0,-30.6,-20.71,-51.31],[&quot;Florida 9th&quot;,&quot;FL-09&quot;,&quot;Democratic&quot;,&quot;Darren&quot;,&quot;Soto&quot;,57.5,42.5,356530.0,195368.0,149352.0,5.6,520247.0,15.0,12.91,27.91],[&quot;Florida 10th&quot;,&quot;FL-10&quot;,&quot;Democratic&quot;,&quot;Val&quot;,&quot;Demings&quot;,64.9,35.1,315611.0,194934.0,110062.0,12.8,519891.0,29.8,26.89,56.69],[&quot;Florida 11th&quot;,&quot;FL-11&quot;,&quot;Republican&quot;,&quot;Daniel&quot;,&quot;Webster&quot;,31.6,65.4,410998.0,133448.0,266256.0,-17.7,574603.0,-33.8,-32.31,-66.11],[&quot;Florida 12th&quot;,&quot;FL-12&quot;,&quot;Republican&quot;,&quot;Gus&quot;,&quot;Bilirakis&quot;,31.4,68.6,380357.0,147759.0,218487.0,-10.8,554847.0,-37.2,-18.6,-55.8],[&quot;Florida 13th&quot;,&quot;FL-13&quot;,&quot;Democratic&quot;,&quot;Charlie&quot;,&quot;Crist&quot;,51.9,48.1,360760.0,178892.0,167348.0,0.6,572547.0,3.8,3.2,7.0],[&quot;Florida 14th&quot;,&quot;FL-14&quot;,&quot;Democratic&quot;,&quot;Kathy&quot;,&quot;Castor&quot;,61.8,38.2,330433.0,188870.0,128797.0,8.3,540408.0,23.6,18.18,41.78],[&quot;Florida 15th&quot;,&quot;FL-15&quot;,&quot;Republican&quot;,&quot;Dennis&quot;,&quot;Ross&quot;,42.5,57.5,334518.0,144225.0,177635.0,-6.3,533364.0,-15.0,-9.99,-24.99],[&quot;Florida 16th&quot;,&quot;FL-16&quot;,&quot;Republican&quot;,&quot;Vern&quot;,&quot;Buchanan&quot;,40.2,59.8,396807.0,170442.0,213271.0,-6.7,555284.0,-19.6,-10.79,-30.39],[&quot;Florida 17th&quot;,&quot;FL-17&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Rooney&quot;,34.2,61.8,353861.0,123919.0,220156.0,-15.1,563830.0,-27.6,-27.2,-54.8],[&quot;Florida 18th&quot;,&quot;FL-18&quot;,&quot;Republican&quot;,&quot;Brian&quot;,&quot;Mast&quot;,43.1,53.6,382474.0,168558.0,203771.0,-5.8,557944.0,-10.5,-9.21,-19.71],[&quot;Florida 19th&quot;,&quot;FL-19&quot;,&quot;Republican&quot;,&quot;Francis&quot;,&quot;Rooney&quot;,34.1,65.9,381158.0,143001.0,227097.0,-12.5,569135.0,-31.8,-22.06,-53.86],[&quot;Florida 20th&quot;,&quot;FL-20&quot;,&quot;Democratic&quot;,&quot;Alcee&quot;,&quot;Hastings&quot;,80.3,19.7,288811.0,231596.0,52251.0,30.5,523033.0,60.6,62.1,122.7],[&quot;Florida 21st&quot;,&quot;FL-21&quot;,&quot;Democratic&quot;,&quot;Lois&quot;,&quot;Frankel&quot;,62.7,35.1,351661.0,206239.0,137490.0,8.9,554416.0,27.6,19.55,47.15],[&quot;Florida 22nd&quot;,&quot;FL-22&quot;,&quot;Democratic&quot;,&quot;Ted&quot;,&quot;Deutch&quot;,58.9,41.1,356482.0,202355.0,146228.0,6.9,562571.0,17.8,15.74,33.54],[&quot;Florida 23rd&quot;,&quot;FL-23&quot;,&quot;Democratic&quot;,&quot;Debbie&quot;,&quot;Wasserman Schultz&quot;,56.7,40.5,337782.0,209079.0,120967.0,12.2,542450.0,16.2,26.09,42.29],[&quot;Florida 24th&quot;,&quot;FL-24&quot;,&quot;Democratic&quot;,&quot;Frederica&quot;,&quot;Wilson&quot;,100.0,0.0,263196.0,218424.0,40234.0,33.3,530066.0,100.0,67.7,167.7],[&quot;Florida 25th&quot;,&quot;FL-25&quot;,&quot;Republican&quot;,&quot;Mario&quot;,&quot;Diaz-Balart&quot;,37.6,62.4,264255.0,126702.0,131186.0,-2.0,540846.0,-24.8,-1.7,-26.5],[&quot;Florida 26th&quot;,&quot;FL-26&quot;,&quot;Republican&quot;,&quot;Carlos&quot;,&quot;Curbelo&quot;,41.2,53.0,284735.0,161555.0,115529.0,7.2,530119.0,-11.8,16.16,4.36],[&quot;Florida 27th&quot;,&quot;FL-27&quot;,&quot;Republican&quot;,&quot;Ileana&quot;,&quot;Ros-Lehtinen&quot;,45.1,54.9,304130.0,178154.0,118206.0,9.0,569381.0,-9.8,19.71,9.91],[&quot;Georgia 1st&quot;,&quot;GA-01&quot;,&quot;Republican&quot;,&quot;Buddy&quot;,&quot;Carter&quot;,0.0,100.0,269568.0,110190.0,151996.0,-9.1,518703.0,-100.0,-15.51,-115.51],[&quot;Georgia 2nd&quot;,&quot;GA-02&quot;,&quot;Democratic&quot;,&quot;Sanford&quot;,&quot;Bishop&quot;,61.2,38.8,248103.0,136455.0,107361.0,4.9,515612.0,22.4,11.73,34.13],[&quot;Georgia 3rd&quot;,&quot;GA-03&quot;,&quot;Republican&quot;,&quot;Drew&quot;,&quot;Ferguson&quot;,31.7,68.3,311865.0,102155.0,200624.0,-17.4,515563.0,-36.6,-31.57,-68.17],[&quot;Georgia 4th&quot;,&quot;GA-04&quot;,&quot;Democratic&quot;,&quot;Hank&quot;,&quot;Johnson&quot;,75.7,24.3,298663.0,224907.0,66433.0,26.1,504112.0,51.4,53.06,104.46],[&quot;Georgia 5th&quot;,&quot;GA-05&quot;,&quot;Democratic&quot;,&quot;John&quot;,&quot;Lewis&quot;,84.4,15.6,305754.0,259805.0,36385.0,36.6,539971.0,68.8,73.07,141.87],[&quot;Georgia 6th&quot;,&quot;GA-06&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Price&quot;,38.3,61.7,331246.0,155077.0,160022.0,-1.9,519945.0,-23.4,-1.49,-24.89],[&quot;Georgia 7th&quot;,&quot;GA-07&quot;,&quot;Republican&quot;,&quot;Rob&quot;,&quot;Woodall&quot;,39.6,60.4,294972.0,132012.0,150845.0,-4.4,489192.0,-20.8,-6.38,-27.18],[&quot;Georgia 8th&quot;,&quot;GA-08&quot;,&quot;Republican&quot;,&quot;Austin&quot;,&quot;Scott&quot;,32.4,67.6,265514.0,91360.0,168193.0,-15.9,517611.0,-35.2,-28.94,-64.14],[&quot;Georgia 9th&quot;,&quot;GA-09&quot;,&quot;Republican&quot;,&quot;Doug&quot;,&quot;Collins&quot;,0.0,100.0,297215.0,57468.0,231194.0,-31.2,522084.0,-100.0,-58.45,-158.45],[&quot;Georgia 10th&quot;,&quot;GA-10&quot;,&quot;Republican&quot;,&quot;Jody&quot;,&quot;Hice&quot;,0.0,100.0,315073.0,112691.0,193030.0,-14.3,519419.0,-100.0,-25.5,-125.5],[&quot;Georgia 11th&quot;,&quot;GA-11&quot;,&quot;Republican&quot;,&quot;Barry&quot;,&quot;Loudermilk&quot;,32.6,67.4,329615.0,116457.0,198813.0,-14.2,512972.0,-34.8,-24.99,-59.79],[&quot;Georgia 12th&quot;,&quot;GA-12&quot;,&quot;Republican&quot;,&quot;Rick&quot;,&quot;Allen&quot;,38.4,61.6,267674.0,108937.0,152204.0,-9.4,519454.0,-23.2,-16.16,-39.36],[&quot;Georgia 13th&quot;,&quot;GA-13&quot;,&quot;Democratic&quot;,&quot;David&quot;,&quot;Scott&quot;,100.0,0.0,301238.0,213936.0,80157.0,21.6,492458.0,100.0,44.41,144.41],[&quot;Georgia 14th&quot;,&quot;GA-14&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Graves&quot;,0.0,100.0,255872.0,56513.0,191849.0,-28.4,509005.0,-100.0,-52.89,-152.89],[&quot;Hawaii 1st&quot;,&quot;HI-01&quot;,&quot;Democratic&quot;,&quot;Colleen&quot;,&quot;Hanabusa&quot;,71.9,22.7,209300.0,132009.0,63916.0,16.3,537531.0,49.2,32.53,81.73],[&quot;Hawaii 2nd&quot;,&quot;HI-02&quot;,&quot;Democratic&quot;,&quot;Tulsi&quot;,&quot;Gabbard&quot;,81.2,18.8,219637.0,134882.0,64931.0,16.4,518952.0,62.4,31.85,94.25],[&quot;Idaho 1st&quot;,&quot;ID-01&quot;,&quot;Republican&quot;,&quot;Ra\u00fal&quot;,&quot;Labrador&quot;,31.8,68.2,359661.0,91284.0,229034.0,-22.6,571430.0,-36.4,-38.3,-74.7],[&quot;Idaho 2nd&quot;,&quot;ID-02&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Simpson&quot;,29.4,62.9,330594.0,98481.0,180021.0,-15.8,567080.0,-33.5,-24.66,-58.16],[&quot;Illinois 1st&quot;,&quot;IL-01&quot;,&quot;Democratic&quot;,&quot;Bobby&quot;,&quot;Rush&quot;,74.1,25.9,326175.0,245908.0,69956.0,26.7,533507.0,48.2,53.94,102.14],[&quot;Illinois 2nd&quot;,&quot;IL-02&quot;,&quot;Democratic&quot;,&quot;Robin&quot;,&quot;Kelly&quot;,79.8,20.2,303622.0,236726.0,58024.0,29.2,522175.0,59.6,58.86,118.46],[&quot;Illinois 3rd&quot;,&quot;IL-03&quot;,&quot;Democratic&quot;,&quot;Dan&quot;,&quot;Lipinski&quot;,100.0,0.0,284970.0,157383.0,113779.0,6.9,530768.0,100.0,15.3,115.3],[&quot;Illinois 4th&quot;,&quot;IL-04&quot;,&quot;Democratic&quot;,&quot;Luis&quot;,&quot;Guti\u00e9rrez&quot;,100.0,0.0,209931.0,172374.0,27807.0,35.0,509233.0,100.0,68.86,168.86],[&quot;Illinois 5th&quot;,&quot;IL-05&quot;,&quot;Democratic&quot;,&quot;Mike&quot;,&quot;Quigley&quot;,67.8,27.5,326036.0,229937.0,78069.0,23.5,582376.0,40.3,46.58,86.88],[&quot;Illinois 6th&quot;,&quot;IL-06&quot;,&quot;Republican&quot;,&quot;Peter&quot;,&quot;Roskam&quot;,40.8,59.2,353766.0,177578.0,152909.0,2.6,531232.0,-18.4,6.97,-11.43],[&quot;Illinois 7th&quot;,&quot;IL-07&quot;,&quot;Democratic&quot;,&quot;Danny&quot;,&quot;Davis&quot;,84.2,15.8,310159.0,271100.0,28580.0,39.3,551986.0,68.4,78.19,146.59],[&quot;Illinois 8th&quot;,&quot;IL-08&quot;,&quot;Democratic&quot;,&quot;Raja&quot;,&quot;Krishnamoorthi&quot;,58.3,41.7,255064.0,148233.0,92926.0,10.4,535959.0,16.6,21.68,38.28],[&quot;Illinois 9th&quot;,&quot;IL-09&quot;,&quot;Democratic&quot;,&quot;Jan&quot;,&quot;Schakowsky&quot;,66.5,33.5,339587.0,238096.0,84456.0,22.7,564386.0,33.0,45.24,78.24],[&quot;Illinois 10th&quot;,&quot;IL-10&quot;,&quot;Democratic&quot;,&quot;Brad&quot;,&quot;Schneider&quot;,52.6,47.4,288303.0,178857.0,94108.0,14.4,525064.0,5.2,29.4,34.6],[&quot;Illinois 11th&quot;,&quot;IL-11&quot;,&quot;Democratic&quot;,&quot;Bill&quot;,&quot;Foster&quot;,60.4,39.6,279620.0,164632.0,99104.0,11.3,508627.0,20.8,23.43,44.23],[&quot;Illinois 12th&quot;,&quot;IL-12&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Bost&quot;,39.7,54.3,315846.0,126817.0,173693.0,-8.9,547710.0,-14.6,-14.84,-29.44],[&quot;Illinois 13th&quot;,&quot;IL-13&quot;,&quot;Republican&quot;,&quot;Rodney&quot;,&quot;Davis&quot;,40.3,59.7,319979.0,141541.0,159013.0,-4.0,561827.0,-19.4,-5.46,-24.86],[&quot;Illinois 14th&quot;,&quot;IL-14&quot;,&quot;Republican&quot;,&quot;Randy&quot;,&quot;Hultgren&quot;,40.7,59.3,343417.0,153989.0,167348.0,-3.2,508613.0,-18.6,-3.89,-22.49],[&quot;Illinois 15th&quot;,&quot;IL-15&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Shimkus&quot;,0.0,100.0,320442.0,78574.0,226605.0,-25.4,550135.0,-100.0,-46.2,-146.2],[&quot;Illinois 16th&quot;,&quot;IL-16&quot;,&quot;Republican&quot;,&quot;Adam&quot;,&quot;Kinzinger&quot;,0.0,99.9,311988.0,119542.0,173093.0,-10.3,544420.0,-99.9,-17.16,-117.06],[&quot;Illinois 17th&quot;,&quot;IL-17&quot;,&quot;Democratic&quot;,&quot;Cheri&quot;,&quot;Bustos&quot;,60.3,39.7,287103.0,133999.0,136017.0,-1.5,545747.0,20.6,-0.7,19.9],[&quot;Illinois 18th&quot;,&quot;IL-18&quot;,&quot;Republican&quot;,&quot;Darin&quot;,&quot;LaHood&quot;,27.9,72.1,347134.0,115442.0,210529.0,-15.7,547688.0,-44.2,-27.39,-71.59],[&quot;Indiana 1st&quot;,&quot;IN-01&quot;,&quot;Democratic&quot;,&quot;Pete&quot;,&quot;Visclosky&quot;,81.5,0.0,300283.0,162358.0,124638.0,5.5,539744.0,81.5,12.56,94.06],[&quot;Indiana 2nd&quot;,&quot;IN-02&quot;,&quot;Republican&quot;,&quot;Jackie&quot;,&quot;Walorski&quot;,36.9,59.3,275928.0,99496.0,163527.0,-13.3,536097.0,-22.4,-23.21,-45.61],[&quot;Indiana 3rd&quot;,&quot;IN-03&quot;,&quot;Republican&quot;,&quot;Jim&quot;,&quot;Banks&quot;,23.0,70.1,291173.0,87697.0,189573.0,-19.5,526624.0,-47.1,-34.99,-82.09],[&quot;Indiana 4th&quot;,&quot;IN-04&quot;,&quot;Republican&quot;,&quot;Todd&quot;,&quot;Rokita&quot;,30.5,64.6,302370.0,91264.0,194402.0,-19.2,546655.0,-34.1,-34.11,-68.21],[&quot;Indiana 5th&quot;,&quot;IN-05&quot;,&quot;Republican&quot;,&quot;Susan&quot;,&quot;Brooks&quot;,34.3,61.5,363584.0,150081.0,192998.0,-7.4,535579.0,-27.2,-11.8,-39.0],[&quot;Indiana 6th&quot;,&quot;IN-06&quot;,&quot;Republican&quot;,&quot;Luke&quot;,&quot;Messer&quot;,26.7,69.1,301524.0,82498.0,204129.0,-22.3,548538.0,-42.4,-40.34,-82.74],[&quot;Indiana 7th&quot;,&quot;IN-07&quot;,&quot;Democratic&quot;,&quot;Andr\u00e9&quot;,&quot;Carson&quot;,60.0,35.7,264325.0,156015.0,95625.0,10.9,533492.0,24.3,22.85,47.15],[&quot;Indiana 8th&quot;,&quot;IN-08&quot;,&quot;Republican&quot;,&quot;Larry&quot;,&quot;Bucshon&quot;,31.7,63.7,300621.0,92844.0,194208.0,-18.8,554038.0,-32.0,-33.72,-65.72],[&quot;Indiana 9th&quot;,&quot;IN-09&quot;,&quot;Republican&quot;,&quot;Trey&quot;,&quot;Hollingsworth&quot;,40.5,54.1,324475.0,110835.0,198106.0,-15.2,554737.0,-13.6,-26.9,-40.5],[&quot;Iowa 1st&quot;,&quot;IA-01&quot;,&quot;Republican&quot;,&quot;Rod&quot;,&quot;Blum&quot;,46.1,53.7,390934.0,176535.0,190410.0,-3.0,581256.0,-7.6,-3.55,-11.15],[&quot;Iowa 2nd&quot;,&quot;IA-02&quot;,&quot;Democratic&quot;,&quot;Dave&quot;,&quot;Loebsack&quot;,53.7,46.2,379959.0,170796.0,186384.0,-3.3,584497.0,7.5,-4.1,3.4],[&quot;Iowa 3rd&quot;,&quot;IA-03&quot;,&quot;Republican&quot;,&quot;David&quot;,&quot;Young&quot;,39.7,53.4,397492.0,178937.0,192960.0,-3.0,568128.0,-13.7,-3.53,-17.23],[&quot;Iowa 4th&quot;,&quot;IA-04&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;King&quot;,38.6,61.2,379900.0,127401.0,231229.0,-15.6,584481.0,-22.6,-27.33,-49.93],[&quot;Kansas 1st&quot;,&quot;KS-01&quot;,&quot;Republican&quot;,&quot;Roger&quot;,&quot;Marshall&quot;,0.0,65.9,264783.0,64384.0,183473.0,-25.1,536568.0,-65.9,-44.98,-110.88],[&quot;Kansas 2nd&quot;,&quot;KS-02&quot;,&quot;Republican&quot;,&quot;Lynn&quot;,&quot;Jenkins&quot;,32.6,60.9,295657.0,110596.0,165000.0,-11.0,543270.0,-28.3,-18.4,-46.7],[&quot;Kansas 3rd&quot;,&quot;KS-03&quot;,&quot;Republican&quot;,&quot;Kevin&quot;,&quot;Yoder&quot;,40.6,51.3,341967.0,161479.0,157304.0,-0.5,522489.0,-10.7,1.22,-9.48],[&quot;Kansas 4th&quot;,&quot;KS-04&quot;,&quot;Vacant (R)&quot;,&quot;Vacant&quot;,&quot;Vacant&quot;,29.6,60.7,274528.0,90546.0,165241.0,-15.7,523820.0,-31.1,-27.21,-58.31],[&quot;Kentucky 1st&quot;,&quot;KY-01&quot;,&quot;Republican&quot;,&quot;James&quot;,&quot;Comer&quot;,27.3,72.6,310299.0,74179.0,224657.0,-26.3,554556.0,-45.3,-48.49,-93.79],[&quot;Kentucky 2nd&quot;,&quot;KY-02&quot;,&quot;Republican&quot;,&quot;Brett&quot;,&quot;Guthrie&quot;,0.0,100.0,324512.0,89563.0,219152.0,-22.1,548073.0,-100.0,-39.93,-139.93],[&quot;Kentucky 3rd&quot;,&quot;KY-03&quot;,&quot;Democratic&quot;,&quot;John&quot;,&quot;Yarmuth&quot;,63.5,36.5,340043.0,186549.0,135714.0,6.8,556038.0,27.0,14.95,41.95],[&quot;Kentucky 4th&quot;,&quot;KY-04&quot;,&quot;Republican&quot;,&quot;Thomas&quot;,&quot;Massie&quot;,28.7,71.3,337149.0,98664.0,219749.0,-20.1,539855.0,-42.6,-35.91,-78.51],[&quot;Kentucky 5th&quot;,&quot;KY-05&quot;,&quot;Republican&quot;,&quot;Hal&quot;,&quot;Rogers&quot;,0.0,100.0,278383.0,48628.0,221558.0,-33.1,559487.0,-100.0,-62.12,-162.12],[&quot;Kentucky 6th&quot;,&quot;KY-06&quot;,&quot;Republican&quot;,&quot;Andy&quot;,&quot;Barr&quot;,38.9,61.1,333012.0,131271.0,182141.0,-9.2,557982.0,-22.2,-15.28,-37.48],[&quot;Louisiana 1st&quot;,&quot;LA-01&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;Scalise&quot;,19.5,74.6,356482.0,95169.0,244907.0,-23.1,580152.0,-55.1,-42.0,-97.1],[&quot;Louisiana 2nd&quot;,&quot;LA-02&quot;,&quot;Democratic&quot;,&quot;Cedric&quot;,&quot;Richmond&quot;,100.0,0.0,331702.0,247490.0,73779.0,25.9,569251.0,100.0,52.37,152.37],[&quot;Louisiana 3rd&quot;,&quot;LA-03&quot;,&quot;Republican&quot;,&quot;Clay&quot;,&quot;Higgins&quot;,17.5,80.7,343025.0,100241.0,231017.0,-20.9,561690.0,-63.2,-38.12,-101.32],[&quot;Louisiana 4th&quot;,&quot;LA-04&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Johnson&quot;,28.2,69.8,318462.0,116599.0,192977.0,-13.4,566615.0,-41.6,-23.98,-65.58],[&quot;Louisiana 5th&quot;,&quot;LA-05&quot;,&quot;Republican&quot;,&quot;Ralph&quot;,&quot;Abraham&quot;,0.0,100.0,323409.0,110259.0,205258.0,-16.2,567467.0,-100.0,-29.37,-129.37],[&quot;Louisiana 6th&quot;,&quot;LA-06&quot;,&quot;Republican&quot;,&quot;Garret&quot;,&quot;Graves&quot;,23.9,72.8,355951.0,110395.0,230700.0,-18.7,570182.0,-48.9,-33.8,-82.7],[&quot;Maine 1st&quot;,&quot;ME-01&quot;,&quot;Democratic&quot;,&quot;Chellie&quot;,&quot;Pingree&quot;,58.0,41.9,393343.0,212773.0,154425.0,6.8,526524.0,16.1,14.83,30.93],[&quot;Maine 2nd&quot;,&quot;ME-02&quot;,&quot;Republican&quot;,&quot;Bruce&quot;,&quot;Poliquin&quot;,45.2,54.8,352341.0,144962.0,181168.0,-6.7,527304.0,-9.6,-10.28,-19.88],[&quot;Maryland 1st&quot;,&quot;MD-01&quot;,&quot;Republican&quot;,&quot;Andy&quot;,&quot;Harris&quot;,28.6,67.0,363917.0,121841.0,225249.0,-16.0,556858.0,-38.4,-28.42,-66.82],[&quot;Maryland 2nd&quot;,&quot;MD-02&quot;,&quot;Democratic&quot;,&quot;Dutch&quot;,&quot;Ruppersberger&quot;,62.1,33.1,321234.0,193236.0,114461.0,11.7,548029.0,29.0,24.52,53.52],[&quot;Maryland 3rd&quot;,&quot;MD-03&quot;,&quot;Democratic&quot;,&quot;John&quot;,&quot;Sarbanes&quot;,63.2,33.9,352627.0,221842.0,113317.0,15.1,561258.0,29.3,30.78,60.08],[&quot;Maryland 4th&quot;,&quot;MD-04&quot;,&quot;Democratic&quot;,&quot;Anthony&quot;,&quot;Brown&quot;,74.1,21.4,330115.0,256575.0,63390.0,29.1,546219.0,52.7,58.52,111.22],[&quot;Maryland 5th&quot;,&quot;MD-05&quot;,&quot;Democratic&quot;,&quot;Steny&quot;,&quot;Hoyer&quot;,67.4,29.4,355428.0,225989.0,115868.0,15.0,546582.0,38.0,30.98,68.98],[&quot;Maryland 6th&quot;,&quot;MD-06&quot;,&quot;Democratic&quot;,&quot;John&quot;,&quot;Delaney&quot;,56.0,40.1,339563.0,189512.0,134827.0,7.3,551978.0,15.9,16.1,32.0],[&quot;Maryland 7th&quot;,&quot;MD-07&quot;,&quot;Democratic&quot;,&quot;Elijah&quot;,&quot;Cummings&quot;,74.9,21.8,309849.0,233796.0,63444.0,27.5,554898.0,53.1,54.98,108.08],[&quot;Maryland 8th&quot;,&quot;MD-08&quot;,&quot;Democratic&quot;,&quot;Jamie&quot;,&quot;Raskin&quot;,60.6,34.2,363916.0,235137.0,112613.0,16.5,554766.0,26.4,33.67,60.07],[&quot;Massachusetts 1st&quot;,&quot;MA-01&quot;,&quot;Democratic&quot;,&quot;Richie&quot;,&quot;Neal&quot;,73.3,0.0,339326.0,194036.0,123953.0,9.9,564391.0,73.3,20.65,93.95],[&quot;Massachusetts 2nd&quot;,&quot;MA-02&quot;,&quot;Democratic&quot;,&quot;Jim&quot;,&quot;McGovern&quot;,98.2,0.0,351423.0,197492.0,129437.0,9.3,566402.0,98.2,19.37,117.57],[&quot;Massachusetts 3rd&quot;,&quot;MA-03&quot;,&quot;Democratic&quot;,&quot;Niki&quot;,&quot;Tsongas&quot;,68.7,31.2,348563.0,202952.0,123347.0,11.1,549384.0,37.5,22.84,60.34],[&quot;Massachusetts 4th&quot;,&quot;MA-04&quot;,&quot;Democratic&quot;,&quot;Joe&quot;,&quot;Kennedy&quot;,70.1,29.8,381767.0,225976.0,133705.0,11.7,556642.0,40.3,24.17,64.47],[&quot;Massachusetts 5th&quot;,&quot;MA-05&quot;,&quot;Democratic&quot;,&quot;Katherine&quot;,&quot;Clark&quot;,98.6,0.0,373498.0,258908.0,95922.0,21.9,579172.0,98.6,43.64,142.24],[&quot;Massachusetts 6th&quot;,&quot;MA-06&quot;,&quot;Democratic&quot;,&quot;Seth&quot;,&quot;Moulton&quot;,98.4,0.0,401046.0,224858.0,153244.0,8.4,564150.0,98.4,17.86,116.26],[&quot;Massachusetts 7th&quot;,&quot;MA-07&quot;,&quot;Democratic&quot;,&quot;Mike&quot;,&quot;Capuano&quot;,98.6,0.0,301939.0,254037.0,36018.0,36.5,599387.0,98.6,72.21,170.81],[&quot;Massachusetts 8th&quot;,&quot;MA-08&quot;,&quot;Democratic&quot;,&quot;Stephen&quot;,&quot;Lynch&quot;,72.4,27.5,382917.0,231356.0,131624.0,12.6,575118.0,44.9,26.05,70.95],[&quot;Massachusetts 9th&quot;,&quot;MA-09&quot;,&quot;Democratic&quot;,&quot;Bill&quot;,&quot;Keating&quot;,55.7,33.6,391289.0,205581.0,163643.0,4.6,574060.0,22.1,10.72,32.82],[&quot;Michigan 1st&quot;,&quot;MI-01&quot;,&quot;Republican&quot;,&quot;Jack&quot;,&quot;Bergman&quot;,40.1,54.9,364131.1,133236.7,210822.1,-12.4,562018.0,-14.8,-21.31,-36.11],[&quot;Michigan 2nd&quot;,&quot;MI-02&quot;,&quot;Republican&quot;,&quot;Bill&quot;,&quot;Huizenga&quot;,32.5,62.6,346504.8,132462.3,193198.1,-10.4,526885.0,-30.1,-17.53,-47.63],[&quot;Michigan 3rd&quot;,&quot;MI-03&quot;,&quot;Republican&quot;,&quot;Justin&quot;,&quot;Amash&quot;,37.5,59.5,349489.7,147329.8,180344.0,-6.2,525031.0,-22.0,-9.45,-31.45],[&quot;Michigan 4th&quot;,&quot;MI-04&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Moolenaar&quot;,32.1,61.6,328239.9,113817.1,195302.5,-14.3,549309.0,-29.5,-24.82,-54.32],[&quot;Michigan 5th&quot;,&quot;MI-05&quot;,&quot;Democratic&quot;,&quot;Dan&quot;,&quot;Kildee&quot;,61.2,35.1,327572.3,162961.1,148972.0,1.1,535819.0,26.1,4.27,30.37],[&quot;Michigan 6th&quot;,&quot;MI-06&quot;,&quot;Republican&quot;,&quot;Fred&quot;,&quot;Upton&quot;,36.4,58.6,331985.5,142305.1,170314.3,-5.6,536850.0,-22.2,-8.44,-30.64],[&quot;Michigan 7th&quot;,&quot;MI-07&quot;,&quot;Republican&quot;,&quot;Tim&quot;,&quot;Walberg&quot;,40.0,55.1,340357.8,131566.2,189655.5,-10.2,539775.0,-15.1,-17.07,-32.17],[&quot;Michigan 8th&quot;,&quot;MI-08&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Bishop&quot;,39.2,56.0,374968.0,164436.0,189891.0,-4.7,537989.0,-16.8,-6.79,-23.59],[&quot;Michigan 9th&quot;,&quot;MI-09&quot;,&quot;Democratic&quot;,&quot;Sandy&quot;,&quot;Levin&quot;,57.9,37.4,355751.0,183085.0,155597.0,2.9,554396.0,20.5,7.73,28.23],[&quot;Michigan 10th&quot;,&quot;MI-10&quot;,&quot;Republican&quot;,&quot;Paul&quot;,&quot;Mitchell&quot;,32.3,63.1,357784.7,113064.9,228171.0,-18.0,535917.0,-30.8,-32.17,-62.97],[&quot;Michigan 11th&quot;,&quot;MI-11&quot;,&quot;Republican&quot;,&quot;Dave&quot;,&quot;Trott&quot;,40.2,52.9,390926.0,177143.0,194245.0,-3.4,537930.0,-12.7,-4.37,-17.07],[&quot;Michigan 12th&quot;,&quot;MI-12&quot;,&quot;Democratic&quot;,&quot;Debbie&quot;,&quot;Dingell&quot;,64.3,29.3,338523.2,205938.8,116740.5,12.7,545365.0,35.0,26.35,61.35],[&quot;Michigan 13th&quot;,&quot;MI-13&quot;,&quot;Democratic&quot;,&quot;John&quot;,&quot;Conyers&quot;,77.1,15.7,265343.0,209105.0,48111.0,30.2,523898.0,61.4,60.67,122.07],[&quot;Michigan 14th&quot;,&quot;MI-14&quot;,&quot;Democratic&quot;,&quot;Brenda&quot;,&quot;Lawrence&quot;,78.5,18.7,318751.0,252387.0,58179.0,30.2,528390.0,59.8,60.93,120.73],[&quot;Minnesota 1st&quot;,&quot;MN-01&quot;,&quot;Democratic&quot;,&quot;Tim&quot;,&quot;Walz&quot;,50.3,49.6,340831.0,130831.0,181647.0,-9.2,505339.0,0.7,-14.91,-14.21],[&quot;Minnesota 2nd&quot;,&quot;MN-02&quot;,&quot;Republican&quot;,&quot;Jason&quot;,&quot;Lewis&quot;,45.2,47.0,377887.0,171287.0,175807.0,-1.8,485541.0,-1.8,-1.2,-3.0],[&quot;Minnesota 3rd&quot;,&quot;MN-03&quot;,&quot;Republican&quot;,&quot;Erik&quot;,&quot;Paulsen&quot;,43.0,56.7,397008.0,201833.0,164259.0,4.0,496951.0,-13.7,9.46,-4.24],[&quot;Minnesota 4th&quot;,&quot;MN-04&quot;,&quot;Democratic&quot;,&quot;Betty&quot;,&quot;McCollum&quot;,57.8,34.4,363650.0,223803.0,111163.0,15.7,504063.0,23.4,30.97,54.37],[&quot;Minnesota 5th&quot;,&quot;MN-05&quot;,&quot;Democratic&quot;,&quot;Keith&quot;,&quot;Ellison&quot;,69.1,22.3,370869.0,273402.0,68535.0,28.8,523712.0,46.8,55.24,102.04],[&quot;Minnesota 6th&quot;,&quot;MN-06&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Emmer&quot;,34.3,65.6,370947.0,123329.0,218546.0,-15.0,482759.0,-31.3,-25.67,-56.97],[&quot;Minnesota 7th&quot;,&quot;MN-07&quot;,&quot;Democratic&quot;,&quot;Collin&quot;,&quot;Peterson&quot;,52.5,47.4,337005.0,104566.0,208215.0,-17.7,505477.0,5.1,-30.76,-25.66],[&quot;Minnesota 8th&quot;,&quot;MN-08&quot;,&quot;Democratic&quot;,&quot;Rick&quot;,&quot;Nolan&quot;,50.2,49.6,359353.0,138665.0,194779.0,-9.5,516020.0,0.6,-15.62,-15.02],[&quot;Mississippi 1st&quot;,&quot;MS-01&quot;,&quot;Republican&quot;,&quot;Trent&quot;,&quot;Kelly&quot;,27.9,68.7,310622.2,100769.5,203143.7,-18.0,553526.0,-40.8,-32.96,-73.76],[&quot;Mississippi 2nd&quot;,&quot;MS-02&quot;,&quot;Democratic&quot;,&quot;Bennie&quot;,&quot;Thompson&quot;,67.1,29.1,291426.7,185208.3,102391.5,13.3,543684.0,38.0,28.42,66.42],[&quot;Mississippi 3rd&quot;,&quot;MS-03&quot;,&quot;Republican&quot;,&quot;Gregg&quot;,&quot;Harper&quot;,30.4,66.2,323853.1,119108.2,198526.8,-13.6,557605.0,-35.8,-24.52,-60.32],[&quot;Mississippi 4th&quot;,&quot;MS-04&quot;,&quot;Republican&quot;,&quot;Steven&quot;,&quot;Palazzo&quot;,27.8,65.0,283455.0,80045.0,196652.0,-22.2,556927.0,-37.2,-41.14,-78.34],[&quot;Missouri 1st&quot;,&quot;MO-01&quot;,&quot;Democratic&quot;,&quot;Lacy&quot;,&quot;Clay&quot;,75.5,20.0,319606.0,246107.0,60136.0,29.3,575685.0,55.5,58.19,113.69],[&quot;Missouri 2nd&quot;,&quot;MO-02&quot;,&quot;Republican&quot;,&quot;Ann&quot;,&quot;Wagner&quot;,37.7,58.5,420072.0,177647.0,220842.0,-6.5,572513.0,-20.8,-10.28,-31.08],[&quot;Missouri 3rd&quot;,&quot;MO-03&quot;,&quot;Republican&quot;,&quot;Blaine&quot;,&quot;Luetkemeyer&quot;,27.9,67.8,378846.0,106365.0,254183.0,-21.6,563086.0,-39.9,-39.02,-78.92],[&quot;Missouri 4th&quot;,&quot;MO-04&quot;,&quot;Republican&quot;,&quot;Vicky&quot;,&quot;Hartzler&quot;,27.8,67.8,340290.0,99844.0,222162.0,-20.1,573748.0,-40.0,-35.95,-75.95],[&quot;Missouri 5th&quot;,&quot;MO-05&quot;,&quot;Democratic&quot;,&quot;Emanuel&quot;,&quot;Cleaver&quot;,58.8,38.2,328803.0,177772.0,133458.0,6.0,569063.0,20.6,13.48,34.08],[&quot;Missouri 6th&quot;,&quot;MO-06&quot;,&quot;Republican&quot;,&quot;Sam&quot;,&quot;Graves&quot;,28.4,68.0,354014.0,112056.0,223375.0,-17.7,564869.0,-39.6,-31.44,-71.04],[&quot;Missouri 7th&quot;,&quot;MO-07&quot;,&quot;Republican&quot;,&quot;Billy&quot;,&quot;Long&quot;,27.4,67.5,342069.0,84419.0,240690.0,-25.1,571140.0,-40.1,-45.68,-85.78],[&quot;Missouri 8th&quot;,&quot;MO-08&quot;,&quot;Republican&quot;,&quot;Jason&quot;,&quot;Smith&quot;,22.7,74.4,317749.0,66858.0,239666.0,-29.3,573387.0,-51.7,-54.39,-106.09],[&quot;Montana At-Large&quot;,&quot;MT-AL&quot;,&quot;Republican&quot;,&quot;Ryan&quot;,&quot;Zinke&quot;,40.5,56.2,494525.0,177709.0,279240.0,-12.2,765852.0,-15.7,-20.53,-36.23],[&quot;Nebraska 1st&quot;,&quot;NE-01&quot;,&quot;Republican&quot;,&quot;Jeff&quot;,&quot;Fortenberry&quot;,30.5,69.5,276046.0,100030.0,158629.0,-12.4,458727.0,-39.0,-21.23,-60.23],[&quot;Nebraska 2nd&quot;,&quot;NE-02&quot;,&quot;Republican&quot;,&quot;Don&quot;,&quot;Bacon&quot;,47.7,48.9,285211.0,131102.0,137506.0,-2.3,447161.0,-1.2,-2.25,-3.45],[&quot;Nebraska 3rd&quot;,&quot;NE-03&quot;,&quot;Republican&quot;,&quot;Adrian&quot;,&quot;Smith&quot;,0.0,100.0,266918.0,53362.0,199826.0,-30.0,461232.0,-100.0,-54.87,-154.87],[&quot;Nevada 1st&quot;,&quot;NV-01&quot;,&quot;Democratic&quot;,&quot;Dina&quot;,&quot;Titus&quot;,61.9,28.8,196840.0,121321.0,64233.0,14.3,509371.0,33.1,29.0,62.1],[&quot;Nevada 2nd&quot;,&quot;NV-02&quot;,&quot;Republican&quot;,&quot;Mark&quot;,&quot;Amodei&quot;,36.9,58.3,326011.0,129318.0,169631.0,-7.9,515125.0,-21.4,-12.37,-33.77],[&quot;Nevada 3rd&quot;,&quot;NV-03&quot;,&quot;Democratic&quot;,&quot;Jacky&quot;,&quot;Rosen&quot;,47.2,46.0,325602.0,151552.0,154815.0,-1.6,521733.0,1.2,-1.0,0.2],[&quot;Nevada 4th&quot;,&quot;NV-04&quot;,&quot;Democratic&quot;,&quot;Ruben&quot;,&quot;Kihuen&quot;,48.5,44.5,276932.0,137070.0,123380.0,1.5,489314.0,4.0,4.94,8.94],[&quot;New Hampshire 1st&quot;,&quot;NH-01&quot;,&quot;Democratic&quot;,&quot;Carol&quot;,&quot;Shea-Porter&quot;,45.8,44.4,371973.0,173344.0,179259.0,-2.0,514495.0,1.4,-1.59,-0.19],[&quot;New Hampshire 2nd&quot;,&quot;NH-02&quot;,&quot;Democratic&quot;,&quot;Annie&quot;,&quot;Kuster&quot;,49.8,45.4,360294.0,175182.0,166531.0,0.2,514741.0,4.4,2.4,6.8],[&quot;New Jersey 1st&quot;,&quot;NJ-01&quot;,&quot;Democratic&quot;,&quot;Donald&quot;,&quot;Norcross&quot;,60.0,36.8,329188.0,199386.0,118880.0,11.5,556968.0,23.2,24.46,47.66],[&quot;New Jersey 2nd&quot;,&quot;NJ-02&quot;,&quot;Republican&quot;,&quot;Frank&quot;,&quot;LoBiondo&quot;,37.2,59.2,321004.0,147656.0,162486.0,-3.5,564025.0,-22.0,-4.62,-26.62],[&quot;New Jersey 3rd&quot;,&quot;NJ-03&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;MacArthur&quot;,38.9,59.3,365240.0,165090.0,187703.0,-4.3,571390.0,-20.4,-6.19,-26.59],[&quot;New Jersey 4th&quot;,&quot;NJ-04&quot;,&quot;Republican&quot;,&quot;Chris&quot;,&quot;Smith&quot;,33.5,63.7,356583.0,146191.0,198859.0,-8.7,547849.0,-30.2,-14.77,-44.97],[&quot;New Jersey 5th&quot;,&quot;NJ-05&quot;,&quot;Democratic&quot;,&quot;Josh&quot;,&quot;Gottheimer&quot;,51.1,46.7,364545.0,173963.0,178058.0,-1.7,559815.0,4.4,-1.12,3.28],[&quot;New Jersey 6th&quot;,&quot;NJ-06&quot;,&quot;Democratic&quot;,&quot;Frank&quot;,&quot;Pallone&quot;,63.7,34.9,289648.0,162857.0,117679.0,6.9,566466.0,28.8,15.6,44.4],[&quot;New Jersey 7th&quot;,&quot;NJ-07&quot;,&quot;Republican&quot;,&quot;Leonard&quot;,&quot;Lance&quot;,43.1,54.1,371592.0,180530.0,176386.0,-0.5,547532.0,-11.0,1.12,-9.88],[&quot;New Jersey 8th&quot;,&quot;NJ-08&quot;,&quot;Democratic&quot;,&quot;Albio&quot;,&quot;Sires&quot;,77.0,18.5,229736.0,173834.0,49336.0,26.8,572563.0,58.5,54.19,112.69],[&quot;New Jersey 9th&quot;,&quot;NJ-09&quot;,&quot;Democratic&quot;,&quot;Bill&quot;,&quot;Pascrell&quot;,69.7,28.0,276738.0,177954.0,91696.0,14.9,559066.0,41.7,31.17,72.87],[&quot;New Jersey 10th&quot;,&quot;NJ-10&quot;,&quot;Democratic&quot;,&quot;Donald&quot;,&quot;Payne&quot;,85.7,11.9,274410.0,233822.0,35111.0,35.8,556646.0,73.8,72.41,146.21],[&quot;New Jersey 11th&quot;,&quot;NJ-11&quot;,&quot;Republican&quot;,&quot;Rodney&quot;,&quot;Frelinghuysen&quot;,38.9,58.0,380595.0,182334.0,185696.0,-1.6,564075.0,-19.1,-0.88,-19.98],[&quot;New Jersey 12th&quot;,&quot;NJ-12&quot;,&quot;Democratic&quot;,&quot;Bonnie&quot;,&quot;Watson Coleman&quot;,62.9,32.0,314766.0,204661.0,100043.0,16.1,560285.0,30.9,33.24,64.14],[&quot;New Mexico 1st&quot;,&quot;NM-01&quot;,&quot;Democratic&quot;,&quot;Michelle&quot;,&quot;Lujan Grisham&quot;,65.1,34.9,285170.0,147250.0,100132.0,8.4,523774.0,30.2,16.52,46.72],[&quot;New Mexico 2nd&quot;,&quot;NM-02&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;Pearce&quot;,37.2,62.7,234095.0,93363.0,117211.0,-6.8,508668.0,-25.5,-10.19,-35.69],[&quot;New Mexico 3rd&quot;,&quot;NM-03&quot;,&quot;Democratic&quot;,&quot;Ben Ray&quot;,&quot;Luj\u00e1n&quot;,62.4,37.6,279053.0,144621.0,102323.0,7.5,508065.0,24.8,15.16,39.96],[&quot;New York 1st&quot;,&quot;NY-01&quot;,&quot;Republican&quot;,&quot;Lee&quot;,&quot;Zeldin&quot;,41.0,58.9,336437.0,141900.0,183233.0,-7.5,549345.0,-17.9,-12.29,-30.19],[&quot;New York 2nd&quot;,&quot;NY-02&quot;,&quot;Republican&quot;,&quot;Pete&quot;,&quot;King&quot;,37.5,62.4,313286.0,137680.0,165908.0,-5.8,546482.0,-24.9,-9.01,-33.91],[&quot;New York 3rd&quot;,&quot;NY-03&quot;,&quot;Democratic&quot;,&quot;Tom&quot;,&quot;Suozzi&quot;,52.8,47.2,345275.0,178288.0,156942.0,2.1,553265.0,5.6,6.18,11.78],[&quot;New York 4th&quot;,&quot;NY-04&quot;,&quot;Democratic&quot;,&quot;Kathleen&quot;,&quot;Rice&quot;,59.5,40.4,336811.0,179845.0,147469.0,3.8,552258.0,19.1,9.61,28.71],[&quot;New York 5th&quot;,&quot;NY-05&quot;,&quot;Democratic&quot;,&quot;Gregory&quot;,&quot;Meeks&quot;,85.4,13.0,246961.0,211667.0,31322.0,36.0,539006.0,72.4,73.03,145.43],[&quot;New York 6th&quot;,&quot;NY-06&quot;,&quot;Democratic&quot;,&quot;Grace&quot;,&quot;Meng&quot;,72.1,26.7,207285.0,134970.0,66487.0,15.9,590986.0,45.4,33.04,78.44],[&quot;New York 7th&quot;,&quot;NY-07&quot;,&quot;Democratic&quot;,&quot;Nydia&quot;,&quot;Vel\u00e1zquez&quot;,90.7,9.2,204473.0,177664.0,21198.0,38.2,542978.0,81.5,76.52,158.02],[&quot;New York 8th&quot;,&quot;NY-08&quot;,&quot;Democratic&quot;,&quot;Hakeem&quot;,&quot;Jeffries&quot;,93.2,0.0,254930.0,215689.0,34356.0,35.1,550237.0,93.2,71.13,164.33],[&quot;New York 9th&quot;,&quot;NY-09&quot;,&quot;Democratic&quot;,&quot;Yvette&quot;,&quot;Clarke&quot;,92.3,0.0,253789.0,211812.0,36600.0,34.2,558573.0,92.3,69.04,161.34],[&quot;New York 10th&quot;,&quot;NY-10&quot;,&quot;Democratic&quot;,&quot;Jerry&quot;,&quot;Nadler&quot;,78.0,21.9,261945.0,205114.0,49179.0,29.5,580997.0,56.1,59.53,115.63],[&quot;New York 11th&quot;,&quot;NY-11&quot;,&quot;Republican&quot;,&quot;Dan&quot;,&quot;Donovan&quot;,36.7,61.5,248457.0,108807.0,133232.0,-6.2,556859.0,-24.8,-9.83,-34.63],[&quot;New York 12th&quot;,&quot;NY-12&quot;,&quot;Democratic&quot;,&quot;Carolyn&quot;,&quot;Maloney&quot;,83.1,16.8,306909.0,255601.0,41383.0,35.0,632656.0,66.3,69.8,136.1],[&quot;New York 13th&quot;,&quot;NY-13&quot;,&quot;Democratic&quot;,&quot;Adriano&quot;,&quot;Espaillat&quot;,88.6,6.9,252393.0,232925.0,13727.0,43.3,556707.0,81.7,86.85,168.55],[&quot;New York 14th&quot;,&quot;NY-14&quot;,&quot;Democratic&quot;,&quot;Joe&quot;,&quot;Crowley&quot;,82.8,17.1,194923.0,151407.0,38560.0,28.6,569765.0,65.7,57.89,123.59],[&quot;New York 15th&quot;,&quot;NY-15&quot;,&quot;Democratic&quot;,&quot;Jos\u00e9&quot;,&quot;Serrano&quot;,95.2,3.5,191383.0,179454.0,9371.0,43.9,504655.0,91.7,88.87,180.57],[&quot;New York 16th&quot;,&quot;NY-16&quot;,&quot;Democratic&quot;,&quot;Eliot&quot;,&quot;Engel&quot;,94.4,0.0,283114.0,212644.0,63590.0,25.9,549246.0,94.4,52.65,147.05],[&quot;New York 17th&quot;,&quot;NY-17&quot;,&quot;Democratic&quot;,&quot;Nita&quot;,&quot;Lowey&quot;,99.1,0.0,318220.0,186437.0,122339.0,9.3,531665.0,99.1,20.14,119.24],[&quot;New York 18th&quot;,&quot;NY-18&quot;,&quot;Democratic&quot;,&quot;Sean Patrick&quot;,&quot;Maloney&quot;,55.6,44.4,310455.0,146175.0,152137.0,-2.1,536296.0,11.2,-1.92,9.28],[&quot;New York 19th&quot;,&quot;NY-19&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Faso&quot;,45.7,54.2,315518.0,138019.0,161027.0,-5.0,568027.0,-8.5,-7.29,-15.79],[&quot;New York 20th&quot;,&quot;NY-20&quot;,&quot;Democratic&quot;,&quot;Paul&quot;,&quot;Tonko&quot;,67.9,32.1,325088.0,175390.0,131559.0,6.0,565607.0,35.8,13.48,49.28],[&quot;New York 21st&quot;,&quot;NY-21&quot;,&quot;Republican&quot;,&quot;Elise&quot;,&quot;Stefanik&quot;,30.1,65.3,279438.0,111760.0,150481.0,-8.5,560156.0,-35.2,-13.86,-49.06],[&quot;New York 22nd&quot;,&quot;NY-22&quot;,&quot;Republican&quot;,&quot;Claudia&quot;,&quot;Tenney&quot;,41.0,46.5,289954.0,114016.0,158913.0,-9.3,562336.0,-5.5,-15.48,-20.98],[&quot;New York 23rd&quot;,&quot;NY-23&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Reed&quot;,42.4,57.6,290013.0,115010.0,158155.0,-9.0,561120.0,-15.2,-14.88,-30.08],[&quot;New York 24th&quot;,&quot;NY-24&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Katko&quot;,39.4,60.5,308574.0,151021.0,139763.0,0.8,553204.0,-21.1,3.65,-17.45],[&quot;New York 25th&quot;,&quot;NY-25&quot;,&quot;Democratic&quot;,&quot;Louise&quot;,&quot;Slaughter&quot;,56.1,43.8,329443.0,182896.0,128955.0,7.5,555664.0,12.3,16.37,28.67],[&quot;New York 26th&quot;,&quot;NY-26&quot;,&quot;Democratic&quot;,&quot;Brian&quot;,&quot;Higgins&quot;,74.6,25.4,304440.0,175336.0,115558.0,9.2,565026.0,49.2,19.64,68.84],[&quot;New York 27th&quot;,&quot;NY-27&quot;,&quot;Republican&quot;,&quot;Chris&quot;,&quot;Collins&quot;,32.8,67.2,346762.0,122102.0,206866.0,-14.0,560034.0,-34.4,-24.44,-58.84],[&quot;North Carolina 1st&quot;,&quot;NC-01&quot;,&quot;Democratic&quot;,&quot;G.K.&quot;,&quot;Butterfield&quot;,68.6,29.0,354704.0,239585.0,108100.0,17.8,567106.0,39.6,37.07,76.67],[&quot;North Carolina 2nd&quot;,&quot;NC-02&quot;,&quot;Republican&quot;,&quot;George&quot;,&quot;Holding&quot;,43.3,56.7,397167.0,173131.0,211450.0,-6.1,530179.0,-13.4,-9.65,-23.05],[&quot;North Carolina 3rd&quot;,&quot;NC-03&quot;,&quot;Republican&quot;,&quot;Walter&quot;,&quot;Jones&quot;,32.8,67.2,328403.0,121070.0,198843.0,-13.3,563610.0,-34.4,-23.68,-58.08],[&quot;North Carolina 4th&quot;,&quot;NC-04&quot;,&quot;Democratic&quot;,&quot;David&quot;,&quot;Price&quot;,68.2,31.8,412533.0,281517.0,116383.0,19.6,561968.0,36.4,40.03,76.43],[&quot;North Carolina 5th&quot;,&quot;NC-05&quot;,&quot;Republican&quot;,&quot;Virginia&quot;,&quot;Foxx&quot;,41.6,58.4,356490.0,142028.0,204207.0,-10.1,567664.0,-16.8,-17.44,-34.24],[&quot;North Carolina 6th&quot;,&quot;NC-06&quot;,&quot;Republican&quot;,&quot;Mark&quot;,&quot;Walker&quot;,40.8,59.2,358941.0,148761.0,201437.0,-8.6,558250.0,-18.4,-14.68,-33.08],[&quot;North Carolina 7th&quot;,&quot;NC-07&quot;,&quot;Republican&quot;,&quot;David&quot;,&quot;Rouzer&quot;,39.1,60.9,357908.0,142809.0,206150.0,-10.2,569264.0,-21.8,-17.7,-39.5],[&quot;North Carolina 8th&quot;,&quot;NC-08&quot;,&quot;Republican&quot;,&quot;Richard&quot;,&quot;Hudson&quot;,41.2,58.8,331236.0,136233.0,185875.0,-8.8,544179.0,-17.6,-14.99,-32.59],[&quot;North Carolina 9th&quot;,&quot;NC-09&quot;,&quot;Republican&quot;,&quot;Robert&quot;,&quot;Pittenger&quot;,41.8,58.2,343915.0,147084.0,186989.0,-7.1,536830.0,-16.4,-11.6,-28.0],[&quot;North Carolina 10th&quot;,&quot;NC-10&quot;,&quot;Republican&quot;,&quot;Patrick&quot;,&quot;McHenry&quot;,36.9,63.1,358269.0,130711.0,218369.0,-13.7,568988.0,-26.2,-24.47,-50.67],[&quot;North Carolina 11th&quot;,&quot;NC-11&quot;,&quot;Republican&quot;,&quot;Mark&quot;,&quot;Meadows&quot;,35.9,64.1,362420.0,122682.0,229545.0,-16.3,580523.0,-28.2,-29.49,-57.69],[&quot;North Carolina 12th&quot;,&quot;NC-12&quot;,&quot;Democratic&quot;,&quot;Alma&quot;,&quot;Adams&quot;,67.0,33.0,356321.0,243736.0,101161.0,19.6,546981.0,34.0,40.01,74.01],[&quot;North Carolina 13th&quot;,&quot;NC-13&quot;,&quot;Republican&quot;,&quot;Ted&quot;,&quot;Budd&quot;,43.9,56.1,363763.0,159968.0,194119.0,-5.9,558306.0,-12.2,-9.39,-21.59],[&quot;North Dakota At-Large&quot;,&quot;ND-AL&quot;,&quot;Republican&quot;,&quot;Kevin&quot;,&quot;Cramer&quot;,23.7,69.1,337963.0,93758.0,216794.0,-20.9,522720.0,-45.4,-36.41,-81.81],[&quot;Ohio 1st&quot;,&quot;OH-01&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;Chabot&quot;,40.8,59.2,361297.0,160988.0,185025.0,-4.6,539642.0,-18.4,-6.65,-25.05],[&quot;Ohio 2nd&quot;,&quot;OH-02&quot;,&quot;Republican&quot;,&quot;Brad&quot;,&quot;Wenstrup&quot;,32.8,65.0,354868.0,140773.0,197877.0,-9.5,547568.0,-32.2,-16.09,-48.29],[&quot;Ohio 3rd&quot;,&quot;OH-03&quot;,&quot;Democratic&quot;,&quot;Joyce&quot;,&quot;Beatty&quot;,68.6,31.4,314155.0,210445.0,89824.0,19.0,535897.0,37.2,38.4,75.6],[&quot;Ohio 4th&quot;,&quot;OH-04&quot;,&quot;Republican&quot;,&quot;Jim&quot;,&quot;Jordan&quot;,32.0,68.0,324648.0,99641.0,208715.0,-18.8,546601.0,-36.0,-33.6,-69.6],[&quot;Ohio 5th&quot;,&quot;OH-05&quot;,&quot;Republican&quot;,&quot;Bob&quot;,&quot;Latta&quot;,29.1,70.9,359624.0,124410.0,214653.0,-14.4,549592.0,-41.8,-25.09,-66.89],[&quot;Ohio 6th&quot;,&quot;OH-06&quot;,&quot;Republican&quot;,&quot;Bill&quot;,&quot;Johnson&quot;,29.3,70.7,320064.0,85512.0,221852.0,-23.3,561586.0,-41.4,-42.6,-84.0],[&quot;Ohio 7th&quot;,&quot;OH-07&quot;,&quot;Republican&quot;,&quot;Bob&quot;,&quot;Gibbs&quot;,29.0,64.0,328938.0,108004.0,205565.0,-16.7,544526.0,-35.0,-29.66,-64.66],[&quot;Ohio 8th&quot;,&quot;OH-08&quot;,&quot;Republican&quot;,&quot;Warren&quot;,&quot;Davidson&quot;,27.0,68.8,342785.0,104927.0,223221.0,-19.1,542712.0,-41.8,-34.51,-76.31],[&quot;Ohio 9th&quot;,&quot;OH-09&quot;,&quot;Democratic&quot;,&quot;Marcy&quot;,&quot;Kaptur&quot;,68.7,31.3,301655.0,177118.0,110204.0,10.5,552056.0,37.4,22.18,59.58],[&quot;Ohio 10th&quot;,&quot;OH-10&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Turner&quot;,32.7,64.1,348181.0,153323.0,178703.0,-4.9,557295.0,-31.4,-7.29,-38.69],[&quot;Ohio 11th&quot;,&quot;OH-11&quot;,&quot;Democratic&quot;,&quot;Marcia&quot;,&quot;Fudge&quot;,80.3,19.7,323301.0,260298.0,55018.0,31.4,548819.0,60.6,63.5,124.1],[&quot;Ohio 12th&quot;,&quot;OH-12&quot;,&quot;Republican&quot;,&quot;Pat&quot;,&quot;Tiberi&quot;,29.8,66.6,387279.0,162245.0,205883.0,-7.0,545814.0,-36.8,-11.27,-48.07],[&quot;Ohio 13th&quot;,&quot;OH-13&quot;,&quot;Democratic&quot;,&quot;Tim&quot;,&quot;Ryan&quot;,67.7,32.3,319877.0,163553.0,142800.0,2.3,570274.0,35.4,6.49,41.89],[&quot;Ohio 14th&quot;,&quot;OH-14&quot;,&quot;Republican&quot;,&quot;David&quot;,&quot;Joyce&quot;,37.4,62.6,369274.0,155602.0,197884.0,-7.1,551969.0,-25.2,-11.45,-36.65],[&quot;Ohio 15th&quot;,&quot;OH-15&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;Stivers&quot;,33.8,66.2,355390.0,141654.0,196679.0,-9.2,556070.0,-32.4,-15.48,-47.88],[&quot;Ohio 16th&quot;,&quot;OH-16&quot;,&quot;Republican&quot;,&quot;Jim&quot;,&quot;Renacci&quot;,34.7,65.3,368837.0,145672.0,207101.0,-9.8,555332.0,-30.6,-16.65,-47.25],[&quot;Oklahoma 1st&quot;,&quot;OK-01&quot;,&quot;Republican&quot;,&quot;Jim&quot;,&quot;Bridenstine&quot;,0.0,100.0,311506.0,101757.0,191343.0,-16.4,558360.0,-100.0,-28.76,-128.76],[&quot;Oklahoma 2nd&quot;,&quot;OK-02&quot;,&quot;Republican&quot;,&quot;Markwayne&quot;,&quot;Mullin&quot;,23.2,70.6,271844.0,62022.0,198155.0,-27.3,567268.0,-47.4,-50.08,-97.48],[&quot;Oklahoma 3rd&quot;,&quot;OK-03&quot;,&quot;Republican&quot;,&quot;Frank&quot;,&quot;Lucas&quot;,21.7,78.3,293417.0,61179.0,216078.0,-29.0,567154.0,-56.6,-52.79,-109.39],[&quot;Oklahoma 4th&quot;,&quot;OK-04&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Cole&quot;,26.1,69.6,295464.0,83648.0,194160.0,-21.0,568351.0,-43.5,-37.4,-80.9],[&quot;Oklahoma 5th&quot;,&quot;OK-05&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;Russell&quot;,36.8,57.1,280761.0,111769.0,149400.0,-8.3,560552.0,-20.3,-13.4,-33.7],[&quot;Oregon 1st&quot;,&quot;OR-01&quot;,&quot;Democratic&quot;,&quot;Suzanne&quot;,&quot;Bonamici&quot;,59.6,37.0,382673.0,219412.0,132160.0,11.3,576034.0,22.6,22.8,45.4],[&quot;Oregon 2nd&quot;,&quot;OR-02&quot;,&quot;Republican&quot;,&quot;Greg&quot;,&quot;Walden&quot;,28.0,71.7,381561.0,139059.0,215711.0,-11.9,589203.0,-43.7,-20.09,-63.79],[&quot;Oregon 3rd&quot;,&quot;OR-03&quot;,&quot;Democratic&quot;,&quot;Earl&quot;,&quot;Blumenauer&quot;,71.8,0.0,399204.0,282346.0,89678.0,24.8,604077.0,71.8,48.26,120.06],[&quot;Oregon 4th&quot;,&quot;OR-04&quot;,&quot;Democratic&quot;,&quot;Peter&quot;,&quot;DeFazio&quot;,55.5,39.7,392006.0,180872.0,180318.0,-1.0,613372.0,15.8,0.14,15.94],[&quot;Oregon 5th&quot;,&quot;OR-05&quot;,&quot;Democratic&quot;,&quot;Kurt&quot;,&quot;Schrader&quot;,53.5,43.0,373298.0,180417.0,164536.0,1.2,581935.0,10.5,4.25,14.75],[&quot;Pennsylvania 1st&quot;,&quot;PA-01&quot;,&quot;Democratic&quot;,&quot;Bob&quot;,&quot;Brady&quot;,82.2,17.8,315605.0,250924.0,57521.0,30.2,535939.0,64.4,61.28,125.68],[&quot;Pennsylvania 2nd&quot;,&quot;PA-02&quot;,&quot;Democratic&quot;,&quot;Dwight&quot;,&quot;Evans&quot;,90.2,9.8,369756.0,334322.0,28067.0,41.1,557094.0,80.4,82.83,163.23],[&quot;Pennsylvania 3rd&quot;,&quot;PA-03&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Kelly&quot;,0.0,100.0,324203.0,113563.0,197960.0,-14.7,549101.0,-100.0,-26.03,-126.03],[&quot;Pennsylvania 4th&quot;,&quot;PA-04&quot;,&quot;Republican&quot;,&quot;Scott&quot;,&quot;Perry&quot;,33.9,66.1,338687.0,125762.0,198571.0,-12.3,544246.0,-32.2,-21.5,-53.7],[&quot;Pennsylvania 5th&quot;,&quot;PA-05&quot;,&quot;Republican&quot;,&quot;Glenn&quot;,&quot;Thompson&quot;,32.8,67.2,314143.0,105138.0,195736.0,-16.2,566600.0,-34.4,-28.84,-63.24],[&quot;Pennsylvania 6th&quot;,&quot;PA-06&quot;,&quot;Republican&quot;,&quot;Ryan&quot;,&quot;Costello&quot;,42.7,57.3,368554.0,177639.0,175340.0,-0.8,539084.0,-14.6,0.62,-13.98],[&quot;Pennsylvania 7th&quot;,&quot;PA-07&quot;,&quot;Republican&quot;,&quot;Pat&quot;,&quot;Meehan&quot;,40.5,59.5,386339.0,190599.0,181455.0,0.1,541045.0,-19.0,2.37,-16.63],[&quot;Pennsylvania 8th&quot;,&quot;PA-08&quot;,&quot;Republican&quot;,&quot;Brian&quot;,&quot;Fitzpatrick&quot;,45.5,54.5,387025.0,185685.0,186607.0,-1.2,542944.0,-9.0,-0.24,-9.24],[&quot;Pennsylvania 9th&quot;,&quot;PA-09&quot;,&quot;Republican&quot;,&quot;Bill&quot;,&quot;Shuster&quot;,36.7,63.3,305937.0,83263.0,213383.0,-23.0,556989.0,-26.6,-42.53,-69.13],[&quot;Pennsylvania 10th&quot;,&quot;PA-10&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Marino&quot;,29.8,70.2,308952.0,93240.0,204114.0,-19.8,553619.0,-40.4,-35.89,-76.29],[&quot;Pennsylvania 11th&quot;,&quot;PA-11&quot;,&quot;Republican&quot;,&quot;Lou&quot;,&quot;Barletta&quot;,36.3,63.7,319035.0,115480.0,191473.0,-13.5,559032.0,-27.4,-23.82,-51.22],[&quot;Pennsylvania 12th&quot;,&quot;PA-12&quot;,&quot;Republican&quot;,&quot;Keith&quot;,&quot;Rothfus&quot;,38.2,61.8,363139.0,137482.0,213003.0,-11.9,558549.0,-23.6,-20.8,-44.4],[&quot;Pennsylvania 13th&quot;,&quot;PA-13&quot;,&quot;Democratic&quot;,&quot;Brendan&quot;,&quot;Boyle&quot;,100.0,0.0,332645.0,217268.0,105558.0,16.2,542293.0,100.0,33.58,133.58],[&quot;Pennsylvania 14th&quot;,&quot;PA-14&quot;,&quot;Democratic&quot;,&quot;Mike&quot;,&quot;Doyle&quot;,74.4,25.6,346773.0,231552.0,107099.0,17.3,576561.0,48.8,35.89,84.69],[&quot;Pennsylvania 15th&quot;,&quot;PA-15&quot;,&quot;Republican&quot;,&quot;Charlie&quot;,&quot;Dent&quot;,38.0,58.4,334869.0,148080.0,173597.0,-5.1,545594.0,-20.4,-7.62,-28.02],[&quot;Pennsylvania 16th&quot;,&quot;PA-16&quot;,&quot;Republican&quot;,&quot;Lloyd&quot;,&quot;Smucker&quot;,42.9,53.8,317019.0,140186.0,161763.0,-4.7,526440.0,-10.9,-6.81,-17.71],[&quot;Pennsylvania 17th&quot;,&quot;PA-17&quot;,&quot;Democratic&quot;,&quot;Matt&quot;,&quot;Cartwright&quot;,53.8,46.2,306641.0,132702.0,163730.0,-6.3,554815.0,7.6,-10.12,-2.52],[&quot;Pennsylvania 18th&quot;,&quot;PA-18&quot;,&quot;Republican&quot;,&quot;Tim&quot;,&quot;Murphy&quot;,0.0,100.0,370498.0,142705.0,215102.0,-11.2,560279.0,-100.0,-19.54,-119.54],[&quot;Rhode Island 1st&quot;,&quot;RI-01&quot;,&quot;Democratic&quot;,&quot;David&quot;,&quot;Cicilline&quot;,64.5,35.1,216116.0,130682.0,75510.0,12.3,412614.0,29.4,25.53,54.93],[&quot;Rhode Island 2nd&quot;,&quot;RI-02&quot;,&quot;Democratic&quot;,&quot;Jim&quot;,&quot;Langevin&quot;,58.1,30.7,238589.0,121843.0,105033.0,2.6,415997.0,27.4,7.05,34.45],[&quot;South Carolina 1st&quot;,&quot;SC-01&quot;,&quot;Republican&quot;,&quot;Mark&quot;,&quot;Sanford&quot;,36.8,58.6,333021.0,134685.0,178052.0,-8.0,501866.0,-21.8,-13.02,-34.82],[&quot;South Carolina 2nd&quot;,&quot;SC-02&quot;,&quot;Republican&quot;,&quot;Joe&quot;,&quot;Wilson&quot;,35.9,60.2,312625.0,120591.0,175985.0,-10.5,504664.0,-24.3,-17.72,-42.02],[&quot;South Carolina 3rd&quot;,&quot;SC-03&quot;,&quot;Republican&quot;,&quot;Jeff&quot;,&quot;Duncan&quot;,27.1,72.8,284348.0,82527.0,190540.0,-20.9,510519.0,-45.7,-37.99,-83.69],[&quot;South Carolina 4th&quot;,&quot;SC-04&quot;,&quot;Republican&quot;,&quot;Trey&quot;,&quot;Gowdy&quot;,31.0,67.2,301747.0,103975.0,181634.0,-14.7,501815.0,-36.2,-25.74,-61.94],[&quot;South Carolina 5th&quot;,&quot;SC-05&quot;,&quot;Republican&quot;,&quot;Mick&quot;,&quot;Mulvaney&quot;,38.7,59.2,306200.0,118791.0,175391.0,-10.7,498138.0,-20.5,-18.48,-38.98],[&quot;South Carolina 6th&quot;,&quot;SC-06&quot;,&quot;Democratic&quot;,&quot;James&quot;,&quot;Clyburn&quot;,70.1,27.6,266848.0,178159.0,80741.0,17.7,514995.0,42.5,36.51,79.01],[&quot;South Carolina 7th&quot;,&quot;SC-07&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Rice&quot;,38.9,61.0,298237.0,116645.0,173046.0,-10.8,512893.0,-22.1,-18.91,-41.01],[&quot;South Dakota At-Large&quot;,&quot;SD-AL&quot;,&quot;Republican&quot;,&quot;Kristi&quot;,&quot;Noem&quot;,35.9,64.1,370047.0,117442.0,227701.0,-17.1,611383.0,-28.2,-29.8,-58.0],[&quot;Tennessee 1st&quot;,&quot;TN-01&quot;,&quot;Republican&quot;,&quot;Phil&quot;,&quot;Roe&quot;,15.4,78.4,265493.0,52240.0,203668.0,-30.7,557064.0,-63.0,-57.04,-120.04],[&quot;Tennessee 2nd&quot;,&quot;TN-02&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Duncan&quot;,24.4,75.6,290193.0,86214.0,188956.0,-19.8,549646.0,-51.2,-35.4,-86.6],[&quot;Tennessee 3rd&quot;,&quot;TN-03&quot;,&quot;Republican&quot;,&quot;Chuck&quot;,&quot;Fleischmann&quot;,28.8,66.4,276457.0,83524.0,180932.0,-19.5,550020.0,-37.6,-35.23,-72.83],[&quot;Tennessee 4th&quot;,&quot;TN-04&quot;,&quot;Republican&quot;,&quot;Scott&quot;,&quot;DesJarlais&quot;,35.0,65.0,276582.0,75831.0,189613.0,-22.5,534051.0,-30.0,-41.14,-71.14],[&quot;Tennessee 5th&quot;,&quot;TN-05&quot;,&quot;Democratic&quot;,&quot;Jim&quot;,&quot;Cooper&quot;,62.6,37.4,276959.0,156608.0,105776.0,8.6,547011.0,25.2,18.35,43.55],[&quot;Tennessee 6th&quot;,&quot;TN-06&quot;,&quot;Republican&quot;,&quot;Diane&quot;,&quot;Black&quot;,21.8,71.1,297967.0,70549.0,216461.0,-26.5,539694.0,-49.3,-48.97,-98.27],[&quot;Tennessee 7th&quot;,&quot;TN-07&quot;,&quot;Republican&quot;,&quot;Marsha&quot;,&quot;Blackburn&quot;,23.5,72.2,291561.0,82313.0,196848.0,-21.6,522321.0,-48.7,-39.28,-87.98],[&quot;Tennessee 8th&quot;,&quot;TN-08&quot;,&quot;Republican&quot;,&quot;David&quot;,&quot;Kustoff&quot;,25.1,68.8,296672.0,91025.0,196702.0,-19.5,533039.0,-43.7,-35.62,-79.32],[&quot;Tennessee 9th&quot;,&quot;TN-09&quot;,&quot;Democratic&quot;,&quot;Steve&quot;,&quot;Cohen&quot;,78.7,18.9,222353.0,172391.0,43970.0,28.6,517258.0,59.8,57.76,117.56],[&quot;Texas 1st&quot;,&quot;TX-01&quot;,&quot;Republican&quot;,&quot;Louie&quot;,&quot;Gohmert&quot;,24.1,73.9,262492.0,66389.0,189604.0,-25.2,523109.0,-49.8,-46.94,-96.74],[&quot;Texas 2nd&quot;,&quot;TX-02&quot;,&quot;Republican&quot;,&quot;Ted&quot;,&quot;Poe&quot;,36.0,60.6,277873.0,119659.0,145530.0,-6.0,535783.0,-24.6,-9.31,-33.91],[&quot;Texas 3rd&quot;,&quot;TX-03&quot;,&quot;Republican&quot;,&quot;Sam&quot;,&quot;Johnson&quot;,34.6,61.2,318536.0,129384.0,174561.0,-8.5,501350.0,-26.6,-14.18,-40.78],[&quot;Texas 4th&quot;,&quot;TX-04&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Ratcliffe&quot;,0.0,88.0,279188.0,60841.0,210587.0,-28.7,526203.0,-88.0,-53.64,-141.64],[&quot;Texas 5th&quot;,&quot;TX-05&quot;,&quot;Republican&quot;,&quot;Jeb&quot;,&quot;Hensarling&quot;,0.0,80.6,232735.0,79759.0,145841.0,-15.8,503906.0,-80.6,-28.39,-108.99],[&quot;Texas 6th&quot;,&quot;TX-06&quot;,&quot;Republican&quot;,&quot;Joe&quot;,&quot;Barton&quot;,39.0,58.3,274848.0,115272.0,148945.0,-7.5,499013.0,-19.3,-12.25,-31.55],[&quot;Texas 7th&quot;,&quot;TX-07&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Culberson&quot;,43.8,56.2,257308.0,124722.0,121204.0,-0.4,519856.0,-12.4,1.37,-11.03],[&quot;Texas 8th&quot;,&quot;TX-08&quot;,&quot;Republican&quot;,&quot;Kevin&quot;,&quot;Brady&quot;,0.0,100.0,295099.0,70532.0,214605.0,-26.4,513910.0,-100.0,-48.82,-148.82],[&quot;Texas 9th&quot;,&quot;TX-09&quot;,&quot;Democratic&quot;,&quot;Al&quot;,&quot;Green&quot;,80.6,19.4,191042.0,151559.0,34447.0,30.4,499324.0,61.2,61.3,122.5],[&quot;Texas 10th&quot;,&quot;TX-10&quot;,&quot;Republican&quot;,&quot;Michael&quot;,&quot;McCaul&quot;,38.4,57.3,315133.0,135984.0,164912.0,-5.9,507359.0,-18.9,-9.18,-28.08],[&quot;Texas 11th&quot;,&quot;TX-11&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Conaway&quot;,0.0,89.5,248860.0,47468.0,193620.0,-31.4,537073.0,-89.5,-58.73,-148.23],[&quot;Texas 12th&quot;,&quot;TX-12&quot;,&quot;Republican&quot;,&quot;Kay&quot;,&quot;Granger&quot;,26.9,69.4,282691.0,92549.0,177939.0,-16.9,514594.0,-42.5,-30.21,-72.71],[&quot;Texas 13th&quot;,&quot;TX-13&quot;,&quot;Republican&quot;,&quot;Mac&quot;,&quot;Thornberry&quot;,0.0,90.0,238846.0,40253.0,190838.0,-33.7,518568.0,-90.0,-63.05,-153.05],[&quot;Texas 14th&quot;,&quot;TX-14&quot;,&quot;Republican&quot;,&quot;Randy&quot;,&quot;Weber&quot;,38.1,61.9,263381.0,101228.0,153191.0,-11.3,524374.0,-23.8,-19.73,-43.53],[&quot;Texas 15th&quot;,&quot;TX-15&quot;,&quot;Democratic&quot;,&quot;Vicente&quot;,&quot;Gonz\u00e1lez&quot;,57.3,37.7,184358.0,104454.0,73689.0,7.5,466070.0,19.6,16.69,36.29],[&quot;Texas 16th&quot;,&quot;TX-16&quot;,&quot;Democratic&quot;,&quot;Beto&quot;,&quot;O'Rourke&quot;,85.7,0.0,192692.0,130784.0,52334.0,20.3,489548.0,85.7,40.71,126.41],[&quot;Texas 17th&quot;,&quot;TX-17&quot;,&quot;Republican&quot;,&quot;Bill&quot;,&quot;Flores&quot;,35.2,60.8,247625.0,96156.0,139415.0,-10.3,534916.0,-25.6,-17.47,-43.07],[&quot;Texas 18th&quot;,&quot;TX-18&quot;,&quot;Democratic&quot;,&quot;Shelia&quot;,&quot;Jackson Lee&quot;,73.5,23.6,205514.0,157117.0,41011.0,28.2,492316.0,49.9,56.5,106.4],[&quot;Texas 19th&quot;,&quot;TX-19&quot;,&quot;Republican&quot;,&quot;Jodey&quot;,&quot;Arrington&quot;,0.0,86.7,228008.0,53519.0,165384.0,-26.7,524057.0,-86.7,-49.06,-135.76],[&quot;Texas 20th&quot;,&quot;TX-20&quot;,&quot;Democratic&quot;,&quot;Joaquin&quot;,&quot;Castro&quot;,79.7,0.0,216952.0,132363.0,74386.0,12.9,503169.0,79.7,26.72,106.42],[&quot;Texas 21st&quot;,&quot;TX-21&quot;,&quot;Republican&quot;,&quot;Lamar&quot;,&quot;Smith&quot;,36.4,57.0,358985.0,152528.0,188335.0,-6.4,539982.0,-20.6,-9.97,-30.57],[&quot;Texas 22nd&quot;,&quot;TX-22&quot;,&quot;Republican&quot;,&quot;Pete&quot;,&quot;Olson&quot;,40.5,59.5,306777.0,135525.0,159717.0,-5.2,494113.0,-19.0,-7.89,-26.89],[&quot;Texas 23rd&quot;,&quot;TX-23&quot;,&quot;Republican&quot;,&quot;Will&quot;,&quot;Hurd&quot;,47.0,48.3,231365.0,115154.0,107276.0,0.7,495646.0,-1.3,3.41,2.11],[&quot;Texas 24th&quot;,&quot;TX-24&quot;,&quot;Republican&quot;,&quot;Kenny&quot;,&quot;Marchant&quot;,39.3,56.2,276137.0,122872.0,140128.0,-4.4,523431.0,-16.9,-6.25,-23.15],[&quot;Texas 25th&quot;,&quot;TX-25&quot;,&quot;Republican&quot;,&quot;Roger&quot;,&quot;Williams&quot;,37.7,58.3,313111.0,125949.0,172476.0,-8.9,536383.0,-20.6,-14.86,-35.46],[&quot;Texas 26th&quot;,&quot;TX-26&quot;,&quot;Republican&quot;,&quot;Michael&quot;,&quot;Burgess&quot;,29.6,66.4,318854.0,109536.0,194033.0,-15.0,496578.0,-36.8,-26.5,-63.3],[&quot;Texas 27th&quot;,&quot;TX-27&quot;,&quot;Republican&quot;,&quot;Blake&quot;,&quot;Farenthold&quot;,38.3,61.7,234367.0,85589.0,140787.0,-13.3,520958.0,-23.4,-23.55,-46.95],[&quot;Texas 28th&quot;,&quot;TX-28&quot;,&quot;Democratic&quot;,&quot;Henry&quot;,&quot;Cuellar&quot;,66.2,31.3,188600.0,110023.0,72518.0,9.2,477030.0,34.9,19.89,54.79],[&quot;Texas 29th&quot;,&quot;TX-29&quot;,&quot;Democratic&quot;,&quot;Gene&quot;,&quot;Green&quot;,72.5,24.0,133642.0,95027.0,34011.0,22.5,470400.0,48.5,45.66,94.16],[&quot;Texas 30th&quot;,&quot;TX-30&quot;,&quot;Democratic&quot;,&quot;Eddie Bernice&quot;,&quot;Johnson&quot;,81.6,15.1,220711.0,174528.0,40333.0,30.1,501433.0,66.5,60.8,127.3],[&quot;Texas 31st&quot;,&quot;TX-31&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Carter&quot;,36.5,58.4,287510.0,117181.0,153823.0,-7.9,500711.0,-21.9,-12.74,-34.64],[&quot;Texas 32nd&quot;,&quot;TX-32&quot;,&quot;Republican&quot;,&quot;Pete&quot;,&quot;Sessions&quot;,0.0,71.1,278080.0,134895.0,129701.0,-0.1,527032.0,-71.1,1.87,-69.23],[&quot;Texas 33rd&quot;,&quot;TX-33&quot;,&quot;Democratic&quot;,&quot;Marc&quot;,&quot;Veasey&quot;,73.7,26.3,129653.0,94513.0,30787.0,24.3,475960.0,47.4,49.15,96.55],[&quot;Texas 34th&quot;,&quot;TX-34&quot;,&quot;Democratic&quot;,&quot;Filemon&quot;,&quot;Vela&quot;,62.7,37.3,171969.0,101796.0,64767.0,10.0,476984.0,25.4,21.53,46.93],[&quot;Texas 35th&quot;,&quot;TX-35&quot;,&quot;Democratic&quot;,&quot;Lloyd&quot;,&quot;Doggett&quot;,63.1,31.6,200576.0,128535.0,61136.0,16.7,490339.0,31.5,33.6,65.1],[&quot;Texas 36th&quot;,&quot;TX-36&quot;,&quot;Republican&quot;,&quot;Brian&quot;,&quot;Babin&quot;,0.0,88.6,254447.0,64225.0,183176.0,-25.2,518256.0,-88.6,-46.75,-135.35],[&quot;Utah 1st&quot;,&quot;UT-01&quot;,&quot;Republican&quot;,&quot;Rob&quot;,&quot;Bishop&quot;,26.4,65.9,280442.0,62733.0,139503.0,-20.1,467487.0,-39.5,-27.37,-66.87],[&quot;Utah 2nd&quot;,&quot;UT-02&quot;,&quot;Republican&quot;,&quot;Chris&quot;,&quot;Stewart&quot;,33.9,61.6,283699.0,90686.0,130525.0,-10.1,484976.0,-27.7,-14.04,-41.74],[&quot;Utah 3rd&quot;,&quot;UT-03&quot;,&quot;Republican&quot;,&quot;Jason&quot;,&quot;Chaffetz&quot;,26.5,73.5,289923.0,67461.0,136782.0,-18.1,474644.0,-47.0,-23.91,-70.91],[&quot;Utah 4th&quot;,&quot;UT-04&quot;,&quot;Republican&quot;,&quot;Mia&quot;,&quot;Love&quot;,41.3,53.8,277311.0,89796.0,108421.0,-5.8,465748.0,-12.5,-6.72,-19.22],[&quot;Vermont At-Large&quot;,&quot;VT-AL&quot;,&quot;Democratic&quot;,&quot;Peter&quot;,&quot;Welch&quot;,89.5,0.0,315067.0,178573.0,95369.0,14.1,496508.0,89.5,26.41,115.91],[&quot;Virginia 1st&quot;,&quot;VA-01&quot;,&quot;Republican&quot;,&quot;Rob&quot;,&quot;Wittman&quot;,36.6,59.9,395289.0,162931.0,211991.0,-7.7,543207.0,-23.3,-12.41,-35.71],[&quot;Virginia 2nd&quot;,&quot;VA-02&quot;,&quot;Republican&quot;,&quot;Scott&quot;,&quot;Taylor&quot;,38.5,61.3,321068.0,145762.0,156694.0,-2.9,561599.0,-22.8,-3.4,-26.2],[&quot;Virginia 3rd&quot;,&quot;VA-03&quot;,&quot;Democratic&quot;,&quot;Bobby&quot;,&quot;Scott&quot;,66.7,33.1,323422.0,205746.0,103064.0,15.5,551449.0,33.6,31.75,65.35],[&quot;Virginia 4th&quot;,&quot;VA-04&quot;,&quot;Democratic&quot;,&quot;Donald&quot;,&quot;McEachin&quot;,57.7,42.0,362532.0,212677.0,134676.0,10.1,563650.0,15.7,21.52,37.22],[&quot;Virginia 5th&quot;,&quot;VA-05&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Garrett&quot;,41.6,58.2,365403.0,154665.0,195190.0,-6.9,574403.0,-16.6,-11.09,-27.69],[&quot;Virginia 6th&quot;,&quot;VA-06&quot;,&quot;Republican&quot;,&quot;Bob&quot;,&quot;Goodlatte&quot;,33.1,66.6,345500.0,120596.0,206303.0,-14.2,572758.0,-33.5,-24.81,-58.31],[&quot;Virginia 7th&quot;,&quot;VA-07&quot;,&quot;Republican&quot;,&quot;Dave&quot;,&quot;Brat&quot;,42.2,57.5,392168.0,172544.0,198032.0,-4.6,544939.0,-15.3,-6.5,-21.8],[&quot;Virginia 8th&quot;,&quot;VA-08&quot;,&quot;Democratic&quot;,&quot;Don&quot;,&quot;Beyer&quot;,68.4,27.3,367885.0,270415.0,76854.0,26.8,578936.0,41.1,52.61,93.71],[&quot;Virginia 9th&quot;,&quot;VA-09&quot;,&quot;Republican&quot;,&quot;Morgan&quot;,&quot;Griffith&quot;,28.3,68.6,316740.0,86463.0,217837.0,-22.7,584866.0,-40.3,-41.48,-81.78],[&quot;Virginia 10th&quot;,&quot;VA-10&quot;,&quot;Republican&quot;,&quot;Barbara&quot;,&quot;Comstock&quot;,46.9,52.7,403821.0,210692.0,170580.0,4.1,522584.0,-5.8,9.93,4.13],[&quot;Virginia 11th&quot;,&quot;VA-11&quot;,&quot;Democratic&quot;,&quot;Gerry&quot;,&quot;Connolly&quot;,87.9,0.0,357054.0,238982.0,98222.0,19.8,548956.0,87.9,39.42,127.32],[&quot;Washington 1st&quot;,&quot;WA-01&quot;,&quot;Democratic&quot;,&quot;Suzan&quot;,&quot;DelBene&quot;,55.4,44.6,349064.0,188952.0,132109.0,7.7,507779.0,10.8,16.28,27.08],[&quot;Washington 2nd&quot;,&quot;WA-02&quot;,&quot;Democratic&quot;,&quot;Rick&quot;,&quot;Larsen&quot;,64.0,36.0,326462.0,185821.0,113670.0,10.9,521526.0,28.0,22.1,50.1],[&quot;Washington 3rd&quot;,&quot;WA-03&quot;,&quot;Republican&quot;,&quot;Jaime&quot;,&quot;Herrera Beutler&quot;,38.2,61.8,315150.0,134009.0,157359.0,-5.1,503246.0,-23.6,-7.41,-31.01],[&quot;Washington 4th&quot;,&quot;WA-04&quot;,&quot;Republican&quot;,&quot;Dan&quot;,&quot;Newhouse&quot;,0.0,100.0,242668.0,85083.0,140560.0,-13.4,474350.0,-100.0,-22.86,-122.86],[&quot;Washington 5th&quot;,&quot;WA-05&quot;,&quot;Republican&quot;,&quot;Cathy&quot;,&quot;McMorris Rodgers&quot;,40.4,59.6,319635.0,125112.0,166765.0,-8.2,521176.0,-19.2,-13.03,-32.23],[&quot;Washington 6th&quot;,&quot;WA-06&quot;,&quot;Democratic&quot;,&quot;Derek&quot;,&quot;Kilmer&quot;,61.5,38.5,332992.0,172596.0,131449.0,5.7,529928.0,23.0,12.36,35.36],[&quot;Washington 7th&quot;,&quot;WA-07&quot;,&quot;Democratic&quot;,&quot;Pramila&quot;,&quot;Jayapal&quot;,100.0,0.0,415693.0,341412.0,50615.0,36.0,565602.0,100.0,69.95,169.95],[&quot;Washington 8th&quot;,&quot;WA-08&quot;,&quot;Republican&quot;,&quot;Dave&quot;,&quot;Reichert&quot;,39.8,60.2,321002.0,153167.0,143403.0,0.5,498830.0,-20.4,3.04,-17.36],[&quot;Washington 9th&quot;,&quot;WA-09&quot;,&quot;Democratic&quot;,&quot;Adam&quot;,&quot;Smith&quot;,72.9,27.1,291192.0,205193.0,67956.0,24.0,517163.0,45.8,47.13,92.93],[&quot;Washington 10th&quot;,&quot;WA-10&quot;,&quot;Democratic&quot;,&quot;Denny&quot;,&quot;Heck&quot;,58.7,41.3,295356.0,151373.0,117861.0,5.1,503586.0,17.4,11.35,28.75],[&quot;West Virginia 1st&quot;,&quot;WV-01&quot;,&quot;Republican&quot;,&quot;David&quot;,&quot;McKinley&quot;,31.0,69.0,243894.0,64384.0,165934.0,-23.2,494743.0,-38.0,-41.64,-79.64],[&quot;West Virginia 2nd&quot;,&quot;WV-02&quot;,&quot;Republican&quot;,&quot;Alex&quot;,&quot;Mooney&quot;,41.8,58.2,250267.0,73487.0,164674.0,-20.3,484668.0,-16.4,-36.44,-52.84],[&quot;West Virginia 3rd&quot;,&quot;WV-03&quot;,&quot;Republican&quot;,&quot;Evan&quot;,&quot;Jenkins&quot;,24.0,67.9,218890.0,50923.0,158763.0,-26.8,486165.0,-43.9,-49.27,-93.17],[&quot;Wisconsin 1st&quot;,&quot;WI-01&quot;,&quot;Republican&quot;,&quot;Paul&quot;,&quot;Ryan&quot;,30.2,64.9,355961.0,150436.0,187372.0,-6.6,534871.0,-34.7,-10.38,-45.08],[&quot;Wisconsin 2nd&quot;,&quot;WI-02&quot;,&quot;Democratic&quot;,&quot;Mark&quot;,&quot;Pocan&quot;,68.7,31.2,412803.0,271507.0,119608.0,18.3,549282.0,37.5,36.8,74.3],[&quot;Wisconsin 3rd&quot;,&quot;WI-03&quot;,&quot;Democratic&quot;,&quot;Ron&quot;,&quot;Kind&quot;,98.9,0.0,359555.0,160999.0,177172.0,-3.5,553645.0,98.9,-4.5,94.4],[&quot;Wisconsin 4th&quot;,&quot;WI-04&quot;,&quot;Democratic&quot;,&quot;Gwen&quot;,&quot;Moore&quot;,76.7,0.0,308575.0,228226.0,67287.0,26.1,524444.0,76.7,52.16,128.86],[&quot;Wisconsin 5th&quot;,&quot;WI-05&quot;,&quot;Republican&quot;,&quot;Jim&quot;,&quot;Sensenbrenner&quot;,29.3,66.7,399261.0,148900.0,229325.0,-11.7,548075.0,-37.4,-20.14,-57.54],[&quot;Wisconsin 6th&quot;,&quot;WI-06&quot;,&quot;Republican&quot;,&quot;Glenn&quot;,&quot;Grothman&quot;,37.3,57.2,365442.0,141917.0,203433.0,-10.0,550929.0,-19.9,-16.83,-36.73],[&quot;Wisconsin 7th&quot;,&quot;WI-07&quot;,&quot;Republican&quot;,&quot;Sean&quot;,&quot;Duffy&quot;,38.3,61.7,369841.0,137874.0,213467.0,-11.9,547463.0,-23.4,-20.44,-43.84],[&quot;Wisconsin 8th&quot;,&quot;WI-08&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Gallagher&quot;,37.3,62.6,369562.0,142677.0,207620.0,-10.4,538785.0,-25.3,-17.57,-42.87],[&quot;Wyoming At-Large&quot;,&quot;WY-AL&quot;,&quot;Republican&quot;,&quot;Liz&quot;,&quot;Cheney&quot;,30.0,62.0,255849.0,55973.0,174419.0,-26.8,428224.0,-32.0,-46.3,-78.3]];
    
    var xName = &quot;demlead_pres2016&quot;;
    var yName = &quot;demlead_house2016&quot;;
    var xLabel = &quot;Democratic Lead, President 2016 (%)&quot;;
    var yLabel = &quot;Democratic Lead, House 2016 (%)&quot;;
    
    var min_x = d3.min(data, function(d) { return +d[keys[xName]]; });
    var max_x = d3.max(data, function(d) { return +d[keys[xName]]; });
    var min_y = d3.min(data, function(d) { return +d[keys[yName]]; });
    var max_y = d3.max(data, function(d) { return +d[keys[yName]]; });
    var max = d3.max([min_x, min_y, max_x, max_y].map(Math.abs));

    var x = d3.scale.linear()
            .domain([-1.2*max, 1.2*max])
            .range([ 0, width ]);

    var y = d3.scale.linear()
            //.domain([min_y - Math.abs(0.2*min_y), max_y + Math.abs(0.2*max_y)])
            .domain([-1.2*max, 1.2*max])
            .range([ height, 0 ]);

    var xAxis = d3.svg.axis()
        .scale(x)
        .orient(&quot;bottom&quot;)
        .ticks(6)  //5
        .tickSize(-height);

    var yAxis = d3.svg.axis()
        .scale(y)
        .orient(&quot;left&quot;)
        .ticks(6)  //5
        .tickSize(-width);  //-width

    var zoom = d3.behavior.zoom()
        .x(x)
        .y(y)
        .scaleExtent([1, 10])
        .center([width / 2, height / 2])
        .size([width, height])
        .on(&quot;zoom&quot;, zoomed);

    var svg = d3.select(&quot;body&quot;).append(&quot;svg&quot;)
        .attr(&quot;width&quot;, width + margin.left + margin.right)
        .attr(&quot;height&quot;, height + margin.top + margin.bottom)
      .append(&quot;g&quot;)
        .attr(&quot;transform&quot;, &quot;translate(&quot; + margin.left + &quot;,&quot; + margin.top + &quot;)&quot;)
        .call(zoom);

    //http://stackoverflow.com/questions/28723551
    //Create clip, then apply it to each dot
    var clip = svg.append(&quot;defs&quot;).append(&quot;svg:clipPath&quot;)
        .attr(&quot;id&quot;, &quot;clip&quot;)
        .append(&quot;svg:rect&quot;)
        .attr(&quot;id&quot;, &quot;clip-rect&quot;)
        .attr(&quot;x&quot;, &quot;0&quot;)  //
        .attr(&quot;y&quot;, &quot;0&quot;)  //
        .attr('width', width)
        .attr('height', height);

    svg.append(&quot;rect&quot;)
        .attr(&quot;width&quot;, width)
        .attr(&quot;height&quot;, height);

    svg.append(&quot;g&quot;)
        .attr(&quot;class&quot;, &quot;x axis&quot;)
        .attr(&quot;transform&quot;, &quot;translate(0,&quot; + height + &quot;)&quot;)
        .call(xAxis);

    svg.append(&quot;g&quot;)
        .attr(&quot;class&quot;, &quot;y axis&quot;)
        .call(yAxis);

    d3.selectAll('g.tick')
      .filter(function(d){ return d==0;} )
      .select('line') 
      .attr('id', 'main-tick');

    // Tooltips
    var div = d3.select(&quot;body&quot;)
        .append(&quot;div&quot;)  
        .attr(&quot;class&quot;, &quot;tooltip&quot;)
        .style(&quot;opacity&quot;, 0); 

    svg.selectAll(&quot;.dot&quot;)
      .data(data)
    .enter().append(&quot;circle&quot;)
      .attr(&quot;class&quot;, &quot;dot&quot;)
      .attr(&quot;clip-path&quot;, &quot;url(#clip)&quot;)  //add the clip to each dot
      .attr(&quot;r&quot;, 4.0) //3.5  4.5 3*zoom.scale()
      .attr(&quot;cx&quot;, function(d) { return x(+d[keys[xName]]); })
      .attr(&quot;cy&quot;, function(d) { return y(+d[keys[yName]]); })
      .style(&quot;fill&quot;, 'red' ) 
      .attr('fill-opacity', 0.6)
      .on(&quot;mouseover&quot;, function(d) { drawTooltip(d); })
      .on(&quot;mouseout&quot;, function() {
        div.style(&quot;opacity&quot;, 0);
      });

    svg.append(&quot;text&quot;)
        .attr(&quot;class&quot;, &quot;x label&quot;)
        .attr(&quot;text-anchor&quot;, &quot;middle&quot;)
        .attr(&quot;x&quot;, width/2)
        .attr(&quot;y&quot;, height + 30)
        .text(&quot;Democratic Lead, President 2016 (%)&quot;);

    svg.append(&quot;text&quot;)
        .attr(&quot;class&quot;, &quot;y label&quot;)
        .attr(&quot;text-anchor&quot;, &quot;middle&quot;)
        .attr(&quot;x&quot;, -height/2)
        .attr(&quot;y&quot;, -30) //-30
        .attr(&quot;transform&quot;, &quot;rotate(-90)&quot;)
        .text(&quot;Democratic Lead, House 2016 (%)&quot;);

    d3.selectAll(&quot;button[data-zoom]&quot;)
        .on(&quot;click&quot;, clicked);

    function zoomed() {
      svg.select(&quot;.x.axis&quot;).call(xAxis);
      svg.select(&quot;.y.axis&quot;).call(yAxis);

      //http://stackoverflow.com/questions/37573228
      svg.selectAll(&quot;.dot&quot;)
        //.attr(&quot;r&quot;, 3*zoom.scale())
        .attr(&quot;cx&quot;, function (d) {
            return x(+d[keys[xName]]);
        })
        .attr(&quot;cy&quot;, function (d) {
            return y(+d[keys[yName]]);
        });

        d3.selectAll('g.tick')
          .filter(function(d){ return d==0;} )
          .select('line') //grab the tick line
          .attr('id', 'main-tick');
    }

    function clicked() {
      svg.call(zoom.event); // https://github.com/mbostock/d3/issues/2387

      // Record the coordinates (in data space) of the center (in screen space).
      var center0 = zoom.center(), translate0 = zoom.translate(), coordinates0 = coordinates(center0);
      zoom.scale(zoom.scale() * Math.pow(2, +this.getAttribute(&quot;data-zoom&quot;)));

      // Translate back to the center.
      var center1 = point(coordinates0);
      zoom.translate([translate0[0] + center0[0] - center1[0], translate0[1] + center0[1] - center1[1]]);

      svg.transition().duration(750).call(zoom.event);

    }

    function coordinates(point) {
      var scale = zoom.scale(), translate = zoom.translate();
      return [(point[0] - translate[0]) / scale, (point[1] - translate[1]) / scale];
    }

    function point(coordinates) {
      var scale = zoom.scale(), translate = zoom.translate();
      return [coordinates[0] * scale + translate[0], coordinates[1] * scale + translate[1]];
    }

    function drawTooltip(d) {
        div.style(&quot;opacity&quot;, 1.0);
        div.html(
    '<b>District:</b> '+ d[keys.code] + 
    '<br><b>Name:</b> ' + d[keys.first] + ' ' + d[keys.last] + 
    '<br><b>President:</b> ' + d[keys.demlead_pres2016] + &quot;%&quot; + 
    '<br><b>House:</b> ' + d[keys.demlead_house2016] +&quot;%&quot; 
)
            .style(&quot;left&quot;, (d3.event.pageX) + &quot;px&quot;)
            .style(&quot;top&quot;, (d3.event.pageY ) + &quot;px&quot;);
    }

    </script>
    </body>
    </html>
    " style="width: 960px; height: 600px; display:block; width: 100%; margin: 15px auto; border: none"></iframe>



## Close House Seats for Democrats

The first two numeric columns below show the Democrat's lead in the House race and Presidential race for each district.  When the sum column of these two values is negative it indicates a district that had a larger margin for Trump than for the Democrat that was elected.  

Interestingly, Minnesota had a number of close seats, including the 7th district with a 35 point spread between Collin Peterson and Trump.  Someone needs to ask these guys in Minnesota how they appealed to Trump voters ([Peterson](https://en.wikipedia.org/wiki/Collin_Peterson) is a Blue Dog Democrat, and both [Nolan](https://en.wikipedia.org/wiki/Rick_Nolan) and [Walz](https://en.wikipedia.org/wiki/Rick_Nolan) are moderate Democrats).  I think Walz provides an especially good template for moderate Democrats to follow in contentious districts.   

I also include the [Partisan Voter Index](https://en.wikipedia.org/wiki/Cook_Partisan_Voting_Index) (pvi_2016), which combines the past two elections into an index of how the district votes relative to the country.  Currently, the table is sorted by the 'sum' column, but Bokeh outputs interactive tables so feel free to sort the columns by any of the indicators. 


<iframe srcdoc="
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset=&quot;utf-8&quot;>
    <style>

    /*
    body {
        width: 800px;
    }*/

    table {
        font-size: 12px;
        border-collapse: collapse;
        border-top: 1px solid #ddd;
        border-right: 1px solid #ddd;
    }

    th {
        padding: 10px;
        cursor: pointer;
        background-color: #f2f2f2;
    }

    th, td {
        text-align: left;
        border-bottom: 1px solid #ddd;
        border-left: 1px solid #ddd;
    }

    td {
        padding: 5px 8px;
    }

    tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    tr:hover {
      background-color: #F0F8FF; /*#f9f9f9;*/
    }

    </style>
    </head>

    <body>

    <div id =&quot;tableInsert&quot;></div>

    <script>
    //http://stackoverflow.com/questions/14267781/sorting-html-table-with-javascript

    function sortTable(table, col, reverse) {
        var tb = table.tBodies[0], 
            tr = Array.prototype.slice.call(tb.rows, 0), // put rows into array
            i;

        reverse = -((+reverse) || -1);
        tr = tr.sort(function (a, b) { 
            var first = a.cells[col].textContent.trim();
            var second = b.cells[col].textContent.trim();

            if (isNumeric(first) && isNumeric(second)) {        
                return reverse * (Number(first) - Number(second));
            } else {
                return reverse * first.localeCompare(second);
            };
        });
        for(i = 0; i < tr.length; ++i) {  // append each row in order
            tb.appendChild(tr[i]);
        }
    }

    //http://stackoverflow.com/questions/18082
    function isNumeric(n) {
      return !isNaN(parseFloat(n)) && isFinite(n);
    }

    function makeSortable(table) {
        var th = table.tHead, i;
        th && (th = th.rows[0]) && (th = th.cells);
        if (th) i = th.length;
        else return; // if no `<thead>` then do nothing
        while (--i >= 0) (function (i) {
            var dir = 1;
            th[i].addEventListener('click', function () {sortTable(table, i, (dir = 1 - dir))});
        }(i));
    }

    function makeAllSortable(parent) {
        parent = parent || document.body;
        var t = parent.getElementsByTagName('table'), i = t.length;
        while (--i >= 0) makeSortable(t[i]);
    }

    function addTable() {
        var tableDiv = document.getElementById(&quot;tableInsert&quot;)
        var table = document.createElement('table')
        var tableHead = document.createElement('thead')
        var tableBody = document.createElement('tbody')

        table.appendChild(tableHead)
        table.appendChild(tableBody);

        var heading = [&quot;district&quot;, &quot;party&quot;, &quot;first&quot;, &quot;last&quot;, &quot;demlead_house2016&quot;, &quot;demlead_pres2016&quot;, &quot;sum&quot;, &quot;pvi_2016&quot;];
        var data = [[&quot;Minnesota 7th&quot;,&quot;Democratic&quot;,&quot;Collin&quot;,&quot;Peterson&quot;,5.1,-30.76,-25.66,-17.7],[&quot;Minnesota 8th&quot;,&quot;Democratic&quot;,&quot;Rick&quot;,&quot;Nolan&quot;,0.6,-15.62,-15.02,-9.5],[&quot;Minnesota 1st&quot;,&quot;Democratic&quot;,&quot;Tim&quot;,&quot;Walz&quot;,0.7,-14.91,-14.21,-9.2],[&quot;Pennsylvania 17th&quot;,&quot;Democratic&quot;,&quot;Matt&quot;,&quot;Cartwright&quot;,7.6,-10.12,-2.52,-6.3],[&quot;New Hampshire 1st&quot;,&quot;Democratic&quot;,&quot;Carol&quot;,&quot;Shea-Porter&quot;,1.4,-1.59,-0.19,-2.0],[&quot;Nevada 3rd&quot;,&quot;Democratic&quot;,&quot;Jacky&quot;,&quot;Rosen&quot;,1.2,-1.0,0.2,-1.6],[&quot;New Jersey 5th&quot;,&quot;Democratic&quot;,&quot;Josh&quot;,&quot;Gottheimer&quot;,4.4,-1.12,3.28,-1.7],[&quot;Iowa 2nd&quot;,&quot;Democratic&quot;,&quot;Dave&quot;,&quot;Loebsack&quot;,7.5,-4.1,3.4,-3.3],[&quot;Arizona 1st&quot;,&quot;Democratic&quot;,&quot;Tom&quot;,&quot;O'Halleran&quot;,7.3,-1.07,6.23,-1.7],[&quot;New Hampshire 2nd&quot;,&quot;Democratic&quot;,&quot;Annie&quot;,&quot;Kuster&quot;,4.4,2.4,6.8,0.2],[&quot;Florida 13th&quot;,&quot;Democratic&quot;,&quot;Charlie&quot;,&quot;Crist&quot;,3.8,3.2,7.0,0.6],[&quot;Nevada 4th&quot;,&quot;Democratic&quot;,&quot;Ruben&quot;,&quot;Kihuen&quot;,4.0,4.94,8.94,1.5],[&quot;New York 18th&quot;,&quot;Democratic&quot;,&quot;Sean Patrick&quot;,&quot;Maloney&quot;,11.2,-1.92,9.28,-2.1],[&quot;Florida 7th&quot;,&quot;Democratic&quot;,&quot;Stephanie&quot;,&quot;Murphy&quot;,3.0,7.29,10.29,2.7],[&quot;New York 3rd&quot;,&quot;Democratic&quot;,&quot;Tom&quot;,&quot;Suozzi&quot;,5.6,6.18,11.78,2.1],[&quot;California 7th&quot;,&quot;Democratic&quot;,&quot;Ami&quot;,&quot;Bera&quot;,2.4,11.45,13.85,5.0],[&quot;Oregon 5th&quot;,&quot;Democratic&quot;,&quot;Kurt&quot;,&quot;Schrader&quot;,10.5,4.25,14.75,1.2],[&quot;Oregon 4th&quot;,&quot;Democratic&quot;,&quot;Peter&quot;,&quot;DeFazio&quot;,15.8,0.14,15.94,-1.0],[&quot;Illinois 17th&quot;,&quot;Democratic&quot;,&quot;Cheri&quot;,&quot;Bustos&quot;,20.6,-0.7,19.9,-1.5],[&quot;Connecticut 5th&quot;,&quot;Democratic&quot;,&quot;Elizabeth&quot;,&quot;Esty&quot;,16.0,4.1,20.1,1.0],[&quot;Delaware At-Large&quot;,&quot;Democratic&quot;,&quot;Lisa&quot;,&quot;Blunt Rochester&quot;,14.5,11.43,25.93,4.9],[&quot;California 24th&quot;,&quot;Democratic&quot;,&quot;Salud&quot;,&quot;Carbajal&quot;,6.8,20.21,27.01,9.7],[&quot;Washington 1st&quot;,&quot;Democratic&quot;,&quot;Suzan&quot;,&quot;DelBene&quot;,10.8,16.28,27.08,7.7],[&quot;Colorado 7th&quot;,&quot;Democratic&quot;,&quot;Ed&quot;,&quot;Perlmutter&quot;,15.4,12.01,27.41,5.5],[&quot;Florida 9th&quot;,&quot;Democratic&quot;,&quot;Darren&quot;,&quot;Soto&quot;,15.0,12.91,27.91,5.6],[&quot;Michigan 9th&quot;,&quot;Democratic&quot;,&quot;Sandy&quot;,&quot;Levin&quot;,20.5,7.73,28.23,2.9],[&quot;New York 25th&quot;,&quot;Democratic&quot;,&quot;Louise&quot;,&quot;Slaughter&quot;,12.3,16.37,28.67,7.5],[&quot;New York 4th&quot;,&quot;Democratic&quot;,&quot;Kathleen&quot;,&quot;Rice&quot;,19.1,9.61,28.71,3.8],[&quot;Washington 10th&quot;,&quot;Democratic&quot;,&quot;Denny&quot;,&quot;Heck&quot;,17.4,11.35,28.75,5.1],[&quot;Michigan 5th&quot;,&quot;Democratic&quot;,&quot;Dan&quot;,&quot;Kildee&quot;,26.1,4.27,30.37,1.1],[&quot;Maine 1st&quot;,&quot;Democratic&quot;,&quot;Chellie&quot;,&quot;Pingree&quot;,16.1,14.83,30.93,6.8],[&quot;California 3rd&quot;,&quot;Democratic&quot;,&quot;John&quot;,&quot;Garamendi&quot;,18.8,12.6,31.4,5.6],[&quot;Maryland 6th&quot;,&quot;Democratic&quot;,&quot;John&quot;,&quot;Delaney&quot;,15.9,16.1,32.0,7.3],[&quot;Connecticut 2nd&quot;,&quot;Democratic&quot;,&quot;Joe&quot;,&quot;Courtney&quot;,29.5,2.88,32.38,0.4],[&quot;Massachusetts 9th&quot;,&quot;Democratic&quot;,&quot;Bill&quot;,&quot;Keating&quot;,22.1,10.72,32.82,4.6],[&quot;California 36th&quot;,&quot;Democratic&quot;,&quot;Raul&quot;,&quot;Ruiz&quot;,24.2,8.74,32.94,3.5],[&quot;California 31st&quot;,&quot;Democratic&quot;,&quot;Pete&quot;,&quot;Aguilar&quot;,12.2,21.09,33.29,10.1],[&quot;California 9th&quot;,&quot;Democratic&quot;,&quot;Jerry&quot;,&quot;McNerney&quot;,14.8,18.57,33.37,8.7],[&quot;Florida 22nd&quot;,&quot;Democratic&quot;,&quot;Ted&quot;,&quot;Deutch&quot;,17.8,15.74,33.54,6.9],[&quot;Missouri 5th&quot;,&quot;Democratic&quot;,&quot;Emanuel&quot;,&quot;Cleaver&quot;,20.6,13.48,34.08,6.0],[&quot;Georgia 2nd&quot;,&quot;Democratic&quot;,&quot;Sanford&quot;,&quot;Bishop&quot;,22.4,11.73,34.13,4.9],[&quot;Rhode Island 2nd&quot;,&quot;Democratic&quot;,&quot;Jim&quot;,&quot;Langevin&quot;,27.4,7.05,34.45,2.6],[&quot;Illinois 10th&quot;,&quot;Democratic&quot;,&quot;Brad&quot;,&quot;Schneider&quot;,5.2,29.4,34.6,14.4],[&quot;Washington 6th&quot;,&quot;Democratic&quot;,&quot;Derek&quot;,&quot;Kilmer&quot;,23.0,12.36,35.36,5.7],[&quot;California 52nd&quot;,&quot;Democratic&quot;,&quot;Scott&quot;,&quot;Peters&quot;,13.0,22.56,35.56,10.9],[&quot;Texas 15th&quot;,&quot;Democratic&quot;,&quot;Vicente&quot;,&quot;Gonz\u00e1lez&quot;,19.6,16.69,36.29,7.5],[&quot;Virginia 4th&quot;,&quot;Democratic&quot;,&quot;Donald&quot;,&quot;McEachin&quot;,15.7,21.52,37.22,10.1],[&quot;California 16th&quot;,&quot;Democratic&quot;,&quot;Jim&quot;,&quot;Costa&quot;,16.0,21.59,37.59,10.3],[&quot;Arizona 9th&quot;,&quot;Democratic&quot;,&quot;Kyrsten&quot;,&quot;Sinema&quot;,21.9,16.22,38.12,7.6],[&quot;Illinois 8th&quot;,&quot;Democratic&quot;,&quot;Raja&quot;,&quot;Krishnamoorthi&quot;,16.6,21.68,38.28,10.4],[&quot;New Mexico 3rd&quot;,&quot;Democratic&quot;,&quot;Ben Ray&quot;,&quot;Luj\u00e1n&quot;,24.8,15.16,39.96,7.5],[&quot;Colorado 2nd&quot;,&quot;Democratic&quot;,&quot;Jared&quot;,&quot;Polis&quot;,19.7,21.26,40.96,10.5],[&quot;Florida 14th&quot;,&quot;Democratic&quot;,&quot;Kathy&quot;,&quot;Castor&quot;,23.6,18.18,41.78,8.3],[&quot;Ohio 13th&quot;,&quot;Democratic&quot;,&quot;Tim&quot;,&quot;Ryan&quot;,35.4,6.49,41.89,2.3],[&quot;Kentucky 3rd&quot;,&quot;Democratic&quot;,&quot;John&quot;,&quot;Yarmuth&quot;,27.0,14.95,41.95,6.8],[&quot;Florida 23rd&quot;,&quot;Democratic&quot;,&quot;Debbie&quot;,&quot;Wasserman Schultz&quot;,16.2,26.09,42.29,12.2],[&quot;California 26th&quot;,&quot;Democratic&quot;,&quot;Julia&quot;,&quot;Brownley&quot;,20.8,21.84,42.64,10.5],[&quot;Connecticut 4th&quot;,&quot;Democratic&quot;,&quot;Jim&quot;,&quot;Himes&quot;,19.8,23.01,42.81,10.9],[&quot;Tennessee 5th&quot;,&quot;Democratic&quot;,&quot;Jim&quot;,&quot;Cooper&quot;,25.2,18.35,43.55,8.6],[&quot;Illinois 11th&quot;,&quot;Democratic&quot;,&quot;Bill&quot;,&quot;Foster&quot;,20.8,23.43,44.23,11.3],[&quot;New Jersey 6th&quot;,&quot;Democratic&quot;,&quot;Frank&quot;,&quot;Pallone&quot;,28.8,15.6,44.4,6.9],[&quot;Oregon 1st&quot;,&quot;Democratic&quot;,&quot;Suzanne&quot;,&quot;Bonamici&quot;,22.6,22.8,45.4,11.3],[&quot;New Mexico 1st&quot;,&quot;Democratic&quot;,&quot;Michelle&quot;,&quot;Lujan Grisham&quot;,30.2,16.52,46.72,8.4],[&quot;Texas 34th&quot;,&quot;Democratic&quot;,&quot;Filemon&quot;,&quot;Vela&quot;,25.4,21.53,46.93,10.0],[&quot;Florida 21st&quot;,&quot;Democratic&quot;,&quot;Lois&quot;,&quot;Frankel&quot;,27.6,19.55,47.15,8.9],[&quot;Indiana 7th&quot;,&quot;Democratic&quot;,&quot;Andr\u00e9&quot;,&quot;Carson&quot;,24.3,22.85,47.15,10.9],[&quot;New Jersey 1st&quot;,&quot;Democratic&quot;,&quot;Donald&quot;,&quot;Norcross&quot;,23.2,24.46,47.66,11.5],[&quot;New York 20th&quot;,&quot;Democratic&quot;,&quot;Paul&quot;,&quot;Tonko&quot;,35.8,13.48,49.28,6.0],[&quot;Washington 2nd&quot;,&quot;Democratic&quot;,&quot;Rick&quot;,&quot;Larsen&quot;,28.0,22.1,50.1,10.9],[&quot;Connecticut 1st&quot;,&quot;Democratic&quot;,&quot;John&quot;,&quot;Larson&quot;,30.3,23.09,53.39,10.9],[&quot;Connecticut 3rd&quot;,&quot;Democratic&quot;,&quot;Rosa&quot;,&quot;DeLauro&quot;,38.0,15.49,53.49,6.9],[&quot;Maryland 2nd&quot;,&quot;Democratic&quot;,&quot;Dutch&quot;,&quot;Ruppersberger&quot;,29.0,24.52,53.52,11.7],[&quot;Florida 5th&quot;,&quot;Democratic&quot;,&quot;Al&quot;,&quot;Lawson&quot;,28.4,25.41,53.81,12.0],[&quot;Minnesota 4th&quot;,&quot;Democratic&quot;,&quot;Betty&quot;,&quot;McCollum&quot;,23.4,30.97,54.37,15.7],[&quot;Texas 28th&quot;,&quot;Democratic&quot;,&quot;Henry&quot;,&quot;Cuellar&quot;,34.9,19.89,54.79,9.2],[&quot;Rhode Island 1st&quot;,&quot;Democratic&quot;,&quot;David&quot;,&quot;Cicilline&quot;,29.4,25.53,54.93,12.3],[&quot;Florida 10th&quot;,&quot;Democratic&quot;,&quot;Val&quot;,&quot;Demings&quot;,29.8,26.89,56.69,12.8],[&quot;California 41st&quot;,&quot;Democratic&quot;,&quot;Mark&quot;,&quot;Takano&quot;,30.0,27.87,57.87,13.7],[&quot;California 47th&quot;,&quot;Democratic&quot;,&quot;Alan&quot;,&quot;Lowenthal&quot;,27.4,31.58,58.98,15.7],[&quot;Ohio 9th&quot;,&quot;Democratic&quot;,&quot;Marcy&quot;,&quot;Kaptur&quot;,37.4,22.18,59.58,10.5],[&quot;Maryland 8th&quot;,&quot;Democratic&quot;,&quot;Jamie&quot;,&quot;Raskin&quot;,26.4,33.67,60.07,16.5],[&quot;Maryland 3rd&quot;,&quot;Democratic&quot;,&quot;John&quot;,&quot;Sarbanes&quot;,29.3,30.78,60.08,15.1],[&quot;Massachusetts 3rd&quot;,&quot;Democratic&quot;,&quot;Niki&quot;,&quot;Tsongas&quot;,37.5,22.84,60.34,11.1],[&quot;Michigan 12th&quot;,&quot;Democratic&quot;,&quot;Debbie&quot;,&quot;Dingell&quot;,35.0,26.35,61.35,12.7],[&quot;Nevada 1st&quot;,&quot;Democratic&quot;,&quot;Dina&quot;,&quot;Titus&quot;,33.1,29.0,62.1,14.3],[&quot;New Jersey 12th&quot;,&quot;Democratic&quot;,&quot;Bonnie&quot;,&quot;Watson Coleman&quot;,30.9,33.24,64.14,16.1],[&quot;Massachusetts 4th&quot;,&quot;Democratic&quot;,&quot;Joe&quot;,&quot;Kennedy&quot;,40.3,24.17,64.47,11.7],[&quot;Texas 35th&quot;,&quot;Democratic&quot;,&quot;Lloyd&quot;,&quot;Doggett&quot;,31.5,33.6,65.1,16.7],[&quot;Virginia 3rd&quot;,&quot;Democratic&quot;,&quot;Bobby&quot;,&quot;Scott&quot;,33.6,31.75,65.35,15.5],[&quot;Mississippi 2nd&quot;,&quot;Democratic&quot;,&quot;Bennie&quot;,&quot;Thompson&quot;,38.0,28.42,66.42,13.3],[&quot;New York 26th&quot;,&quot;Democratic&quot;,&quot;Brian&quot;,&quot;Higgins&quot;,49.2,19.64,68.84,9.2],[&quot;California 53rd&quot;,&quot;Democratic&quot;,&quot;Susan&quot;,&quot;Davis&quot;,34.0,34.93,68.93,17.4],[&quot;Maryland 5th&quot;,&quot;Democratic&quot;,&quot;Steny&quot;,&quot;Hoyer&quot;,38.0,30.98,68.98,15.0],[&quot;Massachusetts 8th&quot;,&quot;Democratic&quot;,&quot;Stephen&quot;,&quot;Lynch&quot;,44.9,26.05,70.95,12.6],[&quot;California 27th&quot;,&quot;Democratic&quot;,&quot;Judy&quot;,&quot;Chu&quot;,34.8,37.65,72.45,18.8],[&quot;New Jersey 9th&quot;,&quot;Democratic&quot;,&quot;Bill&quot;,&quot;Pascrell&quot;,41.7,31.17,72.87,14.9],[&quot;North Carolina 12th&quot;,&quot;Democratic&quot;,&quot;Alma&quot;,&quot;Adams&quot;,34.0,40.01,74.01,19.6],[&quot;California 33rd&quot;,&quot;Democratic&quot;,&quot;Ted&quot;,&quot;Lieu&quot;,32.8,41.33,74.13,20.8],[&quot;Wisconsin 2nd&quot;,&quot;Democratic&quot;,&quot;Mark&quot;,&quot;Pocan&quot;,37.5,36.8,74.3,18.3],[&quot;Ohio 3rd&quot;,&quot;Democratic&quot;,&quot;Joyce&quot;,&quot;Beatty&quot;,37.2,38.4,75.6,19.0],[&quot;North Carolina 4th&quot;,&quot;Democratic&quot;,&quot;David&quot;,&quot;Price&quot;,36.4,40.03,76.43,19.6],[&quot;North Carolina 1st&quot;,&quot;Democratic&quot;,&quot;G.K.&quot;,&quot;Butterfield&quot;,39.6,37.07,76.67,17.8],[&quot;Illinois 9th&quot;,&quot;Democratic&quot;,&quot;Jan&quot;,&quot;Schakowsky&quot;,33.0,45.24,78.24,22.7],[&quot;New York 6th&quot;,&quot;Democratic&quot;,&quot;Grace&quot;,&quot;Meng&quot;,45.4,33.04,78.44,15.9],[&quot;South Carolina 6th&quot;,&quot;Democratic&quot;,&quot;James&quot;,&quot;Clyburn&quot;,42.5,36.51,79.01,17.7],[&quot;California 38th&quot;,&quot;Democratic&quot;,&quot;Linda&quot;,&quot;S\u00e1nchez&quot;,41.0,39.56,80.56,19.8],[&quot;Hawaii 1st&quot;,&quot;Democratic&quot;,&quot;Colleen&quot;,&quot;Hanabusa&quot;,49.2,32.53,81.73,16.3],[&quot;Pennsylvania 14th&quot;,&quot;Democratic&quot;,&quot;Mike&quot;,&quot;Doyle&quot;,48.8,35.89,84.69,17.3],[&quot;California 35th&quot;,&quot;Democratic&quot;,&quot;Norma&quot;,&quot;Torres&quot;,44.8,40.79,85.59,20.4],[&quot;Colorado 1st&quot;,&quot;Democratic&quot;,&quot;Diana&quot;,&quot;DeGette&quot;,40.2,45.79,85.99,23.7],[&quot;Illinois 5th&quot;,&quot;Democratic&quot;,&quot;Mike&quot;,&quot;Quigley&quot;,40.3,46.58,86.88,23.5],[&quot;California 30th&quot;,&quot;Democratic&quot;,&quot;Brad&quot;,&quot;Sherman&quot;,45.2,43.41,88.61,21.8],[&quot;California 20th&quot;,&quot;Democratic&quot;,&quot;Jimmy&quot;,&quot;Panetta&quot;,41.6,47.13,88.73,24.1],[&quot;Washington 9th&quot;,&quot;Democratic&quot;,&quot;Adam&quot;,&quot;Smith&quot;,45.8,47.13,92.93,24.0],[&quot;California 11th&quot;,&quot;Democratic&quot;,&quot;Mark&quot;,&quot;DeSaulnier&quot;,44.2,48.85,93.05,24.8],[&quot;California 15th&quot;,&quot;Democratic&quot;,&quot;Eric&quot;,&quot;Swalwell&quot;,47.6,45.74,93.34,23.2],[&quot;Virginia 8th&quot;,&quot;Democratic&quot;,&quot;Don&quot;,&quot;Beyer&quot;,41.1,52.61,93.71,26.8],[&quot;Massachusetts 1st&quot;,&quot;Democratic&quot;,&quot;Richie&quot;,&quot;Neal&quot;,73.3,20.65,93.95,9.9],[&quot;Indiana 1st&quot;,&quot;Democratic&quot;,&quot;Pete&quot;,&quot;Visclosky&quot;,81.5,12.56,94.06,5.5],[&quot;Texas 29th&quot;,&quot;Democratic&quot;,&quot;Gene&quot;,&quot;Green&quot;,48.5,45.66,94.16,22.5],[&quot;Hawaii 2nd&quot;,&quot;Democratic&quot;,&quot;Tulsi&quot;,&quot;Gabbard&quot;,62.4,31.85,94.25,16.4],[&quot;Wisconsin 3rd&quot;,&quot;Democratic&quot;,&quot;Ron&quot;,&quot;Kind&quot;,98.9,-4.5,94.4,-3.5],[&quot;California 51st&quot;,&quot;Democratic&quot;,&quot;Juan&quot;,&quot;Vargas&quot;,45.6,49.06,94.66,24.8],[&quot;California 18th&quot;,&quot;Democratic&quot;,&quot;Anna&quot;,&quot;Eshoo&quot;,42.2,53.17,95.37,27.3],[&quot;California 6th&quot;,&quot;Democratic&quot;,&quot;Doris&quot;,&quot;Matsui&quot;,50.8,44.75,95.55,22.8],[&quot;Texas 33rd&quot;,&quot;Democratic&quot;,&quot;Marc&quot;,&quot;Veasey&quot;,47.4,49.15,96.55,24.3],[&quot;California 5th&quot;,&quot;Democratic&quot;,&quot;Mike&quot;,&quot;Thompson&quot;,53.8,44.87,98.67,22.9],[&quot;California 19th&quot;,&quot;Democratic&quot;,&quot;Zoe&quot;,&quot;Lofgren&quot;,47.8,51.41,99.21,26.1],[&quot;California 2nd&quot;,&quot;Democratic&quot;,&quot;Jared&quot;,&quot;Huffman&quot;,53.8,45.69,99.49,23.6],[&quot;Arizona 7th&quot;,&quot;Democratic&quot;,&quot;Ruben&quot;,&quot;Gallego&quot;,50.5,49.1,99.6,24.9],[&quot;Minnesota 5th&quot;,&quot;Democratic&quot;,&quot;Keith&quot;,&quot;Ellison&quot;,46.8,55.24,102.04,28.8],[&quot;Illinois 1st&quot;,&quot;Democratic&quot;,&quot;Bobby&quot;,&quot;Rush&quot;,48.2,53.94,102.14,26.7],[&quot;Georgia 4th&quot;,&quot;Democratic&quot;,&quot;Hank&quot;,&quot;Johnson&quot;,51.4,53.06,104.46,26.1],[&quot;California 28th&quot;,&quot;Democratic&quot;,&quot;Adam&quot;,&quot;Schiff&quot;,56.0,49.8,105.8,25.2],[&quot;Texas 18th&quot;,&quot;Democratic&quot;,&quot;Shelia&quot;,&quot;Jackson Lee&quot;,49.9,56.5,106.4,28.2],[&quot;Texas 20th&quot;,&quot;Democratic&quot;,&quot;Joaquin&quot;,&quot;Castro&quot;,79.7,26.72,106.42,12.9],[&quot;Maryland 7th&quot;,&quot;Democratic&quot;,&quot;Elijah&quot;,&quot;Cummings&quot;,53.1,54.98,108.08,27.5],[&quot;Maryland 4th&quot;,&quot;Democratic&quot;,&quot;Anthony&quot;,&quot;Brown&quot;,52.7,58.52,111.22,29.1],[&quot;New Jersey 8th&quot;,&quot;Democratic&quot;,&quot;Albio&quot;,&quot;Sires&quot;,58.5,54.19,112.69,26.8],[&quot;Missouri 1st&quot;,&quot;Democratic&quot;,&quot;Lacy&quot;,&quot;Clay&quot;,55.5,58.19,113.69,29.3],[&quot;California 43rd&quot;,&quot;Democratic&quot;,&quot;Maxine&quot;,&quot;Waters&quot;,52.2,61.69,113.89,31.3],[&quot;Illinois 3rd&quot;,&quot;Democratic&quot;,&quot;Dan&quot;,&quot;Lipinski&quot;,100.0,15.3,115.3,6.9],[&quot;New York 10th&quot;,&quot;Democratic&quot;,&quot;Jerry&quot;,&quot;Nadler&quot;,56.1,59.53,115.63,29.5],[&quot;Vermont At-Large&quot;,&quot;Democratic&quot;,&quot;Peter&quot;,&quot;Welch&quot;,89.5,26.41,115.91,14.1],[&quot;Massachusetts 6th&quot;,&quot;Democratic&quot;,&quot;Seth&quot;,&quot;Moulton&quot;,98.4,17.86,116.26,8.4],[&quot;Tennessee 9th&quot;,&quot;Democratic&quot;,&quot;Steve&quot;,&quot;Cohen&quot;,59.8,57.76,117.56,28.6],[&quot;Massachusetts 2nd&quot;,&quot;Democratic&quot;,&quot;Jim&quot;,&quot;McGovern&quot;,98.2,19.37,117.57,9.3],[&quot;Arizona 3rd&quot;,&quot;Democratic&quot;,&quot;Ra\u00fal&quot;,&quot;Grijalva&quot;,88.1,29.92,118.02,14.6],[&quot;Illinois 2nd&quot;,&quot;Democratic&quot;,&quot;Robin&quot;,&quot;Kelly&quot;,59.6,58.86,118.46,29.2],[&quot;New York 17th&quot;,&quot;Democratic&quot;,&quot;Nita&quot;,&quot;Lowey&quot;,99.1,20.14,119.24,9.3],[&quot;Oregon 3rd&quot;,&quot;Democratic&quot;,&quot;Earl&quot;,&quot;Blumenauer&quot;,71.8,48.26,120.06,24.8],[&quot;California 14th&quot;,&quot;Democratic&quot;,&quot;Jackie&quot;,&quot;Speier&quot;,61.8,58.7,120.5,29.7],[&quot;Michigan 14th&quot;,&quot;Democratic&quot;,&quot;Brenda&quot;,&quot;Lawrence&quot;,59.8,60.93,120.73,30.2],[&quot;Michigan 13th&quot;,&quot;Democratic&quot;,&quot;John&quot;,&quot;Conyers&quot;,61.4,60.67,122.07,30.2],[&quot;Texas 9th&quot;,&quot;Democratic&quot;,&quot;Al&quot;,&quot;Green&quot;,61.2,61.3,122.5,30.4],[&quot;Florida 20th&quot;,&quot;Democratic&quot;,&quot;Alcee&quot;,&quot;Hastings&quot;,60.6,62.1,122.7,30.5],[&quot;New York 14th&quot;,&quot;Democratic&quot;,&quot;Joe&quot;,&quot;Crowley&quot;,65.7,57.89,123.59,28.6],[&quot;Ohio 11th&quot;,&quot;Democratic&quot;,&quot;Marcia&quot;,&quot;Fudge&quot;,60.6,63.5,124.1,31.4],[&quot;Pennsylvania 1st&quot;,&quot;Democratic&quot;,&quot;Bob&quot;,&quot;Brady&quot;,64.4,61.28,125.68,30.2],[&quot;Texas 16th&quot;,&quot;Democratic&quot;,&quot;Beto&quot;,&quot;O'Rourke&quot;,85.7,40.71,126.41,20.3],[&quot;Texas 30th&quot;,&quot;Democratic&quot;,&quot;Eddie Bernice&quot;,&quot;Johnson&quot;,66.5,60.8,127.3,30.1],[&quot;Virginia 11th&quot;,&quot;Democratic&quot;,&quot;Gerry&quot;,&quot;Connolly&quot;,87.9,39.42,127.32,19.8],[&quot;Wisconsin 4th&quot;,&quot;Democratic&quot;,&quot;Gwen&quot;,&quot;Moore&quot;,76.7,52.16,128.86,26.1],[&quot;Pennsylvania 13th&quot;,&quot;Democratic&quot;,&quot;Brendan&quot;,&quot;Boyle&quot;,100.0,33.58,133.58,16.2],[&quot;New York 12th&quot;,&quot;Democratic&quot;,&quot;Carolyn&quot;,&quot;Maloney&quot;,66.3,69.8,136.1,35.0],[&quot;California 46th&quot;,&quot;Democratic&quot;,&quot;Lou&quot;,&quot;Correa&quot;,100.0,38.37,138.37,19.3],[&quot;California 32nd&quot;,&quot;Democratic&quot;,&quot;Grace&quot;,&quot;Napolitano&quot;,100.0,38.87,138.87,19.5],[&quot;Alabama 7th&quot;,&quot;Democratic&quot;,&quot;Terri&quot;,&quot;Sewell&quot;,98.4,41.15,139.55,19.8],[&quot;California 40th&quot;,&quot;Democratic&quot;,&quot;Lucille&quot;,&quot;Roybal-Allard&quot;,71.4,69.45,140.85,35.4],[&quot;Georgia 5th&quot;,&quot;Democratic&quot;,&quot;John&quot;,&quot;Lewis&quot;,68.8,73.07,141.87,36.6],[&quot;Massachusetts 5th&quot;,&quot;Democratic&quot;,&quot;Katherine&quot;,&quot;Clark&quot;,98.6,43.64,142.24,21.9],[&quot;Georgia 13th&quot;,&quot;Democratic&quot;,&quot;David&quot;,&quot;Scott&quot;,100.0,44.41,144.41,21.6],[&quot;New York 5th&quot;,&quot;Democratic&quot;,&quot;Gregory&quot;,&quot;Meeks&quot;,72.4,73.03,145.43,36.0],[&quot;New Jersey 10th&quot;,&quot;Democratic&quot;,&quot;Donald&quot;,&quot;Payne&quot;,73.8,72.41,146.21,35.8],[&quot;Illinois 7th&quot;,&quot;Democratic&quot;,&quot;Danny&quot;,&quot;Davis&quot;,68.4,78.19,146.59,39.3],[&quot;New York 16th&quot;,&quot;Democratic&quot;,&quot;Eliot&quot;,&quot;Engel&quot;,94.4,52.65,147.05,25.9],[&quot;Louisiana 2nd&quot;,&quot;Democratic&quot;,&quot;Cedric&quot;,&quot;Richmond&quot;,100.0,52.37,152.37,25.9],[&quot;California 17th&quot;,&quot;Democratic&quot;,&quot;Ro&quot;,&quot;Khanna&quot;,100.0,53.43,153.43,27.2],[&quot;New York 7th&quot;,&quot;Democratic&quot;,&quot;Nydia&quot;,&quot;Vel\u00e1zquez&quot;,81.5,76.52,158.02,38.2],[&quot;California 12th&quot;,&quot;Democratic&quot;,&quot;Nancy&quot;,&quot;Pelosi&quot;,80.9,77.5,158.4,39.7],[&quot;California 29th&quot;,&quot;Democratic&quot;,&quot;Tony&quot;,&quot;Cardenas&quot;,100.0,60.94,160.94,31.1],[&quot;New York 9th&quot;,&quot;Democratic&quot;,&quot;Yvette&quot;,&quot;Clarke&quot;,92.3,69.04,161.34,34.2],[&quot;California 13th&quot;,&quot;Democratic&quot;,&quot;Barbara&quot;,&quot;Lee&quot;,81.6,80.55,162.15,41.7],[&quot;Pennsylvania 2nd&quot;,&quot;Democratic&quot;,&quot;Dwight&quot;,&quot;Evans&quot;,80.4,82.83,163.23,41.1],[&quot;New York 8th&quot;,&quot;Democratic&quot;,&quot;Hakeem&quot;,&quot;Jeffries&quot;,93.2,71.13,164.33,35.1],[&quot;Florida 24th&quot;,&quot;Democratic&quot;,&quot;Frederica&quot;,&quot;Wilson&quot;,100.0,67.7,167.7,33.3],[&quot;New York 13th&quot;,&quot;Democratic&quot;,&quot;Adriano&quot;,&quot;Espaillat&quot;,81.7,86.85,168.55,43.3],[&quot;Illinois 4th&quot;,&quot;Democratic&quot;,&quot;Luis&quot;,&quot;Guti\u00e9rrez&quot;,100.0,68.86,168.86,35.0],[&quot;Washington 7th&quot;,&quot;Democratic&quot;,&quot;Pramila&quot;,&quot;Jayapal&quot;,100.0,69.95,169.95,36.0],[&quot;California 44th&quot;,&quot;Democratic&quot;,&quot;Nanette&quot;,&quot;Barragan&quot;,100.0,70.77,170.77,36.0],[&quot;Massachusetts 7th&quot;,&quot;Democratic&quot;,&quot;Mike&quot;,&quot;Capuano&quot;,98.6,72.21,170.81,36.5],[&quot;California 37th&quot;,&quot;Democratic&quot;,&quot;Karen&quot;,&quot;Bass&quot;,100.0,76.05,176.05,38.8],[&quot;New York 15th&quot;,&quot;Democratic&quot;,&quot;Jos\u00e9&quot;,&quot;Serrano&quot;,91.7,88.87,180.57,43.9]];

        //TABLE HEAD
        var tr = document.createElement('tr');
        tableHead.appendChild(tr);
        for (i = 0; i < heading.length; i++) {
            var th = document.createElement('th')
            //th.width = '75';
            th.appendChild(document.createTextNode(heading[i]));
            tr.appendChild(th);
        }

        //TABLE ROWS
        for (i = 0; i < data.length; i++) {
            var tr = document.createElement('TR');
            for (j = 0; j < data[i].length; j++) {
                var td = document.createElement('TD')
                td.appendChild(document.createTextNode(data[i][j]));
                tr.appendChild(td)
            }
            tableBody.appendChild(tr);
        }  
        tableDiv.appendChild(table)

    }

    window.onload = function () {addTable(); makeAllSortable(); };
    // use callback makeAllSortable(); at end?
    // window.onload = function () {addTable(makeAllSortable);  };  

    </script>

    </body>
    </html>" style="width: 725px; height: 500px; display:block; margin: 45px 0px; border: none"></iframe>
            



## Close House Seats for Republicans

I do the same thing below for House Republicans, but this time a positive sum indicates a district that had a larger margin for Clinton than for the Republican elected.  I also include a column showing whether or not the [Democratic Congressional Campaign Committee](http://dccc.org/) has indicated that this member of the House is a target for the 2018 election.  This shows that the 'sum' column is a fairly good indicator for a midterm target.


<iframe srcdoc="
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset=&quot;utf-8&quot;>
    <style>

    /*
    body {
        width: 800px;
    }*/

    table {
        font-size: 12px;
        border-collapse: collapse;
        border-top: 1px solid #ddd;
        border-right: 1px solid #ddd;
    }

    th {
        padding: 10px;
        cursor: pointer;
        background-color: #f2f2f2;
    }

    th, td {
        text-align: left;
        border-bottom: 1px solid #ddd;
        border-left: 1px solid #ddd;
    }

    td {
        padding: 5px 8px;
    }

    tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    tr:hover {
      background-color: #F0F8FF; /*#f9f9f9;*/
    }

    </style>
    </head>

    <body>

    <div id =&quot;tableInsert&quot;></div>

    <script>
    //http://stackoverflow.com/questions/14267781/sorting-html-table-with-javascript

    function sortTable(table, col, reverse) {
        var tb = table.tBodies[0], 
            tr = Array.prototype.slice.call(tb.rows, 0), // put rows into array
            i;

        reverse = -((+reverse) || -1);
        tr = tr.sort(function (a, b) { 
            var first = a.cells[col].textContent.trim();
            var second = b.cells[col].textContent.trim();

            if (isNumeric(first) && isNumeric(second)) {        
                return reverse * (Number(first) - Number(second));
            } else {
                return reverse * first.localeCompare(second);
            };
        });
        for(i = 0; i < tr.length; ++i) {  // append each row in order
            tb.appendChild(tr[i]);
        }
    }

    //http://stackoverflow.com/questions/18082
    function isNumeric(n) {
      return !isNaN(parseFloat(n)) && isFinite(n);
    }

    function makeSortable(table) {
        var th = table.tHead, i;
        th && (th = th.rows[0]) && (th = th.cells);
        if (th) i = th.length;
        else return; // if no `<thead>` then do nothing
        while (--i >= 0) (function (i) {
            var dir = 1;
            th[i].addEventListener('click', function () {sortTable(table, i, (dir = 1 - dir))});
        }(i));
    }

    function makeAllSortable(parent) {
        parent = parent || document.body;
        var t = parent.getElementsByTagName('table'), i = t.length;
        while (--i >= 0) makeSortable(t[i]);
    }

    function addTable() {
        var tableDiv = document.getElementById(&quot;tableInsert&quot;)
        var table = document.createElement('table')
        var tableHead = document.createElement('thead')
        var tableBody = document.createElement('tbody')

        table.appendChild(tableHead)
        table.appendChild(tableBody);

        var heading = [&quot;district&quot;, &quot;party&quot;, &quot;first&quot;, &quot;last&quot;, &quot;demlead_house2016&quot;, &quot;demlead_pres2016&quot;, &quot;sum&quot;, &quot;dccc_target&quot;, &quot;pvi_2016&quot;];
        var data = [[&quot;Florida 27th&quot;,&quot;Republican&quot;,&quot;Ileana&quot;,&quot;Ros-Lehtinen&quot;,-9.8,19.71,9.91,true,9.0],[&quot;California 49th&quot;,&quot;Republican&quot;,&quot;Darrell&quot;,&quot;Issa&quot;,-0.6,7.49,6.89,true,2.9],[&quot;Florida 26th&quot;,&quot;Republican&quot;,&quot;Carlos&quot;,&quot;Curbelo&quot;,-11.8,16.16,4.36,true,7.2],[&quot;Virginia 10th&quot;,&quot;Republican&quot;,&quot;Barbara&quot;,&quot;Comstock&quot;,-5.8,9.93,4.13,true,4.1],[&quot;California 21st&quot;,&quot;Republican&quot;,&quot;David&quot;,&quot;Valadao&quot;,-13.4,15.58,2.18,true,7.1],[&quot;Texas 23rd&quot;,&quot;Republican&quot;,&quot;Will&quot;,&quot;Hurd&quot;,-1.3,3.41,2.11,true,0.7],[&quot;Colorado 6th&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Coffman&quot;,-8.3,8.93,0.63,true,3.8],[&quot;California 25th&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;Knight&quot;,-6.2,6.68,0.48,true,2.4],[&quot;California 10th&quot;,&quot;Republican&quot;,&quot;Jeff&quot;,&quot;Denham&quot;,-3.4,3.0,-0.4,true,0.5],[&quot;Minnesota 2nd&quot;,&quot;Republican&quot;,&quot;Jason&quot;,&quot;Lewis&quot;,-1.8,-1.2,-3.0,true,-1.8],[&quot;Nebraska 2nd&quot;,&quot;Republican&quot;,&quot;Don&quot;,&quot;Bacon&quot;,-1.2,-2.25,-3.45,true,-2.3],[&quot;Minnesota 3rd&quot;,&quot;Republican&quot;,&quot;Erik&quot;,&quot;Paulsen&quot;,-13.7,9.46,-4.24,true,4.0],[&quot;California 39th&quot;,&quot;Republican&quot;,&quot;Ed&quot;,&quot;Royce&quot;,-14.4,8.61,-5.79,true,3.4],[&quot;Arizona 2nd&quot;,&quot;Republican&quot;,&quot;Martha&quot;,&quot;McSally&quot;,-14.0,4.9,-9.1,true,1.5],[&quot;Pennsylvania 8th&quot;,&quot;Republican&quot;,&quot;Brian&quot;,&quot;Fitzpatrick&quot;,-9.0,-0.24,-9.24,true,-1.2],[&quot;Kansas 3rd&quot;,&quot;Republican&quot;,&quot;Kevin&quot;,&quot;Yoder&quot;,-10.7,1.22,-9.48,true,-0.5],[&quot;New Jersey 7th&quot;,&quot;Republican&quot;,&quot;Leonard&quot;,&quot;Lance&quot;,-11.0,1.12,-9.88,true,-0.5],[&quot;Texas 7th&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Culberson&quot;,-12.4,1.37,-11.03,true,-0.4],[&quot;Iowa 1st&quot;,&quot;Republican&quot;,&quot;Rod&quot;,&quot;Blum&quot;,-7.6,-3.55,-11.15,true,-3.0],[&quot;Illinois 6th&quot;,&quot;Republican&quot;,&quot;Peter&quot;,&quot;Roskam&quot;,-18.4,6.97,-11.43,true,2.6],[&quot;California 45th&quot;,&quot;Republican&quot;,&quot;Mimi&quot;,&quot;Walters&quot;,-17.2,5.44,-11.76,true,1.8],[&quot;Pennsylvania 6th&quot;,&quot;Republican&quot;,&quot;Ryan&quot;,&quot;Costello&quot;,-14.6,0.62,-13.98,true,-0.8],[&quot;California 48th&quot;,&quot;Republican&quot;,&quot;Dana&quot;,&quot;Rohrabacher&quot;,-16.6,1.71,-14.89,true,-0.2],[&quot;New York 19th&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Faso&quot;,-8.5,-7.29,-15.79,true,-5.0],[&quot;Pennsylvania 7th&quot;,&quot;Republican&quot;,&quot;Pat&quot;,&quot;Meehan&quot;,-19.0,2.37,-16.63,true,0.1],[&quot;Michigan 11th&quot;,&quot;Republican&quot;,&quot;Dave&quot;,&quot;Trott&quot;,-12.7,-4.37,-17.07,true,-3.4],[&quot;Iowa 3rd&quot;,&quot;Republican&quot;,&quot;David&quot;,&quot;Young&quot;,-13.7,-3.53,-17.23,true,-3.0],[&quot;Washington 8th&quot;,&quot;Republican&quot;,&quot;Dave&quot;,&quot;Reichert&quot;,-20.4,3.04,-17.36,true,0.5],[&quot;New York 24th&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Katko&quot;,-21.1,3.65,-17.45,true,0.8],[&quot;Pennsylvania 16th&quot;,&quot;Republican&quot;,&quot;Lloyd&quot;,&quot;Smucker&quot;,-10.9,-6.81,-17.71,true,-4.7],[&quot;Utah 4th&quot;,&quot;Republican&quot;,&quot;Mia&quot;,&quot;Love&quot;,-12.5,-6.72,-19.22,false,-5.8],[&quot;Florida 18th&quot;,&quot;Republican&quot;,&quot;Brian&quot;,&quot;Mast&quot;,-10.5,-9.21,-19.71,true,-5.8],[&quot;Maine 2nd&quot;,&quot;Republican&quot;,&quot;Bruce&quot;,&quot;Poliquin&quot;,-9.6,-10.28,-19.88,true,-6.7],[&quot;New Jersey 11th&quot;,&quot;Republican&quot;,&quot;Rodney&quot;,&quot;Frelinghuysen&quot;,-19.1,-0.88,-19.98,true,-1.6],[&quot;New York 22nd&quot;,&quot;Republican&quot;,&quot;Claudia&quot;,&quot;Tenney&quot;,-5.5,-15.48,-20.98,true,-9.3],[&quot;North Carolina 13th&quot;,&quot;Republican&quot;,&quot;Ted&quot;,&quot;Budd&quot;,-12.2,-9.39,-21.59,true,-5.9],[&quot;Virginia 7th&quot;,&quot;Republican&quot;,&quot;Dave&quot;,&quot;Brat&quot;,-15.3,-6.5,-21.8,false,-4.6],[&quot;Illinois 14th&quot;,&quot;Republican&quot;,&quot;Randy&quot;,&quot;Hultgren&quot;,-18.6,-3.89,-22.49,true,-3.2],[&quot;North Carolina 2nd&quot;,&quot;Republican&quot;,&quot;George&quot;,&quot;Holding&quot;,-13.4,-9.65,-23.05,false,-6.1],[&quot;Texas 24th&quot;,&quot;Republican&quot;,&quot;Kenny&quot;,&quot;Marchant&quot;,-16.9,-6.25,-23.15,false,-4.4],[&quot;Michigan 8th&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Bishop&quot;,-16.8,-6.79,-23.59,true,-4.7],[&quot;Illinois 13th&quot;,&quot;Republican&quot;,&quot;Rodney&quot;,&quot;Davis&quot;,-19.4,-5.46,-24.86,true,-4.0],[&quot;Georgia 6th&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Price&quot;,-23.4,-1.49,-24.89,true,-1.9],[&quot;Florida 15th&quot;,&quot;Republican&quot;,&quot;Dennis&quot;,&quot;Ross&quot;,-15.0,-9.99,-24.99,false,-6.3],[&quot;Ohio 1st&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;Chabot&quot;,-18.4,-6.65,-25.05,true,-4.6],[&quot;Virginia 2nd&quot;,&quot;Republican&quot;,&quot;Scott&quot;,&quot;Taylor&quot;,-22.8,-3.4,-26.2,true,-2.9],[&quot;Colorado 3rd&quot;,&quot;Republican&quot;,&quot;Scott&quot;,&quot;Tipton&quot;,-14.3,-11.91,-26.21,true,-7.6],[&quot;Florida 25th&quot;,&quot;Republican&quot;,&quot;Mario&quot;,&quot;Diaz-Balart&quot;,-24.8,-1.7,-26.5,true,-2.0],[&quot;New Jersey 3rd&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;MacArthur&quot;,-20.4,-6.19,-26.59,true,-4.3],[&quot;New Jersey 2nd&quot;,&quot;Republican&quot;,&quot;Frank&quot;,&quot;LoBiondo&quot;,-22.0,-4.62,-26.62,true,-3.5],[&quot;Texas 22nd&quot;,&quot;Republican&quot;,&quot;Pete&quot;,&quot;Olson&quot;,-19.0,-7.89,-26.89,false,-5.2],[&quot;Georgia 7th&quot;,&quot;Republican&quot;,&quot;Rob&quot;,&quot;Woodall&quot;,-20.8,-6.38,-27.18,false,-4.4],[&quot;Virginia 5th&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Garrett&quot;,-16.6,-11.09,-27.69,false,-6.9],[&quot;North Carolina 9th&quot;,&quot;Republican&quot;,&quot;Robert&quot;,&quot;Pittenger&quot;,-16.4,-11.6,-28.0,true,-7.1],[&quot;Pennsylvania 15th&quot;,&quot;Republican&quot;,&quot;Charlie&quot;,&quot;Dent&quot;,-20.4,-7.62,-28.02,false,-5.1],[&quot;Texas 10th&quot;,&quot;Republican&quot;,&quot;Michael&quot;,&quot;McCaul&quot;,-18.9,-9.18,-28.08,false,-5.9],[&quot;Alaska At-Large&quot;,&quot;Republican&quot;,&quot;Don&quot;,&quot;Young&quot;,-14.3,-14.73,-29.03,false,-9.5],[&quot;Illinois 12th&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Bost&quot;,-14.6,-14.84,-29.44,false,-8.9],[&quot;California 42nd&quot;,&quot;Republican&quot;,&quot;Ken&quot;,&quot;Calvert&quot;,-17.6,-11.95,-29.55,false,-7.4],[&quot;New York 23rd&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Reed&quot;,-15.2,-14.88,-30.08,false,-9.0],[&quot;New York 1st&quot;,&quot;Republican&quot;,&quot;Lee&quot;,&quot;Zeldin&quot;,-17.9,-12.29,-30.19,true,-7.5],[&quot;Florida 16th&quot;,&quot;Republican&quot;,&quot;Vern&quot;,&quot;Buchanan&quot;,-19.6,-10.79,-30.39,false,-6.7],[&quot;Texas 21st&quot;,&quot;Republican&quot;,&quot;Lamar&quot;,&quot;Smith&quot;,-20.6,-9.97,-30.57,false,-6.4],[&quot;Michigan 6th&quot;,&quot;Republican&quot;,&quot;Fred&quot;,&quot;Upton&quot;,-22.2,-8.44,-30.64,false,-5.6],[&quot;Washington 3rd&quot;,&quot;Republican&quot;,&quot;Jaime&quot;,&quot;Herrera Beutler&quot;,-23.6,-7.41,-31.01,true,-5.1],[&quot;Missouri 2nd&quot;,&quot;Republican&quot;,&quot;Ann&quot;,&quot;Wagner&quot;,-20.8,-10.28,-31.08,false,-6.5],[&quot;Michigan 3rd&quot;,&quot;Republican&quot;,&quot;Justin&quot;,&quot;Amash&quot;,-22.0,-9.45,-31.45,false,-6.2],[&quot;Texas 6th&quot;,&quot;Republican&quot;,&quot;Joe&quot;,&quot;Barton&quot;,-19.3,-12.25,-31.55,false,-7.5],[&quot;Michigan 7th&quot;,&quot;Republican&quot;,&quot;Tim&quot;,&quot;Walberg&quot;,-15.1,-17.07,-32.17,true,-10.2],[&quot;Arkansas 2nd&quot;,&quot;Republican&quot;,&quot;French&quot;,&quot;Hill&quot;,-21.5,-10.72,-32.22,true,-6.8],[&quot;Washington 5th&quot;,&quot;Republican&quot;,&quot;Cathy&quot;,&quot;McMorris Rodgers&quot;,-19.2,-13.03,-32.23,false,-8.2],[&quot;North Carolina 8th&quot;,&quot;Republican&quot;,&quot;Richard&quot;,&quot;Hudson&quot;,-17.6,-14.99,-32.59,true,-8.8],[&quot;Florida 3rd&quot;,&quot;Republican&quot;,&quot;Ted&quot;,&quot;Yoho&quot;,-16.8,-15.96,-32.76,false,-9.4],[&quot;North Carolina 6th&quot;,&quot;Republican&quot;,&quot;Mark&quot;,&quot;Walker&quot;,-18.4,-14.68,-33.08,false,-8.6],[&quot;Oklahoma 5th&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;Russell&quot;,-20.3,-13.4,-33.7,false,-8.3],[&quot;Nevada 2nd&quot;,&quot;Republican&quot;,&quot;Mark&quot;,&quot;Amodei&quot;,-21.4,-12.37,-33.77,false,-7.9],[&quot;New York 2nd&quot;,&quot;Republican&quot;,&quot;Pete&quot;,&quot;King&quot;,-24.9,-9.01,-33.91,false,-5.8],[&quot;Texas 2nd&quot;,&quot;Republican&quot;,&quot;Ted&quot;,&quot;Poe&quot;,-24.6,-9.31,-33.91,false,-6.0],[&quot;Arizona 6th&quot;,&quot;Republican&quot;,&quot;David&quot;,&quot;Schweikert&quot;,-24.2,-9.98,-34.18,false,-6.4],[&quot;Florida 6th&quot;,&quot;Republican&quot;,&quot;Ron&quot;,&quot;DeSantis&quot;,-17.2,-16.98,-34.18,false,-9.9],[&quot;North Carolina 5th&quot;,&quot;Republican&quot;,&quot;Virginia&quot;,&quot;Foxx&quot;,-16.8,-17.44,-34.24,false,-10.1],[&quot;New York 11th&quot;,&quot;Republican&quot;,&quot;Dan&quot;,&quot;Donovan&quot;,-24.8,-9.83,-34.63,true,-6.2],[&quot;Texas 31st&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Carter&quot;,-21.9,-12.74,-34.64,false,-7.9],[&quot;South Carolina 1st&quot;,&quot;Republican&quot;,&quot;Mark&quot;,&quot;Sanford&quot;,-21.8,-13.02,-34.82,false,-8.0],[&quot;Texas 25th&quot;,&quot;Republican&quot;,&quot;Roger&quot;,&quot;Williams&quot;,-20.6,-14.86,-35.46,false,-8.9],[&quot;New Mexico 2nd&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;Pearce&quot;,-25.5,-10.19,-35.69,false,-6.8],[&quot;Virginia 1st&quot;,&quot;Republican&quot;,&quot;Rob&quot;,&quot;Wittman&quot;,-23.3,-12.41,-35.71,false,-7.7],[&quot;Michigan 1st&quot;,&quot;Republican&quot;,&quot;Jack&quot;,&quot;Bergman&quot;,-14.8,-21.31,-36.11,false,-12.4],[&quot;Montana At-Large&quot;,&quot;Republican&quot;,&quot;Ryan&quot;,&quot;Zinke&quot;,-15.7,-20.53,-36.23,false,-12.2],[&quot;Ohio 14th&quot;,&quot;Republican&quot;,&quot;David&quot;,&quot;Joyce&quot;,-25.2,-11.45,-36.65,false,-7.1],[&quot;Wisconsin 6th&quot;,&quot;Republican&quot;,&quot;Glenn&quot;,&quot;Grothman&quot;,-19.9,-16.83,-36.73,false,-10.0],[&quot;Kentucky 6th&quot;,&quot;Republican&quot;,&quot;Andy&quot;,&quot;Barr&quot;,-22.2,-15.28,-37.48,true,-9.2],[&quot;California 1st&quot;,&quot;Republican&quot;,&quot;Doug&quot;,&quot;LaMalfa&quot;,-18.2,-19.63,-37.83,false,-11.7],[&quot;Ohio 10th&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Turner&quot;,-31.4,-7.29,-38.69,false,-4.9],[&quot;South Carolina 5th&quot;,&quot;Republican&quot;,&quot;Mick&quot;,&quot;Mulvaney&quot;,-20.5,-18.48,-38.98,false,-10.7],[&quot;Indiana 5th&quot;,&quot;Republican&quot;,&quot;Susan&quot;,&quot;Brooks&quot;,-27.2,-11.8,-39.0,false,-7.4],[&quot;Georgia 12th&quot;,&quot;Republican&quot;,&quot;Rick&quot;,&quot;Allen&quot;,-23.2,-16.16,-39.36,false,-9.4],[&quot;North Carolina 7th&quot;,&quot;Republican&quot;,&quot;David&quot;,&quot;Rouzer&quot;,-21.8,-17.7,-39.5,false,-10.2],[&quot;California 8th&quot;,&quot;Republican&quot;,&quot;Paul&quot;,&quot;Cook&quot;,-24.6,-15.13,-39.73,false,-9.1],[&quot;California 4th&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;McClintock&quot;,-25.4,-14.75,-40.15,false,-9.0],[&quot;Alabama 2nd&quot;,&quot;Republican&quot;,&quot;Martha&quot;,&quot;Roby&quot;,-8.3,-31.93,-40.23,true,-17.4],[&quot;Indiana 9th&quot;,&quot;Republican&quot;,&quot;Trey&quot;,&quot;Hollingsworth&quot;,-13.6,-26.9,-40.5,false,-15.2],[&quot;Texas 3rd&quot;,&quot;Republican&quot;,&quot;Sam&quot;,&quot;Johnson&quot;,-26.6,-14.18,-40.78,false,-8.5],[&quot;South Carolina 7th&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Rice&quot;,-22.1,-18.91,-41.01,false,-10.8],[&quot;Utah 2nd&quot;,&quot;Republican&quot;,&quot;Chris&quot;,&quot;Stewart&quot;,-27.7,-14.04,-41.74,false,-10.1],[&quot;California 50th&quot;,&quot;Republican&quot;,&quot;Duncan&quot;,&quot;Hunter&quot;,-27.0,-15.01,-42.01,false,-9.1],[&quot;South Carolina 2nd&quot;,&quot;Republican&quot;,&quot;Joe&quot;,&quot;Wilson&quot;,-24.3,-17.72,-42.02,false,-10.5],[&quot;Wisconsin 8th&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Gallagher&quot;,-25.3,-17.57,-42.87,false,-10.4],[&quot;Texas 17th&quot;,&quot;Republican&quot;,&quot;Bill&quot;,&quot;Flores&quot;,-25.6,-17.47,-43.07,false,-10.3],[&quot;Texas 14th&quot;,&quot;Republican&quot;,&quot;Randy&quot;,&quot;Weber&quot;,-23.8,-19.73,-43.53,false,-11.3],[&quot;Wisconsin 7th&quot;,&quot;Republican&quot;,&quot;Sean&quot;,&quot;Duffy&quot;,-23.4,-20.44,-43.84,false,-11.9],[&quot;Pennsylvania 12th&quot;,&quot;Republican&quot;,&quot;Keith&quot;,&quot;Rothfus&quot;,-23.6,-20.8,-44.4,false,-11.9],[&quot;California 22nd&quot;,&quot;Republican&quot;,&quot;Devin&quot;,&quot;Nunes&quot;,-35.2,-9.49,-44.69,false,-6.1],[&quot;New Jersey 4th&quot;,&quot;Republican&quot;,&quot;Chris&quot;,&quot;Smith&quot;,-30.2,-14.77,-44.97,false,-8.7],[&quot;Wisconsin 1st&quot;,&quot;Republican&quot;,&quot;Paul&quot;,&quot;Ryan&quot;,-34.7,-10.38,-45.08,false,-6.6],[&quot;Indiana 2nd&quot;,&quot;Republican&quot;,&quot;Jackie&quot;,&quot;Walorski&quot;,-22.4,-23.21,-45.61,false,-13.3],[&quot;Kansas 2nd&quot;,&quot;Republican&quot;,&quot;Lynn&quot;,&quot;Jenkins&quot;,-28.3,-18.4,-46.7,true,-11.0],[&quot;Texas 27th&quot;,&quot;Republican&quot;,&quot;Blake&quot;,&quot;Farenthold&quot;,-23.4,-23.55,-46.95,false,-13.3],[&quot;Ohio 16th&quot;,&quot;Republican&quot;,&quot;Jim&quot;,&quot;Renacci&quot;,-30.6,-16.65,-47.25,false,-9.8],[&quot;Michigan 2nd&quot;,&quot;Republican&quot;,&quot;Bill&quot;,&quot;Huizenga&quot;,-30.1,-17.53,-47.63,false,-10.4],[&quot;Ohio 15th&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;Stivers&quot;,-32.4,-15.48,-47.88,false,-9.2],[&quot;Ohio 12th&quot;,&quot;Republican&quot;,&quot;Pat&quot;,&quot;Tiberi&quot;,-36.8,-11.27,-48.07,false,-7.0],[&quot;Ohio 2nd&quot;,&quot;Republican&quot;,&quot;Brad&quot;,&quot;Wenstrup&quot;,-32.2,-16.09,-48.29,false,-9.5],[&quot;New York 21st&quot;,&quot;Republican&quot;,&quot;Elise&quot;,&quot;Stefanik&quot;,-35.2,-13.86,-49.06,false,-8.5],[&quot;Arizona 5th&quot;,&quot;Republican&quot;,&quot;Andy&quot;,&quot;Biggs&quot;,-28.2,-21.12,-49.32,false,-12.3],[&quot;Iowa 4th&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;King&quot;,-22.6,-27.33,-49.93,false,-15.6],[&quot;North Carolina 10th&quot;,&quot;Republican&quot;,&quot;Patrick&quot;,&quot;McHenry&quot;,-26.2,-24.47,-50.67,false,-13.7],[&quot;Pennsylvania 11th&quot;,&quot;Republican&quot;,&quot;Lou&quot;,&quot;Barletta&quot;,-27.4,-23.82,-51.22,false,-13.5],[&quot;Florida 8th&quot;,&quot;Republican&quot;,&quot;Bill&quot;,&quot;Posey&quot;,-30.6,-20.71,-51.31,false,-11.9],[&quot;West Virginia 2nd&quot;,&quot;Republican&quot;,&quot;Alex&quot;,&quot;Mooney&quot;,-16.4,-36.44,-52.84,true,-20.3],[&quot;Pennsylvania 4th&quot;,&quot;Republican&quot;,&quot;Scott&quot;,&quot;Perry&quot;,-32.2,-21.5,-53.7,false,-12.3],[&quot;Florida 19th&quot;,&quot;Republican&quot;,&quot;Francis&quot;,&quot;Rooney&quot;,-31.8,-22.06,-53.86,false,-12.5],[&quot;Michigan 4th&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Moolenaar&quot;,-29.5,-24.82,-54.32,false,-14.3],[&quot;Florida 17th&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Rooney&quot;,-27.6,-27.2,-54.8,false,-15.1],[&quot;Colorado 4th&quot;,&quot;Republican&quot;,&quot;Ken&quot;,&quot;Buck&quot;,-31.8,-23.16,-54.96,false,-13.7],[&quot;Colorado 5th&quot;,&quot;Republican&quot;,&quot;Doug&quot;,&quot;Lamborn&quot;,-31.4,-23.94,-55.34,false,-14.4],[&quot;Florida 12th&quot;,&quot;Republican&quot;,&quot;Gus&quot;,&quot;Bilirakis&quot;,-37.2,-18.6,-55.8,false,-10.8],[&quot;Minnesota 6th&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Emmer&quot;,-31.3,-25.67,-56.97,false,-15.0],[&quot;Wisconsin 5th&quot;,&quot;Republican&quot;,&quot;Jim&quot;,&quot;Sensenbrenner&quot;,-37.4,-20.14,-57.54,false,-11.7],[&quot;North Carolina 11th&quot;,&quot;Republican&quot;,&quot;Mark&quot;,&quot;Meadows&quot;,-28.2,-29.49,-57.69,false,-16.3],[&quot;South Dakota At-Large&quot;,&quot;Republican&quot;,&quot;Kristi&quot;,&quot;Noem&quot;,-28.2,-29.8,-58.0,false,-17.1],[&quot;North Carolina 3rd&quot;,&quot;Republican&quot;,&quot;Walter&quot;,&quot;Jones&quot;,-34.4,-23.68,-58.08,false,-13.3],[&quot;Idaho 2nd&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Simpson&quot;,-33.5,-24.66,-58.16,false,-15.8],[&quot;Virginia 6th&quot;,&quot;Republican&quot;,&quot;Bob&quot;,&quot;Goodlatte&quot;,-33.5,-24.81,-58.31,false,-14.2],[&quot;New York 27th&quot;,&quot;Republican&quot;,&quot;Chris&quot;,&quot;Collins&quot;,-34.4,-24.44,-58.84,true,-14.0],[&quot;Georgia 11th&quot;,&quot;Republican&quot;,&quot;Barry&quot;,&quot;Loudermilk&quot;,-34.8,-24.99,-59.79,false,-14.2],[&quot;Nebraska 1st&quot;,&quot;Republican&quot;,&quot;Jeff&quot;,&quot;Fortenberry&quot;,-39.0,-21.23,-60.23,false,-12.4],[&quot;Mississippi 3rd&quot;,&quot;Republican&quot;,&quot;Gregg&quot;,&quot;Harper&quot;,-35.8,-24.52,-60.32,false,-13.6],[&quot;California 23rd&quot;,&quot;Republican&quot;,&quot;Kevin&quot;,&quot;McCarthy&quot;,-38.4,-22.07,-60.47,false,-12.8],[&quot;South Carolina 4th&quot;,&quot;Republican&quot;,&quot;Trey&quot;,&quot;Gowdy&quot;,-36.2,-25.74,-61.94,false,-14.7],[&quot;Michigan 10th&quot;,&quot;Republican&quot;,&quot;Paul&quot;,&quot;Mitchell&quot;,-30.8,-32.17,-62.97,false,-18.0],[&quot;Pennsylvania 5th&quot;,&quot;Republican&quot;,&quot;Glenn&quot;,&quot;Thompson&quot;,-34.4,-28.84,-63.24,false,-16.2],[&quot;Texas 26th&quot;,&quot;Republican&quot;,&quot;Michael&quot;,&quot;Burgess&quot;,-36.8,-26.5,-63.3,false,-15.0],[&quot;Oregon 2nd&quot;,&quot;Republican&quot;,&quot;Greg&quot;,&quot;Walden&quot;,-43.7,-20.09,-63.79,false,-11.9],[&quot;Georgia 8th&quot;,&quot;Republican&quot;,&quot;Austin&quot;,&quot;Scott&quot;,-35.2,-28.94,-64.14,false,-15.9],[&quot;Ohio 7th&quot;,&quot;Republican&quot;,&quot;Bob&quot;,&quot;Gibbs&quot;,-35.0,-29.66,-64.66,true,-16.7],[&quot;Louisiana 4th&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Johnson&quot;,-41.6,-23.98,-65.58,false,-13.4],[&quot;Indiana 8th&quot;,&quot;Republican&quot;,&quot;Larry&quot;,&quot;Bucshon&quot;,-32.0,-33.72,-65.72,false,-18.8],[&quot;Florida 11th&quot;,&quot;Republican&quot;,&quot;Daniel&quot;,&quot;Webster&quot;,-33.8,-32.31,-66.11,false,-17.7],[&quot;Maryland 1st&quot;,&quot;Republican&quot;,&quot;Andy&quot;,&quot;Harris&quot;,-38.4,-28.42,-66.82,false,-16.0],[&quot;Alabama 5th&quot;,&quot;Republican&quot;,&quot;Mo&quot;,&quot;Brooks&quot;,-33.5,-33.37,-66.87,false,-18.5],[&quot;Utah 1st&quot;,&quot;Republican&quot;,&quot;Rob&quot;,&quot;Bishop&quot;,-39.5,-27.37,-66.87,false,-20.1],[&quot;Ohio 5th&quot;,&quot;Republican&quot;,&quot;Bob&quot;,&quot;Latta&quot;,-41.8,-25.09,-66.89,false,-14.4],[&quot;Alabama 3rd&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Rogers&quot;,-34.0,-32.96,-66.96,false,-18.0],[&quot;Georgia 3rd&quot;,&quot;Republican&quot;,&quot;Drew&quot;,&quot;Ferguson&quot;,-36.6,-31.57,-68.17,false,-17.4],[&quot;Indiana 4th&quot;,&quot;Republican&quot;,&quot;Todd&quot;,&quot;Rokita&quot;,-34.1,-34.11,-68.21,false,-19.2],[&quot;Pennsylvania 9th&quot;,&quot;Republican&quot;,&quot;Bill&quot;,&quot;Shuster&quot;,-26.6,-42.53,-69.13,false,-23.0],[&quot;Texas 32nd&quot;,&quot;Republican&quot;,&quot;Pete&quot;,&quot;Sessions&quot;,-71.1,1.87,-69.23,true,-0.1],[&quot;Ohio 4th&quot;,&quot;Republican&quot;,&quot;Jim&quot;,&quot;Jordan&quot;,-36.0,-33.6,-69.6,false,-18.8],[&quot;Florida 4th&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Rutherford&quot;,-42.6,-28.02,-70.62,false,-15.7],[&quot;Utah 3rd&quot;,&quot;Republican&quot;,&quot;Jason&quot;,&quot;Chaffetz&quot;,-47.0,-23.91,-70.91,false,-18.1],[&quot;Missouri 6th&quot;,&quot;Republican&quot;,&quot;Sam&quot;,&quot;Graves&quot;,-39.6,-31.44,-71.04,false,-17.7],[&quot;Tennessee 4th&quot;,&quot;Republican&quot;,&quot;Scott&quot;,&quot;DesJarlais&quot;,-30.0,-41.14,-71.14,false,-22.5],[&quot;Illinois 18th&quot;,&quot;Republican&quot;,&quot;Darin&quot;,&quot;LaHood&quot;,-44.2,-27.39,-71.59,false,-15.7],[&quot;Texas 12th&quot;,&quot;Republican&quot;,&quot;Kay&quot;,&quot;Granger&quot;,-42.5,-30.21,-72.71,false,-16.9],[&quot;Tennessee 3rd&quot;,&quot;Republican&quot;,&quot;Chuck&quot;,&quot;Fleischmann&quot;,-37.6,-35.23,-72.83,false,-19.5],[&quot;Florida 2nd&quot;,&quot;Republican&quot;,&quot;Neal&quot;,&quot;Dunn&quot;,-37.4,-35.6,-73.0,false,-19.5],[&quot;Mississippi 1st&quot;,&quot;Republican&quot;,&quot;Trent&quot;,&quot;Kelly&quot;,-40.8,-32.96,-73.76,false,-18.0],[&quot;Idaho 1st&quot;,&quot;Republican&quot;,&quot;Ra\u00fal&quot;,&quot;Labrador&quot;,-36.4,-38.3,-74.7,false,-22.6],[&quot;Missouri 4th&quot;,&quot;Republican&quot;,&quot;Vicky&quot;,&quot;Hartzler&quot;,-40.0,-35.95,-75.95,false,-20.1],[&quot;Pennsylvania 10th&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Marino&quot;,-40.4,-35.89,-76.29,false,-19.8],[&quot;Ohio 8th&quot;,&quot;Republican&quot;,&quot;Warren&quot;,&quot;Davidson&quot;,-41.8,-34.51,-76.31,false,-19.1],[&quot;Florida 1st&quot;,&quot;Republican&quot;,&quot;Matt&quot;,&quot;Gaetz&quot;,-38.2,-39.34,-77.54,false,-21.7],[&quot;Wyoming At-Large&quot;,&quot;Republican&quot;,&quot;Liz&quot;,&quot;Cheney&quot;,-32.0,-46.3,-78.3,false,-26.8],[&quot;Mississippi 4th&quot;,&quot;Republican&quot;,&quot;Steven&quot;,&quot;Palazzo&quot;,-37.2,-41.14,-78.34,false,-22.2],[&quot;Kentucky 4th&quot;,&quot;Republican&quot;,&quot;Thomas&quot;,&quot;Massie&quot;,-42.6,-35.91,-78.51,false,-20.1],[&quot;Missouri 3rd&quot;,&quot;Republican&quot;,&quot;Blaine&quot;,&quot;Luetkemeyer&quot;,-39.9,-39.02,-78.92,false,-21.6],[&quot;Tennessee 8th&quot;,&quot;Republican&quot;,&quot;David&quot;,&quot;Kustoff&quot;,-43.7,-35.62,-79.32,false,-19.5],[&quot;West Virginia 1st&quot;,&quot;Republican&quot;,&quot;David&quot;,&quot;McKinley&quot;,-38.0,-41.64,-79.64,false,-23.2],[&quot;Oklahoma 4th&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Cole&quot;,-43.5,-37.4,-80.9,false,-21.0],[&quot;Virginia 9th&quot;,&quot;Republican&quot;,&quot;Morgan&quot;,&quot;Griffith&quot;,-40.3,-41.48,-81.78,false,-22.7],[&quot;North Dakota At-Large&quot;,&quot;Republican&quot;,&quot;Kevin&quot;,&quot;Cramer&quot;,-45.4,-36.41,-81.81,false,-20.9],[&quot;Indiana 3rd&quot;,&quot;Republican&quot;,&quot;Jim&quot;,&quot;Banks&quot;,-47.1,-34.99,-82.09,false,-19.5],[&quot;Louisiana 6th&quot;,&quot;Republican&quot;,&quot;Garret&quot;,&quot;Graves&quot;,-48.9,-33.8,-82.7,false,-18.7],[&quot;Indiana 6th&quot;,&quot;Republican&quot;,&quot;Luke&quot;,&quot;Messer&quot;,-42.4,-40.34,-82.74,false,-22.3],[&quot;Arizona 4th&quot;,&quot;Republican&quot;,&quot;Paul&quot;,&quot;Gosar&quot;,-43.0,-40.15,-83.15,false,-22.2],[&quot;South Carolina 3rd&quot;,&quot;Republican&quot;,&quot;Jeff&quot;,&quot;Duncan&quot;,-45.7,-37.99,-83.69,false,-20.9],[&quot;Ohio 6th&quot;,&quot;Republican&quot;,&quot;Bill&quot;,&quot;Johnson&quot;,-41.4,-42.6,-84.0,false,-23.3],[&quot;Missouri 7th&quot;,&quot;Republican&quot;,&quot;Billy&quot;,&quot;Long&quot;,-40.1,-45.68,-85.78,false,-25.1],[&quot;Tennessee 2nd&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Duncan&quot;,-51.2,-35.4,-86.6,false,-19.8],[&quot;Tennessee 7th&quot;,&quot;Republican&quot;,&quot;Marsha&quot;,&quot;Blackburn&quot;,-48.7,-39.28,-87.98,false,-21.6],[&quot;Arizona 8th&quot;,&quot;Republican&quot;,&quot;Trent&quot;,&quot;Franks&quot;,-68.5,-21.13,-89.63,false,-12.2],[&quot;West Virginia 3rd&quot;,&quot;Republican&quot;,&quot;Evan&quot;,&quot;Jenkins&quot;,-43.9,-49.27,-93.17,false,-26.8],[&quot;Alabama 6th&quot;,&quot;Republican&quot;,&quot;Gary&quot;,&quot;Palmer&quot;,-49.1,-44.68,-93.78,false,-24.2],[&quot;Kentucky 1st&quot;,&quot;Republican&quot;,&quot;James&quot;,&quot;Comer&quot;,-45.3,-48.49,-93.79,false,-26.3],[&quot;Texas 1st&quot;,&quot;Republican&quot;,&quot;Louie&quot;,&quot;Gohmert&quot;,-49.8,-46.94,-96.74,false,-25.2],[&quot;Louisiana 1st&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;Scalise&quot;,-55.1,-42.0,-97.1,false,-23.1],[&quot;Oklahoma 2nd&quot;,&quot;Republican&quot;,&quot;Markwayne&quot;,&quot;Mullin&quot;,-47.4,-50.08,-97.48,false,-27.3],[&quot;Tennessee 6th&quot;,&quot;Republican&quot;,&quot;Diane&quot;,&quot;Black&quot;,-49.3,-48.97,-98.27,false,-26.5],[&quot;Louisiana 3rd&quot;,&quot;Republican&quot;,&quot;Clay&quot;,&quot;Higgins&quot;,-63.2,-38.12,-101.32,false,-20.9],[&quot;Missouri 8th&quot;,&quot;Republican&quot;,&quot;Jason&quot;,&quot;Smith&quot;,-51.7,-54.39,-106.09,false,-29.3],[&quot;Arkansas 4th&quot;,&quot;Republican&quot;,&quot;Bruce&quot;,&quot;Westerman&quot;,-74.9,-32.83,-107.73,false,-18.3],[&quot;Arkansas 3rd&quot;,&quot;Republican&quot;,&quot;Steve&quot;,&quot;Womack&quot;,-77.3,-31.43,-108.73,false,-18.1],[&quot;Texas 5th&quot;,&quot;Republican&quot;,&quot;Jeb&quot;,&quot;Hensarling&quot;,-80.6,-28.39,-108.99,false,-15.8],[&quot;Oklahoma 3rd&quot;,&quot;Republican&quot;,&quot;Frank&quot;,&quot;Lucas&quot;,-56.6,-52.79,-109.39,false,-29.0],[&quot;Kansas 1st&quot;,&quot;Republican&quot;,&quot;Roger&quot;,&quot;Marshall&quot;,-65.9,-44.98,-110.88,false,-25.1],[&quot;Arkansas 1st&quot;,&quot;Republican&quot;,&quot;Rick&quot;,&quot;Crawford&quot;,-76.3,-34.81,-111.11,false,-19.4],[&quot;Georgia 1st&quot;,&quot;Republican&quot;,&quot;Buddy&quot;,&quot;Carter&quot;,-100.0,-15.51,-115.51,false,-9.1],[&quot;Illinois 16th&quot;,&quot;Republican&quot;,&quot;Adam&quot;,&quot;Kinzinger&quot;,-99.9,-17.16,-117.06,false,-10.3],[&quot;Pennsylvania 18th&quot;,&quot;Republican&quot;,&quot;Tim&quot;,&quot;Murphy&quot;,-100.0,-19.54,-119.54,false,-11.2],[&quot;Tennessee 1st&quot;,&quot;Republican&quot;,&quot;Phil&quot;,&quot;Roe&quot;,-63.0,-57.04,-120.04,false,-30.7],[&quot;Washington 4th&quot;,&quot;Republican&quot;,&quot;Dan&quot;,&quot;Newhouse&quot;,-100.0,-22.86,-122.86,false,-13.4],[&quot;Georgia 10th&quot;,&quot;Republican&quot;,&quot;Jody&quot;,&quot;Hice&quot;,-100.0,-25.5,-125.5,false,-14.3],[&quot;Alabama 1st&quot;,&quot;Republican&quot;,&quot;Bradley&quot;,&quot;Byrne&quot;,-96.4,-29.42,-125.82,false,-16.2],[&quot;Pennsylvania 3rd&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Kelly&quot;,-100.0,-26.03,-126.03,false,-14.7],[&quot;Oklahoma 1st&quot;,&quot;Republican&quot;,&quot;Jim&quot;,&quot;Bridenstine&quot;,-100.0,-28.76,-128.76,false,-16.4],[&quot;Louisiana 5th&quot;,&quot;Republican&quot;,&quot;Ralph&quot;,&quot;Abraham&quot;,-100.0,-29.37,-129.37,false,-16.2],[&quot;Texas 36th&quot;,&quot;Republican&quot;,&quot;Brian&quot;,&quot;Babin&quot;,-88.6,-46.75,-135.35,false,-25.2],[&quot;Texas 19th&quot;,&quot;Republican&quot;,&quot;Jodey&quot;,&quot;Arrington&quot;,-86.7,-49.06,-135.76,false,-26.7],[&quot;Kentucky 2nd&quot;,&quot;Republican&quot;,&quot;Brett&quot;,&quot;Guthrie&quot;,-100.0,-39.93,-139.93,false,-22.1],[&quot;Texas 4th&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Ratcliffe&quot;,-88.0,-53.64,-141.64,false,-28.7],[&quot;Illinois 15th&quot;,&quot;Republican&quot;,&quot;John&quot;,&quot;Shimkus&quot;,-100.0,-46.2,-146.2,false,-25.4],[&quot;Texas 11th&quot;,&quot;Republican&quot;,&quot;Mike&quot;,&quot;Conaway&quot;,-89.5,-58.73,-148.23,false,-31.4],[&quot;Texas 8th&quot;,&quot;Republican&quot;,&quot;Kevin&quot;,&quot;Brady&quot;,-100.0,-48.82,-148.82,false,-26.4],[&quot;Georgia 14th&quot;,&quot;Republican&quot;,&quot;Tom&quot;,&quot;Graves&quot;,-100.0,-52.89,-152.89,false,-28.4],[&quot;Texas 13th&quot;,&quot;Republican&quot;,&quot;Mac&quot;,&quot;Thornberry&quot;,-90.0,-63.05,-153.05,false,-33.7],[&quot;Nebraska 3rd&quot;,&quot;Republican&quot;,&quot;Adrian&quot;,&quot;Smith&quot;,-100.0,-54.87,-154.87,false,-30.0],[&quot;Georgia 9th&quot;,&quot;Republican&quot;,&quot;Doug&quot;,&quot;Collins&quot;,-100.0,-58.45,-158.45,false,-31.2],[&quot;Alabama 4th&quot;,&quot;Republican&quot;,&quot;Robert&quot;,&quot;Aderholt&quot;,-98.5,-62.92,-161.42,false,-33.3],[&quot;Kentucky 5th&quot;,&quot;Republican&quot;,&quot;Hal&quot;,&quot;Rogers&quot;,-100.0,-62.12,-162.12,false,-33.1]];

        //TABLE HEAD
        var tr = document.createElement('tr');
        tableHead.appendChild(tr);
        for (i = 0; i < heading.length; i++) {
            var th = document.createElement('th')
            //th.width = '75';
            th.appendChild(document.createTextNode(heading[i]));
            tr.appendChild(th);
        }

        //TABLE ROWS
        for (i = 0; i < data.length; i++) {
            var tr = document.createElement('TR');
            for (j = 0; j < data[i].length; j++) {
                var td = document.createElement('TD')
                td.appendChild(document.createTextNode(data[i][j]));
                tr.appendChild(td)
            }
            tableBody.appendChild(tr);
        }  
        tableDiv.appendChild(table)

    }

    window.onload = function () {addTable(); makeAllSortable(); };
    // use callback makeAllSortable(); at end?
    // window.onload = function () {addTable(makeAllSortable);  };  

    </script>

    </body>
    </html>" style="width: 725px; height: 500px; display:block; margin: 45px 0px; border: none"></iframe>
            


# Senate Seats at Risk

Next, I look at the Senate seats at risk for each party.  Below is a plot similar plot to the one above, except it only shows the Senators up for re-election in 2018.  This plot is also slightly different, as I am using the Democratic Lead in the 2012 Senate election for each candidate on the y-axis.  This might not be the best indicator of the state's support for the candidate as a lot has changed since 2012, but it's the best one I can think of.

This plot makes it clear that Senate Democrats have a tough 2018 coming up, as 9 senators are up for re-election in states that Trump won.  


<!--<iframe src="{{site.url}}/vis/midterm_senate.html"-->
<!--    style="width: 960px; height: 600px; display:block; width: 100%; margin: 25px 0px; border: none"></iframe>-->

<iframe srcdoc="
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset=&quot;utf-8&quot;>
    <title>Zoom + Pan</title>
    <style>
    
    body {
      position: relative;
      width: 650px; /*960px*/
    }

    svg {font: 10px sans-serif;}

    rect {fill: #e5e5e5; }

    .label {
        font-size: 12px;
        /*stroke: #ddd;*/
        fill: #555;
    }

    .dot {
      stroke: #aaa;
      stroke-width: 0.5px;
      /*stroke: red;*/
      /*border: 1;*/
    }
    .dot:hover {fill-opacity: 0.4;}

    .axis path,
    .axis line {
      stroke: #fff; /*black;*/
      fill: none; 
      stroke-width: 1px;
    }
    
    #main-tick{
      fill: none;
      stroke: #777;  
      stroke-width: 1px;
      opacity: 1;
    }

    .buttons {
      position: absolute;
      right: 30px;
      top: 30px;
    }
    button {
      font: 16px sans-serif;
      display: block;
      border-radius: 0px;
      width: 25px;
      /*outline: none;*/
      /*outline:0;*/
      background-color: white;
      border: none;
    }
    
    button:hover {
      background-image:none;
      background-color:#d5d5d5;
    }
    
    button:focus{ 
    /*outline-color: #ddd;
    outline:none;
    outline: 1;*/
    outline-color: #b5b5b5;
    }
    
    div.tooltip {
      position: absolute;
      padding: 5px;
      font: 12px sans-serif;
      background: white;
      border: 0px;
      border-radius: 0px;
      pointer-events:none;
    }

    </style>
    </head>
    <body>
    
    <div class=&quot;buttons&quot;>
      <button data-zoom=&quot;+1&quot;>+</button>
      <button data-zoom=&quot;-1&quot;>-</button>
    </div>
    <script src=&quot;//d3js.org/d3.v3.min.js&quot;></script>
    <script>

    var margin = {top: 20, right: 20, bottom: 40, left: 40},  //40, 40
        width = 650 - margin.left - margin.right,  //650
        height = 515 - margin.top - margin.bottom;

    var keys = {&quot;last&quot;: 4, &quot;state&quot;: 0, &quot;sum&quot;: 14, &quot;lastelect_dem&quot;: 10, &quot;voting_age_pop&quot;: 9, &quot;clinton_2016&quot;: 6, &quot;pvi_2016&quot;: 8, &quot;party&quot;: 2, &quot;demlead_lastsenate&quot;: 13, &quot;lastelect_rep&quot;: 11, &quot;first&quot;: 3, &quot;demlead_pres2016&quot;: 12, &quot;class&quot;: 1, &quot;trump_2016&quot;: 7, &quot;prestotal_2016&quot;: 5};
    var data = [[&quot;Arizona&quot;,2012.0,&quot;Republican&quot;,&quot;Jeff&quot;,&quot;Flake&quot;,2604657.0,1161167.0,1252401.0,-2.93,4763003.0,46.16,49.18,-3.5,-3.02,-6.53],[&quot;California&quot;,2012.0,&quot;Democratic&quot;,&quot;Dianne&quot;,&quot;Feinstein&quot;,14237884.0,8753788.0,4483810.0,15.09,27958916.0,62.52,37.48,29.99,25.05,55.04],[&quot;Connecticut&quot;,2012.0,&quot;Democratic&quot;,&quot;Chris&quot;,&quot;Murphy&quot;,1644920.0,897572.0,673215.0,6.1,2757082.0,55.29,43.03,13.64,12.26,25.9],[&quot;Delaware&quot;,2012.0,&quot;Democratic&quot;,&quot;Tom&quot;,&quot;Carper&quot;,443814.0,235603.0,185127.0,4.96,692169.0,66.42,28.95,11.37,37.47,48.84],[&quot;Florida&quot;,2012.0,&quot;Democratic&quot;,&quot;Bill&quot;,&quot;Nelson&quot;,9501617.0,4504975.0,4617886.0,-1.66,14798498.0,55.23,42.23,-1.19,13.01,11.82],[&quot;Hawaii&quot;,2012.0,&quot;Democratic&quot;,&quot;Mazie&quot;,&quot;Hirono&quot;,428937.0,266891.0,128847.0,16.4,1056483.0,62.6,37.4,32.18,25.2,57.39],[&quot;Indiana&quot;,2012.0,&quot;Democratic&quot;,&quot;Joe&quot;,&quot;Donnelly&quot;,2757828.0,1033126.0,1557286.0,-11.02,4875504.0,50.03,44.3,-19.01,5.74,-13.27],[&quot;Maine&quot;,2012.0,&quot;Independent - Dem Caucus&quot;,&quot;Angus&quot;,&quot;King&quot;,747927.0,357735.0,335593.0,0.41,1053828.0,52.89,30.74,2.96,22.15,25.11],[&quot;Maryland&quot;,2012.0,&quot;Democratic&quot;,&quot;Ben&quot;,&quot;Cardin&quot;,2781446.0,1677928.0,943169.0,12.97,4420588.0,55.98,26.33,26.42,29.65,56.07],[&quot;Massachusetts&quot;,2012.0,&quot;Democratic&quot;,&quot;Elizabeth&quot;,&quot;Warren&quot;,3325046.0,1995196.0,1090893.0,13.61,5128706.0,53.74,46.19,27.2,7.55,34.75],[&quot;Michigan&quot;,2012.0,&quot;Democratic&quot;,&quot;Debbie&quot;,&quot;Stabenow&quot;,4824119.0,2268839.0,2279543.0,-1.16,7539572.0,58.8,37.98,-0.22,20.81,20.59],[&quot;Minnesota&quot;,2012.0,&quot;Democratic&quot;,&quot;Amy&quot;,&quot;Klobuchar&quot;,2945233.0,1367825.0,1323232.0,-0.21,4019862.0,65.23,30.53,1.51,34.7,36.22],[&quot;Mississippi&quot;,2012.0,&quot;Republican&quot;,&quot;Roger&quot;,&quot;Wicker&quot;,1211088.0,485131.0,700714.0,-10.14,2211742.0,40.55,57.16,-17.8,-16.6,-34.41],[&quot;Missouri&quot;,2012.0,&quot;Democratic&quot;,&quot;Claire&quot;,&quot;McCaskill&quot;,2827673.0,1071068.0,1594511.0,-10.85,4563491.0,54.81,39.11,-18.51,15.7,-2.81],[&quot;Montana&quot;,2012.0,&quot;Democratic&quot;,&quot;Jon&quot;,&quot;Tester&quot;,501822.0,177709.0,279240.0,-12.15,765852.0,48.58,44.86,-20.23,3.72,-16.51],[&quot;Nebraska&quot;,2012.0,&quot;Republican&quot;,&quot;Deb&quot;,&quot;Fischer&quot;,844227.0,284494.0,495961.0,-14.59,1367120.0,42.23,57.77,-25.05,-15.55,-40.6],[&quot;Nevada&quot;,2012.0,&quot;Republican&quot;,&quot;Dean&quot;,&quot;Heller&quot;,1125385.0,539260.0,512058.0,0.25,2035543.0,44.71,45.87,2.42,-1.16,1.26],[&quot;New Jersey&quot;,2012.0,&quot;Democratic&quot;,&quot;Bob&quot;,&quot;Menendez&quot;,3906723.0,2148278.0,1601933.0,6.24,6726680.0,58.84,39.4,13.98,19.44,33.42],[&quot;New Mexico&quot;,2012.0,&quot;Democratic&quot;,&quot;Martin&quot;,&quot;Heinrich&quot;,798318.0,385234.0,319666.0,3.61,1540507.0,51.01,45.28,8.21,5.73,13.94],[&quot;New York&quot;,2012.0,&quot;Democratic&quot;,&quot;Kirsten&quot;,&quot;Gillibrand&quot;,7707363.0,4547562.0,2814589.0,10.05,15053150.0,72.22,26.34,22.48,45.88,68.36],[&quot;North Dakota&quot;,2012.0,&quot;Democratic&quot;,&quot;Heidi&quot;,&quot;Heitkamp&quot;,344360.0,93758.0,216794.0,-20.85,522720.0,50.23,49.33,-35.73,0.9,-34.83],[&quot;Ohio&quot;,2012.0,&quot;Democratic&quot;,&quot;Sherrod&quot;,&quot;Brown&quot;,5536528.0,2394164.0,2841005.0,-5.31,8805753.0,50.7,44.7,-8.07,6.0,-2.07],[&quot;Pennsylvania&quot;,2012.0,&quot;Democratic&quot;,&quot;Bob&quot;,&quot;Casey&quot;,6166698.0,2926441.0,2970733.0,-1.42,9910224.0,53.69,44.59,-0.72,9.1,8.38],[&quot;Rhode Island&quot;,2012.0,&quot;Democratic&quot;,&quot;Sheldon&quot;,&quot;Whitehouse&quot;,464144.0,252525.0,180543.0,7.27,828611.0,64.81,34.97,15.51,29.85,45.35],[&quot;Tennessee&quot;,2012.0,&quot;Republican&quot;,&quot;Bob&quot;,&quot;Corker&quot;,2508027.0,870695.0,1522925.0,-14.68,4850104.0,30.41,64.89,-26.01,-34.48,-60.49],[&quot;Texas&quot;,2012.0,&quot;Republican&quot;,&quot;Ted&quot;,&quot;Cruz&quot;,8969226.0,3877868.0,4685047.0,-5.76,18279734.0,40.62,56.46,-9.0,-15.83,-24.83],[&quot;Utah&quot;,2012.0,&quot;Republican&quot;,&quot;Orrin&quot;,&quot;Hatch&quot;,1143601.0,310676.0,515231.0,-13.43,1892855.0,29.98,65.31,-17.89,-35.33,-53.22],[&quot;Vermont&quot;,2012.0,&quot;Independent - Dem Caucus&quot;,&quot;Bernie&quot;,&quot;Sanders&quot;,315067.0,178573.0,95369.0,14.14,496508.0,71.04,24.87,26.41,46.17,72.58],[&quot;Virginia&quot;,2012.0,&quot;Democratic&quot;,&quot;Tim&quot;,&quot;Kaine&quot;,3982752.0,1981473.0,1769443.0,1.78,6147347.0,52.87,46.96,5.32,5.91,11.23],[&quot;Washington&quot;,2012.0,&quot;Democratic&quot;,&quot;Maria&quot;,&quot;Cantwell&quot;,3316996.0,1742718.0,1221747.0,7.74,5143186.0,60.45,39.55,15.71,20.9,36.61],[&quot;West Virginia&quot;,2012.0,&quot;Democratic&quot;,&quot;Joe&quot;,&quot;Manchin&quot;,721231.0,188794.0,489371.0,-23.21,1465576.0,60.57,36.47,-41.68,24.1,-17.57],[&quot;Wisconsin&quot;,2012.0,&quot;Democratic&quot;,&quot;Tammy&quot;,&quot;Baldwin&quot;,2976150.0,1382536.0,1405284.0,-1.44,4347494.0,51.41,45.86,-0.76,5.55,4.78],[&quot;Wyoming&quot;,2012.0,&quot;Republican&quot;,&quot;John&quot;,&quot;Barrasso&quot;,255849.0,55973.0,174419.0,-26.75,428224.0,21.65,75.65,-46.3,-54.0,-100.3]];
    
    var xName = &quot;demlead_pres2016&quot;;
    var yName = &quot;demlead_lastsenate&quot;;
    var xLabel = &quot;Democratic Lead, President 2016 (%)&quot;;
    var yLabel = &quot;Democratic Lead, Last Senate (%)&quot;;
    
    var min_x = d3.min(data, function(d) { return +d[keys[xName]]; });
    var max_x = d3.max(data, function(d) { return +d[keys[xName]]; });
    var min_y = d3.min(data, function(d) { return +d[keys[yName]]; });
    var max_y = d3.max(data, function(d) { return +d[keys[yName]]; });
    var max = d3.max([min_x, min_y, max_x, max_y].map(Math.abs));

    var x = d3.scale.linear()
            .domain([-1.2*max, 1.2*max])
            .range([ 0, width ]);

    var y = d3.scale.linear()
            //.domain([min_y - Math.abs(0.2*min_y), max_y + Math.abs(0.2*max_y)])
            .domain([-1.2*max, 1.2*max])
            .range([ height, 0 ]);

    var xAxis = d3.svg.axis()
        .scale(x)
        .orient(&quot;bottom&quot;)
        .ticks(6)  //5
        .tickSize(-height);

    var yAxis = d3.svg.axis()
        .scale(y)
        .orient(&quot;left&quot;)
        .ticks(6)  //5
        .tickSize(-width);  //-width

    var zoom = d3.behavior.zoom()
        .x(x)
        .y(y)
        .scaleExtent([1, 10])
        .center([width / 2, height / 2])
        .size([width, height])
        .on(&quot;zoom&quot;, zoomed);

    var svg = d3.select(&quot;body&quot;).append(&quot;svg&quot;)
        .attr(&quot;width&quot;, width + margin.left + margin.right)
        .attr(&quot;height&quot;, height + margin.top + margin.bottom)
      .append(&quot;g&quot;)
        .attr(&quot;transform&quot;, &quot;translate(&quot; + margin.left + &quot;,&quot; + margin.top + &quot;)&quot;)
        .call(zoom);

    //http://stackoverflow.com/questions/28723551
    //Create clip, then apply it to each dot
    var clip = svg.append(&quot;defs&quot;).append(&quot;svg:clipPath&quot;)
        .attr(&quot;id&quot;, &quot;clip&quot;)
        .append(&quot;svg:rect&quot;)
        .attr(&quot;id&quot;, &quot;clip-rect&quot;)
        .attr(&quot;x&quot;, &quot;0&quot;)  //
        .attr(&quot;y&quot;, &quot;0&quot;)  //
        .attr('width', width)
        .attr('height', height);

    svg.append(&quot;rect&quot;)
        .attr(&quot;width&quot;, width)
        .attr(&quot;height&quot;, height);

    svg.append(&quot;g&quot;)
        .attr(&quot;class&quot;, &quot;x axis&quot;)
        .attr(&quot;transform&quot;, &quot;translate(0,&quot; + height + &quot;)&quot;)
        .call(xAxis);

    svg.append(&quot;g&quot;)
        .attr(&quot;class&quot;, &quot;y axis&quot;)
        .call(yAxis);

    d3.selectAll('g.tick')
      .filter(function(d){ return d==0;} )
      .select('line') 
      .attr('id', 'main-tick');

    // Tooltips
    var div = d3.select(&quot;body&quot;)
        .append(&quot;div&quot;)  
        .attr(&quot;class&quot;, &quot;tooltip&quot;)
        .style(&quot;opacity&quot;, 0); 

    svg.selectAll(&quot;.dot&quot;)
      .data(data)
    .enter().append(&quot;circle&quot;)
      .attr(&quot;class&quot;, &quot;dot&quot;)
      .attr(&quot;clip-path&quot;, &quot;url(#clip)&quot;)  //add the clip to each dot
      .attr(&quot;r&quot;, 4.0) //3.5  4.5 3*zoom.scale()
      .attr(&quot;cx&quot;, function(d) { return x(+d[keys[xName]]); })
      .attr(&quot;cy&quot;, function(d) { return y(+d[keys[yName]]); })
      .style(&quot;fill&quot;, 'red' ) 
      .attr('fill-opacity', 0.6)
      .on(&quot;mouseover&quot;, function(d) { drawTooltip(d); })
      .on(&quot;mouseout&quot;, function() {
        div.style(&quot;opacity&quot;, 0);
      });

    svg.append(&quot;text&quot;)
        .attr(&quot;class&quot;, &quot;x label&quot;)
        .attr(&quot;text-anchor&quot;, &quot;middle&quot;)
        .attr(&quot;x&quot;, width/2)
        .attr(&quot;y&quot;, height + 30)
        .text(&quot;Democratic Lead, President 2016 (%)&quot;);

    svg.append(&quot;text&quot;)
        .attr(&quot;class&quot;, &quot;y label&quot;)
        .attr(&quot;text-anchor&quot;, &quot;middle&quot;)
        .attr(&quot;x&quot;, -height/2)
        .attr(&quot;y&quot;, -30) //-30
        .attr(&quot;transform&quot;, &quot;rotate(-90)&quot;)
        .text(&quot;Democratic Lead, Last Senate (%)&quot;);

    d3.selectAll(&quot;button[data-zoom]&quot;)
        .on(&quot;click&quot;, clicked);

    function zoomed() {
      svg.select(&quot;.x.axis&quot;).call(xAxis);
      svg.select(&quot;.y.axis&quot;).call(yAxis);

      //http://stackoverflow.com/questions/37573228
      svg.selectAll(&quot;.dot&quot;)
        //.attr(&quot;r&quot;, 3*zoom.scale())
        .attr(&quot;cx&quot;, function (d) {
            return x(+d[keys[xName]]);
        })
        .attr(&quot;cy&quot;, function (d) {
            return y(+d[keys[yName]]);
        });

        d3.selectAll('g.tick')
          .filter(function(d){ return d==0;} )
          .select('line') //grab the tick line
          .attr('id', 'main-tick');
    }

    function clicked() {
      svg.call(zoom.event); // https://github.com/mbostock/d3/issues/2387

      // Record the coordinates (in data space) of the center (in screen space).
      var center0 = zoom.center(), translate0 = zoom.translate(), coordinates0 = coordinates(center0);
      zoom.scale(zoom.scale() * Math.pow(2, +this.getAttribute(&quot;data-zoom&quot;)));

      // Translate back to the center.
      var center1 = point(coordinates0);
      zoom.translate([translate0[0] + center0[0] - center1[0], translate0[1] + center0[1] - center1[1]]);

      svg.transition().duration(750).call(zoom.event);

    }

    function coordinates(point) {
      var scale = zoom.scale(), translate = zoom.translate();
      return [(point[0] - translate[0]) / scale, (point[1] - translate[1]) / scale];
    }

    function point(coordinates) {
      var scale = zoom.scale(), translate = zoom.translate();
      return [coordinates[0] * scale + translate[0], coordinates[1] * scale + translate[1]];
    }

    function drawTooltip(d) {
        div.style(&quot;opacity&quot;, 1.0);
        div.html(
    '<b>Class:</b> '+ d[keys.class] + 
    '<br><b>State:</b> '+ d[keys.state] + 
    '<br><b>Name:</b> ' + d[keys.first] + ' ' + d[keys.last] + 
    '<br><b>President:</b> ' + d[keys.demlead_pres2016] + &quot;%&quot; + 
    '<br><b>Last Senate:</b> ' + d[keys.demlead_lastsenate] +&quot;%&quot; 
    )
            .style(&quot;left&quot;, (d3.event.pageX) + &quot;px&quot;)
            .style(&quot;top&quot;, (d3.event.pageY ) + &quot;px&quot;);
    }

    </script>
    </body>
    </html>
    " style="width: 960px; height: 600px; display:block; width: 100%; margin: 15px auto; border: none"></iframe>



## Close Senate Seats for Democrats

The Senate is a little different because voting happens every six years.  I order this by the sum of the Democratic lead in the 2016 presidential election and the Senator's lead in their last election.  A district could shift quite a bit during a Senator's term, so this sum should be taken with a grain of salt.  

These data make it clear that Senate Democrats have a very difficult election ahead in 2018. 

<iframe srcdoc="
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset=&quot;utf-8&quot;>
    <style>

    /*
    body {
        width: 800px;
    }*/

    table {
        font-size: 12px;
        border-collapse: collapse;
        border-top: 1px solid #ddd;
        border-right: 1px solid #ddd;
    }

    th {
        padding: 10px;
        cursor: pointer;
        background-color: #f2f2f2;
    }

    th, td {
        text-align: left;
        border-bottom: 1px solid #ddd;
        border-left: 1px solid #ddd;
    }

    td {
        padding: 5px 8px;
    }

    tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    tr:hover {
      background-color: #F0F8FF; /*#f9f9f9;*/
    }

    </style>
    </head>

    <body>

    <div id =&quot;tableInsert&quot;></div>

    <script>
    //http://stackoverflow.com/questions/14267781/sorting-html-table-with-javascript

    function sortTable(table, col, reverse) {
        var tb = table.tBodies[0], 
            tr = Array.prototype.slice.call(tb.rows, 0), // put rows into array
            i;

        reverse = -((+reverse) || -1);
        tr = tr.sort(function (a, b) { 
            var first = a.cells[col].textContent.trim();
            var second = b.cells[col].textContent.trim();

            if (isNumeric(first) &amp;&amp; isNumeric(second)) {        
                return reverse * (Number(first) - Number(second));
            } else {
                return reverse * first.localeCompare(second);
            };
        });
        for(i = 0; i < tr.length; ++i) {  // append each row in order
            tb.appendChild(tr[i]);
        }
    }

    //http://stackoverflow.com/questions/18082
    function isNumeric(n) {
      return !isNaN(parseFloat(n)) &amp;&amp; isFinite(n);
    }

    function makeSortable(table) {
        var th = table.tHead, i;
        th &amp;&amp; (th = th.rows[0]) &amp;&amp; (th = th.cells);
        if (th) i = th.length;
        else return; // if no `<thead>` then do nothing
        while (--i >= 0) (function (i) {
            var dir = 1;
            th[i].addEventListener('click', function () {sortTable(table, i, (dir = 1 - dir))});
        }(i));
    }

    function makeAllSortable(parent) {
        parent = parent || document.body;
        var t = parent.getElementsByTagName('table'), i = t.length;
        while (--i >= 0) makeSortable(t[i]);
    }

    function addTable() {
        var tableDiv = document.getElementById(&quot;tableInsert&quot;)
        var table = document.createElement('table')
        var tableHead = document.createElement('thead')
        var tableBody = document.createElement('tbody')

        table.appendChild(tableHead)
        table.appendChild(tableBody);

        var heading = [&quot;state&quot;, &quot;class&quot;, &quot;party&quot;, &quot;first&quot;, &quot;last&quot;, &quot;demlead_lastsenate&quot;, &quot;demlead_pres2016&quot;, &quot;sum&quot;, &quot;pvi_2016&quot;];
        var data = [[&quot;North Dakota&quot;,2012.0,&quot;Democratic&quot;,&quot;Heidi&quot;,&quot;Heitkamp&quot;,0.9,-35.73,-34.83,-20.85],[&quot;West Virginia&quot;,2012.0,&quot;Democratic&quot;,&quot;Joe&quot;,&quot;Manchin&quot;,24.1,-41.68,-17.57,-23.21],[&quot;Montana&quot;,2012.0,&quot;Democratic&quot;,&quot;Jon&quot;,&quot;Tester&quot;,3.72,-20.23,-16.51,-12.15],[&quot;Indiana&quot;,2012.0,&quot;Democratic&quot;,&quot;Joe&quot;,&quot;Donnelly&quot;,5.74,-19.01,-13.27,-11.02],[&quot;Missouri&quot;,2012.0,&quot;Democratic&quot;,&quot;Claire&quot;,&quot;McCaskill&quot;,15.7,-18.51,-2.81,-10.85],[&quot;Ohio&quot;,2012.0,&quot;Democratic&quot;,&quot;Sherrod&quot;,&quot;Brown&quot;,6.0,-8.07,-2.07,-5.31],[&quot;Wisconsin&quot;,2012.0,&quot;Democratic&quot;,&quot;Tammy&quot;,&quot;Baldwin&quot;,5.55,-0.76,4.78,-1.44],[&quot;Pennsylvania&quot;,2012.0,&quot;Democratic&quot;,&quot;Bob&quot;,&quot;Casey&quot;,9.1,-0.72,8.38,-1.42],[&quot;Virginia&quot;,2012.0,&quot;Democratic&quot;,&quot;Tim&quot;,&quot;Kaine&quot;,5.91,5.32,11.23,1.78],[&quot;Florida&quot;,2012.0,&quot;Democratic&quot;,&quot;Bill&quot;,&quot;Nelson&quot;,13.01,-1.19,11.82,-1.66],[&quot;New Mexico&quot;,2012.0,&quot;Democratic&quot;,&quot;Martin&quot;,&quot;Heinrich&quot;,5.73,8.21,13.94,3.61],[&quot;Michigan&quot;,2012.0,&quot;Democratic&quot;,&quot;Debbie&quot;,&quot;Stabenow&quot;,20.81,-0.22,20.59,-1.16],[&quot;Connecticut&quot;,2012.0,&quot;Democratic&quot;,&quot;Chris&quot;,&quot;Murphy&quot;,12.26,13.64,25.9,6.1],[&quot;New Jersey&quot;,2012.0,&quot;Democratic&quot;,&quot;Bob&quot;,&quot;Menendez&quot;,19.44,13.98,33.42,6.24],[&quot;Massachusetts&quot;,2012.0,&quot;Democratic&quot;,&quot;Elizabeth&quot;,&quot;Warren&quot;,7.55,27.2,34.75,13.61],[&quot;Minnesota&quot;,2012.0,&quot;Democratic&quot;,&quot;Amy&quot;,&quot;Klobuchar&quot;,34.7,1.51,36.22,-0.21],[&quot;Washington&quot;,2012.0,&quot;Democratic&quot;,&quot;Maria&quot;,&quot;Cantwell&quot;,20.9,15.71,36.61,7.74],[&quot;Rhode Island&quot;,2012.0,&quot;Democratic&quot;,&quot;Sheldon&quot;,&quot;Whitehouse&quot;,29.85,15.51,45.35,7.27],[&quot;Delaware&quot;,2012.0,&quot;Democratic&quot;,&quot;Tom&quot;,&quot;Carper&quot;,37.47,11.37,48.84,4.96],[&quot;California&quot;,2012.0,&quot;Democratic&quot;,&quot;Dianne&quot;,&quot;Feinstein&quot;,25.05,29.99,55.04,15.09],[&quot;Maryland&quot;,2012.0,&quot;Democratic&quot;,&quot;Ben&quot;,&quot;Cardin&quot;,29.65,26.42,56.07,12.97],[&quot;Hawaii&quot;,2012.0,&quot;Democratic&quot;,&quot;Mazie&quot;,&quot;Hirono&quot;,25.2,32.18,57.39,16.4],[&quot;New York&quot;,2012.0,&quot;Democratic&quot;,&quot;Kirsten&quot;,&quot;Gillibrand&quot;,45.88,22.48,68.36,10.05]];

        //TABLE HEAD
        var tr = document.createElement('tr');
        tableHead.appendChild(tr);
        for (i = 0; i < heading.length; i++) {
            var th = document.createElement('th')
            //th.width = '75';
            th.appendChild(document.createTextNode(heading[i]));
            tr.appendChild(th);
        }

        //TABLE ROWS
        for (i = 0; i < data.length; i++) {
            var tr = document.createElement('TR');
            for (j = 0; j < data[i].length; j++) {
                var td = document.createElement('TD')
                td.appendChild(document.createTextNode(data[i][j]));
                tr.appendChild(td)
            }
            tableBody.appendChild(tr);
        }  
        tableDiv.appendChild(table)

    }

    window.onload = function () {addTable(); makeAllSortable(); };
    // use callback makeAllSortable(); at end?
    // window.onload = function () {addTable(makeAllSortable);  };  

    </script>

    </body>
    </html>" style="width: 800px; height: 500px; 
            display:block; margin: 25px; border: none"></iframe>

            

## Close Senate Seat(s) for Republicans

Relative to the Democrats, Senate Republicans have an easier 2018.  Dean Heller's seat in Nevada is the only one in a state that was won by Clinton in 2016, and many of the other seats look pretty safe.


<iframe srcdoc="
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset=&quot;utf-8&quot;>
    <style>

    /*
    body {
        width: 800px;
    }*/

    table {
        font-size: 12px;
        border-collapse: collapse;
        border-top: 1px solid #ddd;
        border-right: 1px solid #ddd;
    }

    th {
        padding: 10px;
        cursor: pointer;
        background-color: #f2f2f2;
    }

    th, td {
        text-align: left;
        border-bottom: 1px solid #ddd;
        border-left: 1px solid #ddd;
    }

    td {
        padding: 5px 8px;
    }

    tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    tr:hover {
      background-color: #F0F8FF; /*#f9f9f9;*/
    }

    </style>
    </head>

    <body>

    <div id =&quot;tableInsert&quot;></div>

    <script>
    //http://stackoverflow.com/questions/14267781/sorting-html-table-with-javascript

    function sortTable(table, col, reverse) {
        var tb = table.tBodies[0], 
            tr = Array.prototype.slice.call(tb.rows, 0), // put rows into array
            i;

        reverse = -((+reverse) || -1);
        tr = tr.sort(function (a, b) { 
            var first = a.cells[col].textContent.trim();
            var second = b.cells[col].textContent.trim();

            if (isNumeric(first) && isNumeric(second)) {        
                return reverse * (Number(first) - Number(second));
            } else {
                return reverse * first.localeCompare(second);
            };
        });
        for(i = 0; i < tr.length; ++i) {  // append each row in order
            tb.appendChild(tr[i]);
        }
    }

    //http://stackoverflow.com/questions/18082
    function isNumeric(n) {
      return !isNaN(parseFloat(n)) && isFinite(n);
    }

    function makeSortable(table) {
        var th = table.tHead, i;
        th && (th = th.rows[0]) && (th = th.cells);
        if (th) i = th.length;
        else return; // if no `<thead>` then do nothing
        while (--i >= 0) (function (i) {
            var dir = 1;
            th[i].addEventListener('click', function () {sortTable(table, i, (dir = 1 - dir))});
        }(i));
    }

    function makeAllSortable(parent) {
        parent = parent || document.body;
        var t = parent.getElementsByTagName('table'), i = t.length;
        while (--i >= 0) makeSortable(t[i]);
    }

    function addTable() {
        var tableDiv = document.getElementById(&quot;tableInsert&quot;)
        var table = document.createElement('table')
        var tableHead = document.createElement('thead')
        var tableBody = document.createElement('tbody')

        table.appendChild(tableHead)
        table.appendChild(tableBody);

        var heading = [&quot;state&quot;, &quot;class&quot;, &quot;party&quot;, &quot;first&quot;, &quot;last&quot;, &quot;demlead_lastsenate&quot;, &quot;demlead_pres2016&quot;, &quot;sum&quot;, &quot;pvi_2016&quot;];
        var data = [[&quot;Nevada&quot;,2012.0,&quot;Republican&quot;,&quot;Dean&quot;,&quot;Heller&quot;,-1.16,2.42,1.26,0.25],[&quot;Arizona&quot;,2012.0,&quot;Republican&quot;,&quot;Jeff&quot;,&quot;Flake&quot;,-3.02,-3.5,-6.53,-2.93],[&quot;Texas&quot;,2012.0,&quot;Republican&quot;,&quot;Ted&quot;,&quot;Cruz&quot;,-15.83,-9.0,-24.83,-5.76],[&quot;Mississippi&quot;,2012.0,&quot;Republican&quot;,&quot;Roger&quot;,&quot;Wicker&quot;,-16.6,-17.8,-34.41,-10.14],[&quot;Nebraska&quot;,2012.0,&quot;Republican&quot;,&quot;Deb&quot;,&quot;Fischer&quot;,-15.55,-25.05,-40.6,-14.59],[&quot;Utah&quot;,2012.0,&quot;Republican&quot;,&quot;Orrin&quot;,&quot;Hatch&quot;,-35.33,-17.89,-53.22,-13.43],[&quot;Tennessee&quot;,2012.0,&quot;Republican&quot;,&quot;Bob&quot;,&quot;Corker&quot;,-34.48,-26.01,-60.49,-14.68],[&quot;Wyoming&quot;,2012.0,&quot;Republican&quot;,&quot;John&quot;,&quot;Barrasso&quot;,-54.0,-46.3,-100.3,-26.75]];

        //TABLE HEAD
        var tr = document.createElement('tr');
        tableHead.appendChild(tr);
        for (i = 0; i < heading.length; i++) {
            var th = document.createElement('th')
            //th.width = '75';
            th.appendChild(document.createTextNode(heading[i]));
            tr.appendChild(th);
        }

        //TABLE ROWS
        for (i = 0; i < data.length; i++) {
            var tr = document.createElement('TR');
            for (j = 0; j < data[i].length; j++) {
                var td = document.createElement('TD')
                td.appendChild(document.createTextNode(data[i][j]));
                tr.appendChild(td)
            }
            tableBody.appendChild(tr);
        }  
        tableDiv.appendChild(table)

    }

    window.onload = function () {addTable(); makeAllSortable(); };
    // use callback makeAllSortable(); at end?
    // window.onload = function () {addTable(makeAllSortable);  };  

    </script>

    </body>
    </html>" style="width: 725px; height: 275px; display:block; margin: 45px 0px; border: none"></iframe>
            

So it seems clear that the Senate is much more difficult for Democrats, but who knows what will happen if Trump's popularity rating keeps going south.
 

## Special Elections Update - 2018

As an early 2018 follow up, I thought it would make sense to see how some special elections are going.  I found this [great dataset](https://docs.google.com/spreadsheets/d/1C2MVeM2K7WgqmJw5RCQbWyTo2u73CX1pI8zw_G-7BJo) collected by The Daily Kos that includes every special election post Trump:   

<iframe srcdoc="
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset=&quot;utf-8&quot;>
    <style>

    /*
    body {
        width: 800px;
    }*/

    table {
        font-size: 12px;
        border-collapse: collapse;
        border-top: 1px solid #ddd;
        border-right: 1px solid #ddd;
    }

    th {
        padding: 10px;
        cursor: pointer;
        background-color: #f2f2f2;
    }

    th, td {
        text-align: left;
        border-bottom: 1px solid #ddd;
        border-left: 1px solid #ddd;
    }

    td {
        padding: 5px 8px;
    }

    tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    tr:hover {
      background-color: #F0F8FF; /*#f9f9f9;*/
    }

    </style>
    </head>

    <body>

    <div id =&quot;tableInsert&quot;></div>

    <script>
    //http://stackoverflow.com/questions/14267781/sorting-html-table-with-javascript

    function sortTable(table, col, reverse) {
        var tb = table.tBodies[0], 
            tr = Array.prototype.slice.call(tb.rows, 0), // put rows into array
            i;

        reverse = -((+reverse) || -1);
        tr = tr.sort(function (a, b) { 
            var first = a.cells[col].textContent.trim();
            var second = b.cells[col].textContent.trim();

            if (isNumeric(first) &amp;&amp; isNumeric(second)) {        
                return reverse * (Number(first) - Number(second));
            } else {
                return reverse * first.localeCompare(second);
            };
        });
        for(i = 0; i < tr.length; ++i) {  // append each row in order
            tb.appendChild(tr[i]);
        }
    }

    //http://stackoverflow.com/questions/18082
    function isNumeric(n) {
      return !isNaN(parseFloat(n)) &amp;&amp; isFinite(n);
    }

    function makeSortable(table) {
        var th = table.tHead, i;
        th &amp;&amp; (th = th.rows[0]) &amp;&amp; (th = th.cells);
        if (th) i = th.length;
        else return; // if no `<thead>` then do nothing
        while (--i >= 0) (function (i) {
            var dir = 1;
            th[i].addEventListener('click', function () {sortTable(table, i, (dir = 1 - dir))});
        }(i));
    }

    function makeAllSortable(parent) {
        parent = parent || document.body;
        var t = parent.getElementsByTagName('table'), i = t.length;
        while (--i >= 0) makeSortable(t[i]);
    }

    function addTable() {
        var tableDiv = document.getElementById(&quot;tableInsert&quot;)
        var table = document.createElement('table')
        var tableHead = document.createElement('thead')
        var tableBody = document.createElement('tbody')

        table.appendChild(tableHead)
        table.appendChild(tableBody);

        var heading = [&quot;date&quot;, &quot;state&quot;, &quot;district&quot;, &quot;incumbent&quot;, &quot;winner&quot;, &quot;dem&quot;, &quot;rep&quot;, &quot;dem_margin&quot;, &quot;clinton&quot;, &quot;trump&quot;, &quot;clinton_margin&quot;, &quot;margin-dif&quot;];
        var data = [[&quot;02-20-2018&quot;,&quot;KY&quot;,&quot;HD-49&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.6845,0.3155,0.369,0.2327,0.7225,-0.4898,0.8588],[&quot;02-06-2018&quot;,&quot;MO&quot;,&quot;HD-144&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.47376,0.52624,-0.05248,0.1914,0.7784,-0.587,0.53452],[&quot;05-09-2017&quot;,&quot;OK&quot;,&quot;HD-28&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4816,0.5048,-0.0232,0.23,0.73,-0.5,0.4768],[&quot;12-19-2017&quot;,&quot;TN&quot;,&quot;SD-17&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4868,0.5132,-0.0264,0.2375,0.7222,-0.4847,0.4583],[&quot;11-14-2017&quot;,&quot;OK&quot;,&quot;SD-37&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5035,0.4965,0.007,0.2745,0.6675,-0.393,0.4],[&quot;05-23-2017&quot;,&quot;NY&quot;,&quot;AD-09&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5791,0.4195,0.1596,0.37,0.6,-0.23,0.3896],[&quot;02-13-2018&quot;,&quot;OK&quot;,&quot;SD-27&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3203,0.6797,-0.3594,0.1132,0.8421,-0.7289,0.3695],[&quot;01-31-2017&quot;,&quot;IA&quot;,&quot;HD-89&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.7246,0.2723,0.4523,0.52,0.41,0.11,0.3423],[&quot;09-26-2017&quot;,&quot;SC&quot;,&quot;HD-31&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.908,0.09,0.818,0.72,0.24,0.48,0.338],[&quot;07-18-2017&quot;,&quot;NH&quot;,&quot;HD-Merrimack-18&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.776,0.224,0.552,0.59,0.37,0.22,0.332],[&quot;12-12-2017&quot;,&quot;IA&quot;,&quot;SD-03&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4533,0.5451,-0.092,0.27,0.68,-0.41,0.32],[&quot;09-12-2017&quot;,&quot;OK&quot;,&quot;HD-46&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.6041,0.3959,0.2082,0.4133,0.5165,-0.1032,0.3114],[&quot;02-06-2018&quot;,&quot;MO&quot;,&quot;HD-97&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.51558,0.48442,0.03116,0.3331,0.6114,-0.2783,0.30946],[&quot;12-27-2016&quot;,&quot;IA&quot;,&quot;SD-45&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.7319,0.2531,0.4788,0.55,0.38,0.17,0.3088],[&quot;08-08-2017&quot;,&quot;IA&quot;,&quot;HD-82&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.5379,0.4448,0.0931,0.37,0.58,-0.21,0.3031],[&quot;12-12-2017&quot;,&quot;AL&quot;,&quot;AL-Sen&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.4997,0.4834,0.0163,0.3436,0.6208,-0.2772,0.2935],[&quot;01-23-2018&quot;,&quot;PA&quot;,&quot;HD-35&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.7363,0.2598,0.4765,0.5789,0.3941,0.1848,0.2917],[&quot;12-05-2017&quot;,&quot;PA&quot;,&quot;HD-133&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.6755,0.2906,0.3849,0.53,0.43,0.1,0.2849],[&quot;02-27-2018&quot;,&quot;KY&quot;,&quot;HD-89&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3324,0.6675,-0.3351,0.173,0.7899,-0.6169,0.2818],[&quot;07-11-2017&quot;,&quot;OK&quot;,&quot;SD-44&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5457,0.4543,0.0914,0.37,0.56,-0.19,0.2814],[&quot;09-12-2017&quot;,&quot;NH&quot;,&quot;HD-Belknap-09&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5567,0.4433,0.1134,0.3917,0.5561,-0.1644,0.2778],[&quot;01-16-2018&quot;,&quot;WI&quot;,&quot;SD-10&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.546,0.4416,0.1044,0.3805,0.553,-0.1725,0.2769],[&quot;07-11-2017&quot;,&quot;OK&quot;,&quot;HD-75&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5232,0.4768,0.0464,0.36,0.58,-0.22,0.2664],[&quot;11-14-2017&quot;,&quot;OK&quot;,&quot;SD-45&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4322,0.5678,-0.1356,0.269,0.6662,-0.3972,0.2616],[&quot;11-07-2017&quot;,&quot;MO&quot;,&quot;HD-151&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.2724,0.7045,-0.4321,0.1415,0.8322,-0.6907,0.2586],[&quot;02-06-2018&quot;,&quot;MO&quot;,&quot;HD-129&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.30905,0.69095,-0.3819,0.1636,0.8003,-0.6367,0.2548],[&quot;09-26-2017&quot;,&quot;NH&quot;,&quot;HD-Rockingham-04&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.4994,0.4778,0.0216,0.36,0.59,-0.23,0.2516],[&quot;01-16-2018&quot;,&quot;WI&quot;,&quot;AD-58&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4337,0.5656,-0.1319,0.2843,0.6652,-0.3809,0.249],[&quot;02-14-2017&quot;,&quot;MN&quot;,&quot;HD-32B&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4673,0.5322,-0.0649,0.315,0.6069,-0.2919,0.227],[&quot;11-07-2017&quot;,&quot;SC&quot;,&quot;HD-113&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.809,0.19,0.619,0.6701,0.2772,0.3929,0.2261],[&quot;10-24-2017&quot;,&quot;NH&quot;,&quot;HD-Strafford-13&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.78,0.1443,0.6357,0.67,0.26,0.41,0.2257],[&quot;01-16-2018&quot;,&quot;IA&quot;,&quot;HD-06&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4426,0.5564,-0.1138,0.309,0.6436,-0.3346,0.2208],[&quot;04-11-2017&quot;,&quot;KS&quot;,&quot;KS-04&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4603,0.5224,-0.0621,0.33,0.6,-0.27,0.2079],[&quot;02-27-2018&quot;,&quot;NH&quot;,&quot;HD-Belknap-3&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5351,0.4649,0.0702,0.4117,0.5363,-0.1246,0.1948],[&quot;08-08-2017&quot;,&quot;MO&quot;,&quot;SD-28&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3172,0.6828,-0.3656,0.2,0.76,-0.56,0.1944],[&quot;11-07-2017&quot;,&quot;MI&quot;,&quot;HD-109&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.5648,0.4218,0.143,0.4475,0.4882,-0.0407,0.1837],[&quot;02-06-2018&quot;,&quot;MO&quot;,&quot;HD-39&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.35674,0.64326,-0.28652,0.2445,0.7095,-0.465,0.17848],[&quot;08-08-2017&quot;,&quot;MO&quot;,&quot;HD-50&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4792,0.5208,-0.0416,0.37,0.58,-0.21,0.1684],[&quot;11-07-2017&quot;,&quot;MA&quot;,&quot;HD-1st Berkshire&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.7429,0.2208,0.5221,0.648,0.2891,0.3589,0.1632],[&quot;06-20-2017&quot;,&quot;SC&quot;,&quot;SC-05&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4794,0.5104,-0.031,0.39,0.57,-0.18,0.149],[&quot;05-25-2017&quot;,&quot;MT&quot;,&quot;MT-AL&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4437,0.4995,-0.0558,0.3541,0.5565,-0.2024,0.1466],[&quot;05-31-2017&quot;,&quot;SC&quot;,&quot;HD-84&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3788,0.5853,-0.2065,0.31,0.65,-0.34,0.1335],[&quot;06-20-2017&quot;,&quot;SC&quot;,&quot;HD-70&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.7807,0.2183,0.5624,0.7,0.27,0.43,0.1324],[&quot;11-07-2017&quot;,&quot;MO&quot;,&quot;SD-08&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4258,0.5035,-0.0777,0.3685,0.5744,-0.2059,0.1282],[&quot;06-15-2017&quot;,&quot;TN&quot;,&quot;HD-95&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3469,0.6189,-0.272,0.285,0.678,-0.393,0.121],[&quot;02-13-2018&quot;,&quot;FL&quot;,&quot;HD-72&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5217,0.448,0.0737,0.4603,0.5071,-0.0468,0.1205],[&quot;09-05-2017&quot;,&quot;NH&quot;,&quot;HD-Grafton-09&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4695,0.5113,-0.0418,0.4,0.55,-0.15,0.1082],[&quot;02-28-2017&quot;,&quot;CT&quot;,&quot;HD-115&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.6435,0.3565,0.287,0.57,0.39,0.18,0.107],[&quot;11-07-2017&quot;,&quot;NH&quot;,&quot;HD-Hillsborough-15&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5042,0.4958,0.0084,0.4288,0.5266,-0.0978,0.1062],[&quot;05-23-2017&quot;,&quot;NH&quot;,&quot;HD-Carroll-06&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5176,0.4818,0.0358,0.44,0.51,-0.07,0.1058],[&quot;07-25-2017&quot;,&quot;NH&quot;,&quot;SD-16&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.5475,0.44,0.1075,0.4769,0.4737,0.0032,0.1043],[&quot;11-07-2017&quot;,&quot;NH&quot;,&quot;HD-Sullivan-01&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.659,0.341,0.318,0.5858,0.3697,0.2161,0.1019],[&quot;01-16-2018&quot;,&quot;SC&quot;,&quot;HD-99&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4335,0.5643,-0.1308,0.3535,0.5814,-0.2279,0.0971],[&quot;11-07-2017&quot;,&quot;GA&quot;,&quot;HD-117&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5313,0.4688,0.0625,0.4606,0.4944,-0.0338,0.0963],[&quot;02-28-2017&quot;,&quot;CT&quot;,&quot;SD-32&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4423,0.5383,-0.096,0.39,0.57,-0.18,0.084],[&quot;02-12-2018&quot;,&quot;MN&quot;,&quot;HD-23B&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3992,0.5922,-0.193,0.327,0.5947,-0.2677,0.0747],[&quot;11-07-2017&quot;,&quot;ME&quot;,&quot;HD-56&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.42,0.58,-0.16,0.3542,0.57,-0.2158,0.0558],[&quot;02-12-2018&quot;,&quot;MN&quot;,&quot;SD-54&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.5072,0.4707,0.0365,0.4474,0.4616,-0.0142,0.0507],[&quot;02-25-2017&quot;,&quot;DE&quot;,&quot;SD-10&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.5814,0.4075,0.1739,0.54,0.41,0.13,0.0439],[&quot;06-20-2017&quot;,&quot;SC&quot;,&quot;HD-48&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3925,0.606,-0.2135,0.35,0.59,-0.24,0.0265],[&quot;01-10-2017&quot;,&quot;VA&quot;,&quot;SD-22&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3957,0.5307,-0.135,0.4056,0.5481,-0.1425,0.0075],[&quot;05-16-2017&quot;,&quot;GA&quot;,&quot;SD-32&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4302,0.5698,-0.1396,0.4042,0.5449,-0.1407,0.0011],[&quot;11-07-2017&quot;,&quot;WA&quot;,&quot;HD-07a&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3253,0.6747,-0.3494,0.29,0.6345,-0.3445,-0.0049],[&quot;02-27-2018&quot;,&quot;CT&quot;,&quot;HD-120&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.50818,0.49181,0.01637,0.49,0.4686,0.0214,-0.00503],[&quot;05-23-2017&quot;,&quot;NY&quot;,&quot;SD-30&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.9162,0.0272,0.889,0.94,0.04,0.9,-0.011],[&quot;05-23-2017&quot;,&quot;NH&quot;,&quot;HD-Hillsborough-44&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4493,0.5507,-0.1014,0.43,0.52,-0.09,-0.0114],[&quot;11-14-2017&quot;,&quot;OK&quot;,&quot;HD-76&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3165,0.6835,-0.367,0.296,0.6451,-0.3491,-0.0179],[&quot;11-07-2017&quot;,&quot;MO&quot;,&quot;HD-23&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.8795,0.0911,0.7884,0.8879,0.079,0.8089,-0.0205],[&quot;11-07-2017&quot;,&quot;WA&quot;,&quot;SD-07&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3167,0.6833,-0.3666,0.29,0.6345,-0.3445,-0.0221],[&quot;06-20-2017&quot;,&quot;GA&quot;,&quot;GA-06&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4822,0.5178,-0.0356,0.47,0.48,-0.01,-0.0256],[&quot;11-07-2017&quot;,&quot;NY&quot;,&quot;SD-26&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.8486,0.1468,0.7018,0.8508,0.1183,0.7325,-0.0307],[&quot;11-07-2017&quot;,&quot;MI&quot;,&quot;HD-01&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.7158,0.2513,0.4645,0.7449,0.2285,0.5164,-0.0519],[&quot;01-10-2017&quot;,&quot;VA&quot;,&quot;HD-85&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4705,0.5284,-0.0579,0.4651,0.4706,-0.0055,-0.0524],[&quot;11-07-2017&quot;,&quot;WA&quot;,&quot;SD-31&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4294,0.5706,-0.1412,0.4161,0.5016,-0.0855,-0.0557],[&quot;11-07-2017&quot;,&quot;WA&quot;,&quot;HD-31b&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4289,0.5711,-0.1422,0.4161,0.5016,-0.0855,-0.0567],[&quot;10-17-2017&quot;,&quot;MA&quot;,&quot;SD-Bristol &amp; Norfolk&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.473,0.4338,0.0392,0.5248,0.4116,0.1132,-0.074],[&quot;11-07-2017&quot;,&quot;UT&quot;,&quot;UT-03&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.2558,0.5802,-0.3244,0.2327,0.4718,-0.2391,-0.0853],[&quot;11-07-2017&quot;,&quot;MA&quot;,&quot;HD-3rd Essex&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.5317,0.465,0.0667,0.5468,0.3944,0.1524,-0.0857],[&quot;08-22-2017&quot;,&quot;RI&quot;,&quot;SD-13&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.6116,0.3611,0.2505,0.65,0.3,0.35,-0.0995],[&quot;12-19-2017&quot;,&quot;FL&quot;,&quot;HD-58&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3383,0.5447,-0.2064,0.43,0.53,-0.1,-0.1064],[&quot;12-05-2017&quot;,&quot;MA&quot;,&quot;SD-Worcester &amp; Middlesex&quot;,&quot;(D)&quot;,&quot;(R)&quot;,0.4245,0.4633,-0.0388,0.5,0.42,0.08,-0.1188],[&quot;09-26-2017&quot;,&quot;FL&quot;,&quot;SD-40&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5095,0.4721,0.0374,0.58,0.4,0.18,-0.1426],[&quot;10-10-2017&quot;,&quot;FL&quot;,&quot;HD-44&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4434,0.5566,-0.1132,0.51,0.45,0.06,-0.1732],[&quot;02-28-2017&quot;,&quot;CT&quot;,&quot;SD-02&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.7175,0.2449,0.4726,0.83,0.14,0.69,-0.2174],[&quot;04-25-2017&quot;,&quot;CT&quot;,&quot;HD-68&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.2192,0.7808,-0.5616,0.32,0.65,-0.33,-0.2316],[&quot;11-07-2017&quot;,&quot;WA&quot;,&quot;SD-45&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5542,0.4458,0.1084,0.648,0.2803,0.3677,-0.2593],[&quot;09-26-2017&quot;,&quot;FL&quot;,&quot;HD-116&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3419,0.6581,-0.3162,0.51,0.46,0.05,-0.3662]];

        //TABLE HEAD
        var tr = document.createElement('tr');
        tableHead.appendChild(tr);
        for (i = 0; i < heading.length; i++) {
            var th = document.createElement('th')
            //th.width = '75';
            th.appendChild(document.createTextNode(heading[i]));
            tr.appendChild(th);
        }

        //TABLE ROWS
        for (i = 0; i < data.length; i++) {
            var tr = document.createElement('TR');
            for (j = 0; j < data[i].length; j++) {
                var td = document.createElement('TD')
                td.appendChild(document.createTextNode(data[i][j]));
                tr.appendChild(td)
            }
            tableBody.appendChild(tr);
        }  
        tableDiv.appendChild(table)

    }

    window.onload = function () {addTable(); makeAllSortable(); };
    // use callback makeAllSortable(); at end?
    // window.onload = function () {addTable(makeAllSortable);  };  

    </script>

    </body>
    </html>" style="width: 850px; height: 500px; display:block; margin: 25px 10px; border: none"></iframe>
    
    
This scatterplot one shows the Democratic margin in the special election plotted against the Democratic margin for the 2016 presidential election.  Seats in the bottom right quadrant were lost by Republicans, while points in the top left were lost by Democrats.  As you can see, there are many more that have switched D -> R than R -> D, some by huge margins ([Kentucky HD-49](https://www.ourcampaigns.com/RaceDetail.html?RaceID=841294)). 


<iframe srcdoc="
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset=&quot;utf-8&quot;>
    <title>Zoom + Pan</title>
    <style>
    
    body {
      position: relative;
      width: 650px; /*960px*/
    }

    svg {font: 10px sans-serif;}

    rect {fill: #e5e5e5; }

    .label {
        font-size: 12px;
        /*stroke: #ddd;*/
        fill: #555;
    }

    .dot {
      stroke: #aaa;
      stroke-width: 0.5px;
      /*stroke: red;*/
      /*border: 1;*/
    }
    .dot:hover {fill-opacity: 0.4;}

    .axis path,
    .axis line {
      stroke: #fff; /*black;*/
      fill: none; 
      stroke-width: 1px;
    }
    
    #main-tick{
      fill: none;
      stroke: #777;  
      stroke-width: 1px;
      opacity: 1;
    }

    .buttons {
      position: absolute;
      right: 30px;
      top: 30px;
    }
    button {
      font: 16px sans-serif;
      display: block;
      border-radius: 0px;
      width: 25px;
      /*outline: none;*/
      /*outline:0;*/
      background-color: white;
      border: none;
    }
    
    button:hover {
      background-image:none;
      background-color:#d5d5d5;
    }
    
    button:focus{ 
    /*outline-color: #ddd;
    outline:none;
    outline: 1;*/
    outline-color: #b5b5b5;
    }
    
    div.tooltip {
      position: absolute;
      padding: 5px;
      font: 12px sans-serif;
      background: white;
      border: 0px;
      border-radius: 0px;
      pointer-events:none;
    }

    </style>
    </head>
    <body>
    
    <div class=&quot;buttons&quot;>
      <button data-zoom=&quot;+1&quot;>+</button>
      <button data-zoom=&quot;-1&quot;>-</button>
    </div>
    <script src=&quot;//d3js.org/d3.v3.min.js&quot;></script>
    <script>

    var margin = {top: 20, right: 20, bottom: 40, left: 40},  //40, 40
        width = 650 - margin.left - margin.right,  //650
        height = 515 - margin.top - margin.bottom;

    var keys = {&quot;clinton_margin&quot;: 10, &quot;margin-dif&quot;: 11, &quot;state&quot;: 1, &quot;date&quot;: 0, &quot;incumbent&quot;: 3, &quot;dem&quot;: 5, &quot;rep&quot;: 6, &quot;clinton&quot;: 8, &quot;winner&quot;: 4, &quot;district&quot;: 2, &quot;trump&quot;: 9, &quot;dem_margin&quot;: 7};
    var data = [[&quot;12-19-2017&quot;,&quot;FL&quot;,&quot;HD-58&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3383,0.5447,-0.2064,0.43,0.53,-0.1,-0.1064],[&quot;12-19-2017&quot;,&quot;TN&quot;,&quot;SD-17&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4868,0.5132,-0.0264,0.2375,0.7222,-0.4847,0.4583],[&quot;12-12-2017&quot;,&quot;AL&quot;,&quot;AL-Sen&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.4997,0.4834,0.0163,0.3436,0.6208,-0.2772,0.2935],[&quot;12-12-2017&quot;,&quot;IA&quot;,&quot;SD-03&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4533,0.5451,-0.092,0.27,0.68,-0.41,0.32],[&quot;12-05-2017&quot;,&quot;MA&quot;,&quot;SD-Worcester &amp; Middlesex&quot;,&quot;(D)&quot;,&quot;(R)&quot;,0.4245,0.4633,-0.0388,0.5,0.42,0.08,-0.1188],[&quot;12-05-2017&quot;,&quot;PA&quot;,&quot;HD-133&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.6755,0.2906,0.3849,0.53,0.43,0.1,0.2849],[&quot;11-14-2017&quot;,&quot;OK&quot;,&quot;SD-37&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5035,0.4965,0.007,0.2745,0.6675,-0.393,0.4],[&quot;11-14-2017&quot;,&quot;OK&quot;,&quot;SD-45&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4322,0.5678,-0.1356,0.269,0.6662,-0.3972,0.2616],[&quot;11-14-2017&quot;,&quot;OK&quot;,&quot;HD-76&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3165,0.6835,-0.367,0.296,0.6451,-0.3491,-0.0179],[&quot;11-07-2017&quot;,&quot;UT&quot;,&quot;UT-03&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.2558,0.5802,-0.3244,0.2327,0.4718,-0.2391,-0.0853],[&quot;11-07-2017&quot;,&quot;GA&quot;,&quot;HD-117&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5313,0.4688,0.0625,0.4606,0.4944,-0.0338,0.0963],[&quot;11-07-2017&quot;,&quot;MA&quot;,&quot;HD-1st Berkshire&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.7429,0.2208,0.5221,0.648,0.2891,0.3589,0.1632],[&quot;11-07-2017&quot;,&quot;MA&quot;,&quot;HD-3rd Essex&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.5317,0.465,0.0667,0.5468,0.3944,0.1524,-0.0857],[&quot;11-07-2017&quot;,&quot;ME&quot;,&quot;HD-56&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.42,0.58,-0.16,0.3542,0.57,-0.2158,0.0558],[&quot;11-07-2017&quot;,&quot;MI&quot;,&quot;HD-01&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.7158,0.2513,0.4645,0.7449,0.2285,0.5164,-0.0519],[&quot;11-07-2017&quot;,&quot;MI&quot;,&quot;HD-109&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.5648,0.4218,0.143,0.4475,0.4882,-0.0407,0.1837],[&quot;11-07-2017&quot;,&quot;MO&quot;,&quot;HD-151&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.2724,0.7045,-0.4321,0.1415,0.8322,-0.6907,0.2586],[&quot;11-07-2017&quot;,&quot;MO&quot;,&quot;HD-23&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.8795,0.0911,0.7884,0.8879,0.079,0.8089,-0.0205],[&quot;11-07-2017&quot;,&quot;MO&quot;,&quot;SD-08&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4258,0.5035,-0.0777,0.3685,0.5744,-0.2059,0.1282],[&quot;11-07-2017&quot;,&quot;NH&quot;,&quot;HD-Hillsborough-15&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5042,0.4958,0.0084,0.4288,0.5266,-0.0978,0.1062],[&quot;11-07-2017&quot;,&quot;NH&quot;,&quot;HD-Sullivan-01&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.659,0.341,0.318,0.5858,0.3697,0.2161,0.1019],[&quot;11-07-2017&quot;,&quot;NY&quot;,&quot;SD-26&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.8486,0.1468,0.7018,0.8508,0.1183,0.7325,-0.0307],[&quot;11-07-2017&quot;,&quot;SC&quot;,&quot;HD-113&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.809,0.19,0.619,0.6701,0.2772,0.3929,0.2261],[&quot;11-07-2017&quot;,&quot;WA&quot;,&quot;HD-31b&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4289,0.5711,-0.1422,0.4161,0.5016,-0.0855,-0.0567],[&quot;11-07-2017&quot;,&quot;WA&quot;,&quot;HD-07a&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3253,0.6747,-0.3494,0.29,0.6345,-0.3445,-0.0049],[&quot;11-07-2017&quot;,&quot;WA&quot;,&quot;SD-31&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4294,0.5706,-0.1412,0.4161,0.5016,-0.0855,-0.0557],[&quot;11-07-2017&quot;,&quot;WA&quot;,&quot;SD-45&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5542,0.4458,0.1084,0.648,0.2803,0.3677,-0.2593],[&quot;11-07-2017&quot;,&quot;WA&quot;,&quot;SD-07&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3167,0.6833,-0.3666,0.29,0.6345,-0.3445,-0.0221],[&quot;10-24-2017&quot;,&quot;NH&quot;,&quot;HD-Strafford-13&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.78,0.1443,0.6357,0.67,0.26,0.41,0.2257],[&quot;10-17-2017&quot;,&quot;MA&quot;,&quot;SD-Bristol &amp; Norfolk&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.473,0.4338,0.0392,0.5248,0.4116,0.1132,-0.074],[&quot;10-10-2017&quot;,&quot;FL&quot;,&quot;HD-44&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4434,0.5566,-0.1132,0.51,0.45,0.06,-0.1732],[&quot;09-26-2017&quot;,&quot;FL&quot;,&quot;SD-40&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5095,0.4721,0.0374,0.58,0.4,0.18,-0.1426],[&quot;09-26-2017&quot;,&quot;FL&quot;,&quot;HD-116&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3419,0.6581,-0.3162,0.51,0.46,0.05,-0.3662],[&quot;09-26-2017&quot;,&quot;NH&quot;,&quot;HD-Rockingham-04&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.4994,0.4778,0.0216,0.36,0.59,-0.23,0.2516],[&quot;09-26-2017&quot;,&quot;SC&quot;,&quot;HD-31&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.908,0.09,0.818,0.72,0.24,0.48,0.338],[&quot;09-12-2017&quot;,&quot;OK&quot;,&quot;HD-46&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.6041,0.3959,0.2082,0.4133,0.5165,-0.1032,0.3114],[&quot;09-12-2017&quot;,&quot;NH&quot;,&quot;HD-Belknap-09&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5567,0.4433,0.1134,0.3917,0.5561,-0.1644,0.2778],[&quot;09-05-2017&quot;,&quot;NH&quot;,&quot;HD-Grafton-09&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4695,0.5113,-0.0418,0.4,0.55,-0.15,0.1082],[&quot;08-22-2017&quot;,&quot;RI&quot;,&quot;SD-13&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.6116,0.3611,0.2505,0.65,0.3,0.35,-0.0995],[&quot;08-08-2017&quot;,&quot;IA&quot;,&quot;HD-82&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.5379,0.4448,0.0931,0.37,0.58,-0.21,0.3031],[&quot;08-08-2017&quot;,&quot;MO&quot;,&quot;SD-28&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3172,0.6828,-0.3656,0.2,0.76,-0.56,0.1944],[&quot;08-08-2017&quot;,&quot;MO&quot;,&quot;HD-50&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4792,0.5208,-0.0416,0.37,0.58,-0.21,0.1684],[&quot;07-25-2017&quot;,&quot;NH&quot;,&quot;SD-16&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.5475,0.44,0.1075,0.4769,0.4737,0.0032,0.1043],[&quot;07-18-2017&quot;,&quot;NH&quot;,&quot;HD-Merrimack-18&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.776,0.224,0.552,0.59,0.37,0.22,0.332],[&quot;07-11-2017&quot;,&quot;OK&quot;,&quot;SD-44&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5457,0.4543,0.0914,0.37,0.56,-0.19,0.2814],[&quot;07-11-2017&quot;,&quot;OK&quot;,&quot;HD-75&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5232,0.4768,0.0464,0.36,0.58,-0.22,0.2664],[&quot;06-20-2017&quot;,&quot;GA&quot;,&quot;GA-06&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4822,0.5178,-0.0356,0.47,0.48,-0.01,-0.0256],[&quot;06-20-2017&quot;,&quot;SC&quot;,&quot;SC-05&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4794,0.5104,-0.031,0.39,0.57,-0.18,0.149],[&quot;06-20-2017&quot;,&quot;SC&quot;,&quot;HD-48&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3925,0.606,-0.2135,0.35,0.59,-0.24,0.0265],[&quot;06-20-2017&quot;,&quot;SC&quot;,&quot;HD-70&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.7807,0.2183,0.5624,0.7,0.27,0.43,0.1324],[&quot;06-15-2017&quot;,&quot;TN&quot;,&quot;HD-95&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3469,0.6189,-0.272,0.285,0.678,-0.393,0.121],[&quot;05-31-2017&quot;,&quot;SC&quot;,&quot;HD-84&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3788,0.5853,-0.2065,0.31,0.65,-0.34,0.1335],[&quot;05-25-2017&quot;,&quot;MT&quot;,&quot;MT-AL&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4437,0.4995,-0.0558,0.3541,0.5565,-0.2024,0.1466],[&quot;05-23-2017&quot;,&quot;NH&quot;,&quot;HD-Carroll-06&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5176,0.4818,0.0358,0.44,0.51,-0.07,0.1058],[&quot;05-23-2017&quot;,&quot;NH&quot;,&quot;HD-Hillsborough-44&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4493,0.5507,-0.1014,0.43,0.52,-0.09,-0.0114],[&quot;05-23-2017&quot;,&quot;NY&quot;,&quot;SD-30&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.9162,0.0272,0.889,0.94,0.04,0.9,-0.011],[&quot;05-23-2017&quot;,&quot;NY&quot;,&quot;AD-09&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5791,0.4195,0.1596,0.37,0.6,-0.23,0.3896],[&quot;05-16-2017&quot;,&quot;GA&quot;,&quot;SD-32&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4302,0.5698,-0.1396,0.4042,0.5449,-0.1407,0.0011],[&quot;05-09-2017&quot;,&quot;OK&quot;,&quot;HD-28&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4816,0.5048,-0.0232,0.23,0.73,-0.5,0.4768],[&quot;04-25-2017&quot;,&quot;CT&quot;,&quot;HD-68&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.2192,0.7808,-0.5616,0.32,0.65,-0.33,-0.2316],[&quot;04-11-2017&quot;,&quot;KS&quot;,&quot;KS-04&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4603,0.5224,-0.0621,0.33,0.6,-0.27,0.2079],[&quot;02-28-2017&quot;,&quot;CT&quot;,&quot;SD-02&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.7175,0.2449,0.4726,0.83,0.14,0.69,-0.2174],[&quot;02-28-2017&quot;,&quot;CT&quot;,&quot;SD-32&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4423,0.5383,-0.096,0.39,0.57,-0.18,0.084],[&quot;02-28-2017&quot;,&quot;CT&quot;,&quot;HD-115&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.6435,0.3565,0.287,0.57,0.39,0.18,0.107],[&quot;02-25-2017&quot;,&quot;DE&quot;,&quot;SD-10&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.5814,0.4075,0.1739,0.54,0.41,0.13,0.0439],[&quot;02-14-2017&quot;,&quot;MN&quot;,&quot;HD-32B&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4673,0.5322,-0.0649,0.315,0.6069,-0.2919,0.227],[&quot;01-31-2017&quot;,&quot;IA&quot;,&quot;HD-89&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.7246,0.2723,0.4523,0.52,0.41,0.11,0.3423],[&quot;01-10-2017&quot;,&quot;VA&quot;,&quot;SD-22&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3957,0.5307,-0.135,0.4056,0.5481,-0.1425,0.0075],[&quot;01-10-2017&quot;,&quot;VA&quot;,&quot;HD-85&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4705,0.5284,-0.0579,0.4651,0.4706,-0.0055,-0.0524],[&quot;12-27-2016&quot;,&quot;IA&quot;,&quot;SD-45&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.7319,0.2531,0.4788,0.55,0.38,0.17,0.3088],[&quot;02-27-2018&quot;,&quot;CT&quot;,&quot;HD-120&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.50818,0.49181,0.01637,0.49,0.4686,0.0214,-0.00503],[&quot;02-27-2018&quot;,&quot;KY&quot;,&quot;HD-89&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3324,0.6675,-0.3351,0.173,0.7899,-0.6169,0.2818],[&quot;02-27-2018&quot;,&quot;NH&quot;,&quot;HD-Belknap-3&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5351,0.4649,0.0702,0.4117,0.5363,-0.1246,0.1948],[&quot;02-20-2018&quot;,&quot;KY&quot;,&quot;HD-49&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.6845,0.3155,0.369,0.2327,0.7225,-0.4898,0.8588],[&quot;02-13-2018&quot;,&quot;FL&quot;,&quot;HD-72&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.5217,0.448,0.0737,0.4603,0.5071,-0.0468,0.1205],[&quot;02-13-2018&quot;,&quot;OK&quot;,&quot;SD-27&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3203,0.6797,-0.3594,0.1132,0.8421,-0.7289,0.3695],[&quot;02-12-2018&quot;,&quot;MN&quot;,&quot;SD-54&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.5072,0.4707,0.0365,0.4474,0.4616,-0.0142,0.0507],[&quot;02-12-2018&quot;,&quot;MN&quot;,&quot;HD-23B&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.3992,0.5922,-0.193,0.327,0.5947,-0.2677,0.0747],[&quot;02-06-2018&quot;,&quot;MO&quot;,&quot;HD-39&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.35674,0.64326,-0.28652,0.2445,0.7095,-0.465,0.17848],[&quot;02-06-2018&quot;,&quot;MO&quot;,&quot;HD-97&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.51558,0.48442,0.03116,0.3331,0.6114,-0.2783,0.30946],[&quot;02-06-2018&quot;,&quot;MO&quot;,&quot;HD-129&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.30905,0.69095,-0.3819,0.1636,0.8003,-0.6367,0.2548],[&quot;02-06-2018&quot;,&quot;MO&quot;,&quot;HD-144&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.47376,0.52624,-0.05248,0.1914,0.7784,-0.587,0.53452],[&quot;01-23-2018&quot;,&quot;PA&quot;,&quot;HD-35&quot;,&quot;(D)&quot;,&quot;(D)&quot;,0.7363,0.2598,0.4765,0.5789,0.3941,0.1848,0.2917],[&quot;01-16-2018&quot;,&quot;IA&quot;,&quot;HD-06&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4426,0.5564,-0.1138,0.309,0.6436,-0.3346,0.2208],[&quot;01-16-2018&quot;,&quot;SC&quot;,&quot;HD-99&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4335,0.5643,-0.1308,0.3535,0.5814,-0.2279,0.0971],[&quot;01-16-2018&quot;,&quot;WI&quot;,&quot;SD-10&quot;,&quot;(R)&quot;,&quot;(D)&quot;,0.546,0.4416,0.1044,0.3805,0.553,-0.1725,0.2769],[&quot;01-16-2018&quot;,&quot;WI&quot;,&quot;AD-58&quot;,&quot;(R)&quot;,&quot;(R)&quot;,0.4337,0.5656,-0.1319,0.2843,0.6652,-0.3809,0.249]];
    
    var xName = &quot;dem_margin&quot;;
    var yName = &quot;clinton_margin&quot;;
    var xLabel = &quot;Democratic Lead, Special Election&quot;;
    var yLabel = &quot;Democratic Lead, President 2016&quot;;
    
    var min_x = d3.min(data, function(d) { return +d[keys[xName]]; });
    var max_x = d3.max(data, function(d) { return +d[keys[xName]]; });
    var min_y = d3.min(data, function(d) { return +d[keys[yName]]; });
    var max_y = d3.max(data, function(d) { return +d[keys[yName]]; });
    var max = d3.max([min_x, min_y, max_x, max_y].map(Math.abs));

    var x = d3.scale.linear()
            .domain([-1.2*max, 1.2*max])
            .range([ 0, width ]);

    var y = d3.scale.linear()
            //.domain([min_y - Math.abs(0.2*min_y), max_y + Math.abs(0.2*max_y)])
            .domain([-1.2*max, 1.2*max])
            .range([ height, 0 ]);

    var xAxis = d3.svg.axis()
        .scale(x)
        .orient(&quot;bottom&quot;)
        .ticks(6)  //5
        .tickSize(-height);

    var yAxis = d3.svg.axis()
        .scale(y)
        .orient(&quot;left&quot;)
        .ticks(6)  //5
        .tickSize(-width);  //-width

    var zoom = d3.behavior.zoom()
        .x(x)
        .y(y)
        .scaleExtent([1, 10])
        .center([width / 2, height / 2])
        .size([width, height])
        .on(&quot;zoom&quot;, zoomed);

    var svg = d3.select(&quot;body&quot;).append(&quot;svg&quot;)
        .attr(&quot;width&quot;, width + margin.left + margin.right)
        .attr(&quot;height&quot;, height + margin.top + margin.bottom)
      .append(&quot;g&quot;)
        .attr(&quot;transform&quot;, &quot;translate(&quot; + margin.left + &quot;,&quot; + margin.top + &quot;)&quot;)
        .call(zoom);

    //http://stackoverflow.com/questions/28723551
    //Create clip, then apply it to each dot
    var clip = svg.append(&quot;defs&quot;).append(&quot;svg:clipPath&quot;)
        .attr(&quot;id&quot;, &quot;clip&quot;)
        .append(&quot;svg:rect&quot;)
        .attr(&quot;id&quot;, &quot;clip-rect&quot;)
        .attr(&quot;x&quot;, &quot;0&quot;)  //
        .attr(&quot;y&quot;, &quot;0&quot;)  //
        .attr('width', width)
        .attr('height', height);

    svg.append(&quot;rect&quot;)
        .attr(&quot;width&quot;, width)
        .attr(&quot;height&quot;, height);

    svg.append(&quot;g&quot;)
        .attr(&quot;class&quot;, &quot;x axis&quot;)
        .attr(&quot;transform&quot;, &quot;translate(0,&quot; + height + &quot;)&quot;)
        .call(xAxis);

    svg.append(&quot;g&quot;)
        .attr(&quot;class&quot;, &quot;y axis&quot;)
        .call(yAxis);

    d3.selectAll('g.tick')
      .filter(function(d){ return d==0;} )
      .select('line') 
      .attr('id', 'main-tick');

    // Tooltips
    var div = d3.select(&quot;body&quot;)
        .append(&quot;div&quot;)  
        .attr(&quot;class&quot;, &quot;tooltip&quot;)
        .style(&quot;opacity&quot;, 0); 

    svg.selectAll(&quot;.dot&quot;)
      .data(data)
    .enter().append(&quot;circle&quot;)
      .attr(&quot;class&quot;, &quot;dot&quot;)
      .attr(&quot;clip-path&quot;, &quot;url(#clip)&quot;)  //add the clip to each dot
      .attr(&quot;r&quot;, 4.0) //3.5  4.5 3*zoom.scale()
      .attr(&quot;cx&quot;, function(d) { return x(+d[keys[xName]]); })
      .attr(&quot;cy&quot;, function(d) { return y(+d[keys[yName]]); })
      .style(&quot;fill&quot;, 'red' ) 
      .attr('fill-opacity', 0.6)
      .on(&quot;mouseover&quot;, function(d) { drawTooltip(d); })
      .on(&quot;mouseout&quot;, function() {
        div.style(&quot;opacity&quot;, 0);
      });

    svg.append(&quot;text&quot;)
        .attr(&quot;class&quot;, &quot;x label&quot;)
        .attr(&quot;text-anchor&quot;, &quot;middle&quot;)
        .attr(&quot;x&quot;, width/2)
        .attr(&quot;y&quot;, height + 30)
        .text(&quot;Democratic Lead, Special Election&quot;);

    svg.append(&quot;text&quot;)
        .attr(&quot;class&quot;, &quot;y label&quot;)
        .attr(&quot;text-anchor&quot;, &quot;middle&quot;)
        .attr(&quot;x&quot;, -height/2)
        .attr(&quot;y&quot;, -30) //-30
        .attr(&quot;transform&quot;, &quot;rotate(-90)&quot;)
        .text(&quot;Democratic Lead, President 2016&quot;);

    d3.selectAll(&quot;button[data-zoom]&quot;)
        .on(&quot;click&quot;, clicked);

    function zoomed() {
      svg.select(&quot;.x.axis&quot;).call(xAxis);
      svg.select(&quot;.y.axis&quot;).call(yAxis);

      //http://stackoverflow.com/questions/37573228
      svg.selectAll(&quot;.dot&quot;)
        //.attr(&quot;r&quot;, 3*zoom.scale())
        .attr(&quot;cx&quot;, function (d) {
            return x(+d[keys[xName]]);
        })
        .attr(&quot;cy&quot;, function (d) {
            return y(+d[keys[yName]]);
        });

        d3.selectAll('g.tick')
          .filter(function(d){ return d==0;} )
          .select('line') //grab the tick line
          .attr('id', 'main-tick');
    }

    function clicked() {
      svg.call(zoom.event); // https://github.com/mbostock/d3/issues/2387

      // Record the coordinates (in data space) of the center (in screen space).
      var center0 = zoom.center(), translate0 = zoom.translate(), coordinates0 = coordinates(center0);
      zoom.scale(zoom.scale() * Math.pow(2, +this.getAttribute(&quot;data-zoom&quot;)));

      // Translate back to the center.
      var center1 = point(coordinates0);
      zoom.translate([translate0[0] + center0[0] - center1[0], translate0[1] + center0[1] - center1[1]]);

      svg.transition().duration(750).call(zoom.event);

    }

    function coordinates(point) {
      var scale = zoom.scale(), translate = zoom.translate();
      return [(point[0] - translate[0]) / scale, (point[1] - translate[1]) / scale];
    }

    function point(coordinates) {
      var scale = zoom.scale(), translate = zoom.translate();
      return [coordinates[0] * scale + translate[0], coordinates[1] * scale + translate[1]];
    }

    function drawTooltip(d) {
        div.style(&quot;opacity&quot;, 1.0);
        div.html(
    '<b>State:</b> '+ d[keys.state] + 
    '<br><b>District:</b> '+ d[keys.district] + 
    '<br><b>Date:</b> '+ d[keys.date] + 
    '<br><b>President:</b> ' + d[keys.clinton_margin] +
    '<br><b>Special:</b> ' + d[keys.dem_margin] 
    )
            .style(&quot;left&quot;, (d3.event.pageX) + &quot;px&quot;)
            .style(&quot;top&quot;, (d3.event.pageY ) + &quot;px&quot;);
    }

    </script>
    </body>
    </html>
    " style="width: 960px; height: 600px; display:block; width: 100%; margin: 15px auto; border: none"></iframe>
    
So this bodes pretty well for Democrats in the 2018 midterms, although a lot can change in a year.  