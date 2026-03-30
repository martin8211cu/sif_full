<cfinclude template="jedi-options.cfm">
<cfloop query="Menues">
	<cfset LCategory = "Operaciones">
	<cfset QuerySetCell(Menues,"Category","#LCategory#",CurrentRow)>
	<cfset QuerySetCell(Menues,"Name","&nbsp;#Name#",CurrentRow)>
</cfloop>
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		SIF - Cuentas por Cobrar
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet titulo="Men&uacute; Principal de Cuentas por Cobrar">
		<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
		  	<cfset col = 0>
			<cfoutput query="Menues" group="Category">
			<cfset show = true>
			<cfset col = col + 1>
			<td width="33%" valign="top">
				<br>
				<table width="100%"  align="center" border="0" cellpadding="0" cellspacing="0" bgcolor="##FFFFFF">
				  <cfoutput>
				  <tr>
					<td height="30" bgcolor="##99ADC2" style="font-weight: bold; color: ##FFFFFF">#Name#</td>
					<td height="30" bgcolor="##99ADC2" style="font-weight: bold; color: ##FFFFFF"><a href="##" style="color:##FFFFFF;">Nuevo</a>&nbsp;&nbsp;<a href="##" style="color:##FFFFFF;">Ir</a></td>
				  </tr>
				  <tr>
					<td colspan="2">
						<cfset show = false>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td>
								#Description#
							</td>
						  </tr>
						</table>
					</td>
				  </tr>
				  </cfoutput>
				</table>
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