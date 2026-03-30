<!--- Consultas --->
<cfinclude template="../portlets/pQuienSoy.cfm">
<cfquery name="roles" datasource="#Session.DSN#">
	<cfif Session.secfw.soy_pso>
		<!--- Query para obtener el rol de agente,
			solamente si soy pso --->
		select distinct rtrim(r.rol) as rol, rtrim(r.sistema) as sistema, s.nombre as nombre_sistema, r.nombre--, porque = 'soy pso'
		from Rol r, Sistema s
		where r.empresarial = 0
		  and r.interno = 1
		  and r.activo = 1
		  and r.rol = 'sys.agente'
		  and s.sistema = r.sistema
	  
		union
		<!--- Query para obtener los roles de TODOS los usuarios,
			porque pso es agente de todos --->
		select distinct rtrim(r.rol) as rol, rtrim(r.sistema) as sistema, s.nombre as nombre_sistema, r.nombre--, porque = 'soy pso, vale como agente de ' + u.Usulogin
		from Usuario u, UsuarioPermiso up, Rol r, Sistema s
		where u.activo = 1
		  and up.Usucodigo = u.Usucodigo
		  and up.Ulocalizacion = u.Ulocalizacion
		  and up.activo = 1
		  and r.rol = up.rol
		  and r.empresarial = 0
		  <!--- and r.interno = 0 --->
		  and r.activo = 1
		  and s.sistema = r.sistema
		  
		union

		select distinct rtrim(r.rol) as rol, rtrim(r.sistema) as sistema, s.nombre as nombre_sistema, r.nombre--, porque = 'soy pso, vale como admin de ' + cce.nombre
		from CuentaClienteEmpresarial cce, UsuarioEmpresarial ue, UsuarioEmpresa ue2, UsuarioPermiso up, Rol r, Sistema s
		where cce.activo = 1
		  and ue.cliente_empresarial = cce.cliente_empresarial
		  and ue.activo = 1
		  and ue2.Usucodigo = ue.Usucodigo
		  and ue2.Ulocalizacion = ue.Ulocalizacion
		  and ue2.cliente_empresarial = ue.cliente_empresarial
		  and ue2.activo = 1
		  and up.Usucodigo = ue.Usucodigo
		  and up.Ulocalizacion = ue.Ulocalizacion
		  and up.Ulocalizacion = ue2.Ulocalizacion
		  and up.cliente_empresarial = ue2.cliente_empresarial
		  and up.activo = 1
		  and r.rol = up.rol
		  and r.empresarial = 1
		  and r.interno = 0
		  and r.activo = 1
		  and s.sistema = r.sistema

	</cfif>

	<cfif Session.secfw.soy_agente and not Session.secfw.soy_pso>
		<!--- Query para obtener los roles personales de mis usuarios,
			solamente si soy agente
			si soy pso no aplica porque en el query de arriba ya estan
			incluidos
			--->
		select distinct rtrim(r.rol) as rol, rtrim(r.sistema) as sistema, s.nombre as nombre_sistema, r.nombre--, porque = 'soy agente de ' + u.Usulogin
		from Usuario u, UsuarioPermiso up, Rol r, Sistema s
		where u.agente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		  and u.agente_loc = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
		  and u.activo = 1
		  and up.Usucodigo = u.Usucodigo
		  and up.Ulocalizacion = u.Ulocalizacion
		  and up.activo = 1
		  and r.rol = up.rol
		  and r.empresarial = 0
		  and r.interno = 0
		  and r.activo = 1
		  and s.sistema = r.sistema
		  
		union
	</cfif>

	<cfif not Session.secfw.soy_pso>
		<!--- Query para obtener los roles de los usuarios 
			de las empresas que yo administre --->
		select distinct rtrim(r.rol) as rol, rtrim(r.sistema) as sistema, s.nombre as nombre_sistema, r.nombre--, porque = 'soy admin de ' + cce.nombre
		from UsuarioEmpresarial yo, CuentaClienteEmpresarial cce, UsuarioEmpresarial ue, UsuarioEmpresa ue2, UsuarioPermiso up, Rol r, Sistema s
		where yo.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		  and yo.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
		  and yo.activo = 1
		  and yo.admin = 1
		  and cce.cliente_empresarial = yo.cliente_empresarial
		  and cce.activo = 1
		  and ue.cliente_empresarial = cce.cliente_empresarial
		  and ue.activo = 1
		  and ue2.Usucodigo = ue.Usucodigo
		  and ue2.Ulocalizacion = ue.Ulocalizacion
		  and ue2.cliente_empresarial = ue.cliente_empresarial
		  and ue2.activo = 1
		  and up.Usucodigo = ue.Usucodigo
		  and up.Ulocalizacion = ue.Ulocalizacion
		  and up.Ulocalizacion = ue2.Ulocalizacion
		  and up.cliente_empresarial = ue2.cliente_empresarial
		  and up.activo = 1
		  and r.rol = up.rol
		  and r.empresarial = 1
		  and r.interno = 0
		  and r.activo = 1
		  and s.sistema = r.sistema
	</cfif>
	  
	order by 3,4,1
