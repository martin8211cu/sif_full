<cfquery name="rsLista" datasource="sifcontrol">
	<!--- Cuando el mantenimiento no es para el PSO, incluir los couriers insertados para la empresa --->
	<cfif not (isdefined("Request.courier") and Request.courier EQ "PSO")>
	select CRid, rtrim(CRcodigo) as CRcodigo, CRdescripcion, Usucodigo, Curl, CEcodigo, Ecodigo, EcodigoSDC
	from Courier
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	
	union

	</cfif>
	select 	<cfif isdefined("Request.courier") and Request.courier EQ "PSO">
			'PSO' as courier,
			</cfif>
			CRid, rtrim(CRcodigo) as CRcodigo, CRdescripcion, Usucodigo, Curl, CEcodigo, Ecodigo, EcodigoSDC
	from Courier
	where CEcodigo is null
	and Ecodigo is null
	and EcodigoSDC is null

	order by 2	
</cfquery>

<cfinvoke 
	component="sif.Componentes.pListas"
	method="pListaQuery"
	returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsLista#"/>
		<cfinvokeargument name="desplegar" value="CRcodigo, CRdescripcion, Curl"/>
		<cfinvokeargument name="etiquetas" value="Código, Descripci&oacute;n Courier, Url"/>
		<cfinvokeargument name="formatos" value="V, V, V"/>
		<cfinvokeargument name="align" value="left, left, left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfif isdefined("Request.courier") and Request.courier EQ "PSO">
		<cfinvokeargument name="irA" value="Courierpso.cfm"/>
		<cfelse>
		<cfinvokeargument name="irA" value="Courier.cfm"/>
		</cfif>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="keys" value="CRid"/>
</cfinvoke>
