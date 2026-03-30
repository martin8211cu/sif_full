<cfreturn>


<cfparam name="session.msid" default="0" type="numeric">
<cfparam name="monitoreo_modulo" default="/">
<cfset args = "-">
<cfset ip = GetPageContext().getRequest().getRemoteAddr()>
<cfif session.msid EQ 0 AND IsDefined("url.msid") and IsNumeric(url.msid)>
	<cfset session.msid = url.msid>
</cfif>
<cfif session.msid NEQ 0>
	<cfquery datasource="sdc" name="mon_upd_1">
		update MonHistoria
		set hasta = getdate()
		from MonProcesos
		where MonHistoria.sessionid = #session.msid#
		  and MonProcesos.historiaid = MonHistoria.historiaid
		  and MonHistoria.modulo = '#monitoreo_modulo#'
		select @@rowcount as rc
	</cfquery>
	<cfif mon_upd_1.rc EQ 0>
		<cfquery datasource="sdc">
			update MonHistoria
			set hasta = getdate()
			from MonProcesos
			where MonHistoria.sessionid = #session.msid#
			  and MonProcesos.historiaid = MonHistoria.historiaid
			insert MonHistoria (
				sessionid, desde, hasta, Usucodigo, Ulocalizacion,
				ip, login, modulo, args)
			select
				sessionid, getdate(), getdate(), Usucodigo, Ulocalizacion,
				ip, login, '#monitoreo_modulo#', args
			from MonProcesos
			where sessionid = #session.msid#
			update MonProcesos
			set historiaid = @@identity
			where sessionid = #session.msid#
		</cfquery>
	</cfif>
</cfif>
 
 
<cfquery datasource="sdc" name="mon_upd_3">
	update MonProcesos
	set Usucodigo = #Session.Edu.Usucodigo#,
	Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ulocalizacion#">,
	ip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ip#">,
	login = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
	desde = case when modulo = '#monitoreo_modulo#'
			then desde else getdate() end,
	modulo = '#monitoreo_modulo#',
	args = <cfqueryparam cfsqltype="cf_sql_varchar" value="#args#">
	where sessionid = #session.msid#
	
	select @@rowcount as rc
</cfquery>
<cfif mon_upd_3.rc EQ 0>
	<cfquery datasource="sdc" name="mon_upd_4">
	  declare @sessionid numeric(18)
	  insert MonProcesos (
		Usucodigo, Ulocalizacion, ip, login,
		desde, modulo, args)
	  values (
		#Session.Edu.Usucodigo#, <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ulocalizacion#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ip#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
		getdate(),
		'#monitoreo_modulo#', 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#args#">)
	  select @sessionid = @@identity
	  select convert(varchar,@sessionid) as sessionid
	  insert MonHistoria (
		sessionid, desde, hasta, Usucodigo, Ulocalizacion,
		ip, login, modulo, args)
	  select
		sessionid, desde, getdate(), Usucodigo, Ulocalizacion,
		ip, login, modulo, args
	  from MonProcesos
	  where sessionid = @sessionid
	  update MonProcesos
	  set historiaid = @@identity
	  where sessionid = @sessionid
	</cfquery>
	<cfif IsDefined("mon_upd_4")>
		<cfset session.msid = mon_upd_4.sessionid>
	</cfif>
</cfif>
