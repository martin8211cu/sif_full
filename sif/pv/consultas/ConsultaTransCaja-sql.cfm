<!--- 
	Valores para Combo de Transacciones 
	1: Facturas de Contado
	2: Anticipos
	3: Adelantos
	4: Recibos CxC
	5: Devoluciones
	6: Adelantos Aplicados
	7: Facturas de Crédito
	8: Notas de Crédito
--->

<cf_dbtemp name="CG_ConsTransacciones">
	<cf_dbtempcol name="CodigoMoneda"  		type="char(3)">
	<cf_dbtempcol name="Oficina"			type="char(10)">
	<cf_dbtempcol name="Ofic_descrip"  		type="varchar(60)">
	<cf_dbtempcol name="CodigoCaja"  		type="char(4)">
	<cf_dbtempcol name="TipoTransaccion"  	type="varchar(15)">	
	<cf_dbtempcol name="Transaccion"  		type="varchar(20)">
	<cf_dbtempcol name="Documento"  		type="varchar(15)">
	<cf_dbtempcol name="FechaFactura"  		type="datetime">
	<cf_dbtempcol name="Cliente"  			type="varchar(255)">
	<cf_dbtempcol name="TipoCambio"  		type="money">
	<cf_dbtempcol name="TotalLinea"  		type="money">
</cf_dbtemp>
<cfset TablaConsulta = temp_table>

<cfinclude template="../../Utiles/sifConcat.cfm">

<cfif Len(Trim(url.TipoTrans)) EQ 0 or url.TipoTrans EQ 1>
	<!--- Facturas de Contado --->
	<cfquery name="insFacContado" datasource="#session.DSN#">
		insert into #TablaConsulta#(CodigoMoneda, Oficina, Ofic_descrip, CodigoCaja, TipoTransaccion, Transaccion, Documento, FechaFactura, Cliente, TipoCambio, TotalLinea)
		select 
			G.Miso4217 as CodigoMoneda,
			rtrim(H.Oficodigo) as Oficina, 
			rtrim(H.Odescripcion) as Ofic_descrip,
			rtrim(D.FAM01CODD) as CodigoCaja, 
			'Efectivo' as TipoTransaccion,
			'Facturas Contado' as Transaccion,
			rtrim(C.FAX11DOC) as Documento,
			A.FAX01FEC as FechaFactura,
			case 
				when E.CDCidentificacion = '0' and A.SNcodigo is not null then
					(select ltrim(rtrim(sn.SNnumero)) #_Cat# ' - ' #_Cat# ltrim(rtrim(sn.SNnombre)) from SNegocios sn where sn.SNcodigo = A.SNcodigo and sn.Ecodigo = A.Ecodigo)
				else
					ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) 
			end as Cliente,
			coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
			A.FAX01TOT as TotalLinea
		from FAX001 as A

		inner join FAM001 as D     /*cajas*/
			on  D.FAM01COD = A.FAM01COD
			and D.Ecodigo  = A.Ecodigo

		inner join Monedas as G /*monedas */
			 on G.Mcodigo = A.Mcodigo
			and G.Ecodigo = A.Ecodigo

		inner join Oficinas as H /*Oficinas */
			on  H.Ocodigo = D.Ocodigo
			and H.Ecodigo = D.Ecodigo
	
		left outer join FAX011 as C      /* No. de Documento */
			on  C.FAM01COD = A.FAM01COD
			and C.FAX01NTR = A.FAX01NTR
			and C.Ecodigo  = A.Ecodigo
			and C.FAX11LIN = (select max(FAX11LIN) 
								from FAX011 doc 
							  where doc.FAM01COD = C.FAM01COD 
								and doc.FAX01NTR = C.FAX01NTR 
								and doc.Ecodigo = C.Ecodigo )
		
		left outer join ClientesDetallistasCorp as E /* clientes*/
			on  E.CDCcodigo = A.CDCcodigo
		
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and A.FAX01STA in ('T', 'C')
		and A.FAX01TIP = '1'
		and A.FAX01TPG = 0
	
		<!--- FILTRO DE CAJAS --->
		<cfif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1)) and isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD between <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		<cfelseif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1))>
			and D.FAM01CODD >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#">
		<cfelseif isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		</cfif>
	
		<!--- FILTRO DE OFICINA --->
		<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		</cfif>
		
		<!--- FILTRO DE RANGO DE FECHAS --->
		<cfif isdefined("url.Fdesde") and Len(Trim(url.Fdesde)) and isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		<cfelseif isdefined("url.Fdesde") and Len(Trim(url.Fdesde))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fdesde)))#">
		<cfelseif isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		</cfif>
		
		order by G.Miso4217, H.Oficodigo, D.FAM01CODD, A.FAX01TIP, C.FAX11DOC
	</cfquery>
</cfif>

