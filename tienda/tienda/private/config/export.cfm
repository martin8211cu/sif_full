<cfheader name="Content-Disposition" value="attachment; filename=mitienda.bak"
><cfheader name="tus nalgas: frias"
><cfcontent type="text/xml"
><?xml version="1.0" encoding="iso-8859-1" ?>
<tienda id="<cfoutput>#session.Ecodigo#</cfoutput>">
<cfset tablas = "Tienda,Categoria,Producto,ProductoCategoria,Presentacion,ArteTienda,FotoProducto,FotoPresentacion">
<cfloop list="#tablas#" index="tabla">
<cfflush interval="2048">
<data src="<cfoutput>#tabla#</cfoutput>">
<cfquery name="cat" datasource="#Session.DSN#">
select *
from #tabla#
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery><cfwddx input="#cat#" action="cfml2wddx">
</data>
</cfloop>
</export>