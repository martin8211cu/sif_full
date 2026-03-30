<cfcomponent>

    <cffunction  name="run" returntype="boolean">

    <cftry>
        <cfset migrationsPath = GetDirectoryFromPath(ExpandPath('/asp/admin/dbmigrate/db/migrate/')) />

        <cfdirectory action="list" directory="#migrationsPath#" name="listRoot">
        <cfloop query="listRoot">
            <cfset y =left(listRoot.name, 4)>
            <cfif  y lt "2020">
                <cfset _file = "#migrationsPath##listRoot.name#">
                <cfif FileExists(_file)>
                    <cffile action = "delete" file = "#_file#">
                </cfif>
            </cfif>
        </cfloop>

        <cfreturn true>
    <cfcatch type="any">
        <cfreturn false>
    </cfcatch>
    </cftry>

    </cffunction>
    
</cfcomponent>