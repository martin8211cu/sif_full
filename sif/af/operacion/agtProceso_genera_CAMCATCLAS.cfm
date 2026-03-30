<cfset IDtrans = 6>
 <cfif isdefined("form.BTNNUEVO")>
	<cfset form.AGTPid = ''>
</cfif><!--- --->
<cfinclude template="agtProceso_genera.cfm">