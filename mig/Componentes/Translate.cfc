<cfcomponent output="no">
<!---
	Traduce etiquetas de un archivo XML
	Para traducciones basadas en sifcontrol.VSidioma, utilice TranslateDB.cfc
	Modificado, danim, 2006-09-11 para guardar los XML en Request y no estarlos
	leyendo cada vez
--->
	<cffunction name="Translate" output="false" returntype="string" access="public">
		<cfargument name="Key"          type="string" required="yes">
		<cfargument name="Default"      type="string" required="yes">
		<cfargument name="XmlFile"      type="string" default="">
		<cfargument name="Idioma"       type="string" default="">
		
		<cfif isdefined("session.traducir") and not session.traducir >
			<cfreturn Arguments.Default>
		</cfif>

		<cftry>
			<cfset Arguments.Idioma = Trim(Arguments.Idioma)>
			<cfif Len(Trim(Arguments.Idioma)) is 0>
				<cfif IsDefined('url.lang')>
					<cfset Arguments.Idioma = trim(url.lang) >
				<cfelseif IsDefined('session.Idioma')>
					<cfset Arguments.Idioma = trim(session.Idioma) >
				<cfelse>
					<cfset Arguments.Idioma = 'es_CR'>
				</cfif>
			</cfif>
		
			<cfif Len(Trim(Arguments.XmlFile))>
				<cfset AbsoluteXMLFile = ExpandPath(Arguments.XmlFile)>
			<cfelse>
				<!--- sacar el nombre sin extension --->
				<cfset AbsoluteXMLFile = GetTemplatePath()>
				<cfset AbsoluteXMLFile = GetDirectoryFromPath(AbsoluteXMLFile) & ListFirst(GetFileFromPath(AbsoluteXMLFile), '.') & ".xml">	
				<cfif Len(trim(Arguments.Idioma)) gt 6>
					<!--- Toma la ruta a partir de /sif/.../.... y crea una nueva ruta basada en el directorio locales --->
					<cfset AbsoluteXMLFile = expandpath('/locales' & mid(AbsoluteXMLFile, len(expandPath(""))+1, (len(AbsoluteXMLFile)-len(expandPath("")))))>
					<!--- recupera la estructura de directorios basada en locales, solo para verificar si no existe para crearla --->
					<cfset directory = GetDirectoryFromPath(AbsoluteXmlFile)>
					<cfif not directoryexists(directory)>
						<cfdirectory action="create" directory="#directory#">
					</cfif>
				</cfif>	
			</cfif>
			
			<cfif FileExists(AbsoluteXMLFile)>
				<cfset xml = OpenXML(AbsoluteXMLFile)>
				<cfset Valor = GetLabel(xml, Arguments.Idioma, Arguments.Key)>
				<cfif Len(trim(Valor))> <!--- Encontro el dato ---->
					<cfreturn (Valor)>
				</cfif>
			</cfif>
	
			<cfif ListLen(Arguments.Idioma, '_') LT 2>
				<cfset AgregarRecordatorio(AbsoluteXMLFile, Arguments.Idioma, Arguments.Key, Arguments.Default)>
				<cfreturn (Arguments.Default)>
			<cfelse>
				<!--- saca el idioma padre del idioma actual. Ej: es_CR_NAC ==> es_CR, es_CR ==> es --->
				<cfset LvarIdioma = Reverse(ListRest(Reverse(Arguments.Idioma), '_'))>
				<cfreturn Translate(arguments.key, arguments.Default, arguments.XmlFile, LvarIdioma) >
			</cfif>
		<cfcatch type="any">
			<cflog file="translate" text="Translate (File=#Arguments.XmlFile#, Key=#Arguments.Key#), #cfcatch.Message# #cfcatch.Detail#">
			<cfreturn Arguments.Default>
		</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="GetLabel" access="public" output="false">
		<cfargument name="xml">
		<cfargument name="Idioma">
		<cfargument name="Key">
		
		<!---Parche, por ahora, se debe encontrar todos los lugares donde se envia este Key y eliminar los :--->
		<cfif Arguments.Key EQ 'Error_La_zona_economica_ya_esta_definida_en_la_corporacion_debe_utilizar_un_codigo:distinto_Proceso_Cancelado'>
			<cfset Arguments.Key = 'Error_La_zona_economica_ya_esta_definida_en_la_corporacion_debe_utilizar_un_codigo_distinto_Proceso_Cancelado'>
		</cfif>
		<!---<cfset var nodo = XmlSearch(Arguments.xml, "//Idioma[@id='" & Trim(Arguments.Idioma) & "']/" & Trim(Arguments.Key))>--->
		
		<cfset nodo = XmlSearch(Arguments.xml, "//Idioma[@id='" & Trim(Arguments.Idioma) & "']/" & Trim(Arguments.Key))>
		<cfif ArrayLen(nodo)>
			<cfreturn Trim(StripCR(Trim(nodo[1].XmlText)))>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>
	
	<cffunction name="OpenXML" access="public" output="false">
		<cfargument name="AbsoluteFileName">
		<!--- Se usa un hash para reducir el tamaño del nombre del archivo y quitar los caracteres extraños --->
		<cfset var key = Hash(AbsoluteFileName)>
		<cfparam name="Request.TranslationCache" default="#StructNew()#">
		
		<cfif StructKeyExists(Request.TranslationCache, key)>
			<cfreturn Request.TranslationCache[Key]>
		<cfelse>
			<cffile action="read" file="#Arguments.AbsoluteFileName#" variable="FileContents">
			<cfset value = XmlParse(FileContents, true)>
			<cfset Request.TranslationCache[key] = value>
			<cfreturn value>
		</cfif>
	</cffunction>
	
	<cffunction name="SaveXML" output="no">
		<cfargument name="AbsoluteFileName">
		<cfargument name="xml">
		<!---
			El BOM es 0xfeff , pero en UTF-8 se ve como ef bb bf
		--->
		<cfset Byte_Order_Marker = BinaryDecode('efbbbf', 'Hex')>
		
		<cftry>
		<cffile action='write' file='#AbsoluteFileName#' 
			output='#Byte_Order_Marker#' addnewline="yes" 
			nameconflict="overwrite" >
			
		<cffile action='append' file='#AbsoluteFileName#' 
			output='#ToString(xml)#' addnewline="yes" 
			nameconflict="overwrite"  charset="utf-8" >
		<cfcatch type="any">
		</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="NewXML" access="public" output="false">
		<cfset MyNewDoc = XmlNew(true)>
		<cfset MyNewDoc.xmlRoot = XmlElemNew(MyNewDoc, "Etiquetas")>	
		<cfreturn MyNewDoc>
	</cffunction>
	
	<cffunction name="UpdateXML" access="public" output="false">
		<cfargument name="xml">
		<cfargument name="Idioma">
		<cfargument name="Key">
		<cfargument name="NewValue">
		<!--- ---->

		<cfset xpath_idioma = "//Idioma[@id='" & Trim(Arguments.Idioma) & "']">
		<cfset arguments.xml = UpdateIdiomaXML(arguments.xml, Arguments.Idioma, xpath_idioma )>
		<cfset n_idioma = XmlSearch(arguments.xml, xpath_idioma)>
		<cfset n_idioma = n_idioma[1]>

		<cfset xpath_etiqueta = xpath_idioma & "/" & Trim(Arguments.Key)>
		<cfset search_etiqueta = XmlSearch(Arguments.xml, xpath_etiqueta)>
		
		<cfif ArrayLen(search_etiqueta)>
			<cfset nodo_etiqueta = search_etiqueta[1]>
			<cfset nodo_etiqueta.XmlText = Trim(Arguments.NewValue)>
		<cfelse>
			<cfset nodo_etiqueta = XmlElemNew(Arguments.xml, Trim(Arguments.Key))>
			<cfset nodo_etiqueta.XmlText = Trim(Arguments.NewValue)>
			<cfset ArrayAppend(n_idioma.XmlChildren, nodo_etiqueta)>
		</cfif>

		<!---
			por alguna extraña razón la expresión siguiente debe estar dentro del if, y no se puede factorizar 
			danim, 21/10/2004
			<cfset nodo_etiqueta.XmlText = Trim(Arguments.NewValue)>
		--->
		
	</cffunction>
	
	<cffunction name="UpdateIdiomaXML" output="false" hint="Agrega el idioma si no existe">
		<cfargument name="xml">
		<cfargument name="Idioma">
		<cfargument name="xpath_idioma">
		
		<cfset n_idioma = XmlSearch(Arguments.xml, Arguments.xpath_idioma)>
		<cfif not ArrayLen(n_idioma)>
			<cfset n_idioma = XmlElemNew(Arguments.xml, "Idioma")>
			<cfset n_idioma.XmlAttributes["id"] = Arguments.Idioma>
			<cfset ArrayAppend(Arguments.xml.xmlRoot.XmlChildren, n_idioma)>
		</cfif>
		<cfreturn arguments.xml >
	</cffunction>

	<cffunction name="init" output="no">
		<cfreturn this >
	</cffunction>
	
	<cffunction name="AgregarRecordatorio" output="false" returntype="void">
		<cfargument name="AbsoluteFileName">
		<cfargument name="Idioma">
		<cfargument name="Key">
		<cfargument name="Default">
		<cfset var rootdir = ExpandPath("")>
		<cfset var ruta = Mid(Arguments.AbsoluteFileName, Len(rootdir) + 1, Len(Arguments.AbsoluteFileName) - Len(rootdir)  )>
		<cfset ruta = replace(ruta,'\','/', 'ALL')>
		<cfquery datasource="#session.dsn#" name="AgregarRecordatorio_Q" cachedwithin="#CreateTimeSpan(0,0,15,0)#">
			select count(1) as cantidad
			from VSnuevo
			where ruta = '#ruta#'
			  and entrada = '#Arguments.Key#'
		</cfquery>
		<cfif AgregarRecordatorio_Q.cantidad is 0>
			<cfquery datasource="#session.dsn#">
				insert into VSnuevo (ruta, entrada, valor_default)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ruta#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Key#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Default#">)
			</cfquery>
			<cflog file="translate" text="Pendiente de traducir: #ruta#, #Arguments.Key#, #Arguments.Default#">
		</cfif>
	</cffunction>
	
</cfcomponent>
