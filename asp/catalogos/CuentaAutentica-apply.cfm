<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>

<cfif StructKeyExists(form, 'submit-sess')>

	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "sesion.duracion.default", form.sesion_duracion_default)>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "sesion.duracion.min",     form.sesion_duracion_min)>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "sesion.duracion.max",     form.sesion_duracion_max)>
	
	<cfparam name="form.sesion_duracion_modo" default="1">
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "sesion.duracion.modo",    form.sesion_duracion_modo)>
	
	<cfparam name="form.sesion_multiple" default="1">
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "sesion.multiple",         form.sesion_multiple)>
	
	<cfparam name="form.auth_orden" default="asp">
	<cfparam name="form.auth_validar_ip" default="0">
	<cfparam name="form.auth_validar_horario" default="0">
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "auth.orden",     form.auth_orden)>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "auth.nuevo",     form.auth_nuevo)>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "auth.validar.ip",  form.auth_validar_ip)>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "auth.validar.horario",  form.auth_validar_horario)>
	<cflocation url="CuentaAutentica.cfm?tab=sess" addtoken="no">
</cfif>

<cfif StructKeyExists(form, 'submit-pass') or StructKeyExists(form, 'submit-passtest')>

	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "pass.expira.default", form.pass_expira_default)>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "pass.expira.min",     form.pass_expira_min)>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "pass.expira.max",     form.pass_expira_max)>
	
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "sesion.bloqueo.cant",     form.sesion_bloqueo_cant)>
	<cfif form.sesion_bloqueo_reactivar is 1>
		<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "sesion.bloqueo.duracion", '0')>
	<cfelse>
		<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "sesion.bloqueo.duracion", form.sesion_bloqueo_duracion)>
	</cfif>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "sesion.bloqueo.periodo",  form.sesion_bloqueo_periodo)>
	
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "user.long.min",       form.user_long_min)>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "user.long.max",       form.user_long_max)>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "pass.long.min",       form.pass_long_min)>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "pass.long.max",       form.pass_long_max)>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "user.valid.chars",   form.user_valid_chars)>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "pass.valida.letras",  iif(isdefined('form.pass_valida_letras'),1,0))>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "pass.valida.digitos", iif(isdefined('form.pass_valida_digitos'),1,0))>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "pass.valida.simbolos",iif(isdefined('form.pass_valida_simbolos'),1,0))>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "user.valida.letras",  iif(isdefined('form.user_valida_letras'),1,0))>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "user.valida.digitos", iif(isdefined('form.user_valida_digitos'),1,0))>
        
	<cfif isdefined('form.pass_valida_lista_0')>
		<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "pass.valida.lista",   form.pass_valida_lista)>
	<cfelse>
		<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "pass.valida.lista",   0)>
	</cfif>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "pass.valida.usuario",     iif(isdefined('form.pass_valida_usuario'),1,0))>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "pass.valida.diccionario", iif(isdefined('form.pass_valida_diccionario'),1,0))>

	<cfif StructKeyExists(form, 'submit-passtest')>
		<cflocation url="CuentaAutentica.cfm?tab=pass&test=yes" addtoken="no">
	<cfelse>
		<cflocation url="CuentaAutentica.cfm?tab=pass" addtoken="no">
	</cfif>
</cfif>
<!---
<cfif StructKeyExists(form, 'submit-serv')>
	<cfif form.monitor_historia_auto is 0>
		<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "monitor.historia", '0')>
	<cfelse>
		<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "monitor.historia", form.monitor_historia)>
	</cfif>
	
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "correo.cuenta", form.correo_cuenta)>
	
	<cfparam name="form.servidor_principal" default="">
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "servidor.principal",   form.servidor_principal)>
	<cflocation url="CuentaAutentica.cfm?tab=serv" addtoken="no">
</cfif>

<cfif StructKeyExists(form, 'submit-demo')>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "demo.vigencia",       		form.demo_vigencia)>
	<cfif isdefined("form.demo_CuentaEmpresarial")>
		<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "demo.CuentaEmpresarial", form.demo_CuentaEmpresarial)>
	</cfif>
	<cfif isdefined("form.demo_cache")>
		<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "demo.cache", form.demo_cache)>
	</cfif>
	<cflocation url="CuentaAutentica.cfm?tab=demo" addtoken="no">
</cfif>
--->
<cfif StructKeyExists(form, 'submit-ldap')>
	
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "ldap.adminDN",   form.ldap_adminDN)>
	<cfif Len(Trim(form.ldap_adminPass)) and (form.ldap_adminPass Neq '**secret**')>
		<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "ldap.adminPass", form.ldap_adminPass)>
	</cfif>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "ldap.baseDN",    form.ldap_baseDN)>
	<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "ldap.port",      form.ldap_port)>
	<cfif Len(form.ldap_server)>
		<cfset Politicas.modifica_parametro_cuenta(Session.Progreso.CEcodigo, "ldap.server",    form.ldap_server)>
	</cfif>
	<cflocation url="CuentaAutentica.cfm?tab=ldap" addtoken="no">
</cfif>

<cfif StructKeyExists(form, 'submit-acceso') Or StructKeyExists(form, 'eliminar-acceso')>
	<cfinclude template="AccesoRemoto-apply.cfm">
</cfif>

<cflocation url="CuentaAutentica.cfm" addtoken="no">
