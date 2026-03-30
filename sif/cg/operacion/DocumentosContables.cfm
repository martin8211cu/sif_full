<cfinvoke  key="BTN_Buscar" default="Buscar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Buscar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="linea" default="Línea" component="sif.Componentes.Translate" method="Translate"
returnvariable="linea" xmlfile="DocumentosContables.xml"/>
<cfinvoke  key="descripcion" default="Descripci&oacute;n" component="sif.Componentes.Translate" method="Translate"
returnvariable="descripcion" xmlfile="DocumentosContables.xml"/>
<cfinvoke  key="CuentaFinanciera" default="Cuenta Financiera" component="sif.Componentes.Translate" method="Translate"
returnvariable="CuentaFinanciera" xmlfile="DocumentosContables.xml"/>
<cfinvoke  key="Moneda" default="Moneda" component="sif.Componentes.Translate" method="Translate"
returnvariable="Moneda" xmlfile="DocumentosContables.xml"/>
<cfinvoke  key="debito" default="D&eacute;bito" component="sif.Componentes.Translate" method="Translate"
returnvariable="Debito" xmlfile="DocumentosContables.xml"/>
<cfinvoke  key="credito" default="Cr&eacute;dito" component="sif.Componentes.Translate" method="Translate"
returnvariable="Credito" xmlfile="DocumentosContables.xml"/>
<cfinvoke  key="LB_Titulo" default="Registro de Documentos Contables" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Titulo" xmlfile="DocumentosContables.xml"/>
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

<cfif isdefined("url.PageNum_lista2") and url.PageNum_lista2 gt 1>
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

<cfif isdefined ("Form.btnbuscar") or isdefined("url.pagenum_lista2")>
	<cfset modo = "CAMBIO">
</cfif>
<cfif isdefined ("Form.btnBuscar")>
	<cfset form.pageNum_lista2 = 1>
    <cfset form.pageNum2 = 1>
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
<cfif isdefined("url.pageNum_lista2") and len(trim(url.pageNum_lista2)) and not isdefined("form.pageNum_lista2")>
	<cfset form.pageNum_lista2 = url.pageNum_lista2 >
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
		<cf_templateheader title="#LB_Titulo#">

		<table width="100%" cellpadding="2" cellspacing="0" >
			<tr>
				<td valign="top">
                	<cf_navegacion name="flinea" default="1">
                    <cfset LvarLineaInicial = 1>
					<cfif len(trim(Form.flinea))>
                    	<cfset LvarLineaInicial = Form.flinea>
                    </cfif>
					<cfset LvarLineaFinal   = LvarLineaInicial + 500>
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
												'<img alt=#chr(34)#Borrar#chr(34)# border=#chr(34)#0#chr(34)# src=#chr(34)#../../imagenes/Borrar01_S.gif#chr(34)# onClick=#chr(34)#javascript:borrar('''
												#_Cat# <cf_dbfunction name="to_char" args="a.IDcontable" datasource="#session.dsn#">
												#_Cat# ''','''
												#_Cat# <cf_dbfunction name="to_char" args="a.Dlinea" datasource="#session.dsn#">
												#_Cat#''');#chr(34)#>'
											else ' '
										end as IMGborrar, a.Dreferencia as Dreferencia , a.Ddocumento as Ddocumento, E.ECauxiliar
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
                                        <cfif isdefined("Form.fdoc") and len(trim(Form.fdoc))> and a.Ddocumento like '%#Form.fdoc#%' </cfif>
                                        <cfif isdefined("Form.fref") and len(trim(Form.fref))> and a.Dreferencia like '%#Form.fref#%' </cfif>
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
												#_Cat# ''','''
												#_Cat# <cf_dbfunction name="to_char" args="a.Dlinea" datasource="#session.dsn#">
												#_Cat#''');#chr(34)#>'
											else ' '
										end as IMGborrar, a.Dreferencia as Dreferencia, a.Ddocumento as Ddocumento, E.ECauxiliar
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
                                         <cfif isdefined("Form.fdoc") and len(trim(Form.fdoc))> and a.Ddocumento like '%#Form.fdoc#%' </cfif>
                                        <cfif isdefined("Form.fref") and len(trim(Form.fref))> and a.Dreferencia like '%#Form.fref#%' </cfif>
									order by a.Dlinea
								</cfquery>
							</cfif>
