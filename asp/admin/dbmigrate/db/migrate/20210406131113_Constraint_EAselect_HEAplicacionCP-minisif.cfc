<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Constraint_EAselect_HEAplicacionCP">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP ADD CONSTRAINT HEAplicacionCP_CK12 CHECK ((EAselect=(1) OR EAselect=(0)))');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP DROP CONSTRAINT HEAplicacionCP_CK12');
    </cfscript>
  </cffunction>
</cfcomponent>

		
