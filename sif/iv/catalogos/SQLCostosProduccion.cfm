<cfoutput>
	<!-----	Se reciben las siguientes variables:
			1. form.IDS = Vienen todos los CTDid de la lista separados por una coma (,)
			2. form.Costo[CTDid]:  La variable se llama Costo1000000000000025 (Costo + CTDid), contiene el costo cambiado si fue modificado 
			3. form.CostoAnterior[CTDid]: Igual que el anterior pero conserva el costo del articulo que se tenia anteriormente (sin modificar)			 
	--->
	<!---- Si esta definida la variable(IDS) que contiene los CTDid de la tabla CostoProduccionSTD y no es vacía ----->
	<cfif isdefined("form.IDS") and len(trim(form.IDS))>
		<!--- Se hace un ciclo sobre la variable, el separador es la coma (,) en #i# se guarda el valor de la variable (osea el CTDid) ---->
		<cfloop list="#form.IDS#" index="i">
			<!--- Si esta definido un costo (CTDcosto) y no es vacio.... ---->
			<!-----	1. Quita el formato del monto (las comas) 
					2. Compara que el costo que mostrado sea diferente al costo original 
			---->
			<cfquery name="update" datasource="#Session.DSN#">
				update CostoProduccionSTD 
				set	
				<cfif isdefined("form.Costo#i#") and replace(form['Costo#i#'],',','','all') NEQ form['CostoAnterior#i#']>
					CTDcosto = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form['Costo#i#'],',','','all')#" >,
				<cfelse>
					CTDcosto = CTDcosto,
				</cfif>	
				<cfif isdefined("form.CTDprecio#i#") and  replace(form['CTDprecio#i#'],',','','all') NEQ form['CTDprecioAnterior#i#']>
					CTDprecio = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form['CTDprecio#i#'],',','','all')#" >
				<cfelse>
					CTDprecio = CTDprecio
				</cfif>	
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				and CTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#" >
			</cfquery>
		</cfloop>
	</cfif>
	<!---- Se devuelven los parámetros de Periodo y mes para que se regrese a los mismos que venian ---->
	<cfif isdefined("url.CTDperiodo") and len(trim(url.CTDperiodo))>
		<cfset parametros="?CTDperiodo=#url.CTDperiodo#">
 	</cfif>
	
	<cfif isdefined("url.CTDmes") and len(trim(url.CTDmes))>
		<cfset parametros = parametros & "&CTDmes=#url.CTDmes#">
	</cfif>
	
	<cflocation url="formCostosProduccion.cfm#parametros#">

</cfoutput>
