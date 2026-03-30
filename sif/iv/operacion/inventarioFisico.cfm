<cf_templateheader title=" Inventario F&iacute;sico">
	
	<!--- ======================================================================== --->
	<!--- ======================================================================== --->
	<cfif isdefined("url.EFid") and not isdefined("form.EFid") >
		<cfset form.EFid = url.EFid >
	</cfif>

	<!--- Filtros de la lista principal --->
	<cfif isdefined("url.pageNum_lista") and not isdefined("form.pageNum_lista") >
		<cfset form.pageNum_lista = url.pageNum_lista >
	</cfif>
	<cfif isdefined("url.fAid") and not isdefined("form.fAid") >
		<cfset form.fAid = url.fAid >
	</cfif>
	<cfif isdefined("url.fDescripcion")and not isdefined("form.fDescripcion") >
		<cfset form.fDescripcion = url.fDescripcion >
	</cfif>
	<cfif isdefined("url.fEFfecha")and not isdefined("form.fEFfecha")>
		<cfset form.fEFfecha = url.fEFfecha >
	</cfif>

	<cfif isdefined("url.pageNum_lista2") and not isdefined("form.pageNum_lista2") >
		<cfset form.pageNum_lista2 = url.pageNum_lista2 >
	</cfif>
	<cfif isdefined("url.fAcodigo")and not isdefined("form.fAcodigo")>
		<cfset form.fAcodigo = url.fAcodigo >
	</cfif>
	<cfif isdefined("url.fAdescripcion")and not isdefined("form.fAdescripcion")>
		<cfset form.fAdescripcion = url.fAdescripcion >
	</cfif>

	<!--- ======================================================================== --->
	<!--- ======================================================================== --->

	<cfset params = '' >
	<!--- ================================================================================================= --->
	<!--- FILTROS DE LA LISTA PRINCIPAL --->
	<!--- ================================================================================================= --->
	<cfif isdefined("form.pageNum_lista") and len(trim(form.pageNum_lista))>
		<cfset params = params & "&pageNum_lista=#form.pageNum_lista#" >
	</cfif>
	<cfif isdefined("form.fAid") and len(trim(form.fAid))>
		<cfset params = params & "&fAid=#form.fAid#" >
	</cfif>
	<cfif isdefined("form.fDescripcion") and len(trim(form.fDescripcion))>
		<cfset params = params & "&fDescripcion=#form.fDescripcion#" >
	</cfif>
	<cfif isdefined("form.fEFfecha") and len(trim(form.fEFfecha))>
		<cfset params = params & "&fEFfecha=#form.fEFfecha#" >
	</cfif>
	<!--- ================================================================================================= --->
	<!--- ================================================================================================= --->

	<!--- ================================================================================================= --->
	<!--- FILTROS DE LA LISTA DETALLE --->
	<!--- ================================================================================================= --->
	<cfset params2 = ''>
	<cfif isdefined("form.fAcodigo") and len(trim(form.fAcodigo))>
		<cfset params2 = params2 & "&fAcodigo=#form.fAcodigo#" >
	</cfif>
	<cfif isdefined("form.fAdescripcion") and len(trim(form.fAdescripcion))>
		<cfset params2 = params2 & "&fAdescripcion=#form.fAdescripcion#" >
	</cfif>
	<!--- ================================================================================================= --->
	<!--- ================================================================================================= --->

	<!--- MODO --->
	<cfset modo = 'ALTA'>
	<cfif isdefined("form.EFid") and len(trim(form.EFid))>
		<cfset modo = 'CAMBIO'>
	</cfif>

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Inventario F&iacute;sico'>
	 		<cfinclude template="../../portlets/pNavegacion.cfm">
			<table width="100%" cellpadding="4" cellspacing="0">
				<cfoutput>
				<form name="form1" method="post" action="inventarioFisico-sql.cfm" style="margin:0;" onsubmit="javascript: return validar();">
					<tr><td align="center" class="tituloListas">Encabezado del Documento</td></tr>
					<tr><td><cfinclude template="inventarioFisicoEnc-form.cfm"></td></tr>
					
					<cfif modo neq 'ALTA'>
						<input type="hidden" name="EFid" value="#form.EFid#" />
						
						<cfset modoDet = 'ALTA'>
						<cfif isdefined("form.DFlinea") and len(trim(form.DFlinea))>
							<cfset modoDet = 'CAMBIO'>
						</cfif>
						
						<cfif modoDet neq 'ALTA' >
							<input type="hidden" name="DFlinea" value="#form.DFlinea#" />
						</cfif>
						
						<tr><td align="center" class="tituloListas">Detalle del Documento</td></tr>
						<tr><td><cfinclude template="inventarioFisicoDet-form.cfm"></td></tr>
					</cfif>
					
					<!--- botones --->
					<tr><td>
						<cfif modo eq 'ALTA'>
							<cf_botones modo="ALTA" include="Regresar"  tabindex="2">
						<cfelse>
							<cfif modoDet eq 'ALTA'>
								<cf_botones exclude="limpiar" 
											names="btnAgregarDet,Baja,btnAplicarM,btnImprimir,Nuevo,Regresar"
											values="Agregar l&iacute;nea,Eliminar Doc.,Aplicar,Imprimir,Nuevo Doc.,Regresar"  
											tabindex="2">
							<cfelse>
								<cf_botones exclude="limpiar" 
											names="btnModificar,btnEliminarDet,Baja,btnAplicarM,btnImprimir,Nuevo,Regresar"
											values="Modificar l&iacute;nea,Eliminar l&iacute;nea,Eliminar Doc.,Aplicar,Imprimir,Nuevo Doc.,Regresar"  
											tabindex="2">
							</cfif>
						</cfif>
					</td></tr>
					
					<!--- ======================================== --->
					<!--- ======================================== --->
					<!--- FILTROS DE LA LISTA --->
					<input tabindex="-1" type="hidden" name="pageNum_lista" value="<cfif isdefined('form.pageNum_lista')>#form.pageNum_lista#<cfelse>1</cfif>" />
					<input tabindex="-1" type="hidden" name="fAid" value="<cfif isdefined('form.fAid') and len(trim(form.fAid))>#form.fAid#</cfif>" />
					<input tabindex="-1" type="hidden" name="fDescripcion" value="<cfif isdefined('form.fDescripcion')>#trim(form.fDescripcion)#</cfif>" />
					<input tabindex="-1" type="hidden" name="fEFfecha" value="<cfif isdefined('form.fEFfecha') and len(trim(form.fEFfecha))>#form.fEFfecha#</cfif>" />
					<!--- ======================================== --->
					<!--- ======================================== --->
					
					<!--- ======================================== --->
					<!--- ======================================== --->
					<!--- FILTROS DE LA LISTA DETALLE --->
					<input tabindex="-1" type="hidden" name="pageNum_lista2" value="<cfif isdefined('form.pageNum_lista2')>#form.pageNum_lista2#<cfelse>1</cfif>" />
					<input tabindex="-1" type="hidden" name="fAcodigo" value="<cfif isdefined('form.fAcodigo')>#form.fAcodigo#</cfif>" />
					<input tabindex="-1" type="hidden" name="fAdescripcion" value="<cfif isdefined('form.fAdescripcion')>#form.fAdescripcion#</cfif>" />
					<!--- ======================================== --->
					<!--- ======================================== --->
					
				</form>
				</cfoutput>				
				
				<!--- lista detalles--->
				<cfif modo neq 'ALTA'>
                	<cfinclude template="../../Utiles/sifConcat.cfm">
					<cfquery name="rsListaDet" datasource="#session.DSN#">
						select a.DFlinea, a.Aid as ArtId, b.Acodigo #_Cat# ' - '#_Cat# b.Adescripcion as articulo, a.DFcantidad, a.DFactual, a.DFdiferencia, a.DFcostoactual, a.DFtotal
						from  DFisico a

						inner join Articulos b
						on b.Aid=a.Aid
						
						<cfif isdefined("form.fAcodigo") and len(trim(form.fAcodigo))>
							and upper(b.Acodigo) like '%#ucase(trim(form.fAcodigo))#%'
						</cfif>

						<cfif isdefined("form.fAdescripcion") and len(trim(form.fAdescripcion))>
							and upper(b.Adescripcion) like '%#ucase(trim(form.fAdescripcion))#%'
						</cfif>

						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a.EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EFid#">

						order by b.Acodigo, b.Adescripcion		
					</cfquery>
				
					<tr>
						<td>
							<table width="100%" cellpadding="1" cellspacing="0">
								<tr>
									<td>
										<cfoutput>
										<form name="listadet" method="post" action="inventarioFisico.cfm" style="margin:0;">
											<input type="hidden" name="EFid" value="#form.EFid#" />
											<!--- ======================================== --->
											<!--- ======================================== --->
											<!--- FILTROS DE LA LISTA PRINCIPAL --->
											<input tabindex="-1" type="hidden" name="pageNum_lista" value="<cfif isdefined('form.pageNum_lista')>#form.pageNum_lista#<cfelse>1</cfif>" />
											<input tabindex="-1" type="hidden" name="fAid" value="<cfif isdefined('form.fAid') and len(trim(form.fAid))>#form.fAid#</cfif>" />
											<input tabindex="-1" type="hidden" name="fDescripcion" value="<cfif isdefined('form.fDescripcion')>#trim(form.fDescripcion)#</cfif>" />
											<input tabindex="-1" type="hidden" name="fEFfecha" value="<cfif isdefined('form.fEFfecha') and len(trim(form.fEFfecha))>#form.fEFfecha#</cfif>" />
											<!--- ======================================== --->
											<!--- ======================================== --->

											<!--- ======================================== --->
											<!--- ======================================== --->
											<!--- FILTROS DE LA LISTA DETALLE --->
											<input tabindex="-1" type="hidden" name="pageNum_lista2" value="<cfif isdefined('form.pageNum_lista2')>#form.pageNum_lista2#<cfelse>1</cfif>" />
											<!--- ======================================== --->
											<!--- ======================================== --->

											<table width="100%" cellpadding="1" cellspacing="0" class="areaFiltro">
												<tr>
													<td width="1%"><strong>Art&iacute;culo:</strong>&nbsp;</td>
													<td><input type="text" name="fAcodigo" size="40" maxlength="80" value="<cfif isdefined('form.fAcodigo')>#form.fAcodigo#</cfif>"></td>
													<td width="1%"><strong>Descripci&oacute;n:</strong>&nbsp;</td>
													<td><input type="text" name="fAdescripcion" size="40" maxlength="80" value="<cfif isdefined('form.fAdescripcion')>#form.fAdescripcion#</cfif>"></td>
													<td><input type="submit" class="btnNormal" name="btnFiltrar" value="Filtrar" onClick="javascript:document.listadet.action='';"></td>
												</tr>
											</table>



											<cfset navegacion2 = '&EFid=#form.EFid##params##params2#'>
											<cfinvoke 
													component="sif.Componentes.pListas"
													method="pListaQuery"
													returnvariable="pListaRet">
												<cfinvokeargument name="query" value="#rsListaDet#"/>
												<cfinvokeargument name="desplegar" value="articulo, DFcantidad, DFactual, DFdiferencia, DFcostoactual, DFtotal"/>
												<cfinvokeargument name="etiquetas" value="Art&iacute;culo, Unidades F&iacute;sicas, Inventario Actual, Diferencia, Costo, Total"/>
												<cfinvokeargument name="formatos" value="V, M, M, M, M, M"/>
												<cfinvokeargument name="align" value="left, right, right, right, right, right"/>
												<cfinvokeargument name="ajustar" value="N"/>
												<cfinvokeargument name="irA" value="inventarioFisico.cfm"/>
												<cfinvokeargument name="keys" value="DFlinea"/>
												<cfinvokeargument name="showEmptyListMsg" value="true"/>
												<cfinvokeargument name="formname" value="listadet"/>
												<cfinvokeargument name="incluyeform" value="false"/>
												<cfinvokeargument name="maxrows" value="30"/>
												<cfinvokeargument name="PageIndex" value="2"/>
												<cfinvokeargument name="navegacion" value="#navegacion2#"/>
											</cfinvoke>
										</form>	
										</cfoutput>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</cfif>
			</table>
			
			<cf_qforms>
			
			
			<script language="javascript1.2" type="text/javascript">
				objForm.Aid.required = true;
				objForm.Aid.description = 'Almacén';
				objForm.EFdescripcion.required = true;
				objForm.EFdescripcion.description = 'Descripción';
				objForm.EFfecha.required = true;
				objForm.EFfecha.description = 'Fecha';
				
				<cfif modo neq 'ALTA'>
					objForm.ArtId.required = true;
					objForm.ArtId.description = 'Artículo';
					objForm.DFcantidad.required = true;
					objForm.DFcantidad.description = 'Unidades Físicas';
				</cfif>
				
				
				function deshabilitarValidacion(){
					objForm.Aid.required = false;
					objForm.EFdescripcion.required = false;
					objForm.EFfecha.required = false;
					
					<cfif modo neq 'ALTA'>
						objForm.ArtId.required = false;
						objForm.DFcantidad.required = false;
					</cfif>
				}
				
				function funcRegresar(){
					location.href = 'inventarioFisico-lista.cfm?1=1<cfoutput>#params#</cfoutput>';
					return false;
				}
				
				function funcbtnAplicarM(){
					if ( confirm('Desea aplicar el documento de Inventario Físico?') ){
						deshabilitarValidacion();
						return true;
					}
					return false;
				}
				
				function funcBaja(){
					if ( confirm('Desea eliminar el documento de Inventario Físico?') ){
						deshabilitarValidacion();
						return true;
					}
					return false;
				}
				function funcNuevo(){
					deshabilitarValidacion();
				}
				function validar(){
					//document.form1.DFactual.disabled = false;
					//document.form1.DFdiferencia.disabled = false;
					//document.form1.DFcostoactual.disabled = false;
					//document.form1.DFtotal.disabled = false;
					return true;
				}
				function funcbtnEliminarDet(){
					if ( confirm('Desea eliminar la línea del Inventario Físico?') ){
						deshabilitarValidacion();
						return true;
					}
					return false;
				}

				var popUpWin=0;
				function popUpWindow(URLStr, left, top, width, height){
					if(popUpWin) {
						if(!popUpWin.closed) popUpWin.close();
					}
					popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}

				function funcbtnImprimir(){
					deshabilitarValidacion();
					popUpWindow("/cfmx/sif/iv/operacion/inventarioFisico-reportefs.cfm?EFid="+document.form1.EFid.value+"&Aid="+document.form1.Aid.value,100,50,1100,750);
					return false;
				}
			</script>
			
		<cf_web_portlet_end>
	<cf_templatefooter>