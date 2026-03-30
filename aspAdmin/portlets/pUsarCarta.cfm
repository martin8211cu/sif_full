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

<!--- consulta usa carta --->
<cftry>
	<cfset usarCarta = LCase(getAfiliacionEJB().getConfig("usarCarta")) eq 'TRUE'>
<cfcatch type="any">
	<cfinclude template="../../errorPages/BDerror.cfm">	
	<cfabort>
</cfcatch>
</cftry>