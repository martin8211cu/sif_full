<cfset msg = "">


<cftry>
	<cfset aplicar = 1>
	<cfif isDefined('form.btnEliminar')> <cfset aplicar = 3> </cfif>

	<cfif aplicar eq 1>
		<cfquery name="q_Incidencias" datasource="#session.DSN#">
			select id,TransaccionPendiente from CRCIncidenciasCuenta 
				where 
					id in (#form.chk#) 
					and ecodigo = #session.ecodigo# 
					and TransaccionPendiente = 0
		</cfquery>

		<cfloop query="q_Incidencias">
			<cfinvoke  component ="crc.Componentes.incidencias.CRCIncidencia" method="AplicarIncidencia">
				<cfinvokeargument name="ID_Incidencia" value="#q_Incidencias.id#" >
			</cfinvoke>
		</cfloop>
	</cfif>

	
	<cfquery name="q_update" datasource="#session.DSN#">
		update CRCIncidenciasCuenta set 
				TransaccionPendiente = #aplicar#
			,	updatedat = CURRENT_TIMESTAMP
			,	Usumodif = #session.usucodigo#
			where id in (#form.chk#)
				and TransaccionPendiente = 0
				and ecodigo = #session.ecodigo#;
	</cfquery>

	<cfif aplicar eq 1>
		<cfset msg = "Se aplicaron correctamente">
	<cfelse>
		<cfset msg = "Se rechazaron correctamente">
	</cfif>

<cfcatch>
	<cfset msg = "#cfcatch.message#">
</cfcatch>
</cftry>

<form name="form1" action="AplicarIncidencia.cfm" method="post">
	<input type="hidden" name="resultT" value="<cfoutput>#msg#</cfoutput>">
</form>
<script>
	document.form1.submit();
</script>