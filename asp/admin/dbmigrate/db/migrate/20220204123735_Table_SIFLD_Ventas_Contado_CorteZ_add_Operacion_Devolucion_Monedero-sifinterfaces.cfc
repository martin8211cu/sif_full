<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Table_SIFLD_Ventas_Contado_CorteZ_add_Operacion_Devolucion_Monedero">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='SIFLD_Ventas_Contado_CorteZ', columnType='money', columnName='Operacion_Devolucion_Monedero', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='SIFLD_Ventas_Contado_CorteZ',columnName='Operacion_Devolucion_Monedero');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		
