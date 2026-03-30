<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addColumns_To_RHPTUE">
  <cffunction name="up">
    <cfscript>
      addColumn(table='RHPTUE', columnType='string', columnName='EIRid', null=true);
      addColumn(table='RHPTUE', columnType='numeric', columnName='RHPTUECantDias', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='RHPTUE',columnName='EIRid');
    removeColumn(table='RHPTUE',columnName='RHPTUECantDias');
    </cfscript>
  </cffunction>
</cfcomponent>
