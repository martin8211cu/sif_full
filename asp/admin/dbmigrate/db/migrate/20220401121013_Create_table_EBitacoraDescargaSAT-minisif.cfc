<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Create_table_EBitacoraDescargaSAT">
  <cffunction name="up">
    <cfscript>
      execute("              
          CREATE TABLE dbo.EBitacoraDescargaSAT(
          [EBDSATid] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
    	  [Ecodigo] [int] NOT NULL,
          [FechaInicial] [datetime] NULL,
          [FechaFinal] [datetime] NULL,
          [URL] [varchar](600) NULL,
          [Estatus] [varchar](50) NULL,
          [RequestGetToken] [varchar](max) NULL,
          [ResponseGetToken] [varchar](max) NULL,
          [RequestGetSolicitud] [varchar](max) NULL,
          [ResponseGetSolicitud] [varchar](max) NULL,
          [RequestValidarSolicitud] [varchar](max) NULL,
          [ResponseValidarSolicitud] [varchar](max) NULL,
          [RequestDescargarZIP] [varchar](max) NULL,
          [ResponseDescargarZIP] [varchar](max) NULL,
          [UUID_Solicitud] [varchar](100) NULL,
          [Total_Registros] [int] NULL,
          [FechaSolicitud] [datetime] NULL,
          [Proveedor] [varchar](100) NULL,
          [ZIP] [varbinary](max) NULL,
          [ts_rversion] [timestamp] NULL,
          [BMUsucodigo] [numeric](18, 0) NULL,
          [BMfecha] [datetime] NULL,
          CONSTRAINT [PK_EBitacoraDescargaSAT] PRIMARY KEY CLUSTERED 
          (
            [EBDSATid] ASC,
            [Ecodigo] ASC
          )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
          ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

 	  ");
	    
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      dropTable('EBitacoraDescargaSAT');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		
