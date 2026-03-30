<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TipoCaja" default="Tipo de Caja" returnvariable="LB_TipoCaja"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Codigo" default="Código" returnvariable="LB_Codigo"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" default="Descripción" returnvariable="LB_Descripcion"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Estado" default="Estado" returnvariable="LB_Estado"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CentroFuncional" default="Centro Funcional" returnvariable="LB_CentroFuncional"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Responsable" default="Responsanble" returnvariable="LB_Responsable"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Moneda" default="Moneda" returnvariable="LB_Moneda"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CuentaFinanciera" default="Cuenta Financiera" returnvariable="LB_CuentaFinanciera"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CuentaTransitoriaRecepcionEfectivo" default="Cuenta Transitoria de Recepci&oacute;n de Efectivo" returnvariable="LB_CuentaTransitoriaRecepcionEfectivo"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoAsignado" default="Monto asignado" returnvariable="LB_MontoAsignado"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_PorcentajeMaximoSolicitud" default="% M&aacute;ximo de solicitud" returnvariable="LB_PorcentajeMaximoSolicitud"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_PorcentajeDeConsumoReintregro" default="% De consumo para reintegro" returnvariable="LB_PorcentajeDeConsumoReintregro"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_PorcentajeMinimoSaldoCaja" default="% Minimo de saldo en caja" returnvariable="LB_PorcentajeMinimoSaldoCaja"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TesoreriaPago" default="Tesorer&iacute;a de pago" returnvariable="LB_TesoreriaPago"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_UnidadRedondeoReintegros" default="Unidad de redondeo para Reintegros" returnvariable="LB_UnidadRedondeoReintegros"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_AbrirCaja" default="Abrir Caja" returnvariable="BTN_AbrirCaja"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Limpiar" default="Limpiar" returnvariable="BTN_Limpiar"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Nuevo" default="Nuevo" returnvariable="BTN_Nuevo"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Modificar" default="Modificar" returnvariable="BTN_Modificar"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Transacciones" default="Transacciones" returnvariable="BTN_Transacciones"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Regresar" default="Regresar" returnvariable="BTN_Regresar"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_CentrosFuncional" default="Centros Funcional" returnvariable="BTN_CentrosFuncional"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "CHK_SuspenderOperacionCaja" default="Suspender operaci&oacute;n de caja" returnvariable="CHK_SuspenderOperacionCaja"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CajaChicaComprasMenores" default="Caja Chica para Compras menores" returnvariable="LB_CajaChicaComprasMenores"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CajaEspecialEntradaSalidaEfectivo" default="Caja Especial de Entrada y Salida de Efectivo"returnvariable="LB_CajaEspecialEntradaSalidaEfectivo"  xmlfile="CCHapertura_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CajaExterna" default="Caja Externa (No participa en Gasto Empleado)" returnvariable="LB_CajaExterna"  xmlfile="CCHapertura_form.xml"> 


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
			a.CFcuenta, CFcuentaRecepcion,
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
			a.CCHunidadReintegro,
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
				<strong>#LB_TipoCaja#:</strong>			
			</td>
			<td width="54%">
			<cfif modo eq 'CAMBIO' AND rsForm.CCHestado NEQ 'INACTIVA'>
				<input type="hidden" name="CCHtipo" value="#rsForm.CCHtipo#" />
				<cfif rsForm.CCHtipo EQ 1>
					<strong>#UCase(LB_CajaChicaComprasMenores)#</strong>
				<cfelse>
					<strong>#UCase(LB_CajaEspecialEntradaSalidaEfectivo)#</strong>
				</cfif>
			<cfelse>
				<select name="CCHtipo">
					<option value="1" <cfif modo eq 'CAMBIO' and rsForm.CCHtipo EQ 1>selected</cfif>>#LB_CajaChicaComprasMenores#</option>
					<option value="2" <cfif modo eq 'CAMBIO' and rsForm.CCHtipo EQ 2>selected</cfif>>#LB_CajaEspecialEntradaSalidaEfectivo#</option>
					<option value="3" <cfif modo eq 'CAMBIO' and rsForm.CCHtipo EQ 3>selected</cfif>>#LB_CajaExterna#</option>
				</select>
			</cfif>
		    </td>
		</tr>

		<tr>
			<td width="46%" align="right">
				<strong>#LB_Codigo#:</strong>			
			</td>
			<td width="54%">
				<input type="text" name="codigo" maxlength="20" size="12" <cfif modo eq 'CAMBIO'> value="#rsForm.CCHcodigo#" disabled="disabled" </cfif>>
		    </td>
		</tr>
		
		<tr>
			<td width="46%" align="right">
				<strong>#LB_Descripcion#</strong>			
			</td>
			<td>
				<input type="text" name="descrip" maxlength="150" size="60" <cfif modo eq 'CAMBIO'> value="#rsForm.CCHdescripcion#" </cfif> />
			</td>
		</tr>
		

		<cfif modo eq 'CAMBIO'>
		<tr>
			<td width="46%" align="right">
				<strong>#LB_Estado#:</strong>			
			</td>
			<td width="54%">
				<strong>#rsForm.CCHestado#</strong>
		    </td>
		</tr>
		</cfif>
				
		<cfif (isdefined ('form.CCHid') and len(trim(form.CCHid)) eq 0) or not isdefined ('form.CCHid')>
		<tr>
			<td width="46%" align="right">
				<strong>#LB_CentroFuncional#:</strong>			
			</td>
			<td>
						<cf_rhcfuncional form="form1" tabindex="1" >
			</td>
		</tr>
		</cfif>
		
		
		<tr>
			<td width="46%" align="right">
				<strong>#LB_Responsable#:</strong>			
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
				<strong>#LB_Moneda#:</strong>			
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
				<strong>#LB_CuentaFinanciera#:</strong>				
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

	<cfif modo EQ "ALTA" OR rsForm.CCHtipo NEQ 1 OR rsForm.CCHestado EQ 'INACTIVA'>
		<tr>
			<td width="46%" align="right">
				<strong>#LB_CuentaTransitoriaRecepcionEfectivo#:</strong>				
			</td>
			<td>
				<cfif modo NEQ "ALTA" and rsForm.CFcuentaRecepcion NEQ "">
					<cfquery name="rsCuenta" datasource="#session.dsn#">
						select CFcuenta,Cmayor,Ccuenta,CFdescripcion,CFformato from CFinanciera where CFcuenta=#rsForm.CFcuentaRecepcion#
					</cfquery>
					<input type="text" value="#trim(rsCuenta.CFformato)# #rsCuenta.CFdescripcion#" disabled="disabled" size="65" />
					<input type="hidden" name="CFcuentaRecepcion" value="#rsCuenta.CFcuenta#" />
				<cfelse>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" tabindex="1"
					cmayor="cmayor2" CFcuenta="CFcuentaRecepcion" ccuenta="Ccuenta2" Cdescripcion="Cdescripcion2" cformato="Cformato2" form="form1"> 
				</cfif>		
			</td>
		</tr>
	</cfif>
		<tr>
			<td width="46%" align="right">
				<strong>#LB_MontoAsignado#:</strong>			
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
				<strong>#LB_PorcentajeMaximoSolicitud#:</strong>			
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
				<strong>#LB_PorcentajeDeConsumoReintregro#:</strong>			
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
				<strong>#LB_PorcentajeMinimoSaldoCaja#:</strong>			
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
		       <strong>#LB_TesoreriaPago#:</strong>
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
		<tr>
			<td width="46%" align="right">
				<strong>#LB_UnidadRedondeoReintegros#:</strong>			
			</td>
			<cfif modo eq 'CAMBIO'>
				<td>
					<cf_inputNumber name="CCHunidadReintegro" value="#rsForm.CCHunidadReintegro#" enteros="4" decimales="2" readonly="#rsForm.CCHtipo NEQ 2#">
				</td>
			<cfelse>
				<td>
					<cf_inputNumber name="CCHunidadReintegro" value="" enteros="4" decimales="2">
				</td>
			</cfif>
		</tr>
		<cfif modo neq 'Alta'>
		<tr align="center">
			<td nowrap="nowrap" colspan="2"><input type="checkbox" name="suspender" <cfif rsForm.CCHestado eq 'CERRADA' OR rsForm.CCHestado eq 'SUSPENDIDA'> checked="checked" </cfif> />
              <strong>#CHK_SuspenderOperacionCaja#</strong></td>	
		</tr>
		</cfif>
		<cfif modo eq 'Alta'>
		<tr>
		<td colspan="3" align="center">
        	<cf_translate key = MSG_MontoMaximo xmlfile = "CCHapertura_form.xml"> 
			El monto m&aacute;ximo, al igual que el porcentaje m&aacute;ximo y el porcentaje minimo son sugeridos por el sistema, dichos valores se pueden modificar. Pero el monto asignado no puede
			exceder el monto maximo mencionado.</cf_translate>
		</td>
		</tr>
		</cfif>
		<tr>
			<cfif modo eq 'ALTA'>
				<td colspan="3" align="center">
					<input type="submit" name="Agregar" value="#BTN_AbrirCaja#" onClick="javascript: habilitarValidacion();"/>
					<input type="submit" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript: Limpiar(); "/>
					<input type="submit" name="Regresar" value="#BTN_Regresar#"onClick="javascript: inhabilitarValidacion(); " />
				</td>
			<cfelse>
				<td colspan="4" align="center">
					<input type="submit" name="Nuevo" value="#BTN_Nuevo#" />
					<input type="submit" name="Modificar" value="#BTN_Modificar#" onClick="javascript: habilitarValidacion(); "/>
					<!---<input type="submit" name="Eliminar" value="Eliminar" />--->
					<input type="submit" name="Transacciones" value="#BTN_Transacciones#" />
					<input type="submit" name="cFuncional" value="#BTN_CentrosFuncional#" />				
					<input type="submit" name="Regresar" value="#BTN_Regresar#" />
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

	function habilitarValidacion() 
	{
		var LvarCCHtipo = document.form1.CCHtipo.value;
	<cfif modo eq 'ALTA'>
		<cfoutput>
		objForm.CFid.required = true;	
		objForm.CFid.description = "#LB_Centrofuncional#";
		objForm.CFcuenta.required = true;	
		objForm.CFcuenta.description = "#LB_CuentaFinanciera#";
		objForm.CFcuentaRecepcion.description = "Cuenta Financiera Transitoria";
		</cfoutput>
	<cfelse>
		objForm.CFformato.required=true;
		objForm.CFformato.description = "<cfoutput>#LB_CuentaFinanciera#</cfoutput>";
	</cfif>
		objForm.codigo.required = true;	
		objForm.descrip.required = true;		
		objForm.DEid.required = true;	

		if (LvarCCHtipo == 3)
		{
			objForm.asignado.required=false;
			objForm.maximo.required=false;
			objForm.minimo.required=false;
			objForm.TESidCCH.required=false;
		<cfif modo eq 'ALTA'>
			objForm.CFcuenta.required = false;	
			objForm.CFcuentaRecepcion.required = true;	
		</cfif>
		}
		else
		{
			objForm.CFcuentaRecepcion.required = (LvarCCHtipo == 2);
			objForm.asignado.required=true;
			objForm.maximo.required=true;
			objForm.minimo.required=true;
			objForm.TESidCCH.required=true;
		}
		<cfoutput>
		objForm.codigo.description = "#LB_Codigo#";
		objForm.descrip.description = "#LB_Descripcion#";
		objForm.DEid.description = "#LB_Responsable#";
		objForm.asignado.description = "#LB_MontoAsignado#";
		objForm.maximo.description = "#LB_PorcentajeMaximoSolicitud#";
		objForm.minimo.description = "#LB_PorcentajeDeConsumoReintregro#";
		objForm.TESidCCH.description = "#LB_TesoreriaPago#";
		</cfoutput>
	}
</script>

<script language="javascript" type="text/javascript">
	var GvarValidar = false;
	function Validar(){
		if (objForm.codigo.required == true)
		{
			var LvarLinea = "Confirme los datos de la Caja " + document.form1.codigo.value + ":";
			LvarLinea += "\n- TIPO:\t" + document.form1.CCHtipo.options[document.form1.CCHtipo.selectedIndex].text;
			LvarLinea += "\n\ten " + document.form1.McodigoOri.options[document.form1.McodigoOri.selectedIndex].text;
			LvarLinea += "\n- Monto:\t" + document.form1.asignado.value;
			
			if (!confirm(LvarLinea)) return false
		}
		document.form1.McodigoOri.disabled=false;
		return true;
	}
</script>
