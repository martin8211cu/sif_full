<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_HSalarioEmpleado_SEDiferencial">
  <cffunction name="up">
    <cfscript>
      execute("ALTER TABLE HSalarioEmpleado ADD [SEDiferencial] [money] NULL");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("ALTER TABLE HSalarioEmpleado DROP COLUMN SEDiferencial");
    </cfscript>
  </cffunction>
</cfcomponent>
