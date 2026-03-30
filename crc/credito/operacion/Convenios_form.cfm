
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Convenios" returnvariable="LB_Title"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cuenta" Default="Cuenta" returnvariable="LB_Cuenta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MinimoC" Default="Saldo Actual" returnvariable="LB_MinimoC"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Convenido" Default="Monto Convenido" returnvariable="LB_Convenido"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Interes" Default="Intereses" returnvariable="LB_Interes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Condonado" Default="Monto Convenido" returnvariable="LB_Condonado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoTrans" Default="Tipo Transaccion" returnvariable="LB_TipoTrans"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoTrans2" Default="Genera Transaccion" returnvariable="LB_TipoTrans2"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Observaciones" Default="Observaciones" returnvariable="LB_Observaciones"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha de Aplicaci&oacute;n" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Parcialidades" Default="Parcialidades" returnvariable="LB_Parcialidades"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_GastoCobranza" Default="Gasto de Cobranza" returnvariable="LB_GastoCobranza"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Condonacion" Default="Monto Condonar Intereses" returnvariable="LB_Condonacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Porciento" Default="Es Porciento" returnvariable="LB_Porciento"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaInicio" Default="Inicio de Pago" returnvariable="LB_FechaInicio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estado" Default="Estado" returnvariable="LB_Estado"/>


<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfset cuentaValues="">
<cfif modo eq "CAMBIO">
	<cfquery name="q_Convenio" datasource="#session.DSN#">
		select 
				A.CRCCuentasid
			,	B.Tipo as tipoCta
			,	B.Numero
			,	replace(C.SNnombre,',','') SNnombre
			,	ISNULL(B.SaldoActual, 0 ) as MontoConvenir
			,	ISNULL(B.Interes,0) as Interes
			,	A.CodigoConvenio
			,	A.DescripConvenio
			,	A.MontoGastoCobranza
			,	A.esPorcentaje
			,	A.FechaAplicacion
			,	A.Parcialidades
			,	A.CRCTipoTransaccionid
			,	ISNULL(A.Observaciones,'') Observaciones
			,	A.MontoConvenio
			,	case A.convenioAplicado
				when 1 then 
					case A.esPorcentaje
						when 1 then
							A.MontoConvenio + (A.MontoConvenio * (A.MontoGastoCobranza/100))
						else
							A.MontoConvenio + A.MontoGastoCobranza
						end
				else 
					case A.esPorcentaje
						when 1 then
							ISNULL(B.SaldoActual, 0 ) + (ISNULL(B.SaldoActual, 0 ) * (A.MontoGastoCobranza/100))
						else
							ISNULL(B.SaldoActual, 0 ) + A.MontoGastoCobranza
						end 
				end as MontoTotal
			,	A.ConvenioAplicado
			,	A.FechaInicio
			,	case A.Estado
				when 'V' then 'Vencido'
				when 'A' then 'Aplicado'
				else 'Pendiente' end as EstadoD
			,	A.Estado
		from CRCConvenios A
			inner join CRCCuentas B
				on A.CRCCuentasid = B.id
			inner join SNegocios C
				on C.SNid = B.SNegociosSNid
			left join CRCCondonaciones D
				on D.id = A.CRCCondonacionesid
		where A.id = #form.id#
	</cfquery>

	<cfquery name="q_corte" datasource="#session.dsn#">
		select FechaFin from CRCCortes where tipo = '#q_Convenio.tipoCta#' and status = 1;
	</cfquery>

	<cfset cuentaValues = "#q_Convenio.CRCCuentasid#,#q_Convenio.Numero#,#q_Convenio.SNnombre#">
</cfif>

<cfquery name="q_TipoTransaccion"  datasource="#session.DSN#">
	select id,Descripcion from CRCTipoTransaccion where afectaSaldo = 1 and Descripcion like '%conven%' and Ecodigo = #session.ecodigo#;
