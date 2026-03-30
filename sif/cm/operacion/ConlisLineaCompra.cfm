<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<style>
	.LetraDetalle{
		font-size:10px;
		font-weight:bold;
	}
</style>
<!--- ******************************** --->
<!-----  Se guarda en una variable el número de pagina (de la lista) ----->	
	<cfset pagina = 1 >
	<cfif isdefined("form.pagenum")>
		<cfset pagina = form.pagenum >
	<cfelseif isdefined("url.pagenum_lista")>
		<cfset pagina = url.pagenum_lista >
	</cfif>
<!--- Se le suma una para el caso que se de clic al boton de agregar y continuar ---->
	<cfset pagina = pagina + 1>
<!--- ******************************** --->

<cfif isdefined("url.EDRid") and not isdefined("form.EDRid")>
	<cfset form.EDRid = url.EDRid >
</cfif>
<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo >
</cfif>
<cfif isdefined("url.Devoluciones") and not isdefined("Form.Devoluciones")>
	<cfset Form.Devoluciones = url.Devoluciones>
</cfif>
<cfif isdefined("url.McodigoE") and not isdefined("Form.McodigoE")>
	<cfset Form.McodigoE = url.McodigoE>
</cfif>
<cfif isdefined("url.TC_E") and not isdefined("Form.TC_E")>
	<cfset Form.TC_E = url.TC_E>
</cfif>
<cfif isdefined("url.DOobservaciones") and not isdefined("Form.DOobservaciones")>
	<cfset Form.DOobservaciones = url.DOobservaciones>
</cfif>
<cfif isdefined("url.DOalterna") and not isdefined("Form.DOalterna")>
	<cfset Form.DOalterna = url.DOalterna>
</cfif>
<cfif isdefined("url.DOdescripcion") and not isdefined("Form.DOdescripcion")>
	<cfset Form.DOdescripcion = url.DOdescripcion>
</cfif>
<cfif isdefined("url.Acodigo") and not isdefined("Form.Acodigo")>
	<cfset Form.Acodigo = url.Acodigo>
</cfif>
<cfif isdefined("url.Ccodigo") and not isdefined("Form.Ccodigo")>
	<cfset Form.Ccodigo = url.Ccodigo>
</cfif>

