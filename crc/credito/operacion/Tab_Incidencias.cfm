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
	select * from CRCTipoTransaccion where afectaGastoCobranza='1';
</cfquery>

<cfif isdefined('form.IDINCI') and form.modo eq 'CAMBIO'>
	<cfif form.IDINCI neq "">
		<cfquery name="q_Inci" datasource="#session.DSN#">
			select ic.*
				, CONCAT(isNull(de.DEnombre,''),' ',isNull(de.DEapellido1,''),' ',isNull(de.DEapellido2,'')) as ReportadoPor 
			from CRCIncidenciasCuenta ic
				left join DatosEmpleado de
					on de.DEid = ic.DatosEmpleadoDEid
			where ic.id = #form.IDINCI#
		</cfquery>
	</cfif>
</cfif>

<cfset corteInciFiltro = q_currentCorte>
<cfif isDefined('form.codigoCorte')>
	<cfset corteInciFiltro = form.codigoCorte>
</cfif>




<cfoutput>

<div style="height: 100%; width:100%; font-size: 0;">
	<div style="width: 50%; display: inline-block; *display: inline; zoom: 1; vertical-align: top; font-size: 12px;">
		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td>
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="CRCIncidenciasCuenta A
								left join DatosEmpleado B
								on B.DEid = A.DatosEmpleadoDEid"
						columnas="
							A.id as idInci,
							A.Corte,
							CONCAT(SUBSTRING(A.Observaciones,0,30),' ...') as ObservacionesInci,
							case A.TipoEmpleado
								when 'GE' then 'Gestor'
								when 'AB' then 'Abogado'
								else 'N/D'
							end as TipoEmpleadoInci,
							A.Monto as MontoInci,
							case A.TransaccionPendiente
								when 0 then 'PENDIENTE'
								when 1 then 'APLICADA'
								when 2 then 'N/A'
								when 3 then 'RECHAZADA'
							end as TransaccionPendienteDescripInci,
							A.TransaccionPendiente as TransaccionPendienteInci,
							A.DatosEmpleadoDEid as DatosEmpleadoDEidInci,
							CONCAT(SUBSTRING(CONCAT(B.DEnombre,' ',B.DEapellido1,' ',B.DEapellido2),0,20),' ...') as DENombre"
						desplegar="Corte,ObservacionesInci,TipoEmpleadoInci,MontoInci,TransaccionPendienteDescripInci,DENombre"
						etiquetas="Corte,Observaciones,TipoEmpleado,Monto,Estado,Reportada Por"
						formatos="S,S,S,S,S,S"
						filtro="A.Ecodigo=#session.Ecodigo# and A.CRCCuentasid = #form.id# and A.Corte = '#corteInciFiltro#'"
						align="left,left,left,left,left,left"
						checkboxes="N"
						formName="formDetalleCuenta"
						ira="#parentEntrancePoint#?tab=4"
						keys="idInci">
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
					<td align="right"> #LB_GastoCobranza#: &nbsp; </td>
					<td>
						<select name="tipoTransID">
							<option value="">-No Aplica-</option>
							<cfloop query="q_TipoTran">
								<option value="#q_TipoTran.id#"
									<cfif isdefined('form.IDINCI') and form.modo eq 'CAMBIO' >
										<cfif q_TipoTran.id eq q_Inci.CRCTipoTransaccionid>
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
						<cfif isdefined('form.IDINCI') and form.modo eq 'CAMBIO' >value="#q_Inci.MONTO#"<cfelse>value=""</cfif>
					> </td>
				</tr>
				<tr>
					<td align="right"> #LB_Observacion#: &nbsp; </td>
					<td> 
						<textarea name="Observaciones" cols="50" rows="5" maxlength="255" onkeyup="countCharacter(this.value);"><cfif modo eq 'CAMBIO'><cfif isdefined('form.IDINCI') and form.modo eq 'CAMBIO' >#q_Inci.Observaciones#<cfelse></cfif></cfif></textarea>
						<br/>
						<div style="font-size:80%" name="txtAreaCounter" align="left"><div>
					</td>
				</tr>
				<cfif isdefined('form.IDINCI') and form.modo eq 'CAMBIO' >
				<tr>
					<td align="right"> #LB_Reportado#: &nbsp; </td>
					<td>
						<input size="38" type="text" tabindex="-1" style="border:none;" value="#q_Inci.ReportadoPor#" readonly disabled > 
					</td>
				</tr>
				</cfif>
				<tr>
					<td colspan="3" align="center">
						<cfif isdefined('form.IDINCI') and form.modo eq 'CAMBIO'>
							&emsp;<input type="button" name="INCIDENCIA" value="Nuevo" onclick="setWhatToDo('NewINCI');">
							<cfif parentEntrancePoint eq 'cuentasAdmin.cfm'>
								<cfif ArrayContains([0,2], q_Inci.TransaccionPendiente)> <!--- 0:pendiente, 1:aplicada, 2:N/A, 3:Rechazada--->
									&emsp;<input type="button" name="INCIDENCIA" value="Modificar" onclick="setWhatToDo('updateINCI')">
								</cfif>
								<cfif q_Inci.TransaccionPendiente eq 0> <!--- 0:pendiente, 1:aplicada, 2:N/A, 3:Rechazada--->
									&emsp;<input type="button" name="APROBAR_INCI" value="Aplicar" onclick="aprobarInci('a');">
									&emsp;<input type="button" name="RECHAZAR_INCI" value="Rechazar" onclick="aprobarInci('r');">
								</cfif>
							</cfif>
						<cfelse>
						&emsp;<input type="button" name="INCIDENCIA" value="Agregar" onclick="setWhatToDo('AddINCI');">
						</cfif>
					</td>
				</tr>
			</table>
		<cfelse> 
			<p align="center"><font color="red"><br/><br/><br/><b>Este usuario no ha sido asignado a un empleado <br/>por lo tanto no puede modificar las incidencias</b></font> </p>
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
	
	function aprobarInci(t){
		
		var msg = 'APLICAR';
		if(t == 'r'){msg = 'RECHAZAR';}

		if(confirm('Esta seguro de '+msg+' la incidencia?')){
			if(document.getElementsByName('TPendiente')[0].value == '1'){
				alert('La transaccion ya fue aprobada');
			}else if(document.getElementsByName('TPendiente')[0].value == '2'){
				alert('La transaccion no requiere aprobacion');
			}else{
				document.getElementsByName('procesarInciComo')[0].value=t;
				setWhatToDo('ProcessINCI');
			}
		}
		return false;
	}
	
</script>