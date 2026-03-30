<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Constraint_Unique_HDAplicacionCP">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE HDAplicacionCP ADD CONSTRAINT HDAplicacionCP_AK01 UNIQUE (ID,DAlinea,SNcodigo,DAdocref,DAtransref,Ecodigo)');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE HDAplicacionCP DROP CONSTRAINT HDAplicacionCP_AK01');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
