<!---
    |-----------------------------------------------------------------------------------------------------|
	| Parameter               | Required | Type    | Default | Description                                |
    |-----------------------------------------------------------------------------------------------------|
	| table                   | Yes      | string  |         | Name of table to update records            |
	| where                   | No       | string  |         | Where condition                            |
	| one or more columnNames | No       | string  |         | Use column name as argument name and value |
    |-----------------------------------------------------------------------------------------------------|

    EXAMPLE:
      updateRecord(table='members',where='id=1',status='Active');
--->
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Actualiza_Motivos_Cancelacion">
  <cffunction name="up">
    <cfscript>
	   execute("
      update CSAT_MotivoCanc
      set CSATdescripcion= 'Comprobantes emitidos con errores con relación.'
      where Id = 1

      update CSAT_MotivoCanc
      set CSATdescripcion= 'Comprobantes emitidos con errores sin relación.'
      where Id = 2

      update CSAT_MotivoCanc
      set CSATdescripcion= 'No se llevó a cabo la operación.'
      where Id = 3

      update CSAT_MotivoCanc
      set CSATdescripcion= 'Operación nominativa relacionada en una factura global.'
      where Id = 4"
    );

    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
     execute("
        update CSAT_MotivoCanc
        set CSATdescripcion= 'Comprobantes emitidos con errores con relaci�n.'
        where Id = 1

        update CSAT_MotivoCanc
        set CSATdescripcion= 'Comprobantes emitidos con errores sin relaci�n.'
        where Id = 2

        update CSAT_MotivoCanc
        set CSATdescripcion= 'No se llev� a cabo la operaci�n.'
        where Id = 3

        update CSAT_MotivoCanc
        set CSATdescripcion= 'Operaci�n nominativa relacionada en una factura global.'
        where Id = 4"
    );
    </cfscript>
  </cffunction>
</cfcomponent>
