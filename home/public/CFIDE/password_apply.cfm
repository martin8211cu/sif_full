<html>
<cfif isdefined("application.CFadmiPWD")>
	<cfset structdelete(application,"CFadmiPWD")>
</cfif>
<cftry>
	<cffile action="delete" file="#expandpath("./home/Componentes/CFIDE.cfg")#">
<cfcatch type="any">
</cfcatch>
</cftry>

<cftry>
	<cfinvoke component="home.Componentes.DbUtils" method="getColdfusionDatasources" returnvariable="datasources">
		<cfinvokeargument name="CFadmiPWD"  value="#form.txtPassword#">
	</cfinvoke>
<cfcatch type="any">
	<font color="#FF0000">El password de Administrador Coldfusion no es correcto</font><BR><BR>
	<input type="button" value="Reintentar" onClick="javascript:location.href='password.cfm'">
	</html>
	<cfabort>
</cfcatch>
</cftry>

<cfset application.CFadmiPWD = encrypt(form.txtPassword,"asp128","CFMX_COMPAT","HEX")>
<cffile action="write" file="#expandpath("/home/Componentes/CFIDE.cfg")#" output="PWD=#application.CFadmiPWD#">

<cftry>
	<cfinvoke component="home.Componentes.DbUtils" method="getColdfusionDatasources" returnvariable="datasources">
		<cfinvokeargument name="CFadmiPWD"  value="XXX_XXX">
	</cfinvoke>
<cfcatch type="any"></cfcatch></cftry>
El password se registró correctamente<BR><BR>
<input type="button" value="Continuar" onClick="javascript:location.href='/cfmx/'">
</html>
