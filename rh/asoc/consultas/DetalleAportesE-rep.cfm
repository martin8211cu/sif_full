<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ReporteDeAnticiposPorEmpleado" default="Reporte de Anticipos por Empleado" returnvariable="LB_ReporteDeAnticiposPorEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificaci&oacute;n" returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Periodo" default="Periodo"	 returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Resumen" default="Resumen" returnvariable="LB_Resumen" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Sumas" default="Sumas" returnvariable="LB_Sumas" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<!--- TABLA TEMPORAL PARA ALMACENAR LOS DATOS DE LAS COLUMNAS --->
	<cf_dbtemp name="AportesD" returnvariable="AportesD" datasource="#session.dsn#">
		<cf_dbtempcol name="DEid" 		type="numeric"		mandatory="yes">
		<cf_dbtempcol name="ACAid"		type="numeric"		mandatory="no">
		<cf_dbtempcol name="ACATid"		type="numeric"		mandatory="no">
		<cf_dbtempcol name="ACASperiodo"type="numeric"		mandatory="no">
		<cf_dbtempcol name="ACASmes"	type="numeric"		mandatory="no">
		<cf_dbtempcol name="Monto" 		type="money"		mandatory="no">
		<cf_dbtempcol name="Concepto"	type="numeric"		mandatory="yes">
		<cf_dbtempcol name="tipo"		type="char"			mandatory="yes">
		<cf_dbtempcol name="DescConcep"	type="varchar(255)"	mandatory="yes">
	</cf_dbtemp>

	<cfset Lvar_PeriodoAnt = url.anno - 1>
	<!--- ACUMULADO DE APORTES DEL AÑO ANTERIOR --->
	<cfquery name="rsAporteAnt" datasource="#session.DSN#">
		insert into #AportesD# (DEid,ACAid,ACATid,ACASperiodo,ACASmes,Monto,Concepto,DescConcep,tipo)
		select c.DEid,c.ACAid, a.ACATid,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_PeriodoAnt#">,12, 
				round(ACAAaporteMes+ACAAsaldoInicial,2),0 as concepto,ACATdescripcion,b.ACAStipo
		from ACAportesAsociado a
		inner join ACAportesSaldos b
			  on b.ACAAid = a.ACAAid
		inner join ACAsociados c
			  on c.ACAid = a.ACAid
		inner join ACAportesTipo d
			  on d.ACATid = a.ACATid
		inner join DatosEmpleado de
			on de.DEid = c.DEid
		inner join ACLineaTiempoAsociado lt
		  on lt.ACAid = c.ACAid
		  and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between lt.ACLTAfdesde and ACLTAfhasta 
		  and lt.ACLTAfdesde <= ACAAfechaInicio
		where b.ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_PeriodoAnt#">
		  and b.ACASmes = 12
		  and a.ACAestado = 0
		<cfif isdefined('url.DEidentificacion') and LEN(TRIM(url.DEidentificacion)) and not isdefined('url.DEidentificacion')>
		and de.DEidentificacion >= '#url.DEidentificacion#'
		<cfelseif isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1)) and not isdefined('url.DEidentificacion')>
		and de.DEidentificacion <= '#url.DEidentificacion1#'
		<cfelseif isdefined('url.DEidentificacion') and LEN(TRIM(url.DEidentificacion)) and 
				isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1))>
		and de.DEidentificacion between '#url.DEidentificacion#' and '#url.DEidentificacion1#'
		</cfif>
		<cfif isdefined('url.Estado') and url.Estado NEQ -1>
		  and c.ACAestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Estado#">
		</cfif>
	</cfquery>	
	
	<cfquery name="rsAporte" datasource="#session.DSN#">
		insert into #AportesD# (DEid,ACAid,ACATid,ACASperiodo,ACASmes,Monto,Concepto,DescConcep,tipo)
		select c.DEid,c.ACAid, a.ACATid,b.ACASperiodo,b.ACASmes,round(ACAAaporteMes,2),0 as concepto,ACATdescripcion,ACAStipo
		from ACAportesAsociado a
		inner join ACAportesSaldos b
			  on b.ACAAid = a.ACAAid
		inner join ACAsociados c
			  on c.ACAid = a.ACAid
		inner join ACAportesTipo d
			  on d.ACATid = a.ACATid
		inner join DatosEmpleado de
			on de.DEid = c.DEid
		inner join ACLineaTiempoAsociado lt
		  on lt.ACAid = c.ACAid
		  and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between lt.ACLTAfdesde and ACLTAfhasta 
		  and lt.ACLTAfdesde <= ACAAfechaInicio
		where b.ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.anno#">
		and a.ACAestado = 0
		<cfif isdefined('url.DEidentificacion') and LEN(TRIM(url.DEidentificacion)) and not isdefined('url.DEidentificacion')>
		and de.DEidentificacion >= '#url.DEidentificacion#'
		<cfelseif isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1)) and not isdefined('url.DEidentificacion')>
		and de.DEidentificacion <= '#url.DEidentificacion1#'
		<cfelseif isdefined('url.DEidentificacion') and LEN(TRIM(url.DEidentificacion)) and 
				isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1))>
		and de.DEidentificacion between '#url.DEidentificacion#' and '#url.DEidentificacion1#'
		</cfif>
		<cfif isdefined('url.Estado') and url.Estado NEQ -1>
		  and c.ACAestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Estado#">
		</cfif>
	</cfquery>
	
	<cfquery name="rsIntereses" datasource="#session.DSN#">
		insert into #AportesD# (DEid,ACAid,ACATid,ACASperiodo,ACASmes,Monto,Concepto,DescConcep,tipo)
		select c.DEid,c.ACAid,a.ACATid,b.ACASperiodo,b.ACASmes,round(ACAAaporteMesInt,2),1 as Concepto,{fn concat('Bonos <br />',ACATdescripcion)},ACAStipo
		from ACAportesAsociado a
		inner join ACAportesSaldos b
			  on b.ACAAid = a.ACAAid
		inner join ACAsociados c
			  on c.ACAid = a.ACAid
		inner join ACAportesTipo d
			  on d.ACATid = a.ACATid
		inner join DatosEmpleado de
			on de.DEid = c.DEid
		inner join ACLineaTiempoAsociado lt
		  on lt.ACAid = c.ACAid
		  and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between lt.ACLTAfdesde and ACLTAfhasta 
		  and lt.ACLTAfdesde <= ACAAfechaInicio
		where b.ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.anno#">
		and a.ACAestado = 0
		<cfif isdefined('url.DEidentificacion') and LEN(TRIM(url.DEidentificacion)) and not isdefined('url.DEidentificacion')>
		and de.DEidentificacion >= '#url.DEidentificacion#'
		<cfelseif isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1)) and not isdefined('url.DEidentificacion')>
		and de.DEidentificacion <= '#url.DEidentificacion1#'
		<cfelseif isdefined('url.DEidentificacion') and LEN(TRIM(url.DEidentificacion)) and 
				isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1))>
		and de.DEidentificacion between '#url.DEidentificacion#' and '#url.DEidentificacion1#'
		</cfif>
		<cfif isdefined('url.Estado') and url.Estado NEQ -1>
		  and c.ACAestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Estado#">
		</cfif>
		<!--- and ACAAaporteMesInt > 0 ---> <!--- PARA QUE NO TOME EN CUENTA LA LIQUIDACION DE INTERESES --->
	</cfquery>
	<!--- INTERESES PERIODO ANTERIOR --->
	<cfquery name="rsInteresesAnt" datasource="#session.DSN#">
		insert into #AportesD# (DEid,ACAid,ACATid,ACASperiodo,ACASmes,Monto,Concepto,DescConcep,tipo)
		select c.DEid,c.ACAid, a.ACATid,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_PeriodoAnt#">,12, 
				sum(round(ACAAaporteMesInt+ACAAsaldoInicialInt,2)),1 as Concepto,{fn concat('Intereses <br />',ACATdescripcion)} ,'N'
		from ACAportesAsociado a
		inner join ACAportesSaldos b
			  on b.ACAAid = a.ACAAid
		inner join ACAsociados c
			  on c.ACAid = a.ACAid
		inner join ACAportesTipo d
			  on d.ACATid = a.ACATid
		inner join DatosEmpleado de
			on de.DEid = c.DEid
		inner join ACLineaTiempoAsociado lt
		  on lt.ACAid = c.ACAid
		  and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between lt.ACLTAfdesde and ACLTAfhasta 
		  and lt.ACLTAfdesde <= ACAAfechaInicio
		where b.ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_PeriodoAnt#">
		  and b.ACASmes = 12
		  and a.ACAestado = 0
		<cfif isdefined('url.DEidentificacion') and LEN(TRIM(url.DEidentificacion)) and not isdefined('url.DEidentificacion')>
		and de.DEidentificacion >= '#url.DEidentificacion#'
		<cfelseif isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1)) and not isdefined('url.DEidentificacion')>
		and de.DEidentificacion <= '#url.DEidentificacion1#'
		<cfelseif isdefined('url.DEidentificacion') and LEN(TRIM(url.DEidentificacion)) and 
				isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1))>
		and de.DEidentificacion between '#url.DEidentificacion#' and '#url.DEidentificacion1#'
		</cfif>
		<cfif isdefined('url.Estado') and url.Estado NEQ -1>
		  and c.ACAestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Estado#">
		</cfif>
		group by  c.DEid,c.ACAid, a.ACATid,ACATdescripcion
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
		order by DEidentificacion, ACASperiodo desc, ACASmes
	</cfquery>
