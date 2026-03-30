<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ReporteDeDepositosElectronicos" Default="Reporte de Dep&oacute;sitos Electr&oacute;nicos" returnvariable="LB_ReporteDeDepositosElectronicos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ReporteDeDepositosCheques" Default="Reporte de Dep&oacute;sitos Cheques" returnvariable="LB_ReporteDeDepositosCheques" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_TipodeNomina" Default="Tipo de Nómina" returnvariable="MSG_TipodeNomina" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="MSG_NominaAplicada" Default="Nómina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="MSG_NominaNoAplicada" Default="Nómina no Aplicada" returnvariable="MSG_NominaNoAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="MSG_ElTipoDeCambioDebeSerMayorACero" Default="El tipo de cambio debe ser mayor a cero" returnvariable="MSG_ElTipoDeCambioDebeSerMayorACero" component="sif.Componentes.Translate" method="Translate"/> 
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined('form.chq')>
	<cfset titulo = LB_ReporteDeDepositosCheques>
<cfelse>
	<cfset titulo = LB_ReporteDeDepositosElectronicos>
</cfif>

<cf_templateheader title="#titulo#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	  	<cfinclude template="/rh/Utiles/params.cfm">
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td valign="top" colspan="2">
					<cfset params = ''>
                    <cfif isdefined('form.CPcodigo')>
						<cfset params = params & '&CPcodigo=' & form.CPcodigo>
					</cfif>
                    <cfif isdefined('form.CPdescripcion')>
						<cfset params = params & '&CPdescripcion=' & form.CPdescripcion>
					</cfif>
                    <cfif isdefined('form.CPid')>
						<cfset params = params & '&CPid=' & form.CPid>
					</cfif>
                    <cfif isdefined('form.TCodigo')>
						<cfset params = params & '&TCodigo=' & form.TCodigo>
					</cfif>
                    <cfif isdefined('form.chkTxt')>
						<cfset params = params & '&chkTxt=' & form.chkTxt>
					</cfif>
					<cfset params = params & '&chq=' & form.chq>
					<cfif isdefined('form.chkTxt')>
                    	<cfinclude template="DepositosElectronicos-export.cfm">
                    	<!---<cflocation url="/rh/nomina/consultas/DepositosElectronicos-export.cfm?#params#" addToken="yes">--->
                    	<!---<cflocation url = "cfmx/rh/nomina/consultas/DepositosElectronicos-export.cfm?#params#" >--->
						<!---<cfinclude template="DepositosElectronicos-export.cfm">--->
					<cfelse>
	                <cf_reportWFormat url="/rh/nomina/consultas/DepositosElectronicos-rep.cfm" orientacion="portrait" regresar="DepositosCheques.cfm" params="#params#">
					</cfif>
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>