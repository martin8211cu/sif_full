<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Modifica RHEducacionEmpleado">
  <cffunction name="up">
    <cfscript>
    t = changeTable('RHEducacionEmpleado');
    t.boolean(columnNames="RHEnf", null=true);
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='RHEducacionEmpleado',columnName='RHEnf');
    </cfscript>
  </cffunction>
</cfcomponent>

		
