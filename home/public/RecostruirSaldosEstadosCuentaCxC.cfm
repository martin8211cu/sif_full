<cfflush interval="10">
<cfloop from="2010" to="2014" index="p">
	<cfloop from="1" to="12" index="m">
		<cfoutput>Generando #m#/#p#...<br /></cfoutput>
		<cfif m EQ 12>
			<cfset PeriodoSiguiente = p +1>
			<cfset MesSiguiente     = 1>
		<cfelse>
			<cfset PeriodoSiguiente = p>
			<cfset MesSiguiente     = m +1>
		</cfif>
		
		<cfquery datasource="#session.dsn#">
			delete from SNSaldosIniciales 
			 where Speriodo  = #PeriodoSiguiente#
			   and Smes      = #MesSiguiente# 
		</cfquery>
			<cfquery datasource="#session.dsn#">
			delete from SNSaldosInicialesD 
			 where Speriodo  = #PeriodoSiguiente#
			   and Smes      = #MesSiguiente# 
		</cfquery>
		<cfinvoke component="sif.Componentes.CG_CierreAuxiliares" method="CreaSIDocsCC" returnvariable="TCC_SIdocumentos">
		</cfinvoke>
		<cfinvoke component="sif.Componentes.CC_CierreMesCxC" method="SISaldosIniciales">
			<cfinvokeargument name="Ecodigo" 		value="#session.Ecodigo#">
			<cfinvokeargument name="PeriodoCerrado" value="#p#">
			<cfinvokeargument name="MesCerrado" 	value="#m#">
			<cfinvokeargument name="debug" 			value="false">
			<cfinvokeargument name="SIdocumentos" 	value="#TCC_SIdocumentos#">
			<cfinvokeargument name="conexion" 		value="minisif">
		</cfinvoke>
		<cfabort>
	</cfloop>
</cfloop>