<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Alter_Table_ID_HEAplicacionCP ">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP DROP CONSTRAINT HEAplicacionCP_PK');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP ADD CONSTRAINT HEAplicacionCP_PK PRIMARY KEY (ID)');
    </cfscript>
  </cffunction>
</cfcomponent>

		
