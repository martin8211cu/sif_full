<script language="JavaScript">
  window.close();
</script>

<cfset LLAVE = #url.LLAVE#>
<cfquery datasource="#session.Conta.dsn#"  name="sql" >	
	set nocount on
	update  tbl_archivoscf set 
		status = <cfqueryparam cfsqltype="cf_sql_varchar"  value="B">
		where  
		idarchivo = <cfqueryparam  cfsqltype="cf_sql_integer"  value="#LLAVE#">
	set nocount off
</cfquery>


<cfset tempfile_TXT = '#GetTempDirectory()##url.ARCHIVO#'>
 <cfheader name="Content-Disposition" value="attachment; filename=#url.ARCHIVO#" >
<cfcontent type="text/plain" file="#tempfile_TXT#" deletefile="yes">

