<cfif isdefined("form.btnAnular")>
	<cfset fnProcesaAnulacion()>
</cfif>

<cflocation url="QPassAnulaVenta.cfm" addtoken="no">	

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

<cffunction name="fnProcesaAnulacion" access="private" output="false">
	<!---Si Anula--->	
	<cfset fnObtieneRegistrosVenta(1)>
	<cfloop query="PorActualizar">
		<cfinvoke component="sif.QPass.Componentes.QPassTag" method="fnRechazaVenta" returnvariable="LvarResultado">
			<cfinvokeargument name="Conexion" value="#session.DSN#">
			<cfinvokeargument name="QPTidTag" value="#PorActualizar.QPTidTag#">
			<cfinvokeargument name="QPvtaTagid" value="#PorActualizar.QPvtaTagid#">
	        <cfinvokeargument name="QPvtaEstado" value="3">
		</cfinvoke>
	</cfloop>
</cffunction>