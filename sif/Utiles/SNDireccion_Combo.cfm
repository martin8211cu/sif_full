<cfquery name="rsDirecciones" datasource="#session.DSN#">
	select id_direccion,SNnombre as nombre,SNDtelefono
	from SNDirecciones
	where Ecodigo = #Session.Ecodigo#  
	and SNid = #url.SNid# 
	order by SNnombre
</cfquery>

<cfoutput>
<select name="id_direccion" id="id_direccion" tabindex="1">
	<cfloop query="rsDirecciones">
		<option value="#rsDirecciones.id_direccion#">#rsDirecciones.nombre#</option>
	</cfloop>
</select>
</cfoutput>





