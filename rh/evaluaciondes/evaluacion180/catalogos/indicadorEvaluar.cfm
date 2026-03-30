<cfif isdefined("url.IAEid") and not isdefined("form.IAEid")>
	<cfparam name="form.IAEid" default="#url.IAEid#">
</cfif>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
﻿<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_TablasDeEvaluacion"
						Default="Tablas de Evaluaci&oacute;n"
						returnvariable="LB_TablasDeEvaluacion"/>
					<cf_web_portlet_start border="true" titulo="#LB_TablasDeEvaluacion#" skin="#Session.Preferences.Skin#">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
						
						<table width="100%" cellpadding="2" cellspacing="0">
							<tr>
								<td valign="top" width="50%">
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
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Peso"
										Default="Peso"
										returnvariable="LB_Peso"/>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Jefe"
										Default="Jefe"
										returnvariable="LB_Jefe"/>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Subjefe"
										Default="Subjefe"
										returnvariable="LB_Subjefe"/>
									<cfinvoke 
									 component="rh.Componentes.pListas"
									 method="pListaRH"
									 returnvariable="pListaRet">
										<cfinvokeargument name="tabla" value="RHIndicadoresAEvaluar"/>
										<cfinvokeargument name="columnas" value="IAEid, IAEcodigo, IAEdescripcion, IAEpesop, 
										case IAEevaluajefe when 1 then '<img src=''/cfmx/rh/imagenes/checked.gif'' />' else '<img src=''/cfmx/rh/imagenes/unchecked.gif'' />' end as IAEevaluajefe, 
										case IAEevaluasubjefe when 1 then '<img src=''/cfmx/rh/imagenes/checked.gif'' />' else '<img src=''/cfmx/rh/imagenes/unchecked.gif'' />' end as IAEevaluasubjefe "/>
										
										<cfinvokeargument name="desplegar" value="IAEcodigo, IAEdescripcion, IAEpesop, IAEevaluajefe, IAEevaluasubjefe"/>
										<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_Peso#,#LB_Jefe#,#LB_Subjefe#"/>
										<cfinvokeargument name="formatos" value=""/>
										<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# order by IAEcodigo, IAEdescripcion"/>
										<cfinvokeargument name="align" value="left,left,right,center,center"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="irA" value="indicadorEvaluar.cfm"/>
										<cfinvokeargument name="debug" value="N"/>
									</cfinvoke>								
								</td>
								<td valign="top"  width="50%"><cfinclude template="indicadorEvaluar-form.cfm"></td>
							</tr>
						</table>
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>