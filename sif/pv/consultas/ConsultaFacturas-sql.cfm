<!--- 
	Creado por: 		Rebeca Corrales Alfaro
	Fecha: 				25/05/2005  4:00 p.m.
	
	Modificado por: 	Mauricio Esquivel
	Fecha: 				2/Agosto/2008
	Motivo:				No debe permitirse generar el reporte sin filtros pues provoca la caida del Servidor de Aplicaciones
						En caso de que el reporte genere más de 1000 registros, se genera en formato HTML con un flush
--->

<cfif isdefined("url.FechaI") and len(url.FechaI)>
	<cfset LvarFechaI = createdate(right(url.FechaI,4),mid(url.FechaI,4,2),left(url.FechaI,2))>
</cfif>

<cfif isdefined("url.FechaF") and len(url.FechaF)>
	<cfset LvarFechaF = createdate(right(url.FechaF,4),mid(url.FechaF,4,2),left(url.FechaF,2))>
	<cfset LvarFechaF = dateadd('d',1,LvarFechaF)>
	<cfset LvarFechaF = dateadd('s',-1,LvarFechaF)>
</cfif>

<cfquery name="rsCantidadRegistros" datasource="#session.dsn#">
	select count(1) as Cantidad
	from FAX001 as A
		inner join FAM001 as D     					<!--- cajas --->
		on  A.FAM01COD = D.FAM01COD
		and A.Ecodigo = D.Ecodigo

		inner join Monedas as G 						<!--- monedas --->
		on A.Mcodigo = G.Mcodigo
	  
		inner join Oficinas as H 						<!--- Oficinas --->
		on A.Ocodigo = H.Ocodigo
		and A.Ecodigo = H.Ecodigo
	  
	where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and A.FAX01STA IN ('T', 'C')
	  and A.FAX01TIP not in ('2','3','9') <!--- Recibos --->
		
		<!--- Filtro de Caja --->
		<cfif isdefined("url.FAM01CODD") and len(trim(url.FAM01CODD))>
			and D.FAM01CODD = <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD#">
		</cfif>	

		<!--- FILTROS DE FECHAS --->
		<cfif isdefined("url.FechaI") and len(trim(url.FechaI))>
			and A.FAX01FEC >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaI#">
		</cfif> 
		<cfif isdefined("url.FechaF") and len(trim(url.FechaF))>
			and A.FAX01FEC <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaF#">
		</cfif> 
		   
		<!--- FILTRO DE OFICINA --->
		<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
			and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		</cfif>
	
		<!--- FILTRO DE MONEDAS ---> 
		<cfif isdefined("url.Mcodigo") and len(trim(url.Mcodigo))>
			and A.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Mcodigo#">
		</cfif> 
		
		<!--- FILTRO DE FACTURAS  --->
		<cfif isdefined("url.FAX11DOCI") and len(trim(url.FAX11DOCI))>
			and rtrim(A.FAX01DOC) >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(url.FAX11DOCI)#">
		</cfif> 
		<cfif isdefined("url.FAX11DOCF") and len(trim(url.FAX11DOCF))>
			and rtrim(A.FAX01DOC) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(url.FAX11DOCF)#">
		</cfif> 
</cfquery>

<cfif rsCantidadRegistros.Cantidad GT 20000>
	<cf_errorCode	code = "50572"
					msg  = "Se han generado @errorDat_1@ registros. El límite indicado son 20.000. Favor de indicar parámetros que delimiten mejor la consulta "
					errorDat_1="#rsCantidadRegistros.Cantidad#"
	>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsReporte" datasource="#session.DSN#">
	select 
		A.FAX01NTR as Transaccion,
		H.Oficodigo as Oficina, 
		H.Odescripcion as Ofic_descrip,
		rtrim(D.FAM01CODD) as CodigoCaja, 
		A.FAX01DOC as Documento,
		A.FAX01FEC as FechaFactura,
		ltrim(rtrim(B.SNidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(B.SNnombre)) as SocNeg,
		case 
			when A.FAX01TPG = 1 
				then ltrim(rtrim(B.SNnumero)) #_Cat# '-' #_Cat# B.SNnombre 
				else ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) 
		end as Cliente,		 
		coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
		A.FAX01TOT as TotalLinea,
		case 
			when A.FAX01TPG = 1 then 'Crédito'
			else 'Contado'
		end as TipoPago,
		G.Miso4217 as CodigoMoneda
	from FAX001 as A
		inner join FAM001 as D     					<!--- cajas --->
		on  A.FAM01COD = D.FAM01COD
		and A.Ecodigo = D.Ecodigo

		inner join Monedas as G 					<!--- monedas --->
		on A.Mcodigo = G.Mcodigo
	  
		inner join Oficinas as H 					<!--- Oficinas --->
		on A.Ocodigo = H.Ocodigo
		and A.Ecodigo = H.Ecodigo
	  
		left outer join ClientesDetallistasCorp as E 	<!--- clientes --->
		on A.CDCcodigo = E.CDCcodigo

		left outer join SNegocios as B 				<!--- clientes --->
		on A.SNcodigo = B.SNcodigo
		and A.Ecodigo = B.Ecodigo
		
	where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and A.FAX01STA IN ('T', 'C')
	  and A.FAX01TIP not in ('2','3','9') <!--- Recibos --->
		
		<!--- Filtro de Caja --->
		<cfif isdefined("url.FAM01CODD") and len(trim(url.FAM01CODD))>
			and D.FAM01CODD = <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD#">
		</cfif>	

		<!--- FILTROS DE FECHAS --->
		<cfif isdefined("url.FechaI") and len(trim(url.FechaI))>
			and A.FAX01FEC >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaI#">
		</cfif> 
		<cfif isdefined("url.FechaF") and len(trim(url.FechaF))>
			and A.FAX01FEC <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaF#">
		</cfif> 
		   
		<!--- FILTRO DE OFICINA --->
		<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
			and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
		</cfif>
	
		<!--- FILTRO DE MONEDAS ---> 
		<cfif isdefined("url.Mcodigo") and len(trim(url.Mcodigo))>
			and A.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Mcodigo#">
		</cfif> 
		
		<!--- FILTRO DE FACTURAS  --->
		<cfif isdefined("url.FAX11DOCI") and len(trim(url.FAX11DOCI))>
			and rtrim(A.FAX01DOC) >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(url.FAX11DOCI)#">
		</cfif> 
		<cfif isdefined("url.FAX11DOCF") and len(trim(url.FAX11DOCF))>
			and rtrim(A.FAX01DOC) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(url.FAX11DOCF)#">
		</cfif> 
	order by H.Oficodigo, A.FAX01NTR
