<!--- <cf_dump var="#Form#"> --->
<cfif isdefined("form.ID_EstrCta") and Len(Trim(form.ID_EstrCta))>
	<cfset modoCM = 'CAMBIO'>
<cfelse>
	<cfset modoCM = 'ALTA'>
</cfif>

<cfif isdefined("form.ID_EstrCta") and Len(Trim(form.ID_EstrCta))>
	<cfparam name="Form.ID_EstrCta" default="#form.ID_EstrCta#">
</cfif>

<cfquery datasource="#session.dsn#" name="rsGruposCtas">
	select ID_Grupo, ID_Estr, EPGcodigo, EPGdescripcion
	from CGGrupoCtasMayor
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTiposRep.ID_Estr#">
    and EPTipoAplica= 1
</cfquery>

<!---►►Inclusion de JQUERY◄◄--->
<script>
	!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
</script>

<cfoutput>
	<form name="formCuentaM1" method="post" action="CuentasEstrProg-sql.cfm" style="margin: 0;">
		<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
		  <input type="hidden" name="PageNum_lista" value="#Form.PageNum_lista#" tabindex="-1">
		<cfelseif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
		  <input type="hidden" name="PageNum_lista" value="#Form.PageNum#" tabindex="-1">
		</cfif>
        <cfif isdefined("form.ID_EstrCta") and Len(Trim(form.ID_EstrCta))>
            <input type="hidden" name="ID_EstrCta" value="#form.ID_EstrCta#" tabindex="-1">
        </cfif>

		<input type="hidden" name="ID_Estr" value="#rsTiposRep.ID_Estr#" tabindex="-1">

		<cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
		  <input type="hidden" name="fID_Estr" value="#Form.fID_Estr#" tabindex="-1">
		</cfif>
		<cfif isdefined("Form.fCGEPCtaMayor") and Len(Trim(Form.fCGEPCtaMayor))>
		  <input type="hidden" name="fCGEPCtaMayor" value="#Form.fCGEPCtaMayor#" tabindex="-1">
		</cfif>
		<cfif isdefined("Form.fCGEPctaTipo") and Len(Trim(Form.fCGEPctaTipo))>
		  <input type="hidden" name="fCGEPctaTipo" value="#Form.fCGEPctaTipo#" tabindex="-1">
		</cfif>
		<cfif isdefined("Form.fCGEPctaGrupo") and Len(Trim(Form.fCGEPctaGrupo))>
		  <input type="hidden" name="fCGEPctaGrupo" value="#Form.fCGEPctaGrupo#" tabindex="-1">
		</cfif>
		<cfif isdefined("Form.fCGEPctaBalance") and Len(Trim(Form.fCGEPctaBalance))>
		  <input type="hidden" name="fCGEPctaBalance" value="#Form.fCGEPctaBalance#" tabindex="-1">
		</cfif>
		<cfif isdefined("Form.fCGEPDescrip") and Len(Trim(Form.fCGEPDescrip))>
		  <input type="hidden" name="fCGEPDescrip" value="#Form.fCGEPDescrip#" tabindex="-1">
		</cfif>
		<cfif isdefined("Form.fCGEPInclCtas") and Len(Trim(Form.fCGEPInclCtas))>
			<input type="hidden" name="fCGEPInclCtas" value="#Form.fCGEPInclCtas#" tabindex="-1">
		</cfif>

		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td style="background-color:##CCCCCC"><strong>Cuenta Mayor</strong></td>
			<td style="background-color:##CCCCCC"><strong>Tipo</strong></td>
			<td style="background-color:##CCCCCC"><strong>Balance</strong></td>
            <td style="background-color:##CCCCCC" align="left"><strong>Descripci&oacute;n Alterna</strong></td>
            <td style="background-color:##CCCCCC" align="left"><strong>Inc/Exc</strong></td>
			<td style="background-color:##CCCCCC" align="left"><strong>Grupo</strong></td>
		  </tr>
		  <tr>
			<td width="25%">
				<cfif isdefined("Form.CGEPCtaMayor") and len(Form.CGEPCtaMayor)>

					<cfquery name="rsdesc" datasource="#Session.DSN#">
					Select Cdescripcion
					from CtasMayor
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CGEPCtaMayor#">
					</cfquery>

					#Form.CGEPCtaMayor# #rsdesc.Cdescripcion#
					<input type="hidden" name="Cmayor" value="#Form.CGEPCtaMayor#" tabindex="-1">
				<cfelse>
					<cf_CTRConlis Conexion = #Session.DSN#
					form = "formCuentaM1"
					name = "Cmayor"
					descripcion = "Cdescripcion"
					size = 4
					sizedesc = 25
					tabindex = "1"
					autoSubmit="true"
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
			<td width="8%">
				<select name="CGEPctaBalance" tabindex="1">
					<option value="1"<cfif isdefined("Form.CGEPctaBalance") and (Form.CGEPctaBalance eq 1)>selected</cfif>>D&eacute;bito</option>
					<option value="-1"<cfif isdefined("Form.CGEPctaBalance") and (Form.CGEPctaBalance eq -1)>selected</cfif>>Cr&eacute;dito</option>
				</select>
			</td>
            <td width="25%" nowrap="nowrap" align="left">
            	<input type="text" name="CGEPDescrip" value=<cfif isdefined("Form.CGEPDescrip")>"#Form.CGEPDescrip#"<cfelse>""</cfif> tabindex="2">
            </td>
            <td width="5%" align="right">
   				<select name="CGEPInclCtas" tabindex="1">
					<option value="1"<cfif isdefined("Form.CGEPInclCtas") and (Form.CGEPInclCtas eq 1)>selected</cfif>>Incluir Todas</option>
					<option value="2"<cfif isdefined("Form.CGEPInclCtas") and (Form.CGEPInclCtas eq 2)>selected</cfif>>Incluir Lista</option>
					<option value="3"<cfif isdefined("Form.CGEPInclCtas") and (Form.CGEPInclCtas eq 3)>selected</cfif>>Excluir Lista</option>
				</select>
            </td>
			<!---<cfif isdefined('Form.CGEPInclCtas')>
			<cfthrow message="variable #Form.CGEPInclCtas#">
			</cfif>--->
			<td>
			<select name="GrupoCta" tabindex="1">
			<option value="0">Ninguno</option>
		  	<cfloop query="rsGruposCtas">
				<option value="#rsGruposCtas.ID_Grupo#"<cfif isdefined("Form.EPGcodigo") and Form.EPGcodigo EQ #rsGruposCtas.EPGcodigo#>selected</cfif>>#rsGruposCtas.EPGcodigo#</option>
			</cfloop>
			</select>
		    </select>
			</td>
		  </tr>

		  <tr>
			<td colspan="4">
				<cf_botones modo="#modoCM#" tabindex="2">
			</td>
		  </tr>
		  <tr>
			<td colspan="4">&nbsp;</td>
		  </tr>
		</table>
	</form>
