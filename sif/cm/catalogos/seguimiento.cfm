<cfif isdefined("url.ERid") and not isdefined("form.ERid")>
	<cfset form.ERid = url.ERid >
</cfif>
<cfif isdefined("url.DRid") and not isdefined("form.DRid")>
	<cfset form.DRid = url.DRid >
</cfif>
<cfif isdefined("url.SRid") and not isdefined("form.SRid")>
	<cfset form.SRid = url.SRid >
</cfif>

<cf_templateheader title="Seguimiento de Reclamos">
		<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript" type="text/JavaScript">
			<!--//
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
			//-->
		</script>

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipo de Documento'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td colspan="2">
						<cfinclude template="../../portlets/pNavegacion.cfm">
					</td>
				</tr>

				<tr> 
					<td valign="top"> 
						<cfquery name="rsLista" datasource="#session.DSN#">
							select SRid, SRfecha, case SRestado when 0 then 'En Proceso' when 1 then 'Concluído' end as SRestado, #form.ERid# as ERid, #form.DRid# as DRid
							from SReclamos
							where DRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DRid#">
							order by SRfecha desc
						</cfquery>

						<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="SRfecha,SRestado"/>
							<cfinvokeargument name="etiquetas" value="Fecha,Estado"/>
							<cfinvokeargument name="formatos" value="D, V"/>
							<cfinvokeargument name="align" value="left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="seguimiento.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="SRid"/>
						</cfinvoke>
					</td>
					<td width="55%">
						<cfinclude template="seguimiento-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>