<cfif Len(Trim(url.TipoTrans)) EQ 0 or url.TipoTrans EQ 3>
	<!--- Adelantos --->
	<cfquery name="insFacContado" datasource="#session.DSN#">
		insert into #TablaConsulta#(CodigoMoneda, Oficina, Ofic_descrip, CodigoCaja, TipoTransaccion, Transaccion, Documento, FechaFactura, Cliente, TipoCambio, TotalLinea)
		select 
			G.Miso4217 as CodigoMoneda,
			rtrim(H.Oficodigo) as Oficina, 
			rtrim(H.Odescripcion) as Ofic_descrip,
			rtrim(D.FAM01CODD) as CodigoCaja, 
			'Efectivo' as TipoTransaccion,
			'Recibos de Adelantos' as Transaccion,
			rtrim(C.FAX11DOC) as Documento,
			A.FAX01FEC as FechaFactura,
			case 
				when E.CDCidentificacion = '0' and A.SNcodigo is not null then
					(select ltrim(rtrim(sn.SNnumero)) #_Cat# ' - ' #_Cat# ltrim(rtrim(sn.SNnombre)) from SNegocios sn where sn.SNcodigo = A.SNcodigo and sn.Ecodigo = A.Ecodigo)
				else
					ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) 
			end as Cliente,
			coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
			A.FAX01TOT as TotalLinea
		from FAX001 as A
	
		inner join FAM001 as D     /*cajas*/
			on  D.FAM01COD = A.FAM01COD
			and D.Ecodigo  = A.Ecodigo

		inner join Monedas as G /*monedas */
			 on G.Mcodigo = A.Mcodigo
			and G.Ecodigo = A.Ecodigo

		inner join Oficinas as H /*Oficinas */
			on  H.Ocodigo = D.Ocodigo
			and H.Ecodigo = D.Ecodigo
	
		left outer join FAX011 as C      /* No. de Documento */
			on  C.FAM01COD = A.FAM01COD
			and C.FAX01NTR = A.FAX01NTR
			and C.Ecodigo  = A.Ecodigo
			and C.FAX11LIN = (select max(FAX11LIN) 
								from FAX011 doc 
							  where doc.FAM01COD = C.FAM01COD 
								and doc.FAX01NTR = C.FAX01NTR 
								and doc.Ecodigo = C.Ecodigo )
		
		left outer join ClientesDetallistasCorp as E /* clientes*/
			on  E.CDCcodigo = A.CDCcodigo
		
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and A.FAX01STA in ('T', 'C')
		and A.FAX01TIP = '9'
		and A.FAX01TPG = 0
	
		<!--- FILTRO DE CAJAS --->
		<cfif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1)) and isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD between <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		<cfelseif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1))>
			and D.FAM01CODD >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#">
		<cfelseif isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		</cfif>
	
		<!--- FILTRO DE OFICINA --->
		<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		</cfif>
		
		<!--- FILTRO DE RANGO DE FECHAS --->
		<cfif isdefined("url.Fdesde") and Len(Trim(url.Fdesde)) and isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		<cfelseif isdefined("url.Fdesde") and Len(Trim(url.Fdesde))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fdesde)))#">
		<cfelseif isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		</cfif>
		
		order by G.Miso4217, H.Oficodigo, D.FAM01CODD, A.FAX01TIP, C.FAX11DOC
	</cfquery>
</cfif>

