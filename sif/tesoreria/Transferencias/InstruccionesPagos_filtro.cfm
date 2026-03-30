<cfoutput>
<form name="formFiltro" method="post" action="InstruccionesPagos.cfm" style="margin: '0' ">
<table class="tituloAlterno" width="100%"  border="0" cellpadding="0" cellspacing="0">
	<tr><td colspan="4"></td></tr>	
	<tr>
		<td nowrap align="right">
			<strong>Trabajar con Tesorería:</strong>&nbsp;
		</td>
		<td align="left">
			<cf_cboTESid onchange="this.form.submit();" tabindex="1">
		</td>
	</tr>	
	<tr>
		<td nowrap align="right">
			<strong>Tipo de Beneficiario:</strong>&nbsp;
		</td>
		<td align="left">
			<select name="TIPO" onChange="this.form.submit();" tabindex="1">
				<option value="SN" <cfif form.TIPO EQ "SN"> selected</cfif>>Socio de Negocios</option>
				<option value="BT" <cfif form.TIPO EQ "BT"> selected</cfif>>Beneficiario de Contado</option>
				<option value="CD" <cfif form.TIPO EQ "CD"> selected</cfif>>Cliente Detallista</option>
			</select>
		<cfif form.TIPO EQ "BT">
			<select name="TIPO_ESPECIAL" onChange="this.form.submit();" tabindex="1">
				<option value="0" <cfif form.TIPO_ESPECIAL EQ "0"> selected</cfif>>Todos</option>
				<option value="1" <cfif form.TIPO_ESPECIAL EQ "1"> selected</cfif>>Empresa</option>
				<option value="2" <cfif form.TIPO_ESPECIAL EQ "2"> selected</cfif>>Empleados</option>
				<option value="3" <cfif form.TIPO_ESPECIAL EQ "3"> selected</cfif>>Bancos</option>
				<option value="-1" <cfif form.TIPO_ESPECIAL EQ "-1"> selected</cfif>>Otros Externos</option>
			</select>
		</cfif>
		</td>
	</tr>	
	<tr>
		<td nowrap align="right">
			<strong>Identificación:</strong>&nbsp;
		</td>
		<td align="left">
			<input 	type="text" name="Fidentificacion" size="40" tabindex="1"
					value="<cfif isdefined("form.Fidentificacion") and len(trim(form.Fidentificacion))>#form.Fidentificacion#</cfif>" maxlength="100">
		</td>
		<td nowrap align="left">
			<strong>Nombre:</strong>&nbsp;
			<input 	type="text" name="Fnombre" size="30" maxlength="255" tabindex="1"
					value="<cfif isdefined("form.Fnombre") and len(trim(form.Fnombre))>#form.Fnombre#</cfif>">
		</td>
		<td align="center">
			<cf_botones exclude="ALTA,CAMBIO,BAJA,LIMPIAR" include="btnFiltrar"  includevalues="Filtrar" tabindex="1" >
			<!--- <input name="btnFiltro" type="submit" value="Filtrar"> --->
		</td>
	</tr>
</table>
</form>
<script language="javascript" type="text/javascript">
	document.formFiltro.TESid.focus();
</script>

</cfoutput>
