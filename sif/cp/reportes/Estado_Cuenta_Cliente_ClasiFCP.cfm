<!---
	Creado por: Ana Villavicencio
	Fecha: 17 de julio de 2006
	Motivo: Nuevo reporte.
--->
<cf_templateheader title="SIF - Cuentas por Pagar">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_EdoCuexClas = t.Translate('TIT_EdoCuexClas','Estado de Cuenta del Socio de Negocios por Clasificación')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Datos del Reporte')>
<cfset TIT_EdoCue = t.Translate('TIT_EdoCue','Estado de Cuenta')>
<cfset LB_AntRes = t.Translate('LB_AntRes','Antiguedad Resumida')>
<cfset LB_AntCltRes = t.Translate('LB_AntCltRes','Antig&uuml;edad  Por Cliente Resumido')>
<cfset BTN_Clasificacion 	= t.Translate('BTN_Clasificacion','Clasificación','/sif/generales.xml')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset LB_ValorClasDesde = t.Translate('LB_ValorClasDesde','Valor Clasificación desde')>
<cfset LB_ValorClasHasta = t.Translate('LB_ValorClasHasta','Valor Clasificación hasta')>
<cfset LB_SocioNegocioI = t.Translate('LB_SocioNegocioI','Socio de Negocios Inicial')>
<cfset LB_SocioNegocioF = t.Translate('LB_SocioNegocioF','Socio de Negocios Final')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha Desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha Hasta','/sif/generales.xml')>
<cfset LB_OrdCons = t.Translate('LB_OrdCons','Orden de la Consulta')>
<cfset LB_ImpCodDor = t.Translate('LB_ImpCodDor','Imprimir por Código de Dirección')>
<cfset LB_InEdoCtasMov = t.Translate('LB_InEdoCtasMov','Incluir Estados de Cuenta sin Movimientos')>
<cfset LB_OrdImprClasif = t.Translate('LB_OrdImprClasif','Orden de impresión por Clasificación')>


<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=''>
<script language="JavaScript" src="../../js/fechas.js"></script>

<form name="form1" action="Estado_Cuenta_Cliente_ClasiFCP.cfm" method="get">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>#LB_DatosReporte#</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3">
						<input type="radio" id="radio1" name="TipoReporte" value="0" checked tabindex="1">
						<label for="radio1" style="font-style:normal; font-variant:normal;">#TIT_EdoCue#</label>
						<input type="radio" id="radio2" name="TipoReporte" value="1" tabindex="1">
						<label for="radio2" style="font-style:normal; font-variant:normal;">#LB_AntRes#</label>
						<input type="radio" id="radio3" name="TipoReporte" value="2" tabindex="1">
						<label for="radio3" style="font-style:normal; font-variant:normal;">#LB_AntCltRes#</label>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#BTN_Clasificacion#:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<!--- <tr>
					<td>&nbsp;</td>
					<td width="10%"><strong>#LB_ValorClasDesde#:&nbsp;</strong></td>
					<td width="10%"><strong>#LB_ValorClasHasta#:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid1" name="SNCDvalor1" desc="SNCDdescripcion1" tabindex="1"></td>
					<td width="10%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid2" name="SNCDvalor2" desc="SNCDdescripcion2" tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
				</tr> --->
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_SocioNegocioI#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_SocioNegocioF#:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2 Proveedores="SI"  tabindex="1"></td>
					 <td align="left"><cf_sifsociosnegocios2 Proveedores="SI" form ="form1" frame="frsocios2" SNcodigo="SNcodigob2" SNnombre="SNnombreb2" SNnumero="SNnumerob2"  tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
				</tr>

				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Fecha_Desde#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_Fecha_Hasta#:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left"><cf_sifcalendario name="fechaDes" value="#LSDateFormat(now(),'dd/mm/yyyy')#"  tabindex="1"></td>
					<td nowrap align="left"><cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#"  tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<!--- <tr>
					<td>&nbsp;</td>
					<td style="text-decoration:underline"><strong>#LB_OrdCons#:</strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#BTN_Clasificacion#:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion id="SNCEid_Orden" name="SNCEcodigo_Orden" desc="SNCEdescripcion_orden" form="form1" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr> --->
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%">
					<input name="chk_cod_Direccion" id="chk_cod_Direccion" value="1" checked type="checkbox" tabindex="1">
					<label for="chk_cod_Direccion"  style="font-style:normal;font-weight:normal">&nbsp;<strong>#LB_ImpCodDor#</strong></label></td>
					<td colspan="4">&nbsp;</td>
				</tr>

				<tr>
					<td>&nbsp;</td>
				  <td valign="middle">
				  	<input name="SaldoCero" id="SaldoCero" type="checkbox" value="1" tabindex="1" checked="checked">
					<label for="SaldoCero" style="font-style:normal;font-weight:normal"><strong>#LB_InEdoCtasMov#</strong></label></td>					<td align="left" width="10%">
						<strong>#LB_Formato#&nbsp;</strong>
						<select name="Formato" id="Formato" tabindex="1">
							<option value="2">PDF</option>
							<option value="3">EXCEL</option>
						</select>
					</td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr>
					<td colspan="6">
					<cf_botones values="Generar" names="Generar"  tabindex="1">
					</td>
				</tr>
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
<cfquery name="rsConsultaCorp" datasource="asp">
		select *
		from CuentaEmpresarial
		where Ecorporativa is not null
		  and CEcodigo =  #Session.CEcodigo#
	</cfquery>
	<cfif isdefined('session.Ecodigo') and
		  isdefined('session.Ecodigocorp') and
		  session.Ecodigo NEQ session.Ecodigocorp and
		  rsConsultaCorp.RecordCount GT 0>
		  <cfset filtro = " h.Ecodigo=#session.Ecodigo# ">
	<cfelse>
		  <cfset filtro = " h.Ecodigo is null ">
	</cfif>

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
	<cf_dbtemp name="SocTempEstaCu_V1" returnvariable="socios" datasource="#session.dsn#">
		<cf_dbtempcol name="Ecodigo"	  	type="integer"	mandatory="no">
		<cf_dbtempcol name="SNcodigo"	  	type="integer"	mandatory="no">
		<cf_dbtempcol name="id_direccion" 	type="numeric"	mandatory="no">
		<cf_dbtempcol name="SNid"			type="numeric"	mandatory="no">
		<cf_dbtempcol name="FechaIni"		type="datetime"	mandatory="no">
		<cf_dbtempcol name="FechaFin"		type="datetime"	mandatory="no">
		<cf_dbtempcol name="SNnumero"		type="char(20)"	mandatory="no">
		<cf_dbtempcol name="SNDcodigo"		type="char(20)"	mandatory="no">
		<cf_dbtempcol name="periodo"		type="integer"	mandatory="no">
		<cf_dbtempcol name="mes"			type="integer"	mandatory="no">
		<cf_dbtempcol name='Mcodigo'		type="numeric"	mandatory="yes">
	</cf_dbtemp>

	<!--- Inserto los socios que juegan en el proceso --->
	<cfquery name="rsSocios" datasource="#session.DSN#">
		insert into #socios# (Ecodigo, SNcodigo, SNid, FechaIni, FechaFin, SNnumero, id_direccion, SNDcodigo, Mcodigo)
		select
			s.Ecodigo, s.SNcodigo, s.SNid,
			<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#"> as FechaIni,
			<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#"> as FechaFin,
			s.SNnumero,
			<cfif isdefined("chk_cod_Direccion")>
				snd.id_direccion, snd.SNDcodigo
			<cfelse>
				s.id_direccion, s.SNnumero
			</cfif>
			, s.Mcodigo
		from SNClasificacionD cd <cf_dbforceindex name="PCClasificacionD_02">
			<cfif isdefined("chk_cod_Direccion")>
				inner join SNClasificacionSND cs
					on cs.SNCDid = cd.SNCDid
				inner join SNDirecciones snd
				   on cs.SNid = snd.SNid
				  and cs.id_direccion = snd.id_direccion

			<cfelse>
				inner join SNClasificacionSN cs <cf_dbforceindex name="FKSNClasificacionSN_01">
					on cs.SNCDid = cd.SNCDid
			</cfif>

				inner join SNegocios s <cf_dbforceindex name="AK_KEY_ID_SNEGOCIO">
						on s.SNid = cs.SNid
						and s.Ecodigo =  #session.Ecodigo#

				<cfif isdefined('url.SNnumero') and Len(trim(url.SNnumero)) and not isdefined('url.SNnumerob2')>
						and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero#">
				</cfif>

				<cfif isdefined('url.SNnumerob2') and Len(trim(url.SNnumerob2)) and not isdefined('url.SNnumero')>
						and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumerob2#">
				</cfif>

				<cfif isdefined('url.SNnumero') and Len(trim(url.SNnumero)) and isdefined('url.SNnumerob2') and Len(trim(url.SNnumerob2))>
						<cfif url.SNnumero LTE url.SNnumerob2>
							   and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero#">
							   and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumerob2#">
						<cfelse>
							   and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero#">
							   and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumerob2#">
						</cfif>
				</cfif>
		where cd.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
		  <!---and (cd.SNCDvalor between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#">
			  and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor2#">)      Parametros de Valores de Clasificacion --->
		<cfif not isdefined('url.SaldoCero')>
		  and (
				 exists(
						select 1
						from HEDocumentosCP do
						where do.SNcodigo = s.SNcodigo
						  and do.Ecodigo  = s.Ecodigo
						  and do.Dfecha between
								<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechades)#">
							and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechahas)#">
							<cfif isdefined("chk_cod_Direccion")>
								and do.id_direccion = snd.id_direccion
							</cfif>
						 )
				or exists(
						select 1
						from BMovimientosCxP bm
							inner join HEDocumentosCP do
								on do.Ecodigo = bm.Ecodigo
								and do.CPTcodigo = bm.CPTRcodigo
								and do.Ddocumento = bm.DRdocumento
						where bm.SNcodigo = s.SNcodigo
						  and bm.Ecodigo  = s.Ecodigo
						  and bm.Dfecha between
								<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechades)#">
							and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechahas)#">
							<cfif isdefined("chk_cod_Direccion")>
								and do.id_direccion = snd.id_direccion
							</cfif>
						 )
			)
		</cfif>
	</cfquery>

	<cf_dbtemp name="DocTempEstaCu_V1" returnvariable="documentos" datasource="#session.dsn#">
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
		<cf_dbtempcol name="SaldoInicial"		type="money"		mandatory="no">
		<cf_dbtempcol name="SaldoFinal"			type="money"		mandatory="no">
	</cf_dbtemp>

	  <cfquery name="rsInsert2" datasource="#session.DSN#">
		insert into #documentos# (
			Ecodigo, SNid, Socio,  IDdireccion, Documento, TTransaccion,  CPTtipo, Moneda,
			FechaVencimiento, Fecha, Total, SaldoInicial, SaldoFinal)
		select
			d.Ecodigo, s.SNid, d.SNcodigo,
			<cfif isdefined("url.chk_cod_Direccion")>
			coalesce(d.id_direccion, s.id_direccion),
			<cfelse>
			s.id_direccion,
			</cfif>
			d.Ddocumento, d.CPTcodigo, t.CPTtipo, d.Mcodigo,
			d.Dfechavenc, d.Dfecha, d.Dtotal as Total, 0.00 as SaldoInicial, 0.00 as SaldoFinal
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
					select sum(BMmontoref)
					from BMovimientosCxP bm
						inner join CPTransacciones t
								on t.Ecodigo = bm.Ecodigo
								and t.CPTcodigo = bm.CPTcodigo
								and t.CPTtipo = 'D'
					where bm.Ecodigo = #documentos#.Ecodigo
					  and bm.CPTRcodigo = #documentos#.TTransaccion
					  and bm.DRdocumento = #documentos#.Documento
					  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
					  and bm.Dfecha >= #documentos#.Fecha
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
				select sum(BMmontoref)
				from BMovimientosCxP bm
					inner join CPTransacciones t
							on t.Ecodigo = bm.Ecodigo
							and t.CPTcodigo = bm.CPTRcodigo
							and t.CPTtipo = 'C'
				where bm.Ecodigo = #documentos#.Ecodigo
				  and bm.CPTcodigo = #documentos#.TTransaccion
				  and bm.Ddocumento = #documentos#.Documento
				  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				  and bm.Dfecha >= #documentos#.Fecha
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
				select sum(BMmontoref)
				from BMovimientosCxP bm
					inner join CPTransacciones t
							on t.Ecodigo = bm.Ecodigo
							and t.CPTcodigo = bm.CPTcodigo
							and t.CPTtipo = 'D'
				where bm.Ecodigo = #documentos#.Ecodigo
				  and bm.CPTRcodigo = #documentos#.TTransaccion
				  and bm.DRdocumento = #documentos#.Documento
				  and bm.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
				  and bm.Dfecha >= #documentos#.Fecha
				  and (bm.CPTcodigo <> bm.CPTRcodigo or bm.Ddocumento <> bm.DRdocumento)
				) , 0.00)
			where CPTtipo = 'C'
			  and Fecha <=  <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
		</cfquery>

		<!---Saldos de documentos tipo credito a la fecha 2--->
		<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
			update #documentos#
			set SaldoFinal = Total - coalesce((
				select sum(BMmontoref)
				from BMovimientosCxP bm
					inner join CPTransacciones t
							on t.Ecodigo = bm.Ecodigo
							and t.CPTcodigo = bm.CPTRcodigo
							and t.CPTtipo = 'C'
				where bm.Ecodigo = #documentos#.Ecodigo
				  and bm.CPTcodigo = #documentos#.TTransaccion
				  and bm.Ddocumento = #documentos#.Documento
				  and bm.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
				  and bm.Dfecha >= #documentos#.Fecha
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

	<cf_dbtemp name="SalTempIni_V1" returnvariable="SaldosIniciales" datasource="#session.dsn#">
		<cf_dbtempcol name="Ecodigo"  		type="integer" 		mandatory="no">
		<cf_dbtempcol name="Mcodigo"  		type="numeric" 		mandatory="no">
		<cf_dbtempcol name="SNid"  			type="numeric" 		mandatory="no">
		<cf_dbtempcol name="id_direccion"  	type="numeric" 		mandatory="no">
		<cf_dbtempcol name="SfechaIni" 		type="datetime"		mandatory="no">
		<cf_dbtempcol name="SfechaFin"		type="datetime"		mandatory="no">
		<cf_dbtempcol name="SIsaldoinicial" type="money" 		mandatory="no">
		<cf_dbtempcol name="SIsaldoFinal"   type="money" 		mandatory="no">
		<cf_dbtempcol name="SIsinvencer"  	type="money" 		mandatory="no">
		<cf_dbtempcol name="SIcorriente"  	type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp1"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp2"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp3"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp4"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp5"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp5p"  		type="money" 		mandatory="no">
	</cf_dbtemp>
	<cfquery name="rsInsertSaldosIni" datasource="#session.DSN#">
		insert into #SaldosIniciales#(Ecodigo,Mcodigo,SNid,id_direccion,SfechaIni,SfechaFin,SIsaldoinicial,SIsaldoFinal,SIsinvencer,SIcorriente,
									  SIp1, SIp2, SIp3, SIp4, SIp5, SIp5p)
		select 	distinct Ecodigo, Moneda, SNid, IDdireccion,
		<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">,
		<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">,
		0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
		from #documentos#
	</cfquery>
		<!--- Actualizar el saldo de la tabla #SaldosIniciales# --->
		<cfquery datasource="#session.DSN#">
			update #SaldosIniciales#
			set
				SIsaldoinicial =
					coalesce((
						select sum(d.SaldoInicial)
						from #documentos# d
						where d.SNid         = #SaldosIniciales#.SNid
						  and d.IDdireccion = #SaldosIniciales#.id_direccion
						  and d.Moneda      = #SaldosIniciales#.Mcodigo
						  and d.Fecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaDes)#">
					), 0.00)
			where SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaDes)#">
			  and SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHas)#">
			  and Ecodigo 	=  #session.Ecodigo#
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
						  and <cf_dbfunction name="date_part" args="mm,d.Fecha"> = <cf_dbfunction name="date_part"	args="mm, #LSParseDateTime(url.fechaHas)#">

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
						  and <cf_dbfunction name="date_part" args="mm,d.Fecha"> <>  <cf_dbfunction name="date_part"	args="mm, #LSParseDateTime(url.fechaHas)#">
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
						  and <cf_dbfunction name="datediff" args="d.FechaVencimiento, #LSParseDateTime(url.fechaHas)#"> between 1 and #p1#
					), 0.00)
			where SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
			  and SfechaFin     = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.FechaHas)#">
			  and Ecodigo =  #session.Ecodigo#
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
						  and <cf_dbfunction name="datediff" args="d.FechaVencimiento, #LSParseDateTime(url.fechaHas)#"> between #p1+1# and #p2#
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

