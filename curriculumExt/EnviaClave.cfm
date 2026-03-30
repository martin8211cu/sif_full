<!--- Primero genera el nuevo password --->
<cfquery name="rs_cedula" datasource="#Session.datasource#">
	select  ltrim(rtrim(RHOidentificacion)) as RHOidentificacion  from DatosOferentes
	where ltrim(rtrim(RHOemail)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Correo)#">
</cfquery>

<cfset  valid_password_chars = "bcdfgkmnpqrstvwx234789">
<cfset  nuevo_password = __randomString(6, valid_password_chars)>
<cfset This.HashMethod = "MD5">
<cfset new_salt = "MCSOIN">
<cfset HashCFC = createObject("component","Hash") />
<cfset new_hash = HashCFC.hashPassword("#This.HashMethod#","#nuevo_password#","#rs_cedula.RHOidentificacion#","-1","#new_salt#")>
<!--- segundo actualiza el nuevo password en la tabla --->
<cfquery name="update_password" datasource="#Session.datasource#">
	update DatosOferentes
	set  RHPassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hash#">
	where ltrim(rtrim(RHOemail)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Correo)#">
</cfquery>	
<!--- tercero contruye y envia el correo con la nueva contraseña--->
<cfquery name="RS_user_datos_personales" datasource="#Session.datasource#">
	select RHOnombre ,RHOapellido1 ,RHOapellido2 from DatosOferentes
	where ltrim(rtrim(RHOemail)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Correo)#">
</cfquery>	

<cfset  hostname = session.sitio.host>
<cfsavecontent variable="_mail_body">
	<cfset _password = nuevo_password>
	<cfinclude template="mailbody.cfm">
	<cfset _password = "">
</cfsavecontent>

<cfquery datasource="asp">
	insert into SMTPQueue (
		SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
	values (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="gestion@soin.co.cr">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Correo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="Nueva contraseña">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#_mail_body#">, 1)
</cfquery>


<cfset session.Estado = "4">
<cflocation  url="index.cfm"  addtoken="no">	

<cffunction name="__randomString" access="public" returntype="string" output="false">
	<cfargument name="size" type="numeric" required="yes">
	<cfargument name="validChars" type="string" required="no"
		default="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789">
	
	<cfset var SALT_DIGITS = validChars.toCharArray()>
	<cfset ch = "">
	<cfloop from="1" to="#Arguments.size#" index="n">
		<cfset ch = ch & SALT_DIGITS[Rand() * ArrayLen(SALT_DIGITS) + 1] >
	</cfloop>
	<cfreturn ch>
</cffunction>


