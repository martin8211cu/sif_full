<cfquery datasource="sifcontrol" name="idiomas">
	select Iid,Icodigo,Descripcion,Icodigo as locale_lang
	from Idiomas
	order by Icodigo
</cfquery>
<cfloop query="idiomas">
	<cfset idiomas.locale_lang = Mid(idiomas.locale_lang,1,2)>
</cfloop>
<cfquery datasource="sifcontrol" name="grupos">
	select VSgrupo, VSnombre_grupo
	from VSgrupo
	order by VSgrupo
</cfquery>


<cfparam name="url.VSgrupo" default="">
<cfparam name="url.Iid" default="">

<cf_templateheader title="Traducción de etiquetas XML">

	<cf_web_portlet_start titulo="Traducción de etiquetas XML">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<cfinclude template="traduccionXML-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>


