<cfif isdefined("url.ECid") and not isdefined("form.ECid")>
	<cfset form.ECid = url.ECid >
</cfif>


<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate>
	</cf_templatearea>

	<cf_templatearea name="body">

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Codigo_Excepcion"
		Default="C&oacute;digo"
		returnvariable="LB_Codigo_Excepcion"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Descripcion_Excepcion"
		Default="Descripci&oacute;n"
		returnvariable="LB_Descripcion_Excepcion"/>	

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_PorcentajeEmpleado"
		Default="Porcentaje Empleado"
		returnvariable="LB_PorcentajeEmpleado"/>	
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_PorcentajePatrono"
		Default="Porcentaje Patrono"
		returnvariable="LB_PorcentajePatrono"/>	

		<cf_web_portlet_start border="true" titulo="Excepciones a Rebajar" skin="#session.preferences.skin#" >
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td width="50%" valign="top">

						<cfset navegacion = "&ECid=#form.ECid#" >
						<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="RHCargasRebajar a
																inner join  ECargas b
																on b.ECid=a.ECidreb"/>
							<cfinvokeargument name="columnas" value="a.ECid, b.ECcodigo, b.ECdescripcion, a.ECidreb, a.RHCRporc_emp, a.RHCRporc_pat"/>
							<cfinvokeargument name="desplegar" value="ECcodigo, ECdescripcion,RHCRporc_emp,RHCRporc_pat"/>
							<cfinvokeargument name="etiquetas" value="#LB_Codigo_Excepcion#,#LB_Descripcion_Excepcion#,#LB_PorcentajeEmpleado#,#LB_PorcentajePatrono#"/>
							<cfinvokeargument name="formatos" value="V,V,M,M"/>
							<cfinvokeargument name="filtro" value="a.ECid = #form.ECid#"/>
							<cfinvokeargument name="align" value="left,left,right,right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value="cargas-excepcion.cfm"/>
							<cfinvokeargument name="keys" value="ECidreb"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="maxrows" value="20"/>
							<cfinvokeargument name="mostrar_filtro" value="false"/>
							<cfinvokeargument name="filtrar_automatico" value="false"/>
						</cfinvoke>
					</td>
					
					<td width="50%" valign="top">
						<cfinclude template="cargas-excepcion-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>