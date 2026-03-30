<cfcomponent output="no">

<cffunction name="update" output="false" returntype="void">
	<cfargument name="Ecodigo" type="numeric" required="yes">
	<cfargument name="Enombre" type="string" required="yes">
	<cfargument name="Etelefono1" type="string" required="yes">
	<cfargument name="Etelefono2" type="string" required="yes">
	<cfargument name="Efax" type="string" required="yes">
	<cfargument name="Eidentificacion" type="string" required="yes">
	<cfargument name="auditar" type="boolean" required="yes">
	<cfargument name="logoblob" type="binary" required="yes">
	
	<cfquery datasource="asp" name="empq">
		select e.id_direccion, e.Ereferencia, c.Ccache
		from Empresa e
			join Caches c
				on c.Cid = e.Cid
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
	</cfquery>

	<!--- Inserta la dirección --->
	<cf_direccion action="readform" name="data">
	<cfset data.id_direccion = empq.id_direccion>
	<cf_direccion action="update" key="#empq.id_direccion#" name="data" data="#data#">
	
	<cfquery name="rs" datasource="asp">
		update Empresa
		set Enombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Enombre#">,
			Etelefono1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Etelefono1#" null="#len(trim(Arguments.Etelefono1)) is 0#">,
			Etelefono2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Etelefono2#" null="#len(trim(Arguments.Etelefono2)) is 0#">,
			Efax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Efax#" null="#len(trim(Arguments.Efax)) is 0#">,
			Eidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Eidentificacion#" null="#Len(trim(Arguments.Eidentificacion)) Is 0#">,
			BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			<cfif Len(form.logo)>
			, Elogo = <cfqueryparam cfsqltype="cf_sql_blob" value="#Arguments.logoblob#">
			</cfif>
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
	</cfquery>
	<cfif True OR StructKeyExists(Application.dsinfo, empq.Ccache)>
		<cfquery name="rs" datasource="#empq.Ccache#">
			update Empresas
			set Edescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Enombre#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empq.Ereferencia#">
		</cfquery>
	</cfif>
<!---
	<cfif Not IsDefined('Arguments.auditar')>
		<cfinvoke component="asp.admin.bitacora.catalogos.PBitacoraEmp.activar" method="inactivarEmpresa" Ecodigo="#rs.identity#"/>
	</cfif>
--->
</cffunction>
</cfcomponent>