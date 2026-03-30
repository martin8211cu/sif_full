<cfsetting 	requesttimeout="36000"
			enablecfoutputonly="yes">

<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cfparam name="form.CPPid" default="#session.CPPid#">
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cfset LvarLineasPagina = 55>
<cftry>
	<cfif not isdefined("session.rptRnd")><cfset session.rptRnd = int(rand()*10000)></cfif>
	<cfif isdefined("form.btnCancelar")>
		<cfset session.rptDocsPRES_Cancel = true>
		<cflocation url="rptDocsPRES.cfm">
		<cfabort>	
	</cfif>

    <cfinclude template="../../Utiles/sifConcat.cfm">

	<cflock timeout="1" name="rptDocsPRES_#session.rptRnd#" throwontimeout="yes">
		<cfset structDelete(session, "rptDocsPRES_Cancel")>

		<cfset LvarCPPid = form.CPPid>
		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
		<cfset LvarPAg = 1>  
		<cfset LvarContL = 5>  
		<cfset TIPO    = form.CPTpoRep>
		
		<cfif TIPO EQ "RE">
			<cfset CPTpoRep = "R">
		<cfelseif TIPO EQ "LB">
			<cfset CPTpoRep = "L">
		<cfelseif TIPO EQ "TE">
			<cfset CPTpoRep = "T">
		<cfelseif TIPO EQ "TR">
			<cfset CPTpoRep = "T">
		<cfelseif TIPO EQ "T1">
			<cfset CPTpoRep = "E">
		<cfelseif TIPO EQ "T2">
			<cfset CPTpoRep = "E">
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
		<cfif mid(TIPO,1,1) NEQ "T">
			<cfset LvarCF_INI = evaluate("form.CFidIni")>
			<cfset LvarCF_FIN = evaluate("form.CFidFin")>
			<cfset LvarCentroFuncional = "">
			<cfif LvarCF_INI NEQ "">
				<cfif LvarCF_FIN EQ "">
					<cfset LvarCentroFuncional = " and LE.CFidOrigen = #LvarCF_INI#">
				<cfelse>
					<cfset LvarCentroFuncional = " and LE.CFidOrigen >= #LvarCF_INI# and LE.CFidOrigen <= #LvarCF_FIN#">
				</cfif>
			</cfif>
		<cfelse>
			<cfif TIPO EQ "TE" OR TIPO EQ "T1">
				<cfset LvarCFO_INI = evaluate("form.CFIDORIGENINI")>
				<cfset LvarCFO_FIN = evaluate("form.CFIDORIGENFIN")>
				<cfset LvarCFD_INI = evaluate("form.CFIDCFIDDESTINI")>
				<cfset LvarCFD_FIN = evaluate("form.CFIDCFIDDESTFIN")>
			<cfelse>
				<cfset LvarCFO_INI = evaluate("form.CFIDCFIDORIGENINI")>
				<cfset LvarCFO_FIN = evaluate("form.CFIDCFIDORIGENFIN")>
				<cfset LvarCFD_INI = evaluate("form.CFIDDESTINI")>
				<cfset LvarCFD_FIN = evaluate("form.CFIDDESTFIN")>
			</cfif>
			<cfset LvarCentroFuncional = "">
			<cfif LvarCFO_INI NEQ "">
				<cfif LvarCFO_FIN EQ "">
					<cfset LvarCentroFuncional = LvarCentroFuncional  & " and LE.CFidOrigen = #LvarCFO_INI#">
				<cfelse>
					<cfset LvarCentroFuncional = LvarCentroFuncional  &  " and LE.CFidOrigen >= #LvarCFO_INI# and LE.CFidOrigen <= #LvarCFO_FIN#">
				</cfif>
			</cfif>
		
			<cfif LvarCFD_INI NEQ "">
				<cfif LvarCFD_FIN EQ "">
					<cfset LvarCentroFuncional = LvarCentroFuncional  & " and LE.CFidDestino = #LvarCFD_INI#">
				<cfelse>
					<cfset LvarCentroFuncional = LvarCentroFuncional  &  " and LE.CFidDestino >= #LvarCFD_INI# and LE.CFidDestino <= #LvarCFD_FIN#">
				</cfif>
			</cfif>
		</cfif>	
		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
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
		<cfquery name="rsListaDoc" datasource="#Session.DSN#">
			select
			case LE.CPDEtipoDocumento
				when 'T' then 'Traslado Interno'
				when 'E' then 'Traslado Aut.Externa'
				when 'R' then 'Provisión'
				when 'L' then 'Liberación'
			end as Referencia,
			LE.CPDEnumeroDocumento as Documento,
			LE.CPDEfechaDocumento  as FechaDoc,
			LE.NAP as NAP,
			LE.CPDEfechaAprueba as FechaAutoriza,
			case 
				when LE.CPDEtipoDocumento<>'T' then (select CFcodigo from CFuncional cf where cf.CFid=LE.CFidOrigen)
				when LD.CPDDtipo=-1 then (select CFcodigo from CFuncional cf where cf.CFid=LE.CFidOrigen)
				when LD.CPDDtipo=1  then (select CFcodigo from CFuncional cf where cf.CFid=LE.CFidDestino)
			end as CentroFunc,
			o.Oficodigo as Oficina,
			<cf_dbfunction name="to_char" args="LD.CPCano"> #_Cat# '-' #_Cat#
			case LD.CPCmes when 1 then 'ENE' when 2 then 'FEB' when 3 then 'MAR' when 4 then 'ABR' when 5 then 'MAY' when 6 then 'JUN' when 7 then 'JUL' when 8 then 'AGO' when 9 then 'SET' when 10 then 'OCT' when 11 then 'NOV' when 12 then 'DIC' else '' end 
			as Mes,
			c.CPformato as CuentaPpto,
			<cfif TIPO EQ "RE">
				LD.CPDDmonto   as MontoReserva,
				LD.CPDDsaldo   as SaldoActual,
			<cfelseif TIPO EQ "LB">
				RE.CPDEnumeroDocumento as DocReserva,
				RD.CPDDmonto   as MontoReserva,
				LD.CPDDmonto+LD.CPDDsaldo as SaldoAnterior,
				LD.CPDDmonto   as MontoLiberacion,
				LD.CPDDsaldo   as SaldoGenerado,
				RD.CPDDsaldo   as SaldoActual,
			<cfelseif mid(TIPO,1,1) EQ "T">
				case LD.CPDDtipo
					when -1 then 'Origen'
					when 1  then 'Destino' 
				end as Tipo,
				(LD.CPDDtipo * LD.CPDDmonto)  as MontoTraslado,
			</cfif>
			1 as fin
			
			from CPDocumentoD LD
			inner join CPDocumentoE LE
				 on LE.Ecodigo  = LD.Ecodigo
				and LE.CPDEid   = LD.CPDEid
			inner join Oficinas o
				 on o.Ecodigo 	= LD.Ecodigo
				and o.Ocodigo 	= LD.Ocodigo
			inner join CPresupuesto c
				 on c.CPcuenta 	= LD.CPcuenta
				and c.Ecodigo 	= LD.Ecodigo
				#PreserveSingleQuotes(LvarCPformato)#
			<cfif TIPO EQ "LB">
				inner join CPDocumentoE RE
					on  RE.CPDEid  = LE.CPDEidRef
				inner join CPDocumentoD RD
					on  RD.CPDDid	 = LD.CPDDidRef
			</cfif>
			where LE.CPDEtipoDocumento = '#CPTpoRep#'
				<cfif isdefined("form.CPPid") and len(trim(form.CPPid))>
					and LE.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
				</cfif>
				<cfif isdefined("form.FechaIni") and len(trim(form.FechaIni))>
					and LE.CPDEfechaDocumento >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaIni)#">
				</cfif>	
				<cfif isdefined("form.FechaFin") and len(trim(form.FechaFin))>
					and LE.CPDEfechaDocumento <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaFin)#">
				</cfif>
				<cfif TIPO EQ "TR" OR TIPO EQ "T2">
					<cf_CPSegUsu_where Consultar="true" aliasCF="LE" name="CFidDestino" soloCFs="true">
				<cfelse>
					<cf_CPSegUsu_where Consultar="true" aliasCF="LE" name="CFidOrigen" soloCFs="true">
				</cfif>
				#PreserveSingleQuotes(LvarCentroFuncional)#
				
				and LE.CPDEaplicado = 1
			order by LE.CPDEid, LD.CPDDtipo
		</cfquery>
	
	<!--- ************************************************************* --->
	<!--- ************************************************************* --->
	<cfif isdefined("btnDownload")>
		<cfset LvarNoCortes = "1">
	</cfif>
	<cf_htmlReportsHeaders 
		title="Reportes de Documentos de Presupuesto" 
		filename="rptDocs.xls"
		irA="rptDocsPRES.cfm" 
		>
	<cfoutput>
				<cfset sbGeneraEstilos()>

				<cfset Encabezado()>
				<cfset Creatabla()>
				<cfset titulos()>
				<cfloop query="rsListaDoc" >
					<cfset sbCortePagina()>
					<tr>
						<!--- <td align="left" class="Datos">#rsListaDoc.Referencia#</td> --->
						<td align="left" class="Datos" >#rsListaDoc.Documento#</td>
						<td align="center" class="Datos" >#LSDateFormat(rsListaDoc.FechaDoc,"mm/dd/yyyy")#</td>
						<td align="right" class="Datos" >#rsListaDoc.NAP#</td>
						<td align="center" class="Datos" >#LSDateFormat(rsListaDoc.FechaAutoriza,"mm/dd/yyyy")#</td>
						<td align="left" class="Datos" >#rsListaDoc.CentroFunc#</td>
						<td align="left" class="Datos" >#rsListaDoc.Oficina#</td>
						<td align="left" class="Datos" >#rsListaDoc.Mes#</td>
						<td align="left" class="Datos" >#rsListaDoc.CuentaPpto#</td>
						<cfif CPTpoRep EQ "R">
							<td align="right" class="Datos" >#LSNumberFormat(rsListaDoc.MontoReserva,',9.00')#</td>
							<td align="right" class="Datos" >#LSNumberFormat(rsListaDoc.SaldoActual,',9.00')#</td>
						<cfelseif CPTpoRep EQ "L">
							<td align="left" class="Datos" >#rsListaDoc.DocReserva#</td>
							<td align="right" class="Datos" >#LSNumberFormat(rsListaDoc.MontoReserva,',9.00')#</td>
							<td align="right" class="Datos" >#LSNumberFormat(rsListaDoc.SaldoAnterior,',9.00')#</td>
							<td align="right" class="Datos" >#LSNumberFormat(rsListaDoc.MontoLiberacion,',9.00')#</td>
							<td align="right" class="Datos" >#LSNumberFormat(rsListaDoc.SaldoGenerado,',9.00')#</td>
							<td align="right" class="Datos" >#LSNumberFormat(rsListaDoc.SaldoActual,',9.00')#</td>
						<cfelseif CPTpoRep EQ "T" OR CPTpoRep EQ "E">
							<td align="left" class="Datos" >#rsListaDoc.Tipo#</td>
							<td align="right" class="Datos" >#LSNumberFormat(rsListaDoc.MontoTraslado,',9.00')#</td>
						</cfif>
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
		location.href = "rptDocsPRES.cfm";
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
		<cfif CPTpoRep EQ "R">
			<td  class="Header1" colspan="16" align="center"><strong>REPORTE DE DOCUMENTOS DE PROVISIÓN PRESUPUESTARIA</strong></td>
		<cfelseif CPTpoRep EQ "L">
			<td  class="Header1" colspan="16" align="center"><strong>REPORTE DE DOCUMENTOS DE LIBERACION DE PROVISIÓN PRESUPUESTARIA</strong></td>
		<cfelseif CPTpoRep EQ "T">
			<td  class="Header1" colspan="16" align="center"><strong>REPORTE DE DOCUMENTOS DE TRASLADOS DE PRESUPUESTO INTERNOS</strong></td>
		<cfelseif CPTpoRep EQ "E">
			<td  class="Header1" colspan="16" align="center"><strong>REPORTE DE DOCUMENTOS DE TRASLADOS CON AUTORIZACION EXTERNA</strong></td>
		</cfif>
		</tr>
		<tr>
			<td class="Header" colspan="16" align="center"><strong>#ucase(rsPeriodo.CPPDESCRIPCION)#</strong></td>
		</tr>
		<tr> 
