<cfset moreParams="">
<cfif isdefined("form.Pquien_CT") and len(trim(form.Pquien_CT))> <cfset moreParams= "&Pquien_CT="&form.Pquien_CT> </cfif>
<cfset Request.Error.Url = "gestion.cfm?cli=#form.cli#&tab=#form.tab##moreParams#">

<cfset duenno = Form.cli>
<cfset sufijo = "_CT">

<cfinclude template="/saci/vendedor/venta/representante-apply.cfm">

<cfinclude template="gestion-redirect.cfm">
