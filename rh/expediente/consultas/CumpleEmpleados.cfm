<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_ConsultaDeCumpleannosDeEmpleados" Default="Consulta de Cumpleaños de Empleados" returnvariable="LB_ConsultaDeCumpleannosDeEmpleados" component="sif.Componentes.Translate" method="Translate"/> 
<!--- VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
	<!--- 
	Modificado por : Rodolfo Jimenez Jara, ROJIJA
	Fecha: 05 de Enero de 2006
	Motivo: Creacion del reporte  --->
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_ConsultaDeCumpleannosDeEmpleados#">
			<cfset modulo = "pp">
			<cfif isdefined("url.RHTMid") and len(trim(url.RHTMid))>
				<cfset form.RHTMid = url.RHTMid >
			</cfif>							
			<table width="100%" border="0" cellspacing="0">
			  <tr>
			  	<td valign="top">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td>
			  </tr>
			  <tr>
				<td valign="top">
					<cfinclude template="CumpleEmpleados-form.cfm">
				</td>
			  </tr>
			</table>		
		<cf_web_portlet_end>
<cf_templatefooter>
