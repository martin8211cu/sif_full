<cfif not isdefined("Session.Ecodigo")>
	<cflock scope="session" timeout="20" type="exclusive">
		<cfparam name="Session.Ecodigo" default="-1">
		<cfparam name="Session.EcodigoSDC" default="-1">
		<cfparam name="Session.CEcodigo" default="-1">
	</cflock>
</cfif>

<cfparam name="pEmpresas_SScodigo" default="SIF">
<cfquery name="rsEmpresas2" datasource="asp">
	select distinct 
		   b.CEcodigo, 
		   e.Ecodigo as EcodigoSDC, 
		   e.Ereferencia as Ecodigo, 
		   e.Enombre as Edescripcion, 
		   g.Ccache as cache,
		   '0' as cache_empresarial, e.ts_rversion as ts_rversion
	from Usuario a, CuentaEmpresarial b, ModulosCuentaE c, vUsuarioProcesos d, Empresa e, Caches g
	where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and a.CEcodigo = b.CEcodigo
	and b.CEactiva = 1
	and b.CEcodigo = c.CEcodigo
	and c.SScodigo = d.SScodigo
	and c.SMcodigo = d.SMcodigo
	and a.Usucodigo = d.Usucodigo
	and b.CEcodigo = e.CEcodigo
	and d.Ecodigo = e.Ecodigo
	and e.Cid = g.Cid
	<!---and c.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pEmpresas_SScodigo#">--->
</cfquery>

<cfif rsEmpresas2.RecordCount GT 0 and not isdefined("Form.Ecodigo")>
	<cfloop query="rsEmpresas2">
		<cfif (rsEmpresas2.CurrentRow EQ 1) and (Session.Ecodigo LT 0)>
			<cflock scope="session" timeout="20" type="exclusive">
				<cfset Session.Ecodigo = rsEmpresas2.Ecodigo>
				<cfset Session.Enombre = rsEmpresas2.Edescripcion>
				<cfset Session.EcodigoSDC = rsEmpresas2.EcodigoSDC>
				<cfset Session.DSN = Trim(rsEmpresas2.cache)>
				<cfset Session.cache_empresarial = rsEmpresas2.cache_empresarial>
			</cflock>
		</cfif>
	</cfloop>
<cfelseif rsEmpresas2.RecordCount EQ 0>
	<cf_errorCode	code = "50447" msg = "No hay acceso a ninguna empresa. Por favor verifique con el administrador del Portal.">
	<cflocation url="/cfmx/sif/">
<cfelseif isdefined("Form.Ecodigo") and len(trim(form.Ecodigo)) GT 0>
	<!--- Validar que el Ecodigo sea correcto --->
	<cfif ListFindNoCase(ValueList(rsEmpresas2.Ecodigo,','), Form.Ecodigo, ',') NEQ 0>
		<cflock scope="session" timeout="20" type="exclusive">
			<cfset Session.Ecodigo = form.Ecodigo>
		</cflock>
	</cfif>
</cfif>

<cfquery name="rsSeleccionada2" dbtype="query">
	select * from rsEmpresas2 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfif rsSeleccionada2.recordcount gt 0>
	<cflock scope="session" timeout="20" type="exclusive">
		<cfset Session.Enombre = rsSeleccionada2.Edescripcion>
		<cfset Session.EcodigoSDC = rsSeleccionada2.EcodigoSDC>
		<cfset Session.DSN = Trim(rsSeleccionada2.cache)>
		<cfset Session.cache_empresarial = rsSeleccionada2.cache_empresarial>
	</cflock>
	<cfinvoke 
		 component="sif.Componentes.DButils"
		 method="toTimeStamp"
		 returnvariable="EmpresaTS">
			<cfinvokeargument name="arTimeStamp" value="#rsSeleccionada2.ts_rversion#"/>
		</cfinvoke>
<cfelse>
	<cflock scope="session" timeout="20" type="exclusive">
		<cfset Session.Ecodigo = rsEmpresas2.Ecodigo>
		<cfset Session.Enombre = rsEmpresas2.Edescripcion>
		<cfset Session.EcodigoSDC = rsEmpresas2.EcodigoSDC>
		<cfset Session.DSN = Trim(rsEmpresas2.cache)>
		<cfset Session.cache_empresarial = rsEmpresas2.cache_empresarial>
	</cflock>
	<cfinvoke 
		 component="sif.Componentes.DButils"
		 method="toTimeStamp"
		 returnvariable="EmpresaTS">
			<cfinvokeargument name="arTimeStamp" value="#rsEmpresas2.ts_rversion#"/>
		</cfinvoke>
</cfif>

<script language="JavaScript" type="text/JavaScript">
	<!--
	function MM_reloadPage(init) {  //reloads the window if Nav4 resized
	  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
		document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
	  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}
	MM_reloadPage(true);
	
	function Empresa() {
		document.pEmpresas2.submit();
	}
	//-->
</script>
<cf_templatecss>
 <cfoutput>
 
 
 <cfset form_action = "/cfmx/home/menu/proceso.cfm?s=#URLEncodedFormat(ListGetAt(monitoreo_modulo,1))
	#&m=#URLEncodedFormat(ListGetAt(monitoreo_modulo,2))
	#&p=#URLEncodedFormat(ListGetAt(monitoreo_modulo,3))#">


 <cfquery datasource="asp" name="actionquery">
 	select SPhomeuri
	from SProcesos
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SScodigo#">
	  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SMcodigo#">
	  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SPcodigo#">
 </cfquery>
 <cfif actionquery.RecordCount>
 	<cfset form_action = "/cfmx" & actionquery.SPhomeuri>
 </cfif>

  <form name="pEmpresas2" method="post" action="#form_action#">
 <!---
  <form name="pEmpresas2" method="post" action="/cfmx/sif/<cfif isdefined("Session.modulo") and Session.modulo neq "index">#lcase(session.modulo)#/Menu#session.modulo#<cfelse>indexSif</cfif>.cfm">
--->
    <table border="0" cellpadding="0" cellspacing="0">
      <tr> 
        <td rowspan="2" valign="middle"> 
		<img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&ts=#EmpresaTS#" border="0"><!---
		  	<cf_leerimagen autosize="true" border="false" tabla="Empresa" campo="Elogo"
				condicion="Ecodigo = #Session.EcodigoSDC# and datalength(Elogo) > 1" conexion="asp" imgname="img">--->
        </td>
        <td nowrap valign="bottom">
		#Request.Translate('Empresa','Empresa:','/sif/Utiles/Generales.xml')#
		<font face="Arial, Helvetica, sans-serif">&nbsp; 
          </font></td>
    </tr>
    <tr>
        <td valign="top" nowrap> 
			<select name="Ecodigo"  tabindex="-1" onChange="javascript: Empresa();">
			  <cfloop query="rsEmpresas2"> 
				<option value="#rsEmpresas2.Ecodigo#" <cfif (isDefined("Session.Ecodigo") AND rsEmpresas2.Ecodigo EQ Session.Ecodigo)>selected</cfif>>#rsEmpresas2.Edescripcion#</option>
			  </cfloop> 
			</select>
		</td>	
    </tr>
  </table>
</form>
</cfoutput>