<cfif Len(Trim(url.TipoTrans)) EQ 0 or url.TipoTrans EQ 4>
	<!--- Recibos CxC --->
	<cfquery name="insFacContado" datasource="#session.DSN#">
		insert into #TablaConsulta#(CodigoMoneda, Oficina, Ofic_descrip, CodigoCaja, TipoTransaccion, Transaccion, Documento, FechaFactura, Cliente, TipoCambio, TotalLinea)
		select 
			G.Miso4217 as CodigoMoneda,
			rtrim(H.Oficodigo) as Oficina, 
			rtrim(H.Odescripcion) as Ofic_descrip,
			rtrim(D.FAM01CODD) as CodigoCaja, 
			'Efectivo' as TipoTransaccion,
			'Recibos CxC' as Transaccion,
			rtrim(C.FAX11DOC) as Documento,
			A.FAX01FEC as FechaFactura,
			case 
				when E.CDCidentificacion = '0' and A.SNcodigo is not null then
					(select ltrim(rtrim(sn.SNnumero)) #_Cat# ' - ' #_Cat# ltrim(rtrim(sn.SNnombre)) from SNegocios sn where sn.SNcodigo = A.SNcodigo and sn.Ecodigo = A.Ecodigo)
				else
					ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) 
			end as Cliente,
			coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
			A.FAX01TOT as TotalLinea
		from FAX001 as A
	
		inner join FAM001 as D     /*cajas*/
			on  D.FAM01COD = A.FAM01COD
			and D.Ecodigo  = A.Ecodigo

		inner join Monedas as G /*monedas */
			 on G.Mcodigo = A.Mcodigo
			and G.Ecodigo = A.Ecodigo

		inner join Oficinas as H /*Oficinas */
			on  H.Ocodigo = D.Ocodigo
			and H.Ecodigo = D.Ecodigo
	
		left outer join FAX011 as C      /* No. de Documento */
			on  C.FAM01COD = A.FAM01COD
			and C.FAX01NTR = A.FAX01NTR
			and C.Ecodigo  = A.Ecodigo
			and C.FAX11LIN = (select max(FAX11LIN) 
								from FAX011 doc 
							  where doc.FAM01COD = C.FAM01COD 
								and doc.FAX01NTR = C.FAX01NTR 
								and doc.Ecodigo = C.Ecodigo )
		
		left outer join ClientesDetallistasCorp as E /* clientes*/
			on  E.CDCcodigo = A.CDCcodigo
		
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and A.FAX01STA in ('T', 'C')
		and A.FAX01TIP = '2'
	
		<!--- FILTRO DE CAJAS --->
		<cfif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1)) and isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD between <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		<cfelseif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1))>
			and D.FAM01CODD >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#">
		<cfelseif isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		</cfif>
	
		<!--- FILTRO DE OFICINA --->
		<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		</cfif>
		
		<!--- FILTRO DE RANGO DE FECHAS --->
		<cfif isdefined("url.Fdesde") and Len(Trim(url.Fdesde)) and isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		<cfelseif isdefined("url.Fdesde") and Len(Trim(url.Fdesde))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fdesde)))#">
		<cfelseif isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		</cfif>
		
		order by G.Miso4217, H.Oficodigo, D.FAM01CODD, A.FAX01TIP, C.FAX11DOC
	</cfquery>
	
	<!--- Recibos de Documentos de CxC --->
	<cfquery name="insFacContado" datasource="#session.DSN#">
		insert into #TablaConsulta#(CodigoMoneda, Oficina, Ofic_descrip, CodigoCaja, TipoTransaccion, Transaccion, Documento, FechaFactura, Cliente, TipoCambio, TotalLinea)
		select 
			G.Miso4217 as CodigoMoneda,
			rtrim(H.Oficodigo) as Oficina, 
			rtrim(H.Odescripcion) as Ofic_descrip,
			rtrim(D.FAM01CODD) as CodigoCaja, 
			'Efectivo' as TipoTransaccion,
			'Recibos CxC' as Transaccion,
			rtrim(C.FAX11DOC) as Documento,
			A.FAX01FEC as FechaFactura,
			case 
				when E.CDCidentificacion = '0' and A.SNcodigo is not null then
					(select ltrim(rtrim(sn.SNnumero)) #_Cat# ' - ' #_Cat# ltrim(rtrim(sn.SNnombre)) from SNegocios sn where sn.SNcodigo = A.SNcodigo and sn.Ecodigo = A.Ecodigo)
				else
					ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) 
			end as Cliente,
			coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
			I.FAX07DMON as TotalLinea
		from FAX001 as A
	
		inner join FAM001 as D     /*cajas*/
			on  D.FAM01COD = A.FAM01COD
			and D.Ecodigo  = A.Ecodigo

		inner join Monedas as G /*monedas */
			 on G.Mcodigo = A.Mcodigo
			and G.Ecodigo = A.Ecodigo

		inner join Oficinas as H /*Oficinas */
			on  H.Ocodigo = D.Ocodigo
			and H.Ecodigo = D.Ecodigo
	
		inner join FAX007D as I 
			on I.FAX01NTR = A.FAX01NTR
			and I.FAM01COD = A.FAM01COD
			and I.Ecodigo =  A.Ecodigo
		
		left outer join FAX011 as C      /* No. de Documento */
			on  C.FAM01COD = A.FAM01COD
			and C.FAX01NTR = A.FAX01NTR
			and C.Ecodigo  = A.Ecodigo
			and C.FAX11LIN = (select max(FAX11LIN) 
								from FAX011 doc 
							  where doc.FAM01COD = C.FAM01COD 
								and doc.FAX01NTR = C.FAX01NTR 
								and doc.Ecodigo = C.Ecodigo )
		
		left outer join ClientesDetallistasCorp as E /* clientes*/
			on  E.CDCcodigo = A.CDCcodigo
		
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and A.FAX01STA in ('T', 'C')
		and A.FAX01TIP = 'D'
	
		<!--- FILTRO DE CAJAS --->
		<cfif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1)) and isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD between <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		<cfelseif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1))>
			and D.FAM01CODD >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#">
		<cfelseif isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		</cfif>
	
		<!--- FILTRO DE OFICINA --->
		<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		</cfif>
		
		<!--- FILTRO DE RANGO DE FECHAS --->
		<cfif isdefined("url.Fdesde") and Len(Trim(url.Fdesde)) and isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		<cfelseif isdefined("url.Fdesde") and Len(Trim(url.Fdesde))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fdesde)))#">
		<cfelseif isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		</cfif>
		
		order by G.Miso4217, H.Oficodigo, D.FAM01CODD, A.FAX01TIP, C.FAX11DOC
	</cfquery>
