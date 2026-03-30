
<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 13-2-2006.
		Motivo: se desencripta la contrasea, se pasa a binario y de binario a hexadecimal como lo pidieron en Ricardo Prez.
 --->

<!--- NO SUBIR!!! Gustavo Fonseca!!!--->
<cfset LvarAlgoritmo = 'AES'>
<cfset password = url.pass>

<cfset LvarPassword = decrypt(trim(password),'gE1/S/pwxkjLcTwjV4t6rQ==',LvarAlgoritmo,'Hex')>
El password es:<cfoutput>#LvarPassword#</cfoutput>
<cfabort>



<cfsetting enablecfoutputonly="yes" showdebugoutput="no">
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	sessiontimeout=#CreateTimeSpan(0,0,0,5)#>
<cfheader name = "Expires" value = "0">
<cfinclude template="/home/check/dominio.cfm">

<cfparam name="url.emp" default="">
<cfparam name="url.user">
<cfparam name="url.pass">
<cfparam name="url.ecodigosdc" default="">

<cfset Usucodigo_Autenticado = 0>
<cfset status = 0>

<cfif IsDefined("url.user") AND IsDefined("url.pass") And Len(url.user) NEQ 0 and Len(url.pass) NEQ 0>
					
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

	<cfparam name="url.emp" default="">
	
	<!--- validar usuario solamente si no es autoafiliado --->
	<cfset Usucodigo_Autenticado = sec.buscarUsuarioGlobal(url.emp, url.user)>
	<cfset AUTHBACKEND = sec.autenticarUsucodigo(Usucodigo_Autenticado, url.pass)>
	<cfif Len(AUTHBACKEND)>
		
		<cfset info_usuario = sec.infoUsuario("", "", Usucodigo_Autenticado)>

		<cfinvoke component="home.Componentes.aspmonitor" method="ValidarSiSePuedeIniciarSesion">
			<cfinvokeargument name="Usucodigo" value="#info_usuario.Usucodigo#">
		</cfinvoke>

		<cfquery name="rsUsuario" datasource="asp">
			select 
				a.Usucodigo, 
				a.Usulogin,
				a.datos_personales,
				a.Utemporal,
				a.CEcodigo,
				b.CEnombre, a.LOCIdioma, a.Usurespuesta
			from Usuario a
			join CuentaEmpresarial b
			  on a.CEcodigo = b.CEcodigo
			where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#info_usuario.Usucodigo#">
		</cfquery>

		<cfif len(rsUsuario.Usucodigo) EQ 0>
			<cfset sec.login_incorrecto(info_usuario.CEcodigo, "",
				info_usuario.Usulogin, "Usuario no existe")>
			<cfset status = 0>
			<cfset Usucodigo_Autenticado = 0>Usuario no existe
		<cfelse>
			<cfquery name="empresas" datasource="asp">
				select distinct e.Ecodigo, e.Enombre, e.Ereferencia, c.Ccache
				from vUsuarioProcesos up
					join Empresa e
						on e.Ecodigo = up.Ecodigo
					join Caches c
						on c.Cid = e.Cid
				where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#info_usuario.Usucodigo#">
				  and up.SScodigo = 'SIF' 
				  and up.SMcodigo = 'PUNTOVENTA' 
				  <cfif Len(url.ecodigosdc)>
				  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ecodigosdc#" >
				  </cfif>
				  <!---and up.SPcodigo = 'PVCACAJAS'--->
			</cfquery>
			<cfif empresas.RecordCount EQ 0>
				<cfset status = 0>
			<cfelseif empresas.RecordCount EQ 1>
				<cfset status = 1>
				<cfquery datasource="#empresas.Ccache#" name="conexion">
					select FAlogin, FAcontrasena, BaseDatos, Servidor
					from FAUsuario
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresas.Ereferencia#">
				</cfquery>
			<cfelse>
				<cfset status = 2>
			</cfif>
		</cfif>
	<cfelse>
		<cfset status = 0>
		<cfset Usucodigo_Autenticado = 0> Sin autenticar
	</cfif>
</cfif>

<cfset LvarAlgoritmo = 'AES'>

<cffunction name="DesEncriptar" returntype="string">
	<cfargument  type="string" name="password" required="yes">
	
	<cfset passAct = Mid(password, 5, len(password))>	<!--- Se elimina el prefijo 'HEX/' --->
	<cfset newPass = ''>
	<!--- <cfset xx = decrypt(trim(password),'gE1/S/pwxkjLcTwjV4t6rQ==',LvarAlgoritmo,'Hex')>
	<cfset x2 = CharsetDecode(decrypt(trim(password),'gE1/S/pwxkjLcTwjV4t6rQ==',LvarAlgoritmo,'Hex'), 'utf-8')>
	<cfset x3 = BinaryEncode(CharsetDecode(decrypt(trim(password),'gE1/S/pwxkjLcTwjV4t6rQ==',LvarAlgoritmo,'Hex'), 'utf-8'),'Hex')> --->
	
<!--- 	<cfdump var="#password#  555">  <br>
	<cfdump var="#passAct#  777">  <br> --->
<!--- 	<cfdump var="#xx#"><br />
	<cfdump var="#x2#"><br />
	<cfdump var="#x3#"><br /> --->

	<cfset newPass = CharsetEncode(BinaryDecode(decrypt(passAct,'gE1/S/pwxkjLcTwjV4t6rQ==',LvarAlgoritmo, 'utf-8'),'Hex'),'utf-8')> 
	<!--- <cfset newPass = '0x' & BinaryEncode(CharsetDecode(decrypt(trim(password),'gE1/S/pwxkjLcTwjV4t6rQ==',LvarAlgoritmo,'Hex'), 'utf-8'),'Hex')> --->
	<cfreturn newPass>	
</cffunction>

<cfcontent type="text/xml">
<cfoutput><?xml version="1.0" encoding="iso-8859-1"?>
<resultado>
	<status>#status#</status>
	<usucodigo>#NumberFormat(Usucodigo_Autenticado,'0')#</usucodigo>
	<empresas><cfif IsDefined('empresas')>
		<cfloop query="empresas">
		<empresa>
			<ecodigo>#XMLFormat(NumberFormat(Ereferencia,'0'))#</ecodigo>
			<ecodigosdc>#XMLFormat(NumberFormat(Ecodigo,'0'))#</ecodigosdc>
			<nombre>#XMLFormat(Enombre)#</nombre>
		</empresa></cfloop></cfif>
	</empresas>
	<conexion><cfif status eq 1>
		<usuario>#XMLFormat(Trim(conexion.FAlogin))#</usuario>
		<password>#XMLFormat(Trim(DesEncriptar(conexion.FAcontrasena)))#</password>
		<servidor>#XMLFormat(Trim(conexion.Servidor))#</servidor>
		<basedatos>#XMLFormat(Trim(conexion.BaseDatos))#</basedatos></cfif>
	</conexion>
</resultado>
</cfoutput>
<!--- <password>#XMLFormat(Trim(conexion.FAcontrasena))#</password> --->
