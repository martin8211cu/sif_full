<cfset params= "">
<cfif isdefined("Form.tab") and Len(Trim(Form.tab))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "tab=" & Form.tab>
</cfif>
<cfif isdefined("Form.CGARid") and Len(Trim(Form.CGARid)) and not isdefined("Form.Baja")>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "CGARid=" & Form.CGARid>
</cfif>
<cfif isdefined("Form.PageNum_lista1") and Len(Trim(Form.PageNum_lista1))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista1=" & Form.PageNum_lista1>
<cfelseif isdefined("Form.PageNum1") and Len(Trim(Form.PageNum1))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista1=" & Form.PageNum1>
</cfif>

<cfif isdefined("Form.fCGARcodigo") and Len(Trim(Form.fCGARcodigo))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGARcodigo=" & Form.fCGARcodigo>
</cfif>
<cfif isdefined("Form.fCGARdescripcion") and Len(Trim(Form.fCGARdescripcion))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGARdescripcion=" & Form.fCGARdescripcion>
</cfif>
<cfif isdefined("Form.fCGARresponsable") and Len(Trim(Form.fCGARresponsable))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGARresponsable=" & Form.fCGARresponsable>
</cfif>
<cflocation url="AreaResponsabilidad.cfm#params#">

