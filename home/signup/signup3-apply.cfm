<cfparam name="form.logintext" default="">
<cfparam name="form.pregunta" default="">
<cfparam name="form.respuesta" default="">
<cfparam name="form.newpass" default="">
<cfparam name="form.newpass2" default="">

<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

<cfif Len(form.logintext) EQ 0 OR
      Len(form.newpass)   EQ 0 OR
	  Len(form.newpass2)  EQ 0>
	<!--- faltan datos --->
	<cflocation url="signup3.cfm?error=1&logintext=#URLEncodedFormat(form.logintext)#">
<cfelseif form.newpass NEQ form.newpass2>
	<!--- la contraseña no coincide --->
	<cflocation url="signup3.cfm?error=2&logintext=#URLEncodedFormat(form.logintext)#">
</cfif>

<!--- repito validaciones de signup2-apply.cfm --->
<cfquery datasource="asp" name="repetidos">
	select Usulogin
	from Usuario
	where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.logintext#">
	  and Usucodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and CEcodigo = #session.CEcodigo#
</cfquery>
<cfif repetidos.RecordCount GT 0>
	<cflocation url="signup2.cfm?error=2">
</cfif>
	
<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta" returnvariable="data"
	CEcodigo="#session.CEcodigo#"/>
<cfinvoke component="home.Componentes.ValidarPassword" method="validar" returnvariable="valida"
	data="#data#" user="#form.logintext#" pass="#form.newpass#" />
<cfif ArrayLen(valida.erruser)>
	<cfset session.erruser = ArrayToList(valida.erruser,'<br>')>
	<cflocation url="signup2.cfm?error=5">
</cfif>
<cfif ArrayLen(valida.errpass)>
	<cfset session.errpass = ArrayToList(valida.errpass,'<br>')>
	<cflocation url="signup3.cfm?error=5&logintext=#URLEncodedFormat(form.logintext)#">
</cfif>

<cfset AUTHBACKEND = sec.autenticar(session.CEcodigo, session.usuario, form.oldpass)>
<cfif Len (AUTHBACKEND)>
		
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
     <!---<cfdump var="#data.pass.valida.lista#">
	 <cfdump var="#data.pass.valida.lista#"><cfabort>  --->
	 <!---verifica historicos--->
	 <cfif data.pass.valida.lista gt 0 and not sec.verificaPasswordHist(form.newpass,form.oldpass,data.pass.valida.lista)>
		    <cflocation url="signup3.cfm?error=6&logintext=#URLEncodedFormat(form.logintext)#">
	<cfelse>
   	  
			<!--- hay que mandarle el password junto con el login --->
            <cfset sec.cambiarUsuario(form.logintext, form.newpass)>
            <!--- Modifica la pregunta de Usuario --->
            <cfif Len(form.pregunta) GT 0 AND Len(form.respuesta) GT 0>
                <cfquery datasource="asp">
                    update Usuario
                    set Usupregunta  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pregunta#">,
                        Usurespuesta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.respuesta#">
                    where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                </cfquery>
            </cfif>
            
            <!--- Guardar en bitácora
            <cfquery datasource="asp">
                insert UsuarioBitacora (Usucodigo, Ulocalizacion, UBtipo, UBumod, UBfmod, UBdata)
                values (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
                    'PrimerIngreso',
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
                    getdate(), 'signup/signup3-apply.cfm')
            </cfquery> --->
            <cfset session.autoafiliado = session.Usucodigo>
            <cflocation url="/cfmx/home/index.cfm">
      </cfif>
<cfelse>
	<cflocation url="signup3.cfm?error=3&logintext=#URLEncodedFormat(form.logintext)#">
</cfif>
