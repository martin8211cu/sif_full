
<!---Valida que el cliente no poseea cuentas inconsistentes--->
<cfinvoke component="saci.comp.ISBcuenta" method="PermiteVenta" returnvariable="PermiteCuenta">
	<cfinvokeargument name="Pquien" value="#Form.Pquien#">
</cfinvoke>
<style type="text/css">
<!--
.style1 {
	color: #B7005B;
	font-weight: bold;
}
-->
</style>



<cfif isdefined('form.CTid') and form.CTid NEQ ''>
	<cfquery name="rsDetCuenta" datasource="#session.dsn#">
		select Habilitado
		from ISBcuenta
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
	</cfquery>
</cfif>

<cfset PermitePrint = false>
<cfif isdefined('form.CTid') and form.CTid NEQ ''>
	<cfquery name="rsPermiteImpresion" datasource="#session.dsn#">
		select count(1) as x
			from ISBproducto a, ISBcuenta b
		where a.CTid = b.CTid
		  and b.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
		  and a.CTcondicion != 'C'
	</cfquery>
	<cfif rsPermiteImpresion.x gt 0>
		<cfset PermitePrint = true>
	</cfif>	
</cfif>


<cfif not PermiteCuenta.valida>
	<cfoutput>
	<div style="height: 300">
	<form name="form1" method="post" style="margin: 0;" action="#CurrentPage#">
		<input type="hidden" name="AgPaquete" value="#session.saci.vendedor.agentes#" />
		<input type="hidden" name="Pquien" value="<cfif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#<cfelseif isdefined("form.pq") and Len(Trim(form.pq))>#form.pq#</cfif>" />
		<cfinclude template="venta-hiddens.cfm">
		<p align="center"><strong>No se puede vender m&aacute;s servicios al cliente #rsDatosPersona.NombreCompleto# debido a que la cédula posee cuenta(s) en estado (#PermiteCuenta.nombre#).</strong></p>
	</form>
	</div>
	</cfoutput>
	
