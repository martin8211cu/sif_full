<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="RHOTitulo add  RHOTnf ">
  <cffunction name="up">
    <cfscript>
    t = changeTable('RHOTitulo');
    t.boolean(columnNames="RHOTnf", default="0", null=true);
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='RHOTitulo',columnName='RHOTnf');
    </cfscript>
  </cffunction>
</cfcomponent>

		
