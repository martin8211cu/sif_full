<cfinclude template="simple-selemp.cfm">
<cfif IsDefined('url.reload')>
	<html><head></head><body>
	<cfinclude template="simple-selemp.cfm">
	<cfinclude template="simple-matriz.cfm">
	<script type="text/javascript">
		window.parent.document.getElementById('matriz').innerHTML=
			document.getElementById('matriz').innerHTML;
		<cfif IsDefined('url.hideuser')>window.parent.hideUser();</cfif>
	</script></body>
	</html>
<cfelseif IsDefined('url.loaduser')>
	<cfinclude template="simple-userdata.cfm">
<cfelse>
	<cfset session.simple._buscar = "">
	<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta"
		CEcodigo="#session.simple._ctaemp#" returnvariable="dataPoliticas"/>
	<cf_templateheader title="Administración de la seguridad">
	<cf_web_portlet_start titulo="Administración de la seguridad">
	<cfinclude template="simple-combos.cfm">
	<cfinclude template="simple-javascript.cfm">
	<cfinclude template="simple-matriz.cfm">
	<cfinclude template="simple-userform.cfm">
	<br /><br />
	<cf_web_portlet_end>
	<cf_templatefooter>
</cfif>