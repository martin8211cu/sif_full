<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBproducto">

<cffunction name="consultarProducto" output="false" returntype="query" access="remote">
 <cfargument name="Contratoid" 	type="numeric" 	required="Yes"  	displayname="ID Producto">
 <cfargument name="datasource" 	type="string" 	required="No" 	default="#session.DSN#">
 
	 <cfquery datasource="#Arguments.datasource#" name="rsQuery">
	 	select Contratoid, CTid, CTidFactura, PQcodigo, Vid, VPNid, CTcondicion, CNsubestado, CNsuscriptor, 
				CNnumero, CNapertura, CNconsultar, BMUsucodigo, MRid, CNfechaRetiro
		from ISBproducto
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
	 </cfquery>
	 
	 <cfreturn rsQuery>
</cffunction>

<cffunction name="cambioPaquete" output="false" returntype="void" access="remote">
 <cfargument name="Contratoid" 	type="numeric" 	required="Yes"  	displayname="ID Producto">
 <cfargument name="pqNuevo" 	type="string" 	required="No" 		displayname="Codigo del Paquete Nuevo">
 <cfargument name="pqActual" 	type="string" 	required="No" 		displayname="Codigo del Paquete Actual">
 <cfargument name="LGevento" 	type="string" 	required="No" default="SACI" 		displayname="Indica el origen del últimp evento">
 <cfargument name="datasource" 	type="string" 	required="No" 	default="#session.DSN#">
 	
 	<cfquery datasource="#Arguments.datasource#">
		update ISBproducto
			set 
				PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.pqNuevo#">
				, LGevento = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGevento#">
				, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
	</cfquery>
	
</cffunction>

<cffunction name="Ocultar" output="false" returntype="void" access="remote">
 <cfargument name="Contratoid" type="numeric" required="Yes"  displayname="ID Producto">
 <cfargument name="CNconsultar" type="numeric" required="No" default="1"  displayname="Consultar">
 <cfargument name="datasource" 	type="string" 	required="No" 	default="#session.DSN#">
 
 	<cfquery datasource="#Arguments.datasource#">
		update ISBproducto
			set 
				CNconsultar = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.CNconsultar#">
				, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
	</cfquery>
	
</cffunction>

<cffunction name="RetirarProducto" output="false" returntype="void" access="remote">
 <cfargument name="Contratoid" 	type="numeric"	required="Yes"  displayname="ID Producto">
 <cfargument name="fecha" 		type="date"	required="No"  default="#now()#"	displayname="Fecha en que se realizo la reprogramacion">
 <cfargument name="MRid" 		type="string"	required="Yes"  displayname="Id Motivo de Retiro">
 <cfargument name="datasource" 	type="string" 	required="No" 	default="#session.DSN#">
 <cfargument name="devolver" 	type="boolean" 	required="No"   default="false">



 	<!---Retiro del producto--->
 	<cfquery datasource="#Arguments.datasource#">
		update ISBproducto
		set 
			CNfechaRetiro = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha#">
			, CNdevolverdeposito = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.devolver#">
			, MRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MRid#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
	</cfquery>
	<!---Logines que pertenecen al producto--->
	<cfquery name="rslogs" datasource="#Arguments.datasource#">
		select LGnumero
		from ISBlogin
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
		and Habilitado=1
	</cfquery>
	
	<!---Retiro de Logines del producto--->
	<cfloop query="rslogs">
		<cfinvoke component="saci.comp.ISBtareaProgramadaRL" method="RetiroLoginProgramado">
			<cfinvokeargument name="LGnumero" 	value="#rslogs.LGnumero#">
			<cfinvokeargument name="Contratoid" value="#Arguments.Contratoid#">
			<cfinvokeargument name="MRid" 		value="#Arguments.MRid#">
			<cfinvokeargument name="MStexto" 	value="Retiro del #rslogs.LGnumero# por retiro del producto #Arguments.Contratoid#">
			<cfinvokeargument name="BLobs" 		value="Retiro del #rslogs.LGnumero# por retiro del producto #Arguments.Contratoid#">
		</cfinvoke>
	</cfloop>
	
</cffunction>

