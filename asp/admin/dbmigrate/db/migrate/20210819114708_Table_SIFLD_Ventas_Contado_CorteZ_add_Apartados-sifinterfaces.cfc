<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Table SIFLD_Ventas_Contado_CorteZ add Refacturacion:">
  <cffunction name="up">
    <cfscript>
    t = changeTable('SIFLD_Ventas_Contado_CorteZ');
    t.money(columnNames='Operacion_Recibos', null=true);
    t.money(columnNames='Operacion_Recibo_Apartado', null=true);
    t.money(columnNames='Operacion_Apartado_Cancela', null=true);
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='SIFLD_Ventas_Contado_CorteZ',columnName='Operacion_Recibos');
    removeColumn(table='SIFLD_Ventas_Contado_CorteZ',columnName='Operacion_Recibo_Apartado');
    removeColumn(table='SIFLD_Ventas_Contado_CorteZ',columnName='Operacion_Apartado_Cancela');
    </cfscript>
  </cffunction>
</cfcomponent>

		
