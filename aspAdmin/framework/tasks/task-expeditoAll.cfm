<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title> Task de Afiliación </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<!--- 	Componente para ser llamado como un task de ColdFusion.
		Se encarga de tomar todos los Usuarios recientemente creados para afliarlos y enviarles la contraseña.
--->

<p><h2><b>Task de Afiliación</b></h2></p><br>

<p>Iniciando proceso <cfoutput> #TimeFormat(Now(),"HH:MM:SS")#</cfoutput></p><br>

<!--- Parámetros Fijos
--->
<cfset cantProcesar = 10><!--- Cantidad de Registros que se van a Procesar  --->
<p>Cantidad de Registros que se van a Procesar: <cfoutput>#cantProcesar#</cfoutput>.</p><br>
 
<!--- EJB --->
<cfset EjbUser = 'guest'>
<cfset EjbPass = 'guest'>
<cfset EjbJndi = 'SdcSeguridad/Afiliacion'>

<cfscript>
	function getAfiliacionEJB ( )
	{
		var home = 0;
		var prop = 0;

		if (IsDefined ("__AfiliacionStub")) {
			return __AfiliacionStub;
		}

		// initial context
		prop = CreateObject("java", "java.util.Properties" );
		initContext = CreateObject("java", "javax.naming.InitialContext" );
		// especificar propiedades, esto se requiere para objetos remotos
		prop.init();
		prop.put(initContext.SECURITY_PRINCIPAL, EjbUser);
		prop.put(initContext.SECURITY_CREDENTIALS, EjbPass);
		initContext.init(prop);
		
		// ejb lookup
		home = initContext.lookup(EjbJndi);
		
		// global var, reuse
		__AfiliacionStub = home.create();
		return __AfiliacionStub;
	}
</cfscript>
 
<!--- 	1.Query de los Usuarios que se van a procesar.
			Se encuentra limitado en registros porque podrían ser tantos que peguen el servidor tratando 
			de procesarlos a todos.
--->
<p>1.Query de los Usuarios que se van a procesar...</p><br>
<cfquery name="segUsers" datasource="SDC" maxrows="#cantProcesar#">
 	select null as nombre_cuenta_empresarial, null as nombre_empresa, r.rol, r.nombre as nombre_rol, up.id,
		u.Pnombre, u.Papellido1, u.Papellido2, u.Pemail1, u.Usucodigo, u.Ulocalizacion,
		porque = 'soy pso'
	from Rol r, UsuarioPermiso up, Usuario u
	where r.empresarial = 0
	  and r.interno = 1
	  and r.activo = 1
	  and r.rol = 'sys.agente'
	  and up.rol = r.rol
	  and up.activo = 1
	  and u.Usutemporal = 1
	  and u.activo = 1
	  and u.Usucodigo = up.Usucodigo
	  and u.Ulocalizacion = up.Ulocalizacion
	  and up.num_impreso = 0
  
	union
	select null as nombre_cuenta_empresarial, null as nombre_empresa, r.rol, r.nombre as nombre_rol, up.id,
		u.Pnombre, u.Papellido1, u.Papellido2, u.Pemail1, u.Usucodigo, u.Ulocalizacion,
		porque = 'soy pso, vale como agente de ' + u.Usulogin
	from Usuario u, UsuarioPermiso up, Rol r
	where u.activo = 1
	  and up.Usucodigo = u.Usucodigo
	  and up.Ulocalizacion = u.Ulocalizacion
	  and up.activo = 1
	  and u.Usutemporal = 1
	  and u.activo = 1
	  and r.rol = up.rol
	  and r.empresarial = 0
	  and r.activo = 1
	  and up.num_impreso = 0

	union
	select cce.nombre as nombre_cuenta_empresarial, e.nombre_comercial as nombre_empresa, r.rol, r.nombre as nombre_rol, up.id,
		ue.Pnombre, ue.Papellido1, ue.Papellido2, ue.Pemail1, ue.Usucodigo, ue.Ulocalizacion, 
		porque = 'soy pso, vale como admin de ' + cce.nombre
	from CuentaClienteEmpresarial cce, UsuarioEmpresarial ue, UsuarioEmpresa ue2, UsuarioPermiso up, Rol r, Usuario u, Empresa e
	where cce.activo = 1
	  and e.Ecodigo = up.Ecodigo
	  and e.activo = 1
	  and ue.cliente_empresarial = cce.cliente_empresarial
	  and ue.activo = 1
	  and ue2.Usucodigo = ue.Usucodigo
	  and ue2.Ulocalizacion = ue.Ulocalizacion
	  and ue2.cliente_empresarial = ue.cliente_empresarial
	  and ue2.activo = 1
	  and up.Usucodigo = ue.Usucodigo
	  and up.Ulocalizacion = ue.Ulocalizacion
	  and up.Ulocalizacion = ue2.Ulocalizacion
	  and up.cliente_empresarial = ue2.cliente_empresarial
	  and up.activo = 1
	  and u.Usucodigo = ue.Usucodigo
	  and u.Ulocalizacion = ue.Ulocalizacion
	  and u.Usutemporal = 1
	  and u.activo = 1
	  and r.rol = up.rol
	  and r.empresarial = 1
	  and r.interno = 0
	  and r.activo = 1
	  and up.num_impreso = 0
</cfquery>

<cfdump var="#segUsers#" label="Usuarios recientemente creados para afliarlos y enviarles la contraseña">
<br>
 
<!--- 	2.Inicia Procesado de los registros consultados
--->
<p>2.Inicia Procesado de los registros consultados...</p><br>
<cfloop query="segUsers">
	<!--- consulta ejb --->
	<cftry>
	
		<p>Afiliando <cfoutput>#segUsers.Usucodigo#,#segUsers.Ulocalizacion#</cfoutput>...</p><br>
	
		<cfscript>
			getAfiliacionEJB().prepararUsuarioTemporal(segUsers.Usucodigo,segUsers.Ulocalizacion,true);
		</cfscript>

		<cfquery name="ABC_UpdateUP" datasource="sdc">
			update UsuarioPermiso
			set fecha_impreso = getdate()
				 , num_impreso = num_impreso + 1
				 , BMUsucodigo = 1
				 , BMUlocalizacion = '00'
				 , BMUsulogin = 'tasks'
				 , BMfechamod = getdate()
			where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#segUsers.id#">
			  and activo = 1
		</cfquery>
		
		<cfcatch type="any">
			Error Procesando.
			Procesados ok = <cfoutput>#segUsers.CurrentRow-1#</cfoutput>.
			<cfdump var="#cfcatch#">
			<cfabort>
		</cfcatch>
	</cftry>	
</cfloop>

<p>Proceso Completado con exito! <cfoutput>#TimeFormat(Now(),"HH:MM:SS")#</cfoutput></p><br>

</body>
</html>
