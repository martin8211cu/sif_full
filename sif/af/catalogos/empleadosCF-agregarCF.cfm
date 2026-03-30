<!---
 Acrchivo:	empleadoCF-agregarCF.cfm
 Creado: 	Randall Colomer Villalta en SOIN
 Fecha:  	04 Diciembre del 2006.
 --->
 
<title>Agregar Centro Funcional</title>

<!--- Asignación de valores a las variables del form --->	
<cfif isDefined("url.DEid") and not isDefined("form.DEid")>
	<cfset form.DEid = url.DEid>
</cfif>

<cfoutput>
<form name="form2" id="form2" method="post" action="empleadosCF-agregarCFSQL.cfm">
	<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
	<input type="hidden" name="DEid" value="#form.DEid#">
	<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center">
		<!--- Línea No. 1 --->
		<tr><td>&nbsp;</td></tr>
		<!--- Línea No. 2 --->
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
										<td><cf_sifcalendario form="form2" value="" name="ECFdesde" tabindex="1"></td>
										<td class="fileLabel"><strong>Fecha Hasta</strong></td>
										<td><cf_sifcalendario form="form2" value="" name="ECFhasta" tabindex="1"></td>	
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
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="2" align="center">
							<input type="submit" name="btnAgregarCF" value="Agregar" >
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