<!---**************************************************************************************************************--->
<!---**************************************************************************************************************--->
<!--- Movimientos del Estado de Cuenta --->
	<cf_dbtemp name="movimientosTemp_v2" returnvariable="movimientos" datasource="#session.dsn#">
		<cf_dbtempcol name="id"  				type="numeric" 		mandatory="no" identity>
		<cf_dbtempcol name="Ecodigo"  			type="integer" 		mandatory="no">
		<cf_dbtempcol name="SNnumero"  			type="char(20)" 	mandatory="no">
		<cf_dbtempcol name="Socio"  			type="integer"	 	mandatory="no">
		<cf_dbtempcol name="Moneda"  			type="integer" 		mandatory="no">
		<cf_dbtempcol name="IDdireccion"  		type="numeric" 		mandatory="no">
		<cf_dbtempcol name="Ocodigo"   			type="integer"  	mandatory="no">
		<cf_dbtempcol name="Control"   			type="integer"  	mandatory="no">
		<cf_dbtempcol name="TTransaccion"		type="char(2)" 		mandatory="no">
		<cf_dbtempcol name="Documento" 			type="char(50)" 	mandatory="no">
		<cf_dbtempcol name="Fecha"				type="datetime" 	mandatory="no">
		<cf_dbtempcol name="FechaVencimiento"	type="datetime"		mandatory="no">
		<cf_dbtempcol name="Total"				type="money"		mandatory="no">
		<cf_dbtempcol name="Saldo"				type="money" 		mandatory="no">
		<cf_dbtempcol name="Pago"				type="integer" 		mandatory="no">
		<cf_dbtempcol name="TReferencia"		type="char(2)" 		mandatory="no">
		<cf_dbtempcol name="DReferencia"		type="char(20)" 	mandatory="no">
		<cf_dbtempcol name="Ordenamiento"		type="char(20)" 	mandatory="no">
		<cf_dbtempcol name="SNid"				type="numeric" 		mandatory="no">
		<cf_dbtempcol name="TRgroup"			type="char(2)"		mandatory="no">
		<cf_dbtempcol name="Oficodigo"			type="char(10)"		mandatory="no">
		<cf_dbtempcol name="CPTdescripcion"		type="varchar(80)"	mandatory="no">
		<cf_dbtempcol name="FolioReferencia"	type="varchar(80)"	mandatory="no">
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
			so.Ecodigo,
			so.SNcodigo,
			so.SNnumero,
			si.Mcodigo,
			so.id_direccion,
			-1 as Oficina,
			1 as Control,
			' ' as TTransaccion,
			' Saldo Inicial ' as Documento,
			<cf_dbfunction name="dateadd"	args="-1, so.FechaIni"> as Fecha,
			sum(SIsaldoinicial) as Total,
			0.00 as Saldo,
			0 as Pago,
			' ' as TReferencia,
			' ' as DReferencia,
			' ' as Ordenamiento,
			so.SNid as SNid,
			' ' as TRgroup,
			' ' as Oficodigo,
			' Saldo Inicial ' as CPTdescripcion
		from #socios# so
			inner join #SaldosIniciales# si
				on si.Ecodigo = so.Ecodigo
				and si.SNid = so.SNid
				and si.SfechaIni = so.FechaIni
				and si.SfechaFin = so.FechaFin
				<cfif isdefined("chk_cod_Direccion")>
				and si.id_direccion = so.id_direccion
				</cfif>
		group by so.Ecodigo,
			so.SNid,
			si.Mcodigo,
			so.SNcodigo,
			so.SNnumero,
			so.id_direccion,
			<cf_dbfunction name="dateadd"  args="-1, so.FechaIni">

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
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento,
			FolioReferencia
		)
		<!--- Todos los documentos --->
		select
			s.SNid,
			<cfif isdefined("chk_cod_Direccion")>
				do.id_direccion,
			<cfelse>
				s.id_direccion,
			</cfif>
			do.Dfecha,
			do.CPTcodigo,
			do.Ddocumento,
			s.Ecodigo,
			s.SNcodigo,
			s.SNnumero,
			do.Mcodigo,
			do.Ocodigo as Oficina,
			2 as Control,
			case when t.CPTtipo = 'C' then do.Dtotal else -do.Dtotal end as Total,
			case when t.CPTtipo = 'C' then do.Dtotal else -do.Dtotal end as Saldo,
			0 as Pago,
			do.CPTcodigo as TReferencia,
			do.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			do.CPTcodigo as TRgroup,
			o.Oficodigo as Oficodigo,
			t.CPTdescripcion as CPTdescripcion,
			do.Dfechavenc,
			do.FolioReferencia

		from #socios# so
			inner join SNegocios s
				on s.SNid = so.SNid

			inner join HEDocumentosCP do <cf_dbforceindex name="HEDocumentosCP_FK3">
				 on do.SNcodigo = so.SNcodigo
				and do.Ecodigo = s.Ecodigo
				<cfif isdefined("chk_cod_Direccion")>
					and do.id_direccion = so.id_direccion
				</cfif>
			inner join CPTransacciones t
				on t.CPTcodigo = do.CPTcodigo
				and t.Ecodigo = do.Ecodigo
			inner join Oficinas o
				 on o.Ecodigo = do.Ecodigo
				and o.Ocodigo = do.Ocodigo
		where do.Dfecha between so.FechaIni and so.FechaFin
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
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento,
			FolioReferencia
		)

		select
			s.SNid,
		<cfif isdefined("chk_cod_Direccion")>
			do.id_direccion as IDdireccion,
		<cfelse>
			s.id_direccion  as IDdireccion,
		</cfif>
			bm.Dfecha 		as Fecha,
			bm.CPTcodigo    as TTransaccion,
			bm.Ddocumento   as Documento,
			min(s.Ecodigo)  as Ecodigo,
			min(s.SNcodigo) as Socio,
			min(s.SNnumero) as SNnumero,
			do.Mcodigo      as Moneda,
			min(do.Ocodigo) as Ocodigo,
			2 as Control,
			sum(bm.Dtotal * case when t.CPTtipo='D' then -1.00 else 1.00 end) Total,
			<!---
			sum(bm.BMmontoref * case when t.CPTtipo='D' then -1.00 else 1.00 end) Total,
			--->
			0.00 as Saldo,
			1 as Pago,
			min(t.CPTcodigo) as TReferencia,
			bm.Ddocumento    as DReferencia,
			' ' 			 as Ordenamiento,
			bm.CPTcodigo     as TRgroup,
			min(o.Oficodigo) as Oficodigo,
			min(t.CPTdescripcion) as CPTdescripcion,
			bm.Dfecha        as FechaVencimiento,
			do.FolioReferencia
		from  #socios# so

			inner join SNegocios s
				on s.SNid = so.SNid

			inner join CPTransacciones t
				 on t.Ecodigo = s.Ecodigo
				and t.CPTpago = 1

			inner join BMovimientosCxP bm <cf_dbforceindex name="BMovimientos01">
				 on bm.SNcodigo   = s.SNcodigo
				and bm.CPTcodigo  = t.CPTcodigo
				and bm.Ecodigo    = t.Ecodigo
				and bm.Ecodigo    = s.Ecodigo
				and bm.Dfecha     >= so.FechaIni
				and bm.Dfecha     <= so.FechaFin

			inner join HEDocumentosCP do
				 on do.SNcodigo   = bm.SNcodigo
				and do.Ecodigo    = bm.Ecodigo
				and do.CPTcodigo  = bm.CPTRcodigo
				and do.Ddocumento = bm.DRdocumento
				<cfif isdefined("chk_cod_Direccion")>
				and do.id_direccion = so.id_direccion
				</cfif>

			inner join Oficinas o
				 on o.Ecodigo = do.Ecodigo
				and o.Ocodigo = do.Ocodigo
		group by
			s.SNid,
			<cfif isdefined("chk_cod_Direccion")>
				do.id_direccion,
			<cfelse>
				s.id_direccion,
			</cfif>
			bm.Dfecha,
			bm.CPTcodigo,
			bm.Ddocumento,
			do.Mcodigo,
			bm.Ddocumento,
			bm.CPTcodigo,
			bm.Dfecha,
			do.FolioReferencia
	</cfquery>



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
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento,
			FolioReferencia
		)

		select
			so.SNid,
			<cfif isdefined("chk_cod_Direccion")>
				hd.id_direccion,
			<cfelse>
				so.id_direccion,
			</cfif>
			min(bm.Dfecha) as Fecha,
			bm.CPTcodigo,
			<cf_dbfunction name="concat" args="'APLIC.',bm.CPTcodigo,'-',rtrim(bm.Ddocumento),'/',bm.CPTRcodigo,'-',ltrim(rtrim(bm.DRdocumento))">,
			min(so.Ecodigo),
			min(so.SNcodigo),
			min(so.SNnumero),
			hd.Mcodigo,
			min(hd.Ocodigo) as Oficina,
			2 as Control,
			sum(-bm.Dtotal) Total,
			0.00 as Saldo,
			1 as Pago,
			min(t.CPTcodigo) as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			bm.CPTcodigo as TRgroup,
			min(o.Oficodigo) as Oficodigo,
			min(t.CPTdescripcion) as CPTdescripcion,
			min(bm.Dfecha) as FechaVencimiento,
			hd2.FolioReferencia

		from #socios# so
			inner join HEDocumentosCP hd
				on hd.SNcodigo = so.SNcodigo
				and hd.Ecodigo = so.Ecodigo
				<cfif isdefined("chk_cod_Direccion")>
					and hd.id_direccion = so.id_direccion
				</cfif>

			inner join CPTransacciones t
				on t.CPTcodigo = hd.CPTcodigo
				and t.Ecodigo = hd.Ecodigo
				and t.CPTtipo = 'D'

			inner join BMovimientosCxP bm
				on bm.Ecodigo = hd.Ecodigo
				and bm.CPTcodigo  = hd.CPTcodigo
				and bm.Ddocumento = hd.Ddocumento

			inner join HEDocumentosCP hd2
				on hd2.Ecodigo = bm.Ecodigo
				and hd2.CPTcodigo = bm.CPTRcodigo
				and hd2.Ddocumento = bm.DRdocumento
			inner join Oficinas o
				on o.Ecodigo = hd.Ecodigo
				and o.Ocodigo = hd.Ocodigo

		where hd2.SNcodigo <> hd.SNcodigo                    <!---Socios Diferentes--->
		  and bm.Dfecha between so.FechaIni and so.FechaFin  <!---Rango de Fechas de la aplicacion--->

		group by
			so.SNid,
			<cfif isdefined("chk_cod_Direccion")>
				hd.id_direccion,
			<cfelse>
				so.id_direccion,
			</cfif>
			bm.CPTcodigo,
			<cf_dbfunction name="concat" args="'APLIC.',bm.CPTcodigo,'-',rtrim(bm.Ddocumento),'/',bm.CPTRcodigo,'-',ltrim(rtrim(bm.DRdocumento))">,
			hd.Mcodigo,
			bm.Ddocumento,
			bm.CPTcodigo,
			hd2.FolioReferencia

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
			Saldo,
			Pago,
			TReferencia,
			DReferencia,
			Ordenamiento,
			TRgroup,
			Oficodigo,
			CPTdescripcion,
			FechaVencimiento,
			FolioReferencia
		)


		select
			so.SNid,
			<cfif isdefined("chk_cod_Direccion")>
				hd.id_direccion,
			<cfelse>
				so.id_direccion,
			</cfif>
			min(bm.Dfecha) as Fecha,
			bm.CPTcodigo,
			<cf_dbfunction name="concat" args="'APLIC.',bm.CPTRcodigo,'-',rtrim(bm.DRdocumento),'/',bm.CPTcodigo,'-',ltrim(rtrim(bm.Ddocumento))"> as Documento,
			min(so.Ecodigo),
			min(so.SNcodigo),
			min(so.SNnumero),
			hd.Mcodigo,
			min(hd.Ocodigo) as Oficina,
			2 as Control,
			sum(bm.Dtotal) Total,
			0.00 as Saldo,
			1 as Pago,
			min(t.CPTcodigo) as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			bm.CPTcodigo as TRgroup,
			min(o.Oficodigo) as Oficodigo,
			min(t.CPTdescripcion) as CPTdescripcion,
			min(bm.Dfecha) as FechaVencimiento,
			hd2.FolioReferencia

		from #socios# so
			inner join HEDocumentosCP hd
				on hd.SNcodigo = so.SNcodigo
				and hd.Ecodigo = so.Ecodigo
				<cfif isdefined("chk_cod_Direccion")>
					and hd.id_direccion = so.id_direccion
				</cfif>

			inner join CPTransacciones t
				on t.CPTcodigo = hd.CPTcodigo
				and t.Ecodigo = hd.Ecodigo
				and t.CPTtipo = 'C'

			inner join BMovimientosCxP bm
				on bm.Ecodigo = hd.Ecodigo
				and bm.CPTRcodigo  = hd.CPTcodigo
				and bm.DRdocumento = hd.Ddocumento

			inner join HEDocumentosCP hd2
				on hd2.Ecodigo = bm.Ecodigo
				and hd2.CPTcodigo = bm.CPTcodigo
				and hd2.Ddocumento = bm.Ddocumento

			inner join Oficinas o
				on o.Ecodigo = hd.Ecodigo
				and o.Ocodigo = hd.Ocodigo

		where hd2.SNcodigo <> hd.SNcodigo   				 <!---Socios Diferentes--->
		  and bm.Dfecha between so.FechaIni and so.FechaFin  <!---Rango de Fechas de la aplicacion		  --->
			group by
			so.SNid,
			<cfif isdefined("chk_cod_Direccion")>
				hd.id_direccion,
			<cfelse>
				so.id_direccion,
			</cfif>
			bm.CPTcodigo,
			<cf_dbfunction name="concat" args="'APLIC.',bm.CPTRcodigo,'-',rtrim(bm.DRdocumento),'/',bm.CPTcodigo,'-',ltrim(rtrim(bm.Ddocumento))">,
			hd.Mcodigo,
			bm.Ddocumento,
			bm.CPTcodigo,
			hd2.FolioReferencia


	</cfquery>


	<cfif isdefined("chk_cod_Direccion")>
	<!---	Notas de Credito de un socio aplicadas a otra direccion del mismo --->
		<cfquery name="rsMovimientos8" datasource="#session.DSN#">
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
				FechaVencimiento,
				FolioReferencia
			)
			select
					so.SNid,
					<cfif isdefined("chk_cod_Direccion")>
						hd.id_direccion,
					<cfelse>
						so.id_direccion,
					</cfif>
					min(bm.Dfecha) as Fecha,
					bm.CPTcodigo,
					<cf_dbfunction name="concat" args="'APLIC.',bm.CPTcodigo,'-',rtrim(bm.Ddocumento),'/',bm.CPTRcodigo,'-',ltrim(rtrim(bm.DRdocumento))"> as Documento,
					min(so.Ecodigo),
					min(so.SNcodigo),
					min(so.SNnumero),
					hd.Mcodigo,
					min(hd.Ocodigo) as Oficina,
					2 as Control,
					sum(case when t.CPTtipo = 'D' then bm.Dtotal*-1 else bm.Dtotal end) as Total,
					0.00 as Saldo,
					1 as Pago,
					min(t.CPTcodigo) as TReferencia,
					bm.Ddocumento as DReferencia,
					' ' as Ordenamiento,
					bm.CPTcodigo as TRgroup,
					min(o.Oficodigo) as Oficodigo,
					min(t.CPTdescripcion) as CPTdescripcion,
					min(bm.Dfecha) as FechaVencimiento,
					hd.FolioReferencia
			from #socios# so
				inner join HEDocumentosCP hd
					on hd.SNcodigo = so.SNcodigo
					and hd.Ecodigo = so.Ecodigo
					and hd.id_direccion = so.id_direccion

				inner join CPTransacciones t
					on t.CPTcodigo = hd.CPTcodigo
					and t.Ecodigo = hd.Ecodigo
					and t.CPTtipo = 'D'

				inner join BMovimientosCxP bm
					on bm.Ecodigo = hd.Ecodigo
					and bm.CPTcodigo  = hd.CPTcodigo
					and bm.Ddocumento = hd.Ddocumento

				inner join HEDocumentosCP hd2
					on hd2.Ecodigo = bm.Ecodigo
					and hd2.CPTcodigo = bm.CPTRcodigo
					and hd2.Ddocumento = bm.DRdocumento
				inner join Oficinas o
				   on o.Ecodigo = hd.Ecodigo
				  and o.Ocodigo = hd.Ocodigo

			where hd2.SNcodigo = hd.SNcodigo                     <!---Socios iguales--->
			  and hd2.id_direccion <> hd.id_direccion
			  and bm.Dfecha between so.FechaIni and so.FechaFin  <!---Rango de Fechas de la aplicacion--->
			group by
				so.SNid,
				<cfif isdefined("chk_cod_Direccion")>
					hd.id_direccion,
				<cfelse>
					so.id_direccion,
				</cfif>
				bm.CPTcodigo,
				<cf_dbfunction name="concat" args="'APLIC.',bm.CPTcodigo,'-',rtrim(bm.Ddocumento),'/',bm.CPTRcodigo,'-',ltrim(rtrim(bm.DRdocumento))">,
				hd.Mcodigo,
				bm.Ddocumento,
				bm.CPTcodigo,
				hd.FolioReferencia
		</cfquery>


		<cfquery name="rsMovimientos9" datasource="#session.DSN#">

		<!---Notas de Credito de un socio aplicadas a otra direccion del mismo socio--->

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
				FechaVencimiento,
				FolioReferencia
			)
			select
					so.SNid,
					<cfif isdefined("chk_cod_Direccion")>
						hd.id_direccion,
					<cfelse>
						so.id_direccion,
					</cfif>
					min(bm.Dfecha) as Fecha,
					bm.CPTcodigo,
					<cf_dbfunction name="concat" args="'APLIC.',bm.CPTRcodigo,'-',rtrim(bm.DRdocumento),'/',bm.CPTcodigo,'-',ltrim(rtrim(bm.Ddocumento))"> as Documento,
					min(so.Ecodigo),
					min(so.SNcodigo),
					min(so.SNnumero),
					hd.Mcodigo,
					min(hd.Ocodigo) as Oficina,
					2 as Control,
					sum(case when t.CPTtipo = 'D' then bm.Dtotal*-1 else bm.Dtotal end) as Total,
					0.00 as Saldo,
					1 as Pago,
					min(t.CPTcodigo) as TReferencia,
					bm.Ddocumento as DReferencia,
					' ' as Ordenamiento,
					bm.CPTcodigo as TRgroup,
					min(o.Oficodigo) as Oficodigo,
					min(t.CPTdescripcion) as CPTdescripcion,
					min(bm.Dfecha) as FechaVencimiento,
					hd.FolioReferencia
			from #socios# so
				inner join HEDocumentosCP hd
					on hd.SNcodigo = so.SNcodigo
					and hd.Ecodigo = so.Ecodigo
					and hd.id_direccion = so.id_direccion

				inner join CPTransacciones t
					on t.CPTcodigo = hd.CPTcodigo
					and t.Ecodigo = hd.Ecodigo
					and t.CPTtipo = 'C'

				inner join BMovimientosCxP bm
					on bm.Ecodigo = hd.Ecodigo
					and bm.CPTRcodigo  = hd.CPTcodigo
					and bm.DRdocumento = hd.Ddocumento

				inner join HEDocumentosCP hd2
					on hd2.Ecodigo = bm.Ecodigo
					and hd2.CPTcodigo = bm.CPTcodigo
					and hd2.Ddocumento = bm.Ddocumento

				inner join Oficinas o
				   on o.Ecodigo = hd.Ecodigo
				  and o.Ocodigo = hd.Ocodigo

			where hd2.SNcodigo = hd.SNcodigo                     <!---Socios iguales--->
			  and hd2.id_direccion <> hd.id_direccion
			  and bm.Dfecha between so.FechaIni and so.FechaFin  <!---Rango de Fechas de la aplicacion--->
			group by
				so.SNid,
				<cfif isdefined("chk_cod_Direccion")>
					hd.id_direccion,
				<cfelse>
					so.id_direccion,
				</cfif>
				bm.CPTcodigo,
				<cf_dbfunction name="concat" args="'APLIC.',bm.CPTRcodigo,'-',rtrim(bm.DRdocumento),'/',bm.CPTcodigo,'-',ltrim(rtrim(bm.Ddocumento))">,
				hd.Mcodigo,
				bm.Ddocumento,
				bm.CPTcodigo,
				hd.FolioReferencia
		</cfquery>
	</cfif>


