<cfparam name="form.id_persona" type="numeric">
<cfparam name="form.pariente">
<cfparam name="form.Pnombre">
<cfparam name="form.Papellido1">
<cfparam name="form.Papellido2">
<cfparam name="form.Pid">
<cfparam name="form.parentesco">
<cfset form.Psexo = ListFirst(form.parentesco)>
<cfset form.id_parentesco = ListLast(form.parentesco)>
<cfif Len( form.id_parentesco )>
	<cfparam name="form.id_parentesco" type="numeric">
</cfif>

<cfif Len(form.pariente) is 0>
	<cfquery datasource="#session.dsn#" name="sujeto">
		select id_persona, datos_personales, id_direccion, Pcasa, Poficina, Pcelular, Pfax
		from sa_personas
		where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>
	<cf_datospersonales action="select" key="#sujeto.datos_personales#" name="copy_datos_personales">
	<cfset copy_datos_personales.datos_personales = ''>
	<cf_datospersonales action="insert" data="#copy_datos_personales#"  name="copy_datos_personales">
	
	<cf_direccion action="select" key="#sujeto.datos_personales#" name="copy_direccion">
	<cfset copy_direccion.id_direccion = ''>
	<cf_direccion action="insert" data="#copy_direccion#"  name="copy_direccion">
</cfif>

<cftransaction>

<cfif Len(form.pariente) is 0>
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
		<cfset form.pariente = buscar_si_ya_existe.id_persona>
	</cfif>
</cfif>
<cfif Len(form.pariente) is 0>
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
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#sujeto.Pcasa#" null="#Len(sujeto.Pcasa) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#sujeto.Poficina#" null="#Len(sujeto.Poficina) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#sujeto.Pcelular#" null="#Len(sujeto.Pcelular) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#sujeto.Pfax#" null="#Len(sujeto.Pfax) Is 0#">,
			
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
	<cfset form.pariente = persona_insertada.identity>
</cfif>
<cfif Len(Trim(Form.foto)) GT 0 >
	<cfquery datasource="#session.DSN#">
		insert into sa_imagenpersona (id_persona, imagen)
		values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pariente#">, 
				 <cf_dbupload filefield="foto" accept="image/*" datasource="#session.dsn#"> )
	</cfquery>
</cfif>


<cfquery datasource="#session.dsn#" name="ya_es_pariente">
	select pariente from sa_pariente
	where sujeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
	  and pariente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pariente#">
</cfquery>
<cfif Len(ya_es_pariente.pariente)>
	<cfquery datasource="#session.DSN#">
		update sa_pariente
		set id_parentesco = 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_parentesco#" null="#Len(form.id_parentesco) is 0#">
		where sujeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
		  and pariente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pariente#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfquery>
<cfelse>
	<cfquery datasource="#session.DSN#">
		insert into sa_pariente (
			sujeto, pariente, id_parentesco,
			CEcodigo, Ecodigo, BMfechamod, BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pariente#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_parentesco#" null="#Len(form.id_parentesco) is 0#">, 
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> )
	</cfquery>
</cfif>

<cfquery datasource="#session.DSN#" name="inverso">
	select inverso
	from sa_parentesco
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and id_parentesco = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_parentesco#" null="#Len(form.id_parentesco) is 0#">
	  and inverso is not null
</cfquery>

<cfif Len(inverso.inverso)>
	<cfquery datasource="#session.dsn#" name="ya_es_pariente">
		select sujeto from sa_pariente
		where sujeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pariente#">
		  and pariente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
	</cfquery>
	<cfif Len(ya_es_pariente.sujeto)>
		<cfquery datasource="#session.DSN#">
			update sa_pariente
			set id_parentesco = 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#inverso.inverso#">
			where sujeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pariente#">
			  and pariente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.DSN#">
			insert into sa_pariente (
				sujeto, pariente, id_parentesco,
				CEcodigo, Ecodigo, BMfechamod, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pariente#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#inverso.inverso#">, 
				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> )
		</cfquery>
	</cfif>
</cfif>

</cftransaction>


<cflocation url="familiares.cfm?id_persona=#URLEncodedFormat(form.id_persona)#">