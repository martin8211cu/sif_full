<!--- Sugiere el ultimo tipo de cambio --->
<!--- Si se indica moneda devuelve el valor en TCsugerido --->
<!--- Si no se indica moneda devuelve los valores en TCsugerido["#Miso4217#"] --->

<!---
sugerirTC_Mcodigo	(McodigoOrigen, Ecodigo)
	R=TipoCambio
sugerirTC_Miso4217	(Miso4217Origen, Ecodigo)
	R=TipoCambio

sugerirFC_Mcodigo	(McodigoOrigen, McodigoDestino, Ecodigo)
	R=FactorConversion
sugerirFC_Miso4217	(Miso4217Origen, Miso4217Destino, Ecodigo)
	R=FactorConversion

TC  = Tipo de cambio para convertir una moneda Origen a la moneda Local, ejemplo: 	
		sugerirTCL  ('USD') = 455   			===> USD 1 = CRC 455
FC	= Factor de conversión para convertir una moneda Origen a una Destino:
		sugerirFC	('USD','EUR') = 455/505		===> USD 1 = EUR 0.900900900

sugerirTCs	(Ecodigo)
sugerirFCs_Mcodigo	(McodigoDestino, Ecodigo)
sugerirFCs_Miso4217	(Miso4217Destino, Ecodigo)

convertirTC_Mcodigo	(McodigoOrigen, MontoOrigen, Ecodigo)

TCdestino 		= K
MontoOrigen 	= K
fnCalcularMontoLocalTC		= round(MontoOrigen * TCorigen, 2)
fnCalcularMontoOrigenTC		= round(MontoLocal / TCorigen, 2)
fnCalcularMontoDestinoTC 	= MontoOrigen * TCorigen / TCdestino
fnCalcularFC 				= TCorigen / TCdestino
fnCalcularTCorigenFC		= FC * TCdestino
fnCalcularMontoOrigenFC		= round(MontoDestino / FC, 2)
fnCalcularMontoDestinoFC 	= MontoOrigen * FC

fnSugerirTC_Mcodigo 		= tc_Mcodigo[McodigoOrigen]
fnSugerirTC_Miso4217		= tc_Miso4217[Miso4217Origen]

fnSugerirFC_Mcodigo 		= tc_Mcodigo[McodigoOrigen]   / tc_Mcodigo[McodigoDestino]
fnSugerirFC_Miso4217		= tc_Miso4217[Miso4217Origen] / tc_Miso4217[Miso4217Destino]

fnSugerirTC_Empresa
fnSugerirFC_Empresa

MontoOrigen 		===> MontoDestino 	= fnCalcularMontoDestinoFC (MontoOrigen, FC)
						 MontoLocal 	= fnCalcularMontoLocalTC (MontoOrigen, TCorigen)
TCorigen			===> FC 			= fnCalcularFC (TCorigen, TCdestino)
						 MontoDestino 	= fnCalcularMontoDestinoFC (MontoOrigen, FC)
						 MontoLocal 	= fnCalcularMontoLocalTC (MontoOrigen, TCorigen)
TCdestino 			===> FC 			= fnCalcularFC (TCorigen, TCdestino)
						 MontoDestino 	= fnCalcularMontoDestinoFC (MontoOrigen, FC)
MontoDestino 		===> FC 			= fnCalcularFC (TCorigen, TCdestino)
						 TCorigen 		= fnCalcularTCorigenFC (FC, TCdestino)
						 MontoLocal 	= fnCalcularMontoLocalTC (MontoOrigen, TCorigen)
FC 					===> TCorigen 		= fnCalcularTCorigenFC (FC, TCdestino)
						 MontoDestino 	= fnCalcularMontoDestinoFC (MontoOrigen, FC)
						 MontoLocal 	= fnCalcularMontoLocalTC (MontoOrigen, TCorigen)





TCsugeridoEmpresa			(Ecodigo)
	R["#Miso4217#"]=TipoCambio
TCconvertirToLocal			(Ecodigo, {Mcodigo | Miso4217}, MontoOrigen,	{TCsugerido | TipoCambioOrigen})
	R.Origen:	Mcodigo,Miso4217,Monto,TipoCambio
	R.Local:	Mcodigo,Miso4217,Monto,TipoCambio=1
	R.Destino	=	R.Local
TCconvertirToDestino		(Ecodigo, {Mcodigo | Miso4217}, MontoLocal,		{TCsugerido | TipoCambioDestino})
	R.Origen:	=	R.Local
	R.Local:	Mcodigo,Miso4217,Monto,TipoCambio=1
	R.Destino:	Mcodigo,Miso4217,Monto,TipoCambio
TCconvertirOrigenToDestino	(Ecodigo, {Mcodigo | Miso4217}, MontoOrigen,	{TCsugerido | TipoCambioOrigen, TipoCambioDestino | {TipoCambioOrigen | TipoCambioDestino}, FactorOrigenDestino})
	R.Origen:	Mcodigo,Miso4217,Monto,TipoCambio
	R.Local:	Mcodigo,Miso4217,Monto,TipoCambio=1
	R.Destino:	Mcodigo,Miso4217,Monto,TipoCambio
	R.FactorOrigenDestino
