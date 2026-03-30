<cfif isdefined("url.EOnumero1") and not isdefined("form.EOnumero1")>
	<cfset form.EOnumero1 = url.EOnumero1>
</cfif>
<cfif isdefined("url.EOnumero2") and not isdefined("form.EOnumero2")>
	<cfset form.EOnumero2 = url.EOnumero2>
</cfif>
<cfif isdefined("url.Ccuenta") and not isdefined("form.Ccuenta")>
	<cfset form.Ccuenta = url.Ccuenta>
</cfif>
<cfif isdefined("url.CMCid1") and not isdefined("form.CMCid1")>
	<cfset form.CMCid1 = url.CMCid1>
</cfif>
<cfif isdefined("url.SNcodigo1") and not isdefined("form.SNcodigo1")>
	<cfset form.SNcodigo1 = url.SNcodigo1>
</cfif>
<cfif isdefined("url.ETidtracking_move1") and not isdefined("form.ETidtracking_move1")>
	<cfset form.ETidtracking_move1 = url.ETidtracking_move1>
</cfif>
<cfif isdefined("url.ColumnasAdicionales") and not isdefined("form.ColumnasAdicionales")>
	<cfset form.ColumnasAdicionales = url.ColumnasAdicionales>
</cfif>

<!--- Verifica que la orden inicial sea menor que la final, sino las intercambia --->
<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and isdefined("form.EOnumero2") and len(trim(form.EOnumero2))>
	<cfif EOnumero1 gt EOnumero2>
		<cfset tmp = form.EOnumero1>
		<cfset form.EOnumero1 = form.EOnumero2>
		<cfset form.EOnumero2 = tmp>
	</cfif>
</cfif>

<!--- Obtiene la descripción de la cuenta seleccionada --->
<cfquery name="rsAuxiliarTransito" datasource="#session.dsn#">
	select cc.Cdescripcion
	from CContables cc
	where cc.Ccuenta = <cfqueryparam value="#form.Ccuenta#" cfsqltype="cf_sql_numeric">
</cfquery>

<!--- Obtiene la moneda de la empresa --->
<cfquery name="rsMoneda" datasource="#session.dsn#">
	select m.Mnombre
	from Monedas m
	where m.Mcodigo = (select e.Mcodigo from Empresas e where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
</cfquery>

<!--- Obtiene los datos del reporte --->
<cfquery name="rsSaldosMercaderiaTransito" datasource="#session.dsn#">
	select eo.EOnumero,
		   sn.SNidentificacion,
		   sn.SNnombre,
		   comp.CMCnombre,
		   iac.IACtransito,
		   et.ETconsecutivo,
		   coalesce(art.Acodigo, con.Ccodigo) as codigo,
		   do.DOdescripcion,
		   eti.ETcantfactura,
		   eti.ETcantrecibida,
		   eti.ETIcantidad,
		   eti.ETcostodirecto as ETcostodirecto,
		   (eti.ETcostoindfletes + eti.ETcostoindfletesPoliza) as Fletes,
		   (eti.ETcostoindseg + eti.ETcostoindsegPoliza) as Seguros,
		   eti.ETcostoindsegpropio as ETcostoindsegpropio,
		   eti.ETcostoindgastos as ETcostoindgastos,
		   eti.ETcostoindimp as ETcostoindimp,
		   eti.ETcostorecibido as ETcostorecibido,
		   (eti.ETcostodirecto + eti.ETcostoindfletes + eti.ETcostoindfletesPoliza
		   + eti.ETcostoindseg + eti.ETcostoindsegPoliza + eti.ETcostoindsegpropio
		   + eti.ETcostoindgastos + eti.ETcostoindimp - eti.ETcostorecibido) as Saldo
	from ETrackingItems eti
		inner join ETracking et
			on et.ETidtracking = eti.ETidtracking
		inner join DOrdenCM do
			on do.DOlinea = eti.DOlinea
		left outer join Articulos art
			on art.Aid = do.Aid
		left outer join Conceptos con
			on con.Cid = do.Cid
		left outer join Existencias ex
			on ex.Aid = do.Aid
			and ex.Alm_Aid = do.Alm_Aid
		left outer join IAContables iac
			on iac.IACcodigo = ex.IACcodigo
			and iac.Ecodigo = eti.Ecodigo
		left outer join AClasificacion ac
			on ac.Ecodigo = do.Ecodigo
			and ac.ACid = do.ACid
			and ac.ACcodigo = do.ACcodigo
		inner join EOrdenCM eo
			on eo.EOidorden = do.EOidorden
		inner join SNegocios sn
			on sn.SNcodigo = eo.SNcodigo
			and sn.Ecodigo = eo.Ecodigo
		inner join CMCompradores comp
			on comp.CMCid = eo.CMCid
	where eti.ETcantfactura > 0
		and eti.ETIcantidad > 0
		and eti.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1))>
		and eo.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
		</cfif>
		<cfif isdefined("form.SNcodigo1") and len(trim(form.SNcodigo1))>
		and eo.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo1#">
		</cfif>
		<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and not isdefined("form.EOnumero2")>
		and eo.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
		</cfif> 
		<cfif isdefined("form.EOnumero2") and len(trim(form.EOnumero2)) and not isdefined("form.EOnumero1")>
		and eo.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
		</cfif> 
		<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and isdefined("form.EOnumero2") and len(trim(form.EOnumero2))>
		and eo.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#"> and  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
		</cfif>
		<cfif isdefined("form.ETidtracking_move1") and len(trim(form.ETidtracking_move1))>
		and et.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move1#">
		</cfif>
		<cfif isdefined("form.Ccuenta") and len(trim(form.Ccuenta))>
		and (iac.IACtransito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">
			or (select Pvalor from Parametros where Pcodigo = 240 and Ecodigo = #session.Ecodigo#) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccuenta#">)
		</cfif>
	order by eo.EOnumero
</cfquery>
