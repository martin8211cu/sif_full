
<cfif isdefined("Form.Alta") and not isdefined("Form.Nuevo")>
     <cfquery name="rsCheck" datasource="#Session.DSN#">
     		select count(1) as checked 
        	from CPDistribucionCostosCF 
        	where CPDCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
        		and CPDCCFdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
     </cfquery>
     
     <cfif isdefined("Form.CPDCCFdefault")>
     	<cfquery name="rsActDef" datasource="#Session.DSN#"> 
        	update CPDistribucionCostosCF set CPDCCFdefault = 0
            where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
      	</cfquery>
     </cfif>
        
      <cfquery name="insert" datasource="#Session.DSN#">      
        	insert into CPDistribucionCostosCF
			       (
					   CPDCid,
					   CFid,
					   CPDCCFporc,
                       CPDCCFdefault
				   )
			values 
			       (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
						<cfqueryparam cfsqltype="cf_sql_double" value="#form.CPDCCFporc#">,
                        <cfif #rsCheck.checked# eq 0>
	                       	<cfqueryparam cfsqltype="cf_sql_bit" value="1">
                        <cfelse>
                        	<cfif isdefined("form.CPDCCFdefault")>
                            	<cfqueryparam cfsqltype="cf_sql_bit" value="1">
                            <cfelse>
                            	<cfqueryparam cfsqltype="cf_sql_bit" value="0">
                            </cfif>
                        </cfif>
            	   )
            
            update CPDistribucionCostos set 
            	CPDCporcTotal = <cfqueryparam cfsqltype="cf_sql_double" value="#form.CPDCCFtot + form.CPDCCFporc#">
            where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
	      		and Ecodigo  = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
     </cfquery>
	<cfset modo = "ALTA">
</cfif>
   <cfif isdefined("Form.Nuevo")>
	  <cfset modo = "ALTA">  
		<!---<form action="TipoDistribucion.cfm" method="post" name="sql">
			<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
			<input name="CPDCid" type="hidden" value="<cfif isdefined("form.CPDCid")><cfoutput>#form.CPDCid#</cfoutput></cfif>">
		</form>--->
		<HTML>
		<head>
	 	</head>
	    	<body>
		     <script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
		    </body>
		</HTML>

</cfif>

<cfif isdefined("Form.Baja")>
	<cfquery name="rsDefault" datasource="#Session.DSN#">
    	select count(1) as def
    	from CPDistribucionCostosCF
    	where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
        	and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
        	and CPDCCFdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
	</cfquery>
              
	<cfquery name="delete" datasource="#Session.DSN#">
    	delete from CPDistribucionCostosCF
    	where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
        	and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>   

	<cfif #rsDefault.def# neq 0 and #form.CPDCCFtot# neq 0.00>
        <cfquery name="rsCount" datasource="#Session.DSN#" maxrows="1">
            select CFid 
            from CPDistribucionCostosCF 
            where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#"> 
            order by CFid
        </cfquery>
    	<cfquery name="rsActDefault" datasource="#Session.DSN#">
        	update CPDistribucionCostosCF set
            	CPDCCFdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="1">                
        	where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
            	and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCount.Cfid#">
    	</cfquery>
	</cfif>

	<cfquery name="rsActTotal" datasource="#Session.DSN#">
    	update CPDistribucionCostos set
        	CPDCporcTotal = <cfqueryparam cfsqltype="cf_sql_double" value="#form.CPDCCFtot#">
        	,CPDCactivo = 0                
    	where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
        	and Ecodigo  = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
	</cfquery>
	<cfset LvarReset = "SI"> 
	<cfset modo="ALTA">
</cfif>

<cfif isdefined("Form.Cambio")>
	<cfif isdefined("Form.CPDCCFdefault")>
	    <cfquery name="rsUpdateDef" datasource="#Session.DSN#">
        	update CPDistribucionCostosCF set CPDCCFdefault = 0
            where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
    	 </cfquery>
     </cfif> 
     
     <cfquery name="rsCountDef" datasource="#Session.DSN#">
		select count(1) as def
        from CPDistribucionCostosCF
        where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
			and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
            and CPDCCFdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
     </cfquery>  
	
    <cfquery name="update" datasource="#Session.DSN#">
    	update CPDistribucionCostosCF set 
			<cfif isdefined('form.CFid') >
				CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			</cfif>	
			<cfif isdefined('form.CPDCCFporc') >
				,CPDCCFporc = <cfqueryparam cfsqltype="cf_sql_double" value="#form.CPDCCFporc#">						                
			</cfif>
            ,CPDCCFdefault = <cfif isdefined("form.CPDCCFdefault")>1<cfelse>0</cfif>				
		where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
			and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#"> 
            
        update CPDistribucionCostos set
        	CPDCporcTotal = <cfqueryparam cfsqltype="cf_sql_double" value="#form.CPDCCFtot + form.CPDCCFporc#">
        	<cfif (form.CPDCCFtot+form.CPDCCFporc) LT 100>
	        	,CPDCactivo = 0                   
            </cfif>
        where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
	    	and Ecodigo  = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery> 
    
    <cfif #rsCountDef.def# eq 1 and not isdefined("Form.CPDCCFdefault")>
        <cfquery name="rsCountCPD" datasource="#Session.DSN#" maxrows="1">
            select CFid 
            from CPDistribucionCostosCF 
            where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#"> 
            order by CFid
        </cfquery>

		<cfquery name="rsUpdateDefault" datasource="#Session.DSN#">
        	update CPDistribucionCostosCF set
            	CPDCCFdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="1">                
            where CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
            	and CFid = #rsCountCPD.Cfid#
    	 </cfquery>
    </cfif> 
	<cfset modo = "CAMBIO">
</cfif>
		<cfif isdefined("url.CPDCid")>
        	<cfquery name="Validar" datasource="#Session.DSN#">
				update CPDistribucionCostos set
					   Validada = 1
				where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
					   and  CPDCid = <cfqueryparam value="#CPDCid#" cfsqltype="cf_sql_numeric">
			</cfquery> 
            <cfset modo="CAMBIO">

        </cfif>
<form action="TipoDistribucion.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined('form.CPDCid')>	
		<input name="CPDCid" type="hidden" value="<cfif isdefined("form.CPDCid")><cfoutput>#form.CPDCid#</cfoutput></cfif>">
	</cfif>	
	<cfif isdefined('LvarReset')>	
		<input name="LvarReset" type="hidden" value="<cfif isdefined("LvarReset")><cfoutput>#LvarReset#</cfoutput></cfif>">
	</cfif>
</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>




