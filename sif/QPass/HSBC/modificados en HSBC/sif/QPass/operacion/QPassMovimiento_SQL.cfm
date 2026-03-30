<cfloop collection="#form#" item="i">
	<cfif FindNoCase("QPCid_", i) NEQ 0>
		<cfset LvarValor = #evaluate('form.#i#')#>
		<cfset LvarQPCid ="#mid(i,7,len(trim(i)))#">

		<cfquery name="rsCausa" datasource="#session.dsn#">
			select
				a.QPCid, 
				a.Mcodigo,
				a.QPCmonto,
				a.QPCcodigo, 
				a.QPCdescripcion,
				a.QPCMontoVariable 
			from QPCausa a
			where QPCid = #LvarQPCid#
		</cfquery>
		<cfquery name="rsMonedalocal" datasource="#session.dsn#">
			select Mcodigo 
			from Empresas 
			where Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset LvarTC =1>
		<cfif rsCausa.Mcodigo NEQ rsMonedalocal.Mcodigo>
		
			<cfquery name="rsmoneda" datasource="#session.dsn#">
				select 
					tc.Mcodigo, 
					tc.TCventa
				from Htipocambio tc
				where tc.Ecodigo = #Session.Ecodigo#
				and tc.Mcodigo = #rsCausa.Mcodigo#
				and tc.Hfecha <= #now()#
				and tc.Hfechah > #now()#
			</cfquery>
			<cfset LvarTC = rsmoneda.TCventa>
		</cfif>
	
		<cfquery name="insertMovimiento" datasource="#session.dsn#">
			insert into QPMovCuenta 
			(
				QPCid,     
				QPctaSaldosid,
				QPcteid,         
				QPMovid,       
				QPTidTag,     
				QPMCFInclusion, 
				QPMCFProcesa,  
				QPMCFAfectacion,
				Mcodigo,         
				QPMCMonto,  
				QPMCMontoLoc, 
				BMFecha,
				QPTPAN  
			 )
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarQPCid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#QPctaSaldosid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"   value="#form.QPcteid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPMovid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPTidTag#">,
				#now()#,
				null,
				null,
				#rsCausa.Mcodigo#,
				<cfif rsCausa.QPCMontoVariable eq 0>
					<cfqueryparam cfsqltype="cf_sql_money" value="#rsCausa.QPCmonto#">,
				<cfelse>								
					#LvarValor#,
				</cfif>
				<cfif rsCausa.QPCMontoVariable eq 0>
					<cfqueryparam cfsqltype="cf_sql_money" value="#rsCausa.QPCmonto#"> * #LvarTC#,
				<cfelse>								
					#LvarValor# * #LvarTC#,
				</cfif>
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPTPAN#">
			)
			<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
		</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="insertMovimiento" verificar_transaccion="false" returnvariable="QPMCid">
	</cfif>
</cfloop>
<cflocation url="QPassMovimiento.cfm" addtoken="no">