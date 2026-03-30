<cfcomponent>
	<!---►►►procesaCaracteres: Funcion encargada de cambiar los caracteres inválidos en un archivo XML◄◄◄--->
	<cffunction name="procesaCaracteres" access="public" returnType="string" hint="Funcion encargada de cambiar los caracteres inválidos en un archivo XML">
		<cfargument name="hilera" type="string" required="Yes">
        <cfreturn "#hilera#">
	</cffunction>
	<!---►►►quitaCaracteres:Funcion encargada de eliminar los caracteres > 128 en un archivo XML◄◄◄--->
	<cffunction name="quitaCaracteres" access="public" returnType="string" hint="Funcion encargada de eliminar los caracteres > 128 en un archivo XML">
		<cfargument name="hilera" type="string" required="Yes">
        <cfset hilera = Replace("#hilera#", "á", "a", "ALL") >
        <cfset hilera = Replace("#hilera#", "é", "e", "ALL") >
        <cfset hilera = Replace("#hilera#", "í", "i", "ALL") >
        <cfset hilera = Replace("#hilera#", "ó", "o", "ALL") >
        <cfset hilera = Replace("#hilera#", "ú", "u", "ALL") >
        <cfset hilera = Replace("#hilera#", "à", "a", "ALL") >
        <cfset hilera = Replace("#hilera#", "è", "e", "ALL") >
        <cfset hilera = Replace("#hilera#", "ì", "i", "ALL") >
        <cfset hilera = Replace("#hilera#", "ì", "o", "ALL") >
        <cfset hilera = Replace("#hilera#", "ù", "u", "ALL") >
        <cfset hilera = Replace("#hilera#", "Á", "A", "ALL") >
        <cfset hilera = Replace("#hilera#", "É", "E", "ALL") >
        <cfset hilera = Replace("#hilera#", "Í", "I", "ALL") >
        <cfset hilera = Replace("#hilera#", "Ó", "O", "ALL") >
        <cfset hilera = Replace("#hilera#", "Ú", "U", "ALL") >
        <cfset hilera = Replace("#hilera#", "À", "A", "ALL") >
        <cfset hilera = Replace("#hilera#", "È", "E", "ALL") >
        <cfset hilera = Replace("#hilera#", "Ì", "I", "ALL") >
        <cfset hilera = Replace("#hilera#", "Ò", "O", "ALL") >
        <cfset hilera = Replace("#hilera#", "Ù", "U", "ALL") >
        <cfset hilera = Replace("#hilera#", "ä", "a", "ALL") >
        <cfset hilera = Replace("#hilera#", "ë", "e", "ALL") >
        <cfset hilera = Replace("#hilera#", "ï", "i", "ALL") >
        <cfset hilera = Replace("#hilera#", "ö", "o", "ALL") >
        <cfset hilera = Replace("#hilera#", "ü", "u", "ALL") >
        <cfset hilera = Replace("#hilera#", "Ä", "A", "ALL") >
        <cfset hilera = Replace("#hilera#", "Ë", "E", "ALL") >
        <cfset hilera = Replace("#hilera#", "Ï", "I", "ALL") >
        <cfset hilera = Replace("#hilera#", "Ö", "O", "ALL") >
        <cfset hilera = Replace("#hilera#", "Ü", "U", "ALL") >
        <cfset hilera = Replace("#hilera#", "ñ", "n", "ALL") >
        <cfset hilera = Replace("#hilera#", "Ñ", "N", "ALL") >
        <cfset hilera = Replace("#hilera#", "¡", "", "ALL")  >
        <cfset hilera = Replace("#hilera#", "¿", "", "ALL")  >
        <cfset hilera = Replace("#hilera#", "´", "", "ALL")  >
		<cfreturn "#hilera#">
	</cffunction>
</cfcomponent>