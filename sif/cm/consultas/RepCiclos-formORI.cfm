<cfsetting requesttimeout="3600">
<cfif isdefined("url.CFid") and len(trim(url.CFid)) and not isdefined("form.CFid")>
	<cfset form.CFid = url.CFid>
</cfif>
<cfif isdefined("url.mesIni") and len(trim(url.mesIni)) and not isdefined("form.mesIni")>
	<cfset form.mesIni = url.mesIni>
</cfif>
<cfif isdefined("url.mesFin") and len(trim(url.mesFin)) and not isdefined("form.mesFin")>
	<cfset form.mesFin = url.mesFin>
</cfif>
<cfif isdefined("url.anoIni") and len(trim(url.anoIni)) and not isdefined("form.anoIni")>
	<cfset form.anoIni = url.anoIni>
</cfif>
<cfif isdefined("url.anoFin") and len(trim(url.anoFin))  and not isdefined("form.anoFin")>
	<cfset form.anoFin = url.anoFin>
</cfif>
<cfif isdefined("url.cod_CMTScodigo") and len(trim(url.cod_CMTScodigo)) and not isdefined("form.cod_CMTScodigo")>
	<cfset form.cod_CMTScodigo = url.cod_CMTScodigo>
</cfif>
<cfif isdefined("url.CMCid1") and len(trim(url.CMCid1)) and not isdefined("form.CMCid1")>
	<cfset form.CMCid1 = url.CMCid1>
</cfif>
<cfif isdefined("url.Ccodigo") and len(trim(url.Ccodigo)) and not isdefined("form.Ccodigo")>
	<cfset form.Ccodigo = url.Ccodigo>
</cfif>
<cfif isdefined("url.CCid") and len(trim(url.CCid)) and not isdefined("form.CCid")>
	<cfset form.CCid = url.CCid>
</cfif>
<cfif isdefined("url.AgruparPor") and len(trim(url.AgruparPor)) and not isdefined("form.AgruparPor")>
	<cfset form.AgruparPor = url.AgruparPor>
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<!---Descripción del centro funcional y sus tipos de solicitud asociados--->
<cfquery name="rsCtroFunc" datasource="#session.DSN#">
	select a.CFcodigo#_Cat#' - '#_Cat#a.CFdescripcion as ctrofuncional, rtrim(ltrim(b.CMTScodigo)) as CMTScodigo
	from CFuncional a
		inner join CMTSolicitudCF b
			on a.Ecodigo = b.Ecodigo
			and a.CFid = b.CFid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
</cfquery>

<!--- Comprador en el filtro --->
<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
	<cfquery name="rsComprador" datasource="#session.DSN#">
		select CMCnombre, CMCcodigo
		from CMCompradores
		where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfswitch expression="#form.mesIni#">
	<cfcase value="1"><cfset vsMesIni = 'Enero'></cfcase>
	<cfcase value="2"><cfset vsMesIni = 'Febrero'></cfcase>
	<cfcase value="3"><cfset vsMesIni = 'Marzo'></cfcase>
	<cfcase value="4"><cfset vsMesIni = 'Abril'></cfcase>
	<cfcase value="5"><cfset vsMesIni = 'Mayo'></cfcase>
	<cfcase value="6"><cfset vsMesIni = 'Junio'></cfcase>
	<cfcase value="7"><cfset vsMesIni = 'Julio'></cfcase>
	<cfcase value="8"><cfset vsMesIni = 'Agosto'></cfcase>
	<cfcase value="9"><cfset vsMesIni = 'Setiembre'></cfcase>
	<cfcase value="10"><cfset vsMesIni = 'Octubre'></cfcase>
	<cfcase value="11"><cfset vsMesIni = 'Noviembre'></cfcase>
	<cfcase value="12"><cfset vsMesIni = 'Diciembre'></cfcase>
</cfswitch>
<cfswitch expression="#form.mesFin#">
	<cfcase value="1"><cfset vsMesFin = 'Enero'></cfcase>
	<cfcase value="2"><cfset vsMesFin = 'Febrero'></cfcase>
	<cfcase value="3"><cfset vsMesFin = 'Marzo'></cfcase>
	<cfcase value="4"><cfset vsMesFin = 'Abril'></cfcase>
	<cfcase value="5"><cfset vsMesFin = 'Mayo'></cfcase>
	<cfcase value="6"><cfset vsMesFin = 'Junio'></cfcase>
	<cfcase value="7"><cfset vsMesFin = 'Julio'></cfcase>
	<cfcase value="8"><cfset vsMesFin = 'Agosto'></cfcase>
	<cfcase value="9"><cfset vsMesFin = 'Setiembre'></cfcase>
	<cfcase value="10"><cfset vsMesFin = 'Octubre'></cfcase>
	<cfcase value="11"><cfset vsMesFin = 'Noviembre'></cfcase>
	<cfcase value="12"><cfset vsMesFin = 'Diciembre'></cfcase>
</cfswitch>

<cfset divisorAgrupar = 1>	<!--- Variables usadas para agrupar. Por default usa meses --->
<cfset factorAgrupar = 12>

