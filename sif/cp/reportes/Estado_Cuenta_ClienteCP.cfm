<!---
	Creado por: Ana Villavicencio
	Fecha: 17 de julio de 2006
	Motivo: Nuevo reporte.
--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_EdoCue = t.Translate('TIT_EdoCue','Estado de Cuenta')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Datos del Reporte')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha Desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha Hasta','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_Socio_de_Negocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset LB_SaldoIni 	= t.Translate('LB_SaldoIni','Saldo Inicial')>
<cfset LB_SinDef 	= t.Translate('LB_SinDef','Sin Definir')>

<cf_templateheader title="SIF - Cuentas por Pagar">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_EdoCue#'>
<script language="JavaScript" src="../../js/fechas.js"></script>
<cfquery name="rsMonedas" datasource="#session.DSN#">
	select Mcodigo, Mnombre, Miso4217
	from Monedas
	where Ecodigo =  #session.Ecodigo#
	order by Mnombre
</cfquery>
<form name="form1" action="Estado_Cuenta_ClienteCP.cfm" method="get">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<fieldset><legend>#LB_DatosReporte#</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Fecha_Desde#:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left"><cf_sifcalendario name="fechaDes" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Fecha_Hasta#:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left"><cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_SocioNegocio#:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2  Proveedores="SI" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong>#LB_Formato#&nbsp;</strong>
					<select name="Formato" id="Formato" tabindex="1">
						<option value="2">PDF</option>
					</select>
					</td>
					<td valign="middle">&nbsp;</td>


					<td colspan="2">&nbsp;</td>
				</tr>
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr><td colspan="6"><cf_botones values="Generar" names="Generar" tabindex="1"></td></tr>
			</table>
			</fieldset>
		</td>
	</tr>
