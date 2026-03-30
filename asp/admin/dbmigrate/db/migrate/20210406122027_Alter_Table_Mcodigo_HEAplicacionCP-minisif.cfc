<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Alter_Table_Mcodigo_HEAplicacionCP">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP ALTER COLUMN Mcodigo NUMERIC (8, 0)');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP ALTER COLUMN Mcodigo NUMERIC (18, 0)');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		
