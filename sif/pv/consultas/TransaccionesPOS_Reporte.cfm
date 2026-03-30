<cfsetting 	requesttimeout="1800">

<cfparam name="Session.Idioma"  default="es_CR">
<cfparam name="Session.Ecodigo" default="193">

<cfparam name="form.codigocaja"   		default="">
<cfparam name="form.numerofax01ntr"   	default="">

<cfif isdefined('url.FechaDes')>
	<cfset form.FechaDes = url.FechaDes>
</cfif>

<cfif isdefined('url.FechaHas')>
	<cfset form.FechaHas = url.FechaHas>
</cfif>

<cfif isdefined('url.codigocaja')>
	<cfset form.codigocaja = url.codigocaja>
</cfif>

<cfif isdefined('url.numerofax01ntr')>
	<cfset form.numerofax01ntr = url.numerofax01ntr>
</cfif>

<cfif isdefined('url.tiporep')>
	<cfif url.tiporep EQ '1'>
		<cfset form.tiporeporte = "Detallado">
	</cfif>
	<cfif url.tiporep EQ '2'>
		<cfset form.tiporeporte = "ResumidoCajaFecha">
	</cfif>
	<cfif url.tiporep EQ '3'>
		<cfset form.tiporeporte = "ResumidoFecha">
	</cfif>
</cfif>

<cfset fecha1 = createdate(mid(form.FECHADES, 7,4),mid(form.FECHADES, 4,2), mid(form.FECHADES, 1, 2))>
<cfset fecha2 = createdate(mid(form.FECHAHAS, 7,4),mid(form.FECHAHAS, 4,2), mid(form.FECHAHAS, 1, 2))>
<cfset fecha2q = dateadd('d', 1, fecha2)>
<cfset fecha2q = dateadd('s', -1, fecha2q)>

<cfset Tar_id  = arraynew(1)>
<cfset Tar_cod = arraynew(1)>
<cfset Tar_tip = arraynew(1)>
<cfset Tar_des = arraynew(1)>
<cfset Tar_num = 0>

<cfset Tar_num = creaconsultas()>

<cfif isdefined('form.tiporeporte') and form.tiporeporte eq 'Detallado'>
	<cfset LvarTipo = "Detallado">
	<cfset ReporteDetallado()>
	<cfset LvarColumnas = 16 + Tar_num>
	<cfset LvarColsDoc = 9>
<cfelseif isdefined('form.tiporeporte') and form.tiporeporte eq 'ResumidoCajaFecha'>
	<cfset LvarTipo = "ResumidoCajaFecha">
	<cfset ReporteResumidoxCajaFecha()>
	<cfset LvarColumnas = 14 + Tar_num>
	<cfset LvarColsDoc = 7>
<cfelse>
	<cfset LvarTipo = "ResumidoFecha">
	<cfset ReporteResumidoxFecha()>
	<cfset LvarColumnas = 12 + Tar_num>
	<cfset LvarColsDoc = 5>
</cfif>

<cfset PintaReporte(LvarTipo, LvarColumnas)>
<cfabort>

