<!---
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 9-8-2005.
		Motivo: Se da tratamiento para que tome en cuenta los socios de negocios corporativos(Ecodigo is null)
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','SIF - Cuentas por Pagar')>
<cfset TIT_SocXClas 	= t.Translate('TIT_SocXClas','Socios de Negocios por Clasificación')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Datos del Reporte')>
<cfset LB_Clasif 		= t.Translate('LB_Clasif','Clasificaci&oacute;n')>
<cfset LB_ClasifSA 		= t.Translate('LB_Clasif','Clasificación')>
<cfset LB_ClasifDesde	= t.Translate('LB_ClasifDesde','Valor Clasificación desde')>
<cfset LB_ClasifHasta	= t.Translate('LB_ClasifHasta','Valor Clasificación hasta')>
<cfset LB_Estado 	= t.Translate('LB_Estado','Estado','/sif/generales.xml')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>

<cfset LB_Hora 	= t.Translate('LB_Hora','Hora')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificación','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset LB_Estado 	= t.Translate('LB_Estado','Estado','/sif/generales.xml')>
<cfset LB_CorpLoc 	= t.Translate('LB_CorpLoc','Corporativo/Local')>
<cfset LB_Criterio 	= t.Translate('LB_Criterio','Criterio de Seleción')>
<cfset LB_ClasifDesde	= t.Translate('LB_ClasifDesde','Valor Clasificación desde')>
<cfset LB_ClasifHasta	= t.Translate('LB_ClasifHasta','Valor Clasificación hasta')>
<cfset LB_Corporativo 	= t.Translate('LB_Corporativo','Corporativo')>
<cfset LB_Local 	= t.Translate('LB_Local','Local')>


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_SocXClas#'>

<cfquery name="rsValores" datasource="#session.dsn#">
	select b.SNCEid, b.SNCDid, b.SNCDdescripcion
	from SNClasificacionE a
		inner join SNClasificacionD b
			on b.SNCEid = a.SNCEid
	where a.Ecodigo =  #session.Ecodigo#
	ORDER BY a.SNCEcodigo, a.SNCEdescripcion
</cfquery>

 <cfquery name="rsEstados" datasource="#session.DSN#">
 	select ESNdescripcion, ESNid, ESNcodigo
	from EstadoSNegocios
	where Ecodigo = #session.Ecodigo#
 </cfquery>

<form name="form1" action="SociosxClasificacionCP.cfm" method="get">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend><cfoutput>#LB_DatosReporte#</cfoutput></legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong><cfoutput>#LB_Clasif#&nbsp;</cfoutput></strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<!--- <tr>
                	<cfoutput>
					<td>&nbsp;</td>
					<td width="10%"><strong>#LB_ClasifDesde#:&nbsp;</strong></td>
					<td width="10%"><strong>#LB_ClasifHasta#:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
                    </cfoutput>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid1" name="SNCDvalor1" desc="SNCDdescripcion1" tabindex="1"></td>
					<td width="10%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid2" name="SNCDvalor2" desc="SNCDdescripcion2" tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
				</tr> --->

				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong><cfoutput>&nbsp;&nbsp;&nbsp;#LB_Estado#:&nbsp;</cfoutput></strong>

					 <select name="ESNid" id="ESNid" tabindex="1">
						<cfoutput query="rsEstados">
						  <option value="#ESNid#">#ESNdescripcion#</option>
						</cfoutput>
					  </select>
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong><cfoutput>#LB_Formato#&nbsp;</cfoutput></strong>

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
</form>

