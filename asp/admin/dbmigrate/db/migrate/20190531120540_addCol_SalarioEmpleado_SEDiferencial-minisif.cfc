<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_SalarioEmpleado_SEDiferencial">
  <cffunction name="up">
    <cfscript>
      execute("ALTER TABLE SalarioEmpleado ADD [SEDiferencial] [money] NULL");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("ALTER TABLE SalarioEmpleado DROP COLUMN SEDiferencial");
    </cfscript>
  </cffunction>
</cfcomponent>
