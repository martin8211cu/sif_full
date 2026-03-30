
<!--- <cf_dump var="#Form#">  --->

<!---
            <cfloop from="1" to="#form.NumRegs_PInsumo#" index="i">  
                <cfif isdefined("form.chk#i#")>
                    <cfdump var="entre a query">
                    <cfquery name="rsRegistraMovimiento" datasource="#Session.DSN#">
                          insert into Prod_Movimiento (ECodigo, OTcodigo, Artid, OTseqOrigen, OTseqDestino, PMcantidad)
                          values (
                          <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                          <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">,									
                          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.Artid#i#')#">, 
                          <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CodAreaAct#">,                    
                          <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.AreaPsig#">,
                          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.ecantidad#i#')#">
                          )							
                    </cfquery>
                </cfif> 
            </cfloop>  
--->


<cfif isdefined("Form.btnEnviar") and isdefined("Form.Registro")>
  <cftry>
    <!--- <cfdump var="Entre ya"> --->
		<cfif #Form.Registro# eq "MEDIO">
           <!--- <cfdump var="Entre a Medio"> --->
            
            <cfif #Form.AreaDestino# eq 0>
            	<cfset AreaDestino = #Form.AreaPsig#>
			<cfelse>
            	<cfset AreaDestino = #Form.AreaDestino#>
            </cfif>
            
			<cfset AreaOrigen = #Form.CodAreaAct#>
			
            <!--- <cfdump var="#form#">  --->
            
            <cfif EnvioM eq 2>  <!--- Opcion Especificar Material --->
            
                <cfloop from="1" to="#ListLen(form.artid)#" index="i">
                
                    <!--- <cfdump var="#ListGetAt(Form.CantTrasladar,i)#"> --->
                    <cfif #ListGetAt(Form.CantTrasladar,i)# gt 0> 
                
                        <cfquery name="rsBuscaRegInvTraslado_Origen" datasource="#Session.DSN#">
                              select Pexistencia, Psalida from prod_Inventario
                              where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                              and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                              and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">
                              and Artid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.Artid,i)#">
                        </cfquery>
                        
                        <cfif rsBuscaRegInvTraslado_Origen.recordcount gt 0>
                            <cfset PIexistencias = #rsBuscaRegInvTraslado_Origen.Pexistencia# - #ListGetAt(Form.CantTrasladar,i)#>
                            <cfset PIsalidas = #rsBuscaRegInvTraslado_Origen.Psalida# + #ListGetAt(Form.CantTrasladar,i)#>
                            
                            <cfquery name="rsUpd_RegInvTraslado_Origen" datasource="#Session.DSN#">
                                update prod_Inventario
                                set Pexistencia = #PIexistencias#, Psalida = #PIsalidas#
                                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                                and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">
                                and Artid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.Artid,i)#">
                            </cfquery>
                        <cfelse>
                            <cfdump var="No Existe Inventario Origen de esta Area">
                            <cfbreak>
                        </cfif>
                            
                        <cfquery name="rsBuscaRegInvTraslado_Destino" datasource="#Session.DSN#">
                              select Pexistencia, Pentrada from prod_Inventario
                              where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                              and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                              and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaDestino#">
                              and Artid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.Artid,i)#">
                        </cfquery>
                        
                        <cfif rsBuscaRegInvTraslado_Destino.recordcount gt 0>
                            <cfset PIentradas = rsBuscaRegInvTraslado_Destino.Pentrada + #ListGetAt(Form.CantTrasladar,i)#>
                            <cfset PIexistencias = #rsBuscaRegInvTraslado_Destino.Pexistencia# + #ListGetAt(Form.CantTrasladar,i)#>
                            
                            <cfquery name="rsUpd_RegInvTraslado_Destino" datasource="#Session.DSN#">
                                update prod_Inventario
                                set Pentrada = #PIentradas#, Pexistencia = #PIexistencias#
                                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                                and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaDestino#">
                                and Artid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.Artid,i)#">
                            </cfquery>
                        <cfelse>
                        
              <!---          	<cfdump var="#Form#"> 
                            <cf_dump var="#rsBuscaRegInvTraslado_Destino#"> ---> 
                        
                            <cfquery name="rsInsert_RegInvTraslado_Origen" datasource="#Session.DSN#">
                                insert into Prod_Inventario (ECodigo, OTcodigo, OTseq, DPstatus, Artid, Pentrada, Psalida, Pexistencia)
                                values (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaDestino#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#0#">,                            										
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.artid,i)#">,
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.CantTrasladar,i)#">,                 
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#0#">,
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.CantTrasladar,i)#">
                                )								
                            </cfquery>
                        </cfif>
                        
                             <cfquery name="rsRegistraMovimiento" datasource="#Session.DSN#">
                                insert into Prod_Movimiento (ECodigo, OTcodigo, Artid, OTseqOrigen, OTseqDestino, PMcantidad)
                                values (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">,										
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.artid,i)#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaDestino#">,                   
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.CantTrasladar,i)#">
                                )								
                            </cfquery>
                    </cfif>    
                </cfloop> 
	        <cfelse>
				<!--- Opcion Todo el Material --->
                <cfquery name="rsBuscaRegInvTraslado_Origen" datasource="#Session.DSN#">
                      select Pexistencia, Psalida, Artid from prod_Inventario
                      where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                      and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                      and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">
                </cfquery>
                        
				<cfif rsBuscaRegInvTraslado_Origen.recordcount gt 0>
               
                    <cfloop query="rsBuscaRegInvTraslado_Origen">
                    
                        <cfquery name="rsExtraeRegInvTraslado_Origen" datasource="#Session.DSN#">
                              select Pexistencia, Psalida, Pexistencia from prod_Inventario
                              where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                              and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                              and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">
                              and Artid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaRegInvTraslado_Origen.Artid#">
                        </cfquery>
                    
						<cfif #rsExtraeRegInvTraslado_Origen.Pexistencia# gt 0>
                            <cfset PIexistencias = 0>
                            <cfset PIsalidas = #rsBuscaRegInvTraslado_Origen.Psalida# + #rsBuscaRegInvTraslado_Origen.Pexistencia#>
                            
                            <cfquery name="rsUpd_RegInvTraslado_Origen" datasource="#Session.DSN#">
                                update prod_Inventario
                                set Pexistencia = #PIexistencias#, Psalida = #PIsalidas#
                                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                                and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">
                                and Artid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaRegInvTraslado_Origen.Artid#">
                            </cfquery>
    
                            <cfquery name="rsBuscaRegInvTraslado_Destino" datasource="#Session.DSN#">
                                  select Pexistencia, Pentrada from prod_Inventario
                                  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                  and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                                  and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaDestino#">
                                  and Artid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaRegInvTraslado_Origen.Artid#">
                            </cfquery>
                        
                            <cfif rsBuscaRegInvTraslado_Destino.recordcount gt 0>
                                <cfset PIentradas = rsBuscaRegInvTraslado_Destino.Pentrada + #rsBuscaRegInvTraslado_Origen.Pexistencia#>
                                <cfset PIexistencias = #rsBuscaRegInvTraslado_Destino.Pexistencia# + #rsBuscaRegInvTraslado_Origen.Pexistencia#>
                                
                                <cfquery name="rsUpd_RegInvTraslado_Destino" datasource="#Session.DSN#">
                                    update prod_Inventario
                                    set Pentrada = #PIentradas#, Pexistencia = #PIexistencias#
                                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                    and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                                    and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaDestino#">
                                    and Artid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaRegInvTraslado_Origen.Artid#">
                                </cfquery>
                            <cfelse>
                        
                                <cfquery name="rsInsert_RegInvTraslado_Origen" datasource="#Session.DSN#">
                                    insert into Prod_Inventario (ECodigo, OTcodigo, OTseq, DPstatus, Artid, Pentrada, Psalida, Pexistencia)
                                    values (
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaDestino#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#0#">,                            										
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaRegInvTraslado_Origen.artid#">,
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaRegInvTraslado_Origen.Pexistencia#">,                 
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#0#">,
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaRegInvTraslado_Origen.Pexistencia#">
                                    )								
                                </cfquery>
                            </cfif>
                        
                             <cfquery name="rsRegistraMovimiento" datasource="#Session.DSN#">
                                insert into Prod_Movimiento (ECodigo, OTcodigo, Artid, OTseqOrigen, OTseqDestino, PMcantidad)
                                values (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">,										
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaRegInvTraslado_Origen.artid#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaDestino#">,                   
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaRegInvTraslado_Origen.Pexistencia#">
                                )								
                            </cfquery>
                            
                          </cfif>
                        
                    </cfloop>            
                </cfif>                                    
            
    	    </cfif>
        <cfelseif #Form.Registro# eq "INICIAL">
   <!---         <cfdump var="Entre Inicial"> --->
        
            <cfloop from="1" to="#ListLen(form.artid)#" index="i"> 
            
                <cfquery name="rsBuscaRegMovIni" datasource="#Session.DSN#">
                      select Pentrada, Pexistencia from prod_Inventario
                      where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                      and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                      and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(Form.OTsec,i)#">
                      and Artid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.Artid,i)#">
                </cfquery>
                
                <cfif rsBuscaRegMovIni.recordcount gt 0>
                    <cfset PIentradas = rsBuscaRegMovIni.Pentrada + #ListGetAt(Form.CantPI,i)#>
                    <cfset PIexistencias = #rsBuscaRegMovIni.Pexistencia# + #ListGetAt(Form.CantPI,i)#>
                    
                    <cfquery name="rsUpd_RegMovIni" datasource="#Session.DSN#">
                        update prod_Inventario
                        set Pentrada = #PIentradas#, Pexistencia = #PIexistencias#
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                        and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(Form.OTsec,i)#">
                        and Artid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.Artid,i)#">
                    </cfquery>
                <cfelse>
                
                    <cfquery name="rsRegistraInventarioP" datasource="#Session.DSN#">
                        insert into Prod_Inventario (ECodigo, OTcodigo, OTseq, DPstatus, Artid, Pentrada, Psalida, Pexistencia)
                        values (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(Form.OTsec,i)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#0#">,                            										
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.artid,i)#">, 
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.CantPI,i)#">,                    
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#0#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.CantPI,i)#">
                        )								
                    </cfquery>
                    
                    <cfquery name="rsRegistraMovimiento" datasource="#Session.DSN#">
                        insert into Prod_Movimiento (ECodigo, OTcodigo, Artid, OTseqOrigen, OTseqDestino, PMcantidad)
                        values (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">,										
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.artid,i)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="0">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(Form.OTsec,i)#">,                    
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.CantPI,i)#">
                        )								
                    </cfquery>
                
                </cfif>
            </cfloop>
            
        <cfelseif #Form.Registro# eq "FINAL">
             
			<cfset AreaOrigen = #Form.CodAreaAct#>
			
             <cfif EnvioM eq 2>  <!--- Opcion Especificar Material --->

				  <!--- <cfdump var="#form#">  --->
                  <cfloop from="1" to="#ListLen(form.artid)#" index="i">
                  
                 <!--- 	<cfdump var="#ListGetAt(Form.CantTrasladar,i)#"> --->
                      <cfif #ListGetAt(Form.CantTrasladar,i)# gt 0> 
                  
                          <cfquery name="rsBuscaRegInvTraslado_Origen" datasource="#Session.DSN#">
                                select Pexistencia, Psalida from prod_Inventario
                                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                                and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">
                                and Artid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.Artid,i)#">
                          </cfquery>
                          
                          <cfif rsBuscaRegInvTraslado_Origen.recordcount gt 0>
                              <cfset PIexistencias = #rsBuscaRegInvTraslado_Origen.Pexistencia# - #ListGetAt(Form.CantTrasladar,i)#>
                              <cfset PIsalidas = #rsBuscaRegInvTraslado_Origen.Psalida# + #ListGetAt(Form.CantTrasladar,i)#>
                              
                              <cfquery name="rsUpd_RegInvTraslado_Origen" datasource="#Session.DSN#">
                                  update prod_Inventario
                                  set Pexistencia = #PIexistencias#, Psalida = #PIsalidas#
                                  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                  and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                                  and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">
                                  and Artid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.Artid,i)#">
                              </cfquery>
                          <cfelse>
                              <cfdump var="No Existe Inventario Origen de esta Area">
                              <cfbreak>
                          </cfif>
                          
                          <cfquery name="rsRegistraMovimiento" datasource="#Session.DSN#">
                              insert into Prod_Movimiento (ECodigo, OTcodigo, Artid, OTseqOrigen, OTseqDestino, PMcantidad)
                              values (
                              <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                              <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">,										
                              <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.artid,i)#">, 
                              <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">,
                              <cfqueryparam cfsqltype="cf_sql_integer" value="#0#">,                   
                              <cfqueryparam cfsqltype="cf_sql_numeric" value="#ListGetAt(Form.CantTrasladar,i)#">
                              )								
                          </cfquery>
                       </cfif>
                  </cfloop>
                  
             <cfelse>	<!--- Opcion Todo el Material --->
             								
                <cfquery name="rsBuscaRegInvTraslado_Origen" datasource="#Session.DSN#">
                      select Pexistencia, Psalida, Artid from prod_Inventario
                      where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                      and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                      and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">
                </cfquery>
                        
				<cfif rsBuscaRegInvTraslado_Origen.recordcount gt 0>
               
                    <cfloop query="rsBuscaRegInvTraslado_Origen">
                    
                        <cfquery name="rsExtraeRegInvTraslado_Origen" datasource="#Session.DSN#">
                              select Pexistencia, Psalida, Pexistencia from prod_Inventario
                              where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                              and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                              and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">
                              and Artid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaRegInvTraslado_Origen.Artid#">
                        </cfquery>
                    
						<cfif #rsExtraeRegInvTraslado_Origen.Pexistencia# gt 0>
                            <cfset PIexistencias = rsExtraeRegInvTraslado_Origen.Pexistencia - rsExtraeRegInvTraslado_Origen.Pexistencia>
                            <cfset PIsalidas = #rsBuscaRegInvTraslado_Origen.Psalida# + #rsExtraeRegInvTraslado_Origen.Pexistencia#>
                            
                            <cfquery name="rsUpd_RegInvTraslado_Origen" datasource="#Session.DSN#">
                                update prod_Inventario
                                set Pexistencia = #PIexistencias#, Psalida = #PIsalidas#
                                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                                and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">
                                and Artid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaRegInvTraslado_Origen.Artid#">
                            </cfquery>
                            
                            <cfquery name="rsRegistraMovimiento" datasource="#Session.DSN#">
                                insert into Prod_Movimiento (ECodigo, OTcodigo, Artid, OTseqOrigen, OTseqDestino, PMcantidad)
                                values (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">,										
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaRegInvTraslado_Origen.artid#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#0#">,                   
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBuscaRegInvTraslado_Origen.Pexistencia#">
                                )								
                            </cfquery>
                        </cfif>
                    </cfloop>
             	</cfif>
             </cfif>
                             
        </cfif>
       
     	<cfif isdefined("Form.Status")>
        	<cfset Status = #Form.Status#>
        	<cfquery name="rsUpdSatusAreaP" datasource="#Session.DSN#">
            	Update Prod_Proceso set OTstatus = <cfqueryparam value="#Status#" cfsqltype="cf_sql_varchar"> 
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OT#">
                        and OTseq = <cfqueryparam cfsqltype="cf_sql_integer" value="#AreaOrigen#">
            </cfquery>
		</cfif>
        
    <cfcatch type="any">
      <cfinclude template="../../../sif/errorPages/BDerror.cfm">
      <cfabort>
    </cfcatch>
  </cftry>
</cfif>


<form action="BuscaOTprod.cfm" method="post" name="sql">
	<input name="OT" type="hidden" value="<cfif isdefined("Form.Registro")><cfoutput>#Form.OT#</cfoutput></cfif>">
    <input name="OTsec" type="hidden" value="<cfif isdefined("Form.Registro")><cfoutput>#1#</cfoutput></cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
</form>

<!--- <cf_dump var="#Form#">  --->

<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>