</cfif>

<cfif Len(Trim(url.TipoTrans)) EQ 0 or url.TipoTrans EQ 5>
	<!--- Devoluciones --->
	<cfquery name="insFacContado" datasource="#session.DSN#">
		insert into #TablaConsulta#(CodigoMoneda, Oficina, Ofic_descrip, CodigoCaja, TipoTransaccion, Transaccion, Documento, FechaFactura, Cliente, TipoCambio, TotalLinea)
		select 
			G.Miso4217 as CodigoMoneda,
			rtrim(H.Oficodigo) as Oficina, 
			rtrim(H.Odescripcion) as Ofic_descrip,
			rtrim(D.FAM01CODD) as CodigoCaja, 
			'Efectivo' as TipoTransaccion,
			'Devoluciones de Facturas' as Transaccion,
			rtrim(C.FAX11DOC) as Documento,
			A.FAX01FEC as FechaFactura,
			case 
				when E.CDCidentificacion = '0' and A.SNcodigo is not null then
					(select ltrim(rtrim(sn.SNnumero)) #_Cat# ' - ' #_Cat# ltrim(rtrim(sn.SNnombre)) from SNegocios sn where sn.SNcodigo = A.SNcodigo and sn.Ecodigo = A.Ecodigo)
				else
					ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) 
			end as Cliente,
			coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
			A.FAX01TOT as TotalLinea
		from FAX001 as A
	
		inner join FAM001 as D     /*cajas*/
			on  D.FAM01COD = A.FAM01COD
			and D.Ecodigo  = A.Ecodigo

		inner join Monedas as G /*monedas */
			 on G.Mcodigo = A.Mcodigo
			and G.Ecodigo = A.Ecodigo

		inner join Oficinas as H /*Oficinas */
			on  H.Ocodigo = D.Ocodigo
			and H.Ecodigo = D.Ecodigo
	
		left outer join FAX011 as C      /* No. de Documento */
			on  C.FAM01COD = A.FAM01COD
			and C.FAX01NTR = A.FAX01NTR
			and C.Ecodigo  = A.Ecodigo
			and C.FAX11LIN = (select max(FAX11LIN) 
								from FAX011 doc 
							  where doc.FAM01COD = C.FAM01COD 
								and doc.FAX01NTR = C.FAX01NTR 
								and doc.Ecodigo = C.Ecodigo )
		
		left outer join ClientesDetallistasCorp as E /* clientes*/
			on  E.CDCcodigo = A.CDCcodigo
		
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and A.FAX01STA in ('T', 'C')
		and A.FAX01TIP = '4'
		and A.FAX01TPG = 0
	
		<!--- FILTRO DE CAJAS --->
		<cfif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1)) and isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD between <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		<cfelseif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1))>
			and D.FAM01CODD >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#">
		<cfelseif isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		</cfif>
	
		<!--- FILTRO DE OFICINA --->
		<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		</cfif>
		
		<!--- FILTRO DE RANGO DE FECHAS --->
		<cfif isdefined("url.Fdesde") and Len(Trim(url.Fdesde)) and isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		<cfelseif isdefined("url.Fdesde") and Len(Trim(url.Fdesde))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fdesde)))#">
		<cfelseif isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		</cfif>
		
		order by G.Miso4217, H.Oficodigo, D.FAM01CODD, A.FAX01TIP, C.FAX11DOC
	</cfquery>
</cfif>

