
<cfquery datasource="asp" name="rsUsers">
select a.Usucodigo, Usulogin, b.Pnombre+' '+b.Papellido1+' '+b.Papellido2 as Pnombre
from Usuario a
inner join DatosPersonales b
on a.datos_personales=b.datos_personales
where CEcodigo = #session.CEcodigo#  and Utemporal = 0 order by Usulogin
</cfquery>
<cfif isdefined("url.ForzarStyle") and len(trim(url.ForzarStyle)) eq 1>
		<cfset session.sitio.CSS = '/plantillas/Cloud/css/style.css'>
		<cfset session.sitio.FOOTER = '/plantillas/Cloud/footer.cfm'>
		<cfset session.sitio.HOME = '/plantillas/Cloud/home.cfm'>
		<cfset session.sitio.LOGIN = '/plantillas/Cloud/login.cfm'>
		<cfset session.sitio.SKINLIST = ''>
		<cfset session.sitio.SKINVERDE='/cfmx/plantillas/Cloud/css/Verde/style.css'>
		<cfset session.sitio.TEMPLATE = '/plantillas/Cloud/plantilla.cfm'>

<cfif isdefined("url.ForzarStyle") and len(trim(url.ForzarStyle)) eq 2>
		<cfset session.sitio.CSS = '/plantillas/Sapiens/css/soinasp01_sapiens.css'>
		<cfset session.sitio.FOOTER = ''>
		<cfset session.sitio.HOME = '/plantillas/Sapiens/home.cfm'>
		<cfset session.sitio.LOGIN = '/plantillas/Sapiens/login.cfm'>
		<cfset session.sitio.SKINLIST = 'soinasp01_sapiens.css,Sapiens'>
		<cfset session.sitio.SKINVERDE=''>
		<cfset session.sitio.TEMPLATE = '/plantillas/Sapiens/plantilla.cfm'>
		
</cfif>

<form method="get">
	<select name="ForzarStyle">
		<option value="1" >Cloud</option>
		<option value="2" >Sapiens</option>
	</select>
	<input type="submit" value="Go">
</form>


	<cfif session.usulogin eq 'cloud'>

	</cfif>