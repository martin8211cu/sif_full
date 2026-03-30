<CF_NAVEGACION NAME="CMPid">
<CF_NAVEGACION NAME="Pantalla">
<CF_NAVEGACION NAME="OPT">

<cfif (NOT ISDEFINED('Session.Compras.ProcesoCompra.CMPid') OR NOT LEN(TRIM(Session.Compras.ProcesoCompra.CMPid))) AND (ISDEFINED('form.CMPid') AND LEN(TRIM(form.CMPid)))>
	<CFSET Session.Compras.ProcesoCompra.CMPid = form.CMPid>
</cfif>

<!---►►Nuevo Proceso◄◄--->
<cfif isdefined('form.OPT') and ListFind('1,9',form.OPT)>
	<cfset Session.Compras.ProcesoCompra.Pantalla = 1>
    <cfset Session.Compras.ProcesoCompra.DSlinea  = ''/>
</cfif>

<!---►►Lista de Proceso◄◄--->
<cfif isdefined('form.OPT') and listFind('0',form.OPT)>
	<cfset Session.Compras.ProcesoCompra.Pantalla = form.OPT>
    <cfset Session.Compras.ProcesoCompra.DSlinea  = ''/>
</cfif>
<cfif isdefined('form.OPT') and listFind('2,3,4,5,6',form.OPT)>
	<cfset Session.Compras.ProcesoCompra.Pantalla = form.OPT>
</cfif>

<cfif isdefined('Session.Compras.ProcesoCompra.CMPid') and LEN(trim(Session.Compras.ProcesoCompra.CMPid)) and NOT isdefined('form.btnAnular_Proceso')>
    <cfquery name="rsProcesos" datasource="#session.dsn#">
    	select CMPestado from CMProcesoCompra where CMPid IN (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Session.Compras.ProcesoCompra.CMPid#">)
    </cfquery>
    <cfif NOT rsProcesos.recordCount>
    	<CFSET Session.Compras.ProcesoCompra.Pantalla  = 0>
		<CFSET Session.Compras.ProcesoCompra.CMPestado = ''>
        <cfset Session.Compras.ProcesoCompra.CMPid     = '' />
    	<cflocation url="compraProceso.cfm">
    <cfelse>
        <CFSET Session.Compras.ProcesoCompra.CMPestado = rsProcesos.CMPestado>
    </cfif>
<cfelseif (NOT ISDEFINEd('Session.Compras.ProcesoCompra.Pantalla')) and NOT isdefined('form.btnAnular_Proceso')>
		<CFSET Session.Compras.ProcesoCompra.Pantalla  = 0>
		<CFSET Session.Compras.ProcesoCompra.CMPestado = ''>
        <cfset Session.Compras.ProcesoCompra.CMPid     = ''/>
</cfif>
<cfif isdefined('Session.Compras.ProcesoCompra.Pantalla') and Session.Compras.ProcesoCompra.Pantalla EQ 0 and NOT isdefined('form.btnAnular_Proceso')>
	 	<cfset Session.Compras.ProcesoCompra.CMPid     = '' >
        <cfset Session.Compras.ProcesoCompra.CMPestado = ''>
        <cfset Session.Compras.ProcesoCompra.DSlinea = ''/>
        <cfset form.CMPid = ''>
        <cfset URL.CMPid  = ''>
</cfif>

<!--- Valida Comprador. Se asegura que solo hay acceso a est< pantalla si es un comprador --->
<cfif not (isdefined("session.compras.comprador") and len(trim(session.compras.comprador)))>
	<cf_errorCode	code = "50294" msg = " El Usuario Actual no está definido como comprador!, Acceso Denegado!">
</cfif>
<cf_templateheader title="Publicación de Compra">
<cf_web_portlet_start titulo="Publicación de Compra">	
		<cfinclude template="compraProceso-config.cfm">
		<cfinclude template="compraProceso-getData.cfm">
		<script language="javascript" type="text/javascript">
			function funcSiguiente() {
				document.form1.opt.value = '<cfoutput>#Session.Compras.ProcesoCompra.Pantalla + 1#</cfoutput>';
			}
			
			function funcAnterior() {
				document.form1.opt.value = '<cfoutput>#Session.Compras.ProcesoCompra.Pantalla - 1#</cfoutput>';
			}
		</script>
		
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
        	<cfif isdefined('form.Colorder') and form.Colorder eq 1>
				<cfset Session.Compras.ProcesoCompra.Pantalla = 0>
			</cfif>
		  <tr>
			<td valign="top">
					<cfinclude template="/sif/portlets/pNavegacion.cfm">
					<cfinclude template="compraProceso-header.cfm">
					<cfif Session.Compras.ProcesoCompra.Pantalla EQ 0>
						<cfinclude template="compraProceso-listaProcesos.cfm">
					<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ 1>
						<cfinclude template="compraProceso-listaSolic.cfm">
					<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ 2 >
						<cfif isdefined("Form.btnNotas")>
							<cfinclude template="compraProceso-notas.cfm">
						<cfelse>
							<cfinclude template="compraProceso-form.cfm">
						</cfif>
					<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ 3>
						<cfinclude template="compraProceso-invitacion.cfm">
					<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ 4>
						<cfinclude template="compraProceso-resumen.cfm">
					<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ 5>											
						<cfinclude template="compraProceso-cotizmanual.cfm">
					<cfelseif Session.Compras.ProcesoCompra.Pantalla EQ 6>
						<cfinclude template="compraProceso-importcoti.cfm">
					</cfif>
				
			</td>
			<td width="1%" valign="top">
				<cfinclude template="compraProceso-progreso.cfm"><br>
				<cfinclude template="compraProceso-ayuda.cfm">
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
