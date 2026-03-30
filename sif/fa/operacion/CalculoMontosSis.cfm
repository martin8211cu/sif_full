		<!--- ============================================================================================== --->
<!---                                           Montos del usuario                                   --->
<!--- ============================================================================================== --->
<cffunction name="monto_usu" access="public" returntype="string">
<!--- 
	RESULTADO
	Devuelve totales por moneda. Es parametrizable, se le indican los campos 
	que se quieren recuperea .
--->
	<cfargument name="Mcodigo" type="string" required="false" default="">
	<cfargument name="campos"  type="string" required="false" default="">

	<cfset sql = "select " & campos & " as Monto from rsDatosUsu " >

	<cfif len(trim(Mcodigo)) gt 0 >
		<cfset sql = sql & " where Mcodigo = '" & Mcodigo & "'">
	</cfif>	

	<cfquery name="rsget_montoUsu" dbtype="query"  >
		#PreserveSingleQuotes(sql)#
	</cfquery>

	<cfif rsget_montoUsu.RecordCount gt 0 >
		<cfset monto = rsget_montoUsu.Monto >
	<cfelse>
		<cfset monto = 0 >
	</cfif>
	
	<cfreturn #monto#>
</cffunction>

<!--- datos del cierre por el usuario --->
<cfquery name="rsDatosUsu" datasource="#session.DSN#">
	select convert(varchar, a.FACid) as FACid, convert(varchar, b.Mcodigo) as Mcodigo,  FADCminicial, FADCcontado, FADCfcredito, FADCefectivo, FADCcheques, FADCvouchers, FADCdepositos, FADCncredito, FADCtc,  
	  FADCminicial*FADCtc as FADCminiciallocal, FADCcontado*FADCtc as FADCcontadolocal, FADCfcredito*FADCtc as FADCfcreditolocal, FADCefectivo*FADCtc as FADCefectivolocal, FADCcheques*FADCtc as FADCchequeslocal, FADCvouchers*FADCtc as FADCvoucherslocal, FADCdepositos*FADCtc as FADCdepositoslocal, FADCncredito*FADCtc as FADCncreditolocal
	from FACierres a, FADCierres b
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
	  and a.FACestado='T'
	  and a.FACid=b.FACid
</cfquery>

<!--- ============================================================================================== --->
<!---                                           Montos del Sistema                                   --->
<!--- ============================================================================================== --->
<!--- Devuelve el nombre de la moneda --->
<cffunction name="get_moneda" access="public" returntype="string">
	<cfargument name="Mcodigo" type="numeric" required="true" default="">
	<cfquery name="rsget_moneda" datasource="#session.DSN#" >
		select Mnombre from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
	</cfquery>
	<cfreturn #rsget_moneda.Mnombre#>
</cffunction>

<cffunction name="get_monto" access="public" returntype="string">
	<cfargument name="Mcodigo" 		type="numeric" required="true" default="">
	<cfargument name="Vencimiento"	type="string"  required="false" default="">
	<cfargument name="TipoPago" 	type="string"  required="false" default="">
	<cfargument name="TipoCredito" 	type="string"  required="false" default="">

	<cfquery name="rsget_monto" dbtype="query"  >
		select sum(Montoori) as Montoori
		from rsDatosPago
		where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">

		<cfif len(trim(Vencimiento)) gt 0 >
			and CCTvencim = -1
		</cfif>
		
		<cfif len(trim(TipoPago)) gt 0 >
			and TipoPago = <cfqueryparam cfsqltype="cf_sql_char" value="#TipoPago#">
		</cfif>

		<cfif len(trim(TipoCredito)) gt 0 >
			and CCTvencim != -1
			and CCTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#TipoCredito#">
		</cfif>
	</cfquery>
	
	<cfif rsget_monto.RecordCount eq 0 >
		<cfset monto = '0'>
	<cfelse>
		<cfset monto = rsget_monto.Montoori >
	</cfif>
	
	<cfreturn #monto#>
</cffunction>

