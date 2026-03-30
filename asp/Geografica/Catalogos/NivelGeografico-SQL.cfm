<cfif isdefined('alta')>
	<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnAltaNivel" returnvariable="NGid">
			<cfinvokeargument name="Ppais"  		value="#form.Ppais#">
			<cfinvokeargument name="NGcodigo"  		value="#form.NGcodigo#">
			<cfinvokeargument name="NGDescripcion"  value="#form.NGDescripcion#">
		<cfif isdefined('form.CURP')>
			<cfinvokeargument name="CURP" 		value="true">
		</cfif>
		<cfif isdefined('form.NGidRef') and len(trim(form.NGidRef))>
			<cfinvokeargument name="NGidPadre"  	value="#form.NGidRef#">
		</cfif>
	</cfinvoke>
<cfelseif isdefined('cambio')>
	<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnCambioNivel" returnvariable="NGid">
			<cfinvokeargument name="NGid"  			value="#form.NGid#">
			<cfinvokeargument name="Ppais"  		value="#form.Ppais#">
			<cfinvokeargument name="NGcodigo"  		value="#form.NGcodigo#">
			<cfinvokeargument name="NGDescripcion"  value="#form.NGDescripcion#">
		<cfif isdefined('form.CURP')>
			<cfinvokeargument name="CURP" 		value="true">
		</cfif>
		<cfif isdefined('form.NGidRef') and len(trim(form.NGidRef))>
			<cfinvokeargument name="NGidPadre"  	value="#form.NGidRef#">
		</cfif>
			<cfinvokeargument name="ts_rversion"  	value="#form.ts_rversion#">
			<cfinvokeargument name="Action"  		value="NivelGeografico.cfm">
	</cfinvoke>
<cfelseif isdefined('baja')>
	<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnBajaNivel">
			<cfinvokeargument name="NGid"  			value="#form.NGid#">
			<cfinvokeargument name="ts_rversion"  	value="#form.ts_rversion#">
			<cfinvokeargument name="Action"  		value="NivelGeografico.cfm">
	</cfinvoke>
</cfif>
<html><head></head><body>
<cfoutput>
<form name="form1" method="post" action="NivelGeografico.cfm">
	<cfif not isdefined('regresar') and not isdefined('form.nuevo') and isdefined('NGid')>
	<input type="hidden" id="NGid" name="NGid" value="#NGid#"/>
	</cfif>
	<cfif not isdefined('regresar') and isdefined('form.Ppais')>
	<input type="hidden" id="Ppais" name="Ppais" value="#form.Ppais#"/>
	</cfif>
</form>
</cfoutput>
<script language="javascript1.2" type="text/javascript">
	document.form1.submit();
</script>
</body></html>
