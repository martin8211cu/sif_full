<cf_templateheader title="Códigos Aduanales">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Códigos Aduanales'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="4">
			    <tr>
			      	<td>
						<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
						<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
							<cfset form.Pagina = url.Pagina>
						</cfif>
						<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
						<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
							<cfset form.Pagina = url.PageNum_Lista>
						</cfif>
						<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
						<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
							<cfset form.Pagina = form.PageNum>
						</cfif>		
						<cfif isdefined('url.filtro_CAcodigo') and not isdefined('form.filtro_CAcodigo')>
							<cfset form.filtro_CAcodigo = url.filtro_CAcodigo>
						</cfif>
						<cfif isdefined('url.filtro_CAdescripcion') and not isdefined('form.filtro_CAdescripcion')>
							<cfset form.filtro_CAdescripcion = url.filtro_CAdescripcion>
						</cfif>			
						<cfif isdefined('url.filtro_Idescripcion') and not isdefined('form.filtro_Idescripcion')>
							<cfset form.filtro_Idescripcion = url.filtro_Idescripcion>
						</cfif>				
						<cfif isdefined("url.CAid") and len(trim(url.CAid)) and not isdefined("form.CAid")>
							<cfset form.CAid = url.CAid >
						</cfif>
						<cfif isdefined("url.Ppaisori") and len(trim(url.Ppaisori)) and not isdefined("form.Ppaisori")>
							<cfset form.Ppaisori = url.Ppaisori >
						</cfif>						

						<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
						<cfparam name="form.Pagina" default="1">
						<cfparam name="form.MaxRows" default="25">	

						<cfif isdefined("url.btnNuevo") and not isdefined("form.btnNuevo")>
							<cfset form.btnNuevo = url.btnNuevo >
						</cfif>		
						<cfif isdefined('form.CAid') and form.CAid NEQ '' or isdefined('form.btnNuevo')>
							<cfinclude template="CodigoAduanal.cfm">
						<cfelse>
							<cfset campos_extra = '' >
							<cfif isdefined("form.pagenum_lista")>
								<cfset campos_extra = ",'#form.pagenum_lista#' as pagenum_lista" >
							</cfif>						
						
							<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="CodigoAduanal a
																		inner join Impuestos imp
																			on imp.Icodigo = a.Icodigo
																			and imp.Ecodigo = a.Ecodigo"/>
								<cfinvokeargument name="columnas" value="
																		a.CAid,
																		a.CAcodigo,
																		a.Ecodigo,
																		a.CAdescripcion,
																		imp.Idescripcion
																		#preservesinglequotes(campos_extra)#"/>
								<cfinvokeargument name="desplegar" value="CAcodigo, CAdescripcion, Idescripcion"/>
								<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Grupo de impuestos"/>
								<cfinvokeargument name="formatos" value="S,S,S"/>
								<cfinvokeargument name="filtro" value="a.Ecodigo=#Session.Ecodigo# order by a.CAdescripcion"/>
								<cfinvokeargument name="align" value="left, left, left"/>
								<cfinvokeargument name="ajustar" value="S"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="keys" value="CAid"/>
								<cfinvokeargument name="irA" value="listaCodigoAduanal.cfm"/>
								<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>				
								<cfinvokeargument name="mostrar_filtro" value="true"/>
								<cfinvokeargument name="botones" value="Nuevo"/>
								<cfinvokeargument name="filtrar_automatico" value="true"/>							
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
							  </cfinvoke> 					
						</cfif>
					</td>
				</tr>
			</table>
			
		<cf_web_portlet_end>
	<cf_templatefooter>