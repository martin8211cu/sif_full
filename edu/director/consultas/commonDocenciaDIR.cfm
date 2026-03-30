<cfset Session.javascript_txtFecha = false>

<cfif isdefined("Form.CEcodigo")>
  <cfset Session.Edu.CEcodigo = Form.CEcodigo>
</cfif>

<cffunction name="fnNotificarCorreoBuzon">
  <cfargument name="LprmUsucodigo"          type="string" required="true" default="-1">
  <cfargument name="LprmUlocalizacion"      type="string"  required="true">
  <cfargument name="LprmEmail"              type="string"  required="true" default="-1">
  <cfargument name="LprmNombreDestino"      type="string"  required="true">
  <cfargument name="LprmTituloMsg"          type="string"  required="true">
  <cfargument name="LprmTextoMsg"           type="string"  required="true">
  <cfargument name="LprmNombreOrigen"       type="string"  required="true">
  <cfargument name="LprmAsuntoMail"         type="string"  required="true">
  <cfargument name="LprmQueryUsuLocMailNom" type="query"   required="false">
  <cfargument name="LprmUsarPantallaError"  type="boolean" default="false">
 
  <cfparam name="Session.CuentaOrigen " default="migestion@soin.co.cr">
  <cfset LvarTblError = "">
  <cfset LvarTextoMail = 
"DE PARTE DE: " & LprmNombreOrigen & " 
ASUNTO:      " & LprmTituloMsg & "
	
" & LprmTextoMsg>

    <cfif LprmUsucodigo neq "" and LprmUsucodigo neq "-1" and LprmUlocalizacion neq ""
	   OR LprmEmail neq ""     and LprmEmail neq "-1"     and LprmNombreDestino neq ""
	   OR isdefined("LprmQueryUsuLocMailNom")>
      <cftry>
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
	    <cfset home2 = initContext.lookup("Correo/BuzonSalida")>
	    <cfset Correo = home2.create()>
	  <cfcatch>
        <cfset LvarTblError = "fnNotificarCorreoBuzon: Error al utilizar Servidor de correos<br><br>" & cfcatch.Message>
   	    <cfif LprmUsarPantallaError>
          <cfset LvarURL="/cfmx/edu/errorPages/BDerror.cfm?errType=0&errMsg=" & urlencodedformat(LvarTblError)>
	      <cflocation addtoken="no" url=#LvarURL#>
	    </cfif>
	    <cfreturn LvarTblError>
	  </cfcatch>
	  </cftry>
	  <cfif not isdefined("LprmQueryUsuLocMailNom") and LprmQueryUsuLocMailNom neq "">
        <cftry>
          <cfif LprmUsucodigo eq "" or LprmUsucodigo eq "-1">
		    <cfset Correo.poner ("migestion.net <" & Session.CuentaOrigen & ">", LprmNombreDestino & "<" & LprmEmail & ">", LprmAsuntoMail, LvarTextoMail)>
		  <cfelse>
		    <cfobject action="create" name="BigDecimal" type="java" class="java.math.BigDecimal" >
		    <cfset LvarUsucodigo = BigDecimal.init(LprmUsucodigo)>
		    <cfset LvarTipo = "1">
		    <cfset Mensajeria.MensajeBuzon(LprmUlocalizacion, LvarUsucodigo, LprmTituloMsg, LprmTextoMsg, LvarTipo, LprmNombreOrigen)>
<!--- 
		    <cfset Mensajeria.MensajeCorreo(LvarUsucodigo, LprmUlocalizacion, LprmTituloMsg, LvarTextoMail)>
--->
 		  </cfif>
		<cfcatch>
		  <cfset LvarTblError = LvarTblError & "<tr><td>" & LprmUsucodigo & "</td><td>" & LprmUlocalizacion & "</td><td>" & LprmNombreDestino & "</td><td>" & LprmEmail & "</td><td>" & cfcatch.Message & "</td></tr>">
		</cfcatch>
		</cftry>
	  <cfelse>
		<cfloop query="LprmQueryUsuLocMailNom">
		  <cfif isdefined("LprmQueryUsuLocMailNom.Usucodigo") and LprmQueryUsuLocMailNom.Usucodigo neq "">
			<cfobject action="create" name="BigDecimal" type="java" class="java.math.BigDecimal" >
			<cfset LvarUsucodigo = BigDecimal.init(LprmQueryUsuLocMailNom.Usucodigo)>
			<cfset LvarUlocalizacion = LprmQueryUsuLocMailNom.Ulocalizacion>
			<cfset LvarTipo = "1">
			<cftry>
			  <cfset Mensajeria.MensajeBuzon(LvarUlocalizacion, LvarUsucodigo, LprmTituloMsg, LprmTextoMsg, LvarTipo, LprmNombreOrigen)>