--->
<cffunction name="fnSugerir" returntype="query" access="private">
	<cfargument name="Ecodigo"			type="numeric"	default="#session.Ecodigo#">
	<cfargument name="Miso4217"			type="string"	default="">
	<cfargument name="Mcodigo"			type="numeric"	default="-1">
	<cfargument name="Fecha"			type="date">
	<cfargument name="CompraVenta"		type="string">
	<cfargument name="Miso4217Destino"	type="string"	default="">
	<cfargument name="McodigoDestino"	type="numeric"	default="-1">

	<cfset var LvarTodos 		= Arguments.Miso4217 EQ "" AND Arguments.Mcodigo EQ -1>
	<cfset var LvarConDestino	= Arguments.Miso4217Destino EQ "" AND Arguments.McodigoDestino EQ -1>
	<cfset var rsEmpresa 		= querynew("Mcodigo,Miso4217")>
	<cfset var rsDestino 		= querynew("Mcodigo,Miso4217,TipoCambio,TCcompra,TCventa")>
	<cfset var rsTC 			= querynew("Mcodigo,Miso4217,TipoCambio,TCcompra,TCventa")>
	
	<cfif LvarTodos AND Arguments.CompraVenta NEQ "C" AND Arguments.CompraVenta NEQ "V">
		<cf_errorCode	code = "50712" msg = "TipoCambioSugerido: El atributo CompraVenta debe ser 'C' o 'V'">
	</cfif>
	<cfquery name="rsEmpresa" datasource="#Session.DSN#">
		select e.Mcodigo, m.Miso4217, 1.0 as TipoCambio
		  from Empresas e
			inner join Monedas m
				 on m.Mcodigo = e.Mcodigo
				and m.Ecodigo = e.Ecodigo
		 where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
	</cfquery>
	<cfif rsEmpresa.recordCount EQ 0>
		<cf_errorCode	code = "50713"
						msg  = "TipoCambioSugerido: La empresa Ecodigo='@errorDat_1@' no está definida"
						errorDat_1="#Arguments.Ecodigo#"
		>
	</cfif>
	
	<cfif NOT LvarConDestino>
		<cfset Arguments.McodigoDestino  = rsEmpresa.Mcodigo>
		<cfset Arguments.Miso4217Destino = rsEmpresa.Miso4217>
	</cfif>
	
	<cfif Arguments.Miso4217Destino EQ rsEmpresa.Miso4217 OR Arguments.McodigoDestino EQ rsEmpresa.Mcodigo>
		<cfset rsDestino.Mcodigo = rsEmpresa.Mcodigo>
		<cfset rsDestino.TipoCambio = 1.0>
		<cfset rsDestino.TCcompra 	= 1.0>
		<cfset rsDestino.TCventa 	= 1.0>
	<cfelse>
		<cfquery name="rsDestino" datasource="#Session.DSN#">
			select 	m.Mcodigo, Miso4217,
				<cfif LvarTodos>
					tc.TCcompra, tc.TCventa
				<cfelse>
					<cfif Arguments.CompraVenta EQ "C">tc.TCcompra<cfelse>tc.TCventa</cfif> as TipoCambio
				</cfif>
			  from Monedas m
				left join Htipocambio tc
					 on tc.Mcodigo = m.Mcodigo
					and tc.Ecodigo = m.Ecodigo
					and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">
					and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">
			 where m.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			<cfif Arguments.McodigoDestino NEQ "-1">
			   and m.Mcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.McodigoDestino#">
			<cfelseif Arguments.Miso4217Destino NEQ "">
			   and m.Miso4217 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Miso4217Destino#">
			</cfif>
		</cfquery>
		<cfif rsEmpresa.recordCount EQ 0>
			<cf_errorCode	code = "50714" msg = "TipoCambioSugerido: La Moneda Destino no está definida">
		</cfif>
	</cfif>

	<cfquery name="rsTC" datasource="#Session.DSN#">
		select 	m.Mcodigo, m.Miso4217, 
			<cfif NOT LvarTodos>
				case m.Mcodigo
					when #rsDestino.Mcodigo# then 1.0
				<cfif rsDestino.TipoCambio EQ "" OR rsDestino.TipoCambio LTE 0>
					else 0.0
				<cfelse>
					when #rsEmpresa.Mcodigo# then 1.0 / #rsDestino.TipoCambio#
					else coalesce(<cfif Arguments.CompraVenta EQ "C">tc.TCcompra<cfelse>tc.TCventa</cfif> / #rsDestino.TipoCambio#, 0)
				</cfif>
				end as TipoCambio
			<cfelse>
				case m.Mcodigo
					when #rsDestino.Mcodigo# then 1.0
				<cfif rsDestino.TCcompra EQ "" OR rsDestino.TCcompra LTE 0>
					else 0.0
				<cfelse>
					when #rsEmpresa.Mcodigo# then 1.0 / #rsDestino.TCcompra#
					else coalesce(tc.TCcompra / #rsDestino.TCcompra#, 0)
				</cfif>
				end as TCcompra,

				case m.Mcodigo
					when #rsDestino.Mcodigo# then 1.0
				<cfif rsDestino.TCventa EQ "" OR rsDestino.TCventa LTE 0>
					else 0
				<cfelse>
					when #rsEmpresa.Mcodigo# then 1.0 / #rsDestino.TCventa#
					else coalesce(tc.TCventa / #rsDestino.TCventa#, 0)
				</cfif>
				end as TCventa
			</cfif>
		  from Monedas m
			left join Htipocambio tc
				 on tc.Mcodigo = m.Mcodigo
				and tc.Ecodigo = m.Ecodigo
				and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">
				and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">
		 where m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		<cfif Arguments.Mcodigo NEQ "-1">
		   and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Mcodigo#">
		<cfelseif Arguments.Miso4217 NEQ "">
		   and m.Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Miso4217#">
		</cfif>
	</cfquery>

	<cfreturn rsTC>
</cffunction>


