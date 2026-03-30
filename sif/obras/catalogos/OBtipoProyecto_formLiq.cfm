<cfquery datasource="#session.dsn#" name="rsDet">
	select OBTPLnivel, rtrim(OBTPLvalor) as OBTPLvalor
	  from OBTPliquidacionDet
	 where OBTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
	 order by OBTPLnivel
</cfquery>

<cfoutput>
<table width="100%">
	<tr>
		<td valign="top" align="center" colspan="2" style="background-color:##CCCCCC">
			<strong>Parametrización de la Liquidación de Obras en Construcción</strong><BR>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<strong>Tipo Cuenta de Liquidación:</strong>
		</td>
		<td valign="top">
			<select name="OBTPtipoCtaLiquidacion" id="OBTPtipoCtaLiquidacion" onfocus="GvarSelectedIndex = this.selectedIndex;" onchange="return fnOBTPtipoCtaLiquidacionOnChange(this);">
				<option value="1" <cfif rsForm.OBTPtipoCtaLiquidacion EQ "1">selected</cfif>>Sustitución de niveles con valores fijos</option>
				<option value="0" <cfif rsForm.OBTPtipoCtaLiquidacion EQ "0">selected</cfif>>Cada Cuenta de la Obra</option>
				<option value="2" <cfif rsForm.OBTPtipoCtaLiquidacion EQ "2">selected</cfif>>Una única Cuenta de Liquidación</option>
				<option value="3" <cfif rsForm.OBTPtipoCtaLiquidacion EQ "3">selected</cfif>>Una Cuenta de Liquidación por Activo</option>
				<option value="99" <cfif rsForm.OBTPtipoCtaLiquidacion EQ "99">selected</cfif>>Liquidacion Externa</option>
			</select>
		</td>
	</tr>
</table>
<table width="100%" id="tblLiquidacion" <cfif rsForm.OBTPtipoCtaLiquidacion NEQ 1 AND rsForm.OBTPtipoCtaLiquidacion NEQ "">style="visibility:hidden"</cfif>>
	<tr>
		<td colspan="2" align="center">
			<table>
				<tr>
					<td colspan="3">Indique los niveles de las Cuentas de la Obra<BR>que deben ser sustituidos por valores fijos:</td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><strong>Nivel</strong></td>
					<td><strong>Valor a sustituir</strong></td>
				</tr>
		<cfif rsForm.RecordCount GT 0>
			<cfloop query="rsDet">
				<cfset i=rsDet.currentRow>
				<tr>
					<td></td>
					<td>
						<cf_inputNumber	name="OBTPLnivel#i#" 
									value="#rsDet.OBTPLnivel#"
									enteros="2" decimales="0"
						>
					</td>
					<td>
						<input 	type="text" 
								name="OBTPLvalor#i#"
								id="OBTPLvalor#i#"
								value="#rsDet.OBTPLvalor#"/>
					</td>
				</tr>
			</cfloop>
		</cfif>
			<cfloop index="i" from="#rsDet.recordCount+1#" to="10">
				<tr>
					<td></td>
					<td>
						<cf_inputNumber	name="OBTPLnivel#i#" 
									value="0"
									enteros="2" decimales="0"
						>
					</td>
					<td>
						<input 	type="text" 
								name="OBTPLvalor#i#"
								id="OBTPLvalor#i#"
								value=""/>
					</td>
				</tr>
			</cfloop>
			</table>
		</td>
	</tr>
	<tr style="visibility:hidden;">
		<td valign="top">
			<strong>Tipo de Liquidación:</strong>
		</td>
		<td valign="top">
			<select>
				<option>Sustitución de niveles con valores fijos</option>
			</select>
		</td>
	</tr>
</table>

<script language="javascript">
	function fnOBLdetalle()
	{
		if (document.form1.OBTPtipoCtaLiquidacion.value != "1")
			return;

		var LvarMSG = "";
		var LvarNIVs = ",";
		var j = 0;
		for (var i = 1; i<=10; i++)
		{
			var LvarNivel = eval("document.form1.OBTPLnivel"+i).value;
			var LvarValor = eval("document.form1.OBTPLvalor"+i).value;
			eval("document.form1.OBTPLnivel"+i).value = "0";
			eval("document.form1.OBTPLvalor"+i).value = "";
			if (LvarNivel != "" && parseInt(LvarNivel) != 0)
			{
				j++;
				eval("document.form1.OBTPLnivel"+j).value = LvarNivel;
				if (LvarNIVs.indexOf(","+LvarNivel+",") >= 0)
					LvarMSG += "\n    - El Nivel '" + LvarNivel + "' está repetido.";
				else if (parseInt(LvarNivel) <= parseInt(LobjQForm.OBTPnivelObra.value))
					LvarMSG += "\n    - Los Niveles anteriores a Proyecto y Obra '" + LobjQForm.OBTPnivelObra.value + "' no pueden sustituirse en la Liquidación.";
				else if (parseInt(LvarNivel) > parseInt(document.form1.MaxNivel.value))
					LvarMSG += "\n    - El Nivel '" + LvarNivel + "' no puede ser mayor que los niveles de cuenta '" + document.form1.MaxNivel.value + "'.";

				if (LvarValor != "")
					eval("document.form1.OBTPLvalor"+j).value = LvarValor;
				else
					LvarMSG += "\n    - No puede dejar valores en blanco";
				LvarNIVs += LvarNivel + ",";
			}
			else
			{
				eval("document.form1.OBTPLnivel"+i).value = "0";
				eval("document.form1.OBTPLvalor"+i).value = "";
			}
		}
		if (j < 1)
			LvarMSG += "\n    - Debe sustituir por lo menos un nivel en los Parámetros de Liquidación";
		
		if (LvarMSG != "")
			this.error = "Errores en Parámetros de Liquidación:" + LvarMSG;
	}
	var GvarSelectedIndex = 0;
	function fnOBTPtipoCtaLiquidacionOnChange(obj)
	{
		var LvarLiquidar = (document.getElementById("OBCliquidacion").value == "1");

		if (LvarLiquidar && obj.value == "99")
		{
			alert("La Cuenta Mayor está parametrizada para Liquidar las Obras en el sistema, es necesario indicar el Tipo de Cuenta de Liquidación");
			obj.selectedIndex = GvarSelectedIndex;
			return false;
		}
		if (!LvarLiquidar && obj.value != "99")
		{
			alert("La Cuenta Mayor está parametrizada para no Liquidar las Obras en el sistema, el Tipo de Cuenta de Liquidación se va a ignorar en el sistema (se puede indicar 'Liquidación Externa').");
		}
		
		GvarSelectedIndex = obj.selectedIndex;
		document.getElementById("tblLiquidacion").style.visibility = (obj.value == "1") ? "visible" : "hidden";
		return true;
	}
</script>
</cfoutput>

