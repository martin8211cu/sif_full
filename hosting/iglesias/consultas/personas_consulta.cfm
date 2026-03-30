<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Consulta de Feligreses
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="../pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
	<cfset ArrayAppend(navBarItems,'Donaciones')>
	<cfset ArrayAppend(navBarLinks,'/cfmx/hosting/iglesias/donacion.cfm')>
	<cfset ArrayAppend(navBarStatusText,'Menú de Donaciones')>
	<cfset Regresar = "/cfmx/hosting/iglesias/consultas/personas_lista.cfm">
	<cfinclude template="../pNavegacion.cfm">
	<cfif isdefined("Url.MEpersona") and not isdefined("Form.MEpersona")>
		<cfparam name="Form.MEpersona" default="#Url.MEpersona#">
	</cfif>
	<cfset navegacion = "">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "MEpersona=" & Form.MEpersona>
	<cfif isdefined("form.MEpersona") and len(trim(form.MEpersona)) gt 0>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td rowspan="3">&nbsp;</th>
			<td>&nbsp;</td>
			<td rowspan="3">&nbsp;</td>
			<td>&nbsp;</td>
			<td rowspan="3">&nbsp;</td>
			<td>&nbsp;</td>
			<td rowspan="3">&nbsp;</td>
		  </tr>
		  <tr>
			<td valign="top"><cfinclude template="personas_infopersonal.cfm"><cfinclude template="personas_familiares.cfm"></td>
			<td valign="top"></td>
			<td valign="top"><cfinclude template="personas_donaciones.cfm"></td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td align="center" colspan="7">
			<cfif isdefined("form.Parentesco")>
				<input type="button" value="Regresar" onClick="javascript:history.back();">
			</cfif>
			</td>
		  </tr>
		</table>
	<cfelse>
		<cflocation url="personas_lista.cfm">
	</cfif>
</cf_templatearea>
</cf_template>