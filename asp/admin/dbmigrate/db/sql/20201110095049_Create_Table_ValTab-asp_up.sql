
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        	  AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'ValTab')
              CREATE TABLE [dbo].[ValTab](
                [id] [int] IDENTITY(1,1) NOT NULL,
                [Codigo] [varchar](20) NOT NULL,
                [Descripcion] [varchar](255) NULL,
                [createdat] [datetime] NULL,
                [updatedat] [datetime] NULL,
                [deletedat] [datetime] NULL,
              PRIMARY KEY CLUSTERED 
              (
                [id] ASC
              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
              ) ON [PRIMARY];