<cfif Len(Trim(url.TipoTrans)) EQ 0 or url.TipoTrans EQ 6>
	<!--- Adelantos Aplicados --->
	<cfquery name="insFacContado" datasource="#session.DSN#">
		insert into #TablaConsulta#(CodigoMoneda, Oficina, Ofic_descrip, CodigoCaja, TipoTransaccion, Transaccion, Documento, FechaFactura, Cliente, TipoCambio, TotalLinea)
		select 
			G.Miso4217 as CodigoMoneda,
			rtrim(H.Oficodigo) as Oficina, 
			rtrim(H.Odescripcion) as Ofic_descrip,
			rtrim(D.FAM01CODD) as CodigoCaja, 
			'Efectivo' as TipoTransaccion,
			'Adelantos Aplicados' as Transaccion,
			rtrim(C.FAX11DOC) as Documento,
			A.FAX01FEC as FechaFactura,
			case 
				when E.CDCidentificacion = '0' and A.SNcodigo is not null then
					(select ltrim(rtrim(sn.SNnumero)) #_Cat# ' - ' #_Cat# ltrim(rtrim(sn.SNnombre)) from SNegocios sn where sn.SNcodigo = A.SNcodigo and sn.Ecodigo = A.Ecodigo)
				else
					ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) 
			end as Cliente,
			coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
			I.FAX12TOTMF as TotalLinea
		from FAX001 as A
	
		inner join FAM001 as D     /*cajas*/
			on  D.FAM01COD = A.FAM01COD
			and D.Ecodigo  = A.Ecodigo

		inner join Monedas as G /*monedas */
			 on G.Mcodigo = A.Mcodigo
			and G.Ecodigo = A.Ecodigo

		inner join Oficinas as H /*Oficinas */
			on  H.Ocodigo = D.Ocodigo
			and H.Ecodigo = D.Ecodigo
	
		inner join FAX012 as I 
			on I.FAX01NTR = A.FAX01NTR
			and I.FAM01COD = A.FAM01COD
			and I.Ecodigo  = A.Ecodigo
			and I.FAX12TIP = 'AD'
		
		left outer join FAX011 as C      /* No. de Documento */
			on  C.FAM01COD = A.FAM01COD
			and C.FAX01NTR = A.FAX01NTR
			and C.Ecodigo  = A.Ecodigo
			and C.FAX11LIN = (select max(FAX11LIN) 
								from FAX011 doc 
							  where doc.FAM01COD = C.FAM01COD 
								and doc.FAX01NTR = C.FAX01NTR 
								and doc.Ecodigo = C.Ecodigo )
		
		left outer join ClientesDetallistasCorp as E /* clientes*/
			on  E.CDCcodigo = A.CDCcodigo
		
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and A.FAX01STA in ('T', 'C')
	
		<!--- FILTRO DE CAJAS --->
		<cfif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1)) and isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD between <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		<cfelseif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1))>
			and D.FAM01CODD >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#">
		<cfelseif isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		</cfif>
	
		<!--- FILTRO DE OFICINA --->
		<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		</cfif>
		
		<!--- FILTRO DE RANGO DE FECHAS --->
		<cfif isdefined("url.Fdesde") and Len(Trim(url.Fdesde)) and isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		<cfelseif isdefined("url.Fdesde") and Len(Trim(url.Fdesde))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fdesde)))#">
		<cfelseif isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		</cfif>
		
		order by G.Miso4217, H.Oficodigo, D.FAM01CODD, A.FAX01TIP, C.FAX11DOC
	</cfquery>
</cfif>
	
<cfif Len(Trim(url.TipoTrans)) EQ 0 or url.TipoTrans EQ 7>
	<!--- Facturas de Credito --->
	<cfquery name="insFacContado" datasource="#session.DSN#">
		insert into #TablaConsulta#(CodigoMoneda, Oficina, Ofic_descrip, CodigoCaja, TipoTransaccion, Transaccion, Documento, FechaFactura, Cliente, TipoCambio, TotalLinea)
		select 
			G.Miso4217 as CodigoMoneda,
			rtrim(H.Oficodigo) as Oficina, 
			rtrim(H.Odescripcion) as Ofic_descrip,
			rtrim(D.FAM01CODD) as CodigoCaja, 
			'Crédito' as TipoTransaccion,
			'Facturas Crédito' as Transaccion,
			rtrim(C.FAX11DOC) as Documento,
			A.FAX01FEC as FechaFactura,
			case 
				when E.CDCidentificacion = '0' and A.SNcodigo is not null then
					(select ltrim(rtrim(sn.SNnumero)) #_Cat# ' - ' #_Cat# ltrim(rtrim(sn.SNnombre)) from SNegocios sn where sn.SNcodigo = A.SNcodigo and sn.Ecodigo = A.Ecodigo)
				else
					ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) 
			end as Cliente,
			coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
			A.FAX01TOT as TotalLinea
		from FAX001 as A
	
		inner join FAM001 as D     /*cajas*/
			on  D.FAM01COD = A.FAM01COD
			and D.Ecodigo  = A.Ecodigo

		inner join Monedas as G /*monedas */
			 on G.Mcodigo = A.Mcodigo
			and G.Ecodigo = A.Ecodigo

		inner join Oficinas as H /*Oficinas */
			on  H.Ocodigo = D.Ocodigo
			and H.Ecodigo = D.Ecodigo
	
		left outer join FAX011 as C      /* No. de Documento */
			on  C.FAM01COD = A.FAM01COD
			and C.FAX01NTR = A.FAX01NTR
			and C.Ecodigo  = A.Ecodigo
			and C.FAX11LIN = (select max(FAX11LIN) 
								from FAX011 doc 
							  where doc.FAM01COD = C.FAM01COD 
								and doc.FAX01NTR = C.FAX01NTR 
								and doc.Ecodigo = C.Ecodigo )
		
		left outer join ClientesDetallistasCorp as E /* clientes*/
			on  E.CDCcodigo = A.CDCcodigo
		
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and A.FAX01STA in ('T', 'C')
		and A.FAX01TIP = '1'
		and A.FAX01TPG = 1
	
		<!--- FILTRO DE CAJAS --->
		<cfif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1)) and isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD between <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		<cfelseif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1))>
			and D.FAM01CODD >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#">
		<cfelseif isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		</cfif>
	
		<!--- FILTRO DE OFICINA --->
		<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		</cfif>
		
		<!--- FILTRO DE RANGO DE FECHAS --->
		<cfif isdefined("url.Fdesde") and Len(Trim(url.Fdesde)) and isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		<cfelseif isdefined("url.Fdesde") and Len(Trim(url.Fdesde))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fdesde)))#">
		<cfelseif isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		</cfif>
		
		order by G.Miso4217, H.Oficodigo, D.FAM01CODD, A.FAX01TIP, C.FAX11DOC
	</cfquery>
