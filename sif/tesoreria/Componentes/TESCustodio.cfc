<cfcomponent>
<!---Transacciones de Custodio--->
	<cffunction name="TranCustodioP" access="public" returntype="numeric">
		<cfargument name="CCHTCestado"   		 type="string" 		required="yes">
		<cfargument name="CCHTtipo" 			 type="string" 		required="no">
		<cfargument name="CCHTCconfirmador"		 type="numeric" 	required="yes">
		<cfargument name="CCHTCrelacionada"		 type="any" 		required="no" default=" ">
		<cfargument name="CCHTid"		 		 type="numeric" 	required="yes">
	
		<cflock name="ConsecTranC" timeout="20" throwontimeout="yes" type="exclusive">
			<cfquery name="rsConsecutivo" datasource="#session.dsn#">
				select coalesce(max(CCHTCnumero),0) + 1 as CCHTCnumero
				from CCHTransaccionesCProceso
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>	
			
			 <cfquery datasource="#Session.DSN#">
				update CCHTransaccionesCProceso
				   set CCHTCnumero = CCHTCnumero
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and CCHTCnumero = #rsConsecutivo.CCHTCnumero-1#
			</cfquery>
			
			<cfquery name="insertTranC" datasource="#Session.DSN#">
				insert into CCHTransaccionesCProceso
				(
					CCHTCnumero,           
					CCHTCestado,            
					CCHTCconfirmador,   
					CCHTCfecha,              
					CCHTid,            
					CCHTtipo,            
					CCHTCrelacionada,                  
					Ecodigo            
				)
					values
					(
						#rsConsecutivo.CCHTCnumero#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CCHTCestado#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCHTCconfirmador#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CCHTid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCHTtipo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCHTCrelacionada#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					)
					<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
			</cfquery>
            <cf_dbidentity2 datasource="#Session.DSN#" name="insertTranC" verificar_transaccion="false" returnvariable="LvarCCHTCidProc">
			<cfset varReturn=#LvarCCHTCidProc#>	
			<cfreturn #varReturn#>		
		</cflock>
	</cffunction>	
		

<!---Modificacion Estado de Transacciones de custodio en Proceso--->
	<cffunction name="CambiaEstadoTCP" access="public">
		<cfargument name="CCHTCid" 		type="numeric" 	required="yes"> 
		<cfargument name="CCHTCestado"	type="any"	required="yes"> 
	
		<cfquery name="rsMod" datasource="#session.dsn#">
			update CCHTransaccionesCProceso set
				CCHTCestado='#arguments.CCHTCestado#'
			where CCHTCid= #arguments.CCHTCid#
		</cfquery>
	</cffunction>

<!---Creacion del Vale--->
	<cffunction name="crearVale" access="public">
		<cfargument name="CCHVestado" 		 type="string"   	required="yes"> 
		<cfargument name="GELid" 	 		 type="any" 		required="no"> 
		<cfargument name="GEAid" 	 		 type="any" 		required="yes"> 
		<cfargument name="CCHVmontonOrig"    type="any" 		required="yes"> 
		<cfargument name="CCHVmontoAplicado" type="any"			required="yes"> 
		<cfargument name="CCHTid"		 	 type="numeric" 	required="yes">
		
		<cfif isdefined ('GELid') and #GELid# neq ''>
			<cfquery name="rsConsultaLiq" datasource="#session.dsn#">
				select GELid,GELtotalGastos, GELtotalDepositos,GELtotalAnticipos,GELtotalDevoluciones 
				from GEliquidacion 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and GELid = #GELid#
			</cfquery>
		<cfelseif isdefined ('GEAid') and #GEAid# neq ''>
			<cfquery name="rsConsultaAnt" datasource="#session.dsn#">
				select GEAid,GEAtotalOri
				from GEanticipo
				where GEAid = #GEAid#
			</cfquery>
		</cfif>
		
	   <cflock name="ConsecVale" timeout="20" throwontimeout="yes" type="exclusive">
			<cfquery name="SolicVale" datasource="#session.dsn#">
				select coalesce(max(CCHVnumero),0) + 1 as CCHVnumero
				from CCHVales
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>	
			
			 <cfquery datasource="#Session.DSN#">
                update CCHVales
                   set CCHVnumero = CCHVnumero
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  and CCHVnumero = #SolicVale.CCHVnumero-1#
            </cfquery>

            <cfquery name="insertVale" datasource="#Session.DSN#">
               insert into CCHVales
					(
					CCHVnumero,            
					CCHVestado,  
					GELid,  
 					GEAid,
					CCHTid,
					CCHVusucodigoGenera,           
					CCHVfecha,                    
					BMUsucodigo,                
					CCHVmontonOrig,             
					CCHVmontoAplicado,            
					CCHVusucodigoAplica,        
					CCHVfechaAplica,
					Ecodigo       
					)
				values(
					#SolicVale.CCHVnumero#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CCHVestado#">,
					<cfif isdefined ('arguments.GELid') and len(trim(arguments.GELid)) gt 0>  
					#arguments.GELid#,
					<cfelse>
					null,
					</cfif>
					<cfif isdefined ('arguments.GEAid') and len(trim(arguments.GEAid)) gt 0>  
					#arguments.GEAid#,
					<cfelse>
					null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CCHTid#">,
					#session.usucodigo#,
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(now(),'DD/MM/YYYY')#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.CCHVmontonOrig#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.CCHVmontoAplicado#">,
					#session.usucodigo#,
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				)
                <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
            </cfquery>
            <cf_dbidentity2 datasource="#Session.DSN#" name="insertVale" verificar_transaccion="false">
        </cflock>
	</cffunction>

<!---Modificacion Estado del Vale--->
	<cffunction name="CambiaEstadoVale" access="public">
		<cfargument name="CCHVid" 		type="numeric" 	required="yes"> 
		<cfargument name="CCHVestado"	type="any"		required="yes"> 
	
		<cfquery name="rsMod" datasource="#session.dsn#">
			update CCHVale set
				CCHVestado='#arguments.CCHVestado#'
			where CCHVid= #arguments.CCHVid#
		</cfquery>
	</cffunction>
</cfcomponent>