<!--- 
			<td class="Header" colspan="16" align="center"><strong>PARA EL MES DE #LvarMeses[LvarMes]#  #LvarAno#</strong></td>
 --->
 		</tr>			
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
		<!--- <td align="center" class="ColHeader">Referencia</td> --->
		<td align="center" class="ColHeader" >Documento</td>
		<td align="center" class="ColHeader">Fecha<br>Documento</td>
		<td align="center" class="ColHeader">NAP</td>
		<td align="center" class="ColHeader">Fecha<br>Autorizaci&oacute;n</td>
		<td align="center" class="ColHeader">Centro<br>Funcional</td>
		<td align="center" class="ColHeader">Oficina</td>
		<td align="center" class="ColHeader">Mes</td>
		<td align="center" class="ColHeader">Cuenta<br>Presupuesto</td>
		<cfif TIPO EQ "RE">
			<td align="center" class="ColHeader">Monto<br>Provisión</td>
			<td align="center" class="ColHeader">Saldo<br>Actual</td>
		<cfelseif TIPO EQ "LB">
			<td align="center" class="ColHeader">Documento<br>Provisión</td>
			<td align="center" class="ColHeader">Monto<br>Provisión</td>
			<td align="center" class="ColHeader">Saldo<br>Anterior</td>
			<td align="center" class="ColHeader">Monto<br>Liberado</td>
			<td align="center" class="ColHeader">Saldo</td>
			<td align="center" class="ColHeader">Saldo<br>Actual</td>
		<cfelseif mid(TIPO,1,1) EQ "T">
			<td align="center" class="ColHeader">Tipo</td>
			<td align="center" class="ColHeader">Monto<br>Traslado</td>
		</cfif>

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
			font-size: 		11px;
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
			font-size: 		14px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
		.Corte2 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		7px;
			font-weight: 	bold;
			padding-left: 	10px;
		}
	
		.Corte3 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	bold;
			padding-left: 	20px;
		}
	
		.Corte4 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	none;
			padding-left: 	30px;
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
				
