<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>d3.js demo</title>  
  <script type="text/javascript" src="js/d3.v3.min.js"></script>
      <script type="text/javascript" src="js/dc.js"></script>   
      <script type="text/javascript" src="js/crossfilter.js"></script>
      <script type="text/javascript" src="js/jquery-1.10.2.js"></script>
      <link rel="stylesheet" type="text/css" href="css/dc.css"> 
</head>
<body>
<h1>d3,dc,crossfilter</h1>
<div id="chart-ring-year">
		<a class="reset" href="javascript:yearRingChart.filterAll();dc.redrawAll()" style="display:none;">reset</a>
	</div>
	
	<div id="chart-ring-http">
		<a class="reset" href="javascript:httpRingChart.filterAll();dc.redrawAll()" style="display:none;">reset</a>
	</div>
	
	<div id="chart-line-hitsperday">
		<a class="reset" href="javascript:hitslineChart.filterAll();dc.redrawAll()" style="display:none;">reset</a>
	</div>

</body>
<script type="text/javascript"> 
window.onload=function(){
	 hitslineChart  = dc.lineChart("#chart-line-hitsperday");
	/* var data = [
			{date: "12/27/2012", http_404: 2, http_200: 190, http_302: 100},
			{date: "12/28/2012", http_404: 2, http_200: 10, http_302: 100},
			{date: "12/29/2012", http_404: 1, http_200: 300, http_302: 200},
			{date: "12/30/2012", http_404: 2, http_200: 90, http_302: 0},
			{date: "12/31/2012", http_404: 2, http_200: 90, http_302: 0},
			{date: "01/01/2013", http_404: 2, http_200: 90, http_302: 0},
			{date: "01/02/2013", http_404: 1, http_200: 10, http_302: 1},
			{date: "01/03/2013", http_404: 2, http_200: 90, http_302: 0},
			{date: "01/04/2013", http_404: 2, http_200: 90, http_302: 0},
			{date: "01/05/2013", http_404: 2, http_200: 90, http_302: 0},
			{date: "01/06/2013", http_404: 2, http_200: 200, http_302: 1},
			{date: "01/07/2013", http_404: 1, http_200: 200, http_302: 100}
			]; */
			
			var data = [
{ "Year": "1993", "Company":"kideco","Production":1.2,"Sales":1.4 },
{ "Year": "2000", "Company":"kideco","Production":8.1,"Sales":8.3},
{ "Year": "2002", "Company":"kideco","Production":11.5,"Sales":11.7 },
{ "Year": "2004", "Company":"kideco","Production":16.9,"Sales":17.1 },
{ "Year": "2006", "Company":"kideco","Production":18.9,"Sales":19.1 },
{ "Year": "2008", "Company":"kideco","Production":22,"Sales":22.2 },
{ "Year": "2010", "Company":"kideco","Production":29,"Sales":29.2 },
{ "Year": "2011", "Company":"kideco","Production":31.5,"Sales":31.7 },
{ "Year": "2012", "Company":"kideco","Production":34 ,"Sales":34.2},
{ "Year": "2013", "Company":"kideco","Production":37,"Sales":37.2 },
{ "Year": "2005", "Company":"adaro","Production":34.6,"Sales":26.3 },
{ "Year": "2007", "Company":"adaro","Production":37.4,"Sales":34.7 },
{ "Year": "2008", "Company":"adaro","Production":41,"Sales":37.6 },
{ "Year": "2009", "Company":"adaro","Production":40.6,"Sales":41.1 },
{ "Year": "2010", "Company":"adaro","Production":42.2,"Sales":41.1 },
{ "Year": "2011", "Company":"adaro","Production":47.7,"Sales":42.5 },
{ "Year": "2012", "Company":"adaro","Production":47.2,"Sales":47.2 },
{ "Year": "2013", "Company":"adaro","Production":52.3,"Sales":47.4 },

];
			
	var ndx = crossfilter(data);
	var parseDate = d3.time.format("%m/%d/%Y").parse;
	data.forEach(function(d) {
		d.date = new Date(Date.parse(d.Year));
		//alert(d.date); 
		d.Company=d.Company;
        d.Year=d.date.getFullYear();//parseInt(d.date); 
        //alert(d.Year);
	}); 
	 var dateDim = ndx.dimension(function(d) {return d.Year;});
	var hits = dateDim.group().reduceSum(function(d) {return d.total;});
	var minDate = dateDim.bottom(1)[0].Year;
	alert(dateDim);
	var maxDate = dateDim.top(1)[0].Year;
var status_200=dateDim.group().reduceSum(function(d) {return d.Production;});
var status_302=dateDim.group().reduceSum(function(d) {return d.Sales;});

	hitslineChart
		.width(600).height(250)
		.dimension(dateDim)
        .group(status_200,"production")
        .stack(status_302,"Sales")
        .renderArea(true)
		.x(d3.time.scale().domain([minDate,maxDate]))
        .brushOn(true)
        .legend(dc.legend().x(50).y(10).itemHeight(13).gap(5))
		.yAxisLabel("Hits per day");

 yearRingChart   = dc.pieChart("#chart-ring-year");
var yearDim  = ndx.dimension(function(d) {return +d.Year;});
var year_total = yearDim.group().reduceSum(function(d) {return d.Production+d.Sales;});

yearRingChart
    .width(250).height(250)
    .dimension(yearDim)
    .group(year_total)
    .innerRadius(30);
    
httpRingChart=dc.pieChart("#chart-ring-http");//ring chart http declare and use div id for area 
var httpDim  = ndx.dimension(function(d) {return d.Company;});
var http_total = httpDim.group().reduceSum(function(d) {return d.Production+d.Sales;});


httpRingChart
.width(250).height(250)
.dimension(httpDim)
.group(http_total)
.innerRadius(50);

	dc.renderAll(); 
}
</script>
</html>