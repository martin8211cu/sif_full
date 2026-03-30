<cfif isdefined("form.btnAnular")>
	<cfset fnProcesaAnulacion()>
</cfif>

<cfif isdefined("form.btnAceptar")>
	<cfset fnProcesaAceptacion()>
</cfif>

<cflocation url="QPassAceptaVenta.cfm" addtoken="no">	

<cffunction name="fnObtieneRegistrosVenta" access="private" output="false">
	<cfargument name="QPvtaEstado" required="yes" type="numeric">
	<cfset LvarCheck = -1>
	<cfif isdefined("form.chk")>
		<cfset LvarCheck = form.chk>
	</cfif>
	<cfquery name="PorActualizar" datasource="#session.dsn#">
		select b.QPvtaTagid, b.QPTidTag
		from QPventaTags b
		where b.QPvtaTagid in (#LvarCheck#)
		  and b.QPvtaEstado = #Arguments.QPvtaEstado#
	</cfquery>
</cffunction>

<cffunction name="fnProcesaAceptacion" access="private" output="false">
	<cfset fnObtieneRegistrosVenta(0)>
	<cfloop query="PorActualizar">
		<cfinvoke component="sif.QPass.Componentes.QPassTag" method="ActualizaTag" returnvariable="LvarResultado">
			<cfinvokeargument name="Conexion" value="#session.DSN#">
			<cfinvokeargument name="QPTidTag" value="#PorActualizar.QPTidTag#">
			<cfinvokeargument name="QPTEstadoActivacion" value="4">
			<cfinvokeargument name="QPTMovTipoMov" value="6">
		</cfinvoke>
		<cfif LvarResultado>
			<cfquery datasource="#session.dsn#">
				Update QPventaTags
				set QPvtaEstado = 1
				where QPvtaTagid   = #PorActualizar.QPvtaTagid#
			</cfquery>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="fnProcesaAnulacion" access="private" output="false">
	<!---Si Anula--->	
	<cfset fnObtieneRegistrosVenta(0)>
	<cfloop query="PorActualizar">
		<cfinvoke component="sif.QPass.Componentes.QPassTag" method="fnRechazaVenta" returnvariable="LvarResultado">
			<cfinvokeargument name="Conexion" value="#session.DSN#">
			<cfinvokeargument name="QPTidTag" value="#PorActualizar.QPTidTag#">
			<cfinvokeargument name="QPvtaTagid" value="#PorActualizar.QPvtaTagid#">
	        <cfinvokeargument name="QPvtaEstado" value="2">
		</cfinvoke>
	</cfloop>
</cffunction>
