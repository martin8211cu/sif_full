<cfset params = "">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction action="begin">
        <cftry>
            <cfquery name="insEquivalencia" datasource="sifinterfaces">			
                insert into SIFLD_Parametros (
                    Ecodigo,
                    SIScodigo,
                    Sucursal,
                    Criterio,
                    Pcodigo,
                    Pvalor,
                    Pdescripcion)
                values (
                     <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                     <cfif isdefined("form.SIScodigo") and len(trim(form.SIScodigo)) NEQ 0>
                        rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SIScodigo#">)),
                     <cfelse>
                        '0',
                     </cfif>
					 <cfif isdefined("form.Sucursal") and len(trim(form.Sucursal)) NEQ 0>
                        rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Sucursal#">)),
                     <cfelse>
                        '0',
                     </cfif>
                     <cfif isdefined("form.Criterio") and len(trim(form.Criterio)) NEQ 0>
                        rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Criterio#">)),
                     <cfelse>
                        '0',
                     </cfif> 
                     <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Pcodigo#">, 
                     rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pvalor#">)), 
                     <cfif isdefined("form.Pdescripcion") and len(trim(form.Pdescripcion)) NEQ 0>
                        rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdescripcion#">))
                     <cfelse>
                        null
                     </cfif> 
                    )
            </cfquery>
			<cftransaction action="commit" />
        <cfcatch>
        	<cfif find("PRIMARY KEY", cfcatch.detail) NEQ 0>
				<cfset ErrorParametro = "El parametro #form.Pcodigo# para los criterios Empresa: #session.Ecodigo#">
                <cfif isdefined("form.SIScodigo") and len(trim(form.SIScodigo)) NEQ 0 and trim(form.SIScodigo) NEQ "0"> 
                    <cfset ErrorParametro = ErrorParametro & " Sistema: #form.SIScodigo#">
                </cfif>
				<cfif isdefined("form.Sucursal") and len(trim(form.Sucursal)) NEQ 0 and trim(form.Sucursal) NEQ "0"> 
                    <cfset ErrorParametro = ErrorParametro & " Sucursal: #form.Sucursal#">
                </cfif>
                <cfif isdefined("form.Criterio") and len(trim(form.Criterio)) NEQ 0 and trim(form.Criterio) NEQ "0"> 
                    <cfset ErrorParametro = ErrorParametro & " Criterio: #form.Criterio#">
                </cfif>
                <cfabort showerror="#ErrorParametro# ya existe">
            <cfelse>
            	<cfabort showerror="#cfcatch.detail#">
            </cfif>
        </cfcatch>
        </cftry>
		</cftransaction>
        *****************************************************************************************************************
        *****************************************************************************************************************
        
    <cfelseif isdefined("Form.Baja")>
		<cfquery name="delEquivalencias" datasource="sifinterfaces">
            delete from SIFLD_Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            <cfif isdefined('form.Pcodigo')>
            	and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Pcodigo#">
            </cfif>
            
            <cfif isdefined('form.SIScodigo') and len(trim(form.SIScodigo)) NEQ 0>
            	and SIScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SIScodigo#">
            <cfelse>
            	and SIScodigo = '0'
            </cfif>
            
            <cfif isdefined("form.Sucursal") and len(trim(form.Sucursal)) NEQ 0>
            	and Sucursal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Sucursal#">
            <cfelseif isdefined("form.Sucursal") and len(trim(form.Sucursal)) EQ 0>
            	and Sucursal = '0'
            </cfif>
            
            <cfif isdefined("form.Criterio") and len(trim(form.Criterio)) NEQ 0>
            	and Criterio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Criterio#">
            <cfelseif isdefined("form.Criterio") and len(trim(form.Criterio)) EQ 0>
            	and Criterio = '0'
            </cfif>
		</cfquery>
    	<cfset form.pagina = 1> 
        
        *****************************************************************************************************************
        *****************************************************************************************************************
        		
	<cfelseif isdefined("Form.Cambio")>
		<!---<cf_dbtimestamp
			datasource="sifinterfaces"
			table="SIFLD_Equivalencia" 
			redirect="Equivalencias.cfm"
			timestamp="#form.ts_rversion#"
			field1="EQUid,numeric,#form.EQUid#"> --->
		
		<cfquery name="updEquivalencias" datasource="sifinterfaces">
			update SIFLD_Parametros set 
				Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pvalor#">,
				Pdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdescripcion#"> 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            	<cfif isdefined('form.Pcodigo')>
                	and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Pcodigo#">
                </cfif>
                  
                <cfif isdefined("form.Sucursal") and len(trim(form.Sucursal)) NEQ 0>
                    and Sucursal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Sucursal#">
                <cfelseif isdefined("form.Sucursal") and len(trim(form.Sucursal)) EQ 0>
                    and Sucursal = '0'
                </cfif>
                
                <cfif isdefined("form.Criterio") and len(trim(form.Criterio)) NEQ 0>
                    and Criterio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Criterio#">
                <cfelseif isdefined("form.Criterio") and len(trim(form.Criterio)) EQ 0>
                    and Criterio = '0'
                </cfif>
		</cfquery>
	</cfif>
</cfif>

<cfset params="">
<!---
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.SIScodigo') and form.SIScodigo NEQ ''>
        <cfset params= params & '&SIScodigo=' & form.SIScodigo>			
    </cfif>
	<cfif isdefined('form.Sucursal') and form.Sucursal NEQ ''>
        <cfset params= params & '&Sucursal=' & form.Sucursal>			
    </cfif>
    <cfif isdefined('form.Criterio') and form.Criterio NEQ ''>
        <cfset params= params&'&Criterio='&form.Criterio>		
    </cfif>
    <cfif isdefined('form.Pcodigo') and form.Pcodigo NEQ ''>
        <cfset params= params & '&Pcodigo='&form.Pcodigo>	
    </cfif>
    <cfset params= params & '&modo=ALTA'>
</cfif>
--->

<cflocation url="Parametros.cfm?Pagina=#Form.Pagina##params#">

