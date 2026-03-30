<cfif not isdefined("url.tran_id") or url.tran_id eq "">
	<cfthrow message="No se encontro la Transaccion">
</cfif>


<div class="row">
	<div class="col-md-6">
		<cfquery name="q_Transacciones" datasource="#session.DSN#">
			select top 1
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
				,	cc.id CuentaId
				,	mcc.PagadoNeto
			from CRCTransaccion A
			inner join (
				select t.id, sum(mcc.MontoRequerido + mcc.Intereses) MontoRequerido,
									sum(mcc.Pagado + mcc.Descuento) Pagado,
									sum(mcc.Pagado) PagadoNeto
								from CRCTransaccion t
								inner join CRCMovimientoCuenta mcc
									on t.id = mcc.CRCTransaccionid
								where t.TipoTransaccion = 'VC'
								group by t.id
								having sum(mcc.MontoRequerido + mcc.Intereses) > sum(mcc.Pagado + mcc.Descuento)
			) mcc on A.id = mcc.id
			<cfif isdefined('form.buscarPor') and #form.buscarPor# eq 2 and #form.folio_NumTar# neq ''>
				inner join CRCTarjeta ct on ct.CRCCuentasid = A.CRCCuentasid 
			</cfif>
			inner join CRCCuentas cc on cc.id = A.CRCCuentasid
			inner join SNegocios sn on sn.SNid = cc.SNegociosSNid
			left JOIN CRCCortes c ON A.Fecha BETWEEN c.FechaInicio AND dateadd(DAY, 1, c.FechaFin)
				AND rtrim(ltrim(c.Tipo)) = rtrim(ltrim(cc.Tipo))
				and cc.Tipo <> 'TM'
			where A.ecodigo = #session.Ecodigo#
				and A.id = '#url.tran_id#'
				and cc.Tipo = 'D'
				and A.TipoMov = 'C'
				and A.TipoTransaccion = 'VC'
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
		<cfif q_Transacciones.recordCount eq 0>
			<cfthrow message="No se encontro la Transaccion">
		</cfif>
		<cfoutput>
		<table width="95%" border="0" >
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td align="right"><strong>Distribuidor:</strong></td>
				<td width="1%"></td>
				<td align="left">#q_Transacciones.SNnombre#</td>
			</tr>
			<tr>
				<td align="right"><strong>Transaccion:</strong></td>
				<td width="1%"></td>
				<td align="left">#q_Transacciones.id#</td>
			</tr>
			<tr>
				<td align="right"><strong>Fecha:</strong></td>
				<td width="1%"></td>
				<td align="left">#DateFormat(q_Transacciones.Fecha,'yyyy/mm/dd')#</td>
			</tr>
			<tr>
				<td align="right"><strong>Monto:</strong></td>
				<td width="1%"></td>
				<td align="left">#LSCurrencyFormat(q_Transacciones.Monto)#</td>
			</tr>
			<tr>
				<td align="right"><strong>Pagado Neto:</strong></td>
				<td width="1%"></td>
				<td align="left">#LSCurrencyFormat(q_Transacciones.PagadoNeto)#</td>
			</tr>
			<tr>
				<td align="right"><strong>Parcialidades:</strong></td>
				<td width="1%"></td>
				<td align="left">#q_Transacciones.Parciales#</td>
			</tr>
			<tr>
				<td align="right"><strong>CURP:</strong></td>
				<td width="1%"></td>
				<td align="left">#q_Transacciones.CURP#</td>
			</tr>
			<tr>
				<td align="right"><strong>Cliente:</strong></td>
				<td width="1%"></td>
				<td align="left">#q_Transacciones.Cliente#</td>
			</tr>
			<tr>
				<td align="right"><strong>Observaciones:</strong></td>
				<td width="1%"></td>
				<td align="left">#q_Transacciones.Observaciones#</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
		</cfoutput>
	</div>
	<form action="TransferirTransacciones_sql.cfm" name="form1" onsubmit="return validateForm()" method="post">
		<div class="col-md-6">
			<cfoutput>
			<table width="95%" border="0" >
				<tr>
					<td>&nbsp;
						<input name="tran_id" type="hidden" value="#url.tran_id#">
					</td>
				</tr>
				<tr>
					<td align="right"><strong>#LB_Cuenta#:&nbsp;</strong></td>
					<td width="1%"></td>
					<td>
						<input type="hidden" name="Monto" value="#q_Transacciones.Monto#">
						<cf_conlis
							Campos="id, Numero, SNnombre, Tipo"
							Desplegables="N,S,S,N"
							Modificables="N,S,N,S"
							Size="0,10,30,20"
							tabindex="2"
							Tabla="CRCCuentas cc inner join SNegocios sn on sn.SNid = SNegociosSNid"
							Columnas="id,SNid,Numero,SNnombre, Tipo = case 
									when Tipo = 'D' then 'Distribuidor'
									when Tipo = 'TC' then 'Tarjeta de Credito'
									when Tipo = 'TM' then 'Tarjeta Mayorista' 
									end"
							form="form1"
							Filtro="sn.Ecodigo = #Session.Ecodigo# and cc.Tipo = 'D' and cc.id <> #q_Transacciones.CuentaId#
									order by SNnombre"
							Desplegar="Numero, SNnombre, Tipo"
							Etiquetas="#LB_Numero#, #LB_Nombre#, #LB_Tipo#"
							filtrar_por="Numero, SNnombre, Tipo"
							Formatos="S,S,S"
							Align="left, left, left"
							Asignar="id,SNid,Numero,SNnombre, Tipo"
							Asignarformatos="S,S,S,S"
							funcion = "validaTipo()"/>

						</td>
				</tr>
				<cfif q_Transacciones.PagadoNeto gt 0>
				<tr>
					<td align="left" colspan="3">
					<div class="row">
						<div class="col-md-6">
							<label class="text-danger">La transacci&oacute;n seleccionada tiene pagos realizados</label>
							<p class="text-info">
								Puede realizar una Re-aplicaci&oacute;n de Pago o pasar el monto pagado como Saldo a favor.
							</p>
						</div>
						<div class="col-md-6">
							<div class="checkbox">
								<label>
									<input type="checkbox" name="PagadoNeto" id="PagadoNeto" value="#q_Transacciones.PagadoNeto#" onclick="checkPagadoNeto()">
									<cfoutput>#LSCurrencyFormat(q_Transacciones.PagadoNeto)# a Saldo a favor</cfoutput>
								</label>
							  </div>
						</div>
					</div>
						
					</td>
				</tr>
				</cfif>
				<tr id="Aplica">
					<td align="center" colspan="3">
						<input type="submit" class="btnAplicar" name="aplicar" id="aplicar" value="Aplicar"> 
					</td>
				</tr>
			</table>
			</cfoutput>
		</div>
	</form>
</div>

<script>
function validateForm() {
	var x = document.forms["form1"]["id"].value;
	if (x == "") {
		alert("Seleccione la cuenta destino");
		return false;
	}
}
</script>
<cfif q_Transacciones.PagadoNeto gt 0>
<script>
	$("#Aplica").hide();
</script>
</cfif>

<script>
	function checkPagadoNeto(){
		var checkbox = document.getElementById('PagadoNeto');
		if (checkbox.checked == true){
			$("#Aplica").show();
		}else{
			$("#Aplica").hide();
		}
	}
</script>