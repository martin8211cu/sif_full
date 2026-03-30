<cfif IsDefined("form.Ecodigo")>
	<!--- activar/desactivar una unica empresa : <cfoutput>#form.Ecodigo#</cfoutput> --->
	<cfif form['activo'&form.Ecodigo] is 0>
		<cfinvoke component="activar" method="inactivarEmpresa" Ecodigo="#form.Ecodigo#" />
	<cfelse>
		<cfinvoke component="activar" method="activarEmpresa" Ecodigo="#form.Ecodigo#" />
	</cfif>
<cfelseif IsDefined("form.CEcodigo")>
	<!--- activar/desactivar toda la cuenta empresarial : <cfoutput>#form.CEcodigo#</cfoutput> --->
	<cfquery datasource="asp" name="lista_empresas">
		select Ecodigo from Empresa where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CEcodigo#">
	</cfquery>
	<cfif IsDefined('form.inactivar_todo')>
		<cfloop query="lista_empresas">
			<cfinvoke component="activar" method="inactivarEmpresa" Ecodigo="#lista_empresas.Ecodigo#" />
		</cfloop>
	<cfelse>
		<cfloop query="lista_empresas">
			<cfinvoke component="activar" method="activarEmpresa" Ecodigo="#lista_empresas.Ecodigo#" />
		</cfloop>
	</cfif>
<cfelseif IsDefined('form.glb')>
	<!--- activar/desactivar toda la cuenta empresarial --->
	<cfquery datasource="asp" name="lista_empresas">
		select Ecodigo from Empresa
	</cfquery>
	<cfif form.activo is 0>
		<cfloop query="lista_empresas">
			<cfinvoke component="activar" method="inactivarEmpresa" Ecodigo="#lista_empresas.Ecodigo#" />
		</cfloop>
	<cfelse>
		<cfloop query="lista_empresas">
			<cfinvoke component="activar" method="activarEmpresa" Ecodigo="#lista_empresas.Ecodigo#" />
		</cfloop>
	</cfif>
<cfelse>
	<cfthrow message="No se especificó operación">
</cfif>

<cflocation url="PBitacoraEmp.cfm">
