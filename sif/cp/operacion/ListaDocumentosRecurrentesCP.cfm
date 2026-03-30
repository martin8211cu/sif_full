<!--- ****************************************************************************************************
	12/1/2006 Modificado por: Dorian Abarca Gómez, Motivo: Se agregan 3 columnas Periodo, Mes, Fecha, y se reordena.
	12/1/2006 Creado por: Gustavo Fonseca H, Motivo: Nueva opción de Facturas Recurentes.
	************************************************************************************************** --->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Lista de Facturas Recurrentes</title>
<script language="javascript" type="text/javascript">
	function funcCerrar(){
		window.close();
	}
</script>
</head>

<body>
<cf_templatecss>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">	
			<cfset url.tipo = 'C'>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr> 
						<td> 
							<cfset filtro = "a.Ecodigo = #Session.Ecodigo# and c.CPTtipo = '#url.tipo#' and a.SNcodigo = b.SNcodigo and a.SNcodigo = #url.SNcodigo# and a.CPTcodigo = c.CPTcodigo and a.Ecodigo = b.Ecodigo and a.Ecodigo = c.Ecodigo and a.Mcodigo = m.Mcodigo"> 
							<form name="filtros" action="ListaDocumentosRecurrentesCP.cfm" method="get" style="margin:0">
								<input name="SNcodigo" value="<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))><cfoutput>#url.SNcodigo#</cfoutput></cfif>" type="hidden">
								<input name="EDdocumento" value="<cfif isdefined("url.EDdocumento") and len(trim(url.EDdocumento))><cfoutput>#url.EDdocumento#</cfoutput></cfif>" type="hidden">
								<input name="TESRPTCid" value="<cfif isdefined("url.TESRPTCid") and len(trim(url.TESRPTCid))><cfoutput>#url.TESRPTCid#</cfoutput></cfif>" type="hidden">
								<cfparam name="url.Registros" default="20">
								<cfset Navegacion = "Tipo=#url.Tipo#">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
								  <tr>
									<td align="center" class="tituloListas">Lista de Facturas Recurrentes</td>
								  </tr>
								</table>
								<table width="100%" border="0" cellspacing="2" cellpadding="0">
									<tr> 
										<td class="tituloListas" width="4%">&nbsp;</td>
										<td class="tituloListas"><strong>Transacción</strong></td>
										<td class="tituloListas"><strong>Documento </strong></td>
										<td class="tituloListas"><strong>Moneda</strong></td>
										<td class="tituloListas"><strong>Periodo</strong></td>
										<td class="tituloListas"><strong>Mes</strong></td>
										<td class="tituloListas"><strong>Fecha</strong></td>
										<td class="tituloListas"><strong>Usuario</strong></td>
										<td class="tituloListas"><strong>Registros</strong></td>
										<td class="tituloListas">&nbsp;</td>
									</tr>
									
									<tr> 
										<td class="tituloListas">&nbsp;</td>
										<td class="tituloListas">
											<cfquery name="rsTransacciones" datasource="#Session.DSN#" >
												  select 'Todos' as CPTcodigo, 'Todos' as CPTdescripcion from dual
												  union all 
												  select distinct a.CPTcodigo, b.CPTdescripcion 
												  from CPTransacciones b , HEDocumentosCP a 
												  where a.Ecodigo =  #Session.Ecodigo# 
													and a.Ecodigo = b.Ecodigo and a.CPTcodigo = b.CPTcodigo 
													and b.CPTtipo = '#url.tipo#' 
													and coalesce(b.CPTpago, 0) != 1
													and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
													and a.EDrecurrente = 1
												  order by CPTcodigo desc 
											</cfquery> 
											<select name="Transaccion">
												<cfoutput query="rsTransacciones"> 
													<option value="#rsTransacciones.CPTcodigo#" <cfif isdefined("url.Transaccion") and  rsTransacciones.CPTcodigo EQ Transaccion>selected</cfif>>#rsTransacciones.CPTdescripcion#</option>
												</cfoutput>
											</select>
										</td>
										<td class="tituloListas">
											<input name="Documento" type="text" value="<cfif isDefined("url.Documento") and len(Trim(url.Documento))><cfoutput>#url.Documento#</cfoutput></cfif>" size="20" maxlength="20">	
										</td>
										<td class="tituloListas">
											<cfquery name="rsMonedas" datasource="#Session.DSN#">
												select 'Todos' as Mcodigo, 'Todas' as Mnombre from dual
												union all 
												select distinct <cf_dbfunction name="to_char" args="a.Mcodigo"> Mcodigo, b.Mnombre 
												from Monedas b , HEDocumentosCP a 
												where a.Ecodigo =  #Session.Ecodigo# 
												  and b.Mcodigo = a.Mcodigo 
												  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
												  and a.EDrecurrente = 1
												 order by Mcodigo desc 
											</cfquery> 
											<select name="Moneda">
												<cfoutput query="rsMonedas"> 
													<option value="#rsMonedas.Mcodigo#" <cfif isdefined("url.Moneda") and rsMonedas.Mcodigo EQ url.Moneda>selected</cfif>>#rsMonedas.Mnombre#</option>
												</cfoutput>
											</select>
										</td>
										<td class="tituloListas">
										
											<cfquery name="rsPeriodos" datasource="#Session.DSN#">
												select 0 as valor, 'Todos' as description from dual
												union all 
												select distinct <cf_dbfunction name="date_part"	args="YYYY,Dfecha"> as valor, <cf_dbfunction name="date_format"	args="Dfecha,YYYY"> as description
												from HEDocumentosCP a, CPTransacciones b 
												where a.Ecodigo =  #Session.Ecodigo# 
												  and a.Ecodigo = b.Ecodigo 
												  and a.CPTcodigo = b.CPTcodigo 
												  and b.CPTtipo = '#url.tipo#' 
												  and coalesce(b.CPTpago,0) != 1
												  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
												  and a.EDrecurrente = 1
												order by valor
											</cfquery> 
											<select name="Periodo">
												<cfoutput query="rsPeriodos"> 
													<option value="#rsPeriodos.valor#" <cfif isdefined("url.Periodo") and  rsPeriodos.valor EQ Url.Periodo>selected</cfif>>#rsPeriodos.description#</option>
												</cfoutput>
											</select>
										</td>
										<td class="tituloListas">
											<cfquery name="rsMeses" datasource="#Session.DSN#">
												select 0 as value, 'Todos' as description from dual
												union all 
												select <cf_dbfunction args="VSvalor" name="to_number"> as value, VSdesc as description
												from VSidioma, Idiomas
												where rtrim(lower(Icodigo))=rtrim(lower('es_CR'))
												and VSidioma.Iid =  Idiomas.Iid
												and VSgrupo = 1
												order by 1
											</cfquery> 
											<select name="Mes">
												<cfoutput query="rsMeses"> 
													<option value="#rsMeses.value#" <cfif isdefined("url.Mes") and  rsMeses.value EQ Url.Mes>selected</cfif>>#rsMeses.description#</option>
												</cfoutput>
											</select>
										</td>
										<td class="tituloListas">
										
											<cfquery name="rsFechas" datasource="#Session.DSN#">
												select 'Todos' as EDfecha, 'Todas' as EDfechaDESC, #lsparsedatetime('01/01/6100')# as Dfecha from dual
												union all 
												select distinct <cf_dbfunction name="to_sdateDMY"	args="a.Dfecha"> as EDfecha, <cf_dbfunction name="to_sdateDMY"	args="a.Dfecha">as EDfechaDESC , a.Dfecha
												from HEDocumentosCP a, CPTransacciones b 
												where a.Ecodigo =  #Session.Ecodigo# 
												  and a.Ecodigo = b.Ecodigo 
												  and a.CPTcodigo = b.CPTcodigo 
												  and b.CPTtipo = '#url.tipo#' 
												  and coalesce(b.CPTpago,0) != 1
												  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
												  and a.EDrecurrente = 1
												order by Dfecha desc
											</cfquery> 
											<select name="Fecha">
												<cfoutput query="rsFechas"> 
													<option value="#rsFechas.EDFecha#" <cfif isdefined("url.Fecha") and  rsFechas.EDfecha EQ Fecha>selected</cfif>>#rsFechas.EDfechaDESC#</option>
												</cfoutput>
											</select>
										</td>
										<td class="tituloListas">
											<cfquery name="rsUsuarios" datasource="#Session.DSN#">
												select 'Todos' as EDusuario, 'Todos' as EDusuarioDESC  from dual
												union all 
												select distinct EDusuario, EDusuario as EDusuarioDESC 
												from HEDocumentosCP 
												where Ecodigo =  #Session.Ecodigo# 
													and CPTcodigo in ( select CPTcodigo 
																	 from CPTransacciones 
																	 where CPTtipo = '#url.tipo#' and coalesce(CPTpago, 0) != 1
																   ) 
													and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
													and EDrecurrente = 1
												order by EDusuario asc 
											</cfquery>
											<select name="Usuario">
												<cfoutput query="rsUsuarios"> 
													<option value="#rsUsuarios.EDusuario#" <cfif isdefined("url.Usuario") and  rsUsuarios.EDusuario EQ Usuario>selected</cfif>>#rsUsuarios.EDusuarioDESC#</option>
												</cfoutput>
											</select>
										</td>										
										<td class="tituloListas">
											<cf_monto decimales="0" size="3" maxlength="3" name="Registros" value="#url.Registros#">
										</td>										
										<td  class="tituloListas"> 
											<cf_botones values="Filtrar,Limpiar">
											<input type="hidden" name="tipo" value="<cfoutput>#url.tipo#</cfoutput>"> 
											
										</td>
									</tr>
								</table>
							</form>
						</td>
					  </tr>
					  <tr> 
						<td>
						<cf_dbfunction name="date_part"	args="yyyy, a.Dfecha" returnvariable="DfechaY">
						<cf_dbfunction name="date_part"	args="mm, a.Dfecha" returnvariable="DfechaM">
							<cfif isDefined("url.SNcodigo") and Trim(url.SNcodigo) NEQ "">
									<cfset SNcodigo= Trim(url.SNcodigo)>
									<cfset Navegacion = Navegacion & "&SNcodigo="&url.SNcodigo>
								</cfif> 
								
								 <cfif isDefined("url.EDdocumento") and trim(url.EDdocumento) NEQ "">
									<cfset EDdocumento= Trim(url.EDdocumento)> 
									<cfset Navegacion = Navegacion & "&EDdocumento="&trim(url.EDdocumento)>
								 </cfif>
								 
								 <cfif isDefined("url.TESRPTCid") and trim(url.TESRPTCid) NEQ "">
									<cfset EDdocumento= Trim(url.TESRPTCid)> 
									<cfset Navegacion = Navegacion & "&TESRPTCid="&trim(url.TESRPTCid)>
								 </cfif>
		
								<cfif isDefined("url.Periodo") and Trim(url.Periodo) NEQ "">
									<cfif Trim(url.Periodo) NEQ "0">
										<cfset filtro = filtro & " and DfechaY = " & url.Periodo>
										<cfset Periodo = Trim(url.Periodo)>
										<cfset Navegacion = Navegacion & "&Periodo="&url.Periodo>
									</cfif>
								</cfif>
								
								<cfif isDefined("url.Mes") and Trim(url.Mes) NEQ "">
									<cfif Trim(url.Mes) NEQ "0">
										<cfset filtro = filtro & " and #DfechaM# = " & url.Mes>
										<cfset Mes = Trim(url.Mes)>
										<cfset Navegacion = Navegacion & "&Mes="&url.Mes>
									</cfif>
								</cfif>
								
								<cfif isDefined("url.Fecha") and Trim(url.Fecha) NEQ "">
									<cfif Trim(url.Fecha) NEQ "Todos">
									<cf_dbfunction name="to_sdateDMY"	args="a.Dfecha" returnvariable="Dfecha">
										<cfset filtro = filtro & " and #Dfecha# = '" & Trim(url.Fecha) & "'" >
										<cfset Fecha = Trim(url.Fecha)>
										<cfset Navegacion = Navegacion & "&Fecha="&url.Fecha>
									</cfif>
								</cfif>
								
								<cfif isDefined("url.Transaccion") and len(Trim(url.Transaccion))>
									<cfif Trim(url.Transaccion) NEQ "Todos">
										<cfset filtro = filtro & " and a.CPTcodigo = '" & Trim(url.Transaccion) & "'" >
										<cfset Transaccion = Trim(url.Transaccion)>
										<cfset Navegacion = Navegacion & "&Transaccion="&url.Transaccion>
									</cfif>
								</cfif>
								
								<cfif isDefined("url.Documento") and len(Trim(url.Documento))>
									<cfset filtro = filtro & " and upper(a.Ddocumento) like '%" & Ucase(Trim(url.Documento)) & "%'" >
									<cfset Documento = Trim(url.Documento)>
									<cfset Navegacion = Navegacion & "&Documento="&url.Documento>
								</cfif>
								
								<cfif isDefined("url.Usuario") and Trim(url.Usuario) NEQ "">
									<cfif Trim(url.Usuario) NEQ "Todos">
										<cfset filtro = filtro & " and a.EDusuario = '" & Trim(url.Usuario) & "'" >
										<cfset Usuario = Trim(url.Usuario)>
										<cfset Navegacion = Navegacion & "&Usuario="&url.Usuario>
									</cfif>
								</cfif>
								
								<cfif isDefined("url.Registros") and Trim(url.Registros) NEQ "">
									<cfset Registros = url.Registros>
									<cfset Navegacion = Navegacion & "&Registros="&url.Registros>
								</cfif>
								
								<cfif isDefined("url.Moneda") and Trim(url.Moneda) NEQ "">
									<cfif Trim(url.Moneda) NEQ "Todos">
										<cfset filtro = filtro & " and a.Mcodigo = " & Trim(url.Moneda) >
										<cfset Moneda = Trim(url.Moneda)>
										<cfset Navegacion = Navegacion & "&Moneda="&url.Moneda>
									</cfif>
								</cfif>
								<cfset filtro = filtro & " and EDrecurrente = 1 ">
								<cfset filtro = filtro & " Order by Dfecha desc">

							 <cfif isdefined("url.Pagina") and url.Pagina NEQ "">
								<cfset Pagenum_lista = #url.Pagina#>
							</cfif> 
							
							<cfif isdefined("url.c")>
							<!--- <cfdump var="#url.c#"> --->
							</cfif>
							<cfset navegacion = "c=0"><!--- --->
							<cfif isdefined("url.tipo") and len(trim(url.tipo)) and url.tipo EQ 'C'> <!--- C = Facturas en CxP  --->

								<!--- Para que no se caiga si no se le pone nada. --->
								<cfif isDefined("registros")>
									<cfif len(trim(registros)) EQ 0>
										<cfset registros = 20>
									</cfif>
								</cfif>
								
								<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
									tabla="HEDocumentosCP a, SNegocios b, CPTransacciones c, Monedas m" 
									columnas="a.IDdocumento, 
											b.SNidentificacion, 
											b.SNnombre, 
											c.CPTdescripcion, 
											a.Ddocumento, 
											a.EDusuario, 
											#DfechaY# as periodo,
											#DfechaM# as mes,
											a.Dfecha,
											m.Mnombre,
											a.Dtotal, 
											'#url.tipo#' as tipo,
											'#url.EDdocumento#' as EDdocumento,
											'#url.TESRPTCid#' as TESRPTCid,
											a.SNcodigo"
									desplegar="CPTdescripcion, Ddocumento, Mnombre, periodo, mes, Dfecha, EDusuario, Dtotal"
									etiquetas="Transacción, Documento, Moneda, Periodo, Mes, Fecha, Usuario, Total"
									formatos="S,S,S,S,S,D,S,M"
									filtro= "#filtro#"
									cortes="SNnombre" 
									align="left, left, left, left, left, left, left, right"
									showlink="true"
									ira="ListaDocumentosRecurrentesCP_sql.cfm" 
									botones="Cerrar"
									keys="IDdocumento"
									MaxRows="#Registros#"
									Navegacion="#Navegacion#"/> 
							</cfif>
						</td>
					  </tr>
					  <script language="JavaScript1.2">
						/*  Funciones para el evento onclick de los botones */
						function funcCerrar(){
							window.close();
						}
						//-->
					  </script>
						<tr><td>&nbsp;</td></tr>
					</table>
		</td>	
	</tr>
</table>
</body>
</html>