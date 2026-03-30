<cfset IDtrans = 7>
 <cfif isdefined("form.BTNNUEVO")>
	<cfset form.AGTPid = ''>
</cfif><!--- --->
<cfinclude template="agtProceso_genera.cfm">