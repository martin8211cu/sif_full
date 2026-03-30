<cfquery datasource="#session.dsn#" name="rsMayorista">
	select MRidMayorista
		, MRnombre  
	from ISBmayoristaRed
	order by MRnombre
</cfquery>

<!---busca las transacciones para cargar en combo transacciones--->
<cfquery datasource="#session.dsn#" name="rsTransaccion">
	select distinct(Tranuc)
	from ISBtransaccionDepositos
	Where Sevcod = '09'
	and Trahab = 'S'
	order by Tranuc
</cfquery>

<!---busca las transacciones para cargar en combo transacciones--->
<cfquery datasource="#session.dsn#" name="rsTransaccionCD">
	select distinct(Tranuc)
	from ISBtransaccionDepositos
	Where Sevcod = '52'
	and Trahab = 'S'
	order by Tranuc
</cfquery>

<!---Genera el código de paquete automáticamente--->
<cfquery datasource="#session.dsn#" name="rsCodPaquete">
	SELECT max(convert(int,PQcodigo)) + 1 PQcodigo
	FROM ISBpaquete
</cfquery>

<!---almacena codigo de paquete nuevo--->
<cfset codpaquete = "#rsCodPaquete.PQcodigo#">

<!---da formato de ceros al codigo de paquete generado--->
<cfif Len(codpaquete) lt 4>
	<cfset ceros = RepeatString('0',4-Len(codpaquete))>
<cfelse>
	<cfset ceros = ''>
</cfif>
<cfif Len(ceros)>
	<cfset codpaquete =  '#ceros##codpaquete#'>
</cfif>


<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="PG_caracteresValidos">
	<cfinvokeargument name="Pcodigo" value="223">
</cfinvoke>

<cfset checks = 0>


<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="mostrarpq">
	<cfinvokeargument name="Pcodigo" value="224">
</cfinvoke>

<cfset mostrar_paqinterfaz = false>

<cfif mostrarpq eq "SI">
	<cfset mostrar_paqinterfaz = true>
</cfif>