<!--- Agrupar por mes --->
<cfif form.AgruparPor eq 1>
	<cfset divisorAgrupar = 1>
	<cfset factorAgrupar = 12>
<!--- Agrupar por trimestre --->
<cfelseif form.AgruparPor eq 2>
	<cfset divisorAgrupar = 3>
	<cfset factorAgrupar = 4>
<!--- Agrupar por semestre --->
<cfelseif form.AgruparPor eq 3>
	<cfset divisorAgrupar = 6>
	<cfset factorAgrupar = 2>
<!--- Agrupar por año --->
<cfelseif form.AgruparPor eq 4>
	<cfset divisorAgrupar = 12>
	<cfset factorAgrupar = 1>
</cfif>

<!----Tabla con los encabezados--->
<table width="98%" cellpadding="2" cellspacing="0" border="0">
	<tr><td align="center" colspan="8" class="tituloAlterno"><strong><cfoutput>#session.Enombre#</cfoutput></strong></td></tr>
	<tr><td align="center" colspan="8" style="font-size:13px"><strong>Ciclos de compra</strong></td></tr>
	<tr>		
		<td align="center" colspan="8"><strong><cfoutput>Desde&nbsp;#vsMesIni#&nbsp;del&nbsp;#form.anoIni#&nbsp; a &nbsp;#vsMesFin#&nbsp;del&nbsp;#form.anoFin#</cfoutput></strong></td>
	</tr>		
	<tr><td align="center" colspan="8"><strong><cfoutput>Centro Funcional:&nbsp;#rsCtroFunc.ctrofuncional#</cfoutput></strong></td></tr>
	<cfif isdefined("rsComprador") and rsComprador.RecordCount gt 0>
		<tr><td align="center" colspan="8"><strong>Comprador:&nbsp;<cfoutput>#rsComprador.CMCcodigo#&nbsp;-&nbsp;#rsComprador.CMCnombre#</cfoutput></strong></td></tr>
	</cfif>
	<tr><td colspan="8">&nbsp;</td></tr>
