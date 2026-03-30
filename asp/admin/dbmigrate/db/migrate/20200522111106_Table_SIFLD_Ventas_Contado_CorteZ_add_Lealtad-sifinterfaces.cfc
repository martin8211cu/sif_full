
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Table SIFLD_Ventas_Contado_CorteZ add Lealtad">
  <cffunction name="up">
    <cfscript>
    t = changeTable('SIFLD_Ventas_Contado_CorteZ');
    t.money(columnNames='Monedero_Acumula', null=true);
    t.money(columnNames='Devolucion_Monedero_Acumula', null=true);
    t.money(columnNames='Operacion_FP_Monedero', null=true);
    t.money(columnNames='Monedero_Saldo_Reinicio', null=true);
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='SIFLD_Ventas_Contado_CorteZ',columnName='Monedero_Acumula');
    removeColumn(table='SIFLD_Ventas_Contado_CorteZ',columnName='Devolucion_Monedero_Acumula');
    removeColumn(table='SIFLD_Ventas_Contado_CorteZ',columnName='Operacion_FP_Monedero');
    removeColumn(table='SIFLD_Ventas_Contado_CorteZ',columnName='Monedero_Saldo_Reinicio');
    </cfscript>
  </cffunction>
</cfcomponent>

		
