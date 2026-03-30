<cfif isdefined("form.chk") 
		and len(trim(form.chk)) 
		and isdefined("form.btnCancelar") 
		and isdefined("form.textarea_justificacion") 
		and len(trim(form.textarea_justificacion))>
		
	<cfset ESjustificacion = form.textarea_justificacion>
	<cfloop list="#form.chk#" index="llaves">
		<cfset llaves2 = ListToArray(llaves,'|')>
		<cfinvoke 
				component="sif.Componentes.CM_CancelaSolicitud"
				method="CM_CancelaLineasSolicitud"
				returnvariable="NAPcancel">
			<cfinvokeargument name="ESidsolicitud" value="#llaves2[1]#"> 
			<cfinvokeargument name="ESjustificacion" value="#ESjustificacion#">
			<cfinvokeargument name="DSlinea" value="#llaves2[2]#">
		</cfinvoke>
	</cfloop>
</cfif>