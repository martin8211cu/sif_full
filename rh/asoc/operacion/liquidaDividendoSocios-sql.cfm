<cfif isdefined("url.liquidar")>
	<cftransaction>
		<cfinvoke component="rh.asoc.Componentes.RH_DistribucionDividendos" method="calcular" >
			<cfinvokeargument name="periodo" value="#url.periodo#" >
			<cfinvokeargument name="monto" 	 value="#replace(url.monto, ',', '', 'all')#" >
		</cfinvoke>
	</cftransaction>
</cfif>

<cfif isdefined("url.aplicar")>
	<cftransaction>
		<cfinvoke component="rh.asoc.Componentes.RH_DistribucionDividendos" method="aplicar" >
			<cfinvokeargument name="periodo" value="#url.periodo#" >
		</cfinvoke>
	</cftransaction>
	<cflocation url="liquidaDividendoSocios.cfm">
</cfif>


<cflocation url="liquidaDividendoSocios-listado.cfm?periodo=#url.periodo#">



