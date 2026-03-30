<cfoutput>
<table width="100%" border="0" style="background-color:##ccc;border:1px solid ##999; padding:1px; border-bottom: 1px solid ##333; border-right: 1px solid ##333">
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td align="right" style="font-size: 12px;" width="58%"><strong><cfif isdefined("session.menues.SMcodigo") and trim(session.menues.SMcodigo) eq 'AUTO'><cf_translate  key="LB_Autogestion">Autogesti&oacute;n</cf_translate><cfelse><cf_translate  key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate></cfif></strong></td>
					<td align="right" style="padding-right:3px;" width="42%"><span class="toprightitems">
					<cfoutput>#session.Usulogin#, #session.CEnombre#</cfoutput>
					</span></td>
				</tr>
				<!---<tr>
					<td align="right" style="padding-right:3px;"><span class="toprightitems">
					<cfoutput>#session.Usulogin#, #session.CEnombre#</cfoutput>
				</span></td>
				</tr>
				--->
			</table>
		</td>
	</tr>
</table>
</cfoutput>