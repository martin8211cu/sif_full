<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Se corrige la navegación del form por tabs para que tenga un orden lógico.
 --->
 
<cfif isdefined("form.CGARepid") and Len(Trim(form.CGARepid))>
	<cfparam name="Form.fCGARepid" default="#form.CGARepid#">
</cfif>

<cfoutput>
	<form name="form1" method="post" action="CuentasTipoRep-sql.cfm" style="margin: 0;">
		<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>		  
		  <input type="hidden" name="PageNum_lista" value="#Form.PageNum_lista#" tabindex="-1">
		<cfelseif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
		  <input type="hidden" name="PageNum_lista" value="#Form.PageNum#" tabindex="-1">
		</cfif>

		<input type="hidden" name="CGARepid" value="#rsTiposRep.CGARepid#" tabindex="-1">
		<cfif isdefined("Form.fCGARepid") and Len(Trim(Form.fCGARepid))>		  
		  <input type="hidden" name="fCGARepid" value="#Form.fCGARepid#" tabindex="-1">
		</cfif>
		<cfif isdefined("Form.fCmayor") and Len(Trim(Form.fCmayor))>
		  <input type="hidden" name="fCmayor" value="#Form.fCmayor#" tabindex="-1">
		</cfif>
		<cfif isdefined("Form.fCtipo") and Len(Trim(Form.fCtipo))>
		  <input type="hidden" name="fCtipo" value="#Form.fCtipo#" tabindex="-1">
		</cfif>
		<cfif isdefined("Form.fCsubtipo") and Len(Trim(Form.fCsubtipo))>
		  <input type="hidden" name="fCsubtipo" value="#Form.fCsubtipo#" tabindex="-1">
		</cfif>
		<cfif isdefined("Form.fCGARctaBalance") and Len(Trim(Form.fCGARctaBalance))>
		  <input type="hidden" name="fCGARctaBalance" value="#Form.fCGARctaBalance#" tabindex="-1">
		</cfif>

		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  
		  <tr>
			<td style="background-color:##CCCCCC"><strong>Cuenta Mayor</strong></td>
			<td style="background-color:##CCCCCC"><strong>Tipo</strong></td>
			<td style="background-color:##CCCCCC"><strong>Balance</strong></td>
		  </tr>
		  <tr>
			<td width="25%">
				<cfif isdefined("Form.cgarctamayor") and len(Form.cgarctamayor)>
								
					<cfquery name="rsdesc" datasource="#Session.DSN#">
					Select Cdescripcion 
					from CtasMayor 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.cgarctamayor#">
					</cfquery>
					
					#Form.cgarctamayor# #rsdesc.Cdescripcion#
					<input type="hidden" name="Cmayor" value="#Form.cgarctamayor#" tabindex="-1">
				<cfelse>	
					
					<cf_CTRConlis Conexion = #Session.DSN#
					form = "form1"
					name = "Cmayor"
					descripcion = "Cdescripcion"
					size = 4
					sizedesc = 25 
					tabindex = "1"
					>
				</cfif>	
			</td>
			<td width="35%">
				<table cellpadding="2" cellspacing="0">
				  <tr>
					<td>
					  <select name="Ctipo" id="Ctipo" onChange="javascript: changeTipo(this);" tabindex="1">
						<option value="A" <cfif isdefined("Form.tipo") and (Form.tipo eq "Activo")>selected</cfif>>Activo</option>
						<option value="P" <cfif isdefined("Form.tipo") and (Form.tipo eq "Pasivo")>selected</cfif>>Pasivo</option>
						<option value="C" <cfif isdefined("Form.tipo") and (Form.tipo eq "Capital")>selected</cfif>>Capital</option>
						<option value="I" <cfif isdefined("Form.tipo") and (Form.tipo eq "Ingreso")>selected</cfif>>Ingreso</option>
						<option value="G" <cfif isdefined("Form.tipo") and (Form.tipo eq "Gasto")>selected</cfif>>Gasto</option>
						<option value="O" <cfif isdefined("Form.tipo") and (Form.tipo eq "Orden")>selected</cfif>>Orden</option>
					  </select>
					  
					</td>
					<td id="tdSubtipo2">
					  <select name="Csubtipo1" id="Csubtipo1" tabindex="1">
						<option value="1" <cfif isdefined("Form.subtipo") and (Form.subtipo eq "Ventas o Ingresos")>selected</cfif>>Ventas o Ingresos</option>
						<option value="4" <cfif isdefined("Form.subtipo") and (Form.subtipo eq "Otros Ingresos Gravables")>selected</cfif>>Otros Ingresos Gravables</option>
						<option value="6" <cfif isdefined("Form.subtipo") and (Form.subtipo eq "Ingresos no Gravables")>selected</cfif>>Ingresos no Gravables</option>
						<option value="2" <cfif isdefined("Form.subtipo") and (Form.subtipo eq "Costos de Operaci&oacute;n")>selected</cfif>>Costos de Operaci&oacute;n</option>
						<option value="3" <cfif isdefined("Form.subtipo") and (Form.subtipo eq "Gastos de Operaci&oacute;n y Administrativos")>selected</cfif>>Gastos de Operaci&oacute;n y Administrativos</option>
						<option value="5" <cfif isdefined("Form.subtipo") and (Form.subtipo eq "Otros Gastos Deducibles")>selected</cfif>>Otros Gastos Deducibles</option>
						<option value="7" <cfif isdefined("Form.subtipo") and (Form.subtipo eq "Gastos no Deducibles")>selected</cfif>>Gastos no Deducibles</option>
						<option value="8" <cfif isdefined("Form.subtipo") and (Form.subtipo eq "Impuestos")>selected</cfif>>Impuestos</option>
					  </select>					  
					</td>
				  </tr>
			  </table>
			</td>
			<td width="15%">				
				<select name="CGARctaBalance" tabindex="1">
					<option value="1">D&eacute;bito</option>
					<option value="-1">Cr&eacute;dito</option>
				</select>
			</td>
		  </tr>
		  <tr>
			<td colspan="4">				
				<cf_botones modo="#modo#" tabindex="2">
			</td>
		  </tr>
		  <tr>
			<td colspan="4">&nbsp;</td>
		  </tr>
		</table>
	</form>
</cfoutput>

<cf_qforms form="form1" objForm="objForm1">

<script language="JavaScript" type="text/javascript">
	function changeTipo(ctl) {
		// Escoge el balance según el tipo de cuenta
		//ctl.form.CGARctaBalance.selectedIndex = (ctl.value == 'A' || ctl.value == 'G') ? 0 : 1;
		// Si la cuenta es de tipo ingreso o gasto solicita un subtipo para éstas
		<cfif isdefined("Form.balance") and Mid(trim(Form.balance),1,1) eq "C">
			ctl.form.CGARctaBalance.selectedIndex = 1;			
		<cfelse>
			<cfif isdefined("Form.balance") and Mid(trim(Form.balance),1,1) eq "D">
				ctl.form.CGARctaBalance.selectedIndex = 0;
			</cfif>
		</cfif>
	}
	
	objForm1.CGARepid.required = true;
	objForm1.CGARepid.description = 'Tipo de Reporte';
	objForm1.Cmayor.required = true;
	objForm1.Cmayor.description = 'Cuenta Mayor';
	changeTipo(document.form1.Ctipo);
</script>