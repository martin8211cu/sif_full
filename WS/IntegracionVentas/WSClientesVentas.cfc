<!---
  --- WSGetToken
  --------------
  --- Description WS que devuelve Arreglo de Clientes (SNegocios) y Objeto de Cliente
  --- Author Ing. Oscar Orlando Parrales Villanueva
  --- Date   2018-09-06
 --->
<cfcomponent extends="IntegracionVentas_Base">

	<cffunction name="getClientes" returntype="WEDatosCliente[]" access="remote">
		<cfargument name="Nombre"			type="string"	required="false">
		<cfargument name="RFC"				type="string"	required="false">
		<cfargument name="CodigoInterno"	type="string"	required="false">
		<cfargument name="Ecodigo"			type="string"	required="true"> <!--- Codigo de la Empresa externa que consume el WS --->
		<cfargument name="token" 			type="string" 	required="true">
<!---
		<cfinvoke method="getToken" returnvariable="tokenOrig" component="WSGetToken">
			<cfinvokeargument name="usuario" value="SampleUserLD">
			<cfinvokeargument name="password" value="UnPassSample015O1NLD">
		</cfinvoke>

		<cfif tokenOrig neq token>
			<cflog file="WSClientesVentas" text="ValidationException: TOKEN INVALIDO" log="Application" type="information">
			<cfthrow message="ValidationException: " detail="TOKEN INVALIDO">
		</cfif>
--->
		<!--- Obtiene las empresas a sincronizar --->
		<cfquery name="rsEmpresas" datasource="sifinterfaces">
			select EQUidSIF,EQUidSIF, EQUdescripcion
			from SIFLD_Equivalencia
			where CATcodigo like 'CADENA'
			and SIScodigo like 'LD'
			<cfif  isdefined('Arguments.Ecodigo') and Trim(Arguments.Ecodigo) neq ''>
				and EQUcodigoOrigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ecodigo#">
			</cfif>
		</cfquery>

		<cfif rsEmpresas.RecordCount eq 0>
			<cflog file="WSClientesVentas" text="ValidationException: No hay equivalencias configuradas" log="Application" type="information">
			<cfthrow message="ValidationException: " detail="No hay equivalencias configuradas">
		</cfif>

		<cfset session.dsn = getConexion(val(rsEmpresas.EQUidSIF))>
		<cflog file="WSClientesVentas" text="Obteniendo Caches #session.dsn#" log="Application" type="information">

		<cflog file="WSClientesVentas" text="************** CONSULTANDO Clientes **************" log="Application" type="information">
		<cfquery name="rsClientes" datasource="#session.dsn#">
			select
				SNid,
				SNcodigo,
				SNtipo,
				SNnombre,
				SNidentificacion,
				s.SNcodigoext,
				SNdireccion,
				coalesce(SNemail,'') SNemail,
				coalesce(SNtelefono,'') SNtelefono,
				SNnumero,
				SNmontoLimiteCC,
				s.Ecodigo EcodigoSIF,
				SNtiposocio,
				SNcuentacxp,
				SNplazocredito,
				Mcodigo,
					SNmontoLimiteCC - (isnull(saldoCliente,0) + isnull(btr.Monto,0)) saldoCliente
			from SNegocios s
			left join (
						select SNcodigoExt, Ecodigo, sum(Monto) Monto
						from BTransito_CC
						group by SNcodigoExt, Ecodigo
					) btr on s.Ecodigo = btr.Ecodigo and s.SNcodigoext = btr.SNcodigoExt
			where 1 = 1
				and s.Ecodigo = #rsEmpresas.EQUidSIF#
				and s.SNtiposocio in ('C','A')
				and s.Mayor = 1
			<cfif IsDefined('Arguments.Nombre') and Trim(Arguments.Nombre) neq ''>
				and Upper(SNnombre) like '%#UCase(Arguments.Nombre)#%'
			</cfif>
			<cfif IsDefined('Arguments.RFC') and Trim(Arguments.RFC) neq ''>
				and SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.RFC)#">
			</cfif>
			<cfif IsDefined('Arguments.CodigoInterno') and Trim(Arguments.CodigoInterno) neq ''>
				and s.SNcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.CodigoInterno)#">
			</cfif>
		</cfquery>
		<cflog file="WSClientesVentas" text="Clientes consultados: #rsClientes.RecordCount#" log="Application" type="information">

		<cfset arrayClientes = arrayNew(1)>

		<cflog file="WSClientesVentas" text="ITERANDO Clientes" log="Application" type="information">
		<cfloop query="rsClientes">
			
			<cfobject component="WEDatosCliente" name="tmpCliente"><!---Objeto del tipo de la estructura del "query" con los datos del Cliente--->
			<cfset tmpCliente.Id = rsClientes.SNid>
			<cfset tmpCliente.CodigoExterno = rsClientes.SNcodigoext>
			<cfset tmpCliente.Nombre = rsClientes.SNnombre>
			<cfset tmpCliente.Saldo = rsClientes.saldoCliente>
			<cfset tmpCliente.LimiteCredito = rsClientes.SNmontoLimiteCC>
			<cfset tmpCliente.Direccion = rsClientes.SNdireccion>
			<cfset tmpCliente.RFC = rsClientes.SNidentificacion>
			<cfset temp = ArrayAppend(arrayClientes, tmpCliente)>
		</cfloop>
		<cfreturn arrayClientes>
	</cffunction>

	<cffunction name="getCliente" returntype="WEDatosCliente" access="remote">
		<cfargument name="Ecodigo"		type="string"	required="true"> <!--- Codigo de la Empresa externa que consume el WS --->
		<cfargument name="IdCliente"	type="string"	required="true">
		<cfargument name="token" 		type="string" 	requiered="true">
