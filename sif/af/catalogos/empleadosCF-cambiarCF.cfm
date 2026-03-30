<title>Cambiar Centro Funcional</title>

<!--- Asignación de valores a las variables del form --->	
<cfif isDefined("url.DEid") and not isDefined("form.DEid")>
	<cfset form.DEid = url.DEid>
</cfif>

<cfquery name="rsDatos" datasource="#session.dsn#">
	select 
		a.ECFlinea,
		a.CFid,
		a.ECFencargado ,
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
		and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between a.ECFdesde and a.ECFhasta   
</cfquery>


<cfoutput>
<form name="form2" id="form2" method="post" action="empleadosCF-cambiarCFSQL.cfm">
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
						<legend><strong>Informaci&oacute;n del Centro Funcional Vigente</strong></legend>			
						<table width="100%" border="0" cellspacing="2" cellpadding="0">
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td width="30%" class="fileLabel"><strong>Centro Funcional</strong></td>
								<td>#rsDatos.CFcodigo# - #rsDatos.CFdescripcion#</td>
							</tr>						
							<tr>
								<td width="30%" class="fileLabel"><strong>Encargado</strong></td>
								<td><input type="checkbox" name="ECFencargado" id="ECFencargado" tabindex="1" value="0" <cfif #rsDatos.ECFencargado# EQ 1>checked</cfif> disabled ></td>	
							</tr>
							<tr>
								<td colspan="2">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="30%" class="fileLabel"><strong>Fecha Desde</strong></td>
											<td>#DateFormat(rsDatos.ECFdesde,'dd/mm/yyyy')#</td>
											<td class="fileLabel"><strong>Fecha Hasta</strong></td>
											<td>#DateFormat(rsDatos.ECFhasta,'dd/mm/yyyy')#</td>	
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<!--- Línea No. 3 --->
			<tr><td>&nbsp;</td></tr>
			<!--- Línea No. 4 --->
			<tr>
				<td>
					<fieldset>
						<legend><strong>Informaci&oacute;n del Centro Funcional</strong></legend>			
						<table width="100%" border="0" cellspacing="2" cellpadding="0">
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td width="30%" class="fileLabel"><strong>Centro Funcional</strong></td>
								<td>					
									<cf_conlis
									campos="CFid2, CFcodigo2, CFdescripcion2"
									desplegables="N,S,S"
									modificables="N,S,N"
									size="0,10,40"
									title="Lista de Centros Funcionales"
									valuesArray=""
									tabla="CFuncional"
									columnas="CFid as CFid2, CFcodigo as CFcodigo2, CFdescripcion as CFdescripcion2"
									filtro="Ecodigo=#SESSION.ECODIGO# order by CFcodigo"
									desplegar="CFcodigo2, CFdescripcion2"
									filtrar_por="CFcodigo, CFdescripcion"
									etiquetas="Código, Descripción"
									formatos="S,S"
									align="left,left"
									asignar="CFid2, CFcodigo2, CFdescripcion2"
									asignarformatos="S, S, S"
									showEmptyListMsg="true"
									EmptyListMsg="-- No se encontraron Centros Funcionales --"
									tabindex="1"
									form="form2">								

									<!---
									<cf_rhcfuncional form="form2" id="CFid2" name="CFcodigo2" desc="CFdescripcion2" tabindex="1" frame="frcfuncional">
									--->
								</td>
							</tr>						
							<tr>
								<td width="30%" class="fileLabel"><strong>Encargado</strong></td>
								<td><input type="checkbox" name="ECFencargado" id="ECFencargado" value="0" tabindex="1"></td>	
							</tr>
							<tr>
								<td colspan="2">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="30%" class="fileLabel"><strong>Fecha Desde</strong></td>
											<td>
												<cf_sifcalendario form="form2" value="" name="ECFdesde" tabindex="1">
											</td>
											<td class="fileLabel"><strong>Fecha Hasta</strong></td>
											<td>
												<cf_sifcalendario form="form2" value="" name="ECFhasta" tabindex="1">
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
		<!--- Línea No. 4 --->
		<tr><td>&nbsp;</td></tr>
		<!--- Línea No. 5 --->
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="2" align="center">
							<cfif isdefined("rsDatos") and rsDatos.recordcount GT 0>
								<input type="submit" name="btnCambiarCF" value="Cambiar">
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
	<cf_qformsRequiredField args="CFid2,Centro Funcional">
	<cf_qformsRequiredField args="ECFdesde,Fecha Desde">
</cf_qforms>

