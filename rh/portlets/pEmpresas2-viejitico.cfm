<cfif not isdefined("Session.Ecodigo")>
	<cflock scope="session" timeout="20" type="exclusive">
		<cfparam name="Session.Ecodigo" default="-1">
		<cfparam name="Session.EcodigoSDC" default="-1">
		<cfparam name="Session.CEcodigo" default="-1">
	</cflock>
</cfif>

<!--- <cfinclude template="/rh/portlets/cons_corporativo.cfm"> --->

<cfoutput>holaww</cfoutput><cfabort>
<cfquery name="rsEmpresas2" datasource="sdc">
select distinct
	convert(varchar,f.Ecodigo) as Ecodigosdc, 
	e.consecutivo as Ecodigo, 
	f.nombre_comercial as Edescripcion, 
	e.nombre_cache as cache, 
	convert(varchar,g.cliente_empresarial) as CEcodigo,
	g.cache_empresarial
from UsuarioEmpresarial a, UsuarioEmpresa d, EmpresaID e, UsuarioPermiso b, Rol c, Empresa f, CuentaClienteEmpresarial g
where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
  and a.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
  and a.Usucodigo = d.Usucodigo
  and a.Ulocalizacion = d.Ulocalizacion
  and a.cliente_empresarial = d.cliente_empresarial
  and a.activo = 1
  and d.activo = 1
  and d.Ecodigo = f.Ecodigo
  and d.cliente_empresarial = f.cliente_empresarial
  and f.activo = 1
  and e.Ecodigo = f.Ecodigo
  and e.sistema = 'rh'
  and e.consecutivo is not null
  and e.nombre_cache is not null
  and e.activo = 1
  and b.Usucodigo = d.Usucodigo
  and b.Ulocalizacion = d.Ulocalizacion
  and b.cliente_empresarial = d.cliente_empresarial
  and b.Ecodigo = d.Ecodigo
  and b.activo = 1
  and b.rol = c.rol
  and c.sistema = e.sistema
  and c.activo = 1
  and f.cliente_empresarial = g.cliente_empresarial
  and g.activo = 1
order by e.consecutivo
</cfquery>

<cfif rsEmpresas2.RecordCount GT 0 and not isdefined("Form.Ecodigo")>
	<cfloop query="rsEmpresas2">
		<cfif (rsEmpresas2.CurrentRow EQ 1) and (Session.Ecodigo LT 0)>
			<cflock scope="session" timeout="20" type="exclusive">
				<cfset Session.Ecodigo = rsEmpresas2.Ecodigo>
				<cfset Session.CEcodigo = rsEmpresas2.CEcodigo>
				<cfset Session.EcodigoSDC = rsEmpresas2.EcodigoSDC>
				<cfset Session.cache_empresarial = rsEmpresas2.cache_empresarial>
			</cflock>
		</cfif>
	</cfloop>
<cfelseif rsEmpresas2.RecordCount EQ 0>
	<cflocation url="/cfmx/sif/">
<cfelseif isdefined("Form.Ecodigo") and len(trim(form.Ecodigo)) GT 0>
	<cflock scope="session" timeout="20" type="exclusive">
		<cfset Session.Ecodigo = form.Ecodigo>
	</cflock>
</cfif>

<cfquery name="rsSeleccionada2" dbtype="query">
	select * from rsEmpresas2 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif rsSeleccionada2.recordcount gt 0>
<cflock scope="session" timeout="20" type="exclusive">
	<cfset Session.DSN = "#Trim(rsSeleccionada2.cache)#">
	<cfset Session.EcodigoSDC = rsSeleccionada2.Ecodigosdc>
	<cfset Session.CEcodigo = rsSeleccionada2.CEcodigo>
	<cfset Session.cache_empresarial = rsSeleccionada2.cache_empresarial>
</cflock>
<cfelse>
<cflock scope="session" timeout="20" type="exclusive">
	<cfset Session.DSN = "#Trim(rsEmpresas2.cache)#">
	<cfset Session.EcodigoSDC = rsEmpresas2.Ecodigosdc>
	<cfset Session.CEcodigo = rsEmpresas2.CEcodigo>
	<cfset Session.cache_empresarial = rsEmpresas2.cache_empresarial>
</cflock>
</cfif>

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
<script language="JavaScript">
<!--
function Empresa(empresa) {
	document.pEmpresas2.submit();
}
//-->
</script>
 <cf_templatecss>
 <cfoutput>
  <form name="pEmpresas2" method="post" action="/cfmx/rh/<cfif isdefined("Session.modulo") and Session.modulo neq "index">#lcase(session.modulo)#/Menu#session.modulo#<cfelse>index</cfif>.cfm">
    <table border="0" cellpadding="0" cellspacing="0">
      <tr> 
        <td rowspan="2" valign="middle"> 
		  <cfquery name="rsLogos2" datasource="sdc">
		  	select * from Empresa where Ecodigo = #iif(Len(Trim(Session.Ecodigosdc)) EQ 0,-1,Session.Ecodigosdc)#
		  </cfquery>
		  <cf_sifleerimagen Tabla="Empresa" Campo="logo" Condicion="Ecodigo = #Session.EcodigoSDC#" Conexion="sdc" imgname="Logo" autosize="false">
        </td>
        <td nowrap valign="bottom">
		<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="Empresa"
				Default="Empresa"
				XmlFile="/rh/generales.xml"
				returnvariable="Empresa"/>	
		#Empresa#:
		<font face="Arial, Helvetica, sans-serif">&nbsp; 
          </font></td>
    </tr>
    <tr>
        <td valign="top" nowrap> 
			<select name="Ecodigo"  tabindex="-1" onChange="Empresa(#rsEmpresas2.Ecodigo#)">
			  <cfloop query="rsEmpresas2"> 
				<option value="#rsEmpresas2.Ecodigo#" <cfif (isDefined("Session.Ecodigo") AND rsEmpresas2.Ecodigo EQ Session.Ecodigo)>selected</cfif>>#rsEmpresas2.Edescripcion#</option>
			  </cfloop> 
			</select>
		</td>	
    </tr>
  </table>
</form>
</cfoutput>