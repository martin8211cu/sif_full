<cfsetting enablecfoutputonly="yes" requesttimeout="36000" showdebugoutput="no">

<!--- Obtiene el Periodo Contable --->
<cfset LvarFechas = fnPeriodoContable (form.Speriodo, form.Smes)>

<!--- Obtiene Parámetros del Tipo Proyecto y sus Cortes --->
<cfset LvarCortes = arrayNew(1)>
<cfquery name="rsSQL" datasource="#session.DSN#">
	select tp.OBTPnivelObjeto, tp.PCCEclaidOG, co.OBTPCnivel, co.OBTPCencabezado, tp.OBTPnivelProyecto
	  from OBtipoProyecto tp
	  	inner join OBTPcedulaObrasDet co
			on co.OBTPid = tp.OBTPid
	 where tp.OBTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#">
</cfquery>

<cfset LvarCortesN = rsSQL.recordCount>

<cfif LvarCortesN EQ 0>
	<cf_errorCode	code = "50432" msg = "Falta definir los parámetros de Cedula de Obras en Tipo de Proyecto">
</cfif>

<cfset LvarNivelPR	= rsSQL.OBTPnivelProyecto>
<cfset LvarNivelOG	= rsSQL.OBTPnivelObjeto>
<cfset LvarClaidOG	= rsSQL.PCCEclaidOG>

<cfset LvarMontosI = LvarCortesN + 2>
<cfset LvarIdx = 1>
<cfloop query="rsSQL">
	<cfset LvarCortes[LvarIdx] = StructNew()>
	<cfset LvarCortes[LvarIdx].Nivel = rsSQL.OBTPCnivel>
	<cfset LvarCortes[LvarIdx].Encab = rsSQL.OBTPCencabezado>
	<cfset LvarIdx = LvarIdx + 1>
</cfloop>

