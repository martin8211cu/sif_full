<cfif isdefined("form.chk") and len(trim(form.chk)) 
	and isdefined("form.textarea_justificacion") and len(trim(form.textarea_justificacion))
	and isdefined("form.btnCancelar")>
		
	<cfset ESjustificacion = form.textarea_justificacion>
	<cfloop list="#form.chk#" index="llaves">
		<cfset llaves2 = ListToArray(llaves,'|')>
		<cfset DScantcancel = "saldo_" & llaves2[1] & "_" & llaves2[2]>
		 		
		<cfinvoke 
				component="sif.Componentes.CM_CancelaSolicitud"
				method="CM_CancelaLineasSolicitud"
				returnvariable="NAPcancel">
			<cfinvokeargument name="ESidsolicitud" value="#llaves2[1]#">
			<cfinvokeargument name="DSlinea" value="#llaves2[2]#">
			<cfinvokeargument name="DScantcancel" value="#form[DScantcancel]#"> 
			<cfinvokeargument name="ESjustificacion" value="#ESjustificacion#">
			<cfif not(IsDefined("session.compras.solicitante") and Len(Trim(session.compras.solicitante)))>
				<cfinvokeargument name="Solicitante" value="0">
			</cfif>
		</cfinvoke> 
	</cfloop>
</cfif>