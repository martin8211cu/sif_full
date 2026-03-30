
<cfparam	name="Attributes.idcuenta"			type="string"	default="">						<!--- Id de Cuenta --->
<cfparam	name="Attributes.idpersona"			type="string"	default="">						<!--- Id del usuario--->
<cfparam	name="Attributes.idcontrato"		type="string"	default="">						<!--- Id del contrato actual --->
<cfparam	name="Attributes.idlogin"			type="string"	default="">						<!--- Id del login actual --->
<cfparam	name="Attributes.user"				type="string"	default="">						<!--- login(usuario) del login actual --->
<cfparam	name="Attributes.rol"				type="string"	default="">						<!--- rol del usuario actual --->
<cfparam	name="Attributes.mens"				type="string"	default="">						<!--- integer que designa un tipo de mensaje definido --->
<cfparam	name="Attributes.forwardIra"		type="string"	default="">						<!--- obligatorio es el atributo "ira" de la lista que esta en el paso de cambio de forwarding --->
<cfparam 	name="Attributes.form" 				type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.alignEtiquetas" 	type="string"	default="right">				<!--- alineación de etiquetas --->
<cfparam 	name="Attributes.paso" 				type="integer"	default="1">					<!--- paso para la creación de cuentas --->
<cfparam 	name="Attributes.vista" 			type="integer"	default="1">					<!--- para definir el conjunto de condiciones para el pintado de la venta de servicios --->
<cfparam 	name="Attributes.Ecodigo" 			type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 			type="string"	default="#session.DSN#">		<!--- cache de conexión --->
<cfparam 	name="Attributes.sufijo" 			type="string"	default="">						<!--- sufijo por si se usa mas de una vez el tag en alguna pantalla --->
<cfparam 	name="Attributes.cl" 				type="string"	default="">						<!--- Clave nueva despues de un reset de clave por parte del DAS --->
<cfparam 	name="Attributes.permiteTel"		type="boolean"	default="true">					<!--- El paquete permite o no telefono --->

<cfset LoginBloqueado = false>
<cfset LoginInactivo = false>
<cfset LoginSinServicios = false>
<cfset PasswordProbicional = "">
<cfset ExisteSobre = false>
<cfset ExisteMail = true>
<cfset ExisteACCS = true>
	
<cfif Attributes.mens EQ 1 or Attributes.mens EQ 3 and Attributes.rol EQ 'DAS'> <!---revisa si se realizó un Reset de password por parte de DAS para un cliente--->	
	<cfif len(trim(Attributes.cl))>
		<cfset PasswordProbicional = Attributes.cl>					
	</cfif>
</cfif>

<cfquery name="rsLogActivo" datasource="#session.DSN#">							<!---Revisa que el login este activo--->
	select LGnumero
	from ISBlogin
	where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idlogin#">
	and Habilitado=1
</cfquery>
<cfif rsLogActivo.recordCount EQ 0>
	<cfset LoginInactivo = True>
</cfif>

<cfquery datasource="#Attributes.Conexion#" name="rsEstadoLogin">				<!---revisa que el login no posea motivos de bloqueo--->	
	select 	count(1) as bloqueado from 	ISBlogin 
	where 	LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idlogin#"> 
	and LGbloqueado = 1
</cfquery>
<cfif rsEstadoLogin.bloqueado GT 0>
	<cfset LoginBloqueado = true>
</cfif>

<cfif not LoginBloqueado and not LoginInactivo>
	<cfquery name="rsServicios" datasource="#session.DSN#">						<!---Revisa que el login posea servicios asociados--->
		select distinct  c.LGnumero,c.TScodigo   
		from ISBserviciosLogin c
		where c.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idlogin#">
		and c.Habilitado=1
	</cfquery>
	
	<cfif rsServicios.recordCount EQ 0>
		<cfset LoginSinServicios = true>
	
	<cfelse>
		<cfset lisServ = valueList(rsServicios.TScodigo)>						
		<cfif listFind(lisServ,"MAIL",',') EQ 0>								<!---Valida si el login posee un servicio MAIL--->
			<cfset ExisteMail = false>
		</cfif>
		<cfif listFind(lisServ,"ACCS",',') EQ 0>								<!---Valida si el login posee un servicio ACCS--->
			<cfset ExisteACCS = false>
		</cfif>		
	</cfif>
	
	<!---<cfquery datasource="#Attributes.Conexion#" name="rsSobre">			<!---revisa si el login posee un sobre asignado--->	
		select 	Snumero from ISBlogin 
		where 	LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idlogin#"> 
		and Habilitado = 1
	</cfquery>
	<cfif isdefined("rsSobre.Snumero") and len(trim(rsSobre.Snumero))>
		<cfset ExisteSobre = true>
	</cfif>--->
</cfif>

