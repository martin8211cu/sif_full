<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>

<cfparam name="form.DEid">
<cf_web_portlet_start titulo="Base de Entrenamiento">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<cf_rhimprime datos="/rh/capacitacion/consultas/BaseEntrenamiento/baseEntrenam-form.cfm" paramsuri="?DEid=#DEid#">
	
	<cfinclude template="baseEntrenam-form.cfm" >
	
	<center><form action="index.cfm"><input type="submit" value="Regresar"></form>
	</center>

<cf_web_portlet_end>
<cf_templatefooter>