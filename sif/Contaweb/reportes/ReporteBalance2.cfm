<cfif Len(session.tempfile_cfm) is 0>
	<cfheader statuscode="304" statustext="Not Modified">
<cfelse>
	<cfset tempfile_cfm = session.tempfile_cfm>
	<cfset tempfile_xls = session.tempfile_xls>
	<cfset session.tempfile_cfm = ''>

<cfdirectory 
	directory="#GetDirectoryFromPath(tempfile_cfm)#" 
	name="myDirectory" 
	sort="name ASC, size DESC">
<!---- Output the contents of the cfdirectory as a cftable -----> 
<cfloop query="myDirectory" >
	<cfif findnocase(Name, tempfile_xls) GT 0>
		<cfif Size LTE 3145728>
			<cfcontent file="#tempfile_cfm#" deletefile="yes" type="text/html">
		<cfelse>
			<cffile action="delete" file="#tempfile_cfm#"> 
		
			<html><head><title>Reporte</title></head><body>
			
				El reporte fue generado existosamente, pero es muy grande para desplegarlo.<br>
				Haga clic <a href="../reportes/cmn_excel.cfm">aqu&iacute;</a> para descargarlo en formato excel.
			</body></html>
			<cfbreak>

		</cfif>
	</cfif>
</cfloop>
<!--- 	<cfcontent file="#tempfile_cfm#" deletefile="yes" > --->
</cfif>
