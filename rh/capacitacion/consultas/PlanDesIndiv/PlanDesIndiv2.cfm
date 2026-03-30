<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>
		<cf_web_portlet_start titulo="Plan de Desarrollo Individual">
			<cfinclude template="/home/menu/pNavegacion.cfm">

			<cfif isDefined("Url.DEid") and not isDefined("Form.DEid")>
				<cfparam name="Form.DEid" default="#Url.DEid#">
			</cfif>

			<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
				<cf_rhimprime datos="/rh/capacitacion/consultas/PlanDesIndiv/PlanDesIndiv2-form.cfm" paramsuri="?DEid=#Form.DEid#">
				<cfinclude template="PlanDesIndiv2-form.cfm" >
			<cfelse>
				<p align="center"><strong>No seleccion&oacute; ning&uacute;n empleado</strong></p>
			</cfif>

			<center><form action="index.cfm"><input type="submit" value="Regresar"></form>
			</center>
		<cf_web_portlet_end>
<cf_templatefooter>