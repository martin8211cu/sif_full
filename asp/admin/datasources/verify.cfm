
  <cfloop list="#url.ds#" index="theds">
    <cfoutput>ping #theds# ............. # RepeatString(' ', 1200) #
      <cfflush>
      <cftry>
#ds_service.verifyDatasource(theds)#
        <cfif dsources[theds].driver eq 'Sybase'>
          <cfquery datasource="#theds#" name="query_ping">
				select db_name() as name, 'sybase' as mydbtype
			</cfquery>
        <cfelseif dsources[theds].driver eq 'Oracle'>
          <cfquery datasource="#theds#" name="query_ping">
				SELECT SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA') AS NAME, 'oracle' as mydbtype
				from dual
			</cfquery>
        <cfelseif dsources[theds].driver eq 'mssqlserver'>
          <cfquery datasource="#theds#" name="query_ping">
				SELECT db_name() as name, 'mssqlserver' as mydbtype
			</cfquery>
        <cfelse>
          <cfthrow message="DBMS invalido: #dsources[theds].driver#">
        </cfif>
        <span <cfif lcase( query_ping.mydbtype ) NEQ lcase ( dsources[theds].driver)>style="color:red"</cfif>>#query_ping.mydbtype# / #query_ping.name#</span>
        <cfcatch type="anyx">
          <span style="color:red">#cfcatch.Message#</span>
        </cfcatch>
      </cftry>
      <br>
      # RepeatString(' ', 1200) #
      <cfflush>
    </cfoutput>
  </cfloop>
