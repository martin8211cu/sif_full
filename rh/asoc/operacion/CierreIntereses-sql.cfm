<cfif isdefined("form.cerrar")>
	<cfinvoke component="rh.asoc.Componentes.RH_CierreIntereses" method="cierreIntereses" >
		<cfinvokeargument name="periodo" value="#form.periodo#" >
		<cfinvokeargument name="mes" 	 value="#form.mes#" >
	</cfinvoke>
</cfif>

<cflocation url="CierreIntereses.cfm?cierre=ok&periodo=#form.periodo#&mes=#form.mes#">