<cfif isdefined("url.formulario") and len(trim(url.formulario))>
	<cfset form.formulario = url.formulario>
</cfif>
<cfif isdefined("url.CAcodigo") and len(trim(url.CAcodigo))>
	<cfquery name="rs" datasource="#session.DSN#">
		select CAid, rtrim(CAcodigo) as CAcodigo, CAdescripcion 
		from CodigoAduanal
		where Ecodigo = #session.Ecodigo#
		and rtrim(ltrim(CAcodigo)) = rtrim(ltrim(<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Trim(ucase(url.CAcodigo))#">))
		order by CAdescripcion
	</cfquery>
	<script language="javascript1.2" type="text/javascript">
		<cfoutput>
		<cfif rs.recordCount gt 0>
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.CAid.value = '#rs.CAid#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.CAcodigo.value = '#rs.CAcodigo#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.CAdescripcion.value = '#rs.CAdescripcion#';
		<cfelse>	
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.CAid.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.CAcodigo.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.CAdescripcion.value = '';
		</cfif>
		</cfoutput>
	</script>
</cfif>


