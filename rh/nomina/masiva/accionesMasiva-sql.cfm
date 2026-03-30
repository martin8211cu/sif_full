<cfsetting requesttimeout="#3600*24#">

<cfif isdefined("Form.paso")>
	<cfif Form.paso EQ 1>
		<cfinclude template="accionesMasiva-sqlpaso1.cfm">
	<cfelseif Form.paso EQ 2>
		<cfinclude template="accionesMasiva-sqlpaso2.cfm">
	<cfelseif Form.paso EQ 3>
		<cfinclude template="accionesMasiva-sqlpaso3.cfm">
	<cfelseif Form.paso EQ 4>
		<cfinclude template="accionesMasiva-sqlpaso4.cfm">
	<cfelseif Form.paso EQ 5>
		<cfinclude template="accionesMasiva-sqlpaso5.cfm">
	<cfelseif Form.paso EQ 6>
		<cfinclude template="accionesMasiva-sqlpaso6.cfm">
	<cfelse>
	
	</cfif>
</cfif>

<cfset params = "">
<cfif isdefined("Form.paso") and Len(Trim(Form.paso))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "paso=" & Form.paso>
</cfif>
<cfif isdefined("Form.RHAid") and Len(Trim(Form.RHAid))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "RHAid=" & Form.RHAid>
</cfif>
<cfif isdefined("Form.RHAnua") and Len(Trim(Form.RHAnua))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "RHAnua=" & Form.RHAnua>
</cfif>


<cfif isdefined("form.paso") and form.paso EQ 6 and isdefined("Form.btnAplicar")>
	<cflocation url="accionesMasiva.cfm">
<cfelse>
	<cflocation url="accionesMasiva.cfm#params#">
</cfif>