<cfset mensArr = ArrayNew(1)>													<!--- Arreglo de mensajes de error o exito --->
<cfset a = ArraySet(mensArr, 1,20, "")>
<cfset mensArr[1] = "EL password ha sido modificado con exito">
<cfset mensArr[2] = "Error: No se ha modificado con &eacute;xito, es posible que el password anterior no sea correcto">
<cfset mensArr[3] = "EL password ha sido modificado globalmente con exito">
<cfset mensArr[4] = "El login actual no posee servicios asociados">
<cfset mensArr[5] = "El login se encuentra bloqueado">
<cfset mensArr[6] = "Restablecer el password seg&uacute;n el servicio al que corresponde">
<cfset mensArr[7] = "Restablecer los passwords para todos los servicios que posee el login actual.">
<cfset mensArr[8] = "NOTA: vigente por un d&iacute;a">
<cfset mensArr[9] = "El login actual se encuentra inactivo">
<cfset mensArr[10] = "El login actual no posee sobre asociado">
<cfset mensArr[11] = "Restablecer el sobre asociado al login">
<cfset mensArr[12] = "Se ha restablecido el nuevo sobre con &eacute;xito">
<cfset mensArr[13] = "Error: no se logro restablecer el nuevo sobre con &eacute;xito">
<cfset mensArr[14] = "El login actual no posee servicios de tipo MAIL.">
<cfset mensArr[15] = "El login actual no posee servicios de tipo Acceso Conmutado.">
<cfset mensArr[16] = "El Paquete no tiene Restricci&oacute;n de Movilidad.">

<cfset mensArr[17] = "El Sobre no está disponible">
<cfset mensArr[18] = "El Sobre no cuenta con las claves para todos los servicios requeridos del Login">
<cfset mensArr[19] = "El Sobre no está asignado al Agente Genérico">

<!---FALTA VALIDAR QUE EL LOGIN NO ESA REPETIDO EN LA PARTE INFERIOR--->
<cfset ExisteLog = (isdefined("Attributes.idlogin") and Len(Trim(Attributes.idlogin)))>
<cfif not ExisteLog>
	<cfthrow message="Error: el id del Login es obligatorio.">
</cfif>

<cfif not LoginInactivo>
	
	<cfswitch expression="#Attributes.paso#">
			
			<!--- Datos del login --->
			<cfcase value="0">
				<cfinclude template="gestion-login-datos.cfm">
			</cfcase>
			
			<!--- Cambio de Login --->
			<cfcase value="1">
				<cfinclude template="gestion-login-name.cfm">
			</cfcase>
		
			<!--- Cambio de Telefono --->
			<cfcase value="2">
				<cfinclude template="gestion-login-telefono.cfm">
			</cfcase>
			
			<!---Cambio de RealName --->
			<cfcase value="3">
				<cfinclude template="gestion-login-realName.cfm">
			</cfcase>
		
			<!--- Cambio de Password por Servicio--->	
			<cfcase value="4">
				<cfinclude template="gestion-login-pass-serv.cfm">
			</cfcase>
			
			<!--- Cambio de Password Global --->
			<cfcase value="5">
				<cfinclude template="gestion-login-pass-global.cfm">
			</cfcase>
		
			<!--- Cambio de Forwarding  --->
			<cfcase value="6">
				<cfinclude template="gestion-login-forwarding.cfm">
			</cfcase>
			
			<!--- Cambio de Password por Sobre --->
			<cfcase value="7">
				<cfif len(trim(Attributes.rol)) and Attributes.rol EQ "DAS">
					<cfinclude template="gestion-login-sobre.cfm">
				<cfelse>
					&nbsp;
				</cfif>
			</cfcase>
			
			<!--- Bloqueo de Login  --->
			<cfcase value="8">
				<cfinclude template="gestion-login-bloqueoLog.cfm">
			</cfcase>
			
			<!--- Retiro de Login  --->
			<cfcase value="9">
				<cfif len(trim(Attributes.rol)) and Attributes.rol EQ "DAS">
					<cfinclude template="gestion-login-retiro.cfm">
				<cfelse>
					&nbsp;
				</cfif>
			</cfcase>
			
			<!--- Consulta de bitacora de Login  --->
			<cfcase value="10">
				<cfinclude template="gestion-login-bitacora-lista.cfm">				
			</cfcase>
						
			<cfdefaultcase>
				&nbsp;
			</cfdefaultcase>
		</cfswitch>	
<cfelse>
	<cf_web_portlet_start tipo="Box">
		<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr><td align="center">
				<label style="color:##660000">
					<cfoutput>
						<cfif LoginInactivo>#mensArr[9]#
						<cfelseif LoginBloqueado> #mensArr[5]#
						</cfif>
					</cfoutput>
				</label>
			</td></tr>
		</table>
	<cf_web_portlet_end> 	
</cfif>			
