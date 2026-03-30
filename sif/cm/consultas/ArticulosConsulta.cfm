<cfparam name="url.formulario" default="form1">
<cfparam name="url.Ecodigo" default="#session.Ecodigo#">
<cfquery name="rsValidar" datasource="#session.DSN#">
	Select Aid, Acodigo, Adescripcion
    from Articulos 
    where Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.CodArt#">
    and Ecodigo in (#url.Empresas#)
</cfquery>

<cfset index = 1>
<cfif url.opcion eq 2>
	<cfset index = 2>
</cfif>

<cfoutput>
	<script language="javascript1.2" type="text/javascript">
		<cfif rsValidar.recordCount gt 0>
			window.parent.document.#url.formulario#.IDArt#index#.value = #rsValidar.Aid#;
			window.parent.document.#url.formulario#.codigoArticulo#index#.value = '#trim(rsValidar.Acodigo)#';
			window.parent.document.#url.formulario#.NombreArticulo#index#.value = '#trim(rsValidar.Adescripcion)#';
		<cfelse>
			window.parent.document.#url.formulario#.IDArt#index#.value = "";
			window.parent.document.#url.formulario#.codigoArticulo#index#.value = "";
			window.parent.document.#url.formulario#.NombreArticulo#index#.value = "";
		</cfif>
	</script>
</cfoutput>