Plantilla Auxiliar...
<cfabort>
<!---   --->

<!--- cfquery - sql select  --->
	<cfquery name="nombrequery" datasource="#GvarConexion#" maxrows="1">
		select SNid,SNcodigo,id_direccion
		from SNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
		  and SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.NumeroSocio#">
	</cfquery>

<!--- cfquery - sql insert  --->
	<cfquery datasource="#Request.CM_InterfazArticulos.GvarConexion#">
		insert INTO Articulos 
		(Ecodigo, Acodigo, Acodalterno, Ucodigo, Ccodigo, Adescripcion, Afecha, Acosto, Aconsumo, AFMMid, AFMid, CAid, BMUsucodigo)
		values (
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
			, <cfqueryparam cfsqltype="cf_sql_char" value="#getAcodigo_vIntegridad(Arguments.Acodigo,'A','Alta_Articulos')#">
			<cfif isdefined('Arguments.Acodalterno') and Arguments.Acodalterno NEQ ''>
				, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Acodalterno#">
			<cfelse>
				, null
			</cfif>
			, <cfqueryparam cfsqltype="cf_sql_char" value="#getUcodigo_vIntegridad(Arguments.Ucodigo,'Alta_Articulos')#">
			, <cfqueryparam cfsqltype="cf_sql_integer" value="#getCcodigo_vIntegridad(Arguments.Ccodigo,'A','Alta_Articulos')#">
			, <cfqueryparam cfsqltype="cf_sql_char" value="#getAdescripcion_vIntegridad(Arguments.Adescripcion,'Alta_Articulos')#">
			, <cfqueryparam cfsqltype="cf_sql_date" value="#Request.CM_InterfazArticulos.GvarFecha#">
			,  null
			,  0
			<cfif isdefined('Arguments.AFMid') and Arguments.AFMid NEQ '' and isdefined('Arguments.AFMMid')	and Arguments.AFMMid NEQ ''> 
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#getAFMMid_vIntegridad(Arguments.AFMid,Arguments.AFMMid,'Alta_Articulos')#">				
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#getAFMid_vIntegridad(Arguments.AFMid,'Alta_Articulos')#">
			<cfelse>
				, null
				, null				
			</cfif>
			,  null
			,  null)
	</cfquery>

<!--- cfquery - sql update  --->
	<cfquery datasource="#Request.CM_InterfazArticulos.GvarConexion#">
		update Articulos set
			Acodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#getAcodigo_vIntegridad(Arguments.Acodigo,'C','Cambio_Articulos')#">
			<cfif isdefined('Arguments.Acodalterno') and Arguments.Acodalterno NEQ ''>
				, Acodalterno=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Acodalterno#">
			<cfelse>
				, Acodalterno=null
			</cfif> 
			, Ucodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#getUcodigo_vIntegridad(Arguments.Ucodigo,'Cambio_Articulos')#">
			, Ccodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#getCcodigo_vIntegridad(Arguments.Ccodigo,'C','Cambio_Articulos')#">
			, Adescripcion=<cfqueryparam cfsqltype="cf_sql_char" value="#getAdescripcion_vIntegridad(Arguments.Adescripcion,'Cambio_Articulos')#">
			, Afecha=<cfqueryparam cfsqltype="cf_sql_date" value="#Request.CM_InterfazArticulos.GvarFecha#">
			<cfif isdefined('Arguments.AFMid') and Arguments.AFMid NEQ '' and isdefined('Arguments.AFMMid') and Arguments.AFMMid NEQ ''>
				,  AFMMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getAFMMid_vIntegridad(Arguments.AFMid,Arguments.AFMMid,'Cambio_Articulos')#">				
				,  AFMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getAFMid_vIntegridad(Arguments.AFMid,'Cambio_Articulos')#">
			<cfelse>
				, AFMMid=null
				, AFMid=null				
			</cfif>
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
			  and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getAid_vIntegridad(Arguments.Acodigo,'Cambio_Articulos')#">
	</cfquery>