<cffunction name="PintaReporte" output="true" returntype="any">
	<cfargument name="LvarTipoReporte" type="string"  required="yes">
	<cfargument name="LvarColumnas"    type="numeric" required="yes">
		
	<cf_htmlreportsheaders
		title="Reporte de Transacciones de Venta" 
		filename="TransaccionesVentas#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls" 
		ira="TransaccionesPOS.cfm">
	<cf_templatecss>
	<cfif not isdefined("form.btnDownload") and not isdefined("url.btnDownload")>
		<!--- location.href='/cfmx/RPSA/TransaccionesPOS_Reporte.cfm?numerofax01ntr='+escape(fax01ntr)+'&FechaDes='+escape(FechaDes)+'&FechaHas='+escape(FechaHas)+'&Documento='+escape(Documento); --->
		<script language="javascript1.2" type="text/javascript">
			<!--
			function c(fax01ntr){
				location.href='./TransaccionesPOS_DetalleDocCxC.cfm?numerofax01ntr='+escape(fax01ntr);
				return;
			}
			function d(fax01ntr){
				location.href='./TransaccionesPOS-DetalleDoc.cfm?fax01ntr='+escape(fax01ntr);
				return;
			}
			function r2(FechaDes, caja) {
				location.href='/cfmx/RPSA/TransaccionesPOS_Reporte.cfm?FechaDes='+escape(FechaDes)+'&FechaHas='+escape(FechaDes)+'&Tiporep=2';
				return;
			}
			function r(FechaDes, caja) {
				location.href='/cfmx/RPSA/TransaccionesPOS_Reporte.cfm?FechaDes='+escape(FechaDes)+'&FechaHas='+escape(FechaDes)+'&codigocaja='+escape(caja)+'&Tiporep=1';
				return;
			}
			//-->
		</script>
	</cfif>	
	<table border="0">
		<cfoutput>
		<tr>
			<td colspan="#LvarColumnas#" align="center">#session.Enombre#</td>
		</tr>
		<tr>
			<td colspan="#LvarColumnas#" align="center">Reporte de Transacciones de Venta por POS</td>
		</tr>
		<tr>
			<td colspan="#LvarColumnas#" align="center">De #dateformat(fecha1,'DD/MM/YYYY')# a #dateformat(fecha2,'DD/MM/YYYY')#</td>
		</tr>
		<tr>
			<td colspan="#LvarColumnas#" align="center">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="#LvarColsDoc#" bgcolor="##D5D5D5"><strong>Documento</strong></td>
			<td align="center" colspan="#LvarColumnas - LvarColsDoc#" bgcolor="##ABABAB"><strong>Forma Pago</strong></td>
		</tr>
		</cfoutput>
		<tr>
			<cfif LvarTipoReporte NEQ 'ResumidoFecha'>
				<td><strong>Tipo</strong></td>
			</cfif>
			<td><strong>Fecha</strong></td>
			<cfif LvarTipoReporte EQ 'Detallado' or LvarTipoReporte EQ 'ResumidoCajaFecha'><td><strong>Caja</strong></td></cfif>
			<cfif LvarTipoReporte EQ 'Detallado'><td><strong>Documento</strong></td></cfif>
			<cfif LvarTipoReporte EQ 'Detallado'><td align="right"><strong>No.Transac</strong></td></cfif>
			<td align="right"><strong>Neto</strong></td>
			<td align="right"><strong>Descuento</strong></td>
			<td align="right"><strong>Impuesto</strong></td>
			<td align="right"><strong>Total</strong></td>
			<td align="right"><strong>Credito</strong></td>
			<td align="right"><strong>Carta Bancaria</strong></td>
			<td align="right"><strong>Efectivo</strong></td>
			<td align="right"><strong>Cheques</strong></td>
			<td align="right"><strong>Bonos</strong></td>
			<td align="right"><strong>Anticipos</strong></td>
			<cfloop index="x" from="1" to="#tar_num#">
				<td align="right"><cfoutput><strong>#tar_cod[x]#</strong></cfoutput></td>
			</cfloop>
			<td align="right"><strong>Total</strong></td>
		</tr>
		<cfflush interval="64">
		<cfset Lvarfuncion = "">
		<cfoutput query="rsSalida">
			<cfset LvarFechaStr = dateformat(rsSalida.fecha, 'DD/MM/YYYY')>
			<cfif not isdefined("form.btnDownload") and not isdefined("url.btnDownload")>
				<cfif LvarTipoReporte EQ 'Detallado'>
					<cfif rsSalida.credito NEQ 0>
						<cfset Lvarfuncion = "c(#fax01ntr#);">
					<cfelse>
						<cfset Lvarfuncion = "d(#fax01ntr#);">
					</cfif>
				<cfelseif LvarTipoReporte EQ 'ResumidoCajaFecha'>
					<cfset Lvarfuncion = "r('#LvarFechaStr#', '#FAM01CODD#');">
				<cfelse>
					<cfset Lvarfuncion = "r2('#LvarFechaStr#','');">
				</cfif>
				<cfif Lvarfuncion NEQ "">
					<cfset Lvarfuncion = 'onclick="javascript: #Lvarfuncion#"'>
				</cfif>
			</cfif>
			<cfset LvarTotal = credito + cpromesa + efectivo + cheque + anticipo + bonos>
			<tr #LvarFuncion#> 
				<cfif LvarTipoReporte NEQ 'ResumidoFecha'>
					<td style="cursor:pointer" nowrap="nowrap">#tipo#</td>
				</cfif>
				<td style="cursor:pointer" nowrap="nowrap">#LvarFechaStr#</td>
				<cfif LvarTipoReporte EQ 'Detallado' or LvarTipoReporte EQ 'ResumidoCajaFecha'><td style="cursor:pointer" nowrap="nowrap">#FAM01CODD#</td></cfif>
				<cfif LvarTipoReporte EQ 'Detallado'><td style="cursor:pointer" nowrap="nowrap">#FAX01DOC#</td></cfif>
				<cfif LvarTipoReporte EQ 'Detallado'><td align="right" style="cursor:pointer" nowrap="nowrap">#fax01ntr#</td></cfif>
				<td align="right" style="cursor:pointer" nowrap="nowrap">#numberformat(neto, ',_.__')#</td>
				<td align="right" style="cursor:pointer" nowrap="nowrap">#numberformat(descuento, ',_.__')#</td>
				<td align="right" style="cursor:pointer" nowrap="nowrap">#numberformat(impuesto, ',_.__')#</td>
				<td align="right" style="cursor:pointer" nowrap="nowrap">#numberformat(total, ',_.__')#</td>
				<td align="right" style="cursor:pointer" nowrap="nowrap">#numberformat(credito, ',_.__')#</td>
				<td align="right" style="cursor:pointer" nowrap="nowrap">#numberformat(cpromesa, ',_.__')#</td>
				<td align="right" style="cursor:pointer" nowrap="nowrap">#numberformat(efectivo, ',_.__')#</td>
				<td align="right" style="cursor:pointer" nowrap="nowrap">#numberformat(cheque, ',_.__')#</td>
				<td align="right" style="cursor:pointer" nowrap="nowrap">#numberformat(bonos, ',_.__')#</td>
				<td align="right" style="cursor:pointer" nowrap="nowrap">#numberformat(anticipo, ',_.__')#</td>
				<cfloop index="x" from="1" to="#tar_num#">
					<td align="right" style="cursor:pointer" nowrap="nowrap">#numberformat(evaluate("t#x#"), ',_.__')#</td>
					<cfset LvarTotal = LvarTotal + evaluate("t#x#")>
				</cfloop>
				<td align="right" style="cursor:pointer" nowrap="nowrap">#numberformat(LvarTotal, ',_.__')#</td>
			</tr>
		</cfoutput>	
		<tr>
			<td colspan="#LvarColumnas#" align="center"><strong>*****&nbsp;&nbsp;---- ULTIMA LINEA ----&nbsp;&nbsp;*****</strong></td>
		</tr>
	</table>
