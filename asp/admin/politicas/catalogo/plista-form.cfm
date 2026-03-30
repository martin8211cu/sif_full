<style type="text/css">
<!--
.flat {	border:1px solid #7f9db9;
}
-->
</style>

<cfif isdefined("url.parametro") and not isdefined("form.parametro")>
	<cfset form.parametro = url.parametro>
</cfif>

<cfif isdefined("form.parametro") and Len(form.parametro)>
	<cfquery datasource="asp" name="data">
		select parametro,pnombre,es_global,es_cuenta,es_usuario,predeterminado
		from PLista 
		where parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.parametro#">
	</cfquery>
<cfelse>
	<cfset data = QueryNew('parametro,pnombre,es_global,es_cuenta,es_usuario,predeterminado')>
</cfif>
<cfoutput>
<form id="form1" name="form1" method="post" action="plista-apply.cfm">
<table><tr>
  <td colspan="2">Definici&oacute;n de par&aacute;metros</td></tr>
  <tr>
    <td>C&oacute;digo</td>
    <td><input name="parametro" type="text" value="#HTMLEditFormat(data.parametro)#" <cfif len(data.parametro)>readonly</cfif> class="flat" id="parametro" onFocus="this.select()" size="40" maxlength="40">
	<input name="parametro0" type="hidden" value="#HTMLEditFormat(data.parametro)#">
	</td>
  </tr>
  <tr>
    <td>Nombre</td>
    <td><input name="pnombre" type="text" class="flat" value="#HTMLEditFormat(data.pnombre)#" id="pnombre" onFocus="this.select()" size="40" maxlength="60"></td>
  </tr>
  <tr>
    <td>Valor predeterminado </td>
    <td><input name="predeterminado" type="text" class="flat" value="#HTMLEditFormat(data.predeterminado)#" id="predeterminado" onFocus="this.select()" size="40" maxlength="60"></td>
  </tr>
  <tr>
    <td colspan="2">Este par&aacute;metro aplica en los siguientes &aacute;mbitos</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="es_global" type="checkbox" id="es_global" value="1" <cfif data.es_global is 1>checked</cfif>>
      <label for="es_global">Global</label></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="es_cuenta" type="checkbox" id="es_cuenta" value="1" <cfif data.es_cuenta is 1>checked</cfif>>
      <label for="es_cuenta">Cuenta Empresarial </label></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="es_usuario" type="checkbox" id="es_usuario" value="1" <cfif data.es_usuario is 1>checked</cfif>>
      <label for="es_usuario">Usuarios</label></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td></td>
  </tr>
  <tr align="center">
    <td colspan="2"><input name="guardar" type="submit" id="guardar" value="Guardar">
	<cfif Len(data.parametro)>
      <input name="eliminar" type="submit" id="eliminar" value="Eliminar">
      <input name="nuevo" type="button" id="nuevo" onclick="location.href='index.cfm'" value="Nuevo">
	</cfif></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td></td>
  </tr>
</table>
</form><script type="text/javascript">
<!--
<cfif Len(data.parametro)>
document.form1.pnombre.focus();
<cfelse>
document.form1.parametro.focus();
</cfif>
//--></script></cfoutput>