</table>
</cfoutput>
</form>
<cf_web_portlet_end>
<cf_templatefooter>
<cfif isdefined("url.Generar")>
	<cfsetting requesttimeout="3600">
	<cfquery name="rsParametros1" datasource="#session.DSN#">
		select Pvalor as p1
		from Parametros
		where Ecodigo =  #session.Ecodigo#
			and Pcodigo = 310
	</cfquery>
	<cfif isdefined("rsParametros1") and rsParametros1.recordcount gt 0>
		<cfset p1 = rsParametros1.p1>
	<cfelse>
    	<cfset MSG_DefPer1 = t.Translate('MSG_DefPer1','Debe definir el primer período en los parámetros.')>
		<cf_errorCode	code = "50178" msg = "#MSG_DefPer1#">
	</cfif>
	<cfquery name="rsParametros2" datasource="#session.DSN#">
		select Pvalor as p2
		from Parametros
		where Ecodigo =  #session.Ecodigo#
			and Pcodigo = 320
	</cfquery>
	<cfif isdefined("rsParametros2") and rsParametros2.recordcount gt 0>
		<cfset p2 = rsParametros2.p2>
	<cfelse>
    	<cfset MSG_DefPer2 = t.Translate('MSG_DefPer2','Debe definir el segundo período en los parámetros.')>
		<cf_errorCode	code = "50179" msg = "#MSG_DefPer2#">
	</cfif>
	<cfquery name="rsParametros3" datasource="#session.DSN#">
		select Pvalor as p3
		from Parametros
		where Ecodigo =  #session.Ecodigo#
			and Pcodigo = 330
	</cfquery>
	<cfif isdefined("rsParametros3") and rsParametros3.recordcount gt 0>
		<cfset p3 = rsParametros3.p3>
	<cfelse>
    	<cfset MSG_DefPer3 = t.Translate('MSG_DefPer3','Debe definir el tercer período en los parámetros.')>
		<cf_errorCode	code = "50180" msg = "#MSG_DefPer3#">
	</cfif>
	<cfquery name="rsParametros4" datasource="#session.DSN#">
		select Pvalor as p4
		from Parametros
		where Ecodigo =  #session.Ecodigo#
			and Pcodigo = 340
	</cfquery>
	<cfif isdefined("rsParametros4") and rsParametros4.recordcount gt 0>
		<cfset p4 = rsParametros4.p4>
	<cfelse>
    	<cfset MSG_DefPer4 = t.Translate('MSG_DefPer4','Debe definir el cuarto período en los parámetros.')>
		<cf_errorCode	code = "50181" msg = "#MSG_DefPer4#">
	</cfif>

	<!--- Tabla de Trabajo de los Socios seleccionados --->
	<cf_dbtemp name="TempSocios_v1" returnvariable="socios" datasource="#session.dsn#">
		<cf_dbtempcol name="Ecodigo"	  	type="integer"		mandatory="no">
		<cf_dbtempcol name="SNcodigo"	  	type="integer"		mandatory="no">
		<cf_dbtempcol name="SNnombre"	  	type="char(254)"	mandatory="no">
		<cf_dbtempcol name="SNid"			type="numeric"		mandatory="no">
		<cf_dbtempcol name="id_direccion"  	type="numeric"		mandatory="no">
		<cf_dbtempcol name="FechaIni"		type="datetime"		mandatory="no">
		<cf_dbtempcol name="FechaFin"		type="datetime"		mandatory="no">
		<cf_dbtempcol name="SNnumero"		type="char(20)"		mandatory="no">
		<cf_dbtempcol name="SNDcodigo"		type="char(20)"		mandatory="no">
		<cf_dbtempcol name="periodo"		type="integer"		mandatory="no">
		<cf_dbtempcol name="mes"			type="integer"		mandatory="no">
		<cf_dbtempcol name='Mcodigo'		type="numeric"		mandatory="yes">
	</cf_dbtemp>
	<cfquery name="rsSocios" datasource="#session.DSN#">
		insert into #socios# (Ecodigo, SNcodigo, SNnombre,SNid, id_direccion, FechaIni, FechaFin, SNnumero, Mcodigo)
		select
			s.Ecodigo, s.SNcodigo, s.SNnombre, s.SNid, s.id_direccion,
			#LSParseDateTime(url.fechaDes)# as FechaIni,
			#LSParseDateTime(url.fechaHas)# as FechaFin,
			s.SNnumero,
			s.Mcodigo
		from SNegocios s
		where Ecodigo =  #session.Ecodigo#
		<cfif isdefined('url.SNnumero1') and Len(trim(url.SNnumero1)) and not isdefined('url.SNnumero2')>
				and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero1#">
		<cfelseif isdefined('url.SNnumero2') and Len(trim(url.SNnumero2)) and not isdefined('url.SNnumero1')>
				and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero2#">
		<cfelseif isdefined('url.SNnumero1') and Len(trim(url.SNnumero1)) and isdefined('url.SNnumero2') and Len(trim(url.SNnumero2))>
			<cfif url.SNnumero1 LTE url.SNnumero2>
				   and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero1#">
				   and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero2#">
			<cfelse>
				   and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero1#">
				   and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero2#">
			</cfif>
		<cfelseif isdefined('url.SNnumero') and Len(trim(url.SNnumero))>
		  and s.SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero#">
		</cfif>
	</cfquery>
	<cf_dbtemp name="TempDocumentos_v1" returnvariable="documentos" datasource="#session.dsn#">
		<cf_dbtempcol name="Ecodigo"			type="integer" 		mandatory="no">
		<cf_dbtempcol name="SNid"				type="numeric" 		mandatory="no">
		<cf_dbtempcol name="Socio"  			type="integer"	 	mandatory="no">
		<cf_dbtempcol name="IDdireccion"  		type="numeric" 		mandatory="no">
		<cf_dbtempcol name="Documento" 			type="char(70)" 	mandatory="no">
		<cf_dbtempcol name="TTransaccion"		type="char(2)" 		mandatory="no">
		<cf_dbtempcol name="CPTtipo"			type="char(1)"		mandatory="no">
		<cf_dbtempcol name="Moneda"  			type="integer" 		mandatory="no">
		<cf_dbtempcol name="FechaVencimiento"	type="datetime"		mandatory="no">
		<cf_dbtempcol name="Fecha"				type="datetime" 	mandatory="no">
		<cf_dbtempcol name="Total"				type="money"		mandatory="no">
		<cf_dbtempcol name="TotalOri"			type="money"		mandatory="no">
		<cf_dbtempcol name="Tcambio"			type="money"		mandatory="no">
		<cf_dbtempcol name="SaldoInicial"		type="money"		mandatory="no">
		<cf_dbtempcol name="SaldoFinal"			type="money"		mandatory="no">
	</cf_dbtemp>
	<cfquery name="rsInsert2" datasource="#session.DSN#">
		insert into #documentos# (
			Ecodigo, SNid, Socio,  IDdireccion, Documento, TTransaccion,  CPTtipo, Moneda,
			FechaVencimiento, Fecha, Total,TotalOri,Tcambio, SaldoInicial, SaldoFinal)
		select
			d.Ecodigo, s.SNid, d.SNcodigo,
			<cfif isdefined("url.chk_cod_Direccion")>
			coalesce(d.id_direccion, s.id_direccion),
			<cfelse>
			s.id_direccion,
			</cfif>
			d.Ddocumento, d.CPTcodigo, t.CPTtipo, d.Mcodigo,
			d.Dfechavenc, d.Dfecha, (d.Dtotal*d.Dtipocambio) as Total,
			d.Dtotal as Total,  
			d.Dtipocambio as Tcambio, 
			0.00 as SaldoInicial, 
			0.00 as SaldoFinal
		from #socios# sn
			inner join SNegocios s
					on  s.SNid = sn.SNid
			inner join HEDocumentosCP d
						inner join CPTransacciones t
							on t.Ecodigo = d.Ecodigo
							and t.CPTcodigo = d.CPTcodigo
					on d.Ecodigo = sn.Ecodigo
					and d.SNcodigo = sn.SNcodigo
					<cfif isdefined("url.chk_cod_Direccion")>
					and d.id_direccion = sn.id_direccion
					</cfif>
		where d.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
	</cfquery>


	
	<!---
		Actualizar el saldo de todos los documentos a la fecha de inicio del análisis.
		Documentos tipo "Debito", se hace el join por las columnas DRdocumento, CPTRcodigo y Ecodigo
	--->
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #documentos#
		set SaldoInicial = Total -
			coalesce((
				select sum(BMmontoref*Dtipocambio)
				from BMovimientosCxP bm
					inner join CPTransacciones t
							on t.Ecodigo = bm.Ecodigo
							and t.CPTcodigo = bm.CPTcodigo
							and t.CPTtipo = 'D'
				where bm.Ecodigo = #documentos#.Ecodigo
				  and bm.CPTRcodigo = #documentos#.TTransaccion
				  and bm.DRdocumento = #documentos#.Documento
				  and bm.SNcodigo    = #documentos#.Socio
				  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				  <!---and bm.Dfecha >= #documentos#.Fecha--->
				  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00)
		where #documentos#.CPTtipo = 'C'
		  and #documentos#.Fecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
	</cfquery>

<!---Actualizacion para los tipo NE--->
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #documentos#
		set SaldoInicial = SaldoInicial -
			coalesce((
				select sum(BMmontoref*Dtipocambio)
				from BMovimientosCxP bm
				where bm.Ecodigo = #documentos#.Ecodigo
				  and bm.CPTcodigo = 'NE'
				  and bm.CPTRcodigo = #documentos#.TTransaccion
				  and bm.DRdocumento = #documentos#.Documento
				  and bm.SNcodigo    = #documentos#.Socio
				  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				  <!---and bm.Dfecha >= #documentos#.Fecha--->
				  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00)
		where #documentos#.CPTtipo = 'C'
		  and #documentos#.Fecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
	</cfquery>

	<!---
		Documentos tipo "Credito", se hace el join por las columnas Ecodigo, CPTcodigo, DDocumento
		Las aplicaciones de los documentos de credito se hacen a documentos de debito - de ahí el join con CPTransacciones t2
	--->
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #documentos#
		set SaldoInicial = Total - coalesce((
			select sum(BMmontoref*Dtipocambio)
			from BMovimientosCxP bm
				inner join CPTransacciones t
						on t.Ecodigo = bm.Ecodigo
						and t.CPTcodigo = bm.CPTRcodigo
						and t.CPTtipo = 'C'
			where bm.Ecodigo = #documentos#.Ecodigo
			  and bm.CPTcodigo = #documentos#.TTransaccion
			  and bm.Ddocumento = #documentos#.Documento
			  and bm.SNcodigo    = #documentos#.Socio
			  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
			  <!---and bm.Dfecha >= #documentos#.Fecha--->
			  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00)
		where #documentos#.CPTtipo = 'D'
		  and #documentos#.Fecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
	</cfquery>

	<!--- Actualizar el saldo de todos los documentos a la fecha de final del análisis. --->
	<!---saldo de documentos tipo debito a la fecha 2--->
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #documentos#
		set SaldoFinal = Total - coalesce((
			select sum(BMmontoref*Dtipocambio)
			from BMovimientosCxP bm
				inner join CPTransacciones t
						on t.Ecodigo = bm.Ecodigo
						and t.CPTcodigo = bm.CPTcodigo
						and t.CPTtipo = 'D'
			where bm.Ecodigo = #documentos#.Ecodigo
			  and bm.CPTRcodigo = #documentos#.TTransaccion
			  and bm.DRdocumento = #documentos#.Documento
			  and bm.SNcodigo    = #documentos#.Socio
			  and bm.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
			  <!---and bm.Dfecha >= #documentos#.Fecha--->
			  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00)
		where CPTtipo = 'C'
		  and Fecha <=  <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
	</cfquery>

<!--- Actualizacion de tipo 'NE' --->
	<!--- <cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #documentos#
		set SaldoFinal = Total - coalesce((
			select sum(BMmontoref)
			from BMovimientosCxP bm
			where bm.Ecodigo = #documentos#.Ecodigo
			  and bm.CPTcodigo = 'NE'
			  and bm.CPTRcodigo = #documentos#.TTransaccion
			  and bm.DRdocumento = #documentos#.Documento
			  and bm.SNcodigo    = #documentos#.Socio
			  and bm.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
			  <!---and bm.Dfecha >= #documentos#.Fecha--->
			  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00)
		where CPTtipo = 'C'
		  and Fecha <=  <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
	</cfquery> --->
	<!---Saldos de documentos tipo credito a la fecha 2--->
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #documentos#
		set SaldoFinal = Total - coalesce((
			select sum(BMmontoref*Dtipocambio)
			from BMovimientosCxP bm
				inner join CPTransacciones t
						on t.Ecodigo = bm.Ecodigo
						and t.CPTcodigo = bm.CPTRcodigo
						and t.CPTtipo = 'C'
			where bm.Ecodigo = #documentos#.Ecodigo
			  and bm.CPTcodigo = #documentos#.TTransaccion
			  and bm.Ddocumento = #documentos#.Documento
			  and bm.SNcodigo    = #documentos#.Socio
			  and bm.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
			  <!---and bm.Dfecha >= #documentos#.Fecha--->
			  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00)
		where CPTtipo = 'D'
		  and Fecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
	</cfquery>

	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #documentos#
		set SaldoInicial = -SaldoInicial, SaldoFinal = -SaldoFinal
		where CPTtipo = 'D'
	</cfquery>
	<!--- Generacion de Saldos Iniciales--->

	<cf_dbtemp name="TempSaldosIniciales_v1" returnvariable="SaldosIniciales" datasource="#session.dsn#">
		<cf_dbtempcol name="Ecodigo"  		type="integer" 		mandatory="no">
		<cf_dbtempcol name="Mcodigo"  		type="numeric" 		mandatory="no">
		<cf_dbtempcol name="SNid"  			type="numeric" 		mandatory="no">
		<cf_dbtempcol name="id_direccion"  	type="numeric" 		mandatory="no">
		<cf_dbtempcol name="SfechaIni" 		type="datetime"		mandatory="no">
		<cf_dbtempcol name="SfechaFin"		type="datetime"		mandatory="no">
		<cf_dbtempcol name="SIsaldoinicial" type="money" 		mandatory="no">
		<cf_dbtempcol name="SIsaldoFinal" type="money" 		mandatory="no">
		<cf_dbtempcol name="SIsinvencer"  	type="money" 		mandatory="no">
		<cf_dbtempcol name="SIcorriente"  	type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp1"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp2"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp3"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp4"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp5"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp5p"  		type="money" 		mandatory="no">
		<cf_dbtempcol name="Tcambio"  		type="money" 		mandatory="no">
	</cf_dbtemp>
	<cfquery name="rsInsertSaldosIni" datasource="#session.DSN#">
		insert into #SaldosIniciales#(Ecodigo,Mcodigo,SNid,id_direccion,SfechaIni,SfechaFin,SIsaldoinicial,SIsaldoFinal,SIsinvencer,SIcorriente,
									  SIp1, SIp2, SIp3, SIp4, SIp5, SIp5p)
		select 	distinct Ecodigo, Moneda, SNid, IDdireccion,
		#LSParseDateTime(url.fechaDes)#,
		#LSParseDateTime(url.fechaHas)#,
		0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
		from #documentos#
	</cfquery>

	<!--- Actualizar el saldo final de la tabla #SaldosIniciales# --->
	<cfquery datasource="#session.DSN#">
		update #SaldosIniciales#
		set
			SIsaldoFinal =
				coalesce((
					select sum(d.SaldoFinal)
					from #documentos# d
					where d.SNid         = #SaldosIniciales#.SNid
					  and d.IDdireccion = #SaldosIniciales#.id_direccion
					  and d.Moneda      = #SaldosIniciales#.Mcodigo
					  and d.Fecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHas)#">
				), 0.00)
		where SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaDes)#">
		  and SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHas)#">
		  and Ecodigo 	=  #session.Ecodigo#
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update #SaldosIniciales#
		set
			SIcorriente =
				coalesce((
					select sum(d.SaldoFinal)
					from #documentos# d
					where d.SNid = #SaldosIniciales#.SNid
					  and d.IDdireccion = #SaldosIniciales#.id_direccion
					  and d.Moneda = #SaldosIniciales#.Mcodigo
					  and d.FechaVencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
					  and
					  	<cf_dbfunction name="date_part"	args="mm,d.Fecha"> =
						<cf_dbfunction name="date_part"	args="mm,#LSParseDateTime(url.fechaHas)#">
				), 0.00)
		where SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaDes)#">
		  and SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHas)#">
		  and Ecodigo 	=  #session.Ecodigo#
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update #SaldosIniciales#
		set
			SIsinvencer =
				coalesce((
					select sum(d.SaldoFinal)
					from #documentos# d
					where d.SNid            = #SaldosIniciales#.SNid
					  and d.IDdireccion    = #SaldosIniciales#.id_direccion
					  and d.Moneda      	= #SaldosIniciales#.Mcodigo
					  and d.FechaVencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
					  and
					  	<cf_dbfunction name="date_part"	args="mm,d.Fecha"> <>
					  	<cf_dbfunction name="date_part"	args="mm,#LSParseDateTime(url.fechaHas)#">
				), 0.00)
		where SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
		  and SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHas)#">
		  and Ecodigo 	=  #session.Ecodigo#
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update #SaldosIniciales#
		set
			SIp1 =
				coalesce((
					select sum(d.SaldoFinal)
					from #documentos# d
					where d.SNid             = #SaldosIniciales#.SNid
					  and d.IDdireccion     = #SaldosIniciales#.id_direccion
					  and d.Moneda      	 = #SaldosIniciales#.Mcodigo
					  and d.FechaVencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
					  and <cf_dbfunction name="datediff" args="d.FechaVencimiento,#LSParseDateTime(url.fechaHas)#"> between 1 and #p1#
				), 0.00)
		where SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
		  and SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHas)#">
		  and Ecodigo   = #session.Ecodigo#
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update #SaldosIniciales#
		set
			SIp2 =
				coalesce((
					select sum(d.SaldoFinal)
					from #documentos# d
					where d.SNid = #SaldosIniciales#.SNid
					  and d.IDdireccion = #SaldosIniciales#.id_direccion
					  and d.Moneda = #SaldosIniciales#.Mcodigo
					  and d.FechaVencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
					  and  <cf_dbfunction name="datediff" args="d.FechaVencimiento,#LSParseDateTime(url.fechaHas)#"> between #p1+1# and #p2#
				), 0.00)
		where SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
		  and SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHas)#">
		  and Ecodigo 	=  #session.Ecodigo#
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update #SaldosIniciales#
		set
			SIp3 =
				coalesce((
					select sum(d.SaldoFinal)
					from #documentos# d
					where d.SNid             = #SaldosIniciales#.SNid
					  and d.IDdireccion     = #SaldosIniciales#.id_direccion
					  and d.Moneda      	= #SaldosIniciales#.Mcodigo
					  and d.FechaVencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
					  and <cf_dbfunction name="datediff" args="d.FechaVencimiento, #LSParseDateTime(fechaHas)#"> between #p2+1# and #p3#
				), 0.00)
		where SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
		  and SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHas)#">
		  and Ecodigo 	=  #session.Ecodigo#
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update #SaldosIniciales#
		set
			SIp4 =
				coalesce((
					select sum(d.SaldoFinal)
					from #documentos# d
					where d.SNid             = #SaldosIniciales#.SNid
					  and d.IDdireccion     = #SaldosIniciales#.id_direccion
					  and d.Moneda      	= #SaldosIniciales#.Mcodigo
					  and d.FechaVencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
					  and <cf_dbfunction name="datediff" args="d.FechaVencimiento, #LSParseDateTime(fechaHas)#"> between #p3+1# and #p4#
				), 0.00)
		where SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
		  and SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHas)#">
		  and Ecodigo 	=  #session.Ecodigo#
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update #SaldosIniciales#
		set
			SIp5 =
				coalesce((
					select sum(d.SaldoFinal)
					from #documentos# d
					where d.SNid             = #SaldosIniciales#.SNid
					  and d.IDdireccion     = #SaldosIniciales#.id_direccion
					  and d.Moneda      	= #SaldosIniciales#.Mcodigo
					  and d.FechaVencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
					  and <cf_dbfunction name="datediff" args="d.FechaVencimiento, #LSParseDateTime(url.fechaHas)#"> between #p4+1# and 151
				), 0.00)
		where SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
		  and SfechaFin     = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHas)#">
		  and Ecodigo =  #session.Ecodigo#
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update #SaldosIniciales#
		set
			SIp5p =
				coalesce((
					select sum(d.SaldoFinal)
					from #documentos# d
					where d.SNid             = #SaldosIniciales#.SNid
					  and d.IDdireccion     = #SaldosIniciales#.id_direccion
					  and d.Moneda      	= #SaldosIniciales#.Mcodigo
					  and d.FechaVencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
					  and <cf_dbfunction name="datediff" args="d.FechaVencimiento, #LSParseDateTime(url.fechaHas)#"> > 151
				), 0.00)
		where SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
		  and SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHas)#">
		  and Ecodigo =  #session.Ecodigo#
	</cfquery>

	<!--- Fernando Alcaraz Cristobal.
		Actualiza los saldos iniciales.
	--->

	<!--- Movimientos del Estado de Cuenta --->
	<cf_dbtemp name="TempMovimientos_v1" returnvariable="movimientos" datasource="#session.dsn#">
		<cf_dbtempcol name="id"  				type="numeric" 		mandatory="no" identity>
		<cf_dbtempcol name="Ecodigo"  			type="integer" 		mandatory="no">
		<cf_dbtempcol name="SNnumero"  			type="char(20)" 	mandatory="no">
		<cf_dbtempcol name="Socio"  			type="integer"	 	mandatory="no">
		<cf_dbtempcol name="Moneda"  			type="integer" 		mandatory="no">
		<cf_dbtempcol name="IDdireccion"  		type="numeric" 		mandatory="no">
		<cf_dbtempcol name="Ocodigo"   			type="integer"  	mandatory="no">
		<cf_dbtempcol name="Control"   			type="integer"  	mandatory="no">
		<cf_dbtempcol name="TTransaccion"		type="char(2)" 		mandatory="no">
		<cf_dbtempcol name="Documento" 			type="char(100)" 	mandatory="no">
		<cf_dbtempcol name="Fecha"				type="datetime" 	mandatory="no">
		<cf_dbtempcol name="FechaVencimiento"	type="datetime"		mandatory="no">
		<cf_dbtempcol name="Total"				type="money"		mandatory="no">
		<cf_dbtempcol name="TotalOri"			type="money"		mandatory="no">
		<cf_dbtempcol name="Tcambio"			type="money"		mandatory="no">
		<cf_dbtempcol name="Saldo"				type="money" 		mandatory="no">
		<cf_dbtempcol name="Pago"				type="integer" 		mandatory="no">
		<cf_dbtempcol name="TReferencia"		type="char(2)" 		mandatory="no">
		<cf_dbtempcol name="DReferencia"		type="char(20)" 	mandatory="no">
		<cf_dbtempcol name="Ordenamiento"		type="char(20)" 	mandatory="no">
		<cf_dbtempcol name="SNid"				type="numeric" 		mandatory="no">
		<cf_dbtempcol name="TRgroup"			type="char(2)"		mandatory="no">
		<cf_dbtempcol name="Oficodigo"			type="char(10)"		mandatory="no">
		<cf_dbtempcol name="CPTdescripcion"		type="varchar(80)"	mandatory="no">
		<cf_dbtempcol name="CPTtipo"			type="char(1)"		mandatory="no">
		<cf_dbtempkey cols="id">
	</cf_dbtemp>
		

	<!--- /* insertar los saldos iniciales del socio */ --->
	<cfquery name="rsMovimientos1" datasource="#session.DSN#">
		insert into #movimientos#
		(
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			IDdireccion,
			Ocodigo,
			Control,
			TTransaccion,
			Documento,
			Fecha,
			Total,
			TotalOri,
			Tcambio,
			Saldo,
			Pago, TReferencia,
			DReferencia,
			Ordenamiento,
			SNid,
			TRgroup,
			Oficodigo,
			CPTdescripcion
		)
		select
			s.Ecodigo,
			s.SNcodigo,
			s.SNnumero,
			si.Mcodigo,
			s.id_direccion,
			-1 as Oficina,
			1 as Control,
			' ' as TTransaccion,
			' #LB_SaldoIni# ' as Documento,
			<cf_dbfunction name="dateadd" args="-1, #LSParseDateTime(url.fechaDes)#"> as Fecha,
			sum(SIsaldoinicial) as Total,
			sum(SIsaldoinicial) as Totalori,
			1 as Tcambio,
			0.00 as Saldo,
			0 as Pago,
			' ' as TReferencia,
			' ' as DReferencia,
			' ' as Ordenamiento,
			s.SNid as SNid,
			' ' as TRgroup,
			' ' as Oficodigo,
			' #LB_SaldoIni# ' as CPTdescripcion
		from #socios# s
		inner join #SaldosIniciales# si
			on si.SNid = s.SNid
			and si.SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
			and si.SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
		group by s.Ecodigo,
			s.SNid,
			si.Mcodigo,
			s.SNcodigo,
			s.SNnumero,
			s.id_direccion
	</cfquery>


	<cfquery name="rsMovimientos2" datasource="#session.DSN#">
		insert into #movimientos# (
			SNid,
			IDdireccion,
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			Ocodigo,
			Control,
			Total,
			TotalOri,
			Tcambio,
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			CPTtipo,
			FechaVencimiento
		)
		<!--- Todos los documentos --->
		select
			s.SNid,
			s.id_direccion,
			do.Dfecha,
			do.CPTcodigo,
			do.Ddocumento,
			s.Ecodigo,
			s.SNcodigo,
			s.SNnumero,
			do.Mcodigo,
			do.Ocodigo as Oficina,
			2 as Control,
			case when t.CPTtipo = 'C' then do.Dtotal*do.Dtipocambio  else -do.Dtotal*do.Dtipocambio  end as Total,
			case when t.CPTtipo = 'C' then do.Dtotal else -do.Dtotal end as Totalori,
			do.Dtipocambio as Tcambio,
			case when t.CPTtipo = 'C' then do.Dtotal*do.Dtipocambio else -do.Dtotal*do.Dtipocambio end as Saldo,
			0 as Pago,
			do.CPTcodigo as TReferencia,
			do.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			do.CPTcodigo as TRgroup,
			o.Oficodigo as Oficodigo,
			t.CPTdescripcion as CPTdescripcion,
			t.CPTtipo as CPTtipo,
			do.Dfechavenc

		from #socios# s
			inner join HEDocumentosCP do
				 on do.SNcodigo = s.SNcodigo
				and do.Ecodigo = s.Ecodigo
			inner join CPTransacciones t
				on t.CPTcodigo = do.CPTcodigo
				and t.Ecodigo = do.Ecodigo
			inner join Oficinas o
				 on o.Ecodigo = do.Ecodigo
				and o.Ocodigo = do.Ocodigo
		where do.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
	</cfquery>

	<!---CASO ESPECIAL, CUANDO SE APLICA UN PAGO O UN DOCUMENTO A FAVOR ANTERIOR A LA FECHA DESDE
	 ABG 20141013--->
	<!---Para Facturas--->
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #movimientos#
		set Total = Total -
			coalesce((
				select sum(BMmontoref*Dtipocambio)
				from BMovimientosCxP bm
					inner join CPTransacciones t
							on t.Ecodigo = bm.Ecodigo
							and t.CPTcodigo = bm.CPTcodigo
							and t.CPTtipo = 'D'
				where bm.Ecodigo = #movimientos#.Ecodigo
				  and bm.CPTRcodigo = #movimientos#.TTransaccion
				  and bm.DRdocumento = #movimientos#.Documento
				  and bm.SNcodigo    = #movimientos#.Socio
				  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				  and bm.Dfecha < #movimientos#.Fecha
				  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00),
			Saldo = Saldo -
			coalesce((
				select sum(BMmontoref*Dtipocambio)
				from BMovimientosCxP bm
					inner join CPTransacciones t
							on t.Ecodigo = bm.Ecodigo
							and t.CPTcodigo = bm.CPTcodigo
							and t.CPTtipo = 'D'
				where bm.Ecodigo = #movimientos#.Ecodigo
				  and bm.CPTRcodigo = #movimientos#.TTransaccion
				  and bm.DRdocumento = #movimientos#.Documento
				  and bm.SNcodigo    = #movimientos#.Socio
				  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				  and bm.Dfecha < #movimientos#.Fecha
				  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00)
		where #movimientos#.CPTtipo = 'C'
		  and #movimientos#.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
	</cfquery>

	<!--- Actualizacion de Tipo NE --->
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #movimientos#
		set Total = Total -
			coalesce((
				select sum(BMmontoref*Dtipocambio)
				from BMovimientosCxP bm
				where bm.Ecodigo = #movimientos#.Ecodigo
				  and bm.CPTcodigo = 'NE'
				  and bm.CPTRcodigo = #movimientos#.TTransaccion
				  and bm.DRdocumento = #movimientos#.Documento
				  and bm.SNcodigo    = #movimientos#.Socio
				  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				  and bm.Dfecha < #movimientos#.Fecha
				  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00),
			Saldo = Saldo -
			coalesce((
				select sum(BMmontoref*Dtipocambio)
				from BMovimientosCxP bm
				where bm.Ecodigo = #movimientos#.Ecodigo
				  and bm.CPTcodigo = 'NE'
				  and bm.CPTRcodigo = #movimientos#.TTransaccion
				  and bm.DRdocumento = #movimientos#.Documento
				  and bm.SNcodigo    = #movimientos#.Socio
				  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				  and bm.Dfecha < #movimientos#.Fecha
				  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00)
		where #movimientos#.CPTtipo = 'C'
		  and #movimientos#.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
	</cfquery>

	<!---
		Documentos tipo "Credito", se hace el join por las columnas Ecodigo, CPTcodigo, DDocumento
		Las aplicaciones de los documentos de credito se hacen a documentos de debito - de ahí el join con CPTransacciones t2
	--->
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #movimientos#
		set Total = Total + coalesce((
			select sum(BMmontoref*Dtipocambio)
			from BMovimientosCxP bm
				inner join CPTransacciones t
						on t.Ecodigo = bm.Ecodigo
						and t.CPTcodigo = bm.CPTRcodigo
						and t.CPTtipo = 'C'
			where bm.Ecodigo = #movimientos#.Ecodigo
			  and bm.CPTcodigo = #movimientos#.TTransaccion
			  and bm.Ddocumento = #movimientos#.Documento
			  and bm.SNcodigo    = #movimientos#.Socio
			  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
			  and bm.Dfecha < #movimientos#.Fecha
			  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00),
			Saldo = Saldo + coalesce((
			select sum(BMmontoref*Dtipocambio)
			from BMovimientosCxP bm
				inner join CPTransacciones t
						on t.Ecodigo = bm.Ecodigo
						and t.CPTcodigo = bm.CPTRcodigo
						and t.CPTtipo = 'C'
			where bm.Ecodigo = #movimientos#.Ecodigo
			  and bm.CPTcodigo = #movimientos#.TTransaccion
			  and bm.Ddocumento = #movimientos#.Documento
			  and bm.SNcodigo    = #movimientos#.Socio
			  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
			  and bm.Dfecha < #movimientos#.Fecha
			  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00)
		where #movimientos#.CPTtipo = 'D'
		  and #movimientos#.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
	</cfquery>

	<!--- /* Recibos de Dinero */ --->

	<cfquery name="rsMovimientos3" datasource="#session.DSN#">
		insert into #movimientos# (
			SNid,
			IDdireccion,
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			Ocodigo,
			Control,
			Total,
			TotalOri,
			Tcambio,
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento
		)

		select
			s.SNid,
			s.id_direccion,
			bm.Dfecha,
			bm.CPTcodigo,
			bm.Ddocumento,
			min(s.Ecodigo),
			min(s.SNcodigo),
			min(s.SNnumero),
			do.Mcodigo,
			min(do.Ocodigo) as Oficina,
			2 as Control,
			sum((bm.Dtotal*bm.Dtipocambio) * case when t.CPTtipo='D' then -1.00 else 1.00 end) as Total, <!--- sum(bm.BMmontoref * case when t.CPTtipo='D' then -1.00 else 1.00 end) Total, --->
			sum(bm.Dtotal * case when t.CPTtipo='D' then -1.00 else 1.00 end) as Totalori, 
			bm.Dtipocambio as Tcambio,
			0.00 as Saldo,
			1 as Pago,
			min(t.CPTcodigo) as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			bm.CPTcodigo as TRgroup,
			min(o.Oficodigo) as Oficodigo,
			min(t.CPTdescripcion) as CPTdescripcion,
			bm.Dfecha
		from #socios# s
			inner join CPTransacciones t
				 on t.Ecodigo = s.Ecodigo
				and t.CPTpago = 1

			inner join BMovimientosCxP bm
				 on bm.SNcodigo   = s.SNcodigo
				and bm.CPTcodigo  = t.CPTcodigo
				and bm.Ecodigo    = t.Ecodigo
				and bm.Ecodigo    = s.Ecodigo
				and bm.Dfecha     < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">


			inner join HEDocumentosCP do
				 on do.SNcodigo   = bm.SNcodigo
				and do.Ecodigo    = bm.Ecodigo
				and do.CPTcodigo  = bm.CPTRcodigo
				and do.Ddocumento = bm.DRdocumento

			inner join Oficinas o
				 on o.Ecodigo = do.Ecodigo
				and o.Ocodigo = do.Ocodigo
		group by
			s.SNid,
			s.id_direccion,
			bm.Dfecha,
			bm.CPTcodigo,
			bm.Dtipocambio,
			bm.Ddocumento,
			do.Mcodigo,
			bm.Ddocumento,
			bm.CPTcodigo,
			bm.Dfecha
	</cfquery>
<!--- <cf_dumptable name="#movimientos#" abrot="false"> --->

	<cfquery name="rsMovimientos5" datasource="#session.DSN#">
		<!--- Notas de Credito aplicada a documentos de otros socios --->

		insert into #movimientos# (
			SNid,
			IDdireccion,
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			Ocodigo,
			Control,
			Total,
			TotalOri,
			Tcambio,
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento
		)


		select
			s.SNid,
			s.id_direccion,
			min(bm.Dfecha) as Fecha,
			bm.CPTcodigo,
			<cf_dbfunction name="concat" args="'APLIC.',bm.CPTcodigo,'-',rtrim(bm.Ddocumento),'/',bm.CPTRcodigo,'-',ltrim(rtrim(bm.DRdocumento))">,
			min(s.Ecodigo),
			min(s.SNcodigo),
			min(s.SNnumero),
			hd.Mcodigo,
			min(hd.Ocodigo) as Oficina,
			2 as Control,
			sum(-bm.Dtotal*bm.Dtipocambio) as Total,
			sum(-bm.Dtotal) as Totalori,
			bm.Dtipocambio as Tcambio,
			0.00 as Saldo,
			1 as Pago,
			min(t.CPTcodigo) as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			bm.CPTcodigo as TRgroup,
			min(o.Oficodigo) as Oficodigo,
			min(t.CPTdescripcion) as CPTdescripcion,
			min(bm.Dfecha) as FechaVencimiento

		from #socios# s
			inner join HEDocumentosCP hd
				on hd.SNcodigo = s.SNcodigo
				and hd.Ecodigo = s.Ecodigo

			inner join CPTransacciones t
				on t.CPTcodigo = hd.CPTcodigo
				and t.Ecodigo = hd.Ecodigo
				and t.CPTtipo = 'D'

			inner join BMovimientosCxP bm
				on bm.Ecodigo = hd.Ecodigo
				and bm.CPTcodigo  = hd.CPTcodigo
				and bm.Ddocumento = hd.Ddocumento
				and bm.SNcodigo   = hd.SNcodigo

			inner join HEDocumentosCP hd2
				on hd2.Ecodigo = bm.Ecodigo
				and hd2.CPTcodigo = bm.CPTRcodigo
				and hd2.Ddocumento = bm.DRdocumento
				and hd2.SNcodigo   = bm.SNcodigo

			inner join Oficinas o
				on o.Ecodigo = hd.Ecodigo
				and o.Ocodigo = hd.Ocodigo

		where hd2.SNcodigo <> hd.SNcodigo                    <!---Socios Diferentes--->
		  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">

		group by
			s.SNid,
			s.id_direccion,
			bm.CPTcodigo,
			bm.Dtipocambio,
			<cf_dbfunction name="concat" args="'APLIC.',bm.CPTcodigo,'-',rtrim(bm.Ddocumento),'/',bm.CPTRcodigo,'-',ltrim(rtrim(bm.DRdocumento))">,
			hd.Mcodigo,
			bm.Ddocumento,
			bm.CPTcodigo
	</cfquery>

	<cfquery name="rsMovimientos6" datasource="#session.DSN#">
		<!--- Notas de Credito de otros socios aplicadas a documentos del socios del estado de cuenta --->
		insert into #movimientos# (
			SNid,
			IDdireccion,
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			Ocodigo,
			Control,
			Total,
			TotalOri,
			Tcambio,
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento
		)
		select
			s.SNid,
			s.id_direccion,
			min(bm.Dfecha) as Fecha,
			bm.CPTcodigo,
			<cf_dbfunction name="concat" args="'APLIC.',bm.CPTRcodigo,'-',rtrim(bm.DRdocumento),'/',bm.CPTcodigo,'-',ltrim(rtrim(bm.Ddocumento))">as Documento,
			min(s.Ecodigo),
			min(s.SNcodigo),
			min(s.SNnumero),
			hd.Mcodigo,
			min(hd.Ocodigo) as Oficina,
			2 as Control,
			sum(bm.Dtotal*bm.Dtipocambio) Total,
			sum(bm.Dtotal) Totalori,
			bm.Dtipocambio as Tcambio,
			0.00 as Saldo,
			1 as Pago,
			min(t.CPTcodigo) as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			bm.CPTcodigo as TRgroup,
			min(o.Oficodigo) as Oficodigo,
			min(t.CPTdescripcion) as CPTdescripcion,
			min(bm.Dfecha) as FechaVencimiento

		from #socios# s
			inner join HEDocumentosCP hd
				on hd.SNcodigo = s.SNcodigo
				and hd.Ecodigo = s.Ecodigo

			inner join CPTransacciones t
				on t.CPTcodigo = hd.CPTcodigo
				and t.Ecodigo = hd.Ecodigo
				and t.CPTtipo = 'C'

			inner join BMovimientosCxP bm
				on bm.Ecodigo = hd.Ecodigo
				and bm.CPTRcodigo  = hd.CPTcodigo
				and bm.DRdocumento = hd.Ddocumento
				and bm.SNcodigo    = hd.SNcodigo

			inner join HEDocumentosCP hd2
				on hd2.Ecodigo = bm.Ecodigo
				and hd2.CPTcodigo = bm.CPTcodigo
				and hd2.Ddocumento = bm.Ddocumento
				and hd2.SNcodigo   = bm.SNcodigo

			inner join Oficinas o
				on o.Ecodigo = hd.Ecodigo
				and o.Ocodigo = hd.Ocodigo
		where hd2.SNcodigo <> hd.SNcodigo   				 <!---Socios Diferentes--->
		  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
			group by
			s.SNid,
			s.id_direccion,
			bm.CPTcodigo,
			bm.Dtipocambio,
			<cf_dbfunction name="concat" args="'APLIC.',bm.CPTRcodigo,'-',rtrim(bm.DRdocumento),'/',bm.CPTcodigo,'-',ltrim(rtrim(bm.Ddocumento))">,
			hd.Mcodigo,
			bm.Ddocumento,
			bm.CPTcodigo

	</cfquery>
<!--- <cf_dumptable name="#movimientos#"> --->
	 <!--- ************************************ --->
	 <!--- ************** NETEOS ************** --->

	<cfset LvarTransNeteo = "">
	<cfquery name="rsTranNeteo" datasource="#session.dsn#">
		select CCTcodigo
		from  CCTransacciones tn
		where tn.Ecodigo      = #session.Ecodigo#
		and tn.CCTtranneteo = 1
	</cfquery>
	<cfif rsTranNeteo.recordcount EQ 1>
		<cfset LvarTransNeteo = "and m.CPTcodigo = '#rsTranNeteo.CCTcodigo#'">
	<cfelseif rsTranNeteo.recordcount GT 1>
		<cfloop query="rsTranNeteo">
			<cfset LvarTransNeteo = trim(LvarTransNeteo) & ", '#rsTranNeteo.CCTcodigo#'">
		</cfloop>
		<cfset LvarTransNeteo = "and m.CPTcodigo in (" & trim(mid(LvarTransNeteo, 3, 255)) & ")">
	</cfif>
<!--- JARR 31/03/2020 se comento ya que por Reglas de NEgocio se definio que no se deben de ver estos registros --->
	<!--- <cfquery name="rsMovimientos7" datasource="#session.DSN#">
		<!--- Inclusion de Documentos de Neteo --->
		insert into #movimientos# (
			SNid,
			IDdireccion,
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			Ocodigo,
			Control,
			Total,
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento
		)

select 		s.SNid,
			s.id_direccion,
			min(m.Dfecha) as Fecha,
			m.CPTcodigo,
			<cf_dbfunction name="concat" args="d.CPTcodigo,' ',rtrim(d.Ddocumento),' (Aplic.Neteo ',rtrim(m.Ddocumento),')'">as Documento,
			min(s.Ecodigo),
			min(s.SNcodigo),
			min(s.SNnumero),
			d.Mcodigo,
			min(d.Ocodigo) as Oficina,
			2 as Control,
			sum(case when t.CCTtipo = 'C' then m.Dtotal*-1 else m.Dtotal end) as Total,
			0.00 as Saldo,
			1 as Pago,
			min(t.CCTcodigo) as TReferencia,
			m.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			m.CPTcodigo as TRgroup,
			(( select min(o.Oficodigo) from Oficinas o where o.Ecodigo = d.Ecodigo and o.Ocodigo = d.Ocodigo)) as Oficodigo,
			min(t.CCTdescripcion) as CPTdescripcion,
			min(m.Dfecha) as FechaVencimiento

		from 	BMovimientosCxP m

			inner join CCTransacciones t
			on  t.Ecodigo   = m.Ecodigo
			and t.CCTcodigo = m.CPTcodigo

			inner join HEDocumentosCP d
			on  d.Ddocumento = m.DRdocumento
			and d.CPTcodigo  = m.CPTRcodigo
			and d.Ecodigo    = m.Ecodigo
			and d.SNcodigo   = m.SNcodigo

			inner join #socios# s
				on d.SNcodigo = s.SNcodigo
				and d.Ecodigo = s.Ecodigo

		where   m.Dfecha     < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
		  and   m.Ecodigo    =  #session.Ecodigo#
		  and   m.Dfecha     < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">

		  and   m.CPTcodigo  <> m.CPTRcodigo
		  #PreserveSingleQuotes(LvarTransNeteo)#
		group by
			s.SNid,
			s.id_direccion,
			m.CPTcodigo,
			d.CPTcodigo,
			d.Ddocumento,
			m.Ddocumento,
			d.Mcodigo,
			d.Ecodigo,
			d.Ocodigo
	</cfquery>


	<cfquery name="rsMovimientos7" datasource="#session.DSN#">
		<!--- Inclusion de Documentos de Neteo --->
		insert into #movimientos# (
			SNid,
			IDdireccion,
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			Ocodigo,
			Control,
			Total,
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento
		)

		select
			s.SNid,
			s.id_direccion,
			min(m.Dfecha) as Fecha,
			m.CPTcodigo,
			<cf_dbfunction name="concat" args="d.CPTcodigo,' ',rtrim(d.Ddocumento),' (Aplic.Neteo ',rtrim(m.Ddocumento),')'">as Documento,
			min(s.Ecodigo),
			min(s.SNcodigo),
			min(s.SNnumero),
			d.Mcodigo,
			min(d.Ocodigo) as Oficina,
			2 as Control,
			sum(case when t.CCTtipo = 'D' then m.Dtotal*-1 else m.Dtotal end) as Total,
			0.00 as Saldo,
			1 as Pago,
			min(t.CCTcodigo) as TReferencia,
			m.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			m.CPTcodigo as TRgroup,
			(( select min(o.Oficodigo) from Oficinas o where o.Ecodigo = d.Ecodigo and o.Ocodigo = d.Ocodigo)) as Oficodigo,
			min(t.CCTdescripcion) as CPTdescripcion,
			min(m.Dfecha) as FechaVencimiento

		from 	BMovimientosCxP m

			inner join CCTransacciones t
			on  t.Ecodigo   = m.Ecodigo
			and t.CCTcodigo = m.CPTcodigo

			inner join HEDocumentosCP d
			on  d.Ddocumento = m.DRdocumento
			and d.CPTcodigo  = m.CPTRcodigo
			and d.Ecodigo    = m.Ecodigo
			and d.SNcodigo   = m.SNcodigo

			inner join #socios# s
				on d.SNcodigo = s.SNcodigo
				and d.Ecodigo = s.Ecodigo

		where   m.Dfecha     < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
		  and   m.Ecodigo    =  #session.Ecodigo#
		  and   m.Dfecha
					< <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
		  and   m.CPTcodigo  <> m.CPTRcodigo
		  and 	t.CCTtranneteo != 1
		  #PreserveSingleQuotes(LvarTransNeteo)#
		group by
			s.SNid,
			s.id_direccion,
			m.CPTcodigo,
			d.CPTcodigo,
			d.Ddocumento,
			m.Ddocumento,
			d.Mcodigo,
			d.Ecodigo,
			d.Ocodigo
	</cfquery>
 --->
	<!---**************************************************************************************************************--->
	<cfquery datasource="#session.DSN#">
		update #movimientos#
			set
				Oficodigo  = coalesce((select o.Oficodigo from Oficinas o where o.Ecodigo = #movimientos#.Ecodigo and o.Ocodigo = #movimientos#.Ocodigo ), '  '),
				CPTdescripcion = coalesce((select t.CPTdescripcion from CPTransacciones t where t.Ecodigo = #movimientos#.Ecodigo and t.CPTcodigo = #movimientos#.TTransaccion), '  ')			where Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
	</cfquery>

	<!--- reporte resumido por transacción --->
	<cfquery name="Request.rsReporte2" datasource="#session.DSN#" maxrows="5001">
		select
			sn.SNnumero as Socio,
			sn.id_direccion,
			Moneda,
			TTransaccion as tipo,
			CPTdescripcion  as CPTdescripcion,
			sum(Total) as Total,
			Mnombre
		from  #movimientos# m
			inner join Monedas mo
				on mo.Ecodigo = m.Ecodigo
				and mo.Mcodigo = m.Moneda
			inner join SNegocios sn
				on sn.Ecodigo = m.Ecodigo
				and sn.SNcodigo = m.Socio
		where Fecha < <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
		group by
			sn.SNnumero,
			sn.id_direccion,
			Moneda,
			TTransaccion,
			CPTdescripcion,
			Mnombre,
			sn.SNnombre,
			sn.SNnumero
		having sum(Total) <> 0.00
		order by
			sn.SNnumero,
			Moneda,
			TTransaccion
	</cfquery>

	<cfquery name="rsRepSalIni" datasource="#session.DSN#" maxrows="5001">
		select sum(Total) as SaldoInicial
			from (
			select
				Fecha,
				CPTtipo,
				m.SNid,
				sn.id_direccion,
				mo.Mcodigo as moneda,
				Total,
				m.Ecodigo
			from #movimientos# m
			inner join Monedas mo
				 on mo.Ecodigo = m.Ecodigo
				and mo.Mcodigo = m.Moneda
			inner join SNegocios sn
				 on sn.Ecodigo = m.Ecodigo
				and sn.SNcodigo = m.Socio
			 inner join DireccionesSIF ds
				on ds.id_direccion = sn.id_direccion
	)final
	</cfquery>

	<cfquery name="rsRepSalIni2020" datasource="#session.DSN#" >
			select
			sn.SNid as Socio,
			sum(Total) as Total
		from  #movimientos# m
		inner join SNegocios sn
				 on sn.Ecodigo = m.Ecodigo
				and sn.SNcodigo = m.Socio
		where Fecha < <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
		group by sn.SNid 
	</cfquery>
	
	<cfloop query="rsRepSalIni2020">
	<cfquery datasource="#session.DSN#">
		update #SaldosIniciales# 
		set
			SIsaldoinicial = <cfif rsRepSalIni2020.Total gt 0>#rsRepSalIni2020.Total#
							 <cfelse>
							 0
							 </cfif>
		
		where SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaDes)#">
		  and SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHas)#">
		  and Ecodigo 	=  #session.Ecodigo#
		  and SNid =#rsRepSalIni2020.Socio#
	</cfquery>
	</cfloop>
	<!--- Fernando Alcaraz Cristobal.
		Termina la actualiza los saldos iniciales.
	--->

	<!---**************************************************************************************************************--->
	<!---**************************************************************************************************************--->
	<!--- Movimientos del Estado de Cuenta --->
	<cf_dbtemp name="TempMovimientos_v1" returnvariable="movimientos" datasource="#session.dsn#">
		<cf_dbtempcol name="id"  				type="numeric" 		mandatory="no" identity>
		<cf_dbtempcol name="Ecodigo"  			type="integer" 		mandatory="no">
		<cf_dbtempcol name="SNnumero"  			type="char(20)" 	mandatory="no">
		<cf_dbtempcol name="Socio"  			type="integer"	 	mandatory="no">
		<cf_dbtempcol name="Moneda"  			type="integer" 		mandatory="no">
		<cf_dbtempcol name="IDdireccion"  		type="numeric" 		mandatory="no">
		<cf_dbtempcol name="Ocodigo"   			type="integer"  	mandatory="no">
		<cf_dbtempcol name="Control"   			type="integer"  	mandatory="no">
		<cf_dbtempcol name="TTransaccion"		type="char(2)" 		mandatory="no">
		<cf_dbtempcol name="Documento" 			type="char(100)" 	mandatory="no">
		<cf_dbtempcol name="Fecha"				type="datetime" 	mandatory="no">
		<cf_dbtempcol name="FechaVencimiento"	type="datetime"		mandatory="no">
		<cf_dbtempcol name="Total"				type="money"		mandatory="no">
		<cf_dbtempcol name="TotalOri"			type="money"		mandatory="no">
	    <cf_dbtempcol name="Tcambio"			type="money"		mandatory="no">
		<cf_dbtempcol name="Saldo"				type="money" 		mandatory="no">
		<cf_dbtempcol name="Pago"				type="integer" 		mandatory="no">
		<cf_dbtempcol name="TReferencia"		type="char(2)" 		mandatory="no">
		<cf_dbtempcol name="DReferencia"		type="char(20)" 	mandatory="no">
		<cf_dbtempcol name="Ordenamiento"		type="char(20)" 	mandatory="no">
		<cf_dbtempcol name="SNid"				type="numeric" 		mandatory="no">
		<cf_dbtempcol name="TRgroup"			type="char(10)"		mandatory="no">
		<cf_dbtempcol name="Oficodigo"			type="char(10)"		mandatory="no">
		<cf_dbtempcol name="CPTdescripcion"		type="varchar(80)"	mandatory="no">
		<cf_dbtempcol name="CPTtipo"			type="char(1)"		mandatory="no">
		<cf_dbtempkey cols="id">
	</cf_dbtemp>


	<!--- /* insertar los saldos iniciales del socio */ --->
	<cfquery name="rsMovimientos1" datasource="#session.DSN#">
		insert into #movimientos#
		(
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			IDdireccion,
			Ocodigo,
			Control,
			TTransaccion,
			Documento,
			Fecha,
			Total,
			TotalOri,
			Tcambio,
			Saldo,
			Pago, TReferencia,
			DReferencia,
			Ordenamiento,
			SNid,
			TRgroup,
			Oficodigo,
			CPTdescripcion
		)
		select
			s.Ecodigo,
			s.SNcodigo,
			s.SNnumero,
			si.Mcodigo,
			s.id_direccion,
			-1 as Oficina,
			1 as Control,
			' ' as TTransaccion,
			' #LB_SaldoIni# ' as Documento,
			<cf_dbfunction name="dateadd" args="-1, #LSParseDateTime(url.fechaDes)#"> as Fecha,
			sum(SIsaldoinicial) as Total,
			sum(SIsaldoinicial) as Totalori,
			si.Tcambio,
			0.00 as Saldo,
			0 as Pago,
			' ' as TReferencia,
			' ' as DReferencia,
			' ' as Ordenamiento,
			s.SNid as SNid,
			' ' as TRgroup,
			' ' as Oficodigo,
			' #LB_SaldoIni# ' as CPTdescripcion
		from #socios# s
		inner join #SaldosIniciales# si
			on si.SNid = s.SNid
			and si.SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
			and si.SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
		group by s.Ecodigo,
			s.SNid,
			si.Mcodigo,
			s.SNcodigo,
			si.Tcambio,
			s.SNnumero,
			s.id_direccion
	</cfquery>

	<cfquery name="rsMovimientos2" datasource="#session.DSN#">
		insert into #movimientos# (
			SNid,
			IDdireccion,
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			Ocodigo,
			Control,
			Total,
			TotalOri,
			Tcambio,
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			CPTtipo,
			FechaVencimiento
		)
		<!--- Todos los documentos --->
		select
			s.SNid,
			s.id_direccion,
			do.Dfecha,
			do.CPTcodigo,
			do.Ddocumento,
			s.Ecodigo,
			s.SNcodigo,
			s.SNnumero,
			do.Mcodigo,
			do.Ocodigo as Oficina,
			2 as Control,
			case when t.CPTtipo = 'C' then do.Dtotal*do.Dtipocambio else -do.Dtotal*do.Dtipocambio end as Total,
			case when t.CPTtipo = 'C' then do.Dtotal else -do.Dtotal end as Totalori,
			do.Dtipocambio as Tcambio,
			case when t.CPTtipo = 'C' then do.Dtotal else -do.Dtotal end as Saldo,
			0 as Pago,
			do.CPTcodigo as TReferencia,
			do.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			do.CPTcodigo as TRgroup,
			o.Oficodigo as Oficodigo,
			t.CPTdescripcion as CPTdescripcion,
			t.CPTtipo as CPTtipo,
			do.Dfechavenc

		from #socios# s
			inner join HEDocumentosCP do
				 on do.SNcodigo = s.SNcodigo
				and do.Ecodigo = s.Ecodigo
			inner join CPTransacciones t
				on t.CPTcodigo = do.CPTcodigo
				and t.Ecodigo = do.Ecodigo
			inner join Oficinas o
				 on o.Ecodigo = do.Ecodigo
				and o.Ocodigo = do.Ocodigo
		where do.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
	</cfquery>

	<!---CASO ESPECIAL, CUANDO SE APLICA UN PAGO O UN DOCUMENTO A FAVOR ANTERIOR A LA FECHA DESDE
	 ABG 20141013--->
	<!---Para Facturas--->
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #movimientos#
		set Total = Total -
			coalesce((
				select sum(BMmontoref*Dtipocambio)
				from BMovimientosCxP bm
					inner join CPTransacciones t
							on t.Ecodigo = bm.Ecodigo
							and t.CPTcodigo = bm.CPTcodigo
							and t.CPTtipo = 'D'
				where bm.Ecodigo = #movimientos#.Ecodigo
				  and bm.CPTRcodigo = #movimientos#.TTransaccion
				  and bm.DRdocumento = #movimientos#.Documento
				  and bm.SNcodigo    = #movimientos#.Socio
				  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				  and bm.Dfecha < #movimientos#.Fecha
				  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00),
			Saldo = Saldo -
			coalesce((
				select sum(BMmontoref*Dtipocambio)
				from BMovimientosCxP bm
					inner join CPTransacciones t
							on t.Ecodigo = bm.Ecodigo
							and t.CPTcodigo = bm.CPTcodigo
							and t.CPTtipo = 'D'
				where bm.Ecodigo = #movimientos#.Ecodigo
				  and bm.CPTRcodigo = #movimientos#.TTransaccion
				  and bm.DRdocumento = #movimientos#.Documento
				  and bm.SNcodigo    = #movimientos#.Socio
				  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				  and bm.Dfecha < #movimientos#.Fecha
				  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00)
		where #movimientos#.CPTtipo = 'C'
		  and #movimientos#.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
	</cfquery>

<!--- Actualizacion de Tipo NE --->
<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #movimientos#
		set Total = Total -
			coalesce((
				select sum(BMmontoref*Dtipocambio)
				from BMovimientosCxP bm
				where bm.Ecodigo = #movimientos#.Ecodigo
				  and bm.CPTcodigo = 'NE'
				  and bm.CPTRcodigo = #movimientos#.TTransaccion
				  and bm.DRdocumento = #movimientos#.Documento
				  and bm.SNcodigo    = #movimientos#.Socio
				  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				  and bm.Dfecha < #movimientos#.Fecha
				  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00),
			Saldo = Saldo -
			coalesce((
				select sum(BMmontoref*Dtipocambio)
				from BMovimientosCxP bm
				where bm.Ecodigo = #movimientos#.Ecodigo
				  and bm.CPTcodigo = 'NE'
				  and bm.CPTRcodigo = #movimientos#.TTransaccion
				  and bm.DRdocumento = #movimientos#.Documento
				  and bm.SNcodigo    = #movimientos#.Socio
				  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				  and bm.Dfecha < #movimientos#.Fecha
				  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00)
		where #movimientos#.CPTtipo = 'C'
		  and #movimientos#.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
	</cfquery>

	<!---
		Documentos tipo "Credito", se hace el join por las columnas Ecodigo, CPTcodigo, DDocumento
		Las aplicaciones de los documentos de credito se hacen a documentos de debito - de ahí el join con CPTransacciones t2
	--->
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #movimientos#
		set Total = Total + coalesce((
			select sum(BMmontoref*Dtipocambio)
			from BMovimientosCxP bm
				inner join CPTransacciones t
						on t.Ecodigo = bm.Ecodigo
						and t.CPTcodigo = bm.CPTRcodigo
						and t.CPTtipo = 'C'
			where bm.Ecodigo = #movimientos#.Ecodigo
			  and bm.CPTcodigo = #movimientos#.TTransaccion
			  and bm.Ddocumento = #movimientos#.Documento
			  and bm.SNcodigo    = #movimientos#.Socio
			  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
			  and bm.Dfecha < #movimientos#.Fecha
			  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00),
			Saldo = Saldo + coalesce((
			select sum(BMmontoref*Dtipocambio)
			from BMovimientosCxP bm
				inner join CPTransacciones t
						on t.Ecodigo = bm.Ecodigo
						and t.CPTcodigo = bm.CPTRcodigo
						and t.CPTtipo = 'C'
			where bm.Ecodigo = #movimientos#.Ecodigo
			  and bm.CPTcodigo = #movimientos#.TTransaccion
			  and bm.Ddocumento = #movimientos#.Documento
			  and bm.SNcodigo    = #movimientos#.Socio
			  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
			  and bm.Dfecha < #movimientos#.Fecha
			  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
			) , 0.00)
		where #movimientos#.CPTtipo = 'D'
		  and #movimientos#.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
	</cfquery>

	<!--- /* Recibos de Dinero */ --->
<!--- <cf_dumptable var="#movimientos#"> --->
	<cfquery name="rsMovimientos3" datasource="#session.DSN#">
		insert into #movimientos# (
			SNid,
			IDdireccion,
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			Ocodigo,
			Control,
			Total,
			TotalOri,
			Tcambio,
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento
		)

		select
			s.SNid,
			s.id_direccion,
			bm.Dfecha,
			bm.CPTcodigo,
			bm.Ddocumento,
			min(s.Ecodigo),
			min(s.SNcodigo),
			min(s.SNnumero),
			do.Mcodigo,
			min(do.Ocodigo) as Oficina,
			2 as Control,
			sum(bm.Dtotal * case when t.CPTtipo='D' then -1.00 else 1.00 end) TotalORi, <!--- sum(bm.BMmontoref * case when t.CPTtipo='D' then -1.00 else 1.00 end) Total, --->
			sum((bm.Dtotal*bm.Dtipocambio) * case when t.CPTtipo='D' then -1.00 else 1.00 end) as Total, 
			bm.Dtipocambio as Tcambio,
			0.00 as Saldo,
			1 as Pago,
			min(t.CPTcodigo) as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			bm.CPTcodigo as TRgroup,
			min(o.Oficodigo) as Oficodigo,
			min(t.CPTdescripcion) as CPTdescripcion,
			bm.Dfecha
		from #socios# s
			inner join CPTransacciones t
				 on t.Ecodigo = s.Ecodigo
				and t.CPTpago = 1

			inner join BMovimientosCxP bm
				 on bm.SNcodigo   = s.SNcodigo
				and bm.CPTcodigo  = t.CPTcodigo
				and bm.Ecodigo    = t.Ecodigo
				and bm.Ecodigo    = s.Ecodigo
				and bm.Dfecha     >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				and bm.Dfecha     <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">

			inner join HEDocumentosCP do
				 on do.SNcodigo   = bm.SNcodigo
				and do.Ecodigo    = bm.Ecodigo
				and do.CPTcodigo  = bm.CPTRcodigo
				and do.Ddocumento = bm.DRdocumento

			inner join Oficinas o
				 on o.Ecodigo = do.Ecodigo
				and o.Ocodigo = do.Ocodigo
		group by
			s.SNid,
			s.id_direccion,
			bm.Dfecha,
			bm.CPTcodigo,
			bm.Ddocumento,
			bm.Dtipocambio ,
			do.Mcodigo,
			bm.Ddocumento,
			bm.CPTcodigo,
			bm.Dfecha
	</cfquery>
	<!--- Lineas de Retenciones--->
	<cfquery name="rsMovimientos44" datasource="#session.DSN#">
		insert into #movimientos# (
			SNid,
			IDdireccion,
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			Ocodigo,
			Control,
			Total,
			TotalOri,
			Tcambio,
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento
		)

		select
			s.SNid,
			s.id_direccion,
			bm.Dfecha,
			bm.CPTcodigo,
			bm.Ddocumento,
			min(s.Ecodigo),
			min(s.SNcodigo),
			min(s.SNnumero),
			do.Mcodigo,
			min(do.Ocodigo) as Oficina,
			2 as Control,

			sum(round(
			-1.0 * bm.Dtotal / (do.Dtotal-isnull(do.EDmontoretori,0) )
			* coalesce(dd.DDmonto, 0)
			* case when rd.Rporcentaje is not null then rd.Rporcentaje else r.Rporcentaje end / 100
			+ coalesce(case
							when rd.Rcodigo is not null then
								case
									when rd.isVariable = 1 then coalesce(do.EDretencionVariable,0)
									else 0
								end
							else
								case
									when r.isVariable = 1 then coalesce(do.EDretencionVariable,0)
									else 0
								end
							end,0)
							,4,1)) as Total,
			sum(round(
			-1.0 * bm.Dtotal / (do.Dtotal-isnull(do.EDmontoretori,0) )
			* coalesce(dd.DDmonto, 0)
			* case when rd.Rporcentaje is not null then rd.Rporcentaje else r.Rporcentaje end / 100
			+ coalesce(case
							when rd.Rcodigo is not null then
								case
									when rd.isVariable = 1 then coalesce(do.EDretencionVariable,0)
									else 0
								end
							else
								case
									when r.isVariable = 1 then coalesce(do.EDretencionVariable,0)
									else 0
								end
							end,0)
							,4,1))*bm.Dtipocambio as TotalOri,
			bm.Dtipocambio as Tcambio,
			0.00 as Saldo,
			1 as Pago,
			min(t.CPTcodigo) as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			'Retencion' as TRgroup,
			min(o.Oficodigo) as Oficodigo,
			min('Retencion') as CPTdescripcion,
			bm.Dfecha
		from #socios# s
			inner join CPTransacciones t
				 on t.Ecodigo = s.Ecodigo
				and t.CPTpago = 1
			inner join BMovimientosCxP bm
				 on bm.SNcodigo   = s.SNcodigo
				and bm.CPTcodigo  = t.CPTcodigo
				and bm.Ecodigo    = t.Ecodigo
				and bm.Ecodigo    = s.Ecodigo
				and bm.Dfecha     >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				and bm.Dfecha     <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">

			inner join HEDocumentosCP do
				 on do.SNcodigo   = bm.SNcodigo
				and do.Ecodigo    = bm.Ecodigo
				and do.CPTcodigo  = bm.CPTRcodigo
				and do.Ddocumento = bm.DRdocumento

			outer apply (select sum(h.DDtotallin-h.DDdescdoc) as DDmonto 			
							from HDDocumentosCP h
							left join Impuestos i 
							on i.Ecodigo = h.Ecodigo 
							and i.Icodigo = h.Icodigo
							where h.IDdocumento = do.IDdocumento
							and coalesce(i.InoRetencion,0) <> 1
							)dd

			inner join Oficinas o
				 on o.Ecodigo = do.Ecodigo
				and o.Ocodigo = do.Ocodigo

			inner join Retenciones r
				on r.Ecodigo = do.Ecodigo
				and r.Rcodigo = do.Rcodigo

			left join RetencionesComp rc
				on rc.Ecodigo = r.Ecodigo
				and rc.Rcodigo = r.Rcodigo

			left join Retenciones rd
				on rd.Ecodigo = rc.Ecodigo
				and rd.Rcodigo = rc.RcodigoDet

		group by
			s.SNid,
			s.id_direccion,
			bm.Dfecha,
			bm.CPTcodigo,
			bm.Ddocumento,
			bm.Dtipocambio ,
			do.Mcodigo,
			bm.Ddocumento,
			bm.CPTcodigo,
			bm.Dfecha
	</cfquery>
	<!---Termina Lineas de Retenciones--->
	<!--- Lineas de Ajuste Diferencial cambiario--->

	<cfquery name="rsMovimientos45" datasource="#session.DSN#">
		insert into #movimientos# (
			SNid,
			IDdireccion,
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			Ocodigo,
			Control,
			Total,
			TotalOri,
			Tcambio,
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento
		)
		select
			s.SNid,
			s.id_direccion,
			bm.Dfecha,
			bm.CPTcodigo,
			bm.Ddocumento,
			s.Ecodigo,
			s.SNcodigo,
			s.SNnumero,
			do.Mcodigo,
			do.Ocodigo as Oficina,
			2 as Control,
			case when hdc.Dmovimiento = 'D' 
				then -hdc.Dlocal
				else hdc.Dlocal
			end as Total,
			case when hdc.Dmovimiento = 'D' 
				then -hdc.Dlocal
				else hdc.Dlocal
			end as TotalOri,
			1 as Tcambio,
			0.00 as Saldo,
			1 as Pago,
			1 as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			'Dif.Camb.' as TRgroup,
			o.Oficodigo as Oficodigo,
			'Dif.Camb.' as CPTdescripcion,
			bm.Dfecha
		from #socios# s
			inner join BMovimientosCxP bm
				 on bm.SNcodigo   = s.SNcodigo
				and bm.Ecodigo    = s.Ecodigo
				and bm.Dfecha     >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				and bm.Dfecha     <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
				and bm.CPTcodigo = 'FC'
			inner join HEDocumentosCP do
				 on do.SNcodigo   = bm.SNcodigo
				and do.Ecodigo    = bm.Ecodigo
				and do.CPTcodigo  = bm.CPTRcodigo
				and do.Ddocumento = bm.DRdocumento
				and do.Dtipocambio <> 1
			inner join 
			  (SELECT hcd.Dlocal,hcd.Dreferencia as Hdocumento,hcd.Ddescripcion, hce.Efecha,hcd.Dmovimiento
			   FROM HDContables hcd
			   INNER JOIN HEContables hce 
			   ON hce.IDcontable =hcd.IDcontable
			   AND hce.Ecodigo = hcd.Ecodigo
			   WHERE hcd.Ddescripcion LIKE '%Ajuste Diferencial Cambiario Documento:%'
			     AND hcd.Dlocal > 0
			   UNION 
			   SELECT hcd.Dlocal, hcd.Ddocumento as Hdocumento,hcd.Ddescripcion, hce.Efecha,hcd.Dmovimiento
			   FROM HDContables hcd
			   INNER JOIN HEContables hce 
			   ON hce.IDcontable =hcd.IDcontable
			   AND hce.Ecodigo = hcd.Ecodigo
			   WHERE hcd.Ddescripcion LIKE '%TES: Diferencial Cambiario%'
			     AND hcd.Dlocal > 0)hdc
			on  hdc.Hdocumento = do.Ddocumento
			inner join Oficinas o
				 on o.Ecodigo = do.Ecodigo
				and o.Ocodigo = do.Ocodigo
		where  hdc.Dlocal > 0
		
	</cfquery>
	<!--- <cf_dump var="#rsMovimientos45#">  --->
	<!---Termina Lineas de Diferencial cambiario--->

	<cfquery name="rsMovimientos5" datasource="#session.DSN#">
		<!--- Notas de Credito aplicada a documentos de otros socios --->

		insert into #movimientos# (
			SNid,
			IDdireccion,
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			Ocodigo,
			Control,
			Total,
			TotalOri,
			Tcambio,
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento
		)


		select
			s.SNid,
			s.id_direccion,
			min(bm.Dfecha) as Fecha,
			bm.CPTcodigo,
			<cf_dbfunction name="concat" args="'APLIC.',bm.CPTcodigo,'-',rtrim(bm.Ddocumento),'/',bm.CPTRcodigo,'-',ltrim(rtrim(bm.DRdocumento))">,
			min(s.Ecodigo),
			min(s.SNcodigo),
			min(s.SNnumero),
			hd.Mcodigo,
			min(hd.Ocodigo) as Oficina,
			2 as Control,
			sum(-bm.Dtotal*bm.Dtipocambio) as Total,
			sum(-bm.Dtotal) as TotalOri,
			bm.Dtipocambio as Tcambio,
			0.00 as Saldo,
			1 as Pago,
			min(t.CPTcodigo) as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			bm.CPTcodigo as TRgroup,
			min(o.Oficodigo) as Oficodigo,
			min(t.CPTdescripcion) as CPTdescripcion,
			min(bm.Dfecha) as FechaVencimiento

		from #socios# s
			inner join HEDocumentosCP hd
				on hd.SNcodigo = s.SNcodigo
				and hd.Ecodigo = s.Ecodigo

			inner join CPTransacciones t
				on t.CPTcodigo = hd.CPTcodigo
				and t.Ecodigo = hd.Ecodigo
				and t.CPTtipo = 'D'

			inner join BMovimientosCxP bm
				on bm.Ecodigo = hd.Ecodigo
				and bm.CPTcodigo  = hd.CPTcodigo
				and bm.Ddocumento = hd.Ddocumento
				and bm.SNcodigo   = hd.SNcodigo

			inner join HEDocumentosCP hd2
				on hd2.Ecodigo = bm.Ecodigo
				and hd2.CPTcodigo = bm.CPTRcodigo
				and hd2.Ddocumento = bm.DRdocumento
				and hd2.SNcodigo   = bm.SNcodigo

			inner join Oficinas o
				on o.Ecodigo = hd.Ecodigo
				and o.Ocodigo = hd.Ocodigo

		where hd2.SNcodigo <> hd.SNcodigo                    <!---Socios Diferentes--->
		  and bm.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">

		group by
			s.SNid,
			s.id_direccion,
			bm.CPTcodigo,
			bm.Dtipocambio ,
			<cf_dbfunction name="concat" args="'APLIC.',bm.CPTcodigo,'-',rtrim(bm.Ddocumento),'/',bm.CPTRcodigo,'-',ltrim(rtrim(bm.DRdocumento))">,
			hd.Mcodigo,
			bm.Ddocumento,
			bm.CPTcodigo
	</cfquery>

	<cfquery name="rsMovimientos6" datasource="#session.DSN#">
		<!--- Notas de Credito de otros socios aplicadas a documentos del socios del estado de cuenta --->
		insert into #movimientos# (
			SNid,
			IDdireccion,
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			Ocodigo,
			Control,
			Total,
			TotalOri,
			Tcambio,
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento
		)
		select
			s.SNid,
			s.id_direccion,
			min(bm.Dfecha) as Fecha,
			bm.CPTcodigo,
			<cf_dbfunction name="concat" args="'APLIC.',bm.CPTRcodigo,'-',rtrim(bm.DRdocumento),'/',bm.CPTcodigo,'-',ltrim(rtrim(bm.Ddocumento))">as Documento,
			min(s.Ecodigo),
			min(s.SNcodigo),
			min(s.SNnumero),
			hd.Mcodigo,
			min(hd.Ocodigo) as Oficina,
			2 as Control,
			sum(bm.Dtotal*bm.Dtipocambio) Total,
			sum(-bm.Dtotal) as TotalOri,
			bm.Dtipocambio as Tcambio,
			0.00 as Saldo,
			1 as Pago,
			min(t.CPTcodigo) as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			bm.CPTcodigo as TRgroup,
			min(o.Oficodigo) as Oficodigo,
			min(t.CPTdescripcion) as CPTdescripcion,
			min(bm.Dfecha) as FechaVencimiento

		from #socios# s
			inner join HEDocumentosCP hd
				on hd.SNcodigo = s.SNcodigo
				and hd.Ecodigo = s.Ecodigo

			inner join CPTransacciones t
				on t.CPTcodigo = hd.CPTcodigo
				and t.Ecodigo = hd.Ecodigo
				and t.CPTtipo = 'C'

			inner join BMovimientosCxP bm
				on bm.Ecodigo = hd.Ecodigo
				and bm.CPTRcodigo  = hd.CPTcodigo
				and bm.DRdocumento = hd.Ddocumento
				and bm.SNcodigo    = hd.SNcodigo

			inner join HEDocumentosCP hd2
				on hd2.Ecodigo = bm.Ecodigo
				and hd2.CPTcodigo = bm.CPTcodigo
				and hd2.Ddocumento = bm.Ddocumento
				and hd2.SNcodigo   = bm.SNcodigo

			inner join Oficinas o
				on o.Ecodigo = hd.Ecodigo
				and o.Ocodigo = hd.Ocodigo
		where hd2.SNcodigo <> hd.SNcodigo   				 <!---Socios Diferentes--->
		  and bm.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
			group by
			s.SNid,
			s.id_direccion,
			bm.CPTcodigo,
			bm.Dtipocambio ,
			<cf_dbfunction name="concat" args="'APLIC.',bm.CPTRcodigo,'-',rtrim(bm.DRdocumento),'/',bm.CPTcodigo,'-',ltrim(rtrim(bm.Ddocumento))">,
			hd.Mcodigo,
			bm.Ddocumento,
			bm.CPTcodigo

	</cfquery>
<!--- <cf_dumptable name="#movimientos#"> --->
	 <!--- ************************************ --->
	 <!--- ************** NETEOS ************** --->

	<cfset LvarTransNeteo = "">
	<cfquery name="rsTranNeteo" datasource="#session.dsn#">
		select CCTcodigo
		from  CCTransacciones tn
		where tn.Ecodigo      = #session.Ecodigo#
		and tn.CCTtranneteo = 1
	</cfquery>
	<cfif rsTranNeteo.recordcount EQ 1>
		<cfset LvarTransNeteo = "and m.CPTcodigo = '#rsTranNeteo.CCTcodigo#'">
	<cfelseif rsTranNeteo.recordcount GT 1>
		<cfloop query="rsTranNeteo">
			<cfset LvarTransNeteo = trim(LvarTransNeteo) & ", '#rsTranNeteo.CCTcodigo#'">
		</cfloop>
		<cfset LvarTransNeteo = "and m.CPTcodigo in (" & trim(mid(LvarTransNeteo, 3, 255)) & ")">
	</cfif>

	 <!--- 
	<cfquery name="rsMovimientos7" datasource="#session.DSN#">
		<!--- Inclusion de Documentos de Neteo --->
		insert into #movimientos# (
			SNid,
			IDdireccion,
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			Ocodigo,
			Control,
			Total,
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento
		)

select 		s.SNid,
			s.id_direccion,
			min(m.Dfecha) as Fecha,
			m.CPTcodigo,
			<cf_dbfunction name="concat" args="d.CPTcodigo,' ',rtrim(d.Ddocumento),' (Aplic.Neteo ',rtrim(m.Ddocumento),')'">as Documento,
			min(s.Ecodigo),
			min(s.SNcodigo),
			min(s.SNnumero),
			d.Mcodigo,
			min(d.Ocodigo) as Oficina,
			2 as Control,
			sum(case when t.CCTtipo = 'C' then m.Dtotal*-1 else m.Dtotal end) as Total,
			0.00 as Saldo,
			1 as Pago,
			min(t.CCTcodigo) as TReferencia,
			m.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			m.CPTcodigo as TRgroup,
			(( select min(o.Oficodigo) from Oficinas o where o.Ecodigo = d.Ecodigo and o.Ocodigo = d.Ocodigo)) as Oficodigo,
			min(t.CCTdescripcion) as CPTdescripcion,
			min(m.Dfecha) as FechaVencimiento

		from 	BMovimientosCxP m

			inner join CCTransacciones t
			on  t.Ecodigo   = m.Ecodigo
			and t.CCTcodigo = m.CPTcodigo

			inner join HEDocumentosCP d
			on  d.Ddocumento = m.DRdocumento
			and d.CPTcodigo  = m.CPTRcodigo
			and d.Ecodigo    = m.Ecodigo
			and d.SNcodigo   = m.SNcodigo

			inner join #socios# s
				on d.SNcodigo = s.SNcodigo
				and d.Ecodigo = s.Ecodigo

		where   m.Dfecha     >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
		  and   m.Dfecha     <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
		  and   m.Ecodigo    =  #session.Ecodigo#
		  and   m.Dfecha
					between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				    	and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
		  and   m.CPTcodigo  <> m.CPTRcodigo
		  #PreserveSingleQuotes(LvarTransNeteo)#
		group by
			s.SNid,
			s.id_direccion,
			m.CPTcodigo,
			d.CPTcodigo,
			d.Ddocumento,
			m.Ddocumento,
			d.Mcodigo,
			d.Ecodigo,
			d.Ocodigo
	</cfquery>
--->
<!--- JARR 31/03/2020 se comento ya que por Reglas de NEgocio se definio que no se deben de ver estos registros --->
<!--- 	<cfquery name="rsMovimientos7" datasource="#session.DSN#">
		<!--- Inclusion de Documentos de Neteo --->
		insert into #movimientos# (
			SNid,
			IDdireccion,
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo,
			Socio,
			SNnumero,
			Moneda,
			Ocodigo,
			Control,
			Total,
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento
		)

