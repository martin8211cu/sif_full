<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Create VersionInfo">
  <cffunction name="up">
    <cfscript>
      t = createTable(name='versioninfo');
      t.integer(columnNames='version', null=false);
      t.string(columnNames='package', limit="255", null=true);
      t.boolean(columnNames='revert');
      t.text(columnNames='changelog', null=true);
      t.timestamps();
      t.create();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      dropTable('versioninfo');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
