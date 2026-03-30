<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ID" default = "ID" returnvariable="LB_ID" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Cliente" default = "Cliente" returnvariable="LB_Cliente" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CURP" default = "CURP" returnvariable="LB_CURP" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Observacion" default = "Observaciones" returnvariable="LB_Observacion" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" default = "Descripcion" returnvariable="LB_Descripcion" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Parcialidades" default = "Parcialidades" returnvariable="LB_Parcialidades" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TipoTransac" default = "Tipo Transacci&oacute;n" returnvariable="LB_TipoTransac" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fecha" default = "Fecha" returnvariable="LB_Fecha" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Corte" default = "Corte" returnvariable="LB_Corte" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Monto" default = "Monto" returnvariable="LB_Monto" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TipoMov" default = "Tipo Mov" returnvariable="LB_TipoMov" xmlfile = "tab_Transaccion.xml">



<cfparam name="form.id">

<!--- variables para mayoristas --->
<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
<cfset val = objParams.getParametro('30000706')>
<cfif trim(rsCuenta.Tipo) eq 'TM'>
	<cfset dia_fin = val>
	<cfset mes_fin = form.codigoCorte>
	<cfif not isdefined("form.corteAnno")>
		<cfset form.corteAnno = year(now())>
	</cfif>
	<cfset anno_fin = form.corteAnno>
	<cfset date_fin = createDate(anno_fin, mes_fin, dia_fin)>
	<cfset date_ini =  dateAdd('d',1,dateAdd('m', -1, date_fin))>

	<cfif month(date_ini) gt DateFormat(now(),"m") and form.corteAnno gte  DateFormat(now(),"yyyy")>
		<cfset anno_fin -= 1>
		<cfset date_fin = createDate(anno_fin, mes_fin, dia_fin)>
		<cfset date_ini =  dateAdd('d',1,dateAdd('m', -1, date_fin))>
	</cfif>

</cfif>

<cfif !isdefined('form.codigocorte')>
	<cfset form.codigocorte="#q_currentCorte#">
</cfif>

<cfquery name="q_Corte" datasource="#session.DSN#">
	select FechaFin, FechaInicio from CRCCortes where codigo = '#form.codigocorte#' and Tipo = '#rsCuenta.Tipo#'
			and Ecodigo = #session.ecodigo#;
</cfquery>

<cftry>
	<cfset q_Corte="#QueryGetRow(q_Corte,1)#">
	<cfcatch>
		<cfset q_Corte=StructNew()>
		<cfset q_Corte['FechaFin']="">
		<cfset q_Corte['FechaInicio']="">
	</cfcatch>
</cftry>
	
	<cfquery name="q_Cuenta" datasource="#session.DSN#">
		select * from CRCCuentas where id = #form.id#
	</cfquery>
	<cfquery name="q_Transacciones" datasource="#session.DSN#">
		select 
				A.Cliente
			,	A.id
			,	A.CURP
			,	A.Observaciones
			,	A.TipoTransaccion
			,	A.Fecha
			,	A.TipoMov
			,	A.Parciales
			,	A.Monto
			,	A.id
			, 	A.Descripcion
		from CRCTransaccion A
		inner join CRCCuentas C on A.CRCCuentasid = C.id
		where 
			A.CRCCuentasid = #form.id#
			<cfif trim(rsCuenta.Tipo) eq 'TM'>
				and convert(date,A.fecha) between #date_ini# and #date_fin#
			<cfelse>
				and convert(date,A.Fecha) between convert(date,'#q_Corte.FechaInicio#') and convert(date,'#q_Corte.FechaFin#')
			</cfif>
			and A.ecodigo = #session.Ecodigo#
		order by A.id desc;
	</cfquery>

<cfoutput>

<cfset counter = 0>

<cfset tdStyle = "background-color:##ccc;">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<th>#LB_ID#</th>
		<th>#LB_Cliente#</th>
		<th>#LB_CURP#</th>
		<th>#LB_Observacion#</th>
		<th>#LB_Descripcion#</th>
		<th>#LB_TipoTransac#</th>
		<th>#LB_Fecha#</th>
		<th>#LB_Parcialidades#</th>
		<th>#LB_TipoMov#</th>
		<th>#LB_Monto#</th>
	</tr>
	<cfloop query = 'q_Transacciones'>
		<cfif counter eq 0>
			<cfset tdStyle = "background-color:##ccc;">
			<cfset counter = counter+1>
		<cfelse>
			<cfset counter = counter-1>
			<cfset tdStyle = "background-color:##f1f1f1;">
		</cfif>
		<tr>
			<td style="#tdStyle#">#q_Transacciones.id#</td>
			<td style="#tdStyle#">#q_Transacciones.Cliente#</td>
			<td style="#tdStyle#">#q_Transacciones.Curp#</td>
			<td style="#tdStyle#">#Left(q_Transacciones.Observaciones,30)#<cfif len(q_Transacciones.Observaciones) gt 30>...</cfif></td>
			<td style="#tdStyle#">#Left(q_Transacciones.Descripcion,30)#<cfif len(q_Transacciones.Descripcion) gt 30>...</cfif></td>
			<td style="#tdStyle#">#q_Transacciones.TipoTransaccion#</td>
			<td style="#tdStyle#">#DateFormat(q_Transacciones.Fecha,"YYYY-MM-DD")#</td>
			<td style="#tdStyle#">#q_Transacciones.Parciales#</td>
			<td style="#tdStyle#">#q_Transacciones.TipoMov#</td>
			<td style="#tdStyle#">#LSCurrencyFormat(q_Transacciones.Monto)#</td>
			<td style="#tdStyle#">
				<!---<cfif arrayFind(['VC','TC','TM','RC'], trim(q_Transacciones.TipoTransaccion)) gt 0> --->
				<cfif arrayFind(['VC','TC','TM','RC'], trim(q_Transacciones.TipoTransaccion)) gt 0>
					<button type="button" onclick="openDetail(#q_Transacciones.id#);"><i class="fa fa-search"></i></button>
				<cfelse>&nbsp;</cfif>
			</td>
		</tr>
	</cfloop>
	<cfif q_Transacciones.recordcount eq 0>
		<tr>
			<td style="#tdStyle# text-align:center;" colspan="7">--- NO POSEE TRANSACCIONES ---</td>
		</tr>
	</cfif>
	
</table>

<script>
	function openDetail(id){
		window.open("DetalleTransaccion.cfm?id="+id,'Detalle Transaccion','scrollbars=1,resizeable=1,height=350,width=1000');
		if (window.focus) {newwindow.focus()}
       return false;
	}
</script>

</cfoutput>
