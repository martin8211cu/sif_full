
<cfquery datasource="asp" name="rsUsers">
select a.Usucodigo, Usulogin, b.Pnombre+' '+b.Papellido1+' '+b.Papellido2 as Pnombre
from Usuario a
inner join DatosPersonales b
on a.datos_personales=b.datos_personales
where CEcodigo = #session.CEcodigo#  and Utemporal = 0 order by Usulogin
</cfquery>
<cfif isdefined("url.selectUsucodigo") and len(trim(url.selectUsucodigo)) gt 0>
	<cfset session.usucodigo= url.selectUsucodigo>
</cfif>

	<form method="get">
	Usuario: <select name="selectUsucodigo">
		<cfoutput query="rsUsers">
		<option value="#Usucodigo#" <cfif session.usucodigo eq rsUsers.Usucodigo>selected</cfif> >#Usulogin# - #Pnombre#</option>
		</cfoutput>
	</select><br>
	Debug en esta session: <input type="checkbox" name="modoDebug" <cfif isdefined("session") and isdefined("url.modoDebug")>checked="checked"</cfif>> <br><br>
	<input type="submit" value="Aplicar">
	</form>

<cfif isdefined("session")>
	<cfif isdefined("url.modoDebug")>
		<cfset session.debug = true>
	<cfelse>
		<cfif StructKeyExists(session, "debug")>
			<cfset StructDelete(session, "debug")>
		</cfif>	
	</cfif>	
</cfif>
