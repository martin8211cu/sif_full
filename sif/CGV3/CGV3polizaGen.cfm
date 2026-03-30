<cfparam name="sufix" default="">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif not isdefined("url.inter")  and not isdefined("form.inter")>
 	<cfset inter = 'N'>
</cfif>
<cfif isdefined("url.inter") and not isdefined("form.inter")>
 	<cfset inter = url.inter>
</cfif>
<cfif not isdefined("url.inter") and  isdefined("form.inter")>
 	<cfset inter = form.inter>
</cfif>

<cfif isdefined("url.LvarDlinea") and not isdefined("form.LvarDlinea")>
	<cfset form.LvarDlinea = url.LvarDlinea>
</cfif>

<cfif isdefined("url.IDcontable") and not isdefined("form.IDcontable")>
	<cfset form.IDcontable = url.IDcontable>
</cfif>

<cfif isdefined("url.IDcontable") and len(trim(url.IDcontable)) gt 0>
	<cfset IDcontable = url.IDcontable>
	<cfset IDcontable_detalle = url.IDcontable>
</cfif>


<cfparam name="form.LvarDlinea" default="0">

<cfif isdefined("url.PageNum_lista") and url.PageNum_lista gt 1>
	<cfset form.LvarDlinea = form.LvarDlinea + 30>
</cfif>

<cfif isdefined("Form.flinea") and len(trim(Form.flinea))>
	<cfset form.LvarDlinea= Form.flinea -1>
</cfif>

<cfif isdefined("Url.flinea") and not isdefined("Form.flinea")>
	<cfparam name="Form.flinea" default="#Url.flinea#">
</cfif>
<cfparam  name="form.IDcontable_detalle" default="0">
<cfif isdefined("Form.IDcontable_detalle") and len(trim(form.IDcontable_detalle)) and not isdefined("Form.IDcontable") or isdefined("Form.IDcontable") and  len(trim(Form.IDcontable)) eq 0>
	<cfset form.IDcontable = Form.IDcontable_detalle>
</cfif>

<cfif not isdefined("form.IDcontable") and isdefined("url.IDcontable") and len(trim(url.IDcontable))>
	<cfset form.IDcontable = url.IDcontable>
</cfif>

<cfif isdefined ("Form.btnbuscar") or isdefined("url.pagenum_lista")>
	<cfset modo = "CAMBIO">
</cfif>
<cfif isdefined("form.IDcontable") and len(trim(form.IDcontable)) and form.IDcontable NEQ 0>
	<cfset IDcontable = form.IDcontable>
	<cfset modo = "CAMBIO">
</cfif>

<!--- Parametro para incluir asientos retroactivos --->
<cfif isdefined("url.paramretro") and not isdefined("form.paramretro")>
 	<cfset paramretro = url.paramretro>
</cfif>
<cfif isdefined("form.paramretro") and not isdefined("url.paramretro")>
 	<cfset paramretro = form.paramretro>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfif inter eq 'N'>
		<cfquery name="rsOficinasDetalle" datasource="#Session.DSN#">
			select 
				d.Ecodigo as Ecodigo, 
				d.Ocodigo as Ocodigo,
				((select min({fn concat({fn concat(Edescripcion , ' - ' )},  o.Oficodigo)} ) 
					from Oficinas o
						inner join Empresas e 
							on e.Ecodigo = o.Ecodigo
					where o.Ecodigo = d.Ecodigo
					  and o.Ocodigo = d.Ocodigo
				)) as Odescripcion
			from DContables d
			where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
			group by d.Ecodigo, d.Ocodigo
		</cfquery>
	
	<cfelse>
		<cfquery name="rsOficinasDetalle" datasource="#Session.DSN#">
			select 
				cf.Ecodigo as Ecodigo, 
				d.Ocodigo as Ocodigo, 
				((select min({fn concat({fn concat(Edescripcion , ' - ' )},  o.Oficodigo)} ) 
					from Oficinas o
						inner join Empresas e 
							on e.Ecodigo = o.Ecodigo
					where o.Ecodigo = cf.Ecodigo
					  and o.Ocodigo = d.Ocodigo
				)) as Odescripcion
			from DContables d
				inner join CFinanciera cf
					on cf.CFcuenta = d.CFcuenta
			where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
			group by cf.Ecodigo, d.Ocodigo		
		</cfquery>
	</cfif>

