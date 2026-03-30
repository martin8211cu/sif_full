<cfcomponent>
	<cffunction name="AjusteAValesDespensa" access="public" >
		<cfargument name="DEid"       type="numeric" 	required="yes">
        <cfargument name="RHAAid" 	  type="numeric"    required="yes">
        <cfargument name="FechaDesde" type="date" 		required="yes">
        <cfargument name="FechaHasta" type="date" 		required="yes">
		
        <cf_dbtemp name = "ValesDespensa" datasource = "#session.DSN#" returnvariable = "ValesDespensa">
        	<cf_dbtempcol name="DEid"				type="int"				mandatory ="no">
            <cf_dbtempcol name="Monto"				type="float"			mandatory ="no">
            <cf_dbtempcol name="CIid"				type="int"				mandatory ="no">
            <cf_dbtempcol name="Tcodigo"			type="char(10)"			mandatory = "no">
            <cf_dbtempcol name="RCNid"				type="numeric"			mandatory = "no">
        </cf_dbtemp>
        
        <cfquery name="rsEspecie" datasource="#session.DSN#">
            	select CIid from ComponentesSalariales 
				where Ecodigo = #session.Ecodigo#
					and CSusatabla = 2
					and CSsalarioEspecie = 1
        </cfquery>
	
        <cfquery name="rsInsertSalario_temp" datasource="#session.DSN#">
        		insert into #ValesDespensa# (DEid, Monto, CIid, Tcodigo,RCNid)
                select a.DEid, sum(coalesce(a.ICmontores,0)) as ICmontores,b.CIid, d.Tcodigo,a.RCNid			
				from HIncidenciasCalculo a, CIncidentes b, ComponentesSalariales c , HRCalculoNomina d
				where b.CIid = a.CIid 
					and a.CIid = c.CIid
					and a.RCNid = d.RCNid 
					and c.Ecodigo = b.Ecodigo
					and c.CSsalarioEspecie = 1
					and a.ICmontores <> 0
					and d.RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaDesde#"> 
	  				and d.RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaHasta#"> 
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					and a.ICmontores != 0
					and coalesce(a.ICespecie,0) = 0
					and c.Ecodigo = #session.Ecodigo#
					and a.CIid in (#ValueList(rsEspecie.CIid)#)
				group by a.DEid,b.CIid,a.RCNid, d.Tcodigo
            </cfquery>
            
            <cfquery name="rsInsertSalario_temp" datasource="#session.DSN#">
				insert into #ValesDespensa# (DEid, Monto, CIid, Tcodigo,RCNid)
                select a.DEid, sum(coalesce(a.ICmontores,0)) as ICmontores,b.CIid, d.Tcodigo, a.RCNid				
				from IncidenciasCalculo a, CIncidentes b, ComponentesSalariales c , RCalculoNomina d
				where b.CIid = a.CIid 
					and a.CIid = c.CIid
					and a.RCNid = d.RCNid 
					and c.Ecodigo = b.Ecodigo
					and c.CSsalarioEspecie = 1
					and a.ICmontores <> 0
					and d.RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaDesde#"> 
	  				and d.RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaHasta#"> 
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					and a.ICmontores != 0
					and coalesce(a.ICespecie,0) = 0
					and c.Ecodigo = #session.Ecodigo#
					and a.CIid in (#ValueList(rsEspecie.CIid)#)
				group by a.DEid,b.CIid,a.RCNid, d.Tcodigo
    		</cfquery>
            
            <cfquery name="Prueba" datasource="#session.DSN#">
                select * from #ValesDespensa#
       			order by RCNid asc
    		</cfquery>
            
            <cfset totalValesS = 0>
            <cfset totalValesNS = 0>
           <!--- <cfset CIid = 0>--->
            <cfloop query="Prueba">
                 <cfif isdefined('Prueba') and Prueba.RecordCount GT 0>
                 	 <cfif #Prueba.Tcodigo# EQ '02'>
                      	<cfset totalValesS = totalValesS + #Round(Prueba.Monto)#>
                     <cfelseif #Prueba.Tcodigo# EQ '03'>
                      	<cfset totalValesNS = totalValesNS + #Prueba.Monto#>
                     <cfelse>
                     	<cfset totalValesS = totalValesS + #Round(Prueba.Monto)#>
                     </cfif>
                 </cfif>
                 <cfset CIid = #Prueba.CIid#>
            </cfloop>
            
            <cfset totalVales = (totalValesS + totalValesNS) >
            <cfif isdefined('CIid')>
            <cfquery name="rsSelectFiniquitos" datasource="#session.DSN#">
       			insert into DRHAjusteAnual (RHAAid,DEid,DRHAAAcumulado,CIid)
       			values(#arguments.RHAAid#,#arguments.DEid#,#totalVales#,#CIid#)
    		</cfquery>
            </cfif>
            <!---<cf_dump var = "#Prueba#">--->
		<!---<cfreturn result(totalVales,CIid)>--->
	</cffunction>
</cfcomponent>