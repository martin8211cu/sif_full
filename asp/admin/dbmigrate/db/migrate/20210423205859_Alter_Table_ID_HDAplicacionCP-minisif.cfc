<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Alter_Table_ID_HDAplicacionCP">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE HDAplicacionCP DROP CONSTRAINT HDAplicacionCP_PK');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE HDAplicacionCP ADD CONSTRAINT HDAplicacionCP_PK PRIMARY KEY (ID,DAlinea)');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
