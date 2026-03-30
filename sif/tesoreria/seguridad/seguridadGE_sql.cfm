<cfif isdefined("Form.Nuevo")>
	<cflocation url="seguridadGE.cfm?btnNuevo&Usucodigo=#form.Usucodigo#">	
<cfelseif isdefined("Form.Alta")>
	<cfparam name="form.TESUGEsolicitante"	default="0">
	<cfparam name="form.TESUGEaprobador"	default="0">
	<cfparam name="form.TESUGEmontoMax"		default="0">
	<cfif trim(form.TESUGEmontoMax) EQ "">
		<cfset form.TESUGEmontoMax = "0">
	<cfelse>
		<cfset form.TESUGEmontoMax = replace(TESUGEmontoMax,",","","ALL")>
	</cfif>
	<cfparam name="form.TESUGEcambiarTES"	default="0">

	<cftry>
		<cfquery datasource="#Session.DSN#">
			insert into TESusuarioGE
				(CFid, Usucodigo, Ecodigo, CFcodigo, TESUGEsolicitante, TESUGEaprobador, TESUGEmontoMax, TESUGEcambiarTES, BMUsucodigo)
			values (
		            <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CFid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.CFcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_bit"		value="#form.TESUGEsolicitante#">,					
					<cfqueryparam cfsqltype="cf_sql_bit" 		value="#form.TESUGEaprobador#">, 		
					<cfqueryparam cfsqltype="cf_sql_money"	    value="#numberformat(form.TESUGEmontoMax,'9.99')#">, 
					<cfqueryparam cfsqltype="cf_sql_bit"		value="#form.TESUGEcambiarTES#">, 
					#session.Usucodigo#
				)
		</cfquery>
		<cfcatch type="any">
			<cf_errorCode        code = "001"
   								 msg  = "El Usuario: @errorDat_1@ asociado al centro funcional: @errorDat_2@ no puede ser ingresado nuevamente"
							     errorDat_1="#form.UsuNombre#"
							     errorDat_2="#form.CFDescripcion#">
		</cfcatch>
	</cftry>	
	<cflocation url="seguridadGE.cfm?btnNuevo&Usucodigo=#form.Usucodigo#">	
<cfelseif isdefined("Form.Baja")>
	<cfquery datasource="#Session.DSN#">
		delete from TESusuarioGE
		 where CFid			= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CFid#">
		   and Usucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Usucodigo#">
	</cfquery>
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
					table="TESusuarioGE"
					redirect="seguridadGE.cfm"
					timestamp="#form.ts_rversion#"				
					field1="CFid" 
					type1="numeric" 
					value1="#form.CFid#"
					field2="Usucodigo" 
					type2="numeric" 
					value2="#form.Usucodigo#"
					>
	
	<cfparam name="form.TESUGEsolicitante"	default="0">
	<cfparam name="form.TESUGEaprobador"	default="0">
	<cfparam name="form.TESUGEmontoMax"		default="0">
	<cfif trim(form.TESUGEmontoMax) EQ "">
		<cfset form.TESUGEmontoMax = "0">
	<cfelse>
		<cfset form.TESUGEmontoMax = replace(TESUGEmontoMax,",","","ALL")>
	</cfif>
   
	<cfparam name="form.TESUGEcambiarTES"	default="0">
	<cfquery name="update" datasource="#Session.DSN#">
		update TESusuarioGE
		   set Ecodigo				= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">
			 , CFcodigo				= <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.CFcodigo#">
			 , TESUGEsolicitante	= <cfqueryparam cfsqltype="cf_sql_bit"		value="#form.TESUGEsolicitante#">
			 , TESUGEaprobador		= <cfqueryparam cfsqltype="cf_sql_bit" 		value="#form.TESUGEaprobador#">
			 , TESUGEmontoMax		= <cfqueryparam cfsqltype="cf_sql_money"	value="#numberformat(form.TESUGEmontoMax,'9.99')#">
			 , TESUGEcambiarTES		= <cfqueryparam cfsqltype="cf_sql_bit"		value="#form.TESUGEcambiarTES#">
			 , BMUsucodigo			= #session.Usucodigo#
		 where CFid			= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CFid#">
		   and Usucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Usucodigo#">
	</cfquery>
</cfif><!---Form.Nuevo--->

<cflocation url="seguridadGE.cfm?btnNuevo&Usucodigo=#form.Usucodigo#">	
