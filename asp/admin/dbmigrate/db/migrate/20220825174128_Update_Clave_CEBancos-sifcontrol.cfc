<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Update_Clave_CEBancos">
  <cffunction name="up">
    <cfscript>
      execute('update CEBancos set Clave = CEBancos_2.ClaveSAT from (select RIGHT(''000'' + Ltrim(Rtrim(Clave)),3) as ClaveSAT, Id_Banco from CEBancos) CEBancos_2 where CEBancos_2.Id_Banco = CEBancos.Id_Banco');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
