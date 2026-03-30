<cfif not isdefined('form.btnRegresar')>
	<cfif isdefined('form.btnCambio')>
		<cfif isdefined('form.id_agenda')>
			<cfset idsAgenda = ListToArray(form.id_agenda)>
		</cfif>
		<cfif isdefined('form.cupo1')>
			<cfset arrayCupo1 = ListToArray(form.cupo1)>
		</cfif>
		<cfif isdefined('form.cupo2')>
			<cfset arrayCupo2 = ListToArray(form.cupo2)>
		</cfif>
		<cfif isdefined('form.cupo3')>
			<cfset arrayCupo3 = ListToArray(form.cupo3)>
		</cfif>
		<cfif isdefined('form.cupo4')>
			<cfset arrayCupo4 = ListToArray(form.cupo4)>
		</cfif>
		<cfif isdefined('form.cupo5')>
			<cfset arrayCupo5 = ListToArray(form.cupo5)>
		</cfif>
		<cfif isdefined('form.cupo6')>
			<cfset arrayCupo6 = ListToArray(form.cupo6)>
		</cfif>
		<cfif isdefined('form.cupo7')>
			<cfset arrayCupo7 = ListToArray(form.cupo7)>
		</cfif>
		
		<cfif isdefined('idsAgenda')>
			<cfloop from="1" to="#ArrayLen(idsAgenda)#" index="idx">
				 <cfquery datasource="#session.tramites.dsn#">
					update TPAgenda set
						<cfif isdefined('form.cupo1')>
							cupo1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arrayCupo1[idx]#">
						<cfelse>
							cupo1 = 0
						</cfif>
						<cfif isdefined('form.cupo2')>
							, cupo2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arrayCupo2[idx]#">
						<cfelse>
							, cupo2 = 0					
						</cfif>
						<cfif isdefined('form.cupo3')>
							, cupo3 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arrayCupo3[idx]#">
						<cfelse>
							, cupo3 = 0					
						</cfif>
						<cfif isdefined('form.cupo4')>
							, cupo4 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arrayCupo4[idx]#">
						<cfelse>
							, cupo4 = 0					
						</cfif>
						<cfif isdefined('form.cupo5')>
							, cupo5 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arrayCupo5[idx]#">
						<cfelse>
							, cupo5 = 0					
						</cfif>
						<cfif isdefined('form.cupo6')>
							, cupo6 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arrayCupo6[idx]#">
						<cfelse>
							, cupo6 = 0					
						</cfif>
						<cfif isdefined('form.cupo7')>
							, cupo7 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arrayCupo7[idx]#">
						<cfelse>
							, cupo7 = 0					
						</cfif>	
					where id_agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idsAgenda[idx]#">
				</cfquery>
			</cfloop>
		</cfif>
	<cfelseif isdefined('form.btnBaja')>
		<cfif isdefined('form.id_agendaserv') and form.id_agendaserv NEQ ''>
			<cftransaction>		
				<cfquery datasource="#session.tramites.dsn#">
					Delete TPAgenda
					where id_recurso in (
									Select id_recurso 
									from TPRecurso
									where id_agendaserv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_agendaserv#">
								)
				</cfquery>
				
				<cfquery datasource="#session.tramites.dsn#">
					Delete TPRecurso
					where id_agendaserv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_agendaserv#">	
				</cfquery>			
				
				<cfquery datasource="#session.tramites.dsn#">
					Delete TPAgendaServicio
					where id_agendaserv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_agendaserv#">
				</cfquery>				
			</cftransaction>				
		</cfif>
	</cfif>
</cfif>

<cfoutput>
	<cfset p = "?id_inst=#form.id_inst#">
	
	<cfif isdefined('form.tabsuc')>
		<cfif isdefined('form.id_sucursal') and form.id_sucursal NEQ ''>
			<cfset p = p & "&id_sucursal=#form.id_sucursal#">
		</cfif>				
		<cfset p = p & "&tabsuc=#form.tabsuc#&tab=#form.tab#">
	</cfif>
	
	<cfif isdefined('form.tabserv')>
		<cfif isdefined('form.id_tiposerv') and form.id_tiposerv NEQ ''>
			<cfset p = p & "&id_tiposerv=#form.id_tiposerv#">
		</cfif>			
		<cfset p = p & "&tabserv=#form.tabserv#&tab=#form.tab#">
	</cfif>	

	<cfif (not isdefined('form.btnRegresar')) and (not isdefined('form.btnBaja'))>	
		<cfif isdefined('form.id_agendaserv') and form.id_agendaserv NEQ ''>
			<cfset p = p & "&id_agendaserv=#form.id_agendaserv#">
		</cfif>			
		<cfif not isdefined('form.tabserv')>
			<cfif isdefined('form.id_tiposerv') and form.id_tiposerv NEQ ''>
				<cfset p = p & "&id_tiposerv=#form.id_tiposerv#">
			</cfif>						
		</cfif>
		<cfif not isdefined('form.tabsuc')>
			<cfif isdefined('form.id_sucursal') and form.id_sucursal NEQ ''>
				<cfset p = p & "&id_sucursal=#form.id_sucursal#">
			</cfif>			
		</cfif>							
	</cfif>

	 <cflocation url="../instituciones.cfm#p#">
</cfoutput>