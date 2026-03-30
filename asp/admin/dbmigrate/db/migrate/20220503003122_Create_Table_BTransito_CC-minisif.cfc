<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Create_Table_BTransito_CC">
  <cffunction name="up">
    <cfscript>
       execute("IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'BTransito_CC')
              CREATE TABLE [dbo].[BTransito_CC](
              [id] [int] IDENTITY(1,1) NOT NULL,
              [Emp_id] [numeric](18, 0) NOT NULL,
              [Suc_id] [numeric](18, 0) NOT NULL,
              [SNcodigoExt] [varchar](255) NOT NULL,
              [Ticket] [varchar](255) NOT NULL,
              [Monto] [money] NOT NULL,
              [Ecodigo] [numeric](18, 0) NOT NULL,
              [createdat] [datetime] NULL,
              [updatedat] [datetime] NULL,
              [deletedat] [datetime] NULL,
              [Numero_Documento] [varchar](50) NULL,
            PRIMARY KEY CLUSTERED 
            (
              [id] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
            ) ON [PRIMARY]
      ");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
     execute("IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'BTransito_CC' )
              drop table  BTransito_CC 
      ");
    </cfscript>
  </cffunction>
</cfcomponent>