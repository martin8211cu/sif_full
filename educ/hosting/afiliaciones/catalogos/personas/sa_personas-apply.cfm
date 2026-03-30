<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="sa_personas"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="id_persona"
				type1="numeric"
				value1="#form.id_persona#">

<cfquery datasource="#session.dsn#" name="old">
	select datos_personales,id_direccion
	from sa_personas
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#" null="#Len(form.id_persona) Is 0#">
</cfquery>

<cf_datospersonales action="select" name="form_datos_personales" key="#old.datos_personales#">
	<cfset form_datos_personales.APELLIDO1=form.Papellido1>
	<cfset form_datos_personales.APELLIDO2=form.Papellido2>
	<cfset form_datos_personales.CASA 	  =form.Pcasa>
	<cfset form_datos_personales.CELULAR  =form.Pcelular>
	<cfset form_datos_personales.EMAIL1   =form.Pemail1>
	<cfset form_datos_personales.FAX 	  =form.Pfax>
	<cfset form_datos_personales.ID 	  =form.Pid>
	<cfif Len(form.Pnacimiento)>
		<cfset form_datos_personales.NACIMIENTO=LSParseDateTime(form.Pnacimiento)></cfif>
	<cfset form_datos_personales.NOMBRE   =form.Pnombre>
	<cfset form_datos_personales.OFICINA  =form.Poficina>
	<cfif Len(form.Psexo)>
	<cfset form_datos_personales.SEXO     =form.Psexo>
	<cfelse>
	<cfset form_datos_personales.SEXO     ='M'>
	</cfif>
	
	<cf_datospersonales action="update"key="#old.id_direccion#" name="form_datos_personales" data="#form_datos_personales#">

	<cf_direccion action="readform" name="form_direccion">
	<cfif Len(old.id_direccion)>
	<cfset form_direccion.id_direccion = old.id_direccion></cfif>
	<cf_datospersonales action="update" key="#old.id_direccion#" data="#form_datos_personales#" name="inserted_datos_personales" datasource="#session.dsn#">
	
	<cfquery datasource="#session.dsn#">
		update sa_personas
		set Pid = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Pid#" null="#Len(form.Pid) Is 0#">
		, Pnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Pnombre#" null="#Len(form.Pnombre) Is 0#">
		, Papellido1 = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Papellido1#" null="#Len(form.Papellido1) Is 0#">
		
		, Papellido2 = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Papellido2#" null="#Len(form.Papellido2) Is 0#">
		, Pcasa = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Pcasa#" null="#Len(form.Pcasa) Is 0#">
		, Poficina = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Poficina#" null="#Len(form.Poficina) Is 0#">
		, Pcelular = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Pcelular#" null="#Len(form.Pcelular) Is 0#">
		, Psexo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Psexo#" null="#Len(form.Psexo) Is 0#">
		, Pnacimiento = <cfif Len(form.Pnacimiento)><cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.Pnacimiento)#"><cfelse>null</cfif>
		
		, Pfax = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Pfax#" null="#Len(form.Pfax) Is 0#">
		, Pemail1 = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Pemail1#" null="#Len(form.Pemail1) Is 0#">
		, id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form_direccion.id_direccion#">
		, datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form_datos_personales.datos_personales#" >
		, CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#" null="#Len(form.id_persona) Is 0#">
	</cfquery>
	
	<cfif Len(Trim(Form.foto)) GT 0 >	
		<cfquery datasource="#session.dsn#">
			delete sa_imagenpersona
			where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#" null="#Len(form.id_persona) Is 0#">
		</cfquery>
		<cfquery datasource="#session.DSN#">
			insert into sa_imagenpersona (id_persona, imagen)
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">, 
					 <cf_dbupload filefield="foto" accept="image/*" datasource="#session.dsn#"> )
		</cfquery>
	</cfif>	

	<cflocation url="sa_personas.cfm?id_persona=#URLEncodedFormat(form.id_persona)#">

<cfelseif IsDefined("form.Baja")>

	<cfquery datasource="#session.dsn#">
		delete sa_imagenpersona
		where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#" null="#Len(form.id_persona) Is 0#">
	</cfquery>

	<cfquery datasource="#session.dsn#">
		delete sa_pariente
		where sujeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#" null="#Len(form.id_persona) Is 0#">
	</cfquery>

	<cfquery datasource="#session.dsn#">
		delete sa_pariente
		where pariente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#" null="#Len(form.id_persona) Is 0#">
	</cfquery>

	<cfquery datasource="#session.dsn#">
		delete sa_personas
		where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#" null="#Len(form.id_persona) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>

	<cf_direccion action="readform" name="form_direccion">
	<cf_direccion action="insert" name="inserted_direccion" data="#form_direccion#">

	<cf_datospersonales action="new" name="form_datos_personales">
	<cfset form_datos_personales.APELLIDO1=form.Papellido1>
	<cfset form_datos_personales.APELLIDO2=form.Papellido2>
	<cfset form_datos_personales.CASA 	  =form.Pcasa>
	<cfset form_datos_personales.CELULAR  =form.Pcelular>
	<cfset form_datos_personales.EMAIL1   =form.Pemail1>
	<cfset form_datos_personales.FAX 	  =form.Pfax>
	<cfset form_datos_personales.ID 	  =form.Pid>
	<cfif Len(form.Pnacimiento)>
		<cfset form_datos_personales.NACIMIENTO=LSParseDateTime(form.Pnacimiento)></cfif>
	<cfset form_datos_personales.NOMBRE   =form.Pnombre>
	<cfset form_datos_personales.OFICINA  =form.Poficina>
	<cfif Len(form.Psexo)>
	<cfset form_datos_personales.SEXO     =form.Psexo>
	<cfelse>
	<cfset form_datos_personales.SEXO     ='M'>
	</cfif>

	<cf_datospersonales action="insert" data="#form_datos_personales#" name="inserted_datos_personales" datasource="#session.dsn#">

	<cftransaction>
	<cfquery datasource="#session.dsn#" name="insert">
		insert into sa_personas (
			Pid,
			Pnombre,
			Papellido1,
			
			Papellido2,
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
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.Pcasa#" null="#Len(form.Pcasa) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.Poficina#" null="#Len(form.Poficina) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.Pcelular#" null="#Len(form.Pcelular) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.Pfax#" null="#Len(form.Pfax) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.Pemail1#" null="#Len(form.Pemail1) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#inserted_direccion.id_direccion#" >,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#inserted_datos_personales.datos_personales#" >,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="insert">

	<cfif Len(Trim(Form.foto)) GT 0 >	
		<cfquery datasource="#session.DSN#">
			insert into sa_imagenpersona (id_persona, imagen)
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">, 
					 <cf_dbupload filefield="foto" accept="image/*" datasource="#session.dsn#"> )
		</cfquery>
	</cfif>	
	
	</cftransaction>
	
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="sa_personas.cfm">


