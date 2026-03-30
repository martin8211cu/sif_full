<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Modificacion_Tabla_Documentos_HDocumentos">
  <cffunction name="up">
    <cfscript>
    addColumn( table='Documentos', columnType='date', columnName='EDfechacontrarecibo', null=true);
    addColumn(table='HDocumentos', columnType='date', columnName='EDfechacontrarecibo', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
     removeColumn(table='Documentos',columnName='EDfechacontrarecibo');
     removeColumn(table='HDocumentos',columnName='EDfechacontrarecibo');
    </cfscript>
  </cffunction>
</cfcomponent>
