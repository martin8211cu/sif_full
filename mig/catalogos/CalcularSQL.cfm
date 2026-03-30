

<cfif isdefined ('form.Aceptar')>
	
	<cfset recalc = false>
	<cfif isdefined('form.recalcular')>
		<cfset recalc = true>
	</cfif>
		
	<cfif isdefined('form.tipoFiltro') and form.tipoFiltro EQ 1>	<!---periodo actual--->
		<cfinvoke component="mig.Componentes.Procesos" method="GetMetrica" returnvariable="resultt">
			<cfinvokeargument name="MIGMid" 			value="#form.MIGMid#"/>
			<cfinvokeargument name="CEcodigo" 			value="#session.CEcodigo#"/>
			<cfinvokeargument name="Recalcular" 		value="#recalc#"/>
		</cfinvoke>
		<!---<cfinvokeargument name="Periodo" 			value="#form.periodo#"/>--->
	
	<cfelseif isdefined('form.tipoFiltro') and form.tipoFiltro EQ 2>	<!---periodo especifico--->
			<cfinvoke component="mig.Componentes.Procesos" method="GetMetrica" returnvariable="resultt">
			<cfinvokeargument name="MIGMid" 			value="#form.MIGMid#"/>
			<cfinvokeargument name="Periodo" 				value="#form.periodo#"/>
			<cfinvokeargument name="CEcodigo" 			value="#session.CEcodigo#"/>
			<cfinvokeargument name="Recalcular" 		value="#recalc#"/>
			</cfinvoke>
	<cfelseif isdefined('form.tipoFiltro') and form.tipoFiltro EQ 3>	<!---rango de periodos--->
		<cfinvoke component="mig.Componentes.Procesos" method="GetMetrica" returnvariable="resultt">
			<cfinvokeargument name="MIGMid" 			value="#form.MIGMid#"/>
			<cfinvokeargument name="Pinicio" 			value="#form.Pinicio#"/>
			<cfinvokeargument name="Pfin" 				value="#form.Pfin#"/>
			<cfinvokeargument name="CEcodigo" 			value="#session.CEcodigo#"/>
			<cfinvokeargument name="Recalcular" 		value="#recalc#"/>
			</cfinvoke>
	<cfelseif isdefined('form.tipoFiltro') and form.tipoFiltro EQ 0>	<!---rango de periodos--->
		<cfinvoke component="mig.Componentes.Procesos" method="Todos" returnvariable="result"></cfinvoke><cfabort>
	<cfelse>
		<center><strong>Debe definir el periodo que va a calcular.</strong></center><cfabort>
	</cfif>
	
	<cfif form.esMetric is 'M'>
		<cflocation url="Metricas.cfm?MIGMid=#form.MIGMid#&modo=#form.modo#">
	</cfif>
	
	<cfif form.esMetric is 'I'>
		<cflocation url="Indicadores.cfm?MIGMid=#form.MIGMid#&modo=#form.modo#">
	</cfif>
	
</cfif>



<!---<cfif form.esMetric is 'I'>
			<cfinvoke component="mig.Componentes.Procesos" method="GetIndicador" returnvariable="resultt">
			<cfinvokeargument name="MIGMid" 			value="#form.MIGMid#"/>
			<cfinvokeargument name="Periodo" 				value="#form.periodo#"/>
			<cfinvokeargument name="CEcodigo" 			value="#session.CEcodigo#"/>
			</cfinvoke>
		</cfif>
		<cfif form.esMetric is 'M'>
			<cfinvoke component="mig.Componentes.Procesos" method="GetMetrica" returnvariable="resultt">
			<cfinvokeargument name="MIGMid" 			value="#form.MIGMid#"/>
			<cfinvokeargument name="Periodo" 				value="#form.periodo#"/>
			<cfinvokeargument name="CEcodigo" 			value="#session.CEcodigo#"/>
			</cfinvoke>
		</cfif>--->