<cf_templatefooter>
<cfif isdefined("url.Generar")>

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
		  <cfset filtro = " a.Ecodigo=#session.Ecodigo# ">
	<cfelse>
		  <cfset filtro = " a.Ecodigo is null ">
	</cfif>

	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
		select d.SNid, a.SNCEid, a.SNCEcodigo, a.SNCEdescripcion,  b.SNCDid, rtrim(ltrim(b.SNCDvalor)) as SNCDvalor, b.SNCDdescripcion,
		c.Edescripcion, e.ESNid, f.ESNdescripcion, e.SNnombre, e.SNidentificacion, case when e.SNidCorporativo > 0  then '#LB_Corporativo#' else '#LB_Local#'  end as Tipo_Socio
		from SNClasificacionE a
			inner join SNClasificacionD b
					inner join SNClasificacionSN d
							inner join SNegocios e
									inner join EstadoSNegocios f
										on f.ESNid = e.ESNid
										and f.Ecodigo = e.Ecodigo
								on e.SNid = d.SNid
						on d.SNCDid = b.SNCDid
				on b.SNCEid = a.SNCEid
			inner join Empresas c
				on c.Ecodigo = e.Ecodigo
		where #filtro#
			and e.Ecodigo =  #session.Ecodigo#
			 <cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
			and a.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
			 </cfif>
			 <!--- Valores de Clasificación --->
			<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
				<cfif url.SNCDvalor1 gte url.SNCDvalor2> <!--- si el primero es mayor que el segundo. --->
					and upper(b.SNCDvalor) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor2)#">
									 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor1)#">
				<cfelse>
					and upper(b.SNCDvalor) between <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor1)#">
									 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor2)#">
				</cfif>
			<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
				and upper(b.SNCDvalor) >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#">
			<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
				and upper(b.SNCDvalor) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.SNCDvalor2)#">
			</cfif>
			<cfif isdefined("url.ESNid") and len(trim(url.ESNid))>
				and f.ESNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESNid#">
			</cfif>
		order by b.SNCDid, a.SNCEcodigo, b.SNCDvalor
	</cfquery>

	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
		<cfset MSG_RegLim = t.Translate('MSG_RegLim','Se han generado mas de 5000 registros para este reporte.')>
		<cf_errorCode	code = "50196" msg = "#MSG_RegLim#">
		<cfabort>
	<cfelseif isdefined("rsReporte") and rsReporte.recordcount EQ 0>
		<cfset MSG_RegLim = t.Translate('MSG_RegLim','No se han generado registros para este reporte.')>
		<cf_errorCode	code = "50349" msg = "#MSG_RegLim#">
		<cfabort>
	</cfif>

	<!--- Busca descripción del Encabezado de la Clasificación --->
	<cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
		<cfquery name="rsSNCEid" datasource="#session.DSN#">
			select SNCEdescripcion
			from SNClasificacionE
			where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
			and Ecodigo =   #session.Ecodigo#
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

	<!--- Busca descripción del Estado del Socio de Negocios --->
	<cfif isdefined("url.ESNid") and len(trim(url.ESNid))>
		<cfquery name="rsESNid" datasource="#session.DSN#">
			select ESNdescripcion
			from EstadoSNegocios
			where ESNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESNid#">
			and Ecodigo =  #session.Ecodigo#
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
		fileName = "cp.consultas.reportes.SNegociosxCategoriasCP"/>
	<cfelse>
			<cfreport format="#formatos#" template= "SNegociosxCategoriasCP.cfr" query="rsReporte">
			<cfif isdefined("rsSNCEid") and rsSNCEid.recordcount gt 0>
				<cfreportparam name="SNCEdescripcion" value="#rsSNCEid.SNCEdescripcion#">
			</cfif>

			<!--- <cfif isdefined("rsSNCDid1") and rsSNCDid1.recordcount gt 0>
				<cfreportparam name="SNCDdescripcion1" value="#rsSNCDid1.SNCDdescripcion#">
			</cfif>

			<cfif isdefined("rsSNCDid2") and rsSNCDid2.recordcount gt 0>
				<cfreportparam name="SNCDdescripcion2" value="#rsSNCDid2.SNCDdescripcion#">
			</cfif> --->

			<cfif isdefined("rsESNid") and rsESNid.recordcount gt 0>
				<cfreportparam name="ESNdescripcion" value="#rsESNid.ESNdescripcion#">
			</cfif>
					<cfreportparam name="LB_Fecha" 		value="#LB_Fecha#">
					<cfreportparam name="LB_Hora" 		value="#LB_Hora#">
					<cfreportparam name="TIT_SocXClas" 	value="#TIT_SocXClas#">
					<cfreportparam name="LB_ClasifSA" 	value="#LB_ClasifSA#">
					<cfreportparam name="LB_SocioNegocio" 	value="#LB_SocioNegocio#">
					<cfreportparam name="LB_Criterio" 	value="#LB_Criterio#">
					<cfreportparam name="LB_ClasifDesde" 	value="#LB_ClasifDesde#">
					<cfreportparam name="LB_ClasifHasta" 	value="#LB_ClasifHasta#">
					<cfreportparam name="LB_Estado" 	value="#LB_Estado#">
					<cfreportparam name="LB_CorpLoc" 	value="#LB_CorpLoc#">
					<cfreportparam name="LB_Identificacion" value="#LB_Identificacion#">
		</cfreport>
	</cfif>
</cfif>

<cf_qforms form ="form1">
<cfoutput>
<script language="javascript" type="text/javascript">
<!-- //
	objForm.SNCEcodigo.required = true;
	objForm.SNCEcodigo.description="#LB_ClasifSA#";
	document.form1.SNCEcodigo.focus();
//-->
</script>
</cfoutput>

