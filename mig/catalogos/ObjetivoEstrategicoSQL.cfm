<cfif isdefined ('form.Lista')>
	<cflocation url="ObjetivoEstrategico.cfm">
</cfif>

<cfif isdefined ('form.Importar')>
	<cflocation url="ObjetivoEstrategicoImportar.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.ObjetivoEstrategico" method="Alta" returnvariable="MIGOEid">
			<cfinvokeargument name="MIGOEcodigo" 	value="#form.MIGOEcodigo#"/>
			<cfinvokeargument name="MIGOEdescripcion" 	value="#form.MIGOEdescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="CodFuente" 		value="1"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.CAMBIO')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.ObjetivoEstrategico" method="Cambio" >
			<cfinvokeargument name="MIGOEdescripcion" 	value="#form.MIGOEdescripcion#"/>
			<cfinvokeargument name="MIGOEid" 		value="#form.MIGOEid#"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.ObjetivoEstrategico" method="Baja" >
			<cfinvokeargument name="MIGOEid" 		value="#form.MIGOEid#"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="ObjetivoEstrategico.cfm">
</cfif>
<cflocation url="ObjetivoEstrategico.cfm">
