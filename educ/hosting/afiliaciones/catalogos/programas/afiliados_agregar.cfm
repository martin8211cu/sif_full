<cfparam name="form.id_programa" type="numeric">
<cfparam name="form.id_persona">
<cfparam name="form.Pnombre">
<cfparam name="form.Papellido1">
<cfparam name="form.Papellido2">
<cfparam name="form.Pid">

<cfif Len(form.id_persona) is 0>
	<cf_datospersonales action="new" name="copy_datos_personales">
	<cfset copy_datos_personales.datos_personales = ''>
	<cf_datospersonales action="insert" data="#copy_datos_personales#"  name="copy_datos_personales">
	
	<cf_direccion action="new" name="copy_direccion">
	<cf_direccion action="insert" data="#copy_direccion#"  name="copy_direccion">
</cfif>

<cftransaction>

<cfif Len(form.id_persona) is 0>
	<cfif Len(form.Pid)>
		<cfquery datasource="#session.dsn#" name="buscar_si_ya_existe">
			select id_persona
			from sa_personas
			where Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#" name="buscar_si_ya_existe">
			select id_persona
			from sa_personas
			where upper(Pnombre) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(form.Pnombre)#">
			  and upper(Papellido1) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(form.Pnombre)#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		</cfquery>
	</cfif>
	<cfif Len(buscar_si_ya_existe.id_persona)>
		<cfset form.id_persona = buscar_si_ya_existe.id_persona>
	</cfif>
</cfif>
<cfif Len(form.id_persona) is 0>
	<cfquery datasource="#session.dsn#" name="persona_insertada">
		insert into sa_personas (
			Pid,
			Pnombre,
			Papellido1,
			Papellido2,
			Psexo,
			
			Pcasa,
			Poficina,
			Pcelular,
			Pfax,
			Pemail1,
			id_direccion,
			datos_personales,
			CEcodigo,
			Ecodigo,
			BMfechamod,
			
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.Pid#" null="#Len(form.Pid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.Pnombre#" null="#Len(form.Pnombre) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.Papellido1#" null="#Len(form.Papellido1) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.Papellido2#" null="#Len(form.Papellido2) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.Psexo#" null="#Len(form.Psexo) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_char" null="yes">,
			<cfqueryparam cfsqltype="cf_sql_char" null="yes">,
			<cfqueryparam cfsqltype="cf_sql_char" null="yes">,
			<cfqueryparam cfsqltype="cf_sql_char" null="yes">,
			
			<cfqueryparam cfsqltype="cf_sql_char" null="yes">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#copy_direccion.id_direccion#" >,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#copy_datos_personales.datos_personales#" >,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="persona_insertada">
	<cfset form.id_persona = persona_insertada.identity>
</cfif>
<cfif Len(Trim(Form.foto)) GT 0 >
	<cfquery datasource="#session.DSN#">
		insert into sa_imagenpersona (id_persona, imagen)
		values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">, 
				 <cf_dbupload filefield="foto" accept="image/*" datasource="#session.dsn#"> )
	</cfquery>
</cfif>

</cftransaction>

<cflocation url="afiliados_carnet.cfm?id_persona=#URLEncodedFormat(form.id_persona)#&id_programa=#URLEncodedFormat(form.id_programa)#&id_vigencia=#URLEncodedFormat(form.id_vigencia)#">

