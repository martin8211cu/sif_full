<!---<cfdump var="#url#" >
<cf_dump var="#form#" >--->
<cfparam name="form.GEPVaplicaTodos" default="0">
<cfif isdefined('form.ALTA')>
	<cfquery datasource="#session.dsn#">
		insert into TESreintegroCB (
			CBid,          
			Ecodigo,    
			TESRCBmontoMax, 
			TESRCBmontoMin, 
			BMUsucodigo   
		)
		values(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#form.TESRCBmontoMax#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#form.TESRCBmontoMin#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		)
	</cfquery>
	<cflocation url="catalogoCuentaCorrienteReintegro.cfm?modo=CAMBIO&CBid=#form.CBid#">
	
<cfelseif isdefined('form.CAMBIO')>
	
	<cfquery datasource="#session.dsn#">
		update 		TESreintegroCB
		set 		 CBid=			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">,
					 Ecodigo=		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					 TESRCBmontoMax=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRCBmontoMax#">,
					 TESRCBmontoMin=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRCBmontoMin#">,
					 BMUsucodigo=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		where CBid=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
	</cfquery>
	<cflocation url="catalogoCuentaCorrienteReintegro.cfm?modo=CAMBIO&CBid=#form.CBid#">
	
<cfelseif isdefined('form.BAJA')>
	<cfquery datasource="#session.dsn#">
			delete from TESreintegroCB
			where CBid=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
		</cfquery>	
	<cflocation url="catalogoCuentaCorrienteReintegro.cfm?modo=ALTA">
<cfelse>
	<cflocation url="catalogoCuentaCorrienteReintegro.cfm?modo=ALTA">
</cfif>
