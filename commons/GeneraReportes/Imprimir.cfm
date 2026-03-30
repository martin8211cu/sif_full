
<cfif isdefined("url.idver")>
	<cfset Session.idver = "#url.idver#">
<cfelseif isdefined("Session.idver")>
	<cfset url.idver = "#Session.idver#">
</cfif>
<!--- Variable para almacenar el total general de los niveles agrupados --->
<cfset totGenAgrupados = 0>
<cfif isdefined("url.idver")>
	<cfquery name="rsReporte" datasource="#Session.DSN#">
		SELECT  rtr.RPCodigo, rtr.RPDescripcion,
				rtrv.RPTVTipoGrafica, rtrv.RPTVActivo, rtrv.RPTVCodigo, rtrv.RPTVDescripcion,
				rtrv.RVAAgrupacionTotal as MostrarTotal,
				rtrv.RVAAgrupacionSubTotal as MostrarSubT
		FROM RT_ReporteVersion rtrv
		inner join RT_Reporte rtr
			on rtr.RPTId = rtrv.RPTId
			and rtrv.RPTVId = #url.idver#
	</cfquery>

	<cfquery name="rsColumnAlias" datasource="#session.dsn#">
		select ODCampo,RTPCAlias from RT_ReporteVerColumna
		where RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.idver#">
	</cfquery>

	<cfquery name="rsVD" datasource="#Session.dsn#">
		SELECT  RPTVDId,RPTVId,RPVDCampo,RPTVTipo
		FROM RT_ReporteVersionDetalle
		where  RPTVId = #url.idver#
	</cfquery>
	<cfquery dbtype="query" name="rsVDX">
		select *
		from rsVD
		where RPTVTipo = 'X'
	</cfquery>

	<cfquery dbtype="query" name="rsVDV">
		select *
		from rsVD
		where RPTVTipo = 'V'
	</cfquery>
	<cfif rsReporte.recordCount GT 0 >
		<cfset LvarFile = '#rsReporte.RPCodigo#_#DateFormat(now(),'yyyy-mm-dd-')##TimeFormat(now(),'HH-mm-ss-lll')#'>

		<cfinvoke component="commons.GeneraReportes.Componentes.GeneraReporte"
			method="getSQL"
			varRPCodigo="#rsReporte.RPCodigo#"
			varIdver="#url.idver#"
			returnvariable="strSQL"
		/> <!--- Pasar el id del reporte url.--->
		<cfset arrLista = arraynew(1)>

		<cftransaction>
			<cfquery name="rsDatos" datasource="#Session.DSN#">
				#PreserveSingleQuotes(strSQL)#
			</cfquery>
			<cftransaction action="rollback" />
		</cftransaction>

		<cfset arrCol = Getmetadata(rsDatos)>
