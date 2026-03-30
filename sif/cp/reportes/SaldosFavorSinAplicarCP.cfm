<!---
	Creado por Gustavo Fonseca H.
		Fecha: 13-5-2005.
		Motivo: Nuevo reporte de Saldos a Favor sin aplicar en CxP.
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 9-8-2005.
		Motivo: Se da tratamiento para que tome en cuenta los socios de negocios corporativos(Ecodigo is null)

	Modificado por Gustavo Fonseca Hernández.
		Fecha: 11-10-2005.
		Motivo: Se corrigen filtros de clasificación y de socio de negocios, antes filtraba por SNcodigo y por SNCDid... ahora quedó por SNnuemro y SNCDvalor1.
		También filtra los socios por empresa.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','SIF - Cuentas por Pagar')>
<cfset TIT_SaldosaFavor	= t.Translate('TIT_SaldosaFavor','Saldos&nbsp;a&nbsp;Favor&nbsp;sin&nbsp;Aplicar')>
<cfset LB_DatosRep 		= t.Translate('LB_DatosRep','Datos del Reporte')>
<cfset LB_ClasSoc 		= t.Translate('LB_ClasSoc','Clasificaci&oacute;n de Socios')>
<cfset LB_ClasDirSoc 	= t.Translate('LB_ClasDirSoc','Clasificaci&oacute;n de Direcci&oacute;n de Socio')>
<cfset LB_Clasif 		= t.Translate('LB_Clasif','Clasificaci&oacute;n')>
<cfset LB_ClasifSA 		= t.Translate('LB_Clasif','Clasificación')>
<cfset LB_ClasifDesde	= t.Translate('LB_ClasifDesde','Valor Clasificación desde')>
<cfset LB_ClasifHasta	= t.Translate('LB_ClasifHasta','Valor Clasificación hasta')>
<cfset LB_Socio_Ini = t.Translate('LB_Socio_Ini','Socio de Negocios Inicial')>
<cfset LB_Socio_Fin = t.Translate('LB_Socio_Fin','Socio de Negocios Final')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacción','/sif/generales.xml')>
<cfset LB_Debito 	= t.Translate('LB_Debito','Débito')>
<cfset LB_Credito 	= t.Translate('LB_Credito','Crédito')>
<cfset LB_Ambos 	= t.Translate('LB_Ambos','Ambos')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset TIT_SalSAplXClas 	= t.Translate('TIT_SalSAplXClas','Saldos sin Aplicar por Clasificación: por Socio')>
<cfset TIT_SalSAplXClasXD 	= t.Translate('TIT_SalSAplXClasXD','Saldos sin Aplicar por Clasificación: por Dirección')>

