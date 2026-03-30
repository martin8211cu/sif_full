
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Alter_Column_TESOPReferenciaCIE_TESordenPago">
  <cffunction name="up">
    <cfscript>
    t = changeTable('TESordenPago');
    t.string(columnNames="TESOPReferenciaCIE", null=true, limit="30");
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      t = changeTable('TESordenPago');
      t.string(columnNames="TESOPReferenciaCIE", null=true, limit="20");
      t.change();
    </cfscript>
  </cffunction>
</cfcomponent>

		
