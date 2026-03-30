<cfparam name="Attributes.form" type="string" default="form">
<cfparam name="Attributes.desde" default="">
<cfparam name="Attributes.hasta" default="">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr >
	  <td colspan="3" align="left" valign="middle" nowrap >&nbsp;</td>
  </tr>
	<tr >
	  <td colspan="3" align="left" valign="middle" nowrap bgcolor="#ECE9D8">
	  Periodo de Vigencia
	  </td>
  </tr>
	<tr >
	  <td nowrap align="left" valign="middle">&nbsp;</td>
	  <td nowrap align="left" valign="middle">&nbsp;</td>
	  <td valign="middle">&nbsp;</td>
  </tr>
	<tr >
	  <td nowrap align="left" valign="middle">&nbsp;</td> 
		<td nowrap align="left" valign="middle">Desde:</td>
			<td valign="middle">
		<cfif Len(Attributes.desde) EQ 0>
				<cf_sifcalendario 
					name="vigente_desde" 
					form="#Attributes.form#"
					value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
		<cfelse>
				<cf_sifcalendario name="vigente_desde" form="#Attributes.form#"
					value="#LSDateFormat(Attributes.desde,'DD/MM/YYYY')#">
		</cfif>
			</td>
			</tr><tr>
		<td nowrap valign="middle" align="left">&nbsp;</td>
		<td nowrap valign="middle" align="left">Hasta:&nbsp;</td>
			<td nowrap valign="middle">
		<cfif Len(Attributes.hasta) EQ 0>
				<cf_sifcalendario 
					name="vigente_hasta" 
					form="#Attributes.form#"
					value="01/01/6100"> 
		<cfelse>
				<cf_sifcalendario name="vigente_hasta" form="#Attributes.form#" 
					value="#LSDateFormat(Attributes.hasta,'DD/MM/YYYY')#">
		</cfif>				
			</td>
	</tr>
</table>
