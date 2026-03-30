<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr align="center"> 
    <td align="center" width="5%">&nbsp;</td>
    <td align="center" width="65%" valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr align="center">
				<td align="center">
					<br>
						<cf_web_portlet titulo="Eventos Próximos" skin="#Session.Preferences.Skin#" border="true" tituloalign="left">
							<cfset Eve = 1> <cfset Pub = 0> <cfset Scroll = 0> <cfinclude template="Menu/Eventos.cfm">
						</cf_web_portlet>
					<br>
				</td>
			</tr>
			<tr align="center">
				<td align="center">
					<br>
						<cf_web_portlet titulo="Eventos Pasados" skin="#Session.Preferences.Skin#" border="true" tituloalign="left">
							<cfset Eve = 2> <cfset Pub = 0> <cfset Scroll = 0> <cfinclude template="Menu/Eventos.cfm">
						</cf_web_portlet>
					<br>
				</td>
			</tr>
		</table>
	</td>
    <td align="center" width="5%">&nbsp;</td>
    <td width="20%" rowspan="2" align="center" valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr align="center">
				<td align="center">
					<cfinclude template="Menu/Entidad.cfm">
				</td>
			</tr>
			<tr align="center">
				<td align="center">
					<!--- <cfset Eve = 1> <cfset Pub = 1> <cfset Scroll = 1> <cfinclude template="Menu/Eventos.cfm"> --->
					<br>
						<cf_web_portlet titulo="Eventos Públicos" skin="#Session.Preferences.Skin#" border="true">
							<div align="center">
								<iframe id="datamain" src="Menu/Eventos.cfm?Eve=1&Pub=1&Scroll=1" width=150 height=250 marginwidth=0 marginheight=0 hspace=0 vspace=0 frameborder=0 scrolling=no></iframe>
							</div>
						</cf_web_portlet>
					<br>
				</td>
			</tr>
		</table>
	</td>
    <td align="center" width="5%">&nbsp;</td>
  </tr>
</table>
