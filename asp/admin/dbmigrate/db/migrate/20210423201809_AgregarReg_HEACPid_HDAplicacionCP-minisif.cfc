<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="AgregarReg_HEACPid_HDAplicacionCP">
  <cffunction name="up">
    <cfscript>
      execute("
        update HDAplicacionCP
        set HDAplicacionCP.HEACPid = HEAplicacionCP.HEACPid
        from HDAplicacionCP 
             inner join HEAplicacionCP on HEAplicacionCP.Ecodigo = HDAplicacionCP.Ecodigo 
              		and HDAplicacionCP.ID = HEAplicacionCP.ID
        Where HDAplicacionCP.HEACPid is null
      ");
	    
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>

    </cfscript>
  </cffunction>
</cfcomponent>

		

		
