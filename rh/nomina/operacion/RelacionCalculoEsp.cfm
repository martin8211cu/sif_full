<!---modifica para subir nuevamente y agregar en parche--->
<!-- InstanceBegin template="/Templates/LMenuRH1.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
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
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<!--- Consultas --->
<!--- Tipos de Nómina que tienen un calendario de pago de tipo especial --->
<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
	select rtrim(a.Tcodigo) as Tcodigo, a.Tdescripcion
	from TiposNomina a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and exists (
		select 1
		from CalendarioPagos b
		where a.Tcodigo = b.Tcodigo
		and a.Ecodigo = b.Ecodigo
		and b.CPfcalculo is null
		and b.CPtipo = 1
		and not exists(
			select 1
			from RCalculoNomina rc
			where rc.RCNid = b.CPid
			)
	)
	order by a.Tdescripcion
</cfquery>
<cfif rsTiposNomina.RecordCount EQ 0>
	<cfthrow message="No hay relaciones de Cálculo Especiales definidas.">
</cfif>
<!--- Calendarios --->
<cfquery name="PaySchedAfterRestrict" datasource="#Session.DSN#">
	select 
		a.CPcodigo, 
		a.CPid, 
		rtrim(a.Tcodigo) as Tcodigo, 
		a.CPdesde, 
		a.CPhasta
	from CalendarioPagos a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.CPfenvio is null
	and a.CPtipo = 1
	and not exists (
		select 1
		from RCalculoNomina h
		where a.Ecodigo = h.Ecodigo
		and a.Tcodigo = h.Tcodigo
		and a.CPdesde = h.RCdesde
		and a.CPhasta = h.RChasta
		and a.CPid = h.RCNid
	)
	and not exists (
		select 1
		from HERNomina i
		where a.Tcodigo = i.Tcodigo
		and a.Ecodigo = i.Ecodigo
		and a.CPdesde = i.HERNfinicio
		and a.CPhasta = i.HERNffin
		and a.CPid = i.RCNid
	)
</cfquery>
<cfif rsTiposNomina.RecordCount EQ 0>
	<cfthrow message="No hay Calendarios definidos para Nóminas Especiales.">
</cfif>
<cfquery name="MinFechasNomina" dbtype="query">
	select Tcodigo, min(CPdesde) as CPdesde
	from PaySchedAfterRestrict
	group by Tcodigo
</cfquery>
<cf_templateheader title="Recursos Humanos">
	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<!-- InstanceBeginEditable name="head" -->
					<!-- InstanceEndEditable -->	
                    <!-- InstanceBeginEditable name="MenuJS" --> 
					<!-- InstanceEndEditable -->					
					<!-- InstanceBeginEditable name="Mantenimiento" -->
					  
					  <cfinvoke component="sif.Componentes.TranslateDB"
						method="Translate"
						VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
						Default="Relaci&oacute;n de C&aacute;lculo de N&oacute;mina"
						VSgrupo="103"
						returnvariable="nombre_proceso"/>
					  <cfif nombre_proceso EQ "">
						  <cfset nombre_proceso = "Relacion de Calculo de Nomina Especial">
					  </cfif>
					  <cf_web_portlet_start  titulo="#nombre_proceso#">
							<cfset Regresar = "RelacionCalculoEsp-lista.cfm">
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
							  <tr valign="top"> 
								<td>&nbsp;</td>
							  </tr>
							  <tr valign="top"> 
								<td align="center">
								  <cfinclude template="RelacionCalculoEsp-form.cfm">
								</td>
							  </tr>
							  <tr valign="top"> 
								<td>&nbsp;</td>
							  </tr>
							</table>
					  <cf_web_portlet_end>
				    <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
<cf_templatefooter><!-- InstanceEnd -->