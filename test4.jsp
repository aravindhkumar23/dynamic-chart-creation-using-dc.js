<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%@page import="java.util.ArrayList"%>
     <%@ page import="java.sql.*"%>
<%
Connection con = null; 
PreparedStatement stmt=null;
String db = "db"; 
try {    
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost/"+db, "root", "pass");      
   // out.println (db+ " database successfully opened.(msg from commonconn - connection)<br>");
	}
catch(SQLException e) {
  out.println("SQLException caught: " +e.getMessage());
} 
%>
  <% 
    //db connection starts and chart
	ArrayList<String> continent=new ArrayList<String>();
  	ArrayList<String> country=new ArrayList<String>();
	ArrayList<String> destregion=new ArrayList<String>();
	ArrayList<String> flights=new ArrayList<String>();
	ArrayList<String> dest=new ArrayList<String>();
	ArrayList<String> airline=new ArrayList<String>();
	ArrayList<String> airline_name=new ArrayList<String>();
	ArrayList<String> destcountry=new ArrayList<String>();
	ArrayList<String> destairport=new ArrayList<String>();

	int count=0;
//String db = "aravindh";  
  try {	      
     ResultSet rs=null;
  //  out.println("<b>data from database</b><br>");
     stmt=con.prepareStatement( " SELECT * from table    ");
   //  out.println("<b>fetching date(y-m-d),no1,no2,no3 from dc </b><br>");
     rs=stmt.executeQuery(); 
     airline.clear();flights.clear();dest.clear();destregion.clear();continent.clear();country.clear();
     
   while (rs.next()) {	  	   
	   airline.add(rs.getString("OP_AI"));
	   country.add(rs.getString("ORIG_COUNTRY"));
	   flights.add(rs.getString("FLIGHTS"));
	   dest.add(rs.getString("DEST"));
	   destregion.add(rs.getString("DEST_REGION"));
	   continent.add(rs.getString("ORIG_CONTINENT"));
	   airline_name.add(rs.getString("AIRLINE_NAME"));
	   destcountry.add(rs.getString("DEST_COUNTRY"));
	   destairport.add(rs.getString("DEST_AIRPORT"));
	   
		count++;
		System.out.println("dom "+rs.getString("OP_AI"));
	}        
  }
  catch(SQLException e) {
    out.println("SQLException caught: " +e.getMessage());
  } 
	%> 
<!DOCTYPE html>
<html lang="en">
<head>
  
    <meta charset="utf-8">
    <title>dc.js</title>
        <!-- The styles -->
    <link id="bs-css" href="css/bootstrap-cerulean.min.css" rel="stylesheet">

    <link href="css/charisma-app.css" rel="stylesheet">
    <link href='bower_components/fullcalendar/dist/fullcalendar.css' rel='stylesheet'>
    <link href='bower_components/fullcalendar/dist/fullcalendar.print.css' rel='stylesheet' media='print'>
    <link href='bower_components/chosen/chosen.min.css' rel='stylesheet'>
    <link href='bower_components/colorbox/example3/colorbox.css' rel='stylesheet'>
    <link href='bower_components/responsive-tables/responsive-tables.css' rel='stylesheet'>
    <link href='bower_components/bootstrap-tour/build/css/bootstrap-tour.min.css' rel='stylesheet'>
    <link href='css/jquery.noty.css' rel='stylesheet'>
    <link href='css/noty_theme_default.css' rel='stylesheet'>
    <link href='css/elfinder.min.css' rel='stylesheet'>
    <link href='css/elfinder.theme.css' rel='stylesheet'>
    <link href='css/jquery.iphone.toggle.css' rel='stylesheet'>
    <link href='css/uploadify.css' rel='stylesheet'>
    <link href='css/animate.min.css' rel='stylesheet'>

   
    
     <link rel="stylesheet" type="text/css" href="css/dc.css"> 

</head>

<body>
    <!-- topbar ends -->
<div class="ch-container">
  		
<div class="row">
<div class="col-md-4">
		<div id="chart1" >
                <h4>Source View-Continent wise</h4>
           <a class="reset" href="javascript:ContinentRingChart.filterAll();dc.redrawAll();" style="display: none;">reset</a>

      		  <div class="clearfix"></div>
  	    </div>
</div>
<div class="col-md-4">
	<div id="chart2">
                <h4>Region Wise Traffic</h4>
           <a class="reset" href="javascript:DestRegionChart.filterAll();dc.redrawAll();" style="display: none;">reset</a>

        <div class="clearfix"></div>
    </div>
