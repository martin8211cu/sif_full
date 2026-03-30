<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="createTable_DocCompensacionDCxC">
  <cffunction name="up">
    <cfscript>
      execute("
			IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocCompensacionDCxC')
				BEGIN	  
				  CREATE TABLE [DocCompensacionDCxC](
						[idDetalle] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
						[idDocCompensacion] [numeric](18, 0) NOT NULL,
						[Ecodigo] [int] NOT NULL,
						[CCTcodigo] [char](2) NULL,
						[Ddocumento] [char](20) NULL,
						[Dmonto] [money] NULL,
						[BMUsucodigo] [numeric](18, 0) NULL,
						[Referencia] [varchar](20) NULL,
						[ts_rversion] [timestamp] NULL,
						[DmontoRet] [money] NOT NULL,
						[NumeroEvento] [varchar](25) NULL,
					 CONSTRAINT [DocCompensacionDCxC_PK] PRIMARY KEY CLUSTERED 
					(
						[idDetalle] ASC
					)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
					) ON [PRIMARY]

					ALTER TABLE [DocCompensacionDCxC] ADD  DEFAULT ((0)) FOR [DmontoRet]

					ALTER TABLE [DocCompensacionDCxC]  WITH NOCHECK ADD  CONSTRAINT [DocCompensacionDCxC_FK01] FOREIGN KEY([idDocCompensacion])
					REFERENCES [DocCompensacion] ([idDocCompensacion])

					ALTER TABLE [DocCompensacionDCxC] CHECK CONSTRAINT [DocCompensacionDCxC_FK01]

					ALTER TABLE [DocCompensacionDCxC]  WITH CHECK ADD  CONSTRAINT [DocCompensacionDCxC_FK02] FOREIGN KEY([Ddocumento], [CCTcodigo], [Ecodigo])
					REFERENCES [HDocumentos] ([Ddocumento], [CCTcodigo], [Ecodigo])

					ALTER TABLE [DocCompensacionDCxC] CHECK CONSTRAINT [DocCompensacionDCxC_FK02]

				END");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("
	  		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocCompensacionDCxC')
				BEGIN	  
	  				DROP TABLE DocCompensacionDCxC
				END");
    </cfscript>
  </cffunction>
</cfcomponent>
