<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Grupos de Anexos" 
returnvariable="LB_Titulo" xmlfile="index.xml"/>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfif isdefined("url.GAid") and len(trim(url.GAid))><cfset form.GAid = url.GAid></cfif>
<cfquery name="rsAnexoGrupo" datasource="#session.dsn#">
	select GAid, GAcodigo, GAnombre, GAdescripcion, GApadre, GAruta, GAprofundidad, ts_rversion
	from AnexoGrupo
	where CEcodigo = #session.cecodigo#
</cfquery>

<cfparam name="nav__SPdescripcion" default="#LB_Titulo#">
<cfif isdefined("nav__SPdescripcion")>
	<cfset LvarTitulo = #nav__SPdescripcion#>
<cfelse>
	<cfset LvarTitulo ="">
</cfif>
<cfoutput>
	<cf_templateheader title="#LB_Titulo#">
		#pNavegacion#
			<cf_web_portlet_start titulo="#LB_Titulo#">
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td valign="top" align="center"><cfinclude template="arbol.cfm"></td>
						<td><cfinclude template="form.cfm"></td>
					</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
</cfoutput>