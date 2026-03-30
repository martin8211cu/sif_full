<cfsilent>
<cfif ThisTag.ExecutionMode NEQ "START">
	<cfreturn>
</cfif>
<cfquery name="rsSQL" datasource="#session.dsn#">
	select count(1) as cant
	  from TESRPTcuentas
	 where Ecodigo	= #session.Ecodigo#
</cfquery>
<cfif rsSQL.cant EQ 0>
	<cfexit>
</cfif>

<cfparam name="attributes.name"			default="TESRPTCid">
<cfparam name="attributes.EMid"			default="">
<cfparam name="attributes.IDcontable"	default="">
<cfif attributes.EMid EQ "" AND attributes.IDcontable EQ "">
	<cfthrow message="Attribute EMid o IDcontable es obligatorio">
<cfelseif attributes.EMid NEQ "">
	<cfparam name="attributes.EMid"	type="numeric">
	<cfset LvarDocIdName 	= "EMid">
	<cfset LvarDocIdValue	= attributes.EMid>
<cfelse>
	<cfparam name="attributes.IDcontable"	type="numeric">
	<cfset LvarDocIdName 	= "IDcontable">
	<cfset LvarDocIdValue	= attributes.IDcontable>
</cfif>

<cfparam name="attributes.Dlinea"		type="numeric">

<cfif form["#Attributes.name#"] EQ "">
	<cfset session.cf_conceptoPago.TESRPTCid	= "">
	<cfset session.cf_conceptoPago.SNid			= "">
	<cfset session.cf_conceptoPago.TESBid		= "">
	<cfset session.cf_conceptoPago.CDCcodigo 	= "">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		delete from TESRPTcontables
		 where #LvarDocIdName#	= #LvarDocIdValue#
		   and Dlinea			= #Attributes.Dlinea#
	</cfquery>
<cfelse>
	<cfif form["#Attributes.name#"] EQ -1>
		<cfthrow message="El campo Concepto de Pagos a Terceros es requerido">
	</cfif>
	
	<cfparam name="form.#Attributes.name#" type="numeric">
	<cfif form["Bid#Attributes.name#"] EQ "">
		<cfthrow message="El campo Beneficiario es requerido">
	</cfif>
	<cfparam name="form.Bid#Attributes.name#" type="numeric">

	<cfset session.cf_conceptoPago.TESRPTCid		= form["#Attributes.name#"]>
	<cfif form["Btipo#Attributes.name#"] EQ "S">
		<cfset session.cf_conceptoPago.SNid			= form["Bid#Attributes.name#"]>
		<cfset session.cf_conceptoPago.TESBid		= "">
		<cfset session.cf_conceptoPago.CDCcodigo 	= "">
	<cfelseif form["Btipo#Attributes.name#"] EQ "T">
		<cfset session.cf_conceptoPago.SNid			= "">
		<cfset session.cf_conceptoPago.TESBid		= form["Bid#Attributes.name#"]>
		<cfset session.cf_conceptoPago.CDCcodigo 	= "">
	<cfelseif form["Btipo#Attributes.name#"] EQ "P">
		<cfset session.cf_conceptoPago.SNid			= "">
		<cfset session.cf_conceptoPago.TESBid		= "">
		<cfset session.cf_conceptoPago.CDCcodigo 	= form["Bid#Attributes.name#"]>
	</cfif>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select TESRPTDid
		  from TESRPTcontables
		 where #LvarDocIdName#	= #LvarDocIdValue#
		   and Dlinea			= #Attributes.Dlinea#
	</cfquery>
	<cfif rsSQL.TESRPTDid EQ "">
		<cfquery datasource="#session.dsn#">
			insert TESRPTcontables (
				#LvarDocIdName#, Dlinea, 
				TESRPTCid, SNid, TESBid, CDCcodigo, BMUsucodigo
			)
			values (
				#LvarDocIdValue#, #Attributes.Dlinea#, 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.cf_conceptoPago.TESRPTCid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.cf_conceptoPago.SNid#"		voidNull>,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.cf_conceptoPago.TESBid#"		voidNull>,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.cf_conceptoPago.CDCcodigo#"	voidNull>,
				#session.Usucodigo#
			)
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			update TESRPTcontables
			   set TESRPTCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.cf_conceptoPago.TESRPTCid#">,
				   SNid		 = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.cf_conceptoPago.SNid#"		voidNull>,
				   TESBid	 = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.cf_conceptoPago.TESBid#"		voidNull>,
				   CDCcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.cf_conceptoPago.CDCcodigo#"	voidNull>,
				   BMUsucodigo = #session.Usucodigo#
			 where TESRPTDid = #rsSQL.TESRPTDid#
		</cfquery>
	</cfif>
</cfif>
</cfsilent>