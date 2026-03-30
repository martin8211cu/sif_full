<cfcomponent output="no" hint="Este componente su utiliza para la traduccion de elemento dependiendo del LOCALE utilizado en el idioma">
	<cffunction name="date" output="false" returntype="string" access="public">
		<cfargument name="value"      type="string" required="yes">
		<cfargument name="Idioma"       type="string" default="">

		<cfset initFormatoFecha(arguments.Idioma)>
		<cfreturn LSdateFormat(arguments.value,request.idiomaFormatoFecha)>
	</cffunction>
	
	<cffunction name="number" output="false" returntype="string" access="public" hint="recibe 2 valores, number('valor','idioma') y retorna el formato del número a utilizar">
		<cfargument name="value"      type="string" required="yes">
		<cfargument name="Idioma"       type="string" default="">
		<cfreturn LSNumberFormat(arguments.value,'999,999,999.99')>
	</cffunction>
	
	<cffunction name="initFormatoFecha" >
    	<cfargument name="idiomaSuggest" type="string" default="">
        	<cfif not len(trim(arguments.idiomaSuggest)) and  isdefined("session.Idioma")>
            	<cfset arguments.idiomaSuggest= session.Idioma> 
            </cfif>
			<cfif not isdefined("request.idiomaFormatoFecha")>
				<cfset request.idiomaFormatoFecha = 'dd/mm/yyyy'>
                    <cftry>           
                        <cfquery datasource="sifcontrol" name="rsFF">
                            select Iformatofecha from Idiomas where Icodigo='#trim(arguments.idiomaSuggest)#'
                        </cfquery>
                        <cfif len(trim(rsFF.Iformatofecha))>
                            <cfset request.idiomaFormatoFecha =  rsFF.Iformatofecha>
                        </cfif>
                            <cfcatch type="any">
                            </cfcatch>
                    </cftry>	
             </cfif>	
	</cffunction>
	
</cfcomponent>
