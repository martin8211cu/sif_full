	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CapacitacionYDesarrollo"
	Default="Capacitación y desarrollo"
	returnvariable="LB_CapacitacionYDesarrollo"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_BaseEntrenamientoPorCentroFuncional"
	Default="Base entrenamiento por Centro Funcional"
	returnvariable="LB_BaseEntrenamientoPorCentroFuncional"/> 
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>
		<cf_web_portlet_start titulo="#LB_BaseEntrenamientoPorCentroFuncional#">
			<cfinclude template="/home/menu/pNavegacion.cfm">
			<cfset params = ''>
			<cfoutput>
				<cfif isdefined("url.DEid") and len(trim(url.DEid))>
					<cfset params = params&"&DEid="&url.DEid>
				</cfif>
				<cfif isdefined("url.RHCfdesde") and len(trim(url.RHCfdesde))>
					<cfset params = params&"&RHCfdesde="&url.RHCfdesde>
				</cfif>
				<cfif isdefined("url.RHCfhasta") and len(trim(url.RHCfhasta))>
					<cfset params = params&"&RHCfhasta="&url.RHCfhasta>
				</cfif>
				<cfif isdefined("url.CFid") and len(trim(url.CFid))>
					<cfset params = params&"&CFid="&url.CFid>
				</cfif>
				<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
					<cfset params = params&"&RHPcodigo="&url.RHPcodigo>
				</cfif>
			</cfoutput>
			<cfset params = Mid(params, 2, len(params))>
			<cfset params = "?"&params>
			<table width="98%" cellpadding="0" cellspacing="0" align="center">			
			<tr>
				<td width="1">&nbsp;</td>
				<td><cfinclude template="baseEntCFuncional-rep.cfm"></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td width="1">&nbsp;</td>
				<td><center>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Regresar"
				Default="Regresar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Regresar"/>
				<cfoutput>
				<form action="baseEntCFuncional.cfm"><input type="submit" value="#BTN_Regresar#"></form></center></td>
				</cfoutput>
			</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>