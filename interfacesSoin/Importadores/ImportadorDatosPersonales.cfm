<cfsilent>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_nav__SPdescripcion" 
	Default="#nav__SPdescripcion#" 
	returnvariable="LB_nav__SPdescripcion"/>
<cfquery name="rsImportador" datasource="sifcontrol">
	select EIid, EIcodigo
	from EImportador
	where EIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="IMPDATPER">
</cfquery>
<cfif rsImportador.RecordCount EQ 0>
	<cfthrow message="No se encontró el importador seleccionado">
</cfif>
</cfsilent>
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td width="60%" valign="top">
					<cf_sifFormatoArchivoImpr EIcodigo="#rsImportador.EIcodigo#">
				</td>
				<td align="center" width="40%" valign="top">
					<cf_sifimportar EIcodigo="#rsImportador.EIcodigo#" EIid="#rsImportador.EIid#" mode="in"/>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>