</cfif>

		<cfset LvarTitulo = "">
		<cfif isdefined("paramretro")>
			<cfset LvarTitulo = "Registro de Documento Contable Retroactivo">
		<cfelse>
			 <cfset LvarTitulo = "Registro de Documento Contable">
		</cfif>
		
		<cfif sufix eq 'CierreAnual'>
			<cfset LvarTitulo = "Registro de Documento Contable de Cierre Anual">
		</cfif>
		<cf_templateheader title="#LvarTitulo#">
		
		<table width="100%" cellpadding="2" cellspacing="0" >
			<tr>
				<td valign="top">
					<cfset LvarLineaInicial = form.LvarDlinea+1>
					<cfset LvarLineaFinal   = LvarLineaInicial + 40>
					<cfif  (isdefined("Form.fDescripcion") and Len(Trim(Form.fDescripcion)))
						or (isdefined("Form.fCformato") and Len(Trim(Form.fCformato)))
						or (isdefined("Form.fOcodigo") and Len(Trim(Form.fOcodigo)))>
						<cfset LvarLineaFinal  = LvarLineaInicial + 500>
					</cfif>
          			<cfif not isdefined("form.bntNuevo")>
						<cfif isdefined("Url.IDcontable") and not isdefined("form.IDcontable")>
							<cfset form.IDcontable = Url.IDcontable>
						</cfif>
						<cfset IDcontable = "">
						<cfif not isDefined("Form.NuevoE")>
							<cfif isdefined("Form.IDcontable")>
								<cfset IDcontable = Form.IDcontable>
							<cfelse>
								<cfif inter eq "S">
									<cflocation addtoken="no" url="listaDocumentosContablesI.cfm">
								<cfelse>
									<cfif isdefined("paramretro")>
										<cflocation addtoken="no" url="listaDocumentosContablesR.cfm">
									<cfelseif isdefined("LvarCC")>
										<cflocation addtoken="no" url="listaDocumentosContablesCC.cfm">
                                    <cfelse>
										<cflocation addtoken="no" url="listaDocumentosContables.cfm">
									</cfif>
								</cfif>
							</cfif>
						</cfif>
					</cfif>
					<!--- <cfsavecontent variable="lista"> --->
					<cfif isdefined("url.IDcontable") and len(trim(url.IDcontable)) gt 0>
						<cfset IDcontable = url.IDcontable>
						<cfset IDcontable_detalle = url.IDcontable>
					</cfif>
					
					<cfset LvarFiltro = ''>
					<cfif isdefined('form.FCFORMATO') and len(trim(form.FCFORMATO))>
						<cfset LvarFiltro = LvarFiltro & ' and b.CFformato like ' & "'%" & form.FCFORMATO & "%'">
					</cfif>
					<cfif isdefined('form.FDESCRIPCION') and len(trim(form.FDESCRIPCION))>
						<cfset LvarFiltro = LvarFiltro & ' and a.Ddescripcion like  ' & "'%" & form.FDESCRIPCION & "%'">
					</cfif>
					<cfif isdefined('form.FOcodigo') and len(trim(form.FOcodigo))>
						<cfset LvarOcodigo = mid(form.FOcodigo, FindOneOf("|", form.FOcodigo,1)+1,10)>
						<cfset LvarFiltro = LvarFiltro & ' and a.Ocodigo =  '  & LvarOcodigo>
					</cfif>

						<cfif Len(Trim(IDcontable)) NEQ 0 and not isdefined("form.btnNuevo")>
							<cfif inter eq "N">
								<cfquery name="rsListaLineas" datasource="#Session.DSN#">
									Select a.Dlinea, 
										a.IDcontable,
										<cf_dbfunction name="sPart"	args="a.Ddescripcion,1,50"> as Ddescripcion,
										b.CFformato,
										c.Mnombre,
										case when a.Dmovimiento = 'D' then a.Dlocal else 0 end as Debitos,
										case when a.Dmovimiento = 'C' then a.Dlocal else 0 end as Creditos,
										case when E.ECauxiliar <> 'S' 
											then
												'<img alt=#chr(34)#Borrar#chr(34)# border=#chr(34)#0#chr(34)# src=#chr(34)#/cfmx/sif/imagenes/Borrar01_S.gif#chr(34)# onClick=#chr(34)#javascript:borrar(''' 
												#_Cat# <cf_dbfunction name="to_char" args="a.IDcontable" datasource="#session.dsn#"> 
												#_Cat# ''','''
												#_Cat# <cf_dbfunction name="to_char" args="a.Dlinea" datasource="#session.dsn#">
												#_Cat#''');#chr(34)#>'
											else ' ' 
										end as IMGborrar, a.Dreferencia #_Cat# '-' #_Cat# a.Ddocumento as Dreferencia, E.ECauxiliar
									from DContables a
										inner join EContables E
											on E.IDcontable = a.IDcontable
										inner join CFinanciera b
											on b.CFcuenta = a.CFcuenta
										inner join Monedas c
											on c.Mcodigo = a.Mcodigo 
									where a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
									    and a.Dlinea between #LvarLineaInicial# and #LvarLineaFinal#
										#PreserveSingleQuotes(Lvarfiltro)#
									order by a.Dlinea				
								</cfquery>
								
							<cfelse>
								<cfquery name="rsListaLineas" datasource="#Session.DSN#">
									Select a.Dlinea, 
										a.IDcontable,
										em.Edescripcion,
										<cf_dbfunction name="sPart"	args="a.Ddescripcion,1,50"> as Ddescripcion,
										b.CFformato,
										c.Mnombre,
										case when a.Dmovimiento = 'D' then a.Dlocal else 0 end as Debitos,
										case when a.Dmovimiento = 'C' then a.Dlocal else 0 end as Creditos,
										case when E.ECauxiliar <> 'S' 
											then
												'<img alt=#chr(34)#Borrar#chr(34)# border=#chr(34)#0#chr(34)# src=#chr(34)#../../imagenes/Borrar01_S.gif#chr(34)# onClick=#chr(34)#javascript:borrar(''' 
												#_Cat# <cf_dbfunction name="to_char" args="a.IDcontable" datasource="#session.dsn#">
												#_Cat# '''
												#_Cat# '''
												#_Cat# <cf_dbfunction name="to_char" args="a.Dlinea" datasource="#session.dsn#">
												#_Cat#''');#chr(34)#>'
											else ' ' 
										end as IMGborrar, a.Dreferencia #_Cat# '-' #_Cat# a.Ddocumento as Dreferencia, E.ECauxiliar
									from DContables a
											inner join EContables E
												on  E.IDcontable = a.IDcontable
											inner join CFinanciera b
												inner join Empresas em
													on em.Ecodigo = b.Ecodigo
												on b.CFcuenta = a.CFcuenta
											inner join Monedas c
												on c.Mcodigo = a.Mcodigo 
									where a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
										 and a.Dlinea between #LvarLineaInicial# and #LvarLineaFinal#
										 #PreserveSingleQuotes(Lvarfiltro)#
									order by a.Dlinea				
								</cfquery>
							</cfif>
						
							<script language="javascript" type="text/javascript">
								function borrar(idConta, idLinea){
									if((confirm('Desea eliminar la línea ' + idLinea + ' del asiento contable ?')) && (idConta != "") && (idLinea != "")){
										document.filtroDetalle.nosubmit=true;										
										document.form1.IDcontable.value = idConta;
										document.form1.Dlinea.value = idLinea;
										document.form1.borrarLista.value = 'S';
										document.form1.submit();
									}
									
									return false;							
								}
							</script>						
							<cfquery name="rsTotalLineas" datasource="#session.dsn#">
								select 	sum(case when a.Dmovimiento = 'D' then a.Dlocal else 0 end) as Debitos, 
												sum(case when a.Dmovimiento = 'C' then a.Dlocal else 0 end) as Creditos
								from DContables a
								where a.IDcontable = #IDcontable#
							</cfquery>

							
							<cfset navegacion = "IDcontable=#Form.IDcontable#">
							
							<cfset navegacion = navegacion & "&LvarDlinea=" & form.LvarDlinea>
							<cfset url.PageNum_lista = 1>
							<cfset form.Pagina = 1>
						</cfif>
					<!--- </cfsavecontent> --->
					<cfif inter eq "S">
						<cfset TituloP = 'Registro de Documentos Contables Intercompa&ntilde;&iacute;as'>
					<cfelse>
						<cfif isdefined("paramretro")>
							<cfset TituloP = 'Registro de Documentos Contables Retroactivos'>
						<cfelse>
							<cfset TituloP = 'Registro de Documentos Contables'>
						</cfif>
					</cfif>
					<cfif sufix eq 'CierreAnual'>
						<cfset TituloP = "Registro de Documentos Contables de Cierre Anual">
					</cfif>
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=#TituloP#>
<!---
						<cfinclude template="../../portlets/pNavegacion.cfm">
