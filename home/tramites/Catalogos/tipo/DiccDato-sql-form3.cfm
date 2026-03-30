<!--- MODO ALTA --->
<cfif isdefined("Form.Alta")>
	<cfif not (isdefined("Form.orden_campo") and Len(Trim(Form.orden_campo)))>
		<cfquery name="nextOrden" datasource="#session.tramites.dsn#">
			select coalesce(max(orden_campo), 0) + 10 as orden
			from DDTipoCampo
			where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
		</cfquery>
		<cfset Form.orden_campo = nextOrden.orden>
	</cfif>
	
	<cfquery name="insDDTipoCampo" datasource="#session.tramites.dsn#">
		insert into DDTipoCampo (id_tipo, id_tipocampo, nombre_campo, 
			es_obligatorio, es_descripcion, es_llave,
			orden_campo, BMfechamod, BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipocampo#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_campo#">, 
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_obligatorio')#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_descripcion')#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_llave')#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.orden_campo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		)
	</cfquery>

<!--- MODO CAMBIO --->
<cfelseif isdefined("Form.Cambio")>

	<cfquery name="insDDTipoCampo" datasource="#session.tramites.dsn#">
		update DDTipoCampo set
			id_tipocampo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipocampo#">, 
			nombre_campo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_campo#">, 
			
			es_obligatorio = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_obligatorio')#">,
			es_descripcion = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_descripcion')#">,
			es_llave       = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_llave')#">,
			<cfif isdefined("Form.orden_campo") and Len(Trim(Form.orden_campo))>
				orden_campo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.orden_campo#">,
			</cfif>
			BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		where id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_campo#">
	</cfquery>

<!--- MODO BAJA --->
<cfelseif isdefined("Form.Baja")>

	<!--- 
		Preguntar si hay que eliminar las siguientes tablas 
		DDCampo
		DDVistaCampo
	--->

	<cfquery name="delDDTipoCampo" datasource="#session.tramites.dsn#">
		delete DDTipoCampo
		where id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_campo#">
	</cfquery>
	<cfset StructDelete(Form, "id_campo")>

<cfelseif IsDefined('form.CambioEsPersona')>
	<cfquery name="delDDTipoCampo" datasource="#session.tramites.dsn#">
		update DDTipo
		set es_persona = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_persona')#">
		where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
	</cfquery>
</cfif>

<cfset params= "">
<cfif isdefined("Form.id_tipo") and Len(Trim(Form.id_tipo))>
	<cfset params = "?id_tipo=" & Form.id_tipo>
</cfif>
<cflocation url="DiccDato-form3.cfm#params#">
