<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<cfset url.tipoCuenta = 0>

<!---<cfif isdefined('application.myappvarCC')>
<cfoutput>#application.myappvarCC#</cfoutput>
</cfif>
--->
<cfif isdefined('application.myappvarCC') and #application.myappvarCC# eq "1">
	<cfinclude template="ProcesoOcupado.cfm">
<cfelse>
	<cflock type="EXCLUSIVE" timeout="10"><cfset application.myappvarCC="1"></cflock>
	<cfinclude template="AplicRevMasivo.cfm">
</cfif>

