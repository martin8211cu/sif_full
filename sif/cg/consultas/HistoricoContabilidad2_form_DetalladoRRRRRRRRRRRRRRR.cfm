<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
<cfset javaRT.gc()>

<cfset fnGeneraParamsHistContDet()>
<cfif isdefined("form.chkdownload")>
	<cfset fnProcesaDownloadHistContDet()>
<cfelse>
	<cfset fnPreparaDatosHistContDet()>
	<cfset fnProcesaHistContDet()>
</cfif>

<cffunction name="fnGeneraParamsHistContDet" access="private" output="no">
	<cfset LvarCondicionSaldos = "">
		<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and s.Mcodigo = #varMcodigo#">
		</cfif>
		<cfif isdefined("varOcodigo") and Len(varOcodigo) and varOcodigo NEQ -1>
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and s.Ocodigo = #varOcodigo#">
		</cfif>

		<cfif form.periodo eq form.periodo2>
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and s.Speriodo = #form.periodo# ">
			<cfif form.mes eq form.mes2>
				<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and s.Smes = #form.mes# ">
			<cfelse>
				<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and s.Smes >= #form.mes# and s.Smes <= #form.mes2#">
			</cfif>
		<cfelse>
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and   s.Speriodo >= #form.periodo#">
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and   s.Speriodo <= #form.periodo2#">
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and ((s.Speriodo * 12) + s.Smes >=  #form.periodo  * 12 + form.mes# )">
			<cfset LvarCondicionSaldos = LvarCondicionSaldos & " and ((s.Speriodo * 12) + s.Smes <=  #form.periodo2 * 12 + form.mes2#)">
		</cfif>
		
		<cfset lvarCondicionSaldos = lvarCondicionSaldos & " and (s.SLinicial <> 0  or s.DLdebitos <> 0 or s.CLcreditos <> 0) ">
	
	<cfset LvarCondicion = "">
		<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
			<cfset LvarCondicion = LvarCondicion & " and hd.Mcodigo = #varMcodigo#">
		</cfif>
		<cfif isdefined("varOcodigo") and Len(varOcodigo) and varOcodigo NEQ -1>
			<cfset LvarCondicion = LvarCondicion & " and hd.Ocodigo = #varOcodigo#">
		</cfif>

		<cfif form.periodo eq form.periodo2>
			<cfset LvarCondicion = LvarCondicion & " and hd.Eperiodo = #form.periodo# ">
			<cfif form.mes eq form.mes2>
				<cfset LvarCondicion = LvarCondicion & " and hd.Emes = #form.mes# ">
			<cfelse>
				<cfset LvarCondicion = LvarCondicion & " and hd.Emes >= #form.mes# ">
				<cfset LvarCondicion = LvarCondicion & " and hd.Emes <= #form.mes2#">
			</cfif>
		<cfelse>
			<cfset LvarCondicion = LvarCondicion & " and  hd.Eperiodo >= #form.periodo#">
			<cfset LvarCondicion = LvarCondicion & " and  hd.Eperiodo <= #form.periodo2#">
			<cfset LvarCondicion = LvarCondicion & " and ((hd.Eperiodo * 12) + hd.Emes >=  #form.periodo  * 12 + form.mes#)">
			<cfset LvarCondicion = LvarCondicion & " and ((hd.Eperiodo * 12) + hd.Emes <=  #form.periodo2 * 12 + form.mes2#)">
		</cfif>
	
	<cfset LvarCondicionContable = "">
		<cfif Len(form.Cmayor_Ccuenta1) And Len(form.Cformato1)>
			  <cfset LvarCondicionContable = LvarCondicionContable & " and c.Cformato >= '#form.Cmayor_Ccuenta1#-#form.Cformato1#'">
		<cfelseif Len(form.Cmayor_Ccuenta1) And Len(trim(form.Cformato1)) eq 0>
			  <cfset LvarCondicionContable = LvarCondicionContable & " and c.Cmayor >= '#form.Cmayor_Ccuenta1#'">
		<cfelseif Len(form.Cmayor_Ccuenta1) And not isdefined("form.Cformato1") eq 0>
			  <cfset LvarCondicionContable = LvarCondicionContable & " and c.Cmayor >= '#form.Cmayor_Ccuenta1#'">
		</cfif>
	
		<cfif Len(form.Cmayor_Ccuenta2) And Len(form.Cformato2)>
			  <cfset LvarCondicionContable = LvarCondicionContable & " and c.Cformato <= '#form.Cmayor_Ccuenta2#-#form.Cformato2#'">
		<cfelseif Len(form.Cmayor_Ccuenta2) And Len(trim(form.Cformato2)) eq 0>
			  <cfset LvarCondicionContable = LvarCondicionContable & " and c.Cmayor <= '#form.Cmayor_Ccuenta2#'">
		<cfelseif Len(form.Cmayor_Ccuenta2) And not isdefined("form.Cformato2") eq 0>
			  <cfset LvarCondicionContable = LvarCondicionContable & " and c.Cmayor <= '#form.Cmayor_Ccuenta2#'">
		</cfif>
	
	<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t" />
	<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
	<cfset LvarFileName = "HistoricoContablidadGeneral#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	
	<cfquery name="rsCuentas" datasource="#session.dsn#">
		select c.Cformato, c.Ccuenta, c.Cdescripcion
		from CContables c
		where c.Ecodigo = #session.Ecodigo#
		  and c.Cmovimiento = 'S'
		  and c.Cformato <> c.Cmayor
		#PreserveSingleQuotes(LvarCondicionContable)#
		  and ((
				select count(1)
				from SaldosContables s
				where s.Ccuenta = c.Ccuenta
				  and s.Ecodigo = #session.Ecodigo#
				#LvarCondicionSaldos#
				) > 0 )
		order by c.Cformato
	</cfquery>

	<cfset Lvarmes=''>
	<cfswitch expression="#form.mes#">
		<cfcase value="1"><cfset Lvarmes='Enero'></cfcase>
		<cfcase value="2"><cfset Lvarmes='Febrero'></cfcase>
		<cfcase value="3"><cfset Lvarmes='Marzo'></cfcase>
		<cfcase value="4"><cfset Lvarmes='Abril'></cfcase>
		<cfcase value="5"><cfset Lvarmes='Mayo'></cfcase>
		<cfcase value="6"><cfset Lvarmes='Junio'></cfcase>
		<cfcase value="7"><cfset Lvarmes='Julio'></cfcase>
		<cfcase value="8"><cfset Lvarmes='Agosto'></cfcase>
		<cfcase value="9"><cfset Lvarmes='Septiembre'></cfcase>
		<cfcase value="10"><cfset Lvarmes='Octubre'></cfcase>
		<cfcase value="11"><cfset Lvarmes='Noviembre'></cfcase>
		<cfcase value="12"><cfset Lvarmes='Diciembre'></cfcase>
	</cfswitch>
	
	<cfset Lvarmes2=''>
	<cfswitch expression="#form.mes2#">
		<cfcase value="1"><cfset Lvarmes2='Enero'></cfcase>
		<cfcase value="2"><cfset Lvarmes2='Febrero'></cfcase>
		<cfcase value="3"><cfset Lvarmes2='Marzo'></cfcase>
		<cfcase value="4"><cfset Lvarmes2='Abril'></cfcase>
		<cfcase value="5"><cfset Lvarmes2='Mayo'></cfcase>
		<cfcase value="6"><cfset Lvarmes2='Junio'></cfcase>
		<cfcase value="7"><cfset Lvarmes2='Julio'></cfcase>
		<cfcase value="8"><cfset Lvarmes2='Agosto'></cfcase>
		<cfcase value="9"><cfset Lvarmes2='Septiembre'></cfcase>
		<cfcase value="10"><cfset Lvarmes2='Octubre'></cfcase>
		<cfcase value="11"><cfset Lvarmes2='Noviembre'></cfcase>
		<cfcase value="12"><cfset Lvarmes2='Diciembre'></cfcase>
	</cfswitch>
</cffunction>

<cffunction name="fnProcesaDownloadHistContDet" access="private" output="yes">
	<!--- Exporta excel --->
	<cfif findnocase('MSIE ',CGI.HTTP_USER_AGENT,1) neq 0>
		<cfcontent type="application/vnd.ms-excel">
	<cfelse>
		<cfcontent type="application/msexcel">
	</cfif>
	<cfheader name="Content-Disposition" value="attachment; filename=#LvarFileName#">
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
	<cfflush interval="64">
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td align="left"><strong>Empresa</strong></td>
			<td align="left"><strong>Cuenta</strong></td>
			<td align="right"><strong>Per&iacute;odo</strong></td>
			<td align="right"><strong>Mes</strong></td>
			<td align="left"><strong>Descripci&oacute;nCuenta</strong></td>
			<td align="left"><strong>Concepto</strong></td>
			<td align="left"><strong>P&oacute;liza</strong></td>
			<td align="left"><strong>DocumentoAsiento</strong></td>
			<td align="left"><strong>FechaAsiento</strong></td>
			<td align="left"><strong>Oficina</strong></td>
			<td align="left"><strong>Origen</strong></td>
			<td align="left"><strong>Documento</strong></td>
			<td align="left"><strong>Referencia</strong></td>
			<td align="left"><strong>Descripci&oacute;n</strong></td>
			<td align="right"><strong>MontoOriginal</strong></td>
			<td align="left"><strong>Moneda</strong></td>
			<td align="right"><strong>D&eacute;bitos</strong></td>
			<td align="right"><strong>Cr&eacute;ditos</strong></td>
		</tr>
		<cfloop query="rsCuentas">
			<cfset _LvarCcuenta = rsCuentas.Ccuenta>
			<cfquery name="data" datasource="#session.dsn#">
				select			
					hd.Eperiodo, hd.Emes, he.Efecha, hd.Ddocumento,
					he.Edocbase as docAsiento,
					hd.Edocumento as poliza,
					he.Oorigen,
					hd.Doriginal,
					m.Miso4217,
					hd.Ddescripcion, hd.Dreferencia, he.Ereferencia,
					hd.Dlocal, hd.Dmovimiento,
					hd.Cconcepto, hd.Ocodigo,
					o.Oficodigo
				from HDContables hd
					inner join HEContables he
						on he.IDcontable = hd.IDcontable
					inner join Oficinas o
						on  o.Ecodigo = hd.Ecodigo
						and o.Ocodigo = hd.Ocodigo
					inner join Monedas m
						on m.Mcodigo = hd.Mcodigo
				where hd.Ccuenta = #_LvarCcuenta#
				  #LvarCondicion#
				<cfif not LvarCHKMesCierre>
					and he.ECtipo <> 1
				<cfelse>
					and he.ECtipo = 1
				</cfif>
				<cfif isdefined("form.ckOrdenXMonto") and form.ckOrdenXMonto EQ 1>
					order by o.Oficodigo, hd.Eperiodo, hd.Emes, hd.Dlocal desc, he.Efecha, hd.Ddescripcion 
				<cfelse>
					order by o.Oficodigo, hd.Eperiodo, hd.Emes, he.Efecha, hd.Ddescripcion 
				</cfif>
			</cfquery>
			<cfoutput query="data">
				<tr>
					<td align="left">#session.Enombre#</td>
					<td align="left">#rsCuentas.Cformato#</td>
					<td align="right">#Eperiodo#</td>
					<td align="right">#Emes#</td>
					<td align="left">#rsCuentas.Cdescripcion#</td>
					<td align="left">#Cconcepto#</td>
					<td align="left">#poliza#</td>
					<td align="left">#docAsiento#</td>
					<td align="left">#DateFormat(Efecha,'yyyy-mm-dd')#</td>
					<td align="left">#ofiCodigo#</td>
					<td align="left">#Oorigen#</td>
					<td align="left">#Ddocumento#</td>
					<td align="left">#Dreferencia#</td>
					<td align="left">#Ddescripcion#</td>
					<td align="right">#NumberFormat(dOriginal, ',0.00')#</td>
					<td align="left">#Miso4217#</td>
					<td align="right"><cfif Dmovimiento is 'D'>#NumberFormat(Dlocal, ',0.00')#</cfif></td>
					<td align="right"><cfif Dmovimiento is 'C'>#NumberFormat(Dlocal, ',0.00')#</cfif></td>
				</tr>
			</cfoutput>
		</cfloop>
	</table>
</cffunction>

<cffunction name="fnPreparaDatosHistContDet" access="private" output="no" hint="Prepara la Informacion para Procesar el Reporte">
	<!---Tabla temporal para guardar las sumatorias por oficina ------>
	<cf_dbtemp name="saldosHCDv1" returnvariable="saldos" datasource="#session.dsn#">
		<cf_dbtempcol name="ccuenta"  			type="numeric" 		mandatory="yes">
		<cf_dbtempcol name="ecodigo"  			type="integer" 		mandatory="yes">
		<cf_dbtempcol name="ocodigo"		    type="integer"	 	mandatory="yes">		
		<cf_dbtempcol name="mcodigo"    		type="numeric"	 	mandatory="yes">
		<cf_dbtempcol name="saldoinicial"  		type="Money"	 	mandatory="no">
		<cf_dbtempcol name="debitos"	  		type="Money"	 	mandatory="no">
		<cf_dbtempcol name="creditos"  			type="Money"	 	mandatory="no">
		<cf_dbtempcol name="movimientos"  		type="Money"	 	mandatory="no">
		<cf_dbtempcol name="saldofinal"  		type="Money"	 	mandatory="no">
		<cf_dbtempkey cols="ccuenta,ocodigo,mcodigo">
	</cf_dbtemp>
		
	<!---Cargar tabla temporal con todas las cuentas que se requieren en la consulta---->
	<cfquery datasource="#session.DSN#">
		insert into #saldos# (	ccuenta, ecodigo, ocodigo, mcodigo,
								saldoinicial, debitos, creditos, movimientos, saldofinal)
		select 	distinct s.Ccuenta, s.Ecodigo, s.Ocodigo,
				<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
					 #varMcodigo#,
				<cfelse>
					-1,
				</cfif>			
				0.00, 0.00, 0.00, 0.00, 0.00
		from SaldosContables s
			inner join CContables c
				on c.Ccuenta = s.Ccuenta
		where s.Ecodigo = #session.Ecodigo#
		  #LvarCondicionSaldos#
		  and c.Cmovimiento = 'S'
		  and c.Cmayor <> c.Cformato
		  #PreserveSingleQuotes(LvarCondicionContable)#
	</cfquery>

	<!----Actualizar saldos ----->
	<cfquery datasource="#session.DSN#"><!---Saldo Inicial ---->
		update #saldos#
		set saldoinicial = coalesce
			((select sum(SLinicial)
				from SaldosContables s
				where s.Ccuenta    	= #saldos#.ccuenta
				   and s.Speriodo   = #form.periodo#
				   and s.Smes       = #form.mes#
				   and s.Ocodigo  	= #saldos#.ocodigo
					<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
					   and s.Mcodigo = #saldos#.mcodigo
					</cfif>		  
			), 0.00)
	</cfquery>
	
	<cfif not LvarCHKMesCierre>
		<cfquery datasource="#session.DSN#"><!---Debitos---->
			update #saldos#
			set debitos = coalesce
				((select sum(DLdebitos)
					from SaldosContables s
					where s.Ccuenta    = #saldos#.ccuenta
					   and s.Speriodo >= #form.periodo#
					   and s.Speriodo <= #form.periodo2#
					   and s.Ecodigo   = #session.Ecodigo#
					   and s.Ocodigo  = #saldos#.ocodigo
						<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
							and s.Mcodigo = #saldos#.mcodigo
						</cfif>			  
					   and s.Speriodo * 12 + s.Smes between #form.periodo * 12 + form.mes# and #form.periodo2 * 12 + form.mes2#
				), 0.00)
		</cfquery>
		<cfquery datasource="#session.DSN#"><!---Creditos ----->
			update #saldos#
			set creditos = coalesce
				((select sum(CLcreditos)
					from SaldosContables s
					where s.Ccuenta    = #saldos#.ccuenta
					   and s.Speriodo >= #form.periodo#
					   and s.Speriodo <= #form.periodo2#
					   and s.Ecodigo   = #session.Ecodigo#
					   and s.Ocodigo  = #saldos#.ocodigo	
					   <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
						 and s.Mcodigo = #saldos#.mcodigo
					   </cfif>		  
					   and s.Speriodo * 12 + s.Smes between #form.periodo * 12 + form.mes# and #form.periodo2 * 12 + form.mes2#
				), 0.00)
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.DSN#"><!---Debitos Cierre Anual---->
			update #saldos#
				set debitos =
					coalesce((
							select sum(Dlocal) 
							from HDContables h 
									inner join HEContables e
										on e.IDcontable = h.IDcontable
							where h.Ccuenta  	= #saldos#.Ccuenta
							  and h.Ocodigo 	= #saldos#.ocodigo
							  and h.Eperiodo 	= #form.Periodo#
							  and h.Emes     	= #form.mes#
							  <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
								and h.Mcodigo 	= #saldos#.mcodigo
							  </cfif>	
							  and h.Dmovimiento = 'D'
							  and e.ECtipo = 1
							), 0.00)
		</cfquery>
		<cfquery datasource="#session.DSN#"><!---Creditos Cierre Anual ----->
			update #saldos#
				set creditos =
					coalesce((
							select sum(Dlocal) 
							from HDContables h 
									inner join HEContables e
										on e.IDcontable = h.IDcontable
							where h.Ccuenta  	= #saldos#.Ccuenta
							  and h.Ocodigo 	= #saldos#.ocodigo
							  and h.Eperiodo 	= #form.Periodo#
							  and h.Emes     	= #form.mes#
							  <cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
								and h.Mcodigo 	= #saldos#.mcodigo
							  </cfif>	
							  and h.Dmovimiento = 'C'
							  and e.ECtipo = 1
							), 0.00)
		</cfquery>
	</cfif>
	<cfquery datasource="#session.DSN#"><!---- Movimientos ---->
		update #saldos#
		set movimientos = debitos - creditos, 
		saldofinal = saldoinicial + debitos - creditos
	</cfquery>
