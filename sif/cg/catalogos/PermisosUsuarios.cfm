<cfif isdefined("Url.PCRGid") and (not isdefined("Form.PCRGid") or not len(trim(Form.PCRGid)))>
	<cfset Form.PCRGid = Url.PCRGid>
</cfif>

<cfquery name="rsgrupo" datasource="#session.DSN#">
	select PCRGcodigo, PCRGDescripcion from PCReglaGrupo
	where PCRGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRGid#">
</cfquery>

<cf_templateheader title="Permisos de Usuarios">
<cf_web_portlet_start _start titulo="Permisos por Usuario">
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
					Grupo: <cfoutput>#rsgrupo.PCRGcodigo# - #rsgrupo.PCRGDescripcion#</cfoutput>
				</div> 
			</td>
		</tr>
		<tr>
			<td align="center" width="54%" valign="top">
				<cfinclude template="PermisosUsuarios_list.cfm">
			</td>
			
			<td align="center" width="50%" valign="top">
				<cfinclude template="PermisosUsuarios_form.cfm">
			</td>
		</tr>
	</table>
		
	<cf_web_portlet_start _end>
<cf_templatefooter>