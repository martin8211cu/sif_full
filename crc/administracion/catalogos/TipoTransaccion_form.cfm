
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

<cfif isdefined("url.id") and Len("url.id") gt 0>
	<cfset form.id = url.id >
</cfif>

<cfif isdefined("Session.Ecodigo") and isdefined("Form.id") and not isDefined("Form.Nuevo")>
	<cfset modo="CAMBIO">
</cfif>

<cfif modo eq "CAMBIO">
	<cfquery name="rsEstatu" datasource="#Session.DSN#">
		SELECT id,codigo,descripcion,tipoMov,afectaSaldo,afectaInteres,afectaCompras,afectaPagos,afectaCondonaciones,afectaGastoCobranza,afectaSeguro
		FROM CRCTipoTransaccion
		WHERE Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
	</cfquery>
</cfif>
 
<SCRIPT LANGUAGE="JavaScript">
 
	function soloNumeros(e)
	{
		var keynum = window.event ? window.event.keyCode : e.which;
		if ((keynum == 8) || (keynum == 0))
		return true;
		return /\d/.test(String.fromCharCode(keynum));
	}

</SCRIPT>

<script language="JavaScript">

	function deshabilitarValidacion(){
		objForm.codigo.required = false;
		objForm.Descripcion.required = false;
	}

</script>
<cfoutput>


