<cf_navegacion name="ESidsolicitud">
<cftransaction>
	<cfloop collection="#Form#" item="i">
		<cfif FindNoCase("chkHijo_", i) NEQ 0 and Form[i] NEQ 0>
			<cfset Lineas  = Form[i]>
			<cfset LvarDet = #ListToArray(Lineas, ",")#>
			 <cfloop from="1" to="#ArrayLen(LvarDet)#" index="n">
				<cfset LvarDetalle   = #ListToArray(LvarDet[n], "|")#>
				<cfset LvarDClinea 	 = LvarDetalle[5]>
				<cfset LvarESidsolicitud = form.ESidsolicitud>
				<!--- ►►Obtiene cada una de las lineas del contrato◄◄--->
				<cfquery name="rsDatos" datasource="#Session.DSN#">
					SELECT DClinea,
						   ECid,
						   Ecodigo,
						   DCtipoitem,
						   Aid,
						   Cid,
						   ACcodigo,
						   ACid,
						   Mcodigo,
						   Icodigo,
						   Ucodigo,
						   DCpreciou,
						   DCtc,
						   DCgarantia,
						   DCdescripcion,
						   DCdescalterna,
						   DCcantcontrato,
						   DCcantsurtida,
						   BMUsucodigo,
						   DCdiasEntrega
				   FROM DContratosCM
				  WHERE DClinea = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#LvarDClinea#">
			 </cfquery>
			    <!--- ►►ID de la Solicitud de compra que se esta llenado◄◄--->
				<cfquery name="rsSolicitudCompra" datasource="#session.dsn#">
					select ESnumero, ESidsolicitud, CFid
					  from ESolicitudCompraCM
					 where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarESidsolicitud#">
					   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Ecodigo#">
				</cfquery>
				<!--- Consecutivo del detalle --->
				<cfquery name="rsConsecutivoSC" datasource="#session.dsn#">
					select max(coalesce(DSconsecutivo,0)) as Consecutivo
					  from DSolicitudCompraCM
					 where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarESidsolicitud#">
					   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Ecodigo#">
				</cfquery>
				<!--- id de almacen --->
				<cfquery name="rsAlmacen" datasource="#session.dsn#">
					select Alm_Aid
					  from Existencias
					 where Aid = coalesce(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Aid#">,0)
					   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Ecodigo#">
				</cfquery>
				<!--- impuesto --->
				<cfquery name="rsImpuesto" datasource="#session.dsn#">
					select Iporcentaje
					  from Impuestos
					 where Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Icodigo#">
					   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Ecodigo#">
				</cfquery>
				<!--- variables --->
				<cfset montoTotalLin = rsDatos.DCcantcontrato * rsDatos.DCpreciou>
				<cfset cantImpuesto  = rsImpuesto.Iporcentaje/100 * montoTotalLin>
				<cfset cantDisp		 = rsDatos.DCcantcontrato - rsDatos.DCcantsurtida>
				<cfif rsConsecutivoSC.Consecutivo GT 0>
					<cfset Consecutivo = rsConsecutivoSC.Consecutivo + 1>
				<cfelse>
					<cfset Consecutivo = 1>
				</cfif>
				<!--- <cf_dump var=#Consecutivo#> --->
				<!---Inserta linea de detalle de la Solicitud de compra--->
				<cfinvoke component="sif.Componentes.CM_ContratoSolicitud"  method="insert_DSolicitudCompraCM">
					<cfinvokeargument name="ESidsolicitud"		value="#LvarESidsolicitud#">
					<cfinvokeargument name="Ecodigo" 			value="#rsDatos.Ecodigo#">
					<cfinvokeargument name="ESnumero"			value="#rsSolicitudCompra.ESnumero#">
					<cfinvokeargument name="DSconsecutivo"		value="#Consecutivo#">
					<cfinvokeargument name="DScant"				value="#cantDisp#">
					<cfinvokeargument name="Aid"				value="#rsDatos.Aid#">
					<cfinvokeargument name="Alm_Aid"			value="#rsAlmacen.Alm_Aid#">
					<cfinvokeargument name="Cid"				value="#rsDatos.Cid#">
					<cfinvokeargument name="ACcodigo"			value="#rsDatos.ACcodigo#">
					<cfinvokeargument name="ACid"				value="#rsDatos.ACid#">
					<cfinvokeargument name="CMCid"				value="#session.Usucodigo#">
					<cfinvokeargument name="Icodigo"			value="#rsDatos.Icodigo#">
					<cfinvokeargument name="Ucodigo"			value="#rsDatos.Ucodigo#">
					<cfinvokeargument name="CFid"				value="#rsSolicitudCompra.CFid#">
					<cfinvokeargument name="DSdescripcion"		value="#rsDatos.DCdescripcion#">
					<cfinvokeargument name="DSmontoest"			value="#rsDatos.DCpreciou#">
					<cfinvokeargument name="DStotallinest"		value="#montoTotalLin#">
					<cfinvokeargument name="DStipo"				value="#rsDatos.DCtipoitem#">
					<cfinvokeargument name="DSespecificacuenta"	value="0">
					<cfinvokeargument name="BMUsucodigo"		value="#session.Usucodigo#">
					<cfinvokeargument name="DScontratos"		value="0">
					<cfinvokeargument name="DSimpuestoCF"		value="#cantImpuesto#">
					<cfinvokeargument name="DSnoPresupuesto"	value="1">
					<cfinvokeargument name="DScantidadNAP"		value="#rsDatos.DCcantcontrato#">
					<cfinvokeargument name="DSmontoOriNAP"		value="#montoTotalLin#">
					<cfinvokeargument name="DScontrolCantidad"	value="1">
					<cfinvokeargument name="codIEPS"			value="0">
					<cfinvokeargument name="DSMontoIeps"		value="0">
					<cfinvokeargument name="afectaIVA"			value="0">
					<cfinvokeargument name="ECid"				value="#rsDatos.ECid#">
					<cfinvokeargument name="DClinea"			value="#rsDatos.DClinea#">
				</cfinvoke>

			   <!--- calcula Monto--->
				<cfinvoke component="sif.Componentes.FAP_AplicaPedidos" method="calculaTotalesEOrdenCM">
					<cfinvokeargument name="ecodigo"   value="#rsDatos.Ecodigo#">
					<cfinvokeargument name="eoidorden" value="#LvarESidsolicitud#">
				</cfinvoke>

			</cfloop>
		</cfif>
	</cfloop>
	<cfset total = getTotal(form.ESidsolicitud) >

	<cfquery name="update" datasource="#session.DSN#">
		update ESolicitudCompraCM
		set
			EStotalest	  = <cf_jdbcQuery_param value="#total#" cfsqltype="cf_sql_money">
		where ESidsolicitud = <cfqueryparam value="#form.ESidsolicitud#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cf_cboFormaPago TESOPFPtipoId="1" TESOPFPid="#Form.ESidsolicitud#" SQL="update">
</cftransaction>
<!--- Function getTotal --->
<cffunction name="getTotal" returntype="numeric">
	<cfargument name="id" type="numeric" required="yes">
	<cfargument name="idieps" type="numeric" required="no" default ="0">

	<cfquery name="rsPreTotales" datasource="#session.DSN#">
		select case when (b.DStipo = 'S' or b.DStipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN
				COALESCE(round(round(DScant*DSmontoest,2) * c.Iporcentaje/100,2) +
				round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)
			  else
				COALESCE(round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2) +
				round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)
			  end as  total
		from ESolicitudCompraCM a
			inner join DSolicitudCompraCM b
				on a.ESidsolicitud=b.ESidsolicitud
			inner join Impuestos c
				on a.Ecodigo=c.Ecodigo
				and b.Icodigo=c.Icodigo
			left join Impuestos d
				on a.Ecodigo=d.Ecodigo
				and b.codIEPS=d.Icodigo
			left join Conceptos e
				on e.Cid = b.Cid
			left join Articulos f
				on f.Aid= b.Aid
		where a.ESidsolicitud = <cfqueryparam value="#id#" cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfquery name="rsTotal" dbtype="query">
		select sum(total) as total
		from rsPreTotales
	</cfquery>

	<cfif rsTotal.RecordCount gt 0 and len(trim(rsTotal.total))>
		<cfreturn rsTotal.total>
	<cfelse>
		<cfreturn 0 >
	</cfif>
</cffunction>
<script language="JavaScript" type="text/javascript">
	//llama a la funcion de cambio de orden de compra
	if (window.opener.document.form1.Cambio)
		window.opener.document.form1.Cambio.click();
	else if (window.opener.document.form1.CambioDet)
		window.opener.document.form1.CambioDet.click();
	window.close();
	window.opener.location.reload(false);
</script>