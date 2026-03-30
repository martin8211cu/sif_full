<cfset Session.Edu.DSN = "edu">
<cfset Session.Edu.CEcodigo = 3>
<cfset Session.Edu.Usucodigo = 0>
<!--- Obtener el Usuario Equivalente --->
<cfquery name="rsUsuarioEquiv" datasource="sdc">
	select UsucodigoEdu as Usuario
	from UsuarioRef a
	where a.UsucodigoFrame = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
</cfquery>
<cfif rsUsuarioEquiv.recordCount>
	<cfset Session.Edu.Usucodigo = rsUsuarioEquiv.Usuario>
</cfif>
<cfreturn>

<cfinclude template="../Utiles/general.cfm">

<cfset CambiaSitio = false>
<cfparam name="session.Ulocalizacion" default="00">
<!---
<cfif not isdefined("Session.Usucodigo") and not isdefined("Session.Ulocalizacion")>
	<cfset StructClear(Session)>
	<cflocation url="/cfmx/sif/logout/logout.cfm">
</cfif>
--->
<cfquery name="rsEmpresas2" datasource="sdc">
	select distinct
		convert(varchar,f.Ecodigo) as Ecodigosdc, 
		convert(varchar, e.consecutivo) as CEcodigo, 
		f.nombre_comercial as CEnombre, 
		e.nombre_cache as EScache, 
		convert(varchar,g.cliente_empresarial) as cliente_empresarial,
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
	  and e.sistema = 'edu'
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
	<cfif isdefined("Session.RolActual") and Session.RolActual EQ 4>
	  and c.rol = 'edu.admin'
	<cfelseif isdefined("Session.RolActual") and Session.RolActual EQ 5>
	  and c.rol = 'edu.docente'
	<cfelseif isdefined("Session.RolActual") and Session.RolActual EQ 6>
	  and c.rol = 'edu.estudiante'
	<cfelseif isdefined("Session.RolActual") and Session.RolActual EQ 7>
	  and c.rol = 'edu.encargado'
	<cfelseif isdefined("Session.RolActual") and Session.RolActual EQ 11>
	  and c.rol = 'edu.asistente'
	<cfelseif isdefined("Session.RolActual") and Session.RolActual EQ 12>
	  and c.rol = 'edu.director'
	</cfif>
	order by e.consecutivo
</cfquery>

<!--- Si no puede acceder a ningn Centro Educativo, no debera entrar a educacion --->
<cfif rsEmpresas2.recordCount EQ 0>
<!---
	<cfset Session.Edu.CEcodigo = 0>
	<cfset Session.Edu.DSN = "">
	<cfset Session.Scodigo = 0>
	<cflocation url="/cfmx/edu/errorPages/AccRestricted.cfm">
	--->
	<cfinclude template="/edu/errorPages/AccRestricted.cfm">
</cfif>

<!---
<cfif not isdefined("Session.Edu.CEcodigo") and rsEmpresas2.recordCount GT 0>
	<cfset Session.Edu.CEcodigo = rsEmpresas2.CEcodigo>
	<cfset Session.Edu.DSN = Trim(rsEmpresas2.EScache)>
	<cfset CambiaSitio = true>
</cfif>

<!--- Validar que el usuario actual pueda utilizar el centro educativo escogido --->
<cfif isdefined("Form.CEcodigo") and Len(Trim(Form.CEcodigo)) NEQ 0>
	<cfif Find(Form.CEcodigo, ValueList(rsEmpresas2.CEcodigo)) EQ 0>
		<cfset Session.Edu.CEcodigo = rsEmpresas2.CEcodigo>
		<cfset Session.Edu.DSN = Trim(rsEmpresas2.EScache)>
	<cfelse>
		<cfset Session.Edu.CEcodigo = Form.CEcodigo>
		<cfset Session.Edu.DSN = ListGetAt(ValueList(rsEmpresas2.EScache), ListFind(ValueList(rsEmpresas2.CEcodigo), Session.Edu.CEcodigo))>
	</cfif>
	<cfset CambiaSitio = true>
