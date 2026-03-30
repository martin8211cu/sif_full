<!---  31/5/2006 Modificado por Mauricio Arias --->

<!--- <cf_dump var="#form#"> --->

<!--- Consultas --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsReporte" datasource="#session.DSN#">
	<!--- En caso de que SE HAYA definido un rango de cuentas --->	
	<cfif (isDefined("form.cmayor_ccuenta1") and len(trim(form.cmayor_ccuenta1))) and (isDefined("form.cmayor_ccuenta2") and len(trim(form.cmayor_ccuenta2)))>
		select
			C.Oficodigo as Oficina,		
			A.Ccuenta as cuenta,
			A.Cformato as formato,
			A.Cdescripcion as descripcion,
			A.Cbalancenormal as BalanceNormalN,
			A.Cbalancen      as BalanceNormal,
			sum(B.SLinicial + B.DLdebitos - B.CLcreditos) as saldo,
			sum(B.SLinicial + B.DLdebitos - B.CLcreditos) * A.Cbalancenormal as SaldoAnormal
		from CContables A
			inner join SaldosContables B on
				B.Ccuenta = A.Ccuenta and 
				B.Ecodigo = A.Ecodigo				
			inner join Oficinas C on
				B.Ecodigo = C.Ecodigo and
				B.Ocodigo = C.Ocodigo				
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		    and A.Cmovimiento = 'S'
			and A.Cformato
				between
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.cmayor_ccuenta1#-#form.cformato1#"> and
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.cmayor_ccuenta2#-#form.cformato2#">
			and B.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">	
			and B.Smes
				between
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#"> and
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes2#">				
			<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
				and B.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ocodigo#">
			</cfif>				
			<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
				and B.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			</cfif>		
		 group by C.Oficodigo, A.Ccuenta, A.Cformato, A.Cdescripcion, A.Cbalancenormal, A.Cbalancen
		 having sum(B.SLinicial + B.DLdebitos - B.CLcreditos) * A.Cbalancenormal < 0
		 order by A.Cformato	
	<cfelse>
		<!--- En caso de que no se haya definido un rango de cuentas --->
		select
			C.Oficodigo as Oficina,
			A.Ccuenta as cuenta,
			A.Cformato as formato,
			A.Cdescripcion as descripcion,
			A.Cbalancenormal as BalanceNormalN,
			A.Cbalancen      as BalanceNormal,
			sum(B.SLinicial + B.DLdebitos - B.CLcreditos) as saldo,
			sum(B.SLinicial + B.DLdebitos - B.CLcreditos) * A.Cbalancenormal as SaldoAnormal
		from SaldosContables B
			inner join CContables A on 
				A.Ccuenta = B.Ccuenta and
				A.Ecodigo = B.Ecodigo and
				A.Cmovimiento = 'S'
			inner join Oficinas C on
				B.Ecodigo = C.Ecodigo and
				B.Ocodigo = C.Ocodigo
		where B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and B.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">	
			and B.Smes
			between
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#"> and
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes2#">		
		<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
			and B.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ocodigo#">
		</cfif>
		<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
			and B.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		</cfif>
		group by C.Oficodigo,A.Ccuenta, A.Cformato, A.Cdescripcion, A.Cbalancenormal,A.Cbalancen
		having sum(B.SLinicial + B.DLdebitos - B.CLcreditos) * A.Cbalancenormal < 0
		order by A.Cformato
	</cfif>			
</cfquery>

<!--- Filtros --->
<cfset periodoD = "(No definido)">
<cfset ocodigoD = "(No definida)">
<cfset mesIniD  = "(No definido)">
<cfset mesFinD  = "(No definido)">
<cfset mcodigoD = "(No definida)">
<cfset cuentaIniD = "(No definida)">
<cfset cuentaFinD = "(No definida)">
<cfif isDefined("form.periodo") and len(trim(form.periodo))>
	<cfset periodoD = form.periodo>
</cfif>
<cfif isDefined("form.mes") and len(trim(form.mes))>
	<cfset mesIniD = form.mesDesde>
</cfif>
<cfif isDefined("form.mes2") and len(trim(form.mes2))>
	<cfset mesFinD = form.mesHasta>
</cfif>
<cfif isDefined("form.ocodigo") and len(trim(form.ocodigo))>
	<cfset ocodigoD = form.odescripcion>
</cfif>
<cfif isDefined("form.Mcodigo") and len(trim(form.Mcodigo))>
	<cfset mcodigoD = form.monedaDescrip>
</cfif>
<cfif isDefined("form.cmayor_ccuenta1") and len(trim(form.cmayor_ccuenta1))>
	<cfset cuentaIniD = form.cuenta1D & " (" & form.cmayor_ccuenta1 & "-" & form.cformato1 & ")">
</cfif>
<cfif isDefined("form.cmayor_ccuenta2") and len(trim(form.cmayor_ccuenta2))>
	<cfset cuentaFinD = form.cuenta2D & " (" & form.cmayor_ccuenta2 & "-" & form.cformato2 & ")">
</cfif>

