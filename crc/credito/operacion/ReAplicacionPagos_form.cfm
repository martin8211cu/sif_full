<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Re aplicacion de pagos" returnvariable="LB_Title"/>

<cfinvoke  key="BTN_Regresar" default="Regresar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Regresar" xmlfile="/crc/generales.xml"/>
<cfinvoke  key="BTN_Filtrar" default="Filtrar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Filtrar" xmlfile="/crc/generales.xml"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_SociosNegocio" default = "Socio de Negocio" returnvariable="LB_SociosNegocio" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Transaccion" default = "Transacci&oacute;n" returnvariable="LB_Transaccion" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" default = "Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MovCuentaId" default = "Id Movimiento de Cuenta" returnvariable="LB_MovCuentaId" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoPagado" default = "Monto Pagado" returnvariable="LB_MontoPagado" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoModificado" default = "Monto Modificado" returnvariable="LB_MontoModificado" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Pagado" default = "Pagado" returnvariable="LB_Pagado" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Modificar" default = "Modificar" returnvariable="LB_Modificar" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_DescAsignado" default = "Descuento Asignado" returnvariable="LB_DescAsignado" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_DescModificado" default = "Descuento Modificado" returnvariable="LB_DescModificado" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Cliente" default = "Cliente" returnvariable="LB_Cliente" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CURP" default = "Ticket" returnvariable="LB_CURP" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoAPagar" default = "Monto a Pagar" returnvariable="LB_MontoAPagar" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_SaldoVencido" default = "Saldo Vencido" returnvariable="LB_SaldoVencido" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoRequerido" default = "Monto Requerido" returnvariable="LB_MontoRequerido" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Sugerencia" default = "Sugerencia" returnvariable="LB_Sugerencia" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CorteAnterior" default = "Corte Anterior" returnvariable="LB_CorteAnterior" xmlfile = "Socios.xml">
<cfinvoke component="crc.Componentes.cortes.CRCCortes" method="buscarUltimoCorteCalculado" returnvariable="ultimoCorteCalculado">
	<cfinvokeargument name="TipoTransaccion" value="D">
</cfinvoke>
<cfoutput>


<cfif isdefined("url.modoC") and len(trim(url.modoC)) and not isdefined("form.modoC")>
	<cfparam name="form.modoC" default="#Url.modoC#"> <!--- <cfdump var="#form#"> --->
	<cfset form.modoC = url.modoC>
</cfif>
<cfif isdefined("Form.Cambio")>
	<cfset modoC="ALTA">
<cfelse>
	<cfif not isdefined("Form.modoC")>
		<cfset modoC="ALTA">
	<cfelseif Form.modoC EQ "CAMBIO">
		<cfset modoC="CAMBIO">
	<cfelse>
		<cfset modoC="ALTA">
	</cfif>
</cfif>


<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>