<cftry>
	<!--- Obtiene las Cuentas+Oficinas con saldos en el Período --->
	<cf_dbtemp name="OBCODv1" datasource="#session.dsn#" returnVariable="cuentas">
		<cf_dbtempcol name="Ecodigo" type="int" 	mandatory="yes">
		<cf_dbtempcol name="Ocodigo" type="int" 	mandatory="yes">
		<cf_dbtempcol name="Ccuenta" type="numeric"	mandatory="yes">
	</cf_dbtemp>
	
	<cfquery datasource="#session.DSN#">
		insert into #cuentas# (Ecodigo, Ccuenta, Ocodigo)
		select distinct #session.Ecodigo#, s.Ccuenta, s.Ocodigo
		  from SaldosContables s 
				inner join Oficinas o
				   on o.Ecodigo = s.Ecodigo
				  and o.Ocodigo= s.Ocodigo
		<cfif form.Ocodigo NEQ "">
				  and o.Ocodigo = #form.Ocodigo#
		</cfif>
				inner join CContables c
			
				   on c.Ccuenta = s.Ccuenta
				  and c.Ecodigo	= s.Ecodigo
				  and c.Cformato	>= '#form.Cmayor#'
				  and c.Cformato	<= '#form.Cmayor & chr(255)#'
		 where s.Ecodigo = #session.Ecodigo#
		   and 
		<cfif LvarFechas.FechaIni.Mes EQ 1>
				s.Speriodo = #LvarFechas.FechaIni.Ano#
		<cfelse>
			(
				s.Speriodo = #LvarFechas.FechaIni.Ano# and s.Smes>=#LvarFechas.FechaIni.Mes#
			OR
				s.Speriodo = #LvarFechas.FechaFin.Ano# and s.Smes<=#LvarFechas.FechaFin.Mes#
			)
		</cfif>
	</cfquery>
	
	<!--- Obtiene las Clasificaciones de Objetos de Gasto --->
	<cfquery datasource="#session.DSN#" name="rsCG">
		select distinct d.PCCDvalor, d.PCCDclaid, d.PCCDdescripcion
		  from #cuentas# c
			inner join PCDCatalogoCuenta cuboCG <cf_dbforceindex name="PCDCatalogoCuenta_11">
				 inner join PCDClasificacionCatalogo pcdccCG
					inner join PCClasificacionD d
					   on d.PCCDclaid = pcdccCG.PCCDclaid
				   on pcdccCG.PCCEclaid = #LvarClaidOG#
				  and pcdccCG.PCDcatid  = cuboCG.PCDcatid
			   on cuboCG.Ccuenta = c.Ccuenta
			  and cuboCG.PCDCniv = #LvarNivelOG#
		 order by PCCDvalor
	</cfquery>
	
	<cfset LvarCGsList = "">
	<cfset LvarCGsListN = 0>
	<cfset LvarCGsDescrip = structNew()>
	<cfset LvarCGsMontosCero = StructNew()>
	<cfset LvarCGsMontos = arrayNew(1)>
	
	<cfset LvarCGsMontosCero["CG0"] = 0>
	<cfset LvarCGsMontosCero["SaldoIni"] = 0>
	<cfset LvarCGsMontosCero["SaldoFin"] = 0>
	
	<cfoutput query="rsCG">
		<cfset LvarCGsMontosCero["CG#PCCDclaid#"] = 0>
		<cfif PCCDclaid NEQ "0">
			<cfset LvarCGsList = "#LvarCGsList#,CG#PCCDclaid#">
			<cfset LvarCGsListN = LvarCGsListN + 1>
			<cfset LvarCGsDescrip["CG#PCCDclaid#"] = PCCDdescripcion>
		</cfif>
	</cfoutput>
	<cfset LvarCGsMontosList = "">
	<cfloop collection="#LvarCGsMontosCero#" item="LvarName">
		<cfset LvarCGsMontosList = "#LvarCGsMontosList#,#LvarName#">
	</cfloop>
	
	<!--- Genera y ejecuta el SQL --->
	<cfquery datasource="#session.DSN#" name="rsDatos">
		select 
			  o.Oficodigo, o.Odescripcion
		<cfloop index="i" from="1" to="#LvarCortesN#">
			, valor#i#.PCDvalor as corte#i#
		</cfloop>	  
		<cfloop index="i" from="#LvarCortesN+1#" to="10">
			, '0' as corte#i#
		</cfloop>	  
			, coalesce(pcdccCG.PCCDclaid, 0) as corteCG
		
			, coalesce(sum(s1.SLinicial),0) as SaldoInicialPeriodo
				
			, coalesce(sum(s2.SLinicial),0 ) as SaldoInicialMes
		
			, coalesce(sum(s3.DLdebitos-s3.CLcreditos),0 )as MovimientosMes
				
		  from #cuentas# c
		  	left outer join SaldosContables s1
				on s1.Ccuenta 	= c.Ccuenta
			   and s1.Speriodo 	= #LvarFechas.FechaIni.Ano#
			   and s1.Smes 		= #LvarFechas.FechaIni.Mes#
			   and s1.Ecodigo 	= c.Ecodigo
			  and s1.Ocodigo 	= c.Ocodigo
			  
			left outer join SaldosContables s2
				 on s2.Ccuenta 	= c.Ccuenta
				and s2.Speriodo	= #LvarFechas.Fecha.Ano#
				and s2.Smes 	= #LvarFechas.Fecha.Mes#
				and s2.Ecodigo 	= c.Ecodigo
				and s2.Ocodigo 	= c.Ocodigo
			
			left outer join SaldosContables s3
				 on s1.Ccuenta 	= c.Ccuenta
				and s1.Speriodo = #LvarFechas.Fecha.Ano#
				and s1.Smes 	= #LvarFechas.Fecha.Mes#
				and s1.Ecodigo 	= c.Ecodigo
				and s1.Ocodigo 	= c.Ocodigo
			
			inner join Oficinas o
			   on o.Ecodigo = c.Ecodigo
			  and o.Ocodigo	= c.Ocodigo
		<cfloop index="i" from="1" to="#LvarCortesN#">
			inner join PCDCatalogoCuenta cubo#i# <cf_dbforceindex name="PCDCatalogoCuenta_11">
				inner join PCDCatalogo valor#i#
			<cfif LvarCortes[i].Nivel EQ LvarNivelPR>
					inner join OBproyecto OBP#i#
					   on OBP#i#.PCDcatidPry = valor#i#.PCDcatid
					  and OBP#i#.OBTPid = #form.OBTPid#
			</cfif>
				   on valor#i#.PCDcatid = cubo#i#.PCDcatid
			   on cubo#i#.Ccuenta = c.Ccuenta
			  and cubo#i#.PCDCniv = #LvarCortes[i].Nivel#
		</cfloop>	  
			inner join PCDCatalogoCuenta cuboCG <cf_dbforceindex name="PCDCatalogoCuenta_11">
				 left join PCDClasificacionCatalogo pcdccCG
				   on pcdccCG.PCCEclaid = #LvarClaidOG#
				  and pcdccCG.PCDcatid  = cuboCG.PCDcatid
			   on cuboCG.Ccuenta = c.Ccuenta
			  and cuboCG.PCDCniv = #LvarNivelOG#
		
			group by
				  o.Oficodigo, o.Odescripcion
		<cfloop index="i" from="1" to="#LvarCortesN#">
				, valor#i#.PCDvalor
		</cfloop>	  
				, coalesce(pcdccCG.PCCDclaid, 0)
			order by
				  o.Oficodigo 
		<cfloop index="i" from="1" to="#LvarCortesN#">
				, valor#i#.PCDvalor
		</cfloop>	  
	</cfquery>
	

	
	<cfflush interval="512">
	<cfif isdefined("form.btnDownload") or form.btnName EQ "btnDownload">
		<cfheader name="Content-Disposition" value="attachment;filename=rptCedula.xls">
		<cfcontent type="application/vnd.ms-excel">
	</cfif>
	<cf_htmlReportsHeaders 
		title="Cédula de Obras en Construcción" 
		filename="CedulaObras.xls"
		irA="cedulaObras.cfm" 
		>
	<cfoutput>
			<style type="text/css">
			<!--
				.repHeader {
					font-family: Arial, Helvetica, sans-serif;
					font-weight:bold;
					text-align:center;
					font-size: 14px;
				}
				.colHeader {
					font-family: Arial, Helvetica, sans-serif;
					font-weight:bold;
					text-align:center;
					border:solid 1px ##000000;
					font-size: 8px;
					padding-left:2px;
					padding-right:2px;
					background-color: ##EBEBEB;
				}
				.colDataOFI {
					font-family: Arial, Helvetica, sans-serif;
					font-size: 12px;
					font-weight:bold;
					text-align:right;
					border-top:solid 1px ##000000;
					border-bottom:solid 1px ##000000; 
				}
				.colDataHDR {
					font-family: Arial, Helvetica, sans-serif;
					font-size: 8px;
					font-weight:bold;
					text-align:right;
					border-top:solid 1px ##000000;
					border-bottom:solid 1px ##000000;
					padding-left:5px;
				}
				.colDataCG {
					font-family: Arial, Helvetica, sans-serif;
					font-size: 8px;
					text-align:right;
					padding-left:1px;
				}
			-->
			</style>
			<table border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
				<tr class="repHeader"><td colspan="#LvarCGsListN+11#" class="repHeader">#Session.Enombre#</td></tr>
				<tr class="repHeader"><td colspan="#LvarCGsListN+11#" class="repHeader">Cédula de Obras en Construcción</td></tr>
				<tr class="repHeader"><td colspan="#LvarCGsListN+11#" class="repHeader">Cuenta de Mayor #form.Cmayor#</td></tr>
				<tr class="repHeader"><td colspan="#LvarCGsListN+11#" class="repHeader">Al mes de #fnNombreMes(LvarFechas.Fecha.Mes)# de #LvarFechas.Fecha.Ano#</td></tr>
				<tr class="repHeader"><td>&nbsp;</td></tr>
				<tr>
					<cfloop index="LvarIdx" from="1" to="#LvarCortesN#">
					<td rowspan="2" class="colHeader">#LvarCortes[LvarIdx].Encab#</td>
					</cfloop>
					<td rowspan="2" class="colHeader">Saldo&nbsp;Inicial</td>
					<td colspan="#LvarCGsListN+1#" class="colHeader">Clasificacion de Objetos de Gasto</td>
					<td rowspan="2" class="colHeader">Saldo&nbsp;Final</td>
				</tr>
				<tr>
				<cfloop index="LvarClaidOG" list="#LvarCGsList#">
					<td class="colHeader">#LvarCGsDescrip[LvarClaidOG]#</td>
				</cfloop>
					<td class="colHeader">No Clasificado</td>
				</tr>
	</cfoutput>
	
	<cfset LvarTR = true>
	<cfset LvarCGsMontos[1] = LvarCGsMontosCero.clone()>
	<cfoutput query="rsDatos" group="Oficodigo">
		<cfset fnCorteEncabezado (0, "#Oficodigo# - #Odescripcion#")>
		<cfoutput group="Corte1">
			<cfset fnCorteEncabezado (1, Corte1)>
			<cfoutput group="Corte2">
				<cfset fnCorteEncabezado (2, Corte2)>
				<cfoutput group="Corte3">
					<cfset fnCorteEncabezado (3, Corte3)>
					<cfoutput group="Corte4">
						<cfset fnCorteEncabezado (4, Corte4)>
						<cfoutput group="Corte5">
							<cfset fnCorteEncabezado (5, Corte5)>
							<cfoutput group="Corte6">
								<cfset fnCorteEncabezado (6, Corte6)>
								<cfoutput group="Corte7">
									<cfset fnCorteEncabezado (7, Corte7)>
									<cfoutput group="Corte8">
										<cfset fnCorteEncabezado (8, Corte8)>
										<cfoutput group="Corte9">
											<cfset fnCorteEncabezado (9, Corte9)>
											<cfoutput group="Corte10">
												<cfset fnCorteEncabezado (10, Corte10)>
	
												<cfoutput>  <!---  group="CorteCG" --->
													<cfset LvarCGsMontos[LvarMontosI]["SaldoIni"] = LvarCGsMontos[LvarMontosI]["SaldoIni"] + SaldoInicialPeriodo>
													<cfset LvarCGsMontos[LvarMontosI]["CG#CorteCG#"] = LvarCGsMontos[LvarMontosI]["CG#CorteCG#"] 
														+ SaldoInicialMes - SaldoInicialPeriodo + MovimientosMes>
													<cfset LvarCGsMontos[LvarMontosI]["SaldoFin"] = LvarCGsMontos[LvarMontosI]["SaldoFin"] 
														+ SaldoInicialPeriodo + MovimientosMes>
												</cfoutput>
	
												<!--- Total Corte10 --->
												<cfset fnCorteTotal (10, Corte10)>
											</cfoutput>
											<!--- Total Corte9 --->
											<cfset fnCorteTotal (9, Corte9)>
										</cfoutput>
										<!--- Total Corte8 --->
										<cfset fnCorteTotal (8, Corte8)>
									</cfoutput>
									<!--- Total Corte7 --->
									<cfset fnCorteTotal (7, Corte7)>
								</cfoutput>
								<!--- Total Corte6 --->
								<cfset fnCorteTotal (6, Corte6)>
							</cfoutput>
							<!--- Total Corte5 --->
							<cfset fnCorteTotal (5, Corte5)>
						</cfoutput>
						<!--- Total Corte4 --->
						<cfset fnCorteTotal (4, Corte4)>
					</cfoutput>
					<!--- Total Corte3 --->
					<cfset fnCorteTotal (3, Corte3)>
				</cfoutput>
				<!--- Total Corte2 --->
				<cfset fnCorteTotal (2, Corte2)>
			</cfoutput>
			<!--- Total Corte1 --->
			<cfset fnCorteTotal (1, Corte1)>
		</cfoutput>
		<!--- Total Oficina --->
		<cfset fnCorteTotal (0, Oficodigo)>
	</cfoutput>							
	<cf_jdbcquery_close>
