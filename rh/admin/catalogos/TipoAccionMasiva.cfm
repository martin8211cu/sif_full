<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
	
		<cfif isdefined("Url.RHTAid") and Len(Trim(Url.RHTAid))>
			<cfparam name="Form.RHTAid" default="#Url.RHTAid#">
		</cfif>
	
		<cfif isdefined("url.fRHTAcodigo") and not isdefined("form.fRHTAcodigo")>
			<cfset form.fRHTAcodigo = url.fRHTAcodigo >
		</cfif>
		<cfif isdefined("url.fRHTAdescripcion") and not isdefined("form.fRHTAdescripcion")>
			<cfset form.fRHTAdescripcion = url.fRHTAdescripcion >
		</cfif>

		<script language="JavaScript1.2" type="text/javascript">
			function limpiar(){
				document.filtro.fRHTAcodigo.value = "";
				document.filtro.fRHTAdescripcion.value   = "";
			}
		</script>
		
		<cfset filtro = "Ecodigo = #Session.Ecodigo#">
		<cfset adicionalCols = "">
		<cfset navegacion = "">
		<cfif isdefined("form.fRHTAcodigo") and len(trim(form.fRHTAcodigo)) gt 0 >
			<cfset filtro = filtro & " and RHTAcodigo like '%#form.fRHTAcodigo#%' " >
			<cfset adicionalCols = adicionalCols & ", '#Form.fRHTAcodigo#' as fRHTAcodigo">
			<cfset navegacion = navegacion & "&fRHTAcodigo=#form.fRHTAcodigo#" >
		</cfif>
		<cfif isdefined("form.fRHTAdescripcion") and len(trim(form.fRHTAdescripcion)) gt 0 >
			<cfset filtro = filtro & " and upper(RHTAdescripcion) like '%#ucase(form.fRHTAdescripcion)#%' " >
			<cfset adicionalCols = adicionalCols & ", '#Form.fRHTAdescripcion#' as fRHTAdescripcion">
			<cfset navegacion = navegacion & "&fRHTAdescripcion=#form.fRHTAdescripcion#" >
		</cfif>
		<cfset filtro = filtro & "order by RHTAcodigo">

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_TipoDeAccionMasiva"
		Default="Tipo de Acci&oacute;n Masiva"
		returnvariable="LB_TipoDeAccionMasiva"/>	


		<cf_web_portlet_start titulo="#LB_TipoDeAccionMasiva#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr> 
					<td width="41%" valign="top">
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
												
						
						<form name="filtro" method="post" style="Margin:0"> 
							<table border="0" width="100%" class="areaFiltro">
					  			<tr> 
									<td class="subTitulo"><cfoutput>#LB_CODIGO#:</cfoutput></td>
									<td class="subTitulo"><cfoutput>#LB_DESCRIPCION#:</cfoutput></td>
					  			</tr>
					  			<tr>
									<td><input type="text" name="fRHTAcodigo" value="<cfif isdefined("form.fRHTAcodigo") and len(trim(form.fRHTAcodigo))><cfoutput>#form.fRHTAcodigo#</cfoutput></cfif>" size="5" maxlength="3" onFocus="javascript:this.select();" ></td>
									<td><input type="text" name="fRHTAdescripcion" value="<cfif isdefined("form.fRHTAdescripcion") and len(trim(form.fRHTAdescripcion))><cfoutput>#form.fRHTAdescripcion#</cfoutput></cfif>" size="60" maxlength="60" onFocus="javascript:this.select();" ></td>
					  			</tr>
					  			<tr>
					    			<td colspan="2" align="center">
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
									
										<input type="submit" name="Filtrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
				          				<input type="button" name="Limpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onClick="javascript:limpiar();">
					    			</td>
				      			</tr>
							</table>
						</form>		

 						<cfinvoke
						 component="rh.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="RHTAccionMasiva"/>
						<cfinvokeargument name="columnas" value="RHTAid, RHTid, RHTAcodigo, RHTAdescripcion #adicionalCols#"/>
						<cfinvokeargument name="desplegar" value="RHTAcodigo, RHTAdescripcion"/>
						<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
						<cfinvokeargument name="formatos" value="V, V"/>
						<cfinvokeargument name="filtro" value="#filtro#"/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="TipoAccionMasiva.cfm"/>
						<cfinvokeargument name="keys" value="RHTAid"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="maxRows" value="20"/>
						</cfinvoke>
					</td>
					<td width="1%" valign="top">&nbsp;</td>
 					<td width="58%" valign="top">
						<cfinclude template="TipoAccionMasiva-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>

