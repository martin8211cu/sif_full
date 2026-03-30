<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Table SIFLD_Ventas_Contado_CorteZ add Refacturacion:">
  <cffunction name="up">
    <cfscript>
    t = changeTable('SIFLD_Ventas_Contado_CorteZ');
    t.money(columnNames='Operacion_Fiscal_Devolucion', null=true);
    t.money(columnNames='Operacion_Refactura', null=true);
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='SIFLD_Ventas_Contado_CorteZ',columnName='Operacion_Fiscal_Devolucion');
    removeColumn(table='SIFLD_Ventas_Contado_CorteZ',columnName='Operacion_Refactura');
    </cfscript>
  </cffunction>
</cfcomponent>

		
