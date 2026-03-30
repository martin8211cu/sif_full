
<form name="form1" action="ReversaPago.cfm" method="post">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td align="center">
			<fieldset>
				<b>#LB_FiltrosConsulta#</b>
			</fieldset>
			<table  width="95%" cellpadding="2" cellspacing="0" border="0">
				<tr><td >&nbsp;</td><td >&nbsp;</td></tr>
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
					<td >
						<strong>Usuario:&nbsp;</strong>
						<cfquery name="rsUsuarios" datasource="#Session.dsn#">
							select distinct Usulogin 
							from Etransacciones where ETestado = 'C'
								and Ecodigo = #Session.Ecodigo#
							order by Usulogin
						</cfquery>

						<select name="Usulogin">
							<option value=""> -- Todos --</option>
							<cfloop query="#rsUsuarios#">
								<option value="#UsuLogin#" <cfif isdefined("form.Usulogin") and form.Usulogin eq Usulogin> selected </cfif> >#UsuLogin#</option>
							</cfloop>
						</select>
					</td>
					<td colspan="2">
						<input type="submit" class="btnGuardar" name="consultar" id="consultar" value="#LB_Consultar#"> 
					</td>
				</tr>
				<tr align="left">
					<td>
						<strong>#LB_FechaDesde#:&nbsp;</strong>
						<cf_sifcalendario form="form1" value="" name="fechaDesde" tabindex="1" nameFechaInicio="nameFechaInicio">
						<input type="hidden" name="nameFechaIni" value="#rsCorteActual.FechaInicio#">
					</td>
					<td>
						<strong>Tipo de Cuenta:&nbsp;</strong>
						<select name="tipoCuenta">
							<option value=""> -- Todos --</option>
							<option value="TC" <cfif isdefined("form.tipoCuenta") and form.tipoCuenta eq "TC"> selected </cfif>>Tarjeta</option>
							<option value="D" <cfif isdefined("form.tipoCuenta") and form.tipoCuenta eq "D"> selected </cfif>>Vales</option>							
						</select>
					</td>
				</tr>
				<tr align="left">
					<td>
						<strong>#LB_FechaHasta#:&nbsp;</strong>
						<cfset fechaHas = LSDateFormat(Now(),'dd/mm/yyyy')>
						<cf_sifcalendario form="form1" value="#fechaHas#" name="fechaHasta" tabindex="1" nameFechaFin="nameFechFin">
						<input type="hidden" name="nameFechFin" value="#rsCorteActual.FechaFin#">
					</td>
					<td >&nbsp;</td>
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
							select top 100
									A.Cliente
								,	A.CURP
								,	A.Observaciones
								,	A.TipoTransaccion
								,	A.Fecha
								,	A.TipoMov
								,	A.Parciales
								,	dt.DTtotal Monto
								,	dt.DTdeslinea Descuento
								,	A.id
								,	A.Ticket
								,   cc.Numero
								,	case cc.Tipo when 'D' then 'Vales' else 'Tarjeta' end CuentaTipo
								,	A.Folio
								,	sn.SNnombre
								,	sn.SNid
								,	isnull(c.Codigo, A.Fecha) Codigo
								,	cc.Tipo
								,	A.ETNumero
								,	et.Usulogin
								, 	lp.id ultimoid
							from CRCTransaccion A
							<cfif isdefined('form.buscarPor') and #form.buscarPor# eq 'TC'>
								inner join CRCTarjeta ct on ct.CRCCuentasid = A.CRCCuentasid 
							</cfif>
							inner join CRCCuentas cc on cc.id = A.CRCCuentasid
							inner join SNegocios sn on sn.SNid = cc.SNegociosSNid
							INNER JOIN CRCCortes c ON A.Fecha >= c.FechaInicio AND A.Fecha < dateadd(DAY, 1, c.FechaFin)
								AND rtrim(ltrim(c.Tipo)) = rtrim(ltrim(cc.Tipo)) and c.status < 3
								and cc.Tipo <> 'TM'
							INNER JOIN (
								select t.CRCCuentasId, sum(mc.Pagado) Pagado
								from CRCTransaccion t
								inner join CRCCuentas c on c.id = t.CRCCuentasId
								inner join CRCMovimientoCuenta mc on t.id = mc.CRCTransaccionid
								inner join (
									Select Codigo, Tipo from CRCCortes where status <= 2
								) ct on mc.Corte = ct.Codigo and c.Tipo = ct.Tipo
								where mc.Pagado > 0
								group by t.CRCCuentasId
							) MC ON A.CRCCuentasid = MC.CRCCuentasid
							INNER JOIN ETransacciones et on A.ETnumero = et.ETnumero and A.Ecodigo = et.Ecodigo
							INNER JOIN (select * from DTransacciones where DTborrado = 0 )dt on et.ETnumero = dt.ETnumero and et.Ecodigo = dt.Ecodigo
							left join (
								select CRCCuentasid, max(id) id, max(Fecha) Fecha
								from CRCTransaccion t
								where TipoTransaccion = 'PG'
									and Ecodigo = #Session.Ecodigo#
									and ReversaId is null
								group by CRCCuentasid
							) lp on A.id = lp.id
							where A.ecodigo = #session.Ecodigo#
								and A.TipoMov = 'D'
								and A.TipoTransaccion in ('PG')
								and A.ReversaId is null
								and et.ETestado = 'C'
							<cfif isdefined('form.Numero') and #form.Numero# neq ''>
								and cc.Numero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Numero#">
							</cfif>

							<cfif isdefined("Form.Usulogin") && Form.Usulogin neq "">
								and et.Usulogin = '#form.Usulogin#'
							</cfif>
							
							<cfif isdefined("Form.tipoCuenta") && Form.tipoCuenta neq "">
								and cc.Tipo = '#form.tipoCuenta#'
							</cfif>

							<cfif isdefined("Form.FECHADESDE") && Form.FECHADESDE neq "">
								<cfset form.FECHADESDE = ListToArray(form.FECHADESDE,'/')>
								<cfset form.FECHADESDE = "#form.FECHADESDE[3]#-#form.FECHADESDE[2]#-#form.FECHADESDE[1]#">
								and A.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fechaDesde#">
							</cfif>

							<cfif isdefined("Form.FECHAHASTA") && Form.FECHAHASTA neq "">
								<cfset form.FECHAHASTA = ListToArray(form.FECHAHASTA,'/')>
								<cfset form.FECHAHASTA = "#form.FECHAHASTA[3]#-#form.FECHAHASTA[2]#-#form.FECHAHASTA[1]#">
								and A.Fecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">
							</cfif>
							and A.Monto <= (
								select max(isnull(Ptotal,0)) totalPago 
								from  Pagos p
								where p.Ecodigo = #session.Ecodigo#
							)
							order by A.CRCCuentasId, A.Fecha desc, A.id desc
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
								<td colspan="13"><label color="blue">*Limitado a 100 registros</label></td>
							</tr>
							<tr>
								<th>Cuenta</th>
								<th>Tipo</th>
								<th>Transacci&oacute;n</th>
								<th>Usuario</th>
								<th>#LB_Observacion#</th>
								<th>#LB_Fecha#</th>
								<th>#LB_Monto#</th>
								<th>Descuento</th>
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
									<td style="#tdStyle#">#q_Transacciones.CuentaTipo#</td>
									<td style="#tdStyle#">#q_Transacciones.ETNumero#</td>
									<td style="#tdStyle#">#q_Transacciones.Usulogin#</td>
									<td style="#tdStyle#">#q_Transacciones.Observaciones#</td>
									<td style="#tdStyle#">#DateFormat(q_Transacciones.Fecha,"YYYY-MM-DD")#</td>
									<td style="#tdStyle#" align="right">#LSCurrencyFormat(q_Transacciones.Monto)#</td>
									<td style="#tdStyle#" align="right">#LSCurrencyFormat(q_Transacciones.Descuento)#</td>
									<td style="#tdStyle#">
										<!--- transacciones Cancelables --->
										<cfif (arrayFind(['PG'], trim(q_Transacciones.TipoTransaccion)) gt 0) and q_Transacciones.id eq q_Transacciones.ultimoid>
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
								window.location.href = "ReversaPago.cfm?tran_id="+id;
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


