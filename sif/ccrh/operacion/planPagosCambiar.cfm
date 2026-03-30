
<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfparam name="form.DEid" default="#url.DEid#">
</cfif>

<cfif isdefined("url.Did") and not isdefined("form.Did")>
	<cfparam name="form.Did" default="#url.Did#">
</cfif>

<cfif isdefined("url.TDid") and len(trim(url.TDid))>
	<cfparam name="form.TDid2" default="#url.TDid#">
</cfif>
<cfif isdefined("form.TDid2") and len(trim(form.TDid2))>
	<cfparam name="form.TDid" default="form.TDid2">
</cfif>	

<cfif isdefined("url.TDid2") and len(trim(url.TDid2))>
	<cfparam name="form.TDid2" default="#url.TDid2#">
</cfif>
<cfif isdefined("form.TDid") and len(trim(form.TDid)) and not isdefined("form.TDid2")>
	<cfparam name="form.TDid2" default="#form.TDid#">
</cfif>
<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->

<cfset navegacion = "">
<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>	
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif>
<cfif isdefined("Form.TDid2") and Len(Trim(Form.TDid2)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TDid2=" & Form.TDid2>
</cfif>
<cfif isdefined("Form.Did") and Len(Trim(Form.Did)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Did=" & Form.Did>
</cfif>


	<cf_templateheader title="Cuentas por Cobrar Empleados">

	
	
	<cf_templatecss>
		<cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Modificar Plan de Pagos'>
						<cfinclude template="../../portlets/pNavegacion.cfm">
						<table width="98%" border="0" align="center" cellpadding="2" cellspacing="0">
							<tr>
								<td colspan="2">
									<cfinclude template="/sif/portlets/pEmpleado.cfm">
								</td>
							</tr>
							
							<tr><!--- <cfdump var="#navegacion#"> --->
								<td valign="top" width="50%"><cfinclude template="planPagos-Actual.cfm"></td>
								<td valign="top" width="50%"><cfinclude template="planPagosCambiar-form.cfm"></td>
							</tr>
							
						</table>
						<br>
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>
		</cfoutput>
		<script language="JavaScript1.2">
		</script>		  
	<cf_templatefooter>