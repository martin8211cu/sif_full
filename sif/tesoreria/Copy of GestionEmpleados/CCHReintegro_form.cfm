<form name="form1" action="CCHReintegro_sql.cfm" method="post" onSubmit="return Validar(this);"><!--- --->
<input type="hidden" name="modo" id="modo"  value="#modo#" />
	<cfif isdefined ('url.CCHTid') and (not isdefined('form.CCHTid') or len(trim(form.CCHTid)) eq 0)>
		<cfset form.CCHTid=#url.CCHTid#>
	</cfif>
	
	<cfif isdefined ('url.CCHid') and (not isdefined('form.CCHid') or len(trim(form.CCHid)) eq 0)>
		<cfset form.CCHid=#url.CCHid#>
	</cfif>
	
	<cfif isdefined('form.CCHTid') and len(trim(form.CCHTid)) gt 0>
		<cfset modo='CAMBIO'>
	<cfelse>
		<cfset modo='ALTA'>
	</cfif>
	
	<cfif isdefined ('form.CCHid') and len(trim(form.CCHid)) gt 0>
		<cfquery name="rsCFid" datasource="#session.dsn#">
			select CFid from CCHica where CCHid= #form.CCHid# and Ecodigo=#session.Ecodigo#
		</cfquery>
		
		<cfquery name="rsSPaprobador" datasource="#session.dsn#">
			Select count(1) as cantidad
			from TESusuarioSP
			where CFid = #rsCFid.CFid#
				and Usucodigo  = #session.Usucodigo#
				and TESUSPaprobador = 1
		</cfquery>
	</cfif>
	
	<cfif modo eq 'CAMBIO'>
		<cfquery name="rsForm" datasource="#session.dsn#">
			select 
				tp.CCHTid,
				tp.Ecodigo,
				tp.Mcodigo,
				tp.CCHTestado,
				tp.CCHTmonto,
				tp.CCHTtipo,
				tp.CCHid,
				tp.CCHcod,
				tp.CCHTmsj,
				CCHTdescripcion,
				(select Miso4217 from Monedas where Mcodigo=tp.Mcodigo) as Moneda,
				BMfecha
			from
				CCHTransaccionesProceso tp
			where 
				Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and CCHTid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCHTid#">
		</cfquery>
		
		<cfquery name="rsBus" datasource="#session.dsn#">
			select sum(CCHTAmonto) as disponible from CCHTransaccionesAplicadas where CCHTtipo='GASTO' and CCHTAreintegro=#form.CCHTid#
		</cfquery>
	</cfif>
	
	<table width="100%" align="center">
	<cfoutput>
	<input type="hidden" name="CCHTid" <cfif modo eq 'CAMBIO'> value='#form.CCHTid#'</cfif>/>
	
	<!---<input type="hidden" name="CCHid"  value='#form.CCHid#'/>--->
		<tr>
			<td align="right">
				<strong>Num.Transacci&oacute;n:</strong>
			</td>
			<td>
				<cfif modo eq 'ALTA'>
					-- Nueva Solicitud de Transacci&oacute;n --
				<cfelse>
					<strong>#rsForm.CCHcod#</strong>
					<input type="hidden" name="CCHcod" value="#rsForm.CCHcod#" />
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Tipo de Solicitud:</strong>
			</td>
			<td>
				<strong>Reintegro</strong>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Caja:</strong>
			</td>
			<td>
				<cfif modo eq 'ALTA'>
					<cf_conlisCajas>
				<cfelseif isdefined ('url.Aprobar') and len(trim(url.Aprobar)) gt 0>
					<cf_conlisCajas value="#rsForm.CCHid#" lectu="yes">
				<cfelse>
					<cf_conlisCajas value="#rsForm.CCHid#" lectu="yes">
				</cfif>
			</td>
		</tr>
		
		<tr>
			<td align="right">
				<strong>Descripci&oacute;n:</strong>
			</td>
			<td>
				<cfif modo eq 'ALTA'>
					<input type="text" name="descrip" maxlength="150" size="50">
				<cfelse>
					<input type="text" name="descrip" maxlength="150" size="50" value="#rsForm.CCHTdescripcion#" <cfif rsForm.CCHTestado NEQ 'EN PROCESO'>disabled="disabled" </cfif>>
				</cfif>
			</td>
		</tr>
		<tr>
		<cfif modo neq 'ALTA'>
			<td align="right">
				<strong>Monto:</strong>
			</td>
			<td>
				<cf_inputNumber name="montoA" size="20" value="#rsBus.disponible#" enteros="13" decimales="2" maxlenght="15" readOnly="yes">				
			</td>
		</tr>
		</cfif>
	<!---	<cfif modo eq 'CAMBIO'>
			<cfif isdefined('url.Apro') or (isdefined ('rsSPaprobador') and rsSPaprobador.cantidad gt 0) and rsForm.CCHTestado eq 'EN PROCESO'>
				<tr>			
					<td align="right">
						<strong>Monto Aprobado:</strong>
					</td>
					<td>
						<cf_inputNumber name="montoAp" size="20" value="#rsForm.CCHTmonto#" enteros="13" decimales="2" maxlenght="15">
					</td>
				</tr>
			</cfif>
			
			<cfif isdefined('url.Aprobar') and len(trim(url.Aprobar)) gt 0>
				<tr>			
					<td align="right">
						<strong>Monto Aprobado:</strong>
					</td>
					<td>
						<cf_inputNumber name="montoAp" size="20" value="#rsForm.CCHTmonto#" enteros="13" decimales="2" maxlenght="15">
					</td>
				</tr>
			</cfif>		
		</cfif>--->
		
		<cfif isdefined('url.Aprobar') and len(trim(url.Aprobar)) gt 0>
		<tr>
			<td align="right">
				<strong>Motivo de Rechazo:</strong>
			</td>
			<td>
				<input type="text" maxlength="150" size="75" name="motivo"  />
			</td>
		</tr>
		</cfif>
		<cfif modo eq 'CAMBIO' and rsForm.CCHTestado eq 'RECHAZADO'>
		<tr>
			<td align="right">
				<strong>Estado:&nbsp;</strong>
			</td>
			<td>	
				<font color="FF0000">RECHAZADA</font>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Motivo de Rechazo:</strong>
			</td>
			<td>
				#rsForm.CCHTmsj#
			</td>
		</tr>
		</cfif>
		<tr>
			<cfif modo eq 'ALTA'>
				<td colspan="3" align="center">
					<input type="submit" name="Agregar" value="Agregar" onClick="javascript: habilitarValidacion(); "/><!---onClick="javascript: habilitarValidacion(); "--->
					<input type="submit" name="Limpiar" value="Limpiar" onClick="javascript: inhabilitarValidacion(); "/>
					<input type="submit" name="Regresar" value="Regresar" onClick="javascript: inhabilitarValidacion(); "/>
				</td>
			<cfelseif modo eq 'CAMBIO' and rsForm.CCHTestado eq 'EN PROCESO'>
				<td colspan="4" align="center">
					<input type="submit" name="Nuevo" value="Nuevo" />
					<input type="submit" name="Modificar" value="Modificar" onClick="javascript: habilitarValidacion(); "/>
					<input type="submit" name="Eliminar" value="Eliminar" onClick="javascript: inhabilitarValidacion(); "/>
					<cfif modo eq 'CAMBIO' and rsForm.CCHTestado eq 'EN PROCESO'>
					<input type="submit" name="Enviar" value="Enviar a Aprobar" onClick="javascript: habilitarValidacion(); "/></br>
					</cfif>
					<cfif isdefined('url.Apro') or (isdefined ('rsSPaprobador') and rsSPaprobador.cantidad gt 0) and rsForm.CCHTestado eq 'EN PROCESO'>
						<input type="submit" name="Aprobar" value="Aprobar" onClick="javascript: habilitarValidacion(); "/>
					</cfif>
					<input type="submit" name="Regresar" value="Regresar" onClick="javascript: inhabilitarValidacion(); "/>
				</td>
			<cfelseif isdefined ('url.Aprobar') and len(trim(url.Aprobar)) gt 0>
				<td colspan="4" align="center">
					<input type="submit" name="Aprobar" value="Aprobar" onClick="javascript: habilitarValidacion(); "/>
					<input type="submit" name="Rechazar" value="Rechazar" onClick="javascript: habilitarValidacion(); "/>
					<input type="submit" name="Regresar1" value="Regresar" onClick="javascript: inhabilitarValidacion(); "/>
				</td>
			<cfelse>
				<td colspan="4" align="center">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: inhabilitarValidacion(); "/>
					<input type="submit" name="Regresar" value="Regresar" onClick="javascript: inhabilitarValidacion(); "/>
				</td>
			</cfif>
		</tr>
	</cfoutput>
	</form>
	<cfif modo eq 'CAMBIO'>
		<tr>
			<td colspan="2">
				<cfinclude template="CCHReintegro_detalles.cfm">
			</td>
		</tr>
	</cfif>
	</table>