</cfquery>
<cfquery name="q_TipoTransaccion2"  datasource="#session.DSN#">
	select id,Descripcion from CRCTipoTransaccion where afectaSaldo = 1 and Descripcion like '%recal%' and Ecodigo = #session.ecodigo#;
</cfquery>

<cfoutput>


<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>

<cfset filterUsr = "">
<cfif !isDefined('form.parentEntrancePoint')>
	<cfif isDefined('url.b') && isDefined('url.a') && url.b eq 1 && url.a eq 0>
		<cfset form.parentEntrancePoint = "ConveniosxGestor.cfm">
	<cfelse>
		<cfset form.parentEntrancePoint = "Convenios.cfm">
	</cfif>
</cfif>

<cfif isDefined('form.parentEntrancePoint') && form.parentEntrancePoint eq "ConveniosxGestor.cfm">
	<cfquery name="q_usuario" datasource="#session.DSN#">
		select llave from UsuarioReferencia where Usucodigo = #session.usucodigo# and STabla = 'DatosEmpleado' and Ecodigo = #session.EcodigoSDC#;
	</cfquery>
	<cfif parentEntrancePoint eq 'Convenios.cfm'>
		<cfset filterUsr = "(c.DatosEmpleadoDEid = #q_usuario.llave# or c.DatosEmpleadoDEid2 = #q_usuario.llave#) and">
	</cfif>