<!---Redireccion ConfiguracionParametros_sql.cfm --->
<form method="post" name="form1" action="TipoTransaccion_sql.cfm">
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr valign="baseline">
			<td nowrap align="right">#LB_Codigo#:&nbsp;</td>
			<td> 
				<input type="text" name="codigo" tabindex="1" style="text-transform:uppercase" required
					value="<cfif modo NEQ "ALTA">#rsEstatu.codigo#</cfif>"
					size="10" maxlength="2" onfocus="javascript:this.select();" <cfif isdefined("rsEstatu.codigo") and #rsEstatu.codigo# neq ""> readonly </cfif>>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_Descripcion#:&nbsp;</td>
			<td>
				<input type="text" name="Descripcion" tabindex="1" required
				value="<cfif modo NEQ "ALTA">#rsEstatu.descripcion#</cfif>"
				size="30" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr>
			<td nowrap align="right">#LB_TipoMov#:&nbsp;</td>
			<td> 
				<cfset loc.tipoMov = "">  
				<cfif modo NEQ 'ALTA'> <cfset loc.tipoMov = "#rsEstatu.tipoMov#"></cfif>
				<cf_listaValores name="tipoMov" valor="#loc.tipoMov#"  codigo="LV_TIPO_MOVIMIENTO" tabindex="1">   
			</td> 
			<!---
			<td>
				<label><input type="radio" value="D" name="tipoMov" <cftry><cfif rsEstatu.tipoMov eq 'D'>checked="checked"</cfif><cfcatch></cfcatch></cftry>> D&eacutebito &emsp;</label>
				<label><input type="radio" value="C" name="tipoMov" <cftry><cfif rsEstatu.tipoMov eq 'C'>checked="checked"</cfif><cfcatch></cfcatch></cftry>> Cr&eacutedito </label>
			</td> 
			--->
		</tr>
		<tr valign="baseline">
			<td nowrap align="right" valign="middle"> #LB_AfectaA#:&nbsp; </td>
			<td>
				<select name="Afecta_A"  tabindex="1">
					<option value="afectaSaldo" <cftry><cfif rsEstatu.afectaSaldo eq '1'>selected</cfif><cfcatch></cfcatch></cftry>>#LB_Saldo#</option>
					<option value="afectaInteres" <cftry><cfif rsEstatu.afectaInteres eq '1'>selected</cfif><cfcatch></cfcatch></cftry>>#LB_Interes#</option>
					<option value="afectaCompras" <cftry><cfif rsEstatu.afectaCompras eq '1'>selected</cfif><cfcatch></cfcatch></cftry>>#LB_Compras#</option>
					<option value="afectaPagos"<cftry><cfif rsEstatu.afectaPagos eq '1'>selected</cfif><cfcatch></cfcatch></cftry>>#LB_Pagos#</option>
					<option value="afectaCondonaciones" <cftry><cfif rsEstatu.afectaCondonaciones eq '1'>selected</cfif><cfcatch></cfcatch></cftry>>#LB_Condonaciones#</option>
					<option value="afectaGastoCobranza" <cftry><cfif rsEstatu.afectaGastoCobranza eq '1'>selected</cfif><cfcatch></cfcatch></cftry>>#LB_GastoCobranza#</option>
					<option value="afectaGastoCobranza" <cftry><cfif rsEstatu.afectaGastoCobranza eq '1'>selected</cfif><cfcatch></cfcatch></cftry>>#LB_GastoCobranza#</option>
					<option value="afectaSeguro" <cftry><cfif rsEstatu.afectaSeguro eq '1'>selected</cfif><cfcatch></cfcatch></cftry>>#LB_Seguro#</option>
				</select>
				<!---
				<label><input type="radio" value="afectaSaldo" name="Afecta_A" <cftry><cfif rsEstatu.afectaSaldo eq '1'>checked="checked"</cfif><cfcatch></cfcatch></cftry>> #LB_Saldo#</label>
				<label><input type="radio" value="afectaInteres" name="Afecta_A" <cftry><cfif rsEstatu.afectaInteres eq '1'>checked="checked"</cfif><cfcatch></cfcatch></cftry>> #LB_Interes#&emsp;&emsp;&emsp;&emsp;</label>
				<label><input type="radio" value="afectaCompras" name="Afecta_A" <cftry><cfif rsEstatu.afectaCompras eq '1'>checked="checked"</cfif><cfcatch></cfcatch></cftry>> #LB_Compras#</label>
				<br/>
				<label><input type="radio" value="afectaPagos" name="Afecta_A" <cftry><cfif rsEstatu.afectaPagos eq '1'>checked="checked"</cfif><cfcatch></cfcatch></cftry>>#LB_Pagos#&emsp;</label>
				<label><input type="radio" value="afectaCondonaciones" name="Afecta_A" <cftry><cfif rsEstatu.afectaCondonaciones eq '1'>checked="checked"</cfif><cfcatch></cfcatch></cftry>> #LB_Condonaciones#&emsp;</label>
				<label><input type="radio" value="afectaGastoCobranza" name="Afecta_A" <cftry><cfif rsEstatu.afectaGastoCobranza eq '1'>checked="checked"</cfif><cfcatch></cfcatch></cftry>> #LB_GastoCobranza# </label>
				--->
			</td>
		</tr>
		<tr valign="baseline">
			<td colspan="2" align="right" nowrap>
				<div align="center">
					<script language="JavaScript" type="text/javascript">
						// Funciones para Manejo de Botones
						botonActual = "";

						function setBtn(obj) {
							botonActual = obj.name;
						}
						function btnSelected(name, f) {
							if (f != null) {
								return (f["botonSel"].value == name)
							} else {
								return (botonActual == name)
							}
						}
					</script>

					<input tabindex="-1" type="hidden" name="botonSel" value="">
					<input tabindex="-1" name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
					<cfif modo eq 'ALTA'>
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Agregar"
							Default="Agregar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Agregar"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Limpiar"
							Default="Limpiar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Limpiar"/>

						<input type="submit" tabindex="3" name="Alta" value="#BTN_Agregar#" onClick="javascript: this.form.botonSel.value = this.name">
						<input type="reset" tabindex="3" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript: this.form.botonSel.value = this.name">
					<cfelse>
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Modificar"
							Default="Modificar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Modificar"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Eliminar"
							Default="Eliminar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Eliminar"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_DeseaElimarElRegistro"
							Default="Desea Eliminar el Registro?"
							XmlFile="/crc/generales.xml"
							returnvariable="LB_DeseaElimarElRegistro"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Nuevo"
							Default="Nuevo"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Nuevo"/>

						<input tabindex="3" type="submit" name="Cambio" value="#BTN_Modificar#" onClick="javascript: this.form.botonSel.value = this.name; ">
						<input tabindex="3" type="submit" name="Baja" value="#BTN_Eliminar#" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('#LB_DeseaElimarElRegistro#') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
						<input tabindex="3" type="submit" name="Nuevo" value="#BTN_Nuevo#" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
					</cfif>
				</div>
			</td>
		</tr>
		<tr>
		  <td>&nbsp;</td>
		</tr>
		<tr valign="baseline">
			<input tabindex="-1" type="hidden" name="id" value="<cfif modo NEQ "ALTA">#rsEstatu.id#</cfif>">
			<input tabindex="-1" type="hidden" name="Pagina"
			value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">
			<cfif modo NEQ "ALTA">
				<td colspan="2" align="right" nowrap>
					<div align="center">
					</div>
				</td>
			</cfif>
		</tr>
	</table>
</form>
</cfoutput>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Descripcion" Default="Descripción" XmlFile="/crc/generales.xml" returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Codigo" Default="Código" XmlFile="/crc/generales.xml" returnvariable="MSG_Codigo"/>

<cf_qforms>
	<cf_qformsRequiredField name="codigo" description="#MSG_Codigo#">
	<cf_qformsRequiredField name="Descripcion" description="#MSG_Descripcion#">
</cf_qforms>
