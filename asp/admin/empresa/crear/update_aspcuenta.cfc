<cfcomponent output="no">
<cffunction name="update" output="false" returntype="void">
	<cfargument name="CEcodigo" type="numeric" required="yes">
	<cfargument name="LOCidioma" type="string" required="yes">
	<cfargument name="CEnombre" type="string" required="yes">
	<cfargument name="CEaliaslogin" type="string" required="yes">
	<cfargument name="CEtelefono1" type="string" required="yes">
	<cfargument name="CEtelefono2" type="string" required="yes">
	<cfargument name="CEfax" type="string" required="yes">
	<cfargument name="logoblob" type="binary" required="yes">

	<cfquery datasource="asp" name="ctaeq">
		select id_direccion
		from CuentaEmpresarial
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
	</cfquery>

	<cfif Len(Trim(Arguments.CEaliaslogin))>
		<cfquery name="data" datasource="asp">
			select CEaliaslogin 
			from CuentaEmpresarial
			where CEaliaslogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.CEaliaslogin)#">
			  and CEcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
		</cfquery>
		<cfif data.recordCount gt 0 >
			<cfthrow message="El alias de login solicitado para la cuenta ya está reservado.">
		</cfif>
	</cfif>
	
	<!--- Inserta la dirección --->

	<cf_direccion action="readform" name="data">
	<cfset data.id_direccion = ctaeq.id_direccion>
	<cf_direccion action="update" key="#ctaeq.id_direccion#" name="data" data="#data#">

	<!--- Inserta la Cuenta Empresarial, le asocia la direccion y el numero de cuenta --->
	<cfquery name="rs" datasource="asp">
		update CuentaEmpresarial 
		set LOCIdioma = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LOCIdioma#">,
			CEaliaslogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.CEaliaslogin)#" null="#Len(Trim(Arguments.CEaliaslogin)) Is 0#">,
			CEnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CEnombre#">,
			CEtelefono1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CEtelefono1#" null="#len(trim(Arguments.CEtelefono1)) Is 0#">,
			CEtelefono2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CEtelefono2#" null="#len(trim(Arguments.CEtelefono2)) Is 0#">,
			CEfax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CEfax#" null="#len(trim(Arguments.CEfax)) Is 0#">,
			BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			<cfif Len(form.logo)>
			, CElogo = <cf_dbupload filefield="logo" accept="image/*" datasource="asp"></cfif>
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
	</cfquery>
</cffunction>
</cfcomponent>