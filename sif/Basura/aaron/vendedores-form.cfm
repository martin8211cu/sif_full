<cfset modo = 'ALTA'>
<cfif  isdefined('url.FAX04CVD') and len(trim(url.FAX04CVD)) and not isdefined('form.FAX04CVD')>
	<cfset form.Bid = url.FAX04CVD>
</cfif>
<cfif  isdefined('form.FAX04CVD') and len(trim(form.FAX04CVD))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select *
		from FAM021
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and FAX04CVD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAX04CVD#">
	</cfquery>
	
	<cfquery name="rsCentros" datasource="#session.DSN#">
		Select *
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CFid#">
	</cfquery>
		
</cfif>

<!-- SE UTILIZA PARA DESPLEGAR ---> 
<cfoutput>
<form name="form1" method="post" action="bancos-sql.cfm" onSubmit="javascript: return validar(this);">
	<cfif modo neq 'ALTA'>
		<!--- <input type="hidden" name="Bid" value="#data.Bid#"> --->
	</cfif>
	<table width="100%" cellpadding="3" cellspacing="0">
		<tr>
			<td align="right">Empleado:&nbsp;</td>
			<td>
				<cfif modo NEQ "ALTA">
			        <cf_rhempleados idempleado="#data.DEid#">
				<cfelse>
					 <cf_rhempleados>
				</cfif> 
			</td>
		</tr>
		<tr>	
			<td align="right">Centro Funcional:&nbsp;</td>				
			<td>
					<cfif modo neq 'ALTA'>
						<cf_rhcfuncional form="form1" size="30" titulo="Seleccione un Centro Funcional">
					<cfelse>
						<cf_rhcfuncional form="form1" idquery="#rsCentros#">
					</cfif>					
			</td>
		</tr>
		<tr>			
			<td align="right" width="23%">Identificacion:&nbsp;</td>			
			<td width="77%"><input type="text" name="FAM21CED" size="40" maxlength="40" value="<cfif modo neq 'ALTA'>#data.FAM21CED#</cfif>"></td>
		</tr>				
		<tr>			
			<td align="right" width="23%">Nombre:&nbsp;</td>			
			<td width="77%"><input type="text" name="FAM21NOM" size="40" maxlength="40" value="<cfif modo neq 'ALTA'>#data.FAM21NOM#</cfif>"></td>
		</tr>		
		<tr>
			<td align="right">Puesto:&nbsp;</td>
			<td>
				<input type="text" name="FAM21PUE" size="40" maxlength="40" value="<cfif modo neq 'ALTA'>#data.FAM21PUE#</cfif>">
			</td>
		</tr>
		<tr>	
			<td align="right">Porcentaje de Comision:&nbsp;</td>			
			<td>
				<input type="text" name="FAM21PCO" size="40" maxlength="40" value="<cfif modo neq 'ALTA'>#data.FAM21PCO#</cfif>">
			</td>
		</tr>	 
		<tr>	
			<td align="right">Tipo de Comision:&nbsp;</td>
			<td>
				<select name="FAM21CDI">
				<option value="1">Comision Directa</option>
				<option value="2">Tracto sobre Venta</option>
				<option value="3">Tracto sobre Utilidad</option>
				<option value="4">Comision por Producto</option>
				<option value="9">Comision Variable</option>
				</select>
			</td>
		</tr>	 		
		<tr>
			<td align="right">&nbsp;</td>
			<td><input type="checkbox" name="FAM21PAD" <cfif isdefined("data.FAM21PAD") and FAM21PAD eq 1>checked</cfif>>Permitir Autorizar Descuentos</td>
		</tr>
		<tr>
			<td align="right">&nbsp;</td>
			<td><input type="checkbox" name="FAM21PCP" <cfif isdefined("data.FAM21PCP") and FAM21PCP eq 1>checked</cfif>>Permitir Cambio de Precios</td>
		</tr>		
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>

	</table>
	
	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		
	</cfif>
	
</form>
</cfoutput>



<!-- MANEJA LOS ERRORES--->

<cf_qforms>
<script language="javascript">

	objForm.DEid.required = true;
	objForm.DEid.description = "Empleado";
	objForm.CFid.required = true;
	objForm.CFid.description = "Centro Funcional";
	objForm.FAM21NOM.required = true;
	objForm.FAM21NOM.description = "Nombre";
	objForm.FAM21PUE.required = true;
	objForm.FAM21PUE.description = "Puesto";
	objForm.FAM21PAD.required = true;
	objForm.FAM21PAD.description = "Autorizar Descuento";	
	objForm.FAM21PCP.required = true;
	objForm.FAM21PCP.description = "Cambio de Precios";
	objForm.FAM21PCO.required = true;
	objForm.FAM21PCO.description = "Porcentaje de Comision";
	objForm.FAM21CED.required = true;
	objForm.FAM21CED.description = "Identificacion";	
</script>