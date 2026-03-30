<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio") or isdefined('form.RHPcodigo') and len(trim(form.RHPcodigo)) gt 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>


<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<form name="form1" method="post" action="SQLPerfilPuesto.cfm">
<cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td align="right" width="20%"></td>
      <td align="left" width="80%"></td>
    </tr>
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr>
      <td colspan="2" align="right">&nbsp;</td>
    </tr>
	<tr> 
      <td align="left" colspan="2">
 		<fieldset><legend><cf_translate key="LB_Mision" >Misi&oacute;n</cf_translate></legend>
			<table width="100%" border="0">
				<tr>
					<td>
						<cfif isdefined('rsForm.RHDPmision') and len(trim(rsForm.RHDPmision)) gt 0>
							<cf_sifeditorhtml  name="RHDPmision" value="#Trim(rsForm.RHDPmision)#" tabindex="1" height="150"> 
						<cfelse>
							<cf_sifeditorhtml  name="RHDPmision" tabindex="1" height="150"> 
						</cfif>
					</td>
				</tr>
			</table>
		</fieldset>
      </td>
    </tr>	
	<tr> 
      <td align="left" colspan="2">
 		<fieldset><legend><cf_translate key="LB_Responsabilidad" >Responsabilidad</cf_translate></legend>
			<table width="100%" border="0">
				<tr>
					<td>
						<cfif isdefined('rsForm.RHDPobjetivos') and len(trim(rsForm.RHDPobjetivos)) gt 0>
							<cf_sifeditorhtml  name="RHDPobjetivos" value="#Trim(rsForm.RHDPobjetivos)#" tabindex="1" height="150"> 
						<cfelse>
							<cf_sifeditorhtml  name="RHDPobjetivos" tabindex="1" height="150"> 
						</cfif>
					</td>
				</tr>
			</table>
		</fieldset>
      </td>
    </tr>	
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
	  <td colspan="2">
		<input type="hidden" name="RHDPPid" 		id="RHDPPid" value="#Trim(rsForm.RHDPPid)#">
		<input type="hidden" name="RHPcodigo" 		id="RHPcodigo" value="#Trim(rsForm.RHPcodigo)#">
		<input type="hidden" name="Observaciones" 	id="Observaciones" value="">
		<input type="hidden" name="Boton" 	        id="Boton" value="">
		<input name="sel"    type="hidden" value="1">
		<input name="o" 	 type="hidden" value="1">
		<input name="USUARIO" 	 type="hidden" value="#FORM.USUARIO#">
	  </td>
	</tr>
  </table>
</cfoutput>
</form>
