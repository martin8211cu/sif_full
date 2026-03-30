<!---  --->
<cfset error = 0>
<!--- datos incompletos --->
<cfif len(trim(form.oldpass)) eq 0 or len(trim(form.newpass)) eq 0 or len(trim(form.newpass2)) eq 0 >
	<cfset error = 1 >
</cfif>

<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta" returnvariable="data" CEcodigo="#session.CEcodigo#"/>
<cfinvoke component="home.Componentes.ValidarPassword" method="validar" data="#data#" user="#usuario#" pass="#form.newpass#" returnvariable="valida"/>
<cfif ArrayLen(valida.errpass)>
	<cfset session.errpass = ArrayToList(valida.errpass,'<br>')>
	<cfset error = 5>
</cfif>

<!--- EJB --->
<cfif error is 0>
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
     <cfif data.pass.valida.lista neq 0>
     	<!---verifica historicos--->
     	<cfif not sec.verificaPasswordHist(form.newpass,form.oldpass,data.pass.valida.lista)>
            <cfset error = 6>
        <cfelse>
			<cfif not sec.cambiarPassword(form.oldpass, form.newpass)>
                <cfset error = 2>
            </cfif>
        </cfif>
     <cfelse>  
		<cfif not sec.cambiarPassword(form.oldpass, form.newpass)>
            <cfset error = 2>
        </cfif>
    </cfif>
</cfif>

<cfif error is 0>
	<!--- Modifica la pregunta de Usuario, solamente cuando ya validó el cambio de contraseña --->
	<cfif isdefined("form.preg") and form.preg eq 1>
		<cfquery name="upd_pregunta" datasource="asp">
			update Usuario
			set Usupregunta  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pregunta#">,
				Usurespuesta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.respuesta#">
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#usucodigo#">
		</cfquery>
	</cfif>
</cfif>
