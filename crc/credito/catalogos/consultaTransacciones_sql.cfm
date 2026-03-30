<cfparam name="modo" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','Consulta de Transacciones')>
<cfset LB_Tienda		= t.Translate('LB_Tienda', 'Tienda')>
<cfset LB_Cliente		= t.Translate('LB_Cliente', 'Cliente')>
<cfset LB_Monto			= t.Translate('LB_Monto', 'Monto')>
<cfset LB_CURP			= t.Translate('LB_CURP', 'CURP')>
<cfset LB_Observacion	= t.Translate('LB_Observacion', 'Observaci&oacute;n')>
<cfset LB_TipoTransac	= t.Translate('LB_TipoTransac', 'Tipo Transacci&oacute;n')>
<cfset LB_Fecha 		= t.Translate('LB_Fecha', 'Fecha')>
<cfset LB_Parcialidades = t.Translate('LB_Parcialidades', 'Parcialidades')>
<cfset LB_TipoMov   	= t.Translate('LB_TipoMov', 'Tipo de Movimiento')>
<cfset LB_FolioTarjeta  = t.Translate('LB_FolioTarjeta', 'Folio/Tarjeta')>
<cfset BTN_Regresar   	= t.Translate('BTN_Regresar', 'Regresar')>
<cfset LB_SNnombre   	= t.Translate('LB_SNnombre', 'Socio de Negocio')>
<cfset LB_Referencias  	= t.Translate('LB_Referencias', 'Referencias(Ticket)')>
<cfset LB_Id 			= t.Translate('LB_Id', 'Id')>
<cfset LB_Corte			= t.Translate('LB_Corte', 'Corte')>

<cfset LvarPagina = "consultaTransacciones.cfm">


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TituloH#'>	

<cfset prevPag="consultaTransacciones.cfm">
<cfset targetAction="consultaTransacciones_sql.cfm">
<cfinclude template="imprimirReporte.cfm" >


<cfif isdefined('form.folio') and #form.folio# neq ''>
	<cfset tipoTran = 'VC'>
<cfelseif isDefined('form.numTarjeta') and #form.numTarjeta# neq ''>
	<cfset tipoTran = 'TC'>
</cfif>



<cfquery name="rsCorteActual" datasource="#session.DSN#">
	select top 1 * from CRCCortes 
		where Cerrado != 1
		<cfif isdefined('tipoTran') and #tipoTran# neq ''>
			and Tipo = '#tipoTran#'
		</cfif>
</cfquery>

