<!---
	Elaboró: Eduardo Gonzalez
	Comentarios: Se crear archivo para mostrar datos de la cta de origen,
				 diferentes criterios.

 --->
<cfsetting enablecfoutputonly="yes">
<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
<cfif isdefined("url.modo") AND modo EQ "solPagoCxP">
	<cfset arrURL = listToArray (#url.CBidPago#, ",",false,true)>

	<cfif ArrayLen(arrURL) EQ 4>
		<cfset CBidPago = arrURL[1]>
		<cf_cboTESMPcodigo name="TESMPcodigo" value="" CBid="CBidPago" CBidValue="#CBidPago#" onChange="GvarCambiado=true; sbTESMPcodigoChange(this);">
	<cfelse>
		<cfset session.tesoreria.CBidPago = -1>
		<cfset session.tesoreria.TESMPcodigo = "">
		<cf_cboTESMPcodigo name="TESMPcodigo" value="" CBid="CBidPago" CBidValue="" onChange="GvarCambiado=true; sbTESMPcodigoChange(this);">
	</cfif>
<cfelseif isdefined("url.modo") AND modo EQ "solPagoManualCTA">
	<cfquery datasource="#session.dsn#" name="rsGetInfoOrigenSN">
		SELECT SNCBidPago_Origen
		FROM SNegocios
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
	</cfquery>

	<cfif  rsGetInfoOrigenSN.recordcount gt 0>
		<cfset lVar_CBidPago = #rsGetInfoOrigenSN.SNCBidPago_Origen#>
	<cfelse>
		<cfset lVar_CBidPago = "">
	</cfif>

	<cfset session.tesoreria.CBidPago = -1>
	<cfset LvarCBidPago = "">

	<cf_cboTESCBid name="CBidPago" value="#lVar_CBidPago#" Ccompuesto="yes" Dcompuesto="yes" none="yes"
						cboTESMPcodigo="TESMPcodigo" onchange="return fnCambioCBidPago(this.form);GvarCambiado=true;" tabindex="1"
						CBid = "#LvarCBidPago#">

<cfelseif isdefined("url.modo") AND modo EQ "solPagoManualMP">
	<cfquery datasource="#session.dsn#" name="rsGetInfoOrigenSN_MP">
		SELECT SNMedPago_Origen
		FROM SNegocios
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
	</cfquery>


	<cfif  rsGetInfoOrigenSN_MP.recordcount gt 0>
		<cfset lVar_MedPago = #rsGetInfoOrigenSN_MP.SNMedPago_Origen#>
	<cfelse>
		<cfset lVar_MedPago = "">
	</cfif>

	<cfset session.tesoreria.TESMPcodigo = "">
	<cf_cboTESMPcodigo name="TESMPcodigo" value="" CBid="CBidPago" CBidValue="" onChange="GvarCambiado=true; sbTESMPcodigoChange(this);">
<cfelseif isdefined("url.modo") AND modo EQ "solPagoManualCTABen">
	<cfquery datasource="#session.dsn#" name="rsGetInfoOrigenBen">
		SELECT SNCBidPago_Origen
		FROM TESbeneficiario
		WHERE <!--- Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		AND ---> TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
	</cfquery>

	<cfif  rsGetInfoOrigenBen.recordcount gt 0>
		<cfset lVar_CBidPago = #rsGetInfoOrigenBen.SNCBidPago_Origen#>
	<cfelse>
		<cfset lVar_CBidPago = "">
	</cfif>

	<cfset session.tesoreria.CBidPago = -1>
	<cfset LvarCBidPago = "">

	<cf_cboTESCBid name="CBidPago" value="#lVar_CBidPago#" Ccompuesto="yes" Dcompuesto="yes" none="yes"
						cboTESMPcodigo="TESMPcodigo" onchange="return fnCambioCBidPago(this.form);GvarCambiado=true;" tabindex="1"
						CBid = "#LvarCBidPago#">

<cfelseif isdefined("url.modo") AND modo EQ "solPagoManualMPBen">
	<cfquery datasource="#session.dsn#" name="rsGetInfoOrigenBen_MP">
		SELECT SNMedPago_Origen
		FROM TESbeneficiario
		WHERE <!--- Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		AND ---> TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
	</cfquery>


	<cfif  rsGetInfoOrigenBen_MP.recordcount gt 0>
		<cfset lVar_MedPago = #rsGetInfoOrigenBen_MP.SNMedPago_Origen#>
	<cfelse>
		<cfset lVar_MedPago = "">
	</cfif>

	<cfset session.tesoreria.TESMPcodigo = "">
	<cf_cboTESMPcodigo name="TESMPcodigo" value="" CBid="CBidPago" CBidValue="" onChange="GvarCambiado=true; sbTESMPcodigoChange(this);">
</cfif>