</cfif>

<cfif Len(Trim(url.TipoTrans)) EQ 0 or url.TipoTrans EQ 8>
	<!--- Notas de Crédito --->
	<cfquery name="insFacContado" datasource="#session.DSN#">
		insert into #TablaConsulta#(CodigoMoneda, Oficina, Ofic_descrip, CodigoCaja, TipoTransaccion, Transaccion, Documento, FechaFactura, Cliente, TipoCambio, TotalLinea)
		select 
			G.Miso4217 as CodigoMoneda,
			rtrim(H.Oficodigo) as Oficina, 
			rtrim(H.Odescripcion) as Ofic_descrip,
			rtrim(D.FAM01CODD) as CodigoCaja, 
			'Crédito' as TipoTransaccion,
			'Notas de Crédito' as Transaccion,
			rtrim(C.FAX11DOC) as Documento,
			A.FAX01FEC as FechaFactura,
			case 
				when E.CDCidentificacion = '0' and A.SNcodigo is not null then
					(select ltrim(rtrim(sn.SNnumero)) #_Cat# ' - ' #_Cat# ltrim(rtrim(sn.SNnombre)) from SNegocios sn where sn.SNcodigo = A.SNcodigo and sn.Ecodigo = A.Ecodigo)
				else
					ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) 
			end as Cliente,
			coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
			A.FAX01TOT as TotalLinea
		from FAX001 as A
	
		inner join FAM001 as D     /*cajas*/
			on  D.FAM01COD = A.FAM01COD
			and D.Ecodigo  = A.Ecodigo

		inner join Monedas as G /*monedas */
			 on G.Mcodigo = A.Mcodigo
			and G.Ecodigo = A.Ecodigo

		inner join Oficinas as H /*Oficinas */
			on  H.Ocodigo = D.Ocodigo
			and H.Ecodigo = D.Ecodigo
	
		left outer join FAX011 as C      /* No. de Documento */
			on  C.FAM01COD = A.FAM01COD
			and C.FAX01NTR = A.FAX01NTR
			and C.Ecodigo  = A.Ecodigo
			and C.FAX11LIN = (select max(FAX11LIN) 
								from FAX011 doc 
							  where doc.FAM01COD = C.FAM01COD 
								and doc.FAX01NTR = C.FAX01NTR 
								and doc.Ecodigo = C.Ecodigo )
		
		left outer join ClientesDetallistasCorp as E /* clientes*/
			on  E.CDCcodigo = A.CDCcodigo
		
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and A.FAX01STA in ('T', 'C')
		and A.FAX01TIP = '4'
		and A.FAX01TPG = 1
	
		<!--- FILTRO DE CAJAS --->
		<cfif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1)) and isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD between <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		<cfelseif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1))>
			and D.FAM01CODD >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#">
		<cfelseif isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		</cfif>
	
		<!--- FILTRO DE OFICINA --->
		<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		</cfif>
		
		<!--- FILTRO DE RANGO DE FECHAS --->
		<cfif isdefined("url.Fdesde") and Len(Trim(url.Fdesde)) and isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		<cfelseif isdefined("url.Fdesde") and Len(Trim(url.Fdesde))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fdesde)))#">
		<cfelseif isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		</cfif>
		
		order by G.Miso4217, H.Oficodigo, D.FAM01CODD, A.FAX01TIP, C.FAX11DOC
	</cfquery>
</cfif>

