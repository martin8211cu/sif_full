<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_lineaFactura_DDocumentoCPR">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='DDocumentosCPR', columnType='numeric', columnName='DFacturalinea', default='', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='DDocumentosCPR',columnName='DFacturalinea');
    </cfscript>
  </cffunction>
</cfcomponent>
