<cffunction name="fnNotificarCorreoBuzon">
  <cfargument name="LprmUsucodigo"          type="numeric" required="true" default="-1">
  <cfargument name="LprmUlocalizacion"    type="string"  required="true">
  <cfargument name="LprmEmail"              type="string"  required="true" default="-1">
  <cfargument name="LprmNombreDestino"      type="string"  required="true">
  <cfargument name="LprmTituloMsg"          type="string"  required="true">
  <cfargument name="LprmTextoMsg"           type="string"  required="true">
  <cfargument name="LprmNombreOrigen"       type="string"  required="true">
  <cfargument name="LprmQueryUsuLocMailNom" type="query"   required="false">

  <cftry>
    <cfif LprmUsucodigo neq "" and LprmUsucodigo neq "-1" and LprmUlocalizacion neq ""
	   OR LprmEmail neq ""     and LprmEmail neq "-1"     and LprmNombreDestino neq ""
	   OR isdefined(LprmQueryUsuLocMailNom)>
	  <cfobject action="create" name="ctx"  type="java" class="javax.naming.Context">
	  <cfobject action="create" name="prop" type="java" class="java.util.Properties">
	  <cfset prop.init()>
	  <!---
	  <cfset prop.put(ctx.INITIAL_CONTEXT_FACTORY, "com.sybase.ejb.InitialContextFactory")>
	  <cfset prop.put(ctx.PROVIDER_URL, Session.PROVIDER_URL)>
	  --->
	  <cfset prop.put(ctx.SECURITY_PRINCIPAL, Session.SECURITY_PRINCIPAL)>
	  <cfset prop.put(ctx.SECURITY_CREDENTIALS, Session.SECURITY_CREDENTIALS)>
	  <cfobject action="create" name="initContext" type="java" class="javax.naming.InitialContext">
	  <cfset initContext.init(prop)>
	  <cfset home = initContext.lookup("utilitarios/Mensajeria")>
	  <cfset Mensajeria = home.create()>
	  <cfif not isdefined("LprmQueryUsuLocMailNom")>
		<cfset LvarTextoMail = "De parte de: " & LprmNombreOrigen & "
	
" & LprmTextoMsg>
        <cfif LprmUsucodigo eq "" or LprmUsucodigo eq "-1">
		  <cfset Mensajeria.MensajeCorreoConEmail(eMail, LprmNombreDestino, LprmTituloMsg, LvarTextoMail)>
		<cfelse>
		  <cfobject action="create" name="BigDecimal" type="java" class="java.math.BigDecimal" >
		  <cfset LvarUsucodigo = BigDecimal.init(LprmUsucodigo)>
		  <cfset LvarTipo = "1">
		  <cfset Mensajeria.MensajeBuzon(LprmUlocalizacion, LvarUsucodigo, LprmTituloMsg, LprmTextoMsg, LvarTipo, LprmNombreOrigen)>
		  <cfset Mensajeria.MensajeCorreo(LvarUsucodigo, LprmUlocalizacion, LprmTituloMsg, LvarTextoMail)>
		</cfif>
	  <cfelse>
		<cfloop query="LprmQueryUsuLocMailNom">
		  <cfset LvarTextoMail = "De parte de: " & LprmNombreOrigen & "
	
" & LprmTextoMsg>
		  <cfif isdefined("LprmQueryUsuLocMailNom.Usucodigo") and LprmQueryUsuLocMailNom.Usucodigo neq "">
			<cfobject action="create" name="BigDecimal" type="java" class="java.math.BigDecimal" >
			<cfset LvarUsucodigo = BigDecimal.init(LprmQueryUsuLocMailNom.Usucodigo)>
			<cfset LvarUlocalizacion = LprmQueryUsuLocMailNom.Ulocalizacion>
			<cfset LvarTipo = "1">
			<cfset Mensajeria.MensajeBuzon(LvarUlocalizacion, LvarUsucodigo, LprmTituloMsg, LprmTextoMsg, LvarTipo, LprmNombreOrigen)>
			<cfset Mensajeria.MensajeCorreo(LvarUsucodigo, LprmQueryUsuLocMailNom.USUlocalizacion, LprmTituloMsg, LvarTextoMail)>
		  <cfelse>
			<cfset Mensajeria.MensajeCorreoConEmail(LprmQueryUsuLocMailNom.eMail, LprmQueryUsuLocMailNom.NombreDestino, LprmTituloMsg, LvarTextoMail)>
		  </cfif>
		</cfloop>
	  </cfif>
	
	  <cfset initContext.close()>
    <cfelse>
      fnNotificarCorreoBuzon: No se envió ni Usuario ni eMail<br>
    </cfif>
  <cfcatch type="java.lang.Exception">
    fnNotificarCorreoBuzon: No se pudo enviar 1 mensaje de correo<br>
  </cfcatch>
  </cftry>
</cffunction>

<cffunction name="sbInitFromSession">
           <cfargument name="LprmControl" required="true" type="string">
           <cfargument name="LprmDefault" required="true" type="string">
           <cfargument name="LprmNoChange" required="false" type="boolean" default=false>
  <cfparam name="Session.docencia.#LprmControl#" default="#LprmDefault#">
  <cfif LprmNoChange>
    <cfset form[LprmControl] = Session.docencia[LprmControl]>
  <cfelse>
    <cfparam name="form.#LprmControl#" default="#Session.docencia[LprmControl]#">
  </cfif>
  <cfset Session.docencia[LprmControl] = form[LprmControl]>
</cffunction>

<cffunction name="sbInitFromSessionChks">
           <cfargument name="LprmChk"     required="true" type="string">
           <cfargument name="LprmDefault" required="true" type="string">
  <cfif isdefined("form.chkXAlumno")>
    <cfparam name="form.#LprmChk#" default="0">
  <cfelse>
    <cfparam name="Session.docencia.#LprmChk#" default="#LprmDefault#">
    <cfparam name="form.#LprmChk#" default="#Session.docencia[LprmChk]#">
  </cfif>
  <cfset Session.docencia[LprmChk] = form[LprmChk]>
</cffunction>

