<cf_CPSegUsu_setCFid>
<cfparam name="LvarLiquidacion" default="false">
<cfquery datasource="#session.dsn#" name="rsOficinas">
	<cfif LvarLiquidacion>
		select o.Ocodigo, o.Oficodigo, o.Odescripcion 
		  from Oficinas o
		 where o.Ecodigo = #Session.Ecodigo#
		   and o.Ocodigo = #form.Ocodigo#
		 order by 2
	<cfelseif form.CFid NEQ -100>
		select o.Ocodigo, o.Oficodigo, o.Odescripcion 
		  from Oficinas o
			inner join CFuncional f
				 on f.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
				and o.Ocodigo = f.Ocodigo
		 where o.Ecodigo = #Session.Ecodigo#
		 order by 2
	<cfelse>
		select o.Ocodigo, o.Oficodigo, o.Odescripcion 
		  from Oficinas o
			inner join CFuncional f
				inner join CPSeguridadUsuario cpu
					inner join CPSeguridadMascarasCtasP cpm
						 on cpm.Ecodigo = cpu.Ecodigo
						and cpm.CFid 	= cpu.CFid
						and coalesce(cpm.Usucodigo,cpu.Usucodigo) = cpu.Usucodigo
						and cpm.CPSMconsultar = 1 and cpu.CPSUconsultar = 1
                        and <cf_dbfunction name="like" args="'#rsCuenta.Cuenta#', cpm.CPSMascaraP">
				    on cpu.Ecodigo		= #session.Ecodigo#
				   and cpu.CFid			= f.CFid
				   and cpu.Usucodigo	= #session.Usucodigo#
				 on o.Ocodigo = f.Ocodigo
		 where o.Ecodigo = #Session.Ecodigo#
		<cfif isdefined("form.CPcuenta") AND form.CPcuenta NEQ "">
		   and	(
		   		select count(1)
				  from CPresupuestoControl
				 where CPPid = #session.CPPid#
				   and Ocodigo = o.Ocodigo
				   and CPcuenta = #form.CPcuenta#
				) > 0
		</cfif>
		UNION
		select o.Ocodigo, o.Oficodigo, o.Odescripcion 
		  from Oficinas o
			inner join CPSeguridadMascarasCtasP cpm
				 on cpm.Ecodigo 	= #session.Ecodigo#
			    and cpm.Usucodigo	= #session.Usucodigo#
			    and cpm.CFid		IS NULL
			    and cpm.CPSMconsultar = 1
                and <cf_dbfunction name="like" args="'#rsCuenta.Cuenta#', cpm.CPSMascaraP">
		 where o.Ecodigo = #Session.Ecodigo#
		<cfif isdefined("form.CPcuenta") AND form.CPcuenta NEQ "">
		   and	(
		   		select count(1)
				  from CPresupuestoControl
				 where CPPid = #session.CPPid#
				   and Ocodigo = o.Ocodigo
				   and CPcuenta = #form.CPcuenta#
				) > 0
		</cfif>
		 order by 2
	</cfif>
</cfquery>

<cfif isdefined('form.Ocodigo') and Len(Trim(form.Ocodigo))>
	<cfset session.Ocodigo = form.Ocodigo>
<cfelseif isdefined("Session.Ocodigo") and ListContainsNoCase(ValueList(rsOficinas.Ocodigo, ','), Session.Ocodigo, ',') EQ 0>
	<cfset session.Ocodigo = rsOficinas.Ocodigo>
<cfelse>
	<cfparam name="session.Ocodigo" default="#rsOficinas.Ocodigo#">
	<cfparam name="form.Ocodigo" default="#session.Ocodigo#">
</cfif>
<cfif session.Ocodigo EQ "">
	<cfset form.Ocodigo		= -1>
	<cfset session.Ocodigo	= -1>
</cfif>

