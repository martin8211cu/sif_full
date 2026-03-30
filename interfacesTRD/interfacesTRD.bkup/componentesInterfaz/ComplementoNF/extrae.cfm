<!--- Generacion de Complemento NOFACT
Se genera este nuevo Procedimiento 07-04-08--->

<cfquery name="rsVerifica" datasource="sifinterfaces">
	select *
	from int_ICTS_SOIN
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset varCodigoICTS = rsVerifica.CodICTS>
	<cfset varEcodigoSDC = rsVerifica.EcodigoSDCSoin>
</cfif>

<cfquery datasource="sifinterfaces">
if object_id('##CompNF') is not null
	drop table ##CompNF
</cfquery>

<cfquery name="EperiodoC" datasource="#session.dsn#">
	select Pvalor from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and Pcodigo = 50
</cfquery>
<cfquery name="EmesC" datasource="#session.dsn#">
	select Pvalor from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and Pcodigo = 60
</cfquery>
<cfset FechaFolio = "#EperiodoC.Pvalor##EmesC.Pvalor#">
<cfset varFechaDocumento = createdatetime(EperiodoC.Pvalor,EmesC.Pvalor + 1,1,23,59,59)>
<cfset varFechaDocumento = DateAdd('D',-1,varFechaDocumento)>
<cfquery datasource="sifinterfaces">
	select *
	into ##CompNF
	from DocumentoReversion dr
	where OriCosto != 0 
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and TipoMovimiento like 'F%'
	and IDREV = (select max(IDREV) 
				from DocumentoReversion 
				where OCid = dr.OCid 
				and Ecodigo = dr.Ecodigo
				and TipoMovimiento like 'F%'
				group by OCid,Mcodigo,Producto)
</cfquery>

<!--- Tomamos de la tabla de Reversiones NOFACT todos los NOFACT que tengan saldo --->
<cfquery name="rsCompNF" datasource="sifinterfaces">
	select *
	from ##CompNF
</cfquery>

