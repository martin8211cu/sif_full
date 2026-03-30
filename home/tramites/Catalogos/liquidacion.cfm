<!--- id_inst ,codigo_inst, nombre_inst,ts_rversion  --->
<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
	select id_inst,
		   id_direccion,
		   codigo_inst,
		   nombre_inst,
		   liq_dias,
		   liq_banco,
		   liq_cuenta,
		   BMUsucodigo,
		   BMfechamod,
		   ts_rversion
	from TPInstitucion 
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
</cfquery>

<SCRIPT LANGUAGE='Javascript'  SRC="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
</SCRIPT>

<cfset ts = ""> 
<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts">
</cfinvoke>

<cfoutput>
<form action="liquidacion-sql.cfm" method="post" name="forml">
<table align="center" width="50%" cellpadding="2" cellspacing="0">
	<tr > 
		<td  colspan="2" class="subtitulo" align="left"><font size="2" color="black"><strong>Informaci&oacute;n de Liquidaci&oacute;n </strong></font></td>
	</tr>	
	<tr > 
		<td nowrap align="right">Per&iacute;odo de Liquidaci&oacute;n:</td>
		<td>
			<select name="liq_dias"  onChange=" javascript: PreValidacionIns(this.value);">
				<option value="">Sin per&iacute;odo</option>
				<option value="1" <cfif isdefined('rsDatos.liq_dias') and rsDatos.liq_dias  eq '1'>selected</cfif>>Diario</option>
				<option value="7" <cfif isdefined('rsDatos.liq_dias') and rsDatos.liq_dias  eq '7'>selected</cfif>>Semanal</option>
				<option value="15" <cfif isdefined('rsDatos.liq_dias') and rsDatos.liq_dias eq '15'>selected</cfif>>Quincenal</option>
				<option value="30" <cfif isdefined('rsDatos.liq_dias') and rsDatos.liq_dias eq '30'>selected</cfif>>30 días</option>
			</select>	
		</td>
	</tr>		
	<tr valign="baseline"> 
		<td  colspan="2" nowrap align="left">&nbsp;</td>
	</tr>											
	<tr > 
		<td  colspan="2" nowrap align="left"><strong>Cuenta Bancaria para transferencias</strong></td>
	</tr>											
	<tr > 
		<td nowrap align="right">Siglas Banco:</td>
		<td>
			<input type="text" name="liq_banco" 
			value="#rsDatos.liq_banco#" 
			size="50" maxlength="255" onfocus="javascript:this.select();" >
		</td>
	</tr>
	<tr > 
		<td nowrap align="right">No. Cuenta:</td>
		<td>
			<input type="text" name="liq_cuenta" 
			value="#rsDatos.liq_cuenta#" 
			size="50" maxlength="255" onfocus="javascript:this.select();" >
		</td>
	</tr>
	<tr><td align="center" colspan="2"><input type="submit" name="Cambio" value="Modificar"></td></tr>				
</table>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input type="hidden" name="id_inst" value="#rsDatos.id_inst#">
</form>
</cfoutput>

<script language="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	ObjFormIns = new qForm("forml");

	function PreValidacionIns(valor){
		if(valor ==""){
			ObjFormIns.liq_banco.required = false;
			ObjFormIns.liq_cuenta.required = false;
		}
		else{
			ObjFormIns.liq_banco.required = true;
			ObjFormIns.liq_banco.description="Siglas Banco";
			ObjFormIns.liq_cuenta.required = true;
			ObjFormIns.liq_cuenta.description="No. Cuenta";
		}
	}		
	PreValidacionIns(document.forml.liq_dias.value)
	
	function deshabilitarValidacionIns(){}
</script>