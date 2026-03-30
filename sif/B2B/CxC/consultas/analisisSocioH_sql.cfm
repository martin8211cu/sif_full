<cfset _LvarFechaHoy  = now()>
<cfset _LvarFechaMes  = createdate(year(now()), month(now()), 1)>
<cfset _LvarFechaIni  = dateadd('m', -12, _LvarFechaHoy)>
<cfset _LvarPerActual = datepart('yyyy', now())>
<cfset _LvarMesActual = datepart('m', now())>
<cfset _LvarPerInicio = datepart('yyyy', _LvarFechaIni)>
<cfset _LvarMesInicio = datepart('m', _LvarFechaIni)>

<cfif not isnumeric(url.SNcodigo)>
	<cf_errorCode	code = "50164" msg = "El codigo de Socio debe ser numérico">
</cfif>

<cfif isdefined("url.Tipo") and url.Tipo EQ 'S'>
	<cfquery name="rs" datasource="#session.DSN#">
		select Cid
		from Conceptos
		where Ecodigo =  #session.Ecodigo#
		  and Ccodigo = '#url.DDcodartcon#'
	</cfquery>
	<cfset LvarCodArtCon = rs.Cid>
<cfelse>
	<cfset LvarCodArtCon = -1>
</cfif>

<cfif isdefined("url.Tipo") and url.Tipo EQ 'A'>
	<cfquery name="rs" datasource="#session.DSN#">
		select Aid
		from Articulos
		where Ecodigo =  #session.Ecodigo#
		  and Acodigo = '#url.DDcodartcon#'
	</cfquery>
	<cfset LvarCodArt = rs.Aid>
<cfelse>
	<cfset LvarCodArt = -1>
</cfif>


<cfquery name="rsSNid" datasource="#session.DSN#">
	select 
		SNid, 
		SNnombre
	from SNegocios
	where Ecodigo  = #session.Ecodigo#
	  and SNcodigo = #url.SNcodigo#
</cfquery>

<cfset LVarNombreDireccion = "">
<cfif isdefined("url.id_direccionFact") and url.id_direccionFact NEQ ''>
	<cfset LVarNombreDireccion = "">
	<cfset Lvarid_direccion = url.id_direccionFact>
	<cfset Lvardireccionurl = Lvardireccionurl & "&id_direccionFact=#url.id_direccionFact#">

	<cfif not isnumeric(url.id_direccionFact)>
		<cf_errorCode	code = "50165" msg = "El codigo de direcció debe ser numérico">
	</cfif>
	<cfquery name="rs" datasource="#session.DSN#">
		select 
			di.SNDcodigo, di.SNnombre
		from SNDirecciones di
		where di.Ecodigo      = #session.Ecodigo#
		and   di.SNcodigo     = #url.SNcodigo#
		and   di.id_direccion = #Lvarid_direccion#
	</cfquery>
	<cfif rs.recordcount GT 0>
		<cfset LVarNombreDireccion = trim(rs.SNnombre) & " (#rs.SNDcodigo#)">
	</cfif>
</cfif>

<cfquery name="rsVentasDirecciont" datasource="#session.DSN#">
	select 
		d.id_direccionFact, 
		d.Mcodigo as Mcodigo, 
		di.SNDcodigo,
		min(di.SNnombre) as Nombre, 
		sum( d.Dtotal * case when tr.CCTtipo = 'D' then 1.00 else -1.00 end ) as TotalMoneda,
		sum( d.Dtotal * case when tr.CCTtipo = 'D' then 1.00 else -1.00 end * coalesce(ht.TCcompra, 1.00) )	as Total
	from HDocumentos d
		inner join CCTransacciones tr
		on tr.CCTcodigo = d.CCTcodigo
		and tr.Ecodigo  = d.Ecodigo
	
		inner join SNDirecciones di
		on  di.Ecodigo      = d.Ecodigo
		and di.SNcodigo     = d.SNcodigo
		and di.id_direccion = d.id_direccionFact 
	
		left outer join Htipocambio ht
		on ht.Ecodigo     = d.Ecodigo
		and ht.Mcodigo    = d.Mcodigo
		and <cf_dbfunction name="now"> between ht.Hfecha and Hfechah
	
	where d.Ecodigo   = #session.Ecodigo#
	  and d.SNcodigo  = #url.SNcodigo#
	  and d.Dfecha   >= #_LvarFechaIni#
	group by d.id_direccionFact, d.Mcodigo, di.SNDcodigo
