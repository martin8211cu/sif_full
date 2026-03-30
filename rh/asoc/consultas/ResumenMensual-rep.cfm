<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ResumenMensual" default="Resumen Mensual" returnvariable="LB_ResumenMensual" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->


<!--- VERIFICA SI LA EMPRESA ES DE GUATEMALA PARA MOSTRAR OTROS DATOS --->
<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select 1
	from Empresa e
		inner join Direcciones d
		on d.id_direccion = e.id_direccion
		and Ppais = 'GT'
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>

<cfif rsEmpresa.RecordCount>
	<cfset Lvar_Excepciones = ''>
	<cfquery name="rsSilva" datasource="#session.DSN#">
		select Pvalor from ACParametros where Pcodigo = 130
	</cfquery>
	<cfif isdefined('rsSilva') and rsSilva.RecordCount>
		<cfset Lvar_CSilva = rsSilva.Pvalor>
		<cfset Lvar_Excepciones = ListAppend(Lvar_Excepciones,Lvar_CSilva)>
	<cfelse>
		<cfthrow message="No se ha definido el parámetro para Crédito SilvaCano, para el reporte Resumen Mensual.">
	</cfif>
	<cfquery name="rsElect" datasource="#session.DSN#">
		select Pvalor from ACParametros where Pcodigo = 140
	</cfquery>
	<cfif isdefined('rsElect') and rsElect.RecordCount>
		<cfset Lvar_CElect = rsElect.Pvalor>
		<cfset Lvar_Excepciones = ListAppend(Lvar_Excepciones,Lvar_CElect)>
	<cfelse>
		<cfthrow message="No se ha definido el parámetro para Crédito Electrodom&eacute;stico, para el reporte Resumen Mensual.">
	</cfif>
</cfif>

