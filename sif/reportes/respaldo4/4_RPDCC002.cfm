<cfparam name="url.Dreferencia" default="">

<cfif isdefined ('url.Dreferencia') and len(trim(url.Dreferencia)) >
	<cfset Dreferencia=url.Dreferencia>
</cfif>
<cfif isdefined ('url.Dreferencia') >
	<cfset Dreferencia=url.Dreferencia>
</cfif>

<cfif isdefined('rsIdioma.valor') >
	<cfset Idioma= rsIdioma.valor >
<cfelse>
	<cfset Idioma= '' >
</cfif>
<cfif isdefined ('url.Idioma') >
	<cfset Idioma=url.Idioma>
</cfif>

<cfif isdefined('rsFirma.firma') >
	<cfset firma= rsFirma.firma >
<cfelse>
	<cfset firma= '' >
</cfif>
<cfif isdefined ('url.firmaAutorizada') >
	<cfset firma=url.firmaAutorizada>
</cfif>

<cfif isdefined('url.CCTtipo') >
	<cfset CCTtipo= url.CCTtipo >
<cfelse>
	<cfset CCTtipo= '' >
</cfif>
<cfif isdefined ('url.CCtipo') >
	<cfset CCTtipo=url.CCtipo>
</cfif>


<cfquery datasource="#session.dsn#" name="rsReporte">
	execute sp_FDocumentosCC
	@Ecodigo = #session.Ecodigo#
	, @Dreferencia = #Dreferencia#
	, @Idioma = #Idioma#
	, @firmaAutorizada = '#firma#'
	, @CCtipo = '#CCTtipo#'
</cfquery>
<cfreport format="flashpaper" template="4_RPDCC002.cfr" query="rsReporte"></cfreport>
