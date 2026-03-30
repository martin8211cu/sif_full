<cfif IsDefined("Form.Guardar")>
	<!--- Inicia el proceso de validación --->
	<cfset NoHayErrores = true>
	<cfif isdefined("form.finalVerify") and len(trim(form.finalVerify)) and form.finalVerify neq session.finalVerify>
		código de verificación erroneo
		<cfset NoHayErrores = false>
	</cfif>
	<cfquery name="rsvalidacorreo" datasource="#session.datasource#">
		select RHOid from DatosOferentes
		where  RHOemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Correo#">
	</cfquery>
	<cfquery name="rsvalidauser" datasource="#session.datasource#">
		select RHOid from DatosOferentes
		where NTIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.NTIcodigo#">
		and RHOidentificacion =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cedula#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>
	
	<cfif rsvalidacorreo.recordCount GT 0>
		<cfset session.Estado = "6">
		<cfset NoHayErrores = false>
	</cfif>
	<cfif rsvalidauser.recordCount GT 0>
		<cfset session.Estado = "7">
		<cfset NoHayErrores = false>
	</cfif>
	<cfif rsvalidacorreo.recordCount GT 0 and rsvalidauser.recordCount GT 0>
		<cfset session.Estado = "8">
		<cfset NoHayErrores = false>
	</cfif>
	
	<cfif NoHayErrores>
		<!--- Encryptar password --->
		<cfset This.HashMethod = "MD5">
		<cfset new_salt = "MCSOIN">
		<cfset HashCFC = createObject("component","Hash") />
		<cfset new_hash = HashCFC.hashPassword("#This.HashMethod#","#form.clave#","#form.Cedula#","-1","#new_salt#")>
		<cftransaction>
			<cfquery name="ABC_datosOferente" datasource="#Session.datasource#">
				insert into DatosOferentes 
				(	Ecodigo, 
					NTIcodigo, 
					RHOidentificacion, 
					RHOnombre,
					RHOapellido1,
					RHOapellido2, 
					RHOemail,
					RHOcivil,
					RHOsexo,
					RHPassword,
					RHPregunta,
					RHRespuesta,
					RHAprobado,
					RHAutentificar
				)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cedula#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Apellido1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Apellido2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Correo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOcivil#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHOsexo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hash#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Pregunta#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Respuesta#">,
					0,0
					)
			</cfquery>
			<cfquery name="RS_user_datos_personales" datasource="#Session.datasource#">
				select RHOnombre ,RHOapellido1 ,RHOapellido2 from DatosOferentes
				where ltrim(rtrim(RHOemail)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Correo)#">
			</cfquery>	

			<cfset  hostname = session.sitio.host>
			<cfsavecontent variable="_mail_body">
				<cfset _password = form.clave>
				<cfset authentication = new_hash>
				<cfinclude template="mailbody2.cfm">
				<cfset _password = "">
				<cfset authentication = "">
			</cfsavecontent>
	</cftransaction>		
	
	<!--- Toma el correo remitente desde las politicas del portal--->
	<cfset FromEmail= "CurriculumExterno@soin.co.cr">
	<cfquery name="CuentaPortal"   datasource="asp">
		Select valor
		from  PGlobal
		Where parametro='correo.cuenta'
	</cfquery>
	<cfif isdefined('CuentaPortal') and CuentaPortal.Recordcount GT 0>
		<cfset FromEmail = CuentaPortal.valor>
	</cfif>	
	
	<cfquery datasource="asp">
		insert into SMTPQueue (
			SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
		values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(FromEmail)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Correo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="Registro">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#_mail_body#">, 1)
	</cfquery>			
			
		
		<cfset session.Estado = "1">
		<cflocation  url="index.cfm"  addtoken="no">	
	<cfelse>
		<form action="index.cfm" method="post" name="sql">
			<input name="NTIcodigo" 	type="hidden" value="<cfif isdefined("form.NTIcodigo")><cfoutput>#form.NTIcodigo#</cfoutput></cfif>">
			<input name="Cedula"    	type="hidden" value="<cfif isdefined("form.Cedula")><cfoutput>#form.Cedula#</cfoutput></cfif>">
			<input name="Correo"    	type="hidden" value="<cfif isdefined("form.Correo")><cfoutput>#form.Correo#</cfoutput></cfif>">
			<input name="Nombre"    	type="hidden" value="<cfif isdefined("form.Nombre")><cfoutput>#form.Nombre#</cfoutput></cfif>">
			<input name="Apellido1"     type="hidden" value="<cfif isdefined("form.Apellido1")><cfoutput>#form.Apellido1#</cfoutput></cfif>">
			<input name="Apellido2"     type="hidden" value="<cfif isdefined("form.Apellido2")><cfoutput>#form.Apellido2#</cfoutput></cfif>">
			<input name="RHOcivil"    	type="hidden" value="<cfif isdefined("form.RHOcivil")><cfoutput>#form.RHOcivil#</cfoutput></cfif>">
			<input name="RHOsexo"    	type="hidden" value="<cfif isdefined("form.RHOsexo")><cfoutput>#form.RHOsexo#</cfoutput></cfif>">
			<input name="Pregunta"    	type="hidden" value="<cfif isdefined("form.Pregunta")><cfoutput>#form.Pregunta#</cfoutput></cfif>">
			<input name="Respuesta"    	type="hidden" value="<cfif isdefined("form.Respuesta")><cfoutput>#form.Respuesta#</cfoutput></cfif>">
			<input name="txtRegistrar"  type="hidden" value="">
		</form>		
		<HTML>
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
		<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
		</body>
		</HTML>
	</cfif>
<cfelseif IsDefined("Form.Cambiar")>
	<cfquery name="rs_cedula" datasource="#Session.datasource#">
		select  ltrim(rtrim(RHOidentificacion)) as RHOidentificacion  from DatosOferentes
		where ltrim(rtrim(RHOemail)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Correo)#">
	</cfquery>
	<cfif rs_cedula.recordCount eq 0>
		<cfset session.Estado = "3">
		<cflocation  url="index.cfm"  addtoken="no">	
	</cfif>
	<cfset This.HashMethod = "MD5">
	<cfset new_salt = "MCSOIN">
	<cfset HashCFC = createObject("component","Hash") />
	<cfset Actua_hash = HashCFC.hashPassword("#This.HashMethod#","#form.clave1#","#rs_cedula.RHOidentificacion#","-1","#new_salt#")>
	<cfset new_hash   = HashCFC.hashPassword("#This.HashMethod#","#form.clave2#","#rs_cedula.RHOidentificacion#","-1","#new_salt#")>
	
	<cfquery name="valida_usuario" datasource="#Session.datasource#">
		select  RHOid,Ecodigo from DatosOferentes
		where RHPassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Actua_hash#">
		and RHOemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Correo#">
	</cfquery>	
	<cfif valida_usuario.recordCount GT 0>
		<cftransaction>
			<cfquery name="Update_datosOferente" datasource="#Session.datasource#">
				update DatosOferentes set RHPassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hash#">
				where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valida_usuario.RHOid#">
				and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#valida_usuario.Ecodigo#">
			</cfquery> 
		</cftransaction>
		<cfquery name="valida_datosOferente2" datasource="#Session.datasource#">
			select  RHPassword from DatosOferentes
				where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valida_usuario.RHOid#">
				and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#valida_usuario.Ecodigo#">
		</cfquery>
		<cfset session.Estado = "2">
		<cflocation  url="index.cfm"  addtoken="no">	
	<cfelse>
		<cfset session.Estado = "3">
		<cflocation  url="index.cfm"  addtoken="no">	

	</cfif>
</cfif>




