<!--- Archivo que redirecciona a un sitio apropiado guardando algunas variable de sesión --->
<cfif Not IsDefined("session.sitio.CEcodigo")>
	<!--- Obtener el host --->
	<cfif Right(CGI.SCRIPT_NAME,3) neq 'CFC'>
		<cftry>
			<cfset httpRequestData = GetHTTPRequestData()>
			<cfcatch type="any">
				<!--- GetHTTPRequestData Da error si se invoca desde un web service --->
			</cfcatch>
		</cftry>
	</cfif>
	<cfif IsDefined('httpRequestData')>
		<cfset req = httpRequestData.headers>
		
		<cfset Session.sitio.host = "">
		<cfif StructKeyExists(req,"X-Forwarded-Host")>
			<cfset Session.sitio.host = req["X-Forwarded-Host"]>
		</cfif>
		<cfif Len(Session.sitio.host) EQ 0>
			<cfset Session.sitio.host = req["Host"]>
		</cfif>
	<cfelse>
		<cfset Session.sitio.host = CGI.HTTP_HOST>
	</cfif>
	<cfif ListLen(session.sitio.host) GT 1>
		<cfset session.sitio.host = Trim(ListGetAt(session.sitio.host, 1))>
	</cfif>
	<cfset CreateObject("component","functions").seleccionar_dominio(session.sitio.host)>
</cfif>
<cfif Len(session.sitio.Ecodigo) and session.sitio.Ecodigo neq 0 and
	IsDefined("session.EcodigoSDC") and Len(session.EcodigoSDC) neq 0 and session.EcodigoSDC neq 0 and
	session.EcodigoSDC neq session.sitio.Ecodigo>
	<cfthrow message="No se permite cambiar de empresa en este sitio (#session.EcodigoSDC# != #session.sitio.Ecodigo#)">
</cfif>
<cfif isdefined('url.ssl_return')>
	<cfset session.sitio.ssl_return = url.ssl_return>
</cfif>
<!--- dump final

<cfoutput>
<table border="0" style="background-color:##CCCCCC;padding:4 4 4 4;border:1px solid black;margin-bottom:4" >
  <tr><td colspan="2" style="background-color:##000000;color:##ffffff"><strong>check/check-dominio.cfm</strong> (session.sitio)</td>
    </tr>
  <tr><td>host</td>
    <td>#Session.sitio.host#</td></tr>
  <tr><td>Scodigo</td>
    <td>#Session.sitio.Scodigo#</td></tr>
  <tr><td>home</td>
    <td>#Session.sitio.home#</td></tr>
  <tr><td>login</td>
    <td>#Session.sitio.login#</td></tr>
  <tr><td>template</td>
    <td>#Session.sitio.template#</td></tr>
  <tr><td>dominio</td>
    <td>#Session.sitio.dominio#</td></tr>
</table>
</cfoutput><cfabort>
 --->