<cffunction name="get_montolocal" access="public" returntype="string">
	<cfargument name="Mcodigo" 		type="numeric" required="true" default="">
	<cfargument name="Vencimiento"	type="string"  required="false" default="">
	<cfargument name="TipoPago" 	type="string"  required="false" default="">
	<cfargument name="TipoCredito" 	type="string"  required="false" default="">

	<cfquery name="rsget_montolocal" dbtype="query"  >
		select sum(MontoLocal) as MontoLocal
		from rsDatosPago
		where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">

		<cfif len(trim(Vencimiento)) gt 0 >
			and CCTvencim = -1
		</cfif>
		
		<cfif len(trim(TipoPago)) gt 0 >
			and TipoPago = <cfqueryparam cfsqltype="cf_sql_char" value="#TipoPago#">
		</cfif>

		<cfif len(trim(TipoCredito)) gt 0 >
			and CCTvencim != -1
			and CCTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#TipoCredito#">
		</cfif>
	</cfquery>
	
	<cfif rsget_monto.RecordCount eq 0 >
		<cfset monto = '0'>
	<cfelse>
		<cfset monto = rsget_montolocal.MontoLocal >
	</cfif>
	<cfreturn #monto#>
</cffunction>

<cffunction name="monto_tran" access="public" returntype="string">
<!--- 
	RESULTADO
	Devuelve totales por tipo de transacción. Es parametrizable, se le indican los campos 
	que se quieren recuperar .
--->
	<cfargument name="Mcodigo" type="string" required="false" default="">
	<cfargument name="campos"  type="string" required="false" default="1">
	<cfargument name="vencim"  type="string" required="false" default="">
	<cfargument name="tipo"    type="string" required="false" default="">

	<cfset sql = "select " & campos & " as Monto from rsDatosTran where FCid=" & #form.FCid# >

	<cfif len(trim(Mcodigo)) gt 0 >
		<cfset sql = sql & " and Mcodigo = " & Mcodigo >
	</cfif>	

	<cfif len(trim(vencim)) gt 0 and vencim eq "-1" >
		<cfset sql = sql & " and CCTvencim = -1 ">
	<cfelse>	
		<cfset sql = sql & " and CCTvencim != -1 " >
		<cfif len(trim(tipo)) gt 0 >	
			<cfset sql = sql & " and CCTtipo = '" & tipo & "'" >
		</cfif>	
	</cfif>	

	<cfquery name="rsget_montoTran" dbtype="query"  >
		#PreserveSingleQuotes(sql)#
	</cfquery>
	<cfif rsget_montoTran.RecordCount gt 0 >
		<cfset monto = rsget_montoTran.Monto >
	<cfelse>
		<cfset monto = 0 >
	</cfif>

	<cfreturn #monto#>
</cffunction>

<!--- Consulta General, todos los datos a procesar. --->
<cfquery name="rsDatosTran" datasource="#session.DSN#">
	select 
	a.FCid, 
	a.ETnumero, 
	a.Mcodigo, 
	a.ETtc, 
	a.ETtotal,
	a.ETtotal*ETtc as MontoLocal, 
	a.CCTcodigo, 
	c.CCTvencim,
	c.CCTtipo
	from ETransacciones a, CCTransacciones c
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
	  and a.ETestado='T'
	  and a.FACid is null
	  and a.CCTcodigo=c.CCTcodigo
	  and a.Ecodigo=c.Ecodigo	  
</cfquery>
<cfif rsDatosTran.RecordCount eq 0 ><cfset tran_total = 0 ><cfelse><cfset tran_total = rsDatosTran.MontoLocal></cfif>

<!--- hay transacciones de contado? --->
<cfquery name="rsHayContado" dbtype="query">
	select * from rsDatosTran where CCTvencim = -1
</cfquery>

<!--- Consulta General, todos los datos a procesar. Montos basados en la tabla de pagos --->
  <cfquery name="rsDatosPago" datasource="#session.DSN#">
	select 
	b.FCid as FCid, 
	b.ETnumero as ETnumero, 
	b.Tipo as TipoPago , 
	b.Mcodigo,  
	b.FPtc as TC, 
	b.FPmontoori as Montoori,
	FPmontolocal as MontoLocal, 
	a.CCTcodigo, c.CCTvencim,
	c.CCTtipo
	from ETransacciones a, FPagos b, CCTransacciones c
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
	  and a.ETestado='T'
	  and a.FACid is null
	  and a.FCid=b.FCid 
	  and a.ETnumero=b.ETnumero
	  and a.CCTcodigo=c.CCTcodigo
	  and a.Ecodigo=c.Ecodigo
</cfquery>

<!--- Monedas registradas en transacciones --->
<cfquery name="rsMonedasTran" dbtype="query">
	select distinct Mcodigo from rsDatosTran
</cfquery>

<!--- Monedas registradas en pagos --->
<cfquery name="rsMonedasPago" dbtype="query">
	select distinct Mcodigo from rsDatosPago
</cfquery>
