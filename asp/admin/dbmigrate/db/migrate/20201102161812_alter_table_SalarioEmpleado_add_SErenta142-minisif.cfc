<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="alter table SalarioEmpleado add SErenta142">
  <cffunction name="up">
    <cfscript>
    t = changeTable('SalarioEmpleado');
    t.money(columnNames="SErenta142", null=true);
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='SalarioEmpleado',columnName='SErenta142');
    </cfscript>
  </cffunction>
</cfcomponent>

		
