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
<cfquery name="rsCERepositorio" datasource="#Session.DSN#">
	select hc.Edocumento,hc.Eperiodo,hc.Emes,
		rep.IdRep, rep.IdContable, rep.linea, rep.timbre as UUID,
		rep.numDocumento as Documento,
		rep.rfc,
		rep.origen,
		case rep.origen
			when 'CPFC' then 'Cuentas por Pagar'
			when 'CCFC' then 'Cuentas por Cobrar'
			when 'CPRE' then 'Pago de Cuentas por Pagar'
			when 'CCRE' then 'Cobro de Cuentas por Cobrar'
			when 'TES'  then 'Pagos Tesoreria'
			when 'TSGS' then 'Viaticos'
			when 'CPND' then 'Neteo de Documentos'
			when 'CCND' then 'Neteo de Documentos'
			when 'CPAP' then 'Aplicacion de Documentos a Favor'
			when 'CCAP' then 'Aplicacion de Documentos a Favor'
			when 'CPPA' then 'Aplicacion de Documentos a Favor'
			when 'CCPA' then 'Aplicacion de Documentos a Favor'
			else 'Desconocido'
		end as descOrigen,
		hc.Cconcepto,
		cc.Cdescripcion,
		'<img border=''0'' src=''/cfmx/sif/imagenes/Description.gif'' style=''cursor:pointer'' alt=''Consultar Comprobante'' onclick=''funcMostrarComprobante('+cast(rep.IdContable as varchar)+','+ cast(rep.linea as varchar)+','+ cast(rep.IdRep as varchar)+');''> &nbsp;
		<img border=''0'' src=''/cfmx/sif/imagenes/findsmall.gif'' style=''cursor:pointer'' alt=''Imprimir'' onclick=''funcMostrarPoliza('+ cast(rep.IdContable as varchar)+','+ cast(hc.Eperiodo as varchar)+','+ cast(hc.Emes as varchar)+','+ cast(rep.linea as varchar)+');''>' Botones
	from CERepositorio rep
	inner join HEContables hc
		on rep.IdContable = hc.IDcontable
		and rep.Ecodigo = hc.Ecodigo
	inner join ConceptoContableE cc
		on hc.Cconcepto = cc.Cconcepto
		and hc.Ecodigo = cc.Ecodigo
	where rep.Ecodigo = #Session.Ecodigo#
		and rep.origen is not null
	<cfif isdefined("form.selectLote") and form.selectLote NEQ -1>
		and cc.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.selectLote#">
	</cfif>
	<cfif isdefined("form.Poliza") and form.Poliza NEQ "">
		and hc.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Poliza#">
	</cfif>
	<cfif isdefined("form.UUID") and form.UUID NEQ "">
		and upper(rep.timbre) like upper('%#form.UUID#%')
	</cfif>
	<cfif isdefined("form.Documento") and form.Documento NEQ "">
		and upper(rep.numDocumento) like upper('%#form.Documento#%')
	</cfif>
	<cfif isdefined("form.RFC") and form.RFC NEQ "">
		and replace(upper(rep.rfc),'-','') like replace(upper('%#form.RFC#%'),'-','')
	</cfif>
	<cfif isdefined("form.selectOrigen") and form.selectOrigen NEQ "-1">
		and rep.origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.selectOrigen#">
	</cfif>
	<cfif isdefined("form.periodo") and form.periodo NEQ "-1">
		and hc.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
	</cfif>
	<cfif isdefined("form.mes") and form.mes NEQ "-1">
		and hc.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
	</cfif>
	order by hc.Eperiodo desc, hc.Emes desc, hc.Edocumento desc, rep.linea
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

<cfinvoke key="LB_Titulo" default="Consulta Documentos de Interfaces" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate" xmlfile="SQLConsultaComprobanteCE.xml"/>

<cfset Title = "Comprobante Fiscales">
<cfset FileName = "ComprobantesFiscales">
<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">

<!--- Pinta los botones de regresar, impresión y exportar a excel. --->
<cfset LvarIrA  = 'ConsultaComprobanteCE.cfm'>

<cf_htmlreportsheaders title="#Title#" filename="#FileName#.xls" download="yes" ira="#LvarIrA#">

<table style="width:90%" align="center" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr class="area">
		<td  align="center" colspan="7" nowrap class="tituloAlterno"><cfoutput>#Empresas.Edescripcion#</cfoutput></td>
	</tr>
	<tr class="area">
		<td align="center" colspan="7" nowrap><strong>#LB_Titulo#</strong></td>
	</tr>
	<tr>
		<td colspan="7" align="right"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate>: <font color="##006699"><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></font></strong></td>
	</tr>
    <tr class="tituloListas">
		<td><strong>Per&iacute;odo</strong></td>
		<td><strong>Mes</strong></td>
		<td><strong>L&iacute;nea</strong></td>
		<td><strong>Timbre</strong></td>
		<td><strong>RFC</strong></td>
		<td><strong>Documento</strong></td>
		<td><strong>Origen</strong></td>
	</tr>
	<cfloop query="rsCERepositorio">
	<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
		<td>#Eperiodo#</td>
		<td>#Emes#</td>
		<td>#linea#</td>
		<td>#UUID#</td>
		<td>#rfc#</td>
		<td>#Documento#</td>
		<td>#descOrigen#</td>
	</tr>
	</cfloop>
	</cfoutput>
</table>
