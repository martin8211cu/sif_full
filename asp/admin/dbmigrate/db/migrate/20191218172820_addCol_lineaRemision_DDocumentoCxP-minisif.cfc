<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_lineaRemision_DDocumentoCxP">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='DDocumentosCxP', columnType='numeric', columnName='DRemisionlinea', default='', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='DDocumentosCxP',columnName='DRemisionlinea');
    </cfscript>
  </cffunction>
</cfcomponent>
