<!--- Archivo de consultas a la BD de la pantalla de Captura de Datos para el Cálculo de las Importaciones. --->

<!--- Consultas generales--->

<!--- Paises --->
<cfquery name="rsPais" datasource="asp">
	select Ppais, Pnombre
	from Pais 
	order by Pnombre
</cfquery>

<!--- Seguros --->
<cfquery name="rsCMSeguros" datasource="#session.DSN#">
	select CMSid, CMSdescripcion, Costos, Fletes, Seguros, Gastos, Impuestos, ESporcadic, ESporcmult
	from CMSeguros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
</cfquery>

<!--- Codigos Aduanales --->
<cfquery name="rsCMAgenciaAduanal" datasource="#session.DSN#" >
	select CMAAid, CMAAcodigo, CMAAdescripcion 
	from CMAgenciaAduanal
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
	order by CMAAcodigo, CMAAdescripcion 
</cfquery>

<!--- Aduanas --->
<cfquery name="rsCMAduanas" datasource="#session.DSN#" >
	select CMAid, CMAcodigo, CMAdescripcion 
	from CMAduanas
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
	order by CMAcodigo, CMAdescripcion 
</cfquery>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#session.dsn#">
	select Mcodigo
	from Empresas
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Consultas por modo--->
<cfif (isdefined("modo") and lcase(modo) eq "lista")>
	<!--- consulta todos las polizas, se pasó para el arhivo que pinta la lista--->
