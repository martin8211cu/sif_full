<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ResumenCuentaCorrienteAhorroSolidarista" default="Resumen Cuenta Corriente Ahorro Solidarista" returnvariable="LB_ResumenCuentaCorrienteAhorroSolidarista" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificaci&oacute;n" returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Mes" default="Mes" returnvariable="LB_Mes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Totales" default="Totales" returnvariable="LB_Totales" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<!--- TABLA TEMPORAL PARA ALMACENAR LOS DATOS DE LAS COLUMNAS --->
	<cf_dbtemp name="AportesR" returnvariable="AportesD" datasource="#session.dsn#">
		<cf_dbtempcol name="DEid" 		type="numeric"		mandatory="yes">
		<cf_dbtempcol name="ACAid"		type="numeric"		mandatory="no">
		<cf_dbtempcol name="ACATid"		type="numeric"		mandatory="no">
		<cf_dbtempcol name="Monto" 		type="money"		mandatory="no">
		<cf_dbtempcol name="Concepto"	type="numeric"		mandatory="yes">
		<cf_dbtempcol name="tipo"		type="char"			mandatory="yes">
		<cf_dbtempcol name="DescConcep"	type="varchar(255)"	mandatory="yes">
	</cf_dbtemp>

	
	<cfquery name="rsAporte" datasource="#session.DSN#">
		insert into #AportesD# (DEid,ACAid,ACATid,Monto,Concepto,DescConcep,tipo)
		select c.DEid,c.ACAid, a.ACATid,
			(ACAAsaldoInicial + ACAAaporteMes) as ACAAaporteMes,
			0 as concepto,ACATdescripcion,ACAStipo
		from ACAportesAsociado a
		inner join ACAportesSaldos b
			  on b.ACAAid = a.ACAAid
		inner join ACAsociados c
			  on c.ACAid = a.ACAid
		inner join ACAportesTipo d
			  on d.ACATid = a.ACATid
		inner join DatosEmpleado de
			on de.DEid = c.DEid
		where b.ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
		  and b.ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		   and a.ACAestado = 0
		<cfif isdefined('url.DEid') and LEN(TRIM(url.DEid))>
		  and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
		<cfif isdefined('url.Estado') and url.Estado NEQ -1>
		  and c.ACAestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Estado#">
		</cfif>
		
	</cfquery>
	<cfquery name="rsIntereses" datasource="#session.DSN#">
		insert into #AportesD# (DEid,ACAid,ACATid,Monto,Concepto,DescConcep,tipo)
		select c.DEid,c.ACAid,a.ACATid,
			(ACAAsaldoInicialInt+ACAAaporteMesInt) as ACAAaporteMesInt,
			1 as Concepto,{fn concat('Intereses ',ACATdescripcion)} ,ACAStipo
		from ACAportesAsociado a
		inner join ACAportesSaldos b
			  on b.ACAAid = a.ACAAid
		inner join ACAsociados c
			  on c.ACAid = a.ACAid
		inner join ACAportesTipo d
			  on d.ACATid = a.ACATid
		inner join DatosEmpleado de
			on de.DEid = c.DEid
		where b.ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
		  and b.ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		   and a.ACAestado = 0
		<cfif isdefined('url.DEid') and LEN(TRIM(url.DEid))>
		  and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
		<cfif isdefined('url.Estado') and url.Estado NEQ -1>
		  and c.ACAestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Estado#">
		</cfif>
	</cfquery>
	<cfquery name="columnas" datasource="#session.DSN#">
		select distinct ACATid,Concepto,DescConcep
		from #AportesD#
		order by Concepto
	</cfquery>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select a.*,
			{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat( ' ',DEapellido2)})})})} as Nombre,
			DEidentificacion
		from #AportesD# a
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

