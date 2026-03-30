<cfsetting 	requesttimeout="36000"
			enablecfoutputonly="yes">

<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cfparam name="form.CPPid" default="#session.CPPid#">
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cfset LvarLineasPagina = 45>

<cftry>
	<cfif false>
		<cfset LvarCF = "">
	<cfelseif isdefined("form.CFid") AND form.CFid NEQ "" AND form.CFid GT 0>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select CFdescripcion 
			  from CFuncional 
			 where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		</cfquery>
		<cfset LvarCF = "Cuentas del Centro Funcional: #rsSQL.CFdescripcion#">
	<cfelseif isdefined("form.CFid") AND form.CFid EQ -100>
		<cfset LvarCF = "Todas las cuentas permitidas para el usuario">
	<cfelse>
		<cfset LvarCF = "">
	</cfif>

	<cfif not isdefined("session.rptRnd")><cfset session.rptRnd = int(rand()*10000)></cfif>
	<cfif isdefined("form.btnCancelar")>
		<cfset session.rptDetallesNAP_Cancel = true>
		<cflocation url="rptDetallesNAP.cfm">
		<cfabort>	
	</cfif>
    
    <cfinclude template="../../Utiles/sifConcat.cfm">
	<cflock timeout="1" name="rptDetallesNAP_#session.rptRnd#" throwontimeout="yes">
		<cfset structDelete(session, "rptDetallesNAP_Cancel")>

		<cfquery name="rsPeriodo" datasource="#Session.DSN#">
			select CPPid, 
				   CPPtipoPeriodo, 
				   CPPfechaDesde, 
				   CPPfechaHasta, 
				   CPPfechaUltmodif, 
				   CPPestado,
				   'Presupuesto ' #_Cat#
						case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat# 
							case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
							#_Cat# ' a ' #_Cat# 
							case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
					as CPPdescripcion
			from CPresupuestoPeriodo p
			where p.Ecodigo = #Session.Ecodigo#
			  and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
		</cfquery>
		
		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
		<cfset LvarCPPid = form.CPPid>
		<cfset LvarPAg = 1>  
		<cfset LvarContL = 5>  
		<cfset LvarMeses = arrayNew(1)>
		<cfset LvarMeses[1] = "ENERO">
		<cfset LvarMeses[2] = "FEBRERO">
		<cfset LvarMeses[3] = "MARZO">
		<cfset LvarMeses[4] = "ABRIL">
		<cfset LvarMeses[5] = "MAYO">
		<cfset LvarMeses[6] = "JUNIO">
		<cfset LvarMeses[7] = "JULIO">
		<cfset LvarMeses[8] = "AGOSTO">
		<cfset LvarMeses[9] = "SETIEMBRE">
		<cfset LvarMeses[10] = "OCTUBRE">
		<cfset LvarMeses[11] = "NOVIEMBRE">
		<cfset LvarMeses[12] = "DICIEMBRE">
		
		
		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
		<cfset LvarOorigen = form.Oorigen>
		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
		<cfset LvarTipoMov = form.CPTpoMov>
		<cfif LvarTipoMov EQ "0">
			<cfset LvarTipoMov = "">
		<cfelseif LvarTipoMov EQ "1">
			<cfset LvarTipoMov = "CPLCresultado = 0">
		<cfelseif LvarTipoMov EQ "2">
			<cfset LvarTipoMov = "CPLCresultado <> 0">
		<cfelseif LvarTipoMov EQ "3">
			<cfset LvarTipoMov = "CPLCresultado = 1">
		<cfelseif LvarTipoMov EQ "4">
			<cfset LvarTipoMov = "CPLCresultado = 2">
		</cfif>
		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
		<cfset LvarValor1 = evaluate("form.CPformato1")>
		<cfset LvarValor2 = evaluate("form.CPformato2")>
		<cfset LvarCPformato = "">
		<cfif LvarValor1 NEQ "">
			<cfif LvarValor2 EQ "">
				<cfset LvarCPformato = " and c.CPformato = '#LvarValor1#'">
			<cfelse>
				<cfset LvarCPformato = " and c.CPformato >= '#LvarValor1#' and c.CPformato <= '#LvarValor2 & chr(255)#'">
			</cfif>
		</cfif>
		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
		<cfset LvarOcodigo = "">
		<cfif LvarValor1 NEQ "">
			<cfif LvarValor2 EQ "">
				<cfset LvarCPformato = " and c.CPformato = '#LvarValor1#'">
			<cfelse>
				<cfset LvarCPformato = " and c.CPformato >= '#LvarValor1#' and c.CPformato <= '#LvarValor2 & chr(255)#'">
			</cfif>
		</cfif>
		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
		<cfquery name="rsListaLiquidacion" datasource="#Session.DSN#">
			Select 
				a.CPNAPnum,
				b.CPNAPmoduloOri as Modulo,
				b.CPNAPdocumentoOri as Documento,
				<cf_dbfunction name='sPart' args='b.CPNAPreferenciaOri,1,15'> as DocReferencia,
				b.CPNAPfechaOri as FechaDoc,
				b.CPNAPfecha as FechaAutorizacion,
				a.CPNAPDlinea, 
				<cf_dbfunction name="to_char" args="a.CPCano"> #_Cat# '-' #_Cat#
				case a.CPCmes when 1 then 'ENE' when 2 then 'FEB' when 3 then 'MAR' when 4 then 'ABR' when 5 then 'MAY' when 6 then 'JUN' when 7 then 'JUL' when 8 then 'AGO' when 9 then 'SET' when 10 then 'OCT' when 11 then 'NOV' when 12 then 'DIC' else '' end as Mes,
				c.CPformato as CuentaPresupuesto, coalesce(c.CPdescripcionF, c.CPdescripcion) as Descripcion,
				o.Oficodigo as Oficina,
				case a.CPCPtipoControl
					when 0 then 'Abierto'
					when 1 then 'Restringido'
					when 2 then 'Restrictivo'
					else ''
				end as TipoControl, 
				case a.CPCPcalculoControl
					when 1 then 'Mensual'
					when 2 then 'Acumulado'
					when 3 then 'Total'
					else ''
				end as CalculoControl,
				case 
					when a.CPPid <> ln.CPPid then 'SI'
				end as PeriodoAnterior,
							(case a.CPNAPDtipoMov
								when 'A'  	then 'Presupuesto<BR>Ordinario'
								when 'M'  	then 'Presupuesto<BR>Extraordinario'
								when 'ME'  	then 'Excesos<BR>Autorizados'
								when 'VC' 	then 'Variación<BR>Cambiaria'
								when 'T'  	then 'Traslado'
								when 'TE'  	then 'Traslado<BR>Aut.Externa'
								when 'RA' 	then 'Reserva<BR>Per.Ant.'
								when 'CA' 	then 'Compromiso<BR>Per.Ant.'
								when 'RP' 	then 'Provisión<BR>Presupuestaria'
								when 'RC' 	then 'Reserva'
								when 'CC' 	then 'Compromiso'
								when 'E'  	then 'Ejecución'
								when 'E2'  	then 'Ejecución<BR>No Contable'
								WHEN 'EJ' 	THEN 'Ejercido'
								WHEN 'P'  	THEN 'Pagado'
								else a.CPNAPDtipoMov
							end) as TipoMovimiento,
				a.CPNAPDmonto as Monto,
				a.CPNAPDmonto-a.CPNAPDutilizado -
					coalesce((
						select sum(f.CPNAPDmonto)
						  from CPNAPdetalle f
						 where f.Ecodigo 		= a.Ecodigo
						   and f.CPNAPnumRef	= a.CPNAPnum
						   and f.CPNAPDlineaRef	= a.CPNAPDlinea
						   and f.CPPid			> ln.CPPid
					),0)
				as Saldo,
				a.CPNAPDmonto-a.CPNAPDutilizado as SaldoActual,
				a.CPNAPDmonto-a.CPNAPDutilizado as orden,
				l.CPLCresultado,
				case l.CPLCresultado
					when 0 then 'Monto Liquidado:'
					when 1 then 'ERROR: No hay fondos suficientes en el nuevo Período'
					when 2 then 'ERROR: La cuenta no existe en el nuevo Período'
				end as Resultado,
				CPLCmontoReservas+CPLCmontoCompromisos as MontoLiquidado,
				a.CPNAPnumRef as Referencia,
				case
					when a.CPNAPDreferenciado=1 then 'SI'
				end as Utilizado 
			  from CPLiquidacionNAPdetalle ln
					inner join CPNAPdetalle a
						inner join CPNAP b
							 on b.Ecodigo  = a.Ecodigo
							and b.CPNAPnum = a.CPNAPnum
						 on a.Ecodigo				= ln.Ecodigo
						and a.CPNAPnum				= ln.CPNAPnum
						and a.CPNAPDlinea			= ln.CPNAPDlinea
					inner join CPLiquidacionCuentas l
						 on l.Ecodigo				= ln.Ecodigo
						and l.CPPid					= ln.CPPid
						and l.CPLnumeroLiquidacion  = ln.CPLnumeroLiquidacion
						and l.Ocodigo  				= a.Ocodigo
						and l.CPcuenta 				= a.CPcuenta
					inner join CPresupuesto c
						 on c.CPcuenta 	= a.CPcuenta
						and c.Ecodigo 	= a.Ecodigo
					inner join Oficinas o
						 on o.Ecodigo 	= a.Ecodigo
						and o.Ocodigo 	= a.Ocodigo
			 where ln.Ecodigo 		= #session.ecodigo#
			   and ln.CPPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">
			<cfif LvarOorigen NEQ "">
			   and b.CPNAPmoduloOri = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarOorigen#">
			</cfif>
			<cfif LvarTipoMov NEQ "">
			   and #PreserveSingleQuotes(LvarTipoMov)#
			</cfif>
				#PreserveSingleQuotes(LvarCPformato)#
				<cf_CPSegUsu_where Consultar="true" aliasCuentas="c" aliasOficina="a">
			order by CuentaPresupuesto, a.CPNAPnum, a.CPNAPDmonto-a.CPNAPDutilizado desc
		</cfquery>
	
	<cfif isdefined("btnDownload")>
		<cfset LvarNoCortes = "1">
	</cfif>
	<cf_htmlReportsHeaders 
		title="Reporte de Liquidación de Período Presupuestario" 
		filename="rptLiquidacion.xls"
		irA="rptLiquidacion.cfm" 
		>
	<cfoutput>
				<cfset sbGeneraEstilos()>

				<cfset Encabezado()>
				<cfset Creatabla()>
				<cfset titulos()>
				<cfflush interval="512">
				<cfset LvarCtaAnt = "">
				<cfloop query="rsListaLiquidacion" >
					<cfif isdefined("session.rptDetallesNAP_Cancel")>
						<cfset structDelete(session, "rptDetallesNAP_Cancel")>
						<cf_errorCode	code = "50509" msg = "Reporte Cancelado por el Usuario">
					</cfif>

					<cfif LvarCtaAnt NEQ rsListaLiquidacion.CuentaPresupuesto>
						<cfset LvarCtaAnt = rsListaLiquidacion.CuentaPresupuesto>
						<cfset sbCortePagina()>
						<cfset sbCortePagina()>
					<tr>
						<td align="left" class="Corte1">#rsListaLiquidacion.CuentaPresupuesto#</td>
						<td align="left" class="Corte1" colspan="6">#rsListaLiquidacion.Descripcion#</td>
						<cfif rsListaLiquidacion.CPLCresultado EQ 0>
							<td align="left" class="Corte1" colspan="3">#rsListaLiquidacion.Resultado#</td>
							<td align="right" class="Corte1" colspan="5">#LSnumberFormat(rsListaLiquidacion.MontoLiquidado,",9.00")#</td>
						<cfelse>
							<td align="left" class="Corte1" colspan="8">#rsListaLiquidacion.Resultado#</td>
						</cfif>

					</tr>
					<cfelse>
						<cfset sbCortePagina()>
					</cfif>
					<tr>
						<td class="Datos">&nbsp;</td>
						<td align="right" class="Datos">#rsListaLiquidacion.CPNAPnum#</td>
						<td align="right" class="Datos">#rsListaLiquidacion.CPNAPDlinea#</td>
						<td align="left" class="Datos" >#rsListaLiquidacion.Modulo#</td>
						<td align="left" class="Datos" >#rsListaLiquidacion.Documento#</td>
						<td align="left" class="Datos" >#rsListaLiquidacion.DocReferencia#</td>
						<td align="center" class="Datos" >#LSDateFormat(rsListaLiquidacion.FechaDoc,"mm/dd/yyyy")#</td>
						<td align="center" class="Datos" >#LSDateFormat(rsListaLiquidacion.FechaAutorizacion,"mm/dd/yyyy")#</td>
						<td align="left" class="Datos" >#rsListaLiquidacion.Oficina#</td>
						<td align="center" class="Datos" >#rsListaLiquidacion.Mes#</td>
						<td align="center" class="Datos" >#rsListaLiquidacion.PeriodoAnterior#</td>
						<td align="center" class="Datos" >#rsListaLiquidacion.TipoControl#</td>
						<td align="center" class="Datos" >#rsListaLiquidacion.CalculoControl#</td>
						<td align="center" class="Datos" >#rsListaLiquidacion.TipoMovimiento#</td>
						<td align="right" class="Datos" >#LSNumberFormat(rsListaLiquidacion.Monto,',9.00')#</td>
						<td align="right" class="Datos" >#LSNumberFormat(rsListaLiquidacion.Saldo,',9.00')#</td>
						<td align="right" class="Datos" >#LSNumberFormat(rsListaLiquidacion.SaldoActual,',9.00')#</td>
				</tr>
				</cfloop>
				<cfset Cierratabla()>
			</body>
		</html>
		</cfoutput>

	</cflock>
