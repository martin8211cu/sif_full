<cf_templateheader title="Inventarios - Costos de Producci&oacute;n de Art&iacute;culos">
	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Costos de Producci&oacute;n de Art&iacute;culos'>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="3">
						<cfinclude template="../../portlets/pNavegacion.cfm">
					</td>
				</tr>
				<cfinclude template="paramURL-FORM.cfm">
				<cfif isdefined("url.CTDid") and len(trim(url.CTDid))>
					<cfset form.CTDid = url.CTDid>
				</cfif>

				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
				<cfif isdefined("url.Pagina4") and len(trim(url.Pagina4))>
					<cfset form.Pagina4 = url.Pagina4>
				</cfif>
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
				<cfif isdefined("url.PageNum_Lista4") and len(trim(url.PageNum_Lista4))>
					<cfset form.Pagina4 = url.PageNum_Lista4>
				</cfif>
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
				<cfif isdefined("form.PageNum4") and len(trim(form.PageNum4))>
					<cfset form.Pagina4 = form.PageNum4>
				</cfif>					
				<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
				<cfparam name="form.Pagina4" default="1">				
								
				<cfset navegacionCosPro = "">
				<cfif isdefined("form.Aid") and len(trim(form.Aid)) gt 0>
					<cfset navegacionCosPro = "Aid=#form.Aid#">
				</cfif> 				
				
				<TR><TD>&nbsp;</TD></TR>
				<tr><td colspan="3"><cfinclude template="articulos-link.cfm"></td></tr>

				<tr> 
					<td valign="top" width="50%"> 			
						<cfset campos_extraCosPro = '' >
 						<cfif isdefined("form.Pagina4") and len(trim(form.Pagina4))>
							<cfset navegacionCosPro = navegacionCosPro & "&Pagina4=#form.Pagina4#">
							<cfset campos_extraCosPro = campos_extraCosPro & ",'#form.Pagina4#' as Pagina4" >
						</cfif>
						<cfif isdefined("form.Pagina") and form.Pagina NEQ ''>
							<cfset campos_extraCosPro = campos_extraCosPro & ",'#form.Pagina#' as Pagina" >
							<cfset navegacionCosPro = navegacionCosPro & "&Pagina=#form.Pagina#">
						</cfif>
						<cfif isdefined("form.filtro_Acodigo") and form.filtro_Acodigo NEQ ''>
							<cfset campos_extraCosPro = campos_extraCosPro & ",'#form.filtro_Acodigo#' as filtro_Acodigo" >
							<cfset navegacionCosPro = navegacionCosPro & "&filtro_Acodigo=#form.filtro_Acodigo#">
						</cfif>
						<cfif isdefined("form.filtro_Acodalterno") and form.filtro_Acodalterno NEQ ''>
							<cfset campos_extraCosPro = campos_extraCosPro & ",'#form.filtro_Acodalterno#' as filtro_Acodalterno" >
							<cfset navegacionCosPro = navegacionCosPro & "&filtro_Acodalterno=#form.filtro_Acodalterno#">
						</cfif>												
						<cfif isdefined("form.filtro_Adescripcion") and form.filtro_Adescripcion NEQ ''>
							<cfset campos_extraCosPro = campos_extraCosPro & ",'#form.filtro_Adescripcion#' as filtro_Adescripcion" >
							<cfset navegacionCosPro = navegacionCosPro & "&filtro_Adescripcion=#form.filtro_Adescripcion#">
						</cfif>								
						
 						<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaRH"
						returnvariable="pListaRet"> 
							<cfinvokeargument name="tabla" value="CostoProduccionSTD"/> 
							<cfinvokeargument name="columnas" value="CTDid
																	, Aid
																	, CTDperiodo
																	, CTDmes
																	, CTDcosto
																	, case CTDmes 	when 1 then 'Enero'
																					when 2 then 'Febrero'
																					when 3 then 'Marzo'
																					when 4 then 'Abril'
																					when 5 then 'Mayo'
																					when 6 then 'Junio'
																					when 7 then 'Julio'
																					when 8 then 'Agosto'
																					when 9 then 'Setiembre'
																					when 10 then 'Octubre'
																					when 11 then 'Noviembre'
																					when 12 then 'Diciembre'												
																	end as Mes
																	#preservesinglequotes(campos_extraCosPro)#"/> 
							<cfinvokeargument name="desplegar" value="CTDperiodo, Mes, CTDcosto"/> 
							<cfinvokeargument name="etiquetas" value="Peri&oacute;do, Mes, Costo"/> 
							<cfinvokeargument name="formatos" value="V,V,M"/> 
							<cfinvokeargument name="filtro" value="	Ecodigo = #Session.Ecodigo#
																	and	Aid = #form.Aid#
																	order by CTDperiodo desc, CTDmes"/> 
							<cfinvokeargument name="align" value="left,left,rigth"/> 
							<cfinvokeargument name="ajustar" value="N"/> 
							<cfinvokeargument name="checkboxes" value="N"/> 
							<cfinvokeargument name="irA" value="CostosProduccion-Articulo.cfm"/> 								
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="CTDid"/> 
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="PageIndex" value="4"/>
							<cfinvokeargument name="navegacion" value="#navegacionCosPro#"/>
							<cfinvokeargument name="maxRows" value="25"/>																	
						</cfinvoke>
					</td>
					<td valign="top" width="50%">
						<cfinclude template="formCostosProduccion-Articulo.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>	
	<cf_templatefooter>