<cffunction name="Reprogramar" output="false" returntype="void" access="remote">
 <cfargument name="Contratoid" type="numeric" required="Yes"  displayname="ID Producto">
 <cfargument name="datasource" type="string" 	required="No" 	default="#session.DSN#">
 
 	<cfquery datasource="#Arguments.datasource#">
		update ISBproducto
		set 
			CNfechaRetiro = null
			, CNdevolverdeposito = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
			, MRid = null
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
	</cfquery>
	
</cffunction>

<cffunction name="Activacion" output="false" returntype="void" access="remote">
  <cfargument name="Contratoid" type="numeric" required="Yes"  displayname="ID Producto">
  <cfargument name="datasource" type="string" 	required="No" 	default="#session.DSN#">
  	
	<cfquery datasource="#Arguments.datasource#">
		update ISBproducto
		set CTcondicion = '0'
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="Contratoid" type="numeric"	required="Yes"  displayname="ID Producto">
  <cfargument name="CTid" 		type="numeric"	required="Yes"  displayname="Cuenta">
  <cfargument name="CTidFactura"type="numeric"	required="Yes"  displayname="Factura">
  <cfargument name="PQcodigo" 	type="string"	required="Yes"  displayname="paquete">
  <cfargument name="Vid" 		type="numeric"	required="No"  	displayname="Vendedor">
  <cfargument name="CTcondicion"type="string"	required="Yes"  displayname="Condición de cuenta y aprobacion de comisión">
  <cfargument name="CNsuscriptor"type="string"	required="No" 	default="" displayname="Suscriptor">
  <cfargument name="CNnumero" 	type="string"	required="Yes"  displayname="Contrato">
  <cfargument name="CNapertura" type="date"		required="Yes"  displayname="Fecha de apertura">
  <cfargument name="ts_rversion"type="string"	required="No" 	displayname="ts_rversion">
  <cfargument name="datasource" type="string" 	required="No" 	default="#session.DSN#">
  
	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#Arguments.datasource#"
						table="ISBproducto"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="Contratoid"
						type1="numeric"
						value1="#Arguments.Contratoid#">
	</cfif>
				
	<cfquery datasource="#Arguments.datasource#">
		update ISBproducto
		set CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
		, CTidFactura = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTidFactura#" null="#Len(Arguments.CTidFactura) Is 0#">
		, PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">
		<cfif isdefined("Arguments.Vid") and Len(Trim(Arguments.Vid)) And Arguments.Vid neq 0>
		, Vid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Vid#">
		</cfif>
		, CTcondicion = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcondicion#" null="#Len(Arguments.CTcondicion) Is 0#">
		, CNsuscriptor = <cfif isdefined("Arguments.CNsuscriptor") and Len(Trim(Arguments.CNsuscriptor))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CNsuscriptor#"><cfelse>null</cfif>

		, CNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CNnumero#" null="#Len(Arguments.CNnumero) Is 0#">
		, CNapertura = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.CNapertura#" null="#Len(Arguments.CNapertura) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="CambioSuscriptor" output="false" returntype="void" access="remote">
  <cfargument name="Contratoid" 	type="numeric" 	required="Yes"  displayname="ID Producto">
  <cfargument name="CNsuscriptor" 	type="string" 	required="No" 	default="" 	displayname="Suscriptor">
  <cfargument name="CNnumero" 		type="string" 	required="No" 	default="" displayname="Numero Suscriptor">
  <cfargument name="datasource" 	type="string" 	required="No" 	default="#session.DSN#">
  <cfargument name="ts_rversion" 	type="string" 	required="No" 	displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#Arguments.datasource#"
						table="ISBproducto"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="Contratoid"
						type1="numeric"
						value1="#Arguments.Contratoid#">
	</cfif>
				
	<cfquery datasource="#Arguments.datasource#">
		update ISBproducto
		set CNsuscriptor = <cfif isdefined("Arguments.CNsuscriptor") and Len(Trim(Arguments.CNsuscriptor))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CNsuscriptor#"><cfelse>null</cfif>
		<cfif len(trim(Arguments.CNnumero))>
			,CNnumero = <cfif isdefined("Arguments.CNnumero") and Len(Trim(Arguments.CNnumero))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CNnumero#"><cfelse>null</cfif>
		</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="Contratoid" type="numeric" required="Yes" 	displayname="ID Producto">
  <cfargument name="datasource" type="string" required="No" 	default="#session.DSN#">
	<cfquery datasource="#Arguments.datasource#">
		delete ISBproducto
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
	</cfquery>
	
