<cfif form.ETLCESPECIAL eq 0 > 
    <cfquery name="rsFormato" datasource="#Session.DSN#">
        select 
            FTLCid,
            ETLCid,
            FTLCcedula,
            FTLCformato,
            FTLCnombreCKC,
            FTLCapellido1CKC,
            FTLCapellido2CKC,
            FTLCopcion1,
            FTLCopcion2,
            FTLCopcion3,
            FTLCopcion4,
            FTLCdescricion1,
            FTLCdescricion2,
            FTLCdescricion3,
            FTLCdescricion4
        from  EmpFormatoTLC	
        where  ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#" >	
    </cfquery>	
</cfif>
<cfset modo = 'ALTA'>
<cfif isdefined("url.AccionAEjecutar") and len(trim(url.AccionAEjecutar)) gt 0 and not isdefined("form.AccionAEjecutar")  >
	<cfset form.AccionAEjecutar = url.AccionAEjecutar>
</cfif>

<cfif isdefined("form.AccionAEjecutar") and len(trim(form.AccionAEjecutar)) gt 0>
	<cfif not form.AccionAEjecutar eq 'NUEVO' >
		<cfif form.AccionAEjecutar eq 'AGREGAR' >
			<cfif form.ETLCESPECIAL eq 0 >
                <cfquery name="rs_EmpresasTLC" datasource="#Session.DSN#">
                    select ETLCid   from EmpresasTLC 
                    where ETLCespecial =  1
                </cfquery>
                
                <cfquery name="rs_Referencia" datasource="#Session.DSN#">
                    select ETLCreferencia    from EmpresasTLC 
                    where ETLCid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#">
                </cfquery>
                
				<cfif rs_EmpresasTLC.recordCount eq 0>
					<cfinvoke component="sif.Componentes.Translate"
                    method="Translate"
                    Key="LB_No_se_ha_definido_la_empresa_con_que_van_a_sincronizar_los_datos"
                    Default="No se ha definido la empresa con que van a sincronizar los datos"
                    returnvariable="msg"/>
                    <cfthrow detail="#msg#">
				</cfif>              
               <cftransaction>
                    <cfquery name="ABC_PersonasTLC" datasource="#Session.DSN#">
                        insert into TLCPersonas (
                            TLCPcedula, 		
                            ETLCid,
                            TLCPSincronizado,
                            TLCPnombre,
                            TLCPapellido1,
                            TLCPapellido2,
                            TLCPCampo1,
                            TLCPCampo2,
                            TLCPCampo3,
                            TLCPCampo4
                        )
                        values (
                            <cfqueryparam cfsqltype="cf_sql_char" value="#form.TLCPcedula#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#">,
                            0,
                            <cfif isdefined("rsFormato.FTLCnombreCKC") and rsFormato.FTLCnombreCKC eq 1>
                                <cfqueryparam cfsqltype="cf_sql_char" value="#form.TLCPnombre#">,
                            <cfelse>
                                null,
                            </cfif>
                            <cfif isdefined("rsFormato.FTLCapellido1CKC") and rsFormato.FTLCapellido1CKC eq 1>
                                <cfqueryparam cfsqltype="cf_sql_char" value="#form.TLCPapellido1#">,
                            <cfelse>
                                null,
                            </cfif>
                            <cfif isdefined("rsFormato.FTLCapellido2CKC") and rsFormato.FTLCapellido2CKC eq 1>
                                <cfqueryparam cfsqltype="cf_sql_char" value="#form.TLCPapellido2#">,
                            <cfelse>
                                null,
                            </cfif>
                            <cfif isdefined("rsFormato.FTLCopcion1") and rsFormato.FTLCopcion1 eq 1>
                                <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.TLCPCampo1)#">,
                            <cfelse>
                                null,
                            </cfif>
                             <cfif isdefined("rsFormato.FTLCopcion2") and rsFormato.FTLCopcion2 eq 1>
                                <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.TLCPCampo2)#">,
                            <cfelse>
                                null,
                            </cfif>
                            <cfif isdefined("rsFormato.FTLCopcion3") and rsFormato.FTLCopcion3 eq 1>
                                <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.TLCPCampo3)#">,
                            <cfelse>
                                null,
                            </cfif>
                            <cfif isdefined("rsFormato.FTLCopcion4") and rsFormato.FTLCopcion4 eq 1>
                                <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.TLCPCampo4)#">
                            <cfelse>
                                null
                            </cfif>
                        )
                    </cfquery>

                    <cfset cedula = fnFormatoCedula(rsFormato.FTLCformato,form.TLCPcedula)>
                    

                    <cfquery name="rs_sincronizacion" datasource="#Session.DSN#">
                    	select  TLCPcedula  from TLCPadronE
                        where TLCPcedula =  <cfqueryparam cfsqltype="cf_sql_char" value="#cedula#">
                    </cfquery>
                    <cfif rs_sincronizacion.recordCount GT 0>
                        <cfquery name="insertTLCSincronizar" datasource="#Session.DSN#">
                        	insert into TLCSincronizar (TLCSepivote,TLCSeref,TLCScedula,TLCSreferencia)
                            values(
                            	 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_EmpresasTLC.ETLCid#">,
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#">,
                                <cfqueryparam cfsqltype="cf_sql_char"    value="#rs_sincronizacion.TLCPcedula#">,
                                <cfqueryparam cfsqltype="cf_sql_char"    value="#form.TLCPCampo1#">
                            )
                        </cfquery>
                        <cfquery name="updatePersonasTLC" datasource="#Session.DSN#">
                            update  TLCPersonas  set TLCPSincronizado = 1
                            where  ETLCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#">
                            and TLCPcedula = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TLCPcedula#">
                        </cfquery>
					</cfif>
                </cftransaction>
                <cfset modo = 'CAMBIO'>
            </cfif>
		<cfelseif  form.AccionAEjecutar eq 'MODIFICAR' >
			<cfif form.ETLCESPECIAL eq 0 >
                <cfquery name="updatePersonasTLC" datasource="#Session.DSN#">
                    update  TLCPersonas
                    set 
						<cfif isdefined("rsFormato.FTLCnombreCKC") and rsFormato.FTLCnombreCKC eq 1>
                        	TLCPnombre= <cfqueryparam cfsqltype="cf_sql_char" value="#form.TLCPnombre#">,
						<cfelse>
							TLCPnombre = null,
						</cfif>
                        <cfif isdefined("rsFormato.FTLCapellido1CKC") and rsFormato.FTLCapellido1CKC eq 1>
                        	TLCPapellido1 = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TLCPapellido1#">,
						<cfelse>
							TLCPapellido1 = null,
						</cfif>
                        <cfif isdefined("rsFormato.FTLCapellido2CKC") and rsFormato.FTLCapellido2CKC eq 1>
                        	TLCPapellido2 = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TLCPapellido2#">,
						<cfelse>
							TLCPapellido2 = null,
						</cfif>
                        <cfif isdefined("rsFormato.FTLCopcion1") and rsFormato.FTLCopcion1 eq 1>
                        	TLCPCampo1 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.TLCPCampo1)#">,
						<cfelse>
							TLCPCampo1 = null,
						</cfif>
                         <cfif isdefined("rsFormato.FTLCopcion2") and rsFormato.FTLCopcion2 eq 1>
                        	TLCPCampo2 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.TLCPCampo2)#">,
						<cfelse>
							TLCPCampo2 = null,
						</cfif>
                        <cfif isdefined("rsFormato.FTLCopcion3") and rsFormato.FTLCopcion3 eq 1>
                        	TLCPCampo3 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.TLCPCampo3)#">,
						<cfelse>
							TLCPCampo3 = null,
						</cfif>
                        <cfif isdefined("rsFormato.FTLCopcion4") and rsFormato.FTLCopcion4 eq 1>
                        	TLCPCampo4 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.TLCPCampo4)#">
						<cfelse>
							TLCPCampo4 = null
						</cfif>
                    where  ETLCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#">
                    and TLCPcedula = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TLCPcedula#">
                </cfquery>            
			<cfelse>
                <cfquery name="updatePersonasTLC" datasource="#Session.DSN#">
                    update  TLCPadronE
                    set 
                        TLCDcodigo  			= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TLCDcodigo#">,
                        TLCPsexo				= <cfqueryparam cfsqltype="cf_sql_char"    value="#form.TLCPsexo#">,
                        TLCPfechaCaduc			= <cfqueryparam cfsqltype="cf_sql_date"    value="#form.TLCPfechaCaduc#">,
                        TLCPjunta				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TLCPjunta#">,
                        TLCPnombre 				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TLCPnombre#">,
                        TLCPapellido1			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TLCPapellido1#">,
                        TLCPapellido2			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TLCPapellido2#">
                    where  TLCPcedula = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TLCPcedula#">
                </cfquery>
			</cfif>
			<cfset modo = 'CAMBIO'>
		<cfelseif  form.AccionAEjecutar eq 'ELIMINAR' >
			<cfif form.ETLCESPECIAL eq 0 >
				<cfset  cedula =replace(form.TLCPcedula, '-','','all')>
                
                <cfquery name="rs_sincronizacion" datasource="#Session.DSN#">
                    select  TLCPcedula  from TLCPadronE
                    where TLCPcedula =  <cfqueryparam cfsqltype="cf_sql_char" value="#cedula#">
                </cfquery>
               
                <cftransaction>
                    <cfquery name="deletePersonasTLC" datasource="#Session.DSN#">
                        delete TLCSincronizar
                        where  TLCSeref  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#">
                        and TLCScedula = <cfqueryparam cfsqltype="cf_sql_char" value="#rs_sincronizacion.TLCPcedula#">
                    </cfquery>          
                    
                    <cfquery name="deletePersonasTLC" datasource="#Session.DSN#">
                        delete TLCPersonas
                        where  ETLCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#">
                        and TLCPcedula = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TLCPcedula#">
                    </cfquery>  
                </cftransaction>     
                
            </cfif>
			<cfset modo = 'ALTA'>
		</cfif>
	</cfif>