<cfcatch type="lock">
	<cfoutput>
	<script language="javascript">
		alert('Ya existe un reporte en ejecución, debe esperar a que termine su procesamiento');
		location.href = "rptDetallesNAP.cfm";
	</script>
	</cfoutput>
</cfcatch>
</cftry>

<!--- ************************************************************* --->
<!--- *********    Creación de funciones  			   ************ --->
<!--- ************************************************************* --->
<cffunction name="Encabezado" output="true">
	<table width="100%" border="0">
		<tr>
			<td  class="Header1" colspan="16" align="center">
				<strong>#ucase(session.Enombre)#</strong>
			</td>
		</tr>
		<tr>
			<td  class="Header1" colspan="16" align="center"><strong>REPORTE DE LIQUIDACION DE PERIODO PRESUPUESTARIO</strong></td>
		</tr>
		<tr>
			<td class="Header" colspan="16" align="center"><strong>#ucase(rsPeriodo.CPPDESCRIPCION)#</strong></td>
		</tr>
	<cfif LvarCF NEQ "">
		<tr> 
			<td class="Header" colspan="16" align="center"><strong>(#LvarCF#)</strong></td>
		</tr>
	</cfif>		
	</table>
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="Creatabla" output="true">
	<table width="100%" border="0">
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="Cierratabla" output="true">
	</table>
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="titulos" output="true">
	<tr>
		<td align="center" class="ColHeader">Cuenta Presupuesto</td>
		<td align="center" class="ColHeader">NAP</td>
		<td align="center" class="ColHeader">LIN</td>
		<td align="center" class="ColHeader" >M&oacute;dulo</td>
		<td align="center" class="ColHeader">Documento</td>
		<td align="center" class="ColHeader">Referencia</td>
		<td align="center" class="ColHeader">Fecha<br>Documento</td>
		<td align="center" class="ColHeader">Fecha<br>Autorizaci&oacute;n</td>
		<td align="center" class="ColHeader">Oficina</td>
		<td align="center" class="ColHeader">Mes</td>
		<td align="center" class="ColHeader">Periodo<br>Anterior</td>
		<td align="center" class="ColHeader">Tipo<br>Control</td>
		<td align="center" class="ColHeader">Cálculo<br>Control</td>
		<td align="center" class="ColHeader">Tipo<br>Movimiento</td>
		<td align="center" class="ColHeader">Monto<br>Autorizado</td>
		<td align="center" class="ColHeader">Monto<br>Liquidado</td>
		<td align="center" class="ColHeader">Saldo<br>Actual</td>
	</tr>
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="sbGeneraEstilos" output="true">
	<style type="text/css">
	<!--
		H1.Corte_Pagina
		{
		PAGE-BREAK-AFTER: always
		}
		
		.ColHeader 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		9px;
			font-weight: 	bold;
			padding-left: 	0px;
			border:		1px solid ##CCCCCC;
			background-color:##CCCCCC
		}
	
		.Header 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		12px;
			font-weight: 	bold;
			padding-left: 	0px;
			text-align:	center;
		}
	
		.Header1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		14px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
		.Corte1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		12px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
	
		.Datos 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	none;
			white-space:nowrap;
		}
	
		body
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		11px;
		}
	-->
	</style>
</cffunction>

<cffunction name="sbCortePagina" output="true">
	<cfif isdefined("LvarNoCortes")>
		<cfreturn>
	</cfif>
	<cfif LvarContL GTE LvarLineasPagina>
		<tr><td><H1 class=Corte_Pagina></H1></td></tr>
		<cfset Cierratabla()>
		<cfset LvarPAg   = LvarPAg + 1>
		<cfset LvarContL = 5> 
		<cfset Encabezado()>
		<cfset Creatabla()>
		<cfset titulos()>
	</cfif>
	<cfset LvarContL = LvarContL + 1>  
</cffunction>
				


