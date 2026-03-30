<cfif Not IsDefined("session.comprar_Ecodigo")>
	<cflocation url="seleccione_tienda.cfm">
</cfif>
<cfquery datasource="#session.dsn#" name="CategoriasQuery" >
	select c.id_categoria, c.nombre_categoria, c.formato
	from Categoria c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
	order by c.orden_relativo, c.nombre_categoria
</cfquery>

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">Tienda en línea</cf_templatearea>
	<cf_templatearea name="body">
		<cfinclude template="estilo.cfm">
		
<table width="100%" border="0">

<cfoutput query="CategoriasQuery">
<tr>
  <cfif formato EQ 'I'>
	  <td><cfinclude template="menu_item.cfm"></td>
  <cfelseif formato EQ 'L'>
	  <tr  ><td><cfinclude template="menu_lista.cfm"></td>
  <cfelseif formato EQ 'M'>
	  <td><cfinclude template="menu_matriz.cfm"></td>
  <cfelseif formato EQ 'O'>
  <!---  ya apareció en left.cfm
  <td><cfinclude template="cat-oferta.cfm"></td>
  --->
  <cfelse>
	  <td><cfinclude template="menu_item.cfm"></td>
  </cfif>
</tr>
</cfoutput>
</table>

	</cf_templatearea>
</cf_template>
