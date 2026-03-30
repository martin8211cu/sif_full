<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ReporteDeBonoEscolarSociosSolidaristas" default="Reporte de Bono Escolar Socios Solidaristas, Dep&oacute;sito en Banco" returnvariable="LB_TituloReporte" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<!--- ULTIMO PERIODO/MES CERRADO --->
<cfquery name="rs_periodo" datasource="#session.DSN#">
	select Pvalor as periodo
	from ACParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 10
</cfquery>
<cfquery name="rs_Mes" datasource="#session.DSN#">
	select Pvalor as mes
	from ACParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 20
</cfquery>
<cfif rs_Mes.mes eq 1><cfset mesA = 12 ><cfelse><cfset mesA = rs_Mes.mes - 1 ></cfif>
<cfif url.ACDDEPERIODO LT rs_periodo.Periodo>
	<cfset mesA = 12>
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select  d.DEidentificacion
			,{fn concat(d.DEnombre,{fn concat(' ',{fn concat(d.DEapellido1,{fn concat(' ',d.DEapellido2)})})})} as Nombre		
			,f.Bid
			,f.Bdescripcion	
			,d.DEcuenta			
			,coalesce(b.ACDDmonto,0) as ACDDmonto
			,coalesce((select(sum(e.ACAAsaldoInicialInt)+sum(e.ACAAaporteMesInt))
					from ACAportesSaldos e,ACAportesAsociado g
					where e.ACAAid = g.ACAAid
						and g.ACAid = b.ACAid 
						and b.ACDDEperiodo = e.ACASperiodo			
						and e.ACASmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mesA#">
					    and g.ACAestado = 0
					),0) as Monto
				 
	from ACDistribucionDividendosE a	
		inner join ACDistribucionDividendos b
			on a.ACDDEperiodo = b.ACDDEperiodo
			and a.Ecodigo = b.Ecodigo
			<cfif isdefined("url.ACDDEPERIODO") and len(trim(url.ACDDEPERIODO))>
				and b.ACDDEperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ACDDEPERIODO#"> 
			</cfif>
					
		inner join ACAsociados c
			on b.ACAid = c.ACAid
					
		inner join DatosEmpleado d
			on c.DEid = d.DEid	
			<cfif isdefined("url.DEidentificacion") and len(trim(url.DEidentificacion)) and isdefined("url.DEidentificacion_h") and len(trim(url.DEidentificacion_h))><!---DEid inicial y DEid final---->
				<cfif url.DEidentificacion GT url.DEidentificacion_h>
					and d.DEidentificacion between <cfqueryparam cfsqltype="cf_sql_char" value="#url.DEidentificacion_h#">
											and <cfqueryparam cfsqltype="cf_sql_char" value="#url.DEidentificacion#">	
				<cfelse>
					and d.DEidentificacion between <cfqueryparam cfsqltype="cf_sql_char" value="#url.DEidentificacion#">
											and <cfqueryparam cfsqltype="cf_sql_char" value="#url.DEidentificacion_h#">	
				</cfif>			  
			<cfelseif isdefined("url.DEidentificacion") and len(trim(url.DEidentificacion)) and (not isdefined("url.DEidentificacion_h") or len(trim(url.DEidentificacion_h)) EQ 0)><!----Solo DEid inicial---->
				and d.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#url.DEidentificacion#"> 
			<cfelseif isdefined("url.DEidentificacion_h") and len(trim(url.DEidentificacion_h)) and (not isdefined("url.DEidentificacion") or len(trim(url.DEidentificacion)) EQ 0)><!----Solo DEid final---->
				and d.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#url.DEidentificacion_h#"> 
			</cfif>	  
			
			inner join Bancos f
				on d.Bid = f.Bid	
			
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
	
	order by {fn concat(d.DEnombre,{fn concat(' ',{fn concat(d.DEapellido1,{fn concat(' ',d.DEapellido2)})})})} 					
</cfquery>
<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<style>
	.titulo_empresa2 {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_columna {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		height:20px}
	.detalle {font-size:14px;}		
</style>
<cfset vn_total = 0>
<cfif rsReporte.RecordCount>
	<table width="800" align="center" border="0" cellspacing="0" cellpadding="0">
		<cfoutput>
			<tr><td align="center" colspan="6" class="titulo_empresa2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
			<tr><td align="center" colspan="6" class="titulo_empresa2"><strong>#LB_TituloReporte#</strong></td></tr>
			<tr><td align="right" colspan="6" class="detalle">#LB_Fecha#:#LSDateFormat(now(),'dd/mm/yyyy')#&nbsp;&nbsp;#TimeFormat(now(),'hh:mm:ss')#</td></tr>
			<tr><td>&nbsp;</td></tr>			
			<tr>
				<td class="titulo_columna" width="10%"><strong><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></strong></td>
				<td class="titulo_columna" width="35%"><strong><cf_translate key="LB_Nombre">Nombre</cf_translate></strong></td>
				<td class="titulo_columna" width="9%"><strong><cf_translate key="LB_CodBanco">Cod.Banco</cf_translate></strong></td>
				<td class="titulo_columna" width="10%"><strong><cf_translate key="LB_NoCuenta">No.Cuenta</cf_translate></strong></td>
				<td class="titulo_columna" align="right" width="17%" nowrap><strong><cf_translate key="LB_Total">Total</cf_translate></strong>&nbsp;</td>
				<td class="titulo_columna" width="25%"><strong><cf_translate key="LB_Firma">&nbsp;Firma</cf_translate></strong></td>
			</tr>
		</cfoutput>
		<cfoutput query="rsReporte">
			<cfset vn_total = rsReporte.Monto + rsReporte.ACDDmonto>
			<tr>
				<td width="10%" class="detalle">#DEidentificacion#</td>
				<td width="35%" class="detalle">#Nombre#</td>
				<td width="9%" class="detalle">#Bid#</td>
				<td width="10%" class="detalle">#DEcuenta#</td>				
				<td align="right" width="17%" class="detalle">#LSCurrencyFormat(vn_total,'none')#&nbsp;</td>		
				<td width="25%" style="border-bottom: 1px solid black;">&nbsp;</td>		
			</tr>
			<cfset vn_total = 0>
		</cfoutput>
	</table>
<cfelse>
	<table width="700" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr><td align="center"><cf_translate key="MSG_NoHayDatosRelacionados">No hay datos relacionados</cf_translate></td></tr>
	</table>
</cfif>

