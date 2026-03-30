<cfset datos_1 = listtoarray(form.chk)>

<cfloop from="1" to="#arraylen(datos_1)#" index="i">
	<cfset datos_2 = listtoarray(datos_1[i],'|') >
	
	<cfset demo = structnew() >
	<cfset structinsert(demo, 'Ecodigo', datos_2[1]) >
	<cfset structinsert(demo, 'EcodigoSDC', datos_2[2]) >
	<cfset structinsert(demo, 'DSN', datos_2[3]) >
	<cfset structinsert(demo, 'CEcodigo', datos_2[4]) >
	<cfset structinsert(demo, 'UsucodigoDemo', datos_2[5]) >
	
	<!--- Borra RH --->
	<cfinclude template="/sif/demos/rh/eliminado.cfm">
	<!---Borra Empresa---->
	<cfquery datasource="#demo.DSN#" >
		delete from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#session.dsn#" >
		delete from Empresa where Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>	
	
</cfloop>

<cflocation url="eliminar-demos.cfm">