<cfparam name="action" default="registro_valoracion.cfm">
<!--- <cf_dump var="#form#"> --->

<cfparam name="modo" default="ALTA">
<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.btnGuardar")>
            <cfquery name="rsPuesto" datasource="#session.DSN#">
            select distinct a.RHPcodigo
                from RHPuestos a
                inner join RHGradosFactorPuesto x
                    on    x.RHPcodigo   	= a.RHPcodigo
                    and    x.Ecodigo   		= a.Ecodigo 
                    and    x.RHVPid         = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
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
            <cfset listaPuestos ="">
            <cfloop query="rsPuesto">
				<cfif rsPuesto.recordCount eq rsPuesto.currentRow >
					<cfset listaPuestos = listaPuestos & "'" & rsPuesto.RHPcodigo & "'" >
				<cfelse>
					<cfset listaPuestos = listaPuestos & "'" & rsPuesto.RHPcodigo & "',">
                </cfif>
            </cfloop>
            
            <cfif len(trim(listaPuestos)) eq 0>
				<cfset listaPuestos ="-1">
			</cfif>
            <cfset VarRHPcodigo   	  =  "">
            <cfset VarRHPcodigoForm   =  "">
            <cfset VarAG1   =  "">
            <cfset VarAG2   =  "">
            <cfset VarAG3   =  "">
            
            <cfquery name="ABC_RHGradosFactorPuesto" datasource="#session.DSN#">
                delete 
                from RHDispersionPuesto  
                where  RHVPid       = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
                and    RHPcodigo    in (#PreserveSingleQuotes(listaPuestos)#)

            </cfquery>     
            
            
           	 <cfquery name="rsRHValoracionPuesto" datasource="#session.DSN#">
             	update RHValoracionPuesto set 
                	RHVtipoInterno      = <cfif isdefined("form.radTipo") and len(trim(form.radTipo))><cfqueryparam value="#form.radTipo#" cfsqltype="cf_sql_integer"><cfelse> null</cfif>,
                    RHVAjuste1Interno	= <cfif isdefined("form.AJUSTE1") and len(trim(form.AJUSTE1)) and form.AJUSTE1 gt 0><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.AJUSTE1, ',','','all')#"><cfelse> null</cfif>,	
                    RHVAjuste2Interno	= <cfif isdefined("form.AJUSTE2") and len(trim(form.AJUSTE2)) and form.AJUSTE2 gt 0><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.AJUSTE2, ',','','all')#"><cfelse> null</cfif> 	
                where  RHVPid           = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
             </cfquery>

            <cfloop query="rsPuesto">
                <cfset VarRHPcodigo   =  rsPuesto.RHPcodigo>
                <cfset VarRHPcodigoForm   =  replace(VarRHPcodigo,"-","_","All")>
                
                <cfif isdefined("Form.AG1_#trim(VarRHPcodigoForm)#") and len(trim(Evaluate('Form.AG1_#trim(VarRHPcodigoForm)#'))) gt 0>
                	<cfset VarAG1   = Evaluate("form.AG1_#trim(VarRHPcodigoForm)#")>
                </cfif>
                <cfif isdefined("Form.AG2_#trim(VarRHPcodigoForm)#") and len(trim(Evaluate('Form.AG2_#trim(VarRHPcodigoForm)#'))) gt 0>
                	<cfset VarAG2   =  Evaluate("form.AG2_#trim(VarRHPcodigoForm)#")>
                </cfif>
                <cfif isdefined("Form.AG3_#trim(VarRHPcodigoForm)#") and len(trim(Evaluate('Form.AG3_#trim(VarRHPcodigoForm)#'))) gt 0>
                	<cfset VarAG3   =  Evaluate("form.AG3_#trim(VarRHPcodigoForm)#")>
                </cfif>
                
                <cfif len(trim(VarAG1)) gt 0 or len(trim(VarAG2)) gt 0 or len(trim(VarAG3)) gt 0>
                    <cfquery name="ABC_Puestos_insert" datasource="#session.DSN#">
                        insert into RHDispersionPuesto  (RHVPid,RHPcodigo,Ecodigo,RHDPAjuste1,RHDPAjuste2,RHDPAjuste3,BMUsucodigo,BMfechaalta)
                         values ( 
                                <cfqueryparam value="#form.RHVPid#" 		cfsqltype="cf_sql_numeric">,
                                <cfqueryparam value="#VarRHPcodigo#" 		cfsqltype="cf_sql_char">,
                                <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">,
                                <cfif (isdefined("VarAG1") and len(trim(VarAG1))) and VarAG1 gt 0 >
                                    <cfqueryparam cfsqltype="cf_sql_float" value="#replace(VarAG1, ',','','all')#">,
                                <cfelse>
                                    null,
                                </cfif>
                                <cfif (isdefined("VarAG2") and len(trim(VarAG2))) and VarAG2 gt 0 >
                                    <cfqueryparam cfsqltype="cf_sql_float" value="#replace(VarAG2, ',','','all')#">,
                                <cfelse>
                                    null,
                                </cfif>
                                <cfif (isdefined("VarAG3") and len(trim(VarAG3))) and VarAG3 gt 0 >
                                    <cfqueryparam cfsqltype="cf_sql_float" value="#replace(VarAG3, ',','','all')#">,
                                <cfelse>
                                    null,
                                </cfif>
                                <cfqueryparam value="#session.Usucodigo#"	cfsqltype="cf_sql_numeric">,
                                <cfqueryparam value="#Now()#" 				cfsqltype="cf_sql_timestamp">
                                )
                    </cfquery>
                 </cfif>  
				 <cfset VarAG1   =  "">
                <cfset VarAG2   =  "">
                <cfset VarAG3   =  "">

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
    <input type="hidden" name="SEL" value="3">
    <input type="hidden" name="RHVPid" value="#form.RHVPid#">
    <input type="hidden" name="AJUSTE1" value="#form.AJUSTE1#">
    <input type="hidden" name="AJUSTE2" value="#form.AJUSTE2#">
	<cfif (isdefined("form.FRHPcodigo") and len(trim(form.FRHPcodigo)))>
        <input name="FRHPcodigo" type="hidden" value="#form.FRHPcodigo#">
    </cfif>
    <cfif (isdefined("form.FRHPdescpuesto") and len(trim(form.FRHPdescpuesto)))>
        <input name="FRHPdescpuesto" type="hidden" value="#form.FRHPdescpuesto#">    
	</cfif>
    <cfif (isdefined("form.CFid") and len(trim(form.CFid)))>
        <input name="CFid" type="hidden" value="#form.CFid#">
    </cfif>        
    <input name="tienefiltros" type="hidden" value="S">
    
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