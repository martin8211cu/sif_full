<cfinclude template="catinit.cfm">
<cfset ruta = ArrayNew(1)>
<cfset desc = ArrayNew(1)>

<div style="border-top:1px solid blue; border-bottom:1px solid blue; padding:4px">
<a href="catview.cfm?cat=0" class="catview_link">Categor&iacute;as</a>

<cfif url.cat>
	<cfquery datasource="#session.dsn#" name="catpath_this">
		select Cpath
		from Clasificaciones c
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	</cfquery>
    <cfinclude template="../../../Utiles/sifConcat.cfm">
	<cfquery datasource="#session.dsn#" name="catpath_query">
		select c.Ccodigo, c.Cdescripcion
		from Clasificaciones c
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and <cfqueryparam cfsqltype="cf_sql_varchar" value="#catpath_this.Cpath#"> like c.Cpath #_Cat# '%'
		order by Cnivel
	</cfquery>
	<cfoutput query="catpath_query">
		&gt;
		<a href="catview.cfm?cat=#Ccodigo#" class="catview_link">#Cdescripcion#</a>
	</cfoutput>
</cfif>
</div>