<cfcomponent>
	<cffunction name="TraeUsuarios" returntype="query" >
		<cfargument name="rol"        default="sif.usuario" type="string" required="false">
		<cfargument name="SDCEcodigo" default="-1"          type="string" required="true">
		<cfargument name="cliente_empresarial" default="#session.CEcodigo#"  type="string" required="true">
		<!--- solo usado para los conlis y hacer el filtro por nombre y apellidos del usuario --->
		<cfargument name="filtro"     type="string"         required="false">

		<cfif len(trim(arguments.SDCEcodigo)) eq 0>
			<cfset arguments.SDCEcodigo = -1 >
		</cfif>	

		<cfquery name="rsUsuarios" datasource="sdc">
			select convert(varchar, a.Usucodigo) as Usucodigo, a.Ulocalizacion, a.Usulogin, Pnombre, Papellido1, Papellido2, b.rol,	a.Pid, a.Pemail1, a.Poficina, a.Pfax 
			from Usuario a, UsuarioPermiso b, UsuarioEmpresa c, Rol d, Empresa e, EmpresaID f
			where f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SDCEcodigo#"> 
			  and b.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cliente_empresarial#"> 

			<cfif isdefined("arguments.rol") and len(trim(arguments.rol)) neq 0>
				and upper(d.rol) = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(arguments.rol)#">
			</cfif>

			<cfif isdefined("arguments.filtro") and len(trim(arguments.filtro)) gt 0>
				#preservesinglequotes(arguments.filtro)#
			</cfif>

			and a.activo=1 and b.activo=1 and c.activo=1 and d.activo=1 and e.activo=1 and f.activo=1
			and a.Usucodigo=b.Usucodigo
			and a.Ulocalizacion=b.Ulocalizacion
			and b.Usucodigo = c.Usucodigo
			and b.Ulocalizacion = c.Ulocalizacion
			and b.Ecodigo = c.Ecodigo
			and b.cliente_empresarial = c.cliente_empresarial
			and b.rol=d.rol
			and c.Ecodigo=e.Ecodigo
			and c.Ecodigo=f.Ecodigo
			and e.Ecodigo=f.Ecodigo
		</cfquery>
		<cfreturn rsUsuarios>
	</cffunction>

	<cffunction name="TraeEmpresas" returntype="query" >
		<cfargument name="sistema" default="sif" type="string" required="false">
		<cfargument name="Usucodigo" default="-1" type="string" required="true">
		<cfargument name="Ulocalizacion" default="00" type="string" required="true">

		<cfif len(trim(arguments.Usucodigo)) eq 0>
			<cfset arguments.Usucodigo = -1 >
		</cfif>	

		<cfquery name="rsEmpresas" datasource="sdc">
		select 
			convert(varchar,f.Ecodigo) as Ecodigosdc, 
			e.consecutivo as Ecodigo, 
			f.nombre_comercial as Edescripcion, 
			e.nombre_cache as cache, c.sistema,
			convert(varchar,g.cliente_empresarial) as CEcodigo
		from Usuario a, UsuarioPermiso b, Rol c, UsuarioEmpresa d, EmpresaID e, Empresa f, CuentaClienteEmpresarial g
		where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">
		  and a.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ulocalizacion#">
		  and a.Usucodigo = b.Usucodigo
		  and a.Ulocalizacion = b.Ulocalizacion
		  and b.rol = c.rol

		  <cfif isdefined("arguments.sistema") and len(trim(arguments.sistema)) neq 0>
		  	and upper(c.sistema) = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(arguments.sistema)#">
		  </cfif>	
		  
		  and b.Usucodigo = d.Usucodigo
		  and b.Ulocalizacion = d.Ulocalizacion
		  and b.Ecodigo = d.Ecodigo
		  and d.activo = 1
		  and d.Ecodigo = e.Ecodigo
		  and e.Ecodigo = f.Ecodigo
		  and f.cliente_empresarial = g.cliente_empresarial
		order by e.consecutivo
		</cfquery>
		<cfreturn rsEmpresas>
	</cffunction>
</cfcomponent>