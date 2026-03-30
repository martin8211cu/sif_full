<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ReporteDeMarcasPorEmpleado" Default="Reporte de Marcas por Empleado" returnvariable="LB_ReporteDeMarcasPorEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_ReporteDeMarcasPorEmpleado#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start border="true" titulo="#LB_ReporteDeMarcasPorEmpleado#" skin="#Session.Preferences.Skin#">
	  	<cfinclude template="/rh/Utiles/params.cfm">
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td valign="top" colspan="2">
					<cfset params = ''>
                    <cfif isdefined('form.DEid') and LEN(TRIM(form.DEid))>
						<cfset params = params & '&DEid=' & form.DEid>
					</cfif>
                    <cfif isdefined('form.Opt') and form.Opt EQ 0>
                    	<cfif isdefined('form.CFid') and LEN(TRIM(form.CFid))>
							<cfset params = params & '&CFid=' & form.CFid>
                        </cfif>
                    <cfelseif isdefined('form.Opt') and form.Opt EQ 1>
                        <cfif isdefined('form.Dcodigo') and LEN(TRIM(form.Dcodigo))>
                        	<cfset params = params & '&Dcodigo=' & form.Dcodigo>
						</cfif>
					</cfif>
                    <cfif isdefined('form.Fdesde') and LEN(TRIM(form.Fdesde))>
						<cfset params = params & '&Fdesde=' & form.Fdesde>
					</cfif>
                    <cfif isdefined('form.Fhasta') and LEN(TRIM(form.Fhasta))>
						<cfset params = params & '&Fhasta=' & form.Fhasta>
					</cfif>
                    <cfif isdefined('form.RHJid') and form.RHJid GT 0>
						<cfset params = params & '&RHJid=' & form.RHJid>
					</cfif>
	                <cf_reportWFormat url="/rh/marcas/consultas/ReporteAusentismo-rep.cfm" orientacion="portrait" regresar="ReporteAusentismo.cfm" params="#params#">
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>

