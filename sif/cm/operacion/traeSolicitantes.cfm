<cfparam name="url.formulario" default="form1">
<cfparam name="url.indice" default="">
<cfparam name="url.CMScodigo" default="">

<cfquery name="rs" datasource="#session.DSN#">
	select CMSid, CMScodigo, CMSnombre
	from CMSolicitantes
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and rtrim(CMScodigo)=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CMScodigo)#">
</cfquery>

<cfoutput>
	<script language="javascript1.2" type="text/javascript">
		<cfif rs.recordCount gt 0>
			window.parent.document.#url.formulario#.CMSid#url.indice#.value = #rs.CMSid#;
			window.parent.document.#url.formulario#.CMScodigo#url.indice#.value = '#trim(rs.CMScodigo)#';
			window.parent.document.#url.formulario#.CMSnombre#url.indice#.value = '#trim(rs.CMSnombre)#';
		<cfelse>
			window.parent.document.#url.formulario#.CMSid#url.indice#.value = '';
			window.parent.document.#url.formulario#.CMScodigo#url.indice#.value = '';
			window.parent.document.#url.formulario#.CMSnombre#url.indice#.value = '';
		</cfif>
	</script>
</cfoutput>