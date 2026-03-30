<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ReporteDeDistribucionDeExcedentesSolidaristas" default="Reporte de Distribuci&oacute;n de Excedentes Solidaristas" returnvariable="LB_TituloReporte" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfquery name="rsReporte" datasource="#session.DSN#">
	select  d.DEidentificacion
			,{fn concat(d.DEnombre,{fn concat(' ',{fn concat(d.DEapellido1,{fn concat(' ',d.DEapellido2)})})})} as Nombre		
			,b.ACDDdias
			,b.ACDDmonto
			,a.ACDDEperiodo
			,a.ACDDEmonto
	from ACDistribucionDividendosE a	
		inner join ACDistribucionDividendos b
			on a.ACDDEperiodo = b.ACDDEperiodo
			and a.Ecodigo = b.Ecodigo
		
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
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("url.ACDDEPERIODO") and len(trim(url.ACDDEPERIODO))>
			and a.ACDDEperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ACDDEPERIODO#">
		</cfif>
	order by d.DEidentificacion
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
<!---Variables para sumatorias---->
<cfset vn_totaldias = 0>
<cfset vn_totalmto = 0>
<cfif rsReporte.RecordCount>
	<table width="700" align="center" border="0" cellspacing="0" cellpadding="0">
		<cfoutput>
			<tr><td align="center" colspan="4" class="titulo_empresa2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
			<tr><td align="center" colspan="4" class="titulo_empresa2"><strong>#LB_TituloReporte#</strong></td></tr>
			<tr><td align="right" colspan="4" class="detalle">#LB_Fecha#:#LSDateFormat(now(),'dd/mm/yyyy')#&nbsp;&nbsp;#TimeFormat(now(),'hh:mm:ss')#</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="4" class="detalle">					
					<strong><cf_translate key="LB_MontoDistribuido">Monto Distribuido</cf_translate>:&nbsp;#LSCurrencyFormat(rsReporte.ACDDEmonto,'none')#</strong>
				</td>
			</tr>
			<tr>
				<td class="titulo_columna" width="15%"><strong><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate></strong></td>
				<td class="titulo_columna" width="45%"><strong><cf_translate key="LB_Nombre">Nombre</cf_translate></strong></td>
				<td class="titulo_columna" width="10%"><strong><cf_translate key="LB_Dias">D&iacute;as</cf_translate></strong></td>
				<td class="titulo_columna" align="right" width="20%" nowrap><strong><cf_translate key="LB_Monto">Monto</cf_translate></strong></td>
			</tr>
		</cfoutput>
		<cfoutput query="rsReporte">
			<tr>
				<td width="15%" class="detalle">#DEidentificacion#</td>
				<td width="45%" class="detalle">#Nombre#</td>
				<td width="10%" class="detalle">#rsReporte.ACDDdias#</td>
				<td align="right" width="20%" class="detalle">#LSCurrencyFormat(rsReporte.ACDDmonto,'none')#</td>				
			</tr>
			<cfset vn_totaldias = vn_totaldias + rsReporte.ACDDdias>
			<cfset vn_totalmto = vn_totalmto + rsReporte.ACDDmonto>
		</cfoutput>
		<!---Totales--->
		<tr>
			<td colspan="2" align="right"><strong><cf_translate key="LB_Totales">Totales</cf_translate>:</strong></td>
			<cfoutput>
			<td  width="5%" class="detalle" style="border-top:0.5px solid black;">#vn_totaldias#</td>
			<td align="right" width="20%" class="detalle" style="border-top:0.5px solid black;">#LSCurrencyFormat(vn_totalmto,'none')#</td>
			</cfoutput>
		</tr>
	</table>
<cfelse>
	<table width="700" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr><td align="center"><cf_translate key="MSG_NoHayDatosRelacionados">No hay datos relacionados</cf_translate></td></tr>
	</table>
</cfif>

