<cfif isdefined("Url.RHRCdesc_F") and not isdefined("Form.RHRCdesc_F")>
	<cfparam name="Form.RHRCdesc_F" default="#Url.RHRCdesc_F#">
</cfif>
<cfif isdefined("Url.RHRCestado_F") and not isdefined("Form.RHRCestado_F")>
	<cfparam name="Form.RHRCestado_F" default="#Url.RHRCestado_F#">
</cfif>
<cfif isdefined("Url.RHRCfdesde_F") and not isdefined("Form.RHRCfdesde_F")>
	<cfparam name="Form.RHRCfdesde_F" default="#Url.RHRCfdesde_F#">
</cfif>
<cfif isdefined("Url.RHRCfhasta_F") and not isdefined("Form.RHRCfhasta_F")>
	<cfparam name="Form.RHRCfhasta_F" default="#Url.RHRCfhasta_F#">
</cfif>
<cfif isdefined("Url.RHRCitems_F") and not isdefined("Form.RHRCitems_F")>
	<cfparam name="Form.RHRCitems_F" default="#Url.RHRCitems_F#">
</cfif>

<cfset navegacion = "">
<cfif isdefined("Form.RHRCdesc_F") and Len(Trim(Form.RHRCdesc_F)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHRCdesc_F=" & Form.RHRCdesc_F>
</cfif>
<cfif isdefined("Form.RHRCestado_F") and Len(Trim(Form.RHRCestado_F)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHRCestado_F=" & Form.RHRCestado_F>
</cfif>
<cfif isdefined("Form.RHRCfdesde_F") and Len(Trim(Form.RHRCfdesde_F)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHRCfdesde_F=" & Form.RHRCfdesde_F>
</cfif>
<cfif isdefined("Form.RHRCfhasta_F") and Len(Trim(Form.RHRCfhasta_F)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHRCfhasta_F=" & Form.RHRCfhasta_F>
</cfif>
<cfif isdefined("Form.RHRCitems_F") and Len(Trim(Form.RHRCitems_F)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHRCitems_F=" & Form.RHRCitems_F>
</cfif>

<form action="actCompetencias.cfm" method="post" style="margin:0" name="form1">
	<cfoutput>
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="areafiltro">
			<tr>
				<td width="9%" align="right"><strong>Descripción:</strong></td>
				<td width="31%">
				<input tabindex="0" name="RHRCdesc_F" type="text" value="<cfif isdefined("form.RHRCdesc_F") and len(trim(form.RHRCdesc_F)) gt 0>#form.RHRCdesc_F#</cfif>" size="50" maxlength="80">
				</td>
				<td width="13%" align="right" nowrap><strong>Fecha desde:</strong></td>
				<td width="13%">
					<cfif isdefined('form.RHRCfdesde_F') and form.RHRCfdesde_F NEQ ''>
						<cf_sifcalendario value="#LSDateFormat(form.RHRCfdesde_F,'dd/mm/yyyy')#" name="RHRCfdesde_F"> 
					<cfelse>	
						<cf_sifcalendario value="" name="RHRCfdesde_F"> 
					</cfif>				
				</td>
				<td width="5%" align="right"><strong>Items:</strong></td>
				<td width="12%" nowrap><input class="areafiltro" name="RHRCitems_F" type="radio" value="H" <cfif isdefined('form.RHRCitems_F') and form.RHRCitems_F EQ 'H'> checked</cfif>>
Habilidades </td>
				<td width="17%" nowrap><input class="areafiltro" name="RHRCitems_F" type="radio" value="A"  <cfif isdefined('form.RHRCitems_F') and form.RHRCitems_F EQ 'A'> checked</cfif>> 
				  Ambos</td>
			</tr>
			<tr>
				<td align="right"><strong>Estado:</strong></td>
				<td>
				<select name="RHRCestado_F" tabindex="0">
				<option value="-1">Todos</option>
				<option value="0" <cfif  isdefined("form.RHRCestado_F") and form.RHRCestado_F eq 0>selected</cfif>>En Proceso</option>
				<option value="10" <cfif  isdefined("form.RHRCestado_F") and form.RHRCestado_F eq 10>selected</cfif>>Habilitada</option>
				<option value="20" <cfif  isdefined("form.RHRCestado_F") and form.RHRCestado_F eq 20>selected</cfif>>Terminada</option>
				</select></td>
				<td align="right"><strong>Fecha hasta:</strong></td>
				<td>
					<cfif isdefined('form.RHRCfhasta_F') and form.RHRCfhasta_F NEQ ''>
						<cf_sifcalendario value="#LSDateFormat(form.RHRCfhasta_F,'dd/mm/yyyy')#" name="RHRCfhasta_F"> 
					<cfelse>	
						<cf_sifcalendario value="" name="RHRCfhasta_F"> 
					</cfif>				</td>
				<td align="center">&nbsp;			    </td>
			<td nowrap><input class="areafiltro" name="RHRCitems_F" type="radio" value="C" <cfif isdefined('form.RHRCitems_F') and form.RHRCitems_F EQ 'C'> checked</cfif>>
Conocimientos</td>
	        <td width="17%" nowrap align="center" valign="middle"><input tabindex="0" name="btnBuscar" type="submit" id="btnBuscar5" value="Filtrar"></td>
			</tr>
		</table>
	</cfoutput>		
</form>
<script language="javascript" type="text/javascript">
	var f = document.form1;
	f.RHRCdesc_F.focus();
</script>