<cfset LvarID = 0>
<cfif rsCompNF.recordcount GT 0>
<cfloop query="rsCompNF">

	<!--- Obtiene la fecha de tipo de cambio del ultimo Documento NOFACT en tabla --->
	<cfquery name="rsVerificaNF" datasource="sifinterfaces">
		<cfif rsCompNF.Modulo EQ 'CC'>
			select hd.EDtipocambioFecha 
			from DocumentoReversion dr 
				inner join #minisifdb#..HDocumentos hd 
				on dr.Documento = hd.Ddocumento 
				and dr.CodigoTransaccion = hd.CCTcodigo 
				and dr.SNcodigo = hd.SNcodigo 
				and dr.Ecodigo = hd.Ecodigo
			where dr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and dr.OCid = #rsCompNF.OCid#
			and IDREV = (select max(IDREV) 
							from DocumentoReversion 
							where OCid = dr.OCid 
							and SNcodigo != 0
							and Ecodigo = dr.Ecodigo
							group by OCid,Mcodigo,Producto)
		<cfelse>
			select hd.EDtipocambioFecha
			from DocumentoReversion dr 
				inner join #minisifdb#..HEDocumentosCP hd 
				on dr.Documento = hd.Ddocumento 
				and dr.CodigoTransaccion = hd.CPTcodigo 
				and dr.SNcodigo = hd.SNcodigo 
				and dr.Ecodigo = hd.Ecodigo
			where dr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and dr.OCid = #rsCompNF.OCid#
			and IDREV = (select max(IDREV) 
							from DocumentoReversion 
							where OCid = dr.OCid 
							and SNcodigo != 0
							and Ecodigo = dr.Ecodigo
							group by OCid,Mcodigo,Producto)
		</cfif>
	</cfquery>
	<cfset varFechaTipoCambio = rsVerificaNF.EDtipocambioFecha>
	
	<!--- Obtiene Numero de Socio --->
	<cfquery name="rsVerificaNF" datasource="sifinterfaces">
		select SNcodigoext 
		from #minisifdb#..SNegocios
		where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCompNF.SNcodigo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif rsVerificaNF.SNcodigoext EQ "">
		<cfquery name="rsVerificaNF" datasource="sifinterfaces">
			select SNcodigoext 
			from #minisifdb#..SNegocios a inner join #minisifdb#..OCordenComercial b 
											on a.Ecodigo = b.Ecodigo and a.SNid = b.SNid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and b.OCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCompNF.OCid#">
		</cfquery>
	</cfif>
	<cfset varNumeroSocio = rsVerificaNF.SNcodigoext>
	
	<!--- Obtiene Moneda --->
	<cfquery name="rsVerificaNF" datasource="sifinterfaces">
		select Miso4217
		from #minisifdb#..Monedas
		where Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCompNF.Mcodigo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset varMoneda = rsVerificaNF.Miso4217>
	
	<!--- Obtiene Concepto de Servicio --->
	<cfif rsCompNF.Modulo EQ "CC">
		<cfset varCServ = "CV-001">
	<cfelse>
		<cfset varCServ = "CV-002">
	</cfif>
	
	<!--- Obtiene Contrato --->
	<cfquery name="rsVerificaNF" datasource="sifinterfaces">
		select OCcontrato
		from #minisifdb#..OCordenComercial
		where OCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCompNF.OCid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset varOCcontrato = rsVerificaNF.OCcontrato>
	
	<!---Obtiene el Codigo de Transaccion --->
	<cfquery name="rsVerificaNF" datasource="sifinterfaces">
		select sum(OriCosto) as Total
		from ##CompNF
		where OCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCompNF.OCid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCompNF.Mcodigo#">
	</cfquery>
	<cfif rsVerificaNF.Total GT 0>
		<cfset varTranCodigo = 'XS'>
	<cfelse>
		<cfset varTranCodigo = 'ZS'>
	</cfif>
	
	<!--- Se crea el numero de Documento--->
	<cfset varDocumento = "#varOCcontrato#C#varTranCodigo##FechaFolio#">
	
	<!--- Se verifica si se genera documento si ya se genero anteriormente no se genera --->
	<!---Elimina los Documentos ya aplicados en la IE10--->
	<cfquery name="rsVerifica" datasource="sifinterfaces">
		select ID
		from IE10 a
		where Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varDocumento#">
		and EcodigoSDC = #varEcodigoSDC#
		and ID > 0
	</cfquery>
	<cfif rsVerifica.recordcount EQ 0>
	
		<!--- Inserta registro en la tabla de paso PMIINTIE10 y PMIINTID10 --->
		<cfset LvarID = LvarID + 1>	
	
		<!--- Se verifica si se genera o no Encabezado --->
		<cfquery name="rsVerificaNF" datasource="sifinterfaces">
			select ID
			from PMIINT_IE10
			where sessionid = #session.monitoreo.sessionid#
			and Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varDocumento#">
		</cfquery>
		<cfif rsVerificaNF.recordcount EQ 1 and rsVerificaNF.ID NEQ "">
			<cfset varID = ID>
			<cfset Encabezado = false>
		<cfelse>
			<cfset varID = LvarID>
			<cfset Encabezado = true>
		</cfif>
	
		<cfif Encabezado>
			<cfquery datasource="sifinterfaces">
				insert PMIINT_IE10 (FechaRegistro,sessionid,
					ID,EcodigoSDC, NumeroSocio, Modulo,CodigoTransacion, 
					Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento, 
					Facturado, Origen, VoucherNo, CodigoConceptoServicio, CodigoRetencion,
					CodigoOficina, DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
					FechaTipoCambio, StatusProceso)
				values
					(<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#varID#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#varNumeroSocio#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCompNF.Modulo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#varTranCodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#varDocumento#">,
					 null,<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#varFechaDocumento#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#varFechaDocumento#">,
					'S', 'ICTS',<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCompNF.OCid#">,null,null,
					null , 0 ,null,	null, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#varFechaTipoCambio#">, 1)
			</cfquery>
		</cfif>
	
		<!--- Obtiene el Consecutivo --->
		<cfquery name="rsVerificaNF" datasource="sifinterfaces">
			select max(Consecutivo) as Consecutivo
			from PMIINT_ID10 
			where sessionid = #session.monitoreo.sessionid#
			and ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varID#">
			group by ID
		</cfquery>
		<cfif rsVerificaNF.Consecutivo EQ "">
			<cfset varConsecutivo = 1>
		<cfelse>
			<cfset varConsecutivo = rsVerificaNF.Consecutivo + 1>
		</cfif>
	
		<cfquery datasource="sifinterfaces">
			insert #sifinterfacesdb#..PMIINT_ID10 (FechaRegistro,sessionid,
				ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, 
				FechaHoraCarga, FechaHoraSalida, PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
				CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, TripNo, 
				ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, CodigoAlmacen, 
				CodigoDepartamento, PrecioTotal, CentroFuncional, 
				CuentaFinancieraDet, OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra, OCconceptoIngreso)
			values(<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#varID#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#varConsecutivo#">,
				'S',<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCServ#">, null,
				null, null,abs(round(#rsCompNF.OriCosto#,2)),'',1,
				1, null,'0',<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, null, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOCcontrato#">, 
				null, 0, 0,null,
				null,abs(round(#rsCompNF.OriCosto#,2)), null, 
				null, null, null, null, null, null)					
		</cfquery>
	</cfif>
</cfloop>
</cfif>