<!--- 
			  <cfset Mensajeria.MensajeCorreo(LvarUsucodigo, LprmQueryUsuLocMailNom.Ulocalizacion, LprmTituloMsg, LvarTextoMail)>
--->
			<cfcatch>
			  <cfset LvarTblError = LvarTblError & "<tr><td>" & LvarUsucodigo.toString() & "</td><td>" & LprmQueryUsuLocMailNom.Ulocalizacion & "</td><td>" & LprmQueryUsuLocMailNom.NombreDestino & "</td><td>" & LprmQueryUsuLocMailNom.eMail & "</td><td>" & cfcatch.Message & "</td></tr>">
			</cfcatch>
			</cftry>
		  <cfelseif isdefined("LprmQueryUsuLocMailNom.eMail") and LprmQueryUsuLocMailNom.eMail neq "">
			<cftry>
              <cfset Correo.poner ("migestion.net <" & Session.CuentaOrigen & ">", LprmQueryUsuLocMailNom.NombreDestino & "<" & LprmQueryUsuLocMailNom.eMail & ">", LprmAsuntoMail, LvarTextoMail)>
			<cfcatch>
		      <cfif isdefined("LprmQueryUsuLocMailNom.Uusucodigo")>   <cfset LvarUsucodigo = LprmQueryUsuLocMailNom.Uusucodigo>       <cfelse><cfset LvarUsucodigo = ""></cfif>
		      <cfif isdefined("LprmQueryUsuLocMailNom.Ulocalizacion")><cfset LvarUlocalizacion = LprmQueryUsuLocMailNom.Ulocalizacion><cfelse><cfset LvarUlocalizacion = ""></cfif>
		      <cfif isdefined("LprmQueryUsuLocMailNom.NombreDestino")><cfset LvarNombre = LprmQueryUsuLocMailNom.NombreDestino>       <cfelse><cfset LvarNombre = ""></cfif>
		      <cfif isdefined("LprmQueryUsuLocMailNom.eMail")>        <cfset LvarEmail = LprmQueryUsuLocMailNom.eMail>                <cfelse><cfset LvarEmail = ""></cfif>
			  <cfset LvarTblError = LvarTblError & "<tr><td>" & LvarUsucodigo & "</td><td>" & LvarUlocalizacion & "</td><td>" & LvarNombre & "</td><td>" & LvarEmail & "</td><td>" & cfcatch.Message & "</td></tr>">
			</cfcatch>
			</cftry>
		  <cfelse>
		    <cfif isdefined("LprmQueryUsuLocMailNom.Uusucodigo")>   <cfset LvarUsucodigo = LprmQueryUsuLocMailNom.Uusucodigo>       <cfelse><cfset LvarUsucodigo = ""></cfif>
		    <cfif isdefined("LprmQueryUsuLocMailNom.Ulocalizacion")><cfset LvarUlocalizacion = LprmQueryUsuLocMailNom.Ulocalizacion><cfelse><cfset LvarUlocalizacion = ""></cfif>
		    <cfif isdefined("LprmQueryUsuLocMailNom.NombreDestino")><cfset LvarNombre = LprmQueryUsuLocMailNom.NombreDestino>       <cfelse><cfset LvarNombre = ""></cfif>
		    <cfif isdefined("LprmQueryUsuLocMailNom.eMail")>        <cfset LvarEmail = LprmQueryUsuLocMailNom.eMail>                <cfelse><cfset LvarEmail = ""></cfif>
			<cfset LvarTblError = LvarTblError & "<tr><td>" & LvarUsucodigo & "</td><td>" & LvarUlocalizacion & "</td><td>" & LvarNombre & "</td><td>" & LvarEmail & "</td><td>No indico ni Usuario ni Mail</td></tr>">
		  </cfif>
		</cfloop>
	  </cfif>
	
	  <cfset initContext.close()>
    <cfelse>
	  <cfset LvarTblError = "<tr><td>" & LprmUsucodigo & "</td><td>" & LprmUlocalizacion & "</td><td>" & LprmNombreDestino & "</td><td>" & LprmEmail & "</td><td>No indico ni Usuario ni Mail ni Query</td></tr>">
    </cfif>
	
	<cfif LvarTblError neq "">
 	  <cfif LprmUsarPantallaError>
        <cfset Session.tblError = "<table border='1' cellspacing='0' cellpadding='0'><tr><td>Usuario</td><td>Localizacion</td><td>Nombre</td><td>eMail</td><td>ERROR</td></tr>"
	                            & LvarTblError & "</table>">
        <cfset LvarTblError = "fnNotificarCorreoBuzon: No se pudieron enviar los siguientes Correos:<BR><BR>">
        <cfset LvarURL="/cfmx/edu/errorPages/BDerror.cfm?errType=0&errMsg=" & urlencodedformat(LvarTblError)>
	    <cflocation addtoken="no" url=#LvarURL#>
      <cfelse>
	    <cfset LvarTblError = "fnNotificarCorreoBuzon: No se pudieron enviar los siguientes Correos:<BR><BR>"
	                        & "<table border='1' cellspacing='0' cellpadding='0'><tr><td>Usuario</td><td>Localizacion</td><td>Nombre</td><td>eMail</td><td>ERROR</td></tr>"
	                        & LvarTblError & "</table>">
	  </cfif>
	</cfif>
	<cfreturn LvarTblError>