<!--- <cf_dump var="#rsREporte#"> --->
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
	.titulo_1{
		font-size:12px;
		font-weight:bold;
		background-color:#DBDBDB;
		text-align:left;
		height:20px}
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
<cfif rsReporte.RecordCount>
		<table width="100%" cellpadding="1" cellspacing="0" align="center">
		<!--- ENCABEZADO --->
		<cfset vColspan = columnas.RecordCount + 2>
		<cfoutput>
		<tr class="titulo_empresa2"><td colspan="#vColspan#">&nbsp;</td></tr>
		<tr class="titulo_empresa2"><td colspan="#vColspan#" align="center"><strong>#Trim(Session.Enombre)#</strong></td></tr>
		<tr class="titulo_empresa2"><td colspan="#vColspan#" align="center"><strong>#Trim(LB_ReporteDeAnticiposPorEmpleado)#</strong></td></tr>
		<tr class="titulo_empresa2"><td colspan="#vColspan#" align="center"><strong>#LB_Periodo#:&nbsp;#url.anno#</strong></td></tr>
		<tr><td colspan="#vColspan#">&nbsp;</td></tr>
		</cfoutput>
		<cfset vTotal = 0>
		<cfset cont=0>
		<cfoutput query="rsReporte" group="DEid">
			<tr class="titulo_1" align="left"><td colspan="7">#DEidentificacion#&nbsp;-&nbsp;#nombre#</td></tr>
			<!--- TITULOS --->
			<tr class="titulo_columnar">
				<td  valign="bottom" nowrap align="left">#LB_Periodo#</td>
				<cfloop query="columnas">
					<td  valign="bottom" align="right">#DescConcep#</td>
				</cfloop>
			</tr>
			<cfset cont = cont +1>
			<cfset vDEid = rsReporte.DEid>
			<cfquery name="Lineas" dbtype="query">
				select distinct ACASmes as ACASmes, ACASperiodo,tipo
				from rsReporte
				where DEid = #vDEid#
				order by ACASperiodo, ACASmes,tipo
			</cfquery>
			<cfloop query="Lineas">
				<cfset Lvar_mes = Lineas.ACASmes>
				<cfset Lvar_periodo = Lineas.ACASperiodo>
				<cfset Lvar_tipo = Lineas.Tipo>
				<cfif Lvar_tipo EQ 'N'>
					<tr <cfif not cont MOD 2>class="listaPar"</cfif>>
						<td class="detalle">#ACASperiodo#/#ACASmes#</td>
						<cfloop query="columnas">
								<cfset Lvar_ACATid = columnas.ACATid>
								<cfset Lvar_Concepto = columnas.Concepto>
								<cfquery name="rsMonto" dbtype="query">
									select Monto
									from rsReporte
									where DEid = #vDEid#
									  and ACATid = #Lvar_ACATid#
									  and Concepto = #Lvar_Concepto#
									  and ACASmes = #Lvar_mes#
									  and ACASperiodo = #Lvar_periodo#
									  and tipo = '#Lvar_Tipo#'
								</cfquery>
							<td class="detaller">
								<cfif isdefined('rsMonto') and rsMonto.RecordCount GT 0>#LSCurrencyFormat(rsMonto.Monto,'none')#<cfelse><div align="center">-</div></cfif>
							</td>
						</cfloop>
					</tr>
				</cfif>
			</cfloop>
			<tr class="totales">
				<td >#LB_Sumas#</td>
				<cfloop query="columnas">
					<cfquery name="Totales" dbtype="query">
						select sum(Monto) as TotalCP
						from rsReporte
						where DEid = #vDEid#
						  and ACATid = #columnas.ACATid#
						  and Concepto = #columnas.Concepto#
						  and  not(Concepto = 0 and tipo = 'L')
						group by ACATid, Concepto
					</cfquery>
					<td align="right">
						<cfif Totales.RecordCount GT 0>#LSCurrencyFormat(Totales.TotalCP,'none')#<cfelse><div align="center">-</div></cfif>
					</td>
				</cfloop>
			</tr>
		</cfoutput>
 		<cfoutput>
			<tr class="totales">
				<td >#LB_Resumen#</td>
				<cfloop query="columnas">
					<cfquery name="Totales" dbtype="query">
						select sum(Monto) as TotalCP
						from rsReporte
						where ACATid = #columnas.ACATid#
						  and Concepto = #columnas.Concepto#
						  and  not(Concepto = 0 and tipo = 'L')
						group by ACATid, Concepto
					</cfquery>
					<td align="right">
						<cfif Totales.RecordCount GT 0>#LSCurrencyFormat(Totales.TotalCP,'none')#<cfelse><div align="center">-</div></cfif>
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