<cfif isdefined('form.btnAgregar') and form.btnAgregar NEQ '' or (isdefined("form.btnAgregar_y_continuar"))>
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
		Select Mcodigo
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	
	
	<cfset actEncab = 0>
	<cfset actEncab_B = 0>	
	<cfset costounitario = 0.00>
	
	<cfloop collection="#Form#" item="i">
					
		<!--- Insercion de las lineas de compra --->
		<cfif FindNoCase("chkHijo_", i) NEQ 0 and Form[i] NEQ 0>
			<cfset MM_columns = ListToArray(form[i],",")>
			
			<cfif isdefined('MM_columns') and ArrayLen(MM_columns) GT 0>				
				<cfset j = ArrayLen(MM_columns)>
				<cfloop index = "k" from = "1" to = #j#>
					<cfquery name="verifpoliza" datasource="#session.DSN#" maxrows="1">
						select #LvarOBJ_PrecioU.enSQL_AS("DPDvalordeclarado / DPDcantidad", "ValorUnitario")#
						from DPolizaDesalmacenaje 
						where DOlinea = <cfqueryparam value="#MM_columns[k]#" cfsqltype="cf_sql_numeric">
						  and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					</cfquery>
		
					<cfif verifpoliza.recordcount GT 0 and verifpoliza.ValorUnitario GT 0.0000>
						<cfset costounitario = LvarOBJ_PrecioU.enCF(verifpoliza.ValorUnitario)>
					<cfelse>
						<cfquery name="verifPreciou" datasource="#session.DSN#" maxrows="1">
							select #LvarOBJ_PrecioU.enSQL_AS("coalesce(DOpreciou,0)", "ValorUnitario")#
							from DOrdenCM
							where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							  and DOlinea = <cfqueryparam value="#MM_columns[k]#" cfsqltype="cf_sql_numeric">
						</cfquery>
						<cfif isdefined('verifPreciou') and verifPreciou.recordCount GT 0>
							<cfset costounitario = LvarOBJ_PrecioU.enCF(verifPreciou.ValorUnitario)>
						</cfif>
					</cfif>
					
					<cfquery name="cantidadSurtida" datasource="#session.DSN#">
						<cfif isdefined("Form.Devoluciones") and Len(Trim(Form.Devoluciones)) NEQ 0>
							select do.DOcantsurtida
							from DOrdenCM do
							where do.DOlinea = <cfqueryparam value="#MM_columns[k]#" cfsqltype="cf_sql_numeric">
								and do.Ecodigo = <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">
						<cfelse>
							select (do.DOcantsurtida +
								coalesce(
									(select sum(ddr.DDRcantordenconv)
									from DDocumentosRecepcion ddr
										inner join EDocumentosRecepcion edr
											on edr.EDRid = ddr.EDRid
											and edr.Ecodigo = ddr.Ecodigo
										inner join TipoDocumentoR tdr
											on tdr.TDRcodigo = edr.TDRcodigo
											and tdr.Ecodigo = edr.Ecodigo
											and tdr.TDRtipo = 'R'
									where ddr.DOlinea = do.DOlinea
										and ddr.Ecodigo = do.Ecodigo
										and edr.EDRestado = 0),
									0)) as DOcantsurtida
							from DOrdenCM do
							where do.DOlinea = <cfqueryparam value="#MM_columns[k]#" cfsqltype="cf_sql_numeric">
								and do.Ecodigo = <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">
						</cfif>
					</cfquery>

					<!--- inserta detalles de la orden de compra seleccionada 	--->
					<cfquery name="insertd" datasource="#session.DSN#">
						insert into DDocumentosRecepcion(
								Ecodigo, EDRid, DOlinea, Usucodigo, 
								fechaalta, DDRtipoitem, Aid, Cid, 
								DDRcantrec, DDRcantorigen, DDRcantreclamo, DDRcantordenconv,
								DDRpreciou, DDRprecioorig, DDRdesclinea, DDRdescporclin,
								DDRtotallin, DDRtotallincd, DDRcostopro, DDRcostototal, DDRgenreclamo, Ucodigo, Icodigo,
								DDRmtoimpfact, DDRimptoporclin)					
						select 	#session.Ecodigo#, 
								<cf_jdbcquery_param value="#form.EDRid#" cfsqltype="cf_sql_numeric">, 
								do.DOlinea, 
								#session.Usucodigo#, 
								<cf_dbfunction name="now">,
								do.CMtipo, 
								do.Aid, 
								do.Cid,
								(do.DOcantidad-#cantidadSurtida.DOcantsurtida#), 
								(do.DOcantidad-#cantidadSurtida.DOcantsurtida#),								
								0,				
								(do.DOcantidad-#cantidadSurtida.DOcantsurtida#),							
								<cfparam name="form.McodigoE" 	type="numeric">
								<cfparam name="form.TC_E" 		type="numeric">
								<cfsavecontent variable="LvarCASE">
									case 
										when eo.Mcodigo <> #form.McodigoE#
											then(
													<cfif isdefined('rsEmpresa') and rsEmpresa.recordCount GT 0 and rsEmpresa.Mcodigo NEQ ''>
														case 
															when eo.Mcodigo <> #rsEmpresa.Mcodigo# then
																#costounitario# * #form.TC_E#
															else 
																#costounitario# / #form.TC_E#
														end
													<cfelse>
														#costounitario# * #form.TC_E#
													</cfif>	
												)
										else #costounitario#
									end 
								</cfsavecontent>
								#LvarOBJ_PrecioU.enSQL_AS(LvarCASE, "costoUnit")#,		<!--- (" para brincarme la verificación automática")# --->
								<cfsavecontent variable="LvarCASE">
									<cfif costounitario NEQ 0.00>								
										case 
											when eo.Mcodigo <> #form.McodigoE#
												then(
														<cfif isdefined('rsEmpresa') and rsEmpresa.recordCount GT 0 and rsEmpresa.Mcodigo NEQ ''>
															case 
																when eo.Mcodigo <> #rsEmpresa.Mcodigo# then
																	#costounitario# * #form.TC_E#
																else 
																	#costounitario# / #form.TC_E#
															end
														<cfelse>	
															#costounitario# * #form.TC_E#
														</cfif>	
													)
											else #costounitario#
										end
									<cfelse>
										case 
											when eo.Mcodigo <> #form.McodigoE#
												then(
														<cfif isdefined('rsEmpresa') and rsEmpresa.recordCount GT 0 and rsEmpresa.Mcodigo NEQ ''>
															case 
																when eo.Mcodigo <> #rsEmpresa.Mcodigo# then
																	do.DOpreciou * #form.TC_E#
																else 
																	do.DOpreciou / #form.TC_E#
															end												
														<cfelse>	
															do.DOpreciou * #form.TC_E#
														</cfif>
													)
											else do.DOpreciou
										end
									</cfif>
								</cfsavecontent>
								#LvarOBJ_PrecioU.enSQL_AS(LvarCASE, "DOpreciou")#,		<!--- (" para brincarme la verificación automática")# --->
								case 
									when eo.Mcodigo <> #form.McodigoE#
										then(
												<cfif isdefined('rsEmpresa') and rsEmpresa.recordCount GT 0 and rsEmpresa.Mcodigo NEQ ''>
													case 
														when eo.Mcodigo <> #rsEmpresa.Mcodigo# then
															((do.DOcantidad - #cantidadSurtida.DOcantsurtida#) * do.DOpreciou * (do.DOporcdesc / 100)) * #form.TC_E#
														else 
															((do.DOcantidad - #cantidadSurtida.DOcantsurtida#) * do.DOpreciou * (do.DOporcdesc / 100)) / #form.TC_E#
													end
												<cfelse>
													((do.DOcantidad - #cantidadSurtida.DOcantsurtida#) * do.DOpreciou * (do.DOporcdesc / 100)) * #form.TC_E#
												</cfif>
											)
									else ((do.DOcantidad - #cantidadSurtida.DOcantsurtida#) * do.DOpreciou * (do.DOporcdesc / 100))
								end DOmontoD,
								DOporcdesc,
								round(
								(do.DOcantidad - #cantidadSurtida.DOcantsurtida#) * 
								<cfif costounitario NEQ 0.00>
									case 
										when eo.Mcodigo <> #form.McodigoE#
											then(
													<cfif isdefined('rsEmpresa') and rsEmpresa.recordCount GT 0 and rsEmpresa.Mcodigo NEQ ''>
														case 
															when eo.Mcodigo <> #rsEmpresa.Mcodigo# then
																#costounitario# * #form.TC_E#
															else 
																#costounitario# / #form.TC_E#
														end
													<cfelse>
														#costounitario# * #form.TC_E#
													</cfif>
												)
										else #costounitario#
									end
								<cfelse>
									case 
										when eo.Mcodigo <> #form.McodigoE#
											then(
													<cfif isdefined('rsEmpresa') and rsEmpresa.recordCount GT 0 and rsEmpresa.Mcodigo NEQ ''>
														case 
															when eo.Mcodigo <> #rsEmpresa.Mcodigo# then
																do.DOpreciou * #form.TC_E#
															else 
																do.DOpreciou / #form.TC_E#
														end
													<cfelse>
														do.DOpreciou * #form.TC_E#
													</cfif>
												)
                                        else do.DOpreciou
									end								
								</cfif>,2)
								, 
								round(
									((do.DOcantidad - #cantidadSurtida.DOcantsurtida#) * 
										<cfif costounitario NEQ 0.00>
											case 
												when eo.Mcodigo <> #form.McodigoE#
													then(
															<cfif isdefined('rsEmpresa') and rsEmpresa.recordCount GT 0 and rsEmpresa.Mcodigo NEQ ''>
																case 
																	when eo.Mcodigo <> #rsEmpresa.Mcodigo# then
																		#costounitario# * #form.TC_E#
																	else 
																		#costounitario# / #form.TC_E#
																end
															<cfelse>
																#costounitario# * #form.TC_E#
															</cfif>
														)
												else #costounitario#
											end
										<cfelse>
											case 
												when eo.Mcodigo <> #form.McodigoE#
													then(
															<cfif isdefined('rsEmpresa') and rsEmpresa.recordCount GT 0 and rsEmpresa.Mcodigo NEQ ''>
																case 
																	when eo.Mcodigo <> #rsEmpresa.Mcodigo# then
																		do.DOpreciou * #form.TC_E#
																	else 
																		do.DOpreciou / #form.TC_E#
																end
															<cfelse>
																do.DOpreciou * #form.TC_E#
															</cfif>
														)
												else do.DOpreciou
											end							
										</cfif> - ((do.DOcantidad - #cantidadSurtida.DOcantsurtida#) * do.DOpreciou * (do.DOporcdesc / 100)))
									,2),
								0, 0, 0,
								do.Ucodigo,
								do.Icodigo ,
                                case 
                                    when eo.Mcodigo <> #form.McodigoE# then
                                         ((((round((do.DOcantidad - #cantidadSurtida.DOcantsurtida#) * 
                                            <cfif costounitario NEQ 0.00>
                                                <cfif isdefined('rsEmpresa') and rsEmpresa.recordCount GT 0 and rsEmpresa.Mcodigo NEQ ''>
                                                    case 
                                                        when eo.Mcodigo <> #rsEmpresa.Mcodigo# then
                                                            #costounitario# * #form.TC_E#
                                                        else 
                                                            #costounitario# / #form.TC_E#
                                                    end
                                                <cfelse>
                                                    #costounitario# * #form.TC_E#
                                                </cfif>	
                                            <cfelse>
                                                <cfif isdefined('rsEmpresa') and rsEmpresa.recordCount GT 0 and rsEmpresa.Mcodigo NEQ ''>
                                                    case 
                                                        when eo.Mcodigo <> #rsEmpresa.Mcodigo# then
                                                            do.DOpreciou * #form.TC_E#
                                                        else 
                                                            do.DOpreciou / #form.TC_E#
                                                    end
                                                <cfelse>
                                                    do.DOpreciou * #form.TC_E#
                                                </cfif>
                                            </cfif>,2))
                                            - ((do.DOcantidad - #cantidadSurtida.DOcantsurtida#) * do.DOpreciou * (do.DOporcdesc / 100)))*i.Iporcentaje)/100
                                         * #form.TC_E#)
                                    else 
                                        (((round((do.DOcantidad - #cantidadSurtida.DOcantsurtida#) * 
                                            <cfif costounitario NEQ 0.00>
                                                #costounitario#
                                            <cfelse>
                                                do.DOpreciou
                                            </cfif>,2))
                                        - ((do.DOcantidad - #cantidadSurtida.DOcantsurtida#) * do.DOpreciou * (do.DOporcdesc / 100)))*i.Iporcentaje)/100										
                                end DDRmtoimpfactura,
								i.Iporcentaje
						from DOrdenCM do 
							inner join EOrdenCM eo 
									inner join CMTipoOrden e
										 on e.Ecodigo         = eo.Ecodigo
										and e.CMTOcodigo      = eo.CMTOcodigo
										and e.CMTOimportacion = 0
								on eo.EOidorden = do.EOidorden 
								and eo.Ecodigo = do.Ecodigo
							inner join Impuestos i 
								 on i.Icodigo = do.Icodigo 
								and i.Ecodigo = do.Ecodigo 		
						where do.Ecodigo = <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">
						  and do.DOlinea = <cfqueryparam value="#MM_columns[k]#" cfsqltype="cf_sql_numeric">
						  and #cantidadSurtida.DOcantsurtida# < DOcantidad
						  and not exists(
								select 1
								from DDocumentosRecepcion x
									inner join EDocumentosRecepcion x2
										inner join TipoDocumentoR x3 
										 on x3.TDRcodigo = x2.TDRcodigo
										and x3.Ecodigo   = x2.Ecodigo  
										and x3.TDRtipo =
										<cfif isdefined("Form.Devoluciones") and Len(Trim(Form.Devoluciones)) NEQ 0>
											'D'
										<cfelse>
											'R'
										</cfif>										
									 on x2.EDRid   = x.EDRid 
									and x2.Ecodigo = x.Ecodigo 
									and x2.EDRestado < 10
								where x.DOlinea = do.DOlinea
								  and x.EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
								)								 
					</cfquery>
					<cfset j = j - 1>
				</cfloop>
			</cfif>
		</cfif>		
	</cfloop>
	
	<!--- Actualización del campo "EOidorden" con la orden que tenga el mayor plazo --->
	<cfquery name="rsOrdenMaxPlazo" datasource="#session.dsn#">
		select distinct eo.EOidorden
		from DDocumentosRecepcion ddr
			inner join DOrdenCM do
				on do.DOlinea = ddr.DOlinea
				and do.Ecodigo = ddr.Ecodigo
			inner join EOrdenCM eo
				on eo.EOidorden = do.EOidorden
				and eo.Ecodigo = do.Ecodigo
		where ddr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
			and ddr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and eo.EOplazo = (
							select max(eo1.EOplazo)
							from DDocumentosRecepcion ddr1
								inner join DOrdenCM do1
									on do1.DOlinea = ddr1.DOlinea
									and do1.Ecodigo = ddr1.Ecodigo
								inner join EOrdenCM eo1
									on eo1.EOidorden = do1.EOidorden
									and eo1.Ecodigo = do1.Ecodigo
							where ddr1.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
								and ddr1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							)
	</cfquery>
	
	<cfquery name="rsUpdateOrdenEncabezado" datasource="#session.dsn#">
		update EDocumentosRecepcion
			<cfif rsOrdenMaxPlazo.RecordCount eq 0 or len(trim(rsOrdenMaxPlazo.EOidorden)) eq 0>
			set EOidorden = 1,
			<cfelse>
			set EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrdenMaxPlazo.EOidorden#">,
			</cfif>
				EDRtc = <cfqueryparam cfsqltype="cf_sql_float" value="#form.TC_E#">
		where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfquery name="sumaImp" datasource="#session.DSN#">
		select sum(coalesce(DDRmtoimpfact,0)) as sumaImp, sum(coalesce(DDRdesclinea,0)) as sumaDesc
		from DDocumentosRecepcion
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
	</cfquery>
	
	<cfif isdefined('sumaImp') and sumaImp.recordCount GT 0 and sumaImp.sumaImp GTE 0 and sumaImp.sumaDesc GTE 0>
		<cfquery datasource="#session.DSN#">
			update EDocumentosRecepcion
				set EDRimppro = <cfqueryparam cfsqltype="cf_sql_money" value="#sumaImp.sumaImp#">,
					EDRdescpro = <cfqueryparam cfsqltype="cf_sql_money" value="#sumaImp.sumaDesc#">
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
		</cfquery>
	</cfif>
	
	<cfif isdefined('form.btnAgregar')>
		<script language="JavaScript" type="text/javascript">
			window.close();	
			window.opener.form1.submit();
		</script>
	</cfif>
</cfif> 

<cfif isdefined("Url.EOnumero") and not isdefined("Form.EOnumero")>
	<cfparam name="Form.EOnumero" default="#Url.EOnumero#">
</cfif>
<cfif isdefined("Url.fecha") and not isdefined("Form.fecha")>
	<cfparam name="Form.fecha" default="#Url.fecha#">
</cfif>
<cfif isdefined("Url.Observaciones") and not isdefined("Form.Observaciones")>
	<cfparam name="Form.Observaciones" default="#Url.Observaciones#">
</cfif>
<cfif isdefined("Url.numparte") and not isdefined("Form.numparte")>
	<cfparam name="Form.numparte" default="#Url.numparte#">
</cfif>


<cfset filtro = "">
<cfset filtrosocio = "">
<cfset filtrotipo = "">
<cfset lfiltroarticulo = false>
<cfset lfiltroconcepto = false>
<cfset lfiltroparte    = false>

<cfset navegacion = ''>

<cfif isdefined("form.EDRid") and len(trim(form.EDRid))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EDRid=" & Form.EDRid>
</cfif>
<cfif isdefined("form.McodigoE") and form.McodigoE NEQ ''>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "McodigoE=" & Form.McodigoE>
</cfif>
<cfif isdefined("form.TC_E") and form.TC_E NEQ ''>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TC_E=" & Form.TC_E>
</cfif>

<cfif isdefined("Form.EOnumero") and Len(Trim(Form.EOnumero)) NEQ 0>
	<cfset filtro = filtro & " and a.EOnumero = " & Form.EOnumero >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EOnumero=" & Form.EOnumero>
</cfif>

<cfif isdefined("Form.Observaciones") and Len(Trim(Form.Observaciones)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Observaciones) like '%" & #UCase(Form.Observaciones)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Observaciones=" & Form.Observaciones>
</cfif>

<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fecha=" & Form.fecha>
</cfif>

<cfif isdefined("Form.Devoluciones") and Len(Trim(Form.Devoluciones)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Devoluciones=" & Form.Devoluciones>
</cfif>

<cfif isdefined("Form.numparte") and Len(Trim(Form.numparte)) NEQ 0>
	<cfset filtro = filtro & " and upper(par.NumeroParte) like '%" & #UCase(Form.numparte)# & "%'">
	<cfset lfiltroparte = true>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "numparte=" & Form.numparte>
</cfif>

<cfif isdefined("Form.SNcodigo") and Len(Trim(Form.SNcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNcodigo=" & Form.SNcodigo>
</cfif>

<cfif isdefined("Form.DOalterna") and Len(Trim(Form.DOalterna)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.DOalterna) like '%" & #UCase(Form.DOalterna)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DOalterna=" & Form.DOalterna>
</cfif>

<cfif isdefined("Form.DOobservaciones") and Len(Trim(Form.DOobservaciones)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.DOobservaciones) like '%" & #UCase(Form.DOobservaciones)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DOobservaciones=" & Form.DOobservaciones>
</cfif>

<cfif isdefined("Form.DOdescripcion") and Len(Trim(Form.DOdescripcion)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.DOdescripcion) like '%" & #UCase(Form.DOdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DOdescripcion=" & Form.DOdescripcion>
</cfif>

<cfif isdefined("Form.Acodigo") and Len(Trim(Form.Acodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(art.Acodigo) like '%" & #UCase(Form.Acodigo)# & "%'">
	<cfset lfiltroarticulo = true>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Acodigo=" & Form.Acodigo>
</cfif>

<cfif isdefined("Form.Ccodigo") and Len(Trim(Form.Ccodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(con.Ccodigo) like '%" & #UCase(Form.Ccodigo)# & "%'">
	<cfset lfiltroconcepto = true>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Ccodigo=" & Form.Ccodigo>
</cfif>

<cfquery name="rsLista" datasource="#session.DSN#">
		select  
			'#form.EDRid#' as EDRid
			, '#form.McodigoE#' as McodigoE
			, '#form.TC_E#' as TC_E
			, a.EOnumero
			, a.DOconsecutivo
			, b.SNcodigo                       
			, a.EOidorden
			, a.DOlinea 
			, b.EOestado
			, alm.Almcodigo
			<cfif isdefined("Form.Devoluciones") and Len(Trim(Form.Devoluciones)) NEQ 0>
				, a.DOcantsurtida
			<cfelse>
				, a.DOcantsurtida 
					+ 
						coalesce(
							(
								select sum(ddr.DDRcantordenconv)
								from DDocumentosRecepcion ddr
									inner join EDocumentosRecepcion edr
											inner join TipoDocumentoR tdr
												 on tdr.TDRcodigo = edr.TDRcodigo
												and tdr.Ecodigo   = edr.Ecodigo
										on edr.EDRid = ddr.EDRid
								where ddr.DOlinea = a.DOlinea
								  and edr.EDRestado < 1
								  and tdr.TDRtipo = 'R'
							), 0
						)
				  as DOcantsurtida
			</cfif>
			,  a.DOcantidad
			,  rtrim( 
						case 
							when CMtipo = 'A' then 
								((select min(c.Acodigo) from Articulos c where c.Aid = a.Aid)) 
							when CMtipo = 'S' then 
								((select min(d.Ccodigo) from Conceptos d where d.Cid = a.Cid))
							else ' '      
						end
						) #_Cat# ' - '#_Cat#a.DOdescripcion
					as DOdescripcion
			, case 
				when CMtipo = 'A' then
						coalesce(
						(
							select min(g.NumeroParte)
							from NumParteProveedor g
							where g.NPPid = (
										select min(NP.NPPid) 
										from NumParteProveedor NP          
										where NP.Ecodigo  = b.Ecodigo
										  and NP.SNcodigo = b.SNcodigo 
										  and NP.Aid      = a.Aid 
										  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between NP.Vdesde and NP.Vhasta)
						),
							((
								select min(c.Acodalterno)
								from Articulos c
								where c.Aid = a.Aid
							))
						) 
					else ' '
				end 
				as numeroparte
			, <cf_dbfunction name="to_char" args="a.EOnumero"> #_Cat#' - '#_Cat# b.Observaciones  as Orden
		from EOrdenCM b
			inner join DOrdenCM a

					 <cfif lfiltroarticulo>
							inner join Articulos art
								on art.Aid = a.Aid
					 </cfif>

					 <cfif lfiltroconcepto>
							inner join Conceptos con
								on con.Cid = a.Cid
					 </cfif>

					 <cfif lfiltroparte>
							inner join NumParteProveedor par
								 on par.Ecodigo  = b.Ecodigo
								and par.SNcodigo = b.SNcodigo
								and par.Aid      = a.Aid
								and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between par.Vdesde and par.Vhasta
					 </cfif>

					 left outer join Almacen alm
					 on alm.Aid = a.Alm_Aid
					 
			on a.EOidorden=b.EOidorden

			inner join Impuestos i 
				   on a.Icodigo = i.Icodigo 
				  and a.Ecodigo = i.Ecodigo                   
			 inner join CMTipoOrden e
				   on e.CMTOcodigo = b.CMTOcodigo
				  and e.Ecodigo    = b.Ecodigo 
		where b.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		  and b.Mcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoE#">
		  and b.EOestado = 10
		  and e.CMTOimportacion < 1
		  and coalesce(
					(
							select sum(ddr.DDRcantordenconv)
							from DDocumentosRecepcion ddr
								inner join EDocumentosRecepcion edr
										inner join TipoDocumentoR tdr
											 on tdr.TDRcodigo = edr.TDRcodigo
											and tdr.Ecodigo   = edr.Ecodigo
									on edr.EDRid = ddr.EDRid
							where ddr.DOlinea = a.DOlinea
							  and edr.EDRestado < 1
							  and tdr.TDRtipo = 'R'
		
					)
				, 0) < (a.DOcantidad - a.DOcantsurtida)
		  and not exists(
				select 1
				from DDocumentosRecepcion x
				where x.DOlinea = a.DOlinea
				  and x.EDRid = <cfqueryparam value="#form.EDRid#" cfsqltype="cf_sql_numeric">
				)								 
		#preservesinglequotes(filtro)#
		order by a.EOnumero, a.DOconsecutivo
</cfquery>

<!--- Se regresa a la pagina #1 cuando se esta en la ultima pagina y se da clic en el botn de guardar y continuar ---->
<cfif pagina gt ceiling(rsLista.recordcount/8)><!--- Se obtiene la máxima pagina (la pagina hace corte cada 8 lineas, la funcion Ceiling me "redondea" al proximo numero inmediato ---->
	<cfset pagina = 1 >
</cfif>

<html>
<head>
<title>Lista de Ordenes de Compra</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfif isdefined("session.sitio.template") and listfind(session.sitio.template, 'login02', '/')>
	<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
	<link href="/cfmx/plantillas/login02/stylesheet.css" rel="stylesheet" type="text/css">
	<link href="/cfmx/plantillas/login02/login02.css" rel="stylesheet" type="text/css">
<cfelse>
	<cf_templatecss>
</cfif> 
<!----<cf_templatecss>---->
<script language="JavaScript" type="text/javascript">
<!--//
	function Asignar(DOlinea, DOdescripcion) {
		if (window.opener != null) {
			window.opener.document.form1.DOlinea.value = DOlinea;
			window.opener.document.form1.DOdescripcion.value = DOdescripcion;
			window.close();
		}
	}

	function funcAgregar(DOlinea, DOdescripcion) {
		document.linea.EDRID.value = <cfoutput>#form.EDRid#</cfoutput>;
		document.linea.SNCODIGO.value = <cfoutput>#form.SNcodigo#</cfoutput>;
		document.linea.MCODIGOE.value = <cfoutput>#form.McodigoE#</cfoutput>;		
		document.linea.TC_E.value = <cfoutput>#form.TC_E#</cfoutput>;	
		window.close();
		window.opener.document.form1.submit();			
	}	
	
	//Funcion para el botón de agregar y continuar 
	function funcAgregar_y_continuar(DOlinea, DOdescripcion) {
		document.linea.EDRID.value = <cfoutput>#form.EDRid#</cfoutput>;
		document.linea.SNCODIGO.value = <cfoutput>#form.SNcodigo#</cfoutput>;
		document.linea.MCODIGOE.value = <cfoutput>#form.McodigoE#</cfoutput>;		
		document.linea.TC_E.value = <cfoutput>#form.TC_E#</cfoutput>;		
		document.linea.PageNum.value = <cfoutput>#pagina#</cfoutput>;		
		window.opener.document.form1.submit();
	}

	//Funcion para cerrar la pantalla
	function funcCerrar(){
		window.close();
		window.opener.document.form1.submit();
	}	



//-->
</script>
</head>
<body>
<script  language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<cfoutput><form style="margin:0;" name="filtroOrden" method="post" action="ConlisLineaCompra.cfm">
			<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
					<td width="14%" align="right" nowrap class="LetraDetalle">N&uacute;mero Orden:</td>
					<td width="8%"> 
						<input tabindex="1" type="text" name="EOnumero" id="EOnumero" style="text-align:right;"
						   size="25" maxlength="20" 
						   onKeyUp="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
						   onFocus="javascript:this.select();" 
						   onChange="javascript: fm(this,-1);"
						   value="<cfif isdefined("Form.EOnumero")>#Form.EOnumero#</cfif>">
					</td>
					<td width="13%" align="right" nowrap class="LetraDetalle">Descripci&oacute;n Orden:</td>
					<td width="27%"> 
						<input name="Observaciones" type="text" id="desc" size="25" maxlength="80" value="<cfif isdefined("Form.Observaciones")>#Form.Observaciones#</cfif>" onFocus="javascript:this.select();">
					</td>
				    <td width="15%" align="right" nowrap class="LetraDetalle">Num. de Parte:</td>
				    <td width="7%">
						<input name="numparte" type="text" id="numparte" size="25" maxlength="20" value="<cfif isdefined("Form.numparte")>#Form.numparte#</cfif>" onFocus="javascript:this.select();">
					</td>					
					<td width="16%" align="center">						
						<input name="EDRid" type="hidden" value="#form.EDRid#">
						<input name="McodigoE" type="hidden" value="#form.McodigoE#">
						<input name="TC_E" type="hidden" value="#form.TC_E#">				
						<input name="SNcodigo" type="hidden" value="#form.SNcodigo#">
						<cfif isdefined("Form.Devoluciones") and len(trim(Form.Devoluciones))>
						<input name="Devoluciones" type="hidden" value="#Form.Devoluciones#">
						</cfif>
					</td>
				</tr>
				<tr>
					
					<td width="15%" align="right" nowrap class="LetraDetalle">Descripción alterna:</td>
					<td><input name="DOalterna" type="text" id="DOalterna" size="25" maxlength="1024" value="<cfif isdefined("Form.DOalterna")>#Form.DOalterna#</cfif>"> 
					<td width="15%" align="right" nowrap class="LetraDetalle">Observaciones:</td>
				  <td><input name="DOobservaciones" type="text" id="DOobservaciones" size="25" maxlength="255" value="<cfif isdefined("Form.DOobservaciones")>#Form.DOobservaciones#</cfif>"> 
					<td width="15%" align="right" nowrap class="LetraDetalle">Descripción línea:</td>
					<td><input name="DOdescripcion" type="text" id="DOdescripcion" size="25" maxlength="255" value="<cfif isdefined("Form.DOdescripcion")>#Form.DOdescripcion#</cfif>"></td>					
				</tr>
				<tr>
					<td width="15%" align="right" nowrap class="LetraDetalle">Código Artículo:</td>
					<td><input name="Acodigo" type="text" id="Acodigo" size="20" maxlength="20" value="<cfif isdefined("Form.Acodigo")>#Form.Acodigo#</cfif>"> 
					<td width="15%" align="right" nowrap class="LetraDetalle">Código Servicio:</td>
				  <td><input name="Ccodigo" type="text" id="Ccodigo" size="20" maxlength="20" value="<cfif isdefined("Form.Ccodigo")>#Form.Ccodigo#</cfif>"> <!---onFocus="javascript:this.select();">--->										
					<td><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar"></td>
					<td><input name="btnlimpiar" type="reset"  id="btnlimpiar" value="Limpiar"></td>
				</tr>
			</table>
			</form>
			</cfoutput>
		</td>
	</tr>	
	<tr>
		<td>
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet"> 
					<cfinvokeargument name="query" value="#rsLista#"/> 
					<cfinvokeargument name="desplegar" value="DOconsecutivo, DOdescripcion, Almcodigo, numeroparte, DOcantidad , DOcantsurtida"/> 
					<cfinvokeargument name="etiquetas" value="L&iacute;nea, Descripci&oacute;n, Alm, N. Parte, Cantidad, Surtida"/> 
					<cfinvokeargument name="formatos" value="S,S,S,S,M,M"/> 
					<cfinvokeargument name="align" value="left,left,left,right,right,right"/> 
					<cfinvokeargument name="ajustar" value="S"/> 				 
					<cfinvokeargument name="chkcortes" value="S"/> 	
					<cfinvokeargument name="keycorte" value="EOidorden"/>
					<cfinvokeargument name="keys" value="DOlinea"/>				
					<cfinvokeargument name="botones" value="Agregar,Agregar_y_continuar,Cerrar"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="irA" value="ConlisLineaCompra.cfm"/>				
					<cfinvokeargument name="formname" value="linea"/> 
					<cfinvokeargument name="maxrows" value="8"/> 
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="showEmptyListMsg" value="yes"/>
					<cfinvokeargument name="Cortes" value="Orden"/>
					<cfinvokeargument name="fontsize" value="10"/>
			</cfinvoke>  	
		</td>
	</tr>
    <tr>
    	<td>
        	* no se toman en cuenta las líneas de órdenes de compra que tengan asociado un "Tipo de Orden para Importación" tampoco las OC que no tengan unidades pendintes de surtir
        </td>
    </tr>
</table>
</body>
</html>