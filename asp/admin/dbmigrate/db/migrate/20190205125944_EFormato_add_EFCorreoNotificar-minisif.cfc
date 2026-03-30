<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="EFormato add EFCorreoNotificar">
  <cffunction name="up">
    <cfscript>
    t = changeTable('EFormato');
    t.string(columnNames="EFCorreoNotificar", null=true, limit="50");
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='EFormato',columnName='EFCorreoNotificar');
    </cfscript>
  </cffunction>
</cfcomponent>

		