<cfcatch>
	<cf_jdbcquery_close>
	<cfrethrow>
</cfcatch>
</cftry>
<cfoutput>							
<cfset fnCorteTotal(-1,"")>
		</table>
	</body>
</html>
</cfoutput>							

<cffunction name="fnCorteEncabezado" output="true" access="private" returntype="void">
	<cfargument name="Corte" type="numeric" required="yes">
	<cfargument name="Valor" type="string" required="yes">

	<cfif Arguments.Corte GT LvarCortesN>
		<cfreturn>
	<cfelseif Arguments.Corte GT 0>
		<cfset LvarCGsMontos[Arguments.Corte+2] = LvarCGsMontosCero.clone()>
		<cfif LvarTR>
			<TR>
			<cfif Arguments.Corte GT 1>
				<TD colspan="#Arguments.Corte-1#"></TD>
			</cfif>
			<cfset LvarTR = false>
		</cfif>
				<TD style="text-align:left; padding-left:7px; border:none;" class="colDataHDR" nowrap>#Arguments.Valor#</td>
	<cfelse>
		<cfset LvarCGsMontos[2] = LvarCGsMontosCero.clone()>
			<TR><TD>&nbsp;</TD></TR>
			<TR>
				<TD style="text-align:left; border:none;" colspan="10" class="colDataOFI" nowrap>Oficina: #Arguments.Valor#</td>
			</TR>
			<TR><TD>&nbsp;</TD></TR>
		<cfset LvarTR = true>
	</cfif>
