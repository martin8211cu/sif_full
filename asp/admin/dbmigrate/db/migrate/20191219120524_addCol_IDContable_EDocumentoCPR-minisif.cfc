<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_IDContable_EDocumentoCPR">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='EDocumentosCPR', columnType='numeric', columnName='IDContable', default='', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='EDocumentosCPR',columnName='IDContable');
    </cfscript>
  </cffunction>
</cfcomponent>
