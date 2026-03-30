<cfif not isdefined("form.Nuevo")>
	<!--- Validación del Código--->
	<cfif isdefined("form.ALTA")>
		<cfquery name="data" datasource="#session.DSN#">
			select 1
			from CMEspecializacionTSCF 
			where CMTScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Compras.Configuracion.CMTScodigo#">
				and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.Configuracion.CFpk#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif form.CMEtipo eq 'A'>
				and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
			<cfelseif form.CMEtipo eq 'S'>
				and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
			<cfelseif form.CMEtipo eq 'F'>
				and ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigo#">
				and ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACid#">
			</cfif>
		</cfquery>
		<cfif data.RecordCount gt 0>
			<cf_errorCode	code = "50253" msg = "La especialización que está intentando agregar ya existe, Proceso Cancelado!">
		</cfif>
	</cfif>
	<cfif isdefined("form.Alta") or isdefined("form.AltaEsp")>
		<cfquery name="insert" datasource="#session.DSN#">
			insert into CMEspecializacionTSCF( Ecodigo, CFid, CMTScodigo, CMEtipo, ACcodigo, ACid, Ccodigo, CCid )
			values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.Configuracion.CFpk#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Compras.Configuracion.CMTScodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.CMEtipo)#">,
				<cfif form.CMEtipo eq 'F'><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACcodigo#"><cfelse>null</cfif>,
				<cfif form.CMEtipo eq 'F'><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACid#"><cfelse>null</cfif>,
				<cfif form.CMEtipo eq 'A'><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#"><cfelse>null</cfif>,
				<cfif form.CMEtipo eq 'S'><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#"><cfelse>null</cfif>
			)
		</cfquery>
	<cfelseif isdefined("form.Baja") and form.Baja>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from CMEspecializacionTSCF
			where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CMElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMElinea#">
		</cfquery>
	</cfif>
</cfif>
<cflocation url="compraConfig.cfm">

