<cfcomponent>
	<!--- Funcion para obtener la empresa y cuenta empresarial --->
	<cffunction name="getEmpresa" access="private" returntype="query">
		<cfargument name="consecutivo" type="numeric" required="true">
		<cfargument name="sistema" type="string" required="true">

		<cfquery name="empresa" datasource="#Session.DSN#">
			select convert(varchar,e.cliente_empresarial) as cliente_empresarial, 
			       convert(varchar,e.Ecodigo) as Ecodigo
			from EmpresaID eid, Empresa e
			where eid.consecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#consecutivo#">
			  and eid.sistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sistema#">
			  and eid.Ecodigo = e.Ecodigo
		</cfquery>
		
		<cfreturn empresa>
	</cffunction>

	<!--- Funcion para eliminar un Usuario Empresarial --->
	<cffunction name="del_usuario" access="private" returntype="boolean">
		<cfargument name="cliente_empresarial" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfargument name="Ulocalizacion" type="string" required="true">
		
		<cftry>
			<cfquery name="delete_Usuario" datasource="#Session.DSN#">
				set nocount on
	
				delete from UsuarioPermiso
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Ulocalizacion#">
				  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cliente_empresarial#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#">
	
				delete from UsuarioEmpresa
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Ulocalizacion#">
				  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cliente_empresarial#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#">
												
				delete from UsuarioEmpresarial
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Ulocalizacion#">
				  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cliente_empresarial#">
	
				set nocount off
			</cfquery>

		<cfcatch type="any">
			<cfinclude template="/edu/errorPages/BDerror.cfm">
			<cftransaction action="rollback" />
			<cfabort>
		</cfcatch>				
		</cftry>
		
		<cfreturn true>
	</cffunction>

	<!--- Obtiene los datos de un Usuario según las referencias que se le pasen --->
	<cffunction name="get_usuario_by_ref" access="public" returntype="query">
		<cfargument name="corporativo" type="boolean" required="false" default="false">
		<cfargument name="consecutivo" type="numeric" required="true">
		<cfargument name="sistema" type="string" required="true">
		<cfargument name="referencias" type="string" required="true">
		<cfargument name="roles" type="string" required="true"><!--- Los roles no se deben repetir --->
		<cfargument name="addTables" type="string" required="false"><!--- Tablas Adicionales para la consulta --->
		<cfargument name="addCols" type="string" required="false"><!--- Columnas Adicionales para la consulta --->
		<cfargument name="addWhere" type="string" required="false"><!--- Filtros Adicionales para la consulta --->
		
		<cfset filtro = "">
		<cfset arrReferencias = ListToArray(Replace(referencias, ' ', '', 'all'), ",")>
		<cfset arrRoles = ListToArray(Replace(roles, ' ', '', 'all'), ",")>
		<cfloop index="i" from="1" to="#ArrayLen(arrReferencias)#">
			<cfset filtro = filtro & Iif(filtro NEQ "",DE(" or "),DE("")) & "(a.num_referencia = " & arrReferencias[i] & " and a.rol = '" & arrRoles[i] & "')">
		</cfloop>
	
		<cfquery name="usuario" datasource="#Session.DSN#">
			select distinct 
			       convert(varchar, e.Usucodigo) as Usucodigo,
			       e.Ulocalizacion,
				   f.Usulogin,
				   convert(varchar, e.cliente_empresarial) as cliente_empresarial,
				   convert(varchar, c.Ecodigo) as Ecodigo,
				   f.Usutemporal,
				   f.activo,
				   e.Pnombre,
				   e.Papellido1,
				   e.Papellido2,
				   e.Ppais,
				   e.TIcodigo,
				   e.Pid,
				   convert(varchar, e.Pnacimiento, 103) as Pnacimiento,
				   e.Psexo,
				   e.Pemail1,
				   e.Pemail2,
				   e.Pdireccion,
				   e.Pcasa,
				   e.Poficina,
				   e.Pcelular,
				   e.Pfax,
				   e.Ppagertel,
				   e.Ppagernum,
				   a.rol,
				   convert(varchar, a.num_referencia) as num_referencia,
				   a.int_referencia
				   <cfif isdefined("addCols") and Len(Trim(addCols)) NEQ 0>
				   , #PreserveSingleQuotes(addCols)#
				   </cfif>
			from UsuarioPermiso a, UsuarioEmpresa b, Empresa c, EmpresaID d, UsuarioEmpresarial e, Usuario f<cfif corporativo>, Empresa x, EmpresaID y</cfif>
				 <cfif isdefined("addTables") and Len(Trim(addTables)) NEQ 0>
				 , #addTables#
				 </cfif>
			where (#PreserveSingleQuotes(filtro)#)
			  and <cfif corporativo>y<cfelse>d</cfif>.sistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sistema#">
			  and <cfif corporativo>y<cfelse>d</cfif>.consecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#consecutivo#">
			  and a.Ecodigo = b.Ecodigo
			  and a.cliente_empresarial = b.cliente_empresarial
			  and a.Usucodigo = b.Usucodigo
			  and a.Ulocalizacion = b.Ulocalizacion
			  and b.Ecodigo = c.Ecodigo
			  and c.Ecodigo = d.Ecodigo
			  and b.Usucodigo = e.Usucodigo
			  and b.Ulocalizacion = e.Ulocalizacion
			  and b.cliente_empresarial = e.cliente_empresarial
			  and e.Usucodigo = f.Usucodigo
			  and e.Ulocalizacion = f.Ulocalizacion
			  <cfif corporativo>
			  and c.cliente_empresarial = x.cliente_empresarial
			  and x.Ecodigo = y.Ecodigo
			  and y.sistema = d.sistema
			  </cfif>
			  <cfif isdefined("addWhere") and Len(Trim(addWhere)) NEQ 0>
			  and #PreserveSingleQuotes(addWhere)#
			  </cfif>
		</cfquery>
		<cfreturn usuario>
	</cffunction>
	
	<!--- Obtiene los datos de un Usuario según el Usucodigo y Ulocalizacion --->
	<cffunction name="get_usuario_by_cod" access="public" returntype="query">
		<cfargument name="corporativo" type="boolean" required="false" default="false">
		<cfargument name="consecutivo" type="numeric" required="true">
		<cfargument name="sistema" type="string" required="true">
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfargument name="Ulocalizacion" type="string" required="true">
		<cfargument name="roles" type="string" required="false"><!--- Los roles no se deben repetir --->
	
		<cfquery name="usuario" datasource="#Session.DSN#">
			select distinct 
			       convert(varchar, e.Usucodigo) as Usucodigo,
			       e.Ulocalizacion,
				   f.Usulogin, 
				   convert(varchar, e.cliente_empresarial) as cliente_empresarial,
				   convert(varchar, c.Ecodigo) as Ecodigo,
				   f.Usutemporal,
				   f.activo,
				   e.Pnombre,
				   e.Papellido1,
				   e.Papellido2,
				   e.Ppais,
				   e.TIcodigo,
				   e.Pid,
				   convert(varchar, e.Pnacimiento, 103) as Pnacimiento,
				   e.Psexo,
				   e.Pemail1,
				   e.Pemail2,
				   e.Pdireccion,
				   e.Pcasa,
				   e.Poficina,
				   e.Pcelular,
				   e.Pfax,
				   e.Ppagertel,
				   e.Ppagernum,
				   a.rol,
				   convert(varchar, a.num_referencia) as num_referencia,
				   a.int_referencia
			from UsuarioPermiso a, UsuarioEmpresa b, Empresa c, EmpresaID d, UsuarioEmpresarial e, Usuario f<cfif corporativo>, Empresa x, EmpresaID y</cfif>
			where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#"> 
			  and a.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Ulocalizacion#">
			  <cfif isdefined("roles") and Len(Trim(roles)) NEQ 0>
			  and a.rol in (<cfqueryparam cfsqltype="cf_sql_char" value="#Replace(roles, ' ', '', 'all')#" list="yes" separator=",">)
			  </cfif>
			  and <cfif corporativo>y<cfelse>d</cfif>.sistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sistema#">
			  and <cfif corporativo>y<cfelse>d</cfif>.consecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#consecutivo#">
			  and a.Ecodigo = b.Ecodigo
			  and a.cliente_empresarial = b.cliente_empresarial
			  and a.Usucodigo = b.Usucodigo
			  and a.Ulocalizacion = b.Ulocalizacion
			  and b.Ecodigo = c.Ecodigo
			  and c.Ecodigo = d.Ecodigo
			  and b.Usucodigo = e.Usucodigo
			  and b.Ulocalizacion = e.Ulocalizacion
			  and b.cliente_empresarial = e.cliente_empresarial
			  and e.Usucodigo = f.Usucodigo
			  and e.Ulocalizacion = f.Ulocalizacion
			  <cfif corporativo>
			  and c.cliente_empresarial = x.cliente_empresarial
			  and x.Ecodigo = y.Ecodigo
			  and y.sistema = d.sistema
			  </cfif>
		</cfquery>
	
		<cfreturn usuario>
	</cffunction>

	<!--- Activa o desactiva un rol --->
	<cffunction name="activate_rol" access="public" returntype="boolean">
		<cfargument name="cliente_empresarial" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfargument name="Ulocalizacion" type="string" required="true">
		<cfargument name="referencias" type="string" required="true">
		<cfargument name="roles" type="string" required="true"><!--- Los roles no se deben repetir --->
		<cfargument name="activacion" type="string" required="true"><!--- Si se envia la activacion, debe haber uno por cada rol enviado --->
	
		<cfset arrReferencias = ListToArray(Replace(referencias, ' ', '', 'all'), ",")>
		<cfset arrRoles = ListToArray(Replace(roles, ' ', '', 'all'), ",")>
		<cfset arrActivos = ListToArray(Replace(activacion, ' ', '', 'all'), ",")>

		<cftry>
			<cfloop index="cont" from="1" to="#ArrayLen(arrRoles)#">
				<cfquery name="activate_UsuarioPermiso#cont#" datasource="#Session.DSN#">
					update UsuarioPermiso
					set activo = <cfqueryparam cfsqltype="cf_sql_bit" value="#Trim(arrActivos[cont])#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
						BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
						BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
					  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Ulocalizacion#">
					  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cliente_empresarial#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#">
					  and rol = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(arrRoles[cont])#">
					  and num_referencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(arrReferencias[cont])#">
				</cfquery>
			</cfloop>
		<cfcatch type="any">
			<cfinclude template="/edu/errorPages/BDerror.cfm">
			<cftransaction action="rollback" />
			<cfabort>
		</cfcatch>				
		</cftry>
		
		<cfreturn true>
	</cffunction>

	<!--- Agrega un rol a un usuario --->
	<cffunction name="add_rol" access="public" returntype="boolean">
		<cfargument name="cliente_empresarial" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfargument name="Ulocalizacion" type="string" required="true">
		<cfargument name="referencias" type="string" required="true">
		<cfargument name="roles" type="string" required="true"><!--- Los roles no se deben repetir --->
		<cfargument name="activacion" type="string" required="false" default=""><!--- Si se envia la activacion, debe haber uno por cada rol enviado --->
	
		<cfset arrReferencias = ListToArray(Replace(referencias, ' ', '', 'all'), ",")>
		<cfset arrRoles = ListToArray(Replace(roles, ' ', '', 'all'), ",")>
		<cfif isdefined("activacion") and Len(Trim(activacion)) NEQ 0>
			<cfset arrActivos = ListToArray(Replace(activacion, ' ', '', 'all'), ",")>
		</cfif>
		<cfloop index="cont" from="1" to="#ArrayLen(arrRoles)#">
			<cfquery name="a_UsuarioPermiso" datasource="#Session.DSN#">
				if not exists(
					select 1
					from UsuarioPermiso
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
					  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Ulocalizacion#">
					  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cliente_empresarial#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#">
					  and rol = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(arrRoles[cont])#">
					  and num_referencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(arrReferencias[cont])#">
				)
				insert UsuarioPermiso 
						(Usucodigo, Ulocalizacion, cliente_empresarial, Ecodigo, rol, num_referencia, <!--- int_referencia,  --->BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod<cfif isdefined("activacion") and Len(Trim(activacion)) NEQ 0>, activo</cfif>)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#Ulocalizacion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#cliente_empresarial#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Trim(arrRoles[cont])#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(arrReferencias[cont])#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_integer" value="#Trim(arrReferencias[cont])#">, --->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						<cfif isdefined("activacion") and Len(Trim(activacion)) NEQ 0>, <cfqueryparam cfsqltype="cf_sql_bit" value="#Trim(arrActivos[cont])#"></cfif>
						)
			</cfquery>
		</cfloop>
		
		<cfreturn true>
	</cffunction>

	<!--- Elimina un rol de un Usuario --->
	<cffunction name="del_rol" access="public" returntype="boolean">
		<cfargument name="cliente_empresarial" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfargument name="Ulocalizacion" type="string" required="true">
		<cfargument name="roles" type="string" required="true"><!--- Los roles no se deben repetir --->
		<cfargument name="referencias" type="string" required="false" default=""><!--- Si las referencias vienen deben tener la misma cantidad que los roles --->

		<cfif isdefined("referencias") and Len(Trim(referencias)) NEQ 0>
			<cfset arrReferencias = ListToArray(Replace(referencias, ' ', '', 'all'), ",")>
		</cfif>
		<cfset arrRoles = ListToArray(Replace(roles, ' ', '', 'all'), ",")>
		<cfloop index="cont" from="1" to="#ArrayLen(arrRoles)#">
			<cfquery name="del_UsuarioPermiso" datasource="#Session.DSN#">
				delete from UsuarioPermiso
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Ulocalizacion#">
				  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cliente_empresarial#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#">
				  and rol = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(arrRoles[cont])#">
				<cfif isdefined("referencias") and Len(Trim(referencias)) NEQ 0>
				  and num_referencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(arrReferencias[cont])#">
				</cfif>
			</cfquery>
		</cfloop>

		<cfquery name="moreRoles" datasource="#Session.DSN#">
			select 1
			from UsuarioPermiso
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
			  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Ulocalizacion#">
			  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cliente_empresarial#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#">
		</cfquery>

		<!--- Si no tiene más roles borrar el usuario --->
		<cfif moreRoles.recordCount EQ 0>
			<cfscript>
				del_usuario(cliente_empresarial, Ecodigo, Usucodigo, Ulocalizacion);
			</cfscript>
		</cfif>
		
		<cfreturn true>
	</cffunction>

	<!--- Agrega o modifica los datos de un Usuario --->
	<cffunction name="upd_usuario" access="public" returntype="query">
		<cfargument name="corporativo" type="boolean" required="false" default="false">
		<cfargument name="consecutivo" type="numeric" required="true">
		<cfargument name="sistema" type="string" required="true">
		<cfargument name="referencias" type="string" required="true">
		<cfargument name="roles" type="string" required="true" default=""><!--- conjunto de roles de la persona. Los roles no se deben repetir --->
		<cfargument name="activacion" type="string" required="false" default=""><!--- Si se envia la activacion, debe haber uno por cada rol enviado --->
		<cfargument name="Pnombre" type="string" required="true"><!--- Nombre del usuario--->
		<cfargument name="Papellido1" type="string" required="false" default=""><!--- apellido 1 del usuario--->
		<cfargument name="Papellido2" type="string" required="false" default=""><!--- apellido 2 del usuario--->
		<cfargument name="Ppais" type="string" required="true"><!--- Codigo del pais --->
		<cfargument name="TIcodigo" type="string" required="true"><!--- Codigo del tipo de identificacion --->
		<cfargument name="Pid" type="string" required="true"><!--- identificacion del usuario --->
		<cfargument name="Pnacimiento" type="string" required="false" default=""><!--- fecha de nacimiento --->
		<cfargument name="Psexo" type="string" required="false" default=""><!--- sexo del usuario F=femenino, M=masculino --->
		<cfargument name="Pemail1" type="string" required="false" default=""><!--- direccion electronica 1 --->
		<cfargument name="Pemail2" type="string" required="false" default=""><!--- direccion electronica 2 --->
		<cfargument name="Pdireccion" type="string" required="false" default=""><!--- direccion --->
		<cfargument name="Pcasa" type="string" required="false" default=""><!--- telefono de la casa de habitacion --->
		<cfargument name="Poficina" type="string" required="false" default=""><!--- telefono de la oficina --->
		<cfargument name="Pcelular" type="string" required="false" default=""><!--- telefono celular --->
		<cfargument name="Pfax" type="string" required="false" default=""><!--- telefono del fax --->
		<cfargument name="Ppagertel" type="string" required="false" default=""><!--- telefono del pager --->
		<cfargument name="Ppagernum" type="string" required="false" default=""><!--- numero del pager --->
		<cfargument name="Pfoto" type="any" required="false" default=""><!--- estructura con la foto de la persona --->
		<!--- Parametros para entrar en modo cambio --->
		<cfargument name="upd_referencia" type="string" required="false" default="">
		<cfargument name="upd_rol" type="string" required="false" default="">
		<cfargument name="dominio_roles" type="string" required="false" default=""><!--- conjunto de todos los roles del sistema. opcional--->
		
		<cfset userExists = false>
		<cfif isdefined("upd_referencia") and Len(Trim(upd_referencia)) NEQ 0 and isdefined("upd_rol") and Len(Trim(upd_rol)) NEQ 0>
			<cfset u = get_usuario_by_ref(corporativo, consecutivo, sistema, upd_referencia, upd_rol)>
		<cfelse>
			<cfset u = get_usuario_by_ref(corporativo, consecutivo, sistema, referencias, roles)>
		</cfif>
		<!--- Averiguar si el usuario al menos existe --->
		<cfif u.recordCount GT 0>
			<cfset userExists = true>
		</cfif>
		<!--- Averiguar Datos de la Empresa --->
		<cfset clienteEmpr = getEmpresa(consecutivo, sistema)>

		<cfif isdefined('clienteEmpr') and clienteEmpr.recordCount GT 0>
			<cftry>
				<cfif not userExists>
					<!--- Ingreso en UsuarioEmpresarial --->
					<cfquery name="a_Usuario" datasource="#Session.DSN#">
						set nocount on						
						insert Usuario (Ulocalizacion, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo, Pid, Pnacimiento, Psexo, 
								Pemail1, Pemail2, Pdireccion, Pcasa, <cfif isdefined("Pfoto") and Pfoto NEQ "">Pfoto, </cfif>Pemail1validado,
								BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod)
						values (<cfqueryparam cfsqltype="cf_sql_char" value="00">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Pnombre#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Papellido1#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Papellido2#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#Ppais#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#TIcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Pid#">,
								convert(datetime, <cfqueryparam value="#Pnacimiento#" cfsqltype="cf_sql_varchar">, 103 ),
								<cfqueryparam cfsqltype="cf_sql_char" value="#Psexo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Pemail1#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Pemail2#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Pdireccion#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Pcasa#">,
								<cfif isdefined("Pfoto") and Pfoto NEQ "">
								#Pfoto#,
								</cfif>
								0,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
								
						select convert(varchar, @@identity) as Usucodigo, '00' as Ulocalizacion, #clienteEmpr.cliente_empresarial# as cliente_empresarial, #clienteEmpr.Ecodigo# as Ecodigo
						set nocount off
					</cfquery>
					<!--- Ingreso en UsuarioEmpresarial --->
					<cfquery name="a_UsuarioEmpresarial" datasource="#Session.DSN#">
						insert UsuarioEmpresarial 
							(Usucodigo, Ulocalizacion, cliente_empresarial, Pnombre, Papellido1, Papellido2, 
							Ppais, TIcodigo, Pid, Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, 
							<cfif isdefined("Pfoto") and Pfoto NEQ "">Pfoto, </cfif>BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#a_Usuario.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#a_Usuario.Ulocalizacion#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#clienteEmpr.cliente_empresarial#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Pnombre#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Papellido1#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Papellido2#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#Ppais#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#TIcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Pid#">,
								convert( datetime, <cfqueryparam value="#Pnacimiento#" cfsqltype="cf_sql_varchar">, 103 ),
								<cfqueryparam cfsqltype="cf_sql_char" value="#Psexo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Pemail1#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Pemail2#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Pdireccion#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Pcasa#">,
								<cfif isdefined("Pfoto") and Pfoto NEQ "">
								#Pfoto#,
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
					</cfquery>
					<!--- Ingreso en UsuarioEmpresa --->
					<cfquery name="a_UsuarioEmpresa" datasource="#Session.DSN#">
						insert UsuarioEmpresa (Usucodigo, Ulocalizacion, cliente_empresarial, Ecodigo, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#a_Usuario.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#a_Usuario.Ulocalizacion#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#clienteEmpr.cliente_empresarial#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#clienteEmpr.Ecodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
					</cfquery>
				<cfelse>
					<!--- Actualizacion de Datos en UsuarioEmpresarial --->
					<cfquery name="u_UsuarioEmpresarial" datasource="#Session.DSN#">
						update Usuario set
							Pnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pnombre#">,
							Papellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Papellido1#">,
							Papellido2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Papellido2#">,
							Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#Ppais#">,
							TIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TIcodigo#">,
							Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pid#">,
							Pnacimiento = convert(datetime, <cfqueryparam value="#Pnacimiento#" cfsqltype="cf_sql_varchar">, 103),
							Psexo = <cfqueryparam cfsqltype="cf_sql_char" value="#Psexo#">,
							Pemail1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pemail1#">,
							Pemail2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pemail2#">,
							Pdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pdireccion#">,
							Pcasa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pcasa#">,
							Poficina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Poficina#">,							
							Pcelular = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pcelular#">,							
							Pfax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pfax#">,							
							Ppagertel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ppagertel#">,							
							Ppagernum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ppagernum#">,														
							<cfif isdefined("Pfoto") and Pfoto NEQ "">
								Pfoto = #Pfoto#,					
							</cfif>								
							BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
							BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
							BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#u.Usucodigo#">
						and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#u.Ulocalizacion#">
						and Usutemporal = 1
					
						update UsuarioEmpresarial set
							Pnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pnombre#">,
							Papellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Papellido1#">,
							Papellido2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Papellido2#">,
							Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#Ppais#">,
							TIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TIcodigo#">,
							Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pid#">,
							Pnacimiento = convert(datetime, <cfqueryparam value="#Pnacimiento#" cfsqltype="cf_sql_varchar">, 103),
							Psexo = <cfqueryparam cfsqltype="cf_sql_char" value="#Psexo#">,
							Pemail1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pemail1#">,
							Pemail2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pemail2#">,
							Pdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pdireccion#">,
							Pcasa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pcasa#">,
							Poficina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Poficina#">,							
							Pcelular = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pcelular#">,							
							Pfax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Pfax#">,							
							Ppagertel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ppagertel#">,							
							Ppagernum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ppagernum#">,														
							<cfif isdefined("Pfoto") and Pfoto NEQ "">
								Pfoto = #Pfoto#,					
							</cfif>								
							BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
							BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
							BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#u.cliente_empresarial#">
						and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#u.Usucodigo#">
						and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#u.Ulocalizacion#">
					</cfquery>
					<cfset a_Usuario = u>
				</cfif>
				
				<!--- Ingreso en UsuarioPermiso --->
				<cfif isdefined('a_Usuario') and a_Usuario.recordCount GT 0>
					<cfscript>
						add_rol(a_Usuario.cliente_empresarial, a_Usuario.Ecodigo, a_Usuario.Usucodigo, a_Usuario.Ulocalizacion, referencias, roles);
						activate_rol(a_Usuario.cliente_empresarial, a_Usuario.Ecodigo, a_Usuario.Usucodigo, a_Usuario.Ulocalizacion, referencias, roles, activacion);
					</cfscript>
					<cfif userExists>
						<!--- Aqui debe de sacar cuales son los roles que no estan marcados, para así borrarlos   --->
						<cfset roles = Replace(roles, " ", "", "all")>
						<cfif isdefined("dominio_roles") and len(trim(dominio_roles)) NEQ 0>
							<cfset roles_a_borrar = Replace(dominio_roles, " ", "", "all")>
						<cfelse>
							<!---  aqui debe buscar cuales roles faltan en el sistema actual --->
							<cfquery name="rsRolesEdu" datasource="#Session.DSN#">
								select rtrim(ltrim(rol)) as rol
								from Rol
								where sistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sistema#">
							</cfquery>
							<cfset roles_a_borrar = Replace(ValueList(rsRolesEdu.rol), " ", "", "all")>
						</cfif>
						<cfloop index="i" from="#ListLen(roles)#" to="1" step="-1">
							<cfset roles_a_borrar = ListDeleteAt(roles_a_borrar, ListFind(roles_a_borrar, ListGetAt(roles, i, ","), ","), ",")>
						</cfloop>
						<!--- Borrar roles no utilizados --->
						<!--- Se espera que el Usuario no tenga más de una referencia por rol --->
						<cfif Len(Trim(roles_a_borrar)) NEQ 0>
							<cfscript>
								del_rol(a_Usuario.cliente_empresarial, a_Usuario.Ecodigo, a_Usuario.Usucodigo, a_Usuario.Ulocalizacion, roles_a_borrar);
							</cfscript>
						</cfif>
					</cfif>
				</cfif>
				
				<cfset result = get_usuario_by_cod(corporativo, consecutivo, sistema, a_Usuario.Usucodigo, a_Usuario.Ulocalizacion)>
				
				<cfcatch type="any">
					<cfinclude template="/edu/errorPages/BDerror.cfm">
					<cftransaction action="rollback" />
					<cfabort>
				</cfcatch>				
			</cftry>
		</cfif>

		<cfreturn result>
	</cffunction>

	<!--- Elimina un usuario que cumpla con una referencia y un rol --->
	<cffunction name="del_usuario_by_ref" access="public" returntype="boolean">
		<cfargument name="corporativo" type="boolean" required="false" default="false">
		<cfargument name="consecutivo" type="numeric" required="true">
		<cfargument name="sistema" type="string" required="true">
		<cfargument name="referencia" type="string" required="true">
		<cfargument name="rol" type="string" required="true">

		<cftry>
			<cfset u = get_usuario_by_ref(corporativo, consecutivo, sistema, referencia, rol)>
			<cfif u.recordCount GT 0>
				<cfscript>
					del_usuario(u.cliente_empresarial, u.Ecodigo, u.Usucodigo, u.Ulocalizacion);
				</cfscript>
			</cfif>
		<cfcatch type="any">
			<cfinclude template="/edu/errorPages/BDerror.cfm">
			<cftransaction action="rollback" />
			<cfabort>
		</cfcatch>				
		</cftry>

		<cfreturn true>
	</cffunction>

</cfcomponent>