</cfoutput>

<cf_qforms form="formCuentaM1" objForm="objForm1">

<script language="JavaScript" type="text/javascript">

	$(document).ready(function(){
		<cfif isdefined("Form.Cmayor")>
			<cfoutput>
				document.getElementById("Cmayor").value= "#Form.Cmayor#";
				document.getElementById("Cdescripcion").value= "#Form.CGEPDescrip#";
				document.getElementById("Ctipo").value= "#Form.Ctipo#";
				document.getElementById("CGEPctaBalance").value= "#Form.CGEPctaBalance#";
			</cfoutput>
		</cfif>

	});

	function changeTipo(ctl) {
		// Escoge el balance según el tipo de cuenta
		//ctl.form.CGARctaBalance.selectedIndex = (ctl.value == 'A' || ctl.value == 'G') ? 0 : 1;
		// Si la cuenta es de tipo ingreso o gasto solicita un subtipo para éstas
		<cfif isdefined("Form.balance") and Mid(trim(Form.balance),1,1) eq "C">
			ctl.form.CGEPctaBalance.selectedIndex = 1;
		<cfelse>
			<cfif isdefined("Form.balance") and Mid(trim(Form.balance),1,1) eq "D">
				ctl.form.CGEPctaBalance.selectedIndex = 0;
			</cfif>
		</cfif>
	}

	objForm1.ID_Estr.required = true;
	objForm1.ID_Estr.description = 'Tipo de Estructura';
	<!---objForm1.ID_Grupo.required = true;
	objForm1.ID_Grupo.description = 'Grupo para la Cuenta de Mayor';--->
	objForm1.Cmayor.required = true;
	objForm1.Cmayor.description = 'Cuenta Mayor';
	<!---changeTipo(document.form1.Ctipo);--->
</script>