<cfinvoke  key="MSG_DeseaElimLinea" default="Desea eliminar la línea" component="sif.Componentes.Translate" method="Translate"
returnvariable="MSG_DeseaElimLinea" xmlfile="DocumentosContables.xml"/>
<cfinvoke  key="MSG_DelAsCont" default="del asiento contable ?" component="sif.Componentes.Translate" method="Translate"
returnvariable="MSG_DelAsCont" xmlfile="DocumentosContables.xml"/>
							<cfoutput>
							<script language="javascript" type="text/javascript">
								function borrar(idConta, idLinea){

									if((confirm('#MSG_DeseaElimLinea# ' + idLinea + ' #MSG_DelAsCont#')) && (idConta != "") && (idLinea != "")){
										document.filtroDetalle.nosubmit=true;
										document.form1.IDcontable.value = idConta;
										document.form1.Dlinea.value = idLinea;
										document.form1.borrarLista.value = 'S';
										document.form1.submit();
									}

									return false;
								}
							</script>
                            </cfoutput>
							<cfquery name="rsTotalLineas" datasource="#session.dsn#">
								select 	sum(case when a.Dmovimiento = 'D' then a.Dlocal else 0 end) as Debitos,
												sum(case when a.Dmovimiento = 'C' then a.Dlocal else 0 end) as Creditos
								from DContables a
								where a.IDcontable = #IDcontable#
							</cfquery>


							<cfset navegacion2 = "IDcontable=#Form.IDcontable#">

							<cfset navegacion2 = navegacion2 & "&LvarDlinea=" & form.LvarDlinea>

						</cfif>
					<!--- </cfsavecontent> --->
					<cfif inter eq "S">
						<cfset TituloP = 'Registro de Documentos Contables Intercompa&ntilde;&iacute;as'>
					<cfelse>
						<cfif isdefined("paramretro")>
							<cfset TituloP = 'Registro de Documentos Contables Retroactivos'>
						<cfelse>
							<cfset TituloP = '#LB_TItulo#'>
						</cfif>
					</cfif>
					<cfif sufix eq 'CierreAnual'>
						<cfset TituloP = "Registro de Documentos Contables de Cierre Anual">
					</cfif>

                    <cfinvoke  key="BTN_Borrar" default="Borrar" component="sif.Componentes.Translate" method="Translate"
                    returnvariable="BTN_Borrar" xmlfile="/sif/generales.xml"/>
                    <cfinvoke  key="MSG_ElimLinMarc" default="Desea eliminar las líneas marcadas?" component="sif.Componentes.Translate" method="Translate" returnvariable="MSG_ElimLinMarc"/>
                    <cfinvoke  key="MSG_NoLinMarc" default="No hay lineas marcadas" component="sif.Componentes.Translate" method="Translate" returnvariable="MSG_NoLinMarc"/>



					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=#LB_Titulo#>
						<cfinclude template="../../portlets/pNavegacion.cfm">
						<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
							<!--- form --->
							<tr>
								<td>
									<cfif (inter eq "N" or inter eq "S") and isdefined("Form.IDcontable_detalle") and len(trim(form.IDcontable_detalle))>
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
										<cfinclude template="formDocumentosContables.cfm">

								</td>
							</tr>
							<!--- lista --->
							<tr>
								<td>
									<!---  --->
									<!--- Filtros para el Detalle del Documento Contable de Importación --->
									<cfoutput>
										<form name="filtroDetalle" method="post" action="#GetFileFromPath(GetTemplatePath())#">
										<input type="hidden" name="IDcontable_detalle" value="<cfif modo NEQ "ALTA"><cfoutput>#form.IDcontable#</cfoutput></cfif>">
										<input type="hidden" name="LvarDlinea" value="<cfif modo NEQ "ALTA"><cfoutput>#form.LvarDlinea#</cfoutput></cfif>">
										<input name="PageNum_lista2" type="hidden" value="<cfif isdefined("form.PageNum_lista2")>#form.PageNum_lista2#</cfif>">
										  	<cfif isdefined("rsListaLineas") and rsListaLineas.recordcount GT 0 or isdefined("form.fCformato")>
												<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
												<cfif rsListaLineas.ECauxiliar neq 'S'>
												  <tr>
													<td class="fileLabel" colspan="10">
														<input type="checkbox" name="chkDelALL" onclick="funcFiltroChkAllfiltroDetalle(this);" />
														<cf_translate key='Borrar'>Marcar Todos</cf_translate>
														<input type="button" class="btnEliminar" value="#BTN_Borrar#" onclick="borrarMarcados();" />
														<script language="javascript">
															function borrarMarcados()
															{
																if (!fnAlgunoMarcadofiltroDetalle())
																{
																	alert("#MSG_NoLinMarc#")
																	return false;
																}
																if(confirm('#MSG_ElimLinMarc#'))
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
                                                    <td class="fileLabel"><cf_translate key='cuenta_ref'>Ref.</cf_translate></td>
                                                    <td class="fileLabel"><cf_translate key='cuenta_doc'>Doc.</cf_translate></td>
													<td class="fileLabel"><cf_translate key='oficina'>Oficina</cf_translate></td>

												  </tr>
												  <tr>
													<td>
                                                    	<cf_navegacion name="flinea" default="1">
                                                        <cfset navegacion2 = navegacion2 & "&flinea=" & form.flinea>
														<input type="text" name="flinea" size="13" tabindex="3" value="<cfif len(trim(Form.flinea))>#Form.flinea#</cfif>">	</td>
													<td>
														<input type="text" name="fDescripcion" size="30" tabindex="3" value="<cfif isdefined("Form.fDescripcion")>#Form.fDescripcion#</cfif>">			</td>
													<td>
														<input type="text" name="fCformato" size="30" tabindex="3" value="<cfif isdefined("Form.fCformato")>#Form.fCformato#</cfif>">			</td>
                                                    <td>
														<input type="text" name="fref" size="12" tabindex="3" value="<cfif isdefined("Form.fref")>#Form.fref#</cfif>">			</td>
                                                    <td>
														<input type="text" name="fdoc" size="12" tabindex="3" value="<cfif isdefined("Form.fdoc")>#Form.fdoc#</cfif>">			</td>
													<td>
														<cfif isdefined("Form.fOcodigo") and Len(Trim(Form.fOcodigo))>
															<cfset ofic = ListToArray(Form.fOcodigo, '|')>
														</cfif>
														<select name="fOcodigo" tabindex="3">
															<option value="">(<cf_translate key=todas>Todas</cf_translate>)</option>
															<cfif modo EQ "CAMBIO">
																<cfloop query="rsOficinasDetalle">
																	<option value="#rsOficinasDetalle.Ecodigo#|#rsOficinasDetalle.Ocodigo#"<cfif isdefined("Form.fOcodigo") and Len(Trim(Form.fOcodigo)) and rsOficinasDetalle.Ecodigo EQ ofic[1] and rsOficinasDetalle.Ocodigo EQ ofic[2]> selected</cfif>>#rsOficinasDetalle.Odescripcion#</option>
																</cfloop>
															</cfif>
														</select>
													</td>
													<td align="center" colspan="9">
														<input type="submit" name="btnBuscar" class="btnFiltrar" value="#BTN_Buscar#" tabindex="3">
													</td>
												  </tr>
											  <tr>
												<td colspan="8">
													<cfif inter eq "N" and isdefined("Form.IDcontable_detalle") and len(trim(form.IDcontable_detalle))>
														<cfinvoke
															 component="sif.Componentes.pListas"
															 method="pListaQuery"
															 returnvariable="pListaRet">
																<cfinvokeargument name="query" value="#rsListaLineas#"/>
																<!--- <cfinvokeargument name="desplegar" value="DCIconsecutivo, Ddescripcion, CFformato, Odescripcion, Mnombre, Debitos, Creditos, IMGborrar"/> --->
																<cfinvokeargument name="desplegar" value="Dlinea, Ddescripcion, CFformato, Dreferencia, Ddocumento, Mnombre, Debitos, Creditos, IMGborrar"/>
																<cfinvokeargument name="etiquetas" value="#Linea#, #Descripcion#, #CuentaFinanciera#, Ref , Doc, #Moneda#, #Debito#, #Credito#"/>
																<cfinvokeargument name="formatos" value=" S, S, S, S, S, S, M, M, S"/>
																<cfinvokeargument name="align" value="left, left, left, left, left, left, right, right, right"/>
																<cfinvokeargument name="ajustar" value="N"/>
																<cfinvokeargument name="totales" value="Debitos,Creditos"/>
																<cfinvokeargument name="pasarTotales" value="#rsTotalLineas.Debitos#,#rsTotalLineas.Creditos#"/>
																<cfinvokeargument name="Incluyeform" value="true">
																<cfinvokeargument name="formname" value="filtroDetalle">
																<cfinvokeargument name="keys" value="IDcontable, Dlinea">
																<cfinvokeargument name="irA" value="DocumentosContables#sufix#.cfm?inter=#inter#"/>
																<cfinvokeargument name="navegacion" value="#navegacion2#">
																<cfinvokeargument name="showEmptyListMsg" value="true"/>
																<cfinvokeargument name="MaxRows" value="30">
																<cfinvokeargument name="checkBoxes" value="S">
                                                                <cfinvokeargument name="PageIndex" value="2">
														</cfinvoke>
													<cfelseif inter NEQ "N" and isdefined("Form.IDcontable_detalle") and len(trim(form.IDcontable_detalle))>
														<cfinvoke
															 component="sif.Componentes.pListas"
															 method="pListaQuery"
															 returnvariable="pListaRet">
																<cfinvokeargument name="query" value="#rsListaLineas#"/>
																<cfinvokeargument name="desplegar" value="Dlinea, Ddescripcion, Edescripcion,CFformato, Dreferencia, Ddocumento, Mnombre, Debitos, Creditos, IMGborrar"/>
																<cfinvokeargument name="etiquetas" value="L&iacute;nea, Descripci&oacute;n, Empresa, Cuenta Financiera, Ref , Doc, Moneda, D&eacute;bitos, Cr&eacute;ditos"/>
																<cfinvokeargument name="formatos" value=" S, S, S, S, S, S, S, M, M, S"/>
																<cfinvokeargument name="align" value="left, left, left, left, left, left, right, right, right,righ"/>
																<cfinvokeargument name="ajustar" value="N"/>
																<cfinvokeargument name="totales" value="Debitos,Creditos"/>
																<cfinvokeargument name="pasarTotales" value="#rsTotalLineas.Debitos#,#rsTotalLineas.Creditos#"/>
																<cfinvokeargument name="Incluyeform" value="true">
																<cfinvokeargument name="keys" value="IDcontable, Dlinea">
																<cfinvokeargument name="formname" value="filtroDetalle">
																<cfinvokeargument name="irA" value="DocumentosContables#sufix#.cfm?inter=#inter#"/>
																<cfinvokeargument name="navegacion" value="#navegacion2#">
																<cfinvokeargument name="showEmptyListMsg" value="true"/>
																<cfinvokeargument name="MaxRows" value="30">
                                                                <cfinvokeargument name="PageIndex" value="2">
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
