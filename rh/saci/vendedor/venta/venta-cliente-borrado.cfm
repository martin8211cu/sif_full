<cfset sinReferencias = true>
<cfset msgError = "">

<cfquery name="rsTMP_productos" datasource="#Session.DSN#">
	Select 1
	from ISBpersona p
		inner join ISBcuenta c
			on c.Pquien=p.Pquien
	
		inner join ISBproducto pr
			on pr.CTid=c.CTid
	where  p.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pquien#">
		and p.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif isdefined('rsTMP_productos') and rsTMP_productos.recordCount GT 0>
	<cfset msgError = "La persona contiene productos activos asociados. No se permite su eliminación.">
	<cfset sinReferencias = false>
</cfif>

<cfif sinReferencias>
	<cfquery name="rsTMP_contactos" datasource="#Session.DSN#">
		Select 1
		from ISBpersona p
			inner join  ISBcontactoCta cc
				on cc.Pquien=p.Pquien
		where p.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pquien#">
			and p.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif isdefined('rsTMP_contactos') and rsTMP_contactos.recordCount GT 0>
		<cfset msgError = "La persona actual existe como contacto de otra persona. No se permite su eliminación.">	
		<cfset sinReferencias = false>
	</cfif>
</cfif>

<!--- Verificacion del Usuario SACI --->
<cfif sinReferencias>
	<!--- Persona --->
	 <cfquery name="rsTMP_persona" datasource="#Session.DSN#">
		select 1
		from ISBpersona p
			inner join UsuarioReferencia ur
				on ur.llave =<cf_dbfunction name="to_char" args="p.Pquien">
					and STabla='ISBpersona'
					and ur.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
		where p.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pquien#">
			and p.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif isdefined('rsTMP_persona') and rsTMP_persona.recordCount GT 0>
		<cfset msgError = "La persona actual posee un usuario en SACI. No se permite su eliminación.">		
		<cfset sinReferencias = false>
	</cfif>	
</cfif>

<cfif sinReferencias>
	<!--- Agente --->
	<cfquery name="rsTMP_agente" datasource="#Session.DSN#">
		select 1
		from ISBpersona p
			inner join ISBagente a
				on a.Pquien=p.Pquien
					and a.Ecodigo=p.Ecodigo
			inner join UsuarioReferencia ur
				on ur.llave = <cf_dbfunction name="to_char" args="a.AGid">
					and ur.STabla='ISBagente'
					and ur.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
		where p.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pquien#">
			and p.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif isdefined('rsTMP_agente') and rsTMP_agente.recordCount GT 0>
		<cfset msgError = "La persona actual posee un usuario en SACI como agente. No se permite su eliminación.">			
		<cfset sinReferencias = false>
	</cfif>
</cfif>

<cfif sinReferencias>
	<!--- Vendedor --->
	<cfquery name="rsTMP_vendedor" datasource="#Session.DSN#">
		select 1
		from ISBpersona p
			inner join ISBvendedor v
				on v.Pquien=p.Pquien
			inner join UsuarioReferencia ur
				on ur.llave = <cf_dbfunction name="to_char" args="v.Vid">
					and ur.STabla='ISBvendedor'
					and ur.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
		
		where p.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pquien#">
			and p.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif isdefined('rsTMP_vendedor') and rsTMP_vendedor.recordCount GT 0>
		<cfset msgError = "La persona actual posee un usuario en SACI como vendedor. No se permite su eliminación.">				
		<cfset sinReferencias = false>
	</cfif>	
</cfif>

<cfif sinReferencias>
	<cfinvoke component="saci.comp.ISBpersona" method="Baja">
		<cfinvokeargument name="Pquien" value="#form.Pquien#">
	</cfinvoke>
<cfelse>
	<cfthrow message="#msgError#">
</cfif>