<cfoutput>
	
	<cfset PG_caracteresValidos = ReplaceList(PG_caracteresValidos,'.,:,\','\\.,\\:,\\')>
	
	<script type="text/javascript">
	<!--
		var ejeOnblur = false;
		var mascaraOK = false;
		/* Elimina los espacios blancos intermedios de un objeto textbox  */
		function validaMascara(u){
			
			if (! (/^[#PG_caracteresValidos#]*$/.test(u))) {
				alert("Los caracteres permitidos para el usuario son: \"#PG_caracteresValidos#\".");
				mascaraOK = false;
			}else{
				mascaraOK = true;
			}
		}	
	
	
		function funcNuevo() {
			location.href = "ISBpaquete.cfm?tab=1";
			return false;
		}
		function validaPorcentaje(val){
			var valor = new Number(qf(val));

			if (valor < 0 || valor > 100 ){
				alert(" El porcentaje debe estar en el rango 0.00 - 100.00");
				return false;
			}
			return true;
		}		
	
		
		function corrigeFormatoNumeros(f){
			f.PQtarifaBasica.value = qf(f.PQtarifaBasica);
			f.PQhorasBasica.value = qf(f.PQhorasBasica);
			f.PQprecioExc.value = qf(f.PQprecioExc);
		}
		
		function validarPaquete(formulario){
			var error_input;
			var error_msg = '';
			// Validando tabla: ISBpaquete - Paquetes
			formulario.PQnombre.value = formulario.PQnombre.value.replace(/\s+/g,'_').toUpperCase();
			// Columna: PQcodigo paquete char(4)
			if (formulario.PQcodigo.value == "") {
				error_msg += "\n - Código de Paquete no puede quedar en blanco.";
				error_input = formulario.PQcodigo;
			}else{
				if(!ESNUMERO(formulario.PQcodigo.value)){
					error_msg += "\n - El código de Paquete debe ser numérico.";
					error_input = formulario.PQcodigo;				
				}
			}
			
		
			// Columna: PQnombre Nombre varchar(80)
			if (formulario.PQnombre.value == "") {
				error_msg += "\n - Nombre no puede quedar en blanco.";
				error_input = formulario.PQnombre;
			}
			// Columna: PQdescripcion Descripción varchar(1024)
			if (formulario.PQdescripcion.value == "") {
				error_msg += "\n - Descripción no puede quedar en blanco.";
				error_input = formulario.PQdescripcion;
			
			}
			// Columna: configuracion inicial
			if (document.all.opt1.style.display == "" && formulario.PQfileconfigura && formulario.PQfileconfigura.value == 'N') {
				error_msg += "\n - Seleccione el archivo de configuración inicial.";
				error_input = formulario.PQfileconfigura;
			}
		
			// Columna: PQcomisionTipo Tipo de comisión char(1)
			if (formulario.PQcomisionTipo.value == "") {
				error_msg += "\n - Tipo de comisión no puede quedar en blanco.";
				error_input = formulario.PQcomisionTipo;
			}
			if (formulario.PQinicio.value == "") {
				error_msg += "\n - La fecha de inicio no puede quedar en blanco.";
				error_input = formulario.PQinicio;
			}
			//if (formulario.PQcierre.value == "") {
			//	error_msg += "\n - La fecha de cese no puede quedar en blanco.";
			//	error_input = formulario.PQcierre;
			//}								
			if (formulario.PQtarifaBasica.value == "") {
				error_msg += "\n - La Tarifa Básica no puede quedar en blanco.";
				error_input = formulario.PQtarifaBasica;
			}
			if (formulario.PQhorasBasica.value == "") {
				error_msg += "\n - Las Horas Básicas no pueden quedar en blanco.";
				error_input = formulario.PQhorasBasica;
			}			
			if (formulario.PQprecioExc.value == "") {
				error_msg += "\n - El Precio Excedente no puede quedar en blanco.";
				error_input = formulario.PQprecioExc;
			}					
			if ((document.all.opt4.style.display == "")&&(formulario.PQmailQuota.value == "")) {
				error_msg += "\n - El tamaño del Correo.";
				error_input = formulario.PQmailQuota;
			}
			if ((document.all.opt4.style.display == "")&&(formulario.PQmailQuota.value == "0")) {
				error_msg += "\n - El tamaño del Correo debe ser mayor a 0";
				error_input = formulario.PQmailQuota;
			}
			
			if (formulario.TRANUC.value == "") {
				error_msg += "\n - La Transacción no puede quedar en blanco.";
				error_input = formulario.TRANUC;
			}
			
			//if (formulario.PQtransaccion.value == "") {
			//	error_msg += "\n - La Transacción de Cobro no puede quedar en blanco.";
			//	error_input = formulario.PQtransaccion;
			//}			
			if (formulario.PQagrupa.value == "") {
				error_msg += "\n - La Agrupación no puede quedar en blanco.";
				error_input = formulario.PQagrupa;
			}
				
			if (document.getElementsByName("chk")[2].checked && document.getElementsByName("chk")[2].value == 'CABM' )
			{
				if (formulario.MRidMayorista.value == '-1')
				{					
					error_msg += "\n - El campo Mayorista de Red debe ser diferente de: --No Aplica--.";
					error_input = formulario.MRidMayorista;			
				}			
			}
			
						
			if (formulario.PQpagodeposito.value == "M" || formulario.PQpagodeposito.value == "N") 
			{
				if (formulario.PQtransaccion.value != "") 
				{
					error_msg += "\n - La Transacción Cobro del depósito no aplica cuando modo de pago es Mensual o No Aplica.";
					error_input = formulario.PQtransaccion;
				}
			}

			if (formulario.PQpagodeposito.value == "F") 
			{
				if (formulario.PQtransaccion.value == "") 
				{
					error_msg += "\n - Debe seleccionar un valor para el campo Transacción de Cobro del depósito.";
					error_input = formulario.PQtransaccion;
				}
			}

			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}else{
				if(!checkServicios())
					return false;
			}
			
			if (!ejeOnblur){
			
				validaMascara(formulario.PQnombre.value);
				if(!mascaraOK)
					return false;				
			}else{
				if(!mascaraOK){
					ejeOnblur = false;
					return false;				
				}
			}
			
			// Columna: PQtoleranciaGarantia Tolerancia de Garantía - numerico
			if (formulario.PQtoleranciaGarantia.value != "") {
				if(!validaPorcentaje(formulario.PQtoleranciaGarantia.value)){
					formulario.PQtoleranciaGarantia.focus();
					return false;
				}
			}
			
			//Solo valida si el tipo de comision es = a 1
			if(formulario.PQcomisionTipo.value == 1){
				// Columna: PQcomisionPctj Porcentaje de Comision - numerico
				if (formulario.PQcomisionPctj.value != "") {
					if(!validaPorcentaje(formulario.PQcomisionPctj.value)){
						formulario.PQcomisionPctj.focus();
						return false;
					}
				}			
			}	
			// Revisa que la fecha inicial no sea mayor que la fecha final
			if(formulario.PQinicio.value != '' && formulario.PQcierre.value != ''){
				if (!rangoFechas(formulario.PQinicio.value,formulario.PQcierre.value))
					return false;			
			}

			corrigeFormatoNumeros(formulario);
			return true;
		}
		function addZeros(obj){
			var v = obj.value;
			switch (v.length){
				case 0: obj.value = "0000";break;
				case 1: obj.value = "000"+obj.value; break;
				case 2: obj.value = "00"+obj.value; break;
				case 3: obj.value = "0"+obj.value; break;
			}
		}
	//-->
	</script>
	<form action="ISBpaquete-apply.cfm" onsubmit="return validarPaquete(this);" enctype="multipart/form-data" method="post" name="form1" id="form1" style="margin:0">
		<cfinclude template="ISBpaquete-hiddens.cfm">
		<cfset tsS="">
		<cfif isdefined("data.ts_rversion") and len(data.ts_rversion)>
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="tsS">
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversionS" value="#tsS#">
		<table  width="100%"border="0" cellpadding="2" cellspacing="0">
			<tr>
				<td colspan="6">
					<span style="width:100%">
						<cfinclude template="ISBservicio-form.cfm">
					</span>
				</td>
			</tr>
			<tr>
				<td colspan="6">
					<span style="width:100%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" height="30px">
							<tr>
								<td width="1%"><hr /></td>
								<td nowrap="nowrap">&nbsp;<font style="font-weight:bold">Datos Comerciales</font>&nbsp;</td>
								<td width="99%"><hr /></td>
							</tr>
						</table>
					</span>
				</td>
			</tr>
			<tr>
				<td align="right"><label>C&oacute;digo</label></td><td>									
						
						<cfif isdefined('form.PQcodigo') and form.PQcodigo NEQ ''>
							<input name="PQcodigo"  id="PQcodigo" 
								type="text" 
								value="#HTMLEditFormat(data.PQcodigo)#" 
								maxlength="4"
							 	size="6"
								onfocus="this.select()" 
								style="border:solid 1px ##CCCCCC; background:inherit;text-align: right;"
								readonly="true"
							>	
						<cfelse>
							<input name="PQcodigo"  id="PQcodigo" 
								type="text" 
								value="#codpaquete#" 
								maxlength="4"
							 	size="6"
								onfocus="this.select()" 
								style="border:solid 1px ##CCCCCC; background:inherit;text-align: right;"
								readonly="true"
							>	
						
							<!---							
								<cf_inputNumber 
								name="PQcodigo"
								codigoNumerico = "true"
								enteros="4"
								<!---value="#HTMLEditFormat(data.PQcodigo)#"--->
								value="#codpaquete#"
								onBlur="addZeros(this)"
								>
							--->
						</cfif>
				</td>
				
				<td align="right"><label>Nombre</label>				</td><td colspan="3">
					<input name="PQnombre" type="text" id="PQnombre"  
						onfocus="this.select()" value="#HTMLEditFormat(data.PQnombre)#"
						maxlength="80" style="width:100%"
						onblur="this.value = this.value.toUpperCase();ejeOnblur=true;validaMascara(this.value);">
				</td>
		    </tr>
			<tr>
				<td align="right"><label>Descripci&oacute;n</label></td>
				<td colspan="5"><input name="PQdescripcion" type="text" id="PQdescripcion" 
						onFocus="this.select()" value="#HTMLEditFormat(data.PQdescripcion)#"  
						maxlength="1024" style="width:100%"></td>
			</tr>			
			<tr>
				
				<td align="right"><label>Inicio</label>				</td><td>
					<cf_sifcalendario form="form1" name="PQinicio" value="#DateFormat(data.PQinicio,'dd/mm/yyyy')#" >
				</td>

				<td align="right"><label>Cese</label>				</td><td>
					<cf_sifcalendario form="form1" name="PQcierre" value="#DateFormat(data.PQcierre,'dd/mm/yyyy')#" >
				</td>

				<td align="right"><label>Mayorista de Red</label>				</td><td>
                  <select name="MRidMayorista" id="MRidMayorista" >
						<option value="-1" <cfif data.MRidMayorista EQ ''> selected</cfif>>-- No Aplica --</option>
						<cfloop query="rsMayorista">
							<option value="#rsMayorista.MRidMayorista#" <cfif data.MRidMayorista EQ rsMayorista.MRidMayorista>selected</cfif>>#MRnombre#</option>
						</cfloop>
                  </select>
</td>
			</tr><tr>
				
				<td align="right"><label>Tarifa b&aacute;sica</label>				</td><td>
					<cf_inputNumber 
						readonly="false" 
						name="PQtarifaBasica" 
						decimales="2" 
						enteros="4" 
						value="#HTMLEditFormat(data.PQtarifaBasica)#" 
						comas="false">
				</td>
				
				<td align="right"><label>Horas b&aacute;sicas</label>				</td><td>
					<cf_inputNumber 
						readonly="false" 
						name="PQhorasBasica" 
						decimales="2" 
						enteros=4
						value="#HTMLEditFormat(data.PQhorasBasica)#"
						comas="false"
						>	
				</td>

				<td align="right"><label>Precio excedente</label>				</td><td>
					<cf_inputNumber 
						readonly="false" 
						name="PQprecioExc" 
						decimales="2" 
						enteros="5"
						value="#HTMLEditFormat(data.PQprecioExc)#" 
						comas="false"
						>	
				</td>

			</tr><tr>
				
				<td align="right"><label>Moneda</label>				</td><td>
					<cf_moneda
						id = "#HTMLEditFormat(data.Miso4217)#"
						sufijo = ""
						form = "form1"
					>
				</td>
				
				<td align="right" nowrap><label>% Tolerancia garant&iacute;a</label>				</td><td>
					<cf_inputNumber 
						readonly="false" 
						name="PQtoleranciaGarantia" 
						decimales="2" 
						enteros="3"
						value="#HTMLEditFormat(data.PQtoleranciaGarantia)#" 
						comas="false"
						>						
				</td>
				
				<td align="right"><cfif Not data.Recordcount is 0><label for="CINCAT">Codigo SIIC</label></cfif></td>
				<td>
					<cfif Not data.Recordcount is 0>
					<cf_campoNumerico 
						readonly="true" 
						name="CINCAT" 
						decimales="0" 
						size="10" 
						maxlength="5" 
						value="#HTMLEditFormat(data.CINCAT)#" 
						>
					</cfif>
				</td>
			</tr><tr>
				<td align="right"><label>Tipo de Comisi&oacute;n</label>				</td><td>
				
					<select name="PQcomisionTipo" id="PQcomisionTipo" onchange="javascript:muestraTipoComision();">
					
						<option value="0" <cfif data.PQcomisionTipo is '0'>selected</cfif> >
							No comisiona						</option>
					
						<option value="1" <cfif data.PQcomisionTipo is '1'>selected</cfif> >
							Porcentual						</option>
					
						<option value="2" <cfif data.PQcomisionTipo is '2'>selected</cfif> >
							Monto fijo						</option>
					
						<option value="3" <cfif data.PQcomisionTipo is '3'>selected</cfif> >
							Primer pago						</option>
					</select>
				</td>
				<td align="right"><label>Modo pago depósito</label>				</td><td>
				
					<select name="PQpagodeposito" id="PQpagodeposito" onchange="javascript: ActualizaCombCD();">
					
						<option value="F" <cfif data.PQpagodeposito eq 'F'>selected</cfif> >
							Fijo							</option>
					
						<option value="M" <cfif data.PQpagodeposito eq 'M'>selected</cfif> >
							Mensual						</option>

						<option value="N" <cfif data.PQpagodeposito eq 'N'>selected</cfif> >
													No Aplica							</option>					
					</select>
				</td>
	
				<td align="right"><div id="porComision1"><label>% Comisi&oacute;n</label></div>
				<div id="mto1"><label>Monto comisi&oacute;n</label></div></td>
				<td align="left"><div id="porComision2">
					<cf_inputNumber 
						readonly="false" 
						name="PQcomisionPctj" 
						decimales="2" 
						enteros="3"
						value="#HTMLEditFormat(data.PQcomisionPctj)#" 
						comas="false"
						></div><div id="mto2">
					<cf_inputNumber 
						readonly="false" 
						name="PQcomisionMnto" 
						decimales="2" 
						enteros="5"
						value="#HTMLEditFormat(data.PQcomisionMnto)#" 
						comas="false"
						></div>				</td>
				<td align="right">
				<cfif Len(data.PQmaxSession)><!--- SOLO PARA VPN y en cambio, el alta viene por interfaz --->
				<label for="PQmaxSession">Máx. sesiones</label></cfif></td>
				<td nowrap><cfif Len(data.PQmaxSession)>
					<cf_campoNumerico 
						readonly="false" 
						name="PQmaxSession" 
						decimales="0" 
						size="10" 
						maxlength="4" 
						value="#HTMLEditFormat(data.PQmaxSession)#" 
						></cfif></td>
	
			</tr>
			<tr>
				<td align="right"><label>Agrupaci&oacute;n</label>				</td>
				<td>
					<select name="PQagrupa" id="PQagrupa" >
						<option value="0" <cfif data.PQagrupa is '0'>selected</cfif>>Deshabilitado</option>
						<option value="1" <cfif data.PQagrupa is '1'>selected</cfif>>Solo Interno</option>
						<option value="2" <cfif data.PQagrupa is '2'>selected</cfif>>Interno/Externo</option>
						<option value="3" <cfif data.PQagrupa is '3'>selected</cfif>>Grupo VPN</option>
						<option value="4" <cfif data.PQagrupa is '4'>selected</cfif>>Ready</option>
						<option value="5" <cfif data.PQagrupa is '5'>selected</cfif>>Grupo Hogar</option>						
						<option value="6" <cfif data.PQagrupa is '6'>selected</cfif>>Plana, Alterno</option>						
						<option value="7" <cfif data.PQagrupa is '7'>selected</cfif>>Solo Interno, no cobrable</option>						
						<option value="8" <cfif data.PQagrupa is '8'>selected</cfif>>Solo Externo</option>						
						<option value="9" <cfif data.PQagrupa is '9'>selected</cfif>>Grupo Cabletica</option>						
						<option value="10" <cfif data.PQagrupa is '10'>selected</cfif>>Centros Empresariales</option>						
						<option value="11" <cfif data.PQagrupa is '11'>selected</cfif>>Grupo Amnet</option>						
						<option value="12" <cfif data.PQagrupa is '12'>selected</cfif>>Grupo Otros</option>						
						<option value="13" <cfif data.PQagrupa is '13'>selected</cfif>>Grupo Cuentas de Servicio</option>						
						<option value="14" <cfif data.PQagrupa is '14'>selected</cfif>>Grupo Consumo Comunitario</option>						
						<option value="15" <cfif data.PQagrupa is '15'>selected</cfif>>Grupo Correos</option>						
						<option value="16" <cfif data.PQagrupa is '16'>selected</cfif>>Grupo Conmutados</option>						
					</select>				</td>				
				<td align="right"><label for="TRANUC">Transacci&oacute;n</label></td>
				<td align="left">
                  <select name="TRANUC" id="TRANUC" >
						<cfloop query="rsTransaccion">
							<cfif "#rsTransaccion.Tranuc#" eq "#HTMLEditFormat(data.TRANUC)#">
								<option value="#rsTransaccion.Tranuc#"  selected="selected">#rsTransaccion.Tranuc#</option>
							<cfelse>
								<option value="#rsTransaccion.Tranuc#" >#rsTransaccion.Tranuc#</option>
							</cfif>
						</cfloop>
                  </select>				
				
<!---					<input name="TRANUC" 
						id="TRANUC" 
						type="text" 
						value="#HTMLEditFormat(data.TRANUC)#" 
						maxlength="4" 
					 	size="5"
						onfocus="this.select()" 
						>
--->						
				</td>
				<td align="right"><label for="PQtransaccion">Transacci&oacute;n de cobro del dep&oacute;sito</label></td>
				<td>
                  <select name="PQtransaccion" id="PQtransaccion" >
				  		<option value="" > </option>
						<cfloop query="rsTransaccionCD">
							<cfif "#rsTransaccionCD.Tranuc#" eq "#HTMLEditFormat(data.PQtransaccion)#">
								<option value="#rsTransaccionCD.Tranuc#"  selected="selected">#rsTransaccionCD.Tranuc#</option>
							<cfelse>
								<option value="#rsTransaccionCD.Tranuc#" >#rsTransaccionCD.Tranuc#</option>
							</cfif>
						</cfloop>
                  </select>								
				
<!---					<input name="PQtransaccion" 
						id="PQtransaccion" 
						type="text" 
						value="#HTMLEditFormat(data.PQtransaccion)#" 
						maxlength="4" 
					 	size="5"
						onfocus="this.select()" 
						>				--->
				</td>
			</tr>			
			<tr>
				<td align="right">
						<input name="PQutilizadoagente" id="PQutilizadoagente" type="checkbox" value="1" <cfif Len(data.PQutilizadoagente) And data.PQutilizadoagente eq 1> checked</cfif> >
				</td>
				<td><label for="Habilitado">Utilizado para Agente</label></td>
				
				<td align="right">
					<input name="PQcompromiso" id="PQcompromiso" type="checkbox" value="1" <cfif Len(data.PQcompromiso) And data.PQcompromiso> checked</cfif> >				</td>
				<td><label for="PQcompromiso">Compromiso</label></td>
				
				<td align="right"><input name="PQadelanto" id="PQadelanto" type="checkbox" value="1" <cfif Len(data.PQadelanto) And data.PQadelanto EQ 'S'> checked</cfif> ></td>
				<td><label for="PQadelantado">Pago Adelantado</label></td>
				
			</tr><tr>	
				<td align="right">
					<input name="PQinterfaz" id="PQinterfaz" type="checkbox" <cfif mostrar_paqinterfaz>style="visibility:visible"<cfelse>style="visibility:hidden"</cfif> value="1" <cfif Len(data.PQinterfaz) And data.PQinterfaz> checked</cfif> >				</td>
				<td><label for="PQinterfaz" <cfif mostrar_paqinterfaz>style="visibility:visible"<cfelse>style="visibility:hidden"</cfif>>Interno para interfaz</label></td>
					
				<td align="right">
					<input name="PQautogestion" id="PQautogestion" type="checkbox" value="1" <cfif Len(data.PQautogestion) And data.PQautogestion> checked</cfif> >
				</td>
				<td nowrap><label for="Permite_Autogesti">Permite Autogesti&oacute;n</label></td>
				<td align="right">
					<input 
						name="Habilitado" 
						id="Habilitado" 
						type="checkbox" 
						value="1" 
						<cfif isdefined('form.PQcodigo') and form.PQcodigo NEQ ''>
							<cfif Len(data.Habilitado) And data.Habilitado> checked</cfif> 
						<cfelse>
							checked
						</cfif>
						>				</td>
				<td><label for="Habilitado">Habilitado</label></td>
			</tr>
			<tr>
				<td colspan="6">
					<span style="width:100%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" height="30px">
							<tr>
								<td width="1%"><hr /></td>
								<td nowrap="nowrap">&nbsp;<font style="font-weight:bold">Datos Técnicos</font>&nbsp;</td>
								<td width="99%"><hr /></td>
							</tr>
						</table>
					</span>
				</td>
			</tr>
			<tr>
				<td colspan="6">
					<span style="width:100%;">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" height="30px">
							<tr>
								<td nowrap="nowrap" width="40%">
									<div id="opt1" name="opt1" style="display:none">
									<cfif Len(data.PQcodigo) Is 0>
										<label>Archivo de configuración inicial: &nbsp;</label>
									  <select name="PQfileconfigura">
										<option value="N">-Seleccione-</option>
										<option value="T">TACACS</option>
										<option value="R">RADIUS</option>
										<option value="A">TACACS y RADIUS</option>
										<option value="N">Ninguno</option>
									  </select>
									</cfif>
									</div>
								</td>
								<td nowrap="nowrap" width="20%">
									<span id="opt2" name="opt2" style="display:none">
										<input name="PQtelefono" id="PQtelefono" type="checkbox" value="1" <cfif Len(data.PQtelefono) And data.PQtelefono> checked</cfif> ><label for="PQtelefono">Requiere tel&eacute;fono</label>
									</span>
								</td>								
								<td nowrap="nowrap" width="20%">
									<span id="opt3" name="opt3" style="display:none">
										<input name="PQroaming" id="PQroaming" type="checkbox" value="1" <cfif Len(data.PQroaming) And data.PQroaming> checked</cfif> ><label for="PQroaming">Permite roaming</label>
									</span>
								</td>
								<td nowrap="nowrap" width="20%">
									<span id="opt4" name="opt4" style="display:none">
										<label>Tamaño del Correo</label>
										<cf_campoNumerico 
											readonly="false" 
											name="PQmailQuota" 
											decimales="-1" 
											size="10" 
											maxlength="8" 
											value="#HTMLEditFormat(data.PQmailQuota)#" 
											>KB
									</span>
								</td>
							</tr>
						</table>
					</span>
					<span style="width:100%; height:20px;text-align:center;">
						<input id="msg_nochecks" name="msg_nochecks" type="text" style="background-color:transparent;
																						font-size:xx-small; 
																						font-family:Verdana, Arial; 
																						color:##993333; 
																						border:none; 
																						width:350px; 
																						text-align:center;
																						font-weight:bold;
											<cfif checks gt 0>visibility:hidden;<cfelse>visibility:visible</cfif>" 
						value="No hay servicios seleccionados">
					</span>					
				</td>
			</tr>
			<tr>	
				<td colspan="8" class="formButtons">
					<cfif data.RecordCount>
						<cf_botones modo="CAMBIO" Include="Lista" >
					<cfelse>
						<cf_botones modo="ALTA" Include="Lista" >
					</cfif>
				</td>
			</tr>
		</table>
	</form>
	<script language="javascript" type="text/javascript">
		function evaluaChecks(v,obj){
			var i=0;
			var j=0;
			var k = 0;
			var l = 0;
			
			
			if(document.getElementById("form1").msg_nochecks.style.visibility == "visible"){
				document.getElementById("form1").msg_nochecks.style.visibility = "hidden";
			}else{
				<cfif rsDatos.recordCount>
					<cfloop query="rsDatos">
						if(document.getElementsByName("chk")[i].checked){
							j+=1;
							<cfif rsDatos.TStipo eq "A">
								k+=1;
							</cfif>
							<cfif rsDatos.TStipo eq "C">
								l+=1;
							</cfif>
						}
						
						i+=1;
					</cfloop>
				</cfif>
				if(j==0){
					document.getElementById("form1").msg_nochecks.style.visibility = "visible";
					
				}
				if(k==0){
					document.all.opt1.style.visibility = "hidden";
					document.all.opt2.style.visibility = "hidden";
					document.all.opt3.style.visibility = "hidden";
					document.all.opt1.style.display = "none";
					document.all.opt2.style.display = "none";
					document.all.opt3.style.display = "none";
					
					document.all.PQroaming.checked = true;
					document.all.PQfileconfigura.selectedIndex = 0;
				}
				if(l==0){
					document.all.opt4.style.visibility = "hidden";
					document.all.opt4.style.display = "none";
				}
			}
			
			if((v == "A")&&(obj.checked)){
				document.all.opt1.style.display = "";
				document.all.opt2.style.display = "";
				document.all.opt3.style.display = "";
				document.all.opt1.style.visibility = "visible";
				document.all.opt2.style.visibility = "visible";
				document.all.opt3.style.visibility = "visible";
				
				i=0;
				j=0;
				<cfif rsDatos.recordCount>
					<cfloop query="rsDatos">
						if(document.getElementsByName("chk")[i].checked){
							<cfif rsDatos.TStipo eq "A">
								j+=1;
							</cfif>
						}
						i+=1;
					</cfloop>
				</cfif>
				/*if(j>1){
					alert("No se permite seleccionar más de un tipo servicio de acceso");
					obj.checked = false;
				}*/
				
			}
			else if((v == "C")&&(obj.checked)){
				document.all.opt4.style.display = "";
				document.all.opt4.style.visibility = "visible";
				i=0;
				j=0;
				<cfif rsDatos.recordCount>
					<cfloop query="rsDatos">
						if(document.getElementsByName("chk")[i].checked){
							<cfif rsDatos.TStipo eq "C">
								j+=1;
							</cfif>
						}
						i+=1;
					</cfloop>
				</cfif>
				if(j>1){
					alert("No se permite seleccionar más de un tipo servicio de correo");
					obj.checked = false;
				}
			}
			

		}
		function load_datos_tecnicos(){
			var i=0;
			var j=0;
			var k = 0;
			
			<cfif rsDatos.recordCount>
				<cfloop query="rsDatos">
					if(document.getElementsByName("chk")[i].checked){
						<cfif rsDatos.TStipo eq "A">
							j+=1;
						</cfif>
						<cfif rsDatos.TStipo eq "C">
							k+=1;
						</cfif>
					}
					
					i+=1;
				</cfloop>
			</cfif>
				if(j>0){
					document.all.opt1.style.visibility = "visible";
					document.all.opt2.style.visibility = "visible";
					document.all.opt3.style.visibility = "visible";
					document.all.opt1.style.display = "";
					document.all.opt2.style.display = "";
					document.all.opt3.style.display = "";
				}
				if(k>0){
					document.all.opt4.style.visibility = "visible";
					document.all.opt4.style.display = "";
				}
		}
		
	<!--	
		function muestraTipoComision(){
			if(document.form1.PQcomisionTipo.value == 1){
				document.getElementById("mto1").style.display='none';
				document.getElementById("mto2").style.display='none';	
				document.getElementById("porComision1").style.display='';
				document.getElementById("porComision2").style.display='';
			}
			else{ 
				if(document.form1.PQcomisionTipo.value == 2){
					document.getElementById("mto1").style.display='';
					document.getElementById("mto2").style.display='';
					document.getElementById("porComision1").style.display='none';
					document.getElementById("porComision2").style.display='none';
				}
				else{
					document.getElementById("mto1").style.display='none';
					document.getElementById("mto2").style.display='none';
					document.getElementById("porComision1").style.display='none';
					document.getElementById("porComision2").style.display='none';
					}
			}
		}

		function ActualizaCombCD()
		{
			if(document.form1.PQpagodeposito.value == 'M' || document.form1.PQpagodeposito.value == 'N')
			{
				document.form1.PQtransaccion.value = "";
			}
		}	
			
		muestraTipoComision();
		//-->
		
		load_datos_tecnicos();
		
	</script>

</cfoutput>

