<!--- Area de Consultas --->
<!--- empresas por Cuenta Empresarial --->
<cf_dbfunction name="OP_concat" returnvariable="_Cat">

<cfquery name="rsEmpresa" datasource="asp">
	select  Ecodigo
	from Empresa
	where CEcodigo = #session.CEcodigo#
		and Ereferencia is not null
</cfquery>
<cfset empresas ="">
<cfloop query="rsEmpresa">
	<cfset empresas = empresas & rsEmpresa.Ecodigo & ','>
</cfloop>
<cfset empresas = empresas & '-1'>

<!--- Activos --->
<cfif (isdefined("url.Aplaca") and len(trim(url.Aplaca))) or (isdefined("url.Aserie") and len(trim(url.Aserie))) or (isdefined("url.Responsable") and len(trim(url.Responsable))) >

	<cfif (isdefined("url.Responsable") and len(trim(url.Responsable)))>
		<cfset responsable = uCase(#url.Responsable#)>
	</cfif>

	<cfquery name="rsActivos" datasource="#session.dsn#">
		select a.Ecodigo,a.Aid,d.Edescripcion,a.Aplaca,a.Adescripcion,a.Aserie,b.AFMdescripcion as marca,c.AFMMdescripcion as modelo
		from Activos a
			left outer join AFMarcas b
				on b.AFMid = a.AFMid
			left outer join AFMModelos c
				on c.AFMMid = a.AFMMid
			inner join Empresas d
				on a.Ecodigo = d.Ecodigo
				and d.EcodigoSDC in (#empresas#)
			inner join AFResponsables e
				on a.Aid = e.Aid
<!---				and AFRffin = (select max(AFRffin) from AFResponsables x where x.Aid = e.Aid and x.Ecodigo = e.Ecodigo)
--->				inner join DatosEmpleado f
					on e.DEid = f.DEid
		where 1=1
		<cfif (isdefined("url.Aplaca") and len(trim(url.Aplaca))) and (isdefined("url.Aserie") and len(trim(url.Aserie)))>
			and ( a.Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Aplaca#">
				  or
				  a.Aserie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Aserie#">
				)
		<cfelseif (isdefined("url.Aplaca") and len(trim(url.Aplaca))) or (isdefined("url.Aserie") and len(trim(url.Aserie)))>
			<cfif (isdefined("url.Aplaca") and len(trim(url.Aplaca)))>
				and a.Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Aplaca#">
			</cfif>

			<cfif (isdefined("url.Aserie") and len(trim(url.Aserie)))>
				and a.Aserie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Aserie#">
			</cfif>
		</cfif>
		<cfif (isdefined("url.Responsable") and len(trim(url.Responsable)))>
		and <cf_dbfunction name="like" args="upper( rtrim(DEnombre) #_Cat# rtrim(DEapellido1) #_Cat# rtrim(DEapellido2)) , '%' #_Cat# '#url.Responsable#' #_Cat# '%'">			
		</cfif>
		and AFRffin = (select max(AFRffin) from AFResponsables x where x.Aid = e.Aid and x.Ecodigo = e.Ecodigo)
	</cfquery>
	<cfif rsActivos.recordCount eq 1>
		<cflocation url="../../catalogos/Activos.cfm?tab=1&aid=#rsActivos.aid#&Ecodigo=#rsActivos.Ecodigo#&consulta=S">
	</cfif>
</cfif>
<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
			<form name="form1" method="get" action="Activos.cfm">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<cfoutput>
					<tr><td nowrap colspan="2">&nbsp;</td></tr>
					<tr>
						<td valign="top" width="40%" align="center">
							<table width="98%" border="0" cellspacing="0" cellpadding="2" align="center">
								<tr>
									<td>
										<cf_web_portlet_start border="true" titulo="Consulta de Activos en Cuenta Empresarial" skin="info1">
											En esta consulta se muestra la informaci&oacute;n de un activo.
											La busqueda del mismo se hace por n&uacute;mero de placa o serie
											sin importar en que empresa se encuentre.
										<cf_web_portlet_end>
									</td>
								</tr>
							</table>
						</td>

						<td valign="top" width="60%" align="center">
							<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">

								<tr>
							  	  <td class="fileLabel" align="right">Placa:</td>
							      <td>
										<input type="text" name="Aplaca" size="50" maxlength="50" tabindex="1" value="<cfif (isdefined("url.Aplaca") and len(trim(url.Aplaca)))>#url.Aplaca#</cfif>">

								  </td>
							  	</tr>
								<tr>
								    <td class="fileLabel" align="right">Serie:</td>
								    <td>
										<input type="text" name="Aserie" size="50" maxlength="50" tabindex="1" value="<cfif (isdefined("url.Aserie") and len(trim(url.Aserie)))>#url.Aserie#</cfif>">
									</td>
								</tr>
								<tr>
								    <td class="fileLabel" align="right">Responsable:</td>
								    <td>
										<input type="text" name="Responsable" size="50" maxlength="50" tabindex="1" value="<cfif (isdefined("url.Responsable") and len(trim(url.Responsable)))>#url.Responsable#</cfif>">
									</td>
								</tr>
								<tr><td colspan="4">&nbsp;</td></tr>
								<tr>
									<td colspan="4" align="center">
										<cf_botones values="Consultar,Limpiar" tabindex="1">
									</td>
								</tr>
								<tr><td colspan="4">&nbsp;</td></tr>
							</table>
						</td>
					</tr>
					</cfoutput>
					<tr><td colspan="2" align="center" valign="top">&nbsp;</td></tr>
					<cfif isdefined("rsActivos") and  rsActivos.recordCount GT 1>
					<tr>
						<td colspan="2" align="center" valign="top">
							<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
								<tr bgcolor="#CCCCCC">
									<td nowrap><strong>Empresa</strong></td>
									<td nowrap><strong>N&uacute;m. Placa</strong></td>
									<td nowrap><strong>Serie</strong></td>
									<td nowrap><strong>Descripci&oacute;n del activo</strong></td>
									<td nowrap><strong>Marca</strong></td>
									<td nowrap><strong>Modelo</strong></td>
								</tr>
								<cfoutput query="rsActivos">
									<tr onClick="javascript:ver(#rsActivos.Ecodigo#,#rsActivos.Aid#);" style="cursor:pointer;"
										class="<cfif rsActivos.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>"
										onmouseover="style.backgroundColor='##E4E8F3';"
										onMouseOut="style.backgroundColor='<cfif rsActivos.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>'"
									 >
										<td valign="top">#rsActivos.Edescripcion#</td>
										<td valign="top">#rsActivos.Aplaca#</td>
										<td valign="top">#rsActivos.Aserie#</td>
										<td valign="top">#rsActivos.Adescripcion#</td>
										<td valign="top">#rsActivos.marca#</td>
										<td valign="top">#rsActivos.modelo#</td>
									</tr>
								</cfoutput>
							</table>
						</td>
					</tr>
					<input type="hidden" name="tab" value="1">
					<input type="hidden" name="Aid" value="">
					<input type="hidden" name="Ecodigo" value="">
					<input type="hidden" name="consulta" value="S">

					<cfelseif isdefined("rsActivos") and rsActivos.recordCount eq 0>
					<tr>
						<td colspan="2" align="center" valign="top">
							<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
								<tr bgcolor="#CCCCCC">
									<td align="center"><strong>La consulta no retorno datos </strong></td>
								</tr>
						</table>
						</td>
					</tr>
					</cfif>
				</table>
			</form>
		<cf_web_portlet_end>
	<cf_templatefooter>

<script language="javascript1.2" type="text/javascript">
		function ver(Ecodigo,Aid){
			document.form1.Ecodigo.value = Ecodigo;
			document.form1.Aid.value = Aid;
			document.form1.action = "../../catalogos/Activos.cfm";
			document.form1.submit();
		}
</script>