<cfif isdefined("form.baja")>
	<cfquery datasource="aspsecure">
		delete from Autorizador
		where autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#">
	</cfquery>
	<cflocation url="autorizador.cfm">
<cfelseif isdefined("form.autorizador") and form.autorizador NEQ ''>
	<cf_direccion action="readform" name="direccion">
	<cf_direccion action="update" data="#direccion#" name="direccion">
	
	<cfquery datasource="aspsecure">
		update Autorizador
		set nombre_autorizador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_autorizador#">,
		    id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.id_direccion#">,
			programa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.programa#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		where autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#">
	</cfquery>

	<cfquery datasource="aspsecure" name="tipos">
		select case when att.autorizador is null then 0 else 1 end as valido,
			tt.tc_tipo, tt.nombre_tipo_tarjeta
		from TipoTarjeta tt left outer join AutorizadorTipoTarjeta att 
			on tt.tc_tipo = att.tc_tipo
				and att.autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#">
	</cfquery>
	<cfparam name="form.tc_tipo" default="">
	<cfloop query="tipos">
		<cfif ListFind(form.tc_tipo, trim(tipos.tc_tipo)) neq 0 and tipos.valido is 0>
			<cfquery datasource="aspsecure">
				insert INTO AutorizadorTipoTarjeta (autorizador, tc_tipo, BMUsucodigo, BMfechamod)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#tipos.tc_tipo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
			</cfquery>
		<cfelseif ListFind(form.tc_tipo, trim(tipos.tc_tipo)) is 0 and tipos.valido neq 0>
			<cfquery datasource="aspsecure">
				delete from AutorizadorTipoTarjeta
				where autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#">
				  and tc_tipo = <cfqueryparam cfsqltype="cf_sql_char" value="#tipos.tc_tipo#">
			</cfquery>
		</cfif>
	</cfloop>
	
	<cflocation url="autorizador.cfm?autorizador=#form.autorizador#">
<cfelse>
	<!--- default = alta --->
	<cf_direccion action="readform" name="direccion">
	<cf_direccion action="insert" data="#direccion#" name="direccion">
	
	<cfquery datasource="aspsecure" name="inserted">
		insert INTO Autorizador (
			nombre_autorizador, id_direccion, programa,
			BMUsucodigo, BMfechamod)
		values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_autorizador#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.id_direccion#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.programa#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
	
	  <cf_dbidentity1 datasource="aspsecure">
	</cfquery>
	<cf_dbidentity2 datasource="aspsecure" name="inserted">	
	
	<cfset autorizador = inserted.identity>
	<cflocation url="autorizador.cfm?autorizador=#autorizador#">
</cfif>