<!--- Chequear que el Centro Educativo en Session siga siendo correcto --->
<cfelseif Find(Session.Edu.CEcodigo, ValueList(rsEmpresas2.CEcodigo)) EQ 0>
	<cfset Session.Edu.CEcodigo = rsEmpresas2.CEcodigo>
	<cfset Session.Edu.DSN = Trim(rsEmpresas2.EScache)>
	<cfset CambiaSitio = true>
</cfif>

--->
<cfif CambiaSitio>
	<cfquery name="rsPagWebCollege" datasource="#Session.Edu.DSN#">
		select convert(varchar, Scodigo) as Scodigo 
		from CentroEducativo a
		where a.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfif len(trim(rsPagWebCollege.Scodigo)) NEQ 0>
		<cfset Session.Scodigo = Trim(rsPagWebCollege.Scodigo)>
	<cfelse>
		<!--- insert en sdc.Sitio --->
		<cfquery name="qrySitio" datasource="#Session.Edu.DSN#">
			set nocount on
				insert sdc..Sitio (Snombre, Slogo)
				select c.nombre_comercial, c.logo 
				from CentroEducativo a,  sdc..EmpresaID b, sdc..Empresa c 
				where a.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
				  and b.sistema = 'edu' 
				  and a.CEcodigo = b.consecutivo 
				  and b.Ecodigo = c.Ecodigo

				select convert(varchar, @@identity )  as nSitio
			set nocount off
		</cfquery>
		<cfif isdefined('qrySitio') and qrySitio.RecordCount GT 0>	<!--- Logro hacer el ALTA del Sitio --->
			<!--- sacar el identity --->
			<cfset Session.Scodigo = qrySitio.nSitio>
			<!--- update del CentroEducativo para ponerle el Scodigo generado --->
			<cfquery name="updSitio" datasource="#Session.Edu.DSN#">
				update CentroEducativo 
				set Scodigo = <cfqueryparam value="#qrySitio.nSitio#" cfsqltype="cf_sql_numeric"> 
				where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
			</cfquery>
		<cfelse>	
			<cfset Session.Scodigo = 0>
		</cfif>
	</cfif>
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
function Empresa(c) {
	document.pEmpresas2.submit();
}
//-->
</script>
 <link href="../css/portlets.css" rel="stylesheet" type="text/css">
  <form name="pEmpresas2" method="post" style="margin: 0">
  <table width="90%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="30%" rowspan="2" style="padding-left: 5px; padding-right: 5px;"> 
		<cf_LoadImage tabla="CentroEducativo a,  sdc..EmpresaID b, sdc..Empresa c " columnas="logo as contenido, #Session.Edu.CEcodigo# as codigo" condicion="a.CEcodigo = #Session.Edu.CEcodigo# and b.sistema = 'edu' and a.CEcodigo = b.consecutivo and b.Ecodigo = c.Ecodigo" imgname="Logo" height="60">
	 </td>
      <td width="70%" nowrap valign="bottom">Centro Educativo:&nbsp;</td>
    </tr>
    <tr> 
      <td nowrap valign="top"><font face="Arial, Helvetica, sans-serif">
	  	<cfif rsEmpresas2.recordCount GT 1>
        <select name="CEcodigo"  tabindex="-1" onChange="Empresa(this)">
          <cfoutput query="rsEmpresas2"> 
            <option value="#rsEmpresas2.CEcodigo#" <cfif (isDefined("Session.Edu.CEcodigo") AND rsEmpresas2.CEcodigo EQ Session.Edu.CEcodigo)>selected</cfif>>#rsEmpresas2.CEnombre#</option>
          </cfoutput> 
        </select>
		<cfelse>
          <cfoutput><b><font size="3">#rsEmpresas2.CEnombre#</font></b></cfoutput> 
        </cfif>
        </font></td>
    </tr>
  </table>
</form>
