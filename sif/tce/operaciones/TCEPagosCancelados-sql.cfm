<!---<cf_dump var="#Form.chk#">--->
<cfif isdefined("Form.chk")>
	<cfloop index="LvarLin" list="#Form.chk#" delimiters=",">
		<cfset LvarDet 		= #ListToArray(LvarLin, "|")#>
		<cfset LvarCBPTCid			 	= LvarDet[1]>
		<cfset LvarCBPTCdescripcion 	= LvarDet[2]>
		<cfset LvarCBPTCfecha			= LvarDet[3]>
		<cfset LvarCBid 				= LvarDet[4]>
		<cfset LvarTESid 				= LvarDet[5]>
		<cfset LvarTESMPcodigo 			= LvarDet[6]>
		<cfset LvarTESTPid 				= LvarDet[7]>
		<cfset LvarTESBid 				= LvarDet[8]>
		<cfset LvarCBPTCtipocambio 		= LvarDet[9]>
			
		<cfquery name="rsInsertarDuplica" datasource="#session.dsn#">
			
			INSERT CBEPagoTCE 
			
						(	CBPTCdescripcion,
							CBPTCfecha, 
							CBid, 
							TESid, 
							TESMPcodigo, 
							TESTPid, 
							TESBid, 
							CBPTCtipocambio, 
							CBPTCestatus,
							CBPTCidOri)
		
			VALUES  	(	<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCBPTCdescripcion#">, 
							<cfqueryparam cfsqltype="cf_sql_date"	 value="#LvarCBPTCfecha#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCBid#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESid#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#LvarTESMPcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESTPid#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESBid#">, 
							<cfqueryparam cfsqltype="cf_sql_float" value="#LvarCBPTCtipocambio#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="10">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCBPTCid#">
						)
		</cfquery>	
		<cfquery name="rsDetalle" datasource="#session.dsn#">
		
			INSERT INTO CBDPagoTCEdetalle ( CBPTCid, 
											CBid, 
											CBDPTCmonto, 
											CBDPTCtipocambio, 
											ECid
											)
			SELECT 	(SELECT MAX(CBPTCid) FROM CBEPagoTCE) as CBTCidDuplica, 
					CBid, 
					CBDPTCmonto, 
					CBDPTCtipocambio, 
					ECid
					
			FROM CBDPagoTCEdetalle
			
			WHERE CBPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCBPTCid#">
				
	</cfquery>
	</cfloop>
</cfif>
<cflocation url="TCEPagosCancelados.cfm">							