<cf_templateheader title="Inventarios - Conversi&oacute;n de Unidades de Art&iacute;culos">
	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Conversi&oacute;n de Unidades de Art&iacute;culos'>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2">
						<cfinclude template="../../portlets/pNavegacion.cfm">
					</td>
				</tr>
				<cfinclude template="paramURL-FORM.cfm">
				<cfif isdefined("url.CUAUcodigo") and len(trim(url.CUAUcodigo))>
					<cfset form.CUAUcodigo = url.CUAUcodigo>
				</cfif>

				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
				<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
					<cfset form.Pagina2 = url.Pagina2>
				</cfif>
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
				<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
					<cfset form.Pagina2 = url.PageNum_Lista2>
				</cfif>
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
				<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
					<cfset form.Pagina2 = form.PageNum2>
				</cfif>					
				<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
				<cfparam name="form.Pagina2" default="1">				
								
				<cfset navegacionConver = "">
				<cfif isdefined("form.Aid") and len(trim(form.Aid)) gt 0>
					<cfset navegacionConver = "Aid=#form.Aid#">
				</cfif>  

				<TR><TD colspan="2">&nbsp;</TD></TR>
				<tr><td colspan="2">
					<cfinclude template="articulos-link.cfm">
				</td></tr>
				<tr> 
					<td valign="top" width="50%"> 									  
						<cfset campos_extraConver = '' >
 						<cfif isdefined("form.Pagina2") and len(trim(form.Pagina2))>
							<cfset navegacionConver = navegacionConver & "&Pagina2=#form.Pagina2#">
							<cfset campos_extraConver = campos_extraConver & ",'#form.Pagina2#' as Pagina2" >
						</cfif>
						<cfif isdefined("form.Pagina") and form.Pagina NEQ ''>
							<cfset campos_extraConver = campos_extraConver & ",'#form.Pagina#' as Pagina" >
							<cfset navegacionConver = navegacionConver & "&Pagina=#form.Pagina#">
						</cfif>
						<cfif isdefined("form.filtro_Acodigo") and form.filtro_Acodigo NEQ ''>
							<cfset campos_extraConver = campos_extraConver & ",'#form.filtro_Acodigo#' as filtro_Acodigo" >
							<cfset navegacionConver = navegacionConver & "&filtro_Acodigo=#form.filtro_Acodigo#">
						</cfif>
						<cfif isdefined("form.filtro_Acodalterno") and form.filtro_Acodalterno NEQ ''>
							<cfset campos_extraConver = campos_extraConver & ",'#form.filtro_Acodalterno#' as filtro_Acodalterno" >
							<cfset navegacionConver = navegacionConver & "&filtro_Acodalterno=#form.filtro_Acodalterno#">
						</cfif>												
						<cfif isdefined("form.filtro_Adescripcion") and form.filtro_Adescripcion NEQ ''>
							<cfset campos_extraConver = campos_extraConver & ",'#form.filtro_Adescripcion#' as filtro_Adescripcion" >
							<cfset navegacionConver = navegacionConver & "&filtro_Adescripcion=#form.filtro_Adescripcion#">
						</cfif>			
						
 						<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaRH"
						returnvariable="pListaRet"> 
							<cfinvokeargument name="tabla" value="ConversionUnidadesArt a inner join Unidades b
																  on a.Ecodigo = b.Ecodigo and a.Aid = #form.Aid# 
																  and a.Ucodigo = b.Ucodigo "/> 
							<cfinvokeargument name="columnas" value="a.Aid
																	, a.Ucodigo as CUAUcodigo
																	, a.Ecodigo
																	, a.CUAfactor
																	, b.Udescripcion
																	#preservesinglequotes(campos_extraConver)#"/> 
							<cfinvokeargument name="desplegar" value="Udescripcion, CUafactor"/> 
							<cfinvokeargument name="etiquetas" value="Unidad Conversi&oacute;n,Factor"/> 
							<cfinvokeargument name="formatos" value="V,M"/> 
							<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
																	and	a.Aid = #form.Aid#
																	order by a.Ucodigo"/> 
							<cfinvokeargument name="align" value="left,left"/> 
							<cfinvokeargument name="ajustar" value="N"/> 
							<cfinvokeargument name="checkboxes" value="N"/> 
							<cfinvokeargument name="irA" value="ConversionUnidadesArticulo.cfm"/> 								
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="CUAUcodigo"/> 
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="PageIndex" value="2"/>
							<cfinvokeargument name="navegacion" value="#navegacionConver#"/>
							<cfinvokeargument name="maxRows" value="25"/>
						</cfinvoke>
					</td>
					<td valign="top" width="50%">
						<cfinclude template="formConversionUnidadesArticulo.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>	
	<cf_templatefooter>