<!--- TABLA TEMPORAL PARA LOS ASOCIADOS CON CREDITOS --->
    <cf_dbtemp name="salidaAsociados" returnvariable="Asociados">
    	<cf_dbtempcol name="DEid"   		type="numeric"     	mandatory="yes">
        <cf_dbtempcol name="Capital"   		type="money"     	mandatory="yes">
        <cf_dbtempcol name="Intereses"		type="money"		mandatory="no">
        <cf_dbtempcol name="SaldoCap"		type="money"		mandatory="no">
        <cf_dbtempcol name="SaldoInt"		type="money"		mandatory="no">
        <cf_dbtempcol name="CElect"			type="money"		mandatory="no">
        <cf_dbtempcol name="CSilva"			type="money"		mandatory="no">
        <cf_dbtempkey cols="DEid">
    </cf_dbtemp>

	<cfquery name="rsAsociados" datasource="#session.DSN#">
		insert into #Asociados# (DEid,Capital)
		select a.DEid, sum(ACCTcapital) as Capital
		from DatosEmpleado a
		inner join ACAsociados b
			on b.DEid = a.DEid
		inner join ACCreditosAsociado c
			  on c.ACAid = b.ACAid
			 and c.ACCTfechaInicio <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fecha)#">
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined('url.DEidentificacion') and LEN(TRIM(url.DEidentificacion)) and not isdefined('url.DEidentificacion1')>
		and a.DEidentificacion >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DEidentificacion#">
		<cfelseif isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1)) and not isdefined('url.DEidentificacion')>
		and a.DEidentificacion <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DEidentificacion1#">
		<cfelseif isdefined('url.DEidentificacion') and LEN(TRIM(url.DEidentificacion)) and 
				isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1))>
		and a.DEidentificacion between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DEidentificacion#">
				and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DEidentificacion1#">
		</cfif>
		and (c.ACCTcapital - c.ACCTamortizado) >= 0
		group by a.DEid
	</cfquery>
	
		<!--- ACTUALIZA LOS INTERESES DE LOS CREDITOS PARA CADA ASOCIADO --->
	<cfquery name="rsIntereses" datasource="#session.DSN#">
		update #Asociados#
 		set Capital = (select coalesce(sum(ACCTcapital),0.00)
						from ACAsociados a
						inner join ACCreditosAsociado b
							  on b.ACAid = a.ACAid
							  and (b.ACCTcapital - b.ACCTamortizado) > 0
						<cfif rsEmpresa.RecordCount>
						inner join ACCreditosTipo d
							  on d.ACCTid = b.ACCTid
							  and d.ACCTid not in(#Lvar_Excepciones#)
						</cfif>
						where a.DEid = #Asociados#.DEid
						)
		
	</cfquery>

	<!--- ACTUALIZA LOS INTERESES DE LOS CREDITOS PARA CADA ASOCIADO --->
	<cfquery name="rsIntereses" datasource="#session.DSN#">
		update #Asociados#
 		set Intereses = (select sum(ACPPpagoInteres)
						from ACAsociados a
						inner join ACCreditosAsociado b
							  on b.ACAid = a.ACAid
							  and (b.ACCTcapital - b.ACCTamortizado) > 0
						inner join ACPlanPagos c
							  on c.ACCAid = b.ACCAid
						<cfif rsEmpresa.RecordCount>
						inner join ACCreditosTipo d
							  on d.ACCTid = b.ACCTid
							  and d.ACCTid not in(#Lvar_Excepciones#)
						</cfif>
						where a.DEid = #Asociados#.DEid
						)
		
	</cfquery>
	<!--- ACTUALIZA EL SALDO DE LOS CREDITOS PARA CADA ASOCIADO --->
	<cfquery name="rsSaldoCap" datasource="#session.DSN#">
		update #Asociados#
 		set SaldoCap = (select sum(ACPPpagoPrincipal)
						from ACAsociados a
						inner join ACCreditosAsociado b
							  on b.ACAid = a.ACAid
							  and (b.ACCTcapital - b.ACCTamortizado) > 0
						inner join ACPlanPagos c
							  on c.ACCAid = b.ACCAid
							  and ACPPestado = 'N'
						<cfif rsEmpresa.RecordCount>
						inner join ACCreditosTipo d
							  on d.ACCTid = b.ACCTid
							  and d.ACCTid not in(#Lvar_Excepciones#)
						</cfif>
						where a.DEid = #Asociados#.DEid
						)
	</cfquery>
	<!--- ACTUALIZA EL SALDO DE LOS INTERESES DE LOS CREDITOS PARA CADA ASOCIADO --->
	<cfquery name="rsSaldoInt" datasource="#session.DSN#">
		update #Asociados#
 		set SaldoInt = (select sum(ACPPpagoInteres)
						from ACAsociados a
						inner join ACCreditosAsociado b
							  on b.ACAid = a.ACAid
							  and (b.ACCTcapital - b.ACCTamortizado) > 0
						inner join ACPlanPagos c
							  on c.ACCAid = b.ACCAid
							  and ACPPestado = 'N'
						<cfif rsEmpresa.RecordCount>
						inner join ACCreditosTipo d
							  on d.ACCTid = b.ACCTid
							  and d.ACCTid not in(#Lvar_Excepciones#)
						</cfif>
						where a.DEid = #Asociados#.DEid
						)
	</cfquery>
	<cfif rsEmpresa.RecordCount>
		<!--- ACTUALIZA LOS CREDITOS ELECTRODOMESTICOS PARA CADA ASOCIADO --->
		<cfquery name="rsSaldoInt" datasource="#session.DSN#">
			update #Asociados#
			set CElect = (select sum(b.ACCTcapital - b.ACCTamortizado)
							from ACAsociados a
							inner join ACCreditosAsociado b
								  on b.ACAid = a.ACAid
								  and (b.ACCTcapital - b.ACCTamortizado) > 0
							inner join ACCreditosTipo d
								  on d.ACCTid = b.ACCTid
								  and d.ACCTid = #Lvar_CElect#
							where a.DEid = #Asociados#.DEid
							)
		</cfquery>
		<!--- ACTUALIZA LOS CREDITOS SILVACANO PARA CADA ASOCIADO --->
		<cfquery name="rsSaldoInt" datasource="#session.DSN#">
			update #Asociados#
			set CSilva = (select sum(b.ACCTcapital - b.ACCTamortizado)
							from ACAsociados a
							inner join ACCreditosAsociado b
								  on b.ACAid = a.ACAid
								  and (b.ACCTcapital - b.ACCTamortizado) > 0
							inner join ACCreditosTipo d
								  on d.ACCTid = b.ACCTid
								  and d.ACCTid = #Lvar_CSilva#
							where a.DEid = #Asociados#.DEid
							)
		</cfquery>
	</cfif>
<cfquery name="rsReporte" datasource="#session.DSN#">
	select a.*, 
		DEidentificacion,
		{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombre
	from #Asociados# a
	inner join DatosEmpleado b
		on b.DEid = a.DEid
	order by DEidentificacion
</cfquery>
<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsTotalesCol" dbtype="query">
	select sum(Capital) as TotalCapital,
		   sum(Intereses) as TotalInt,
		   sum(SaldoCap) as TotalSaldoC,
		   sum(SaldoInt) as TotalSaldoI,
		   sum(CElect) as TotalCElect,
		   sum(CSilva) as TotalCSilva
	from rsReporte
	<cfif isdefined('url.chkSaldoCero')>
	where Capital <> SaldoCap
	</cfif>
</cfquery>

<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.titulo_empresa2 {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;
		height:20px}
	.detalle {
		font-size:14px;
		text-align:left;}
	.detaller {
		font-size:14px;
		text-align:right;}
	.detallec {
		font-size:14px;
		text-align:center;}
	.totales {
		font-size:14px;
		text-align:right;
		font-weight:bold;}	
</style>

<cfif rsReporte.RecordCount>
	<cfif rsEmpresa.RecordCount><cfset LvarCols = 8><cfelse><cfset LvarCols = 6></cfif>
	<table width="700" align="center" border="0" cellspacing="0" cellpadding="2">
		<cfoutput>
		<tr><td align="center" colspan="#LvarCols#" class="titulo_empresa2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
		<tr><td align="center" colspan="#LvarCols#" class="titulo_empresa2"><strong>#LB_ResumenMensual#</strong></td></tr>
		<tr><td colspan="#LvarCols#">&nbsp;</td></tr>
		<tr><td align="right" colspan="#LvarCols#" class="detaller"><strong>#LB_Fecha#:#LSDateFormat(now(),'dd/mm/yyyy')#</strong></td></tr>
		</cfoutput>
		<tr><td colspan="#LvarCols#">&nbsp;</td></tr>
		<tr class="titulo_columnar">
			<td align="center"><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate></td>
			<td align="center"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
			<td align="center"><cf_translate key="LB_Capital">Capital</cf_translate></td>
			<td align="center"><cf_translate key="LB_Intereses">Intereses</cf_translate></td>
			<td align="center"><cf_translate key="LB_SaldoCapital">Saldo Capital</cf_translate></td>
			<td align="center"><cf_translate key="LB_SaldoInteres">Saldo Inter&eacute;s</cf_translate></td>
			<cfif rsEmpresa.RecordCount>
			<td align="center"><cf_translate key="LB_Tienda">Tienda</cf_translate></td>
			<td align="center"><cf_translate key="LB_Silva">Silva</cf_translate></td>
			</cfif>
		</tr>
		
		<cfoutput query="rsReporte">
			<cfset Lvar_ImprimeSaldosCero = 1>
			<cfif rsReporte.Capital GTE rsReporte.SaldoCap and isdefined('url.chkSaldoCero')>
				<cfset Lvar_ImprimeSaldosCero = 0>
			</cfif>
			<cfif Lvar_ImprimeSaldosCero>
			<tr>
				<td class="detalle">#DEidentificacion#</td>
				<td class="detalle" nowrap>#nombre#</td>
				<td class="detaller">#LSCurrencyFormat(Capital,'none')#</td>
				<td class="detaller">#LSCurrencyFormat(Intereses,'none')#</td>
				<td class="detaller">#LSCurrencyFormat(SaldoCap,'none')#</td>
				<td class="detaller">#LSCurrencyFormat(SaldoInt,'none')#</td>
				<cfif rsEmpresa.RecordCount>
				<td class="detaller"><cfif CElect GT 0>#LSCurrencyFormat(CElect,'none')#<cfelse>&nbsp;</cfif></td>
				<td class="detaller"><cfif CSilva GT 0>#LSCurrencyFormat(CSilva,'none')#<cfelse>&nbsp;</cfif></td>
				</cfif>
			</tr>
			</cfif>
		</cfoutput>
		<cfif isdefined('url.chkTotales')>
			<cfoutput>
			<tr>
				<td colspan="2"></td>
				<td height="1" bgcolor="000000" colspan="#LvarCols#"></td>
			<tr height="20">
				<td class="totales" colspan="2"><cf_translate key="LB_Totales">Totales</cf_translate></td>
				<td class="detaller">#LSCurrencyFormat(rsTotalesCol.TotalCapital,'none')#</td>
				<td class="detaller">#LSCurrencyFormat(rsTotalesCol.TotalInt,'none')#</td>
				<td class="detaller">#LSCurrencyFormat(rsTotalesCol.TotalSaldoC,'none')#</td>
				<td class="detaller">#LSCurrencyFormat(rsTotalesCol.TotalSaldoI,'none')#</td>
				<cfif rsEmpresa.RecordCount>
				<td class="detaller"><cfif rsTotalesCol.TotalCElect GT 0>#LSCurrencyFormat(rsTotalesCol.TotalCElect,'none')#</cfif></td>
				<td class="detaller"><cfif rsTotalesCol.TotalCSilva GT 0>#LSCurrencyFormat(rsTotalesCol.TotalCSilva,'none')#</cfif></td>
				</cfif>
			</tr>
			</cfoutput>
		</cfif>
	</table>
<cfelse>
	<table width="700" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr><td align="center"><cf_translate key="MSG_NoHayDatosRelacionados">No hay datos relacionados</cf_translate></td></tr>
	</table>
</cfif>