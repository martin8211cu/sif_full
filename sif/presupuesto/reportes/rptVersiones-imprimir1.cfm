<cfsetting 	requesttimeout="36000"
			enablecfoutputonly="yes">

<cfif isdefined('form.CPPid')>
	<cfset form.CPPid = ListFirst(#form.CPPid#,',')>
</cfif>
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
		<cfset session.rptVersiones_Cancel = true>
		<cflocation url="rptVersiones.cfm">
		<cfabort>	
	</cfif>
    <cfinclude template="../../Utiles/sifConcat.cfm">
	<cflock timeout="1" name="rptVersiones_#session.rptRnd#" throwontimeout="yes">
		<cfset structDelete(session, "rptVersiones_Cancel")>

		<cfif isdefined("form.btnRefrescar")>
			<!--- Obtiene las Cuentas de Presupuesto existentes (correspondientes a las cuentas de Version) --->
			<!--- Actualiza los tipos de Cambio Proyectados por Mes y actualiza el monto a aplicar--->
			<!--- Actualiza los Totales de Formulacion por Cuenta+Año+Mes+Oficina (sin Moneda) --->
			<cfset LobjAjuste = createObject( "component","sif.Componentes.PRES_Formulacion")>
			<cfset LobjAjuste.AjustaFormulacion(form.CVid)>
		</cfif>
		
		<!--- Obtiene la Moneda de la Empresa --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select e.Mcodigo, m.Mnombre
			from Empresas e, Monedas m
			where e.Ecodigo = #session.ecodigo#
			  and m.Ecodigo = e.Ecodigo
			  and m.Mcodigo = e.Mcodigo
		</cfquery>
		<cfif find(",",rsSQL.Mnombre) GT 0>
			<cfset LvarMnombreEmpresa = trim(mid(rsSQL.Mnombre,find(",",rsSQL.Mnombre)+1,100))>
		<cfelse>	
			<cfset LvarMnombreEmpresa = rsSQL.Mnombre>
		</cfif>

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
		
		<cfquery name="rsVersion" datasource="#Session.dsn#">
			select Ecodigo, CVid, CVtipo, CVdescripcion, CPPid, CVaprobada, ts_rversion
			from CVersion
			where Ecodigo = #session.ecodigo#
			and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
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
		
		<cfquery name="rsListaVersion" datasource="#session.dsn#">
			select 	a.Ocodigo, 'Oficina: ' #_Cat# o.Odescripcion as Oficina,
					a.Mcodigo, b.Miso4217, b.Mnombre,
				a.CVPcuenta, CPCano, CPCmes, 
				case a.CPCmes when 1 then 'ENE' when 2 then 'FEB' when 3 then 'MAR' when 4 then 'ABR' when 5 then 'MAY' when 6 then 'JUN' when 7 then 'JUL' when 8 then 'AGO' when 9 then 'SET' when 10 then 'OCT' when 11 then 'NOV' when 12 then 'DIC' else '' end #_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="a.CPCano"> as AnoMes,
				Miso4217 as moneda, 
				CPformato, 	CPdescripcion,
					'(Control ' #_Cat#
						case CVPtipoControl
							when 0 then 'Abierto'
							when 1 then 'Restringido'
							when 2 then 'Restrictivo'
						end
						#_Cat#
						case CVPcalculoControl
							when 1 then '&nbsp;Mensual'
							when 2 then '&nbsp;Acumulado'
							when 3 then '&nbsp;Total'
						end
					#_Cat#	')'
				as control,

				a.CVFMmontoBase 											as MontoBase, 
				a.CVFMajusteUsuario 										as AjusteU, 
				a.CVFMmontoBase + a.CVFMajusteUsuario						as VersionU, 
				a.CVFMajusteFinal 											as AjusteF, 
				a.CVFMmontoBase + a.CVFMajusteUsuario + a.CVFMajusteFinal 	as VersionF,
				coalesce(a.CVFMtipoCambio, 0) as TipoCambio,
				case 
					when coalesce(a.CVFMtipoCambio, 0) <> 0 
					then coalesce((a.CVFMmontoBase + a.CVFMajusteUsuario + a.CVFMajusteFinal)*a.CVFMtipoCambio,0)
					else 0
				end as colonesSolicitado, 
			<cfif rsVersion.CVtipo EQ "2">
				a.CVFMmontoBase + a.CVFMajusteUsuario + a.CVFMajusteFinal - coalesce(a.CVFMmontoAplicar,0) as MontoActual,
				coalesce(a.CVFMmontoAplicar,0) as MontoModificar,
				case 
					when coalesce(a.CVFMtipoCambio, 0) <> 0 
					then coalesce(((a.CVFMmontoBase + a.CVFMajusteUsuario + a.CVFMajusteFinal) - coalesce(a.CVFMmontoAplicar,0))*a.CVFMtipoCambio ,0)
					else 0
				end as colonesActual,
				case 
					when coalesce(a.CVFMtipoCambio, 0) <> 0 
					then coalesce(a.CVFMmontoAplicar,0)*a.CVFMtipoCambio 
					else 0
				 end as colonesModificar,
			</cfif>
				' ' as nada
			from CVFormulacionMonedas a
				inner join Monedas b
					 on b.Ecodigo = a.Ecodigo
					and b.Mcodigo = a.Mcodigo
				inner join Oficinas o
					 on o.Ecodigo = a.Ecodigo
					and o.Ocodigo = a.Ocodigo
				inner join CVPresupuesto c
					 on c.Ecodigo 	= a.Ecodigo
					and c.CVid 		= a.CVid
					and c.CVPcuenta = a.CVPcuenta
			where a.Ecodigo = #session.ecodigo#
			and a.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
			<cfif form.CPCanoMes1 NEQ "">
				<cfif form.CPCanoMes2 NEQ "">
					and a.CPCano*100+a.CPCmes >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCanoMes1#">
					and a.CPCano*100+a.CPCmes <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCanoMes2#">
				<cfelse>
					and a.CPCano*100+a.CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCanoMes1#">
				</cfif>
			</cfif>
			<cfif form.CPformato1 NEQ "">
				<cfif form.CPformato2 NEQ "">
					and c.CPformato >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPformato1#">
					and c.CPformato <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPformato2##chr(255)#">
				<cfelse>
					and c.CPformato = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPformato1#">
				</cfif>
			</cfif>
			<cfif NOT isdefined("form.chkConCeros")>
				and (coalesce(a.CVFMmontoAplicar,0) <> 0 OR a.CVFMmontoBase <> 0 OR a.CVFMajusteUsuario <> 0 OR a.CVFMajusteFinal <> 0)
			</cfif>
			<cf_CPSegUsu_where Consultar="true" aliasCuentas="c" aliasOficina="a">
			order by a.Ocodigo, c.CPformato, a.Mcodigo, a.CPCano, a.CPCmes
		</cfquery>
			
		<cfif isdefined("btnDownload")>
			<cfset LvarNoCortes = "1">
		</cfif>
		<cf_htmlReportsHeaders 
			title="Reporte de Versiones de Formulación de Presupuesto" 
			filename="rptVersion.xls"
			irA="rptVersiones.cfm" 
			>
		<cfoutput>
					<cfset sbGeneraEstilos()>
	
					<cfset Encabezado()>
					<cfset Creatabla()>
					<cfset titulos()>
					<cfflush interval="512">
					<cfset LvarOfiAnt = "">
					<cfset LvarCtaAnt = "">
					<cfset LvarMonAnt = "">
					<cfset sbTotales(0)>
					<cfloop query="rsListaVersion" >
						<cfif isdefined("session.rptVersiones_Cancel")>
							<cfset structDelete(session, "rptVersiones_Cancel")>
							<cf_errorCode	code = "50509" msg = "Reporte Cancelado por el Usuario">
						</cfif>

						<cfif LvarOfiAnt NEQ rsListaVersion.Ocodigo>
							<cfset sbTotales(3)>
							<cfset sbTotales(2)>
							<cfset sbTotales(1)>
							<cfset sbCorte1()>
							<cfset sbCorte2()>
							<cfset sbCorte3()>
						<cfelseif LvarCtaAnt NEQ rsListaVersion.CVPcuenta>
							<cfset sbTotales(3)>
							<cfset sbTotales(2)>
							<cfset sbCorte2()>
							<cfset sbCorte3()>
						<cfelseif LvarMonAnt NEQ rsListaVersion.Mcodigo>
							<cfset sbTotales(3)>
							<cfset sbCorte3()>
						</cfif>
						<cfset sbCortePagina(0)>
						<tr>
							<td align="left" class="Datos">&nbsp;</td>
							<td align="left" class="Datos">
								#rsListaVersion.AnoMes#
							</td>

						<cfset LvarTotales.C4[1] = LvarTotales.C4[1] + rsListaVersion.MontoBase>
						<cfset LvarTotales.C4[2] = LvarTotales.C4[2] + rsListaVersion.AjusteU>
						<cfset LvarTotales.C4[3] = LvarTotales.C4[3] + rsListaVersion.MontoBase+rsListaVersion.AjusteU>
						<cfset LvarTotales.C4[4] = LvarTotales.C4[4] + rsListaVersion.AjusteF>
						<cfset LvarTotales.C4[5] = LvarTotales.C4[5] + rsListaVersion.MontoBase+rsListaVersion.AjusteU+rsListaVersion.AjusteF>
						<cfset LvarTotales.C4[9] = LvarTotales.C4[9] + rsListaVersion.ColonesSolicitado>
						<cfif rsVersion.CVtipo EQ "2">
							<cfset LvarTotales.C4[6] = LvarTotales.C4[6] + rsListaVersion.MontoActual>
							<cfset LvarTotales.C4[7] = LvarTotales.C4[7] + rsListaVersion.MontoModificar>
							<cfset LvarTotales.C4[10] = LvarTotales.C4[10] + rsListaVersion.ColonesActual>
							<cfset LvarTotales.C4[11] = LvarTotales.C4[11] + rsListaVersion.ColonesModificar>
						</cfif>
							<td align="right" class="Datos" width="500">
								#lsCurrencyformat(rsListaVersion.MontoBase,'none')#
							</td>
							<td align="right" class="Datos" width="500">
								<cfif rsListaVersion.AjusteU NEQ 0>
								#lsCurrencyformat(rsListaVersion.AjusteU,'none')#
								</cfif>
							</td>
							<td align="right" class="Datos" width="500">
								#lsCurrencyformat(rsListaVersion.MontoBase+rsListaVersion.AjusteU,'none')#
							</td>
							<td align="right" class="Datos" width="500">
								<cfif rsListaVersion.AjusteF NEQ 0>
								#lsCurrencyformat(rsListaVersion.AjusteF,'none')#
								</cfif>
							</td>
							<td align="right" class="Datos" width="500">
								#lsCurrencyformat(rsListaVersion.MontoBase+rsListaVersion.AjusteU+rsListaVersion.AjusteF,'none')#
							</td>
						<cfif rsVersion.CVtipo EQ "2">
							<td align="right" class="Datos" width="500">
								#lsCurrencyformat(rsListaVersion.MontoActual,'none')#
							</td>
							<td align="right" class="Datos" width="500">
								#lsCurrencyformat(rsListaVersion.MontoModificar,'none')#
							</td>
						</cfif>
							<td align="right" class="Datos" width="500">
								#lsCurrencyformat(rsListaVersion.tipoCambio,'none')#
							</td>
							<td align="right" class="Datos" width="500">
								#lsCurrencyformat(rsListaVersion.ColonesSolicitado,'none')#
							</td>
						<cfif rsVersion.CVtipo EQ "2">
							<td align="right" class="Datos" width="500">
								#lsCurrencyformat(rsListaVersion.ColonesActual,'none')#
							</td>
							<td align="right" class="Datos" width="500">
								#lsCurrencyformat(rsListaVersion.ColonesModificar,'none')#
							</td>
						</cfif>
						</tr>
					</cfloop>
					<cfset sbTotales(3)>
					<cfset sbTotales(2)>
					<cfset sbTotales(1)>
					<cfset sbTotales(0)>
					<cfset Cierratabla()>
				</body>
			</html>
		</cfoutput>
	</cflock>
<cfcatch type="lock">
	<cfoutput>
	<script language="javascript">
		alert('Ya existe un reporte en ejecución, debe esperar a que termine su procesamiento');
		location.href = "rptVersiones.cfm";
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
			<td  class="Header1" colspan="16" align="center"><strong>REPORTE DE VERSIONES DE FORMULACION DE PRESUPUESTO</strong></td>
		</tr>
		<tr>
			<td class="Header" colspan="16" align="center"><strong>#ucase(rsPeriodo.CPPDESCRIPCION)#</strong></td>
		</tr>
		<tr> 
			<td class="Header" colspan="16" align="center"><strong>#rsVersion.CVdescripcion#</strong></td>
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
		<td align="center" class="ColHeader">Mes</td>
		<td align="center" class="ColHeader" >Monto&nbsp;Base<BR>Moneda</td>
		<td align="center" class="ColHeader">Ajuste&nbsp;Usuario<BR>Moneda</td>
		<td align="center" class="ColHeader">Versión&nbsp;Usuario<BR>Moneda</td>
		<td align="center" class="ColHeader">Ajuste&nbsp;Final<BR>Moneda</td>
		<td align="center" class="ColHeader">Monto&nbsp;Final Solicitado<BR>Moneda</td>
	<cfif rsVersion.CVtipo EQ "2">
		<td align="center" class="ColHeader">Formulaciones Aprobadas<BR>Moneda</td>
		<td align="center" class="ColHeader">Modificacion Solicitada<BR>Moneda</td>
	</cfif>
		<td align="center" class="ColHeader">Tipo Cambio Proyectado</td>
		<td align="center" class="ColHeader">Monto Final Solicitado<BR>#LvarMnombreEmpresa#</td>
	<cfif rsVersion.CVtipo EQ "2">
		<td align="center" class="ColHeader">Formulaciones Aprobadas<BR>#LvarMnombreEmpresa#</td>
		<td align="center" class="ColHeader">Modificacion Solicitada<BR>#LvarMnombreEmpresa#</td>
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
			font-size: 		8px;
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
	
		.Corte0
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
			font-size: 		10px;
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
			font-size: 		8px;
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
	<cfargument name="Lineas" required="yes" type="numeric">
	
	<cfif isdefined("LvarNoCortes")>
		<cfreturn>
	</cfif>
	<cfif LvarContL + Arguments.Lineas GTE LvarLineasPagina>
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
				
<cffunction name="sbCorte1" output="true">
	<cfset LvarOfiAnt = rsListaVersion.Ocodigo>
	<cfset sbCortePagina(3)>
	<tr>
		<td align="left" class="Corte1" colspan="15">#rsListaVersion.Oficina#</td>
	</tr>
</cffunction>

<cffunction name="sbCorte2" output="true">
	<cfset LvarCtaAnt = rsListaVersion.CVPcuenta>
	<cfset sbCortePagina(2)>
	<tr>
		<td align="left" class="Corte2" nowrap>#rsListaVersion.CPformato#</td>
		<td align="left" class="Corte2" colspan="5">#rsListaVersion.CPdescripcion#</td>
		<td align="left" class="Corte2" colspan="10">#rsListaVersion.Control#</td>
	</tr>
</cffunction>
<cffunction name="sbCorte3" output="true">
	<cfset LvarMonAnt = rsListaVersion.Mcodigo>
	<cfset sbCortePagina(1)>
	<tr>
		<td align="left" class="Corte3" colspan="15">#rsListaVersion.Miso4217# #rsListaVersion.Mnombre#</td>
	</tr>
</cffunction>

<cffunction name="sbTotales" output="true">
	<cfargument name="Corte" required="yes" type="numeric">
	
	<cfset LvarTotal = Arguments.Corte + 1>
	<cfif not isdefined("LvarTotales.C#LvarTotal#")>
		<cfset LvarTotales["C#LvarTotal#"] = ArrayNew(1)>
		<cfloop index="i" from="1" to="11">
			<cfset LvarTotales["C#LvarTotal#"][i] = 0>
		</cfloop>
		<cfreturn>
	</cfif>
	<cfset sbCortePagina(0)>
	<tr>
		<td align="left" class="Corte#Arguments.Corte#" colspan="2">
			<cfif LvarTotal EQ 1>
				Totales Generales
			<cfelseif LvarTotal EQ 2>
				Totales por Oficina
			<cfelseif LvarTotal EQ 3>
				Totales por Cuenta (#LvarMnombreEmpresa#)
			<cfelseif LvarTotal EQ 4>
				Totales por Moneda
			</cfif>
		</td>
		<cfloop index="i" from="1" to="11">
			<cfif rsVersion.CVtipo EQ "2" or (i NEQ 6 AND i NEQ 7 AND i NEQ 10 AND i NEQ 11)>
				<td align="right" class="Datos" width="500">
				<cfif i NEQ 8 and (Arguments.Corte EQ 3 OR i GT 8)>
					<strong>#lsCurrencyformat(LvarTotales["C#LvarTotal#"][i],'none')#</strong>
					<cfif Arguments.Corte GT 0>
						<cfset LvarTotales["C#LvarTotal-1#"][i] = LvarTotales["C#LvarTotal-1#"][i] + LvarTotales["C#LvarTotal#"][i]>
					</cfif>
					<cfset LvarTotales["C#LvarTotal#"][i] = 0>
				</cfif>
				</td>
			</cfif>
		</cfloop>
	</tr>
</cffunction>


