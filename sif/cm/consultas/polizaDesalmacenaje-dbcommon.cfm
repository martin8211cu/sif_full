<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- consulta el encabezado de la póliza --->
<cfif (isdefined("modo") and lcase(modo) eq "reporte")>
	<cfquery name="rsAlmacen" datasource="#session.DSN#">
		select Aid, Bdescripcion
		from Almacen
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	</cfquery>
	<cfquery name="rsEPD" datasource="#session.dsn#">
		select poliza.EPDestado, poliza.EPDid, poliza.CMAAid, poliza.Ecodigo, poliza.EPDnumero, poliza.EPembarque, poliza.EPembarque as ETidtracking,  poliza.EPembarque as idTracking
			, poliza.SNcodigo, poliza.EPDfecha, poliza.EPDdescripcion, poliza.EPDpaisori, '' as paisori
			, poliza.EPDpaisproc, '' as paisproc, poliza.EPDtotbultos, poliza.EPDpesobruto, poliza.EPDpesoneto
			, poliza.EPDobservaciones, poliza.Usucodigo, poliza.fechaalta, poliza.ts_rversion, '' as ts
			, aduanas.CMAid, aduanas.CMAcodigo, aduanas.CMAdescripcion
			, agencia.CMAAid, agencia.CMAAcodigo, agencia.CMAAdescripcion
			, socio.SNcodigo, socio.SNidentificacion, socio.SNtiposocio, socio.SNnombre, socio.SNnumero
			, (select count(1) from CMImpuestosPoliza impuestos 
				where impuestos.EPDid = poliza.EPDid and impuestos.Ecodigo = poliza.Ecodigo) as count_impuestos
			, (select count(1) from DPolizaDesalmacenaje detalles 
				where detalles.EPDid = poliza.EPDid and detalles.Ecodigo = poliza.Ecodigo) as count_detalles
			, poliza.EPDtcref
            , poliza.PermiteDesParcial
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
			and poliza.Ecodigo =  #Session.Ecodigo# 
	</cfquery>
	
	<!--- Como número de embarque lo que se muetra al usuario es el ETnumero, así es en la captura por tanto así debe ser aquí, para no confundir al usuario. --->
	<cfif rsEPD.recordcount and len(trim(rsEPD.EPembarque))>		
		<cfquery name="rsEtracking" datasource="sifpublica">
			select ETconsecutivo
			from ETracking
			where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEPD.EPembarque#">
		</cfquery>
		<cfif rsEtracking.recordcount and len(rsEtracking.ETconsecutivo)>
			<cfset QuerySetCell(rsEPD, 'EPembarque', rsEtracking.ETconsecutivo)>
		</cfif>
	</cfif>
	
	<!--- Busca los nombres de los paíces. --->
	<cfif rsEPD.recordcount and len(rsEPD.EPDpaisori)>
		<cfquery name="rsPais" datasource="asp">
			select Ppais, Pnombre
			from Pais 
			where Ppais = '#rsEPD.EPDpaisori#'
		</cfquery>
		<cfif rsPais.recordcount and len(rsPais.Pnombre)>
			<cfset QuerySetCell(rsEPD, 'paisori', rsPais.Pnombre)>
		</cfif>
	</cfif>
	<cfif rsEPD.recordcount and len(rsEPD.EPDpaisproc)>
		<cfquery name="rsPais" datasource="asp">
			select Ppais, Pnombre
			from Pais 
			where Ppais = '#rsEPD.EPDpaisproc#'
		</cfquery>
		<cfif rsPais.recordcount and len(rsPais.Pnombre)>
			<cfset QuerySetCell(rsEPD, 'paisproc', rsPais.Pnombre)>
		</cfif>
	</cfif>
	
	<!--- consulta todos los detalles de la póliza --->
	<cfquery name="rsLDPD" datasource="#session.dsn#">
		select 	detalles.DPDlinea, 
				detalles.EPDid, 
				detalles.DOlinea, 
				detalles.Ecodigo, 
				detalles.CMtipo, 
				case detalles.CMtipo when 'A' then 'Artículo' when 'S' then 'Servicio' when 'F' then 'Activo' end as CMtipodesc, 
				detalles.Cid, 
				detalles.Aid, 
				detalles.Alm_Aid, 
				detalles.ACcodigo, 
				detalles.ACid, 
				detalles.CAid, 
				detalles.Icodigo, 
				detalles.DPDpaisori, 
				detalles.DPDcantidad, 
				<cf_dbfunction name="sPart"	args="detalles.DPDdescripcion,1,40"> as DPDdescripcion, detalles.DPDpeso, detalles.DPDmontofobreal, 
				detalles.DPDmontocifreal, 
				detalles.DPDimpuestosreal, 
				coalesce(detalles.DPDsegurosprorrat, 0) as DPDsegurosprorrat,
				detalles.DPseguropropio,
				detalles.DPDsegurosreal,
				coalesce(detalles.DPDfletesprorrat, 0) as DPDfletesprorrat,
				detalles.DPDfletesreal, 
				detalles.DPDaduanalesreal, 
				detalles.DPDmontofobest, 
				detalles.DPDmontocifest, 
				detalles.DPDimpuestosest, 
				detalles.DPDsegurosest, 
				detalles.DPDfletesest, 
				detalles.DPDaduanalesest, 
				detalles.DPDvalordeclarado, 
				detalles.Usucodigo, 
				detalles.fechaalta, 
				codadu.CAdescripcion, 
				Impuestos.Idescripcion,
				case detalles.CMtipo when 'A' then art.Acodigo when 'S' then con.Ccodigo end codigo, 
				detalles.DPDimpuestosrecup,
				detalles.DPDvalordeclarado as montoreal,
                case when detalles.DPDcantidad = 0 then 0 else #LvarOBJ_PrecioU.enSQL("(detalles.DPDvalordeclarado)/detalles.DPDcantidad")# end as costounitario,
				detalles.Ucodigo, 
				u.Udescripcion,
				a.EOnumero,
                '' as Pnombre
				
		from DPolizaDesalmacenaje detalles
		
			inner join DOrdenCM a
				on detalles.DOlinea = a.DOlinea

			left outer join CodigoAduanal codadu
				on detalles.CAid = codadu.CAid
				and detalles.Ecodigo = codadu.Ecodigo

			left outer join Impuestos
				on detalles.Icodigo = Impuestos.Icodigo
				and detalles.Ecodigo = Impuestos.Ecodigo

			left outer join Articulos art
				on detalles.Aid=art.Aid
	
			left outer join Conceptos con
				on detalles.Cid=con.Cid
			
			left outer join Unidades u
				on u.Ucodigo = detalles.Ucodigo
				and u.Ecodigo = detalles.Ecodigo

		where detalles.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
			and detalles.Ecodigo =  #Session.Ecodigo# 
			
		order by a.EOidorden
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
	
	<!--- Consulta de las facturas de la póliza --->
	<cfquery name="rsFacturas" datasource="#session.dsn#">
		select documentos.Ddocumento, ddocumentos.DDIconsecutivo, concepto.Ccodigo, concepto.Cdescripcion as Concepto, fp.FMmonto * case when documentos.EDItipo = 'N' then -1 else 1 end as Monto
		from FacturasPoliza fp

		left outer join Conceptos concepto
			on concepto.Cid = fp.Cid
			and concepto.Ecodigo = fp.Ecodigo

		left outer join DDocumentosI ddocumentos
			left outer join EDocumentosI documentos
				on documentos.EDIid = ddocumentos.EDIid
				and documentos.Ecodigo = ddocumentos.Ecodigo
			on ddocumentos.DDlinea = fp.DDlinea
			and ddocumentos.Ecodigo = fp.Ecodigo

		where fp.EPDid = <cfqueryparam value="#form.EPDid#" cfsqltype="cf_sql_numeric">
			and fp.Ecodigo =  #session.Ecodigo# 
	</cfquery>
	
	<!--- Consulta de los impuestos de la póliza --->
	<cfquery name="rsImpuestos" datasource="#session.dsn#">
		select documentos.Ddocumento, ddocumentos.DDIconsecutivo,
		ip.CMIPmonto, i.Icodigo, i.Idescripcion
		
		from CMImpuestosPoliza ip
		left outer join Impuestos i
			on i.Icodigo = ip.Icodigo
			and i.Ecodigo = ip.Ecodigo

		left outer join DDocumentosI ddocumentos
			left outer join EDocumentosI documentos
				on documentos.EDIid = ddocumentos.EDIid
				and documentos.Ecodigo = ddocumentos.Ecodigo
			on ddocumentos.DDlinea = ip.DDlinea
			and ddocumentos.Ecodigo = ip.Ecodigo

		where ip.EPDid = <cfqueryparam value="#form.EPDid#" cfsqltype="cf_sql_numeric">
			and ip.Ecodigo =  #session.Ecodigo# 
	</cfquery>
<cfelse>
	<cfquery name="rsCMAgenciaAduanal" datasource="#session.DSN#" >
		select CMAAid, CMAAcodigo, CMAAdescripcion 
		from CMAgenciaAduanal
		where Ecodigo =  #session.Ecodigo#  
		order by CMAAcodigo, CMAAdescripcion 
	</cfquery>
	<cfquery name="rsCMAduanas" datasource="#session.DSN#" >
		select CMAid, CMAcodigo, CMAdescripcion 
		from CMAduanas
		where Ecodigo =  #session.Ecodigo#  
		order by CMAcodigo, CMAdescripcion 
	</cfquery>
</cfif>