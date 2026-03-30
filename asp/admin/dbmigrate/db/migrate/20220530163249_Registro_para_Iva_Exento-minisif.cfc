<!---
    |-------------------------------------------------------------------------------------------|
	| Parameter     | Required | Type    | Default | Description                                |
    |-------------------------------------------------------------------------------------------|
	| table         | Yes      | string  |         | Name of table to add record to             |
	| columnNames   | Yes      | string  |         | Use column name as argument name and value |
    |-------------------------------------------------------------------------------------------|

    EXAMPLE:
      addRecord(table='members',id=1,username='admin',password='#Hash("admin")#');
--->
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Registro para Iva Exento">
  <cffunction name="up">
    <cfscript>
	    addRecord(table='CSATTasaCuota',TCRangoFijo='Fijo', TCValMin=0, TCValMax=0,TCImpuesto='IVA',
      TCFactor='Exento', TCTraslado=1,TCRetencion=0);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeRecord(table='CSATTasaCuota',where='IdTasaCuota = 18');
    </cfscript>
  </cffunction>
</cfcomponent>

		
