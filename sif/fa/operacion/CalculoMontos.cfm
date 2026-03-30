<!--- Consulta General, todos los datos a procesar --->
<cfquery name="rsDatos" datasource="#session.DSN#">
	select 
	isnull(a.FCid, b.FCid) as FCid, 
	isnull(a.ETnumero, b.ETnumero) as ETnumero, 
	b.Tipo as TipoPago , 
	isnull(b.Mcodigo, a.Mcodigo) as Mcodigo, 
	isnull(b.FPtc, a.ETtc) as TC, 
	isnull(FPmontoori, a.ETtotal) as Montoori,
	isnull(FPmontolocal, a.ETtotal) as MontoLocal, 
	a.CCTcodigo, c.CCTvencim,
	c.CCTtipo
	from ETransacciones a, FPagos b, CCTransacciones c
	where a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
	  and a.ETestado='T'
	  and a.FACid is null
	  and a.FCid*=b.FCid 
	  and a.ETnumero*=b.ETnumero
	  and a.CCTcodigo=c.CCTcodigo
	  and a.Ecodigo=c.Ecodigo
</cfquery>

<!--- Total para facturas de contado  --->
<cfquery name="rsContado" dbtype="query" >
	select sum(MontoLocal) as MontoLocal
	from rsDatos
	where CCTvencim = -1
</cfquery>
<cfif rsContado.RecordCount neq 0><cfset contado = rsContado.MontoLocal ><cfelse><cfset contado = 0 ></cfif>

<!--- Total para facturas de credito --->
<cfquery name="rsCredito"  dbtype="query">
	select sum(TC*Montoori) as Montoori
	from rsDatos
	where CCTvencim != -1
</cfquery>
<cfif rsCredito.RecordCount neq 0><cfset credito = rsCredito.Montoori ><cfelse><cfset credito = 0 ></cfif>

<!--- Monedas diferentes registradas --->

<!--- Total Sistema --->
<cfset total = contado + credito >

<!--- montos del usuario --->
<cfset ucontado = 900000000 >
<cfset ucredito = 53581267 >
<cfset utotal   = ucontado + ucredito >