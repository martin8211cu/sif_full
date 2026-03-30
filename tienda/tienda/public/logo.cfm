<cfquery datasource="#session.dsn#" name="arte_tienda" >
	select txt_pie_foto
	from ArteTienda
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
</cfquery>
<table width="100%">
<tr> 
  <td align="center" valign="middle"><img src="/cfmx/tienda/tienda/public/tienda_img.cfm?id=<cfoutput>#session.comprar_Ecodigo#</cfoutput>" width="108" alt=""></td>
</tr>
<tr> 
  <td align="center" valign="middle"><cfoutput>#arte_tienda.txt_pie_foto#</cfoutput></td>
</tr></table>