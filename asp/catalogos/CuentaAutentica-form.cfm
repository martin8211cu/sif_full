<style type="text/css">
<!--
.flat { border:1px solid #7f9db9; }
.right { text-align:right; }
label { font-weight:normal; }
-->
</style>

<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
<cfset data = Politicas.trae_parametros_cuenta(Session.Progreso.CEcodigo)>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td colspan="3" bgcolor="#A0BAD3">
		<table border="0" cellpadding="2" cellspacing="0" style="height: 24px; ">
			<tr>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcContinuar();">
					<img src="../imagenes/r_arrow.gif" border="0" align="top" hspace="2">Continuar
				</td>
				<td>|</td>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcCancelar();">
					<img src="../imagenes/cancel.gif" border="0" align="top" hspace="2">Cancelar
				</td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
  	<td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td class="textoAyuda" width="20%" valign="top">
		<p>En el formulario que se muestra, se listan las opciones de seguridad que pueden modificarse para la cuenta empresarial seleccionada.<br>
		  <br>
	  Para modificar las opciones de sesión, contraseñas, LDAP y acceso remoto, seleccione la ficha correspondiente.</p>
		<p> Note que las fichas de LDAP y acceso remoto solamente aparecen cuando se habilitan en la secciones <em>Método de autenticación</em> y <em>Acceso remoto</em> de la ficha de Sesión.<br>
    </p></td>
    <td style="padding-left: 5px; padding-right: 5px; " valign="top" align="center">


<form name="form1" method="post" action="CuentaAutentica-apply.cfm" onSubmit="if(window.funcvalidar) return funcvalidar()">
		<cfparam name="url.tab" default="sess">
		<br />
		<cf_tabs width=560>
			<cf_tab id="sess" text="Sesión" selected="#url.tab is 'sess'#">
				<cfif url.tab is 'sess'><cfinclude template="/asp/admin/politicas/global/global-form-sess.cfm"></cfif>
			</cf_tab>
			<cf_tab id="pass" text="Contraseñas" selected="#url.tab is 'pass'#">
				<cfif url.tab is 'pass'><cfinclude template="/asp/admin/politicas/global/global-form-pass.cfm"></cfif>
			</cf_tab>
			<cfif ListFind(data.auth.orden, 'ldap')>
			<cf_tab id="ldap" text="Servicio de LDAP" selected="#url.tab is 'ldap'#">
				<cfif url.tab is 'ldap'><cfinclude template="/asp/admin/politicas/global/global-form-ldap.cfm"></cfif>
			</cf_tab></cfif>
			<cfif data.auth.validar.ip is 1 Or  data.auth.validar.horario is 1>
			<cf_tab id="acceso" text="Acceso remoto" selected="#url.tab is 'acceso'#">
				<cfif url.tab is 'acceso'><cfinclude template="AccesoRemoto-form.cfm"></cfif>
			</cf_tab></cfif>
		</cf_tabs>
		<table><tr><td>
		(†) Estas opciones restringen la modificación de políticas por usuario</td></tr>
		  <tr>
		    <td>(‡) Estas opciones se activarán para las sesiones nuevas</td>
	      </tr>
		</table>
</form>
    <td width="1%" valign="top">
		<cfinclude template="frame-Progreso.cfm">
		<br>
		<cfinclude template="frame-Proceso.cfm">
	</td>
  </tr>
</table>

<script type="text/javascript">

function buttonOver(obj) {
	obj.className="botonDown";
}

function buttonOut(obj) {
	obj.className="botonUp";
}

function tab_set_current(n) {
	location.replace('?tab=' + n);
}
function funcCancelar() {
	location.href = '/cfmx/asp/index.cfm';
}
function funcContinuar() {
	location.href = '/cfmx/asp/catalogos/Empresas.cfm';
}

function showList() {
	location.href = 'Modulos.cfm?selecc=1';
}
</script>

