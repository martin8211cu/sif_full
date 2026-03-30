<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>

<cfif StructKeyExists(form, 'check-password')>
	<cfset data = Politicas.trae_parametros_globales()>
	<cfinclude template="/asp/admin/politicas/global/check.cfm">
	<cfabort>
</cfif>

<cfif StructKeyExists(form, 'submit-sess')>

	<cfset Politicas.modifica_parametro_global("sesion.duracion.default", form.sesion_duracion_default)>
	<cfset Politicas.modifica_parametro_global("sesion.duracion.min",     form.sesion_duracion_min)>
	<cfset Politicas.modifica_parametro_global("sesion.duracion.max",     form.sesion_duracion_max)>
	
	<cfparam name="form.sesion_duracion_modo" default="1">
	<cfset Politicas.modifica_parametro_global("sesion.duracion.modo",    form.sesion_duracion_modo)>
	
	<cfparam name="form.sesion_multiple" default="1">
	<cfparam name="form.monitor_habilitar" default="1">
	<cfset Politicas.modifica_parametro_global("sesion.multiple",         form.sesion_multiple)>
	<cfset Politicas.modifica_parametro_global("monitor.habilitar",         form.monitor_habilitar)>
	
	<cfparam name="form.auth_orden" default="asp">
	<cfset Politicas.modifica_parametro_global("auth.orden",     form.auth_orden)>
	<cfset Politicas.modifica_parametro_global("auth.nuevo",     form.auth_nuevo)>
	<cflocation url="index.cfm?tab=sess" addtoken="no">
</cfif>

<cfif StructKeyExists(form, 'submit-pass') or StructKeyExists(form, 'submit-passtest')>

	<cfset Politicas.modifica_parametro_global("pass.expira.default", form.pass_expira_default)>
	<cfset Politicas.modifica_parametro_global("pass.expira.recordatorio", form.pass_expira_recordatorio)>
	<cfset Politicas.modifica_parametro_global("pass.expira.min",     form.pass_expira_min)>
	<cfset Politicas.modifica_parametro_global("pass.expira.max",     form.pass_expira_max)>
	
	<cfset Politicas.modifica_parametro_global("sesion.bloqueo.cant",     form.sesion_bloqueo_cant)>
	<cfif form.sesion_bloqueo_reactivar is 1>
		<cfset Politicas.modifica_parametro_global("sesion.bloqueo.duracion", '0')>
	<cfelse>
		<cfset Politicas.modifica_parametro_global("sesion.bloqueo.duracion", form.sesion_bloqueo_duracion)>
	</cfif>
	<cfset Politicas.modifica_parametro_global("sesion.bloqueo.periodo",  form.sesion_bloqueo_periodo)>
	
	<cfset Politicas.modifica_parametro_global("user.long.min",       form.user_long_min)>
	<cfset Politicas.modifica_parametro_global("user.long.max",       form.user_long_max)>
	<cfset Politicas.modifica_parametro_global("pass.long.min",       form.pass_long_min)>
	<cfset Politicas.modifica_parametro_global("pass.long.max",       form.pass_long_max)>
	<cfset Politicas.modifica_parametro_global("user.valid.chars",   form.user_valid_chars)>
	<cfset Politicas.modifica_parametro_global("pass.valida.letras",  iif(isdefined('form.pass_valida_letras'),1,0))>
	<cfset Politicas.modifica_parametro_global("pass.valida.digitos", iif(isdefined('form.pass_valida_digitos'),1,0))>
	<cfset Politicas.modifica_parametro_global("pass.valida.simbolos",iif(isdefined('form.pass_valida_simbolos'),1,0))>
    <cfset Politicas.modifica_parametro_global("user.valida.letras",  iif(isdefined('form.user_valida_letras'),1,0))>
	<cfset Politicas.modifica_parametro_global("user.valida.digitos", iif(isdefined('form.user_valida_digitos'),1,0))>
    
	<cfif isdefined('form.pass_valida_lista_0')>
		<cfset Politicas.modifica_parametro_global("pass.valida.lista",   form.pass_valida_lista)>
	<cfelse>
		<cfset Politicas.modifica_parametro_global("pass.valida.lista",   0)>
	</cfif>
	<cfset Politicas.modifica_parametro_global("pass.valida.usuario",     iif(isdefined('form.pass_valida_usuario'),1,0))>
	<cfset Politicas.modifica_parametro_global("pass.valida.diccionario", iif(isdefined('form.pass_valida_diccionario'),1,0))>

	<cfif isdefined('form.pass_mail_cambiar')>
		<cfset Politicas.modifica_parametro_global("pass.mail.cambiar",   1)>
	<cfelse>
		<cfset Politicas.modifica_parametro_global("pass.mail.cambiar",   0)>
	</cfif>

	<cfif StructKeyExists(form, 'submit-passtest')>
		<cflocation url="index.cfm?tab=pass&test=yes" addtoken="no">
	<cfelse>
		<cflocation url="index.cfm?tab=pass" addtoken="no">
	</cfif>
