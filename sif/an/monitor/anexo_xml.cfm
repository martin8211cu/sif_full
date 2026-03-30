<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Prueba de subir anexo</title>
</head>
<body>

<cffunction name="memory_check">
	<cfargument name="message">

	<cfparam name="mem_old" default="0">
	<cfparam name="time_old" default="0">
	<cfparam name="mem_qry" default="#QueryNew('message,size')#">
	
	<cfoutput>
	<cfset mem_new = runtime.totalMemory()-runtime.freeMemory()>
	<cfset time_new = GetTickCount()>
	#message# <br />
	#TimeFormat(Now(),'hh:mm:ss')#; Asignada JVM: #NumberFormat(runtime.totalMemory())#; 
	Asignada Objetos: #NumberFormat(runtime.totalMemory()-runtime.freeMemory())#<br />
	<cfset delta = 0>
	<cfif mem_old>
		<cfset delta = mem_new - mem_old>
		&Delta;Memoria = <strong>#NumberFormat(delta)#</strong> 
		<cfset QueryAddRow(mem_qry)>
		<cfset QuerySetCell(mem_qry, 'message', message)>
		<cfset QuerySetCell(mem_qry, 'size', delta/1024)>
	</cfif>
	<cfif time_old>
		<cfset delta_t = time_new - time_old>
		&Delta; t = <strong># NumberFormat(delta_t) #</strong> ms
	</cfif><br/>
	#RepeatString(' ', 1024)#
	<hr />
	</cfoutput>
	<cfset mem_old = mem_new>
	<cfset time_old = time_new>
	<cfflush>
	
</cffunction>

<cfoutput>
  <form action="" method="post" enctype="multipart/form-data" name="form1" id="form1">
    <label for="file">Cargar XML</label>
    <input type="file" name="xmlfile" id="xmlfile" />
    <br />
    <input type="submit" name="Submit" value="Subirlo" id="Submit" />
  </form>
  <cfset runtime = CreateObject("java", "java.lang.Runtime")>
  <cfset jsystem = CreateObject("java", "java.lang.System")>
  <cfset jsystem.gc()>
  <cfset runtime = runtime.getRuntime()>
  
  Java VM Max Memory: #NumberFormat(runtime.maxMemory()/(1024*1024))# MB<hr />
  
  <cfset memory_check('inicio')>
  
  <cfif IsDefined('form.xmlfile')>

    <cffile action="upload" filefield="xmlfile" destination="#GetTempDirectory()#" nameconflict="overwrite">
    <cffile action="read" file="#cffile.serverDirectory#/#cffile.serverFile#" variable="xmlstr">
<!---
    <cfset tmpxml = GetTempFile(GetTempDirectory(), 'myxml')>
    <cffile action="upload" filefield="xmlfile" destination="#tmpxml#" nameconflict="overwrite">
    <cffile action="read" file="#tmpxml#" variable="xmlstr">
--->
    <cfset memory_check('XmlSize: #NumberFormat(Len(xmlstr))#')>

    <cfset xmldoc = XMLParse(xmlstr)>
	<cfset memory_check('XML Parseado')>
	
	<!--- proceso de lista --->
		<cfset xmlNamedRanges = XMLSearch(xmldoc, "//ss:Workbook/ss:Names/ss:NamedRange")>
		<cfset memory_check('XML Search terminado')>

		<cfset rsRangosExcel = QueryNew("Sheet,name,range,col,row,RefersTo")>
		<cfloop from="1" to="#ArrayLen(xmlNamedRanges)#" index="i">
			<cfset RangeName = xmlNamedRanges[i].XmlAttributes['ss:Name']>
			<cfset RefersTo  = xmlNamedRanges[i].XmlAttributes['ss:RefersTo']>
			<cfset SheetName = Replace(Replace(ListFirst(RefersTo,"!"),'=',''),"'",'','all')>
			<cfset Rango     = ListFirst(ListRest(RefersTo,"!"),':')>
			<cfif FindNoCase("C", rango) GTE 1>
				<cfset rangoCol = mid(rango, findnocase("C", rango) + 1, 255) >
				<cfset rangoRow = mid(rango, 2, findnocase("C", rango) - 2) >
			<cfelse>
				<cfset rangoCol = 0 >
				<cfset rangoRow = 0 >
			</cfif>
			
			<cfset temp = QueryAddRow(rsRangosExcel,1)>
			<cfset QuerySetCell(rsRangosExcel, "RefersTo",   RefersTo, i)>
			<cfset QuerySetCell(rsRangosExcel, "Sheet", SheetName, i)>
			<cfset QuerySetCell(rsRangosExcel, "name",  RangeName, i)>
			<cfset QuerySetCell(rsRangosExcel, "range", rango, i)>
			<cfset QuerySetCell(rsRangosExcel, "row",   rangoRow, i)>
			<cfset QuerySetCell(rsRangosExcel, "col",   rangoCol, i)>
		</cfloop>
	<cfset memory_check('Lista Construida, #rsRangosExcel.RecordCount# filas')>
  </cfif>
</cfoutput>

<cfif mem_qry.RecordCount>
<cfchart chartwidth="700" chartheight="500" format="png">
<cfchartseries query="mem_qry" type="bar" itemcolumn="message" valuecolumn="size"></cfchartseries>
</cfchart>
</cfif>
</body>
</html>