</cffunction>


<cffunction name="fnLecturaCtaHistContDet" access="private" output="no" returntype="numeric">
	<cfargument name="Ccuenta" type="numeric" required="yes">
	<cfset TotalDebitos = 0>
	<cfset TotalCreditos = 0>
	<cfquery name="rsSaldosCuentaI" datasource="#session.DSN#">
		select sum(s.saldoinicial) as SaldoInicial
		from #saldos# s
		where s.ccuenta = #Arguments.Ccuenta#
		<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
		  and s.mcodigo = #varMcodigo#
		</cfif>
		<cfif isdefined("varOcodigo") and Len(varOcodigo) and varOcodigo NEQ -1>
		  and s.ocodigo = #varOcodigo#
		</cfif>
	</cfquery>
	<cfquery name="rsSaldosCuentaF" datasource="#session.DSN#">
		select sum(s.saldoinicial + s.debitos - s.creditos) as SaldoFinal
		from #saldos# s
		where s.ccuenta = #Arguments.Ccuenta#
		<cfif isdefined("varMcodigo") and Len(varMcodigo) and varMcodigo NEQ -1>
		  and s.mcodigo = #varMcodigo#
		</cfif>
		<cfif isdefined("varOcodigo") and Len(varOcodigo) and varOcodigo NEQ -1>
		  and s.ocodigo = #varOcodigo#
		</cfif>
	</cfquery>
	<cfif isdefined("rsSaldosCuentaI") and rsSaldosCuentaI.Recordcount GT 0>
		<cfset LvarSLinicial = rsSaldosCuentaI.SaldoInicial>
	</cfif>
	<cfif isdefined("rsSaldosCuentaF") and rsSaldosCuentaF.Recordcount GT 0>
		<cfset LvarSLfinal = rsSaldosCuentaF.SaldoFinal>
	</cfif>
	<cfquery name="rsOficinasCuenta" datasource="#session.dsn#">
		select 
			o.Oficodigo, 
			o.Ocodigo,
			min(o.Odescripcion) as Odescripcion,
			sum(saldoinicial) as saldoinicial, 
			sum(debitos) as debitos, 
			sum(creditos) as creditos, 
			sum(saldofinal) as saldofinal
		from #saldos# s
			inner join Oficinas o
			on o.Ecodigo = s.ecodigo
			and o.Ocodigo = s.ocodigo
		where s.ccuenta = #Arguments.Ccuenta#
		group by o.Oficodigo, o.Ocodigo
		order by o.Oficodigo
	</cfquery>
	<cfreturn rsOficinasCuenta.recordcount>
