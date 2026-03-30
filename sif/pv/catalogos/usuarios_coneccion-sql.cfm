<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 13-2-2006.
		Motivo: se Encripta la contraseña en hexadecimal como lo pidieron en Ricardo Pérez.
 --->

<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FAUsuario"
		redirect="usuarios_coneccion.cfm"
		timestamp="#form.ts_rversion#"
	
		field1="Ecodigo"
		type1="numeric"
		value1="#form.EcodUsu#">
	
	<cfif IsDefined("form.FAcontrasena") and form.FAcontrasena NEQ '' and form.FAcontrasena NEQ form.ClaveActual>
		<!--- Funcion para encriptar la clave 	--->
		<cfset clave = Encriptar(Form.FAcontrasena) > 
		<cfquery name="update" datasource="#session.dsn#">
			update FAUsuario set
				FAlogin = <cfqueryparam value="#Form.FAlogin#" cfsqltype="cf_sql_varchar">,
				FAcontrasena = <cfqueryparam value="#clave#" cfsqltype="cf_sql_varchar">,
				BaseDatos = <cfqueryparam value="#form.BaseDatos#" cfsqltype="cf_sql_char">,
				Servidor = <cfqueryparam value="#Form.Servidor#" cfsqltype="cf_sql_char">,
				BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where Ecodigo = <cfqueryparam value="#form.EcodUsu#" cfsqltype = "cf_sql_numeric"> 
		</cfquery> 
	<cfelse>
		<cfquery name="update" datasource="#session.dsn#">
			update FAUsuario set
				FAlogin = <cfqueryparam value="#Form.FAlogin#" cfsqltype="cf_sql_varchar">,
				BaseDatos = <cfqueryparam value="#form.BaseDatos#" cfsqltype="cf_sql_char">,
				Servidor = <cfqueryparam value="#Form.Servidor#" cfsqltype="cf_sql_char">,
				BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
			where Ecodigo = <cfqueryparam value="#form.EcodUsu#" cfsqltype = "cf_sql_numeric"> 
		</cfquery> 	
	</cfif>

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
	   	 delete from FAUsuario
	  	 where Ecodigo = <cfqueryparam value="#form.EcodUsu#" cfsqltype = "cf_sql_numeric"> 
	</cfquery>
 	
<cfelseif IsDefined("form.Alta")>
	<!--- Funcion para encriptar la clave 	--->
	<cfset clave = Encriptar(Form.FAcontrasena) > 
	
 	<cfquery datasource="#session.dsn#">
		insert into FAUsuario( Ecodigo, FAlogin, FAcontrasena, BaseDatos, Servidor, BMUsucodigo,Fecha)
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value = "#form.FAlogin#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value = "#clave#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#session.dsn#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.Servidor#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>	
</cfif>

<form action="usuarios_coneccion.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="EcodUsu" type="hidden" value="#form.EcodUsu#"> 	
		</cfif>

		<cfif isdefined('form.FAlogin_F') and len(trim(form.FAlogin_F))>
			<input type="hidden" name="FAlogin_F" value="#form.FAlogin_F#">	
		</cfif>
				
	</cfoutput>
</form>


<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>




<cffunction name="Encriptar" returntype="string">
	<cfargument  type="string" name="password" required="yes">
	<cfset newPass = ''>
	<cfset LvarAlgoritmo = 'AES'>
	<cfset newPass =  encrypt((password),'gE1/S/pwxkjLcTwjV4t6rQ==',LvarAlgoritmo,'Hex')>
	<cfreturn newPass>	
</cffunction>  
