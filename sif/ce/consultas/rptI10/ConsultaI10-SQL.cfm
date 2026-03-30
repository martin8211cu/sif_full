<cfset vMon = "">
<cfif isdefined("form.Mcodigo")>
	<cfquery name="rsmoneda" datasource="#Session.DSN#">
		SELECT Miso4217  FROM Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Mcodigo#">
	</cfquery>
	<cfif rsMoneda.recordCount GT 0>
		<cfset vMon = rsMoneda.Miso4217>
	</cfif>
</cfif>
<cfquery name="rsLista" datasource="sifinterfaces">
	SELECT i10.ID, i10.EcodigoSDC, Modulo,
		Documento,TimbreFiscal,ibp.StatusProceso,
		CONVERT(VARCHAR(10),FechaDocumento,126) FechaDocumento, CONVERT(VARCHAR(10),ibp.FechaInclusion,126) FechaInclusion, i10.CodigoMoneda, sum(id10.CantidadTotal) Monto,
		case ibp.StatusProceso
			when 0 then 'Inactivo'
			when 1 then 'Pendiente'
			when 2 then 'Finalizado Exitosamente'
			when 3 then 'Error en Proceso'
			when 4 then 'Pendiente proceso Contable'
			when 5 then 'Pendiente Proceso Auxiliar'
			when 6 then 'Error en Proceso Contable'
			when 10 then 'Proceso en Ejecucion'
			when 11 then 'Proceso en Ejecucion Complementario'
			when 12 then 'Proceso en Ejecucion Auxliar'
			when 13 then 'Proceso en Ejecucion Auxiliar Complementario'
			when 92 then 'Registro Listo para cargarse a Interfaz sin Proceso Pendiente'
			when 94 then 'Registro Listo para cargarse a Interfaz con proceso Pendiente'
			when 95 then 'Registro Listo para cargarse a Interfaz con proceso Pendiente'
			when 99 then 'Proceso en Cola'
			when 100 then 'Proceso Complementario en Cola'
			else ''
		end DescStatus
	FROM IE10 i10
	inner join ID10 id10
		on i10.ID = id10.ID
	inner join InterfazBitacoraProcesos ibp
		on i10.ID = ibp.IdProceso
	group by i10.ID, i10.EcodigoSDC, Modulo,Documento,TimbreFiscal,ibp.StatusProceso,
		FechaDocumento, ibp.FechaInclusion, i10.CodigoMoneda
	HAVING i10.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.EcodigoSDC#">
	<cfif isdefined("form.origen") and form.origen NEQ "-1">
		and i10.Modulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.origen#">
	</cfif>
	<cfif isdefined("form.documento") and form.documento NEQ "">
		and upper(i10.Documento) like upper('%#form.documento#%')
	</cfif>
	<cfif isdefined("form.Timbre") and form.Timbre NEQ "">
		and upper(i10.TimbreFiscal) like upper('%#form.Timbre#%')
	</cfif>
	<cfif vMon NEQ "">
		and i10.CodigoMoneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vMon#">
	</cfif>
	<cfif isdefined("form.mtoTotal") and form.mtoTotal NEQ "" and LSParseNumber(form.mtoTotal) GT 0>
		and sum(id10.CantidadTotal) = <cfqueryparam cfsqltype="cf_sql_money" value="#LSParseNumber(form.mtoTotal)#">
	</cfif>
	<cfif isdefined("form.estado") and form.estado NEQ "" and form.estado GT 0>
		and ibp.StatusProceso = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.estado#">
	</cfif>
	<cfif isDefined("form.fechaIni") AND #form.fechaIni# NEQ "">
		and <cf_dbfunction name="to_date00" args="FechaDocumento"> >= #LSParseDateTime(listgetat(form.fechaIni, 1))#
		<!--- DATEDIFF(dd, FechaDocumento, <cfqueryparam value="#form.fechaIni#" cfsqltype="cf_sql_date">) = 0 --->
	</cfif>
	<cfif isDefined("form.fechaFin") AND #form.fechaFin# NEQ "">
		and <cf_dbfunction name="to_date00" args="FechaDocumento"> <= #LSParseDateTime(listgetat(form.fechaFin, 1))#
		<!--- DATEDIFF(dd, ibp.FechaInclusion, <cfqueryparam value="#form.fechaFin#" cfsqltype="cf_sql_date">) = 0 --->
	</cfif>
	<cfif isdefined("form.comprobante") AND form.comprobante NEQ "-1">
		<cfif form.comprobante EQ "CC">
			and TimbreFiscal is not null and ltrim(rtrim(TimbreFiscal)) <> ''
		<cfelseif form.comprobante EQ "SC">
			and (TimbreFiscal is null or ltrim(rtrim(TimbreFiscal)) = '')
		</cfif>
	</cfif>
	order by FechaDocumento Desc
</cfquery>

<cfquery name="Empresas" datasource="#Session.DSN#">
	select
		Ecodigo,
		Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfhtmlhead text="
<style type='text/css'>
td {  font-size: 11px; font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: normal}
a {
	text-decoration: none;
	color: ##000000;
}
.listaCorte { font-size: 11px; font-weight:bold; background-color:##CCCCCC; text-align:left;}
.listaNon { background-color:##FFFFFF; vertical-align:middle; padding-left:5px;}
.listaPar { background-color:##FAFAFA; vertical-align:middle; padding-left:5px;}
.tituloSub { background-color:##FFFFFF; font-weight: bolder; text-align: center; vertical-align: middle; font-size: smaller; border-color: black black ##CCCCCC; border-style: inset; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px}
.tituloListas {

	font-weight: bolder;
	vertical-align: middle;
	padding: 5px;
	background-color: ##F5F5F5;
}
</style>">

<cfinvoke key="LB_Titulo" default="Consulta Documentos de Interfaces" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate" xmlfile="ConsultaI10.xml"/>

<cfset Title = "Documentos de Interfaces">
<cfset FileName = "DocumentosInterfaces">
<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">

<!--- Pinta los botones de regresar, impresión y exportar a excel. --->
<cfset LvarIrA  = 'ConsultaI10.cfm'>

<cf_htmlreportsheaders title="#Title#" filename="#FileName#.xls" download="yes" ira="#LvarIrA#">

<table style="width:95%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="8" align="right">

		</td>
	</tr>
	<cfoutput>
	<tr class="area">
		<td  align="center" colspan="8" nowrap class="tituloAlterno"><cfoutput>#Empresas.Edescripcion#</cfoutput></td>
	</tr>
	<tr class="area">
		<td align="center" colspan="8" nowrap><strong>#LB_Titulo#</strong></td>
	</tr>
	<tr>
		<td colspan="8" align="right"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate>: <font color="##006699"><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></font></strong></td>
	</tr>
    <tr class="tituloListas">
		<td><strong>Origen</strong></td>
		<td><strong>Documento</strong></td>
		<td><strong>Timbre</strong></td>
		<td><strong>Estado</strong></td>
		<td><strong>Fecha Registro</strong></td>
		<td><strong>Fecha Inclusion</strong></td>
		<td><strong>Moneda</strong></td>
		<td><strong>Monto</strong></td>
	</tr>
	<cfloop query="rsLista">
	<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
		<td>#Modulo#</td>
		<td>#Documento#</td>
		<td>#TimbreFiscal#</td>
		<td>#DescStatus#</td>
		<td>#FechaDocumento#</td>
		<td>#FechaInclusion#</td>
		<td>#CodigoMoneda#</td>
		<td align="right">#LSCurrencyFormat(Monto)#</td>
	</tr>
	</cfloop>
	</cfoutput>
</table>