select 		s.SNid,
			s.id_direccion,
			min(m.Dfecha) as Fecha,
			m.CPTcodigo,
			<cf_dbfunction name="concat" args="d.CPTcodigo,' ',rtrim(d.Ddocumento),' (Aplic.Neteo ',rtrim(m.Ddocumento),')'">as Documento,
			min(s.Ecodigo),
			min(s.SNcodigo),
			min(s.SNnumero),
			d.Mcodigo,
			min(d.Ocodigo) as Oficina,
			2 as Control,
			sum(case when t.CCTtipo = 'D' then m.Dtotal*-1 else m.Dtotal end) as Total,
			0.00 as Saldo,
			1 as Pago,
			min(t.CCTcodigo) as TReferencia,
			m.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			m.CPTcodigo as TRgroup,
			(( select min(o.Oficodigo) from Oficinas o where o.Ecodigo = d.Ecodigo and o.Ocodigo = d.Ocodigo)) as Oficodigo,
			min(t.CCTdescripcion) as CPTdescripcion,
			min(m.Dfecha) as FechaVencimiento

		from 	BMovimientosCxP m

			inner join CCTransacciones t
			on  t.Ecodigo   = m.Ecodigo
			and t.CCTcodigo = m.CPTcodigo

			inner join HEDocumentosCP d
			on  d.Ddocumento = m.DRdocumento
			and d.CPTcodigo  = m.CPTRcodigo
			and d.Ecodigo    = m.Ecodigo
			and d.SNcodigo   = m.SNcodigo

			inner join #socios# s
				on d.SNcodigo = s.SNcodigo
				and d.Ecodigo = s.Ecodigo

		where   m.Dfecha     >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
		  and   m.Dfecha     <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
		  and   m.Ecodigo    =  #session.Ecodigo#
		  and   m.Dfecha
					between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				    	and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
		  and   m.CPTcodigo  <> m.CPTRcodigo
		  and 	t.CCTtranneteo != 1
		  #PreserveSingleQuotes(LvarTransNeteo)#
		group by
			s.SNid,
			s.id_direccion,
			m.CPTcodigo,
			d.CPTcodigo,
			d.Ddocumento,
			m.Ddocumento,
			d.Mcodigo,
			d.Ecodigo,
			d.Ocodigo
	</cfquery> --->

	<!---**************************************************************************************************************--->
	<cfquery datasource="#session.DSN#">
		update #movimientos#
			set
				Oficodigo  = coalesce((select o.Oficodigo from Oficinas o where o.Ecodigo = #movimientos#.Ecodigo and o.Ocodigo = #movimientos#.Ocodigo ), '  '),
				CPTdescripcion = coalesce((select t.CPTdescripcion from CPTransacciones t where t.Ecodigo = #movimientos#.Ecodigo and t.CPTcodigo = #movimientos#.TTransaccion), '  ')			where Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
	</cfquery>

	<!--- reporte resumido por transacción --->
	<cfquery name="Request.rsReporte2" datasource="#session.DSN#" maxrows="5001">
		select
			sn.SNnumero as Socio,
			sn.id_direccion,
			Moneda,
			TTransaccion as tipo,
			CPTdescripcion  as CPTdescripcion,
			sum(Total) as Total,
			Mnombre
		from  #movimientos# m
			inner join Monedas mo
				on mo.Ecodigo = m.Ecodigo
				and mo.Mcodigo = m.Moneda
			inner join SNegocios sn
				on sn.Ecodigo = m.Ecodigo
				and sn.SNcodigo = m.Socio
		where Fecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
		group by
			sn.SNnumero,
			sn.id_direccion,
			Moneda,
			TTransaccion,
			CPTdescripcion,
			Mnombre,
			sn.SNnombre,
			sn.SNnumero
		having sum(Total) <> 0.00
		order by
			sn.SNnumero,
			Moneda,
			TTransaccion
	</cfquery>

<!--- <cf_dumptable name="#movimientos#"> --->
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
			select
				sn.SNnumero as Socio,
				sn.id_direccion,
				mo.Miso4217 as CodigoMoneda,
				mo.Mnombre as Mnombre,
				mo.Mcodigo as moneda,

				TRgroup as tipo,
				Documento as documento,
				Fecha as Fecha,
				FechaVencimiento as FechaVencimiento,
				m.Oficodigo as Oficodigo,
				m.CPTdescripcion as Transaccion,

				case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#"> and Total >= 0 then Total else 0.00 end as Creditos,
				case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#"> and Total < 0 then -Total else 0.00 end as Debitos,

				Total,
				<!---case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#"> and Total >= 0 then TotalOri else 0.00 end as Creditos,
				case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#"> and Total < 0 then -TotalOri else 0.00 end as TotalOri,--->
				case when m.Tcambio >= 1.1
					 then TotalOri 
					 else null end 
				TotalOri,
				m.Tcambio,
				coalesce(si.SIsaldoinicial, 0.00) as Saldo,
				coalesce(si.SIsinvencer, 0.00) as SinVencer,
				coalesce(si.SIcorriente, 0.00) as Corriente,
				coalesce(si.SIp1, 0.00) as P1,
				coalesce(si.SIp2, 0.00) as P2,
				coalesce(si.SIp3, 0.00) as P3,
				coalesce(si.SIp4, 0.00) as P4,
				coalesce(si.SIp5 + si.SIp5p, 0.00) as P5Plus,
				coalesce(si.SIp1 + si.SIp2 + si.SIp3 + si.SIp4 + si.SIp5 + si.SIp5p, 0.00) as Morosidad,

				sn.SNnumero as SNnumero,
				sn.SNidentificacion as SNidentificacion,
				sn.SNmontoLimiteCC as SNmontoLimiteCC,
				sn.SNtelefono as SNtelefono,
				sn.SNemail as SNemail,
				sn.SNnombre as SNnombre,
				ds.direccion1 as direccion1,
				ds.codPostal as codPosta,
				case when TRgroup = 'FC' then 1
					else 2
				end as SigTipo
			from #movimientos# m

			inner join Monedas mo
				 on mo.Ecodigo = m.Ecodigo
				and mo.Mcodigo = m.Moneda

			inner join SNegocios sn
				 on sn.Ecodigo = m.Ecodigo
				and sn.SNcodigo = m.Socio

			 inner join DireccionesSIF ds
				on ds.id_direccion = sn.id_direccion

			left outer join #SaldosIniciales# si
				 on si.SNid = m.SNid
				 and si.Mcodigo = m.Moneda
				 and si.id_direccion = m.IDdireccion
				 and si.SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				 and si.SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">

		order by 
				sn.SNnumero,
				sn.id_direccion,
				mo.Mcodigo,
				mo.Mnombre,
				mo.Miso4217,
				m.Ocodigo,
			    Fecha,
				Documento,
				SigTipo,
				m.Dreferencia
	</cfquery>
	<!--- <cf_dump var="#rsReporte#"> --->
    <cfoutput>
	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 10000>
       	<cfset MSG_GeneraMas10000 = t.Translate('MSG_GeneraMas10000','Se han generado mas de 10000 registros para este reporte.')>
		<cf_errorCode	code = "50196" msg = "#MSG_GeneraMas10000#">
		<cfabort>
	</cfif>
		<cfif isdefined("Request.rsReporte2") and Request.rsReporte2.recordcount gt 10000>
       	<cfset MSG_GenMas10000Sub = t.Translate('MSG_GenMas10000Sub','Se han generado mas de 10000 registros en el subreporte.')>
		<cf_errorCode	code = "50347" msg = "#MSG_GenMas10000Sub#">
		<cfabort>
	</cfif>
	</cfoutput>
 <!--- Busca nombre del Socio de Negocios 1 --->
	 <cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
		<cfquery name="rsSNcodigo" datasource="#session.DSN#">
			select SNnombre, SNnumero, SNidentificacion, SNmontoLimiteCC, b.Mnombre, a.id_direccion, SNtelefono, SNemail
			from SNegocios a
				inner join Monedas b
					on b.Ecodigo = a.Ecodigo
					and b.Mcodigo = a.Mcodigo
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
			and a.Ecodigo =   #session.Ecodigo#
		</cfquery>
		<cfquery name="rsDireccionesSif" datasource="#session.DSN#">
			select direccion1, codPostal
			from DireccionesSIF
			where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNcodigo.id_direccion#">
		</cfquery>
	</cfif>

	<!--- Busca el nombre de la Empresa --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo =  #session.Ecodigo#
	</cfquery>

	 <cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	</cfif>
	<!--- Invocación del reporte --->

	<!--- <cf_Dump var="#rsReporte#"> --->
<cfset LB_Hora 	= t.Translate('LB_Hora','Hora')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset TIT_EdoCta 	= t.Translate('TIT_EdoCta','Estado de Cuenta del Socio de Negocios')>
<cfset LB_Codigo 	= t.Translate('LBR_CODIGO','Código','/sif/generales.xml')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificación','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset LB_Direccion = t.Translate('LB_Direccion','Dirección:','/sif/generales.xml')>
<cfset LB_Telefono 	= t.Translate('LB_Telefono','Teléfono','/sif/generales.xml')>
<cfset LB_Apartado 	= t.Translate('LB_Apartado','Apartado')>
<cfset LB_LimCred	= t.Translate('LB_LimCred','Límite Crédito')>
<cfset LB_EdoCta 	= t.Translate('LB_EdoCta','Estado de Cuenta')>
<cfset LB_Del 	= t.Translate('LB_Del','Del')>
<cfset LB_al 	= t.Translate('LB_al','al')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Ref = t.Translate('LB_Ref','Ref.')>
<cfset LB_FecVenc = t.Translate('LB_FecVenc','Fecha Venc.')>
<cfset LB_Sucursal = t.Translate('LB_Sucursal','Sucursal')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset LB_Debitos = t.Translate('LB_Debitos','Debitos')>
<cfset LB_Creditos = t.Translate('LB_Creditos','Créditos')>
<cfset LB_AnaSaldo = t.Translate('LB_AnaSaldo','Análisis de Saldo')>
<cfset LB_VencSaldo = t.Translate('LB_VencSaldo','Vencimiento de Saldo')>
<cfset LB_Corriente = t.Translate('LB_Corriente','Corriente')>
<cfset LB_SinVenc = t.Translate('LB_SinVenc','Sin Vencer')>
<cfset LB_De = t.Translate('LB_De','De')>
<cfset LB_a = t.Translate('LB_a','a')>
<cfset LB_omas = t.Translate('LB_omas','o mas')>
<cfset LB_Morosidad = t.Translate('LB_Morosidad','Morosidad')>
<cfset LB_Tipo = t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset Descripcion = t.Translate('Descripcion','Descripción','/sif/generales.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_MontoL = t.Translate('LB_Monto','Monto Origen','/sif/generales.xml')>


  	<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>

    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 AND formatos EQ "excel">
	  <cfset typeRep = 1>
	 <!---  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif> --->
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cp.consultas.reportes.Estado_Cuenta_ClienteCP"/>
	<cfelse>

		<cfreport format="#formatos#" template="Estado_Cuenta_ClienteCP.cfr" query="rsReporte">
					<cfreportparam name="TIT_EdoCta" 	value="#TIT_EdoCta#">
					<cfreportparam name="LB_Fecha" 		value="#LB_Fecha#">
					<cfreportparam name="LB_Hora" 		value="#LB_Hora#">
					<cfreportparam name="LB_Codigo" 	value="#LB_Codigo#">
					<cfreportparam name="LB_LimCred" 	value="#LB_LimCred#">
					<cfreportparam name="LB_SocioNegocio" 	value="#LB_SocioNegocio#">
					<cfreportparam name="LB_De" 		value="#LB_De#">
					<cfreportparam name="LB_a" 			value="#LB_a#">
					<cfreportparam name="LB_Telefono" 	value="#LB_Telefono#">
					<cfreportparam name="LB_Direccion" 	value="#LB_Direccion#">
					<cfreportparam name="LB_Apartado" 	value="#LB_Apartado#">
					<cfreportparam name="LB_Moneda" 	value="#LB_Moneda#">
					<cfreportparam name="LB_Documento" 	value="#LB_Documento#">
					<cfreportparam name="LB_Ref" 		value="#LB_Ref#">
					<cfreportparam name="LB_FecVenc" 	value="#LB_FecVenc#">
					<cfreportparam name="LB_Sucursal" 	value="#LB_Sucursal#">
					<cfreportparam name="LB_Del" 		value="#LB_Del#">
					<cfreportparam name="LB_al" 		value="#LB_al#">
					<cfreportparam name="LB_EdoCta" 	value="#LB_EdoCta#">
					<cfreportparam name="LB_Debitos" 	value="#LB_Debitos#">
					<cfreportparam name="LB_Saldo" 		value="#LB_Saldo#">
					<cfreportparam name="LB_Creditos" 	value="#LB_Creditos#">
					<cfreportparam name="LB_AnaSaldo" 	value="#LB_AnaSaldo#">
					<cfreportparam name="LB_VencSaldo" 	value="#LB_VencSaldo#">
					<cfreportparam name="LB_Corriente" 	value="#LB_Corriente#">
					<cfreportparam name="LB_SinVenc" 	value="#LB_SinVenc#">
					<cfreportparam name="LB_Tipo" 		value="#LB_Tipo#">
					<cfreportparam name="Descripcion" 	value="#Descripcion#">
					<cfreportparam name="LB_Monto" 		value="#LB_Monto#">
					<cfreportparam name="LB_MontoL" 		value="#LB_MontoL#">
					<cfreportparam name="LB_Identificacion" 	value="#LB_Identificacion#">
					<cfreportparam name="LB_omas" 		value="#LB_omas#">
					<cfreportparam name="LB_Morosidad" 	value="#LB_Morosidad#">

			<cfif isdefined("rsSNCEid") and rsSNCEid.recordcount gt 0>
				<cfreportparam name="SNCEdescripcion" value="#rsSNCEid.SNCEdescripcion#">
			</cfif>

			<cfif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
				<cfreportparam name="fechaDes" value="#LSDateFormat(url.fechaDes,"DD/MM/YYYY")#">
			</cfif>
			<cfif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				<cfreportparam name="fechaHas" value="#LSDateFormat(url.fechaHas,"DD/MM/YYYY")#">
			</cfif>

			<cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
				<cfreportparam name="SNcodigo" value="#rsSNcodigo.SNnombre#">
				<cfreportparam name="SNtelefono" value="#rsSNcodigo.SNtelefono#">
				<cfreportparam name="SNemail" value="#rsSNcodigo.SNemail#">
			</cfif>
			<cfif isdefined("rsDireccionesSif") and rsDireccionesSif.recordcount gt 0>
				<cfreportparam name="direccion1" value="#rsDireccionesSif.direccion1#">
				<cfreportparam name="codPostal" value="#rsDireccionesSif.codPostal#">
			</cfif>

			<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
				<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
			</cfif>

			<cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
				<cfreportparam name="Numero" value="#rsSNcodigo.SNnumero#">
				<cfreportparam name="Identificacion" value="#rsSNcodigo.SNidentificacion#">
				<cfreportparam name="Nombre" value="#rsSNcodigo.SNnombre#">
				<cfif len(trim(rsSNcodigo.SNmontolimiteCC))>
					<cfreportparam name="LimiteCredito" value="#rsSNcodigo.SNmontoLimiteCC#">
				<cfelse>
					<cfreportparam name="LimiteCredito" value="0">
				</cfif>
				<cfif len(trim(rsSNcodigo.Mnombre))>
					<cfreportparam name="Mnombre" value="#rsSNcodigo.Mnombre#">
				<cfelse>
					<cfreportparam name="Mnombre" value="#LB_SinDef#">
				</cfif>
			</cfif>

			<cfif isdefined("P1")>
				<cfreportparam name="P1" value="#P1#">
			</cfif>
			<cfif isdefined("P2")>
				<cfreportparam name="P2" value="#P2#">
			</cfif>
			<cfif isdefined("P3")>
				<cfreportparam name="P3" value="#P3#">
			</cfif>
			<cfif isdefined("P4")>
				<cfreportparam name="P4" value="#P4#">
			</cfif>

		</cfreport>
	</cfif>
</cfif>
<cfoutput>
<cf_qforms form ="form1">
<script language="javascript" type="text/javascript">
<!-- //
	objForm.SNcodigo.required = true;
	objForm.SNcodigo.description="#LB_SocioNegocio#";
	objForm.fechaDes.required = true;
	objForm.fechaDes.description="#LB_Fecha_Desde#";
	objForm.fechaHas.required = true;
	objForm.fechaHas.description="#LB_Fecha_Hasta#";

	function funcGenerar(){
	if (datediff(document.form1.fechaDes.value, document.form1.fechaHas.value) < 0)
		{
       			<cfset MSG_FecMayor = t.Translate('MSG_FecMayor','La Fecha Hasta debe ser mayor a la Fecha Desde')>
				alert ('#MSG_FecMayor#');
				return false;
		}
	}
//-->
</script>
</cfoutput>