<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<cfset url.tipoCuenta = 1>
<cfif isdefined('application.myappvarCP') and #application.myappvarCP# eq "1">
	<cfinclude template="ProcesoOcupado.cfm">
<cfelse>
	<cflock type="EXCLUSIVE" timeout="10"><cfset application.myappvarCP="1"></cflock>
	<cfinclude template="AplicRevMasivo.cfm">
</cfif>