</cfquery>

<!--- Ventas por Direccion.  Tabla de Ventas por Dirección --->
<cfquery name="rsVentasDireccion" dbtype="query">
	select 
		id_direccionFact, 
		SNDcodigo,
		min(Nombre) as Nombre, 
		sum(Total) as Total
	from rsVentasDirecciont
	group by id_direccionFact, SNDcodigo
</cfquery>

<!--- Saldos en los últimos meses.. Grafico No 1 --->
<cfquery name="rsSaldos" datasource="#session.DSN#">
	select 
		#_LvarPerActual# as Speriodo, 
		#_LvarMesActual# as Smes, 
		#_LvarPerActual * 100 + _LvarMesActual# as PeriodoMes,
		sum( Dsaldo * coalesce(TCcompra, 1.00) * case when tr.CCTtipo = 'D' then 1.00 else -1.00 end ) as Saldo, 
		sum(
			(case when Dvencimiento < #_LvarFechaHoy# then Dsaldo else 0.00	end) 
			* coalesce(TCcompra, 1.00)
			* case when tr.CCTtipo = 'D' then 1.00 else -1.00 end
			) 
		as Morosidad,
		count(1) as Cantidad
	from Documentos d
		inner join CCTransacciones tr
		on  tr.Ecodigo   = d.Ecodigo
		and tr.CCTcodigo = d.CCTcodigo
	
		left outer join Htipocambio ht
		on ht.Ecodigo = d.Ecodigo
		and ht.Mcodigo = d.Mcodigo
		and #_LvarFechaHoy# between ht.Hfecha and Hfechah
		
	where d.Ecodigo = #session.Ecodigo#
	   and d.SNcodigo = #url.SNcodigo#
	<cfif isdefined("url.id_direccionFact")>
	   and d.id_direccionFact = #url.id_direccionFact#
	</cfif>

	union all

	select 
		case when Smes = 1 then Speriodo - 1 else Speriodo end as Speriodo, 
		case when Smes = 1 then 12           else Smes - 1 end as Smes, 
		case when Smes = 1 then Speriodo - 1 else Speriodo end * 100 + case when Smes = 1 then 12 else Smes - 1 end as PeriodoMes, 
		sum(  SIsaldoinicial                              * coalesce(TCcompra, 1.00)) as Saldo, 
		sum( (SIsaldoinicial - SIsinvencer - SIcorriente) * coalesce(TCcompra, 1.00)) as Morosidad,
		count(1) as Cantidad
	from SNSaldosIniciales si

		left outer join Htipocambio ht
		on  ht.Ecodigo = si.Ecodigo
		and ht.Mcodigo = si.Mcodigo
		and #_LvarFechaHoy# between ht.Hfecha and Hfechah

	where si.SNid = #rsSNid.SNid#
	<cfif isdefined("url.id_direccionFact")> and si.id_direccion = #url.id_direccionFact#</cfif>
	  and si.Speriodo >= #_LvarPerInicio#
	  and si.Speriodo * 100 + Smes >= #_LvarPerInicio * 100 + _LvarMesInicio#

	group by Speriodo, Smes
	order by Speriodo, Smes
</cfquery>

<!--- Ventas para la Direccion ( incluye impuesto ) --->
<cfquery name="rsVentas" datasource="#session.DSN#">
		select Periodo, Mes, PeriodoMes, sum(Total) as Total
		from (
			select 
				<cf_dbfunction name="date_part"   args="YY,Dfecha"> as Periodo, 
				<cf_dbfunction name="date_part"   args="MM,Dfecha"> as Mes, 
				<cf_dbfunction name="date_format" args="Dfecha,YYYY-MM"> as PeriodoMes, 
				d.Dtotal * coalesce(TCcompra, 1.00) * case when tr.CCTtipo = 'D' then 1.00 else -1.00 end as Total
			from HDocumentos d
				inner join CCTransacciones tr
				on tr.CCTcodigo = d.CCTcodigo
				and tr.Ecodigo  = d.Ecodigo
		
				left outer join Htipocambio ht
				on ht.Ecodigo = d.Ecodigo
				and ht.Mcodigo = d.Mcodigo
				and #_LvarFechaHoy# between ht.Hfecha and Hfechah
				
			where d.Ecodigo = #Session.Ecodigo#
			  and d.SNcodigo = #url.SNcodigo#
			  <cfif isdefined("url.id_direccionFact")> 
			  and d.id_direccionFact = #url.id_direccionFact#
			  </cfif>
			  and d.Dfecha   >= #_LvarFechaIni#
		  ) x
	group by Periodo, Mes, PeriodoMes
	order by Periodo, Mes
</cfquery>

<!--- Ventas por Servicios --->
<cfquery name="rsVentasServicio" datasource="#session.DSN#">
	select 
		'S' as DDtipo, 
		c.Ccodigo as Concepto, 
		dd.DDcodartcon,
		min(c.Cdescripcion) as Descripcion,
		sum((dd.DDcantidad * dd.DDpreciou - dd.DDdesclinea) * coalesce(TCcompra, 1.00) * case when tr.CCTtipo = 'D' then 1.00 else -1.00 end) as Total
	from HDocumentos d
		inner join HDDocumentos dd
		on dd.HDid = d.HDid

		inner join CCTransacciones tr
		on tr.Ecodigo = d.Ecodigo
		and tr.CCTcodigo = d.CCTcodigo
	
		left outer join Htipocambio ht
		on ht.Ecodigo = d.Ecodigo
		and ht.Mcodigo = d.Mcodigo
		and <cf_dbfunction name="now"> between ht.Hfecha and Hfechah
	
		inner join Conceptos c
		on c.Cid = dd.DDcodartcon
	
	where d.Ecodigo = #session.Ecodigo#
	  and d.SNcodigo = #url.SNcodigo#
	  and d.Dfecha   >= #_LvarFechaIni#
	  and dd.DDtipo = 'S'
	  <cfif isdefined("url.id_direccionFact")> 
	  and d.id_direccionFact = #url.id_direccionFact#
	  </cfif>
	group by dd.DDcodartcon, c.Ccodigo
	order by c.Ccodigo
</cfquery>

<cfif rsVentasServicio.recordcount GT 0 and LvarCodArtCon EQ -1>
	<cfset LvarCodArtCon = rsVentasServicio.DDcodartcon>
</cfif>

<!--- Comparativo por Mes para el Servicio Seleccionado --->
<cfquery name="rsCompServicio" datasource="#session.DSN#">
	select Periodo,Mes,PeriodoMes,DDtipo,min(DDcodartcon) as DDcodartcon ,min(Cdescripcion) as Concepto, sum(Total) as Total
	from (
		select 
			<cf_dbfunction name="date_part"   args="YY,d.Dfecha"> as Periodo, 
			<cf_dbfunction name="date_part"   args="MM,d.Dfecha"> as Mes, 
			<cf_dbfunction name="date_format" args="d.Dfecha,YYYY-MM"> as PeriodoMes, 
			'S' as DDtipo, 
			dd.DDcodartcon,
			c.Cdescripcion,  
			dd.DDcantidad * dd.DDpreciou * coalesce(TCcompra, 1.00) * case when tr.CCTtipo = 'D' then 1.00 else -1.00 end  as Total
		from HDocumentos d
			inner join HDDocumentos dd
			on dd.HDid = d.HDid
	
			inner join CCTransacciones tr
			on tr.Ecodigo = d.Ecodigo
			and tr.CCTcodigo = d.CCTcodigo
	
			inner join Conceptos c
			on c.Cid = dd.DDcodartcon
	
			left outer join Htipocambio ht
			on ht.Ecodigo = d.Ecodigo
			and ht.Mcodigo = d.Mcodigo
			and #_LvarFechaHoy# between ht.Hfecha and Hfechah
	
		where d.Ecodigo  = #session.Ecodigo#
		  and d.SNcodigo = #url.SNcodigo#
		  and d.Dfecha   >= #_LvarFechaIni#
		  <cfif isdefined("url.id_direccionFact")>
		  and d.id_direccionFact = #url.id_direccionFact#
		  </cfif>
		  and dd.DDtipo = 'S'
		  and dd.DDcodartcon = #LvarCodArtCon#
		  ) x
	group by Periodo,Mes,PeriodoMes,DDtipo
	order by Periodo,Mes
</cfquery>

<!--- Ventas por Producto --->
<cfquery name="rsVentasProducto" datasource="#session.dsn#">
	select 
		'A' as DDtipo, 
		dd.DDcodartcon as DDcodart,
		a.Acodigo as Producto,  
		sum((dd.DDcantidad * dd.DDpreciou - dd.DDdesclinea) * coalesce(TCcompra, 1.00) * case when tr.CCTtipo = 'D' then 1.00 else -1.00 end ) as Total
	from HDocumentos d
		inner join HDDocumentos dd
		on dd.HDid = d.HDid

		inner join Articulos a
		on a.Aid = dd.DDcodartcon

		inner join CCTransacciones tr
		on tr.Ecodigo    = d.Ecodigo
		and tr.CCTcodigo = d.CCTcodigo
	
		left outer join Htipocambio ht
		on ht.Ecodigo = d.Ecodigo
		and ht.Mcodigo = d.Mcodigo
		and #_LvarFechaHoy# between ht.Hfecha and Hfechah

	where d.Ecodigo  = #session.Ecodigo#
	  and d.SNcodigo = #url.SNcodigo#
	  and d.Dfecha   >= #_LvarFechaIni#
	  and dd.DDtipo = 'A'
	  <cfif isdefined("url.id_direccionFact")> 
	  and d.id_direccionFact = #url.id_direccionFact#
	  </cfif>

	group by dd.DDcodartcon, a.Acodigo
	order by a.Acodigo
</cfquery>

<cfif rsVentasProducto.recordcount GT 0 and LvarCodArt EQ -1>
	<cfset LvarCodArt = rsVentasProducto.DDcodart>
</cfif>

<!--- Comparativo por Mes para el Producto Seleccionado --->
<cfquery name="rsCompProducto" datasource="#session.DSN#">
	select Periodo,Mes, DDtipo,min(DDcodartcon) as DDcodartcon, min(Adescripcion) as Producto, sum(Total) as Total
	from (
		select 
			<cf_dbfunction name="date_part"   args="YY,d.Dfecha"> as Periodo, 
			<cf_dbfunction name="date_part"   args="MM,d.Dfecha"> as Mes, 
			'A' as DDtipo, 
			dd.DDcodartcon,
			a.Adescripcion,  
			dd.DDcantidad * dd.DDpreciou * coalesce(TCcompra, 1.00) * case when tr.CCTtipo = 'D' then 1.00 else -1.00 end  as Total
		from HDocumentos d
			inner join HDDocumentos dd
			on dd.HDid = d.HDid
		
			inner join Articulos a
			on a.Aid = dd.DDcodartcon
	
			inner join CCTransacciones tr
			on tr.Ecodigo    = d.Ecodigo
			and tr.CCTcodigo = d.CCTcodigo
	
			left outer join Htipocambio ht
			on ht.Ecodigo = d.Ecodigo
			and ht.Mcodigo = d.Mcodigo
			and #_LvarFechaHoy# between ht.Hfecha and Hfechah
	
		where d.Ecodigo  = #session.Ecodigo#
		  and d.SNcodigo = #url.SNcodigo#
		  and d.Dfecha   >= #_LvarFechaIni#
		  <cfif isdefined("url.id_direccionFact")>
		  and d.id_direccionFact = #url.id_direccionFact#
		  </cfif>
		  and dd.DDtipo = 'A'
		  and dd.DDcodartcon = #LvarCodArt#
		  ) x
	group by Periodo,Mes, DDtipo
	order by Periodo,Mes
</cfquery>

