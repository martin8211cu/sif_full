<cfcomponent>
	<!---►►►►►►Agrega un Nuevo Acuerdo de Pago►►►►►►--->
	<cffunction name="AltaAcuerdoPago"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    	type="string"  	required="no">
		<cfargument name="Ecodigo" 		    	type="numeric" 	required="no">
        <cfargument name="BMUsucodigo" 		    type="numeric" 	required="no">
        <cfargument name="TESAPnumero" 		    type="string" 	required="yes">
        <cfargument name="TASAPfecha" 		    type="date" 	required="yes">
        <cfargument name="TESAPautorizador1"    type="string" 	required="yes">
        <cfargument name="TESAPautorizador2" 	type="string" 	required="yes">
        <cfargument name="Ocodigo" 			type="any" 		required="no">
        
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif NOT isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif NOT isdefined('Arguments.BMUsucodigo')>
        	<cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
		
        <cftransaction>
            <cfquery name="rsInsert" datasource="#Arguments.Conexion#">
                insert into TESacuerdoPago 
                    (Ecodigo,TESAPnumero, TASAPfecha, TESAPautorizador1, TESAPautorizador2, BMUsucodigo,Ocodigo)
                values (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESAPnumero#">,
                    '#LSDateFormat(Arguments.TASAPfecha,"YYYY-MM-DD")#',
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESAPautorizador1#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESAPautorizador2#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BMUsucodigo#">,
					<cfif isdefined('Arguments.Ocodigo') and len(trim(Arguments.Ocodigo))>
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
						  <cfelse>
						  	<CF_jdbcquery_param cfsqltype="cf_sql_integer" value="null"> 
						  </cfif>
                 )
                 <cf_dbidentity1>
            </cfquery>
                <cf_dbidentity2 name="rsInsert">
             <cfset AltaDAcuerdoPago(Arguments.Conexion,rsInsert.identity,Arguments.BMUsucodigo,Arguments.TASAPfecha,-1,Arguments.Ocodigo)>
        </cftransaction>
		<cfreturn rsInsert.identity>
    </cffunction>
    <!---►►►►►►Modifica un Acuerdo de Pago►►►►►►--->
    <cffunction name="CambioAcuerdoPago"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    	type="string"  	required="no">
		<cfargument name="Ecodigo" 		    	type="numeric" 	required="no">
        <cfargument name="BMUsucodigo" 		    type="numeric" 	required="no">
        <cfargument name="TESAPid" 				type="numeric" 	required="yes">
        <cfargument name="TESAPnumero" 		    type="string" 	required="yes">
        <cfargument name="TASAPfecha" 		    type="date" 	required="yes">
        <cfargument name="TESAPautorizador1"    type="string" 	required="yes">
        <cfargument name="TESAPautorizador2" 	type="string" 	required="yes">
        <cfargument name="ts_rversion" 			type="any" 		required="yes">
        <cfargument name="Ocodigo" 			type="any" 		required="no">

		  
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif NOT isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif NOT isdefined('Arguments.BMUsucodigo')>
        	<cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
        
         <cf_dbtimestamp datasource="#Arguments.Conexion#" table="TESacuerdoPago" redirect="AcuerdoPago.cfm?TESAPid=#Arguments.TESAPid#" timestamp="#Arguments.ts_rversion#"				
			field1="TESAPid" 
			type1="numeric"
			value1="#Arguments.TESAPid#">
        
       	<cfquery name="rsInsert" datasource="#Arguments.Conexion#">
        	update TESacuerdoPago set 
    			Ecodigo 		  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                TESAPnumero 	  =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESAPnumero#">, 
                TASAPfecha  	  =  <cfqueryparam cfsqltype="cf_sql_date" 	  value="#Arguments.TASAPfecha#">, 
                TESAPautorizador1 =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESAPautorizador1#">, 
                TESAPautorizador2 =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESAPautorizador2#">, 
					<cfif isdefined('Arguments.Ocodigo') and len(trim(Arguments.Ocodigo))>
                Ocodigo 	  	  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">,
					<cfelse>
						Ocodigo 	  	  =  <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,
					</cfif>
                BMUsucodigo 	  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BMUsucodigo#">
            where TESAPid 		  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESAPid#">
        </cfquery>
        
		<cfreturn Arguments.TESAPid>
    </cffunction>
    <!---►►►►►►Elimina un Acuerdo de Pago►►►►►►--->
     <cffunction name="BajaAcuerdoPago"  access="public">
		<cfargument name="Conexion" 	 type="string"  required="no">
        <cfargument name="TESAPid" 		 type="numeric" required="yes">
         <cfargument name="ts_rversion"  type="any" 	required="yes">
        
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
         <cf_dbtimestamp datasource="#Arguments.Conexion#" table="TESacuerdoPago" redirect="AcuerdoPago.cfm?TESAPid=#Arguments.TESAPid#" timestamp="#Arguments.ts_rversion#"				
			field1="TESAPid" 
			type1="numeric"
			value1="#Arguments.TESAPid#">
       <cftransaction>
            <cfset BajaDAcuerdoPago(Arguments.Conexion,Arguments.TESAPid)>
            <cfquery name="rsInsert" datasource="#Arguments.Conexion#">
                delete from TESacuerdoPago 
                where TESAPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESAPid#">
            </cfquery>
       </cftransaction>
    </cffunction>
    <!---►►►►►►Obtiene los datos de un Acuerdo de Pago►►►►►►--->
    <cffunction name="GetAcuerdoPago"  access="public" returntype="query">
		<cfargument name="Conexion" 	 type="string"  required="no">
        <cfargument name="TESAPid" 		 type="numeric" required="yes">
        
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
         
       	<cfquery name="rsAcuerdoPago" datasource="#Arguments.Conexion#">
        	select TESAPid,Ecodigo,TESAPnumero, TASAPfecha, TESAPautorizador1, TESAPautorizador2, BMUsucodigo, ts_rversion , Ocodigo
            	from TESacuerdoPago 
            where TESAPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESAPid#">
        </cfquery>
        <cfreturn rsAcuerdoPago>
    </cffunction>
    <!---►►►►►►Asocia todas las Solicitudes de pago desligadas a el Acuerdo de Pago►►►►►►--->
     <cffunction name="AltaDAcuerdoPago"  access="public">
		<cfargument name="Conexion" 	 type="string"  required="no">
        <cfargument name="TESAPid" 		 type="numeric" required="yes">
        <cfargument name="BMUsucodigo" 	 type="numeric" required="no">
        <cfargument name="TASAPfecha" 	 type="date" required="no">
        <cfargument name="TESSPid" 	 	 type="numeric" required="no">
        <cfargument name="Ocodigo" 		type="any" 		required="no">
        
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif NOT isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
         <cfif NOT isdefined('Arguments.BMUsucodigo')>
        	<cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
         
       	<cfquery datasource="#Arguments.Conexion#">
        	update TESsolicitudPago set 
            	TESAPid 	= #Arguments.TESAPid#, 
                BMUsucodigo = #Arguments.BMUsucodigo#
             where TESAPid is null 
               and TESSPtipoDocumento  in (1,7,10)
               and (TESSPestado in (2, 212) OR (TESSPestado=11 and TESSPtipoDocumento=10))
               and EcodigoOri = #session.Ecodigo#
               <cfif isdefined('Arguments.TASAPfecha') and Arguments.TASAPfecha NEQ "">
        			and TESSPfechaPagar  = '#LSDateFormat(Arguments.TASAPfecha,"YYYY-MM-DD")#'
        	   </cfif>
               <cfif isdefined('Arguments.Ocodigo') and len(trim(Arguments.Ocodigo))>
               		and CFid in (select CFid from CFuncional where Ocodigo =#Arguments.Ocodigo# )
               </cfif>
        </cfquery>
    </cffunction>
    <!---►►►►►►Asocia todas las Solicitudes de pago desligadas a el Acuerdo de Pago►►►►►►--->
     <cffunction name="AltaDAcuerdoPagoUNO"  access="public">
		<cfargument name="Conexion" 	 type="string"  required="no">
        <cfargument name="TESAPid" 		 type="numeric" required="yes">
        <cfargument name="BMUsucodigo" 	 type="numeric" required="no">
        <cfargument name="TESSPid" 	 	 type="numeric" required="no">
        
        
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif NOT isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
         <cfif NOT isdefined('Arguments.BMUsucodigo')>
        	<cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
       	<cfquery datasource="#Arguments.Conexion#">
        	update TESsolicitudPago set 
            	TESAPid 	= #Arguments.TESAPid#, 
                BMUsucodigo = #Arguments.BMUsucodigo#
             where TESAPid is null 
               and (TESSPestado in (2, 212) OR (TESSPestado=11 and TESSPtipoDocumento=10))
               and EcodigoOri = #session.Ecodigo#
               AND TESSPid 	= #Arguments.TESSPid#
        </cfquery>
    </cffunction>
     <!---►►►►►►Des-Asocia todas las Solicitudes de pago Ligadas a el Acuerdo de Pago►►►►►►--->
     <cffunction name="BajaDAcuerdoPago"  access="public">
		<cfargument name="Conexion" 	 type="string"  required="no">
        <cfargument name="TESAPid" 		 type="numeric" required="no">
        <cfargument name="TESSPid" 		 type="numeric" required="no">
        
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
       
       	<cfquery datasource="#Arguments.Conexion#">
        	update TESsolicitudPago set 
            	TESAPid 	  = null
             <cfif isdefined('Arguments.TESAPid')>
            	where TESAPid = #Arguments.TESAPid#
             <cfelseif isdefined('Arguments.TESSPid')>
             	where TESSPid = #Arguments.TESSPid#
             <cfelse>
             	where 1=2
             </cfif>
        </cfquery>
    </cffunction>
	   <!---►►►►►►Obtiene los detalles de un Acuerdo de Pago►►►►►►--->
    <cffunction name="GetAcuerdoPagoD"  access="private" returntype="query">
		<cfargument name="Conexion" 	 type="string"  required="no">
        <cfargument name="TESAPid" 		 type="numeric" required="yes">
        
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
         
       	<cfquery name="rsAcuerdoPagoD" datasource="#Arguments.Conexion#">
        	select TESAPid, TESSPid
            	from TESsolicitudPago 
            where TESAPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESAPid#">
        </cfquery>
        <cfreturn rsAcuerdoPagoD>
    </cffunction>
	<!---►►►►►►Cambia el estado del Acuerdo de Pago►►►►►►--->
     <cffunction name="fnCambiaEstado" access="private">
		<cfargument name="Conexion" 	 type="string"  required="no">
        <cfargument name="TESAPid" 		 type="numeric" required="yes">
		<cfargument name="TESAPestado" 	 type="numeric" required="yes">
        <cfargument name="Usuario" 	 	 type="numeric" required="yes">
		<cfargument name="Tipo" 	 	type="numeric" required="yes">
		
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
       
       	<cfquery datasource="#Arguments.Conexion#">
        	update TESacuerdoPago set 
            	TESAPestado 	  = #Arguments.TESAPestado#
				<cfif Arguments.Tipo eq 0>
					,TESAPusuarioPr = #Arguments.Usuario#
				<cfelseif  Arguments.Tipo eq 2>
					,TESAPusuarioAp = #Arguments.Usuario#
				<cfelseif  Arguments.Tipo eq 3>
					,TESAPusuarioAn = #Arguments.Usuario#
				</cfif>
            where TESAPid = #Arguments.TESAPid#
        </cfquery>
    </cffunction>
	<!---►►►►►►Agrega un Nuevo Acuerdo de Pago al historico►►►►►►--->
	<cffunction name="AltaAcuerdoPagoH"  access="private">
		<cfargument name="Conexion" 	    	type="string"  	required="no">
		<cfargument name="Ecodigo" 		    	type="numeric" 	required="no">
        <cfargument name="BMUsucodigo" 		    type="numeric" 	required="no">
		<cfargument name="TESAPid" 				type="numeric" 	required="yes">
		<cfargument name="TESSPid" 				type="numeric" 	required="no">
        
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif NOT isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif NOT isdefined('Arguments.BMUsucodigo')>
        	<cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
		<cfif isdefined('Arguments.TESSPid') and Arguments.TESSPid neq -1>
			<cfquery datasource="#Arguments.Conexion#">
				insert into TESacuerdoPagoH (TESAPid, TESSPid, Ecodigo, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESAPid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESSPid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BMUsucodigo#">
				 )
			</cfquery>
		<cfelse>
			<cfquery datasource="#Arguments.Conexion#">
				insert into TESacuerdoPagoH (TESAPid, TESSPid, Ecodigo, BMUsucodigo)
				select #Arguments.TESAPid#, TESSPid, #Arguments.Ecodigo# ,#Arguments.BMUsucodigo#
				from TESsolicitudPago
				where TESAPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESAPid#">
			</cfquery>
		</cfif>
    </cffunction>
	<!---►►►►►►Cambio Masivo Acuerdo de Pago Detalles►►►►►►--->
	<cffunction name="fnCambioMasivaAcuerdoPagoH"  access="private">
		<cfargument name="Conexion" 	    	type="string"  	required="no">
		<cfargument name="TESAPid" 				type="numeric" 	required="yes">
        
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
		<cfquery datasource="#Arguments.Conexion#">
			update TESsolicitudPago set TESAPid = null
			where TESAPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESAPid#">
		</cfquery>
    </cffunction>
	<!---►►►►►►Elimina Masivo historico Acuerdo de Pago►►►►►►--->
	<cffunction name="fnBajaMasivaAcuerdoPagoH"  access="private">
		<cfargument name="Conexion" 	    	type="string"  	required="no">
		<cfargument name="TESAPid" 				type="numeric" 	required="yes">
        
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
		<cfquery datasource="#Arguments.Conexion#">
			delete from TESacuerdoPagoH
			where TESAPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESAPid#">
		</cfquery>
    </cffunction>
	 <!---►►►►►►Envia a aprobación el Acuerdo de Pago►►►►►►--->
     <cffunction name="fnEnviarAprobacion" access="public">
		<cfargument name="Conexion" 	 	type="string"  	required="no">
		<cfargument name="Ecodigo" 	 	 	type="numeric" 	required="no">
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="no">
		<cfargument name="TESAPusuarioPr" 	type="numeric" 	required="no">
        <cfargument name="TESAPid" 		 	type="numeric" 	required="yes">
        
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
		<cfif NOT isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
		<cfif NOT isdefined('Arguments.BMUsucodigo')>
        	<cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
		<cfif NOT isdefined('Arguments.TESAPusuarioPr')>
        	<cfset Arguments.TESAPusuarioPr = session.Usucodigo>
        </cfif>
		
		<cftransaction>
			<cfset fnCambiaEstado(Arguments.Conexion,Arguments.TESAPid,1,Arguments.TESAPusuarioPr,0)>
			<cfset AltaAcuerdoPagoH(Arguments.Conexion,Arguments.Ecodigo,Arguments.BMUsucodigo,Arguments.TESAPid,-1)>
		</cftransaction>
    </cffunction>
	 <!---►►►►►►Vuele a En Aprobación el Acuerdo de Pago►►►►►►--->
     <cffunction name="fnRechazado" access="public">
		<cfargument name="Conexion" 	 	type="string"  	required="no">
		<cfargument name="Ecodigo" 	 	 	type="numeric" 	required="no">
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="no">
		<cfargument name="TESAPusuarioPr" 	type="numeric" 	required="no">
        <cfargument name="TESAPid" 		 	type="numeric" 	required="yes">
        
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
		<cfif NOT isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
		<cfif NOT isdefined('Arguments.BMUsucodigo')>
        	<cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
		<cfif NOT isdefined('Arguments.TESAPusuarioPr')>
        	<cfset Arguments.TESAPusuarioPr = session.Usucodigo>
        </cfif>
		
		<cfset rsAcuerdosD = GetAcuerdoPagoD(Arguments.Conexion,Arguments.TESAPid)>
		<cftransaction>
			<cfset fnCambiaEstado(Arguments.Conexion,Arguments.TESAPid,0,-1,-1)>
			<cfset fnBajaMasivaAcuerdoPagoH(Arguments.Conexion,Arguments.TESAPid)>
		</cftransaction>
    </cffunction>
	 <!---►►►►►►Anula el Acuerdo de Pago►►►►►►--->
     <cffunction name="fnAnulado" access="public">
		<cfargument name="Conexion" 	 	type="string"  	required="no">
		<cfargument name="Ecodigo" 	 	 	type="numeric" 	required="no">
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="no">
		<cfargument name="TESAPusuarioAn" 	type="numeric" 	required="no">
        <cfargument name="TESAPid" 		 	type="numeric" 	required="yes">
        
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
		<cfif NOT isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
		<cfif NOT isdefined('Arguments.BMUsucodigo')>
        	<cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
		<cfif NOT isdefined('Arguments.TESAPusuarioAn')>
        	<cfset Arguments.TESAPusuarioAn = session.Usucodigo>
        </cfif>
		<cftransaction>
			<cfset fnCambiaEstado(Arguments.Conexion,Arguments.TESAPid,3,Arguments.TESAPusuarioAn,3)>
			<cfset BajaDAcuerdoPago(Arguments.Conexion,Arguments.TESAPid)>
		</cftransaction>
    </cffunction>
	 <!---►►►►►►A prueba el Acuerdo de Pago►►►►►►--->
     <cffunction name="fnAprobado" access="public">
		<cfargument name="Conexion" 	 	type="string"  	required="no">
		<cfargument name="TESAPusuarioAp" 	type="numeric" 	required="no">
        <cfargument name="TESAPid" 		 	type="numeric" 	required="yes">
        
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
		<cfif NOT isdefined('Arguments.TESAPusuarioAp')>
        	<cfset Arguments.TESAPusuarioAp = session.Usucodigo>
        </cfif>
		
		<cfset fnCambiaEstado(Arguments.Conexion,Arguments.TESAPid,2,Arguments.TESAPusuarioAp,2)>
    </cffunction>
	<!---►►►►►►Obtiene ultimos Autorizadores del Acuerdo de Pago►►►►►►--->
	<cffunction name="fnGetAutorizadores"  	access="public">
		<cfargument name="Ecodigo" 	    		type="numeric"  required="no">
		<cfargument name="Conexion" 	    	type="string"  	required="no">
        
		<cfif NOT isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
		<cfif NOT isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
		<cfquery  name="rsAutorizador" datasource="#Arguments.Conexion#">
			select TESAPautorizador1, TESAPautorizador2
			from TESacuerdoPago
			where TESAPid = (select max(TESAPid) from TESacuerdoPago where Ecodigo = #Arguments.Ecodigo#)
		</cfquery>
		
		<cfreturn rsAutorizador>
    </cffunction>
</cfcomponent>