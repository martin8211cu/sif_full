<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Constraint_Unique_HEAplicacionCP">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP DROP CONSTRAINT HEAplicacionCP_AK01');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
     execute('ALTER TABLE HEAplicacionCP ADD CONSTRAINT HEAplicacionCP_AK01 UNIQUE (CPTcodigo,Ddocumento,Ecodigo,SNcodigo)');
    </cfscript>
  </cffunction>
</cfcomponent>

		