</cffunction>

<cffunction name="sbInitFromSession">
           <cfargument name="LprmControl" required="true" type="string">
           <cfargument name="LprmDefault" required="true" type="string">
           <cfargument name="LprmNoChange" required="false" type="boolean" default=false>
  <cfparam name="Session.docencia.#LprmControl#" default="#LprmDefault#">
  <cfif LprmNoChange>
    <cfset Form[LprmControl] = Session.docencia[LprmControl]>
  <cfelse>
    <cfparam name="Form.#LprmControl#" default="#Session.docencia[LprmControl]#">
  </cfif>
  <cfset Session.docencia[LprmControl] = Form[LprmControl]>
</cffunction>

<cffunction name="sbInitFromSessionChks">
           <cfargument name="LprmChk"     required="true" type="string">
           <cfargument name="LprmDefault" required="true" type="string">
		   <!--- 
		   Para que esta funcion se comporte correctamente necesita que se defina no solo
		   el chkCAMPO sino tambien un hidden con el nombre hdnChkCAMPO (no importa su valor solo su nombre).
		   Si no, siempre va a encender encender el chkCAMPO
		   --->
  <cfif isdefined("Form.#LprmChk#")>
    <cfparam name="Form.#LprmChk#" default="1">
  <cfelseif isdefined("Form.hdn#LprmChk#")>
    <cfparam name="Form.#LprmChk#" default="0">
  <cfelse>
    <cfparam name="Session.docencia.#LprmChk#" default="#LprmDefault#">
    <cfparam name="Form.#LprmChk#" default="#LprmDefault#">
  </cfif>
  <cfset Session.docencia[LprmChk] = Form[LprmChk]>
</cffunction>

<cffunction name="fnObtenerCodigoDeTabla">
           <cfargument name="LprmTabla" required="true" type="string">
           <cfargument name="LprmValor" required="true" type="string">
  <cfif LprmValor eq "">
    <cfreturn "">
  <cfelse>
    <cfquery dbtype="query" name="qryValor">
       select Codigo
         from qryValoresTabla
        where Tabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LprmTabla#">
          and #LprmValor# between Minimo and Maximo
    </cfquery>
    <cfreturn qryValor.Codigo>
  </cfif>
</cffunction>

<cffunction name="fnObtenerValorDeTabla">
           <cfargument name="LprmTabla" required="true" type="string">
           <cfargument name="LprmCodigo" required="true" type="string">
  <cfif LprmCodigo eq "">
    <cfreturn "">
  <cfelse>
    <cfquery dbtype="query" name="qryValor">
       select Equivalente
         from qryValoresTabla
        where Tabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LprmTabla#">
          and Codigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LprmCodigo#">
    </cfquery>
    <cfreturn qryValor.Equivalente>
  </cfif>
</cffunction>

