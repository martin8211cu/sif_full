<!------ Horas Extra de Entrada----->
<cfquery name="rsGenerarDetalle" datasource="#Session.DSN#">	
	insert RHDetalleIncidencias (RHCMid, RHPMid, CIid, RHDMhorascalc, RHDMhorasautor, BMUsucodigo, BMfecha, BMfmod)
	select a.RHCMid, a.RHPMid, b.CIid, 0.00, 0.00, 1, getDate(), getDate()
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and a.RHCMmismodia = 1
	<!----Busca si encuentra incidencias para insertar--->
	and convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHIHhfinal, 108)
	and convert(varchar, b.RHIHhinicio, 108) < convert(varchar, c.RHJhoraini, 108)
	and convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, c.RHJhoraini, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = 1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<!---- Chequea que sea un dia de la jornada---->
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	<!---- Chequear que sea una inconsistencia valida---->
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'H' 
	and d.RHCJmomento = 'A' 
	and datediff(mi, a.RHCMhoraentradac, convert(varchar, a.RHCMhoraentradac, 106)+' '+convert(varchar, c.RHJhoraini, 108)) >= d.RHCJperiodot
	<!---- Chequea que no haya un detalle ya insertado--->
	and not exists (
		select 1
		from RHDetalleIncidencias x
		where x.RHPMid = a.RHPMid
		and x.RHCMid = a.RHCMid
		and x.CIid = b.CIid
	)
