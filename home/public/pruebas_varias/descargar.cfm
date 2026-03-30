<!---
<cfset tempfile = GetTempFile(GetTempDirectory(),"xls")>  SERVER-INF\temp\cfusion-war-tmp 
<cfset nombretmp = ListGetAt(tempfile,Listlen(tempfile,'\'),'\')>
<cfset directorio = ListSetAt(tempfile,Listlen(tempfile,'\'),'','\')>
<cfset nombreXls = "Obras#LSDateFormat(now(),'dd-mm-yyyy')#.xls">
<cfset Archivo = directorio & nombreXls>

<cffile action="write" file="#Archivo#" output="Reporte">


<cfoutput>
<a href="#Archivo#">Descargar</a>
</cfoutput>

<cfoutput>
<a href="#ExpandPath("#nombreXls#")#">Descargar</a>
</cfoutput>

<br>

<cfdump var="#GetCurrentTemplatePath()#">

<br>

<cfdump var="#GetBaseTemplatePath()#">

<br>

<cfdump var="Donde estoy: #ExpandPath("#nombreXls#")#">

<br>

<cfdump var="#GetContextRoot()#">

<br>
<cfdump var="Archivo generado: #directorio# : #Archivo#">
--->

<!--- <cfset yourFileName="#Archivo#">
<cfcontent type="application/x-unknown">
<cfheader name="Content-Disposition" value="attachment;filename=#nombreXls#">
<cfheader name="Content-Description" value="This is a tab-delimited file.">
<cflocation url="#nombreXls#"> --->