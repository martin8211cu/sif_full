<cfif isdefined ('form.Lista')>
	<cflocation url="Lineas.cfm">
</cfif>
<cfif isdefined ('form.Importar')>
	<cflocation url="LineasImportador.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Lineas" method="Alta" returnvariable="MIGProLineas">
			<cfinvokeargument name="MIGProLincodigo" 	value="#form.MIGProLincodigo#"/>
			<cfinvokeargument name="MIGProLindescripcion" 	value="#form.MIGProLindescripcion#"/>
			<cfinvokeargument name="Dactiva" 		value="1"/>
			<cfinvokeargument name="CodFuente" 		value="1"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.CAMBIO')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Lineas" method="Cambio" >
			<cfinvokeargument name="MIGProLindescripcion" 	value="#form.MIGProLindescripcion#"/>
			<cfinvokeargument name="MIGProLinid" 		value="#form.MIGProLinid#"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Lineas" method="Baja" >
			<cfinvokeargument name="MIGProLinid" 		value="#form.MIGProLinid#"/>
		</cfinvoke>	
	</cftransaction>
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="Lineas.cfm">
</cfif>
<cflocation url="Lineas.cfm">
