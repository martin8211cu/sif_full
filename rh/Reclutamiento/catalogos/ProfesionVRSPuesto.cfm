<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puesto_vrs_Profesion_u_Oficio"
	Default="Puesto vrs Profesi&oacute;n u Oficio"
	returnvariable="LB_Profesion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Profesion_u_Oficio"
	Default="Profesi&oacute;n u Oficio"
	returnvariable="LB_Profesion_u_Oficio"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puesto"
	Default="Puesto"
	returnvariable="LB_Puesto"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="msg_DebeSeleccionarUnPuestoPara_ver_las_profesiones_u_oficios_asociados"
	Default="Debe seleccionar un puesto para ver las profesiones u oficios asociados"
	returnvariable="msg_DebeSeleccionarUnPuesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="Código"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Si"
	Default="Si"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Si"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_No"
	Default="No"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_No"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Todos"
	Default="Todos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Todos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeProfesiones"
	Default="Lista de Profesiones"
	returnvariable="LB_ListaDeProfesiones"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Asociado"
	Default="Asociado"
	returnvariable="LB_Asociado"/>		
	

<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo)) gt 0 and not isdefined("form.RHPcodigo")  >
		<cfset form.RHPcodigo = url.RHPcodigo>
</cfif>
<cfif isdefined("url.fRHOPDescripcion") and len(trim(url.fRHOPDescripcion)) gt 0 and not isdefined("form.fRHOPDescripcion")  >
		<cfset form.fRHOPDescripcion = url.fRHOPDescripcion>
</cfif>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center">
			<cfinclude template="ProfesionVRSPuesto-form.cfm">
		<cf_web_portlet_end>
	<cf_templatefooter>