<style type="text/css">
<!--
.flat { border:1px solid #7f9db9; }
.right { text-align:right; }
label { font-weight:normal; }
-->
</style>

<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
<cfset data = Politicas.trae_parametros_globales()>

<cfparam name="url.tab" default="sess">
<br />
<form name="form1" method="post" action="global-apply.cfm" onSubmit="if(window.funcvalidar) return funcvalidar()">
<cf_tabs width=930>
	<cf_tab id="sess" text="Sesión" selected="#url.tab is 'sess'#">
		<cfif url.tab is 'sess'><cfinclude template="global-form-sess.cfm"></cfif>
	</cf_tab>
	<cf_tab id="pass" text="Contraseñas" selected="#url.tab is 'pass'#">
		<cfif url.tab is 'pass'><cfinclude template="global-form-pass.cfm"></cfif>
	</cf_tab>
	<cf_tab id="serv" text="Servicios" selected="#url.tab is 'serv'#">
		<cfif url.tab is 'serv'><cfinclude template="global-form-serv.cfm"></cfif>
	</cf_tab>
	<cf_tab id="demo" text="Demostraciones" selected="#url.tab is 'demo'#">
		<cfif url.tab is 'demo'><cfinclude template="global-form-demo.cfm"></cfif>
	</cf_tab>
	<cfif ListFind(data.auth.orden, 'ldap')>
	<cf_tab id="ldap" text="Servicio de LDAP" selected="#url.tab is 'ldap'#">
		<cfif url.tab is 'ldap'><cfinclude template="global-form-ldap.cfm"></cfif>
	</cf_tab></cfif>
</cf_tabs>
		<table><tr><td>
		(†) Estas opciones restringen la modificación de políticas por cuenta empresarial </td></tr><tr>
		  <td>
		(‡) Estas opciones se activarán para las sesiones nuevas</td>
		</tr></table>
</form>
<script type="text/javascript">
function tab_set_current(n) {
	location.replace('?tab=' + n);
}

function solonumero(c,d) {
	var v = parseInt(c.value);
	if (v!=c.value){
		c.value = isNaN(v) ? d : Math.abs(Math.round(v));
	} else c.value = Math.abs(v)
}

</script>