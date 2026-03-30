<cfset minisifdb = Application.dsinfo[session.dsn].schema>

<!--- Tabla de trabajo --->
<!---
create table sif_interfaces..ACostoVentas(
  fecharegistro date not null,
  sessionid int not null,
  Modulo char(2) not null,
  Producto varchar(20) not null,
  Ecodigo int not null,
  OriCosto float null,
  Mcodigo int not null,
  Procesado char(1) not null,
  OCid int not null,
  OCTid int null,
  BMperiodo int null,
  BMmes int null,
  Concatena int null,
  OCcontrato varchar(20) null
)
--->

<cfquery datasource="sifinterfaces">
	delete ACostoVentas 
	where sessionid = #session.monitoreo.sessionid# 
	or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">  
</cfquery>
<cfquery datasource="sifinterfaces">
if object_id('##ACVNFsaldo') is not null
	drop table ##ACVNFsaldo
if object_id('##ACVCxC') is not null
	drop table ##ACVCxC
if object_id('##ACVCxP') is not null
	drop table ##ACVCxP
</cfquery>

<!--- Verifica si ya se genero la Poliza de ajuste para el periodo actual --->
<cfquery name="rsVerificaEC" datasource="sifinterfaces">
	select 1 
	from #minisifdb#..EContables 
	where Eperiodo = #Actperiodo# 
	and Emes = #Actmes#
	and Edocbase = 'ACV#Actperiodo##Actmes#'
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsVerificaHEC" datasource="sifinterfaces">
	select 1 
	from #minisifdb#..HEContables 
	where Eperiodo = #Actperiodo# 
	and Emes = #Actmes#
	and Edocbase = 'ACV#Actperiodo##Actmes#'
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif rsVerificaEC.recordcount GT 0 OR rsVerificaHEC.recordcount GT 0>
	<cfabort showerror="Ya se genero poliza de ajuste para el Periodo actual">
</cfif>

<!---Mediante este query Se obtienen los NOFACT con saldo segun su periodo y mes--->
<cfquery datasource="sifinterfaces">
	select *
	into ##ACVNFsaldo
	from DocumentoReversion dr
	where OriCosto != 0 
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and TipoMovimiento like 'F%'
	and IDREV = (select max(IDREV) 
				from DocumentoReversion 
				where OCid = dr.OCid 
				and Ecodigo = dr.Ecodigo
				group by OCid,Mcodigo,Producto)
	order by Documento

	--Obtiene Periodo para Documentos de CxC
	select d.*,c.BMperiodo,c.BMmes,convert(varchar,BMperiodo) + convert(varchar,BMmes) as Concatena
	into ##ACVCxC
	 from #minisifdb#..HDDocumentos a 
		inner join #minisifdb#..HDocumentos b
			inner join #minisifdb#..BMovimientos c 
			on b.Ddocumento = c.Ddocumento and b.CCTcodigo = c.CCTcodigo and b.CCTcodigo in ('EC','DC')
			and c.CCTcodigo = c.CCTRcodigo and b.Ecodigo = c.Ecodigo and b.SNcodigo = c.SNcodigo and BMmes > 1
		on a.Ddocumento = b.Ddocumento and a.CCTcodigo = b.CCTcodigo and a.Ecodigo = b.Ecodigo
		inner join ##ACVNFsaldo d on a.OCid = d.OCid and a.Ecodigo = d.Ecodigo

	--Obtiene Periodo para Documentos de CxP
	select d.*,c.BMperiodo,c.BMmes,convert(varchar,BMperiodo) + convert(varchar,BMmes) as Concatena
	into ##ACVCxP
	 from #minisifdb#..HDDocumentosCP a 
		inner join #minisifdb#..HEDocumentosCP b
			inner join #minisifdb#..BMovimientosCxP c 
			on b.Ddocumento = c.Ddocumento and b.CPTcodigo = c.CPTcodigo and b.CPTcodigo in ('EC','DC')
			and c.CPTcodigo = c.CPTRcodigo and b.Ecodigo = c.Ecodigo and b.SNcodigo = c.SNcodigo and BMmes > 1
		on a.Ddocumento = b.Ddocumento and a.CPTcodigo = b.CPTcodigo and a.Ecodigo = b.Ecodigo
		inner join ##ACVNFsaldo d on a.OCid = d.OCid and a.Ecodigo = d.Ecodigo
</cfquery>
<cfquery datasource="sifinterfaces">
	insert ACostoVentas (fecharegistro, sessionid,
		  Modulo,Producto,Ecodigo,OriCosto,Mcodigo,Procesado,OCid,
		  OCTid,BMperiodo,BMmes,Concatena)
	(select distinct getdate(),#session.monitoreo.sessionid#,
		Modulo,Producto,Ecodigo,OriCosto,Mcodigo,Procesado,OCid,
		OCTid,BMperiodo,BMmes,convert(int,Concatena)
	from ##ACVCxC a
	where Concatena = (select max(Concatena) from ##ACVCxC where OCid = a.OCid group by OCid)
	and month(getdate()) - BMmes > 1
	union
	select distinct getdate(),#session.monitoreo.sessionid#,
		Modulo,Producto,Ecodigo,OriCosto,Mcodigo,Procesado,OCid,
		OCTid,BMperiodo,BMmes,convert(int,Concatena)
	from ##ACVCxP a
	where Concatena = (select max(Concatena) from ##ACVCxP where OCid = a.OCid group by OCid)
	and month(getdate()) - BMmes > 1)
</cfquery>

<cfquery datasource="sifinterfaces">
	update ACostoVentas
	set OCcontrato = b.OCcontrato
	from ACostoVentas a, #minisifdb#..OCordenComercial b
	where a.Ecodigo = b.Ecodigo
	and a.OCid = b.OCid
</cfquery>
