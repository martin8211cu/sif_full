<cfcomponent output="no" hint="Tarea de Cambio de Forma de Cobro">
	<cffunction name="ejecutar" access="public" returntype="void" output="false">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="TPid" type="numeric" required="yes">
		<cfargument name="CTid" type="numeric" required="yes">
		<cfargument name="Contratoid" type="numeric" required="no">
		<cfargument name="LGnumero" type="numeric" required="no">
		<cfargument name="TPxml" type="xml" required="yes">
		
		<cfinvoke component="saci.comp.ISBcuentaCobro" method="Cambio">	<!--- ejecutar la tarea programada --->
			<cfinvokeargument name="CTid" 				value="#Arguments.CTid#">
			<cfinvokeargument name="CTcobro" 			value="#TPxml.cambioFormaCobro.datosFormaCobro.XmlAttributes.CTcobro#">
			<cfinvokeargument name="CTtipoCtaBco" 		value="#TPxml.cambioFormaCobro.datosFormaCobro.XmlAttributes.CTtipoCtaBco#">
			<cfinvokeargument name="CTbcoRef" 			value="#TPxml.cambioFormaCobro.datosFormaCobro.XmlAttributes.CTbcoRef#">
			<cfinvokeargument name="CTmesVencimiento" 	value="#TPxml.cambioFormaCobro.datosFormaCobro.XmlAttributes.CTmesVencimiento#">
			<cfinvokeargument name="CTanoVencimiento" 	value="#TPxml.cambioFormaCobro.datosFormaCobro.XmlAttributes.CTanoVencimiento#">
			<cfinvokeargument name="EFid" 				value="#TPxml.cambioFormaCobro.datosFormaCobro.XmlAttributes.EFid#">
			<cfinvokeargument name="MTid" 				value="#TPxml.cambioFormaCobro.datosFormaCobro.XmlAttributes.MTid#">
			<cfinvokeargument name="PpaisTH" 			value="#TPxml.cambioFormaCobro.datosFormaCobro.XmlAttributes.PpaisTH#">
			<cfinvokeargument name="CTcedulaTH" 		value="#TPxml.cambioFormaCobro.datosFormaCobro.XmlAttributes.CTcedulaTH#">
			<cfinvokeargument name="CTnombreTH" 		value="#TPxml.cambioFormaCobro.datosFormaCobro.XmlAttributes.CTnombreTH#">
			<cfinvokeargument name="CTapellido1TH" 		value="#TPxml.cambioFormaCobro.datosFormaCobro.XmlAttributes.CTapellido1TH#">
			<cfinvokeargument name="CTapellido2TH" 		value="#TPxml.cambioFormaCobro.datosFormaCobro.XmlAttributes.CTapellido2TH#">
		</cfinvoke>
		 
	</cffunction>
</cfcomponent>