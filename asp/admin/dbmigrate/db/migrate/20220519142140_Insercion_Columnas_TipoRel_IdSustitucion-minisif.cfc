<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Insercion_Columnas_TipoRel_IdSustitucion">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE FAEOrdenImpresion ADD OIsustitucion int');
      execute('ALTER TABLE FAEOrdenImpresion ADD OItipoRel varchar(10)');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE FAEOrdenImpresion DROP COLUMN OIsustitucion');
      execute('ALTER TABLE FAEOrdenImpresion DROP COLUMN OItipoRel');
    </cfscript>
  </cffunction>
</cfcomponent>
		

		

		