</cfif>

		<form method="post" name="form1" action="Convenios_sql.cfm">
			<table width="60%" border="0" cellspacing="0" cellpadding="0" align="center">
				<input type="hidden" name="id" value="<cfif modo eq "CAMBIO">#form.id#</cfif>">
				<input type="hidden" name="parentEntrancePoint" value="#form.parentEntrancePoint#">
				<tr>
					<td nowrap align="right">#LB_Cuenta#:&nbsp;</td>
					<td colspan="3">
						<cfset readonly = "no">
						<cfif modo eq 'CAMBIO'><cfset readonly = "yes"></cfif>
						<cf_conlis
							showEmptyListMsg="true"
							Campos="cuentaID,NumeroCuenta,SNNombre"
							Values="#cuentaValues#"
							Desplegables="N,S,S"
							Modificables="N,N,N"
							Size="0,10,30"
							tabindex="1"
							Tabla="CRCCuentas c 
									inner join SNegocios sn 
										on c.SNegociosSNid = sn.SNid"
							Columnas="
									  c.id as cuentaID
									, c.Numero as NumeroCuenta
									, c.Tipo
									, sn.SNnombre as SNNombre
									, ISNULL(c.Interes, 0 ) - ISNULL(c.Condonaciones, 0 ) as Interes
									, ISNULL(c.SaldoActual, 0 ) as MontoConvenir
									, ISNULL(c.SaldoActual, 0 ) as MontoTotal"
							Filtro="#filterUsr# c.Ecodigo = #Session.Ecodigo# and ISNULL(c.SaldoActual, 0 ) > 0"
							Desplegar="NumeroCuenta,tipo,SNNombre,MontoConvenir,Interes"
							Etiquetas="Numero de Cuenta,Tipo de Cuenta,Nombre Socio de Negocio,Monto A Convenir,Intereses"
							filtrar_por="c.Numero,c.tipo,sn.SNNombre"
							Formatos="S,S,S"
							Align="left,left,left"
							Asignar="cuentaID,NumeroCuenta,SNNombre,MontoConvenir,Interes,MontoTotal"
							Asignarformatos="S,S,S,M,M"
							readonly = "#readonly#"
							/>
					</td>
				</tr>
				<tr>
					<td nowrap align="right">#LB_MinimoC#:&nbsp;</td>
					<td> <input name="MontoConvenir" 
						style="color: ##6E6E6E; background-color:##D8D8D8" 
						type="text" readonly="true"
						value="<cfif modo eq 'CAMBIO'><cfif q_Convenio.MontoConvenir neq "">#NumberFormat(q_Convenio.MontoConvenir,'0.00')#</cfif></cfif>"
						>
					</td>
					<!---
					<td nowrap align="right">#LB_Interes#:&nbsp;</td>
					<td> <input name="Interes" 
						style="color: ##6E6E6E; background-color:##D8D8D8" 
						type="text" disabled="disabled"
						value="<cfif modo eq 'CAMBIO'>#q_Convenio.Interes#</cfif>"
						>
					</td>
					--->
				</tr>
				<tr>
					<td nowrap align="right">&nbsp;</td>
				</tr>
				<tr>
					<td nowrap align="right">#LB_Codigo#:&nbsp;</td>
					<td colspan="3"><input name="CodigoC" type="text" size="5" maxlength="5"
						value="<cfif modo eq 'CAMBIO'>#q_Convenio.CodigoConvenio#</cfif>"
						></td>
				</tr>
				<tr>
					<td nowrap align="right">#LB_Descripcion#:&nbsp;</td>
					<td colspan="3"><input name="DescripcionC" type="text" size="78"
						value="<cfif modo eq 'CAMBIO'>#q_Convenio.DescripConvenio#</cfif>"
						></td>
				</tr>
				<tr>
					<td nowrap align="right">#LB_GastoCobranza#:&nbsp;</td>
					<td>  <input name="GastoConvenio" type="text" 
							onkeyup="return soloNumerosB(event,this.value);"
							onblur="return soloNumerosB(event,this.value);"
							size="10" maxlength="10"
							value="<cfif modo eq 'CAMBIO'>#NumberFormat(q_Convenio.MontoGastoCobranza,'0.00')#<cfelse>0.0</cfif>"
						>
						<input name="Porciento" type="checkbox" 
							onchange="CalcMontoConvenio('');"
							<cfif modo eq 'CAMBIO'><cfif q_Convenio.esPorcentaje eq 1> checked</cfif></cfif>> Porciento
					</td>
					<td nowrap align="right">#LB_Fecha#:&nbsp;</td>
					<td ><input name="FechaAplicacion" 
						style="color: ##6E6E6E; background-color:##D8D8D8" 
						type="text" readonly="true"
						value="<cfif modo eq 'CAMBIO'>#q_Convenio.FechaAplicacion#</cfif>"
						>
					</td>
				</tr>
				<tr>
					<td nowrap align="right">#LB_Parcialidades#:&nbsp;</td>
					<td><input name="Parcialidades" type="text" 
							onkeyup="return soloNumeros(event);"
							onblur="return soloNumeros(event);"
							size="5" maxlength="3"
							value="<cfif modo eq 'CAMBIO'>#q_Convenio.Parcialidades#</cfif>"
						></td>
					<td nowrap align="right">#LB_TipoTrans#:&nbsp;</td>
					<td>
						<select name="TipoTransaccionID">
							<cfloop query="q_TipoTransaccion">
								<option value="#q_TipoTransaccion.id#"
									<cfif modo eq 'CAMBIO'><cfif q_Convenio.CRCTipoTransaccionid eq q_TipoTransaccion.id>selected</cfif></cfif>
								>#q_TipoTransaccion.Descripcion#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td nowrap align="right">#LB_FechaInicio#:&nbsp;</td>
					<td>
						<cfset fechaInicio = ''>
						<cfset fechaCorte = ''>
						<cfif modo eq 'CAMBIO'>
							<cfset fechaInicio = "#DateFormat(q_Convenio.fechaInicio,'dd/mm/yyyy')#">
							<cfset fechaCorte = "#DateFormat(q_corte.fechaFin,'dd/mm/yyyy')#">
						<cfelse>
							<cfset fechaInicio = "#LSDateFormat(Now(),'dd/mm/yyyy')#">
						</cfif>
						<cf_sifcalendario form="form1" value="#fechaInicio#" name="fechaInicio" tabindex="1">
						<input type="hidden" value="#fechaCorte#" name="fechaCorte">
					</td>
					<td nowrap align="right">#LB_TipoTrans2#:&nbsp;</td>
					<td>
						<select name="TipoTransaccionID2">
							<cfloop query="q_TipoTransaccion2">
								<option value="#q_TipoTransaccion2.id#"
									<cfif modo eq 'CAMBIO'><cfif q_Convenio.CRCTipoTransaccionid eq q_TipoTransaccion2.id>selected</cfif></cfif>
								>#q_TipoTransaccion2.Descripcion#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td nowrap align="right">#LB_Convenido#:&nbsp;</td>
					<td> <input name="MontoTotal"
						style="color: ##6E6E6E; background-color:##D8D8D8" 
						type="text" readonly="true"
						value="<cfif modo eq 'CAMBIO'><cfif q_Convenio.MontoTotal neq "">#NumberFormat(q_Convenio.MontoTotal,'0.00')#</cfif></cfif>"
						>
					</td>
					<td nowrap align="right">#LB_Estado#:&nbsp;</td>
					<td> <input name="Estado"
						style="color: ##6E6E6E; background-color:##D8D8D8" 
						type="text" readonly="true"
						value="<cfif modo eq 'CAMBIO'>#q_Convenio.EstadoD#</cfif>"
						>
					</td>

				</tr>
				<tr>
					<td nowrap align="right">&nbsp;</td>
				</tr>
				<tr>
					<td nowrap align="right">#LB_Observaciones#:&nbsp;</td>
					<td colspan="3"><textarea name="ObservacionC" cols="100" rows="3" maxlength="255" onkeyup="countCharacter(this.value);"><cfif modo eq 'CAMBIO'>#q_Convenio.Observaciones#</cfif></textarea>
						<br/>
						<div style="font-size:80%" name="txtAreaCounter" align="left"><div>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<cfif modo eq "CAMBIO"> 
							<cfif q_Convenio.ConvenioAplicado neq 1 && q_Convenio.Estado neq 'V'>
								<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
								<cfset val = objParams.getParametroInfo('30200711')>
								<cfif val.codigo eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no existe"></cfif>
								<cfif val.valor eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no esta definido"></cfif>
								<cfquery name="checkRol" datasource="#session.dsn#">
									select * from UsuarioRol where 
												Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.usucodigo#">  
											and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#val.valor#">
											and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#"> 
								</cfquery>
								<cfif checkRol.recordCount neq 0 && isDefined('form.parentEntrancePoint') && form.parentEntrancePoint eq "Convenios.cfm">
									<cf_botones modo="#modo#" include="Aplicar,Regresar"> 
								<cfelse>
									<cf_botones modo="#modo#" include="Regresar"> 
								</cfif>
							<cfelse>
								<cf_botones modo="#modo#" include="Regresar" exclude="Cambio">
							</cfif>
						<cfelse> 
							<cf_botones modo="#modo#" include="Regresar"> 
						</cfif>
						
					</td>
				</tr>
				<tr>
				</tr>
			</table>
		</form>