<!--- ********************************** --->
<cfif Len(Trim(url.TipoTrans)) EQ 0 or url.TipoTrans EQ 9>
	<!--- Otros Recibos --->
	<cfquery name="insFacContado" datasource="#session.DSN#">
		insert into #TablaConsulta#(CodigoMoneda, Oficina, Ofic_descrip, CodigoCaja, TipoTransaccion, Transaccion, Documento, FechaFactura, Cliente, TipoCambio, TotalLinea)
		select 
			G.Miso4217 as CodigoMoneda,
			rtrim(H.Oficodigo) as Oficina, 
			rtrim(H.Odescripcion) as Ofic_descrip,
			rtrim(D.FAM01CODD) as CodigoCaja, 
			'Efectivo' as TipoTransaccion,
			'Otros Recibos' as Transaccion,
			rtrim(C.FAX11DOC) as Documento,
			A.FAX01FEC as FechaFactura,
			case 
				when E.CDCidentificacion = '0' and A.SNcodigo is not null then
					(select ltrim(rtrim(sn.SNnumero)) #_Cat# ' - ' #_Cat# ltrim(rtrim(sn.SNnombre)) from SNegocios sn where sn.SNcodigo = A.SNcodigo and sn.Ecodigo = A.Ecodigo)
				else
					ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) 
			end as Cliente,
			coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
			A.FAX01TOT as TotalLinea
		from FAX001 as A
	
		inner join FAM001 as D     /*cajas*/
			on  D.FAM01COD = A.FAM01COD
			and D.Ecodigo  = A.Ecodigo

		inner join Monedas as G /*monedas */
			 on G.Mcodigo = A.Mcodigo
			and G.Ecodigo = A.Ecodigo

		inner join Oficinas as H /*Oficinas */
			on  H.Ocodigo = D.Ocodigo
			and H.Ecodigo = D.Ecodigo
	
		left outer join FAX011 as C      /* No. de Documento */
			on  C.FAM01COD = A.FAM01COD
			and C.FAX01NTR = A.FAX01NTR
			and C.Ecodigo  = A.Ecodigo
			and C.FAX11LIN = (select max(FAX11LIN) 
								from FAX011 doc 
							  where doc.FAM01COD = C.FAM01COD 
								and doc.FAX01NTR = C.FAX01NTR 
								and doc.Ecodigo = C.Ecodigo )
		
		left outer join ClientesDetallistasCorp as E /* clientes*/
			on  E.CDCcodigo = A.CDCcodigo
		
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and A.FAX01STA in ('T', 'C')
		and A.FAX01TIP = '3'
		and A.FAX01TPG = 0
	
		<!--- FILTRO DE CAJAS --->
		<cfif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1)) and isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD between <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		<cfelseif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1))>
			and D.FAM01CODD >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#">
		<cfelseif isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		</cfif>
	
		<!--- FILTRO DE OFICINA --->
		<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		</cfif>
		
		<!--- FILTRO DE RANGO DE FECHAS --->
		<cfif isdefined("url.Fdesde") and Len(Trim(url.Fdesde)) and isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		<cfelseif isdefined("url.Fdesde") and Len(Trim(url.Fdesde))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fdesde)))#">
		<cfelseif isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		</cfif>
		
		order by G.Miso4217, H.Oficodigo, D.FAM01CODD, A.FAX01TIP, C.FAX11DOC
	</cfquery>
</cfif>
<!--- ******************************************* --->