<cfelse>
	<cfif (isdefined("modo") and lcase(modo) eq "cambio")>
	
		<!--- consulta el encabezado de la póliza --->
		<cfquery name="rsEPD" datasource="#session.dsn#">
			select poliza.EPDid, poliza.CMAAid, poliza.Ecodigo, poliza.EPDnumero, poliza.EPembarque
				, poliza.SNcodigo, poliza.EPDfecha, poliza.EPDdescripcion, poliza.EPDpaisori
				, poliza.EPDpaisproc, poliza.EPDtotbultos, poliza.EPDpesobruto, poliza.EPDpesoneto
				, poliza.EPDobservaciones, poliza.Usucodigo, poliza.fechaalta, poliza.ts_rversion, '' as ts
				, aduanas.CMAid, aduanas.CMAcodigo, aduanas.CMAdescripcion
				, agencia.CMAAid, agencia.CMAAcodigo, agencia.CMAAdescripcion
				, socio.SNcodigo, socio.SNidentificacion, socio.SNtiposocio, socio.SNnombre
				, (select count(1) from CMImpuestosPoliza impuestos 
					where impuestos.EPDid = poliza.EPDid and impuestos.Ecodigo = poliza.Ecodigo) as count_impuestos
				, (select count(1) from DPolizaDesalmacenaje detalles 
					where detalles.EPDid = poliza.EPDid and detalles.Ecodigo = poliza.Ecodigo) as count_detalles
				, '' as ETidtracking_move, '' as ETconsecutivo_move, '' as ETnumtracking_move
				, poliza.Mcodigoref, poliza.EPDtcref, poliza.CMSid,
				poliza.EPDFOBDecAduana,
			   poliza.EPDFletesDecAduana,
			   poliza.EPDSegurosDecAduana,
			   poliza.EPDGastosDecAduana,
			   (select sum(a.EPDFOBDecAduana +
						  a.EPDFletesDecAduana +
						  a.EPDSegurosDecAduana +
						  a.EPDGastosDecAduana) 
	   			 from EPolizaDesalmacenaje a
				where a.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
			  		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">) as total_declarado,
               poliza.PermiteDesParcial,
               poliza.EPDidpadre
			from EPolizaDesalmacenaje poliza
				left outer join CMAduanas aduanas
					on poliza.CMAid = aduanas.CMAid
					and poliza.Ecodigo = aduanas.Ecodigo
				left outer join CMAgenciaAduanal agencia 
					on poliza.CMAAid = agencia.CMAAid
					and poliza.Ecodigo = agencia.Ecodigo
				left outer join SNegocios socio
					on poliza.Ecodigo = socio.Ecodigo 
					and  poliza.SNcodigo = socio.SNcodigo
			where poliza.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
				and poliza.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsEPD.ts_rversion#"/>
		</cfinvoke>
		
		<cfset QuerySetCell(rsEPD,'ts',ts)>
		<cfif rsEPD.RecordCount and len(trim(rsEPD.EPembarque)) and IsNumeric(trim(rsEPD.EPembarque))>						
			<cfquery name="rsTracking" datasource="sifpublica">
				select ETidtracking, ETconsecutivo, ETnumtracking
				from ETracking
				where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(rsEPD.EPembarque)#">
			</cfquery>
			<cfif rsTracking.RecordCount>
				<cfset QuerySetCell(rsEPD,'ETidtracking_move',rsTracking.ETidtracking)>
				<cfset QuerySetCell(rsEPD,'ETconsecutivo_move',rsTracking.ETconsecutivo)>
				<cfset QuerySetCell(rsEPD,'ETnumtracking_move',rsTracking.ETnumtracking)>
			</cfif>
		</cfif>
		
		<cfquery name="rsLineasSinSeguro" datasource="#session.dsn#">
			select 1 as total
			from DPolizaDesalmacenaje dpd
			where dpd.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
				and dpd.CMSid is null
		</cfquery>

		<!--- consulta todos los detalles de la póliza --->
		<cfquery name="rsLDPD" datasource="#session.dsn#">
			select detalles.DPDlinea, detalles.EPDid, detalles.DOlinea, detalles.Ecodigo, detalles.CMtipo, 
				case detalles.CMtipo when 'A' then 'Artículo' when 'S' then 'Servicio' when 'F' then 'Activo' end as CMtipodesc, 
				detalles.Cid, detalles.Aid, detalles.Alm_Aid, detalles.ACcodigo, detalles.ACid, detalles.CAid, detalles.Icodigo, 
				detalles.DPDpaisori, detalles.DPDcantidad, <cf_dbfunction name="sPart" args="detalles.DPDdescripcion,1,40"> as DPDdescripcion, detalles.DPDpeso, detalles.DPDmontofobreal, 
				detalles.DPDmontocifreal, detalles.DPDimpuestosreal, detalles.DPDsegurosreal, detalles.DPDfletesreal, 
				detalles.DPDaduanalesreal, detalles.DPDmontofobest, detalles.DPDmontocifest, detalles.DPDimpuestosest, 
				detalles.DPDsegurosest, detalles.DPDfletesest, detalles.DPDaduanalesest, detalles.DPDvalordeclarado, 
				detalles.Usucodigo, detalles.fechaalta, detalles.DPDcostoudescoc, codadu.CAdescripcion, Impuestos.Idescripcion, '' as Pnombre,
				'Costos' as FPafectadesc, coalesce(eti.ETIiditem, -1) as ETIiditem, detalles.Ucodigo, u.Udescripcion,
				eo.EOnumero
			from DPolizaDesalmacenaje detalles
				left outer join ETrackingItems eti
					on eti.ETIiditem = detalles.DDlinea
					and eti.Ecodigo = detalles.Ecodigo
				left outer join CodigoAduanal codadu
					on detalles.CAid = codadu.CAid
					and detalles.Ecodigo = codadu.Ecodigo
				left outer join Impuestos
					on detalles.Icodigo = Impuestos.Icodigo
					and detalles.Ecodigo = Impuestos.Ecodigo
				left outer join Unidades u
					on u.Ucodigo = detalles.Ucodigo
					and u.Ecodigo = detalles.Ecodigo
				inner join DOrdenCM docm
					on docm.DOlinea = detalles.DOlinea
				inner join EOrdenCM eo
					on eo.EOidorden = docm.EOidorden
			where detalles.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
			order by docm.EOnumero
		</cfquery>
		
		<cfif rsLDPD.recordcount>
			<cfloop query="rsLDPD">
				<cfif len(rsLDPD.DPDpaisori)>					
					<cfquery name="rsLDPDPais" dbtype="query">
						select Pnombre 
						from rsPais
						where Ppais = '#rsLDPD.DPDpaisori#'
					</cfquery>
					<cfif rsLDPDPais.recordcount and len(rsLDPDPais.Pnombre)>
						<cfset QuerySetCell(rsLDPD,'Pnombre',rsLDPDPais.Pnombre,CurrentRow)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<!--- Consulta todas las facturas de la póliza--->
		<cfquery name="rsLFP" datasource="#session.dsn#">
			select facturas.FPid, facturas.EPDid, facturas.Ecodigo, 
				facturas.SNcodigo, socio.SNnumero, socio.SNnombre, 
				facturas.Cid, concepto.Ccodigo, concepto.Cdescripcion, case when documento.EPDid is not null then '*' else '' end as gastoexclusivo, 
				facturas.FMmonto * case when edocumento.EDItipo = 'N' then -1 else 1 end as FMmonto, facturas.FPfecha, facturas.Usucodigo, facturas.fechaalta, facturas.FPafecta, 
				case facturas.FPafecta when 1 then 'Fletes' when 2 then 'Seguros' when 3 then 'Costos' when 4 then 'Gastos' when 5 then 'Impuestos' end as FPafectadesc, 
				facturas.DOlinea, facturas.DDlinea, documento.EPDid as dEPDid, 
				documento.DDIconsecutivo, edocumento.Ddocumento, 
				documento.EDIid, documento.DDIafecta, documento.cantidadrestante, 
				round(documento.montorestante * edocumento.EDItc,2) as montorestante
			from FacturasPoliza facturas
				left outer join DDocumentosI documento 
					left outer join EDocumentosI edocumento
						on edocumento.EDIid = documento.EDIid
						and edocumento.Ecodigo = documento.Ecodigo
					on documento.DDlinea = facturas.DDlinea
					and documento.Ecodigo = facturas.Ecodigo
				left outer join SNegocios socio
					on socio.SNcodigo = facturas.SNcodigo
					and socio.Ecodigo = facturas.Ecodigo
				left outer join Conceptos concepto
					on concepto.Cid = facturas.Cid
					and concepto.Ecodigo = facturas.Ecodigo
			where facturas.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
				and facturas.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			order by FPafectadesc, Ddocumento, DDIconsecutivo
		</cfquery>

		<!--- Consulta todos los impuestos de la póliza--->
		<cfquery name="rsLIP" datasource="#session.dsn#">
			select impuestos.Ecodigo, impuestos.Icodigo, impuesto.Idescripcion, 
				impuestos.EPDid, impuestos.CMIPmonto, impuestos.CMIPcridotfiscal, impuestos.Usucodigo, 
				impuestos.fechaalta, impuestos.DDlinea, 
				documento.DDIconsecutivo, edocumento.Ddocumento,
				documento.EDIid, documento.DDIafecta, documento.cantidadrestante, 
				round(documento.montorestante * edocumento.EDItc,2) as montorestante
			from CMImpuestosPoliza impuestos
				left outer join DDocumentosI documento 
					left outer join EDocumentosI edocumento
						on edocumento.EDIid = documento.EDIid
						and edocumento.Ecodigo = documento.Ecodigo
					on documento.DDlinea = 	impuestos.DDlinea
					and documento.Ecodigo = impuestos.Ecodigo
				left outer join Impuestos impuesto
					on impuesto.Icodigo = impuestos.Icodigo
					and impuesto.Ecodigo = impuestos.Ecodigo
			where impuestos.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
				and impuestos.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			order by Ddocumento, DDIconsecutivo
		</cfquery>
		
		<cfif (isdefined("mododet") and lcase(mododet) eq "cambio")>
		
			<cfif (isdefined("form.DPDlinea") and len(form.DPDlinea) and form.DPDlinea)>
			
				<!--- consulta el detalle de la póliza --->
				<cfquery name="rsDPD" datasource="#session.dsn#">
					select detalles.DDlinea, detalles.DPDlinea, detalles.EPDid, detalles.DOlinea, detalles.Ecodigo, detalles.CMtipo, 
						case detalles.CMtipo when 'A' then 'Artículo' when 'S' then 'Servicio' when 'F' then 'Activo' end as CMtipodesc, 
						detalles.Cid, detalles.Aid, detalles.Alm_Aid, detalles.ACcodigo, detalles.ACid, detalles.CAid, detalles.Icodigo, 
						detalles.DPDpaisori, detalles.DPDcantidad, detalles.DPDdescripcion, detalles.DPDpeso, detalles.DPDmontofobreal, 
						detalles.DPDmontocifreal, detalles.DPDimpuestosreal, detalles.DPDsegurosreal, detalles.DPDfletesreal, 
						detalles.DPDaduanalesreal, detalles.DPDmontofobest, detalles.DPDmontocifest, detalles.DPDimpuestosest, 
						detalles.DPDsegurosest, detalles.DPDfletesest, detalles.DPDaduanalesest, detalles.DPDvalordeclarado, 
						detalles.Usucodigo, detalles.fechaalta, detalles.ts_rversion, detalles.DPDcostoudescoc, detalles.Ucodigo, 
						'' as ts, codadu.CAdescripcion, Impuestos.Idescripcion, coalesce(eti.ETIcantidad, 0) as cantidadrestante,
						coalesce(eti.ETcostodirecto, 0) - eti.ETcostodirectorec as montorestante,
						u.Udescripcion, coalesce(detalles.DPcostodec,0.00) as DPcostodec, coalesce(detalles.DPsegurodec,0.00) as DPsegurodec, coalesce(detalles.DPfeltedec,0.00) as DPfletedec,
						coalesce(detalles.DPseguropropio,0.00) as DPseguropropio, detalles.CMSid, detalles.DPDcantreclamo, detalles.DPDobsreclamo,
						coalesce(detalles.DPDfletesprorrat, 0) as DPDfletesprorrat, coalesce(detalles.DPDsegurosprorrat, 0) as DPDsegurosprorrat
					from DPolizaDesalmacenaje detalles
						left outer join ETrackingItems eti
							on eti.ETIiditem = detalles.DDlinea
							and eti.Ecodigo = detalles.Ecodigo
						left outer join CodigoAduanal codadu
							on detalles.CAid = codadu.CAid
							and detalles.Ecodigo = codadu.Ecodigo
						left outer join Impuestos
							on detalles.Icodigo = Impuestos.Icodigo
							and detalles.Ecodigo = Impuestos.Ecodigo
						left outer join Unidades u
							on u.Ucodigo = detalles.Ucodigo
							and u.Ecodigo = detalles.Ecodigo
					where detalles.DPDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DPDlinea#">
						and detalles.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
						and detalles.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
			</cfif>
			
			<cfif rsDPD.recordcount>
				<cfinvoke 
					component="sif.Componentes.DButils"
					method="toTimeStamp"
					returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rsDPD.ts_rversion#"/>
				</cfinvoke>
				<cfset QuerySetCell(rsDPD,'ts',ts)>
			<cfelse>
				<cf_errorCode	code = "50316" msg = "No se encontró el registro, requerido para la modificación.">
			</cfif>
		</cfif>

		<!--- Consultas del detalle de la cotización --->
		
		<!--- Consulta de Códigos Aduanales (CAid)--->		
		<cfquery name="rsCodigoAduanal" datasource="#session.DSN#" >
			select CAid, CAdescripcion 
			from CodigoAduanal 
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
			order by CAdescripcion 
		</cfquery>
		
		<!--- Consulta de impuestos --->
		<cfquery name="rsImpuestos" datasource="#session.DSN#">
			select Icodigo, Idescripcion 
			from Impuestos 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			order by Idescripcion 
		</cfquery>
	</cfif>
</cfif>

