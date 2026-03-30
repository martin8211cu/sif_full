<cfparam name="CurrentPage" default="#GetFileFromPath(GetTemplatePath())#">
<cfset Form.rol = "DAS">


<cfif isdefined("url.tab") and Len(Trim(url.tab))>	<!--- tab en los datos de cliente--->
	<cfset form.tab = url.tab>
</cfif>
<cfparam name="form.tab" default="1">

<cfif isdefined("url.cue") and Len(Trim(url.cue))>	<!--- id de la cuenta--->
	<cfset form.cue = url.cue>
</cfif>
<cfparam name="form.cue" default="">
<cfif isdefined("form.cue") and Len(Trim(form.cue))>
	<cfset form.CTid = form.cue>
</cfif>
<cfparam name="form.CTid" default="">

<cfif isdefined("url.pqc") and Len(Trim(url.pqc))>	<!--- (Pquien) id del contacto--->
	<cfset form.pqc = url.pqc>
</cfif>
<cfparam name="form.pqc" default="">
<cfif isdefined("form.pqc") and Len(Trim(form.pqc))>
	<cfset form.Pcontacto = form.pqc>
</cfif>
<cfparam name="form.Pcontacto" default="">

<cfif isdefined("url.pkg") and Len(Trim(url.pkg))>	<!--- id del contrato--->
	<cfset form.pkg = url.pkg>
</cfif>
<cfparam name="form.pkg" default="">
<cfif isdefined("form.pkg") and Len(Trim(form.pkg))>
	<cfset form.Contratoid = form.pkg>
</cfif>
<cfparam name="form.Contratoid" default="">

<cfif isdefined("url.infoServ") and Len(Trim(url.infoServ))>		<!--- consulta de servicios Ofrecidos--->
	<cfset form.infoServ = url.infoServ>
</cfif>
<cfparam name="form.infoServ" default="">

<cfif isdefined("url.traf") and Len(Trim(url.traf))><!--- Consulta de tráfico--->
	<cfset form.traf = url.traf>
</cfif>
<cfparam name="form.traf" default="">
<cfif isdefined("form.traf") and Len(Trim(form.traf))>
	<cfset form.trafico = form.traf>
</cfif>
<cfparam name="form.trafico" default="">

<cfif isdefined("url.logg") and Len(Trim(url.logg))>		<!--- id del login--->
	<cfset form.logg = url.logg>
</cfif>
<cfparam name="form.logg" default="">
<cfif isdefined("form.logg") and Len(Trim(form.logg))>
	<cfset form.LGnumero = form.logg>
</cfif>
<cfparam name="form.LGnumero" default="">

<cfif isdefined("url.cli") and Len(Trim(url.cli))>			<!--- id del cliente--->
	<cfset form.cli = url.cli>
</cfif>
<cfparam name="form.cli" default="">
<cfif isdefined("form.cli") and Len(Trim(form.cli))>
	<cfset form.cliente = form.cli>
</cfif>
<cfparam name="form.cliente" default="">

<cfif isdefined("url.lpaso") and Len(Trim(url.lpaso))>		<!--- paso para el menu de logines --->
	<cfset form.lpaso = url.lpaso>
</cfif>
<cfparam name="form.lpaso" default="0">

<cfif isdefined("url.cpaso") and Len(Trim(url.cpaso))>		<!--- paso para el menu en cuentas --->
	<cfset form.cpaso = url.cpaso>
</cfif>
<cfparam name="form.cpaso" default="1">

<cfif isdefined("url.csub") and Len(Trim(url.csub))>		<!--- sub-paso para el menu en cuentas en el paso 3 (forma de cobro)--->
	<cfset form.csub = url.csub>
</cfif>
<cfparam name="form.csub" default="false">

<cfif isdefined("url.ppaso") and Len(Trim(url.ppaso))>		<!--- paso para el menu de productos(paquetes) --->
	<cfset form.ppaso = url.ppaso>
</cfif>
<cfparam name="form.ppaso" default="1">

<cfif isdefined("url.cpass") and Len(Trim(url.cpass))>		<!--- Cambio de password--->
	<cfset form.cpass = url.cpass>
</cfif>
<cfparam name="form.cpass" default="">
<cfif isdefined("form.cpass") and Len(Trim(form.cpass))>	
	<cfset form.cambioPass = form.cpass>
</cfif>
<cfparam name="form.cambioPass" default="">

<cfif isdefined("url.pkg_rep") and Len(Trim(url.pkg_rep))>	<!--- Elemento de la lista de Productos a Reprogramar--->
	<cfset form.pkg_rep = url.pkg_rep>
</cfif>
<cfparam name="form.pkg_rep" default="">


<cfif isdefined("url.adser") and Len(Trim(url.adser))>		<!--- Agregar servicios--->
	<cfset form.adser = url.adser>
</cfif>
<cfif isdefined("url.pintaBotones") and Len(Trim(url.pintaBotones))>		<!--- Pinta Botones--->
	<cfset form.pintaBotones = url.pintaBotones>
</cfif>

<cfparam name="form.adser" default="">
<cfif isdefined("form.adser") and Len(Trim(form.adser))>
	<cfset form.AddServicio = form.adser>
</cfif>
<cfparam name="form.AddServicio" default="">



<cfset ExisteCliente = isdefined("form.cli") and Len(Trim(form.cli))>
<cfset ExisteCuenta = isdefined("form.cue") and Len(Trim(form.cue))>
<cfset ExistePaquete = isdefined("form.pkg") and Len(Trim(form.pkg))>
<cfset ExisteContacto = isdefined("form.pqc") and Len(Trim(form.pqc))>
<cfset ExisteTrafico = isdefined("form.traf") and Len(Trim(form.traf))>
<cfset ExisteLog = isdefined("form.logg") and Len(Trim(form.logg))>
<cfset ExisteCambioPass = isdefined("form.cpass") and Len(Trim(form.cpass))>
<cfset ExisteRepro = isdefined("form.pkg_rep") and Len(Trim(form.pkg_rep))>
<cfset ExisteAddServicio = isdefined("form.adser") and Len(Trim(form.adser))>
<cfset ExisteInfoServ = isdefined("form.infoServ") and Len(Trim(form.infoServ))>
<cfset ExisteRecarga = isdefined("form.recarga") and Len(Trim(form.recarga))>
