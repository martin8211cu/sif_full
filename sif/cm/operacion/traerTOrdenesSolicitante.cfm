<cfif isdefined("url.formulario") and len(trim("url.formulario"))>
	<cfset form.formulario = url.formulario>
</cfif>

<cfif isdefined("url.CMTOcodigo") and len(trim(url.CMTOcodigo))>
	<cfquery name="rs" datasource="#session.DSN#">
		select CMTOcodigo, CMTOdescripcion 
		from CMTipoOrden
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.CMTOcodigo#">
		order by CMTOdescripcion
	</cfquery>

	<script language="javascript1.2" type="text/javascript">
		<cfoutput>
		<cfif rs.recordCount gt 0>
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.CMTOcodigo.value = '#rs.CMTOcodigo#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.CMTOdescripcion.value = '#rs.CMTOdescripcion#';
		<cfelse>			
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.CMTOcodigo.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.CMTOdescripcion.value = '';
		</cfif>
		</cfoutput>
	</script>
</cfif>


