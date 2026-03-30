<!--- Regenera CategoriaRelacion, no modifica el orden --->
<cfparam name="fix_Ecodigo" type="numeric">

<cftransaction>
<!--- Reconstruir CategoriaRelacion --->
<cfquery datasource="#session.dsn#">
delete CategoriaRelacion
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fix_Ecodigo#">
</cfquery>

<!--- Self --->
<cfquery datasource="#session.dsn#" name="">
insert CategoriaRelacion (Ecodigo, hijo, distancia, ancestro)
select Ecodigo, id_categoria, 0, id_categoria
from Categoria
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fix_Ecodigo#">
</cfquery>

<!--- Padres --->
<cfquery datasource="#session.dsn#" name="">
insert CategoriaRelacion (Ecodigo, hijo, distancia, ancestro)
select Ecodigo, id_categoria, 1, categoria_padre
from Categoria
where id_categoria != 0
  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fix_Ecodigo#">
</cfquery>

<!--- Abuelos --->
<cfset nivel = 1>

<cfloop from="1" to="10" index="nivel">
	<cfoutput>Nivel: #nivel#<br></cfoutput>
	<cfquery datasource="#session.dsn#" name="inserted">
		insert CategoriaRelacion (Ecodigo, hijo, distancia, ancestro)
		select a.Ecodigo, a.hijo, a.distancia + 1, b.ancestro
		from CategoriaRelacion a, CategoriaRelacion b
		where a.ancestro = b.hijo
		  and a.distancia = <cfqueryparam cfsqltype="cf_sql_integer" value="#nivel#">
		  and b.distancia = 1
		  and a.Ecodigo = b.Ecodigo
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fix_Ecodigo#">
		  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fix_Ecodigo#">
		  and a.hijo != 0
		  and not exists (select *
			from CategoriaRelacion c
			where c.hijo = a.hijo
			  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fix_Ecodigo#">
			  and c.ancestro = b.ancestro
			  and c.Ecodigo = a.Ecodigo
			  and c.Ecodigo = b.Ecodigo)
		select @@rowcount as rowsAffected
	</cfquery>
	<cfif inserted.rowsAffected is 0><cfbreak></cfif>
</cfloop>
</cftransaction>