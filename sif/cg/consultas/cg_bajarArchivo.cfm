<script language="JavaScript">
  window.close();
</script>
<cfset LLAVE = #url.LLAVE#>

<cfquery datasource="#session.dsn#"  name="sql" >	
	update  tbl_archivoscf set 
		Status = 'B'
		where  
		IDArchivo = <cfqueryparam  cfsqltype="cf_sql_numeric"  value="#LLAVE#">
</cfquery>


<cfset tempfile_TXT = '#GetTempDirectory()##url.ARCHIVO#.txt'>
<cfheader name="Content-Disposition" value="attachment; filename=#url.ARCHIVO#.txt" >
<cfcontent type="text/plain" file="#tempfile_TXT#" deletefile="no">