</cffunction>
<cffunction name="fnProcessLineHistContDet" access="private" output="no" hint="Procesa los registros de una Oficina - Cuenta">
	<cfargument name="Ccuenta"  type="numeric" required="yes">
	<cfargument name="Ocodigo" type="numeric" required="yes">

	<cfset _LvarOcodigo 		= Arguments.Ocodigo>
	<cfset TotalDebitos 		= TotalDebitos + rsOficinasCuenta.debitos>
	<cfset TotalCreditos 	 	= TotalCreditos + rsOficinasCuenta.creditos>
	<cfset _LvarOdescripcion 	= rsOficinasCuenta.Odescripcion>
	<cfset _LvarDebitos 		= rsOficinasCuenta.debitos>
	<cfset _LvarCreditos 		= rsOficinasCuenta.Creditos>
	<cfset _LvarSaldoFinal		= rsOficinasCuenta.saldofinal>
	<cfset _LvarSaldoInicial	= rsOficinasCuenta.saldoinicial>
	<cfquery name="data" datasource="#session.dsn#">
		select			
			hd.Eperiodo, 	hd.Emes,			he.Efecha, 		
			m.Miso4217, 	hd.Ddescripcion, 	hd.Dreferencia, 
			he.Oorigen,  	hd.Doriginal,		he.Ereferencia,
			hd.Dlocal, 		hd.Dmovimiento, 	hd.Cconcepto,
			hd.Ddocumento, 	
			hd.Edocumento as poliza,
			he.Edocbase as docAsiento
		from HDContables hd
			inner join HEContables he
				on he.IDcontable = hd.IDcontable
			inner join Monedas m
				on m.Mcodigo = hd.Mcodigo
		where hd.Ccuenta = #Arguments.Ccuenta#
		  and hd.Ocodigo = #Arguments.Ocodigo#
		  #LvarCondicion#
		<cfif not LvarCHKMesCierre>
			and he.ECtipo <> 1
		<cfelse>
			and he.ECtipo = 1
		</cfif>
		<cfif isdefined("form.ckOrdenXMonto") and form.ckOrdenXMonto EQ 1>
			order by hd.Eperiodo, hd.Emes, hd.Dlocal desc, he.Efecha, hd.Ddescripcion 
		<cfelse>
			order by hd.Eperiodo, hd.Emes, he.Efecha, hd.Ddescripcion 
		</cfif>
	</cfquery>