<!---**************************************************************************************************************--->
	<cfif url.TipoReporte eq 0>
		<cfquery datasource="#session.DSN#">
			update #movimientos#
				set
					Oficodigo  = coalesce((select o.Oficodigo from Oficinas o where o.Ecodigo = #movimientos#.Ecodigo and o.Ocodigo = #movimientos#.Ocodigo ), '  '),
					CPTdescripcion = coalesce((select t.CPTdescripcion from CPTransacciones t where t.Ecodigo = #movimientos#.Ecodigo and t.CPTcodigo = #movimientos#.TTransaccion), '  ')
			where Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
		</cfquery>
		<cfif isdefined("url.chk_cod_Direccion")>

			<!--- --- Subreporte --- --->
			<cfquery name="Request.rsReporte2" datasource="#session.DSN#">
				select
					m.IDdireccion as id_direccion,
					m.Moneda as Moneda,
					mo.Mnombre,
					TRgroup as tipo,
					m.CPTdescripcion as CPTdescripcion,
					sum(m.Total) as Total
				from #movimientos# m
					inner join Monedas mo
						on mo.Ecodigo = m.Ecodigo
						and mo.Mcodigo = m.Moneda
				where m.TTransaccion is not null
				  and m.TTransaccion <> ' '
				  and m.Fecha between
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
					and
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
				group by
					m.IDdireccion,
					m.Moneda,
					mo.Mnombre,
					TRgroup,
					m.CPTdescripcion

				order by
					m.IDdireccion,
					m.Moneda,
					TRgroup
			</cfquery>

			<cfquery name="rsReporte" datasource="#session.DSN#">
				select
					m.Ordenamiento as Ordenamiento,
					sn.SNnumero as Socio,
					m.IDdireccion as IDdireccion,
					m.IDdireccion as id_direccion,
					mo.Mnombre as Mnombre,
					m.Moneda as moneda,
					TRgroup as tipo,
					m.Documento as documento,
					m.Fecha as Fecha,
					m.FechaVencimiento as FechaVencimiento,
					m.Control,
					m.Oficodigo as Oficodigo,
					m.CPTdescripcion as Transaccion,
					case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#"> and Total >= 0 then Total else 0.00 end as Creditos,
					case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">  and Total < 0 then -Total else 0.00 end as Debitos,

					m.Total as Total,

					coalesce(si.SIsaldoinicial, 0.00) as Saldo,

					coalesce(si.SIsinvencer, 0.00) as SinVencer,
					coalesce(si.SIcorriente, 0.00) as Corriente,
					coalesce(si.SIp1, 0.00) as P1,
					coalesce(si.SIp2, 0.00) as P2,
					coalesce(si.SIp3, 0.00) as P3,
					coalesce(si.SIp4, 0.00) as P4,
					coalesce(si.SIp5 + si.SIp5p, 0.00) as P5Plus,
					coalesce(si.SIp1 + si.SIp2 + si.SIp3 + si.SIp4 + si.SIp5 + si.SIp5p, 0.00) as Morosidad,

					case when ltrim(rtrim(snd.SNDcodigo)) = '' or snd.SNDcodigo is null then sn.SNnumero else snd.SNDcodigo end as SNnumero,
					sn.SNidentificacion as SNidentificacion,
					sn.SNmontoLimiteCC as SNmontoLimiteCC,
					sn.SNtelefono as SNtelefono,
					sn.SNemail as SNemail,
					case when ltrim(rtrim(snd.SNnombre)) = '' or snd.SNnombre is null then sn.SNnombre else snd.SNnombre end as SNnombre,
					di.direccion1 as direccion1,
					di.direccion2 as direccion2,
					di.codPostal as codPostal,
					m.FolioReferencia
				from #movimientos# m

					inner join SNegocios sn
						on sn.SNid = m.SNid

					inner join SNDirecciones snd
					   on snd.SNid = sn.SNid
					  and snd.id_direccion = m.IDdireccion

					inner join DireccionesSIF di
						on di.id_direccion = snd.id_direccion

					inner join Monedas mo
						on mo.Mcodigo = m.Moneda

					left outer join #SaldosIniciales# si
						 on si.SNid = m.SNid
						 and si.Mcodigo = m.Moneda
						 and si.id_direccion = m.IDdireccion
						 and si.SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
						 and si.SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
				order by
					m.IDdireccion,
					sn.SNnombre,
					sn.SNnumero,
					m.Ordenamiento,
					m.Moneda,
					m.Control,
					m.Fecha,
					m.TTransaccion,
					m.Documento,
					m.FolioReferencia
			</cfquery>
		<cfelse>

			<!--- --- Subreporte --- --->
			<cfquery name="Request.rsReporte2" datasource="#session.DSN#">
				select
					s.id_direccion,
					m.Moneda as Moneda,
					mo.Mnombre,
					TRgroup as tipo,
					m.CPTdescripcion as CPTdescripcion,
					sum(m.Total) as Total
				from #movimientos# m
					inner join Monedas mo
						on mo.Ecodigo = m.Ecodigo
						and mo.Mcodigo = m.Moneda
					inner join SNegocios s
						on s.Ecodigo = m.Ecodigo
						and s.SNcodigo = m.Socio
				where m.TTransaccion is not null
				  and m.TTransaccion <> ' '
				  and m.Fecha between
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
					and
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
				group by
					s.id_direccion,
					m.Moneda,
					mo.Mnombre,
					TRgroup,
					m.CPTdescripcion

				order by
					s.id_direccion,
					m.Moneda,
					TRgroup
			</cfquery>

			<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
				select
					  m.Ordenamiento as Ordenamiento
					, m.SNnumero as Socio
					, sn.id_direccion as IDdireccion
					, sn.id_direccion as id_direccion
					, mo.Mnombre as Mnombre
					, m.Moneda as moneda
					, TRgroup as tipo
					, m.Documento as documento
					, m.Fecha as Fecha
					, m.FechaVencimiento as FechaVencimiento
					, m.Control
					, m.Oficodigo as Oficodigo
					, m.CPTdescripcion as Transaccion
					, case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">  and Total >= 0 then Total else 0.00 end as Creditos
					, case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">  and Total < 0 then -Total else 0.00 end as Debitos
					, m.Total as Total

					, coalesce(si.SIsaldoinicial, 0.00) as Saldo

					, coalesce(si.SIsinvencer, 0.00) as SinVencer
					, coalesce(si.SIcorriente, 0.00) as Corriente
					, coalesce(si.SIp1, 0.00) as P1
					, coalesce(si.SIp2, 0.00) as P2
					, coalesce(si.SIp3, 0.00) as P3
					, coalesce(si.SIp4, 0.00) as P4
					, coalesce(si.SIp5 + si.SIp5p, 0.00) as P5Plus
					, coalesce(si.SIp1 + si.SIp2 + si.SIp3 + si.SIp4 + si.SIp5 + si.SIp5p, 0.00) as Morosidad

					, sn.SNnumero as SNnumero
					,  sn.SNidentificacion as SNidentificacion
					,  sn.SNmontoLimiteCC as SNmontoLimiteCC
					,  sn.SNtelefono as SNtelefono
					,  sn.SNemail as SNemail
					,  sn.SNnombre as SNnombre
					,  di.direccion1 as direccion1
					,  di.direccion2 as direccion2
					,  di.codPostal as codPostal
					, m.FolioReferencia

				from #movimientos# m
					inner join SNegocios sn
						on sn.SNid = m.SNid
					inner join DireccionesSIF di
						on di.id_direccion = sn.id_direccion
					inner join Monedas mo
						on mo.Mcodigo = m.Moneda
						and mo.Ecodigo = m.Ecodigo

					left outer join #SaldosIniciales# si
						 on si.SNid = m.SNid
						 and si.Mcodigo = m.Moneda
						 and si.id_direccion = m.IDdireccion
						 and si.SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
						 and si.SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">

				order by
					sn.SNnombre,
					sn.SNnumero,
					m.Ordenamiento,
					sn.id_direccion,
					m.Moneda,
					m.Control,
					m.Fecha,
					m.TTransaccion,
					m.Documento,
					m.FolioReferencia
			</cfquery>

		</cfif>
	</cfif>

	<cfif url.TipoReporte Eq 1 or url.TipoReporte Eq 2 or url.TipoReporte eq 3>
		<cfquery name="borracero" datasource="#session.DSN#">
			delete from #movimientos# where Saldo = 0
		</cfquery>
	</cfif>

	<cfif url.TipoReporte EQ 2 > <!--- ojo cualquier modificacion aqui, si aplica, hacerlo tambien abajo en el TipoReporte EQ 3--->
		<!--- Antiguedad de Saldos por Cliente --->
				<cfquery name="rsReporte" datasource="#Session.DSN#" maxrows="5001">
			select m.Ordenamiento as Ordenamiento,
				SNCEcodigo,
				SNCEdescripcion,
				SNCDvalor,
				SNCDdescripcion,
				mo.Miso4217 as CodigoMoneda,
				mo.Mnombre as Mnombre,
				mo.Mcodigo as moneda,
				coalesce(si.SIsaldoinicial, 0.00) as Saldo,
				coalesce(si.SIsinvencer, 0.00) as SinVencer,
				coalesce(si.SIcorriente, 0.00) as Corriente,
				coalesce(si.SIp1, 0.00) as P1,
				coalesce(si.SIp2, 0.00) as P2,
				coalesce(si.SIp3, 0.00) as P3,
				coalesce(si.SIp4, 0.00) as P4,
				coalesce(si.SIp5 + si.SIp5p, 0.00) as P5Plus,
				coalesce(si.SIp1 + si.SIp2 + si.SIp3 + si.SIp4 + si.SIp5 + si.SIp5p, 0.00) as Morosidad,
				<cfif isdefined("url.chk_cod_Direccion")>
					min(coalesce(snd.SNDcodigo,sn.SNnumero)) as SNnumero,
					min(coalesce(snd.SNnombre,sn.SNnombre)) as SNnombre
				<cfelse>
					min(sn.SNnumero) as SNnumero,
					min(sn.SNnombre) as SNnombre
				</cfif>
			from #movimientos# m
			inner join SNegocios sn
				on sn.SNid = m.SNid
			<cfif isdefined("url.chk_cod_Direccion")>
			inner join SNDirecciones snd
				on snd.SNid = m.SNid
				and snd.id_direccion = m.IDdireccion
			inner join SNClasificacionSND cl
				on cl.SNid = snd.SNid
				and cl.id_direccion = snd.id_direccion
			<cfelse>
			inner join SNClasificacionSN cl
				on cl.SNid = sn.SNid
			</cfif>
			inner join SNClasificacionD cld
				on cld.SNCDid = cl.SNCDid
			inner join SNClasificacionE cle
				on cle.SNCEid = cld.SNCEid
				and cle.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
			inner join Monedas mo
				on mo.Ecodigo = m.Ecodigo
				and mo.Mcodigo = m.Moneda

			inner join #SaldosIniciales# si
				on si.SNid = m.SNid
				and si.Mcodigo = m.Moneda
				and si.id_direccion = m.IDdireccion
				and si.SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				and si.SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">

			group by
				m.Ordenamiento,
				SNCEcodigo,
				SNCEdescripcion,
				SNCDvalor,
				SNCDdescripcion,
				mo.Miso4217,
				mo.Mnombre,
				mo.Mcodigo,
				coalesce(si.SIsaldoinicial, 0.00),
				coalesce(si.SIsinvencer, 0.00),
				coalesce(si.SIcorriente, 0.00),
				coalesce(si.SIp1, 0.00),
				coalesce(si.SIp2, 0.00),
				coalesce(si.SIp3, 0.00),
				coalesce(si.SIp4, 0.00),
				coalesce(si.SIp5 + si.SIp5p, 0.00),
				coalesce(si.SIp1 + si.SIp2 + si.SIp3 + si.SIp4 + si.SIp5 + si.SIp5p, 0.00)
			order by
				m.Ordenamiento,
				mo.Miso4217,
				mo.Mnombre,
				mo.Mcodigo,
				SNCEcodigo,
				SNCEdescripcion,
				SNCDvalor,
				SNCDdescripcion
		</cfquery>
	</cfif>

	<cfif url.TipoReporte EQ 1>
		<!--- Antiguedad de Saldos Resumido por Clasificacion --->
		<cfquery name="rsReporte" datasource="#Session.DSN#" maxrows="5001">
			select m.Ordenamiento as Ordenamiento,
				SNCEcodigo,
				SNCEdescripcion,
				SNCDvalor,
				SNCDdescripcion,
				mo.Miso4217 as CodigoMoneda,
				mo.Mnombre as Mnombre,
				mo.Mcodigo as moneda,
				sum(coalesce(si.SIsaldoinicial, 0.00)) as Saldo,
				sum(coalesce(si.SIsinvencer, 0.00)) as SinVencer,
				sum(coalesce(si.SIcorriente, 0.00)) as Corriente,
				sum(coalesce(si.SIp1, 0.00)) as P1,
				sum(coalesce(si.SIp2, 0.00)) as P2,
				sum(coalesce(si.SIp3, 0.00)) as P3,
				sum(coalesce(si.SIp4, 0.00)) as P4,
				sum(coalesce(si.SIp5 + si.SIp5p, 0.00)) as P5Plus,
				sum(coalesce(si.SIp1 + si.SIp2 + si.SIp3 + si.SIp4 + si.SIp5 + si.SIp5p, 0.00)) as Morosidad

			from #movimientos# m
			<cfif isdefined("url.chk_cod_Direccion")>
			inner join SNDirecciones snd
				on snd.SNid = m.SNid
				and snd.id_direccion = m.IDdireccion
			inner join SNClasificacionSND cl
				on cl.SNid = snd.SNid
				and cl.id_direccion = snd.id_direccion
			<cfelse>
			inner join SNegocios sn
				on sn.SNid = m.SNid
			inner join SNClasificacionSN cl
				on cl.SNid = sn.SNid
			</cfif>
			inner join SNClasificacionD cld
				on cld.SNCDid = cl.SNCDid
			inner join SNClasificacionE cle
				on cle.SNCEid = cld.SNCEid
				and cle.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
			inner join Monedas mo
				on mo.Ecodigo = m.Ecodigo
				and mo.Mcodigo = m.Moneda

			inner join #SaldosIniciales# si
				on si.SNid = m.SNid
				and si.Mcodigo = m.Moneda
				and si.id_direccion = m.IDdireccion
				and si.SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
				and si.SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">

			group by
				m.Ordenamiento,
				mo.Miso4217,
				mo.Mcodigo,
				mo.Mnombre,
				SNCEcodigo,
				SNCEdescripcion,
				SNCDvalor,
				SNCDdescripcion
		order by
				m.Ordenamiento,
				mo.Miso4217,
				mo.Mnombre,
				mo.Mcodigo,
				SNCEcodigo,
				SNCEdescripcion,
				SNCDvalor,
				SNCDdescripcion
		</cfquery>
	</cfif>

	<cfif url.TipoReporte eq 3>

		<cfquery name="rsReporte" datasource="#Session.DSN#" maxrows="5001">
			select
				m.Ordenamiento as Ordenamiento,
				sn.SNnumero as Socio,
				mo.Miso4217 as CodigoMoneda,
				mo.Mnombre as Mnombre,
				mo.Mcodigo as moneda,
				sum(Saldo) as Saldo,

				sum(case when
					FechaVencimiento <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(url.fechaHas)#">
					and (<cf_dbfunction name="date_part" args="mm, Fecha"> <> <cf_dbfunction name="date_part"	args="mm,#lsparsedatetime(url.fechaHas)#">)
					 or <cf_dbfunction name="date_part" args="yy, Fecha"> <> <cf_dbfunction name="date_part"	args="yy, #lsparsedatetime(url.fechaHas)#"> ))
					then Saldo else 0.00 end)
					as SinVencer,
				sum(case when
					FechaVencimiento <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(url.fechaHas)#">
					and <cf_dbfunction name="date_part" args="mm, Fecha"> = <cf_dbfunction name="date_part"	args="mm, #lsparsedatetime(url.fechaHas)#"> )
					and <cf_dbfunction name="date_part" args="yy, Fecha"> = <cf_dbfunction name="date_part"	args="yy, #lsparsedatetime(url.fechaHas)#"> )
					then Saldo else 0.00 end)
					as Corriente,
				sum (case when
					<cf_dbfunction name="datediff" args="FechaVencimiento, #lsparsedatetime(url.fechaHas)#"> )
							between 1 and <cfqueryparam cfsqltype="cf_sql_integer" value="#p1#">
					  then Saldo
					  else 0.00
					  end
					) as P1,
				sum (case when
					<cf_dbfunction name="datediff" args="FechaVencimiento, #lsparsedatetime(url.fechaHas)#"> )
							between <cfqueryparam cfsqltype="cf_sql_integer" value="#p1+1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p2#">
					  then Saldo
					  else 0.00
					  end
					) as P2,
				sum (case when
					<cf_dbfunction name="datediff" args="FechaVencimiento, #lsparsedatetime(url.fechaHas)#"> )
							between <cfqueryparam cfsqltype="cf_sql_integer" value="#p2+1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p3#">
					  then Saldo
					  else 0.00
					  end
					) as P3,
				sum (case when
					<cf_dbfunction name="datediff" args="FechaVencimiento, #lsparsedatetime(url.fechaHas)#"> )
							between <cfqueryparam cfsqltype="cf_sql_integer" value="#p3+1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#p4#">
					  then Saldo
					  else 0.00
					  end
					) as P4,
				sum (case when
					<cf_dbfunction name="datediff" args="FechaVencimiento, #lsparsedatetime(url.fechaHas)#"> )
							>= <cfqueryparam cfsqltype="cf_sql_integer" value="#p4+1#">
					  then Saldo
					  else 0.00
					  end
					) as P5Plus,
				sum(case when
						FechaVencimiento < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(url.fechaHas)#">
					then
						Saldo
					else
						0.00
					end)
					as Morosidad,

				min(sn.SNnumero) as SNnumero,
				min(sn.SNidentificacion) as SNidentificacion,
				min(sn.SNmontoLimiteCC) as SNmontoLimiteCC,
				min(sn.SNnombre) as SNnombre,
				min(ds.direccion1) as direccion1,
				min(SNCEcodigo) as SNCEcodigo,
				min(SNCEdescripcion) as SNCEdescripcion,
				min(SNCDvalor) as SNCDvalor,
				min(SNCDdescripcion) as SNCDdescripcion,
				<cf_dbfunction name="concat" args="ltrim(rtrim(o.Oficodigo)),' - ',ltrim(rtrim(o.Odescripcion))"> as Odescripcion,
				<cf_dbfunction name="concat" args="ltrim(rtrim(c.CDCidentificacion)),' -0 ',ltrim(rtrim(c.CDCnombre))">as Cliente,
				m.Documento as Ddocumento,
				m.Fecha as Dfecha,
				m.FechaVencimiento as Dfechavenc

			from #movimientos# m
			inner join Monedas mo
				 on mo.Ecodigo = m.Ecodigo
				and mo.Mcodigo = m.Moneda

			inner join SNegocios sn
				 on sn.Ecodigo = m.Ecodigo
				and sn.SNcodigo = m.Socio
			inner join SNClasificacionSN snc
				 on snc.SNid = sn.SNid

			inner join SNClasificacionD sncD
				 on sncD.SNCDid = snc.SNCDid
				and sncD.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">

			inner join SNClasificacionE sncE
				on sncE.SNCEid = sncD.SNCEid
				and sncE.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">

			inner join DireccionesSIF ds
				 on ds.id_direccion = sn.id_direccion
				inner join HEDocumentosCP dh
					  on  dh.SNcodigo = m.Socio
					  and dh.Ecodigo  = m.Ecodigo
					  and dh.CPTcodigo = m.TTransaccion
					  and dh.Ddocumento = m.Documento

				 inner join Oficinas o
						on o.Ecodigo = dh.Ecodigo
					   and o.Ocodigo = dh.Ocodigo

					left outer join ClientesDetallistasCorp c
					  on c.CDCcodigo = dh.CDCcodigo

			group by
				m.Ordenamiento,
				sn.SNnumero,
				mo.Miso4217,
				mo.Mnombre,
				mo.Mcodigo,
				<cf_dbfunction name="concat" args="ltrim(rtrim(o.Oficodigo)),' -a ',ltrim(rtrim(o.Odescripcion))">,
				<cf_dbfunction name="concat" args="ltrim(rtrim(c.CDCidentificacion)),' -b ',ltrim(rtrim(c.CDCnombre))">,
				m.Documento,
				m.Fecha,
				m.FechaVencimiento
			order by
				mo.Mcodigo,
				m.Ordenamiento,
				sn.SNnumero ,
				o.Oficodigo,
				<cf_dbfunction name="concat" args="ltrim(rtrim(c.CDCidentificacion)),' -c ',ltrim(rtrim(c.CDCnombre))">,
				m.Documento,
				m.Fecha,
				m.FechaVencimiento
		</cfquery>
	</cfif>

