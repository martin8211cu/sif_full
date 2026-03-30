<cfif isdefined("LvarInfo")>
	<cfset LvarAction = '../../INFO/catalogos/formCatalogoCuentasMINFO.cfm'>
<cfelse>
	<cfset LvarAction = 'formCatalogoCuentasM.cfm'>
</cfif>

<cfif isdefined("url.CGICMid") and len(trim(url.CGICMid)) and not isdefined("form.CGICMid")>
	<cfset form.CGICMid = url.CGICMid>
</cfif>
<cfif isdefined("url.CGICCid") and len(trim(url.CGICCid)) and not isdefined("form.CGICCid")>
	<cfset form.CGICCid = url.CGICCid>
</cfif>
<cfif isdefined("url.modo") and len(trim(url.modo)) and not isdefined("form.modo")>
	<cfset form.modo = url.modo>
</cfif>

<cfquery name="rs" datasource="#session.dsn#">
	select m.CGICMcodigo, m.CGICMnombre
	from CGIC_Mapeo m
	where m.CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
</cfquery>
<cfinvoke key="LB_Titulo" default="Mapeo de Cuentas" returnvariable="LB_Titulo" component="sif.Componentes.Translate" 
method="Translate" xmlfile="CatalogoCuentasM.xml"/>

<cf_templateheader title="#LB_Titulo#">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#: #rs.CGICMcodigo#: #rs.CGICMnombre#'>
			<cfset filtro = "">
			<cfset navegacion = "">
	
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr> 
				<td colspan="2"><cfinclude template="../../portlets/pNavegacionCG.cfm"></td>
			  </tr>
			  <tr><td colspan="2"><table width="100%" align="center"><tr><td align="right"></td></tr></table></td></tr>
			  <tr> 
				<td valign="top" colspan="2"><cfinclude template="#LvarAction#">&nbsp;</td>
			  </tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>