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


<iframe src="{{site.url}}/vis/midterm_house.html" 
    style="width: 960px; height: 600px; display:block; width: 100%; margin: 25px auto; border: none"></iframe>



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

Next, I look at the Senate seats at risk for each party.  

Below is a plot similar plot to the one above, except it only shows the Senators up for re-election in 2018.  This plot is also slightly different, as I am using the Democratic Lead in the 2012 Senate election for each candidate on the y-axis.  This might not be the best indicator of the state's support for the candidate as a lot has changed since 2012, but it's the best one I can think of.

This plot makes it clear that Senate Democrats have a tough 2018 coming up, as 9 senators are up for re-election in states that Trump won.  


<iframe src="{{site.url}}/vis/midterm_senate.html"
    style="width: 960px; height: 600px; display:block; width: 100%; margin: 25px 0px; border: none"></iframe>



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
    </html>" style="width: 725px; height: 500px; display:block; margin: 45px 0px; border: none"></iframe>
            


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
 

