<cfif isdefined("Url.PCEcatid") and (not isdefined("Form.PCEcatid") or not len(trim(Form.PCEcatid)))>
	<cfset Form.PCEcatid = Url.PCEcatid>
</cfif>

<cfquery name="rsCatalogo" datasource="#session.DSN#">
	select PCEcodigo, PCEdescripcion from PCECatalogo
	where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatid#">
</cfquery>

<cf_templateheader title="Administradores por Catálogo">
<cf_web_portlet_start _start titulo="Administradores por Catálogo">
	<table>
	<tr>
		<td bgcolor="#999999" width="100%" valign="top">
			<cf_navegacion name="Edescripcion" default="" navegacion="">
		</td>
	</tr>
	</table>
	
	<cf_navegacion name="Ususcodigo" default="" navegacion="">
		
	<table width="100%" align="center">
		<tr> 		
			<td colspan="2"  class="tituloListas">
				<div align="left" style="background-color:#E5E5E5; font-size:13px;">			
					Catálogo: <cfoutput>#rsCatalogo.PCEcodigo# - #rsCatalogo.PCEdescripcion#</cfoutput>
				</div> 
			</td>
		</tr>
		<tr>
			<td align="center" width="54%" valign="top">
				<cfinclude template="UsuxCatalogo_list.cfm">
			</td>
			
			<td align="center" width="50%" valign="top">
				<cfinclude template="UsuxCatalogo_form.cfm">
			</td>
		</tr>
	</table>
		
	<cf_web_portlet_start _end>
<cf_templatefooter>