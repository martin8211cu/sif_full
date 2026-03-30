<cfinclude template="ParametrosAlta_header.cfm">
<cfif modo neq 'Alta'>

	<!--- Obtiene los parametros existentes --->
	<cfquery datasource="#session.DSN#" name="Data">
	Select FAPIMPSU, FAPCLF, FAPVICOT, FAPVIAPA, FAPVINC, FAPVICR, 
	       CFcuenta, CFcuenta1, CFcuenta2, ts_rversion
	from FAP000
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif len(trim(data.CFcuenta))>
		<cfquery name="rsCuentas" datasource="#Session.DSN#" >
			Select Ccuenta, CFcuenta, CFformato, CFdescripcion, Cmayor		
			from CFinanciera
			where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and CFcuenta=<cfqueryparam value="#data.CFcuenta#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
	
	<cfif len(trim(data.CFcuenta1))>
		<cfquery name="rsCuentas1" datasource="#Session.DSN#" >
			Select Ccuenta, CFcuenta, CFformato, CFdescripcion, Cmayor		
			from CFinanciera
			where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and CFcuenta=<cfqueryparam value="#data.CFcuenta1#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
	
	<cfif len(trim(data.CFcuenta2))>
		<cfquery name="rsCuentas2" datasource="#Session.DSN#" >
			Select Ccuenta, CFcuenta, CFformato, CFdescripcion, Cmayor		
			from CFinanciera
			where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and CFcuenta=<cfqueryparam value="#data.CFcuenta2#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>		

</cfif>

<cfoutput>
<form name="form1" method="post" action="PV_Otros-sql.cfm">
<table cellpadding="0" cellspacing="0" align="center" >
<tr>
	<td width="209" align="right">Porc. Imp. Venta Sugerido:&nbsp;</td>
	<td width="144"><input type="text" name="FAPIMPSU" <cfif modo neq 'Alta'>value="#Data.FAPIMPSU#"</cfif> onKeypress="if (event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;"></td>
	<td width="190" align="right">M&aacute;ximo de l&iacute;neas de Factura:&nbsp;</td>
	<td width="155"><input type="text" name="FAPCLF" <cfif modo neq 'Alta'>value="#Data.FAPCLF#"</cfif> onKeypress="if (event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;"></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td height="23" align="right">D&iacute;as de Vigencia de Cotizaciones:&nbsp;</td>
	<td><input type="text" name="FAPVICOT" <cfif modo neq 'Alta'>value="#Data.FAPVICOT#"</cfif> onKeypress="if (event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;"></td>
	<td align="right">D&iacute;as de Vigencia de Apartado:&nbsp;</td>
	<td><input type="text" name="FAPVIAPA" <cfif modo neq 'Alta'>value="#Data.FAPVIAPA#"</cfif> onKeypress="if (event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;"></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">D&iacute;as de vigencia NC:&nbsp;</td>
	<td><input type="text" name="FAPVINC" <cfif modo neq 'Alta'>value="#Data.FAPVINC#"</cfif> onKeypress="if (event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;"></td>
	<td align="right">D&iacute;as de Vigencia Cert. Reg.:&nbsp;</td>
	<td><input type="text" name="FAPVICR" <cfif modo neq 'Alta'>value="#Data.FAPVICR#"</cfif> onKeypress="if (event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;"></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="left" colspan="4">
	
		<table align="left" cellpadding="0" cellspacing="0">
		<tr>
			<td width="255">Cuenta Contable Certificados de Regalo:&nbsp;</td>
			<td width="411">
			    <cfif modo NEQ "ALTA" and len(trim(data.CFcuenta))>
			        <cf_cuentas query="#rsCuentas#"  Ccuenta = "Ccuenta"  CFcuenta = "CFcuenta" CFformato = "CFformato" CFdescripcion = "CFdescripcion" Cmayor="Cmayor" frame="frame"> 
				<cfelse>
					 <cf_cuentas Ccuenta = "Ccuenta"  CFcuenta = "CFcuenta" CFformato = "CFformato" CFdescripcion = "CFdescripcion" Cmayor="Cmayor" frame="frame">
				</cfif>			
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td>Cuenta contable de impuestos:&nbsp;</td>
			<td>
			    <cfif modo NEQ "ALTA" and len(trim(data.CFcuenta1))>
			        <cf_cuentas query="#rsCuentas1#" Ccuenta = "Ccuenta1" CFcuenta="CFcuenta1" CFformato="CFformato1" CFdescripcion = "CFdescripcion1" Cmayor="Cmayor1" frame="frame1"> 
				<cfelse>
					 <cf_cuentas Ccuenta = "Ccuenta1" CFcuenta="CFcuenta1" CFformato="CFformato1" CFdescripcion = "CFdescripcion1" Cmayor="Cmayor1" frame="frame1">
				</cfif>			
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td>Cuenta Contable de Adelantos:&nbsp;</td>
			<td>
			    <cfif modo NEQ "ALTA" and len(trim(data.CFcuenta2))>
			        <cf_cuentas query="#rsCuentas2#" Ccuenta = "Ccuenta2" CFcuenta="CFcuenta2" CFformato="CFformato2" CFdescripcion = "CFdescripcion2" Cmayor="Cmayor2" frame="frame2"> 
				<cfelse>
					 <cf_cuentas Ccuenta = "Ccuenta2" CFcuenta="CFcuenta2" CFformato="CFformato2" CFdescripcion = "CFdescripcion2" Cmayor="Cmayor2" frame="frame2">
				</cfif>			
			</td>
		</tr>				
		</table>
	
	</td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td colspan="4" align="center">


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
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
		  <tr>
			<td align="center">
				
				<input type="hidden" name="botonSel" value="">	
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1">					
				<input type="submit" name="Cambio" value="Modificar Par&aacute;metros" onClick="javascript: this.form.botonSel.value = this.name; if (window.funcCambio) return funcCambio();if (window.habilitarValidacion) habilitarValidacion();" tabindex="0">
				
			</td>
		  </tr>
		</table>


	</td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td colspan="4">&nbsp;</td></tr>
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

</script>