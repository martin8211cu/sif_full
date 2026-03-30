<cfif isDefined("form.setFiltroPuesto") and len(trim(form.setFiltroPuesto))>
	<cfset session.setFiltroPuesto =form.setFiltroPuesto>
	<cfabort>
</cfif>

<cfif isDefined("form.modo") and trim(form.modo) eq 'update'>
	<cftransaction>
		<cfif isdefined("form.RHOPid") and len(trim(FORM.RHOPid))> 	
			<cfquery datasource="#session.dsn#" name="rsValidar">
				select count(1) as valor
				from RHOPuestoEquival
					where RHPcodigo = '#Form.RHPcodigo#'
					and  RHOPid= #form.RHOPid#
			</cfquery>
			<cfif rsValidar.valor>
				<cfquery datasource="#session.dsn#">
					delete
					from RHOPuestoEquival
						where RHPcodigo = '#Form.RHPcodigo#'
						and  RHOPid= #form.RHOPid#
				</cfquery>
			<cfelse>	
				<cfquery datasource="#session.dsn#">
					insert into RHOPuestoEquival(RHOPid,RHPcodigo,BMUsucodigo,BMfechaalta)
					values (#form.RHOPid#,'#Form.RHPcodigo#',#session.Usucodigo#,<cf_dbfunction name="now">)
				</cfquery>
			</cfif>
			
		</cfif>	
	</cftransaction>
	<cfabort>
</cfif>