</cfif>
<cfoutput>
	<form action="Personas.cfm" method="post" name="sql">
		<cfif isdefined("form.ETLCid") and len(trim(form.ETLCid)) gt 0>
            <input name="ETLCid" type="hidden" value="#Form.ETLCid#">
        </cfif>		

		<cfif not modo eq 'ALTA'>
            <cfif isdefined("form.TLCPcedula") and len(trim(form.TLCPcedula)) gt 0>
				<input name="TLCPcedula" type="hidden" value="#Form.TLCPcedula#">
			</cfif>
		</cfif>
	</form>
</cfoutput>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

<cffunction name="fnFormatoCedula" output="yes" access="private">
	<cfargument name="tipo"		type="string" required="yes">
	<cfargument name="valor" 	type="string" required="yes">
    <cfset var Lvarcedula = "">
    <cfset var Lvartipo		= Arguments.tipo>
    <cfset var Lvarvalor	= Arguments.valor>
    
    <cfswitch expression="#Lvartipo#">    
    	<cfcase value="1">
        	<cfset Lvarcedula = Lvarvalor>
        </cfcase>
        <cfcase value="2">
        	<cfset Lvarcedula  = Insert('0',Lvarvalor,  1)>
            <cfset Lvarcedula  = Insert('0',Lvarcedula,  5)>
        </cfcase>
        <cfcase value="3">
        	<cfset Lvarcedula = replace(Lvarvalor, '-','','all')>
        </cfcase>
        <cfcase value="4">
           <cfset Lvarcedula = replace(Lvarvalor, '-','0','all')>
        </cfcase>
    </cfswitch>
	<cfreturn Lvarcedula>
</cffunction>