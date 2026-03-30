<!--- Eliminar Usuario --->
<cfparam name="url.uc" type="numeric">
<cfquery name="rsSelUsuario" datasource="asp">
	select id_direccion, datos_personales
	from Usuario
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.uc#">
	and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.simple._ctaemp#">
</cfquery>
<cfif isdefined('rsSelUsuario') and rsSelUsuario.recordCount GT 0>
	<cftransaction>
		<cfquery datasource="asp">
			delete from UsuarioSustituto
			where Usucodigo1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.uc#">
			   or Usucodigo2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.uc#">
		</cfquery>
		<cfloop list="UsuarioReferencia,UsuarioRol,ORGPermisosAgenda,SReciente,SPortletPreferencias,IndicadorUsuario,SShortcut,PUsuario,Preferencias,UsuarioPassword,UsuarioPasswordHist,Usuario" index="tabla">
			<cfquery datasource="asp">
				delete from #tabla#
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.uc#">
			</cfquery>
		</cfloop>
		
		<cfset borrar = true>
		<cfloop list="Usuario,Empresa,CuentaEmpresarial,ReqInfo" index="tabla">
			<cfquery name="busca" datasource="asp">
				select count(1) as cnt from Usuario
				where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelUsuario.id_direccion#">
			</cfquery>
			<cfif busca.cnt><cfset borrar = false><cfbreak></cfif>
		</cfloop>
		<cfif borrar>
			<cfquery name="rsDelDirecciones" datasource="asp">
				delete from Direcciones
				where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelUsuario.id_direccion#">
			</cfquery>
		</cfif>
		
		<cfset borrar = true>
		<cfloop list="Usuario,ReqInfo" index="tabla">
			<cfquery name="busca" datasource="asp">
				select count(1) as cnt from Usuario
				where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelUsuario.datos_personales#">
			</cfquery>
			<cfif busca.cnt><cfset borrar = false><cfbreak></cfif>
		</cfloop>
		<cfif borrar>
			<cfquery name="rsDelDatPerson" datasource="asp">
				delete from DatosPersonales
				where datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelUsuario.datos_personales#">
			</cfquery>
		</cfif>
	</cftransaction>
</cfif>
<cflocation url="simple.cfm?reload">