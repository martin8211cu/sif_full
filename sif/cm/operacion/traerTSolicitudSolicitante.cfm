<cfif isdefined("url.formulario") and len(trim(url.formulario))>
	<cfset form.formulario = url.formulario>
</cfif>

<cfif isdefined("url.fCMTScodigo") and len(trim(url.fCMTScodigo))>
	<cfquery name="rs" datasource="#session.DSN#">
		select rtrim(CMTScodigo) as CMTScodigo, CMTSdescripcion 
		from CMTiposSolicitud
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(ucase(url.fCMTScodigo))#">
		order by CMTSdescripcion
	</cfquery>
	<script language="javascript1.2" type="text/javascript">
		<cfoutput>
		<cfif rs.recordCount gt 0>
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.fCMTScodigo.value = '#rs.CMTScodigo#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.fCMTSdescripcion.value = '#rs.CMTSdescripcion#';
		<cfelse>			
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.fCMTScodigo.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.fCMTSdescripcion.value = '';
		</cfif>
		</cfoutput>
	</script>
</cfif>


