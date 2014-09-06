<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
      <%@ include file="commonconn.jsp" %>
      <% 
    //db connection starts and chart
	ArrayList<String> date=new ArrayList<String>();
	ArrayList<String> no1=new ArrayList<String>();
	ArrayList<String> no2=new ArrayList<String>();
	ArrayList<String> no3=new ArrayList<String>();
	int count=0;
//String db = "aravindh";  
  try {	      
     ResultSet rs=null;
    out.println("<b>data from database</b><br>");
     stmt=con.prepareStatement("select * from dc;");
     out.println("<b>fetching date(y-m-d),no1,no2,no3 from dc </b><br>");
     rs=stmt.executeQuery(); 
   while (rs.next()) {	  	   
	   date.add("'"+rs.getString("date")+"'");
	    no1.add(rs.getString("no1"));    	
		no2.add(rs.getString("no2"));
		no3.add(rs.getString("no3"));
		count++;
	}        
   //System.out.println(count);
	  for(int i=0;i<count;i++)
	 {	
		  out.println(date.get(i));
		out.println(no1.get(i));
		out.println(no2.get(i));
		out.println(no3.get(i));
		out.print("<br>");
	 }   
  }
  catch(SQLException e) {
    out.println("SQLException caught: " +e.getMessage());
  } 
	%> 
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
	
	<a class="reset" href="javascript:hitslineChart.filterAll();yearRingChart.filterAll();httpRingChart.filterAll();dc.redrawAll()">reset all</a>  
</body>

</body>
<script type="text/javascript"> 
//var s=2005-07-08;
window.onload=function(){
	 hitslineChart  = dc.lineChart("#chart-line-hitsperday");//line chart declare and use div id for area 
	  window.data = new Array();
	<%
	for(int i=0;i<count;i++){    	
		%>   
		var obj = new Object();
		obj["date"] = <%=date.get(i)%>;
		obj["http_200"] = <%=no1.get(i)%>;
		obj["http_302"] = <%=no2.get(i)%>;
		obj["http_404"] = <%=no3.get(i)%>;
		data.push(obj);    	
		<%
	}
	%>
//	alert(data);

	var ndx = crossfilter(data);
	
	  var parseDate = d3.time.format("%m/%d/%Y").parse;
	data.forEach(function(d) {
		d.date = new Date(Date.parse(d.date));
		//alert(d.date);
		d.total= d.http_404+d.http_200+d.http_302;
		//alert(d.total);
        d.Year=d.date.getFullYear();//parseInt(d.date); 
        //alert(d.Year);
	});  
	var dateDim = ndx.dimension(function(d) { return d.date;});
	//var hits = dateDim.group().reduceSum(function(d) {return d.total;});
	var minDate = dateDim.bottom(1)[0].date;
	//alert(minDate);
	var maxDate = dateDim.top(1)[0].date;
	//alert(maxDate);
var status_200=dateDim.group().reduceSum(function(d) {return d.http_200;});
var status_302=dateDim.group().reduceSum(function(d) {return d.http_302;});
var status_404=dateDim.group().reduceSum(function(d) {return d.http_404;});


	
	hitslineChart
		.width(600).height(250)
		.dimension(dateDim)
        .group(status_200,"200")
        .stack(status_302,"302")
        .stack(status_404,"404")   
        .renderArea(true)
		.x(d3.time.scale().domain([minDate,maxDate]))
        .brushOn(true)
        .legend(dc.legend().x(50).y(10).itemHeight(13).gap(5))
		.yAxisLabel("Hits per day")
		.xAxisLabel("days");

	 yearRingChart   = dc.pieChart("#chart-ring-year");//ring chart declare and use div id for area 
	var yearDim  = ndx.dimension(function(d) {return +d.Year;});
	var year_total = yearDim.group().reduceSum(function(d) {return d.http_200+d.http_302;});


yearRingChart
    .width(250).height(250)
    .dimension(yearDim)
    .group(year_total)
    .innerRadius(50);
    
    
    httpRingChart=dc.pieChart("#chart-ring-http");//ring chart http declare and use div id for area 
	var httpDim  = ndx.dimension(function(d) {return +d.http_302;});
	var http_total = httpDim.group().reduceSum(function(d) {return d.http_200+d.http_404;});


httpRingChart
    .width(250).height(250)
    .dimension(httpDim)
    .group(http_total)
    .innerRadius(50);

	dc.renderAll(); 
}
</script>
</html>