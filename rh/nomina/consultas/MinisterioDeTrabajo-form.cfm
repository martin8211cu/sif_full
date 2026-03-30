<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ReporteDeMarcasPorEmpleado" Default="Reporte de Marcas por Empleado" returnvariable="LB_ReporteDeMarcasPorEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start border="true" titulo="#LB_nav__SPdescripcion#" skin="#Session.Preferences.Skin#">
	  	<cfinclude template="/rh/Utiles/params.cfm">
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td valign="top" colspan="2">
					<cfset params = ''>
                    <cfif isdefined('form.anno') and form.anno GT 0>
						<cfset params = params & '&anno=' & form.anno>
					</cfif>
					<cfif isdefined('form.TcodigoList') and LEN(TRIM(form.TcodigoList))>
						<cfset params = params & '&TcodigoList=' & form.TcodigoList>
					</cfif>
	                <cf_reportWFormat url="/rh/nomina/consultas/MinisterioDeTrabajo-rep.cfm" orientacion="portrait" regresar="MinisterioDeTrabajo.cfm" params="#params#">
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>

