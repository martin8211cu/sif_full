<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="create_table_addendasDetalle">
  <cffunction name="up">
    <cfscript>
      execute("CREATE TABLE [dbo].[AddendasDetalle](
	[ADDDetalleid] [int] IDENTITY(1,1) NOT NULL,
	[ADDid] [int] NOT NULL,
	[CODIGO] [varchar](50) NULL,
	[VALOR] [varchar](250) NULL,
	[TIPO] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ADDDetalleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("DROP TABLE AddendasDetalle");
    </cfscript>
  </cffunction>
</cfcomponent>