</cffunction>

<cffunction name="fnCorteTotal" output="true" access="private" returntype="void">
	<cfargument name="Corte" type="numeric" required="yes">
	<cfargument name="Valor" type="string" required="yes">

	<cfif Arguments.Corte GT LvarCortesN>
		<cfreturn>
	<cfelseif Arguments.Corte EQ LvarCortesN>
	<cfelseif Arguments.Corte GT 0>
		<TR>
		<cfif Arguments.Corte GT 1>
			<TD colspan="#Arguments.Corte-1#"></TD>
		</cfif>
			<TD colspan="#LvarCortesN-Arguments.Corte+1#" style="text-align:left" class="colDataHDR" nowrap>Total #Arguments.Valor#</td>
	<cfelseif Arguments.Corte EQ 0>
		<TR>
			<TD colspan="#LvarCortesN-Arguments.Corte#" style="text-align:left" class="colDataOFI" nowrap>Total Oficina #Arguments.Valor#:</td>
	<cfelse>
		<TR><TD>&nbsp;</TD></TR>
		<TR>
			<TD colspan="#LvarCortesN-Arguments.Corte-1#" style="text-align:left" class="colDataOFI" nowrap>TOTAL GENERAL:</td>
	</cfif>
	<cfset sbImprimeAcumulaMontos(Arguments.Corte+2)>
	</TR><cfset LvarTR = true>
