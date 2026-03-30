
<cfif isdefined("url.CMTScodigo") and len(trim(url.CMTScodigo))>
	<cfquery name="rs" datasource="#session.DSN#">
		select CMTScodigo, CMTSdescripcion 
		from CMTiposSolicitud
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.CMTScodigo#">
		order by CMTSdescripcion
	</cfquery>

	<script language="javascript1.2" type="text/javascript">
		<cfoutput>
		<cfif rs.recordCount gt 0>
			window.parent.document.form1.CMTScodigo.value = '#rs.CMTScodigo#';
			window.parent.document.form1.CMTSdescripcion.value = '#rs.CMTSdescripcion#';
		<cfelse>			
			window.parent.document.form1.CMTScodigo.value = '';
			window.parent.document.form1.CMTSdescripcion.value = '';
		</cfif>
		</cfoutput>
	</script>
</cfif>


