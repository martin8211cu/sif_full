<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_TituloPortlet"
					Default="Lista de Conceptos para Expediente"
					returnvariable="TituloPortlet"/>

	  <cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#TituloPortlet#">
		<cfset navBarItems = ArrayNew(1)>
		<cfset navBarLinks = ArrayNew(1)>
		<cfset navBarStatusText = ArrayNew(1)>			 
		<cfset navBarItems[1] = "Estructura Organizacional">
		<cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
		<cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">						
		<cfset Regresar = "/cfmx/rh/indexEstructura.cfm">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Concepto"
			Default="Concepto"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_Concepto"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Fecha"
			Default="Fecha"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_Fecha"/>
		
		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="EConceptosExpediente ece"/>
			<cfinvokeargument name="columnas" value="ECEid, {fn concat(ece.ECEcodigo, {fn concat('-',ece.ECEdescripcion)})} as Descripcion, ECEfecha"/>
			<cfinvokeargument name="desplegar" value="Descripcion, ECEfecha"/>
			<cfinvokeargument name="etiquetas" value="#LB_Concepto#, #LB_Fecha#"/>
			<cfinvokeargument name="formatos" value="V,D"/>
			<cfinvokeargument name="formName" value="lista"/>
			<cfinvokeargument name="filtro" value="ece.CEcodigo = #Session.CEcodigo# 
												   order by ece.ECEcodigo"/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="maxRows" value="0"/>
			<cfinvokeargument name="botones" value="Nuevo"/>
			<cfinvokeargument name="irA" value="Conceptos.cfm"/>
		</cfinvoke>
	  <cf_web_portlet_end>
<cf_templatefooter>      