</cffunction>

<cffunction name="sbImprimeAcumulaMontos" output="true">
	<cfargument name="Total" required="yes">

	<cfif Arguments.Total EQ LvarMontosI>
		<cfset LvarTipo = "CG">
	<cfelse>
		<cfset LvarTipo = "HDR">
	</cfif>
	<td align="right" class="colData#LvarTipo#" nowrap>#NumberFormat(LvarCGsMontos[Arguments.Total]["SaldoIni"],",0.00")#</td>
	<cfloop index="LvarClaidOG" list="#LvarCGsList#">
		<td align="right" class="colData#LvarTipo#" nowrap>#NumberFormat(LvarCGsMontos[Arguments.Total]["#LvarClaidOG#"],",0.00")#</td>
	</cfloop>
	<td align="right" class="colData#LvarTipo#" nowrap>#NumberFormat(LvarCGsMontos[Arguments.Total]["CG0"],",0.00")#</td>
	<td align="right" class="colData#LvarTipo#" nowrap>#NumberFormat(LvarCGsMontos[Arguments.Total]["SaldoFin"],",0.00")#</td>
	<cfif Arguments.Total GT 1>
		<cfloop index="LvarMontoId" list="#LvarCGsMontosList#">
			<cfset LvarCGsMontos[Arguments.Total-1] [LvarMontoId] = LvarCGsMontos[Arguments.Total-1] [LvarMontoId] + LvarCGsMontos[Arguments.Total] [LvarMontoId]>
		</cfloop>
	</cfif>
</cffunction>