</table>
<cfflush interval="512">
<!-----Tabla con los detalles---->
<table width="98%" cellpadding="2" cellspacing="0" border="0">
	<cfoutput>
		<cfset aini = form.anoIni>
		<cfset afin = form.anoFin>
		<cfset minicio = form.mesIni>
		<cfset mfin = form.mesFin>
		<cfset finicial = createdate(aini, minicio, 1)>	<!--- Fecha de inicializacion del rango del reporte --->
		<cfset ffinal = createdate(afin, mfin, 1)>		<!--- Fecha de finalizacion del rango del reporte --->
		<cfset CMTScodigo = ''>							<!--- Varibale con el tipo de solicitud por el que va el loop --->
		<cfset vsTipos =''>								<!--- Variable con los tipos de solicitud --->
		<cfset vsBand ='false'>							<!--- Variable para saber si se encontraron registros para esos tipos de solicitud --->
	</cfoutput>

	<cfif isdefined("form.cod_CMTScodigo") and len(trim(form.cod_CMTScodigo)) and form.cod_CMTScodigo NEQ 'Todos'>
		<cfset vsTipos = "'"&form.cod_CMTScodigo&"'">
	<cfelseif isdefined("form.cod_CMTScodigo") and len(trim(form.cod_CMTScodigo)) and form.cod_CMTScodigo EQ 'Todos'>
		<cfset vsTipos = QuotedValueList(rsCtroFunc.CMTScodigo)>
	</cfif>
	
	<cfloop list="#vsTipos#" index="vntip">
		<cfset CMTScodigo = vntip>
		<tr>
			<td colspan="8">&nbsp;</td>
		</tr>
		<tr>
			<cfif form.AgruparPor eq 1 or form.AgruparPor eq 2 or form.AgruparPor eq 4>
				<td colspan="8" class="listaCorte"><strong>Tipo solicitud:</strong><cfoutput>#Replace(CMTScodigo,"'","","all")#</cfoutput></td>
			<cfelseif form.AgruparPor eq 3>
				<td class="listaCorte"><strong>Tipo solicitud:</strong><cfoutput>#Replace(CMTScodigo,"'","","all")#</cfoutput></td>
				<td class="listaCorte" align="right"><strong>Ciclo A</strong></td>
				<td class="listaCorte" align="right"><strong>Ciclo B</strong></td>
				<td class="listaCorte" align="right"><strong>Ciclo C</strong></td>
				<td class="listaCorte" align="right"><strong>Ciclo D</strong></td>
				<td class="listaCorte" align="right"><strong>Ciclo E</strong></td>
				<td class="listaCorte" align="right"><strong>Ciclo F</strong></td>
				<td class="listaCorte" align="right"><strong>Total</strong></td>
			</cfif>
		</tr>
		
		<cfif form.AgruparPor eq 4>
			<tr>
				<td style="background-color:#CCCCCC"><strong>Año</strong></td>
				<td style="background-color:#CCCCCC" align="right"><strong>Ciclo A</strong></td>
				<td style="background-color:#CCCCCC" align="right"><strong>Ciclo B</strong></td>
				<td style="background-color:#CCCCCC" align="right"><strong>Ciclo C</strong></td>
				<td style="background-color:#CCCCCC" align="right"><strong>Ciclo D</strong></td>
				<td style="background-color:#CCCCCC" align="right"><strong>Ciclo E</strong></td>
				<td style="background-color:#CCCCCC" align="right"><strong>Ciclo F</strong></td>
				<td style="background-color:#CCCCCC" align="right"><strong>Total</strong></td>
			</tr>
		</cfif>

		<cfset finicial = createdate(aini, minicio, 1)>	<!--- Fecha de inicializacion del rango del reporte --->
		<cfset ffinal = createdate(afin, mfin, 1)>		<!--- Fecha de finalizacion del rango del reporte --->
		<cfset corte=''>								<!--- Corte por año --->

		<cfloop condition="finicial lte ffinal">
		
			<cfset vna = datepart('yyyy',finicial)>		<!--- año inicial --->
			<cfset vni = datepart('m',finicial)>		<!--- mes inicial --->
			<cfset vnDif = 0>
			<cfset vnCant = 0>
			<cfset vnSumaPromedios = 0>
			<cfset vnDifTotal = 0>
			<cfset vnCantTotal = 0>
			
			<cfif corte NEQ vna>
				<cfif form.AgruparPor neq 4>
					<tr>
						<td colspan="8" style="background-color:#CCCCCC"><strong>Año:&nbsp;<cfoutput>#vna#</cfoutput></strong></td>
					</tr>
				</cfif>
				<cfif form.AgruparPor eq 1 or form.AgruparPor eq 2>
					<tr>
						<cfif form.AgruparPor eq 1>
							<td class="titulolistas"><strong>Mes</strong></td>
						<cfelseif form.AgruparPor eq 2>
							<td class="titulolistas"><strong>Trimestre</strong></td>
						</cfif>
						<td class="titulolistas" align="right"><strong>Ciclo A</strong></td>
						<td class="titulolistas" align="right"><strong>Ciclo B</strong></td>
						<td class="titulolistas" align="right"><strong>Ciclo C</strong></td>
						<td class="titulolistas" align="right"><strong>Ciclo D</strong></td>
						<td class="titulolistas" align="right"><strong>Ciclo E</strong></td>
						<td class="titulolistas" align="right"><strong>Ciclo F</strong></td>
						<td class="titulolistas" align="right"><strong>Total</strong></td>
					</tr>
				</cfif>
				<cfset corte = vna>
			</cfif>
			<tr>
				<td>
					<cfif form.AgruparPor eq 1>
						<cfswitch expression="#vni#">
							<cfcase value="1"><cfset vsMes = 'Enero'></cfcase>
							<cfcase value="2"><cfset vsMes  = 'Febrero'></cfcase>
							<cfcase value="3"><cfset vsMes  = 'Marzo'></cfcase>
							<cfcase value="4"><cfset vsMes  = 'Abril'></cfcase>
							<cfcase value="5"><cfset vsMes  = 'Mayo'></cfcase>
							<cfcase value="6"><cfset vsMes  = 'Junio'></cfcase>
							<cfcase value="7"><cfset vsMes  = 'Julio'></cfcase>
							<cfcase value="8"><cfset vsMes  = 'Agosto'></cfcase>
							<cfcase value="9"><cfset vsMes  = 'Setiembre'></cfcase>
							<cfcase value="10"><cfset vsMes  = 'Octubre'></cfcase>
							<cfcase value="11"><cfset vsMes  = 'Noviembre'></cfcase>
							<cfcase value="12"><cfset vsMes  = 'Diciembre'></cfcase>
						</cfswitch>
						<cfoutput>#vsMes#</cfoutput>
					<cfelseif form.AgruparPor eq 2>
						<cfset numeroTrimestre = Int((vni - 1) / divisorAgrupar)>
						<cfset nombreTrimestre = "">
						<cfswitch expression="#numeroTrimestre#">
							<cfcase value="0"><cfset nombreTrimestre = "Primer Trimeste"></cfcase>
							<cfcase value="1"><cfset nombreTrimestre = "Segundo Trimeste"></cfcase>
							<cfcase value="2"><cfset nombreTrimestre = "Tercer Trimeste"></cfcase>
							<cfcase value="3"><cfset nombreTrimestre = "Cuarto Trimeste"></cfcase>
						</cfswitch>
						<cfoutput>#nombreTrimestre#</cfoutput>
					<cfelseif form.AgruparPor eq 3>
						<cfset numeroSemestre = Int((vni - 1) / divisorAgrupar)>
						<cfset nombreSemestre = "">
						<cfswitch expression="#numeroSemestre#">
							<cfcase value="0"><cfset nombreSemestre = "Primer Semestre"></cfcase>
							<cfcase value="1"><cfset nombreSemestre = "Segundo Semestre"></cfcase>
						</cfswitch>
						<cfoutput>#nombreSemestre#</cfoutput>
					<cfelseif form.AgruparPor eq 4>
						<cfoutput>#vna#</cfoutput>
					</cfif>
				</td>
				
				<!--- Ciclo A - Creación de la solicitud hasta finalización del trámite --->
				<td align="right">
					<cfquery name="rsCicloA" datasource="#session.DSN#">
						select 
							coalesce(sum(
								case when a.ProcessInstanceid is null then coalesce(<cf_dbfunction name="datediff" args="a.ESfalta, a.ESfalta">,0) 
									else coalesce(<cf_dbfunction name="datediff" args="a.ESfalta, b.FinishTime">,0) end
							), 0.00) as vnDif,
							coalesce(count(1), 0) as vnCant
							from ESolicitudCompraCM a
								left outer join WfxProcess b
									on a.ProcessInstanceid = b.ProcessInstanceId
									and b.State = 'COMPLETE'
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and a.ESestado = 20
							<cfif isdefined("form.CFid") and len(trim(form.CFid))>
								and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
							</cfif>
							<cfif isdefined("CMTScodigo") and len(trim(CMTScodigo))>
								and a.CMTScodigo = #preservesinglequotes(CMTScodigo)#
							</cfif>
							<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
								and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
							</cfif>
							<cfif (isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0) or (isdefined("form.CCid") and len(trim(form.CCid)) gt 0)>
								and exists (select 1
											from DSolicitudCompraCM ds
												<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0 and isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
													left outer join Articulos art
														on art.Aid = ds.Aid
													left outer join Conceptos conc
														on conc.Cid = ds.Cid
												<cfelseif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0>
													inner join Articulos art
														on art.Aid = ds.Aid
												<cfelseif isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
													inner join Conceptos conc
														on conc.Cid = ds.Cid
												</cfif>
											where ds.ESidsolicitud = a.ESidsolicitud
												<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0 and isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
													and (art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
														or conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
														)
												<cfelseif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0>
													and art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
												<cfelseif isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
													and conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
												</cfif>
											)
							</cfif>
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * #factorAgrupar# + floor((<cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) / #divisorAgrupar#)) = <cfqueryparam cfsqltype="cf_sql_integer" value="#(vna * factorAgrupar + Int((vni - 1) / divisorAgrupar))#">
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoIni * 12 + form.mesIni - 1#">
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoFin * 12 + form.mesFin - 1#">
					</cfquery>
					<cfif rsCicloA.RecordCount NEQ 0>
						<cfset vnCant = 0>
						<cfset vnDif = 0>
						<cfif len(trim(rsCicloA.vnCant)) gt 0 and rsCicloA.vnCant gt 0>
							<cfset vnCant = rsCicloA.vnCant>
							<cfset vnCantTotal = rsCicloA.vnCant>
							<cfset vnDif = rsCicloA.vnDif>
							<cfset vnDifTotal = rsCicloA.vnDif>
						</cfif>
						<cfif vnCant gt 0>
							<cfoutput>#LSNumberFormat(vnDif / vnCant, ',9.00')#</cfoutput>
							<cfset vnSumaPromedios = (vnDif / vnCant)>
						<cfelse>
							---
						</cfif>
					<cfelse>
					---
					</cfif>
				</td>
				
				<!--- Ciclo B - Aprobación de la solicitud hasta publicación --->
				<td align="right">
					<cfquery name="rsCicloB" datasource="#session.DSN#">
						select 
							coalesce(sum(
								case when a.ProcessInstanceid is null then coalesce(<cf_dbfunction name="datediff" args="a.ESfalta,d.fechaalta">,0)
									else coalesce(<cf_dbfunction name="datediff" args="b.FinishTime,d.fechaalta">,0) end
							), 0.00) as vnDif,
							coalesce(count(1), 0) as vnCant
						from ESolicitudCompraCM a 
								left outer join WfxProcess b 
									on a.ProcessInstanceid = b.ProcessInstanceId 
									and b.State = 'COMPLETE' 
									and b.FinishTime is not null 
								inner join DSolicitudCompraCM c 
									on a.Ecodigo = c.Ecodigo 
									and a.ESidsolicitud = c.ESidsolicitud
									
									left outer join Articulos art
										on art.Aid = c.Aid
										
									left outer join Conceptos conc
										on conc.Cid = c.Cid
									
								inner join CMLineasProceso d 
									on c.ESidsolicitud = d.ESidsolicitud 
									and c.DSlinea = d.DSlinea 
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and a.ESestado = 20
							<cfif isdefined("form.CFid") and len(trim(form.CFid))>
								and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
							</cfif>
							<cfif isdefined("CMTScodigo") and len(trim(CMTScodigo))>
								and a.CMTScodigo = #preserveSingleQuotes(CMTScodigo)#
							</cfif>
							<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
								and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
							</cfif>
							<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0 and isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
								and (art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
									or conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
									)
							<cfelseif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0>
								and art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
							<cfelseif isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
								and conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
							</cfif>
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * #factorAgrupar# + floor((<cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) / #divisorAgrupar#)) = <cfqueryparam cfsqltype="cf_sql_integer" value="#(vna * factorAgrupar + Int((vni - 1) / divisorAgrupar))#">
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoIni * 12 + form.mesIni - 1#">
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoFin * 12 + form.mesFin - 1#">
					</cfquery>
					<cfif rsCicloB.RecordCount NEQ 0>
						<cfset vnCant = 0>
						<cfset vnDif = 0>
						<cfif len(trim(rsCicloB.vnCant)) gt 0 and rsCicloB.vnCant gt 0>
							<cfset vnCant = rsCicloB.vnCant>
							<cfset vnCantTotal = vnCantTotal + rsCicloB.vnCant>
							<cfset vnDif = rsCicloB.vnDif>
							<cfset vnDifTotal = vnDifTotal + rsCicloB.vnDif>
						</cfif>
						<cfif vnCant gt 0>
							<cfoutput>#LSNumberFormat(vnDif / vnCant, ',9.00')#</cfoutput>
							<cfset vnSumaPromedios = vnSumaPromedios + (vnDif / vnCant)>
						<cfelse>
							---
						</cfif>
					<cfelse>
					---
					</cfif>
				</td>
				
				<!--- Ciclo C - Publicación hasta el vencimiento en la recepción de ofertas --->
				<td align="right">
					<cfquery name="rsCicloC" datasource="#session.DSN#">
						select 
								coalesce(sum(
									coalesce(<cf_dbfunction name="datediff" args="c.CMPfechapublica, c.CMPfmaxofertas">,0)
								), 0.00) as vnDif,
								coalesce(count(1), 0) as vnCant
						from ESolicitudCompraCM e
								inner join DSolicitudCompraCM a
									on e.Ecodigo = a.Ecodigo
									and e.ESidsolicitud = a.ESidsolicitud
									
									left outer join Articulos art
										on art.Aid = a.Aid
										
									left outer join Conceptos conc
										on conc.Cid = a.Cid
									
								inner join CMLineasProceso d
									on a.ESidsolicitud = d.ESidsolicitud
									and a.DSlinea = d.DSlinea
								inner join CMProcesoCompra c
									on d.CMPid = c.CMPid
									and c.CMPestado = 50
						where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and e.ESestado = 20
							<cfif isdefined("form.CFid") and len(trim(form.CFid))>
								and e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
							</cfif>
							<cfif isdefined("CMTScodigo") and len(trim(CMTScodigo))>
								and e.CMTScodigo = #preserveSingleQuotes(CMTScodigo)#
							</cfif>
							<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
								and e.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
							</cfif>
							<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0 and isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
								and (art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
									or conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
									)
							<cfelseif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0>
								and art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
							<cfelseif isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
								and conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
							</cfif>
							and (<cf_dbfunction name="date_part" args="YY,e.ESfecha"> * #factorAgrupar# + floor((<cf_dbfunction name="date_part" args="MM,e.ESfecha"> - 1) / #divisorAgrupar#)) = <cfqueryparam cfsqltype="cf_sql_integer" value="#(vna * factorAgrupar + Int((vni - 1) / divisorAgrupar))#">
							and (<cf_dbfunction name="date_part" args="YY,e.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,e.ESfecha"> - 1) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoIni * 12 + form.mesIni - 1#">
							and (<cf_dbfunction name="date_part" args="YY,e.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,e.ESfecha"> - 1) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoFin * 12 + form.mesFin - 1#">
					</cfquery>
					<cfif rsCicloC.RecordCount NEQ 0>
						<cfset vnCant = 0>
						<cfset vnDif = 0>
						<cfif len(trim(rsCicloC.vnCant)) gt 0 and rsCicloC.vnCant gt 0>
							<cfset vnCant = rsCicloC.vnCant>
							<cfset vnCantTotal = vnCantTotal + rsCicloC.vnCant>
							<cfset vnDif = rsCicloC.vnDif>
							<cfset vnDifTotal = vnDifTotal + rsCicloC.vnDif>
						</cfif>
						<cfif vnCant gt 0>
							<cfoutput>#LSNumberFormat(vnDif / vnCant, ',9.00')#</cfoutput>
							<cfset vnSumaPromedios = vnSumaPromedios + (vnDif / vnCant)>
						<cfelse>
							---
						</cfif>
					<cfelse>
					---
					</cfif>
				</td>
				
				<!--- Ciclo D - Fecha máxima de publicación hasta registro de la orden de compra --->
				<td align="right">  
				    <cfquery name="rsMaxEOfAlta" datasource="#session.DSN#">
					select coalesce(max(EOfalta),0) as EOfalta
						from EOrdenCM eo
							inner join DOrdenCM do
								on eo.Ecodigo = do.Ecodigo								
						    inner join DSolicitudCompraCM b 
							    on do.Ecodigo = b.Ecodigo 
							    and do.DSlinea = b.DSlinea 
						    inner join ESolicitudCompraCM a
							    on a.Ecodigo = b.Ecodigo 
							    and a.ESidsolicitud = b.ESidsolicitud    
						    left outer join Articulos art 
							    on art.Aid = b.Aid 
						    left outer join Conceptos conc 
							    on conc.Cid = b.Cid 
						    left outer join CMLineasProceso d 
							    on b.ESidsolicitud = d.ESidsolicitud 
						        and b.DSlinea = d.DSlinea 
						    left outer join CMProcesoCompra e 
							    on d.CMPid = e.CMPid 						
						where do.ESidsolicitud = d.ESidsolicitud	
 						        and eo.EOidorden = do.EOidorden
								and eo.EOestado = 10
								and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						    	and a.ESestado = 20
							<cfif isdefined("form.CFid") and len(trim(form.CFid))>
								and a.CFid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
							</cfif>
							<cfif isdefined("CMTScodigo") and len(trim(CMTScodigo))>
								and a.CMTScodigo = #preserveSingleQuotes(CMTScodigo)#
							</cfif>
							<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
								and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
							</cfif>
							<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0 and isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
								and (art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
									or conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
									)
							<cfelseif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0>
								and art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
							<cfelseif isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
								and conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
							</cfif>
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * #factorAgrupar# + floor((<cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) / #divisorAgrupar#)) = <cfqueryparam cfsqltype="cf_sql_integer" value="#(vna * factorAgrupar + Int((vni - 1) / divisorAgrupar))#">
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoIni * 12 + form.mesIni - 1#">
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoFin * 12 + form.mesFin - 1#">										 
					</cfquery>  
	<!---				<cf_dbfunction name="to_date00"	args="#rsMaxEOfAlta.EOfalta#"  returnvariable="LvarMaxEOfalta" >--->
					<cf_dbfunction name="to_datetime"	args="#rsMaxEOfAlta.EOfalta#" YMD="false" datasource="#session.dsn#" returnvariable="LvarMaxEOfalta" >
					<cfquery name="rsCicloD" datasource="#session.DSN#">
						select 
								coalesce(sum(
									coalesce(<cf_dbfunction name="datediff" args="#LSParseDateTime(rsMaxEOfAlta.EOfalta)#, e.CMPfmaxofertas">,0)
								), 0.00) as vnDif,
								coalesce(count(1), 0) as vnCant
						from ESolicitudCompraCM a 
							inner join DSolicitudCompraCM b 
								on a.Ecodigo = b.Ecodigo 
								and a.ESidsolicitud = b.ESidsolicitud 
								
								left outer join Articulos art
									on art.Aid = b.Aid
									
								left outer join Conceptos conc
									on conc.Cid = b.Cid
									
							left outer join CMLineasProceso d 
								on b.ESidsolicitud = d.ESidsolicitud 
								and b.DSlinea = d.DSlinea 
							left outer join CMProcesoCompra e 
								on d.CMPid = e.CMPid 
								and e.CMPestado = 50 
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and a.ESestado = 20
							<cfif isdefined("form.CFid") and len(trim(form.CFid))>
								and a.CFid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
							</cfif>
							<cfif isdefined("CMTScodigo") and len(trim(CMTScodigo))>
								and a.CMTScodigo = #preserveSingleQuotes(CMTScodigo)#
							</cfif>
							<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
								and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
							</cfif>
							<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0 and isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
								and (art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
									or conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
									)
							<cfelseif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0>
								and art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
							<cfelseif isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
								and conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
							</cfif>
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * #factorAgrupar# + floor((<cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) / #divisorAgrupar#)) = <cfqueryparam cfsqltype="cf_sql_integer" value="#(vna * factorAgrupar + Int((vni - 1) / divisorAgrupar))#">
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoIni * 12 + form.mesIni - 1#">
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoFin * 12 + form.mesFin - 1#">
					</cfquery>
					<cfif rsCicloD.RecordCount NEQ 0>
						<cfset vnCant = 0>
						<cfset vnDif = 0>
						<cfif len(trim(rsCicloD.vnCant)) gt 0 and rsCicloD.vnCant gt 0>
							<cfset vnCant = rsCicloD.vnCant>
							<cfset vnCantTotal = vnCantTotal + rsCicloD.vnCant>
							<cfset vnDif = rsCicloD.vnDif>
							<cfset vnDifTotal = vnDifTotal + rsCicloD.vnDif>
						</cfif>
						<cfif vnCant gt 0>
							<cfoutput>#LSNumberFormat(vnDif / vnCant, ',9.00')#</cfoutput>
							<cfset vnSumaPromedios = vnSumaPromedios + (vnDif / vnCant)>
						<cfelse>
							---
						</cfif>
					<cfelse>
					---
					</cfif>
				</td>
				
				<!--- Ciclo E - Aplicación de la orden de compra hasta la aprobación de la orden de compra --->
				<td align="right">
					<cfquery name="rsCicloE" datasource="#session.DSN#">
						select 
							coalesce(sum( 
								case when d.fechamod is null then coalesce(<cf_dbfunction name="datediff" args="d.EOfalta,d.EOfalta">,0) 
									 else coalesce(<cf_dbfunction name="datediff" args="d.EOfalta,d.fechamod">,0)
								end
							), 0.00) as vnDif,
							coalesce(count(1), 0) as vnCant
						from ESolicitudCompraCM a 
							inner join DSolicitudCompraCM b 
								on a.Ecodigo = b.Ecodigo 
								and a.ESidsolicitud = b.ESidsolicitud 
								
								left outer join Articulos art
									on art.Aid = b.Aid
									
								left outer join Conceptos conc
									on conc.Cid = b.Cid
									
							inner join DOrdenCM c 
								on b.Ecodigo = c.Ecodigo 
								and b.ESidsolicitud = c.ESidsolicitud 
								and b.DSlinea = c.DSlinea 
							inner join EOrdenCM d 
								on c.Ecodigo = d.Ecodigo 
								and c.EOidorden = d.EOidorden 
								and d.EOestado = 10 
						where a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and a.ESestado = 20
							<cfif isdefined("form.CFid") and len(trim(form.CFid))>
								and a.CFid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
							</cfif>
							<cfif isdefined("CMTScodigo") and len(trim(CMTScodigo))>
								and a.CMTScodigo = #preserveSingleQuotes(CMTScodigo)#
							</cfif>
							<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
								and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
							</cfif>
							<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0 and isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
								and (art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
									or conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
									)
							<cfelseif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0>
								and art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
							<cfelseif isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
								and conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
							</cfif>
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * #factorAgrupar# + floor((<cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) / #divisorAgrupar#)) = <cfqueryparam cfsqltype="cf_sql_integer" value="#(vna * factorAgrupar + Int((vni - 1) / divisorAgrupar))#">
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoIni * 12 + form.mesIni - 1#">
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoFin * 12 + form.mesFin - 1#">
					</cfquery>
					<cfif rsCicloE.RecordCount NEQ 0>
						<cfset vnCant = 0>
						<cfset vnDif = 0>
						<cfif len(trim(rsCicloE.vnCant)) gt 0 and rsCicloE.vnCant gt 0>
							<cfset vnCant = rsCicloE.vnCant>
							<cfset vnCantTotal = vnCantTotal + rsCicloE.vnCant>
							<cfset vnDif = rsCicloE.vnDif>
							<cfset vnDifTotal = vnDifTotal + rsCicloE.vnDif>
						</cfif>
						<cfif vnCant gt 0>
							<cfoutput>#LSNumberFormat(vnDif / vnCant, ',9.00')#</cfoutput>
							<cfset vnSumaPromedios = vnSumaPromedios + (vnDif / vnCant)>
						<cfelse>
							---
						</cfif>
					<cfelse>
					---
					</cfif>
				</td>
				
				<!--- Ciclo F - Fecha estimada de la recepción hasta fecha de aplicación de la recepción --->
				<td align="right">
					<cfquery name="rsMaxEDRfecharec" datasource="#session.dsn#">
					  select  max(c.EDRfecharec) as EDRfecharec
						from ESolicitudCompraCM e

						inner join DSolicitudCompraCM f
							on e.Ecodigo = f.Ecodigo
							and e.ESidsolicitud = f.ESidsolicitud

						inner join DOrdenCM a
							on f.Ecodigo = a.Ecodigo
							and f.ESidsolicitud = a.ESidsolicitud
							and f.DSlinea = a.DSlinea		

						inner join EOrdenCM d
							on a.Ecodigo = d.Ecodigo
							and a.EOidorden = d.EOidorden
							and d.EOestado = 10

						inner join DDocumentosRecepcion b
							on a.Ecodigo = b.Ecodigo		
							and a.DOlinea = b.DOlinea		

						inner join EDocumentosRecepcion c
							on b.Ecodigo = c.Ecodigo
							and b.EDRid = c.EDRid
							and c.EDRestado = 10
							and c.EOidorden = a.EOidorden	
					   where
						   d.EOidorden = a.EOidorden		
						   and d.EOestado = 10 
					       and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						   and e.ESestado = 20
						   <cfif isdefined("form.CFid") and len(trim(form.CFid))>
								and e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
						   </cfif>
						   <cfif isdefined("CMTScodigo") and len(trim(CMTScodigo))>
								and e.CMTScodigo = #preserveSingleQuotes(CMTScodigo)#
						   </cfif>
						   <cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
								and e.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
						   </cfif>
						   <cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0 and isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
								and (art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
									or conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
									)
							<cfelseif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0>
								and art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
							<cfelseif isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
								and conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
							</cfif>
							and (<cf_dbfunction name="date_part" args="YY,e.ESfecha"> * #factorAgrupar# + floor((<cf_dbfunction name="date_part" args="MM,e.ESfecha"> - 1) / #divisorAgrupar#)) = <cfqueryparam cfsqltype="cf_sql_integer" value="#(vna * factorAgrupar + Int((vni - 1) / divisorAgrupar))#">
							and (<cf_dbfunction name="date_part" args="YY,e.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,e.ESfecha"> - 1) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoIni * 12 + form.mesIni - 1#">
							and (<cf_dbfunction name="date_part" args="YY,e.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,e.ESfecha"> - 1) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoFin * 12 + form.mesFin - 1#">
						   group by c.EOidorden	,EDRfecharec
					</cfquery>		
					<cfif not len(rtrim(rsMaxEDRfecharec.EDRfecharec))>
					   <cfset LvarMaxEDRfecharec = "co.DOfechaes">
					<cfelse>
					   <cfset LvarMaxEDRfecharec = #rsMaxEDRfecharec.EDRfecharec#>
					</cfif>										
					<cfquery name="rsCicloF" datasource="#session.DSN#">
						select 
							coalesce(sum(
							coalesce(<cf_dbfunction name="datediff" args="co.DOfechaes, #LvarMaxEDRfecharec#">,0)
							), 0.00) as vnDif,
							coalesce(count(1), 0) as vnCant
						from ESolicitudCompraCM a 
								inner join DSolicitudCompraCM b 
									on a.Ecodigo = b.Ecodigo 
									and a.ESidsolicitud = b.ESidsolicitud
									
									left outer join Articulos art
										on art.Aid = b.Aid
										
									left outer join Conceptos conc
										on conc.Cid = b.Cid
										
								inner join DOrdenCM co 
									on b.Ecodigo = co.Ecodigo 
									and b.ESidsolicitud = co.ESidsolicitud 
									and b.DSlinea = co.DSlinea 
								inner join EOrdenCM do 
									on co.Ecodigo = do.Ecodigo 
									and co.EOidorden = do.EOidorden 
									and do.EOestado = 10 
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and a.ESestado = 20
							<cfif isdefined("form.CFid") and len(trim(form.CFid))>
								and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
							</cfif>
							<cfif isdefined("CMTScodigo") and len(trim(CMTScodigo))>
								and a.CMTScodigo = #preserveSingleQuotes(CMTScodigo)#
							</cfif>
							<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
								and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
							</cfif>
							<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0 and isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
								and (art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
									or conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
									)
							<cfelseif isdefined("form.Ccodigo") and len(trim(form.Ccodigo)) gt 0>
								and art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
							<cfelseif isdefined("form.CCid") and len(trim(form.CCid)) gt 0>
								and conc.CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
							</cfif>
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * #factorAgrupar# + floor((<cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) / #divisorAgrupar#)) = <cfqueryparam cfsqltype="cf_sql_integer" value="#(vna * factorAgrupar + Int((vni - 1) / divisorAgrupar))#">
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoIni * 12 + form.mesIni - 1#">
							and (<cf_dbfunction name="date_part" args="YY,a.ESfecha"> * 12 + <cf_dbfunction name="date_part" args="MM,a.ESfecha"> - 1) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anoFin * 12 + form.mesFin - 1#">
          			</cfquery>
					<cfif rsCicloF.RecordCount NEQ 0>
						<cfset vnCant = 0>
						<cfset vnDif = 0>
						<cfif len(trim(rsCicloF.vnCant)) gt 0 and rsCicloF.vnCant gt 0>
							<cfset vnCant = rsCicloF.vnCant>
							<cfset vnCantTotal = vnCantTotal + rsCicloF.vnCant>
							<cfset vnDif = rsCicloF.vnDif>
							<cfset vnDifTotal = vnDifTotal + rsCicloF.vnDif>
						</cfif>
						<cfif vnCant gt 0>
							<cfoutput>#LSNumberFormat(vnDif / vnCant, ',9.00')#</cfoutput>
							<cfset vnSumaPromedios = vnSumaPromedios + (vnDif / vnCant)>
						<cfelse>
							---
						</cfif>
					<cfelse>
					---
					</cfif>
				</td>
				
				<!--- Promedio total --->
				<td align="right">
					<cfif vnCantTotal gt 0>
						<cfoutput>#LSNumberFormat(vnSumaPromedios, ',9.00')#</cfoutput>
					<cfelse>
						---
					</cfif>
				</td>
			</tr>
			<cfset finicial = dateadd('m', divisorAgrupar, finicial)>
		</cfloop>
	</cfloop>

	<tr>
		<td colspan="8">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="8"><strong>Ciclo A:</strong> Confecci&oacute;n de solicitud vrs Finalizaci&oacute;n de trámite</td>
	</tr>
	<tr>
		<td colspan="8"><strong>Ciclo B:</strong> Aprobaci&oacute;n de la solicitud vrs Publicaci&oacute;n</td>
	</tr>
	<tr>
		<td colspan="8"><strong>Ciclo C:</strong> Publicaci&oacute;n vrs Vencimiento en la recepci&oacute;n de ofertas</td>
	</tr>
	<tr>
		<td colspan="8"><strong>Ciclo D:</strong> Fecha m&aacute;xima de Publicaci&oacute;n vrs Registro de la orden de compra</td>
	</tr>
	<tr>
		<td colspan="8"><strong>Ciclo E:</strong> Aplicaci&oacute;n de la orden de compra vrs Aprobaci&oacute;n</td>
	</tr>
	<tr>
		<td colspan="8"><strong>Ciclo F:</strong> Fecha estimada de recepci&oacute;n vrs Fecha de aplicaci&oacute;n de la recepci&oacute;n</td>
	</tr>
	<tr>
		<td colspan="8">&nbsp;</td>
	</tr>
</table>
