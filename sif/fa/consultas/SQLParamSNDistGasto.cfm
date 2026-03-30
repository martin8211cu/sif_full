<cfif not isdefined("Form.Nuevo")>	
	<cfquery name="distribucionGasto" datasource="#session.dsn#">
    	select cuenta, sum(porcentajeDist) as PctjeDist
        from FAParamDistGasto
        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and cuenta=
        <cfif isdefined ("form.cfformato")><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cfformato#">
        <cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ctasdistgasto#">
        </cfif>
        group by cuenta
    </cfquery>
    <cfset pctjeDistGasto=0>
    <cfif isdefined("distribucionGasto") and distribucionGasto.PctjeDist GT 0>
    	<cfset pctjeDistGasto=numberformat(distribucionGasto.PctjeDist,'9.00')>
       <!---<cfset disponible = 100-pctjeDistGasto>--->    
    </cfif>
    <!---<cfset pctjeDistGasto=distribucionGasto.PctjeDist>--->
   
    <cfset disponible = 100-pctjeDistGasto>
    <cfif isdefined("Form.Cambio")>
    	<cfquery name="distGastoCta" datasource="#session.dsn#">
    		select cuenta, porcentajeDist
            from FAParamDistGasto
            where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and cuenta=
            <cfif isdefined ("form.cfformato")><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cfformato#">
            <cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ctasdistgasto#">
            </cfif>
       	</cfquery>
        <cfset  pctjeDistGasto=numberformat(distGastoCta.porcentajeDist,'9.00')>
    </cfif>
    <!---<cfdump var="#distribucionGasto#">--->
    
	<cftry>
		<cfquery name="CtasDistGasto" datasource="#Session.DSN#">
			set nocount on			
			<cfif isdefined("Form.Alta")>
            <cfif isdefined("Form.cformato1") and len(Form.cformato1)>
            	<cfset cuenta='#Form.cmayor_ccuenta1#-#Form.cformato1#'>
            <cfelse>
            	<cfset cuenta='#Form.cfformato#'>
            </cfif>
             <!---<cfthrow message="#Form.chkCim# #Form.chkFmr# #Form.chkHpe# ">--->
			 <cfif Form.txtPctjeDist GT disponible >
             	<cf_throw message="El porcentaje de Distribucion excede el  disponible para la cuenta #form.cfformato#">
        		<cfabort>	
             </cfif>
				Insert 	FAParamDistGasto(Ecodigo,cuenta,descripcion,SNid,porcentajeDist)
						values	(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
						<cfif len(cuenta)><cfqueryparam cfsqltype="cf_sql_varchar" value="#cuenta#"> <cfelse>null</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFdescripcion#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNid#">,
                        
                        <cfif isdefined("form.txtPctjeDist") and len(form.txtPctjeDist)><cfqueryparam cfsqltype="cf_sql_float" value="#numberformat(Form.txtPctjeDist,'9.00')#"><cfelse>0</cfif> 
						)
				Select 1
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
           <cfset distGasto=disponible-Form.txtPctjeDist>
           	<cfif Form.txtPctjeDist LT pctjeDistGasto>
            
			<cfelse>
            	<cfset distGasto=Form.txtPctjeDist-pctjeDistGasto>
                <!---<cfthrow message=" #distGasto# #disponible#">--->
                <cfif distGasto GT disponible>
				 <!---<cfif Form.txtPctjeDist GT disponible>--->
                    <cf_throw message="El porcentaje de Distribucion excede el  disponible para la cuenta #Form.ctasdistgasto#">
                    <cfabort>	
                 </cfif>
            </cfif>     
                        <!---<cfthrow message="#Form.chkCim# #Form.chkFmr# #Form.chkHpe# ">--->
				Update 	FAParamDistGasto
					set  <!---descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion1#">,--->	
                      porcentajeDist=<cfif isdefined("form.txtPctjeDist")and len(form.txtPctjeDist)><cfqueryparam cfsqltype="cf_sql_float" value="#numberformat(Form.txtPctjeDist,'9.00')#"><cfelse>0</cfif>
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				      and cuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ctasdistgasto#">
                      and SNid=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNid#">
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete FAParamDistGasto
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				     and cuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ctasdistgasto#">
                     and SNid=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNid#">
				<cfset modo="BAJA">
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="../consultas/ListaParamDistGastos.cfm" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="cuenta" type="hidden" value="<cfif isdefined("Form.cuenta")><cfoutput>#Form.cuenta#</cfoutput></cfif>">
   	<input name="descripcion" type="hidden" value="<cfif isdefined("Form.descripcion")><cfoutput>#Form.descripcion#</cfoutput></cfif>">
    <input name="socio" type="hidden" value="<cfif isdefined("Form.SNid")><cfoutput>#Form.SNid#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>