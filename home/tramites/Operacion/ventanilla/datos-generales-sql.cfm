<cfif isdefined("form.Modificar")>
	<cfquery datasource="#session.tramites.dsn#">
		update TPPersona
		set casa = <cfif len(trim(form.casa))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.casa#"><cfelse>null</cfif>,
			oficina = <cfif len(trim(form.oficina))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oficina#"><cfelse>null</cfif>,
			celular = <cfif len(trim(form.celular))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.celular#"><cfelse>null</cfif>,
			fax = <cfif len(trim(form.fax))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#"><cfelse>null</cfif>,
			email1 = <cfif len(trim(form.email))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#"><cfelse>null</cfif>
			
		where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
	</cfquery>

<cfelseif isdefined("form.ModificarFoto")>
	<cfif Len(form.foto)>
		<cfquery datasource="#session.tramites.dsn#">
			update TPPersona
			set foto = <cf_dbupload datasource="#session.tramites.dsn#" accept="image/*" filefield="foto">
			where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
		</cfquery>
	</cfif>
</cfif>

  <cfinvoke component="home.tramites.componentes.vistas" argumentcollection="#form#"
		method="updRegistro"></cfinvoke>
		
<cflocation url="tramite.cfm?id_instancia=#form.id_instancia#&id_persona=#form.id_persona#&tab=1">