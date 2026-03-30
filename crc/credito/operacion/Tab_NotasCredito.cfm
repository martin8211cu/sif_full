<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Cliente" default = "Cliente" returnvariable="LB_Cliente" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Observacion" default = "Observaciones" returnvariable="LB_Observacion" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fecha" default = "Fecha" returnvariable="LB_Fecha" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_GastoCobranza" default = "Gener&oacute; Gasto de Cobranza" returnvariable="LB_GastoCobranza" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Monto" default = "Monto" returnvariable="LB_Monto" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Reportado" default = "Reportado por" returnvariable="LB_Reportado" xmlfile = "tab_Transaccion.xml">


<cfparam name="form.id">

<cfif !isdefined('form.codigocorte')>
	<cfset form.codigocorte="#q_currentCorte#">
</cfif>

<cfset filterUsr = "">
<cfset tipoEmpleado = "">
<!--- <cfif parentEntrancePoint eq 'Cuentas.cfm'> --->
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

<cfquery name="q_TipoTran" datasource="#session.DSN#">
	select * from CRCTipoTransaccion 
	where afectaPagos='1'
		and Codigo in ('NR');
</cfquery>

<cfif isdefined('form.IDAJ') and form.modo eq 'CAMBIO'>
	<cfif form.IDAJ neq "">
		<cfquery name="q_Ajuste" datasource="#session.DSN#">
			select ic.*
			from CRCAjusteCuenta ic
			where ic.id = #form.IDAJ#
		</cfquery>
	</cfif>
</cfif>

<cfset corteAJFiltro = q_currentCorte>
<cfif isDefined('form.codigoCorte')>
	<cfset corteAJFiltro = form.codigoCorte>
</cfif>




<cfoutput>

<div style="height: 100%; width:100%; font-size: 0;">
	<div style="width: 50%; display: inline-block; *display: inline; zoom: 1; vertical-align: top; font-size: 12px;">
		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td>
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="CRCAjusteCuenta A"
						columnas="
							A.id,
							A.Corte,
							A.Observaciones,
							A.Monto,
							case A.Aplicada
								when 0 then 'PENDIENTE'
								when 1 then 'APLICADA'
							end as Estado,
							A.Aplicada,
							A.TipoMov,
							A.createdAt Fecha
						"
						desplegar="Fecha,Observaciones,Monto,Estado"
						etiquetas="Fecha,Observaciones,Monto,Estado"
						formatos="S,S,S,S"
						filtro="A.CRCCuentasid = #form.id#"
						align="left,left,left,left"
						checkboxes="N"
						formName="formDetalleCuenta"
						ira="#parentEntrancePoint#?tab=5"
						keys="id">
					</cfinvoke>
				</td>
			</tr>
		</table>
	</div>
	<div style="width: 50%; display: inline-block; *display: inline; zoom: 1; vertical-align: top; font-size: 12px;">
		<cfif q_usuario.RecordCount gt 0>
			<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td colspan="2">
						<input type="hidden" name="CuentaID" 
							<cfif isdefined('form.IDAJ') and form.modo eq 'CAMBIO' >value="#q_Ajuste.CRCCuentasid#"<cfelse>value="#form.id#"</cfif>
						>
						<input type="hidden" name="AJID" 
							<cfif isdefined('form.IDAJ') and form.modo eq 'CAMBIO' >value="#q_Ajuste.id#"<cfelse>value="-"</cfif>
						>
						<input type="hidden" name="TPendiente" 
							<cfif isdefined('form.IDAJ') and form.modo eq 'CAMBIO' >value="#q_Ajuste.Aplicada#"<cfelse>value="-"</cfif>
						>
						<input type="hidden" name="currentUserKey" value="#q_usuario.llave#">
						<input type="hidden" name="procesarAJComo" value="">
					</td>
				</tr>
				<tr>
					<td align="right"> Transacci&oacute;n: &nbsp; </td>
					<td>
						<select name="tipoTransID">
							<cfloop query="q_TipoTran">
								<option value="#q_TipoTran.id#"
									<cfif isdefined('form.IDAJ') and form.modo eq 'CAMBIO' >
										<cfif q_TipoTran.id eq q_Ajuste.CRCTipoTransaccionid>
											selected
										</cfif>
									</cfif>
								> #q_TipoTran.Descripcion#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right"> #LB_Monto#: &nbsp; </td>
					<td><input size="10" maxlength="10" type="text" name="monto" onkeypress="return justNumbers(event);" 
						<cfif isdefined('form.IDAJ') and form.modo eq 'CAMBIO' >value="#q_Ajuste.MONTO#"<cfelse>value=""</cfif>
					> </td>
				</tr>
				<tr>
					<td align="right"> #LB_Observacion#: &nbsp; </td>
					<td> 
						<textarea name="Observaciones" cols="50" rows="5" maxlength="255" onkeyup="countCharacter(this.value);"><cfif modo eq 'CAMBIO'><cfif isdefined('form.IDAJ') and form.modo eq 'CAMBIO' >#q_Ajuste.Observaciones#<cfelse></cfif></cfif></textarea>
						<br/>
						<div style="font-size:80%" name="txtAreaCounter" align="left"><div>
					</td>
				</tr>
				<cfif isdefined('form.IDAJ') and form.modo eq 'CAMBIO' >
				<tr>
					<td align="right"> #LB_Reportado#: &nbsp; </td>
					<td>
						<input size="38" type="text" tabindex="-1" style="border:none;" value="#q_Ajuste.ReportadoPor#" readonly disabled > 
					</td>
				</tr>
				</cfif>
				<tr>
					<td colspan="3" align="center">
						<cfif isdefined('form.IDAJ') and form.modo eq 'CAMBIO'>
							&emsp;<input type="button" name="Ajuste" value="Nuevo" onclick="setWhatToDo('NewAJ');">
							<cfif parentEntrancePoint eq 'cuentasAdmin.cfm'>
								<cfif ArrayContains([0,2], q_Ajuste.Aplicada)> <!--- 0:pendiente, 1:aplicada, 2:N/A, 3:Rechazada--->
									&emsp;<input type="button" name="Ajuste" value="Modificar" onclick="setWhatToDo('updateAJ')">
								</cfif>
								<cfif q_Ajuste.Aplicada eq 0> <!--- 0:pendiente, 1:aplicada, 2:N/A, 3:Rechazada--->
									&emsp;<input type="button" name="APROBAR_AJ" value="Aplicar" onclick="aprobarAJ('a');">
									&emsp;<input type="button" name="RECHAZAR_AJ" value="Rechazar" onclick="aprobarAJ('r');">
								</cfif>
							</cfif>
						<cfelse>
						&emsp;<input type="button" name="Ajuste" value="Agregar" onclick="if( validate)setWhatToDo('AddAJ');">
						</cfif>
					</td>
				</tr>
			</table>
		<cfelse> 
			<p align="center"><font color="red"><br/><br/><br/><b>Este usuario no ha sido asignado a un empleado <br/>por lo tanto no puede modificar las Ajustes</b></font> </p>
		</cfif>
	</div>
