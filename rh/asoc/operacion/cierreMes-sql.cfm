<cfif isdefined("form.cerrar")>
	<cftransaction>
		<cfinvoke component="rh.asoc.Componentes.RH_CierreMes" method="cierreMes" >
			<cfinvokeargument name="periodo" value="#form.periodo#" >
			<cfinvokeargument name="mes" 	 value="#form.mes#" >
		</cfinvoke>
	</cftransaction>
</cfif>

<cflocation url="cierreMes.cfm?cierre=ok&periodo=#form.periodo#&mes=#form.mes#">