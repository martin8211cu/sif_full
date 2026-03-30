<!--- Sección de Traducciones --->
<cfsilent>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Niveles"
	Default="Niveles"
	returnvariable="LB_Niveles"/>
﻿
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
	Key="LB_Habilidades"
	Default="Habilidades"
	returnvariable="LB_Habilidades"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Conocimientos"
	Default="Conocimientos"
	returnvariable="LB_Conocimientos"/>

</cfsilent>
<cf_templateheader title="#LB_Niveles#">

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
	              	<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
	              	<cfset filtro = "Ecodigo = #Session.Ecodigo#">	              
				  	<cfset campos_extra = ''>	              
				  	<cfif isdefined("form.fRHNcodigo") and len(trim(form.fRHNcodigo)) gt 0 >
						<cfset filtro = filtro & " and RHNcodigo like '%#ucase(form.fRHNcodigo)#%' " >
						<cfset campos_extra = campos_extra & " , '#form.fRHNcodigo#' as fRHNcodigo" >
		        	</cfif>
					<cfif isdefined("form.fRHNdescripcion") and len(trim(form.fRHNdescripcion)) gt 0 >
						<cfset filtro = filtro & " and upper(RHNdescripcion) like '%#ucase(form.fRHNdescripcion)#%' " >
						<cfset campos_extra = campos_extra & " , '#form.fRHNdescripcion#' as fRHNdescripcion" >
		            </cfif>
					<cfif isdefined("form.fRHNhabcono") and len(trim(form.fRHNhabcono)) gt 0 >
						<cfset filtro = filtro & " and RHNhabcono = '#form.fRHNhabcono#' " >
						<cfset campos_extra = campos_extra & " , '#form.fRHNhabcono#' as fRHNhabcono" >
		            </cfif>
	              	<cfset filtro = filtro & " order by RHNhabcono, RHNcodigo">
					<cf_web_portlet_start titulo="#LB_Niveles#">
						<cfif isdefined("url.RHNcodigo") and not isdefined("form.RHNcodigo")>
							<cfset form.RHNcodigo = url.RHNcodigo >
						</cfif>
						
						<cfif isdefined("url.modo") and not isdefined("form.modo")>
							<cfset form.modo = url.modo >
						</cfif>
						
						<cfset regresar = "/cfmx/rh/indexPuestos.cfm">
						<cfset navBarItems = ArrayNew(1)>
						<cfset navBarLinks = ArrayNew(1)>
						<cfset navBarStatusText = ArrayNew(1)>
						<cfset navBarItems[1] = "Administración de Puestos">
						<cfset navBarLinks[1] = "/cfmx/rh/indexPuestos.cfm">
						<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm">
						
						<cfinclude template="/rh/portlets/pNavegacion.cfm">

						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td valign="top">
									<form style="margin:0" name="filtro" method="post">
										<table border="0" width="100%" class="tituloListas">
											<tr> 
												<td><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></td>
												<td><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></td>
										  	</tr>
										  	<tr> 
												<td><input type="text" name="fRHNcodigo" tabindex="1" value="<cfif isdefined("form.fRHNcodigo") and len(trim(form.fRHNcodigo)) gt 0 ><cfoutput>#form.fRHNcodigo#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();"></td>
												<td><input type="text" name="fRHNdescripcion" tabindex="1" value="<cfif isdefined("form.fRHNdescripcion") and len(trim(form.fRHNdescripcion)) gt 0 ><cfoutput>#form.fRHNdescripcion#</cfoutput></cfif>" size="60" maxlength="60" onFocus="javascript:this.select();" ></td>
												<td>	  		
													<select name="fRHNhabcono" tabindex="1">
														<option value=""><cf_translate key="CMB_Todos" XmlFile="/rh/generales.xml">Todos</cf_translate></option> 
														<option value="H" <cfif isdefined("form.fRHNhabcono") and form.fRHNhabcono eq 'H' >selected</cfif>><cf_translate key="CMB_Habilidad">Habilidad</cf_translate></option>
														<option value="C" <cfif isdefined("form.fRHNhabcono")  and form.fRHNhabcono eq 'C' >selected</cfif> ><cf_translate key="CMB_Conocimiento">Conocimiento</cf_translate></option>
													</select>
												</td>
											</tr>
											<tr>	
												<td colspan="3" align="right">
													<cfoutput>
														<input type="submit" name="Filtrar" value="#BTN_Filtrar#" tabindex="1">
														<input type="button" name="Limpiar" value="#BTN_Limpiar#" tabindex="1" onClick="javascript:limpiar();">
													</cfoutput>
												</td>
										  	</tr>
										</table>
								  	</form>						

									<cfinvoke 
											 component="rh.Componentes.pListas"
											 method="pListaRH"
											 returnvariable="pListaRet">
										<cfinvokeargument name="tabla" value="RHNiveles"/>
										<cfinvokeargument name="columnas" value="RHNid, RHNcodigo, case when len(RHNdescripcion) > 60 then {fn concat(substring(RHNdescripcion,1,57),'...')} else RHNdescripcion end as RHNdescripcion, case RHNhabcono when 'H' then '#LB_Habilidades#' when 'C' then '#LB_Conocimientos#' end as RHNhabcono #campos_extra#"/>
										<cfinvokeargument name="desplegar" value="RHNcodigo, RHNdescripcion"/>
										<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
										<cfinvokeargument name="formatos" value="V, V"/>
										<cfinvokeargument name="filtro" value="#filtro#"/>
										<cfinvokeargument name="align" value="left, left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="irA" value="PuestosNiveles.cfm"/>
										<cfinvokeargument name="keys" value="RHNid"/>
										<cfinvokeargument name="debug" value="N"/>
										<cfinvokeargument name="Cortes" value="RHNhabcono"/>
									</cfinvoke>
								</td>
								<td valign="top"><cfinclude template="formPuestosNiveles.cfm"></td>
							</tr>
						</table>
	              <cf_web_portlet_end>
	              <script type="text/javascript" language="javascript1.2">
						function limpiar(){
							document.filtro.fRHNcodigo.value = '';
							document.filtro.fRHNdescripcion.value = '';
							document.filtro.fRHNhabcono.value = '';
						}
		            </script>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>