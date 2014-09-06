<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.io.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<% 
//   String fName = "/home/aravindh/asha.csv";
String fName = "/home/aravindh/workspace/d3/WebContent/file/asha.csv";
   String thisLine; 
  int count=0; 
  FileInputStream fis = new FileInputStream(fName);
  DataInputStream myInput = new DataInputStream(fis);
  int i=0; 
%>
<table>
<%
while ((thisLine = myInput.readLine()) != null)
{
String strar[] = thisLine.split(",");
String s=strar[1];
String s1=strar[6];
out.print(s);
out.print(" " +s1);
out.print(" <br>");
} 
%>
</table>
</body>
</html>