<!--- 
		<cfinvoke method="getToken" returnvariable="tokenOrig" component="WSGetToken">
			<cfinvokeargument name="usuario" value="SampleUserLD">
			<cfinvokeargument name="password" value="UnPassSample015O1NLD">
		</cfinvoke>

		<cfif tokenOrig neq token>
			<cflog file="WSClientesVentas" text="ValidationException: TOKEN INVALIDO" log="Application" type="information">
			<cfthrow message="ValidationException: " detail="TOKEN INVALIDO">
		</cfif>
--->
		<!--- Obtiene las empresas a sincronizar --->
		<cfquery name="rsEmpresas" datasource="sifinterfaces">
			select EQUidSIF,EQUidSIF, EQUdescripcion
			from SIFLD_Equivalencia
			where CATcodigo like 'CADENA'
			and SIScodigo like 'LD'
			<cfif  isdefined('Arguments.Ecodigo') and Trim(Arguments.Ecodigo) neq ''>
				and EQUcodigoOrigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ecodigo#">
			</cfif>
		</cfquery>

		<cfif rsEmpresas.RecordCount eq 0>
			<cflog file="WSClientesVentas" text="ValidationException: No hay equivalencias configuradas" log="Application" type="information">
			<cfthrow message="ValidationException: " detail="No hay equivalencias configuradas">
		</cfif>


		<cfset session.dsn = getConexion(val(rsEmpresas.EQUidSIF))>
		<cflog file="WSClientesVentas" text="Obteniendo caches..." log="Application" type="information">

		<cflog file="WSClientesVentas" text="************** CONSULTANDO Cliente **************" log="Application" type="information">

		<cfquery name="rsCliente" datasource="#session.dsn#">
			select
				SNid,
				SNcodigo,
				SNtipo,
				SNnombre,
				SNidentificacion,
				s.SNcodigoext,
				SNdireccion,
				coalesce(SNemail,'') SNemail,
				coalesce(SNtelefono,'') SNtelefono,
				SNnumero,
				SNmontoLimiteCC,
				s.Ecodigo EcodigoSIF,
				SNtiposocio,
				SNcuentacxp,
				SNplazocredito,
				Mcodigo,
				SNmontoLimiteCC - (isnull(saldoCliente,0) + isnull(btr.Monto,0)) saldoCliente
			from SNegocios s
			left join (
						select SNcodigoExt, Ecodigo, sum(Monto) Monto
						from BTransito_CC
						group by SNcodigoExt, Ecodigo
					) btr on s.Ecodigo = btr.Ecodigo and s.SNcodigoext = btr.SNcodigoExt
			where 1 = 1
			and s.SNtiposocio in ('C', 'A')
			and s.SNcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.IdCliente#">
		</cfquery>

		<cflog file="WSClientesVentas" text="CONSTRUYENDO OBJETO Cliente" log="Application" type="information">
		<cfobject component="WEDatosCliente" name="tmpCliente"><!---Objeto del tipo de la estructura del "query" con los datos del Cliente--->
			<cfset tmpCliente.Id = rsCliente.SNid>
			<cfset tmpCliente.CodigoExterno = rsCliente.SNcodigoext>
			<cfset tmpCliente.Nombre = rsCliente.SNnombre>
			<cfset tmpCliente.Saldo = rsCliente.saldoCliente>
			<cfset tmpCliente.LimiteCredito = rsCliente.SNmontoLimiteCC>
			<cfset tmpCliente.Direccion = rsCliente.SNdireccion>
			<cfset tmpCliente.RFC = rsCliente.SNidentificacion>

		<cfreturn tmpCliente>
	</cffunction>
</cfcomponent>