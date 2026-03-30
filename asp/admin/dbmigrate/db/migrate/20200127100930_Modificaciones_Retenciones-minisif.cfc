<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Modificaciones_Retenciones">
  <cffunction name="up">
    <cfscript>
       execute("
	   			IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'FAPreFacturaD' AND col.COLUMN_NAME = 'Rcodigo')
					alter table  FAPreFacturaD 
					add Rcodigo varchar(2)
				
				IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'FADOrdenImpresion' AND col.COLUMN_NAME = 'Rcodigo')
					alter table  FADOrdenImpresion 
					add Rcodigo varchar(2)

				IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DDocumentosCxC' AND col.COLUMN_NAME = 'Rcodigo')
					alter table  DDocumentosCxC 
					add Rcodigo varchar(2)

				IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DDocumentos' AND col.COLUMN_NAME = 'Rcodigo')
					alter table  DDocumentos 
					add Rcodigo varchar(2)

				IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'HDDocumentos' AND col.COLUMN_NAME = 'Rcodigo')
					alter table  HDDocumentos 
					add Rcodigo varchar(2)

				IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'FAPreFacturaE' AND col.COLUMN_NAME = 'MRetencion')
					alter table  FAPreFacturaE 
					add MRetencion  money

				IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'FAEOrdenImpresion' AND col.COLUMN_NAME = 'OIMRetencion')
					alter table  FAEOrdenImpresion 
					add OIMRetencion  money

				IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'EDocumentosCxC' AND col.COLUMN_NAME = 'EDMRetencion')
					alter table  EDocumentosCxC 
					add EDMRetencion  money

				IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'Documentos' AND col.COLUMN_NAME = 'EDMRetencion')
					alter table  Documentos 
					add EDMRetencion  money

				IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'HDocumentos' AND col.COLUMN_NAME = 'EDMRetencion')
					alter table  HDocumentos 
					add EDMRetencion  money
       	");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("
       			IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'FAPreFacturaD' AND col.COLUMN_NAME = 'Rcodigo')
					alter table  FAPreFacturaD 
					drop colum Rcodigo varchar(2)
				
				IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'FADOrdenImpresion' AND col.COLUMN_NAME = 'Rcodigo')
					alter table  FADOrdenImpresion 
					drop colum Rcodigo varchar(2)

				IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DDocumentosCxC' AND col.COLUMN_NAME = 'Rcodigo')
					alter table  DDocumentosCxC 
					drop colum Rcodigo varchar(2)

				IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'DDocumentos' AND col.COLUMN_NAME = 'Rcodigo')
					alter table  DDocumentos 
					drop colum Rcodigo varchar(2)

				IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'HDDocumentos' AND col.COLUMN_NAME = 'Rcodigo')
					alter table  HDDocumentos 
					drop colum Rcodigo varchar(2)

				IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'FAPreFacturaE' AND col.COLUMN_NAME = 'MRetencion')
					alter table  FAPreFacturaE 
					drop colum MRetencion  money

				IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'FAEOrdenImpresion' AND col.COLUMN_NAME = 'OIMRetencion')
					alter table  FAEOrdenImpresion 
					drop colum OIMRetencion  money

				IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'EDocumentosCxC' AND col.COLUMN_NAME = 'EDMRetencion')
					alter table  EDocumentosCxC 
					drop colum EDMRetencion  money

				IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'Documentos' AND col.COLUMN_NAME = 'EDMRetencion')
					alter table  Documentos 
					drop colum EDMRetencion  money

				IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'HDocumentos' AND col.COLUMN_NAME = 'EDMRetencion')
					alter table  HDocumentos 
					drop colum EDMRetencion  money

       	");
    </cfscript>
  </cffunction>
</cfcomponent>