</cffunction>

<cffunction name="ReporteDetallado" output="false" returntype="any">
	<cfquery name="rsSalida" datasource="#session.dsn#">
		select 
			  a.tipo
			, c.FAM01CODD
			, t.FAX01DOC
			, a.fecha 
			, a.total
			, a.impuesto
			, a.descuento
			, a.neto
			, a.credito 
			, a.cpromesa 
			, a.efectivo
			, a.cheque
			, a.anticipo
			, a.bonos 
			, a.fax01ntr
			<cfloop index="x" from="1" to="#tar_num#">
				, t#x#
			</cfloop>
		from #transac# a
			inner join FAX001 t
			on t.FAX01NTR = a.fax01ntr
			and t.FAM01COD = a.fam01cod
			and t.Ecodigo  = a.ecodigo
			
			inner join FAM001 c
			on c.FAM01COD = t.FAM01COD
			and c.Ecodigo = t.Ecodigo
		where fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha1#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha2q#">
		<cfif form.codigocaja neq ''>
		  and c.FAM01CODD = '#form.codigocaja#'
		</cfif>
		order by a.fecha, c.FAM01CODD, t.FAX01DOC
	</cfquery>
</cffunction>

<cffunction name="ReporteResumidoxCajaFecha" output="true" returntype="any">
	<cfquery name="rsSalida" datasource="#session.dsn#">
		select 
			  a.tipo as Tipo
			, c.FAM01CODD as FAM01CODD
			, a.fecha as fecha
			, sum(a.total) as total
			, sum(a.impuesto) as impuesto
			, sum(a.descuento) as descuento
			, sum(a.neto) as neto
			, sum(a.credito) as credito
			, sum(a.cpromesa) as cpromesa
			, sum(a.efectivo) as efectivo
			, sum(a.cheque) as cheque
			, sum(a.anticipo) as anticipo
			, sum(bonos) as bonos
			<cfloop index="x" from="1" to="#tar_num#">
				, sum(a.t#x#) as t#x#
			</cfloop>
		from #transac# a
			inner join FAX001 t
			on t.FAX01NTR = a.fax01ntr
			and t.FAM01COD = a.fam01cod
			and t.Ecodigo  = a.ecodigo
			
			inner join FAM001 c
			on c.FAM01COD = t.FAM01COD
			and c.Ecodigo = t.Ecodigo
		where fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha1#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha2q#">
		<cfif form.codigocaja neq ''>
		  and c.FAM01CODD = '#form.codigocaja#'
		</cfif>
		group by a.fecha, a.tipo, c.FAM01CODD
		order by a.fecha, a.tipo, c.FAM01CODD
	</cfquery>
</cffunction>

<cffunction name="ReporteResumidoxFecha" output="false" returntype="any">
	<cfquery name="rsSalida" datasource="#session.dsn#">
		select 
			  a.fecha as fecha
			, sum(a.total) as total
			, sum(a.descuento) as descuento
			, sum(a.impuesto) as impuesto
			, sum(a.neto) as neto
			, sum(a.credito) as credito
			, sum(a.cpromesa) as cpromesa
			, sum(a.efectivo) as efectivo
			, sum(a.cheque) as cheque
			, sum(a.anticipo) as anticipo
			, sum(bonos) as bonos
			<cfloop index="x" from="1" to="#tar_num#">
				, sum(a.t#x#) as t#x#
			</cfloop>
		from #transac# a
		where fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha1#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha2q#">
		group by a.fecha
		order by a.fecha
	</cfquery>
</cffunction>

<cffunction name="creaconsultas" output="false" returntype="any">

	<cfquery name="rsTarjetas" datasource="#session.dsn#">
		select 
			FATid, FATcodigo, FATtipo, FATdescripcion
		from FATarjetas
		where Ecodigo = #session.Ecodigo#
		order by FATid
	</cfquery>

	<cfset LvarTarjetas = "">
	
	<cfloop query="rsTarjetas">
		<cfset Tar_num = Tar_num + 1>
		<cfset tar_id[tar_num]  = rsTarjetas.FATid>
		<cfset tar_cod[tar_num] = rsTarjetas.FATcodigo>
		<cfset tar_tip[tar_num] = rsTarjetas.FATtipo>
		<cfset tar_des[tar_num] = rsTarjetas.FATdescripcion>
		<cfset LvarTarjetas = LvarTarjetas & " + t#Tar_num#">
	</cfloop>
	
	<cfset x= 1>

	<!--- para que no se vuelva a generar la consulta, si se envia a imprimir desde la pantalla ya generada --->
	<cfif (isdefined("form.btnDownload") or isdefined("url.btnDownload")) and isdefined("form.nombrearchivo") and len(form.nombrearchivo) GT 0>
		<cfquery name="rsVerificaTemporal" datasource="#session.dsn#">
			select object_id('#form.nombrearchivo#') as numerotabla
		</cfquery>

		<cfif len(trim(rsVerificaTemporal.numerotabla)) GT 0>
			<!--- ya está creada la tabla, no se requiere de volver a generar los datos --->
			<cfset transac = form.nombrearchivo>
			<cfreturn Tar_num>
		</cfif>
	</cfif>
	
	<cf_dbtemp name="TPos#session.Usucodigo#" returnvariable="transac" datasource="#session.dsn#">
		<cf_dbtempcol name="fax01ntr" 		type="numeric"	    mandatory="yes">
		<cf_dbtempcol name="fam01cod"  		type="char(4)"      mandatory="yes">
		<cf_dbtempcol name="ecodigo"  		type="integer"      mandatory="yes">
		<cf_dbtempcol name="fecha"  		type="date" 	    mandatory="yes">
		<cf_dbtempcol name="tipo"	  		type="char(1)" 	    mandatory="yes">
		<cf_dbtempcol name="total"		  	type="money"        mandatory="yes">
		<cf_dbtempcol name="impuesto"  		type="money"        mandatory="yes">
		<cf_dbtempcol name="descuento" 		type="money"        mandatory="yes">
		<cf_dbtempcol name="neto"  			type="money"        mandatory="yes">
		<cf_dbtempcol name="credito"  		type="money"        mandatory="yes">
		<cf_dbtempcol name="cpromesa"  		type="money"  	    mandatory="yes">
		<cf_dbtempcol name="efectivo"  		type="money"  	    mandatory="yes">
		<cf_dbtempcol name="cheque"  		type="money"        mandatory="yes">
		<cf_dbtempcol name="bonos"  		type="money"        mandatory="yes">
		<cf_dbtempcol name="anticipo"  		type="money"        mandatory="yes">
		<cfloop condition="x LTE Tar_num">
			<cf_dbtempcol name="t#x#"  		type="money"        mandatory="yes">
			<cfset x = x + 1>
		</cfloop>
		<cf_dbtempkey cols="fax01ntr,fam01cod,ecodigo">
	</cf_dbtemp>
	
	<cfset form.nombrearchivo = transac>
		
	<cfquery datasource="#session.dsn#">
		insert #transac# 
			(
				  fax01ntr
				, fam01cod
				, ecodigo
				, fecha
				, tipo
				, total
				, impuesto
				, descuento
				, neto
				, credito
				, cpromesa
				, efectivo
				, cheque
				, bonos
				, anticipo
				<cfloop index="x" from="1" to="#tar_num#">
					, t#x#
				</cfloop>
			 )
		select
				  t.FAX01NTR
				, t.FAM01COD
				, t.Ecodigo
				, convert(date, t.FAX01FEC)
				, t.FAX01TIP
				, case when t.FAX01TIP = '9' then 0.00 else coalesce(t.FAX01TOT, 0) end as total
				, case when t.FAX01TIP = '9' then 0.00 else coalesce(t.FAX01MIT, 0) end as impuesto
				, case when t.FAX01TIP = '9' then 0.00 else coalesce(t.FAX01MDT, 0) end as descuento
				, case when t.FAX01TIP = '9' then 0.00 else coalesce(t.FAX01TOT, 0) - coalesce(FAX01MIT, 0) + coalesce(t.FAX01MDT, 0) end as neto
				, case when t.FAX01TPG = 1 then t.FAX01TOT else 0.00 end as credito
				, 0.00 as cpromesa
				, 0.00 as efectivo
				, 0.00 as cheque
				, 0.00 as bonos
				, case when t.FAX01TIP = '9' then -t.FAX01TOT else 0.00 end as anticipo
				<cfloop index="x" from="1" to="#tar_num#">
					, 0.00
				</cfloop>
		from FAX001 t
			<cfif isdefined('form.codigocaja') and len(trim(form.codigocaja)) gt 0>
				inner join FAM001 c
				 on c.Ecodigo = t.Ecodigo
				and c.FAM01COD = t.FAM01COD
			</cfif>
		where t.Ecodigo = #session.ecodigo#
		  and t.FAX01FEC between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha1#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha2q#">				
		  and t.FAX01TIP in ('1', '4', '9')		<!---  Solo los tipos 1, 4 y 9. Es constante --->
		  and t.FAX01STA <> 'A'					<!---  Solo Contabilizadas y Terminadas.  Diferentes de Anuladas --->

		<cfif isdefined('form.numerofax01ntr') and len(trim(form.numerofax01ntr)) gt 0>
		  and t.FAX01NTR = #form.numerofax01ntr#
		</cfif>

		<cfif isdefined('form.codigocaja') and len(trim(form.codigocaja)) gt 0>
		  and c.FAM01CODD = '#form.codigocaja#'
		</cfif>
	</cfquery>
	
	<!--- 1.  Actualizar con Carta Promesa lo que tenga Carta Promesa en la FAX012.  No importa la distribución. --->
	<cfquery datasource="#session.dsn#">
		update #transac#
		set cpromesa = total
		where credito = 0
		   and (( 
			select count(1) 
			from FAX012 fp 
			where fp.FAX01NTR = #transac#.fax01ntr 
			and fp.FAM01COD = #transac#.fam01cod 
			and fp.Ecodigo = #transac#.ecodigo 
			and fp.FAX12TIP = 'CP'
			)) > 0
	</cfquery>

	<!--- 2. actualizar el monto del cambio ( vuelto ) en efectivo --->
	<cfquery datasource="#session.dsn#">
		update #transac#
		set efectivo = coalesce(( 
			select sum(FAX10EF1 + FAX10EF2 + FAX10EF3 - FAX10CAM)
			from FAX010 fp 
			where fp.FAX01NTR = #transac#.fax01ntr 
			and fp.FAM01COD = #transac#.fam01cod 
			and fp.Ecodigo = #transac#.ecodigo 
			), 0.00)
		where credito = 0
		  and cpromesa = 0
	</cfquery>

	<!--- 3.  Actualizar el efectivo de la FAX012.  --->
	<cfquery datasource="#session.dsn#">
		update #transac#
		set cheque = coalesce(( 
			select sum(FAX12TOT)
			from FAX012 fp 
			where fp.FAX01NTR = #transac#.fax01ntr 
			and fp.FAM01COD = #transac#.fam01cod 
			and fp.Ecodigo = #transac#.ecodigo 
			and fp.FAX12TIP in ('CK', 'DB')
			), 0.00)
		where credito = 0
		  and cpromesa = 0
	</cfquery>

	<!--- 4.  Actualizar los anticipos de FAX016  --->
	<cfquery datasource="#session.dsn#">
		update #transac#
		set anticipo = coalesce(( 
			select sum(FAX16MON)
			from FAX016 an 
			where an.FAX01NTR = #transac#.fax01ntr 
			and an.FAM01COD = #transac#.fam01cod 
			and an.Ecodigo = #transac#.ecodigo 
			), 0.00)
		where credito = 0
		  and cpromesa = 0
		  and tipo <> '9'
	</cfquery>
		
	<!--- 5.  Por cada tarjeta de credito --->
	<cfloop index="x" from="1" to="#tar_num#">
		<cfquery datasource="#session.dsn#">
			update #transac#
			set t#x# = coalesce(( 
				select sum(FAX12TOT)
				from FAX012 fp 
				where fp.FAX01NTR = #transac#.fax01ntr 
				and fp.FAM01COD = #transac#.fam01cod 
				and fp.Ecodigo = #transac#.ecodigo 
				and fp.FAX12TIP = 'TC'
				and fp.FATid = #tar_id[x]#
				), 0.00)
			where credito = 0
			  and cpromesa = 0
		</cfquery>
	</cfloop>

	<!--- 6.  Actualizar el monto de los bonos de la FAX012  --->
	<cfquery datasource="#session.dsn#">
		update #transac#
		set bonos = coalesce(( 
			select sum(FAX12TOT)
			from FAX012 fp 
			where fp.FAX01NTR = #transac#.fax01ntr 
			and fp.FAM01COD = #transac#.fam01cod 
			and fp.Ecodigo = #transac#.ecodigo 
			and fp.FAX12TIP = 'BN')
			, 0.00)
		where credito = 0
		  and cpromesa = 0
	</cfquery>
		
	<cfreturn Tar_num>
</cffunction>

