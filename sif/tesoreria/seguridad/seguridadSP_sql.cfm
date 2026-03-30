<cfquery name="rsCFid" datasource="#session.DSN#">
    select CFid
    from CFuncional
    where Ecodigo = #session.Ecodigo#
    and CFcodigo = '#form.CFcodigo#'
</cfquery>
<cfif rsCFid.recordcount eq 0>
    <cfthrow message="No existe un centro funcional para el codigo #form.CFcodigo#, verifique de nuevo">
</cfif>
    
<cfif isdefined("Form.Nuevo")>
	<cflocation url="seguridadSP.cfm?btnNuevo&Usucodigo=#form.Usucodigo#">	
<cfelseif isdefined("Form.Alta")>
	<cfparam name="form.TESUSPsolicitante"	default="0">
	<cfparam name="form.TESUSPaprobador"	default="0">
	<cfparam name="form.TESUSPmontoMax"		default="0">
	<cfif trim(form.TESUSPmontoMax) EQ "">
		<cfset form.TESUSPmontoMax = "0">
	<cfelse>
		<cfset form.TESUSPmontoMax = replace(TESUSPmontoMax,",","","ALL")>
	</cfif>
	<cfparam name="form.TESUSPcambiarTES"	default="0">

	<cfquery datasource="#Session.DSN#">
		insert into TESusuarioSP
			(CFid, Usucodigo, Ecodigo, TESUSPsolicitante, TESUSPaprobador, TESUSPmontoMax, TESUSPcambiarTES, BMUsucodigo)
		values (
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsCFid.CFid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">,  

					<cfqueryparam cfsqltype="cf_sql_bit"		value="#form.TESUSPsolicitante#">, 
					<cfqueryparam cfsqltype="cf_sql_bit" 		value="#form.TESUSPaprobador#">, 
					<cfqueryparam cfsqltype="cf_sql_money"		value="#form.TESUSPmontoMax#">, 
					<cfqueryparam cfsqltype="cf_sql_bit"		value="#form.TESUSPcambiarTES#">, 
					#session.Usucodigo#
			)
	</cfquery>
	<cflocation url="seguridadSP.cfm?btnNuevo&Usucodigo=#form.Usucodigo#">	
<cfelseif isdefined("Form.Baja")>
	<cfquery datasource="#Session.DSN#">
		delete from TESusuarioSP
		 where CFid			= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsCFid.CFid#">
		   and Usucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Usucodigo#">
	</cfquery>
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
					table="TESusuarioSP"
					redirect="seguridadSP.cfm"
					timestamp="#form.ts_rversion#"				
					field1="CFid" 
					type1="numeric" 
					value1="#rsCFid.CFid#"
					field2="Usucodigo" 
					type2="numeric" 
					value2="#form.Usucodigo#"
					>
	
	<cfparam name="form.TESUSPsolicitante"	default="0">
	<cfparam name="form.TESUSPaprobador"	default="0">
	<cfparam name="form.TESUSPmontoMax"		default="0">
	<cfif trim(form.TESUSPmontoMax) EQ "">
		<cfset form.TESUSPmontoMax = "0">
	<cfelse>
		<cfset form.TESUSPmontoMax = replace(TESUSPmontoMax,",","","ALL")>
	</cfif>

	<cfparam name="form.TESUSPcambiarTES"	default="0">

	<cfquery name="update" datasource="#Session.DSN#">
		update TESusuarioSP
		   set Ecodigo				= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">
			 , TESUSPsolicitante	= <cfqueryparam cfsqltype="cf_sql_bit"		value="#form.TESUSPsolicitante#">
			 , TESUSPaprobador		= <cfqueryparam cfsqltype="cf_sql_bit" 		value="#form.TESUSPaprobador#">
			 , TESUSPmontoMax		= <cfqueryparam cfsqltype="cf_sql_money"	value="#form.TESUSPmontoMax#">
			 , TESUSPcambiarTES		= <cfqueryparam cfsqltype="cf_sql_bit"		value="#form.TESUSPcambiarTES#">
			 , BMUsucodigo			= #session.Usucodigo#
		 where CFid			= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsCFid.CFid#">
		   and Usucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Usucodigo#">
	</cfquery>
</cfif>

<cflocation url="seguridadSP.cfm?btnNuevo&Usucodigo=#form.Usucodigo#">	
