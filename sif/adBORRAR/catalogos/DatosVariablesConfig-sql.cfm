<cfparam name="form.DVTcodigo" default="">
<cfif not isdefined('Form.TipoConfig') and isdefined('url.TipoConfig')>
	<cfset Form.TipoConfig = url.TipoConfig>
</cfif>
<cfset Param="DVTcodigo=#form.DVTcodigo#&TipoConfig=#Form.TipoConfig#">
<cfif form.TipoConfig EQ 'DatoVariable'>
	<cfset llave='DVid'>
<cfelseif form.TipoConfig EQ 'Evento'>
	<cfset llave='TEVid'>
<cfelse>
	<cfthrow message="Tipo de Configuración no Implementada">
</cfif>

<cfif isdefined('ALTA')>
	<cfinvoke component="sif.Componentes.DatosVariables" method="ALTAConfig">
		<cfinvokeargument name="DVTcodigo" 		value="#form.DVTcodigo#">
		<cfinvokeargument name="#llave#"  	    value="#form.DatoAconfigurar#">
	  <cfif isdefined('form.DVCidTablaCnf')>
		<cfinvokeargument name="DVCidTablaCnf" 	value="#form.DVCidTablaCnf#">
	  </cfif>
	</cfinvoke>
<cfelseif isdefined('BAJA')>
	<cfinvoke component="sif.Componentes.DatosVariables" method="BAJAConfig">
		<cfinvokeargument name="DVTcodigo" 			value="#form.DVTcodigo#">
		<cfinvokeargument name="#llave#"  		 	value="#form.id_List#">
		<cfif isdefined('form.DVCidTablaCnf_List') and len(trim(form.DVCidTablaCnf_List)) GT 0>
			<cfinvokeargument name="DVCidTablaCnf" 	value="#form.DVCidTablaCnf_List#">
		</cfif>
	</cfinvoke>
</cfif>
<cflocation url="DatosVariablesConfig.cfm?#Param#">