<cfelse>
	
	<cfset ProductosEnCaptura = true>
	
	<cfquery name="pq" datasource="#Session.DSN#">
	select PQcodigo from ISBpaquete
	</cfquery>

	<cfinvoke component="saci.ws.intf.base" method="servpaq" returnvariable="maxlogines">
	</cfinvoke>
	
	<cfquery name="maxServicios" datasource="#Session.DSN#">
		select max(cant) as cantidad
		from (
			select coalesce(sum(SVcantidad), 0) as cant
			from ISBservicio
			where Habilitado = 1
			group by PQcodigo
		) temporal
	</cfquery>
	
	<cfset maxServicios.cantidad = maxlogines>
	
	<cfquery name="rsServiciosDisponibles" datasource="#Session.DSN#">
		select TScodigo
		from ISBservicioTipo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by TScodigo
	</cfquery>
	
	<cfquery datasource="#session.dsn#" name="rsDivPolitica">
		select max(DPnivel) as nivel 
		from DivisionPolitica
		where Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.saci.pais#">
	</cfquery>	
	
	<cfif isdefined("Form.CTid") and Len(Trim(Form.CTid))>
	
		<cfquery name="tipoCuenta" datasource="#Session.DSN#">
			select a.CUECUE, a.CTtipoUso, a.Habilitado
			from ISBcuenta a
			where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
		</cfquery>			
		<cfif Form.paso EQ '1'>
			<cfquery name="rsAllContratos" datasource="#session.DSN#">
				select a.Contratoid, a.CNsuscriptor, a.CNnumero, a.CTcondicion,
					   b.PQcodigo, b.Miso4217, b.MRidMayorista, b.PQnombre, b.PQcomisionTipo, b.PQcomisionPctj, b.PQcomisionMnto, b.PQtoleranciaGarantia, b.PQtarifaBasica, b.PQcompromiso, b.PQhorasBasica, b.PQprecioExc, b.PQroaming, b.PQmailQuota, b.PQtelefono, b.PQinterfaz,
					   (select sum(SVcantidad) from ISBservicio x where x.PQcodigo = b.PQcodigo and x.TScodigo = 'MAIL' and x.Habilitado = 1) as CantidadCorreos
					   <cfloop query="rsServiciosDisponibles">
					   , coalesce((select sum(x.SVcantidad) from ISBservicio x where x.PQcodigo = a.PQcodigo and x.TScodigo = '#Trim(rsServiciosDisponibles.TScodigo)#' and x.Habilitado = 1), 0) as Cantidad_#Trim(rsServiciosDisponibles.TScodigo)#
					   </cfloop>
				from ISBproducto a
					inner join ISBpaquete b
						on b.PQcodigo = a.PQcodigo
					inner join ISBcuenta c
						on c.CTid = a.CTid
						and c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pquien#">
				where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
				and a.CTcondicion = 'C'
				order by a.Contratoid
			</cfquery>
		</cfif>

		<cfif Form.paso EQ '7' or Form.paso EQ '4'>
			<cfquery datasource="#Session.DSN#" name="rsProducs">
				select a.Contratoid, b.PQcodigo, b.PQnombre 
				from ISBproducto a
					inner join ISBpaquete b
						on b.PQcodigo = a.PQcodigo
						and b.Habilitado=1
				where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
				and CTcondicion = 'C'
			</cfquery>
			
			<cfif rsProducs.recordCount EQ 0>
				<cfset ProductosEnCaptura = false>
			</cfif>
			
		</cfif>
		
		<cfif Form.paso EQ '1'>
			<cfquery name="productosNoAplicados" datasource="#Session.DSN#">
				select count(1) as cantidad
				from ISBproducto
				where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
					and CTcondicion = 'C'
			</cfquery>
		</cfif>

		<cfif Form.paso EQ '5' or Form.paso EQ '6' or Form.paso EQ '7'>
			<cfquery name="productosCapturados" datasource="#Session.DSN#">
				select count(1) as cantidad
				from ISBproducto a
				where a.CTcondicion = 'C'
				and a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
			</cfquery>
		</cfif>
		
		
	</cfif>
	

	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td valign="top" style="padding-right: 5px;">
				<form name="form1" method="post" style="margin: 0;" action="venta-contrato-apply.cfm" onsubmit="javascript: return validar(this);">
					<input type="hidden" name="AgPaquete" value="#session.saci.vendedor.agentes#" />
					<input type="hidden" name="submitMenu" value="0"/>
					<input type="hidden" name="Pquien" value="<cfif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#<cfelseif isdefined("form.pq") and Len(Trim(form.pq))>#form.pq#</cfif>" />
					<input type="hidden" name="cuentaActiva" value="0"/>

					<cfinclude template="venta-hiddens.cfm">
					<table width="100%" border="0" cellspacing="0" cellpadding="2">
					<cfif ExistePersona>
					  <tr>
						<td align="center" class="menuhead">
							#rsDatosPersona.Pid#&nbsp;&nbsp;#rsDatosPersona.NombreCompleto#
						</td>
					  </tr>
					</cfif>
					<cfif ExisteCuenta and form.paso neq 0>
					  <tr>
						<td align="center" class="menuhead">
							<cfif tipoCuenta.CTtipoUso EQ 'U'>Cuenta <cfif tipoCuenta.CUECUE GT 0>#tipoCuenta.CUECUE#<cfelse>&lt;Por Asignar&gt;</cfif><cfelseif tipoCuenta.CTtipoUso EQ 'A'>Cuenta de Acceso<cfelseif tipoCuenta.CTtipoUso EQ 'F'>Cuenta de Facturaci&oacute;n</cfif>
						</td>
					  </tr>
					   <tr><td><hr/></td></tr>
					</cfif>
					  <tr>
						<td>
							<cfset mens = "">
							<cfset vista = 1>
							<cfif isdefined("url.Activado") and url.Activado EQ 1 >
								<cfset mens = 1>
							</cfif>

							<cfif isdefined('tipoCuenta') and tipoCuenta.CUECUE eq 0 and tipoCuenta.Habilitado eq 1>
								<cfset vista = 2>
							</cfif>
							
							<cf_cuenta 
								id = "#Form.CTid#"
								idpersona = "#Form.Pquien#"
								filtroAgente = "AgPaquete"
								form = "form1"
								Ecodigo = "#Session.Ecodigo#"
								Conexion = "#Session.DSN#"
								paso = "#Form.paso#"
								mens = "#mens#"
								RefId = "#Form.Pquien#"
								Ltipo = "P"
								vista = "#vista#"
							>
						</td>
					  </tr>
					  <cfif Form.paso EQ '7'>
							<tr>
								<td>
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									  <tr>
										<td align="right"><label>Log&iacute;n Principal:</label></td>
										<td><input name="f_loginPrinc" type="text" value="<cfif isdefined('form.f_loginPrinc') and form.f_loginPrinc NEQ ''>#form.f_loginPrinc#</cfif>"></td>
									  </tr>
									  <tr>
										<td colspan="2">&nbsp;</td>
									  </tr>									  
									</table>
								</td>
							</tr>					  
					  </cfif>

					  <tr>
						<td align="center">
							<cfset botones = "">
							<cfset valoresbotones = "">
							<cfset hayBotones = true>
							
							
							<cfif Form.paso EQ '7'>
								<cfset botones = botones & Iif(Len(Trim(botones)), DE(","), DE("")) & "Reimprimir">
								<cfset valoresbotones = valoresbotones & Iif(Len(Trim(valoresbotones)), DE(","), DE("")) & "Reimprimir">
							</cfif>
							
							<cfif Form.paso EQ '5' or Form.paso EQ '6'>
								<cfif isdefined("tipoCuenta") and tipoCuenta.CTtipoUso NEQ 'A' and tipoCuenta.CTtipoUso NEQ 'F' and isdefined("productosCapturados") and productosCapturados.cantidad GT 0>
									<!---<cfset botones = botones & Iif(Len(Trim(botones)), DE(","), DE("")) & "Imprimir,Activar">
									<cfset valoresbotones = valoresbotones & Iif(Len(Trim(valoresbotones)), DE(","), DE("")) & "Imprimir Formulario,Activar Servicio">--->
									<cfset botones = botones & Iif(Len(Trim(botones)), DE(","), DE("")) & "Activar">
									<cfset valoresbotones = valoresbotones & Iif(Len(Trim(valoresbotones)), DE(","), DE("")) & "Activar Servicio">
								</cfif>
							<cfelseif Form.paso neq'7'>
								<cfset botones = botones & Iif(Len(Trim(botones)), DE(","), DE("")) & "Guardar">
								<cfset valoresbotones = valoresbotones & Iif(Len(Trim(valoresbotones)), DE(","), DE("")) & "Guardar">
							</cfif>
							
							<cfif Form.paso NEQ '5' and Form.paso NEQ '6'  and Form.paso NEQ '7'>
								<cfset botones = botones & Iif(Len(Trim(botones)), DE(","), DE("")) & "GuardarContinuar">
								<cfset valoresbotones = valoresbotones & Iif(Len(Trim(valoresbotones)), DE(","), DE("")) & "Guardar y Continuar">
							</cfif>
							<!--- 
								Es posible eliminar cuentas mientras esta no sea una cuenta de acceso o facturación de agente
								y mientras no tenga ningun producto que haya pasado del estado de captura 'C'
							--->
							
							<cfif Form.paso EQ '1' and isdefined("tipoCuenta") and tipoCuenta.CTtipoUso NEQ 'A' and tipoCuenta.CTtipoUso NEQ 'F'
								  and isdefined("productosNoAplicados") and productosNoAplicados.cantidad GT 0>
								<cfset botones = botones & Iif(Len(Trim(botones)), DE(","), DE("")) & "Eliminar">
								<cfset valoresbotones = valoresbotones & Iif(Len(Trim(valoresbotones)), DE(","), DE("")) & "Eliminar">
							</cfif>
							<cfif (Form.paso EQ '2' or Form.paso EQ '3')>
								<cfif isdefined('rsDetCuenta') and (rsDetCuenta.Habilitado EQ '0' or rsDetCuenta.Habilitado EQ '3')>
									<cfif ProductosEnCaptura> 
										<cf_botones names="#botones#" values="#valoresbotones#" tabindex="1">
									</cfif>								
								<cfelse>
									<cfif isdefined('form.CTid') and form.CTid NEQ ''>
										<cfset hayBotones = false>
										<p>&nbsp;</p>
										<p class="style1">La cuenta esta Activa. No se permite su modificaci&oacute;n. </p>									
									<cfelse>
										<cfif ProductosEnCaptura> <!--- Cuenta nueva --->
											<cf_botones names="#botones#" values="#valoresbotones#" tabindex="1">
										</cfif>										
									</cfif>
								</cfif>								
							<cfelse>
								<cfif Form.paso  neq  '0' and ProductosEnCaptura> 
									<cfif Form.paso  eq  '4'> 
										<cfif session.saci.depositoGaranOK>  
											<cf_botones names="#botones#" values="#valoresbotones#" tabindex="1">
										<cfelse>
											<cfset hayBotones = false>
										</cfif>
									<cfelse>
										<cf_botones names="#botones#" values="#valoresbotones#" tabindex="1">
									</cfif>										
								<cfelseif Form.paso  eq  '7'> 
									<cf_botones names="#botones#" values="#valoresbotones#" tabindex="1">
								</cfif>										
							</cfif>
						</td>
					  </tr>
					</table>
				</form>
			</td>
			<td valign="top" width="210">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td style="padding-top: 5px;">
						<cfinclude template="venta-contrato-menu.cfm">
					</td>
				  </tr>
				  <tr>
					<td style="padding-top: 5px;">
						<cf_leyendaServicios>
					</td>
				  </tr>
				</table>
			</td>
		  </tr>
		</table>					
		<script type="text/javascript">
		<!--
			var cuentaAct = false;			
			//Se verifica si la cuenta ya ha sido activada
			<cfif isdefined('rsDetCuenta') and rsDetCuenta.Habilitado EQ 1>
				document.form1.cuentaActiva.value = 1;
				cuentaAct = true;
			</cfif>		
			function funcGuardar(){
				<cfif isdefined('tipoCuenta') and tipoCuenta.CUECUE GT 0>
					return true;
				<cfelse>
					<cfif isdefined('form.CTid') and form.CTid NEQ '' and (isdefined('form.paso') and form.paso EQ 1)>
						if(cuentaAct){
							alert('Error, la cuenta está por asignar, no se permite agregar servicios');
							return false;					
						}else{
							return true;
						}
					<cfelse>
						return true;
					</cfif>				
				</cfif>
			}
			function funcGuardarContinuar(){
				<cfif isdefined('tipoCuenta') and tipoCuenta.CUECUE GT 0>
					return true;
				<cfelse>
					<cfif isdefined('form.CTid') and form.CTid NEQ '' and (isdefined('form.paso') and form.paso EQ 1)>
						if(cuentaAct){
							alert('Error, la cuenta está por asignar, no se permite agregar servicios');
							return false;					
						}else{
							return true;
						}
					<cfelse>
						return true;
					</cfif>	
				</cfif>				
			}
			
			function funcEliminar(){
				if(!confirm('Realmente desea borrar el registro ?.'))
					return false;
				return true;
			}
			<cfif Form.paso EQ '1'>
				//valida el agragar un nuevo producto a la cuenta
				function validar_Paso1(formulario, error_msg) {
					var ninguno = true;
					var sinCheck = true;
					var opciones = new Array(10);
					var logArr = new Array(10);
					var cont = 0;
					
					//Validación de logines correctos
					if (!validarLogines()) {
						error_msg += "\n - Debe validar todos los logines del nuevo producto antes de continuar.";
					}
					
					// validar los datos de localización
					
					if (formulario.Ptelefono1.value == "") {
							error_msg += "\n - Teléfono no puede quedar en blanco.";
							error_input = formulario.Ptelefono1;
					}
					
<!---					if (formulario.CPid.value == "") {
							error_msg += "\n - El Código Postal es requerido.";
							error_input = formulario.CPid;
						}--->


					if (formulario.Pdireccion.value == "") {
							error_msg += "\n - La Dirección Exacta es requerida.";
							error_input = formulario.Pdireccion;
						}


					if (! (/^[A-Za-z0-9ÁÉÍÓÚáéíóúÑñ.\s]*$/.test(formulario.Pdireccion.value))) 
			
						{
							error_msg += "\n - El campo Dirección Exacta tiene caracteres no válidos.";
							error_input = formulario.Pdireccion;
						}

					if (! (/^[A-Za-z0-9ÁÉÍÓÚáéíóúÑñ\s]*$/.test(formulario.Pbarrio.value))) 
			
						{
							error_msg += "\n - El campo Barrio tiene caracteres no válidos.";
							error_input = formulario.Pbarrio;
						}

				
					<cfquery name="rsNiveles" datasource="#session.dsn#">
						select coalesce(min(DPnivel), 0) as minNivel, coalesce(max(DPnivel), 0) as maxNivel
						from DivisionPolitica
						where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.pais#">
					</cfquery>
					<cfset minnivel = rsNiveles.minNivel>
					<cfset maxnivel = rsNiveles.maxNivel>
					<cfoutput><cfloop condition="maxnivel GTE minnivel">
						if (formulario.LCcod_#minnivel#.value == "") {
							error_msg += "\n - " + formulario.LCcod_#minnivel#.alt + " no puede quedar en blanco.";
							error_input = formulario.LCcod_#minnivel#;
						}
					<cfset minnivel = minnivel + 1>
					</cfloop></cfoutput>
	
					var ACCS_CANT = 0;
					var MAIL_CANT = 0;
					var CABM_CANT = 0;
						
					for (var i=1; i<=#maxServicios.cantidad#; i++) { 
						
						var L = eval("document.form1.Login_"+i);
						var S = eval("document.form1.Snumero_"+i);
						if(L != undefined){
							if(L.value != ''){
								ninguno = false;		//valida que al menos se digite un login
								logArr[cont] = L.value;
								cont++;
								
								if(S.value == ''){		//valida que se seleccionen los sobres para cada login digitado
									error_msg += "\n - Debe seleccionar un Sobre para el Login"+i+" del nuevo producto.";
								}
								
								<cfloop query="rsServiciosDisponibles">//valida que al menos se selecione un servicio por login
									if(eval('document.form1.chk_#Trim(rsServiciosDisponibles.TScodigo)#_'+i)!= undefined){
										var C = eval('document.form1.chk_#Trim(rsServiciosDisponibles.TScodigo)#_'+i);
											if(C.checked == true){
												 if (C.value == 'ACCS')
												 	ACCS_CANT += 1; // control de servicios seleccionados tipo ACCS
												 else if (C.value == 'MAIL')
												 	MAIL_CANT += 1;	// control de servicios seleccionados tipo MAIL											 
												 else if (C.value == 'CABM')
													CABM_CANT += 1;
												 sinCheck = false;	
											}
									}
								</cfloop>

								tdTelefono1 = document.getElementById('tdTelefono1_'+i);//validar logines
								if(tdTelefono1.style.display == ''){
									var se =  eval('document.form1.chk_ACCS_'+i);
									var tel = eval("document.form1.LGtelefono_"+i);
									if(tel.value == '' && se.checked){
										error_msg += "\n - Debe digitar un teléfono para el Login"+i+" del nuevo producto.";
									}else{
										if(tel.value.length < 8 && se.checked)
											error_msg = error_msg + '\n - El teléfono del login'+i+ ' es inválido, mínimo son 8 dígitos.';
									}
								}
								
								if(sinCheck)error_msg += "\n - Debe seleccionar al menos un servicio para el Login"+i+" del nuevo producto.";
							}		
						}
					}
					
					var iguales=false;	//validar que no hayan logines iguales
					for(i=0;i<cont;i++){
						for(j=i+1;j<cont;j++){
							if(logArr[i].toUpperCase()  == logArr[j].toUpperCase() ) iguales=true;
						}
					}
					if(iguales)error_msg += "\n - No deben existir logines iguales en el nuevo producto.";
					if(ninguno)error_msg += "\n - Debe digitar al menos un login para el nuevo producto.";
					if (MAIL_CANT > parseInt(document.form1.vCantidad_MAIL1.value))
						error_msg += "\n - Solo se permite seleccionar un máximo de " + document.form1.vCantidad_MAIL1.value + " servicio(s) del tipo MAIL.";
					
					if (!ninguno) {					
						if( document.form1.vCantidadM_ACCS1 != undefined) {					
							if (ACCS_CANT < parseInt(document.form1.vCantidadM_ACCS1.value))
								error_msg += "\n - Debe seleccionar al menos " + document.form1.vCantidadM_ACCS1.value + " servicio(s) del tipo ACCS.";
						}
						
						if( document.form1.vCantidadM_CABM1 != undefined) {					
							if (CABM_CANT < parseInt(document.form1.vCantidadM_CABM1.value))
								error_msg += "\n - Debe seleccionar al menos " + document.form1.vCantidadM_CABM1.value + " servicio(s) del tipo CABM.";
						}
						
						if( document.form1.vCantidadM_MAIL1 != undefined) {					
							if (MAIL_CANT < parseInt(document.form1.vCantidadM_MAIL1.value))
								error_msg += "\n - De seleccionar al menos " + document.form1.vCantidadM_MAIL1.value + " servicio(s) del tipo MAIL.";
						}
					}					
					<cfif isdefined('rsAllContratos')>
						if (document.form1.vCantidad_CABM#rsAllContratos.recordCount + 1# && parseInt(document.form1.vCantidad_CABM#rsAllContratos.recordCount + 1#.value) > 0) {
							if(document.form1.CNsuscriptor#rsAllContratos.recordCount + 1#){
								if(document.form1.CNsuscriptor#rsAllContratos.recordCount + 1#.value == "")
									error_msg += "\n - El nombre del suscriptor del producto nuevo es requerido.";
								
								if (! (/^[A-Za-z0-9ÁÉÍÓÚáéíóúÑñ\s]*$/.test(document.form1.CNsuscriptor#rsAllContratos.recordCount + 1#.value)))
									error_msg += "\n - El nombre del suscriptor tiene caracteres no válidos.";
									
								if(document.form1.CNnumero#rsAllContratos.recordCount + 1#.value == "")
									error_msg += "\n - El número del suscriptor del producto nuevo es requerido.";		
							
					 		    if (! (/^[A-Za-z0-9]*$/.test(document.form1.CNnumero#rsAllContratos.recordCount + 1#.value))) 
									error_msg += "\n - El campo No. Suscriptor tiene caracteres no válidos.";		
	
								
							
							}
						}
							
						if (document.form1.PQcodigo#rsAllContratos.recordCount + 1#.value == "")
							error_msg += "\n - Se debe seleccionar un Paquete.";
					<cfelse>
						if (document.form1.vCantidad_CABM1 && parseInt(document.form1.vCantidad_CABM1.value) > 0) {
							if(document.form1.CNsuscriptor1){
								if(document.form1.CNsuscriptor1.value == "")
									error_msg += "\n - El nombre del suscriptor del producto nuevo es requerido.";
								
								if (! (/^[A-Za-z0-9ÁÉÍÓÚáéíóúÑñ\s]*$/.test(document.form1.CNsuscriptor1.value)))
									error_msg += "\n - El nombre del suscriptor tiene caracteres no válidos.";

									
								if(document.form1.CNnumero1.value == "")
									error_msg += "\n - El número del suscriptor del producto nuevo es requerido.";		
							
							if (! (/^[A-Za-z0-9]*$/.test(document.form1.CNnumero1.value))) 
									error_msg += "\n - El campo No. Suscriptor tiene caracteres no válidos.";		

							}
						}
							
						if (document.form1.PQcodigo1.value == "")
							error_msg += "\n - Se debe seleccionar un Paquete.";				
					</cfif>
					return(error_msg);
				}
				
				//valida los productos agragados a la cuenta por que van a ser modificados
				function validar_Paso1_2(formulario, error_msg) {
					var ninguno = true;
					var sinCheck = true;
					var sinCheckTotal = true;
					var opciones = new Array(10);
					var logArr = new Array(10);
					var cont = 0;
					
					<cfif isdefined("rsAllContratos") and rsAllContratos.RecordCount GT 0>
						//Validación de logines correctos
						if (!validarLogines()) {
							error_msg += "\n - Debe validar los logines del producto #rsAllContratos.PQnombre# antes de continuar.";
						}
					
						
						// validar los datos de localización
					
						if (formulario.Ptelefono1.value == "") {
							error_msg += "\n - Teléfono no puede quedar en blanco.";
							error_input = formulario.Ptelefono1;
						}

<!---						if (formulario.CPid.value == "") {
							error_msg += "\n - El Código Postal es requerido.";
							error_input = formulario.CPid;
						}--->

						if (formulario.Pdireccion.value == "") {
							error_msg += "\n - La Dirección Exacta es requerida.";
							error_input = formulario.Pdireccion;
						}

	
						if (! (/^[A-Za-z0-9ÁÉÍÓÚáéíóúÑñ.\s]*$/.test(formulario.Pdireccion.value))) 
			
						{
							error_msg += "\n - El campo Dirección Exacta tiene caracteres no válidos.";
							error_input = formulario.Pdireccion;
						}

						if (! (/^[A-Za-z0-9ÁÉÍÓÚáéíóúÑñ\s]*$/.test(formulario.Pbarrio.value))) 
			
						{
							error_msg += "\n - El campo Barrio tiene caracteres no válidos.";
							error_input = formulario.Pbarrio;
						}

	
					<cfquery name="rsNiveles" datasource="#session.dsn#">
						select coalesce(min(DPnivel), 0) as minNivel, coalesce(max(DPnivel), 0) as maxNivel
						from DivisionPolitica
						where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.pais#">
					</cfquery>
					<cfset minnivel = rsNiveles.minNivel>
					<cfset maxnivel = rsNiveles.maxNivel>
					<cfoutput><cfloop condition="maxnivel GTE minnivel">
						if (formulario.LCcod_#minnivel#.value == "") {
							error_msg += "\n - " + formulario.LCcod_#minnivel#.alt + " no puede quedar en blanco.";
							error_input = formulario.LCcod_#minnivel#;
						}
					<cfset minnivel = minnivel + 1>
					</cfloop></cfoutput>
					
						<cfloop query="rsAllContratos">
						
						var ACCS_CANT = 0;
						var MAIL_CANT = 0;
						var CABM_CANT = 0;
							
							for (var i=1; i<=#maxServicios.cantidad#; i++) { 
								
								var L = eval("document.form1.Login_"+i+"_#rsAllContratos.Contratoid#");
								var S = eval("document.form1.Snumero_"+i+"_#rsAllContratos.Contratoid#");
								
								if(L != undefined){								
									if(L.value != ''){
										ninguno = false;		//valida que al menos se digite un login
										logArr[cont] = L.value;
										cont++;
										
										if(S.value == ''){		//valida que se seleccionen los sobres para cada login digitado
											error_msg += "\n - Debe seleccionar un Sobre para el Login"+i+" para el producto #rsAllContratos.PQnombre#.";
										}
										
										<cfloop query="rsServiciosDisponibles">//valida que al menos se selecione un servicio por login
											if(eval('document.form1.chk_#Trim(rsServiciosDisponibles.TScodigo)#_'+i+"_#rsAllContratos.Contratoid#")!= undefined){
												var C = eval('document.form1.chk_#Trim(rsServiciosDisponibles.TScodigo)#_'+i+"_#rsAllContratos.Contratoid#");
													if(C.checked == true){
												 		if (C.value == 'ACCS')
												 			ACCS_CANT += 1; // control de servicios seleccionados tipo ACCS
												 		else if (C.value == 'MAIL')
												 			MAIL_CANT += 1;	// control de servicios seleccionados tipo MAIL											 
												 		else if (C.value == 'CABM')
															CABM_CANT += 1;	// control de servicios seleccionados tipo CABM
															sinCheck = false;	
											}	
														}											
										</cfloop>
										if(sinCheck)error_msg += "\n - Debe seleccionar al menos un servicio para el Login"+i+" para el producto #rsAllContratos.PQnombre#.";
										
										tdTelefono1 = document.getElementById('tdTelefono1_'+i+"_#rsAllContratos.Contratoid#");//validar logines
										if(tdTelefono1.style.display == ''){
											var tel = eval("document.form1.LGtelefono_"+i+"_#rsAllContratos.Contratoid#");
											var se =  eval('document.form1.chk_ACCS_'+i+"_#rsAllContratos.Contratoid#");											
											if(tel.value == '' && se.checked){
												error_msg += "\n - Debe digitar un teléfono para el Login"+i+" para el producto #rsAllContratos.PQnombre#.";
											}else{
												if(tel.value.length < 8 && se.checked )
													error_msg = error_msg + '\n - El teléfono del login'+i+ ' es inválido, mínimo son 8 dígitos.';												
											}
										}
									}		
								}
							}
							var iguales=false;	//validar que no hayan logines iguales
							for(i=0;i<cont;i++){
								for(j=i+1;j<cont;j++){
									if(logArr[i].toUpperCase()  == logArr[j].toUpperCase() ) iguales=true;
								}
							}
							if(iguales)error_msg += "\n - No deben existir logines iguales para el producto #rsAllContratos.PQnombre#.";
							if(ninguno)error_msg += "\n - Debe digitar al menos un login para el producto #rsAllContratos.PQnombre#.";
							if (MAIL_CANT > parseInt(document.form1.vCantidad_MAIL1.value))
							error_msg += "\n - Solo se permite seleccionar un máximo de " + document.form1.vCantidad_MAIL1.value + " servicio(s) del tipo MAIL.";
							
							if (!ninguno) { // Si se ingreso al menos un login.
							
								if( document.form1.vCantidadM_ACCS1 != undefined) {					
									if (ACCS_CANT < parseInt(document.form1.vCantidadM_ACCS1.value))
										error_msg += "\n - De seleccionar al menos " + document.form1.vCantidadM_ACCS1.value + " servicio(s) del tipo ACCS.";
								}
								if( document.form1.vCantidadM_CABM1 != undefined) {					
									if (CABM_CANT < parseInt(document.form1.vCantidadM_CABM1.value))
									error_msg += "\n - De seleccionar al menos " + document.form1.vCantidadM_CABM1.value + " servicio(s) del tipo CABM.";
								}
								
								if( document.form1.vCantidadM_MAIL1 != undefined) {					
									if (MAIL_CANT < parseInt(document.form1.vCantidadM_MAIL1.value))
									error_msg += "\n - De seleccionar al menos " + document.form1.vCantidadM_MAIL1.value + " servicio(s) del tipo MAIL.";
								}
							}
							<cfif isdefined('rsAllContratos')>				
								if (document.form1.vCantidad_CABM#rsAllContratos.currentRow# && parseInt(document.form1.vCantidad_CABM#rsAllContratos.currentRow#.value) > 0) {
									if(document.form1.CNsuscriptor#rsAllContratos.recordCount#){
										if(document.form1.CNsuscriptor#rsAllContratos.currentRow#.value == "")
											error_msg += "\n - El nombre del suscriptor es requerido.";
										
										
										if (! (/^[A-Za-z0-9ÁÉÍÓÚáéíóúÑñ\s]*$/.test(document.form1.CNsuscriptor#rsAllContratos.currentRow#.value)))
											error_msg += "\n - El nombre del suscriptor tiene caracteres no válidos.";
	
										if(document.form1.CNnumero#rsAllContratos.currentRow#.value == "")
											error_msg += "\n - El número del suscriptor es requerido.";		
											
						 		    	if (! (/^[A-Za-z0-9]*$/.test(document.form1.CNnumero#rsAllContratos.currentRow#.value))) 
											error_msg += "\n - El campo No. Suscriptor tiene caracteres no válidos.";		

												
									}						
								}
							
								
								if (document.form1.PQcodigo#rsAllContratos.currentRow#.value == "")
									error_msg += "\n - Se debe seleccionar un Paquete.";
							</cfif>
						</cfloop>
					</cfif>
					return(error_msg);
				}

			</cfif>	
			
			function isValidEmail(e)
			{
				// assume an email address cannot start with an @ or white space, but it
				// must contain the @ character followed by groups of alphanumerics and '-'
				// followed by the dot character '.'
				// It must end with 2 or 3 alphanumerics.
				//
				var alnum="a-zA-Z0-9";
				exp="^[^@\\s]+@(["+alnum+"+\\-]+\\.)+["+alnum+"]["+alnum+"]["+alnum+"]?$";
				emailregexp = new RegExp(exp);
			
				result = e.match(emailregexp);
				if (result != null)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			
			function validar(formulario) {		
				var error_input;
				var error_msg = '';
				var varDepoG=true;
				var varDepoG_session=<cfif isdefined('session.saci.depositoGaranOK')>#session.saci.depositoGaranOK#</cfif>;				
			
				
				<cfif Form.paso EQ '1'>
					<cfif not isdefined("rsAllContratos")>
						error_msg = validar_Paso1(formulario,error_msg);//valida el agregar un nuevo producto a la cuenta
					<cfelse>
						error_msg = validar_Paso1_2(formulario,error_msg);//valida los productos agregados a la cuenta por que van a ser modificados
						if(	(#rsAllContratos.RecordCount# == 0)||((#rsAllContratos.RecordCount# > 0) && (eval("document.form1.PQcodigo#rsAllContratos.recordCount+1#.value") != "")) )
							error_msg = validar_Paso1(formulario,error_msg);//valida el agragar un nuevo producto a la cuenta
					</cfif>
				</cfif>
				
				<cfif Form.paso EQ '2'>
					if(!cuentaAct){ 
						if (document.form1.CTtipoEnvio.value =="1"){
							if(document.form1.CPid.value ==""){
								error_msg += "\n - El Código Postal es requerido.";
								error_input = document.getElementById("document.form1.CPid");
							}
							if(trim(document.form1.Papdo.value) =="" || document.form1.Papdo.value == 0){
								error_msg += "\n - El Apdo Postal no puede ser cero.";
								error_input = document.getElementById("document.form1.Papdo");
							}
	<!---						if(trim(document.form1.CTatencionEnvio.value) ==""){
								error_msg += "\n - El campo Atención a: es requerido.";
								error_input = document.getElementById("document.form1.CTatencionEnvio");
							}
	--->						if(document.form1.CTcopiaModo.value =="E"){
								if(document.form1.CTcopiaDireccion.value ==""){
									error_msg += "\n - El E-mail 1 es requerido.";
									error_input = document.getElementById("document.form1.CTcopiaDireccion");
								}
								if(document.form1.CTcopiaDireccion.value.length > 0 && !isValidEmail(document.form1.CTcopiaDireccion.value)){
									error_msg += "\n - Dirección de E-mail 1 inválida.";
									error_input = document.getElementById("document.form1.CTcopiaModo");
								}
								if(document.form1.CTcopiaDireccion2.value.length > 0 && !isValidEmail(document.form1.CTcopiaDireccion2.value)){
									error_msg += "\n - Dirección de E-mail 2 inválida.";
									error_input = document.getElementById("document.form1.CTcopiaDireccion2");
								}
								
								if(document.form1.CTcopiaDireccion3.value.length > 0 && !isValidEmail(document.form1.CTcopiaDireccion3.value)){
									error_msg += "\n - Dirección de E-mail 3 inválida.";
									error_input = document.getElementById("document.form1.CTcopiaDireccion3");
								}
							}
							if(document.form1.CTcopiaModo.value =="F"){
								if(document.form1.CTcopiaDireccion.value ==""){
									error_msg += "\n - El Fax 1 es requerido.";
									error_input = document.getElementById("document.form1.CTcopiaDireccion");
								}		
							}
						}
						else if(document.form1.CTtipoEnvio.value =="2"){
							
							
							if(document.form1.CPid.value ==""){
								error_msg += "\n - El Código Postal es requerido.";
								error_input = document.getElementById("document.form1.CPid");
							}
<!---							if(document.form1.CTatencionEnvio.value ==""){
								error_msg += "\n - El campo Atención a: es requerido.";
								error_input = document.getElementById("document.form1.CTatencionEnvio");
							}
--->							if(eval("document.form1.LCid_#rsDivPolitica.nivel#.value") ==""){
								error_msg += "\n - La provincia es requerida.";
								error_input = document.getElementById("document.form1.LCid_#rsDivPolitica.nivel#");
							}
							if(eval("document.form1.LCid_#rsDivPolitica.nivel-1#.value") ==""){
								error_msg += "\n - El Canton es requerido.";
								error_input = document.getElementById("document.form1.LCid_#rsDivPolitica.nivel-1#");
							}
							if(eval("document.form1.LCid_#rsDivPolitica.nivel-2#.value") ==""){
								error_msg += "\n - El Distrito es requerido.";
								error_input = document.getElementById("document.form1.LCid_#rsDivPolitica.nivel-2#");
							}
	<!---						if(document.form1.CTbarrio.value ==""){
								error_msg += "\n - El Barrio es requerido.";
								error_input = document.getElementById("document.form1.CTbarrio");
							}
--->							
							if (! (/^[A-Za-z0-9ÁÉÍÓÚáéíóúÑñ.\s]*$/.test(document.form1.CTbarrio.value))){
								error_msg += "\n - La Barrio tiene caracteres no válidos.";
								error_input = document.getElementById("document.form1.CTbarrio");
							}

							if(document.form1.CTdireccionEnvio.value ==""){
								error_msg += "\n - La Dirección es requerida.";
								error_input = document.getElementById("document.form1.CTdireccionEnvio");
							}
								if (! (/^[A-Za-z0-9ÁÉÍÓÚáéíóúÑñ.\s]*$/.test(document.form1.CTdireccionEnvio.value))){
								error_msg += "\n - La Dirección tiene caracteres no válidos.";
								error_input = document.getElementById("document.form1.CTdireccionEnvio");

							}
							if(document.form1.CTcopiaModo.value =="E"){
								if(document.form1.CTcopiaDireccion.value ==""){
									error_msg += "\n - El campo E-mail 1 es requerido.";
									error_input = document.getElementById("document.form1.CTcopiaDireccion");
								}		
							}
							if(document.form1.CTcopiaModo.value =="F"){
								if(document.form1.CTcopiaDireccion.value ==""){
									error_msg += "\n - El Fax 1 es requerido.";
									error_input = document.getElementById("document.form1.CTcopiaDireccion");
								}		
							}
						}
					}
				</cfif>
				
				<cfif Form.paso EQ '3'>
					if(!cuentaAct){
						if(document.form1.CTcobro2.checked){
							if(document.form1._NumTarjeta.value ==""){
								error_msg += "\n - El Número de Tarjeta es requerido.";
								error_input = document.getElementById("NumTarjeta");
							}else 
								if(!checkMaxkTC(document.form1._NumTarjeta.value)){
									error_msg += "\n - El Número de Tarjeta no cumple con la máscara del tipo selecionado.";
									error_input = document.getElementById("NumTarjeta");
							}
							if(document.form1._confNumTarjeta.value ==""){
								error_msg += "\n - El Número de Tarjeta de confirmación es requerido.";
								error_input = document.getElementById("confNumTarjeta");
							}else{
								if(document.form1.NumTarjeta.value != document.form1.confNumTarjeta.value){
									error_msg += "\n - El Número de Tarjeta de confirmación es inválido.";
									error_input = document.getElementById("confNumTarjeta");
								}
							}
													
							if(document.form1.MesTarjeta.value ==""){
								error_msg += "\n - El Mes es requerido.";
								error_input = document.getElementById("MesTarjeta");
							}
							
							if(parseInt(document.form1.MesTarjeta.value,10) < 1 || parseInt(document.form1.MesTarjeta.value,10) > 12){
								error_msg += "\n - El Mes debe estár dentro del rango 1-12.";
								error_input = document.getElementById("MesTarjeta");
							
							}
							
							if(document.form1.AnoTarjeta.value ==""){
								error_msg += "\n - El Año es requerido.";
								error_input = document.getElementById("AnoTarjeta");
							}
							
							if(document.form1.AnoTarjeta.value.length < 4) {
								error_msg += "\n - El Año no es válido.";
								error_input = document.getElementById("AnoTarjeta");
							
							}
							
							if(document.form1.MTid.value ==""){
								error_msg += "\n - El Tipo Tarjeta es requerido.";
								error_input = document.getElementById("MTid");
							}
							/*
							if((document.form1.VerificaTarjeta.value =="") || (document.form1.VerificaTarjeta.value.length < 3)){
								error_msg += "\n - Los Dígitos de Verificación son requeridos.";
								error_input = document.getElementById("MTid");
							}*/

							if(document.form1.Ppais.value ==""){
								error_msg += "\n - El País es requerido.";
								error_input = document.getElementById("Ppais");
							}
							//if(document.form1.NombreTarjeta.value ==""){
							//	error_msg += "\n - El Nombre es requerido.";
							//	error_input = document.getElementById("NombreTarjeta");
							//}
							//if(document.form1.Apellido1Tarjeta.value ==""){
							//	error_msg += "\n - El Apellido 1 es requerido.";
							//	error_input = document.getElementById("Apellido1Tarjeta");
							//}
							//if(document.form1.Apellido2Tarjeta.value ==""){
							//	error_msg += "\n - El Apellido 2 es requerido.";
							//	error_input = document.getElementById("Apellido2Tarjeta");
							//}
							//if(document.form1.CedulaTarjeta.value ==""){
							//	error_msg += "\n - La Cédula es requerida.";
							//	error_input = document.getElementById("CedulaTarjeta");
							//} 	
						
							
							//if ( document.form1.NombreTarjeta != undefined){
								//document.form1.NombreTarjeta.value = document.form1.NombreTarjeta.value.toUpperCase();
							//}
							//if ( document.form1.Apellido1Tarjeta != undefined){
							//document.form1.Apellido1Tarjeta.value = document.form1.Apellido1Tarjeta.value.toUpperCase();
							//}
							
							//if ( document.form1.Apellido2Tarjeta != undefined){
							//document.form1.Apellido2Tarjeta.value = document.form1.Apellido2Tarjeta.value.toUpperCase();
							//}--->
						}
						if(document.form1.CTcobro3.checked){
							
							if(document.form1.CuentaTipo.value ==""){
								error_msg += "\n - El Tipo de Cuenta es requerido.";
								error_input = document.getElementById("CuentaTipo");
							}
							if(document.form1.NumCuenta.value ==""){
								error_msg += "\n - El Número de Cuenta es requerido.";
								error_input = document.getElementById("NumCuenta");
							}
							if(document.form1.NumCuenta.value =="0"){
								error_msg += "\n - El Número de cuenta debe ser distinto de 0.";
								error_input = document.getElementById("NumCuenta");
							}
						
							if(document.form1.EFid.value ==""){
								error_msg += "\n - El Banco es requerido.";
								error_input = document.getElementById("EFid");
							}
							if(document.form1.CedulaCuenta.value ==""){
								error_msg += "\n - La Cédula es requerida.";
								error_input = document.getElementById("CedulaCuenta");
							}					
							if(document.form1.NombreCuenta.value ==""){
								error_msg += "\n - El Nombre es requerido.";
								error_input = document.getElementById("NombreCuenta");
							}
							//if(document.form1.Apellido1Cuenta.value ==""){
							//	error_msg += "\n - El Apellido 1 es requerido.";
							//	error_input = document.getElementById("Apellido1Cuenta");
							//}
							
							//if(document.form1.Apellido2Cuenta.value ==""){
							//	error_msg += "\n - El Apellido 2 es requerido.";
							//	error_input = document.getElementById("Apellido2Cuenta");
							//}
						}
					}						
				</cfif>
				
				<cfif Form.paso EQ '4'>
					if(!varDepoG_session)
						error_msg  +="\n - No se encuentra disponible la Interfaz 'Depósito de Garantía'.";											
						
					if(document.form1.listaSuf.value != ""){
						var arrSufijos = document.form1.listaSuf.value.split(',');
						for(var i=0; i < arrSufijos.length; i++){
							if(eval("window.validarDepoGaran" + arrSufijos[i])){		// Funcion de validacion para cada paquete con el tag depoGaran
								varDepoG = eval("validarDepoGaran" + arrSufijos[i] + "();");
								if(!varDepoG)
									break;
							}
						}
					}					
				</cfif>

				<!--- Validacion terminada --->
				<cfif hayBotones>
					if ((error_msg.length != "")&&(document.form1.botonSel.value != "Eliminar")) {
				<cfelse>
					if (error_msg.length != "") {	
				</cfif>
					alert("Por favor revise los siguiente datos:"+error_msg);
					if (error_input && error_input.focus) 
						error_input.focus();					
					return false;
				}else {
					if(varDepoG)
						return true;				
					else
						return false;
				}
			}
			
			function checkMaxkTC(v){
				
				if(document.all.mascaraTarjeta.value.length > 0){
					if(document.all.mascaraTarjeta.value.length == v.length){
						return true;
					}else{
						return false;}
				}else
					return true;
			}
		
			//para el conlis del contrato
			var popUpWin = 0;
			 function popUpWindow(URLStr, left, top, width, height){
			  if(popUpWin){
			   if(!popUpWin.closed) popUpWin.close();
			  }
			  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=yes,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			 }		
			
			function funcReimprimir() {
				if(document.form1.f_loginPrinc.value != '')
					popUpWindow("venta-ver-Contrato.cfm?CTid=#form.CTid#&f_loginPrinc="+ document.form1.f_loginPrinc.value,160,90,700,500);
				else
					popUpWindow("venta-ver-Contrato.cfm?Contratoid="+document.form1.contrat.value+"&f_loginPrinc=",160,90,700,500);
				
				return false;
			}
			function funcImprimir() {
				popUpWindow("venta-formContrato.cfm?CTid=#form.CTid#",160,90,700,500);
				return false;
			}
		//-->
		</script>
	
	</cfoutput>

</cfif>