<!--- Estilos --->
<cfsavecontent variable="VarStyle">
<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.titulo_empresa {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:12px;
		font-weight:bold;
		text-align:center;}
	.titulo_filtro {
		font-size:10px;
		font-weight:bold;
		text-align:center;}
	.titulo_columna {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.titulo_columnar {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.detalle {
		font-size:10px;
		mso-number-format:"\@";
		text-align:left;}
	.detaller {
		font-size:10px;
		text-align:right;}
	.mensaje {
		font-size:10px;
		text-align:center;}
	.paginacion {
		font-size:10px;
		text-align:center;}
	.xl29
		{font-size:10px;
		mso-number-format:"\@";
		white-space:normal;}		
</style>
</cfsavecontent>

<!--- Botones --->
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<table id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0">
	<cfoutput>
	<tr> 
		<td align="right" nowrap>
		<cf_htmlReportsHeaders 	irA="SaldosAnormales.cfm"
			FileName="reporte-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls"
			title="Saldos Anormales">
		</td>
	</tr>
	<tr><td><hr></td></tr>
	</cfoutput>
</table>

<!--- Variables --->
<cfset MaxLineasReporte = 60>	<!--- Máximo de líneas del reporte --->
<cfset nLnEncabezado = 10>		<!--- Total de líneas del encabezado --->
<cfset nCols = 4>				<!--- Total de columnas del encabezado --->

<!--- Página --->
<cfif rsReporte.recordCount gt 0>
	<cfset paginas = rsReporte.recordCount / (MaxLineasReporte - nLnEncabezado)>
	<cfset pf = #Fix(paginas)#>
	<cfif #paginas# gt #pf#>
		<cfset paginas = #pf# + 1>
	</cfif>
<cfelse>
	<cfset pagina = 1>
	<cfset paginas = 1>
</cfif>

<!--- Llena el Encabezado --->
<cfsavecontent variable="encabezado">
	<cfoutput>
		<tr><td colspan="#nCols#" align="center"><h1 class=corte></H1></td></tr>
		<tr><td colspan="#nCols#" class="titulo_empresa">#rsEmpresa.Edescripcion#</td></tr>
		<tr><td colspan="#nCols#" class="titulo_reporte">Reporte de Saldos Anormales</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">Oficina: #ocodigoD#</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">De #mesIniD# A #mesFinD# de #periodoD#</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">Moneda: #mcodigoD#</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">Cuenta Inicial: #cuentaIniD# - Cuenta Final: #cuentaFinD#</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="#nCols#" align="center"><hr></td></tr>
		<tr>
			<td class="titulo_columna">Oficina</td>
			<td class="titulo_columna">Cuenta</td>
			<td class="titulo_columna">Descripci&oacute;n</td>
			<td class="titulo_columnar">Saldo Inicial</td>
		</tr>
		<tr><td colspan="#nCols#" align="center"><hr></td></tr>
	</cfoutput>
</cfsavecontent>

<!--- Llena el Detalle --->
<cfsavecontent variable="detalle">
	<cfoutput>
		<cfif rsReporte.recordcount gt 0>
			<cfset pagina = 1>
			<cfset contador = nLnEncabezado>
			<cfloop query="rsReporte">			

				<cfif contador gte MaxLineasReporte>
					<tr><td class="paginacion" colspan="#nCols#"> - P&aacute;g #pagina# / #paginas# - </td></tr>
					<tr class="corte"><td colspan="#nCols#" nowrap>&nbsp;</td></tr>
					#encabezado#
					<cfset contador = nLnEncabezado>
					<cfset pagina = pagina + 1>
				</cfif>

				<tr>				
					<td class="xl29">#rsReporte.Oficina#</td>				
					<td class="detalle">#rsReporte.formato#</td>
					<td class="detalle">#rsReporte.descripcion#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.saldo,',9.00')#</td>
				</tr>
				<cfset contador = contador + 1>
			</cfloop>
		<cfelse>
			<tr><td colspan="#nCols#" align="center">&nbsp;</td></tr>
			<tr><td colspan="#nCols#" class="mensaje"> --- La consulta no gener&oacute; ning&uacute;n resultado --- </td></tr>
		</cfif>
	</cfoutput>
</cfsavecontent>

<!--- Forma el Reporte  --->
<cfsavecontent variable="reporte">	
<cfoutput>
	#VarStyle#	
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
		#encabezado#
		#detalle#
		<tr><td colspan="#nCols#" align="center">&nbsp;</td></tr>
		<tr><td colspan="#nCols#" class="paginacion"> - P&aacute;g #pagina# / #paginas# - </td></tr>
	</table>
</cfoutput>
</cfsavecontent>

<!--- Pinta el Reporte --->
<cfoutput>
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
	#reporte#
	<cfset tempfile = GetTempDirectory()>
	<cfset session.tempfile_xls = #tempfile# & "/tmp_" & #session.Ecodigo# & "_" & #session.usuario# & ".xls">
	<cffile action="write" file="#session.tempfile_xls#" output="#reporte#" nameconflict="overwrite">		
</table>
</cfoutput>