<!--- 
	Modificado por: Gustavo Fonseca Hernández.
		Fecha: 27-1-2006.
		Motivo: Se le da tratamiento a los documentos de libros y bancos para que no de problemas si digitan "|" o ",".

	Modificado por: Ana Villavicencio
	Fecha: 1 de diciembre del 2005
	Motivo: Se habilitó la función de desasignar documentos conciliado automáticamente, se agregó una columna para
			indicar cual es el tipo de conciliación utilizado, se agregó una nota para indicar la nomenclatura.

	Modificado por: Ana Villavicencio
	Fecha: 23 de noviembre del 2005
	Motivo: Agregar los datos del estado de cuenta en proceso
	
	Modificación: Ana Villavicencio
	Fecha: 16 de noviembre del 2005
	Motivo: Cambiar la  navegación para incluir el nuevo paso en el proceso.
			Modificar le proceso de desasignar, antes se hacia por documento y no por grupo.
	
	Modificado por: Ana Villavicencio
	Fecha: 25 de octubre del 2005
	Motivo: Se cambio la consulta de los documentos de bancos para tomar en cuenta las transacciones de bancos (tabla Transaccionesbancos).
			Se corrigió el proceso de desasignar documentos, este desasignaba todo los documentos conciliados manualmente q pertenecian al 
			mismo grupo, no por linea seleccionada.

	Modificado por: Ana Villavicencio
	Fecha: 07 de octubre de l2005
	Motivo:  modificar el diseño de la forma, se cambio el estilo de los radio para q fuera del color del fondo
 --->
 
<!----
		Modificado por Hector Garcia Beita
		Motivo: validador para la redirección en caso de ser invocada desde la 
		opcion de conciliacion bancaria de el modulo de tarjetas de
		credito empresariales mediante un include
--->
<cfset LvarIrAFrameConfig="frame-config.cfm">
<cfset LvarIrAConciliacion="/cfmx/sif/mb/operacion/Conciliacion.cfm">
<cfset LvarIrAConciLibre="Conciliacion-Libre.cfm">
<cfset LvarIrAresumConci="resumenConciliacion.cfm">
<cfset LvarIrAlistaPreConci="listaPreConciliacion.cfm">
<cfset LvarIrAFrameProgre="frame-Progreso.cfm">
<cfset LvarCBesTCE=0><!---Filtro para los querys TCE o CuentasBancarias--->
<cfif isdefined("LvarTCEListaPreCon")>
	<cfset LvarIrAFrameConfig="../../tce/operaciones/TCEframe-config.cfm">
	<cfset LvarIrAConciliacion="/cfmx/sif/tce/operacion/TCEConciliacion.cfm">
	<cfset LvarIrAConciLibre="TCEConciliacion-Libre.cfm">
	<cfset LvarIrAresumConci="TCEresumenConciliacion.cfm">
	<cfset LvarIrAlistaPreConci="TCElistaPreConciliacion.cfm">
	<cfset LvarIrAFrameProgre="../../tce/operaciones/TCEframe-Progreso.cfm">
  	<cfset LvarCBesTCE=1><!---Filtro para los querys TCE o CuentasBancarias--->
