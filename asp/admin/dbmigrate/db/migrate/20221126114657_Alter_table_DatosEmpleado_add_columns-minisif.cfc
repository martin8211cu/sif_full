<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Alter_table_DatosEmpleado_add_columns">
  <cffunction name="up">
    <cfscript>
      execute("
        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'DErespetaSBC')
        ALTER TABLE [DatosEmpleado] ADD [DErespetaSBC] [bit] NULL

        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'DESindicalizado')
        ALTER TABLE [DatosEmpleado] ADD [DESindicalizado] [int] NULL

        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'DEtext1')
        ALTER TABLE [DatosEmpleado] ADD [DEtext1] [text] NULL

        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'DEtext2')
        ALTER TABLE [DatosEmpleado] ADD [DEtext2] [text] NULL

        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'DEtext3')
        ALTER TABLE [DatosEmpleado] ADD [DEtext3] [text] NULL

        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'DETipoPago')
        ALTER TABLE [DatosEmpleado] ADD [DETipoPago] [numeric](18,0) NOT NULL
        CONSTRAINT [DF_DatosEmpleado_DETipoPago] DEFAULT ((0))

        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'id_direccion')
        ALTER TABLE [DatosEmpleado] ADD [id_direccion] [numeric](18,0) NULL

        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'imen_matrimonial')
        ALTER TABLE [DatosEmpleado] ADD [imen_matrimonial] [varchar](1) NULL

        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'isAbogado')
        ALTER TABLE [DatosEmpleado] ADD [isAbogado] [bit] NOT NULL
        CONSTRAINT [DF_DatosEmpleado_isAbogado] DEFAULT ((0))

        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'isCobrador')
        ALTER TABLE [DatosEmpleado] ADD [isCobrador] [bit] NOT NULL
        CONSTRAINT [DF_DatosEmpleado_isCobrador] DEFAULT ((0))

        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'PorcentajeCobranzaAntes')
        ALTER TABLE [DatosEmpleado] ADD [PorcentajeCobranzaAntes] [money] NOT NULL
        CONSTRAINT [DF_DatosEmpleado_PorcentajeCobranzaAntes] DEFAULT ((0))

        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'PorcentajeCobranzaDespues')
        ALTER TABLE [DatosEmpleado] ADD [PorcentajeCobranzaDespues] [money] NULL

        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'Vigencia1')
        ALTER TABLE [DatosEmpleado] ADD [Vigencia1] [datetime] NULL

        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'Vigencia2')
        ALTER TABLE [DatosEmpleado] ADD [Vigencia2] [datetime] NULL

        /*------------------------------- DatosEmpleado-------------------------------*/
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DatosEmpleado' AND col.COLUMN_NAME = 'Vigencia3')
        ALTER TABLE [DatosEmpleado] ADD [Vigencia3] [datetime] NULL
      ");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("select 1");
    </cfscript>
  </cffunction>
</cfcomponent>
