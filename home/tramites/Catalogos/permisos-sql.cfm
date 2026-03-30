<cfif IsDefined('form.agregar')>
	<cfquery datasource="#session.tramites.dsn#">
		insert into TPPermiso (
			tipo_objeto, id_objeto, tipo_sujeto, id_sujeto,
			puede_capturar, puede_revisar, puede_modificar,
			items_ok,
			BMUsucodigo, BMfechamod)
		values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tipo_objeto#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_objeto#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tipo_sujeto#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_sujeto#">,			
			1, 1, 0, ' ',			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		)
	</cfquery>
	<cflocation url="permisos-form.cfm?tipo_objeto=#URLEncodedFormat(form.tipo_objeto)
									  #&id_objeto=#URLEncodedFormat(form.id_objeto)
									  #&items=#URLEncodedFormat(form.items)
									  #&buscar=#URLEncodedFormat(form.buscar)#">
<cfelseif IsDefined('url.upd')>
	<cfparam name="url.itm" default="">
	<cfquery datasource="#session.tramites.dsn#">
		update TPPermiso
		set 
			puede_capturar  = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('url.cap')#">,
			puede_revisar   = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('url.rev')#">,
			puede_modificar = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('url.mod')#">,
			items_ok = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.itm#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		where tipo_objeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tipo_objeto#">
		  and id_objeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_objeto#">
		  and tipo_sujeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tipo_sujeto#">
		  and id_sujeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_sujeto#">
	</cfquery>
	update ok
	<cfabort>
<cfelseif IsDefined('url.baja')>
	<cfquery datasource="#session.tramites.dsn#">
		delete TPPermiso
		where tipo_objeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tipo_objeto#">
		  and id_objeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_objeto#">
		  and tipo_sujeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tipo_sujeto#">
		  and id_sujeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_sujeto#">
	</cfquery>
	<cflocation url="permisos-form.cfm?tipo_objeto=#URLEncodedFormat(url.tipo_objeto)
									  #&id_objeto=#URLEncodedFormat(url.id_objeto)
									  #&items=#URLEncodedFormat(url.items)
									  #&buscar=#URLEncodedFormat(url.buscar)#">
<cfelse>
	Invocación incorrecta.
	<cfabort>
</cfif>