<cfquery name="q_Transacciones" datasource="#session.DSN#">
	select top 3000
			A.Cliente
		,	A.CURP
		,	A.Observaciones
		,	A.TipoTransaccion
		,	A.Fecha
		,	A.TipoMov
		,	A.Parciales
		,	A.Monto
		,	A.id
		,	A.Ticket
		,   cc.Numero
		,	A.Folio
		,	sn.SNnombre
		,	sn.SNid
		,	isnull(c.Codigo, A.Fecha) Codigo
		,	cc.Tipo
		,	A.TiendaExt
	from CRCTransaccion A
	<cfif isdefined('form.buscarPor') and #form.buscarPor# eq 2 and #form.folio_NumTar# neq ''>
		inner join CRCTarjeta ct on ct.CRCCuentasid = A.CRCCuentasid 
	</cfif>
	inner join CRCCuentas cc on cc.id = A.CRCCuentasid
	inner join SNegocios sn on sn.SNid = cc.SNegociosSNid
	left JOIN CRCCortes c ON A.Fecha > c.FechaInicio AND A.Fecha < dateadd(DAY, 1, c.FechaFin)
		AND rtrim(ltrim(c.Tipo)) = rtrim(ltrim(cc.Tipo))
		and cc.Tipo <> 'TM'
	where A.ecodigo = #session.Ecodigo#

	<cfif isdefined('form.Numero') and #form.Numero# neq ''>
		and cc.Numero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Numero#">
	</cfif>
	<cfif isdefined('form.buscarPor') and #form.buscarPor# neq '' and #form.buscarPor# eq 1 and #form.folio_NumTar# neq ''>
		and Folio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.folio_NumTar#">
	</cfif>

	<cfif isdefined('form.buscarPor') and #form.buscarPor# neq '' and #form.buscarPor# eq 2 and #form.folio_NumTar# neq ''>
		and ct.Numero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.folio_NumTar#">
	</cfif>

	<cfif isdefined('form.referencias') and #form.referencias# neq ''>
		and Ticket = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.referencias#">
	</cfif>

	<cfif isdefined('form.ProcTipo')>
		and cc.Tipo = '#form.ProcTipo#'
	</cfif>


	<cfif isdefined("Form.FECHADESDE") && Form.FECHADESDE neq "">
		<cfset form.FECHADESDE = ListToArray(form.FECHADESDE,'/')>
		<cfset form.FECHADESDE = "#form.FECHADESDE[3]#-#form.FECHADESDE[2]#-#form.FECHADESDE[1]#">
		and A.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fechaDesde#">
	</cfif>

	<cfif isdefined("Form.FECHAHASTA") && Form.FECHAHASTA neq "">
		<cfset form.FECHAHASTA = ListToArray(form.FECHAHASTA,'/')>
		<cfset form.FECHAHASTA = "#form.FECHAHASTA[3]#-#form.FECHAHASTA[2]#-#form.FECHAHASTA[1]#">
		and datediff(day,A.Fecha,dateAdd(day, 1, <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">)) >=0
	</cfif>

	order by A.id desc
</cfquery>

<cfoutput>

<cfset counter = 0>

<cfset tdStyle = "background-color:##ccc;">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td colspan="13"><label color="blue">*Limitado a 3000 registros</label></td>
	</tr>
	<tr>
		<th>#LB_Id#</th>
		<th>#LB_SNnombre#</th>
		<th>#LB_Cliente#</th>
		<th>#LB_CURP#</th>
		<th>#LB_Referencias#</th>
		<th>#LB_Observacion#</th>
		<th>#LB_FolioTarjeta#</th>
		<th>#LB_TipoTransac#</th>
		<th>#LB_Corte#</th>
		<th>#LB_Fecha#</th>
		<th>#LB_Parcialidades#</th>
		<th>#LB_TipoMov#</th>
		<th>#LB_Monto#</th>
	</tr>
	<cfloop query = 'q_Transacciones'>
		<cfif counter eq 0>
			<cfset tdStyle = "background-color:##ccc; padding:2px;">
			<cfset counter = counter+1>
		<cfelse>
			<cfset counter = counter-1>
			<cfset tdStyle = "background-color:##f1f1f1; padding:2px;">
		</cfif>
		<tr>
			<td style="#tdStyle#">#q_Transacciones.id#</td>
			<td style="#tdStyle#">#q_Transacciones.SNnombre#</td>
			<td style="#tdStyle#">#q_Transacciones.Cliente#</td>
			<td style="#tdStyle#">#q_Transacciones.Curp#</td>
			<td style="#tdStyle#">#q_Transacciones.Ticket#</td>
			<td style="#tdStyle#">#q_Transacciones.Observaciones#</td>
			<td style="#tdStyle#" nowrap>
				<cfif q_Transacciones.TiendaExt neq ''>
					#q_Transacciones.TiendaExt#
				</cfif>
				<cfif isdefined('q_Transacciones.Folio') and #q_Transacciones.Folio# neq ''> 
					#q_Transacciones.Folio#
				<cfelseif isdefined('q_Transacciones.Numero') and #q_Transacciones.Numero# neq ''>
					#q_Transacciones.Numero#
				</cfif>
			</td>
			<td style="#tdStyle#">#q_Transacciones.TipoTransaccion#</td>
			<td style="#tdStyle#">
				<cfif q_Transacciones.Tipo eq 'TM'>
					<cfset mesCorte = right("00#month(q_Transacciones.Codigo)#", 2)>
					<cfset diaCorte = right("00#day(q_Transacciones.Codigo)#", 2)>
					TM#year(q_Transacciones.Codigo)##mesCorte##diaCorte#-#q_Transacciones.SNid#
				<cfelse>
					#q_Transacciones.Codigo#
				</cfif>
			</td>
			<td style="#tdStyle#">#DateFormat(q_Transacciones.Fecha,"YYYY-MM-DD")#</td>
			<td style="#tdStyle#">#q_Transacciones.Parciales#</td>
			<td style="#tdStyle#">#q_Transacciones.TipoMov#</td>
			<td style="#tdStyle#">#LSCurrencyFormat(q_Transacciones.Monto)#</td>
			<td style="#tdStyle#">

				<cfif arrayFind(['VC','TC','TM','RC', 'GC'], trim(q_Transacciones.TipoTransaccion)) gt 0>
					<button type="button" onclick="openDetail(#q_Transacciones.id#);"><i class="fa fa-search"></i></button>
				<cfelse>&nbsp;</cfif>
				
			</td>
		</tr>
	</cfloop>
	<cfif q_Transacciones.recordcount eq 0>
		<tr>
			<td style="#tdStyle# text-align:center;" colspan="13">--- NO POSEE TRANSACCIONES ---</td>
		</tr>
	</cfif>
		<tr>
		<td colspan="13" align="right">
			<input type="button" name="Regresar" class="btnAnterior" value="#BTN_Regresar#" onclick="javascript:location.href='consultaTransacciones.cfm';" tabindex="2">
		</td>
	</tr>
</table>

<script>
	function openDetail(id){
		window.open("DetalleTransaccion.cfm?id="+id,'Detalle Transaccion','scrollbars=1,resizeable=1,height=350,width=1000');
		if (window.focus) {newwindow.focus()}
       return false;
	}
</script>
<cf_web_portlet_end>			

<cf_templatefooter>
</cfoutput>
