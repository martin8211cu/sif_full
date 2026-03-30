<title>Retirar Centro Funcional</title>

<!--- Asignación de valores a las variables del form --->	
<cfif isDefined("url.DEid") and not isDefined("form.DEid")>
	<cfset form.DEid = url.DEid>
</cfif>

<cfquery name="rsDatos" datasource="#session.dsn#">
	select 
		a.ECFlinea,
		a.CFid,
		a.ECFencargado,
		a.ECFdesde,
		a.ECFhasta,
		b.CFcodigo,
		b.CFdescripcion 
	from EmpleadoCFuncional a
		inner join CFuncional b
		on a.Ecodigo = b.Ecodigo
		and a.CFid = b.CFid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between a.ECFdesde and a.ECFhasta   
</cfquery>

<cfoutput>
<form name="form2" id="form2" method="post" action="empleadosCF-retirarCFSQL.cfm">
	<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
	<input type="hidden" name="DEid" value="#form.DEid#">
	<input type="hidden" name="ECFlinea" value="#rsDatos.ECFlinea#">
	<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center">
		<!--- Línea No. 1 --->
		<tr><td>&nbsp;</td></tr>
		<!--- Línea No. 2 --->
		<cfif isdefined("rsDatos") and rsDatos.recordcount GT 0>
			<tr>
				<td>
					<fieldset>
						<legend><strong>Informaci&oacute;n del Centro Funcional</strong></legend>			
						<table width="100%" border="0" cellspacing="2" cellpadding="0">
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td width="30%" class="fileLabel"><strong>Centro Funcional</strong></td>
								<td>#rsDatos.CFcodigo# - #rsDatos.CFdescripcion#</td>
							</tr>						
							<tr>
								<td width="30%" class="fileLabel"><strong>Encargado</strong></td>
								<td>
									<input type="checkbox" name="ECFencargado" id="ECFencargado" value="0" tabindex="1" <cfif #rsDatos.ECFencargado# EQ 1>checked</cfif> disabled >
								</td>	
							</tr>
							<tr>
								<td colspan="2">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="30%" class="fileLabel"><strong>Fecha Desde</strong></td>
											<td>
												<cf_sifcalendario form="form2" value="#DateFormat(rsDatos.ECFdesde,'dd/mm/yyyy')#" name="ECFdesde" tabindex="1" readOnly="true">
											</td>
											<td class="fileLabel"><strong>Fecha Hasta</strong></td>
											<td>
												<cf_sifcalendario form="form2" value="#DateFormat(rsDatos.ECFhasta,'dd/mm/yyyy')#" name="ECFhasta" tabindex="1">
											</td>	
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
		<cfelse>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center">
					<span style="font-size:16px; font-weight:bold;  ">
						No hay una l&iacute;nea de tiempo vigente.
					</span>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</cfif>
		<!--- Línea No. 3 --->
		<tr><td>&nbsp;</td></tr>
		<!--- Línea No. 4 --->
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="2" align="center">
							<cfif isdefined("rsDatos") and rsDatos.recordcount GT 0>
								<input type="submit" name="btnRetirarCF" value="Retirar">
							</cfif>
							<input type="button" name="btncerrar" value="Cancelar" onClick="javascript: window.close();">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
</cfoutput>

<cf_qforms form="form2" objForm="objForm2">
	<cf_qformsRequiredField args="ECFhasta,Fecha Hasta">
</cf_qforms>