<cfif !isDefined('parentEntrancePointGestor')>
	<cf_web_portlet_end>
<cf_templatefooter>
</cfif>
</cfoutput>

<script>

	function soloNumerosB(e,v) {
        var keynum = window.event ? window.event.keyCode : e.which;
		var nv = 0;
		if(isNumber(v+""+e.key) || (keynum == 8) || (keynum == 46)){
			if((keynum != 8) && (keynum != 46)){ nv = v;}
			CalcMontoConvenio(nv);
			return true;
		}else{
			document.getElementsByName('GastoConvenio')[0].value = v;
			return false;
		}
        return false;
	}

	function CalcMontoConvenio(gastoC){
		
		
		var gcPorciento = document.getElementsByName('Porciento')[0].checked;
		if(gastoC == ''){
			gastoC = Number(document.getElementsByName('GastoConvenio')[0].value);
		}
		var SActual = Number(document.getElementsByName('MontoConvenir')[0].value.replace(",","","all"));
		var montoTotal = SActual + Number(gastoC);
		if(gcPorciento){
			montoTotal = SActual + (SActual * (Number(gastoC)/100));
		}
		document.getElementsByName('MontoTotal')[0].value = Math.round(montoTotal * 100) / 100;
	}

	function soloNumeros(e) {
        var keynum = window.event ? window.event.keyCode : e.which;
        return /\d/.test(String.fromCharCode(keynum));
	}
	
	function countCharacter(v){
		document.getElementsByName('txtAreaCounter')[0].innerHTML = v.length + "/255";

	}
	
	function validarForm(){
		var form = document.getElementsByName('form1')[0];

		var msg = "Porfavor corrija los siguientes puntos:";
		var result = true;
		
		if(form.CodigoC.value.trim() == "" ){msg += "\n- Ingrese un Código"; result = false;}
		if(form.DescripcionC.value.trim() == "" ){msg += "\n- Ingrese una Descripción"; result = false;}
		if(form.ObservacionC.value.trim() == "" ){msg += "\n- Ingrese una Observación"; result = false;}
		if(form.NumeroCuenta.value.trim() == "" ){msg += "\n- Seleccione una cuenta"; result = false;}
		if(form.TipoTransaccionID.value.trim() == "" ){msg += "\n- No ha configurado 'Tipo Transaccion'"; result = false;}
		if(form.TipoTransaccionID2.value.trim() == "" ){msg += "\n- No ha configurado 'Genera Transaccion'"; result = false;}
		if(Number(form.MontoConvenir.value) == 0|| isNaN(form.MontoConvenir.value.replace(',','','all'))) {msg += "\n- El monto debe ser mayor que CERO"; result = false;}
		if(parseFloat(form.Parcialidades.value) <= 0 || !isNumber(form.Parcialidades.value)) {msg += "\n- La parcialidad no puede ser CERO"; result = false;}
		if(form.fechaInicio.value.trim() == '') {msg += "\n- La fecha de Inicio no puede ser VACIO"; result = false;}
		var finicio = stringToDate(form.fechaInicio.value,"dd/mm/yyyy","/");
		if(form.fechaCorte.value.trim() != '') {
			var ffin = stringToDate(form.fechaCorte.value,"dd/mm/yyyy","/");
			if(finicio <= ffin){msg += "\n- No se puede aplicar un convenio con fecha de inicio en un corte cerrado"; result = false;}
		}
		var today = new Date();
		var today = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 0, 0, 0);
		if(finicio < today){msg += "\n- No se puede aplicar un convenio con fecha de inicio en el pasado"; result = false;}
		
		if(!result){
			alert(msg);
			return false;
		}else{
			document.getElementsByName('MontoConvenir')[0].disabled = false;
		}
		return result;
	}
	
	function funcCambio(){
		if(Number(form.MontoConvenible.value) != Number(form.MontoConvenir.value) ){
				if(confirm("Han ocurrido cambios en la cuenta. Desea Actualizar el Monto a Convenir?")){
					form.MontoConvenir.value = form.MontoConvenible.value;
				}
		}
		return validarForm();
	}
	
	function funcAlta(){ 
		return validarForm();
	}
	function funcAplicar(){ 
	
		if(confirm("Esta seguro que desea aplicar el convenio?")){
			if(Number(document.getElementsByName('form1')[0].MontoConvenir.value) == 0){
				alert("No puede aplicar una Convenio cuyo monto es CERO");
				return false;
			}
			return validarForm(); 
		}
		return false;
	}
	function stringToDate(_date,_format,_delimiter){
		var formatLowerCase=_format.toLowerCase();
		var formatItems=formatLowerCase.split(_delimiter);
		var dateItems=_date.split(_delimiter);
		var monthIndex=formatItems.indexOf("mm");
		var dayIndex=formatItems.indexOf("dd");
		var yearIndex=formatItems.indexOf("yyyy");
		var month=parseInt(dateItems[monthIndex]);
		month-=1;
		var formatedDate = new Date(dateItems[yearIndex],month,dateItems[dayIndex]);
		return formatedDate;
	}
	function isNumber ( n )  {
		return !isNaN(parseFloat ( n ) ) && isFinite( n );
	}
	
</script>