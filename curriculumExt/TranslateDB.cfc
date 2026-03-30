<cfcomponent output="no">
<!---
	Traduce etiquetas de un archivo XML
	Para traducciones basadas en sifcontrol.VSidioma, utilice TranslateDB.cfc
--->

<cfset This.Grupo_Meses      =   1 >
<cfset This.Grupo_SSistemas  = 101 >
<cfset This.Grupo_SModulos   = 102 >
<cfset This.Grupo_SProcesos  = 103 >
<cfset This.Grupo_SRoles     = 104 >
<cfset This.Grupo_SMenues    = 105 >
<cfset This.Grupo_SPortlet   = 121 >
<cfset This.Grupo_SPagina    = 122 >
<cfset This.Grupo_SMenu      = 123 >
<cfset This.Grupo_SMenuItem  = 124 >
<cfset This.Grupo_Monedas    = 201 >
<cfset This.Grupo_Pais       = 202 >

	<cffunction name="Translate" output="false" returntype="string" access="public">
		<cfargument name="VSvalor"      type="string"  required="yes" hint="Llave por obtener (Mes, Sistema, Modulo, etc)">
		<cfargument name="Default"      type="string"  required="yes">
		<cfargument name="VSgrupo"      type="numeric" required="yes" hint="Tipo de valor (1=Mes, 101=Sistema, etc)">
		<cfargument name="Idioma"       type="string"  default="">
		
		<cfif Len(Arguments.Idioma) is 0>
			<cfif IsDefined('url.lang')>
				<cfset Arguments.Idioma = url.lang>
			<cfelseif IsDefined('session.Idioma')>
				<cfset Arguments.Idioma = session.Idioma>
			<cfelse>
				<cfset Arguments.Idioma = 'es_CR'>
			</cfif>
		</cfif>
		
		<cfquery datasource="sifcontrol" name="translate_idioma" maxrows="1" cachedwithin="#CreateTimeSpan(0,0,10,0)#">
			select Iid
			from Idiomas
			where Icodigo = '#Arguments.Idioma#'
			<cfif Len(Arguments.Idioma) GT 3>
			   or Icodigo = '#Mid(Arguments.Idioma,1,2)#'
			</cfif>
			order by Icodigo desc
		</cfquery>
		<cfif translate_idioma.RecordCount>
			<cfquery datasource="sifcontrol" name="translate_query" maxrows="1" cachedwithin="#CreateTimeSpan(0,0,10,0)#">
				select VSdesc
				from VSidioma
				where Iid     = #translate_idioma.Iid#
				  and VSgrupo = #Arguments.VSgrupo#
				  and VSvalor = '#Arguments.VSvalor#'
			</cfquery>
			<cfif Len(Trim(translate_query.VSdesc))>
				<cfreturn translate_query.VSdesc>
			</cfif>
		</cfif>
		<cfreturn Arguments.Default>
		
	</cffunction>
</cfcomponent>