--->
						<table width="100%" align="center"><tr><td align="right"><cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Registro_Documentos_Contables.htm"></td></tr></table>
						<table width="77%" align="center" border="1" cellpadding="0" cellspacing="0">
							<!--- form --->
							<tr>
								<td>
									<cfif inter eq "N" and isdefined("Form.IDcontable_detalle") and len(trim(form.IDcontable_detalle))>
										<cfquery name="rsBalanceOfic" datasource="#session.dsn#">
											select 
												d.Ocodigo as Oficina, 
												d.Mcodigo as Mcodigo,
												<!---d.Dtipocambio as Dtipocambio, --->
												sum(d.Dlocal * case Dmovimiento when 'D' then 1.00 else 0.00 end) as Dlocal, 
												sum(d.Doriginal * case Dmovimiento when 'D' then 1.00 else 0.00 end) as Doriginal
											from DContables d
											where d.IDcontable = #IDcontable#
											group by d.Ocodigo, d.Mcodigo 
											having sum(d.Dlocal * case Dmovimiento when 'D' then 1.00 else 0.00 end) <> 0 or sum(d.Doriginal * case Dmovimiento when 'D' then 1.00 else 0.00 end) <> 0
										</cfquery>
									</cfif>
										<cfinclude template="CGV3polizaGen_form.cfm">
									
								</td>
							</tr>
							<!--- lista --->
							<tr>
								<td>
									<!---  --->
									<!--- Filtros para el Detalle del Documento Contable de Importación --->
									<cfoutput>
										<form name="filtroDetalle" method="post" action="#GetFileFromPath(GetTemplatePath())#">
										<input type="hidden" name="Nivel" value="5">
										<input type="hidden" name="IDcontable_detalle" value="<cfif modo NEQ "ALTA"><cfoutput>#form.IDcontable#</cfoutput></cfif>">
										<input type="hidden" name="LvarDlinea" value="<cfif modo NEQ "ALTA"><cfoutput>#form.LvarDlinea#</cfoutput></cfif>">
										
										  	<cfif isdefined("rsListaLineas") and rsListaLineas.recordcount GT 0 or isdefined("form.fCformato")> 
												<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
												<cfif rsListaLineas.ECauxiliar neq 'S'>
												  <tr>
													<td class="fileLabel" colspan="10">
														<input type="checkbox" name="chkDelALL" onclick="funcFiltroChkAllfiltroDetalle(this);" />
														<cf_translate key='Borrar'>Marcar Todos</cf_translate>
														<input type="button" class="btnEliminar" value="Borrar" onclick="borrarMarcados();" />
														<script language="javascript">
															function borrarMarcados()
															{
																if (!fnAlgunoMarcadofiltroDetalle())
																{
																	alert("No hay lineas marcadas")
																	return false;
																}
																if(confirm('Desea eliminar las líneas marcadas?'))
																{
																	chequeados = '';
																if (document.filtroDetalle.chk.value)
																	chequeados = document.filtroDetalle.chk.value;
																else
																{
																	 for(i = 0; i < document.filtroDetalle.chk.length;i++)
																	 {
																		if (document.filtroDetalle.chk[i].checked)
																		chequeados =chequeados + document.filtroDetalle.chk[i].value +',';
																	 }
																}
																	document.form1.chk.value = (document.filtroDetalle.chk.value ? chequeados : (chequeados.length > 0 ? chequeados.substr(0,chequeados.length - 1) : chequeados));								
																	document.filtroDetalle.nosubmit=true;										
																	document.form1.borrarLista.value = 'S';
																	document.form1.submit();
																}
																
																return false;							
															}
														</script>	
													</td>
												  </tr>
												 </cfif>
												  <tr>
													<td class="fileLabel"><cf_translate key='linea'>L&iacute;nea</cf_translate></td>
													<td class="fileLabel"><cf_translate key='descripcion'>Descripci&oacute;n</cf_translate></td>
													<td class="fileLabel"><cf_translate key='cuenta_contable'>Cuenta Financiera</cf_translate></td>
													<td class="fileLabel"><cf_translate key='oficina'>Oficina</cf_translate></td>
												   
												  </tr>
												  <tr>
													<td>
														<input type="text" name="flinea" size="13" tabindex="3" value="<cfif isdefined("Form.flinea")>#Form.flinea#</cfif>">	</td>
													<td>
														<input type="text" name="fDescripcion" size="30" tabindex="3" value="<cfif isdefined("Form.fDescripcion")>#Form.fDescripcion#</cfif>">			</td>
													<td>
														<input type="text" name="fCformato" size="30" tabindex="3" value="<cfif isdefined("Form.fCformato")>#Form.fCformato#</cfif>">			</td>
													<td>
														<cfif isdefined("Form.fOcodigo") and Len(Trim(Form.fOcodigo))>
															<cfset ofic = ListToArray(Form.fOcodigo, '|')>
														</cfif>
														<select name="fOcodigo" tabindex="3">
															<option value="">(Todas)</option>
															<cfif modo EQ "CAMBIO">
																<cfloop query="rsOficinasDetalle">
																	<option value="#rsOficinasDetalle.Ecodigo#|#rsOficinasDetalle.Ocodigo#"<cfif isdefined("Form.fOcodigo") and Len(Trim(Form.fOcodigo)) and rsOficinasDetalle.Ecodigo EQ ofic[1] and rsOficinasDetalle.Ocodigo EQ ofic[2]> selected</cfif>>#rsOficinasDetalle.Odescripcion#</option>
																</cfloop>
															</cfif>
														</select>
													</td>
													<td align="center" colspan="9">
														<input type="submit" name="btnBuscar" class="btnFiltrar" value="Buscar" tabindex="3">
													</td>
												  </tr>
											  <tr>
												<td colspan="5">
													<cfif inter eq "N" and isdefined("Form.IDcontable_detalle") and len(trim(form.IDcontable_detalle))>
														<cfinvoke 
															 component="sif.Componentes.pListas"
															 method="pListaQuery"
															 returnvariable="pListaRet">
																<cfinvokeargument name="query" value="#rsListaLineas#"/>
																<!--- <cfinvokeargument name="desplegar" value="DCIconsecutivo, Ddescripcion, CFformato, Odescripcion, Mnombre, Debitos, Creditos, IMGborrar"/> --->
																<cfinvokeargument name="desplegar" value="Dlinea, Ddescripcion, CFformato, Dreferencia, Mnombre, Debitos, Creditos, IMGborrar"/>
																<cfinvokeargument name="etiquetas" value="L&iacute;nea, Descripci&oacute;n, Cuenta Financiera, Ref - Doc, Moneda, D&eacute;bitos, Cr&eacute;ditos"/>
																<cfinvokeargument name="formatos" value=" S, S, S, S, S, M, M, S"/>
																<cfinvokeargument name="align" value="left, left, left, left, left, right, right, right"/>
																<cfinvokeargument name="ajustar" value="N"/>
																<cfinvokeargument name="totales" value="Debitos,Creditos"/>
																<cfinvokeargument name="pasarTotales" value="#rsTotalLineas.Debitos#,#rsTotalLineas.Creditos#"/>
																<cfinvokeargument name="Incluyeform" value="true">
																<cfinvokeargument name="formname" value="filtroDetalle">
																<cfinvokeargument name="keys" value="IDcontable, Dlinea">
																<cfinvokeargument name="irA" value="CGV3conta.cfm?nivel=5"/>
																<cfinvokeargument name="navegacion" value="#navegacion#">
																<cfinvokeargument name="showEmptyListMsg" value="true"/>
																<cfinvokeargument name="MaxRows" value="30">
																<cfinvokeargument name="checkBoxes" value="S">
														</cfinvoke>
													<cfelseif inter NEQ "N" and isdefined("Form.IDcontable_detalle") and len(trim(form.IDcontable_detalle))>
														<cfinvoke 
															 component="sif.Componentes.pListas"
															 method="pListaQuery"
															 returnvariable="pListaRet">
																<cfinvokeargument name="query" value="#rsListaLineas#"/>
																<cfinvokeargument name="desplegar" value="Dlinea, Ddescripcion, Edescripcion,CFformato, Dreferencia, Mnombre, Debitos, Creditos, IMGborrar"/>
																<cfinvokeargument name="etiquetas" value="L&iacute;nea, Descripci&oacute;n, Empresa, Cuenta Financiera, Ref - Doc, Moneda, D&eacute;bitos, Cr&eacute;ditos"/>
																<cfinvokeargument name="formatos" value=" S, S, S,S, S,  S, M, M, S"/>
																<cfinvokeargument name="align" value="left, left, left, left, left, left, right, right, right"/>
																<cfinvokeargument name="ajustar" value="N"/>
																<cfinvokeargument name="totales" value="Debitos,Creditos"/>
																<cfinvokeargument name="pasarTotales" value="#rsTotalLineas.Debitos#,#rsTotalLineas.Creditos#"/>
																<cfinvokeargument name="Incluyeform" value="true">
																<cfinvokeargument name="keys" value="IDcontable, Dlinea">
																<cfinvokeargument name="formname" value="filtroDetalle">
																<cfinvokeargument name="irA" value="CGV3conta.cfm?nivel=5"/>
																<cfinvokeargument name="navegacion" value="#navegacion#">
																<cfinvokeargument name="showEmptyListMsg" value="true"/>
																<cfinvokeargument name="MaxRows" value="30">
														</cfinvoke>
													</cfif>
												</td>
											  </tr>
													<tr>
														<td colspan="5"><hr></td>
													</tr>
												</table>
											</cfif>
										  </form>
										  </cfoutput>
								</td>
							</tr>
						</table>
           <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>
