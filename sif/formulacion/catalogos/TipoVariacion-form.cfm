<cfif modo NEQ 'ALTA'>
	<cfinvoke component="sif.Componentes.FPRES_VariacionPresupuestal" method="GetTipoVariacion" returnvariable="TiposVariaciones">
		<cfinvokeargument name="FPTVid" value="#form.FPTVid#">
	</cfinvoke>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#TiposVariaciones.ts_rversion#" returnvariable="ts"></cfinvoke>
</cfif>
<cfinvoke component="sif.Componentes.FPRES_VariacionPresupuestal" method="fnExistePO" returnvariable="existePO">
	<cfif modo NEQ 'ALTA'>
		<cfinvokeargument name="FPTVid" value="#form.FPTVid#">
	</cfif>
</cfinvoke>

<form action="TipoVariacion-sql.cfm" method="post" name="form1">
	<cfif modo NEQ 'ALTA'>
		<input name="FPTVid" type="hidden" value="<cfoutput>#TiposVariaciones.FPTVid#</cfoutput>">
		<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
	</cfif>
	<table border="0" cellspacing="1" cellpadding="1">
		<tr>
			<td>Código:</td>
			<td><input name="FPTVCodigo" 	  type="text" value="<cfoutput>#TiposVariaciones.FPTVCodigo#</cfoutput>"  size="50" maxlength="20" tabindex="1"></td>
		</tr>
		<tr>
			<td>Descripción:</td>
			<td><input name="FPTVDescripcion" type="text" value="<cfoutput>#TiposVariaciones.FPTVDescripcion#</cfoutput>"  size="50" maxlength="100" tabindex="1"></td>
		</tr>
		<tr>
			<td>Tipo:</td>
			<td>
				<select name="FPTVTipo" >
					<cfif existePO eq 0>
					  <option value="-1" <cfif TiposVariaciones.FPTVTipo EQ '-1'> selected="selected"</cfif>>Presupuesto Ordinario</option>
					</cfif>
					  <option value="0"  <cfif TiposVariaciones.FPTVTipo EQ '0'>  selected="selected"</cfif>>Presupuesto Extraordinario</option>
					  <option value="1"  <cfif TiposVariaciones.FPTVTipo EQ '1'>  selected="selected"</cfif>>No modifica monto</option>
					  <option value="4"  <cfif TiposVariaciones.FPTVTipo EQ '4'>  selected="selected"</cfif>>No modifica monto grupal</option>
					  <option value="2"  <cfif TiposVariaciones.FPTVTipo EQ '2'>  selected="selected"</cfif>>Modifica monto hacia abajo</option>
					  <option value="3"  <cfif TiposVariaciones.FPTVTipo EQ '3'>  selected="selected"</cfif>>Modifica monto hacia Arriba</option>
				</select>
			</td>
		</tr>
		<tr><td colspan="2">
				<cf_botones modo='#MODO#'>
			</td>
		</tr>
	</table>
</form>