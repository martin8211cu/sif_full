<!--- 
	Creado por Marco Saborío
		Fecha: 23-01-2007
 --->

<cfquery name="rsCodICTS" datasource="sifinterfaces">
	select EQUempOrigen as CodICTS, EQUempSIF as Ecodigo, EQUcodigoSIF as EcodigoSDC, EQUdescripcion as Edescripcion
	from SIFLD_Equivalencia
	where EQUcodigoSIF = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	and CATcodigo = 'CADENA'
</cfquery>

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cobros y Pagos'>

<cfif isdefined("url.FechaI") and not isdefined("form.FechaI")>
	<cfset form.FechaI = url.FechaI>
</cfif>

<cfif isdefined("url.FechaF") and not isdefined("form.FechaF")>
	<cfset form.FechaF = url.FechaF>
</cfif>

<cfquery name="rsMonedas" datasource="#session.DSN#">
	select Mcodigo, Mnombre, Miso4217
	from Monedas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Mnombre 
</cfquery>

<cfoutput>
	<form name="form1" method="post" action="interfaz11PMI-sql.cfm">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top" align="center">
			<fieldset><legend>Datos del Proceso</legend>
				<table  width="100%" align="center" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>
				<!--- CAMBIO PARA EXTRAER DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF --->
							<tr>
								<td align="center" nowrap="nowrap" colspan="2">Seleccione Empresa ICTS a procesar:</td>
							</tr>
							<tr>
								<td colspan="2" align="center">
									<select name="CodICTS">
										<cfloop query="rsCodICTS">
											<option value="#rsCodICTS.CodICTS#"> #rsCodICTS.CodICTS# - #rsCodICTS.Edescripcion# </option>
										</cfloop>
									</select>
								</td>
							</tr>
							
					<tr>
								
						<td align="right"><strong>Fecha&nbsp;Desde:</strong></td>
						<td >
							<cfif isdefined("form.FechaI") and len(trim(form.FechaI))>
								<cf_sifcalendario form="form1" value="#form.FechaI#" name="FechaI" tabindex="1"> 
							<cfelse>	
								<cfset LvarFecha = createdate(year(now()),month(now()),1)>
								<cf_sifcalendario form="form1" value="#DateFormat(LvarFecha, 'dd/mm/yyyy')#" name="FechaI" tabindex="1"> 
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Hasta:</strong></td>
						<td>
							<cfif isdefined("form.FechaF") and len(trim(form.FechaF))>
								<cf_sifcalendario form="form1" value="#form.FechaF#" name="FechaF" tabindex="1"> 
							<cfelse>
								<cf_sifcalendario form="form1" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="FechaF" tabindex="1"> 
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Cobros</strong></td>
						<td>
							<input type="checkbox" name="Cobros" value="1" tabindex="1" />
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Pagos</strong></td>
						<td>
							<input type="checkbox" name="Pagos" value="1" tabindex="1" />
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Socio de Negocio</strong></td>
						<td>
							<input type="Textbox" name="SocioN" />
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Monedas</strong></td>
						<td>
							<select id="Moneda" name="Moneda" tabindex="1">
								<cfloop query="rsMonedas">
									<option value="<cfoutput>#rsMonedas.Miso4217#</cfoutput>" ><cfoutput>#rsMonedas.Mnombre#</cfoutput></option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><cf_botones values="Generar" names="Generar" tabindex="1"></td></tr>
				</table>
				</fieldset>
			</td>	
		</tr>
	</table>
	</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>
<script language="javascript" type="text/javascript">
	objForm.FechaI.required=true;
	objForm.FechaI.description='Fecha Desde';
	objForm.FechaF.required=true;
	objForm.FechaF.description='Fecha Hasta';
</script>

