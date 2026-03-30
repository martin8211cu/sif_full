<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Actualizacion_CSATTipoRel_Default">
  <cffunction name="up">
    <cfscript>

    EXECUTE ("update CSATTipoRel set CSATdefault = 1 where CSATcodigo = '04'");
      
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>

    EXECUTE ("update CSATTipoRel set CSATdefault = 0 where CSATcodigo = '04'");
      
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
