<cfif not isdefined("url.tran_id") or url.tran_id eq "">
	<cfthrow message="No se encontro la Transaccion">
</cfif>


<div class="row">
	<div class="col-md-6">
		
		<cfquery name="q_Transacciones" datasource="#session.DSN#">
			select top 1
					A.Cliente
				,	A.CURP
				,	A.ETNumero
				,	A.Observaciones
				,	A.TipoTransaccion
				,	A.Fecha
				,	A.TipoMov
				,	A.Parciales
				,	A.Monto - A.Descuento Monto
				,	A.Descuento
				,	A.id
				,	A.Ticket
				,   cc.Numero
				,	case cc.Tipo when 'D' then 'Vales' else 'Tarjeta' end CuentaTipo
				,	A.Folio
				,	sn.SNnombre
				,	sn.SNid
				,	isnull(c.Codigo, A.Fecha) Codigo
				,	cc.Tipo
				,	cc.id CuentaId
				,	A.Monto PagadoNeto
			from CRCTransaccion A
			<cfif isdefined('form.buscarPor') and #form.buscarPor# eq 2 and #form.folio_NumTar# neq ''>
				inner join CRCTarjeta ct on ct.CRCCuentasid = A.CRCCuentasid 
			</cfif>
			inner join CRCCuentas cc on cc.id = A.CRCCuentasid
			inner join SNegocios sn on sn.SNid = cc.SNegociosSNid
			left JOIN CRCCortes c ON A.Fecha >= c.FechaInicio AND A.Fecha < dateadd(DAY, 1, c.FechaFin)
				AND rtrim(ltrim(c.Tipo)) = rtrim(ltrim(cc.Tipo))
				and cc.Tipo <> 'TM'
			where A.ecodigo = #session.Ecodigo#
				and A.id = '#url.tran_id#'
				and cc.Tipo in ('D', 'TC') 
				and A.TipoMov = 'D'
				and A.TipoTransaccion in ('PG')
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
				<td align="right"><strong>Cuenta:</strong></td>
				<td width="1%"></td>
				<td align="left">#q_Transacciones.Numero#</td>
			</tr>
			<tr>
				<td align="right"><strong>Tipo:</strong></td>
				<td width="1%"></td>
				<td align="left">#q_Transacciones.CuentaTipo#</td>
			</tr>
			<tr>
				<td align="right"><strong>Cliente:</strong></td>
				<td width="1%"></td>
				<td align="left">#q_Transacciones.SNnombre#</td>
			</tr>
			<tr>
				<td align="right"><strong>Transaccion:</strong></td>
				<td width="1%"></td>
				<td align="left">#q_Transacciones.id#</td>
			</tr>
			<tr>
				<td align="right"><strong>Lote:</strong></td>
				<td width="1%"></td>
				<td align="left">#q_Transacciones.ETNumero#</td>
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
				<td align="right"><strong>Descuento:</strong></td>
				<td width="1%"></td>
				<td align="left">#LSCurrencyFormat(q_Transacciones.Descuento)#</td>
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
	<form action="ReversaPago_sql.cfm" name="form1" onsubmit="return validateForm()" method="post">
		<div class="col-md-6">
			<cfoutput>
			<table width="95%" border="0" >
				<tr>
					<td>&nbsp;
						<input name="tran_id" type="hidden" value="#url.tran_id#">
						<input type="hidden" name="Monto" value="#q_Transacciones.Monto#">
						<input type="hidden" name="PagadoNeto" id="PagadoNeto" value="#q_Transacciones.PagadoNeto#" >
					</td>
				</tr>
				
				<cfif q_Transacciones.PagadoNeto gt 0>
				<tr>
					<td align="left" colspan="3">
					<div class="row">
						<div class="col-md-12">
							<p class="text-warning">
								El proceso de Reversar pago es irreversible. <br>
								Verifique bien los datos antes de continuar.
							</p>
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
	return confirm('Esta seguro que desea Reversar el Pago?');
}
</script>


<script>
	function checkPagadoNeto(){
		checkbox.checked = true;
		var checkbox = document.getElementById('PagadoNeto');
		if (checkbox.checked == true){
			$("#Aplica").show();
		}else{
			$("#Aplica").hide();
		}
	}
</script>