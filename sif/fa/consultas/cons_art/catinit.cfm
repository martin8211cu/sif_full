<cfif not isdefined("Session.lista_precios")>
	<cfquery datasource="#session.dsn#" name="LPid">
		select min (LPid) as LPid
		from EListaPrecios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and LPdefault = 1
	</cfquery>

	<cfif LPid.recordCount GT 0>
		<cfset session.lista_precios = LPid.LPid>
	</cfif>
</cfif>

<!--- Al inicio la categoria en session es 0 --->
<cfparam name="session.comprar_cat" default="0">
<!--- Al inicio si no viene categoria en url, la categoria en el url va a ser igual a lo que haya en session --->
<cfparam name="url.cat" type="numeric" default="#session.comprar_cat#">

<!--- Si al contrario, la categoria viene en url, entonces la categoria en session se sustituye por la de url --->
<cfif session.comprar_cat NEQ url.cat>
	<cfset session.comprar_cat = url.cat>
</cfif>

<!--- Averiguo los datos de la categoria seleccionada --->
<cfquery datasource="#session.dsn#" name="categoria">
	select c.Ccodigo, c.Cdescripcion, c.Ctexto
	from Clasificaciones c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
</cfquery>

<!--- Si la categoria no existe, se debe reiniciar tanto la categoria en session como la de url --->
<cfif categoria.recordCount EQ 0 and Url.cat>
	<cfset session.comprar_cat = "0">
	<cfset url.cat = "0">
</cfif>
