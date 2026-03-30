<cfoutput>
<form name="form2" method="post" action="cuestionario-sql.cfm" onSubmit="return validar(this);" style="margin:0; ">
	<input type="hidden" name="tab" value="2">
	<cfif isdefined("form.pageNum_lista")>
		<input type="hidden" name="pageNum_lista" value="#form.pageNum_lista#">
	</cfif>
	<cfif isdefined("form.fPCcodigo")>
		<input type="hidden" name="fPCcodigo" value="#form.fPCcodigo#">
	</cfif>
	<cfif isdefined("form.fPCnombre")>
		<input type="hidden" name="fPCnombre" value="#form.fPCnombre#">
	</cfif>
	<cfif isdefined("form.fPCdescripcion")>
		<input type="hidden" name="fPCdescripcion" value="#form.fPCdescripcion#">
	</cfif>

	<cfif modo neq 'ALTA'>
		<input type="hidden" name="PCid" value="#pcdata.PCid#">
	</cfif>

	<TABLE>
	<!--- SECCION DE PARTES --->
	<tr><td colspan="6">
		<table width="99%" cellpadding="0" cellspacing="1" align="center" >
			<tr><td align="center" colspan="2" class="tituloPersona" style="text-align:center; padding:3px;">#trim(cuestionario.PCcodigo)# - #cuestionario.PCnombre#</td></tr>
			<tr>
				<td valign="top" width="40%">
					<cfparam name="pageNum_lista" default="1">
					<cfset navegacion = "&tab=2&PCid=#form.PCid#" >
					<cfset campos = '' >	
					<cfif isdefined("form.fPCcodigo") and len(trim(form.fPCcodigo)) >
						<cfset navegacion = navegacion & '&fPCcodigo=#form.fPCcodigo#' >
					</cfif>
					<cfif isdefined("form.fPCnombre") and len(trim(form.fPCnombre)) >
						<cfset navegacion = navegacion & '&fPCnombre=#form.fPCnombre#' >
					</cfif>
					<cfif isdefined("form.fPCdescripcion") and len(trim(form.fPCdescripcion)) >
						<cfset navegacion = navegacion & '&fPCdescripcion=#form.fPCdescripcion#' >
					</cfif>

					<cfquery name="rsListaPartes" datasource="sifcontrol">
						select PPparte as _PPparte, PCPdescripcion as _PCPdescripcion
						from PortalCuestionarioParte
						where PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
						order by PPparte
					</cfquery>
					
					<cfinvoke component="rh.Componentes.pListas" method="pListaQuery">
						<cfinvokeargument name="query" 			value="#rsListaPartes#">
						<cfinvokeargument name="desplegar" 		value="_PPparte,_PCPdescripcion">
						<cfinvokeargument name="etiquetas" 		value="#LB_Parte#,#LB_DESCRIPCION#">
						<cfinvokeargument name="formatos" 		value="S,S">
						<cfinvokeargument name="align" 			value="left,left">
						<cfinvokeargument name="ira" 			value="cuestionario-tabs.cfm">
						<cfinvokeargument name="keys" 			value="_PPparte">
						<cfinvokeargument name="showEmptyListMsg" value="true">
						<cfinvokeargument name="incluyeform" 	value="false">
						<cfinvokeargument name="formname"		value="form2">
						<cfinvokeargument name="ajustar"		value="S">
						<cfinvokeargument name="navegacion"		value="#navegacion#">
						<cfinvokeargument name="PageIndex"		value="1">
					</cfinvoke>	
				</td>

				<td align="center" width="60%" valign="top">
						<cfif isdefined("form._PPparte") and len(trim(form._PPparte))>
							<cfset form.PPparte = form._PPparte >
						</cfif>
						
						<cfset modo_parte = 'ALTA'>
						<cfif isdefined("form.PPparte") and len(trim(form.PPparte))>
							<cfset modo_parte = 'CAMBIO'>
							<cfquery name="pcpdata" datasource="sifcontrol">
								select PPparte, PCPdescripcion, PCPinstrucciones, PCPmaxpreguntas
								from PortalCuestionarioParte
								where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
								  and PPparte = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPparte#">
							</cfquery>
						</cfif>
						
						<cfoutput>
						<table border="0" cellpadding="0" cellspacing="2" width="100%" align="center" >
							<cfif isdefined("form.pagenum1")>
								<input type="hidden" name="_pagenum1" value="#form.pagenum1#">
							</cfif>
						
							<tr>
								<td align="right" width="1%" nowrap ><cf_translate key="LB_Parte">Parte</cf_translate>:&nbsp;</td>
								<td>
									<input type="text" name="PPparte" size="7" maxlength="3"  style="text-align:right;" value="<cfif modo_parte neq 'ALTA'>#trim(pcpdata.PPparte)#</cfif>"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
								</td>
							</tr>
						
							<tr>
								<td align="right" width="1%"><cf_translate XmlFile="/rh/generales.xml" key="LB_DESCRIPCION">Descripci&oacute;n</cf_translate>:&nbsp;</td>
								<td><input type="text" name="PCPdescripcion" size="30" maxlength="30" onFocus="restaurar_color(this); this.select(); " value="<cfif modo_parte neq 'ALTA'>#trim(pcpdata.PCPdescripcion)#</cfif>"></td>
							</tr>
						
						
							<tr>
								<td align="right" width="1%" nowrap ><cf_translate key="LB_Preguntas">Preguntas</cf_translate>:&nbsp;</td>
								<td>
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr>
											<td><input type="text" name="PCPmaxpreguntas" size="7" maxlength="3"  style="text-align:right;" value="<cfif modo_parte neq 'ALTA'>#trim(pcpdata.PCPmaxpreguntas)#</cfif>"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
											<td><cf_translate key="Ayuda_SeRefiereAlNumeroDePreguntasQueDebenSerContestadasPorParte">Se refiere al número de preguntas que deben ser contestadas por parte.</cf_translate></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr><td colspan="2"></td></tr>
							
							<tr>
								<td align="right" valign="top" nowrap ><cf_translate key="LB_Instrucciones">Instrucciones</cf_translate>:&nbsp;</td>
							</tr>

							<tr>
								<td colspan="2">
									<cfif modo_parte neq 'ALTA'>
										<cf_sifeditorhtml name="PCPinstrucciones" indice="1" value="#trim(pcpdata.PCPinstrucciones)#" height="150">
									<cfelse>
										<cf_sifeditorhtml name="PCPinstrucciones" indice="1" height="150">
									</cfif>
								</td>	
							</tr>
							
							<tr><td>&nbsp;</td></tr>
							
							<tr>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Guardar"
							Default="Guardar"
							returnvariable="BTN_Guardar"/>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Eliminar"
							Default="Eliminar"
							returnvariable="BTN_Eliminar"/>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Nuevo"
							Default="Nuevo"
							returnvariable="BTN_Nuevo"/>	
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="MSG_DeseaEliminarLaParte"
							Default="Desea eliminar la parte?"
							returnvariable="MSG_DeseaEliminarLaParte"/>	
						
							
								<td colspan="2" align="center">
									<input type="submit" class="btnGuardar" name="<cfif modo_parte eq 'ALTA'>PCPGuardar<cfelse>PCPModificar</cfif>" value="<cfoutput>#BTN_Guardar#</cfoutput>">
									<cfif modo_parte neq 'ALTA'>
										<input type="submit" name="PCPEliminar" class="btnEliminar" value="<cfoutput>#BTN_Eliminar#</cfoutput>" onClick="javascript:return confirm('<cfoutput>#MSG_DeseaEliminarLaParte#</cfoutput>');">
										<input type="button" name="NuevaParte" class="btnNuevo" value="<cfoutput>#BTN_Nuevo#</cfoutput>" onClick="location.href='cuestionario-tabs.cfm?tab=2&PCid=#form.PCid#';" >
									</cfif>

									<cfset params = '' >
									<cfif isdefined("form.pageNum_lista")>
										<cfset params = params & '&pageNum_lista=#form.pageNum_lista#' >
									</cfif>
									<cfif isdefined("form.fPCcodigo")>
										<cfset params = params & '&fPCcodigo=#form.fPCcodigo#' >
									</cfif>
									<cfif isdefined("form.fPCnombre")>
										<cfset params = params & '&fPCnombre=#form.fPCnombre#' >
									</cfif>
									<cfif isdefined("form.fPCdescripcion")>
										<cfset params = params & '&fPCdescripcion=#form.fPCdescripcion#' >
									</cfif>
									
									<input type="button" name="PCLista" class="btnAnterior" value="<cfoutput>#BTN_Lista#</cfoutput>" onClick="javascript:location.href='cuestionario-lista.cfm?DUMMY=OK#PARAMS#'">
								</td>
							</tr>
							
							<tr><td>&nbsp;</td></tr>
						</table>
						
						</cfoutput>

				</td>
			</tr>
		</table>
	</td></tr>
	</TABLE>
</form>
</cfoutput>
			
			
			
			
			
			
			
			
			
			