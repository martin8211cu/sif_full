<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
	  <tr>
		<td class="#Session.Preferences.Skin#_thcenter" colspan="4"><div align="center"><cf_translate key="LB_Componentes_Actuales">Componentes Actuales</cf_translate></div></td>
	  </tr>
	  <tr>
		<td>
			<cfif rsAccion.RHTccomp eq 1>
			
				<cfif isdefined("rsSumComponentesActual") and  rsSumComponentesActual.recordCount gt 0>
					<cfinvoke component="rh.Componentes.RH_CompSalarial" method="pComponentes" returnvariable="result">
						<cfinvokeargument name="query" value="#rsComponentesActual#">
						<cfinvokeargument name="totalComponentes" value="#rsSumComponentesActual.Total#">
						<cfinvokeargument name="permiteAgregar" value="false">
						<cfinvokeargument name="unidades" value="DLTunidades">
						<cfinvokeargument name="montobase" value="DLTmontobase">
						<cfinvokeargument name="montores" value="DLTmonto">
						<cfinvokeargument name="readonly" value="true">
						<cfinvokeargument name="incluyeHiddens" value="false">
					</cfinvoke>
				<cfelse>
					<cfinvoke component="rh.Componentes.RH_CompSalarial" method="pComponentes" returnvariable="result">
						<cfinvokeargument name="query" value="#rsComponentesActual#">
						<cfinvokeargument name="totalComponentes" value="0.00">
						<cfinvokeargument name="permiteAgregar" value="false">
						<cfinvokeargument name="unidades" value="DLTunidades">
						<cfinvokeargument name="montobase" value="DLTmontobase">
						<cfinvokeargument name="montores" value="DLTmonto">
						<cfinvokeargument name="readonly" value="true">
						<cfinvokeargument name="incluyeHiddens" value="false">
					</cfinvoke>
				</cfif>	
				
			<cfelse>
				<cfquery name="rsMostrarSalarioNominal" datasource="#session.DSN#">
					select coalesce(Pvalor,'0') as  Pvalor
					from RHParametros
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Pcodigo = 1040
				</cfquery>
				<cfinvoke component="rh.Componentes.RH_CompSalarial" method="pComponentes" returnvariable="result">
					<cfinvokeargument name="query" value="#rsComponentesActual#">
					<cfinvokeargument name="totalComponentes" value="#rsSumComponentesActual.Total#">
					<cfinvokeargument name="MostrarSalarioNominal" value="#rsMostrarSalarioNominal.Pvalor#">
					<cfinvokeargument name="Tiponomina" value="#rsEstadoActual.Tcodigo#">
					<cfinvokeargument name="permiteAgregar" value="false">
					<cfinvokeargument name="unidades" value="DLTunidades">
					<cfinvokeargument name="montobase" value="DLTmontobase">
					<cfinvokeargument name="montores" value="DLTmonto">
					<cfinvokeargument name="readonly" value="true">
					<cfinvokeargument name="incluyeHiddens" value="false">
				</cfinvoke>			
				
			</cfif>
			

		</td>
	  </tr>
	</table>
</cfoutput>