<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.titulo_empresa2 {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_columnar {
		font-size:12px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;
		height:20px}
	.detalle {
		font-size:12px;
		text-align:left;}
	.detaller {
		font-size:12px;
		text-align:right;}
	.detallec {
		font-size:12px;
		text-align:center;}	
	.totales {
		font-size:12px;
		text-align:right;
		font-weight:bold;}	
</style>
<cfset meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
<cfif rsReporte.RecordCount>
		<table width="100%" cellpadding="1" cellspacing="0" align="center">
		<!--- ENCABEZADO --->
		<cfset vColspan = columnas.RecordCount + 2>
		<cfset vs_mes = listgetat(meses, url.mes)>
		<cfoutput>
		<tr class="titulo_empresa2"><td colspan="#vColspan#">&nbsp;</td></tr>
		<tr class="titulo_empresa2"><td colspan="#vColspan#" align="center"><strong>#Trim(Session.Enombre)#</strong></td></tr>
		<tr class="titulo_empresa2"><td colspan="#vColspan#" align="center"><strong>#Trim(LB_ResumenCuentaCorrienteAhorroSolidarista)#</strong></td></tr>
		<tr class="titulo_empresa2"><td colspan="#vColspan#" align="center"><strong>#LB_Mes#:&nbsp;#vs_mes#&nbsp;&nbsp;#LB_Periodo#:&nbsp;#url.Periodo#</strong></td></tr>
		<tr class="titulo_empresa2"><td colspan="#vColspan#" align="right"><strong>#LSDateFormat(now(),'dd/mm/yyyy')#</strong></td></tr>
		<tr><td colspan="#vColspan#">&nbsp;</td></tr>
		</cfoutput>
		<!--- TITULOS --->
		<tr class="titulo_columnar">
			<td nowrap align="left"><cfoutput>#LB_Identificacion#</cfoutput></td>
			<td nowrap align="left"><cfoutput>#LB_Nombre#</cfoutput></td>
			<cfoutput query="columnas">
				<td align="right">#DescConcep#</td>
			</cfoutput>
		</tr>
		<cfset vTotal = 0>
		<cfset cont=0>
		<cfoutput query="rsReporte" group="DEid">
			<cfif rsReporte.tipo EQ 'N'>
			<cfset cont = cont +1>
			<cfset vDEid = rsReporte.DEid>
			<tr <cfif not cont MOD 2>class="listaPar"</cfif>>
				<td class="detalle">#DEidentificacion#</td>
				<td class="detalle" nowrap>#Ucase(Nombre)#</td>
				<cfloop query="columnas">
					<cfset Lvar_ACATid = columnas.ACATid>
					<cfset Lvar_Concepto = columnas.Concepto>
					<cfquery name="rsMonto" dbtype="query">
						select sum(Monto) as Monto
						from rsReporte
						where DEid = #vDEid#
						  and ACATid = #Lvar_ACATid#
						  and Concepto = #Lvar_Concepto#
						  and tipo = 'N' <!--- no es liquidacion --->
					</cfquery>
					<td class="detaller">
						<cfif isdefined('rsMonto') and rsMonto.RecordCount GT 0>#LSCurrencyFormat(rsMonto.Monto,'none')#<cfelse><div align="center">-</div></cfif>
					</td>
				</cfloop>
			</tr>
			</cfif>
		</cfoutput>
 		<cfoutput>
			<tr class="totales">
				<td colspan="2" >#LB_Totales#</td>
				<cfloop query="columnas">
					<cfquery name="rsCP" dbtype="query">
						select sum(Monto) as TotalCP
						from rsReporte
						where ACATid = #columnas.ACATid#
						  and Concepto = #columnas.Concepto#
					</cfquery>
					<td align="right">
						<cfif rsCP.RecordCount GT 0>#LSCurrencyFormat(rsCP.TotalCP,'none')#<cfelse><div align="center">-</div></cfif>
					</td>
				</cfloop>
			</tr>
		</cfoutput>
	</table>

<cfelse>
	<table width="700" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr><td align="center"><cf_translate key="MSG_NoHayDatosRelacionados">No hay datos relacionados</cf_translate></td></tr>
	</table>
</cfif>