<cfif IsDefined('url.ldap')>
	<cfinclude template="parametros-ldap-apply.cfm">
<cfelse>
	
	
	<cfif isdefined("Form.agente")>
		<cfinclude template="parametros-ag-params.cfm">
	<cfelse>	
		<cfinclude template="parametros-params.cfm">
	</cfif>
	
	<cfif isdefined("Form.Guardar")>
	
		<cfinclude template="parametros-config.cfm">
	
		<cfloop from="1" to="#ArrayLen(parametros)#" index="i">
	
			<cfif isdefined("Form.param_#parametros[i]#")>
				<cfinvoke component="saci.comp.ISBparametros" method="Alta_Cambio">
					<cfinvokeargument name="Pcodigo" value="#parametros[i]#">
					<cfinvokeargument name="Pdescripcion" value="#parametrosDesc[parametros[i]]#">
					<cfinvokeargument name="Pvalor" value="#Form['param_'&parametros[i]]#">
				</cfinvoke>
			</cfif>
	
		</cfloop>
	
	</cfif>	
	<cflocation url="#Request.redirect#">
</cfif>