</cffunction>

<cffunction name="BajaCuenta" output="false" returntype="void" access="remote">
  <cfargument name="CTid" 			type="numeric"	required="Yes"  displayname="ID Cuenta">
  <cfargument name="datasource" 	type="string"	required="No" 	default="#session.DSN#">
  <cfargument name="soloEnCaptura" 	type="string" 	required="no" 	default="0" displayname="Solo_Productos_en_captura">    
  
	<cfquery datasource="#Arguments.datasource#">
		delete ISBproducto
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
			<cfif isdefined('Arguments.soloEnCaptura') and Arguments.soloEnCaptura NEQ '0'>
				and CTcondicion = 'C'
			</cfif>			
	</cfquery>
	
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="CTid" 			type="numeric" required="Yes"  displayname="Cuenta">
  <cfargument name="CTidFactura" 	type="numeric" required="Yes"  displayname="Factura">
  <cfargument name="PQcodigo" 		type="string" 	required="Yes"  displayname="paquete">
  <cfargument name="Vid" 			type="numeric" 	required="Yes" default="0"  displayname="Vendedor">
  <cfargument name="CTcondicion" 	type="string" 	required="Yes"  displayname="Condición de cuenta y aprobacion de comisión">
  <cfargument name="CNsuscriptor" 	type="string" 	required="No" default="" displayname="Suscriptor">
  <cfargument name="CNnumero" 		type="string" 	required="Yes"  displayname="Contrato">
  <cfargument name="CNapertura" 	type="date" 	required="Yes"  displayname="Fecha de apertura">
  
  <cfargument name="VPNid" 			type="numeric" 	required="no" displayname="id del VPN">
  <cfargument name="CNsubestado" 	type="string" 	required="no" displayname="sub estado">
  
  <cfargument name="MRid" 			type="numeric" 	required="no" displayname="id motivo de retiro">
  <cfargument name="CNfechaRetiro" 	type="date" 	required="no" displayname="feche de retiro">
  
  <cfargument name="datasource" 	type="string" 	required="No" 	default="#session.DSN#">

	<cfif Arguments.Vid is 0>
		<cfinvoke component="ISBparametros" method="Get" returnvariable="VendedorGenerico"
			Pcodigo="222" />
		<cfif Not Len(VendedorGenerico) or VendedorGenerico is 0>
			<cfthrow message="No se ha seleccionado el vendedor genérico en parámetros globales.">
		</cfif>
		<cfset Arguments.Vid = VendedorGenerico>
	</cfif>

	<cfquery datasource="#Arguments.datasource#" name="rsAlta">
		insert into ISBproducto (
			CTid,
			CTidFactura,
			PQcodigo,
			
			Vid,
			CTcondicion,
			CNsuscriptor,

			CNnumero,
			CNapertura,
			
			VPNid,
			CNsubestado,
			
			MRid,
			CNfechaRetiro,
			
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTidFactura#" null="#Len(Arguments.CTidFactura) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Vid#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcondicion#" null="#Len(Arguments.CTcondicion) Is 0#">,
			<cfif isdefined("Arguments.CNsuscriptor") and Len(Trim(Arguments.CNsuscriptor))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CNsuscriptor#"><cfelse>null</cfif>,

			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CNnumero#" null="#Len(Arguments.CNnumero) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.CNapertura#" null="#Len(Arguments.CNapertura) Is 0#">,
			
			<cfif isdefined("Arguments.VPNid") and Len(Trim(Arguments.VPNid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.VPNid#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.CNsubestado") and Len(Trim(Arguments.CNsubestado))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CNsubestado#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.MRid") and Len(Trim(Arguments.MRid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MRid#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.CNfechaRetiro") and Len(Trim(Arguments.CNfechaRetiro))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.CNfechaRetiro#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		)

		<cf_dbidentity1 datasource="#Arguments.datasource#" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 datasource="#Arguments.datasource#" name="rsAlta" verificar_transaccion="false">

	<cfreturn rsAlta.identity>

</cffunction>

</cfcomponent>