<cfset LB_Hora 	= t.Translate('LB_Hora','Hora')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Valor = t.Translate('LB_Valor','Valor','/sif/generales.xml')>
<cfset LB_SaldoTot 	= t.Translate('LB_SaldoTot','Saldo Total')>
<cfset MSG_Codigo 	= t.Translate('MSG_Codigo','Código','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset LB_Total 	= t.Translate('LB_Total','Total')>
<cfset LB_Criterio 	= t.Translate('LB_Criterio','Criterio de Selección')>
<cfset BTN_Clasificacion = t.Translate('BTN_Clasificacion','Clasificación','/sif/generales.xml')>
<cfset LB_ClasifDesde	= t.Translate('LB_ClasifDesde','Valor Clasificación desde')>
<cfset LB_ClasifHasta	= t.Translate('LB_ClasifHasta','Valor Clasificación hasta')>
<cfset LB_Socio_Ini = t.Translate('LB_Socio_Ini','Socio de Negocios Inicial')>
<cfset LB_Socio_Fin = t.Translate('LB_Socio_Fin','Socio de Negocios Final')>
<cfset LB_OficIni	= t.Translate('LB_OficIni','Oficina Inicial')>
<cfset LB_OficFin	= t.Translate('LB_OficFin','Oficina Final')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Monto		= t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_CxP 		= t.Translate('LB_CxP','Cuentas por Pagar')>


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_SaldosaFavor#'>

<form name="form1" action="SaldosFavorSinAplicarCP.cfm" method="get">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>#LB_DatosRep#</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3">
						<input name="TClasif" id="TClasif1" type="radio" value="0" checked tabindex="1">
						<label for="TClasif1" style="font-style:normal; font-variant:normal;">#LB_ClasSoc#</label>
						<input name="TClasif" id="TClasif2" type="radio" value="1" tabindex="1">
						<label for="TClasif2"  style="font-style:normal; font-variant:normal;">#LB_ClasDirSoc#</label>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Clasif#&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<!--- <tr>
					<td>&nbsp;</td>
					<td width="10%"><strong>#LB_ClasifDesde#:&nbsp;</strong></td>
					<td width="10%"><strong>#LB_ClasifHasta#:&nbsp;</strong></td>
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
					<td nowrap align="left" width="10%"><strong>#LB_Socio_Ini#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_Socio_Fin#:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2 Proveedores="SI"></td>
					 <td align="left"><cf_sifsociosnegocios2 Proveedores="SI" form ="form1" frame="frsocios2" SNcodigo="SNcodigob2" SNnombre="SNnombreb2" SNnumero="SNnumerob2"></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong>#LB_Transaccion#:&nbsp;</strong>

					<select name="fCCTtipo" id="fCCTtipo" tabindex="1">
						<option value="1">#LB_Debito#</option>
						<option value="2">#LB_Credito#</option>
						<option value="3">#LB_Ambos#</option>
					</select>
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LB_Formato#&nbsp;</strong>

					<select name="Formato" id="Formato" tabindex="1">
						<option value="2">PDF</option>
					</select>
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">
					<cf_botones values="Generar" names="Generar" tabindex="1">
					</td>
				</tr>
			</table>
			</fieldset>
		  	<cf_web_portlet_end>
		</td>
	</tr>
</table>
</cfoutput>
</form>

<cf_templatefooter>
<cfif isdefined("url.Generar")>
	<cfif isdefined("url.fCCTtipo") and len(trim(url.fCCTtipo)) and url.fCCTtipo EQ 1>
		<cfset tran = 'D'>
		<cfset Rtran = '#LB_Debito#'>
	<cfelseif isdefined("url.fCCTtipo") and len(trim(url.fCCTtipo)) and url.fCCTtipo EQ 2>
		<cfset tran = 'C'>
		<cfset Rtran = '#LB_Credito#'>
	<cfelseif isdefined("url.fCCTtipo") and len(trim(url.fCCTtipo)) and url.fCCTtipo EQ 3>
		<cfset Rtran = '#LB_Ambos#'>
	</cfif>


	<cfquery name="rsConsultaCorp" datasource="asp">
		select *
		from CuentaEmpresarial
		where Ecorporativa is not null
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
	</cfquery>
	<cfif isdefined('session.Ecodigo') and
		  isdefined('session.Ecodigocorp') and
		  session.Ecodigo NEQ session.Ecodigocorp and
		  rsConsultaCorp.RecordCount GT 0>
		  <cfset filtro = " h.Ecodigo=#session.Ecodigo# ">
	<cfelse>
		  <cfset filtro = " h.Ecodigo is null ">
	</cfif>

	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
		select a.Ddocumento,
			a.Dfecha,
			a.Dfechavenc,
			a.Dtotal,
			<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
			c.SNnumero,
			c.SNnombre,
			<cfelse>
			coalesce(ds.SNDcodigo,c.SNnumero) as SNnumero,
			coalesce(ds.SNnombre,c.SNnombre) as SNnombre,
			</cfif>
			b.CPTcodigo as CCTcodigo,
			d.Mcodigo,
			d.Mnombre,
			e.Edescripcion,
			case b.CPTtipo when  'C' then +(a.EDsaldo)else -(a.EDsaldo)end as Dsaldodc,
			h.SNCEdescripcion,
			h.SNCEid,
			h.SNCEcodigo,
			g.SNCDid,
			g.SNCDvalor,
			g.SNCDdescripcion
		from EDocumentosCP a
			inner join CPTransacciones b
				on  b.Ecodigo = a.Ecodigo
				and b.CPTcodigo = a.CPTcodigo
			inner join SNegocios c
				on c.Ecodigo = a.Ecodigo
				and c.SNcodigo = a.SNcodigo
			inner join Monedas d
				on d.Ecodigo = a.Ecodigo
				and d.Mcodigo = a.Mcodigo
			inner join Empresas e
				on e.Ecodigo = a.Ecodigo
			<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
				inner join SNClasificacionSN f
					on  f.SNid = c.SNid
			<cfelse>
				inner join SNDirecciones ds
				   on ds.SNid = c.SNid
				  and ds.Ecodigo = c.Ecodigo
				  and ds.SNcodigo = c.SNcodigo
				  and ds.id_direccion = a.id_direccion

				inner join SNClasificacionSND f
				   on f.SNid = ds.SNid
				  and f.id_direccion = ds.id_direccion
			</cfif>

			inner join SNClasificacionD g
				on g.SNCDid = f.SNCDid
			inner join SNClasificacionE h
				on h.SNCEid = g.SNCEid
		where #filtro#
			and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and h.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
			<cfif isdefined("tran") and len(trim(tran))>
			and b.CPTtipo = <cfqueryparam cfsqltype="cf_sql_char" maxlength="1" value="#tran#">
			</cfif>
			and a.EDsaldo = a.Dtotal
			<!--- Clasificación --->
			<cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
				and h.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
			</cfif>
			<!--- Valores de Clasificación --->
			<!--- <cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
				<cfif url.SNCDvalor1 gte url.SNCDvalor2> <!--- si el primero es mayor que el segundo. --->
					and upper(g.SNCDvalor) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor2)#">
									 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor1)#">
				<cfelse>
					and upper(g.SNCDvalor) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor1)#">
									 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor2)#">
				</cfif>
			<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
				and upper(g.SNCDvalor) >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#">
			<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
				and upper(g.SNCDvalor) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor2)#">
			</cfif> --->
			<!--- Socio de negocios --->
			<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero)) gt 0 and isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2)) gt 0>
				<cfif url.SNnumero gte SNnumerob2><!--- si el primero es mayor que el segundo. --->
						and upper(c.SNnumero) between <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(url.SNnumerob2)#">
											and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
				<cfelse>
						and upper(c.SNnumero) between <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(url.SNnumero)#">
											and <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(url.SNnumerob2)#">
				</cfif>
			<cfelseif isdefined("url.SNnumero") and len(trim(url.SNnumero)) gt 0>
				and upper(c.SNnumero) >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
			<cfelseif isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2)) gt 0>
				and upper(c.SNnumero) <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
			</cfif>
		order by d.Mcodigo, h.SNCEid, g.SNCDid
	</cfquery>

	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
   		<cfset MSG_RegLim = t.Translate('MSG_RegLim','Se han generado mas de 5000 registros para este reporte.')>
		<cf_errorCode	code = "50196" msg = "#MSG_RegLim#">
		<cfabort>
	</cfif>

	<!--- Busca descripción del Encabezado de la Clasificación --->
	<cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
		<cfquery name="rsSNCEid" datasource="#session.DSN#">
			select SNCEdescripcion
			from SNClasificacionE
			where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
			and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>

	<!--- Busca descripción del Detalle 1 de la Clasificación --->
	<!--- <cfif isdefined("url.SNCDid1") and len(trim(url.SNCDid1))>
		<cfquery name="rsSNCDid1" datasource="#session.DSN#">
			select SNCDdescripcion
			from SNClasificacionD
			where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid1#">
		</cfquery>
	</cfif> --->

	<!--- Busca descripción del Detalle 2 de la Clasificación --->
	<!--- <cfif isdefined("url.SNCDid2") and len(trim(url.SNCDid2))>
		<cfquery name="rsSNCDid2" datasource="#session.DSN#">
			select SNCDdescripcion
			from SNClasificacionD
			where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid2#">
		</cfquery>
	</cfif> --->

	<!--- Busca nombre del Socio de Negocios 1 --->
	<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
		<cfquery name="rsSNcodigo" datasource="#session.DSN#">
			select SNnombre
			from SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
			and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>

	<!--- Busca nombre del Socio de Negocios 2 --->
	<cfif isdefined("url.SNcodigob2") and len(trim(url.SNcodigob2))>
		<cfquery name="rsSNcodigob2" datasource="#session.DSN#">
			select SNnombre
			from SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigob2#">
			and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>



	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	</cfif>

    <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and formatos EQ "excel">
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cp.consultas.reportes.SaldosFavorSinAplicarCP"/>
	<cfelse>
			<cfreport format="#formatos#" template= "SaldosFavorSinAplicarCP.cfr" query="rsReporte">
			<cfif isdefined("rsSNCEid") and rsSNCEid.recordcount gt 0>
				<cfreportparam name="SNCEdescripcion" value="#rsSNCEid.SNCEdescripcion#">
			</cfif>

			<!---
	<cfif isdefined("rsSNCDid1") and rsSNCDid1.recordcount gt 0>
				<cfreportparam name="SNCDdescripcion1" value="#rsSNCDid1.SNCDdescripcion#">
			</cfif>

			<cfif isdefined("rsSNCDid2") and rsSNCDid2.recordcount gt 0>
				<cfreportparam name="SNCDdescripcion2" value="#rsSNCDid2.SNCDdescripcion#">
			</cfif>
	--->

			<cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
				<cfreportparam name="SNcodigo" value="#rsSNcodigo.SNnombre#">
			</cfif>
			<cfif isdefined("rsSNcodigob2") and rsSNcodigob2.recordcount gt 0>
				<cfreportparam name="SNcodigob2" value="#rsSNcodigob2.SNnombre#">
			</cfif>

			<cfif isdefined("Rtran") and len(trim(Rtran))>
				<cfreportparam name="transaccion" value="#Rtran#">
			</cfif>
			<cfif isdefined("url.TClasif") and url.TClasif EQ 0>
				<cfreportparam name="Titulo" value="#TIT_SalSAplXClas#">
			<cfelse>
				<cfreportparam name="Titulo" value="#TIT_SalSAplXClasXD#">
			</cfif>
			<cfreportparam name="TClasif" value="#url.TClasif#">
					<cfreportparam name="LB_Fecha" 		value="#LB_Fecha#">
					<cfreportparam name="LB_Hora" 		value="#LB_Hora#">
					<cfreportparam name="LB_Moneda" 	value="#LB_Moneda#">
					<cfreportparam name="LB_ClasifSA" 	value="#LB_ClasifSA#">
					<cfreportparam name="LB_Valor" 		value="#LB_Valor#">
					<cfreportparam name="LB_SaldoTot" 	value="#LB_SaldoTot#">
					<cfreportparam name="MSG_Codigo" 	value="#MSG_Codigo#">
					<cfreportparam name="LB_SocioNegocio" 	value="#LB_SocioNegocio#">
					<cfreportparam name="LB_Total" 		value="#LB_Total#">
					<cfreportparam name="LB_Criterio" 	value="#LB_Criterio#">
					<cfreportparam name="LB_ClasifDesde" 	value="#LB_ClasifDesde#">
					<cfreportparam name="LB_ClasifHasta" 	value="#LB_ClasifHasta#">
					<cfreportparam name="LB_Socio_Ini" 	value="#LB_Socio_Ini#">
					<cfreportparam name="LB_Socio_Fin" 	value="#LB_Socio_Fin#">
					<cfreportparam name="LB_Documento" 	value="#LB_Documento#">
					<cfreportparam name="LB_Monto" 		value="#LB_Monto#">
					<cfreportparam name="LB_Transaccion" value="#LB_Transaccion#">
				<cfreportparam name="LB_CxP" 		value="#LB_CxP#">
		</cfreport>
	</cfif>
</cfif>
<cf_qforms>
       <cf_qformsRequiredField name="SNCEcodigo" description="#LB_ClasifSA#">
</cf_qforms>

