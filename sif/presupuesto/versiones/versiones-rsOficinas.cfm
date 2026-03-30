<cf_CPSegUsu_setCFid>
<cfif not isnumeric(form.CFid)>
	<cfthrow message="El valor del form cfid no es numérico, proceso cancelado">
</cfif>
<cfquery datasource="#session.dsn#" name="rsOficinas">
	<cfif form.CFid NEQ -100>
		select o.Ocodigo, o.Odescripcion 
		  from Oficinas o
			inner join CFuncional f
				 on f.CFid = #form.CFid#
				and o.Ocodigo = f.Ocodigo
		 where o.Ecodigo = #Session.Ecodigo#
		 order by o.Ocodigo
	<cfelse>
		select o.Ocodigo, o.Odescripcion 
		  from Oficinas o
			inner join CFuncional f
				inner join CPSeguridadUsuario cpu
					inner join CPSeguridadMascarasCtasP cpm
						 on cpm.Ecodigo = cpu.Ecodigo
						and cpm.CFid 	= cpu.CFid
						and coalesce(cpm.Usucodigo,cpu.Usucodigo) = cpu.Usucodigo
						and cpm.CPSMformulacion = 1 and cpu.CPSUformulacion = 1
                        and <cf_dbfunction name="like" args="'#rsCuenta.Cuenta#', cpm.CPSMascaraP">
				    on cpu.Ecodigo		= #session.Ecodigo#
				   and cpu.CFid			= f.CFid
				   and cpu.Usucodigo	= #session.Usucodigo#
				 on o.Ocodigo = f.Ocodigo
		 where o.Ecodigo = #Session.Ecodigo#
		UNION
		select o.Ocodigo, o.Odescripcion 
		  from Oficinas o
			inner join CPSeguridadMascarasCtasP cpm
				 on cpm.Ecodigo 	= #session.Ecodigo#
			    and cpm.Usucodigo	= #session.Usucodigo#
			    and cpm.CFid		IS NULL
			    and cpm.CPSMformulacion = 1
                and <cf_dbfunction name="like" args="'#rsCuenta.Cuenta#', cpm.CPSMascaraP">
		 where o.Ecodigo = #Session.Ecodigo#
		 order by o.Ocodigo
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

