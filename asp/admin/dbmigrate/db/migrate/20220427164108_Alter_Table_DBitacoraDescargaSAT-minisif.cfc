<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Alter_Table_DBitacoraDescargaSAT">
  <cffunction name="up">
    <cfscript>
    t = changeTable('DBitacoraDescargaSAT');
    t.string(columnNames="tipoComprobante", default="", null=true, limit="2");
    t.string(columnNames="versionComprobante", default="", null=true, limit="5");
	t.money(columnNames="TotalIVA", default="0.00", null=true);
    t.money(columnNames="TotalIEPS", default="0.00", null=true);
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='DBitacoraDescargaSAT',columnName='tipoComprobante');
	removeColumn(table='DBitacoraDescargaSAT',columnName='versionComprobante');
	removeColumn(table='DBitacoraDescargaSAT',columnName='TotalIVA');
	removeColumn(table='DBitacoraDescargaSAT',columnName='TotalIEPS');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		

		
