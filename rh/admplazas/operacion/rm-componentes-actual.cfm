<!--- NOTAS:
		1. 	rsComponentesActual y rsComponentesPropuestos estan definidos en registro-movimientos-form.cfm
--->

<!---
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0"  >
		<tr>
			<td  nowrap class="tituloListas">Salario Total</td>
			<td nowrap class="tituloListas" align="right"><cfif len(trim(LTPTotal.monto))>#LSNumberFormat(LTPTotal.monto, ',9.00')#</cfif></td>
		</tr>	
		
		<tr>
			<td height="25" nowrap ></td>
		</tr>	

		<tr>
			<td class="tituloListas"><strong>Componente</strong></td>
			<td class="tituloListas" align="right"><strong>Monto</strong></td>
		</tr>				  

		<cfset completar = '' >
		<cfif isdefined("rsComponentesActual") and rsComponentesActual.recordCount GT 0>
			<cfset completar = valuelist(rsComponentesActual.CSid) >
			<cfloop query="rsComponentesActual">
				<tr>
					<td height="25" nowrap><strong>#rsComponentesActual.CSdescripcion#</strong></td>
					<td height="25" align="right" nowrap>#LSCurrencyFormat(rsComponentesActual.Monto,'none')#</td>
		  		</tr>
	  		</cfloop>

		</cfif>
		<!--- Esto es solo para hacer los portlets de igual tamaño --->
		<cfloop query="rsComponentesPropuestos">
			<cfif not listfind(completar, rsComponentesPropuestos.CSid)>
				<tr>
					<td height="25" nowrap>&nbsp;</td>
					<td height="25" align="right" nowrap>&nbsp;</td>
				</tr>
			</cfif>
		</cfloop>

	</table>
</cfoutput>
--->


<cfinvoke component="rh.Componentes.RH_CompSalarial" method="pComponentes" returnvariable="result">
	<cfinvokeargument name="query" value="#rsComponentesActual#">
	<cfinvokeargument name="totalComponentes" value="#LTPTotal.monto#">
	<cfinvokeargument name="permiteAgregar" value="false">
	<cfinvokeargument name="unidades" value="Cantidad">
	<cfinvokeargument name="montobase" value="MontoBase">
	<cfinvokeargument name="montores" value="Monto">
	<cfinvokeargument name="readonly" value="true">
	<cfinvokeargument name="incluyeHiddens" value="false">
</cfinvoke>