<cfif url.TipoReporte eq 4>
		<cfquery datasource="#session.DSN#">
			update #movimientos#
				set
					Oficodigo  = coalesce((select o.Oficodigo from Oficinas o where o.Ecodigo = #movimientos#.Ecodigo and o.Ocodigo = #movimientos#.Ocodigo ), '  '),
					CPTdescripcion = coalesce((select t.CPTdescripcion from CPTransacciones t where t.Ecodigo = #movimientos#.Ecodigo and t.CPTcodigo = #movimientos#.TTransaccion), '  ')
			where Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
		</cfquery>
		<cfif isdefined("url.chk_cod_Direccion")>

			<!--- --- Subreporte --- --->
			<cfquery name="Request.rsReporte2" datasource="#session.DSN#">
				select
					m.IDdireccion as id_direccion,
					m.Moneda as Moneda,
					mo.Mnombre,
					TRgroup as tipo,
					m.CPTdescripcion as CPTdescripcion,
					sum(m.Total) as Total
				from #movimientos# m
					inner join Monedas mo
						on mo.Ecodigo = m.Ecodigo
						and mo.Mcodigo = m.Moneda
				where m.TTransaccion is not null
				  and m.TTransaccion <> ' '
				  and m.Fecha between
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
					and
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
				group by
					m.IDdireccion,
					m.Moneda,
					mo.Mnombre,
					TRgroup,
					m.CPTdescripcion

				order by
					m.IDdireccion,
					m.Moneda,
					TRgroup
			</cfquery>

			<cfquery name="rsReporte" datasource="#session.DSN#">
				select
					m.Ordenamiento as Ordenamiento,
					sn.SNnumero as Socio,
					m.IDdireccion as IDdireccion,
					m.IDdireccion as id_direccion,
					mo.Mnombre as Mnombre,
					m.Moneda as moneda,
					TRgroup as tipo,
					m.Documento as documento,
					m.Fecha as Fecha,
					m.FechaVencimiento as FechaVencimiento,
					m.Control,
					m.Oficodigo as Oficodigo,
					m.CPTdescripcion as Transaccion,
					case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#"> and Total >= 0 then Total else 0.00 end as Creditos,
					case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">  and Total < 0 then -Total else 0.00 end as Debitos,

					m.Total as Total,

					coalesce(si.SIsaldoinicial, 0.00) as Saldo,

					coalesce(si.SIsinvencer, 0.00) as SinVencer,
					coalesce(si.SIcorriente, 0.00) as Corriente,
					coalesce(si.SIp1, 0.00) as P1,
					coalesce(si.SIp2, 0.00) as P2,
					coalesce(si.SIp3, 0.00) as P3,
					coalesce(si.SIp4, 0.00) as P4,
					coalesce(si.SIp5 + si.SIp5p, 0.00) as P5Plus,
					coalesce(si.SIp1 + si.SIp2 + si.SIp3 + si.SIp4 + si.SIp5 + si.SIp5p, 0.00) as Morosidad,

					case when ltrim(rtrim(snd.SNDcodigo)) = '' or snd.SNDcodigo is null then sn.SNnumero else snd.SNDcodigo end as SNnumero,
					sn.SNidentificacion as SNidentificacion,
					sn.SNmontoLimiteCC as SNmontoLimiteCC,
					sn.SNtelefono as SNtelefono,
					sn.SNemail as SNemail,
					case when ltrim(rtrim(snd.SNnombre)) = '' or snd.SNnombre is null then sn.SNnombre else snd.SNnombre end as SNnombre,
					di.direccion1 as direccion1,
					di.direccion2 as direccion2,
					di.codPostal as codPostal,
					m.FolioReferencia
				from #movimientos# m

					inner join SNegocios sn
						on sn.SNid = m.SNid

					inner join SNDirecciones snd
					   on snd.SNid = sn.SNid
					  and snd.id_direccion = m.IDdireccion

					inner join DireccionesSIF di
						on di.id_direccion = snd.id_direccion

					inner join Monedas mo
						on mo.Mcodigo = m.Moneda

					left outer join #SaldosIniciales# si
						 on si.SNid = m.SNid
						 and si.Mcodigo = m.Moneda
						 and si.id_direccion = m.IDdireccion
						 and si.SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
						 and si.SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
				order by
					m.IDdireccion,
					sn.SNnombre,
					sn.SNnumero,
					m.Ordenamiento,
					m.Moneda,
					m.Control,
					m.Fecha,
					m.TTransaccion,
					m.Documento,
					m.FolioReferencia
			</cfquery>
		<cfelse>

			<!--- --- Subreporte --- --->
			<cfquery name="Request.rsReporte2" datasource="#session.DSN#">
				select
					s.id_direccion,
					m.Moneda as Moneda,
					mo.Mnombre,
					TRgroup as tipo,
					m.CPTdescripcion as CPTdescripcion,
					sum(m.Total) as Total
				from #movimientos# m
					inner join Monedas mo
						on mo.Ecodigo = m.Ecodigo
						and mo.Mcodigo = m.Moneda
					inner join SNegocios s
						on s.Ecodigo = m.Ecodigo
						and s.SNcodigo = m.Socio
				where m.TTransaccion is not null
				  and m.TTransaccion <> ' '
				  and m.Fecha between
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
					and
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">
				group by
					s.id_direccion,
					m.Moneda,
					mo.Mnombre,
					TRgroup,
					m.CPTdescripcion

				order by
					s.id_direccion,
					m.Moneda,
					TRgroup
			</cfquery>

			<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
				select
					  m.Ordenamiento as Ordenamiento
					, m.SNnumero as Socio
					, sn.id_direccion as IDdireccion
					, sn.id_direccion as id_direccion
					, mo.Mnombre as Mnombre
					, m.Moneda as moneda
					, TRgroup as tipo
					, m.Documento as documento
					, m.Fecha as Fecha
					, m.FechaVencimiento as FechaVencimiento
					, m.Control
					, m.Oficodigo as Oficodigo
					, m.CPTdescripcion as Transaccion
					, case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">  and Total >= 0 then Total else 0.00 end as Creditos
					, case when Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">  and Total < 0 then -Total else 0.00 end as Debitos
					, m.Total as Total

					, coalesce(si.SIsaldoinicial, 0.00) as Saldo

					, coalesce(si.SIsinvencer, 0.00) as SinVencer
					, coalesce(si.SIcorriente, 0.00) as Corriente
					, coalesce(si.SIp1, 0.00) as P1
					, coalesce(si.SIp2, 0.00) as P2
					, coalesce(si.SIp3, 0.00) as P3
					, coalesce(si.SIp4, 0.00) as P4
					, coalesce(si.SIp5 + si.SIp5p, 0.00) as P5Plus
					, coalesce(si.SIp1 + si.SIp2 + si.SIp3 + si.SIp4 + si.SIp5 + si.SIp5p, 0.00) as Morosidad

					, sn.SNnumero as SNnumero
					,  sn.SNidentificacion as SNidentificacion
					,  sn.SNmontoLimiteCC as SNmontoLimiteCC
					,  sn.SNtelefono as SNtelefono
					,  sn.SNemail as SNemail
					,  sn.SNnombre as SNnombre
					,  di.direccion1 as direccion1
					,  di.direccion2 as direccion2
					,  di.codPostal as codPostal
					, m.FolioReferencia

				from #movimientos# m
					inner join SNegocios sn
						on sn.SNid = m.SNid
					inner join DireccionesSIF di
						on di.id_direccion = sn.id_direccion
					inner join Monedas mo
						on mo.Mcodigo = m.Moneda
						and mo.Ecodigo = m.Ecodigo

					left outer join #SaldosIniciales# si
						 on si.SNid = m.SNid
						 and si.Mcodigo = m.Moneda
						 and si.id_direccion = m.IDdireccion
						 and si.SfechaIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaDes)#">
						 and si.SfechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechaHas)#">

				order by
					sn.SNnombre,
					sn.SNnumero,
					m.Ordenamiento,
					sn.id_direccion,
					m.Moneda,
					m.Control,
					m.Fecha,
					m.TTransaccion,
					m.Documento,
					m.FolioReferencia
			</cfquery>

		</cfif>
	</cfif>

	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
       	<cfset MSG_GeneraMas5000 = t.Translate('MSG_GeneraMas5000','Se han generado mas de 5000 registros para este reporte.')>
		<cf_errorCode	code = "50196" msg = "#MSG_GeneraMas5000#">
		<cfabort>
	</cfif>
	<cfif isdefined("Request.rsReporte2") and rsReporte.recordcount gt 5000>
       	<cfset MSG_GeneraMas5000 = t.Translate('MSG_GeneraMas5000','Se han generado mas de 5000 registros para este reporte.')>
		<cf_errorCode	code = "50196" msg = "#MSG_GeneraMas5000#">
		<cfabort>
	</cfif>

	<!--- Busca el nombre de la Empresa --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo =  #session.Ecodigo#
	</cfquery>
	<cfquery name="rsSNCEdescripcion" datasource="#session.DSN#">
		select SNCEdescripcion
			from  SNClasificacionE
				where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
	</cfquery>
	<!--- <cfquery name="rsSNCDdescripcion1" datasource="#session.DSN#">
		select SNCDdescripcion
			from  SNClasificacionD
				where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid1#">
	</cfquery>
	<cfquery name="rsSNCDdescripcion2" datasource="#session.DSN#">
		select SNCDdescripcion
			from  SNClasificacionD
				where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid2#">
	</cfquery> --->
	<cfquery name="rsSNnombre1" datasource="#session.DSN#">
		select SNnombre
			from  SNegocios
				where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
				and Ecodigo =  #session.Ecodigo#
	</cfquery>
	<cfquery name="rsSNnombre2" datasource="#session.DSN#">
		select SNnombre
			from  SNegocios
				where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigob2#">
				and Ecodigo =  #session.Ecodigo#
	</cfquery>

<!---
	<cfquery name="rsSNCEdescripcion_orden" datasource="#session.DSN#">
		select SNCEdescripcion
			from  SNClasificacionE
				where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid_orden#">
	</cfquery>
 --->

     <cfset formatos = 'Excel'>
	 <cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 4> <!--- Convirtiendo el reporte de Estado de cuenta en Excel --->
		<cfset formatos = "excel">
	</cfif>
	<!--- Invocación del reporte --->
	<cfset nombreReporteJR = "">
	<cfif url.TipoReporte EQ 0>
		<cfif isdefined("url.chk_cod_Direccion")>
			<cfset LvarReporte = "Estado_Cuenta_Cliente_ClasFxid_direccionCP.cfr">
			<cfset LvarReporte = "Estado_Cuenta_Cliente_ClasFxid_direccionCP_Excel.cfr">
			<cfset nombreReporteJR = "Estado_Cuenta_Cliente_ClasFxid_direccionCP_Excel">
		<cfelse>
			<cfset LvarReporte = "Estado_Cuenta_Cliente_ClasFCP.cfr">
			<cfset nombreReporteJR = "Estado_Cuenta_Cliente_ClasFCP">
		</cfif>
	</cfif>

	<cfif url.TipoReporte EQ 2>
		<cfset LvarReporte = "AntiguedadSaldosxClasClienteFechaCP.cfr">
		<cfset nombreReporteJR = "AntiguedadSaldosxClasClienteFechaCP">

	</cfif>
	<cfif url.TipoReporte EQ 1>
		<cfset LvarReporte = "AntiguedadSaldosxClasFechaCP.cfr">
		<cfset nombreReporteJR = "AntiguedadSaldosxClasFechaCP">
	</cfif>
	<cfif url.TipoReporte EQ 3>
		<cfset LvarReporte = "AntSalxClasFecCliPOSCP.cfr">
		<cfset nombreReporteJR = "AntSalxClasFecCliPOSCP">
	</cfif>


<cfset LB_Hora 	= t.Translate('LB_Hora','Hora')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset TIT_EdoCta 	= t.Translate('TIT_EdoCta','Estado de Cuenta  del')>
<cfset TIT_CXP 	= t.Translate('TIT_CXP','Cuentas por Pagar')>
<cfset LB_Hasta 	= t.Translate('LB_Hasta','al','/sif/generales.xml')>
<cfset LB_Codigo 	= t.Translate('LBR_CODIGO','Código','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset LB_Direccion = t.Translate('LB_Direccion','Dirección:','/sif/generales.xml')>
<cfset LB_Telefono 	= t.Translate('LB_Telefono','Teléfono','/sif/generales.xml')>
<cfset LB_Apartado 	= t.Translate('LB_Apartado','Apartado')>
<cfset LB_LimCred	= t.Translate('LB_LimCred','Límite Crédito')>
<cfset LB_EdoCtaDir	= t.Translate('LB_EdoCtaDir','Estado de Cuenta por Dirección')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Ref = t.Translate('LB_Ref','Ref.')>
<cfset LB_FecVenc = t.Translate('LB_FecVenc','Fecha Venc.')>
<cfset LB_FecCorte = t.Translate('LB_FecCorte','Fecha de Corte')>
<cfset LB_Sucursal = t.Translate('LB_Sucursal','Sucursal')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset LB_Debitos = t.Translate('LB_Debitos','Debitos')>
<cfset LB_Creditos = t.Translate('LB_Creditos','Créditos')>
<cfset LB_AnaSaldo = t.Translate('LB_AnaSaldo','Análisis de Saldo')>
<cfset LB_VencSaldo = t.Translate('LB_VencSaldo','Venciniento de Saldo')>
<cfset LB_Corriente = t.Translate('LB_Corriente','Corriente')>
<cfset LB_SinVenc = t.Translate('LB_SinVenc','Sin Vencer')>
<cfset LB_De = t.Translate('LB_De','De')>
<cfset LB_a = t.Translate('LB_a','a')>
<cfset LB_al = t.Translate('LB_al','al')>
<cfset LB_omas = t.Translate('LB_omas','o mas')>
<cfset LB_Morosidad = t.Translate('LB_Morosidad','Morosidad')>
<cfset LB_Tipo = t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset Descripcion = t.Translate('Descripcion','Descripción','/sif/generales.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Clasificacion = t.Translate('LB_Clasificacion','Clasificación')>
<cfset LB_Valor = t.Translate('LB_Valor','Valor','/sif/generales.xml')>
<cfset LB_Totales = t.Translate('LB_Totales','Totales')>
<cfset LB_TotalMon = t.Translate('LB_TotalMon','Total Moneda')>
<cfset LB_Criterio = t.Translate('LB_Criterio','Criterios de Selección:')>
<cfset LB_ValorClasDesde = t.Translate('LB_ValorClasDesde','Valor Clasificación desde')>
<cfset LB_ValorClasHasta = t.Translate('LB_ValorClasHasta','Valor Clasificación hasta')>
<cfset LB_SocioNegocioI = t.Translate('LB_SocioNegocioI','Socio de Negocios Inicial')>
<cfset LB_SocioNegocioF = t.Translate('LB_SocioNegocioF','Socio de Negocios Final')>
<cfset TIT_AntSalXClas	= t.Translate('TIT_AntSalXClas','Antigüedad de Saldos por Clasificación')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificación','/sif/generales.xml')>
<cfset LB_FolioReferencia = t.Translate('LB_FolioReferencia','Folio Referencia','/sif/generales.xml')>

  <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and  formatos eq "excel">
	  <cfset typeRep = 1>
	 
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cp.consultas.reportes.#nombreReporteJR#"/>
	<cfelse>
		<cfreport format="#formatos#" template="#LvarReporte#" query="rsReporte">
					<cfreportparam name="TIT_EdoCta" 		value="#TIT_EdoCta#">
					<cfreportparam name="TIT_AntSalXClas" 	value="#TIT_AntSalXClas#">
					<!---<cfreportparam name="LB_EdoCue" 	value="#LB_EdoCue#">--->
					<cfreportparam name="TIT_CXP" 		value="#TIT_CXP#">
					<cfreportparam name="LB_Fecha" 		value="#LB_Fecha#">
					<cfreportparam name="LB_Hora" 		value="#LB_Hora#">
					<cfreportparam name="LB_Clasificacion" 	value="#LB_Clasificacion#">
					<cfreportparam name="LB_Valor" 	value="#LB_Valor#">
					<cfreportparam name="LB_Codigo" 	value="#LB_Codigo#">
					<cfreportparam name="LB_LimCred" 	value="#LB_LimCred#">
					<cfreportparam name="LB_SocioNegocio" 	value="#LB_SocioNegocio#">
					<cfreportparam name="LB_De" 		value="#LB_De#">
					<cfreportparam name="LB_a" 			value="#LB_a#">
					<cfreportparam name="LB_al" 			value="#LB_al#">
					<cfreportparam name="LB_Totales" 	value="#LB_Totales#">
					<cfreportparam name="LB_Telefono" 	value="#LB_Telefono#">
					<cfreportparam name="LB_Direccion" 	value="#LB_Direccion#">
					<cfreportparam name="LB_Apartado" 	value="#LB_Apartado#">
					<cfreportparam name="LB_Moneda" 	value="#LB_Moneda#">
					<cfreportparam name="LB_Documento" 	value="#LB_Documento#">
					<cfreportparam name="LB_Ref" 		value="#LB_Ref#">
					<cfreportparam name="LB_FecVenc" 	value="#LB_FecVenc#">
					<cfreportparam name="LB_Sucursal" 	value="#LB_Sucursal#">
					<cfreportparam name="LB_al" 		value="#LB_al#">
	<!---        <cfreportparam name="LB_Del" 		value="#LB_Del#">
			<cfreportparam name="LB_EdoCta" 	value="#LB_EdoCta#">--->
					<cfreportparam name="LB_EdoCtaDir" 	value="#LB_EdoCtaDir#">
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
					<cfreportparam name="LB_Identificacion" 	value="#LB_Identificacion#">
					<cfreportparam name="LB_omas" 		value="#LB_omas#">
					<cfreportparam name="LB_Morosidad" 	value="#LB_Morosidad#">
					<cfreportparam name="LB_TotalMon" 	value="#LB_TotalMon#">
					<cfreportparam name="LB_Criterio" 	value="#LB_Criterio#">
					<cfreportparam name="LB_ValorClasDesde" 	value="#LB_ValorClasDesde#">
					<cfreportparam name="LB_ValorClasHasta" 	value="#LB_ValorClasHasta#">
					<cfreportparam name="LB_SocioNegocioI" 	value="#LB_SocioNegocioI#">
					<cfreportparam name="LB_SocioNegocioF" 	value="#LB_SocioNegocioF#">
					<cfreportparam name="LB_FecCorte" 		value="#LB_FecCorte#">
			<cfreportparam name="LB_FolioReferencia" 	value="#LB_FolioReferencia#">

			<cfif isdefined("rsSNCEdescripcion") and rsSNCEdescripcion.recordcount eq 1>
				<cfreportparam name="SNCEdescripcion" value="#rsSNCEdescripcion.SNCEdescripcion#">
			</cfif>
			<cfif isdefined("rsSNCDdescripcion1") and rsSNCDdescripcion1.recordcount eq 1>
				<cfreportparam name="SNCDdescripcion1" value="#rsSNCDdescripcion1.SNCDdescripcion#">
			</cfif>
			<cfif isdefined("rsSNCDdescripcion2") and rsSNCDdescripcion2.recordcount eq 1>
				<cfreportparam name="SNCDdescripcion2" value="#rsSNCDdescripcion2.SNCDdescripcion#">
			</cfif>

			<cfif isdefined("rsSNnombre1") and rsSNnombre1.recordcount eq 1>
				<cfreportparam name="SNnombre" value="#rsSNnombre1.SNnombre#">
			</cfif>
			<cfif isdefined("rsSNnombre2") and rsSNnombre2.recordcount eq 1>
				<cfreportparam name="SNnombreb2" value="#rsSNnombre2.SNnombre#">
			</cfif>

			<cfif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
				<cfreportparam name="fechaDes" value="#LSDateFormat(url.fechaDes,"DD/MM/YYYY")#">
			</cfif>
			<cfif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				<cfreportparam name="fechaHas" value="#LSDateFormat(url.fechaHas,"DD/MM/YYYY")#">
			</cfif>

			<cfif isdefined("rsSNCEdescripcion_orden") and rsSNCEdescripcion_orden.recordcount eq 1>
				<cfreportparam name="SNCEdescripcion_orden" value="#rsSNCEdescripcion_orden.SNCEdescripcion#">
			</cfif>

			<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
				<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
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


<cf_qforms>
       <cf_qformsRequiredField name="SNcodigo"    description="#LB_SocioNegocioI#">
	    <cf_qformsRequiredField name="SNcodigob2"  description="#LB_SocioNegocioF#">
		 <cf_qformsRequiredField name="fechaDes"    description="#LB_Fecha_Desde#">
		  <cf_qformsRequiredField name="fechaHas"    description="#LB_Fecha_Hasta#">
		   <cf_qformsRequiredField name="SNCEid"      description="#BTN_Clasificacion#">
		    <!--- <cf_qformsRequiredField name="SNCDid1"     description="#LB_ValorClasDesde#">
			 <cf_qformsRequiredField name="SNCDid2"     description="#LB_ValorClasHasta#"> --->
			<!---   <cf_qformsRequiredField name="SNCEid_Orden" description="#LB_OrdImprClasif#"> --->
</cf_qforms>

<script language="javascript" type="text/javascript">
	function funcGenerar(){
	if (datediff(document.form1.fechaDes.value, document.form1.fechaHas.value) < 0)
		{
			<cfoutput>
       			<cfset MSG_FecMayor = t.Translate('MSG_FecMayor','La Fecha Hasta debe ser mayor a la Fecha Desde')>
				alert ('#MSG_FecMayor#');
				return false;
			</cfoutput>
		}
	}
</script>