<!--- cfquery - sql delete  --->
	<cfquery datasource="#Request.CM_InterfazArticulos.GvarConexion#">
		delete Articulos 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
		      and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getAid_vIntegridad(Arguments.Acodigo,'Baja_Articulos')#">
	</cfquery>

<!--- cfoutput query  --->
	<cfoutput query="query">
	</cfoutput>
	
<!--- cfloop  --->
<cfloop from="1" to="#ArrayLen(This.CartArray)#" index="i">
	<cfset QueryAddRow(q)>
	<cfset QuerySetCell(q, "MerchID", This.CartArray[i].MerchID)>
	<cfset QuerySetCell(q, "Quantity", This.CartArray[i].Quantity)>
</cfloop>

<cfloop query="query name">
</cfloop>

<!--- cfset  --->
	<cfset GvarEnombre   = Session.Enombre>
	<cfset GvarMinFecha  = DateAdd('yyyy',-50,Now())>
	<cfset GvarCuentaManual = true>
	<cfset Valid_EcodigoSDC = getValidEcodigoSDC(query.EcodigoSDC)>
	<cfset Valid_Modulo = getValidModulo(query.Modulo)>

<!--- cffunction  --->
	<cffunction access="private" name="getValidMcodigo" output="false" returntype="numeric">
		<cfargument name="miso" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select Mcodigo
			from Monedas
			where Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.miso)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
		<cfif query.recordcount EQ 0 >
			<cfthrow message="Error en Interfaz 10. CodigoMoneda es inválido!.">
		</cfif>
		<cfreturn query.Mcodigo>
	</cffunction>

	<cffunction
		NAME="Add"
		HINT="agrega un item al shopping cart"
		<cfargument NAME="MerchID" TYPE="numeric" REQUIRED="Yes">
		<cfargument NAME="Quantity" TYPE="numeric" REQUIRED="No" default="1">
		
		<!--- Obtiene la estructura que representa este item en el carrito de compras  --->		
		<!--- y entonces actualiza la cantidad, con la cantidad especificada  --->
		<cfset CartItem = GetCartItem(MerchID)>
		<cfset CartItem.Quantity = CartItem.Quantity + Arguments.Quantity>
	</cffunction>

<!--- cfobject  --->
<cfobject name="SESSION.OFacturaProducto" component="interfasesPMI.Componentes.CFacturaProducto">

<!--- cfthrow  --->
	<cfthrow message="Mensaje de Error">

<!--- cftransaction  --->
	<cftransaction>
	</cftransaction>
	<cftransaction isolation="read_uncommitted">
	</cftransaction>

<!--- cfinvoke (llamada directa a un método, sin crear el objeto --->
	<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
		<cfinvokeargument name="Lprm_Cmayor" value="#Left(Arguments.CFormato,4)#"/>							
		<cfinvokeargument name="Lprm_Cdetalle" value="#mid(Arguments.CFormato,6,100)#"/>
		<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
		<cfinvokeargument name="Conexion" value="#GvarConexion#"/>
		<cfinvokeargument name="ecodigo" value="#GvarEcodigo#"/>
	</cfinvoke>

	<cfinvoke 
		component="#SESSION.MyShoppingCart#"
		method="Add"
		MERCHID="#URL.AddMerchID#">
	
<!--- cfif --->
		<cfif len(trim(query.PrecioTotal)) gt 0>
			<cfset Valid_ImporteTotal = query.PrecioTotal >
		<cfelseif (Valid_CantidadTotal * Valid_PrecioUnitario) GT 0.00>
			<cfset Valid_ImporteTotal = (Valid_CantidadTotal * Valid_PrecioUnitario) - Valid_ImporteDescuento >
		<cfelse>
			<cfset Valid_ImporteTotal = query.PrecioTotal + 20 >
		</cfif>
