<!--- If the gridEntered field exists, the form has been submitted.
		Update the database. --->
<cfif IsDefined("form.gridEntered")>
	<cfgridupdate grid = "FirstGrid" dataSource = "minisif" 
	tableName = "Empresas" keyOnly = "Yes">
</cfif>

<!--- Query the database to fill up the grid. --->
<cfquery name = "GetCourses" dataSource = "minisif">
 SELECT Ecodigo as Course_ID, Mcodigo as Dept_ID, Mcodigo as CorNumber,
     Edescripcion as CorName, Ecodigo as CorLevel, Edescripcion as CorDesc
FROM Empresas
ORDER by Dept_ID ASC, CorNumber ASC
</cfquery>

<html>
<head>
<title>cfgrid Example</title>
</head>
<body>
<h3>cfgrid Example</h3>
<I>You can update the Name, Level, and Description information for courses.</i>
<!--- The cfform tag must surround a cfgrid control. --->
<cfform action = "#CGI.SCRIPT_NAME#">
	<cfgrid name = "FirstGrid" width = "500" format="applet"
			query = "GetCourses" colheaderbold="Yes"
			font = "Tahoma" rowHeaders = "No" 
			selectColor = "cyan" selectMode = "single" >
		<!--- cfgridcolumn tags arrange the table and control the display. --->
		<!--- Hide the primary key, required for update --->
		<cfgridcolumn name = "Course_ID" display = "No">
		<!--- select="No" does not seem to have any effect !!! --->
		<cfgridcolumn name = "Dept_ID" header = "Department" Select="No"
			width="75" textcolor="blue" bold="Yes">
		<cfgridcolumn name = "CorNumber" header = "Course ##" Select="No"
			width="65">
		<cfgridcolumn name = "CorName" header = "Name" width="125">
		<cfgridcolumn name = "CorLevel" header = "Level" width="85">
		<cfgridcolumn name = "CorDesc" header = "Description" width="125">
	</cfgrid>
	<br>
	<cfinput type="submit" name="gridEntered">
</cfform>
</body>
</html>
