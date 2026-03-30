
<table width="100%">
	<tr>		
		<td class="tituloListas"><strong>Val</strong></td>
		<td class="tituloListas"><strong>Ant</strong></td>
		<td class="tituloListas"><strong>Var</strong></td>
	</tr>	
	
	<!--- Componente que me devuelve los indicadores del usuario en un query (indicador,parametro y valor)---->
	<cfinvoke component="IndicadoresdeUsuario" method="IndicadoresdeUsuario" Usuario="#session.Usucodigo#" returnvariable="Indicadores" >
	<!--- Recorrer el query devuelto por el componente ---->
	<cfoutput query="Indicadores" group="indicador">		
		<cfset vsParametro = ''>				
		<!--- Concatenar los valores (campo valor) en una sola cadena por c/indicador ---->
		<cfoutput>
			<cfset vsParametro = vsParametro &','& Indicadores.valor><!---Indicadores.parametro>--->
		</cfoutput>

		<!----Funcion para traer y pintar los datos ---->
		<cfset TraerValores(vsParametro,Indicadores)>
				
		<!--- Función para pintar los valores ---->
		<cffunction name="TraerValores" access="public" output="true"><!---- returntype="query" ---->
		
			<cfargument name='vsParametro'	type='string' 	required='true'>	<!--- Recibe los valores concatenados (necesarios para obtener el valor del indicador) ---->
			<cfargument name='Indicadores'	type='query' 	required='true'>	<!--- Recibe el query de indicadores ---->
			<!---- Se invoca un componente que trae los datos a pintar ---->			
			<cfinvoke component="obtenerValorIndicador" method="obtenerValorIndicador" indicador="#Indicadores.indicador#" parametro="#vsParametro#" returnvariable="valores" >								
			<!--- Si no hay datos llama el procedimiento que carga los mismos ---->
			<cfif valores.RecordCount EQ 0>											
				<cfset procedimiento = ''>
				<!--- Obtener la dirección y nombre del componente ---->
				<cfquery name="rsCalculo" datasource="asp">
					select calculo
					from Indicador
					where indicador = <cfqueryparam cfsqltype="cf_sql_char" value="#Indicadores.indicador#">
				</cfquery>
				
				<!--- Si hay un componente definido ---->								
				<cfif rsCalculo.RecordCount NEQ 0 and isdefined("vsParam") and vsParam NEQ ''>					
					<cfif find('/',rsCalculo.calculo,1) EQ 1>
						<cfset procedimiento = mid(rsCalculo.calculo,2,len(rsCalculo.calculo))>
					</cfif>	
					<cfset procedimiento2 = mid(procedimiento,1,find('.',procedimiento,1)-1)>
					<cfset procedimiento3 = replace(procedimiento2,'/','.',"all")>
					<!--- Se obtienen los parametros adicionales ---->
					<cfquery name="rsParametros" datasource="asp">
						select 	a.indicador, 
								a.parametro, 
								valor 
						from IndicadorParam  a						 
						left outer join IndicadorArgumento b
							on a.parametro=b.parametro
							and a.indicador=b.indicador
							and b.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">						 
						where a.indicador=<cfqueryparam cfsqltype="cf_sql_char" value="#Indicadores.indicador#"> 
					</cfquery>
	
					<!---- Llamar al procedimiento que hace los cálculos y los carga en la tabla según el campo calculo de la BD's ---->												
					<cfinvoke component="#procedimiento3#"  method="calcular" returnvariable="valores">
						<cfinvokeargument name="datasource" value="#session.dsn#">
						<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
						<cfinvokeargument name="indicador" value="#Indicadores.indicador#">
						<cfinvokeargument name="CEcodigo" value="#session.CEcodigo#">
						<cfinvokeargument name="fecha" value="#now()#">
						<cfloop query="rsParametros">
							<cfinvokeargument name="#rsParametros.parametro#" value="#rsParametros.valor#">
						</cfloop>																							
					</cfinvoke>
					<cfset TraerValores(vsParametro,Indicadores)>				
				<cfelse><!---- Si el valor de parametros en IndicadorValor es '' ---->
					<tr>						
						<td class="listaNon">#Indicadores.indicador#</td>
						<td class="listaNon" >?</td>
						<td class="listaNon">?</td>
					</tr>
				</cfif>					
			<cfelse>																		
				<cfset anterior=''>
				<cfset actual=''>
				<cfloop query="valores"><!----La funcion devuelve 2 registros ordenados en forma descendente: La última fecha y la anterior a la última ---->				
					<cfif valores.CurrentRow EQ 1>
						<cfset actual = valores.valor>
					<cfelseif valores.CurrentRow EQ 2>
						<cfset anterior = valores.valor>
					</cfif>													
				</cfloop>
				<tr>						
					<td class="listaNon">#valores.texto#</td>
					<td class="listaNon" title="Valor a la fecha:#LSDateFormat(valores.fecha,'dd/mm/yyyy')#">#LSNumberFormat(anterior,'0.99')#</td>
					<td class="listaNon">#LSNumberFormat(actual,'0.99')#</td>
				</tr>
			</cfif>
		</cffunction>
	</cfoutput>		
</table>