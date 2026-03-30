
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="EFormato add EFDiasAntesVencimiento">
  <cffunction name="up">
    <cfscript>
    t = changeTable('EFormato');
    t.integer(columnNames="EFDiasAntesVencimiento", null=true);
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='EFormato',columnName='EFDiasAntesVencimiento');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
