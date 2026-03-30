<cfinclude template="/sif/Application.cfm">
<cfset Session.DSN="sdc">
<cfsetting enablecfoutputonly="no">

<cfparam name="session.TipoRolAdmin"  default="1">
<cfparam name="session.TipoRolAdmin2"  default="2">
<cfif session.TipoRolAdmin NEQ session.TipoRolAdmin2>
	<cfquery name="rsTipoRolAdmin" datasource="#session.DSN#">
		set nocount on
		declare @tipo varchar(255)
		if exists (select 1 from UsuarioPermiso
					where rol = 'sys.admin'
					  and Usucodigo = #session.Usucodigo#
					  and Ulocalizacion = '#session.Ulocalizacion#')
			select @tipo = 'sys.admin'
		else if exists (select 1 from UsuarioPermiso
					where rol = 'sys.agente'
					  and Usucodigo = #session.Usucodigo#
					  and Ulocalizacion = '#session.Ulocalizacion#')
			select @tipo = 'sys.agente'
		else if exists (select 1 from UsuarioPermiso
					where rol = 'sys.adminCuenta'
					  and Usucodigo = #session.Usucodigo#
					  and Ulocalizacion = '#session.Ulocalizacion#')
			select @tipo = 'sys.adminCuenta'
		else 
			select @tipo = ''
		select @tipo as tipo
		set nocount off
	</cfquery>
	<cfset session.TipoRolAdmin = rsTipoRolAdmin.tipo>
	<cfset session.TipoRolAdmin2 = rsTipoRolAdmin.tipo>
</cfif>
