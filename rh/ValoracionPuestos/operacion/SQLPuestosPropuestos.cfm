<cfparam name="action" default="registro_valoracion.cfm">
<cfparam name="modo" default="ALTA">
<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.btnAplicar")>
            <cfquery name="rsRHValoracionPuesto" datasource="#session.DSN#">
                 select RHVPfhasta from RHValoracionPuesto
                 where RHVPid =  <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
                 and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            </cfquery>
            
            <cfquery name="rsPuesto" datasource="#session.DSN#">
                select 
                a.DEid,
                c.RHPcodigo
                from LineaTiempo  a 
                inner join RHPlazas b
                    on  a.RHPid  = b.RHPid 
                    and a.Ecodigo = b.Ecodigo
                inner join RHPuestos c
                    on  b.RHPpuesto = c.RHPcodigo 
                    and b.Ecodigo   = c.Ecodigo
                inner join DatosEmpleado d
                    on  a.DEid = d.DEid
                left outer join CFuncional x
                    on  c.Ecodigo = x.Ecodigo
                    and c.CFid    = x.CFid    
                where <cfqueryparam value="#rsRHValoracionPuesto.RHVPfhasta#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
                and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<cfif (isdefined("form.FRHPcodigo") and len(trim(form.FRHPcodigo)))>
                    and upper(c.RHPcodigo) like  '%#Ucase(form.FRHPcodigo)#%'
                </cfif>
                <cfif (isdefined("form.FRHPdescpuesto") and len(trim(form.FRHPdescpuesto)))>
                    and upper(c.RHPdescpuesto) like  '%#Ucase(form.FRHPdescpuesto)#%'
                </cfif>
                <cfif (isdefined("form.CFid") and len(trim(form.CFid)))>
                    and x.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
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
			<cfset VarDeid  =  -1> 
            <cfquery name="ABC_RHGradosFactorPuesto" datasource="#session.DSN#">
                delete 
                from RHPropuestaPuesto  
                where  RHVPid       = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
                and    RHPcodigo    in (#PreserveSingleQuotes(listaPuestos)#)
            </cfquery>            
            
            <cfloop query="rsPuesto">
                <cfset VarRHPcodigo   =  rsPuesto.RHPcodigo>
                <cfset VarRHPcodigoForm   =  trim(replace(VarRHPcodigo,"-","_","All"))>
                <cfset VarDeid  =  rsPuesto.Deid> 
                 <cfif isdefined("Form.Cod_#trim(VarRHPcodigoForm)#_#VarDeid#") and len(trim(Evaluate('Form.Cod_#trim(VarRHPcodigoForm)#_#VarDeid#'))) gt 0>
                    <cfset RHPcodigoP   =  Evaluate("Form.Cod_#trim(VarRHPcodigoForm)#_#VarDeid#")>
                    <cfquery name="ABC_Puestos_insert" datasource="#session.DSN#">
                        insert into RHPropuestaPuesto  (RHVPid,RHPcodigo,RHPcodigoP,Ecodigo,DEid,BMUsucodigo,BMfechaalta)
                         values ( 
                                <cfqueryparam value="#form.RHVPid#" 		cfsqltype="cf_sql_numeric">,
                                <cfqueryparam value="#VarRHPcodigo#" 			cfsqltype="cf_sql_char">,
                                <cfqueryparam value="#RHPcodigoP#" 			cfsqltype="cf_sql_char">,
                                <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#VarDeid#" 			cfsqltype="cf_sql_numeric">,
                                <cfqueryparam value="#session.Usucodigo#"	cfsqltype="cf_sql_numeric">,
                                <cfqueryparam value="#Now()#" 				cfsqltype="cf_sql_timestamp">
                                )
                    </cfquery>
                 </cfif>  
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
    <input type="hidden" name="SEL" value="4">
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