<!--- PARAMETROS DE LA PANTALLA QUE PUEDEN VENIR POR URL --->
<cfif isdefined("url.ERfechahasta") and len(trim(url.ERfechahasta))>
	<cfset form.ERfechahasta = url.ERfechahasta>
</cfif>
<cfif isdefined("url.Alm_Aiddesde") and len(trim(url.Alm_Aiddesde))>
	<cfset form.Alm_Aiddesde = url.Alm_Aiddesde>
</cfif>
<cfif isdefined("url.ERdocumento") and len(trim(url.ERdocumento))>
	<cfset form.ERdocumento = url.ERdocumento>
</cfif>
<cfif isdefined("url.Alm_Aidhasta") and len(trim(url.Alm_Aidhasta))>
	<cfset form.Alm_Aidhasta = url.Alm_Aidhasta>
</cfif>
<cfif isdefined("url.CFiddesde") and len(trim(url.CFiddesde))>
	<cfset form.CFiddesde = url.CFiddesde>
</cfif>
<cfif isdefined("url.CFidhasta") and len(trim(url.CFidhasta))>
	<cfset form.CFidhasta = url.CFidhasta>
</cfif>
<cfif isdefined("url.TRcodigo") and len(trim(url.TRcodigo))>
	<cfset form.TRcodigo = url.TRcodigo>
</cfif>
<cfif isdefined("url.Formato") and len(trim(url.Formato))>
	<cfset form.Formato = url.Formato>
</cfif>
<cfif isdefined("url.Tipo") and len(trim(url.Tipo))>
	<cfset form.Tipo = url.Tipo>
</cfif>
<cfif isdefined("url.Detallado") and len(trim(url.Detallado))>
	<cfset form.Detallado = url.Detallado>
</cfif>
<cfif isdefined("url.rptpaso") and len(trim(url.rptpaso))>
	<cfset form.rptpaso = url.rptpaso>
</cfif>
<!--- VALORES POR DEFECTO DE PARAMETROS DE LA PANTALLA --->
<cfparam name="form.ERfechadesde" default="#LSDateFormat(CreateDate(Year(Now()),Month(Now()),01),'dd/mm/yyyy')#">
<cfparam name="form.ERfechahasta" default="#LSDateFormat(Now(),'dd/mm/yyyy')#">
<cfparam name="form.ERdocumento" default="">
<cfparam name="form.Alm_Aiddesde" default="0">
<cfparam name="form.Alm_Aidhasta" default="0">
<cfparam name="form.CFiddesde" default="0">
<cfparam name="form.CFidhasta" default="0">
<cfparam name="form.TRcodigo" default="">
<cfparam name="form.Formato" default="html">
<cfparam name="form.Tipo" default="resumido">
<cfparam name="form.rptpaso" default="1">