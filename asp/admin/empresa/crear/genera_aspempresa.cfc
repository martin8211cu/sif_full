<cfcomponent output="no">

<cffunction name="crear" output="false" returntype="numeric">
	<cfargument name="CEcodigo" type="numeric" required="yes">
	<cfargument name="Cid" type="numeric" required="yes">
	<cfargument name="Mcodigo" type="numeric" required="yes">
	<cfargument name="Enombre" type="string" required="yes">
	<cfargument name="Etelefono1" type="string" required="yes">
	<cfargument name="Etelefono2" type="string" required="yes">
	<cfargument name="Efax" type="string" required="yes">
	<cfargument name="Eidentificacion" type="string" required="yes">
	<cfargument name="auditar" type="boolean" required="yes">
	<cfargument name="logoblob" type="binary" required="yes">

	<!--- Inserta la dirección --->
	<cf_direccion action="readform" name="data">
	<cf_direccion action="insert" name="data" data="#data#">

	<!--- Inserta la Cuenta Empresarial, le asocia la direccion y el numero de cuenta --->
	<cfquery name="rsMaxEmpresa" datasource="asp">
		select coalesce(max(Ereferencia), 0)+1 as Ereferencia
		from Empresa		
	</cfquery>
	
	<cfquery name="rs" datasource="asp">
		insert into Empresa (
			CEcodigo, id_direccion, Cid, Mcodigo,
			Enombre, Etelefono1, Etelefono2, Efax,
			Ereferencia, Eidentificacion, BMfecha, BMUsucodigo,
			Elogo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_direccion#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Enombre#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Etelefono1#" null="#len(trim(Arguments.Etelefono1)) is 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Etelefono2#" null="#len(trim(Arguments.Etelefono2)) is 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Efax#" null="#len(trim(Arguments.Efax)) is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxEmpresa.Ereferencia#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Eidentificacion#" null="#Len(trim(Arguments.Eidentificacion)) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfif Len(form.logo)>
			<cfqueryparam cfsqltype="cf_sql_blob" value="#Arguments.logoblob#">
			<cfelse>null
			</cfif>
		)
		<cf_dbidentity1 verificar_transaccion="false" datasource="asp">
	</cfquery>
	<cf_dbidentity2 verificar_transaccion="false" datasource="asp" name="rs">

	<cfif Not IsDefined('Arguments.auditar')>
		<cfinvoke component="asp.admin.bitacora.catalogos.PBitacoraEmp.activar" method="inactivarEmpresa" Ecodigo="#rs.identity#"/>
	</cfif>
	
	<!--- Averiguar Codigo de Referencia, Moneda y Cache para la Empresa --->
	<cfquery name="rsNewEmpresa" datasource="asp">
		select b.Ccache, a.Ereferencia, a.Enombre, c.Mnombre, Msimbolo, Miso4217
		from Empresa a, Caches b, Moneda c
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.identity#">
		and a.Cid = b.Cid
		and a.Mcodigo = c.Mcodigo
	</cfquery>
	<cfset cache = rsNewEmpresa.Ccache>

	<cfquery name="rsMoneda" datasource="#cache#">
		Select Mcodigo as "identity"
		from Monedas
		where Miso4217=<cfqueryparam cfsqltype="cf_sql_char" value="#rsNewEmpresa.Miso4217#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewEmpresa.Ereferencia#">
	</cfquery>

	<!--- NO existe la moneda en la base de datos de referencia --->		
	<cfif rsMoneda.recordCount EQ 0>
		<!--- Insertar moneda en la base de datos referencia --->
		<cfquery name="rsMoneda" datasource="#cache#">
			insert INTO Monedas(Ecodigo, Mnombre, Msimbolo, Miso4217)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewEmpresa.Ereferencia#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewEmpresa.Mnombre#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewEmpresa.Msimbolo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsNewEmpresa.Miso4217#">
			)
			<cf_dbidentity1 verificar_transaccion="false" datasource="#cache#">
		</cfquery>
		<cf_dbidentity2 verificar_transaccion="false" datasource="#cache#" name="rsMoneda">
	</cfif>
	
	<cfquery name="rsFindEmpresa" datasource="#cache#">
		Select Ecodigo
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewEmpresa.Ereferencia#">
	</cfquery>		
	
	<!--- NO existe la Empresa en la base de datos de referencia --->		
	<cfif rsFindEmpresa.recordCount EQ 0>
		<!--- Insertar la empresa en la base de datos referencia --->
		<cfquery name="rsEmpresa" datasource="#cache#">
			insert INTO Empresas(Ecodigo, Mcodigo, Edescripcion, Elocalizacion, Ecache, Usucodigo, Ulocalizacion, cliente_empresarial, EcodigoSDC)
			values ( 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNewEmpresa.Ereferencia#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.identity#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewEmpresa.Enombre#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="00">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cache#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.identity#">
			)
		</cfquery>
	</cfif>
	<cfreturn rs.identity>
</cffunction>
</cfcomponent>