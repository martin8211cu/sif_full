
<cfparam name="url.fRol" default=""><cfset url.fRol = Trim(url.fRol)>
<cfparam name="url.fUid" default=""><cfset url.fUid = Trim(url.fUid)>

<cfquery datasource="asp" name="roles">
	select rtrim(SScodigo) SScodigo, rtrim(SRcodigo) SRcodigo, SRdescripcion
	from SRoles
	where SRinterno = 1
	order by SScodigo, SRcodigo
</cfquery><cf_templateheader title="Asignaci&oacute;n de roles internos">
<cf_web_portlet_start titulo="Asignaci&oacute;n de grupos internos">
<cfinclude template="/home/menu/pNavegacion.cfm">

<cfoutput>
<script type="text/javascript">
<!--
	function validarNuevo(f) {
		if (f.NuevoRol.value == '') {
			alert("Seleccione un Grupo");
			f.NuevoRol.focus();
			return false;
		}
		return true;
	}
//-->
</script>
<form action="roles-nuevo2.cfm" method="get" onSubmit="return validarNuevo(this);">
<table border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="3">Asignar nuevo grupo </td>
    <td width="24">&nbsp;</td>
  </tr>
  <tr>
    <td width="26">&nbsp; </td>
    <td width="141">Grupo</td>
    <td width="120">
      <select name="NuevoRol" id="NuevoRol">
        <option value="">-Seleccione uno-</option>
		<cfloop query="roles">
        <option value="#roles.SScodigo#.#roles.SRcodigo#">#roles.SScodigo#.#roles.SRcodigo# - #roles.SRdescripcion#</option>
		</cfloop>
      </select> </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Usuario (login o nombre) </td>
    <td><input type="text" name="Usuario" value="#HTMLEditFormat(Trim(url.fUid))#" onFocus="this.select()" size="20" maxlength="30"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2" align="center">          <input type="submit" name="Submit" value="Verificar datos &gt;&gt;">          </td>
    <td>&nbsp;</td>
  </tr>
</table></form>
</cfoutput>
<cf_web_portlet_end><cf_templatefooter>