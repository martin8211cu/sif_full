<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="alter table HSalarioEmpleado add SErenta142">
  <cffunction name="up">
    <cfscript>
    t = changeTable('HSalarioEmpleado');
    t.money(columnNames="SErenta142", null=true);
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='HSalarioEmpleado',columnName='SErenta142');
    </cfscript>
  </cffunction>
</cfcomponent>

		
