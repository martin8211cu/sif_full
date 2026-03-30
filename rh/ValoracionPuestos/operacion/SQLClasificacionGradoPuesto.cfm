<cfparam name="action" default="registro_valoracion.cfm">
<cfparam name="modo" default="ALTA">
<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.btnAplicar")>
            <cfquery name="rsPuesto" datasource="#session.DSN#">
                select a.RHPcodigo
                from RHPuestos a
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                <cfif (isdefined("form.FRHPcodigo") and len(trim(form.FRHPcodigo)))>
                    and upper(a.RHPcodigo) like  '%#Ucase(form.FRHPcodigo)#%'
                </cfif>
                <cfif (isdefined("form.FRHPdescpuesto") and len(trim(form.FRHPdescpuesto)))>
                    and upper(a.RHPdescpuesto) like  '%#Ucase(form.FRHPdescpuesto)#%'
                </cfif>
                <cfif (isdefined("form.CFid") and len(trim(form.CFid)))>
                    and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
                </cfif>        
            </cfquery>
            
            <cfquery name="rsfactor" datasource="#session.DSN#">
                select RHFid
                from RHFactores
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            </cfquery> 

			<cfset VarRHPcodigo   	  =  "">
            <cfset VarRHPcodigoForm   =  "">
            <cfloop query="rsPuesto">
            
            	<cfset VarRHPcodigo   =  rsPuesto.RHPcodigo>
                <cfset VarRHPcodigoForm   =  replace(VarRHPcodigo,"-","_","All")>
                <cfquery name="ABC_RHGradosFactorPuesto" datasource="#session.DSN#">
                    delete 
                    from RHGradosFactorPuesto  
                    where  RHPcodigo   	= <cfqueryparam value="#VarRHPcodigo#" cfsqltype="cf_sql_char">
                    and    Ecodigo   	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    and    RHVPid       = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
                </cfquery>
                <cfset VarRHFid   =  -1>
                  <cfloop query="rsfactor">
                 	<cfset VarRHFid   =  rsfactor.RHFid>
                    <cfif isdefined("Form.GRD_#trim(VarRHPcodigoForm)#_#trim(VarRHFid)#") and len(trim(Evaluate('Form.GRD_#trim(VarRHPcodigoForm)#_#trim(VarRHFid)#'))) gt 0>
						<cfset VarRHGid   = Evaluate("form.GRD_#trim(VarRHPcodigoForm)#_#trim(VarRHFid)#")>
                        <cfquery name="ABC_Puestos_insert" datasource="#session.DSN#">
                            insert into RHGradosFactorPuesto  (RHVPid,RHPcodigo,Ecodigo,RHFid,RHGid,BMUsucodigo,BMfechaalta)
                             values ( 
                                    <cfqueryparam value="#form.RHVPid#" 		cfsqltype="cf_sql_numeric">,
                                    <cfqueryparam value="#VarRHPcodigo#" 		cfsqltype="cf_sql_char">,
                                    <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">,
                                    <cfqueryparam value="#VarRHFid#" 			cfsqltype="cf_sql_numeric">,
                                    <cfqueryparam value="#VarRHGid#" 			cfsqltype="cf_sql_numeric">,
                                    <cfqueryparam value="#session.Usucodigo#"	cfsqltype="cf_sql_numeric">,
                                    <cfqueryparam value="#Now()#" 				cfsqltype="cf_sql_timestamp">
                                    )
                        </cfquery>
                    </cfif>
                 </cfloop>
            </cfloop>
		</cfif>
        
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	
<cfoutput>
<form action="#action#" method="post" name="sql">
    <input type="hidden" name="SEL" value="2">
    <input type="hidden" name="RHVPid" value="#form.RHVPid#">
	<cfif (isdefined("form.FRHPcodigo") and len(trim(form.FRHPcodigo)))>
        <input name="FRHPcodigo" type="hidden" value="#form.FRHPcodigo#">
    </cfif>
    <cfif (isdefined("form.FRHPdescpuesto") and len(trim(form.FRHPdescpuesto)))>
        <input name="FRHPdescpuesto" type="hidden" value="#form.FRHPdescpuesto#">    
	</cfif>
    <cfif (isdefined("form.CFid") and len(trim(form.CFid)))>
        <input name="CFid" type="hidden" value="#form.CFid#">
    </cfif>        
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>