
            <cfcomponent>
                <cffunction name="getJson" access="remote" returnformat="json">
                    <cfargument name="page" required="no" default="1" hint="Page user is on">
                    <cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
                    <cfargument name="sidx" required="no" default="1" hint="Sort Column">
                    <cfargument name="sord" required="no" default="DESC" hint="Sort Order">
					<cfargument name="filtro" required="no" hint="Filtro">
                    <cfset var arraydata = ArrayNew(1)>
                    <cfquery name="seldata" datasource="#session.dsn#">
                        select distinct a.RHOPid, '<input type=checkbox ' + 
																				   case when '#session.setFiltroPuesto#' = rtrim(ltrim(b.RHPcodigo)) then
																				   		 'checked=checked ' 
																				  	else '' 
																				  	end +
																				  	' onclick=fnAgregarQuitar(this,'+rtrim(convert (varchar(255), a.RHOPid))+')>'
																				  	as procesar,
																				   RHOPDescripcion, case when '#session.setFiltroPuesto#' = rtrim(ltrim(b.RHPcodigo)) then 1 else 0 end as ordenar  
                        from RHOPuesto a
																				 left join RHOPuestoEquival  b
																					on a.RHOPid = b.RHOPid
						where 1=1
						<cfif isdefined("Arguments.filtro") and len(trim(Arguments.filtro))>
                        	and #replace(Arguments.filtro,"|","'","ALL")#
						</cfif>
						<cfif isdefined("Arguments.filters")>
							<cfset structF = DeserializeJSON(Arguments.filters)>
                        <cfset lvarDato = fnGetDato(structF.rules,"RHOPDescripcion")>
                        <cfif len(trim(lvarDato))>and upper(RHOPDescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(lvarDato)#%"></cfif>
                        <cfset lvarDato = fnGetDato(structF.rules,"procesar")>
                        <cfif len(trim(lvarDato))><cfif IsNumeric("#lvarDato#")>and  case when '#session.setFiltroPuesto#' = rtrim(ltrim(RHPcodigo)) then  1 else 0 end =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDato#"> </cfif></cfif>
                    </cfif>
					ORDER BY #Arguments.sidx# #Arguments.sord#
					</cfquery>
                    <cfset start = ((arguments.page-1)*arguments.rows)+1>
                    <cfset end = (start-1) + arguments.rows>
                    <cfset i = 1>
                    <cfset lvarListColumn = "RHOPDescripcion,procesar,ORDENAR,RHOPID">
                    <cfloop query="seldata" startrow="#start#" endrow="#end#">
                        <cfloop from="1" to = "#ListLen(lvarListColumn)#" index="col">
                            <cfset lvarColsValue[col] = evaluate("seldata.#ListGetAt(lvarListColumn,col)#")>
                        </cfloop>
                        <cfset lvarKey = "">
                        <cfif len(trim(lvarKey))>
                            <cfset lvarValueKey = "">
                            <cfloop from="1" to = "#ListLen(lvarKey)#" index="idx">
                                <cfset lvarValueKey = lvarValueKey & evaluate("seldata.#ListGetAt(lvarKey,idx)#")>
                                <cfif idx lt ListLen(lvarKey)>
                                    <cfset lvarValueKey = lvarValueKey & "|">
                                </cfif>
                            </cfloop>
                            <cfset lvarColsValue[ListLen(lvarListColumn) + 1] = lvarValueKey>
                        </cfif>
                        <cfset arraydata[i] = lvarColsValue>
                        <cfset i = i + 1>
                    </cfloop>
                    <cfset totalPages = Ceiling(seldata.recordcount/arguments.rows)>
                    <cfset stcReturn = {total=totalPages,page=Arguments.page,records=seldata.recordcount,rows=arraydata}>
                    
                    <cfreturn stcReturn>
                </cffunction>
				
				<cffunction name="fnGetDato" access="private" returntype="string">
                	<cfargument name="Arreglo" 	type="array" 	required="yes">
                    <cfargument name="Llave"  	type="string" 	required="yes">
                    <cfloop from = "1" to = "#ArrayLen(Arguments.Arreglo)#" index = "i">
                    	<cfset stct = Arguments.Arreglo[i]>
                        <cfif stct.field eq Arguments.Llave>
                        	<cfreturn stct.data>
                        </cfif>
                    </cfloop>
                    <cfreturn "">
                </cffunction>
            </cfcomponent>