</cffunction>


<cffunction name="fnProcesaHistContDet" access="private" output="yes">
	<style type="text/css">
		* { font-size:11px; font-family:Verdana, Arial, Helvetica, sans-serif }
		.niv1 { font-size: 18px; }
		.niv2 { font-size: 16px; }
		.niv3 { font-size: 12px; }
		.niv4 { font-size: 10px; }
	</style>	
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td colspan="17" align="right">
				<cf_htmlreportsheaders
					title="Histórico de Contabilidad General Resumido" 
					filename="#LvarFileName#" 
					ira="HistoricoContabilidad.cfm">
			</td>
		</tr>
	</table>
	<cfflush interval="64">
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<cfoutput>
	<tr>
		<td colspan="6"> #DateFormat(Now(),'dd-mm-yyyy')#</td>
		<td colspan="5">&nbsp;</td>
		<td colspan="6" align="right">#TimeFormat(Now(), 'HH:mm:ss')#</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
		<td colspan="13" align="center" style="font-size:18px">#HTMLEditFormat(session.Enombre)#</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
		<td colspan="13" align="center" style="font-size:16px">Consulta Hist&oacute;rico de Contabilidad General</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;&nbsp;</td>
		<td colspan="13" align="center" style="font-size:12px">Oficina: &nbsp;#NombreOficina#</td>
		<td>&nbsp;</td>
	</tr>
	
	<tr>
		<td colspan="3">&nbsp;</td>
		<td colspan="13" align="center">Desde: #form.periodo#&nbsp;#Lvarmes#&nbsp;&nbsp;&nbsp;Hasta: #form.periodo2#&nbsp;#Lvarmes2#</td>
		<td colspan="1">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="17">&nbsp;</td>
	</tr>
	</cfoutput>
	<cfloop query="rsCuentas">
		<cfset _LvarCcuenta      = rsCuentas.Ccuenta> 
		<cfset _LvarCdescripcion = rsCuentas.Cdescripcion> 
		<cfset _LvarCformato     = rsCuentas.Cformato>
		<cfset _LvarCantidadReg	 = fnLecturaCtaHistContDet(_LvarCcuenta)>
		<tr>
			<cfoutput>
			<td colspan="14"><strong>Cuenta: #_LvarCformato# #_LvarCdescripcion# </strong></td>		 
			<td align="right" nowrap="nowrap"><strong>Saldo Inicial:</strong></td>
			<td>&nbsp;&nbsp;</td>
			<td align="right" nowrap="nowrap"><strong>#NumberFormat(LvarSLinicial, '(,0.00)')#</strong></td>
			</cfoutput>
		</tr>
		<cfloop query="rsOficinasCuenta">
			<cfset fnProcessLineHistContDet(_LvarCcuenta, rsOficinasCuenta.Ocodigo)>
			<cfoutput>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>&nbsp;</td>	<td>&nbsp;&nbsp;&nbsp;</td>	<td colspan="12"><strong>Oficina: #_LVarOdescripcion# </strong></td>
				<td align="right"><strong>Saldo Inicial:</strong></td> <td>&nbsp;&nbsp;</td>
				<td align="right">#NumberFormat(_Lvarsaldoinicial, '(,0.00)')#</td>
			</tr>
			<tr>
				<td>&nbsp;</td> <td>&nbsp;</td> <td>&nbsp;&nbsp;&nbsp;</td>
				<td align="center"><strong>A&ntilde;o</strong></td>
				<td align="center"><strong>Mes</strong></td>
				<td align="center"><strong>Fecha</strong></td>
				<td align="center">&nbsp;</td>
				<td ><strong>Descripci&oacute;n</strong></td>
				<td>&nbsp;</td>
				<td><strong>Referencia</strong></td>
				<td>&nbsp;</td>
				<td><strong>Documento</strong></td>
				<td align="right">&nbsp;<strong>Lote</strong>&nbsp;</td>
				<td align="right"><strong>#PolizaE#</strong></td>
				<td align="right"><strong>D&eacute;bitos&nbsp;</strong></td>
				<td>&nbsp;&nbsp;</td>
				<td align="right"><strong>Cr&eacute;ditos&nbsp;</strong></td>
			</tr>
			</cfoutput>
			<cfoutput query="data">
				<tr class="<cfif (CurrentRow) Mod 2>listaPar<cfelse>listaNon</cfif>">
				<td>&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;</td>
				<td align="center" class="niv4">#Eperiodo#</td>
				<td align="center"  class="niv4">#Emes#</td>
				<td align="center" class="niv4">#DateFormat(Efecha,'dd/mm/yyyy')#</td>
				<td>&nbsp;</td>
				<td class="niv4">#HTMLEditFormat(Ddescripcion)#</td>
				<td  class="niv4">&nbsp;</td>
				<td class="niv4">#HTMLEditFormat(Dreferencia)#</td>
				<td>&nbsp;</td>
				<td class="niv4">#HTMLEditFormat(Ddocumento)#</td>
				<td align="right" class="niv4">#Cconcepto#&nbsp;</td>
				<td align="right" class="niv4">#poliza#</td>
				<td align="right" class="niv4"><cfif Dmovimiento is 'D'>#NumberFormat(Dlocal, ',0.00')#</cfif></td>
				<td>&nbsp;&nbsp;</td>
				<td align="right" class="niv4"><cfif Dmovimiento is 'C'>#NumberFormat(Dlocal, ',0.00')#</cfif></td>
				</tr>
			</cfoutput>
			<!--- Total por Oficina dentro de una Cuenta --->
			<cfoutput>
			<tr>
				<td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
				<td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
				<td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
				<td colspan="11" valign="bottom"><strong>Total #_LvarOdescripcion#: </strong></td>
				<td align="right" valign="bottom"><hr>#NumberFormat(_Lvardebitos, '(,0.00)')#</td>
				<td valign="bottom">&nbsp;&nbsp;</td>
				<td align="right" valign="bottom"><hr>#NumberFormat(_Lvarcreditos, '(,0.00)')#</td>
			</tr>
			<tr>
				<td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
				<td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
				<td valign="bottom">&nbsp;&nbsp;&nbsp;</td>
				<td colspan="13" valign="bottom"><strong>Saldo Final #_LvarOdescripcion#: </strong></td>
				<td align="right" valign="bottom">#NumberFormat(_Lvarsaldofinal, '(,0.00)')#</td>
			</tr>
			</cfoutput>
            <!--- Limpieza de querys de la función fnProcessLineHistContDet: data --->
            <cfset data = javacast("null","")>
		</cfloop>
		<!--- Total por Cuenta --->
		<cfoutput>
			<tr>
				<td colspan="14" valign="bottom"><strong>Total Cuenta #_LvarCformato# #_LvarCdescripcion#: </strong></td>
				<td align="right" valign="bottom"><hr><strong>#NumberFormat(TotalDebitos, '(,0.00)')#</strong></td>
				<td valign="bottom">&nbsp;&nbsp;</td>
				<td align="right" valign="bottom"><hr><strong>#NumberFormat(TotalCreditos, '(,0.00)')#</strong></td>
			</tr>
			<tr>
				<td colspan="16" valign="bottom"><strong>Saldo Final #_LvarCformato# #_LvarCdescripcion#:</strong></td>
				<td align="right" valign="bottom"><strong>#NumberFormat(LvarSLfinal, '(,0.00)')#</strong></td>
			</tr>
			<tr>
				<td colspan="17" valign="bottom">&nbsp;</td>
			</tr>
		</cfoutput>
        
        <!--- Limpieza de querys de función fnLecturaCtaHistContDet: rsSaldosCuentaI, rsSaldosCuentaF, rsOficinasCuenta --->
        <cfset rsSaldosCuentaI  = javacast("null","")>
        <cfset rsSaldosCuentaF  = javacast("null","")>
        <cfset rsOficinasCuenta = javacast("null","")>
		<cfset javaRT.gc()>
	</cfloop>
		<tr><td colspan="17" align="center">----------------------------------- Fin de la Consulta -----------------------------------</td></tr>
	</table>
</cffunction>