</cfif>



	
	<style type="text/css">
		input {background-color: #FAFAFA; font-family: Tahoma, sans-serif; font-size: 8pt; border:1px solid gray}
	</style>

	<cfparam name="PageNum_rsLibrosConciliados" default="1">
	<cfparam name="PageNum_rsBancosConciliados" default="1">
	<cfif isdefined("url.ECid") and url.ECid neq "">
			<cfset form.ECid = url.ECid >
	</cfif>
	<cfif not (isDefined("Form.ECid") and Form.ECid NEQ "") and not (isDefined("Form.opt") and Form.opt NEQ "")>
			
			<!---Redireccion Conciliacion.cfm o TCEConciliacion.cfm--->
			<cflocation addtoken="no" url="#LvarIrAConciliacion#">
	</cfif>
	<cfif isDefined("Form.opt") and Form.opt NEQ "">
		<cfset Form.ECid = Form.opt>
	</cfif>
	<cfquery name="rsDatosEC" datasource="#session.DSN#">
		select ec.ECid,
			ec.ECdescripcion,
			b.Bdescripcion, 
			cb.CBdescripcion, 
			ec.Bid,
			coalesce(ec.ECdesde, <cf_dbfunction name="now"> ) as ECdesde,
			coalesce(ec.EChasta, <cf_dbfunction name="now"> ) as EChasta	
		from ECuentaBancaria ec
		inner join CuentasBancos cb
		   on cb.CBid = ec.CBid
		  and cb.Bid = ec.Bid
		  and cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		inner join Bancos b
		   on b.Bid = cb.Bid
		  and b.Ecodigo = cb.Ecodigo
		where ec.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
        	and cb.CBesTCE = #LvarCBesTCE#
	</cfquery>
	<cfif isDefined("Form.Desasignar")  and ((isDefined("Form.chkLibrosConc") and Form.chkLibrosConc NEQ "")
										or (isDefined("Form.chkBancosConc") and Form.chkBancosConc NEQ ""))>
		<cfset Lvar_sumaDCL = 0>
		<cfset Lvar_sumaDCB = 0>
		<cfif isdefined('form.chkLibrosConc')>
			<cfset chequeados = ListToArray(Form.chkLibrosConc,",")>
			<cfset cuantos = ArrayLen(chequeados)>
			<cfset listaLibros = ''>
			<cfloop index="CountVar" from="1" to="#cuantos#">
				<cfset valores = ListToArray(chequeados[CountVar],"|")>
				<cfset listaLibros = ListAppend(listaLibros,Trim(valores[8]))>
			</cfloop>
			<cfquery name="rsMontoL" datasource="#session.DSN#">
				select round(coalesce((sum(case CDLtipomov when 'D' then CDLmonto else 0 end) - sum(case CDLtipomov when 'C' then CDLmonto else 0 end)),0.00),2) as sumaDCL
				from CDLibros
				where  ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(valores[1])#">
				  and MLid in (#listaLibros#)
			</cfquery>
			<cfset Lvar_sumaDCL = rsMontoL.sumaDCL>
		</cfif>
		<cfif isdefined('form.chkBancosConc')>
			<cfset chequeados1 = ListToArray(Form.chkBancosConc,",")>
			<cfset cuantos1 = ArrayLen(chequeados1)>
			<cfset listaBancos = ''>
			<cfloop index="CountVar" from="1" to="#cuantos1#">
				<cfset valores1 = ListToArray(chequeados1[CountVar],"|")>
				<cfset listaBancos = ListAppend(listaBancos,Trim(valores1[8]))>
			</cfloop>
			<cfquery name="rsMontoB" datasource="#session.DSN#">
				select coalesce((sum(case CDBtipomov when 'D' then CDBmonto else 0 end) -
				sum(case CDBtipomov when 'C' then CDBmonto else 0 end)),0.00) as sumaDCB
				from CDBancos
				where  ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(valores1[1])#">
				  and CDBlinea in (#listaBancos#)
			</cfquery>
			<cfset Lvar_sumaDCB = rsMontoB.sumaDCB>
		</cfif>		
		
		<!--- VALIDACION DE IGUALDAD ENTRE SUMA DE DEBITOS Y CREDITOS BANCOS Y SUMA DE DEBITOS Y CREDITOS LIBROS --->
		<!--- <cfif Lvar_sumaDCL NEQ Lvar_sumaDCB> --->
		<cfif ( Abs(Lvar_sumaDCL)- Abs(Lvar_sumaDCB) gt 1) OR (Abs(Lvar_sumaDCL)-Abs(Lvar_sumaDCB) lt -1 )>
		
			<script language="javascript1.2" type="text/javascript">
				alert('La suma de los Débitos-Créditos de los documentos no coinciden');
			</script>
		<cfelse><!--- MONTO DE BANCOS COINCIDE CON MONTO DE LIBROS --->
			<cfif isdefined('Form.chkLibrosConc')>
				<cfset valor = ListToArray(Form.chkLibrosConc)>
				<cfloop from="1" to="#ArrayLen(valor)#" index="i">
					<cfset valorlibros = ListToArray(valor[i],"|")>	
					<!--- DESASIGNA LOS LIBROS --->
					<cfquery name="updDesasignarLibros" datasource="#Session.DSN#">
						update CDLibros 
						set CDLconciliado = 'N', 
							CDLgrupo 	  = null 
						where CDLgrupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#valorlibros[2]#">
						 and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
						 and MLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(valorlibros[8])#">
					</cfquery>
				</cfloop>
			</cfif>
			<cfif isdefined('Form.chkBancosConc')>
				<cfset valor = ListToArray(Form.chkBancosConc)>
				<cfloop from="1" to="#ArrayLen(valor)#" index="i">
					<cfset valorbancos = ListToArray(valor[i],"|")>	
					<!--- DESASIGNA LOS BANCOS --->
					<cfquery name="updDesasignarBancos" datasource="#Session.DSN#">
						update CDBancos 
						set CDBconciliado = 'N', 
							CDBgrupo 	  = null 
						where CDBgrupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#valorbancos[2]#">	
						and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
						and CDBlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(valorbancos[8])#">
					</cfquery>
				</cfloop>
			</cfif>
		</cfif>
	</cfif>

	<cfquery name="rsLibrosConciliados" datasource="#Session.DSN#">
		select CDLfecha as FechaLibros, a.*, c.BTcodigo, b.MLreferencia as referencia, a.CDLgrupo as ngrup
		from CDLibros a, MLibros b, BTransacciones c
		where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		  and a.CDLconciliado = 'S'
		  and b.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.MLid = b.MLid
		  and a.CDLidtrans = c.BTid
		   AND b.MLconciliado = 'N'
		 order by a.CDLgrupo DESC, CDLidtrans
	</cfquery>
	<cfquery name="rsBancosConciliados" datasource="#Session.DSN#">
		select CDBfechabanco as FechaBancos, a.*, c.DCReferencia as referencia, a.CDBgrupo as ngrup
		from CDBancos a
		inner join TransaccionesBanco b
		on b.Bid = a.Bid
		and b.BTEcodigo = a.BTEcodigo
		
		left join DCuentaBancaria c
		on c.Linea = a.CDBlinref
		
		where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		and a.CDBconciliado = 'S'
		 and a.BTid is null
		order by a.CDBgrupo DESC, a.BTEcodigo			
	</cfquery>
	
	<cfset cont1 = 0>
	<cfset cont2 = 0>
	<cfset tiraLibros = "">
	<cfset tiraBancos = "">
	
	<cfloop query="rsLibrosConciliados" startrow="1" endrow="#rsLibrosConciliados.RecordCount#">
		<cfset tiraLibros = tiraLibros & "#Replace(Replace(rsLibrosConciliados.ECid, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsLibrosConciliados.CDLgrupo, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsLibrosConciliados.CDLdocumento, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(LSDateFormat(rsLibrosConciliados.FechaLibros, 'dd/mm/yyyy'), "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsLibrosConciliados.CDLtipomov, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsLibrosConciliados.CDLmonto, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsLibrosConciliados.BTcodigo, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsLibrosConciliados.MLid, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsLibrosConciliados.CDLmanual, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsLibrosConciliados.referencia, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsLibrosConciliados.ngrup, "|", "1", "All"), ",", " ", "All")#" & ",">
		<cfset cont1 = cont1 + 1>		
	</cfloop>
<!---	<cf_dump var="#rsBancosConciliados#">--->
	<cfloop query="rsBancosConciliados" startrow="1" endrow="#rsBancosConciliados.RecordCount#">
		<cfset tiraBancos = tiraBancos & "#Replace(Replace(rsBancosConciliados.ECid, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsBancosConciliados.CDBgrupo, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsBancosConciliados.CDBdocumento, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(LSDateFormat(rsBancosConciliados.FechaBancos, 'dd/mm/yyyy'), "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsBancosConciliados.CDBtipomov, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsBancosConciliados.CDBmonto, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsBancosConciliados.BTEcodigo, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsBancosConciliados.CDBlinea, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsBancosConciliados.CDBmanual, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsBancosConciliados.referencia, "|", "1", "All"), ",", " ", "All")#|#Replace(Replace(rsBancosConciliados.ngrup, "|", "1", "All"), ",", " ", "All")#" & ",">
		<cfset cont2 = cont2 + 1>
	</cfloop>
	
	<cfset myArrayLibros = ArrayNew(1)>
	<cfset myArrayLibros = "">
	<cfset myArrayBancos = ArrayNew(1)>
	<cfset myArrayBancos = "">
		
	<cfset myArrayLibros = ListtoArray(tiraLibros, ',')>
	<cfset myArrayBancos = ListtoArray(tiraBancos, ',')>
	<cfset MaxRows_rsLibrosConciliados=16><cfset StartRow_rsLibrosConciliados=Min((PageNum_rsLibrosConciliados-1)*MaxRows_rsLibrosConciliados+1,Max(rsLibrosConciliados.RecordCount,1))><cfset EndRow_rsLibrosConciliados=Min(StartRow_rsLibrosConciliados+MaxRows_rsLibrosConciliados-1,rsLibrosConciliados.RecordCount)><cfset TotalPages_rsLibrosConciliados=Ceiling(rsLibrosConciliados.RecordCount/MaxRows_rsLibrosConciliados)><cfset MaxRows_rsBancosConciliados=16><cfset StartRow_rsBancosConciliados=Min((PageNum_rsBancosConciliados-1)*MaxRows_rsBancosConciliados+1,Max(rsBancosConciliados.RecordCount,1))><cfset EndRow_rsBancosConciliados=Min(StartRow_rsBancosConciliados+MaxRows_rsBancosConciliados-1,rsBancosConciliados.RecordCount)><cfset TotalPages_rsBancosConciliados=Ceiling(rsBancosConciliados.RecordCount/MaxRows_rsBancosConciliados)>
