<!--- 
	CFM que genera la parte relacionada al framework para manjeo de Demostraciones
	Asume:
		1. La base de datos asp_demos_soin debe existir.
		2. Debe existir un datasource (demos_soin) que apunte a asp_demos_soin.
	Que hace:
		1. Crea la cuenta Empresarial
		2. Asocia los modulos de SIF y RH a la cuenta empresarial creada
		3. Crea un cache ( apunta a demos ) y lo asocia a la cuenta empresarial. Debe ser exclusivo.
		4. Crea la empresa en la bd satelite
---><cf_templateheader title="Configuraci&oacute;n para Demos"><cf_web_portlet_start titulo="Configuraci&oacute;n para Demos">
	<cfset alias_cuenta = 'demos' >
	<cfset _cache = 'demos_soin'>
	<cfset referencia = 28 >
	<cfset idioma = 'es_CR' >
	
	<cftransaction>
		<!--- 1. Ingresa Cuenta Empresarial --->
		<cfinclude template="cuenta-empresarial.cfm">	
		<!--- 2. Modulos --->
		<cfinclude template="modulos.cfm">	
		<!--- 3. Modulos --->
		<cfinclude template="cache.cfm">	
		<!--- 4. Empresa --->
		<cfinclude template="empresa.cfm">	
	</cftransaction>
	
	<!--- Actualiza los datos de la Empresa 28 --->
	<cfquery datasource="#_cache#">
		update Empresas
		set Ecache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#_cache#">,
		    cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuenta.identity#">,
			EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa.identity#">
		where Ecodigo = 28
	</cfquery>

	<table width="50%" align="center" cellpadding="2" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
		<tr><td style="border-bottom:1px solid gray; "><strong><font size="1">Configuraci&oacute;n de Demos</font></strong></td></tr>
		<tr><td>1. Se gener&oacute; la cuenta empresarial demos.</td></tr>
		<tr><td>2. Se asociaron los todos los m&oacute;dulos de SIF y RH para la cuenta empresarial demos.</td></tr>
		<tr><td>3. Se gener&oacute; el cache demos_soin y se asoci&oacute; a la cuenta empresarial demos.</td></tr>
		<tr><td>4. Se gener&oacute; la empresa DATA en asp y se asoci&oacute; a la Empresa DATA(28) de la base de datos asp_demos_soin.</td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>

	<cf_web_portlet_end><cf_templatefooter>