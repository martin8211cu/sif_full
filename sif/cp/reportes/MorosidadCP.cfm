<!---
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 9-8-2005.
		Motivo: Se da tratamiento para que tome en cuenta los socios de negocios corporativos(Ecodigo is null)
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 11-10-2005.
		Motivo: Se corrigen filtros de clasificación y de socio de negocios, antes filtraba por SNcodigo y por SNCDid... ahora quedó por SNnuemro y SNCDvalor1.
		También filtra los socios por empresa.
 --->

<cf_templateheader title="SIF - Cuentas por Pagar">

<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Morosidad">


<form name="form1" action="MorosidadCP.cfm" method="get">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>Datos del Reporte</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3">
						<input name="TClasif" id="TClasif1" type="radio" value="0" checked tabindex="1">
						<label for="TClasif1" style="font-style:normal; font-variant:normal;">Clasificaci&oacute;n de Socios</label>
						<input name="TClasif" id="TClasif2" type="radio" value="1" tabindex="1">
						<label for="TClasif2"  style="font-style:normal; font-variant:normal;">Clasificaci&oacute;n de Direcci&oacute;n de Socios</label>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Clasificaci&oacute;n&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<!--- <tr>
					<td>&nbsp;</td>
					<td width="10%"><strong>Valor&nbsp;Clasificaci&oacute;n&nbsp;desde:&nbsp;</strong></td>
					<td width="10%"><strong>Valor&nbsp;Clasificaci&oacute;n&nbsp;hasta:&nbsp;</strong></td>
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
					<td nowrap align="left" width="10%"><strong>Socio&nbsp;de&nbsp;Negocios&nbsp;Inicial:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>Socio&nbsp;de&nbsp;Negocios&nbsp;Final:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2 Proveedores="SI" tabindex="1"></td>
					 <td align="left"><cf_sifsociosnegocios2 Proveedores="SI" form ="form1" frame="frsocios2" SNcodigo="SNcodigob2" SNnombre="SNnombreb2" SNnumero="SNnumerob2" tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Oficina&nbsp;Inicial:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>Oficina&nbsp;Final:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifoficinas tabindex="1"></td>
					 <td align="left"><cf_sifoficinas Ocodigo="Ocodigo2" Oficodigo="Oficodigo2" Odescripcion="Odescripcion2" tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Fecha&nbsp;de&nbsp;Corte:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>D&iacute;as&nbsp;Vencidos:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>

				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left"><cf_sifcalendario name="fechaDes" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					<td nowrap align="left"><input name="Dvencimiento" value="" type="text" tabindex="1"> </td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong>Formato:&nbsp;</strong>

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
		  <cfset filtro = " h.Ecodigo=#session.Ecodigo# ">
	<cfelse>
		  <cfset filtro = " h.Ecodigo is null ">
	</cfif>

	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
	select
		 <cf_dbfunction name="datediff" args="a.Dfechavenc, '#lsdateformat(url.fechaDes,'dd/mm/yyyy')#'"> as Dias_Vencido,
		 b.CPTcodigo as CCTcodigo,
		 a.Ddocumento,
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
			inner join Monedas d
				on d.Ecodigo = a.Ecodigo
				and d.Mcodigo = a.Mcodigo
			inner join Empresas e
				on e.Ecodigo = a.Ecodigo
		where #filtro#
			and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and h.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
			and <cf_dbfunction name="datediff" args="a.Dfechavenc, '#lsdateformat(url.fechaDes,'dd/mm/yyyy')#'"> >= <cfqueryparam cfsqltype="cf_sql_integer" value="#Dvencimiento#">
			and b.CPTtipo = 'C'
			and EDsaldo > 0
			<!--- Valores de Clasificación --->
			<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
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
			</cfif>
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
		<cf_errorCode	code = "50196" msg = "Se han generado mas de 5000 registros para este reporte.">
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
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and formatos eq "excel">
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cp.consultas.reportes.MorosidadCP"/>
	<cfelse>
		<cfreport format="#formatos#" template= "MorosidadCP.cfr" query="rsReporte">
			<cfif isdefined("rsSNCEid") and rsSNCEid.recordcount gt 0>
				<cfreportparam name="SNCEdescripcion" value="#rsSNCEid.SNCEdescripcion#">
			</cfif>

			<!--- <cfif isdefined("rsSNCDid1") and rsSNCDid1.recordcount gt 0>
				<cfreportparam name="SNCDdescripcion1" value="#rsSNCDid1.SNCDdescripcion#">
			</cfif>

			<cfif isdefined("rsSNCDid2") and rsSNCDid2.recordcount gt 0>
				<cfreportparam name="SNCDdescripcion2" value="#rsSNCDid2.SNCDdescripcion#">
			</cfif> --->

			<cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
				<cfreportparam name="SNcodigo" value="#rsSNcodigo.SNnombre#">
			</cfif>
			<cfif isdefined("rsSNcodigob2") and rsSNcodigob2.recordcount gt 0>
				<cfreportparam name="SNcodigob2" value="#rsSNcodigob2.SNnombre#">
			</cfif>

			<cfif isdefined("url.Dvencimiento") and len(trim(url.Dvencimiento))>
				<cfreportparam name="Dvencimiento" value="#url.Dvencimiento#">
			</cfif>
			<cfif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
				<cfreportparam name="fechaDes" value="#url.fechaDes#">
			</cfif>
			<cfif isdefined("url.TClasif") and url.TClasif EQ 0>
				<cfreportparam name="Titulo" value="Morosidad (Socios de Negocios)">
			<cfelse>
				<cfreportparam name="Titulo" value="Morosidad (Dirección de Socios de Negocios)">
			</cfif>
			<cfreportparam name="TClasif" value="#url.TClasif#">

		</cfreport>
	</cfif>
</cfif>
<cf_qforms form ="form1">
<script language="javascript" type="text/javascript">
<!-- //
	objForm.SNCEcodigo.required = true;
	objForm.SNCEcodigo.description="Clasificación";

	objForm.Dvencimiento.required = true;
	objForm.Dvencimiento.description="Días Vencidos";

//-->
</script>





