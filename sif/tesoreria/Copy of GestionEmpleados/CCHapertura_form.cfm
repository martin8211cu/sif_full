<form name="form1" method="post" action="CCHapertura_sql.cfm" onsubmit="javascript:return Validar()">
<cfif isdefined ('url.CCHid') and not isdefined ('form.CCHid')>
	<cfset form.CCHid = #url.CCHid#>
</cfif>

<cfif isdefined ('form.CCHid') and len(trim(form.CCHid)) gt 0>

<cfoutput>
<input type="hidden" name="CCHid" value="#form.CCHid#" />
</cfoutput>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 
			a.CCHtipo,
			a.CFcuenta,
			a.Ecodigo,
			a.Mcodigo,
			a.CCHcodigo,
			a.CCHdescripcion,
			a.CCHestado,
			a.CCHmax,
			a.CCHmin,
			a.CCHminSaldo,
			a.CCHmontoA,
			a.TESidCCH,
			a.CCHtipo,
			<!---cambiarlo por un inner--->
			(select DEnombre#LvarCNCT#' '#LvarCNCT#DEapellido1#LvarCNCT#' '#LvarCNCT#DEapellido2 from DatosEmpleado where DEid=a.CCHresponsable) as CCHresponsable1
		from CCHica a
		where CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCHid#">
	</cfquery>

	<cfset modo='CAMBIO'>
<cfelse>
	<cfquery name="rsAlta" datasource="#session.dsn#">
		select CCHCmonto, CCHCmax, CCHCmin 
			from CCHconfig 
		where 
		Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset modo='ALTA'>

</cfif>
<table width="100%" border="0">
	<cfoutput>
		<tr>
			<td width="46%" align="right">
				<strong>Tipo de Caja:</strong>			
			</td>
			<td width="54%">
			<cfif modo eq 'CAMBIO' AND rsForm.CCHestado NEQ 'INACTIVA'>
				<input type="hidden" name="CCHtipo" value="#rsForm.CCHtipo#" />
				<cfif rsForm.CCHtipo EQ 1>
					<strong>CAJA CHICA PARA COMPRAS MENORES</strong>
				<cfelse>
					<strong>CAJA ESPECIAL PARA ENTRADA Y SALIDA DE EFECTIVO</strong>
				</cfif>
			<cfelse>
				<select name="CCHtipo">
					<option value="1" <cfif modo eq 'CAMBIO' and rsForm.CCHtipo EQ 1>selected</cfif>>Caja Chica para Compras menores</option>
					<option value="2" <cfif modo eq 'CAMBIO' and rsForm.CCHtipo EQ 2>selected</cfif>>Caja Especial de Entrada y Salida de Efectivo</option>
				</select>
			</cfif>
		    </td>
		</tr>

		<tr>
			<td width="46%" align="right">
				<strong>C&oacute;digo:</strong>			
			</td>
			<td width="54%">
				<input type="text" name="codigo" maxlength="50"  <cfif modo eq 'CAMBIO'> value="#rsForm.CCHcodigo#" disabled="disabled" </cfif>>
		    </td>
		</tr>
		
		<tr>
			<td width="46%" align="right">
				<strong>Descripci&oacute;n</strong>			
			</td>
			<td>
				<input type="text" name="descrip" maxlength="150"  <cfif modo eq 'CAMBIO'> value="#rsForm.CCHdescripcion#" </cfif> />
			</td>
		</tr>
		

		<cfif modo eq 'CAMBIO'>
		<tr>
			<td width="46%" align="right">
				<strong>Estado:</strong>			
			</td>
			<td width="54%">
				<strong>#rsForm.CCHestado#</strong>
		    </td>
		</tr>
		</cfif>
				
		<cfif (isdefined ('form.CCHid') and len(trim(form.CCHid)) eq 0) or not isdefined ('form.CCHid')>
		<tr>
			<td width="46%" align="right">
				<strong>Centro Funcional:</strong>			
			</td>
			<td>
						<cf_rhcfuncional form="form1" tabindex="1" >
			</td>
		</tr>
		</cfif>
		
		
		<tr>
			<td width="46%" align="right">
				<strong>Responsable:</strong>			
			</td>
			<td>
				<cfif modo eq "CAMBIO">		
					<input type="text" value="#rsForm.CCHresponsable1#" disabled="disabled" size="65" />
					<!---<cf_rhempleados form="form1" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2" idempleado="#rsForm.CCHresponsable#" readOnly="yes">--->
				<cfelse>
					<cf_rhempleados form="form1" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2" >
				</cfif>			
			</td>
		</tr>
		
		<tr>
			<td width="46%" align="right">
				<strong>Moneda:</strong>			
			</td>
			<td>
				<cfif  modo NEQ 'ALTA'>
					<cfquery name="rsMoneda" datasource="#session.DSN#">
						select Mcodigo, Mnombre
						from Monedas
						where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
						and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
					<cfset LvarMnombreSP = rsMoneda.Mnombre>					
					<cf_sifmonedas  FechaSugTC="#LSDateformat(Now(),'DD/MM/YYYY')#" form="form1" Mcodigo="McodigoOri" query="#rsMoneda#" tabindex="1" valueTC="#rsForm.Mcodigo#"  habilita="N">
				<cfelse>
					<cf_sifmonedas  FechaSugTC="#LSDateformat(Now(),'DD/MM/YYYY')#" form="form1" Mcodigo="McodigoOri"  tabindex="1">
				</cfif>   
			</td>
		</tr>
		
		<tr>
			<td width="46%" align="right">
				<strong>Cuenta Financiera:</strong>				
			</td>
			<td>
				<cfif modo NEQ "ALTA">
					<cfquery name="rsCuenta" datasource="#session.dsn#">
						select CFcuenta,Cmayor,Ccuenta,CFdescripcion,CFformato from CFinanciera where CFcuenta=#rsForm.CFcuenta#
					</cfquery>
					<!---<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#rsCuenta#" auxiliares="N" movimiento="S" tabindex="1"
					cmayor="cmayor" ccuenta="Ccuenta" cdescripcion="Cfdescripcion" cformato="Cformato" form="form1"  readOnly="yes"> 
					<input type="hidden" value="#rsCuenta.CFcuenta#" name="CFcuenta" />--->
					<input type="text" value="#trim(rsCuenta.CFformato)# #rsCuenta.CFdescripcion#" disabled="disabled" size="65" />
				<cfelse>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" tabindex="1"
					cmayor="cmayor" ccuenta="Ccuenta" Cdescripcion="Cdescripcion1" cformato="Cformato" form="form1"> 
				</cfif>		
			</td>
		</tr>
		
		<tr>
			<td width="46%" align="right">
				<strong>Monto asignado:</strong>			
			</td>
			<cfif modo eq 'CAMBIO'>
				<td>
					<cf_inputNumber name="asignado" size="20" value="#rsForm.CCHmontoA#" enteros="13" decimales="2"  readOnly="yes">
				</td>
			<cfelse>
				<td>
					<cf_inputNumber name="asignado" size="20" value="#rsAlta.CCHCmonto#" enteros="13" decimales="2" >
				</td>
			</cfif>
		</tr>
		
		<tr>
			<td width="46%" align="right">
				<strong>% M&aacute;ximo de solicitud:</strong>			
			</td>
			<cfif modo eq 'CAMBIO'>
				<td>
					<cf_inputNumber name="maximo" size="4" value="#rsForm.CCHmax#" enteros="2" decimales="0" >
				</td>
			<cfelse>
				<td>
					<cf_inputNumber name="maximo" size="4" value="#rsAlta.CCHCmax#" enteros="2" decimales="0">
				</td>
			</cfif>
		</tr>
		
		<tr>
			<td width="46%" align="right">
				<strong>% De consumo para reintegro:</strong>			
			</td>
			<cfif modo eq 'CAMBIO'>
				<td>
					<cf_inputNumber name="minimo" size="4" value="#rsForm.CCHmin#" enteros="2" decimales="0">
				</td>
			<cfelse>
				<td>
					<cf_inputNumber name="minimo" size="4" value="#rsAlta.CCHCmin#" enteros="2" decimales="0">
				</td>
			</cfif>
		</tr>
		<tr>
			<td width="46%" align="right">
				<strong>% minimo de saldo en Caja:</strong>			
			</td>
			<cfif modo eq 'CAMBIO'>
				<td>
					<cf_inputNumber name="minimoSaldo" size="4" value="#rsForm.CCHminSaldo#" enteros="2" decimales="0">
				</td>
			<cfelse>
				<td>
					<cf_inputNumber name="minimoSaldo" size="4" value="0" enteros="2" decimales="0">
				</td>
			</cfif>
		</tr>
		<tr>
		  <td width="46%" align="right">
		       <strong>Tesorería de pago:</strong>
		  </td>
		  
		    <cfquery name="rsTesorerias" datasource="#session.dsn#">
				Select 	TESid, 
						TEScodigo,
						TESdescripcion as TESdescripcion 						
				  from Tesoreria 					
				 where CEcodigo	= #session.CEcodigo#				
			</cfquery>
			<td>
				<select name="TESidCCH" id="TESidCCH">
				  <cfloop query="rsTesorerias">
					<option value="#rsTesorerias.TESid#" <cfif modo eq 'cambio' and #rsForm.TESidCCH# eq #rsTesorerias.TESid#> selected="selected"</cfif> >#rsTesorerias.TEScodigo# - #rsTesorerias.TESdescripcion# </option>
				  </cfloop>				
				</select>
			</td>
		  </td>
		</tr>
		<cfif modo neq 'Alta'>
		<tr align="center">
			<td nowrap="nowrap" colspan="2"><input type="checkbox" name="suspender" <cfif rsForm.CCHestado eq 'CERRADA' OR rsForm.CCHestado eq 'SUSPENDIDA'> checked="checked" </cfif> />
              <strong> Suspender operaci&oacute;n de caja </strong></td>	
		</tr>
		</cfif>
		<cfif modo eq 'Alta'>
		<tr>
		<td colspan="3" align="center">
			El monto m&aacute;ximo, al igual que el porcentaje m&aacute;ximo y el porcentaje minimo son sugeridos por el sistema, dichos valores se pueden modificar. Pero el monto asignado no puede
			exceder el monto maximo mencionado.
		</td>
		</tr>
		</cfif>
		<tr>
			<cfif modo eq 'ALTA'>
				<td colspan="3" align="center">
					<input type="submit" name="Agregar" value="Abrir Caja" onClick="javascript: habilitarValidacion(); "/>
					<input type="submit" name="Limpiar" value="Limpiar" onClick="javascript: Limpiar(); "/>
					<input type="submit" name="Regresar" value="Regresar"onClick="javascript: inhabilitarValidacion(); " />
				</td>
			<cfelse>
				<td colspan="4" align="center">
					<input type="submit" name="Nuevo" value="Nuevo" />
					<input type="submit" name="Modificar" value="Modificar" onClick="javascript: habilitarValidacion(); "/>
					<!---<input type="submit" name="Eliminar" value="Eliminar" />--->
					<input type="submit" name="Transacciones" value="Transacciones" />
					<input type="submit" name="cFuncional" value="Centros Funcional" />				
					<input type="submit" name="Regresar" value="Regresar" />
				</td>

			</cfif>
		</tr>
		<cfif isdefined ('url.Transac')>
			<cfinclude template="CCHtransacciones.cfm">
		</cfif>
	</cfoutput>
  </table>
</form>


<cfif isdefined ('url.Cfunc') or isdefined ('form.cfid')>
	<cfinclude template="CCHcentroF_form.cfm">
</cfif>

<!---Validaciones--->

<cf_qforms>


<script language="javascript" type="text/javascript">

	function inhabilitarValidacion() {
	<cfif modo eq 'ALTA'>
		objForm.codigo.required = false;	
		objForm.descrip.required = false;			
		objForm.CFcodigo.required = false;	
		objForm.DEid.required = false;	
		objForm.asignado.required=false;
		objForm.maximo.required=false;
		objForm.minimo.required=false;
		objForm.Cformato.required=false;
<!---		objForm.CFcuenta.required=false;
--->		objForm.Cfdescripcion.required=false;
	<cfelse>
	objForm.codigo.required = false;	
		objForm.descrip.required = false;			
		objForm.DEid.required = false;	
		objForm.asignado.required=false;
		objForm.maximo.required=false;
		objForm.minimo.required=false;
		objForm.Cformato.required=false;
<!---	objForm.CFcuenta.required=false;
--->	objForm.Cfdescripcion.required=false;
        objForm.TESidCCH.required=false;
	</cfif>
	}

	function habilitarValidacion() {
	<cfif modo eq 'ALTA'>
		objForm.codigo.required = true;	
		objForm.descrip.required = true;		
		objForm.CFid.required = true;	
		objForm.DEid.required = true;	
		objForm.asignado.required=true;
		objForm.maximo.required=true;
		objForm.minimo.required=true;
		objForm.CFcuenta.required=true;
		objForm.Cformato.required=true;
		objForm.TESidCCH.required=true;
	<cfelse>
		objForm.codigo.required = true;	
		objForm.descrip.required = true;			
		objForm.DEid.required = true;	
		objForm.asignado.required=true;
		objForm.maximo.required=true;
		objForm.minimo.required=true;
		objForm.Cformato.required=true;
		objForm.TESidCCH.required=true;
	</cfif>
	
	<cfif modo eq 'ALTA'>
	objForm.codigo.description = "Código";
	objForm.descrip.description = "Descripción de la caja";
	objForm.CFid.description = "Centro Funcional";
	objForm.CFcuenta.description = "Cuenta Financiera";
	objForm.DEid.description = "Responsable de la caja";
	objForm.asignado.description = "Monto Asignado";
	objForm.maximo.description = "% Máximo de Solicitud";
	objForm.minimo.description = "% De consumo para reintegro";
	objForm.Cformato.description = "el formato de la Cuenta Financiera";
	objForm.TESidCCH.description = "la tesorería de pago para caja chica";
	<cfelse>
	objForm.codigo.description = "Código";
	objForm.descrip.description = "Descripción de la caja";
	objForm.DEid.description = "Responsable de la caja";
	objForm.asignado.description = "Monto Asignado";
	objForm.maximo.description = "% Máximo de Solicitud";
	objForm.minimo.description = "% De consumo para reintegro";
	objForm.Cformato.description = "el formato de la Cuenta Financiera";
	objForm.TESidCCH.description = "la tesorería de pago para caja chica";
	</cfif>
	}
</script>

<script language="javascript" type="text/javascript">
	function Validar(){
		document.form1.McodigoOri.disabled=false;
		return true;
	}

</script>