</div>
<div class="col-md-4">
	<div id="chart3">
                <h4>Airport Wise Traffic</h4>
		<a class="reset" href="javascript:DestChart.filterAll();dc.redrawAll()" style="display:none;">reset</a>
	<div class="clearfix"></div>
		</div>
</div>
</div>


<div class="row">
<div class="col-md-6">
	<div id="chart22" >
                <h4>Source View-Country wise </h4>
           <a class="reset" href="javascript:ContinentRingChart.filterAll();dc.redrawAll();" style="display: none;">reset</a>

        <div class="clearfix"></div>
    </div>
</div>
<div class="col-md-6">
	<div id="chart4">
            <h4> Airline Wise Traffic</h4>
		<a class="reset" href="javascript:AirlineRowChart.filterAll();dc.redrawAll()" style="display:none;">reset</a>
		<a class="reset" href="javascript:ContinentRingChart.filterAll();DestRegionChart.filterAll();DestChart.filterAll();AirlineRowChart.filterAll();dc.redrawAll()" style="display:none;">Reset All</a>
	<div class="clearfix"></div>
	
	
	
	<!-- table strt -->
	<table class="table table-hover dc-data-table" id="dc-data-table1">
                
			<thead>
			<tr class="header">
				<!-- <th>Continent</th> -->
				<th>Country</th>
				<th>Region</th>
				<th>Airport Code</th>
				<th>Airline Code</th> 
				<th>Airline Name</th>
				<th>Airline Count</th>  
			</tr>
			
			</thead>
		</table>
		<!-- table end -->
		</div>
</div>
</div>
  
</div><!--/.fluid-container-->


<style>
.dc-chart g.row text {
fill: rgb(17, 3, 3);
}
.dc-table-group.info{
   font-weight: bold;
}

</style>

