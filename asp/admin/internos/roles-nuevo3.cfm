<cfparam name="PageNum_users" default="1">
<cfparam name="url.SScodigo" default="">
<cfparam name="url.SRcodigo" default="">

<cfquery datasource="asp" name="users">
	select distinct u.Usulogin, dp.Pnombre, dp.Papellido1, dp.Papellido2, u.Usucodigo,
		ce.CEnombre, u.CEcodigo
	from Usuario u, DatosPersonales dp, CuentaEmpresarial ce
	where u.datos_personales = dp.datos_personales
	  and u.Utemporal = 0
	  and ce.CEcodigo = u.CEcodigo
	  and Usucodigo not in (
	  	select Usucodigo
		from UsuarioRol
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SScodigo#">
		  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SRcodigo#">
		)
	  and u.Usucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.uid#">
	order by CEnombre, Usulogin, dp.Pnombre, dp.Papellido1, dp.Papellido2, Usucodigo
</cfquery>
<cfif users.RecordCount is 0>
	<cflocation url="roles.cfm">
</cfif>
<cfquery datasource="asp" name="emps">
	select Ecodigo, Enombre
	from Empresa
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#users.CEcodigo#" null="#users.RecordCount is 0#">
</cfquery>
<cf_templateheader title="Asignaci&oacute;n de roles internos">
<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start titulo="Asignaci&oacute;n de grupos internos">
<cfoutput>

<script type="text/javascript">
<!--
	function validarNuevo(f) {
		if (f.emp.value == '') {
			alert("Seleccione una Empresa");
			f.emp.focus();
			return false;
		}
		return true;
	}
//-->
</script>
<form action="roles-nuevo-sql.cfm" method="post" name="form1" onSubmit="return validarNuevo(this);" >	
<input type="hidden" name="SScodigo" value="#HTMLEditFormat(url.SScodigo)#">
<input type="hidden" name="SRcodigo" value="#HTMLEditFormat(url.SRcodigo)#">
<input type="hidden" name="uid" value="#HTMLEditFormat(url.uid)#">
<br>
<table border="0" align="center" cellpadding="4" cellspacing="0">
  <tr>
    <td valign="top"><strong>Grupo seleccionado</strong> </td>
    <td valign="top">#HTMLEditFormat(url.SScodigo)#.#HTMLEditFormat(url.SRcodigo)#</td>
    </tr>
  <tr>
    <td valign="top"><strong>Cuenta Empresarial</strong></td>
    <td valign="top">#users.CEnombre#</td>
    </tr>
	
    <tr>
      <td valign="top"><strong>Usuario</strong></td>
      <td valign="top">#users.Usulogin#</td>
      </tr>
    <tr>
      <td valign="top"><strong>Nombre</strong></td>
      <td valign="top">
	  	# HTMLEditFormat( users.Pnombre) #
		#HTMLEditFormat(users.Papellido1)#
		#HTMLEditFormat(users.Papellido2)#</td>
      </tr>
    <tr>
      <td valign="top"><strong>Empresa</strong></td>
      <td valign="top"><select name="emp">
        <option value="">-Seleccione una-</option>
		<cfloop query="emps">
        <option value="#emps.Ecodigo#">#emps.Enombre#</option></cfloop>
      </select></td>
    </tr>
    <tr>
      <td colspan="2" align="center" valign="top"><input name="gr" type="submit" id="gr" value="Asignar Permiso">
        <input name="rv" type="button" id="rv" value="Cancelar" onclick="location.href='roles.cfm';"></td>
      </tr>
  </table>

</form></cfoutput>
<cf_web_portlet_end><cf_templatefooter>
