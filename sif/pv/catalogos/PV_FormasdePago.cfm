<cfinclude template="ParametrosAlta_header.cfm">
<cfif modo neq 'Alta'>

	<!--- Obtiene los parametros existentes --->
	<cfquery datasource="#session.DSN#" name="Data">
	Select FAPFOPG, ts_rversion
	from FAP000
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfif Data.FAPFOPG neq "">
	
		<cfset var1 = #Mid(Data.FAPFOPG,1,1)#>
		<cfset var2 = #Mid(Data.FAPFOPG,2,1)#>
		<cfset var3 = #Mid(Data.FAPFOPG,3,1)#>
		<cfset var4 = #Mid(Data.FAPFOPG,4,1)#>
		<cfset var5 = #Mid(Data.FAPFOPG,5,1)#>
		<cfset var6 = #Mid(Data.FAPFOPG,6,1)#>
		<cfset var7 = #Mid(Data.FAPFOPG,7,1)#>
		<cfset var8 = #Mid(Data.FAPFOPG,8,1)#>
		<cfset var9 = #Mid(Data.FAPFOPG,9,1)#>
							
	<cfelse>
		<cfset var1 = 0>
		<cfset var2 = 0>
		<cfset var3 = 0>
		<cfset var4 = 0>
		<cfset var5 = 0>
		<cfset var6 = 0>
		<cfset var7 = 0>
		<cfset var8 = 0>
		<cfset var9 = 0>
	</cfif>

</cfif>

<cfoutput>
<form name="form1" method="post" action="PV_FormasdePago-sql.cfm" onSubmit="javascript: return valida(this)">
<table cellpadding="0" cellspacing="0" align="center" >
<tr>
	<td><input type="checkbox" name="FAPFOPG" value="1" <cfif modo neq 'Alta' and var1 eq 1>checked</cfif>></td>
	<td align="left">Adelantos&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" value="2" <cfif modo neq 'Alta' and var2 eq 1>checked</cfif>></td>
	<td align="left">Cartas Promesa&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" value="3" <cfif modo neq 'Alta' and var3 eq 1>checked</cfif>></td>
	<td align="left">Certificados&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" value="4" <cfif modo neq 'Alta' and var4 eq 1>checked</cfif>></td>
	<td align="left">Cheques&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" value="5" <cfif modo neq 'Alta' and var5 eq 1>checked</cfif>></td>
	<td align="left">Efectivo&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" value="6" <cfif modo neq 'Alta' and var6 eq 1>checked</cfif>></td>
	<td align="left">Dep&oacute;sitos Bancarios&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" value="7" <cfif modo neq 'Alta' and var7 eq 1>checked</cfif>></td>
	<td align="left">Notas de Cr&eacute;dito&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" value="8" <cfif modo neq 'Alta' and var8 eq 1>checked</cfif>></td>
	<td align="left">Tarjetas de Cr&eacute;dito&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" value="9" <cfif modo neq 'Alta' and var9 eq 1>checked</cfif>></td>
	<td align="left">Ordenes de Compra&nbsp;</td>
</tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr>
	<td colspan="2" align="center">


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
			
			function valida(f){//8
				var band = false;
				for(i=0;i<8;i++){
					if(f.FAPFOPG[i].checked)
						band = true;
				}
				
				if(!band){
					alert('Error, debe marcar al menos una forma de pago');
					return false;
				}
					
				return true;
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