</cfquery>
<!---- Actualizacion de Horas Extra de Entrada---->
<cfquery name="rsGenerarDetalle" datasource="#Session.DSN#">
	update RHDetalleIncidencias
	set RHDMhorascalc = RHDMhorascalc + (datediff(mi, 
											(case when convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, a.RHCMhoraentradac, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, c.RHJhoraini, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, c.RHJhoraini, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0),
	    RHDMhorasautor = RHDMhorasautor + (datediff(mi, 
											(case when convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, a.RHCMhoraentradac, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, c.RHJhoraini, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, c.RHJhoraini, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0)
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where RHDetalleIncidencias.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and RHDetalleIncidencias.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and RHDetalleIncidencias.RHPMid = a.RHPMid
	and RHDetalleIncidencias.RHCMid = a.RHCMid
	and RHDetalleIncidencias.CIid = b.CIid
	and a.RHCMmismodia = 1
	<!--- Busca si encuentra incidencias para insertar---->
	and convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHIHhfinal, 108)
	and convert(varchar, b.RHIHhinicio, 108) < convert(varchar, c.RHJhoraini, 108)
	and convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, c.RHJhoraini, 108)	
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = 1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<!--- Chequea que sea un dia de la jornada--->
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	<!--- Chequear que sea una inconsistencia valida--->
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'H' 
	and d.RHCJmomento = 'A' 
	and datediff(mi, a.RHCMhoraentradac, convert(varchar, a.RHCMhoraentradac, 106)+' '+convert(varchar, c.RHJhoraini, 108)) >= d.RHCJperiodot
</cfquery>
<!---	-- Horas Extra de Salida---->
<cfquery name="rsGenerarDetalle" datasource="#Session.DSN#">
	insert RHDetalleIncidencias (RHCMid, RHPMid, CIid, RHDMhorascalc, RHDMhorasautor, BMUsucodigo, BMfecha, BMfmod)
	select a.RHCMid, a.RHPMid, b.CIid, 0.00, 0.00, 1, getDate(), getDate()
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and a.RHCMmismodia = 1
	<!--- Busca si encuentra incidencias para insertar--->
	and convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHIHhinicio, 108)
	and convert(varchar, b.RHIHhfinal, 108) > convert(varchar, c.RHJhorafin, 108)
	and convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, c.RHJhorafin, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = 1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<!--- Chequea que sea un dia de la jornada--->
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	<!--- Chequear que sea una inconsistencia valida--->
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'H' 
	and d.RHCJmomento = 'D' 
	and datediff(mi, convert(varchar, a.RHCMhorasalidac, 106)+' '+convert(varchar, c.RHJhorafin, 108), a.RHCMhorasalidac) >= d.RHCJperiodot
	<!--- Chequea que no haya un detalle ya insertado--->
	and not exists (
		select 1
		from RHDetalleIncidencias x
		where x.RHPMid = a.RHPMid
		and x.RHCMid = a.RHCMid
		and x.CIid = b.CIid
	)
</cfquery>
<!----- Actualizacion de Horas Extra de Salida---->
<cfquery name="rsGenerarDetalle" datasource="#Session.DSN#">
	update RHDetalleIncidencias
	set RHDMhorascalc = RHDMhorascalc + (datediff(mi, 
											(case when convert(varchar, c.RHJhorafin, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, c.RHJhorafin, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, a.RHCMhorasalidac, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0),
		RHDMhorasautor = RHDMhorasautor + (datediff(mi, 
											(case when convert(varchar, c.RHJhorafin, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, c.RHJhorafin, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, a.RHCMhorasalidac, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0)
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where RHDetalleIncidencias.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and RHDetalleIncidencias.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and RHDetalleIncidencias.RHPMid = a.RHPMid
	and RHDetalleIncidencias.RHCMid = a.RHCMid
	and RHDetalleIncidencias.CIid = b.CIid
	and a.RHCMmismodia = 1
	<!--- Busca si encuentra incidencias para insertar--->
	and convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHIHhinicio, 108)
	and convert(varchar, b.RHIHhfinal, 108) > convert(varchar, c.RHJhorafin, 108)
	and convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, c.RHJhorafin, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = 1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<!---- Chequea que sea un dia de la jornada--->
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	<!--- Chequear que sea una inconsistencia valida--->
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'H' 
	and d.RHCJmomento = 'D'
	and datediff(mi, convert(varchar, a.RHCMhorasalidac, 106)+' '+convert(varchar, c.RHJhorafin, 108), a.RHCMhorasalidac) >= d.RHCJperiodot
</cfquery>	
<!--- Horas de Rebaja Despues de Entrada--->
<cfquery name="rsGenerarDetalle" datasource="#Session.DSN#">		
	insert RHDetalleIncidencias (RHCMid, RHPMid, CIid, RHDMhorascalc, RHDMhorasautor, BMUsucodigo, BMfecha, BMfmod)
	select a.RHCMid, a.RHPMid, b.CIid, 0.00, 0.00, 1, getDate(), getDate()
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and a.RHCMmismodia = 1
	<!--- Busca si encuentra incidencias para insertar--->
	and convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHIHhinicio, 108)
	and convert(varchar, b.RHIHhfinal, 108) > convert(varchar, c.RHJhoraini, 108)
	and convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, c.RHJhoraini, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = -1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<!--- Chequea que sea un dia de la jornada--->
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	<!--- Chequear que sea una inconsistencia valida--->
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'R' 
	and d.RHCJmomento = 'A' 
	and datediff(mi, convert(varchar, a.RHCMhoraentradac, 106)+' '+convert(varchar, c.RHJhoraini, 108), a.RHCMhoraentradac) >= d.RHCJperiodot
	<!--- Chequea que no haya un detalle ya insertado--->
	and not exists (
		select 1
		from RHDetalleIncidencias x
		where x.RHPMid = a.RHPMid
		and x.RHCMid = a.RHCMid
		and x.CIid = b.CIid
	)
</cfquery>
<!------ Actualizacion de Horas de Rebaja Despues de Entrada---->
<cfquery name="rsGenerarDetalle" datasource="#Session.DSN#">	
	update RHDetalleIncidencias
	set RHDMhorascalc = RHDMhorascalc + (datediff(mi, 
											(case when convert(varchar, c.RHJhoraini, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, c.RHJhoraini, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, a.RHCMhoraentradac, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0),
	    RHDMhorasautor = RHDMhorasautor + (datediff(mi, 
											(case when convert(varchar, c.RHJhoraini, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, c.RHJhoraini, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, a.RHCMhoraentradac, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0)
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where RHDetalleIncidencias.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and RHDetalleIncidencias.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and RHDetalleIncidencias.RHPMid = a.RHPMid
	and RHDetalleIncidencias.RHCMid = a.RHCMid
	and RHDetalleIncidencias.CIid = b.CIid
	and a.RHCMmismodia = 1
	<!---- Busca si encuentra incidencias para insertar--->
	and convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHIHhinicio, 108)
	and convert(varchar, b.RHIHhfinal, 108) > convert(varchar, c.RHJhoraini, 108)
	and convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, c.RHJhoraini, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = -1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<!--- Chequea que sea un dia de la jornada---->
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	<!---- Chequear que sea una inconsistencia valida--->
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'R' 
	and d.RHCJmomento = 'A' 
	and datediff(mi, convert(varchar, a.RHCMhoraentradac, 106)+' '+convert(varchar, c.RHJhoraini, 108), a.RHCMhoraentradac) >= d.RHCJperiodot
</cfquery>
<!----- Horas de Rebaja Antes de Salida---->
<cfquery name="rsGenerarDetalle" datasource="#Session.DSN#">		
	insert RHDetalleIncidencias (RHCMid, RHPMid, CIid, RHDMhorascalc, RHDMhorasautor, BMUsucodigo, BMfecha, BMfmod)
	select a.RHCMid, a.RHPMid, b.CIid, 0.00, 0.00, 1, getDate(), getDate()
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and a.RHCMmismodia = 1
	<!---- Busca si encuentra incidencias para insertar---->
	and convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHIHhfinal, 108)
	and convert(varchar, b.RHIHhinicio, 108) < convert(varchar, c.RHJhorafin, 108)
	and convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, c.RHJhorafin, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = -1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<!---- Chequea que sea un dia de la jornada--->
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	<!---- Chequear que sea una inconsistencia valida---->
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'R' 
	and d.RHCJmomento = 'D' 
	and datediff(mi, a.RHCMhorasalidac, convert(varchar, a.RHCMhorasalidac, 106)+' '+convert(varchar, c.RHJhorafin, 108)) >= d.RHCJperiodot
	<!--- Chequea que no haya un detalle ya insertado--->
	and not exists (
		select 1
		from RHDetalleIncidencias x
		where x.RHPMid = a.RHPMid
		and x.RHCMid = a.RHCMid
		and x.CIid = b.CIid
	)
</cfquery>
<!----- Actualizacion de Horas de Rebaja Antes de Salida--->
<cfquery name="rsGenerarDetalle" datasource="#Session.DSN#">
	update RHDetalleIncidencias
	set RHDMhorascalc = RHDMhorascalc + (datediff(mi, 
											(case when convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, a.RHCMhorasalidac, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, c.RHJhorafin, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, c.RHJhorafin, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0),
		RHDMhorasautor = RHDMhorasautor + (datediff(mi, 
											(case when convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, a.RHCMhorasalidac, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, c.RHJhorafin, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, c.RHJhorafin, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0)
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where RHDetalleIncidencias.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and RHDetalleIncidencias.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and RHDetalleIncidencias.RHPMid = a.RHPMid
	and RHDetalleIncidencias.RHCMid = a.RHCMid
	and RHDetalleIncidencias.CIid = b.CIid
	and a.RHCMmismodia = 1
	<!--- Busca si encuentra incidencias para insertar--->
	and convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHIHhfinal, 108)
	and convert(varchar, b.RHIHhinicio, 108) < convert(varchar, c.RHJhorafin, 108)
	and convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, c.RHJhorafin, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = -1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<!---- Chequea que sea un dia de la jornada---->
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	<!---- Chequear que sea una inconsistencia valida---->
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'R' 
	and d.RHCJmomento = 'D'
	and datediff(mi, a.RHCMhorasalidac, convert(varchar, a.RHCMhorasalidac, 106)+' '+convert(varchar, c.RHJhorafin, 108)) >= d.RHCJperiodot
</cfquery>
<!-------=========================ANTERIOR MIGRADO =============================
<cfquery name="rsGenerarDetalle" datasource="#Session.DSN#">
	-- Horas Extra de Entrada
	insert RHDetalleIncidencias (RHCMid, RHPMid, CIid, RHDMhorascalc, RHDMhorasautor, BMUsucodigo, BMfecha, BMfmod)
	select a.RHCMid, a.RHPMid, b.CIid, 0.00, 0.00, 1, getDate(), getDate()
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and a.RHCMmismodia = 1
	-- Busca si encuentra incidencias para insertar
	and convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHIHhfinal, 108)
	and convert(varchar, b.RHIHhinicio, 108) < convert(varchar, c.RHJhoraini, 108)
	and convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, c.RHJhoraini, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = 1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	-- Chequea que sea un dia de la jornada
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	-- Chequear que sea una inconsistencia valida
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'H' 
	and d.RHCJmomento = 'A' 
	and datediff(mi, a.RHCMhoraentradac, convert(varchar, a.RHCMhoraentradac, 106)+' '+convert(varchar, c.RHJhoraini, 108)) >= d.RHCJperiodot
	-- Chequea que no haya un detalle ya insertado
	and not exists (
		select 1
		from RHDetalleIncidencias x
		where x.RHPMid = a.RHPMid
		and x.RHCMid = a.RHCMid
		and x.CIid = b.CIid
	)
	
	-- Actualizacion de Horas Extra de Entrada
	update RHDetalleIncidencias
	set RHDMhorascalc = RHDMhorascalc + (datediff(mi, 
											(case when convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, a.RHCMhoraentradac, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, c.RHJhoraini, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, c.RHJhoraini, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0),
	    RHDMhorasautor = RHDMhorasautor + (datediff(mi, 
											(case when convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, a.RHCMhoraentradac, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, c.RHJhoraini, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, c.RHJhoraini, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0)
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where RHDetalleIncidencias.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and RHDetalleIncidencias.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and RHDetalleIncidencias.RHPMid = a.RHPMid
	and RHDetalleIncidencias.RHCMid = a.RHCMid
	and RHDetalleIncidencias.CIid = b.CIid
	and a.RHCMmismodia = 1
	-- Busca si encuentra incidencias para insertar
	and convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHIHhfinal, 108)
	and convert(varchar, b.RHIHhinicio, 108) < convert(varchar, c.RHJhoraini, 108)
	and convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, c.RHJhoraini, 108)	
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = 1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
-- Chequea que sea un dia de la jornada
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	-- Chequear que sea una inconsistencia valida
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'H' 
	and d.RHCJmomento = 'A' 
	and datediff(mi, a.RHCMhoraentradac, convert(varchar, a.RHCMhoraentradac, 106)+' '+convert(varchar, c.RHJhoraini, 108)) >= d.RHCJperiodot
	
	-- Horas Extra de Salida
	insert RHDetalleIncidencias (RHCMid, RHPMid, CIid, RHDMhorascalc, RHDMhorasautor, BMUsucodigo, BMfecha, BMfmod)
	select a.RHCMid, a.RHPMid, b.CIid, 0.00, 0.00, 1, getDate(), getDate()
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and a.RHCMmismodia = 1
	-- Busca si encuentra incidencias para insertar
	and convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHIHhinicio, 108)
	and convert(varchar, b.RHIHhfinal, 108) > convert(varchar, c.RHJhorafin, 108)
	and convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, c.RHJhorafin, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = 1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	-- Chequea que sea un dia de la jornada
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	-- Chequear que sea una inconsistencia valida
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'H' 
	and d.RHCJmomento = 'D' 
	and datediff(mi, convert(varchar, a.RHCMhorasalidac, 106)+' '+convert(varchar, c.RHJhorafin, 108), a.RHCMhorasalidac) >= d.RHCJperiodot
	-- Chequea que no haya un detalle ya insertado
	and not exists (
		select 1
		from RHDetalleIncidencias x
		where x.RHPMid = a.RHPMid
		and x.RHCMid = a.RHCMid
		and x.CIid = b.CIid
	)
	
	-- Actualizacion de Horas Extra de Salida
	update RHDetalleIncidencias
	set RHDMhorascalc = RHDMhorascalc + (datediff(mi, 
											(case when convert(varchar, c.RHJhorafin, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, c.RHJhorafin, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, a.RHCMhorasalidac, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0),
		RHDMhorasautor = RHDMhorasautor + (datediff(mi, 
											(case when convert(varchar, c.RHJhorafin, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, c.RHJhorafin, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, a.RHCMhorasalidac, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0)
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where RHDetalleIncidencias.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and RHDetalleIncidencias.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and RHDetalleIncidencias.RHPMid = a.RHPMid
	and RHDetalleIncidencias.RHCMid = a.RHCMid
	and RHDetalleIncidencias.CIid = b.CIid
	and a.RHCMmismodia = 1
	-- Busca si encuentra incidencias para insertar
	and convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHIHhinicio, 108)
	and convert(varchar, b.RHIHhfinal, 108) > convert(varchar, c.RHJhorafin, 108)
	and convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, c.RHJhorafin, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = 1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	-- Chequea que sea un dia de la jornada
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	-- Chequear que sea una inconsistencia valida
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'H' 
	and d.RHCJmomento = 'D'
	and datediff(mi, convert(varchar, a.RHCMhorasalidac, 106)+' '+convert(varchar, c.RHJhorafin, 108), a.RHCMhorasalidac) >= d.RHCJperiodot

	-- Horas de Rebaja Despues de Entrada
	insert RHDetalleIncidencias (RHCMid, RHPMid, CIid, RHDMhorascalc, RHDMhorasautor, BMUsucodigo, BMfecha, BMfmod)
	select a.RHCMid, a.RHPMid, b.CIid, 0.00, 0.00, 1, getDate(), getDate()
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and a.RHCMmismodia = 1
	-- Busca si encuentra incidencias para insertar
	and convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHIHhinicio, 108)
	and convert(varchar, b.RHIHhfinal, 108) > convert(varchar, c.RHJhoraini, 108)
	and convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, c.RHJhoraini, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = -1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	-- Chequea que sea un dia de la jornada
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	-- Chequear que sea una inconsistencia valida
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'R' 
	and d.RHCJmomento = 'A' 
	and datediff(mi, convert(varchar, a.RHCMhoraentradac, 106)+' '+convert(varchar, c.RHJhoraini, 108), a.RHCMhoraentradac) >= d.RHCJperiodot
	-- Chequea que no haya un detalle ya insertado
	and not exists (
		select 1
		from RHDetalleIncidencias x
		where x.RHPMid = a.RHPMid
		and x.RHCMid = a.RHCMid
		and x.CIid = b.CIid
	)

	-- Actualizacion de Horas de Rebaja Despues de Entrada
	update RHDetalleIncidencias
	set RHDMhorascalc = RHDMhorascalc + (datediff(mi, 
											(case when convert(varchar, c.RHJhoraini, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, c.RHJhoraini, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, a.RHCMhoraentradac, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0),
	    RHDMhorasautor = RHDMhorasautor + (datediff(mi, 
											(case when convert(varchar, c.RHJhoraini, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, c.RHJhoraini, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, a.RHCMhoraentradac, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, a.RHCMhoraentradac, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0)
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where RHDetalleIncidencias.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and RHDetalleIncidencias.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and RHDetalleIncidencias.RHPMid = a.RHPMid
	and RHDetalleIncidencias.RHCMid = a.RHCMid
	and RHDetalleIncidencias.CIid = b.CIid
	and a.RHCMmismodia = 1
	-- Busca si encuentra incidencias para insertar
	and convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, b.RHIHhinicio, 108)
	and convert(varchar, b.RHIHhfinal, 108) > convert(varchar, c.RHJhoraini, 108)
	and convert(varchar, a.RHCMhoraentradac, 108) > convert(varchar, c.RHJhoraini, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = -1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	-- Chequea que sea un dia de la jornada
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	-- Chequear que sea una inconsistencia valida
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'R' 
	and d.RHCJmomento = 'A' 
	and datediff(mi, convert(varchar, a.RHCMhoraentradac, 106)+' '+convert(varchar, c.RHJhoraini, 108), a.RHCMhoraentradac) >= d.RHCJperiodot

	-- Horas de Rebaja Antes de Salida
	insert RHDetalleIncidencias (RHCMid, RHPMid, CIid, RHDMhorascalc, RHDMhorasautor, BMUsucodigo, BMfecha, BMfmod)
	select a.RHCMid, a.RHPMid, b.CIid, 0.00, 0.00, 1, getDate(), getDate()
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and a.RHCMmismodia = 1
	-- Busca si encuentra incidencias para insertar
	and convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHIHhfinal, 108)
	and convert(varchar, b.RHIHhinicio, 108) < convert(varchar, c.RHJhorafin, 108)
	and convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, c.RHJhorafin, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = -1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	-- Chequea que sea un dia de la jornada
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	-- Chequear que sea una inconsistencia valida
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'R' 
	and d.RHCJmomento = 'D' 
	and datediff(mi, a.RHCMhorasalidac, convert(varchar, a.RHCMhorasalidac, 106)+' '+convert(varchar, c.RHJhorafin, 108)) >= d.RHCJperiodot
	-- Chequea que no haya un detalle ya insertado
	and not exists (
		select 1
		from RHDetalleIncidencias x
		where x.RHPMid = a.RHPMid
		and x.RHCMid = a.RHCMid
		and x.CIid = b.CIid
	)
	
	-- Actualizacion de Horas de Rebaja Antes de Salida
	update RHDetalleIncidencias
	set RHDMhorascalc = RHDMhorascalc + (datediff(mi, 
											(case when convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, a.RHCMhorasalidac, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, c.RHJhorafin, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, c.RHJhorafin, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0),
		RHDMhorasautor = RHDMhorasautor + (datediff(mi, 
											(case when convert(varchar, a.RHCMhorasalidac, 108) > convert(varchar, b.RHIHhinicio, 108) then convert(varchar, a.RHCMhorasalidac, 108) else convert(varchar, b.RHIHhinicio, 108) end),
											(case when convert(varchar, c.RHJhorafin, 108) < convert(varchar, b.RHIHhfinal, 108) then convert(varchar, c.RHJhorafin, 108) else convert(varchar, b.RHIHhfinal, 108) end)
											)/60.0)
	from RHControlMarcas a, RHIncidenciasHora b, RHJornadas c, RHComportamientoJornada d, CIncidentes e
	where RHDetalleIncidencias.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and RHDetalleIncidencias.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	and RHDetalleIncidencias.RHPMid = a.RHPMid
	and RHDetalleIncidencias.RHCMid = a.RHCMid
	and RHDetalleIncidencias.CIid = b.CIid
	and a.RHCMmismodia = 1
	-- Busca si encuentra incidencias para insertar
	and convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, b.RHIHhfinal, 108)
	and convert(varchar, b.RHIHhinicio, 108) < convert(varchar, c.RHJhorafin, 108)
	and convert(varchar, a.RHCMhorasalidac, 108) < convert(varchar, c.RHJhorafin, 108)
	and a.RHCMfcapturada between b.RHIHfrige and b.RHIHfhasta
	and b.CIid = e.CIid
	and e.CInegativo = -1
	and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	-- Chequea que sea un dia de la jornada
	and substring(convert(varchar, RHJsun)+convert(varchar, RHJmon)+convert(varchar, RHJtue)+convert(varchar, RHJwed)+convert(varchar, RHJthu)+convert(varchar, RHJfri)+convert(varchar, RHJsat), datepart(dw, a.RHCMfcapturada), 1) = '1'
	-- Chequear que sea una inconsistencia valida
	and a.RHJid = c.RHJid
	and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and c.RHJid = d.RHJid
	and d.RHCJcomportamiento = 'R' 
	and d.RHCJmomento = 'D'
	and datediff(mi, a.RHCMhorasalidac, convert(varchar, a.RHCMhorasalidac, 106)+' '+convert(varchar, c.RHJhorafin, 108)) >= d.RHCJperiodot
</cfquery>
---->