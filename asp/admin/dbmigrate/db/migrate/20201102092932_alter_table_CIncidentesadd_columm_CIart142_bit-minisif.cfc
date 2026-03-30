
  <cfcomponent extends="asp.admin.dbmigrate.Migration" hint="alter table CIncidentesadd columm CIart142 bit ">
  <cffunction name="up">
    <cfscript>
    t = changeTable('CIncidentes');
    t.boolean(columnNames="CIart142", null=true);
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='CIncidentes',columnName='CIart142');
    </cfscript>
  </cffunction>
</cfcomponent>

		
