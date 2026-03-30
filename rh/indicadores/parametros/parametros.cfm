<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
		<cfif isdefined("url.RHIcodigo") and not isdefined("form.RHIcodigo")>
			<cfset form.RHIcodigo = url.RHIcodigo >
		</cfif>
		<cfif isdefined("url.fRHIcodigo") and not isdefined("form.fRHIcodigo")>
			<cfset form.fRHIcodigo = url.fRHIcodigo >
		</cfif>
		<cfif isdefined("url.fRHIvalor") and not isdefined("form.fRHIvalor")>
			<cfset form.fRHIvalor = url.fRHIvalor >
		</cfif>
		<cfif isdefined("url.fRHIdescripcion") and not isdefined("form.fRHIdescripcion")>
			<cfset form.fRHIdescripcion = url.fRHIdescripcion >
		</cfif>

		<script language="JavaScript1.2" type="text/javascript">
			function limpiar(){
				document.filtro.fRHIcodigo.value 		= "";
				document.filtro.fRHIvalor.value   		= "";
				document.filtro.fRHIdescripcion.value   = "";
			}
		</script>

		<cfset filtro = "">
		<cfset navegacion = "">

		<cfif isdefined("form.fRHIcodigo") and len(trim(form.fRHIcodigo)) gt 0 >
			<cfset filtro = filtro & " and RHIcodigo = #form.fRHIcodigo# " >
			<cfset navegacion = navegacion & "&fRHIcodigo=#form.fRHIcodigo#" >
		</cfif>
		<cfif isdefined("form.fRHIvalor") and len(trim(form.fRHIvalor)) gt 0 >
			<cfset filtro = filtro & " and upper(RHIvalor) like '%#ucase(form.fRHIvalor)#%' " >
			<cfset navegacion = navegacion & "&fRHIvalor=#form.fRHIvalor#" >
		</cfif>
		<cfif isdefined("form.fRHIdescripcion") and len(trim(form.fRHIdescripcion)) gt 0 >
			<cfset filtro = filtro & " and upper(RHIdescripcion) like '%#ucase(form.fRHIdescripcion)#%' " >
			<cfset navegacion = navegacion & "&fRHIdescripcion=#form.fRHIdescripcion#" >
		</cfif>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Parametrizacion_de_Indicadores"
			Default="Parametrizaci&oacute;n de Indicadores"
			returnvariable="LB_Parametros"/>		
			

	  <cf_web_portlet_start titulo="#LB_Parametros#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">

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
			Key="LB_Valor"
			Default="Valor"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_VALOR"/>
	

			<table width="100%" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="50%" valign="top">
					<form name="filtro" method="post" style="Margin:0"> 
					<table border="0" width="100%" class="areaFiltro">
					  <tr> 
						<td ><cfoutput><strong>#LB_CODIGO#:</strong></cfoutput></td>
						<td ><cfoutput><strong>#LB_VALOR#:</strong></cfoutput></td>
						<td ><cfoutput><strong>#LB_DESCRIPCION#:</strong></cfoutput></td>
					    <td align="center" rowspan="2" valign="middle">
						  <input type="submit" name="Filtrar" class="btnFiltrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
					  	</td>
					    <td align="center" rowspan="2" valign="middle">
				          <input type="button" name="Limpiar" class="btnNormal" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onclick="javascript:limpiar();">
					    </td>
						
					  </tr>
					  <tr>
						<td>
							<cfset v_valor = '' >
							<cfif isdefined("form.fRHIcodigo") and len(trim(form.fRHIcodigo)) gt 0 >
								<cfset v_valor = form.fRHIcodigo >
							</cfif>
							<cf_monto name="fRHIcodigo" size="3" decimales="0" value="#v_valor#">
						</td>
						<td><input type="text" name="fRHIvalor" value="<cfif isdefined("form.fRHIvalor") and len(trim(form.fRHIvalor)) gt 0 ><cfoutput>#form.fRHIvalor#</cfoutput></cfif>" size="10" maxlength="50" onfocus="javascript:this.select();" ></td>
						<td><input type="text" name="fRHIdescripcion" value="<cfif isdefined("form.fRHIdescripcion") and len(trim(form.fRHIdescripcion)) gt 0 ><cfoutput>#form.fRHIdescripcion#</cfoutput></cfif>" size="25" maxlength="100" onfocus="javascript:this.select();" ></td>
				      </tr>
					</table>
					</form>

					<cfquery name="rs_lista" datasource="#session.DSN#">
						select a.RHIcodigo, a.RHIvalor, a.RHIdescripcion 
						from RHIndicadores a 
						where 1 = 1
						#preservesinglequotes(filtro)#
						order by a.RHIcodigo
					</cfquery>
					
					<cfinvoke
					component="rh.Componentes.pListas"
					method="pListaquery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rs_lista#"/>
					<cfinvokeargument name="desplegar" value="RHIcodigo, RHIvalor, RHIdescripcion"/>
					<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_VALOR#,#LB_DESCRIPCION#"/>
					<cfinvokeargument name="formatos" value="V, V, V"/>
					<cfinvokeargument name="align" value="left, left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" value="parametros.cfm"/>
					<cfinvokeargument name="keys" value="RHIcodigo"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="debug" value="N"/>
					</cfinvoke>
				</td>
                <td width="1%" valign="top">&nbsp;</td>
                <td width="58%" valign="top"><cfinclude template="parametros-form.cfm"></td>
              </tr>
			 </table>
	  <cf_web_portlet_end>

<cf_templatefooter>
