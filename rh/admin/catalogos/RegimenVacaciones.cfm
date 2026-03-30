<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CatalogoDeRegimenDeVacaciones"
		Default="Catálogo de Régimen de Vacaciones"
		returnvariable="LB_CatalogoDeRegimenDeVacaciones"/>
				
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CODIGO"
		Default="C&oacute;digo"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_CODIGO"/>
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_DESCRIPCION"
		Default="Descripci&oacute;n"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_DESCRIPCION"/>



		
		 <cf_web_portlet_start titulo="#LB_CatalogoDeRegimenDeVacaciones#" >
		  	<cfset regresar = "/cfmx/rh/indexAdm.cfm">	
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarStatusText = ArrayNew(1)>			 
			<cfset navBarItems[1] = "Administraci&oacute;n de N&oacute;mina">
			<cfset navBarLinks[1] = "/cfmx/rh/indexAdm.cfm">
			<cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="40%" valign="top">
					<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaRH"
						returnvariable="pListaRet">
						<cfinvokeargument name="columnas" value="RVid, RVcodigo, Descripcion"/>
						<cfinvokeargument name="tabla" value="RegimenVacaciones"/>
						<cfinvokeargument name="desplegar" value="RVcodigo, Descripcion"/>
						<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
						<cfinvokeargument name="formatos" value="S,S"/>
						<cfinvokeargument name="align" value="left,left"/>
						<cfinvokeargument name="irA" value="RegimenVacaciones.cfm"/>
						<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo#"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="keys" value="RVid"/>
					</cfinvoke>
				</td>
				<td width="60%" valign="top"><cfinclude template="formRegimenVacaciones.cfm"></td>
			  </tr>
			</table>
	  <cf_web_portlet_end>
<cf_templatefooter>