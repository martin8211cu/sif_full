<cfset tipo = 10> 
<!---  Por default tendra valor 10 para que use la boleta estándar (carta)--->

<!--- busca el tipo de boleta de pago definido en parametros generales de RH --->
<cfquery name="RSParametro" datasource="#session.DSN#">
	select ltrim(rtrim(Pvalor)) as tipo  
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 720				
</cfquery>

<cfif isdefined("RSParametro") and len(trim(RSParametro.tipo))>
	<cfset tipo = RSParametro.tipo>
</cfif> 

<cfswitch expression="#tipo#"> 
	<cfcase value="10"> 
		<cfset Ruta.autogestion = '/cfmx/rh/expediente/consultas/HBoletaPago.cfm'>
		<cfset Ruta.pago        = '/cfmx/rh/pago/operacion/EnviarEmails.cfm'>
	</cfcase> 
	<cfcase value="20">
		<cfset Ruta.autogestion = '/cfmx/rh/expediente/consultas/HBoletaPagoDosTercios.cfm'>
		<cfset Ruta.pago        = '/cfmx/rh/pago/operacion/EnviarEmailsDosTercios.cfm'>
	</cfcase>
	<cfcase value="30">
		<cfset Ruta.autogestion = '/cfmx/rh/expediente/consultas/HBoletaPagoDosTercios.cfm'>
		<cfset Ruta.pago        = '/cfmx/rh/pago/operacion/EnviarEmailsDosTercios.cfm'>
	</cfcase>
	<cfcase value="40">
		<cfset Ruta.autogestion = '/cfmx/rh/expediente/consultas/HBoletaPagoDosTerciosImp.cfm'>				
		<cfset Ruta.pago        = '/cfmx/rh/pago/operacion/EnviarEmailsDosTerciosImp.cfm'>
	</cfcase>
	
	<cfdefaultcase> 
		<cfset Ruta.autogestion = '/cfmx/rh/expediente/consultas/HBoletaPago.cfm'>
		<cfset Ruta.pago        = '/cfmx/rh/pago/operacion/EnviarEmails.cfm'>
	</cfdefaultcase> 
</cfswitch> 
