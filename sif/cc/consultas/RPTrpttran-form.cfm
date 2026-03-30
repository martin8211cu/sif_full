<cfif isdefined("url.Speriodo") and len(trim(url.Speriodo))>
	<cfset form.Speriodo = trim(url.Speriodo)>
</cfif>
<cfif isdefined("url.Smes") and len(trim(url.Smes))>
	<cfset form.Smes = trim(url.Smes)>
</cfif>
<cfif isdefined("url.Mcodigo") and len(trim(url.Mcodigo))>
	<cfset form.Mcodigo = trim(url.Mcodigo)>
</cfif>
<cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
	<cfset form.SNCEid = trim(url.SNCEid)>
</cfif>
<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
	<cfset form.SNCDvalor1 = trim(url.SNCDvalor1)>
</cfif>
<cfif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
	<cfset form.SNCDvalor2 = trim(url.SNCDvalor2)>
</cfif>

<cfset nEtiquetas = rsEtiquetas.recordcount + 4>
<cfif not isdefined("url.Impresion")>
	<cf_rhimprime datos="/sif/cc/consultas/RPTrpttran-form.cfm" paramsuri="&Speriodo=#form.Speriodo#&Smes=#form.Smes#&Mcodigo=#form.Mcodigo#&SNCDvalor1=#form.SNCDvalor1#&SNCDvalor2=#form.SNCDvalor2#&Impresion=1">
	<cfinclude template="RPTrpttran-report.cfm">
<cfelse>
	<cfinclude template="RPTrpttran-report.cfm">
	<br />
</cfif>
