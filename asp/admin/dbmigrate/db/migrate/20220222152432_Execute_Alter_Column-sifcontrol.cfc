<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Execute_Alter_Column">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE CSATObjImpuesto ADD ts_rversion timestamp');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE CSATObjImpuesto DROP COLUMN ts_rversion');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		
