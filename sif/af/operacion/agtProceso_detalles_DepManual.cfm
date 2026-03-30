<cfif isdefined("Url.AGTPid")>
	<cfset form.AGTPid = Url.AGTPid>
</cfif>
<cfset IDtrans = 4>
<cfinclude template="agtProceso_listaTransac.cfm">

