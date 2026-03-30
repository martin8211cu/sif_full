<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="create RH_CalculoISR">
  <cffunction name="up">
    <cfscript>
      t = createTable(name='RH_CalculoISR');
      t.numeric(columnNames='RCNid', null=true);
	  t.numeric(columnNames='DEid', null=true);
	  t.numeric(columnNames='Ecodigo', null=true);
	  t.money(columnNames='SalarioM', null=true);
	  t.money(columnNames='SalarioMensual', null=true);
	  t.integer(columnNames='DiasPeriodo', null=true);
	  t.money(columnNames='BaseGravableMensual', null=true);
	  t.money(columnNames='TLIMSubInf', null=true);
	  t.money(columnNames='TPorcentajeAnt', null=true);
	  t.money(columnNames='TMontoAnt', null=true);                
	  t.money(columnNames='RentaMens', null=true);
	  t.money(columnNames='RentaReal', null=true);
	  t.money(columnNames='SubsidioMens', null=true);
	  t.money(columnNames='TMontoSub', null=true);
	  t.money(columnNames='TMontoSubsidioEntregado', null=true);
	  t.money(columnNames='Retencion', null=true);
	  t.money(columnNames='TotalGravable', null=true);
	  t.money(columnNames='TotalIsrAjustado', null=true);
	  t.money(columnNames='TotalIsrDeterminado', null=true);
	  t.money(columnNames='TotalIsrDetm', null=true);
	  t.money(columnNames='TotalIsrM', null=true);
	  t.money(columnNames='TotalSubsidioCausado', null=true);
	  t.money(columnNames='TotalSubsidioEntregado', null=true);
	  t.money(columnNames='TotalSubsidioPagado', null=true);
	  t.money(columnNames='TotalSubsidioTabla', null=true);
      t.create();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      dropTable('RH_CalculoISR');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
