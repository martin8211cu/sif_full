
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="RHParametros adicionales">
  <cffunction name="up">
    <cfscript>
    t = changeTable('RHParametros');
    t.string(columnNames='Pcategoria', null=true, limit='100');
	t.string(columnNames='TipoDato', null=true, limit='1');
  	t.string(columnNames='TipoParametro', null=true, limit='10');
  	t.string(columnNames='Parametros', null=true, limit='500');
	t.boolean(columnNames='Adicional', null=true);
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='RHParametros',columnName='Pcategoria');
	removeColumn(table='RHParametros',columnName='TipoDato');
	removeColumn(table='RHParametros',columnName='TipoParametro');
	removeColumn(table='RHParametros',columnName='Parametros');
	removeColumn(table='RHParametros',columnName='Adicional');
    </cfscript>
  </cffunction>
</cfcomponent>

		
