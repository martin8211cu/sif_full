<cf_templateheader title="Inventarios - N&uacute;meros de Parte ">
	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='N&uacute;meros de Parte de Art&iacute;culos'>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="3">
						<cfinclude template="../../portlets/pNavegacion.cfm">
					</td>
				</tr>
				<cfinclude template="paramURL-FORM.cfm">
				<cf_dbfunction name="OP_concat" returnvariable="_Cat">
				<cfif isdefined("url.NPPid") and len(trim(url.NPPid))>
					<cfset form.NPPid = url.NPPid>
				</cfif>

				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
				<cfif isdefined("url.Pagina3") and len(trim(url.Pagina3))>
					<cfset form.Pagina3 = url.Pagina3>
				</cfif>
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
				<cfif isdefined("url.PageNum_Lista3") and len(trim(url.PageNum_Lista3))>
					<cfset form.Pagina3 = url.PageNum_Lista3>
				</cfif>
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
				<cfif isdefined("form.PageNum3") and len(trim(form.PageNum3))>
					<cfset form.Pagina3 = form.PageNum3>
				</cfif>					
				<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
				<cfparam name="form.Pagina3" default="1">						
				
				<cfset campos_extraNumPar = '' >
				<cfset navegacionNumPa = "">
				<cfif isdefined("form.Aid") and len(trim(form.Aid)) gt 0>
					<cfset navegacionNumPa = "Aid=#form.Aid#">
				</cfif>  				
				
				<cfif isdefined("form.Pagina3") and len(trim(form.Pagina3))>
					<cfset navegacionNumPa = navegacionNumPa & "&Pagina3=#form.Pagina3#">
					<cfset campos_extraNumPar = campos_extraNumPar & ",'#form.Pagina3#' as Pagina3" >
				</cfif>
				<cfif isdefined("form.Pagina") and form.Pagina NEQ ''>
					<cfset campos_extraNumPar = campos_extraNumPar & ",'#form.Pagina#' as Pagina" >
					<cfset navegacionNumPa = navegacionNumPa & "&Pagina=#form.Pagina#">
				</cfif>
				<cfif isdefined("form.filtro_Acodigo") and form.filtro_Acodigo NEQ ''>
					<cfset campos_extraNumPar = campos_extraNumPar & ",'#form.filtro_Acodigo#' as filtro_Acodigo" >
					<cfset navegacionNumPa = navegacionNumPa & "&filtro_Acodigo=#form.filtro_Acodigo#">
				</cfif>
				<cfif isdefined("form.filtro_Acodalterno") and form.filtro_Acodalterno NEQ ''>
					<cfset campos_extraNumPar = campos_extraNumPar & ",'#form.filtro_Acodalterno#' as filtro_Acodalterno" >
					<cfset navegacionNumPa = navegacionNumPa & "&filtro_Acodalterno=#form.filtro_Acodalterno#">
				</cfif>												
				<cfif isdefined("form.filtro_Adescripcion") and form.filtro_Adescripcion NEQ ''>
					<cfset campos_extraNumPar = campos_extraNumPar & ",'#form.filtro_Adescripcion#' as filtro_Adescripcion" >
					<cfset navegacionNumPa = navegacionNumPa & "&filtro_Adescripcion=#form.filtro_Adescripcion#">
				</cfif>		

				<TR><TD>&nbsp;</TD></TR>
				<tr><td colspan="3"><cfinclude template="articulos-link.cfm"></td></tr>
				<tr>
					<td valign="top" width="100%" align="center">                      	
						<cfinclude template="formNumerosParte.cfm">
					</td>				
				</tr>	
				<tr> 
					<td valign="top" width="100%" align="center"> 
						<table width="100%">								
							<tr><td>							
								<cfinvoke 
									component="sif.Componentes.pListas"
									method="pListaRH"
									returnvariable="pListaRet">
									<cfinvokeargument name="tabla" value="NumParteProveedor a
																		left outer join AFMarcas b
																			on a.AFMid = b.AFMid
																			and a.Ecodigo = b.Ecodigo
								
																			left outer join SNegocios c
																				on  a.SNcodigo = c.SNcodigo
																				and a.Ecodigo = c.Ecodigo"/>
									<cfinvokeargument name="columnas" value="NPPid
																			,Aid
																			,a.AFMid
																			,a.SNcodigo
																			,NumeroParte
																			,Vdesde
																			,Vhasta
																			,b.AFMdescripcion
																			,c.SNnumero #_Cat# '-' #_Cat# c.SNnombre as socio
																			#preservesinglequotes(campos_extraNumPar)#"/> 
									<cfinvokeargument name="desplegar" value="NumeroParte, socio, AFMdescripcion, Vdesde, Vhasta"/> 
									<cfinvokeargument name="etiquetas" value="N&uacute;mero Parte, Socio Negocio, Marca, Val. Desde, Val. Hasta"/> 
									<cfinvokeargument name="formatos" value="V,V,V,D,D"/> 
									<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
																			and	a.Aid = #form.Aid#
																			order by Vdesde desc"/> 
									<cfinvokeargument name="align" value="left,left,left,left,left"/> 
									<cfinvokeargument name="ajustar" value="N"/> 
									<cfinvokeargument name="checkboxes" value="N"/> 
									<cfinvokeargument name="irA" value="NumerosParte.cfm"/> 								
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
									<cfinvokeargument name="keys" value="NPPid"/> 
									<cfinvokeargument name="debug" value="N"/>
									<cfinvokeargument name="PageIndex" value="3"/>
									<cfinvokeargument name="navegacion" value="#navegacionNumPa#"/>
									<cfinvokeargument name="maxRows" value="25"/>																			
								</cfinvoke>								
							</td></tr>
						</table>							
					</td>
				</tr>				
			</table>
		<cf_web_portlet_end>	
	<cf_templatefooter>