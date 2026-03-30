<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 03-01-2006.
		Motivo: Nueva consulta de Pagos con Cheques y Targetas.
--->
<cfquery name="rsObtieneCaja" datasource="#session.dsn#">
	select FAM01COD as Caja
	from FAM001 d
	where d.Ecodigo   = #session.Ecodigo#
	  and d.FAM01CODD = '#url.FAM01CODD#'
</cfquery>
<cfif rsObtieneCaja.recordcount EQ 0>
	<p> <strong>La consulta no gener&oacute; resultados.  El codigo de la Caja no fue encontrado </strong></p>
	<cfabort>
</cfif>

<cfset LvarCaja = rsObtieneCaja.Caja>
<cfset LvarFechaHas = DateAdd("d", 1, #dateformat(url.fechaHas,'dd/mm/yyyy')#)>
<cfset LvarFechaHas = DateAdd("s", -1, #LvarFechaHas#)>
<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="3001">
	select 
		d.FAM01CODD as codigocaja, 
		a.FAX01DOC as documento,
		a.FAX01FEC as fechaFactura,
		f.FAX12NUM as numCheque_detTarjeta,
		case when f.FAX12TIP = 'CK' then f.FAX12CTA 
				else convert(varchar, f.FAX12ATB) end as Cuenta_Autoriza,
		case when f.FAX12TIP = 'CK' 
			then ( select min(i.Bdescripcion) from Bancos i where i.Bid = f.Bid) 
			else ( select min(convert(varchar, j.FATtipo)) from FATarjetas j where j.FATid = f.FATid)
		end 
		as Banco_Tipo,   
		case when a.FAX01TPG = 1 then ltrim(rtrim(b.SNnumero)) else ltrim(rtrim(e.CDCidentificacion)) end as identificacion,
		case when a.FAX01TPG = 1 then b.SNnombre else ltrim(rtrim(e.CDCnombre)) end as nombre,
		(( select min(g.Miso4217) from Monedas g where g.Mcodigo = a.Mcodigo )) as CodigoMoneda,
		f.FAX12TOTMF as monto,
		f.FAX12TOT,
		f.FAX12TIP
	
	from FAX001 a
		inner join FAM001 d     					<!--- cajas --->
		on  d.FAM01COD  = a.FAM01COD
		and d.Ecodigo   = a.Ecodigo

		inner join FAX012 f
		on  f.FAM01COD = a.FAM01COD
		and f.FAX01NTR = a.FAX01NTR
	
	  left outer join SNegocios b					<!--- clientes --->
		on a.SNcodigo = b.SNcodigo
		and a.Ecodigo = b.Ecodigo
	
	  left outer join ClientesDetallistasCorp e 	<!--- clientes --->
		on a.CDCcodigo = e.CDCcodigo
		
	where a.Ecodigo   = #session.Ecodigo#
	  and a.FAM01COD = '#LvarCaja#'
	  and a.FAX01STA in ('C', 'T')
	  
	<!--- Fechas Desde / Hasta --->
	<cfif isdefined("url.fechaDes") and len(trim(url.fechaDes)) and isdefined("url.fechaHas") and len(trim(url.fechaHas))>
		and a.FAX01FEC between #lsparsedatetime(url.fechaDes)# 
		and #LvarFechaHas#
	<cfelseif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
		and a.FAX01FEC >= #lsparsedatetime(url.fechaDes)#
	<cfelseif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
		and a.FAX01FEC <= #LvarFechaHas#
	</cfif>
	  
	<!--- Filtro de tipo de pago --->
	<cfif isdefined("url.FAX12TIP") and len(trim(url.FAX12TIP)) and url.FAX12TIP NEQ '-1'>
	  and f.FAX12TIP = '#url.FAX12TIP#'
	<cfelseif url.FAX12TIP eq '-1'>
	  and f.FAX12TIP in('TC','CK')
	</cfif>
	order by FAX12TIP
</cfquery>

<cfif rsReporte.recordcount GT 3000>
	<cf_errorCode	code = "50574" msg = "Se sobrepasó el número de registros aceptable para este reporte">
	<cfabort>
</cfif>

<!--- Formato del Reporte --->
<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
	<cfset formatos = "flashpaper">
<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
	<cfset formatos = "pdf">
</cfif>

<!--- Invocación del Reporte --->
<cfreport format="#formato#" template= "PagosCKTC.cfr" query="rsReporte">
	<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
	<cfreportparam name="Edescripcion" value="#session.Enombre#">

	<cfif isdefined("url.FAX12TIP") and len(trim(url.FAX12TIP)) and FAX12TIP NEQ '-1'>
		<cfreportparam name="tipopago" value="#url.FAX12TIP#">
	<cfelse>
		<cfreportparam name="tipopago" value="Todos">
	</cfif>

	<cfif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
		<cfreportparam name="FechaI" value="#url.fechaDes#">
	</cfif>

	<cfif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
		<cfreportparam name="FechaF" value="#url.fechaHas#">
	</cfif>

	<cfif isdefined("url.FAM01CODD") and len(trim(url.FAM01CODD))>
		<cfreportparam name="caja" value="#url.FAM01CODD#">
	</cfif>
</cfreport>

