<!---<cf_templatecss>--->
<!---  <cftransaction>   --->
<cfsetting requesttimeout="36000" enablecfoutputonly="yes" showdebugoutput="no">

	<cfif isdefined("url.DCDid") and len(trim(url.DCDid)) and not isdefined("form.DCDid")>
		<cfset form.DCDid = url.DCDid>
	</cfif>
	
	<!--- Crea tablas temporales para mantener las cuentas --->		
	<cf_dbtemp name="DT_REPORTE" returnvariable="MOVIMIENTOS_CTAS_DT" datasource="#Session.DSN#">
		<cf_dbtempcol name="ID"   	 	 type="numeric"	     identity="yes">
		<cf_dbtempcol name="Ocodigo"	 type="int"  	     mandatory="yes">
		<cf_dbtempcol name="Ccuenta" 	 type="numeric"      mandatory="yes">
		<cf_dbtempcol name="Monto"       type="money"	     mandatory="yes">

		<cf_dbtempkey cols="ID">
	</cf_dbtemp>
	<cfset Request.movctasdt = MOVIMIENTOS_CTAS_DT>	
	
	<!--- OBTIENE LAS CUENTAS --->
	<cfquery name="rsCuentasDT" datasource="#Session.DSN#">
		select
			distinct
			b.Ccuenta
		from DCD_PCClasificacionD a
			inner join DTDCD_PCClasificacionD b
				on b.DCDid = a.DCDid
			inner join CContables ctas
				on ctas.Ccuenta = b.Ccuenta
		where a.DCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DCDid#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by ctas.Cformato
	</cfquery>
	
	<cfoutput query="rsCuentasDT">
		
		<cfset cuenta = rsCuentasDT.Ccuenta>

		<!--- OBTIENE LAS OFICINAS --->
		<cfquery name="rsOficinasDT" datasource="#Session.DSN#">
			select
				distinct
				b.OcodigoD,
				ofi.Oficodigo as OficodigoD,
				ofi.Odescripcion as OdescripcionD
			from DCD_PCClasificacionD a
				inner join DTDCD_PCClasificacionD b
					on b.DCDid = a.DCDid
				inner join Oficinas ofi
					on ofi.Ocodigo = b.OcodigoD
					and ofi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			where a.DCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DCDid#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			order by b.Ocodigo
		</cfquery>
		
		<cfloop query="rsOficinasDT">
			<!--- AGREGA EN TABLA TEMPORAL POR CUENTA / OFICINA --->
			<cfquery name="rsAltaDT" datasource="#Session.DSN#">
				Insert into #Request.movctasdt# (Ccuenta, Ocodigo, Monto)
				select
					#cuenta#,
					#rsOficinasDT.OcodigoD#,
					(
						select coalesce(SUM(b.MntOficina),0.00)
						from DTDCD_PCClasificacionD b
						where b.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuenta#">
						and b.OcodigoD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOficinasDT.OcodigoD#">
					) as Monto
			</cfquery>
		</cfloop>

	</cfoutput>

	<!---	
	<cfif isdefined("form.botonsel") and len(trim(form.botonsel)) and form.botonsel eq "Exportar">
		<cf_exportQueryToFile query="#rsDistribucion#" separador="#chr(9)#" filename="Distribucion_por_Conductor_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="false">
	</cfif>
	--->
	
	<!---
		SUBSTR(string,pos,len)
		INSTR(string,target,start,nth)
		CHARINDEX('bicycle', DocumentSummary, 5)
	--->
	<cfquery name="rsDistribucion" datasource="#Session.DSN#">
		select
			<!---
			SUBSTRING(ctas.Cformato,1,(CHARINDEX('-', ctas.Cformato))-1) as DT_Proceso,
			SUBSTRING(ctas.Cformato,1,(CHARINDEX('-', ctas.Cformato))-1) as DT_Objeto_Gasto,
			--->
			ctas.Cformato,
			a.Ocodigo,
			ofi.Oficodigo as OficodigoD,
			ofi.Odescripcion as OdescripcionD,
			a.Monto,
			coalesce((select sum(Monto)
					from #Request.movctasdt# dtd
					where dtd.Ccuenta = a.Ccuenta), 0.00) as Movimiento_Mensual
			from #Request.movctasdt# a
				inner join CContables ctas
					on ctas.Ccuenta = a.Ccuenta
				inner join Oficinas ofi
					on ofi.Ocodigo = a.Ocodigo
					and ofi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by ctas.Cformato, a.Ocodigo
	</cfquery>
	
	<!---
	<table border="1">
	<cfoutput query="rsDistribucion">
	<tr>
		<td>#Cformato#</td>
		<td>#Ocodigo#</td>
		<td>#OficodigoD#</td>
		<td>#OdescripcionD#</td>
		<td>#Monto#</td>
	</tr>
	</cfoutput>
	</table>
	--->
	
	<cfset FechaGeneracion = Now()>
	<cfset rsDistribucionrows = 0>
	<cfset Tmp_Proceso = "">
	<cfset Tmp_Objeto_Gasto = "">
	<cfset Tmp_OcodigoD = 0>
	<cfset Tmp_Proceso_Objeto_Gasto_Monto = 0>
	<cfset Tmp_Monto_Mensual = 0>

	<cfoutput query="rsDistribucion">
		<cfset rsDistribucionrows = rsDistribucionrows + 1>
		<cfset Proceso = Left(Cformato,4)>
		<cfset PosTxt = find("-",Cformato)>
		<cfset Objeto_Gasto = RemoveChars(Cformato, 1, PosTxt)>
		<cfset PosTxt = find("-",Objeto_Gasto)>
		<cfset Objeto_Gasto = RemoveChars(Objeto_Gasto, PosTxt, Len(Objeto_Gasto))>

		<cfif rsDistribucion.currentRow EQ 1>
			<cfset Tmp_Cuenta = Cformato>
			<cfset Tmp_Proceso = Proceso>
			<cfset Tmp_Objeto_Gasto = Objeto_Gasto>
			<cfset Tmp_OcodigoD = Ocodigo>
			<cfset Tmp_Proceso_Objeto_Gasto_Monto = Tmp_Proceso_Objeto_Gasto_Monto + Monto>
			<cfset Tmp_Monto_Mensual = Tmp_Monto_Mensual + Monto>

			<cfset ArrayPos = 1>
			<cfset ArrayTotalLength = 0>

			<cfset Reportcols = 3 + rsOficinasDT.recordcount>
			<table width="100%" border="0" cellspacing="2" cellpadding="2">
			<tr>
				<td colspan="#Reportcols#" align="center"><strong>Reporte de Distribuciones por Conductor</strong></td>
			</tr>
			  <tr>
				<td colspan="#Reportcols#" align="center"><strong>Generado: </strong>#LSDateFormat(FechaGeneracion, 'dd/mm/yyyy')# #LSTimeFormat(FechaGeneracion, 'hh:mm tt')#</td>
			  </tr>
			  <tr>
				<td colspan="#Reportcols#" align="center">&nbsp;</td>
			  </tr>
			<tr>
				<td align="center" bgcolor="##CCCCCC"><strong>Proceso</strong></td>
				<td align="center" bgcolor="##CCCCCC"><strong>Objeto Gasto</strong></td>
				<td align="center" bgcolor="##CCCCCC"><strong>Movimiento del Mes</strong></td>
				<cfset Montos = ArrayNew(1)>
				<cfset Totales = ArrayNew(1)>

				<cfloop query="rsOficinasDT">
				<cfset ArrayTotalLength = ArrayTotalLength + 1>
				<cfset ArrayAppend(Montos, 0)>
				<cfset ArrayAppend(Totales, 0)>
				<td align="center" bgcolor="##CCCCCC"><strong>#OficodigoD# - #OdescripcionD#</strong></td>
				</cfloop>

			</tr>
			<tr>
				<td align="center">#Proceso#</td>
				<td align="center">#Objeto_Gasto#</td>
			<!---<cfset PorCiento = (#MntOficina#*100)/#Movimiento_Mensual#>--->

		<cfelse>

			<cfif Tmp_Proceso NEQ Proceso or Tmp_Objeto_Gasto NEQ Objeto_Gasto>
				<td align="center">#Tmp_Monto_Mensual#</td>
				<cfset Montos[#ArrayPos#] = Montos[#ArrayPos#] + Monto>
				<cfset Totales[#ArrayPos#] = Totales[#ArrayPos#] + Monto>
				<cfloop index="i" from="1" to="#ArrayLen(Montos)#" step="1">
				<td align="right">#Montos[i]#</td>
				</cfloop>

			</tr>
			<tr>
				<td align="center">#Proceso#</td>
				<td align="center">#Objeto_Gasto#</td>

				<cfset ArrayPos = 1>

				<cfset Tmp_Cuenta = Cformato>
				<cfset Tmp_Proceso = Proceso>
				<cfset Tmp_Objeto_Gasto = Objeto_Gasto>
				<cfset Tmp_OcodigoD = Ocodigo>
				<cfset Tmp_Proceso_Objeto_Gasto_Monto = Monto>
				<cfset Tmp_Monto_Mensual = Monto>

				<cfset Montos[#ArrayPos#] = Monto>
				<cfset Totales[#ArrayPos#] = Totales[#ArrayPos#] + Monto>
			<cfelse>
				<cfif Tmp_OcodigoD NEQ Ocodigo>
					<cfset Montos[#ArrayPos#] = Montos[#ArrayPos#] + Tmp_Proceso_Objeto_Gasto_Monto>
					<cfset Totales[#ArrayPos#] = Totales[#ArrayPos#] + Tmp_Proceso_Objeto_Gasto_Monto>
					<cfset Tmp_OcodigoD = Ocodigo>
					<cfset Tmp_Proceso_Objeto_Gasto_Monto = 0>
				</cfif>
				
				<cfset ArrayPos = ArrayPos + 1>
				
				<cfif ArrayPos GT ArrayTotalLength>
					<cfset ArrayPos = 1>
				</cfif>
				
				<cfset Tmp_Proceso_Objeto_Gasto_Monto = Tmp_Proceso_Objeto_Gasto_Monto + Monto>
				<cfset Tmp_Monto_Mensual = Tmp_Monto_Mensual + Monto>
			</cfif>
		</cfif>
	</cfoutput>

	<cfoutput>
	<cfif rsDistribucionrows GT 0>

		<cfset Proceso = Left(rsDistribucion.Cformato,4)>
		<cfset PosTxt = find("-",rsDistribucion.Cformato)>
		<cfset Objeto_Gasto = RemoveChars(rsDistribucion.Cformato, 1, PosTxt)>
		<cfset PosTxt = find("-",Objeto_Gasto)>
		<cfset Objeto_Gasto = RemoveChars(Objeto_Gasto, PosTxt, Len(Objeto_Gasto))>

		<cfif Tmp_Proceso EQ Proceso or Tmp_Objeto_Gasto EQ Objeto_Gasto>
			<cfset Montos[#ArrayPos#] = Montos[#ArrayPos#] + rsDistribucion.Monto>
			<cfset Totales[#ArrayPos#] = Totales[#ArrayPos#] + rsDistribucion.Monto>
			<td align="center">#Tmp_Monto_Mensual#</td>
			<cfloop index="i" from="1" to="#ArrayLen(Montos)#" step="1">
				<td align="right">#Montos[i]#</td>
			</cfloop>

		</cfif>

			</tr>
	</cfif>
	
			<tr>
				<td>&nbsp;</td>
				<td align="right"><strong>Total:</strong></td>
				<td>&nbsp;</td>
				<cfloop index="i" from="1" to="#ArrayLen(Totales)#" step="1">
				<td align="right"><strong>#Totales[i]#</strong></td>
				</cfloop>
			</tr>
			</table>
	</cfoutput>	
<!--- </cftransaction> --->