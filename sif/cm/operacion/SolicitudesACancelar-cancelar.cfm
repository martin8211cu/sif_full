<cfif isdefined("form.chk") 
		and len(trim(form.chk)) 
		and isdefined("form.btnCancelar") 
		and isdefined("form.textarea_justificacion") 
		and len(trim(form.textarea_justificacion))>
	<cfset ESjustificacion = form.textarea_justificacion>
	<cfloop list="#form.chk#" index="ESidsolicitud">		
		<cfinvoke 
				component="sif.Componentes.CM_CancelaSolicitud"
				method="CM_CancelaSolicitud"
				returnvariable="NAPcancel">
			<cfinvokeargument name="ESidsolicitud" value="#ESidsolicitud#">
			<cfinvokeargument name="ESjustificacion" value="#ESjustificacion#">
		</cfinvoke>
	</cfloop>
</cfif>