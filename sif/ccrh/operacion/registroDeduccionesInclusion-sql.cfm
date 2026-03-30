<cfif isdefined("Url.RHIDid") and not isdefined("Form.RHIDid")>
	<cfset Form.RHIDid = Url.RHIDid>
</cfif>

<cfif isdefined("Form.RHIDid")>
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<cfif modo NEQ 'ALTA'><!--- modo cambio --->

	<cfif isdefined("form.btnModificar")>
		<cfquery name="upIncDeduc" datasource="#session.DSN#">
			update RHInclusionDeducciones set
				Ecodigo =  #session.Ecodigo# ,
				TDid =	          <cfqueryparam  cfsqltype="cf_sql_numeric" 	value="#form.TDid#">,
				DEid = 	          <cfqueryparam  cfsqltype="cf_sql_numeric" 	value="#form.DEid#">,
				RHIDdesc = 	      <cfqueryparam  cfsqltype="cf_sql_char"     	value="#form.RHIDdesc#">,
				RHIDmonto =	      <cfqueryparam  cfsqltype="cf_sql_money" 		value="#form.RHIDmonto#">,
				RHIDfechadoc =	  <cfqueryparam  cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(form.RHIDfechadoc)#">,
				RHIDfechadesde =  <cfqueryparam  cfsqltype="cf_sql_timestamp" 	value="#LSDateFormat(form.RHIDfechadesde)#">,
				RHIDreferencia =  <cfqueryparam  cfsqltype="cf_sql_char" 		value="#trim(form.RHIDreferencia)#">,
				SNcodigo =		  <cfqueryparam  cfsqltype="cf_sql_integer" 	value="#form.SNcodigo#">,
				RHIDtasa =		  <cfqueryparam  cfsqltype="cf_sql_float" 		value="#form.RHIDtasa#">,
				RHIDtasamora =	  <cfqueryparam  cfsqltype="cf_sql_float" 		value="#form.RHIDtasamora#">,
				RHIDcuotas =	  <cfqueryparam  cfsqltype="cf_sql_integer" 	value="#form.RHIDcuotas#">,
				RHIDObs =		  <cfqueryparam  cfsqltype="cf_sql_char" 		value="#form.RHIDObs#">,
				BMUsucodigo =	  <cfqueryparam  cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">
			where RHIDid =		<cfqueryparam  	 cfsqltype="cf_sql_numeric" 	value="#form.RHIDid#">
		</cfquery>
		
		<cflocation url="registroDeducciones.cfm?modifica=1&RHIDid=#form.RHIDid# ">
	
	</cfif>
	
	<cfif isdefined("form.btnEliminar")>
		<cfquery name="delIncDeduc" datasource="#session.DSN#">
			delete from RHInclusionDeducciones 
			where RHIDid =#form.RHIDid#
		</cfquery>
		<cflocation url="InclusionDeducciones.cfm">
	</cfif>
	
	<cfif isdefined("form.btnNuevo")>
		<cflocation url="registroDeducciones.cfm">
	</cfif>	
	
	<cfif isdefined("form.btnAplicar")>
		<cftransaction>
		<cflocation url="registroDeduccionesAplicar-sql.cfm?RHIDid=#form.RHIDid#">
		</cftransaction>
	</cfif>
	
<cfelse><!--- modo alta --->
	<cftransaction>
		<cfquery name="inIncDeduc" datasource="#session.DSN#">
				Insert into RHInclusionDeducciones(
					Ecodigo,TDid,DEid,RHIDdesc,RHIDmonto,RHIDfechadoc,RHIDfechadesde,RHIDreferencia,SNcodigo,RHIDtasa,RHIDtasamora,RHIDcuotas,RHIDObs,BMUsucodigo,BMfechaalta)
				values(
					 #session.Ecodigo# ,
					<cfqueryparam  cfsqltype="cf_sql_numeric" 	value="#form.TDid#">,
					<cfqueryparam  cfsqltype="cf_sql_numeric" 	value="#form.DEid#">,
					<cfqueryparam  cfsqltype="cf_sql_char"    	value="#form.RHIDdesc#">,
					<cfqueryparam  cfsqltype="cf_sql_money"    	value="#form.RHIDmonto#">,
					
					<cfqueryparam  cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHIDfechadoc)#">,
					<cfqueryparam  cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHIDfechadesde)#">, 
					
					<cfqueryparam  cfsqltype="cf_sql_char" 		value="#trim(form.RHIDreferencia)#">,
					<cfqueryparam  cfsqltype="cf_sql_integer" 	value="#form.SNcodigo#">,
					<cfqueryparam  cfsqltype="cf_sql_float" 	value="#form.RHIDtasa#">,
					<cfqueryparam  cfsqltype="cf_sql_float" 	value="#form.RHIDtasamora#">,
					<cfqueryparam  cfsqltype="cf_sql_integer" 	value="#form.RHIDcuotas#">,
					<cfqueryparam  cfsqltype="cf_sql_char" 		value="#form.RHIDObs#">,
					<cfqueryparam  cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
					<cfqueryparam  cfsqltype="cf_sql_timestamp" value="#Now()#">)		
		</cfquery>
	</cftransaction>
	<cflocation url="registroDeducciones.cfm">
</cfif>