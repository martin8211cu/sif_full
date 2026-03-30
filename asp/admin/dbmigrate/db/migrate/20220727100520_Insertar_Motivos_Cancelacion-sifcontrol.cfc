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
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Insertar_Motivos_Cancelacion">
  <cffunction name="up">
    <cfscript>
   execute("
   insert into CSAT_MotivoCanc
(CSATcodigo,CSATdescripcion,AceptadoCancel,AceptadoSust)
values
('01', 'Comprobantes emitidos con errores con relaci�n.',0,1),
('02', 'Comprobantes emitidos con errores sin relaci�n.',1,1),
('03', ' No se llev� a cabo la operaci�n.',1,1),
('04', 'Operaci�n nominativa relacionada en una factura global.',1,1)
   ");

    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		  execute('TRUNCATE table CSAT_MotivoCanc');
    </cfscript>
  </cffunction>
</cfcomponent>
