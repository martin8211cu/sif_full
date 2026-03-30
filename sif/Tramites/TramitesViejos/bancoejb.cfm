<cfobject action="create" name="ctx"  type="JAVA" class="javax.naming.Context">
<cfobject action="create" name="prop" type="JAVA" class="java.util.Properties">
<cfset prop.init()>

<!--- Specify the properties These are required for a remote server only --->
<cfset prop.put(ctx.INITIAL_CONTEXT_FACTORY, bancoEjbFactory)>
<cfset prop.put(ctx.PROVIDER_URL, bancoEjbUri)>
<cfset prop.put(ctx.SECURITY_PRINCIPAL, bancoEjbUser)>
<cfset prop.put(ctx.SECURITY_CREDENTIALS, bancoEjbPass)>

<!--- Create the InitialContext  --->
<cfobject action="create" name="initContext" type="JAVA" class="javax.naming.InitialContext">

<!--- Call the init method (provided through cfobject)
	  to pass the properties to the InitialContext constructor. --->
<cfset initContext.init(prop)>
<!--- <cfdump var="#initContext#" label="Contexto inicial" > --->

<!--- Get reference to home object. --->
<cfset home = initContext.lookup(bancoEjbJndi)>
<cfset banco = home.create()>

<cffunction name="new_Long">
	<cfargument name="value" required="true">
	<cfobject action="create" name="ret_fn" type="JAVA" class="java.lang.Long">
	<cftry>
		<cfset ret_fn.init(value)>
	<cfcatch>
		<cfset ret_fn.init(value.toString())>
	</cfcatch>
	</cftry>
	<cfreturn #ret_fn#>
</cffunction>

<cffunction name="new_BigDecimal">
	<cfargument name="value" required="true">
	<cfobject action="create" name="ret_fn" type="JAVA" class="java.math.BigDecimal">
	<cftry>
		<cfset ret_fn.init(value)>
	<cfcatch>
		<cfset ret_fn.init(value.toString())>
	</cfcatch>
	</cftry>
	<cfreturn #ret_fn#>
</cffunction>

<cffunction name="cuentaDTO" >
	<cfargument name="Iaba" required="true">
	<cfargument name="CBTcodigo" required="true">
	<cfargument name="CBcodigo" required="true">
	<cfargument name="Mcodigo" required="true">
	<cfargument name="CBofxacctkey" required="true">

	<cfobject action="create" name="cuenta_fn" type="JAVA" class="com.soin.sdc.facturas.servicios.CuentaDTO">
	<cfset cuenta_fn.init()>
	<cfset cuenta_fn.setCodigoBanco(arguments.Iaba)>
	<cfset cuenta_fn.setCodigoTipo(new_BigDecimal(arguments.CBTcodigo))>
	<cfset cuenta_fn.setNumero(arguments.CBcodigo)>
	<cfset cuenta_fn.setCodigoMoneda(new_BigDecimal(arguments.Mcodigo))>
	<cfset cuenta_fn.setIdPropietario(arguments.CBofxacctkey)>
	<cfreturn #cuenta_fn#>
</cffunction>