<cf_templateheader title="Preconciliación">
	<!---Redireccion frame-config.cfm o TCEframe-config.cfm--->
	<cfinclude template="#LvarIrAFrameConfig#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=''>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td width="85%" valign="top">
				<!--- <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Preconciliaci&oacute;n Bancaria'> --->
					<cfinclude template="../../portlets/pNavegacion.cfm">
					<form name="frmGO" action="" method="post" style="margin: 0; ">
						<input type="hidden" name="ECid" value="<cfif isdefined("Form.ECid")><cfoutput>#Form.ECid#</cfoutput></cfif>">
						<input type="hidden" name="anterior" value="1">
						<input type="hidden" name="siguiente" value="1">
					</form>
					
					<form action="" method="post" name="form1">
					  <input type="hidden" name="ECid" value="<cfif isDefined("Form.ECid") and Form.ECid NEQ ""><cfoutput>#Form.ECid#</cfoutput></cfif>">
					  
					<table width="100%" border="0" cellpadding="1" cellspacing="0">
						<tr>
							<td>
								<table width="100%" border="0">
									<tr><td colspan="2">&nbsp;</td></tr>
									<tr>
										<td align="right" nowrap><span style="font-size:10px"><strong>Cuenta:</strong></span></td>
										<td nowrap>
											<span style="font-size:10px">
												<cfif isDefined("Form.ECid")>
													<cfoutput>#rsDatosEC.Bdescripcion# - #rsDatosEC.CBdescripcion#</cfoutput>
												<cfelse>
													<cfoutput>#rsDatosEC.getField(1,3)# - #v.getField(1,4)#</cfoutput>
												</cfif>
											</span>
										</td>
									</tr>
									<tr> 
										<td align="right" nowrap>&nbsp;</td>
										<td nowrap>
											<span style="font-size:10px"><cfoutput>#rsDatosEC.ECdescripcion#</cfoutput></span>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td bgcolor="#A0BAD3">
								<table width="100%"  border="0">
								  <tr>
									<td align="left">
										<input type="submit" name="Desasignar" value="Desasignar" 
										onClick="javascript: return validaChecks();">
									</td>
									<td align="right">
										<input type="button" name="Anterior" value="<< Anterior" onClick="javascript: funcRegresar();">
										<input type="button" name="Siguiente" value="Siguiente >>" onClick="javascript: funcSiguiente();">
									</td>
								  </tr>
								</table>
							</td>
						</tr>
					</table>
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr>
							<td align="center" valign="top" class="tituloListas">Movimientos de Libros</td>
							<td class="tituloListas"> <div align="center">Movimientos de Bancos</div></td>
						</tr>
						<tr> 
							<td width="48%" align="center" valign="top">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr  class="subTitulo">
										<td>
											<input name="chkTodosLibros" type="checkbox" value="" border="1" 
													onClick="javascript:MarcarLibros(this);"
													style=" border:0; background:background-color"
													id="chkTodosLibros">
										</td>
										<td colspan="5" align="left"><label for="chkTodosLibros"><strong>Todos</strong></label></td>
									</tr>
									<tr class="subTitulo" bgcolor="#E2E2E2">
										<td>&nbsp;</td>
										<td><strong>No. Agrupaci&oacute;n</strong></td>
										<td><strong>Transacci&oacute;n</strong></td>										
										<td><strong>Documento</strong></td>
										<td><strong>Fecha</strong></td>
										<td><div align="right"><strong>D&eacute;bitos</strong></div></td>
										<td><div align="right"><strong>Cr&eacute;ditos</strong></div></td>
										<td><div align="right"><strong>&nbsp;Tipo</strong></div></td>
										<td>&nbsp;</td>
									</tr>
									<cfoutput>
										<cfset cuantosRegLibros = "#ArrayLen(myArrayLibros)#">
										<cfset cuantosManualesLibros = 0>
										<cfset CountVar = 1>
										<cfloop condition = "CountVar LESS THAN OR EQUAL TO #cuantosRegLibros#">
											<!--- Replace(Replace(myArrayLibros, "|", "/", "All"), ",", " ", "All") --->

											<cfset valores = listtoArray(myArrayLibros[CountVar],"|")>
											<cfset lvari = ''>
											<cfif arraylen(valores) gte 10>
												<cfset lvari = valores[10]>
											</cfif>
											
											<tr <cfif CountVar MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
												<!--- <cfif valores[9] NEQ 'N'> --->
												<td title="Referencia: #lvari#">
													<input type='checkbox' name='chkLibrosConc' value='#myArrayLibros[CountVar]#' 
													onClick="javascript:document.form1.chkTodosLibros.checked = false;"
													style=" border:0; background:background-color">
													<cfset cuantosManualesLibros = cuantosManualesLibros + 1>
													<!--- </cfif> --->
												</td>
												<td>#valores[11]#</td>
												<td title="Referencia: #lvari#">#valores[7]#</td>
												<td title="Referencia: #lvari#">#valores[3]#</td>
												<td title="Referencia: #lvari#">
													<cfif Len(Trim(valores[4]))>
														<!---#LSDateFormat(valores[4],'DD/MM/YYYY')#--->
														#valores[4]#
													<cfelse>
														&nbsp;
													</cfif>
												</td>
												<td title="Referencia: #lvari#">
													<cfif valores[5] EQ 'D'>
														<div align="right">
															<cfif Len(Trim(valores[6]))>
																#LSCurrencyFormat(valores[6],"none")#
															<cfelse>
																&nbsp;
															</cfif>
														</div>
													</cfif>
												</td>
												<td title="Referencia: #lvari#">
													<cfif valores[5] EQ 'C'>
														<div align="right">
															<cfif Len(Trim(valores[6]))>
																#LSCurrencyFormat(valores[6],"none")#
															<cfelse>
																&nbsp;
															</cfif>
														</div>
													</cfif>
												</td>
												<td title="Referencia: #lvari#" align="center"><cfif valores[9] EQ 'N'>A<cfelse>M</cfif></td>
												<td>&nbsp;</td>
											</tr>
											<cfset CountVar = CountVar + 1>
										</cfloop>
									</cfoutput>
								</table>
							</td>
							<td width="51%" valign="top"> 
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr  class="subTitulo"> 
										<td>
											<input name="chkTodosBancos" type="checkbox" value="" border="1" 
											onClick="javascript:MarcarBancos(this);"
											style=" border:0; background:background-color"
											id="chkTodosBancos">
										</td>
										<td colspan="4"><div align="left"><label for="chkTodosBancos"><strong>Todos</strong></label></div></td>
									</tr>
									<tr class="subTitulo" bgcolor="#E2E2E2"> 
										<td>&nbsp;</td>
										<td><strong>No. Agrupaci&oacute;n</strong></td>
										<td><strong>Transacci&oacute;n</strong></td>
										<td><strong>Documento</strong></td>
										<td><strong>Fecha</strong></td>
										<td><div align="right"><strong>D&eacute;bitos</strong></div></td>
										<td><div align="right"><strong>Cr&eacute;ditos</strong></div></td>
										<td><div align="center"><strong>&nbsp;Tipo</strong></div></td>
									</tr>
									<cfoutput> 
										<cfset cuantosRegBancos = "#ArrayLen(myArrayBancos)#">
										<cfset cuantosManualesBancos = 0>
										<cfset CountVar = 1>
                                        
										<cfloop condition = "CountVar LESS THAN OR EQUAL TO #cuantosRegBancos#">
											<cfset valores = listtoArray(myArrayBancos[CountVar],"|")>