</cfquery>
<script type="text/javascript">

var cntchecked = 0;

function checkall() {
	if (!f.rol) return;
	if (f.rol.length) {
		var maxcheck = f.rol.length;
		var checked = f.chkall.checked;
		for (i=0;i<f.rol.length;i++){
			if (i % 10 == 0) {
				window.status = i + " de " + maxcheck;
			}
			f.rol[i].checked = checked;
		}
		window.status = "";
		cntchecked = f.chkall.checked ? maxcheck : 0;
	} else {
		f.rol.checked = f.chkall.checked;
		cntchecked = f.chkall.checked ? 1 : 0;
	}
}
function checkinv(c) {
	var maxcheck = f.rol.length ? f.rol.length : 1;
	cntchecked += c.checked ? +1 : -1;
	f.chkall.checked = (cntchecked == maxcheck);
	window.status = cntchecked + " de " + maxcheck + " " + c.title;
}
</script>

<form action="cartas_usuario.cfm" method="post" name="f" style="margin:0">
<div class="subTitulo">Criterio de selecci&oacute;n</div>
  <table border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td valign="top">
	  	<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
			  <td>Apellido desde</td>
			  <td>Apellido hasta</td>
			</tr>
			<tr>
			  <td><input type="text" name="ap1">
			  </td>
			  <td><input type="text" name="ap2"></td>
			</tr>
      	</table>
	  </td>
    </tr>
    <tr>
      <td valign="top">
	  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			  <td colspan="6"><strong><input type="checkbox" name="chkall" onClick="checkall()" value="1">Roles</strong></td>
			</tr>
			<tr>
			  <cfset sis=""><cfset n="0">
			  <cfoutput query="roles">
				<cfif sis neq roles.sistema>
					<cfif len(trim(sis)) neq 0></tr><tr></cfif>
					<td colspan="6" title="#sistema#">&nbsp;&nbsp;<strong><em>#nombre_sistema#</em></strong></td>
					</tr><tr>
					<cfset sis= sistema>
					<cfset n="0">
				</cfif>
				<cfif n neq 0 and (n mod 3 eq 0)></tr><tr>
				</cfif>
				<cfset n=n+1>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="rol" onClick="javascript: checkinv(this)" title="#rol#" value="#rol#">
				</td>
				<td title="#rol#">#nombre#
				</td>
			  </cfoutput>
			  </tr>
      	</table>
	  </td>
	</tr>
	<tr>
		<td><input type="checkbox" name="reimp" value="1"/><strong>Reimpresi&oacute;n (Muestra cartas ya impresas con anterioridad)</strong></td>
	</tr>
    <tr>
      <td valign="top"><input name="filtrar" type="submit" id="filtrar" value="Filtrar"></td>
    </tr>
  </table>
</form>