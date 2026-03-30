<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="ModificarTablaRHListaEvalDes">
  <cffunction name="up">
    <cfscript>
       t = changeTable('RHListaEvalDes');
	    t.numeric(columnNames="LTid");
	    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
       removeColumn(table='RHListaEvalDes',columnName='LTid');
    </cfscript>
  </cffunction>
</cfcomponent>
