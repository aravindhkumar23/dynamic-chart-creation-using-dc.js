<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
          <%@ include file="conn.jsp" %>
          <% 
	ArrayList<String> expt=new ArrayList<String>();
	ArrayList<String> run=new ArrayList<String>();
	ArrayList<String> speed=new ArrayList<String>();
	int count=0;
  try {	      
     ResultSet rs=null;
    out.println("<b>data from database</b><br>");
     stmt=con.prepareStatement("SELECT Expt,timestamp(Run) as 'Run',Speed FROM aravindh.`table_date`;");
     rs=stmt.executeQuery(); 
     run.clear();
   while (rs.next()) {	  	   
	    expt.add(rs.getString("Expt"));
		run.add(rs.getString("Run"));
		//out.println("<br>"+ rs.getString("Run"));
		speed.add(rs.getString("Speed"));
		count++;
	}        
    }
  catch(SQLException e) {
    out.println("SQLException caught: " +e.getMessage());
  } 
	%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>final page</title>
    <link rel="stylesheet" type="text/css" href="dc.css"/>
</head>
<body>

<div id="test"></div>

<script type="text/javascript" src="d3.js"></script>
<script type="text/javascript" src="crossfilter.js"></script>
<script type="text/javascript" src="dc.js"></script>
<script type="text/javascript"> 
window.onload=function(){
	var chart = dc.seriesChart("#test");
	var ndx, runDimension, runGroup;

	  window.data = new Array();
	<%
	for(int i=0;i<count;i++){    	
		%>
		var obj = new Object();
		obj["Expt"] = <%=expt.get(i)%>;
		obj["Run"] = '<%=run.get(i)%>';
		obj["Speed"] = <%=speed.get(i)%>;
		data.push(obj);    	
		<%
	}
	%>
	//alert("new "+ data);
	 	ndx = crossfilter(data);
		var parseDate = d3.time.format("%Y-%m-%d %H:%M:%S");
	 	 // var parseDate = d3.time.format("%Y-%m-%d %H:%M:%S").parse;
		data.forEach(function(d) {
			d.Run = parseDate.parse(d.Run.substr(0,19));
			//d.Run =parseDate(d.Run);
		}); 
		
		//data.forEach(function(d) {	console.log("+++"+d.Speed+"--"+d.Expt+"***%% "+d.Run);});
		 
		 // date min max find start 
		 	var dateDim = ndx.dimension(function(d) {return d.Run;});
			var minDate = dateDim.bottom(1)[0].Run;
			var maxDate = dateDim.top(1)[0].Run;
			// date min max find end 

			runDimension = ndx.dimension(function(d) {console.log("x y z run "+d.Run+",speed "+d.Speed+",expt "+d.Expt);return [+d.Run,+d.Expt,+d.Speed]; });
  			runGroup = runDimension.group().reduceSum(function(d) { return +d.Speed; });

  			var symbolScale = d3.scale.ordinal().range(d3.svg.symbolTypes);
  		  var symbolAccessor = function(d) {console.log("key values 0 "+d.key[0]+" 1 "+d.key[1]); return symbolScale(d.key[1]); };
  		  var subChart = function(c) {
  		    return dc.scatterPlot(c)
  		        .symbol(symbolAccessor)
  		        .symbolSize(8)
  		        .highlightedSize(10)
  		  };
  		chart
  	    .width(768)
  	    .height(480)
  	    .chart(subChart)
  	    .x(d3.time.scale().domain([minDate,maxDate]))
  	    .brushOn(false)
  	    .yAxisLabel("Measured Speed ")
  	    .xAxisLabel("column Run")
  	    .elasticY(true)
  	    .dimension(runDimension)
  	    .group(runGroup)
  	    .mouseZoomable(true)
  	     .seriesAccessor(function(d) {return "Expt: " + d.key[1];})
  	    .keyAccessor(function(d) {return +d.key[0];})
  	    .valueAccessor(function(d) {return +d.value - 500;})
  	    .legend(dc.legend().x(90).y(35).itemHeight(13).gap(5).horizontal(1).legendWidth(140).itemWidth(70))
 	    
  		.renderLabel(true) // (optional) whether chart should render labels, :default = true
        .label(function (d) {
            return d.key[0];
        })
        .renderTitle(true) // (optional) whether chart should render titles, :default = false
        .title(function (d) {
            return d.key[0];
        });

  	  	// chart.yAxis().tickFormat(function(d) {return d3.format("d")(d+1000);}); 
  	     chart.margins().left += 40; // yaxis text move towards left avoid over riding of values and text 
  	     chart.margins().bottom += 40;
  	  dc.renderAll();
};
</script>

</body>
</html>
