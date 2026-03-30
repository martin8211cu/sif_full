<cfif not isdefined("Form.Nuevo")>
    	<cfif isdefined("Form.Alta")>
			<cfquery name="rsValida" datasource="#session.dsn#">
              select count(1) as Existe from FACodigosConceptos
               where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                  and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#"> 
                 and CFid =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">  
            </cfquery>
            
            <cfif isdefined('rsValida') and  rsValida.Existe eq 1>
            <cfthrow message="Ya existe la combinación. Proceso cancelado!">
            </cfif>
            
            <cfquery name="rsInsert" datasource="#session.dsn#">	
                insert FACodigosConceptos (	Ecodigo, FCid,FCcodigo,Cid,Ccodigo,CFid,CFcodigo) 								
				values
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
   					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.FCcodigo#">,
   					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">, 
   					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ccodigo#">,
   					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,  
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CFcodigo#"> 
				)
                </cfquery>

				<cfset modo="ALTA">
			
			<cfelseif isdefined("Form.Baja")>            
				<cfquery name="rsDel"  datasource="#session.dsn#">
					delete from FACodigosConceptos
					where FACCid = <cfqueryparam value="#Form.FACCid#" cfsqltype="cf_sql_numeric">					
                </cfquery>    
					
				
				<cfset modo="BAJA">
			
			<cfelseif isdefined("Form.Cambio")>
              <cfquery name="rsValida" datasource="#session.dsn#">
                select count(1) as Existe from FACodigosConceptos
                  where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                   and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#"> 
                   and CFid =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">  
                    and FACCid <> <cfqueryparam  cfsqltype="cf_sql_integer" value="#Form.FACCid#">
              </cfquery>
            
              <cfif isdefined('rsValida') and  rsValida.Existe eq 1>
                <cfthrow message="Ya existe la combinación. Proceso cancelado!">
              </cfif>
            
				<cfquery name="rsUpdate" datasource="#session.dsn#">
                 update FACodigosConceptos set 
			 			FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">,
                        FCcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FCcodigo#">,
                        Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">,
                        Ccodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ccodigo#">,
                        CFid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">,
                        CFcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFcodigo#">						
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and FACCid = <cfqueryparam  cfsqltype="cf_sql_integer" value="#Form.FACCid#">
                </cfquery>  
				<cfset modo="CAMBIO">
			</cfif>	
	
</cfif>

<form action="CodigosConceptos.cfm" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	<cfelse>
		<cfif modo NEQ "BAJA">
			<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
			<cfif modo EQ "CAMBIO">
               <input name="FACCid" type="hidden" value="<cfif isdefined("Form.FCid")><cfoutput>#Form.FACCid#</cfoutput></cfif>">
            </cfif>
		</cfif>
	</cfif>
	<input type="hidden" name="PageNum" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">					
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>