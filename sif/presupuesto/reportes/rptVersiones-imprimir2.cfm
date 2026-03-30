<cfsetting 	requesttimeout="36000" enablecfoutputonly="yes">

<!--- se corrige pues el resultado era "CPPid,CPPid" --->
<cfif isdefined('form.CPPid')>
	<cfset form.CPPid = ListFirst(#form.CPPid#,',')>
</cfif>

<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cfset LvarLineasPagina = 50>
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
		
        <cfif not isdefined("Form.CPPid")>
        	<cfset Form.CPPid = -1>
        </cfif>
        
		<!--- Obtiene la Moneda de la Empresa --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select e.Mcodigo, m.Mnombre
			from Empresas e, Monedas m
			where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
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
			where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
		</cfquery>
		
		<cfquery name="rsVersion" datasource="#Session.dsn#">
			select Ecodigo, CVid, CVtipo, CVdescripcion, CPPid, CVaprobada, ts_rversion
			from CVersion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
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
		
		<cfquery name="rsListaMeses" datasource="#session.dsn#">
			select 	CPCano*100+CPCmes as CPCanoMes,
					case a.CPCmes when 1 then 'ENE' when 2 then 'FEB' when 3 then 'MAR' when 4 then 'ABR' when 5 then 'MAY' when 6 then 'JUN' when 7 then 'JUL' when 8 then 'AGO' when 9 then 'SET' when 10 then 'OCT' when 11 then 'NOV' when 12 then 'DIC' else '' end #_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="a.CPCano"> as AnoMes
			  from CPmeses a
			 where 
             	a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
             	<cfif Form.CPPid NEQ -1 and Len(trim(Form.CPPid)) NEQ 0>
			   		and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
            	</cfif>
			 order by CPCano, CPCmes
		</cfquery>
		<cfquery name="rsSQL" dbtype="query">
			select min(CPCanoMes) Inicio, max(CPCanoMes) as Final from rsListaMeses
		</cfquery>
		<cfset LvarAnoMesIni = rsSQL.Inicio>
        
		<cfset LvarAnoIni = int(LvarAnoMesIni / 100)>
		<cfset LvarMesIni = LvarAnoMesIni - LvarAnoIni*100>
		<cfset LvarAnoMesFin = rsSQL.Final>
		
		<cfquery name="rsListaVersion" datasource="#session.dsn#">
			select 	a.Ocodigo, 'Oficina: ' #_Cat# o.Odescripcion as Oficina,
					a.Mcodigo, b.Miso4217, b.Mnombre,
				a.CVPcuenta, CPformato, CPdescripcion,
				case CVPtipoControl
					when 0 then 'Abierto'
					when 1 then 'Restring.'
					when 2 then 'Restrict.'
				end
				#_Cat#
				case CVPcalculoControl
					when 1 then '&nbsp;Mensual'
					when 2 then '&nbsp;Acumul.'
					when 3 then '&nbsp;Total'
				end
				as tipo,
				a.CPCano, a.CPCmes, a.CPCano*100+a.CPCmes as CPCanoMes, 
				a.CVFMmontoBase + a.CVFMajusteUsuario + a.CVFMajusteFinal as VersionFinal
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
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
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
			order by a.Ocodigo, a.Mcodigo, c.CPformato, a.CPCano, a.CPCmes
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
					<cfset LvarMonAnt = "">
					<cfset LvarCtaAnt = "">
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
						<cfelseif LvarMonAnt NEQ rsListaVersion.Mcodigo>
							<cfset sbTotales(3)>
							<cfset sbTotales(2)>
							<cfset sbCorte2()>
							<cfset sbCorte3()>
						<cfelseif LvarCtaAnt NEQ rsListaVersion.CVPcuenta>
							<cfset sbTotales(3)>
							<cfset sbCorte3()>
						</cfif>
						<cfloop condition="LvarAno*100+LvarMes LT rsListaVersion.CPCanoMes">
							<cfset LvarMes = LvarMes + 1>
							<cfif LvarMes GT 12>
								<cfset LvarAno = LvarAno + 1>
								<cfset LvarMes = 1>
							</cfif>
							<td align="right" class="Datos">
								0.00
							</td>
						</cfloop>
							<td align="right" class="Datos">
								#lsCurrencyformat(rsListaVersion.VersionFinal,'none')#
							</td>
						<cfset LvarMes = LvarMes + 1>
						<cfif LvarMes GT 12>
							<cfset LvarAno = LvarAno + 1>
							<cfset LvarMes = 1>
						</cfif>
						<cfset LvarTotalCta = LvarTotalCta + rsListaVersion.VersionFinal>
						<cfset LvarTotales.C3[rsListaVersion.CPCmes] = LvarTotales.C3[rsListaVersion.CPCmes] + rsListaVersion.VersionFinal>
						<cfset LvarTotales.C3[13] = LvarTotales.C3[13] + rsListaVersion.VersionFinal>
					</cfloop>
					<cfset sbTotales(3)>
					<cfset sbTotales(2)>
					<cfset sbTotales(1)>
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
		<td align="center" class="ColHeader">Descripcion</td>
		<td align="center" class="ColHeader">Control</td>
		<cfloop query="rsListaMeses">
			<td align="center" class="ColHeader" nowrap>#rsListaMeses.AnoMes#</td>
		</cfloop>
		<td align="center" class="ColHeader" >TOTAL</td>
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
			font-size: 		8px;
			font-weight: 	none;
			white-space:	nowrap;
			padding-left: 	20px;
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
	<cfset sbCortePagina(2)>
	<tr>
		<td align="left" class="Corte1" colspan="15">#rsListaVersion.Oficina#</td>
	</tr>
</cffunction>

<cffunction name="sbCorte2" output="true">
	<cfset sbCortePagina(1)>
	<cfset LvarMonAnt = rsListaVersion.Mcodigo>
	<cfset LvarMoneda = "#rsListaVersion.Miso4217# #rsListaVersion.Mnombre#">
	<tr>
		<td align="left" class="Corte2" colspan="15">#rsListaVersion.Miso4217# #rsListaVersion.Mnombre#</td>
	</tr>
</cffunction>
<cffunction name="sbCorte3" output="true">
	<cfset LvarCtaAnt = rsListaVersion.CVPcuenta>
	<cfset LvarAno = LvarAnoIni>
	<cfset LvarMes = LvarMesIni>
	<cfset LvarTotalCta = 0>
	<cfset sbCortePagina(0)>
	<tr>
		<td align="left" class="Corte3" nowrap>#rsListaVersion.CPformato#</td>
		<td align="left" class="Datos" nowrap>#rsListaVersion.CPdescripcion#</td>
		<td align="left" class="Datos" width="1" nowrap>#rsListaVersion.tipo#</td>
</cffunction>

<cffunction name="sbTotales" output="true">
	<cfargument name="Corte" required="yes" type="numeric">
	
	<cfset LvarTotal = Arguments.Corte + 1>
	<cfif not isdefined("LvarTotales.C#LvarTotal#")>
		<cfset LvarTotales["C#LvarTotal#"] = ArrayNew(1)>
		<cfloop index="i" from="1" to="13">
			<cfset LvarTotales["C#LvarTotal#"][i] = 0>
		</cfloop>
		<cfreturn>
	</cfif>
	<cfif LvarTotal EQ 4>
		<cfloop condition="LvarAno*100+LvarMes LTE LvarAnoMesFin">
			<cfset LvarMes = LvarMes + 1>
			<cfif LvarMes GT 12>
				<cfset LvarAno = LvarAno + 1>
				<cfset LvarMes = 1>
			</cfif>
			<td align="right" class="Datos">
				0.00
			</td>
		</cfloop>
			<td align="right" class="Datos">
				<strong>#lsCurrencyformat(LvarTotalCta,'none')#</strong>
			</td> 
		</tr> 
		<cfreturn>
	<cfelseif LvarTotal LT 3>
		<cfreturn>
	</cfif>
	<cfset sbCortePagina(0)>
	<tr>
		<td align="left" class="Corte#Arguments.Corte#" colspan="3">
			<cfif LvarTotal EQ 1>
				Totales Generales
			<cfelseif LvarTotal EQ 2>
				Totales por Oficina
			<cfelseif LvarTotal EQ 3>
				Totales en #LvarMoneda#
			</cfif>
		</td>
		<cfset LvarMes = LvarMesIni>
		<cfset LvarAno = LvarAnoIni>
		<cfloop condition="LvarAno*100+LvarMes LTE LvarAnoMesFin">
			<td align="right" class="Datos">
				<strong>#lsCurrencyformat(LvarTotales["C#LvarTotal#"][LvarMes],'none')#</strong>
				<cfset LvarTotales["C#LvarTotal-1#"][LvarMes] = LvarTotales["C#LvarTotal-1#"][LvarMes] + LvarTotales["C#LvarTotal#"][LvarMes]>
				<cfset LvarTotales["C#LvarTotal#"][LvarMes] = 0>
			</td>
			<cfset LvarMes = LvarMes + 1>
			<cfif LvarMes GT 12>
				<cfset LvarAno = LvarAno + 1>
				<cfset LvarMes = 1>
			</cfif>
		</cfloop>
			<cfset LvarMes = 13>
			<td align="right" class="Datos">
				<strong>#lsCurrencyformat(LvarTotales["C#LvarTotal#"][LvarMes],'none')#</strong>
				<cfset LvarTotales["C#LvarTotal-1#"][LvarMes] = LvarTotales["C#LvarTotal-1#"][LvarMes] + LvarTotales["C#LvarTotal#"][LvarMes]>
				<cfset LvarTotales["C#LvarTotal#"][LvarMes] = 0>
			</td>
	</tr>
</cffunction>


