<cfif (isdefined("url.PAcodigo") and not isdefined("form.PAcodigo"))>
	<cfset form.PAcodigo = url.PAcodigo>
</cfif> 	

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td width="35%" valign="top">			
		<cfinvoke component="aspAdmin.Componentes.pListasASP" 
				  method="pLista" 
				  returnvariable="pListaTiposIdentif">
			<cfinvokeargument name="tabla" value="
					PaqueteTarifas pt
					, Paquete p
					, TarifaCalculoIndicador tc"/>
			<cfinvokeargument name="columnas" value="
					convert(varchar,pt.PAcodigo) as PAcodigo
					, convert(varchar,pt.TCcodigo) as TCcodigo
					, isnull(modulo,'*') as modulo
					, PTmeses
					, TCnombre"/>
			<cfinvokeargument name="desplegar" value="TCnombre,PTmeses"/>
			<cfinvokeargument name="cortes" value="modulo"/>
			<cfinvokeargument name="etiquetas" value="Indicador&nbsp;Tarifario, Meses"/>
			<cfinvokeargument name="formatos"  value=""/>
			<cfinvokeargument name="filtro" value="
					pt.PAcodigo=#form.PAcodigo#
					and pt.PAcodigo=p.PAcodigo
					and pt.TCcodigo=tc.TCcodigo order by modulo"/>
			<cfinvokeargument name="align" value="left,left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="keys" value="PAcodigo,TCcodigo"/>
			<cfinvokeargument name="irA" value="paquete.cfm"/>
			<cfinvokeargument name="formName" value="form_listaPaqueteTarifas"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>				
	</td>
	<td width="65%" valign="top">
		<cfinclude template="paqueteTarifas_form.cfm">
	</td>
  </tr>
</table>	
