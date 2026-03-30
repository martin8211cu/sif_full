<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Cliente" default = "Cliente" returnvariable="LB_Cliente" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CURP" default = "CURP" returnvariable="LB_CURP" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Observacion" default = "Observaciones" returnvariable="LB_Observacion" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Parcialidades" default = "Parcialidades" returnvariable="LB_Parcialidades" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TipoTransac" default = "Tipo Transacci&oacute;n" returnvariable="LB_TipoTransac" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fecha" default = "Fecha" returnvariable="LB_Fecha" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Corte" default = "Corte" returnvariable="LB_Corte" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Monto" default = "Monto" returnvariable="LB_Monto" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ID" default = "ID" returnvariable="LB_ID" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoReq" default = "Monto Requerido" returnvariable="LB_MontoReq" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Pagado" default = "Pagado" returnvariable="LB_Pagado" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descuento" default = "Descuento" returnvariable="LB_Descuento" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoPagar" default = "Monto A PAgar" returnvariable="LB_MontoPagar" xmlfile = "tab_Transaccion.xml">




<cfparam name="form.id">

<cfif !isdefined('form.codigocorte')>
	<cfset form.codigocorte="#q_currentCorte#">
</cfif>

<!--- variables para mayoristas --->
<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
<cfset val = objParams.getParametro('30000706')>
<cfif trim(rsCuenta.Tipo) eq 'TM'>
	<cfset dia_fin = val>
	<cfset mes_fin = form.codigoCorte>
	<cfset anno_fin = DateFormat(now(),"yyyy")>
	<cfif mes_fin gt DateFormat(now(),"m")>
		<cfset anno_fin -= 1>
	</cfif>
	<cfset date_fin = createDate(anno_fin, mes_fin, dia_fin)>
	<cfset date_ini =  dateAdd('d',1,dateAdd('m', -1, date_fin))>

</cfif>


<cfquery name="q_DetalleCorte" datasource="#session.DSN#">
	select 
			A.Cliente
		,	A.CURP
		,	C.Descripcion
		,	A.TipoTransaccion
		,	A.Fecha
		,	A.Parciales
		,	A.Monto
		,	C.Corte
		,	C.MontoRequerido
		,	C.Pagado
		,	C.Descuento
		,	C.MontoAPagar
		,	A.id	
	from CRCTransaccion A
	inner join CRCCuentas B
		on B.id = A.CRCCuentasid
	inner join CRCMovimientoCuenta C
		on C.CRCTransaccionid = A.id
	where 
		B.id = #form.id#
		<cfif trim(rsCuenta.Tipo) eq 'TM'>
			and convert(date,A.fecha) between #date_ini# and #date_fin#
		<cfelse>
			<cfif isdefined('form.codigocorte') and form.codigocorte neq ''>
				and C.Corte = '#form.codigocorte#'
			</cfif>
		</cfif>
		and A.ecodigo = #session.Ecodigo#
	order by A.id desc;
</cfquery>

<cfoutput>

<cfset counter = 0>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<th>#LB_ID#</th>
		<th>#LB_Cliente#</th>
		<th>#LB_CURP#</th>
		<th>#LB_Observacion#</th>
		<th>#LB_TipoTransac#</th>
		<th>#LB_Fecha#</th>
		<th>#LB_Parcialidades#</th>
		<th>#LB_Monto#</th>
		<th>#LB_Corte#</th>
		<th>#LB_MontoReq#</th>
		<th>#LB_Pagado#</th>
		<th>#LB_Descuento#</th>
		<th>#LB_MontoPagar#</th>
	</tr>
	<cfloop query = 'q_DetalleCorte'>
		<cfif counter eq 0>
			<cfset tdStyle = "background-color:##ccc;">
			<cfset counter = counter+1>
		<cfelse>
			<cfset counter = counter-1>
			<cfset tdStyle = "background-color:##f1f1f1;">
		</cfif>
		<tr>
				<td style="#tdStyle#">#q_DetalleCorte.id#</td>
				<td style="#tdStyle#">#q_DetalleCorte.Cliente#</td>
				<td style="#tdStyle#">#q_DetalleCorte.Curp#</td>
				<td style="#tdStyle#">#Left(q_DetalleCorte.Descripcion,30)#<cfif len(q_DetalleCorte.Descripcion) gt 30>...</cfif></td>
				<td style="#tdStyle#">#q_DetalleCorte.TipoTransaccion#</td>
				<td style="#tdStyle#">#DateFormat(q_DetalleCorte.Fecha,"YYYY-MM-DD")#</td>
				<td style="#tdStyle#">#q_DetalleCorte.Parciales#</td>
				<td style="#tdStyle#">#LSCurrencyFormat(q_DetalleCorte.Monto)#</td>
				<td style="#tdStyle#">#q_DetalleCorte.Corte#</td>
				<td style="#tdStyle#">#LSCurrencyFormat(q_DetalleCorte.MontoRequerido)#</td>
				<td style="#tdStyle#">#LSCurrencyFormat(q_DetalleCorte.Pagado)#</td>
				<td style="#tdStyle#">#LSCurrencyFormat(q_DetalleCorte.Descuento)#</td>
			<cfif form.codigocorte eq "#q_currentCorte#">
				<td style="#tdStyle#">-</td>
			<cfelse>
				<td style="#tdStyle#">#NumberFormat(q_DetalleCorte.MontoAPagar,"$0.00")#</td>
			</cfif>
		</tr>
	</cfloop>
	<cfif q_DetalleCorte.recordcount eq 0>
		<tr>
			<td style="#tdStyle# text-align:center;" colspan="12">--- NO POSEE TRANSACCIONES ---</td>
		</tr>
	</cfif>
	
</table>
</cfoutput>