<!--- ********************************** --->
<cfif Len(Trim(url.TipoTrans)) EQ 0 or url.TipoTrans EQ 10>
	<!--- Devoluciones de Recibos --->
	<cfquery name="insFacContado" datasource="#session.DSN#">
		insert into #TablaConsulta#(CodigoMoneda, Oficina, Ofic_descrip, CodigoCaja, TipoTransaccion, Transaccion, Documento, FechaFactura, Cliente, TipoCambio, TotalLinea)
		select 
			G.Miso4217 as CodigoMoneda,
			rtrim(H.Oficodigo) as Oficina, 
			rtrim(H.Odescripcion) as Ofic_descrip,
			rtrim(D.FAM01CODD) as CodigoCaja, 
			'Efectivo' as TipoTransaccion,
			'Devoluciones de Recibos' as Transaccion,
			rtrim(C.FAX11DOC) as Documento,
			A.FAX01FEC as FechaFactura,
			case 
				when E.CDCidentificacion = '0' and A.SNcodigo is not null then
					(select ltrim(rtrim(sn.SNnumero)) #_Cat# ' - ' #_Cat# ltrim(rtrim(sn.SNnombre)) from SNegocios sn where sn.SNcodigo = A.SNcodigo and sn.Ecodigo = A.Ecodigo)
				else
					ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) 
			end as Cliente,
			coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
			A.FAX01TOT as TotalLinea
		from FAX001 as A
	
		inner join FAM001 as D     /*cajas*/
			on  D.FAM01COD = A.FAM01COD
			and D.Ecodigo  = A.Ecodigo

		inner join Monedas as G /*monedas */
			 on G.Mcodigo = A.Mcodigo
			and G.Ecodigo = A.Ecodigo

		inner join Oficinas as H /*Oficinas */
			on  H.Ocodigo = D.Ocodigo
			and H.Ecodigo = D.Ecodigo
	
		left outer join FAX011 as C      /* No. de Documento */
			on  C.FAM01COD = A.FAM01COD
			and C.FAX01NTR = A.FAX01NTR
			and C.Ecodigo  = A.Ecodigo
			and C.FAX11LIN = (select max(FAX11LIN) 
								from FAX011 doc 
							  where doc.FAM01COD = C.FAM01COD 
								and doc.FAX01NTR = C.FAX01NTR 
								and doc.Ecodigo = C.Ecodigo )
		
		left outer join ClientesDetallistasCorp as E /* clientes*/
			on  E.CDCcodigo = A.CDCcodigo
		
		where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and A.FAX01STA in ('T', 'C')
		and A.FAX01TIP = '0'
		and A.FAX01TPG = 0
	
		<!--- FILTRO DE CAJAS --->
		<cfif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1)) and isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD between <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		<cfelseif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1))>
			and D.FAM01CODD >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD1#">
		<cfelseif isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
			and D.FAM01CODD <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD2#">
		</cfif>
	
		<!--- FILTRO DE OFICINA --->
		<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		</cfif>
		
		<!--- FILTRO DE RANGO DE FECHAS --->
		<cfif isdefined("url.Fdesde") and Len(Trim(url.Fdesde)) and isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		<cfelseif isdefined("url.Fdesde") and Len(Trim(url.Fdesde))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fdesde)))#">
		<cfelseif isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
			and A.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(url.Fhasta)))#">
		</cfif>
		
		order by G.Miso4217, H.Oficodigo, D.FAM01CODD, A.FAX01TIP, C.FAX11DOC
	</cfquery>
</cfif>

<cfquery name="rsReporte" datasource="#Session.DSN#" maxrows="3001">
	select CodigoMoneda, Oficina, Ofic_descrip, CodigoCaja, TipoTransaccion, Transaccion, Documento, FechaFactura, Cliente, TipoCambio, TotalLinea,
		   Oficina #_Cat# ' ' #_Cat# CodigoMoneda as OficMoneda,
		   CodigoCaja #_Cat# ' ' #_Cat# TipoTransaccion as CajaTrans
	from #TablaConsulta#
	order by CodigoMoneda, Oficina, Ofic_descrip, CodigoCaja, TipoTransaccion desc, Transaccion, Documento
</cfquery>

<!--- DETERMINA EL TIPO DE FORMATO EN QUE SE REALIZARA EL REPORTE --->
<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
	<cfset formatos = "flashpaper">
<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
	<cfset formatos = "pdf">
</cfif>

<cfset RangoCajas = "TODAS LAS CAJAS">
<cfif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1)) and isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
	<cfset RangoCajas = "DE " & url.FAM01CODD1 & " A " & url.FAM01CODD2>
<cfelseif isdefined("url.FAM01CODD1") and Len(Trim(url.FAM01CODD1))>
	<cfset RangoCajas = "DE " & url.FAM01CODD1>
<cfelseif isdefined("url.FAM01CODD2") and Len(Trim(url.FAM01CODD2))>
	<cfset RangoCajas = "HASTA " & url.FAM01CODD2>
</cfif>
<cfset RangoFechas = "">
<cfif isdefined("url.Fdesde") and Len(Trim(url.Fdesde)) and isdefined("url.Fhasta") and Len(Trim(url.Fhasta))>
	<cfset RangoFechas = "DEL " & url.Fdesde & " AL " & url.Fhasta>
</cfif>

<cfif rsReporte.recordCount gt 3000>
	<cf_errorCode	code = "50573" msg = "El reporte ha generado mas de 3000 registros">
	<cfabort>
</cfif>


<cfif rsReporte.recordCount>
	<!--- INVOCA EL REPORTE --->
	<cfreport format="#formato#" template= "ConsultaTransCaja.cfr" query="rsReporte">
		<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
		<cfreportparam name="Edescripcion" value="#session.Enombre#">
		<cfreportparam name="RangoCajas" value="#RangoCajas#">
		<cfreportparam name="RangoFechas" value="#RangoFechas#">
	</cfreport>
<cfelse>
	<cf_templateheader title="Punto de Venta - Consulta de Transacciones por Caja">
	
		
			<cf_templatecss>
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Consulta de Transacciones por Caja">
				<cfinclude template="../../portlets/pNavegacion.cfm">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="center">
							<strong>No se encontraron registros</strong>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="center">
							<input type="button" name="btnRegresar" value="Regresar" onclick="javascript: location.href='ConsultaTransCaja.cfm';" />
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
				</table>
			<cf_web_portlet_end>
	<cf_templatefooter>
</cfif>

