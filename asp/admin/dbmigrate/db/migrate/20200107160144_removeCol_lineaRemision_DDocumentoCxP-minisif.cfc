<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="removeCol_lineaRemision_DDocumentoCxP">
  <cffunction name="up">
    <cfscript>
		removeColumn(table='DDocumentosCxP',columnName='DRemisionlinea');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
	    addColumn(table='DDocumentosCxP', columnType='numeric', columnName='DRemisionlinea', default='', null=true);
    </cfscript>
  </cffunction>
</cfcomponent>
