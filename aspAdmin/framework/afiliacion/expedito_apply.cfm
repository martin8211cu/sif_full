<cfset debug = false>
<!--- EJB --->
<cfset EjbUser = 'guest'>
<cfset EjbPass = 'guest'>
<cfset EjbJndi = 'SdcSeguridad/Afiliacion'>

<cfif debug>
	Enviando contrase&ntilde;as...<br>
</cfif>

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

<cfset totalok = 0>
<cfset totalerr = 0>
<cfset llaves = ListToArray(form.chk)>
<cfloop from="1" to="#ArrayLen(llaves)#" index="i">
	<cfquery name="rsUser" datasource="#Session.DSN#">
		<!---
			Este query es el mismo que en cartaPDF.cfm (excepto por las columnas obtenidas)
		
			Leer los datos para imprimir en el contrato de afiliacion,
			y marcar en UsuarioPermiso que la carta ha sido impresa.
			Hay que verificar que haya permiso de leer el registro, y que la carta se pueda
			(re)imprimir:
			- Hay que tener permiso sobre el usuario:
				- porque soy pso
				- porque soy agente del usuario
				- porque soy administrador de la cta empresarial del usuario
			- El usuario debe estar en el proceso de afiliacion (Usutemporal = 1)
		--->
		select
			u.Usucodigo, u.Ulocalizacion
		from Usuario u, UsuarioPermiso up, Empresa e, Rol r
		where up.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaves[i]#">
		  and up.activo = 1
		  and e.Ecodigo  =* up.Ecodigo
		  and u.Usucodigo = up.Usucodigo
		  and u.Ulocalizacion = up.Ulocalizacion
		  and u.Usutemporal = 1
		  and r.rol = up.rol
		  and r.activo = 1

		update UsuarioPermiso
		set fecha_impreso = getdate()
			 , num_impreso = num_impreso + 1
			 , BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			 , BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
			 , BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
			 , BMfechamod = getdate()
		where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaves[i]#">
		  and activo = 1
	</cfquery>
	<!--- consulta ejb --->
	<cftry>
		<cfscript>
			getAfiliacionEJB().prepararUsuarioTemporal(rsUser.Usucodigo,rsUser.Ulocalizacion,true);
		</cfscript>
		<cfset totalok = totalok + 1>
	<cfcatch type="any">
		<cfset etxt = cfcatch.Detail>
		<cfset euid = rsUser.Usucodigo>
		<cfset eloc = rsUser.Ulocalizacion>
		<cfset totalerr = totalerr + 1>
	</cfcatch>
	</cftry>	
</cfloop>

<cfif debug>
	cantidad ok: <cfoutput>#totalok#</cfoutput><br>
	cantidad error: <cfoutput>#totalerr#</cfoutput><br>
	cantidad total: <cfoutput>#totalok+totalerr#</cfoutput><br>
</cfif>

<cfif not debug>

	<cfset params ="?ok=" & totalok>
	<cfif totalerr gt 0>
		<cfset params = params & "&err=" & totalerr>
		<cfset params = params & "&etxt=" & etxt>
		<cfset params = params & "&euid=" & euid>
		<cfset params = params & "&eloc=" & eloc>
	</cfif>
	
	<cflocation url="expedito.cfm#params#">

</cfif>