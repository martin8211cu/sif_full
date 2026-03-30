
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="CrearTabla ColaCancelacionFactura">
  <cffunction name="up">
    <cfscript>
       execute("
              IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        	  AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'ColaCancelacionFactura')
              CREATE TABLE [dbo].[ColaCancelacionFactura](
                  [Ecodigo] [int],
                  [IdDocumento] [int] IDENTITY(1,1),
                  [CCTcodigo] varchar(4) NULL,
                  [Ddocumento] varchar(50) NULL,
                  [SNcodigo] [int] NULL,
                  [SNnombre] varchar(255) NULL,
                  [Rfc] varchar(70) NULL,
                  [Timbre] varchar(255) NULL,
                  [Estado] varchar(100) NULL,
                  [Estatus] varchar(100) NULL,
                  [Tipo] varchar(100) NULL,
                  [Aplicado] varchar(100) NULL,
                  [Motivo] varchar(100) NULL,
                  [FechaCancelado] datetime NULL,
                  [ts_rversion] timestamp NULL,
                  [BMUsucodigo] numeric(18, 0) NULL
              	) ON [PRIMARY]
              ");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    	execute("
      IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'ColaCancelacionFactura')
        DROP TABLE ColaCancelacionFactura
    ");
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		
