

<cfset counter = 0>
<cfset th = "font-size: 14px; background-color:##ccc;">
<cfset thleft = "#th# text-align:left">
<cfset thcenter = "#th# text-align:center">
<cfset thright = "#th# text-align:right">

<cfquery name="q_Pagos" datasource="#session.dsn#">
	select 
		  et.ETnumero
		, dt.CRCCuentaid
		, c.Numero 
		, et.ETfecha
		, et.CCTcodigo
		, sn.SNnombre
		, c.Tipo
		, sn.SNNumero
		, case Rtrim(Ltrim(c.Tipo))
			when 'D' then 'Distribuidor'
			when 'TC' then 'Tarjeta Credito'
			when 'TM' then 'Tarjeta Mayorista'
		end as TipoDescripcion
		, et.ETtotal
		, e.Descripcion as Estado
	from ETransacciones et
		inner join DTransacciones dt
			on dt.ETnumero = et.ETnumero
		inner join CRCCuentas c
			on dt.CRCCuentaid = c.id
		inner join SNegocios sn
			on sn.SNid = c.SNegociosSNid
		left join CRCTransaccion t
			on t.ETnumero = et.ETnumero
		left join CRCEstatusCuentas e
			on t.estatusCliente = e.id
	where et.Ecodigo = #session.ecodigo# and dt.DTborrado = 0
		and et.ETestado = 'C'
		<cfif type_Filtro neq ''>
			and Rtrim(Ltrim(c.Tipo)) = '#type_Filtro#'
		</cfif>
		<cfif numCuenta_Filtro neq ''>
			and Rtrim(Ltrim(c.numero)) = '#numCuenta_Filtro#'
		</cfif>
		<cfif FInicio_Filtro neq ''>
			and et.ETfecha >= convert(datetime,'#FInicio_Filtro#',103)
		</cfif>
		<cfif FFin_Filtro neq ''>
			and et.ETfecha <= DateADD(day,1,convert(datetime,'#FFin_Filtro#',103))
		</cfif>
		<cfif isdefined('form.SNid') && trim("#form.SNid#") neq ''>
			and sn.SNid = #form.SNid#
		</cfif>
		order by et.ETfecha desc
</cfquery>

<form name="reciboForm" target="_blank" action="/cfmx/crc/cobros/operacion/ticketPago.cfm?ET=X" method="POST">
<input type="hidden" name="ETnum" value="">
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
	query="#q_Pagos#"
	desplegar	= "ETfecha,ETtotal,CCTcodigo,Numero,TipoDescripcion,SNNumero,SNnombre, estado"
	etiquetas	= "Fecha de Pago,Monto,Tipo Transaccion,Numero de Cuenta,Tipo de Cuenta,Num. Socio Negocio,Nombre Socio Negocio, Estado"
	formatos	= "D,S,S,S,S,S,S,S"
	align		= "left,center,center,center,center,center,left,left"
	formName	= "reciboForm"
	key			= "ETnumero"
	irA			= "##"
	MaxRowsQuery= 1000
	showEmptyListMsg="yes"
	EmptyListMsg="--- No se encontraron recibos de pago ---"
>
</cfinvoke>

<!---
<cfoutput>
<table width="85%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<th rowspan="2" style="#thcenter#">Fecha de Pago</th>
		<th rowspan="2" style="#thcenter#">Monto</th>
		<th rowspan="2" style="#thcenter#">Tipo de Transaccion</th>
		<th rowspan="2" style="#thcenter#">Numero de Cuenta</th>
		<th rowspan="2" style="#thcenter#">Tipo de Cuenta</th>
		<th rowspan="2" style="#thcenter#">Numero Socio de Negocio</th>
		<th rowspan="2" style="#thcenter#">Nombre Socio de Negocio</th>
		<th rowspan="2" style="#thcenter#">&nbsp;</th>
	</tr>

	

	<cfloop query="q_Pagos">
		<cfif counter eq 0>
			<cfset tdStyle = "padding:2px; background-color:##ffffff;">
			<cfset counter = counter+1>
		<cfelse>
			<cfset counter = counter-1>
			<cfset tdStyle = "padding:2px; background-color:##def2f8;">
		</cfif>
		<tr>
			<td style="#tdStyle#" align="left">#dateTimeFormat(q_Pagos.ETfecha,"dd/mm/yyyy hh:nn:sstt")#</td>
			<td style="#tdStyle#" align="center">#lsCurrencyFormat(q_Pagos.ETtotal)#</td>
			<td style="#tdStyle#" align="center">#q_Pagos.CCTcodigo#</td>
			<td style="#tdStyle#" align="center">#q_Pagos.Numero#</td>
			<td style="#tdStyle#" align="center">#q_Pagos.TipoDescripcion#</td>
			<td style="#tdStyle#" align="left">#q_Pagos.SNNumero#</td>
			<td style="#tdStyle#" align="left">#q_Pagos.SNnombre#</td>
			<td style="#tdStyle#" align="left">
				<a target="_blank" href="/cfmx/crc/cobros/operacion/ticketPago.cfm?ET=#q_Pagos.ETnumero#"><button><i class="fa fa-print" style="font-size:24px;"></i></button></a>
			</td>
		</tr>
	</cfloop>
</table>
</cfoutput>
--->