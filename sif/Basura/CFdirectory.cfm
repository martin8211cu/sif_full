<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
</head>

<body>
<h3>cfdirectory Example</h3>
<!--- use cfdirectory to give the contents of the directory that containsthis page order by name and size --->
<cfdirectory 
	directory="#GetDirectoryFromPath(GetTemplatePath())#" 
	name="myDirectory" 
	sort="name ASC, size DESC">
<!---- Output the contents of the cfdirectory as a cftable -----> 
<cftable 
	query="myDirectory" 
	htmltable 
	colheaders> 
	<cfcol 
		header="NAME:" 
		text="#Name#"> 
	<cfcol 
		header="SIZE:" 
		text="#Size#"> 
</cftable> 

</body>
</html>
