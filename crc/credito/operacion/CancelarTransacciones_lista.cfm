
<form name="form1" action="CancelarTransacciones.cfm" method="post">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td align="center">
			<fieldset>
				<b>#LB_FiltrosConsulta#</b>
			</fieldset>
			<table  width="95%" cellpadding="2" cellspacing="0" border="0">
				<tr><td >&nbsp;</td></tr>
				<tr align="left">
					<td>
						<strong>#LB_Cuenta#:&nbsp;</strong>
						<cf_conlis
							Campos="Numero, SNnombre, Tipo"
							Desplegables="S,S,S"
							Modificables="S,N,S"
							Size="10,30,20"
							tabindex="2"
							Tabla="CRCCuentas cc inner join SNegocios sn on sn.SNid = SNegociosSNid"
							Columnas="SNid,Numero,SNnombre, Tipo = case 
									when Tipo = 'D' then 'Distribuidor'
									when Tipo = 'TC' then 'Tarjeta de Credito'
									when Tipo = 'TM' then 'Tarjeta Mayorista' 
									end"
							form="form1"
							Filtro="sn.Ecodigo = #Session.Ecodigo# and cc.Tipo in ('D','TC')
									order by SNnombre"
							Desplegar="Numero, SNnombre, Tipo"
							Etiquetas="#LB_Numero#, #LB_Nombre#, #LB_Tipo#"
							filtrar_por="Numero, SNnombre, Tipo"
							Formatos="S,S,S"
							Align="left, left, left"
							Asignar="SNid,Numero,SNnombre, Tipo"
							Asignarformatos="S,S,S,S"/>

						<!---<input type="text" name="cuenta" id="cuenta">--->
					</td>
					<td>
						<strong>#LB_Referencias#:&nbsp;</strong>
						<input type="text" name="referencias" id="referencias">
					</td>
					<td>
						<select name="buscarPor" id="buscarPor">
							<option value="">Todas</option>
							<option value="VC" <cfif isdefined("form.buscarPor") and form.buscarPor eq 'VC'> selected </cfif>>#LB_Folio#</option>
							<option value="TC" <cfif isdefined("form.buscarPor") and form.buscarPor eq 'TC'> selected </cfif>>Tarjeta</option>
						  </select>
						  <input type="text" name="folio_NumTar" id="folio_NumTar" <cfif isdefined("form.folio_NumTar") and form.folio_NumTar neq ""> value="#folio_NumTar#" </cfif>>
					</td>
				</tr>
				<tr align="left">
					<td>
						<strong>#LB_FechaDesde#:&nbsp;</strong>
						<cf_sifcalendario form="form1" value="" name="fechaDesde" tabindex="1" nameFechaInicio="nameFechaInicio">
						<input type="hidden" name="nameFechaIni" value="#rsCorteActual.FechaInicio#">
						&nbsp;
						<strong>#LB_FechaHasta#:&nbsp;</strong>
						<cfset fechaHas = LSDateFormat(Now(),'dd/mm/yyyy')>
						<cf_sifcalendario form="form1" value="#fechaHas#" name="fechaHasta" tabindex="1" nameFechaFin="nameFechFin">
						<input type="hidden" name="nameFechFin" value="#rsCorteActual.FechaFin#">
					</td>
					<td colspan="2">
					<input type="submit" class="btnGuardar" name="consultar" id="consultar" value="#LB_Consultar#"> 
					<input type="button" name="limpiar" class="btnLimpiar" value="Limpiar" onclick="javascript:location.href='consultaTransacciones.cfm';" tabindex="2">
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<label id="msj"></label>
					</td>
				</tr>
				<tr>
					<td>
						
					</td>
				</tr>
				
				<tr align="center">
					<td colspan="3">
						<cfquery name="q_Transacciones" datasource="#session.DSN#">
							select top 1000
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
								,	mcc.PagadoNeto
							from CRCTransaccion A
							inner join (
								select t.id, sum(mcc.MontoRequerido + mcc.Intereses) MontoRequerido,
									sum(mcc.Pagado + mcc.Descuento) Pagado,
									sum(mcc.Pagado) PagadoNeto
								from CRCTransaccion t
								inner join CRCMovimientoCuenta mcc
									on t.id = mcc.CRCTransaccionid
								where 1 = 1 
								<cfif isdefined('form.buscarPor') and form.buscarPor neq "">
									and t.TipoTransaccion  = '#form.buscarPor#'
								</cfif>
								group by t.id
								having sum(mcc.MontoRequerido + mcc.Intereses) > sum(mcc.Pagado + mcc.Descuento)
							) mcc on A.id = mcc.id
							<cfif isdefined('form.buscarPor') and #form.buscarPor# eq 'TC'>
								inner join CRCTarjeta ct on ct.CRCCuentasid = A.CRCCuentasid 
							</cfif>
							inner join CRCCuentas cc on cc.id = A.CRCCuentasid
							inner join SNegocios sn on sn.SNid = cc.SNegociosSNid
							left JOIN CRCCortes c ON A.Fecha BETWEEN c.FechaInicio AND dateadd(DAY, 1, c.FechaFin)
								AND rtrim(ltrim(c.Tipo)) = rtrim(ltrim(cc.Tipo))
								and cc.Tipo <> 'TM'
							where A.ecodigo = #session.Ecodigo#
								and A.TipoMov = 'C'
								and A.TipoTransaccion in ('VC','TC','TM','GC')
							<cfif isdefined('form.buscarPor') and trim(form.buscarPor) neq ''>
								<cfif form.buscarPor eq 'VC' and form.folio_NumTar neq ''>
									and Folio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.folio_NumTar#">
								<cfelseif form.buscarPor eq 'TC'  and form.folio_NumTar neq ''>
									and ct.Numero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.folio_NumTar#">
								</cfif>
							</cfif>

							<cfif isdefined('form.referencias') and #form.referencias# neq ''>
								and Ticket = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.referencias#">
							</cfif>
							
							<cfif isdefined('form.Numero') and #form.Numero# neq ''>
								and cc.Numero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Numero#">
							</cfif>

							<cfif isdefined("Form.FECHADESDE") && Form.FECHADESDE neq "">
								<cfset form.FECHADESDE = ListToArray(form.FECHADESDE,'/')>
								<cfset form.FECHADESDE = "#form.FECHADESDE[3]#-#form.FECHADESDE[2]#-#form.FECHADESDE[1]#">
								and A.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fechaDesde#">
							</cfif>

							<cfif isdefined("Form.FECHAHASTA") && Form.FECHAHASTA neq "">
								<cfset form.FECHAHASTA = ListToArray(form.FECHAHASTA,'/')>
								<cfset form.FECHAHASTA = "#form.FECHAHASTA[3]#-#form.FECHAHASTA[2]#-#form.FECHAHASTA[1]#">
								and A.Fecha <= dateadd(DAY, 1, <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">)
							</cfif>

							order by A.id desc
						</cfquery>
						
						<cfset counter = 0>
						<cfset tdStyle = "background-color:##ccc; padding:5px;">
						<style>
							th, td { 
								padding-left: 5px;
							}
						</style>
						<table width="100%" border="0" cellspacing="5" cellpadding="5" align="center">
							<tr>
								<td colspan="13"><label color="blue">*Limitado a 1000 registros</label></td>
							</tr>
							<tr>
								<th>Cuenta</th>
								<th>Transacci&oacute;n</th>
								<th>#LB_Cliente#</th>
								<th>#LB_Referencias#</th>
								<th>#LB_Observacion#</th>
								<th>#LB_Fecha#</th>
								<th>#LB_Parcialidades#</th>
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
									<td style="#tdStyle#" nowrap>#q_Transacciones.Numero# #q_Transacciones.SNnombre#</td>
									<td style="#tdStyle#">#q_Transacciones.id#</td>
									<td style="#tdStyle#">#q_Transacciones.Cliente#</td>
									<td style="#tdStyle#">#q_Transacciones.Ticket#</td>
									<td style="#tdStyle#">#q_Transacciones.Observaciones#</td>
									<td style="#tdStyle#">#DateFormat(q_Transacciones.Fecha,"YYYY-MM-DD")#</td>
									<td style="#tdStyle#" align="right">#q_Transacciones.Parciales#</td>
									<td style="#tdStyle#" align="right">#LSCurrencyFormat(q_Transacciones.Monto)#</td>
									<td style="#tdStyle#">
										<!--- transacciones Cancelables --->
										<cfif arrayFind(['VC','TC','TM','GC'], trim(q_Transacciones.TipoTransaccion)) gt 0>
											<button type="button" onclick="openDetail(#q_Transacciones.id#);"><i alt="Cancelar" class="fa fa-trash"></i></button>
										<cfelse>&nbsp;</cfif>
										
									</td>
								</tr>
							</cfloop>
							<cfif q_Transacciones.recordcount eq 0>
								<tr>
									<td style="#tdStyle# text-align:center;" colspan="13">--- NO POSEE TRANSACCIONES ---</td>
								</tr>
							</cfif>
						</table>

						<script>
							function openDetail(id){
								window.location.href = "CancelarTransacciones.cfm?tran_id="+id;
							}
						</script>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</form>

<script type="text/javascript">

	document.ready = document.getElementById("Tipo").style.display = 'none';


	function validaTipoTransac(){


		var tipoT = document.getElementById('numTarjeta').value;
		var tipoVC = document.getElementById('folio').value;

		if (tipoT != '') {
			document.getElementById('filaFolio').style.display = 'none';
		}else{
			document.getElementById('filaFolio').style.display = '';
		}

		if (tipoVC != ''){
			document.getElementById('filaTarjeta').style.display = 'none';

		}else{
			document.getElementById('filaTarjeta').style.display = '';
		}

		muestraMsj();

	}

	function muestraMsj(){
		if (document.getElementById('filaTarjeta').style.display == 'none' || document.getElementById('filaFolio').style.display == 'none') {
			document.getElementById('msj').style.color="##000000";
			document.getElementById('msj').innerHTML = "No se puede buscar por Folio y N&uacute;mero de Tarjeta a la vez";
		}else{
			document.getElementById('msj').style.color="##000000";
			document.getElementById('msj').innerHTML = "";
		}
	}


</script>
 </cfoutput>