</cfquery>
 
<!--- DETERMINA EL TIPO DE FORMATO EN QUE SE RELAIZARA EL REPORTE --->
<cfif (isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ "html") or rsCantidadRegistros.Cantidad GT 2000>
	<cfset formatos = "html">
<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ "flashpaper">
	<cfset formatos = "flashpaper">
<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ "pdf">
	<cfset formatos = "pdf">
<cfelse>
	<cfset formatos = "html">
</cfif>

<cfif formatos neq "html">
	<!--- INVOCA EL REPORTE --->
	<cfreport format="#formato#" template= "ConsultaFacturas.cfr" query="rsReporte">
		<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
		<cfreportparam name="Edescripcion" value="#session.Enombre#">
	</cfreport>
<cfelse>
	<cfset fnPresentarConsultaHTML()>
</cfif>

<cffunction name="fnPresentarConsultaHTML" access="private" output="yes">
	<cf_htmlReportsHeaders 
	title="Impresion de Consultas de Facturas" 
	filename="ConsultaFacturas.xls"
	irA="ConsultaFacturas.cfm"
	download="no"
	preview="no">
	<cfset LvarOficinaAnterior = "">
	<cfset LvarTotalOficina = 0.00>
	<cfset LvarTotalConsulta = 0.00>
	<table cellpadding="0" cellspacing="1">
		<cfoutput>
		<tr>
			<td colspan="8" align="center"><strong>#session.Enombre#</strong></td>
		</tr>
		<tr>
			<td colspan="8" align="center"><strong>Consulta General de Facturas</strong></td>
		</tr>
		<tr>
			<td colspan="8" align="right">#dateformat(now(), "DD/MM/YYYY hh:mm:ss")#</td>
		</tr>
		</cfoutput>
		<cfflush interval="64">
		<cfoutput query="rsReporte">
			<cfif LvarOficinaAnterior NEQ Oficina>
				<cfif LvarOficinaAnterior NEQ "">
					<tr>
						<td colspan="5">Total Oficina:</td>
						<td colspan="3" align="right">#numberformat(LvarTotalOficina, ",9.00")#</td>
					</tr>
				</cfif>
				<tr>
					<td colspan="8">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="8"><strong>Oficina: #Oficina# - #Ofic_descrip#</strong></td>
				</tr>
				<tr>
					<td colspan="8">Oficina: #Oficina# - #Ofic_descrip#</td>
				</tr>
				<tr>
					<td><strong>Transaccion</strong></td>
					<td><strong>Caja</strong></td>
					<td><strong>Factura</strong></td>
					<td><strong>Fecha</strong></td>
					<td><strong>Cliente</strong></td>
					<td><strong>Tipo</strong></td>
					<td><strong>Moneda</strong></td>
					<td align="right"><strong>Total</strong></td>
				</tr>
				<cfset LvarOficinaAnterior = Oficina>
				<cfset LvarTotalOficina = 0.00>
			</cfif>
			<cfset LvarTotalOficina = LvarTotalOficina + TotalLinea>
			<cfset LvarTotalConsulta = LvarTotalConsulta + TotalLinea>
			<tr>
				<td>#Transaccion#</td>
				<td>#CodigoCaja#</td>
				<td>#Documento#</td>
				<td>#dateformat(FechaFactura, "DD/MM/YYYY")#</td>
				<td>#Cliente#</td>
				<td>#TipoPago#</td>
				<td>#CodigoMoneda#</td>
				<td align="right">#numberformat(TotalLinea, ",9.00")#</td>
			</tr>
		</cfoutput>
		<cfoutput>
		<cfif LvarOficinaAnterior NEQ "">
			<tr>
				<td colspan="5">Total Oficina:</td>
				<td colspan="3" align="right">#numberformat(LvarTotalOficina, ",9.00")#</td>
			</tr>
		</cfif>
		<tr>
			<td colspan="5">Total General:</td>
			<td colspan="3" align="right">#numberformat(LvarTotalConsulta, ",9.00")#</td>
		</tr>
		</cfoutput>
	</table>
</cffunction>


