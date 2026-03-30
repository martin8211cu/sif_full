				
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Create_Table_CSAT_MotivoCanc">
  <cffunction name="up">
    <cfscript>
    execute('
        CREATE TABLE [dbo].[CSAT_MotivoCanc](
          [Id] [int] IDENTITY(1,1) NOT NULL,
          [CSATcodigo] [varchar](25) NOT NULL,
          [CSATdescripcion] [varchar](100) NULL,
          [AceptadoCancel] [bit] NULL,
          [AceptadoSust] [bit] NULL,
        PRIMARY KEY CLUSTERED 
        (
          [Id] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    ');
     
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('drop table CSAT_MotivoCanc');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		

		

		

		