<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		<!--- <cfdump var="#form#"> --->
		
		<cfif isDefined("session.Ecodigo") and isDefined("Form.SNcodigo") and len(trim(#Form.SNcodigo#))>

			<cfquery name = "rsSociosD" datasource="#Session.DSN#">

				select sn.SNnombre,
				cc.id IdCuenta, 
				Pagado, 
				t.id idT,
				t.Monto monto, 
				cc.Tipo tipo,
				mc.Corte,
				mc.id idMC, 
				mc.Descripcion,
				mc.Descuento,
				Cliente,
				Ticket CURP,
				---CURP,
				mc.SaldoVencido,
				MontoAPagar,
				MontoRequerido
				from CRCMovimientoCuenta mc 
					INNER JOIN CRCTransaccion t 
						ON mc.CRCTransaccionid = t.id
					INNER JOIN CRCCuentas cc 
						ON t.CRCCuentasid = cc.id
					INNER JOIN SNegocios sn 
						ON cc.SNegociosSNid = sn.SNid
				where sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#">
				and cc.Tipo = 'D'
				and t.TipoTransaccion = 'VC'
				<cfif isDefined('form.corteAnterior') and #form.corteAnterior# neq '' and #form.corteAnterior# eq '2'>
					and mc.Corte in (select Codigo  
									from CRCCortes 
									where Tipo = 'D' 
										and status = 2)
				<cfelse>
					and (mc.Corte in (select Codigo  
									from CRCCortes 
									where Tipo = 'D' 
										and Cerrado = 0)
						or mc.Corte in (select Codigo  
									from CRCCortes 
									where Tipo = 'D' 
										and status = 1)
					)
				</cfif>

			</cfquery>



		</cfif>
		
		<form method="post" name="formR" action="ReAplicacionPagos_sql.cfm">
			<cfset arraycolum = ValueArray (rsSociosD, "Pagado")>
			<cfset totalPagado = ArraySum(arraycolum)>

			<cfset arraycolumD = ValueArray (rsSociosD, "Descuento")> 
			<cfset totalDesAsignado = ArraySum (arraycolumD)>
			 
			<!---Campos ocultos ----> 
			<input name="totalPagado" id="totalPagado" value="#totalPagado#" type="hidden">
			<input name="cantidadTotalPagado" id="cantidadTotalPagado" value="#rsSociosD.recordCount#" type="hidden">
			<input name="SNcodigo" id="SNcodigo" value="#Form.SNcodigo#" type="hidden">
			<input type="hidden" name="IdCuenta" id="IdCuenta" value="#rsSociosD.IdCuenta#">

			<input name="totalDesAsignado" id="totalDesAsignado" value="#totalDesAsignado#" type="hidden">
			<input name="cantidadtotalDesAsignado" id="cantidadtotalDesAsignado" value="#rsSociosD.recordCount#" type="hidden">

			<cfinclude template="/home/menu/pNavegacion.cfm">
			<div class="col col-sm-12" >
				<div class="well">
					<div class="bs-example form-horizontal">
						<table>
							<tr>
								<td><cfoutput><strong>#LB_SociosNegocio#:&nbsp;</strong></cfoutput></td>
								<td><cfoutput>#HTMLEditFormat(rsSociosD.SNnombre)#</cfoutput></td>
							</tr>
							<tr>
								<td><strong>#LB_CorteAnterior#:&nbsp;</strong></td>
								<td>
									<input type="checkbox" name="corteAnterior" id="corteAnterior" onchange="RACorteAnterior()" 
									<cfif isDefined('form.corteAnterior')> checked </cfif> >
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td><cfoutput><strong>#LB_MontoPagado#:&nbsp;</strong></cfoutput></td>
								<td><cfoutput>#NumberFormat(totalPagado,"00.00")#</cfoutput></td>
								<td><cfoutput><strong>#LB_DescAsignado#:&nbsp;</strong></cfoutput></td>
								<td><cfoutput>#NumberFormat(totalDesAsignado,"00.00")#</cfoutput></td>
							</tr>
							<tr>
								<td><cfoutput><strong>#LB_MontoModificado#:</strong></cfoutput></td>
								<td id="rsSuma"><cfoutput>#NumberFormat(totalPagado,"00.00")#</cfoutput></td>
								<td><cfoutput><strong>#LB_DescModificado#:</strong></cfoutput></td>
								<td id="rsSumaD"><cfoutput>#NumberFormat(totalDesAsignado,"00.00")#</cfoutput></td>
							</tr>
						</table>
					</div>
				</div>
			</div>
			<table width="40%" border="0" cellspacing="" cellpadding="" align="center" class="PlistaTable">
				<input type="hidden" name="id" value="<cfif modoC eq "CAMBIO">#form.id#</cfif>">
			    <tr>
					<td>
						<table align="center" cellpadding="5" cellspacing="6" border="0" class="PlistaTable" >
							<tr class="tituloListas" height="25">
								<td></td>
								<td nowrap="nowrap"><strong><cfoutput>Corte&nbsp;&nbsp;</cfoutput></strong></td>
								<td nowrap="nowrap"><strong><cfoutput>#LB_Cliente#&nbsp;&nbsp;</cfoutput></strong></td>
								<td nowrap="nowrap"><strong><cfoutput>#LB_CURP#&nbsp;&nbsp;</cfoutput></strong></td>
								<td nowrap="nowrap"><strong><cfoutput>#LB_Descripcion#&nbsp;&nbsp;</cfoutput></strong></td>
								<td nowrap="nowrap"><strong><cfoutput>#LB_SaldoVencido#&nbsp;&nbsp;</cfoutput></strong></td>
								<td nowrap="nowrap"><strong><cfoutput>#LB_MontoAPagar#&nbsp;&nbsp;</cfoutput></strong></td>
								<td nowrap="nowrap"><strong><cfoutput>#LB_MontoPagado#&nbsp;&nbsp;</cfoutput></strong></td>
								<td nowrap="nowrap" align="center"><strong><cfoutput>#LB_MontoModificado#&nbsp;&nbsp;</cfoutput></strong></td>
								<td nowrap="nowrap"><strong><cfoutput>#LB_DescAsignado#&nbsp;&nbsp;</cfoutput></strong></td>
								<td nowrap="nowrap"><strong><cfoutput>#LB_DescModificado#&nbsp;&nbsp;</cfoutput></strong></td>
								<td nowrap="nowrap"></td>
								
							</tr>
							<cfloop query = "rsSociosD">
								<input type="hidden" value="#rsSociosD.Pagado#" id="lblpagado_#rsSociosD.idMC#">
								<input type="hidden" value="#rsSociosD.Descuento#" id="lblDescAsig_#rsSociosD.idMC#">
								<tr>
									<td> <input id ="IdMovCuenta" name="IdMovCuenta" value="#rsSociosD.idMC#" type="hidden"></td>

									<td nowrap="nowrap"><cfoutput>#rsSociosD.Corte#&nbsp;&nbsp;</cfoutput></td>
									<td nowrap="nowrap"><cfoutput>#rsSociosD.Cliente#&nbsp;&nbsp;</cfoutput></td>

									<td nowrap="nowrap"><cfoutput>#rsSociosD.CURP#&nbsp;&nbsp;</cfoutput></td>

									<td nowrap="nowrap"> <cfoutput>#rsSociosD.Descripcion#&nbsp;&nbsp;</cfoutput></td>

									<td nowrap="nowrap" align="center"><cfoutput>#NumberFormat(rsSociosD.SaldoVencido,"00.00")#&nbsp;&nbsp;</cfoutput></td>

									<td nowrap="nowrap" align="center"><cfoutput>#NumberFormat(rsSociosD.MontoAPagar,"00.00")#&nbsp;&nbsp;</cfoutput></td>
													
									<td nowrap="nowrap" align="center"> <cfoutput>#NumberFormat(rsSociosD.Pagado,"00.00")#</cfoutput></td>
									<cfset form.idT = rsSociosD.idT>
									<cfset montoReq = rsSociosD.MontoRequerido>
									<td nowrap="nowrap"> <input name="PagadoRP" type="text" style="text-align: right; width: 100%;" step="0.01" id="Pagado_#rsSociosD.idMC#" value="#NumberFormat(rsSociosD.Pagado,"00.00")#" max="#rsSociosD.monto#" maxlength="255" onkeypress="return soloNumeros(event,this)" onchange="sumar(#montoReq#);" onkeyup ="document.getElementById('lblpagado_#rsSociosD.idMC#').value=this.value;" onclick="document.getElementById('lblpagado_#rsSociosD.idMC#').value=this.value;" required="true"></td>

									<td nowrap="nowrap" align="center"> <cfoutput>#NumberFormat(rsSociosD.Descuento,"00.00")#</cfoutput></td>

									<td nowrap="nowrap"> <input name="DescuentoRP" type="text" style="text-align: right; width: 80%;" step="0.01" id="Descuento_#rsSociosD.idMC#" value="#NumberFormat(rsSociosD.Descuento,"00.00")#" maxlength="255" onkeypress="return soloNumeros(event,this)" onchange="sumarDescuento(#montoReq#);" onkeyup ="document.getElementById('lblDescAsig_#rsSociosD.idMC#').value=this.value;" onclick="document.getElementById('lblDescAsig_#rsSociosD.idMC#').value=this.value;" required="true">&nbsp;&nbsp;</td>
									<td id="sugerencia_#rsSociosD.idMC#" nowrap></td>

								</tr>
							</cfloop>
						</table>
					</td>
				</tr>
				<tr>
					<td align="right">
						<input tabindex="-1" type="hidden" name="botonSel" value="">
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Modificar"
							Default="Modificar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Modificar"/>

						<input tabindex="3" type="submit" id="btnModificar" class="btnGuardar" name="Cambio" value="#BTN_Modificar#">

						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Regresar"
							Default="Regresar"
							XmlFile="/sif/generales.xml"
							returnvariable="BTN_Regresar"/>	

						<input type="button" name="Regresar" class="btnAnterior" value="#BTN_Regresar#" onclick="javascript:location.href='ReAplicacionPagos.cfm';" tabindex="2">
					</td>
				</tr>

			</table>
		</form>		
	<cf_web_portlet_end>
<cf_templatefooter>

<script type="text/javascript">

	function soloNumeros(e, field) {
	    var key = e.keyCode ? e.keyCode : e.which;
		// backspace
		if (key == 8) return true;
		// 0-9
		if (key > 47 && key < 58) {
			if (field.value == "") return true
			regexp = /.[0-9]{2}$/
			return !(regexp.test(field.value))
		}
		// .
		if (key == 46) {
			if (field.value == "") return false
			regexp = /^[0-9]+$/
			return regexp.test(field.value)
		}
		// other key
		return false
	}

	function RACorteAnterior(){	
		chk = document.getElementById('corteAnterior');
	
		if(chk.checked){
			document.forms.formR.action= "ReAplicacionPagos_form.cfm";
			document.getElementById('corteAnterior').value = '2';
			document.formR.submit();
		}
		else{
			document.forms.formR.action= "ReAplicacionPagos_form.cfm";
			document.getElementById('corteAnterior').value = '1';
			document.formR.submit();
		}
	}

	//Funcion para validar que suma de montos modificados no sea mayor a suma de montos modificados.
	function sumar(valor) {
		var cantidadTotalPagado = document.getElementById("cantidadTotalPagado").value;

		var montoModificado = 0.00;

		<cfloop query = "rsSociosD">
			var value = document.getElementById("lblpagado_#rsSociosD.idMC#").value;
			value = parseFloat(value);
			montoModificado = montoModificado + value;
		</cfloop>

		var totalPagado = document.getElementById("totalPagado").value;
		totalPagado = parseFloat(totalPagado).toFixed(2);
		montoModificado = parseFloat(montoModificado).toFixed(2);

    	if(montoModificado != totalPagado){
			document.getElementById('rsSuma').style.color="##FF0000";
			document.getElementById('rsSuma').innerHTML = montoModificado ;
			//desabilita boton modificar
			 document.formR.Cambio.disabled=true;
			 document.formR.Cambio.title="Monto modificado incorrecto";
		}else {
			document.getElementById('rsSuma').style.color="##000000"
			document.getElementById('rsSuma').innerHTML = montoModificado ;
			//habilita boton modificar
			document.formR.Cambio.disabled=false;
			document.formR.Cambio.title="Modificar";
		}

		validacionMontos(valor);		

	}
	//funcion para validar que suma de columna de descuentos modificados no sea mayor a suma de descuentos aplicados.
	function sumarDescuento(valor) {
		var cantidadtotalDesAsignado = document.getElementById("cantidadtotalDesAsignado").value;

		var descuentoModificado = 0.00;

		<cfloop query = "rsSociosD">
			var value = document.getElementById("lblDescAsig_#rsSociosD.idMC#").value;
			value = parseFloat(value);
			descuentoModificado = descuentoModificado + value;
		</cfloop>

		var totalDesAsignado = document.getElementById("totalDesAsignado").value;
		totalDesAsignado = parseFloat(totalDesAsignado).toFixed(2);
		descuentoModificado = parseFloat(descuentoModificado).toFixed(2);

    	if(descuentoModificado != totalDesAsignado){
			document.getElementById('rsSumaD').style.color="##FF0000";
			document.getElementById('rsSumaD').innerHTML = descuentoModificado ;
			//desabilita boton modificar
			 document.formR.Cambio.disabled=true;
			 document.formR.Cambio.title="Descuento modificado incorrecto";
		}else {
			document.getElementById('rsSumaD').style.color="##000000"
			document.getElementById('rsSumaD').innerHTML = descuentoModificado ;
			//habilita boton modificar
			document.formR.Cambio.disabled=false;
			document.formR.Cambio.title="Modificar";
		}
		validacionMontos(valor);		

	}
	//Funcion para validar montos por fila en base a monto a pagar.
	function validacionMontos(valor){

		<cfloop query = "rsSociosD">
			var montomod = document.getElementById('Pagado_#rsSociosD.idMC#').value;
			var descmod = document.getElementById('Descuento_#rsSociosD.idMC#').value;
			var suma = Number(montomod) + Number(descmod);
			var falt = suma -  #rsSociosD.MontoAPagar#;
			faltante = parseFloat(falt).toFixed(2);
			
			if(suma > #rsSociosD.MontoAPagar#){
				document.getElementById('sugerencia_#rsSociosD.idMC#').innerHTML = 'Monto pagado excedido en: ' + faltante;
				document.getElementById('sugerencia_#rsSociosD.idMC#').style.color="##FF0000";

			}else if (suma < #rsSociosD.MontoAPagar#){
				var dif = #rsSociosD.MontoAPagar# - suma;
				diferencia = parseFloat(dif).toFixed(2);
				//document.getElementById('sugerencia_#rsSociosD.idMC#').innerHTML = 'Se sugiere agregar: '+diferencia;
				//document.getElementById('sugerencia_#rsSociosD.idMC#').style.color="##000000";
			}else{
				//document.getElementById('sugerencia_#rsSociosD.idMC#').innerHTML = '';
			}
			//No muestra sugerencias si no hay cambios
			if(#rsSociosD.Pagado# == Number(montomod) && #rsSociosD.Descuento# == Number(descmod)){
				//document.getElementById('sugerencia_#rsSociosD.idMC#').innerHTML = '';
			}
		</cfloop>

	}

</script>
</cfoutput>