<cf_templateheader title="Mantenimiento de Submenú del portal">
<cfif isdefined("url.id_menu") and not isdefined("form.id_menu")>
	<cfset form.id_menu = url.id_menu >
</cfif>

<cfif isdefined("form.id_menu")>
	<cfquery name="rsRoot" datasource="asp">
		select id_root
		from SMenu
		where id_menu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_menu#">
	</cfquery>
	<cfset url.root = rsRoot.id_root >
</cfif>
<cf_web_portlet_start titulo="Menúes para el portal ASP">
<cfinclude template="/home/menu/pNavegacion.cfm">
<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top" width="50%">
		
		<cfinclude template="SMenuItem-arbol.cfm">
	</td>
    <td valign="top">
		<cfinclude template="SMenuItem-form.cfm">
	</td>
  </tr>
</table>
<cf_web_portlet_end><cf_templatefooter>


