<cfif isdefined("form.baja")>
	<cfquery datasource="aspsecure">
		delete from TipoTarjeta
		where tc_tipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tc_tipo#">
	</cfquery>
	<cflocation url="tipotarjeta.cfm">
<cfelseif isdefined("form.tc_tipo")>	
	<cfquery name="rsFindTipoTar" datasource="aspsecure">
		Select 1
		from TipoTarjeta
		where tc_tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tc_tipo#">
	</cfquery>
	
	<cfquery datasource="aspsecure">	
		<cfif isdefined('rsFindTipoTar') and rsFindTipoTar.recordCount GT 0>
			update TipoTarjeta
			set nombre_tipo_tarjeta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tipo_tarjeta#">,
				mascara = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mascara#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where tc_tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tc_tipo#">
		<cfelse>
			insert TipoTarjeta (
				tc_tipo, nombre_tipo_tarjeta, mascara,
				BMUsucodigo, BMfechamod)
			values (
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.tc_tipo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tipo_tarjeta#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mascara#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		</cfif>
	</cfquery>
	
	<cflocation url="tipotarjeta.cfm?tc_tipo=#form.tc_tipo#">
</cfif>