</cfif>

<cfif StructKeyExists(form, 'submit-serv')>
	<cfif form.monitor_historia_auto is 0>
		<cfset Politicas.modifica_parametro_global("monitor.historia", '0')>
	<cfelse>
		<cfset Politicas.modifica_parametro_global("monitor.historia", form.monitor_historia)>
	</cfif>
	
	<cfset Politicas.modifica_parametro_global("correo.cuenta", form.correo_cuenta)>

	<cfparam name="form.error_detalles" default="0">
	<cfset Politicas.modifica_parametro_global("error.detalles", form.error_detalles)>
	
	<cfparam name="form.servidor_principal" default="">
	<cfset Politicas.modifica_parametro_global("servidor.principal",   form.servidor_principal)>
	<cflocation url="index.cfm?tab=serv" addtoken="no">
</cfif>

<cfif StructKeyExists(form, 'submit-demo')>
	<cfset Politicas.modifica_parametro_global("demo.vigencia",       		form.demo_vigencia)>
	<cfif isdefined("form.demo_CuentaEmpresarial")>
		<cfset Politicas.modifica_parametro_global("demo.CuentaEmpresarial", form.demo_CuentaEmpresarial)>
	</cfif>
	<cfif isdefined("form.demo_cache")>
		<cfset Politicas.modifica_parametro_global("demo.cache", form.demo_cache)>
	</cfif>
	<cflocation url="index.cfm?tab=demo" addtoken="no">
</cfif>

<cfif StructKeyExists(form, 'submit-ldap')>
	
	<cfset Politicas.modifica_parametro_global("ldap.adminDN",   form.ldap_adminDN)>
	<cfif Len(Trim(form.ldap_adminPass)) and (form.ldap_adminPass Neq '**secret**')>
		<cfset strLDAPPASS = ToBase64(#form.ldap_adminPass#)>
		<cfset Politicas.modifica_parametro_global("ldap.adminPass",#strLDAPPASS#)>
        
	</cfif>
	<cfset Politicas.modifica_parametro_global("ldap.baseDN",    form.ldap_baseDN)>
	<cfset Politicas.modifica_parametro_global("ldap.port",      form.ldap_port)>
	<cfif Len(form.ldap_server)>
		<cfset Politicas.modifica_parametro_global("ldap.server",    form.ldap_server)>
	</cfif>
	<cfif isdefined("form.ldap_tipo") and form.ldap_tipo eq 1 >
		<cfset Politicas.modifica_parametro_global("ldap.dominio",      form.ldap_dominio)>
	<cfelse>
		<cfset Politicas.modifica_parametro_global("ldap.dominio",      '')>
	</cfif>
	
	<cflocation url="index.cfm?tab=ldap" addtoken="no">
</cfif>

<cflocation url="index.cfm" addtoken="no">
