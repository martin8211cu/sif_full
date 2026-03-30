<cfinvoke key="LB_Reporte" 			default="Reporte" 			returnvariable="LB_Reporte" 		component="sif.Componentes.Translate" method="Translate" xmlfile="bajar_excel.xml"/>
<cfif Len(session.tempfile_xls) is 0>
	<cfheader statuscode="304" statustext="Not Modified">
<cfelse>
	<cfset tempfile_xls = session.tempfile_xls>
	<cfset session.tempfile_xls = ''>
	
	<!--- o type = application/octet-stream ?? --->
	<cfheader name="Content-Disposition" value="attachment; filename=#LB_Reporte#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls" >
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
	<cfcontent  type="application/vnd.ms-excel" file="#tempfile_xls#" deletefile="yes">	
</cfif>