<script type="text/javascript"> 
window.onload=function(){
	//alert("hi");
	 
	  window.data = new Array();
	<%
	for(int i=0;i<count;i++){    	
		%>   
		var obj = new Object();
		obj["airline"] = "<%=airline.get(i)%>";
		obj["flights"] = <%=flights.get(i)%>;
		obj["dest"] = "<%=dest.get(i)%>";
		obj["destregion"] = "<%=destregion.get(i)%>";
		obj["continent"] = "<%=continent.get(i)%>";
		obj["country"] = "<%=country.get(i)%>";
		obj["airlinename"] = "<%=airline_name.get(i)%>";
		obj["destcountry"] = "<%=destcountry.get(i)%>";
		obj["destairport"] = "<%=destairport.get(i)%>";
		data.push(obj);    	
		<%
	}
	%>
	//alert(JSON.stringify(data));
	//alert(data);
var ndx = crossfilter(data);
var continent  = ndx.dimension(function(d) { if(d.continent=="null") return "To Be Categorised";return d.continent;});
var flight_total_continent = continent.group().reduceSum(function(d) {return d.flights;});

/* first chart-continent */

 ContinentRingChart  = dc.pieChart("#chart1");//line chart declare and use div id for area
ContinentRingChart
    .width(150)
    .height(115)
    .innerRadius(10)
     //.slicesCap(14) 
      //.renderLabel(false)
    .dimension(continent)
    .transitionDuration(700)       
    .ordinalColors(["#5179D6","#66CC66","#EF2F41","#FFC700","#7B71C5","#888888","#00FFFF","#C0C0C0"])
    .legend(dc.legend().x(10).y(10).itemHeight(10).itemWidth(40).gap(12).horizontal(1).legendWidth(50))
    .renderTitle(false)
    .group(flight_total_continent); 
    
/* 2-1 chart chart- couintry */
/* CountryChart  = dc.pieChart("#chart22");//line chart declare and use div id for area
var country  = ndx.dimension(function(d) {return d.country;});
var flight_total_country = country.group().reduceSum(function(d) {return d.flights;});
CountryChart
    .width(350)
    .height(175)
    .dimension(country)
    .transitionDuration(700)       
    //.ordinalColors(["#5179D6","#66CC66","#EF2F41","#FFC700","#7B71C5","#888888","#00FFFF","#C0C0C0"])
    .legend(dc.legend().x(10).y(10).itemHeight(10).gap(12).horizontal(0).legendWidth(250).itemWidth(30)) 
    .group(flight_total_country); */
    
    AirlineRowChart = dc.rowChart("#chart22");
    var country  = ndx.dimension(function(d) {return d.country;});
    var flight_total_country = country.group().reduceSum(function(d) {return d.flights;});
    AirlineRowChart
 		.width(600)
 		.height(1300)
 		.dimension(country)
 		.group(flight_total_country)
 		.ordering(function(d) { return -d.value })
		.gap(0)
		.renderTitleLabel(1)
		
 		/* .svg(d3.selectAll("text").attr('.dc-chart g.row text','rgb(17, 3, 3)')) */
 		.elasticX(true);
    
/* 2nd chart-destregion rgb(17, 3, 3);*/
    DestRegionChart=dc.pieChart("#chart2");
    var destregion  = ndx.dimension(function(d) { 
    	/* if(d.destregion=="East India") return "E.India";
    	if(d.destregion=="Norteast India") return "NE.India";
    	if(d.destregion=="Nothern India") return "N.India";
    	if(d.destregion=="South India") return "S.India";
    	if(d.destregion=="Western India") return "W.India"; */
    	return d.destregion;
    	});
    var flight_total_destregion = destregion.group().reduceSum(function(d) {return d.flights;});
    DestRegionChart
    .width(450)
	.height(240)
    .dimension(destregion)
    .transitionDuration(700)       
    .ordinalColors(["#5179D6","#66CC66","#EF2F41","#FFC700","#7B71C5","#888888","#00FFFF","#C0C0C0"])
    .legend(dc.legend().x(0).y(10).gap(0).horizontal(0).itemHeight(10).gap(9))
  	//.legend(dc.legend().horizontal(0).x(340).y(10).itemHeight(13).gap(5))
	//.legend(dc.legend().horizontal(1).x(10).y(10).itemHeight(13).gap(5))
    .group(flight_total_destregion);
    
    /* 3rd chart-dest */
    DestChart=dc.pieChart("#chart3");
    var dest = ndx.dimension(function(d) {return d.dest;});
    var flight_total_dest = dest.group().reduceSum(function(d) {return d.flights;});
    DestChart
    .width(350)
    .height(175)
    .dimension(dest)
    .transitionDuration(700)       
    //.ordinalColors(["#5179D6","#66CC66","#EF2F41","#FFC700","#7B71C5","#500000","#00FFFF","#C0C0C0"])
    .legend(dc.legend().x(10).y(10).itemHeight(10).gap(12).horizontal(0).legendWidth(250).itemWidth(30)) 
    .group(flight_total_dest);
    
  /* row chart */
   /*  AirlineRowChart = dc.rowChart("#chart4");
    var airline = ndx.dimension(function(d) {return d.airline;});
    var flight_total_airline = airline.group().reduceSum(function(d) {return d.flights;});
    AirlineRowChart
    .width(600)
    .height(2000)
    .dimension(airline)
    .group(flight_total_airline)
    .elasticX(true); */
   
    var datatable   = dc.dataTable("#dc-data-table1");
    var airline = ndx.dimension(function(d) {return d.dest;});
    datatable
        .dimension(airline)
       /*  .group(function(d) {return d.destairport;}) */
        .group(function(d) { if(d.continent=="null") return "Continent: To Be Categorised";return "Continent: " + d.continent;})
        .order(d3.descending)
        .columns([
				/* function(d) { return d.continent;}, */
				function(d) { return d.country;},
				function(d) { return d.destregion;},
				function(d) { return d.dest;},
				function(d) { return d.airline;},
				function(d) { if(d.airlinename=="null") return "Yet To Be Defined";return d.airlinename;},
				function(d) { return d.flights;}
        ])
    .sortBy(function (d) {return d.flights;})
     .renderlet(function (table) {
    table.selectAll(".dc-table-group").classed("info", true);
});

    /* AirlineRowChart = dc.barChart("#chart4");
    var airline = ndx.dimension(function(d) {return d.airline;});
    var flight_total_airline = airline.group().reduceSum(function(d) {return d.flights;});
    AirlineRowChart
    .width(1200)
    .height(500)
    .dimension(airline)
    .group(flight_total_airline)
    .x(d3.scale.ordinal())
    .xUnits(dc.units.ordinal);
    AirlineRowChart.margins().left += 30; */
   // AirlineRowChart.selectAll('text').attr('transform', function (d) { return 'rotate(-90)' });

    // .x(d3.scale.linear().domain([1000,10000]))
  
	dc.renderAll(); 
};

</script>

  <script type="text/javascript" src="js/d3.v3.min.js"></script>
      <script type="text/javascript" src="js/dc.js"></script>   
      <script type="text/javascript" src="js/crossfilter.js"></script>
     <!--  <script type="text/javascript" src="js/jquery-1.10.2.js"></script>
      <script type="text/javascript" src="js/d3.js"></script> -->
		<!-- <script type="text/javascript" src="js/colorbrewer.js"></script> -->

</body>
</html>