<cf_qforms>
<script language="javascript" type="text/javascript">

	function inhabilitarValidacion() {
		objForm.CCHcodigo.required = false;	
		objForm.descrip.required = false;	
		
	}

	function habilitarValidacion() {
		objForm.CCHcodigo.required = true;
		objForm.descrip.required = true;		
		
	}
	objForm.descrip.description = "Descripcion";
	objForm.CCHcodigo.description = "Caja Chica";		
	
	
	
</script>

<script language="javascript" type="text/javascript">
	function Validar(){		
	<!---alert (!btnSelected);
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Eliminar',document.form1) && !btnSelected('IrLista',document.Regresar) && !btnSelected('IrLista',document.Regresar1)){
		if (document.form1.montoAp.value!=''){
			if (document.form1.montoAp.value<=0){
			alert('El monto solicitado debe ser mayor de cero');
			return false;
		}
		}
		if (document.form1.montoA.value==''){
			alert ('-Debe de indicar un monto');
			return false;
		}
		document.form1.montoA.disabled=true;
		document.form1.descrip.disabled=false;
		return true;
	}
	}
	
	function Habilitar(){
		if (document.form1.CCHid.value==''){
		alert('No se puede escoger una transacción hasta que defina la caja chica');
		document.form1.CCHcodigo.focus();
		}
	}
	function funcCambiaValores(){
	 document.form1.montoA.value='';
	 document.form1.descrip.value=''--->
	}
</script>