<!--- <cf_dump var="#rsDatos#"> --->
		<!--- OPARRALES --->
		<cfquery name="columnasGroup" datasource="#Session.Dsn#">
			select ra.RVAColAgrupacion from RT_ReporteVersionAgrupacion ra
			 where ra.RPTVId = #url.idver# order by ra.RVAId ASC
		</cfquery>
		<cfset count = 1>
		<cfif columnasGroup.RecordCount gte 1>
			<cfloop query="#columnasGroup#">
				<cfset arrLista[count] = #columnasGroup['RVAColAgrupacion'][currentRow]#>
				<cfset count+=1>
			</cfloop>
		</cfif>
		<!--- OPARRALES --->
	<cfif not isdefined("form.btnDownload") and not isdefined("url.btnDownload")>
		<!DOCTYPE html>
		<html>
		<head>
			<cfoutput>
				<title>Reporte - #rsReporte.RPDescripcion#</title>
			</cfoutput>
 				<cf_importLibs>
			<cfif ((rsReporte.RPTVTipoGrafica NEQ "ND" and rsReporte.RPTVTipoGrafica NEQ "") and rsVDX.recordCount GT 0 and rsVDV.recordCount GT 0)>
				<cfset varTipoGrafica = "column">
				<cfif rsReporte.RPTVTipoGrafica EQ "P">
					<cfset varTipoGrafica = "pie">
				<cfelseif rsReporte.RPTVTipoGrafica EQ "L">
					<cfset varTipoGrafica = "line">
				</cfif>
				<script type="text/javascript" src="../../../cfmx/jquery/librerias/jquery-1.8.2.min.js"></script>
				<script type="text/javascript">
					$(function () {
					    $('#container').highcharts({
					        data: {
					            table: 'datatable'
					        },
					        chart: {
					            type: '<cfoutput>#varTipoGrafica#</cfoutput>'
					        },
					        title: {
					            text: 'Datos Tabla Dinamica'
					        },
					        yAxis: {
					            allowDecimals: true,
					            title: {
					                text: 'Valor'
					            }
					        },
					        tooltip: {
					            formatter: function () {
					                return '<b>' + this.series.name + '</b><br/>' +
					                    this.point.y + ' ' + this.point.name.toLowerCase();
					            }
					        }
					    });
					});
				</script>
			</cfif>
			<!--- <link rel="stylesheet" type="text/css" href="../../../cfmx/home/css/agrupados.css"> --->
		</head>
		<body>

			<cfif ((rsReporte.RPTVTipoGrafica NEQ "ND" and rsReporte.RPTVTipoGrafica NEQ "") and rsVDX.recordCount GT 0 and rsVDV.recordCount GT 0)>
				<script src="../../../cfmx/jquery/librerias/Highcharts/js/highcharts.js"></script>
				<script src="../../../cfmx/jquery/librerias/Highcharts/js/modules/data.js"></script>
				<script src="../../../cfmx/jquery/librerias/Highcharts/js/modules/exporting.js"></script>
			</cfif>
	</cfif>
			<div class="container" style="margin-left:30px">
				<div class="row">
					<div class="col col-md-12">
						<cf_htmlreportsheaders
				            title="#rsReporte.RPDescripcion#"
				            filename="#LvarFile#-#Session.Usucodigo#.xls"
				            back="false"
				            close="true"
				            ira="Imprimir.cfm?idver=#url.idver#"
				        >
					</div>
				</div>
				<div class="row">
					<div class="col col-md-12">
						<table  width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
				            <tr>
				                <td colspan="<cfoutput>#arraylen(arrCol)#</cfoutput>" align="center">
				                <h4><cfoutput>#Session.enombre#</cfoutput></h4>
				                </td>
				            </tr>
				            <tr >
				                <td colspan="<cfoutput>#arraylen(arrCol)#</cfoutput>" align="center" >
				                    <h4><strong><cfoutput>#rsReporte.RPDescripcion#</cfoutput></strong></h4>
				                </td>
				            </tr>
				        </table>
				     </div>
				</div>
				<cfif not isdefined("form.btnDownload") and not isdefined("url.btnDownload")>
				<cfif ((rsReporte.RPTVTipoGrafica NEQ "ND" and rsReporte.RPTVTipoGrafica NEQ "") and rsVDX.recordCount GT 0 and rsVDV.recordCount GT 0 )>
		        <hr>
				<div class="row">
					<div class="cont">
						<div class="row">
							<div class="col col-md-6">
								<div id="container" style="min-width: 300px; height: 300px; margin: 0 auto"></div>
							</div>
							<div class="col col-md-6" align="center">
								<h4>Tabla Dinamica</h4>
								<cfset a = getSQLTablaDinamica()>
								<cfquery name="rsTD" datasource="#Session.dsn#">
									#getSQLTablaDinamica()#
								</cfquery>
								<cfset arrResult = Getmetadata(rsTD)>
								<!--- <cf_dump var="#arrResult#"> --->
								<div class="CSSTableGenerator">
									<cftry>
										<cfsavecontent  variable = "htmlTD">
											<table id="datatable" class="principal" width="100%">
												<thead>
													<tr class="niveles" bgcolor="##005fbf">
														<cfset vprimero = true>
														<cfloop array="#arrResult#" index="colResult">
															<th id="niveles" style="border:solid 1px; border-color:black; text-align:<cfoutput>#alineaTexto(colResult.typename)#</cfoutput>;"><cfoutput><font color="white"><cfif not vprimero>Suma de </cfif>#getColumnAlias(colResult.Name)#</font></cfoutput></th>
															<cfset vprimero = false>
														</cfloop>
													</tr>
												</thead>
												<tbody>
													<cfset gris = "##EEEEEE">
													<cfset blanco = "##FFFFFF">
													<cfset parImpar = 0>
													<cfloop query="rsTD">
														<cfset color= #gris#>
														<cfif (parImpar MOD 2 EQ 0)>
															<cfset color = #blanco#>
														</cfif>
														<tr class="niveles" style="border:solid 1px; border-color:black; background:<cfoutput>#color#</cfoutput>;">
														<!--- <tr class="niveles"> --->
															<cfloop index="colResult" from = "1" to = "#arraylen(arrResult)#" >
																<cfset cstr = "">
																<cfif colResult EQ 1>
																	<cfset cstr = "#arrResult[colResult].Name# - ">
																</cfif>
																<cfset valor = "#rsTD[arrResult[colResult].name][currentrow]#">
																<td class="nivel" style="border:solid 1px; border-color:black; text-align:<cfoutput>#alineaTexto(arrResult[colResult].typename)#</cfoutput>"><cfoutput>#formatoTexto(valor,arrResult[colResult].typename, false)#</cfoutput></td>
															</cfloop>
														</tr>
														<cfset parImpar +=1>
													</cfloop>
												</tbody>
											</table>
										</cfsavecontent>

									<cfcatch type="any">
										<cfsavecontent  variable = "htmlTD">
											<cfoutput>
												<label class="error" style="color:red" >No se puede imprimir debido a que los campos de la versi&oacute;n no esta actualizados o se encuentran repetidos.</label>
												<label class="error" style="color:red" >Actualice la configuraci&oacute;n de la  versi&oacute;n.</label>
												<!--- <cfdump var="#cfcatch.message#"> --->
												<cfquery datasource="#session.dsn#">
													delete from RT_ReporteVersionDetalle
													where RPTVId = #url.idver#
												</cfquery>
											</cfoutput>
										</cfsavecontent>
									</cfcatch>
									<cffinally>
										<cfoutput>#htmlTD#</cfoutput>
									</cffinally>
									</cftry>
								</div>
							</div>
						</div>
					</div>
				</div>
				</cfif>
			</cfif>
						<!---
							OPARRALES
							Bloque de codigo para pintar la tabla
							con niveles de agrupacion
						--->
			<cfif rsdatos.recordCOunt gt 0>
				<cftry>
					<cfsavecontent  variable = "htmlR">
				        <cfif columnasGroup.RecordCount gte 1>
				        	<cfset parImpar = 0>
							<cfset arrQuery = ArrayNew(1)>
							<cfif not ArrayIsEmpty(arrLista)>
								<cfoutput>
										<hr>
									<div class="row">
										<table class="principal" border="2" width="100%">
											<!--- Columna de encabezado para todos los niveles --->
											 <tr bgcolor="##005fbf" style="border:5px;">
												<th id="niveles" style="border:solid 1px; border-color:black">&nbsp;</th>
												<cfset levelsSize = arraylen(Getmetadata(rsDatos))>
												<!--- Encabezados restantes despues de los niveles --->
												<cfloop  index="i" from="1" to="#levelssize#">
													<cfset col = #Getmetadata(rsDatos)[i].name#>
													<cfif Arrayfind(arrLista,col)>
														<cfcontinue>
													</cfif>
														<th class="sinEstilo" style="border:solid 1px; border-color:black; text-align:<cfoutput>#alineaTexto(Getmetadata(rsDatos)[i].typename)#</cfoutput>;"><font color="white">#getColumnAlias(col)#</font></th>
												</cfloop>
											</tr>
												#generaCode(1,arrLista,rsDatos,rsDatos)#

												<!--- Calculando totales de cifras Numericas --->
												<cfoutput>
													<cfif rsReporte.MostrarTotal eq 1>
														#sumTotales(1)#
													</cfif>
												</cfoutput>

										</table>
									</div>
										<hr>
									</hr>
								</cfoutput>
							</cfif>
							<cfelse>
							<div class="row">
								<hr>
								<cfset parImpar = 0>
								<cfset gris = "##EEEEEE">
								<cfset blanco = "##FFFFFF">
								<table border="2" width="100%">
									<thead style="border:solid 1px; border-color:black;">
										<cfloop array="#arrCol#" index="col">
											<cfset vAlign = alineaTexto(#col.typename#)>
											<th bgcolor="##005fbf" style="border:solid 1px; border-color:black; text-align:<cfoutput>#vAlign#</cfoutput>"><cfoutput><font color="white">#getColumnAlias(col.Name)#</font></cfoutput></th>
										</cfloop>
									</thead>
									<tbody>
										<cfloop query="rsDatos">
											<cfset parImpar +=1>
											<cfset color= #gris#>
											<cfif (parImpar MOD 2 EQ 0)>
												<cfset color = #blanco#>
											</cfif>
											<tr class="niveles" style="border:solid 1px; border-color:black; background:<cfoutput>#color#</cfoutput>;">
												<cfloop index="col" from = "1" to = "#arraylen(arrCol)#" >
													<td style="border:solid 1px; border-color:black; text-align:<cfoutput>#alineaTexto(arrCol[col].typename)#</cfoutput>"><cfoutput>#formatoTexto(rsDatos[arrCol[col].Name][currentrow],arrCol[col].typename)#</cfoutput></td>
												</cfloop>
											</tr>
										</cfloop>
										<cfoutput>
											<cfif rsReporte.MostrarTotal eq 1>
												#sumTotales(0)#
											</cfif>
										</cfoutput>
									</tbody>
								</table>
								<hr>
						</cfif>
					</cfsavecontent>
				<cfcatch type="any">
					<cfsavecontent  variable = "htmlR">
						<cfoutput>
							<label class="error" style="color:red" >Ocurri&oacute; un error ejecutando esta versi&oacute;n del Reporte, Por favor revice la configuraci&oacute;n</label>
							<label class="error" style="color:red" >Verifique lo siguiente:
								<ul>
									<li>Que no existan campos con nombre duplicado</li>
									<li>Que no existan campos de tipo de datos complejos: Ejp: tiemestamp, binary, varbinary</li>
								</ul>
							</label>
							<br>
							#cfcatch.message#
							<br>
							#cfcatch.stacktrace#
						</cfoutput>
					</cfsavecontent>
				</cfcatch>
				<cffinally>
					<cfoutput>#htmlR#</cfoutput>
				</cffinally>
				</cftry>
						<cfelse>
						<table width="100%">
							<tr align="center">
								<td>
									<label class="error" style="color:red" >No hay resultados para esta configuraci&oacute;n de Reporte</label>
								</td>
							</tr>
						</table>
						</cfif>
						<!--- OPARRALES --->
					</div>
				</div>
				<div class="row">
					<div class="col col-md-12">&nbsp;</div>
				</div>
			</div>
		<cfif not isdefined("form.btnDownload") and not isdefined("url.btnDownload")>
		</body>
		</html>
		</cfif>
	</cfif>
<cfelse>
	&nbsp;
</cfif>

<cffunction name="getColFormat" returntype="string">
	<cfargument name="col" 	type="struct" required="true" >

	<cfreturn "<td">
</cffunction>

<cffunction name="getSQLTablaDinamica" returntype="string">

	<cfquery name="mdRSVDX" datasource="#Session.dsn#">
		SELECT  top 1 RPVDCampo
		FROM RT_ReporteVersionDetalle
		where  RPTVId = #url.idver#
			and RPTVTipo = 'X'
	</cfquery>

	<cfsavecontent  variable = "strTDSQL">
		<cfoutput>
			<cfset colValue = 1>
			<cfset colName = 1>
		    <cfquery name="mdRSVDV" datasource="#Session.dsn#">
				SELECT  top 1 RPVDCampo
				FROM RT_ReporteVersionDetalle
				where  RPTVId = #url.idver#
					and RPTVTipo = 'V'
			</cfquery>
			<cfset strCosl = "">
			<cfloop query="rsVDV">
				<cfset strCosl = "#strCosl#, [#rsVDV.RPVDCampo#]">
				<cfset colName = colName + 1>
			</cfloop>
		    SELECT cat.[#mdRSVDX.RPVDCampo#] #strCosl#
		    from (
				select DISTINCT [#mdRSVDX.RPVDCampo#]
				from (
					#strSQL#
				) a
		    ) cat
		    <cfloop query="rsVDV">
				LEFT JOIN (
					SELECT [#mdRSVDX.RPVDCampo#] as [#mdRSVDX.RPVDCampo##colValue#], SUM([#rsVDV.RPVDCampo#]) as [#rsVDV.RPVDCampo#]
					from (
						#strSQL#
				    ) colvalue
				    group by [#mdRSVDX.RPVDCampo#]
				) colvalue#colValue#
					ON cat.[#mdRSVDX.RPVDCampo#] = colvalue#colValue#.[#mdRSVDX.RPVDCampo##colValue#]
				<cfset colValue = colValue + 1>
			</cfloop>
		    order by cat.[#mdRSVDX.RPVDCampo#]
	    </cfoutput>
	</cfsavecontent>
	<cfreturn strTDSQL>
</cffunction>

<cffunction name="generaCode" returntype="string">
	<cfargument name="iteracion" type="numeric">
	<cfargument name="campos" type="array">
	<cfargument name="queryname" type="query">
	<cfargument name="queryOriginal" type="query">
	<cfset vAlign = "">
	<cfset gris = "##EEEEEE">
	<cfset blanco = "##FFFFFF">
	<cfsavecontent variable="result">
		<cfoutput>
			<cfset rs = "rs#arguments.iteracion#">
			<cfquery name="rs#arguments.iteracion#" dbtype="query">
				select distinct
					<cfif arguments.iteracion lte Arraylen(arguments.campos)>
						<cfloop index = "campo" from = "1" to = "#arguments.iteracion#">
							<cfset cc = campos[#campo#]>
							<cfset completo = "[#cc#]">
							 #IIf(campo gt 1, DE(",#completo#"), DE("#completo#"))#
						</cfloop>
					<cfelse>
						*
					</cfif>
				from
					<cfif arguments.iteracion lt Arraylen(arguments.campos)>
						arguments.queryOriginal
					<cfelse>
						arguments.queryname
					</cfif>
				<cfif arguments.iteracion gt 1>
					where
						<cfloop index = "campo" from = "1" to = "#arguments.iteracion - 1#">
							<cfset vInicial = "#request['1']#">
							<cfset vCurr = "#request['#campo#']#">
							 #IIf(campo gt 1, DE("AND  [#campos[campo]#] = '#vCurr#'"), DE("[#campos[campo]#] = '#vInicial#'"))#
						</cfloop>
				</cfif>
			</cfquery>
			<cfif arguments.iteracion lte Arraylen(arguments.campos) and rsReporte.MostrarSubT eq 1>
				<cfset listcc = ArrayToList(campos)>
				<cfquery name="rsST#arguments.iteracion#" dbtype="query">
					select
						<cfloop index = "campo" from = "1" to = "#arguments.iteracion#">
							<cfset cc = campos[#campo#]>
							<cfset completo = "[#cc#]">
							 #IIf(campo gt 1, DE(",#completo#"), DE("#completo#"))#
						</cfloop>
						<cfloop index = "campoSUM" from = "1" to = "#ArrayLen(ArrCol)#">
							<cfset ccSUM = ArrCol[#campoSUM#]>
							<cfset completoSUM = "[#ccSUM.Name#]">
							<cfif ListFindNoCase(listcc,campoSUM) eq 0 and ListFindNoCase("identity,bit,decimal,int,money,bigint,double,real,integer,numeric,real,smallint,tinyint", arrCol[campoSUM].typename) gt 0>
							 ,SUM(#completoSUM#) AS [#ccSUM.Name#]
							</cfif>
						</cfloop>
					from
						arguments.queryOriginal
					<cfif arguments.iteracion gt 1>
						where
							<cfloop index = "campo" from = "1" to = "#arguments.iteracion - 1#">
								<cfset vInicial = "#request['1']#">
								<cfset vCurr = "#request['#campo#']#">
								 #IIf(campo gt 1, DE("AND  [#campos[campo]#] = '#vCurr#'"), DE("[#campos[campo]#] = '#vInicial#'"))#
							</cfloop>
					</cfif>
					group by
						<cfloop index = "campo" from = "1" to = "#arguments.iteracion#">
							<cfset cc = campos[#campo#]>
							<cfset completo = "[#cc#]">
							 #IIf(campo gt 1, DE(",#completo#"), DE("#completo#"))#
						</cfloop>
				</cfquery>
			</cfif>
			<cfloop query="rs#arguments.iteracion#">

				<cfif arguments.iteracion lte Arraylen(arguments.campos)>
					<cfset colResult = #Getmetadata(queryOriginal)[arguments.iteracion]#>
					<cfset vAlign = "left">
					<cfif alineaTexto(#colResult.typename#)  eq "right">
						<cfset totGenAgrupados =+ queryOriginal[#colResult.Name#][currentRow]>
					</cfif>
					<tr class="bordeNiveles" style="border:solid 1px; border-color:black">
						<cfset span = 1>
						<cfif rsReporte.MostrarSubT neq 1>
							<cfset span = listlen(rsDatos.ColumnList)- arraylen(arguments.campos) +1>
						</cfif>
						<cfset px = 0>
						<cfif arguments.iteracion gt 1>
							<cfset px = 10 * #arguments.iteracion#>
						</cfif>
						<td class="nivel" nowrap colspan="#span#" style="text-indent: <cfoutput>#px#</cfoutput>px">
							<cfset f = evaluate("rs#arguments.iteracion#")['#arguments.campos[arguments.iteracion]#'][currentrow]>
							<cfset request["#arguments.iteracion#"] = f>
							<font class="nivel#arguments.iteracion#">
								<strong>
									#getColumnAlias(arguments.campos[arguments.iteracion])#: #f#
								</strong>
							</font>
						</td>



						<!--- completa las columnas de los niveles --->
						<cfif arguments.iteracion lte arraylen(arguments.campos)>
							<cfif rsReporte.MostrarSubT eq 1>
								<cfloop index = "qc" array="#getmetadata(rsDatos)#">
									<cfif listFindNoCase(arrayToList(campos),trim("#qc.Name#")) eq 0>
										<cfset vAlign = alineaTexto(#qc.typename#)>
										<cfif alineaTexto(qc.typename)  eq "right">
											<cfset vAlign = "right">
											<cfset sub = queryOriginal[#qc.Name#][currentRow]>
										</cfif>
										<cfset vAlign = alineaTexto(#qc.typename#)>
										<td class="nivel" style="text-align:<cfoutput>#vAlign#</cfoutput>">
											<cftry> <!--- si no existe el campo en la consulta de subtotal --->
												<cfset f = evaluate("rsST#arguments.iteracion#")['#qc.Name#'][currentrow]>
												<!--- <cfset request["#arguments.iteracion#"] = f> --->
												<cfset f = #formatoTexto(f,qc.typename)#>
												<font><b>#f#</b></font>
											<cfcatch type="any">
												<font>&nbsp;</font>
											</cfcatch>
											</cftry>
										</td>
											<!--- <cfset cont +=1> --->
									</cfif>
								</cfloop>
							</cfif>
						</cfif>
						<!--- End completa columnas niveles --->
					</tr>
					<cfif arguments.iteracion lte Arraylen(arguments.campos)>
						<!--- Recursividad --->
						<cfset parImpar = 0>
						#generaCode(arguments.iteracion + 1,arrLista,rsDatos,rsDatos)#
					</cfif>
				<cfelse>
					<cfset arrSubs = arraynew(1)>
					<cfset contador = 1>
					<cfset arrCol = Getmetadata(rsDatos)>
					<cfloop array="#arrCol#" index="unaCol">
						<cfset bandera=False>
						<cfloop array="#arrLista#" index="unAgr">
							<cfif unAgr eq unaCol.name>
								<cfset bandera = True>
								<cfbreak>
							</cfif>
						</cfloop>
						<cfif bandera eq True>
							<cfcontinue>
						</cfif>
						<cfset arrSubs[contador] = 0>
						<cfset contador +=1>
					</cfloop>
				<!--- Pinta los detalles de las columnas que fueron agrupadas --->
					<cfset parImpar +=1>
					<cfset color= #gris#>
					<cfif (parImpar MOD 2 EQ 0)>
						<cfset color = #blanco#>
					</cfif>
					<tr class="niveles" style="border:solid 1px; border-color:black; background:<cfoutput>#color#</cfoutput>;">
						<cfset lcampos = ArrayToList(arguments.campos)>
						<cfset resultF = ArrayNew(1)>
						<cfset limit = queryOriginal.RecordCount >
						<td class="nivel"></td>
						<cfset cont = 1>
						<cfloop index = "qc" array="#getmetadata(rsDatos)#">
							<cfif listFind(lcampos,trim("#qc.Name#")) eq 0>
								<cfset vAlign = alineaTexto(#qc.typename#)>
								<cfif alineaTexto(qc.typename)  eq "right">
									<cfset vAlign = "right">
									<cfset sub = queryOriginal[#qc.Name#][currentRow]>
									<cfset anterior = arrSubs[cont]>
									<cfset arrSubs[cont] = anterior + sub >
									<cfelse>
										<cfset arrSubs[cont] = "cadena" >
								</cfif>
								<cfset vAlign = alineaTexto(#qc.typename#)>
								<td class="nivel" style="text-align:<cfoutput>#vAlign#</cfoutput>">
									<cfset f = evaluate("rs#arguments.iteracion#")['#qc.Name#'][currentrow]>
									<cfset request["#arguments.iteracion#"] = f>
									<cfset f = #formatoTexto(f,qc.typename)#>
									<font>#f#</font>
								</td>
									<cfset cont +=1>
							</cfif>
						</cfloop>
					</tr>
				</cfif>
			</cfloop>
		</cfoutput>
	</cfsavecontent>
	<cfreturn result>
</cffunction>

<cffunction name="alineaTexto" returntype="string">
	<cfargument name="tipo" type="string">
	<cfset vAlign = "left">
	<cfif ListContainsNoCase("identity,bit,decimal,int,money,bigdecimal,bigint,double,real,integer,numeric identity,smallint,tinyint,float",#tipo#) gt 0>
		<cfset vAlign = "right">
	<cfelseif ListContainsNoCase("date,datetime",#tipo#) gt 0>
		<cfset vAlign = "center">
	</cfif>

	<cfreturn vAlign>
</cffunction>

<cffunction name="formatoTexto" returntype="string">
	<cfargument name="valor" type="string">
	<cfargument name="tipo" type="string">
	<cfargument name="separadormiles" type="boolean" default="true">

	<cfif ListContainsNoCase("identity,bit,int,bigint,integer,numeric,smallint,tinyint",arguments.tipo) gt 0>
		<cfset result = arguments.valor>
	<cfelseif ListContainsNoCase("decimal,money,double,real,float",arguments.tipo) gt 0>
		<cfif arguments.separadormiles>
			<cfset result = numberformat(arguments.valor,",0.00")>
		<cfelse>
			<cfset result = numberformat(arguments.valor,"0.00")>
		</cfif>
	<cfelseif ListContainsNoCase("char,varchar",arguments.tipo) gt 0>
		<cfset result = arguments.valor>
	<cfelseif ListContainsNoCase("date,datetime",tipo) gt 0>
		<cfset result = DateFormat(arguments.valor, "yyyy-mm-dd")>
	<cfelse>
		<cfset result = arguments.valor>
	</cfif>
	<cfreturn result>
</cffunction>

<!---
	  Suma los totales por columna del query original guardandolos en un Array
	  Los totales son guardados con la misma posicion de la columna sobre el Array.
	  Las columnas que no son numericas del Query, se guardan con 0 en el Array.
 --->
<cffunction name="sumTotales" returntype="string">
	<cfargument name="pintar" type="numeric">
	<cfset colSum = arraynew(1)>
	<cfset arrCol = Getmetadata(rsDatos)>
	<cfset count = 1>
	<cfloop array="#arrCol#" index="unaCol">
		<cfset bandera=False>
		<cfloop array="#arrLista#" index="unAgr">
			<cfif unAgr eq unaCol.name>
				<cfset bandera = True>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfif bandera eq True>
			<cfcontinue>
		</cfif>
		<cfif alineaTexto(unaCol.typename)  eq "right">
			<cfset colSum[count] = unaCol.name>
		<cfelse>
			<cfset colSum[count] = 0>
		</cfif>
		<cfset count +=1>
	</cfloop>
	<cfset arrTots = arraynew(1)>
	<cfset count=1>
	<cfloop array="#colSum#" index="colT">
		<cfif colT eq 0>
			<cfset arrTots[count] = 0>
		<cfelse>
			<cfset tTemp = 0>
			<cfloop query="#rsDatos#">
				<cfset unaCant = rsDatos[colT][currentRow]>
				<cfif not isnull(unaCant)>
					<cfif isnumeric(tostring(unaCant))>
						<cfset tTemp += unaCant>
					</cfif>
				</cfif>
				<cfset arrTots[count] = tTemp>
			</cfloop>
		</cfif>
		<cfset count+=1>
	</cfloop>

	<tr class="niveles" style="background-color:#aad4ff;">
		<cfif arguments.pintar eq 1 >
			<td class="nivel"><strong>Total: </strong></td>
		</cfif>
		<cfset count = 1>

		<cfloop array="#colSum#" index="colT">
			<cfset unVal = arrTots[count]>
			<cfset colType = "varchar">
			<cfset indicee = 0>
			<cfloop index="i" from="1" to="#arrayLen(getMetadata(rsDatos))#">
				<cfset indicee +=1>
		        <cfset a = getMetaData(rsDatos)[i].name>
		        <cfif a eq colT>
					<cfbreak >
				</cfif>
			</cfloop>
			<cfif rsdatos.recordcount gt 0>
				<cfset colType = #Getmetadata(rsDatos)[indicee].typename#>
			</cfif>
			<cfif colT eq 0>
				<cfoutput>
					<td class="nivel" style="border:solid 1px; border-color:black; text-align:#alineaTexto(colT)#"><strong></strong></td>
				</cfoutput>
			<cfelse>
				<cfoutput>
						<td class="nivel" style="border:solid 1px; border-color:black; text-align:right"><font size="2.2px"><b>#formatoTexto(unVal,colType)#</b></font></td>
						<!--- <td class="nivel" style="border:solid 1px; border-color:black; text-align:right"><font size="2.2px"><b>#numberformat(unVal,"0.00")#</b></font></td> --->
				</cfoutput>
			</cfif>
			<cfset count+=1>
		</cfloop>
	</tr>

	<cfreturn "">
</cffunction>

<cffunction name="getColumnAlias" returntype="string">
	<cfargument name="campo" type="string" required="true">
	<cfset result = arguments.campo>
	<cfquery dbtype="query" name="rsCA">
		select RTPCAlias from rsColumnAlias
		where ODCampo = '#trim(arguments.campo)#'
	</cfquery>
	<cfif rsCA.recordCount gt 0 and len(trim(rsCA.RTPCAlias)) gt 0>
		<cfset result = rsCA.RTPCAlias>
	</cfif>
	<cfreturn result>
</cffunction>