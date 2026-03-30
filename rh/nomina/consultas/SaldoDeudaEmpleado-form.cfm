<!--- VARIABLES DE TRADUCCION --->
<!---<cf_dump var="#form#">--->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ReporteDeSaldosDeDeudaPorEmpleado" Default="Reporte de Saldos de Deuda por Empleado" returnvariable="LB_ReporteDeSaldosDeDeudaPorEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_ReporteDeSaldosDeDeudaPorEmpleado#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start border="true" titulo="#LB_ReporteDeSaldosDeDeudaPorEmpleado#" skin="#Session.Preferences.Skin#">
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
                    <cfif isdefined('form.IDDESDE') and LEN(TRIM(form.IDDESDE))>
						<cfset params = params & '&TDidDesde=' & form.IDDESDE>
					</cfif>
					<cfif isdefined('form.IDHASTA') and LEN(TRIM(form.IDHASTA))>
						<cfset params = params & '&TDidHasta=' & form.IDHASTA>
					</cfif>
	                <cf_reportWFormat url="/rh/nomina/consultas/SaldoDeudaEmpleado-rep.cfm" orientacion="portrait" regresar="SaldoDeudaEmpleado.cfm" params="#params#">
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>

