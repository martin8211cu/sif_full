<cfif isdefined ('form.Lista')>
	<cflocation url="AccionEstrategica.cfm">
</cfif>

<cfif isdefined ('form.Importar')>
	<cflocation url="AccionEstrategicaImportar.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.AccionEstrategica" method="Alta" returnvariable="MIGAEid">
			<cfinvokeargument name="MIGAEcodigo" 	value="#form.MIGAEcodigo#"/>
			<cfinvokeargument name="MIGAEdescripcion" 	value="#form.MIGAEdescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="CodFuente" 		value="1"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.CAMBIO')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.AccionEstrategica" method="Cambio" >
			<cfinvokeargument name="MIGAEdescripcion" 	value="#form.MIGAEdescripcion#"/>
			<cfinvokeargument name="MIGAEid" 		value="#form.MIGAEid#"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.AccionEstrategica" method="Baja" >
			<cfinvokeargument name="MIGAEid" 		value="#form.MIGAEid#"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="AccionEstrategica.cfm">
</cfif>
<cflocation url="AccionEstrategica.cfm">
