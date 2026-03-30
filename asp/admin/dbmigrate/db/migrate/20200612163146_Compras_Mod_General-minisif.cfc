<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Compras_Mod_General">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='CMTipoOrden', columnType='boolean', columnName='CMTOModGeneral', default='0', null=false);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      removeColumn(table='CMTipoOrden',columnName='CMTOModGeneral');
    </cfscript>
  </cffunction>
</cfcomponent>
