<cfcomponent>
	<cffunction name="getProcesos" access="remote" returntype="array" returnFormat="json"> 
	    <cfargument name="search" type="any" required="false" default="">   

        <cfinvoke component="asp.Componentes.Procesos" method="getProcesoByUser" returnvariable="LvarRetorn">
        	<cfinvokeargument name="search" value="#arguments.search#">
        	<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
        	<cfinvokeargument name="idioma" value="#session.idioma#">
        </cfinvoke>
        
        <cfreturn LvarRetorn/> 
    </cffunction>
    
</cfcomponent>