<cfinclude template="jedi-options.cfm">
<cfloop query="Menues">
	<cfif CurrentRow mod 2 eq 0>
		<cfset LCategory = "Administración de Documentos">
	<cfelse>
		<cfset LCategory = "Administración de Clientes">
	</cfif>
	<cfset QuerySetCell(Menues,"Category","#LCategory#",CurrentRow)>
</cfloop>
<cfquery name="rsMenues" dbtype="query">
	select * 
	from Menues
	order by Category
</cfquery>
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		SIF - Cuentas por Cobrar
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet titulo="Men&uacute; Principal de Cuentas por Cobrar">
		<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
		  	<cfset col = 0>
			<cfoutput query="rsMenues" group="Category">
			<cfset show = true>
			<cfset col = col + 1>
			<td width="33%" valign="top">
				<br>
				<cf_web_portlet titulo="#Category#">
				<table width="100%"  align="center" border="0" cellpadding="0" cellspacing="0" >
				  <cfoutput>
				  <tr>
					<td width="0" height="30" style="font-weight: bold;">#Name#</td>
				  </tr>
				  <tr>
					<td>
						<cfset show = false>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td>
								<p>#Description#</p>
							</td>
						  </tr>
						</table>
					</td>
				  </tr>
				  </cfoutput>
				</table>
				</cf_web_portlet>
				<br>
			</td>
			<td width="1%">&nbsp;</td>
			</cfoutput>
			<td width="33%" valign="top">
				<table width="95%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td><cfinclude template="/sif/cc/MenuConsultasCC2.cfm"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td><cfinclude template="/sif/cc/MenuCatalogosCC2.cfm"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td><cfinclude template="/sif/cc/MenuReportesCC2.cfm"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
				</table>
			</td>
		  </tr>
		</table>
		</cf_web_portlet>
</cf_templatearea>
</cf_template>