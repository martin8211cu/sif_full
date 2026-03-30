<cfif isdefined ('form.ASDir')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Gerencia" method="AgregarDepartamentos" >
			<cfinvokeargument name="MIGGid" 	value="#form.MIGGid#"/>
			<cfinvokeargument name="Dcodigo" 		value="#form.Dcodigo#"/>
			<cfinvokeargument name="Deptocodigo" 		value="#form.Deptocodigo#"/>
		</cfinvoke>	
	</cftransaction>
	<cfset modo='CAMBIO'>
	<cflocation url="Gerencia.cfm?MIGGid=#form.MIGGid#&modo=#modo#&Tab=2">
</cfif>
<cfif isdefined ('form.Lista')>
	<cflocation url="Gerencia.cfm">
</cfif>
<cfif isdefined ('form.ALTA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Gerencia" method="Alta" returnvariable="LvarMIGGid">
			<cfinvokeargument name="MIGGcodigo" 	value="#form.MIGGcodigo#"/>
			<cfinvokeargument name="MIGGdescripcion" 	value="#form.MIGGdescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="MIGSDid" 		value="#form.MIGSDid#"/>
			<cfinvokeargument name="CodFuente" 		value="1"/>
		</cfinvoke>	
	</cftransaction>
	<cfif isdefined ('form.Gerencia')>
		<cfoutput>
				<script language="JavaScript1.2">
					window.close();
					window.parent.opener.document.form2.MIGGid.value=#LvarMIGGid#;
					
				<!---	obj.options[obj.length] = new Option('#form.MIGSDdescripcion#','#MIGSDid#');
					obj.selectedIndex=obj.length-1;--->
				</script>
		</cfoutput>
			<cfabort>
	</cfif>
<cfset modo='CAMBIO'>
<cflocation url="Gerencia.cfm?MIGGid=#LvarMIGGid#&modo=#modo#&Tab=1">
</cfif>
<cfif isdefined ('form.CAMBIO')>

	<cftransaction>
		<cfinvoke component="mig.Componentes.Gerencia" method="Cambio" >
			<cfinvokeargument name="MIGGdescripcion" 	value="#form.MIGGdescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="MIGGid" 		value="#form.MIGGid#"/>
			<cfinvokeargument name="MIGSDid" 		value="#form.MIGSDid#"/>
		</cfinvoke>	
	</cftransaction>
<cfset modo='CAMBIO'>
<cflocation url="Gerencia.cfm?MIGGid=#form.MIGGid#&modo=#modo#&Tab=1">
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Gerencia" method="Baja">
			<cfinvokeargument name="MIGGid" 		value="#form.MIGGid#"/>
		</cfinvoke>	
	</cftransaction>
<cflocation url="Gerencia.cfm">
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="Gerencia.cfm?Nuevo&Tab=1">
</cfif>
<cfif isdefined('form.MIGGid')>
	<cfset modo='CAMBIO'>
	<cflocation url="Gerencia.cfm?MIGGid=#form.MIGGid#&modo=#modo#&Tab=2">
</cfif>
