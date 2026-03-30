<cfif Not IsDefined("form.logintext") OR Len(form.logintext) EQ 0>
	<cflocation url="signup2.cfm?error=1">
<cfelse>
	
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
		data="#data#" user="#form.logintext#" pass="" />
	<cfif ArrayLen(valida.erruser)>
		<cfset session.erruser = ArrayToList(valida.erruser,'<br>')>
		<cflocation url="signup2.cfm?error=5">
	</cfif>

	<cflocation url="signup3.cfm?logintext=#URLEncodedFormat( form.logintext )#">
</cfif>