<!---                                            <cf_dump var="#cuantosRegBancos# #ArrayLen(valores)# " >--->
											<tr <cfif CountVar MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
												<td title="Referencia: #lvari#" ><!--- <cfif valores[9] NEQ 'N'> --->
													<input type='checkbox' name='chkBancosConc' value='#myArrayBancos[CountVar]#' 
													onClick="javascript:document.form1.chkTodosBancos.checked = false;"
													style=" border:0; background:background-color">
													<cfset cuantosManualesBancos = cuantosManualesBancos + 1>
													<!--- </cfif> --->
												</td>
												<td>#valores[10]#</td>

												<td title="Referencia: #lvari#">#valores[7]#</td>
												<td title="Referencia: #lvari#" >#valores[3]#</td>
												<td title="Referencia: #lvari#"><cfif Len(Trim(valores[4]))>#LSDateFormat(valores[4],'DD/MM/YYYY')#<cfelse>&nbsp;</cfif></td>
												<td title="Referencia: #lvari#" align="right">
													<cfif valores[5] EQ 'D'>
														<cfif Len(Trim(valores[6]))>
															#LSCurrencyFormat(valores[6],"none")#
														<cfelse>
															&nbsp;
														</cfif>
													</cfif>
												</td>
												<td title="Referencia: #lvari#" align="right">
													<cfif valores[5] EQ 'C'>
														<cfif Len(Trim(valores[6]))>
															#LSCurrencyFormat(valores[6],"none")#
														<cfelse>
															&nbsp;
														</cfif>
													</cfif>
												</td>
												<td title="Referencia: #lvari#" align="center"><cfif valores[9] EQ 'N'>A<cfelse>M</cfif></td>
											</tr>
											<cfset CountVar = CountVar + 1>
										</cfloop>
									</cfoutput>
								</table>
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
					</table>
					<table width="100%" border="0" cellpadding="1" cellspacing="0">
						<tr>
							<td bgcolor="#A0BAD3">
								<table width="100%"  border="0">
								  <tr>
									<td align="left">
										<input type="submit" name="Desasignar" value="Desasignar" 
										onClick="javascript: return validaChecks();">
									</td>
									<td align="right">
										<input type="button" name="Anterior" value="<< Anterior" onClick="javascript: funcRegresar();">
										<input type="button" name="Siguiente" value="Siguiente >>" onClick="javascript: funcSiguiente();">
									</td>
								  </tr>
								</table>
							</td>
						</tr>
					</table>
					<br>
					</form>	
					<script language="JavaScript" type="text/javascript">
					
						function funcRegresar() {
							<!---Redireccion Conciliacion-Libre.cfm o TCEConciliacion-Libre.cfm (TCE)--->
							document.frmGO.action='<cfoutput>#LvarIrAConciLibre#</cfoutput>';
							document.frmGO.submit();
						}
					
						function funcSiguiente() {
 							<!---Redireccion resumenConciliacion.cfm o resumenConciliacion.cfm (TCE)--->
 							document.frmGO.action='<cfoutput>#LvarIrAresumConci#</cfoutput>';
							document.frmGO.submit();
						}
					
					
						function validaChecks() {		
							if (validaChecksLibros() || validaChecksBancos()) {
								if (confirm("¿Desea eliminar los documentos seleccionados de esta Preconciliación?")) 
								{
									<!---Redireccion listaPreConciliacion.cfm o TCElistaPreConciliacion.cfm(TCE)--->
									document.form1.action='<cfoutput>#LvarIrAlistaPreConci#</cfoutput>';
									return true;
								}
								else
									return false;
							}
							else {
								alert('Debe seleccioar al menos un documento.');
								return false;
							}
								
						}
					
						function validaChecksLibros() {
							<cfif cuantosManualesLibros NEQ 0> 
								<cfif cuantosManualesLibros EQ 1>
									if (document.form1.chkLibrosConc.checked)					
										return true;
								<cfelse>
									var bandera = false;
									var i;
									for (i = 0; i < document.form1.chkLibrosConc.length; i++) {
										if (document.form1.chkLibrosConc[i].checked) bandera = true;						
									}
									if (bandera)
										return true;
								</cfif>	 			
							<cfelse>
								alert("¡No existen documentos de Libros!");							
							</cfif>
							return false;
						}
					
						function validaChecksBancos() {
							<cfif cuantosManualesBancos NEQ 0> 
								<cfif cuantosManualesBancos EQ 1>
									if (document.form1.chkBancosConc.checked)					
										return true;
								<cfelse>
									var bandera = false;
									var i;
									for (i = 0; i < document.form1.chkBancosConc.length; i++) {
										if (document.form1.chkBancosConc[i].checked) bandera = true;						
									}
									if (bandera)
										return true;
								</cfif>	 			
							<cfelse>
								alert("¡No existen documentos de Bancos!");							
							</cfif>
							return false;
						}
					
						function MarcarLibros(c) {
							<cfif cuantosManualesLibros GT 0>
							if (c.checked) {
								for (counter = 0; counter < document.form1.chkLibrosConc.length; counter++)
								{
									if ((!document.form1.chkLibrosConc[counter].checked) && (!document.form1.chkLibrosConc[counter].disabled))
										{  document.form1.chkLibrosConc[counter].checked = true;}
								}
								if ((counter==0)  && (!document.form1.chkLibrosConc.disabled)) {
									document.form1.chkLibrosConc.checked = true;
								}
							}
							else {
								for (var counter = 0; counter < document.form1.chkLibrosConc.length; counter++)
								{
									if ((document.form1.chkLibrosConc[counter].checked) && (!document.form1.chkLibrosConc[counter].disabled))
										{  document.form1.chkLibrosConc[counter].checked = false;}
								};
								if ((counter==0) && (!document.form1.chkLibrosConc.disabled)) {
									document.form1.chkLibrosConc.checked = false;
								}
							};
							</cfif>
						}
					
						function MarcarBancos(c) {
							<cfif cuantosManualesBancos GT 0>
							if (c.checked) {
								for (counter = 0; counter < document.form1.chkBancosConc.length; counter++)
								{
									if ((!document.form1.chkBancosConc[counter].checked) && (!document.form1.chkBancosConc[counter].disabled))
										{  document.form1.chkBancosConc[counter].checked = true;}
								}
								if ((counter==0)  && (!document.form1.chkBancosConc.disabled)) {
									document.form1.chkBancosConc.checked = true;
								}
							}
							else {
								for (var counter = 0; counter < document.form1.chkBancosConc.length; counter++)
								{
									if ((document.form1.chkBancosConc[counter].checked) && (!document.form1.chkBancosConc[counter].disabled))
										{  document.form1.chkBancosConc[counter].checked = false;}
								};
								if ((counter==0) && (!document.form1.chkBancosConc.disabled)) {
									document.form1.chkBancosConc.checked = false;
								}
							};
							</cfif>
						}
					
					</script>		
				<!--- <cf_web_portlet_end> --->
			</td>
			<td width="15%" valign="top">
				<!---Redireccion frame-Progreso.cfm o TCEframe-Progreso.cfm(TCE)--->
				<cfinclude template="#LvarIrAFrameProgre#">
				<br>
				<div class="ayuda">
					<strong>Pasos para Realizar la Operación:</strong><br><br>
					1) Si desea conciliar todos estos documentos presione el bot&oacute;n de <font color="#003399"><strong>Siguiente >></strong></font>.<br><br>
					2) Si no desea conciliar uno o varios estos documentos, selecci&oacute;nelos y presione el bot&oacute;n de <font color="#003399"><strong>Desasignar</strong></font>.<br>
					<br>
					3) Si desea volver a la pantalla anterior presione el bot&oacute;n de <font color="#003399"><strong><< Anterior</strong></font>.
					<br>
					<br>
					<font color="#003399"><strong>Nota:</strong></font> La columna <strong>Tipo</strong> para los documentos conciliados indica 
					<br><strong>&nbsp;&nbsp;A</strong> = Conciliaci&oacute; Autom&aacute;tica 
					<br><strong>&nbsp;&nbsp;M</strong> = Conciliaci&oacute;n Manual
					<br>&nbsp;
				</div>
			</td>
		</tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>