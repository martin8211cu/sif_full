<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
    	<!---<cfif isdefined('Form.CMNestado') and #Form.CMNestado# eq 1>         
		      <cfquery name="rsUpdateEstados" datasource="#Session.DSN#">
			       update CMNotas set CMNestado =  <cfqueryparam value="0" cfsqltype="cf_sql_integer">	
				      where CMPid  = <cfqueryparam value="#Session.compras.procesoCompra.CMPid#" cfsqltype="cf_sql_numeric">
			</cfquery>		  
	   </cfif>--->
       <cfquery name="insert" datasource="#Session.DSN#">
			insert into CMNotas(CMPid, CMNtipo, CMNresp, CMNtel, CMNemail,CMNfechaIni,CMNfechaFin,CMNdiasDuracion, Usucodigo, fechaalta, CMNnota,CMNestado) 
			values ( <cfqueryparam value="#session.compras.procesoCompra.CmPid#" cfsqltype="cf_sql_numeric">,
					 <cfqueryparam value="#Form.CMNtipo#" cfsqltype="cf_sql_varchar">,
					 <cfqueryparam value="#Form.CMNresp#" cfsqltype="cf_sql_varchar">,
					 <cfqueryparam value="#Form.CMNtel#" cfsqltype="cf_sql_varchar">,
					 <cfqueryparam value="#Form.CMNemail#" cfsqltype="cf_sql_varchar">,
 			        <cfif isdefined('Form.CMNfechaIni') and len(trim(#Form.CMNfechaIni#))>
                      <cf_jdbcquery_param value="#lsparsedatetime(Form.CMNfechaIni)#" cfsqltype="cf_sql_timestamp">, 
                    <cfelse>
                     <cf_jdbcquery_param value="null" cfsqltype="cf_sql_timestamp">,  
                    </cfif>
   			        <cfif isdefined('Form.CMNfechaFin') and len(trim(#Form.CMNfechaFin#))>
		             <cf_jdbcquery_param value="#lsparsedatetime(Form.CMNfechaFin)#" cfsqltype="cf_sql_timestamp">,
                    <cfelse>
                     <cf_jdbcquery_param value="null" cfsqltype="cf_sql_timestamp">,
                    </cfif> 
   	                 <cf_jdbcquery_param value="#Form.CMNdiasDuracion#" cfsqltype="cf_sql_integer" voidNull>,
					 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					 <cfqueryparam value="#Form.CMNnota#" cfsqltype="cf_sql_longvarchar">,
					 <cfqueryparam value="#Form.CMNestado#" cfsqltype="cf_sql_integer">					 
			       )
		       	<cf_dbidentity1 datasource="#session.DSN#">				
		</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insert">		
		<cfset Request.key = insert.identity >
        
        <cfif isdefined('Form.CMNestado') and #Form.CMNestado# eq 1>         
		      <cfquery name="rsUpdateEstados" datasource="#Session.DSN#">
			       update CMNotas set CMNestado =  <cfqueryparam value="0" cfsqltype="cf_sql_integer">	
				      where CMPid  = <cfqueryparam value="#Session.compras.procesoCompra.CMPid#" cfsqltype="cf_sql_numeric">
                      and CMNid <> #Request.key#
			</cfquery>		  
	   </cfif>
           
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from CMNotas
			where  CMPid = <cfqueryparam value="#session.compras.procesoCompra.CmPid#" cfsqltype="cf_sql_numeric"> 
			  and  CMNid = <cfqueryparam value="#form.CMNid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset modo="BAJA">

	   <cfelseif isdefined("Form.Cambio")>
	  					
            	 	<cfquery name="update" datasource="#Session.DSN#">
                        update CMNotas set
                           <cfif isdefined('Form.CMNtipo') and len(rtrim(#Form.CMNtipo#)) gt 0>
                              CMNtipo   = <cfqueryparam value="#Form.CMNtipo#" cfsqltype="cf_sql_varchar">,
                           </cfif>
                           <cfif isdefined('Form.CMNresp') and len(rtrim(#Form.CMNresp#)) gt 0>
                              CMNresp   = <cfqueryparam value="#Form.CMNresp#" cfsqltype="cf_sql_varchar">,
                           </cfif>
                           <cfif isdefined('Form.CMNtel') and len(rtrim(#Form.CMNtel#)) gt 0>
                             CMNtel    = <cfqueryparam value="#Form.CMNtel#" cfsqltype="cf_sql_varchar">,
                           </cfif>
                           <cfif isdefined('Form.CMNemail') <!---and len(rtrim(#Form.CMNemail#)) gt 0--->>
                             CMNemail  = <cfqueryparam value="#Form.CMNemail#" cfsqltype="cf_sql_varchar">,
                           </cfif>				   
                           <cfif isdefined('Form.CMNnota') and len(rtrim(#Form.CMNnota#)) gt 0>
                             CMNnota   = <cfqueryparam value="#Form.CMNnota#" cfsqltype="cf_sql_longvarchar">,
                           </cfif>				  
                            CMNdiasDuracion=  <cf_jdbcquery_param value="#Form.CMNdiasDuracion#" cfsqltype="cf_sql_integer" voidNull>,
                           
                            <cfif isdefined('Form.CMNfechaIni') and len(trim(#Form.CMNfechaIni#))>
                              CMNfechaIni= <cf_jdbcquery_param value="#lsparsedatetime(Form.CMNfechaIni)#" cfsqltype="cf_sql_timestamp">, 
                            <cfelse>
                             CMNfechaIni= <cf_jdbcquery_param value="null" cfsqltype="cf_sql_timestamp">,  
                            </cfif>                           
                            <cfif isdefined('Form.CMNfechaFin') and len(trim(#Form.CMNfechaFin#))>
                             CMNfechaFin = <cf_jdbcquery_param value="#lsparsedatetime(Form.CMNfechaFin)#" cfsqltype="cf_sql_timestamp">,
                            <cfelse>
                             CMNfechaFin =  <cf_jdbcquery_param value="null" cfsqltype="cf_sql_timestamp">,
                            </cfif> 				  
                            <cfif isdefined('Form.CMNestado') and len(rtrim(#Form.CMNestado#)) gt 0> 	     		
                             CMNestado = <cfqueryparam value="#Form.CMNestado#" cfsqltype="cf_sql_integer">
                             </cfif>	   
                    	where  CMPid  = <cfqueryparam value="#Session.compras.procesoCompra.CMPid#" cfsqltype="cf_sql_numeric">
                      	and  CMNid  = <cfqueryparam value="#Form.CMNid#" cfsqltype="cf_sql_numeric">
                	</cfquery>                  
                    
                    <cfif isdefined('Form.CMNestado') and #Form.CMNestado# eq 1> 	     		
                          <cfquery name="rsUpdateEstados" datasource="#Session.DSN#">
                               update CMNotas set CMNestado =  <cfqueryparam value="0" cfsqltype="cf_sql_integer">
                                  where  CMPid  = <cfqueryparam value="#Session.compras.procesoCompra.CMPid#" cfsqltype="cf_sql_numeric">
                                  and  CMNid  <> <cfqueryparam value="#Form.CMNid#" cfsqltype="cf_sql_numeric">
                        </cfquery>
                    </cfif>                    
                    
					<cfset modo="CAMBIO">
			</cfif>
</cfif>
<cfoutput>


<form action="compraProceso.cfm" method="post" name="sql">
	<cfif not isdefined("form.btnRegresar")><input name="btnNotas" type="hidden" value="Notas"></cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined("Form.CMNid") and isdefined("Form.Cambio") ><input name="CMNid" type="hidden" value="#Form.CMNid#"></cfif>
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>



