<cf_templateheader title="	Turnos por Oficina">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Turnos por Oficina'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="3" valign="top">
						<cfinclude template="../../portlets/pNavegacionAD.cfm">
					</td>
				</tr>
				<tr>
					<td valign="top" width="50%">
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
						<cfif isdefined('url.filtro_Ocodigo') and not isdefined('form.filtro_Ocodigo')>
							<cfset form.filtro_Ocodigo = url.filtro_Ocodigo>
						</cfif>
						<cfif isdefined('url.filtro_Odescripcion') and not isdefined('form.filtro_Odescripcion')>
							<cfset form.filtro_Odescripcion = url.filtro_Odescripcion>
						</cfif>
						<cfif isdefined('url.Ocodigo') and not isdefined('form.Ocodigo')>
							<cfset form.Ocodigo = url.Ocodigo>
						</cfif>
						<cfif isdefined('url.Odescripcion') and not isdefined('form.Odescripcion')>
							<cfset form.Odescripcion = url.Odescripcion>
						</cfif>						
									
						<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
						<cfparam name="form.Pagina" default="1">
						<cfparam name="form.MaxRows" default="25">					
											
						<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaRH"
							returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="Oficinas"/>
							<cfinvokeargument name="columnas" value="Ocodigo
																	, Ecodigo
																	, Odescripcion"/> 
							<cfinvokeargument name="desplegar" value="Ocodigo,Odescripcion"/> 
							<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n"/> 
							<cfinvokeargument name="formatos" value="V,S"/> 
							<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo#
																	order by Odescripcion"/> 
							<cfinvokeargument name="align" value="left,left"/> 
							<cfinvokeargument name="ajustar" value="N"/> 
							<cfinvokeargument name="checkboxes" value="N"/> 
							<cfinvokeargument name="irA" value="Turnosxofi.cfm"/> 
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="Ocodigo"/> 
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>	
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>																													
						</cfinvoke>				
					</td>
					<td width="1%">&nbsp;</td>
					<td valign="top" width="50%" align="center">
						<cfinclude template="formTurnosxofi.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>

			


