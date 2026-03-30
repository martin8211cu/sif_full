<cfif isdefined('url.sel') and not isdefined('form.sel')>
	<cfset form.sel = url.sel>
</cfif>
<!--- Para la llave de Conceptos --->
<cfif isdefined('url.IREid') and not isdefined('form.IREid')>
	<cfset form.IREid = url.IREid>
</cfif>
<cfif isdefined('url.Estado') and not isdefined('form.Estado')>
	<cfset form.Estado = url.Estado>
</cfif>
