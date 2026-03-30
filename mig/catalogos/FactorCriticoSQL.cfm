<cfif isdefined ('form.Lista')>
	<cflocation url="FactorCritico.cfm">
</cfif>
<cfif isdefined('form.Importar')>
	<cflocation url="FactorCriticoImportar.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.FactorCritico" method="Alta" returnvariable="MIGFCid">
			<cfinvokeargument name="MIGFCcodigo" 	value="#form.MIGFCcodigo#"/>
			<cfinvokeargument name="MIGFCdescripcion" 	value="#form.MIGFCdescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="CodFuente" 		value="1"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.CAMBIO')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.FactorCritico" method="Cambio" >
			<cfinvokeargument name="MIGFCdescripcion" 	value="#form.MIGFCdescripcion#"/>
			<cfinvokeargument name="MIGFCid" 		value="#form.MIGFCid#"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.FactorCritico" method="Baja" >
			<cfinvokeargument name="MIGFCid" 		value="#form.MIGFCid#"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="FactorCritico.cfm">
</cfif>
<cflocation url="FactorCritico.cfm">
