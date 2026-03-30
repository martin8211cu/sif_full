<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_NivelesProfesionales"
			Default="Niveles Profesionales"
			returnvariable="LB_NivelesProfesionales"/>
	  <cf_web_portlet_start titulo="#LB_NivelesProfesionales#">
		  		<table width="100%" cellpadding="0" cellspacing="0">
					<cfset regresar = "/cfmx/rh/indexEstructura.cfm" >
					<cfset navBarItems = ArrayNew(1)>
					<cfset navBarLinks = ArrayNew(1)>
					<cfset navBarStatusText = ArrayNew(1)>			 
					<cfset navBarItems[1] = "Estructura Organizacional">
					<cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
					<cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">			
					<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
					
					<tr>
						<!--- lista --->
						<td valign="top" width="45%">
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Codigo"
								Default="C&oacute;digo"
								XmlFile="/rh/generales.xml"
								returnvariable="LB_Codigo"/>

							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Descripcion"
								Default="Descripci&oacute;n"
								XmlFile="/rh/generales.xml"
								returnvariable="LB_Descripcion"/>
	
							<cfinvoke 
							 component="rh.Componentes.pListas"
							 method="pListaRH"
							 returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="NProfesional"/>
								<cfinvokeargument name="columnas" value="NPcodigo, NPdescripcion"/>
								<cfinvokeargument name="desplegar" value="NPcodigo, NPdescripcion"/>
								<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
								<cfinvokeargument name="formatos" value="V,V"/>
								<cfinvokeargument name="filtro" value="Ecodigo= #session.Ecodigo# order by NPcodigo"/>
								<cfinvokeargument name="align" value="left, left"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="irA" value="NivelProfesional.cfm"/>
								<cfinvokeargument name="keys" value="NPcodigo"/>
							</cfinvoke>
						</td>

						<!--- mantenimiento --->
						<td valign="top"><cfinclude template="formNivelProfesional.cfm"></td>
					</tr>
				</table>
	  <cf_web_portlet_end>
<cf_templatefooter>