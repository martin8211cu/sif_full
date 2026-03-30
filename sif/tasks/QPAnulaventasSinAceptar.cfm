<cfif not isdefined('session.DSN')>
	<cfset session.DSN = 'minisif'>
</cfif>
<cfif not isdefined('session.Ecodigo')>
    <cfset session.Ecodigo = 2>
</cfif>
<cfif isdefined('url.Usucodigo') and url.Usucodigo eq 11499>
    <cfset session.Ecodigo = 1>
</cfif>

<cfset fnProcesaAnulacion()>

<cffunction name="fnObtieneRegistrosVenta" access="private" output="yes">
	<cfargument name="QPvtaEstado" required="yes" type="numeric">
	<cfset LvarCheck = -1>
	<cfif isdefined("form.chk")>
		<cfset LvarCheck = form.chk>
	</cfif>
	<cfquery name="PorActualizar" datasource="#session.dsn#">
		select b.QPvtaTagid, b.QPTidTag
		from QPventaTags b
		where b.QPvtaEstado = #Arguments.QPvtaEstado#
	</cfquery>
</cffunction>

<cffunction name="fnProcesaAnulacion" access="private" output="yes">
	<!---Si Anula--->	
	<cfset fnObtieneRegistrosVenta(0)>
	<cfloop query="PorActualizar">
		<cfinvoke component="sif.QPass.Componentes.QPassTag" method="fnRechazaVenta" returnvariable="LvarResultado">
			<cfinvokeargument name="Conexion" value="#session.DSN#">
			<cfinvokeargument name="QPTidTag" value="#PorActualizar.QPTidTag#">
			<cfinvokeargument name="QPvtaTagid" value="#PorActualizar.QPvtaTagid#">
	        <cfinvokeargument name="QPvtaEstado" value="2">
		<cfinvokeargument name="RechazaDesdeAceptacion" value="true">
		</cfinvoke>
	</cfloop>
</cffunction>
