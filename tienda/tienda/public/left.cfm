<table width="100%">
<cfoutput query="categorias">
<cfif formato EQ 'O'>
<tr><td align="center" valign="top">
<!--- solamente incluir ofertas --->
<cfinclude template="menu_oferta.cfm">
</td></tr>
</cfif>
</cfoutput>
</table>
