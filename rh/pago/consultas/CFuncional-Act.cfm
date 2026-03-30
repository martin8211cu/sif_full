<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_CentrosFuncionalesInactivos" 	Default="Centros Funcionales Inactivos " returnvariable="LB_CentrosFuncionalesInactivos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_RecursosHumanos" 		Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Empleados"			Default="Empleados" returnvariable="LB_Empleados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DetalleErrores"		Default="Detalle Errores" returnvariable="LB_DetalleErrores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CentroFuncional" 		Default="Centro Funcional" returnvariable="LB_CentroFuncional" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

<cfinclude template="/rh/Utiles/params.cfm">
	<table width="100%" cellpadding="2" cellspacing="0">
      <tr>
        <td valign="top">
            <cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_CentrosFuncionalesInactivos#">
              <!--- variables para el portlet de navegación --->
              
				<cfif not isdefined("form.tab") and isdefined("url.tab")>
					<cfset form.tab = url.tab >
				</cfif>
			
				<cfparam name="form.tab" default="1">
				
				<cfif NOT ListContains('1,2', form.tab)>
					<cfset form.tab = 1 >
				</cfif>

				<cfif isdefined("url.RCNid")>
					<cfset form.RCNid = url.RCNid>
				</cfif>
				<cfif isdefined('form.Mens') and len(trim(form.Mens))>
					<center>
					<cfoutput>#form.Mens#
					Si no desea utilizar las propuestas eliminelas, y haga clic en 'Generar asientos.'<br/>
					Si desea utilizar las propuestas solo haga clic en 'Generar asientos.'
					</cfoutput>
					</center>
					<br />
				</cfif>
				
				<cfif isdefined('form.Error') and  #form.Error# EQ 1>
					<cfset form.tab= 3>
				</cfif>
				
				<cf_tabs width="99%">
					<cf_tab text="#LB_CentroFuncional#" selected="#form.tab eq 1#">
							<cfinclude template="CFuncional-Act-tab1.cfm">
					</cf_tab>
					
					<cf_tab text="#LB_Empleados#" selected="#form.tab eq 2#">
						<cf_web_portlet_start border="true" titulo="#LB_Empleados#">
							<cfinclude template="CFuncional-Act-tab2.cfm">
						<cf_web_portlet_end>
					</cf_tab>
					<cfif isdefined('form.Error') and  #form.Error# EQ 1>
						<cfset form.tab = 3>
						<cf_tab text="#LB_DetalleErrores#" selected="#form.tab eq 3#">
							<cf_web_portlet_start border="true" titulo="#LB_DetalleErrores#">
								<cfinclude template="CFuncional-Act-tab3.cfm">
							<cf_web_portlet_end>
						</cf_tab>
					</cfif>
				</cf_tabs>
			<cf_web_portlet_end>
        </td>
      </tr>
    </table>
	
<cf_templatefooter>
