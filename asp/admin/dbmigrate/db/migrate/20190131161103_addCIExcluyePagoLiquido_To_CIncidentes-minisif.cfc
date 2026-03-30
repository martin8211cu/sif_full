<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCIExcluyePagoLiquido_To_CIncidentes">
  <cffunction name="up">
    <cfscript>
      execute('alter table CIncidentes add CIExcluyePagoLiquido bit not null default 0');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('alter table CIncidentes drop column CIExcluyePagoLiquido');
    </cfscript>
  </cffunction>
</cfcomponent>

		