</div>


</cfoutput>


<script>
    document.form1.btnEliminar .value='Rechazar'
	function countCharacter(v){
		document.getElementsByName('txtAreaCounter')[0].innerHTML=v.length+"/255";
		document.getElementsByName('Observaciones')[0].innerHTML=document.getElementsByName('Observaciones')[0].innerHTML.replace('\n','');
		document.getElementsByName('Observaciones')[0].value=document.getElementsByName('Observaciones')[0].value.replace('\n','');
	}
	function justNumbers(e) {
        var keynum = window.event ? window.event.keyCode : e.which;
        if ((keynum == 8) || (keynum == 46))
        return true;
         
        return /\d/.test(String.fromCharCode(keynum));
        }
	
	function aprobarAJ(t){
		
		var msg = 'APLICAR';
		if(t == 'r'){msg = 'RECHAZAR';}

		if(confirm('Esta seguro de '+msg+' el Ajuste?')){
			if(document.getElementsByName('TPendiente')[0].value == '1'){
				alert('La transaccion ya fue aprobada');
			}else if(document.getElementsByName('TPendiente')[0].value == '2'){
				alert('La transaccion no requiere aprobacion');
			}else{
				document.getElementsByName('procesarAJComo')[0].value=t;
				setWhatToDo('ProcessAJ');
			}
		}
		return false;
	}
	
</script>

<script>
	function Validate(){
		if(form.Observaciones != undefined && form.Observaciones.value == "" && form.whatToDo.value.indexOf('AJ') >= 0){
			alert('las Observaciones son obligatorias');
				return false;
		}
		
		if(form.monto.value != '' && !isNumber(form.monto.value)){
			alert('El monto no es un numero valido');
			return false;
		}

		return true;
	}
</script>