<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="ModificacionCampoObs_Prefacturas">
  <cffunction name="up">
    <cfscript>
      	execute("
              ALTER TABLE FAPreFacturaE ALTER COLUMN Observaciones VARCHAR (600);

              ALTER TABLE FAEOrdenImpresion ALTER COLUMN OIObservacion VARCHAR (600);
              ");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      	 execute("
              ALTER TABLE FAPreFacturaE ALTER COLUMN Observaciones VARCHAR (255);

              ALTER TABLE FAEOrdenImpresion ALTER COLUMN OIObservacion VARCHAR (255);
              ");
    </cfscript>
  </cffunction>
</cfcomponent>
