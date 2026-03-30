<cfparam name="url.new" default="no">
<cfparam name="url.agenda" default="0">
<cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">
	<cfinvokeargument name="create" value="no">
	<cfinvokeargument name="throw"  value="no">
</cfinvoke>
<cfif CodigoAgendaMedica is 0>
	<cfif url.new is 'yes'>
		<cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">
			<cfinvokeargument name="create" value="yes">
			<cfinvokeargument name="throw"  value="no">
		</cfinvoke>
	<cfelse>
		<cfinvoke component="rh.Componentes.AgendaMedica" method="UsarAgenda" returnvariable="CodigoAgendaMedica">
			<cfinvokeargument name="agenda" value="#url.agenda#">
		</cfinvoke>
	</cfif>
</cfif>
<cflocation url="Consultorio.cfm">
