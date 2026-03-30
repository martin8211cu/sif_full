<style type="text/css">
	.detalle_incidencia input[type="text"] {
		border:none; font-weight:bold; width:350px;
	}
</style>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Observacion" default = "Observaciones" returnvariable="LB_Observacion" xmlfile = "tab_Transaccion.xml">

<cfoutput>

	<cfparam name="form.id">

	<cfquery name="rsCuenta" datasource="#session.DSN#">
		select *
			,	concat(d.DEnombre,' ',d.DEapellido1,' ',d.DEapellido2) as GDEnombreC
			,	d.DEidentificacion GDEidentificacion
			,	c.DatosEmpleadoDEid GDEid
			,	concat(d2.DEnombre,' ',d2.DEapellido1,' ',d2.DEapellido2) as ADEnombreC
			,	d2.DEidentificacion ADEidentificacion
			,	c.DatosEmpleadoDEid2 ADEid
			,	case c.Tipo
					when 'D' then 'Vales'
					when 'TC' then 'Tarjeta de Credito'
					when 'TM' then 'Tarjeta Mayorista'
					else ''
				end as TipoDescripcion
			, 	ce.Orden
			,	c.Tipo
			,	case c.Tipo
					when 'D' then p.DSeguro
					when 'TC' then p.TCSeguro
					when 'TM' then p.TMSeguro
					else ''
				end as cuentaSeguro
			,	cd.Titulo
			,	s.SNid
			,	dr.Direccion1 as dirDireccion1
			,	dr.Direccion2 as dirDireccion2
			,	dr.Ciudad as dirCiudad
			,	dr.Estado as dirEstado
			,	dr.CodPostal as dirCodPostal
			,	dr.pPais as dirpPais
		from CRCCuentas c
			inner join SNegocios s 
				on c.SNegociosSNid = s.SNid
			inner join CRCEstatusCuentas ce 
				on c.CRCEstatusCuentasid = ce.id
			left join CRCCategoriaDist cd 
				on c.CRCCategoriaDistid = cd.id
			left join DatosEmpleado d 
				on c.DatosEmpleadoDEid = d.DEid
			left join DatosEmpleado d2 
				on c.DatosEmpleadoDEid2 = d2.DEid
			left join DireccionesSIF dr
				on s.id_direccion = dr.id_direccion
			left join CRCTCParametros p
				on p.CRCCuentasid = c.id
		where c.Ecodigo = #Session.Ecodigo#
			and c.id = #form.id#
	</cfquery>

	<cfquery name="rsSeguro" datasource="#session.DSN#">
		select  isNull(mcc.seguro,0) as montoSeguro
		from CRCCuentas c
			inner join SNegocios s 
				on c.SNegociosSNid = s.SNid
			left join CRCCortes ct
				on rtrim(ltrim(ct.Tipo)) = rtrim(ltrim(c.tipo))
			left join CRCMovimientoCuentaCorte mcc
				on mcc.Corte = ct.codigo
				and mcc.CRCCuentasID = c.id
			left join CRCTCParametros p
				on p.CRCCuentasid = c.id
		where c.Ecodigo = #Session.Ecodigo#
			and c.id = #form.id#
			and ct.status = 1;
	</cfquery>

	<cfquery name="q_currentCorte" datasource="#session.DSN#">
		select 
		<cfif rsCuenta.Tipo eq 'TM'>
			max(Codigo) Codigo
		<cfelse>
			Codigo
		</cfif> 
		from CRCCortes 
			where 
				Tipo = '#rsCuenta.Tipo#' 
				and FechaFin >= CURRENT_TIMESTAMP 
				and FechaInicio <= CURRENT_TIMESTAMP
				and Ecodigo = #session.ecodigo#
				<cfif rsCuenta.Tipo eq 'TM'>
					and Codigo like '%-#rsCuenta.SNid#'
				</cfif>
	</cfquery>

	<cfif q_currentCorte.recordCount gt 0>
		<cfset q_currentCorte="#QueryGetRow(q_currentCorte,1).codigo#">
	<cfelse>
		<cfset q_currentCorte="">
	</cfif>

	<cfset top = 3>
	<cfif isdefined('form.monthSearch')><cfset top = form.monthSearch></cfif>
	<cfif '#Trim(rsCuenta.Tipo)#' eq 'D'><cfset top = top * 2></cfif>
	
	<cfquery name="q_Cortes" datasource="#session.DSN#">
		select top((2*#top#)+1) * 
		from CRCCortes  
			where 
				FechaInicio < DateADD(m,<cfif isdefined('form.monthSearch')>#form.monthSearch#<cfelse>3</cfif>,CURRENT_TIMESTAMP)
				and FechaInicio > DateADD(m,<cfif isdefined('form.monthSearch')>-#(form.monthSearch + 1)#<cfelse>-4</cfif>,CURRENT_TIMESTAMP)
				and Tipo = '#rsCuenta.Tipo#'
				and Ecodigo = #session.ecodigo#
				<cfif rsCuenta.Tipo eq 'TM'>
					and Codigo like '%-#rsCuenta.SNid#'
				</cfif>
				order by FechaFin desc;
	</cfquery>

	<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
	<cfset val = objParams.getParametroInfo('30000710')>
	<cfif val.codigo eq ''>
		<cfthrow message="El parametro (30000710 - Cambio automatico hasta estado) no esta definido">
	</cfif>
	<cfif val.valor eq ''>
		<cfthrow message="El parametro (30000710 - Cambio automatico hasta estado) no tiene valor">
	</cfif>
	<cfset catsubsidio = objParams.getParametroInfo('30000508')>
	<cfif catsubsidio.codigo eq ''>
		<cfthrow message="El parametro (30000508 - Categoria para Seguro Subsidiado) no esta definido">
	</cfif>
	<cfif catsubsidio.valor eq ''>
		<cfthrow message="El parametro (30000508 - Categoria para Seguro Subsidiado) no tiene valor">
	</cfif>

<!--- <cfif parentEntrancePoint eq 'Cuentas.cfm'> --->
	<cfset tipoEmpleado = "">
	<cfquery name="q_usuario" datasource="#session.DSN#">
		select A.llave,B.isAbogado,B.isCobrador from UsuarioReferencia A 
			inner join DatosEmpleado B 
				on A.llave = B.DEid 
		where A.Usucodigo = #session.usucodigo# and STabla = 'DatosEmpleado';
	</cfquery>
	
	<cfset filterUsr = "(c.DatosEmpleadoDEid = #q_usuario.llave# or c.DatosEmpleadoDEid2 = #q_usuario.llave#) and">
	<cfif q_usuario.isAbogado eq 1>
		<cfset tipoEmpleado = "AB">
	<cfelseif q_usuario.isCobrador eq 1>
		<cfset tipoEmpleado = "GE">
	</cfif>
<!--- </cfif> --->

	<cfset CRCCorteFactory = createObject("component","crc.Componentes.cortes.CRCCorteFactory")>
	<cfset CRCorte = CRCCorteFactory.obtenerCorte(TipoProducto=#rsCuenta.Tipo#,conexion=#session.DSN#, Ecodigo=#session.ECodigo#, SNid=#rsCuenta.SNid#)>

	<cfset cortes = CRCorte.GetCorteCodigos(fecha='#DateFormat(Now())#', parcialidades=1, SNid=#rsCuenta.SNid#)>

	<form name="formDetalleCuenta" action="#parentEntrancePoint#" method="POST">
		<input name="whatToDo" type="hidden" value="" >
		<input name="currentTab" type="hidden" value="" >
		<table width="100%" class="detalle_incidencia" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td width="50%">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td nowrap align="right">
								<strong>Nombre y Apellidos:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#rsCuenta.SNnombre#"
									readonly tabindex="-1">
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Identificaci&oacute;n:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#rsCuenta.SNidentificacion#"
									tabindex="-1" readonly>
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Fecha Nacimiento:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#DateFormat(rsCuenta.SNFechaNacimiento,'dd/mm/yyyy')#"
									readonly tabindex="-1">
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Fecha Alta:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#DateFormat(rsCuenta.SNFecha,'dd/mm/yyyy')#"
									readonly tabindex="-1">
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Tel&eacute;fono:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#rsCuenta.SNtelefono#"
									readonly tabindex="-1">
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Correo Electr&oacute;nico:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#rsCuenta.SNemail#"
									tabindex="-1" readonly>
							</td>
						</tr>
						<tr>
							<td align="right" valign="top" style="padding: 5px;">
								<strong>Direcci&oacute;n 1:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#rsCuenta.dirDireccion1#"
									tabindex="-1" readonly>
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Direcci&oacute;n 2:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#rsCuenta.dirdireccion2#"
									readonly tabindex="-1">
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Ciudad:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#rsCuenta.dirciudad#"
									readonly tabindex="-1">
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Estado:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#rsCuenta.direstado#"
									readonly tabindex="-1">
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>C&oacute;digo Postal:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#rsCuenta.dircodPostal#"
									readonly tabindex="-1">
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Pa&iacute;s:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#rsCuenta.dirppais#"
									readonly tabindex="-1">
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Limite de Cr&eacute;dito</strong>
							</td>
							<td>
								<input type="text" value="#LSCurrencyFormat(rsCuenta.MontoAprobado)#"
									readonly tabindex="-1">
							</td>
						</tr>
					</table>
				</td>
				<td width="50%" valign="top" align="center">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td align="right">
								<strong>Numero Cuenta:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#rsCuenta.Numero#"
									readonly tabindex="-1">
								<input name="id" type="hidden" value="#rsCuenta.id#" >
								<input type="hidden" name="codigoCorte" value="#cortes#" />
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Tipo Cuenta:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#rsCuenta.TipoDescripcion#"
									readonly tabindex="-1">
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Socio de Negocio:&nbsp;</strong>
							</td>
							<td>
								<input type="text" value="#rsCuenta.SNnombre#"
									readonly tabindex="-1">
							</td>
						</tr>

						<!---cfif q_usuario.RecordCount gt 0--->
							<tr>
								<td colspan="2">
									<input type="hidden" name="CuentaID" 
										<cfif isdefined('form.IDINCI') and form.modo eq 'CAMBIO' >value="#q_Inci.CRCCuentasid#"<cfelse>value="#form.id#"</cfif>
									>
									<input type="hidden" name="TipoEmpleado" 
										<cfif isdefined('form.IDINCI') and form.modo eq 'CAMBIO' >value="#q_Inci.TipoEmpleado#"<cfelse>value="#tipoEmpleado#"</cfif>
									> 
									<input type="hidden" name="EmpleadoID" 
										<cfif isdefined('form.IDINCI') and form.modo eq 'CAMBIO' >value="#q_Inci.DatosEmpleadoDEid#"<cfelse>value="#q_usuario.llave#"</cfif>
									>
									<input type="hidden" name="InciID" 
										<cfif isdefined('form.IDINCI') and form.modo eq 'CAMBIO' >value="#q_Inci.id#"<cfelse>value="-"</cfif>
									>
									<input type="hidden" name="TPendiente" 
										<cfif isdefined('form.IDINCI') and form.modo eq 'CAMBIO' >value="#q_Inci.TransaccionPendiente#"<cfelse>value="-"</cfif>
									>
									<input type="hidden" name="currentUserKey" value="#q_usuario.llave#">
									<input type="hidden" name="procesarInciComo" value="">
								</td>
							</tr>
							<tr>
								<td align="right" style="padding-top:50px;"> #LB_Observacion#: &nbsp; </td>
								<td style="padding-top:50px;">
									<input type="hidden" name="tipoTransID" value="">
									<textarea style="resize: none;" name="Observaciones"
										cols="50" rows="5" maxlength="255"
										onkeyup="countCharacter(this.value);"><cfif modo eq 'CAMBIO'><cfif isdefined('form.IDINCI') and form.modo eq 'CAMBIO' >#q_Inci.Observaciones#<cfelse></cfif></cfif></textarea>
									<br/>
									<div style="font-size:80%" name="txtAreaCounter" align="left"><div>
								</td>
							</tr>
							<tr>
								<td colspan="3" align="center">
									&emsp;<input type="button" name="INCIDENCIA"
										value="Agregar" onclick="setWhatToDo('AddINCI');">
								</td>
							</tr>
						<!---cfelse>
							<tr>
								<td>
									<p align="center">
										<font color="red"><br/><br/><br/><b>Este usuario no ha sido asignado a un empleado <br/>por lo tanto no puede modificar las incidencias</b></font>
									</p>
								</td>
							</tr>
						</cfif--->
					</table>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2">
					<hr width="95%">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<cfinclude template="RegIncidencias.cfm">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>

<script>
	var typewatch = function(){
		var timer = 0;
		return function(callback, ms){
			clearTimeout (timer);
			timer = setTimeout(callback, ms);
		}  
	}();

	function WaitRefreshCortes(){
		setTimeout(function(){
			//if(Number.isInteger(Number(document.formDetalleCuenta.monthSearch.value))){
				setWhatToDo('REFRESH');
		}, 1500);
	}
	
	function setWhatToDo(val){ 
		document.getElementsByName('whatToDo')[0].value = val; 
		Submit();
	}
	
	function ActiveTab(){ 
		var tabs = $('*[id^="tab_custom').get();
		for(var i in tabs){
			console.log(tabs[i].className+" - "+tabs[i].className.indexOf('active'));
			if(tabs[i].className.indexOf('active') >= 0 ){
				document.getElementsByName('currentTab')[0].value = i;
			}
		}
		return true;
	}
	
	function isNumber ( n )  {
		return !isNaN(parseFloat ( n ) ) && isFinite( n );
	}
	
	function Submit() {
		var form = document.getElementsByName('formDetalleCuenta')[0];
		var codigoCorte = document.getElementsByName('codigoCorte')[0];
		
		var tab = ActiveTab();
		var submitOK = true;
		
		if(form.GDEid != undefined && form.ADEid != undefined && form.GDEid.value != "" && form.ADEid.value != ""){
			if(document.getElementsByName('whatToDo')[0].value.indexOf('DELETE') < 0){
				alert('Escoga solo uno [ Gestor | Abogado ]');
				return false;
			}
		}
		
		if(form.Observaciones != undefined && form.Observaciones.value == "" && form.whatToDo.value.indexOf('INCI') >= 0){
			alert('Agregue una descripcion a la incidencia');
				return false;
		}
		
		if(form.tipoTransID != undefined && form.tipoTransID.value != "" && Number(form.monto.value) == 0){
			alert('Ha escogido generar gasto de cobranza pero no ha especificado el monto del gasto');
				return false;
		}

		/*if(form.monto.value != '' && !isNumber(form.monto.value)){
			alert('El monto de Incidencia no es un numero valido');
			return false;
		}

		if(form.tipoTransID != undefined &&  form.tipoTransID.value == "" && Number(form.monto.value) != 0){
			submitOK = confirm('Ha ingresado un monto pero no ha seleccionado generar gasto de cobranza. No se guardara el monto. Desea Continuar?');
		}*/
		
		
		if(form.currentUserKey != undefined && form.currentUserKey.value != form.EmpleadoID.value && form.whatToDo.value == 'updateINCI'){
			alert('No tiene permiso para modificar la transaccion');
				return false;
		}
		
		if(form.TPendiente != undefined && form.TPendiente.value != '1' && form.whatToDo.value == 'processINCI'){
			alert('La transaccion ha sido aprobada y no se puede modificar');
				return false;
		}
		
		/*if(form.codigoCorte == undefined){
			alert('No se ha seleccionado un corte');
				return false;
		}*/
		
		if(submitOK){
			form.submit();
		}
		
	}
</script>