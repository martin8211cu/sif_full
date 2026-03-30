<!---
 * Operaciones Genericas
 *
 * @author OPARRALES
 * @date 2018-09-06
 --->
<cfquery datasource="asp" name="__conexiones__">
   	select e.Ecodigo as EcodigoSDC, e.CEcodigo, c.Ccache, e.Ereferencia
       from Empresa e
           join Caches c
           on e.Cid = c.Cid
</cfquery>

<cfset This.Conexiones = __conexiones__>

<!--- FUNCION GETCONEXION --->
<cffunction name="getConexion" returntype="string" output="no" access="public">
   	<cfargument name="EcodigoSDC" type="numeric" required="yes" hint="Ecodigo (sdc) que se usara para obtener el cache o conexion">
	<cfquery dbtype="query" name="ret">
		select *
		from This.Conexiones
		where Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoSDC#">
	</cfquery>
	<cfreturn ret.Ccache>
</cffunction>

<cffunction  name="getEquivalencia">
	<cfargument name="ValorOrigen" type="string" required="yes" hint="Valor de Origen">
	<cfargument name="CodigEquivalencia" type="string" required="false" default="CADENA" hint="Codigo del catalogo">
	<!--- Obtiene las empresas a sincronizar --->
	<cfquery name="rsEmpresas" datasource="sifinterfaces">
		select EQUidSIF,EQUidSIF, EQUdescripcion
		from SIFLD_Equivalencia
		where upper(CATcodigo) like upper('#Arguments.CodigEquivalencia#')
		and SIScodigo like 'LD'
		<cfif  isdefined('Arguments.ValorOrigen') and Trim(Arguments.ValorOrigen) neq ''>
			and EQUcodigoOrigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ValorOrigen#">
		</cfif>
	</cfquery>

	<cfif rsEmpresas.RecordCount eq 0 or rsEmpresas.EQUidSIF eq ''>
		<cflog file="WSClientesVentas" text="ValidationException: No hay equivalencias configuradas para #Arguments.CodigEquivalencia#" log="Application" type="information">
		<cfthrow message="ValidationException: " detail="No hay equivalencias configuradas para #Arguments.CodigEquivalencia#">
	</cfif>

	<cfreturn rsEmpresas.EQUidSIF>
</cffunction>