<cffunction name="fnPeriodoContable" output="false" access="private" returntype="struct">
	<cfargument name="Ano" type="numeric" required="yes">
	<cfargument name="Mes" type="numeric" required="yes">
	
	<cfset var LvarFechas = structNew()>
	<cfset var LvarAnoMes = 0>
	<cfset var LvarAnoMesIni = 0>
	<cfset var LvarAnoMesFin = 0>
	<cfset var LvarAnoIni = 0>
	<cfset var LvarMesIni = 0>
	<cfset var LvarAnoFin = 0>
	<cfset var LvarMesFin = 0>

	<cfquery name="rsParametros" datasource="#session.DSN#">
		select 	ano.Pvalor as Ano,
				mes.Pvalor as Mes,
				ult.Pvalor as UltMes
		  from Parametros ano, Parametros mes, Parametros ult
		 where 	ano.Ecodigo = #session.Ecodigo# and ano.Pcodigo=30
		   and 	mes.Ecodigo = #session.Ecodigo# and mes.Pcodigo=40
		   and 	ult.Ecodigo = #session.Ecodigo# and ult.Pcodigo=45
	</cfquery>

	<cfif rsParametros.Ano EQ 0 or rsParametros.Mes EQ 0 or not isnumeric(rsParametros.Ano) or not isnumeric(rsParametros.Mes)>
		<cf_errorCode	code = "50427" msg = "Empresa no ha sido iniciada">
	</cfif>
	
	<cfif rsParametros.UltMes EQ 12>
		<cfset LvarAnoIni = rsParametros.Ano>
		<cfset LvarMesIni = 1>
		<cfset LvarAnoFin = rsParametros.Ano>
		<cfset LvarMesFin = 12>
	<cfelseif rsParametros.Mes GT rsParametros.UltMes>
		<cfset LvarAnoIni = rsParametros.Ano>
		<cfset LvarMesIni = rsParametros.UltMes+1>
		<cfset LvarAnoFin = rsParametros.Ano+1>
		<cfset LvarMesFin = rsParametros.UltMes>
	<cfelse>
		<cfset LvarAnoIni = rsParametros.Ano-1>
		<cfset LvarMesIni = rsParametros.UltMes+1>
		<cfset LvarAnoFin = rsParametros.Ano>
		<cfset LvarMesFin = rsParametros.UltMes>
	</cfif>
	
	<cfset LvarFechas.Actual 	= fnAnoMes(rsParametros.Ano,rsParametros.Mes)>
	<cfset LvarFechas.ActualIni = fnAnoMes(LvarAnoIni,LvarMesIni)>
	<cfset LvarFechas.ActualFin = fnAnoMes(LvarAnoFin,LvarMesFin)>
	
	<cfset LvarFechas.Fecha 	= fnAnoMes(Arguments.Ano, Arguments.Mes)>
	
	<cfif LvarFechas.Fecha.AnoMes GT LvarFechas.Actual.AnoMes>
		<cf_errorCode	code = "50428" msg = "No se puede consultar un mes futuro">
	</cfif>
	
	<cfset LvarAnoMes = LvarFechas.Fecha.AnoMes>
	<cfset LvarAnoMesIni = LvarFechas.ActualIni.AnoMes>
	<cfset LvarAnoMesFin = LvarFechas.ActualFin.AnoMes>
	<cfloop condition="NOT (LvarAnoMes GTE LvarAnoMesIni AND LvarAnoMes LTE LvarAnoMesFin)">
		<cfset LvarAnoMesIni = LvarAnoMesIni - 100>
		<cfset LvarAnoMesFin = LvarAnoMesFin - 100>
	</cfloop>
	<cfset LvarFechas.FechaIni 	= fnAnoMes(int(LvarAnoMesIni/100),LvarAnoMesIni mod 100)>
	<cfset LvarFechas.FechaFin 	= fnAnoMes(int(LvarAnoMesFin/100),LvarAnoMesFin mod 100)>
	<cfreturn LvarFechas>
</cffunction>

<cffunction name="fnAnoMes" output="false" access="private" returntype="struct">
	<cfargument name="Ano" type="numeric" required="yes">
	<cfargument name="Mes" type="numeric" required="yes">
	
	<cfset var LvarAnoMes = structNew()>
	<cfset LvarAnoMes.Ano 	 = Arguments.Ano>
	<cfset LvarAnoMes.Mes 	 = Arguments.Mes>
	<cfset LvarAnoMes.AnoMes = Arguments.Ano*100 + Arguments.Mes>
	<cfreturn LvarAnoMes>
</cffunction>

<cffunction name="fnNombreMes" output="false" access="private" returntype="string">
	<cfargument name="Mes" type="numeric" required="yes">
	<cfswitch expression="#Arguments.Mes#">
		<cfcase value="1"><cfreturn "Enero"></cfcase>
		<cfcase value="2"><cfreturn "Febrero"></cfcase>
		<cfcase value="3"><cfreturn "Marzo"></cfcase>
		<cfcase value="4"><cfreturn "Abril"></cfcase>
		<cfcase value="5"><cfreturn "Mayo"></cfcase>
		<cfcase value="6"><cfreturn "Junio"></cfcase>
		<cfcase value="7"><cfreturn "Julio"></cfcase>
		<cfcase value="8"><cfreturn "Agosto"></cfcase>
		<cfcase value="9"><cfreturn "Setiembre"></cfcase>
		<cfcase value="10"><cfreturn "Octubre"></cfcase>
		<cfcase value="11"><cfreturn "Noviembre"></cfcase>
		<cfcase value="12"><cfreturn "Diciembre"></cfcase>
	</cfswitch>
</cffunction>


