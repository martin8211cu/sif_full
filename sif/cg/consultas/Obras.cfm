<!---
	Módulo      : Contabilidad General / Consulta
	Nombre      : Reporte de Obras
	Descripción : 
		Muestra un resumen totalizado de las cuentas para un período
		en particular, agrupado por clasificación de catálogos.
	Hecho por   : Steve Vado Rodríguez
	Creado      : 05/12/2005
	Modificado  : 
 --->

<cfquery name="rsReporte" datasource="#session.DSN#">
	select
		PCCEclaid as clase,
		rtrim(PCCEcodigo) as codigo,
		rtrim(PCCEdescripcion) as descripcion
	from PCClasificacionE
	order by PCCEdescripcion
</cfquery>

<!--- Definición de los años --->
<cfquery name="rsPrePeriodo" datasource="#session.DSN#">
	select Pvalor as periodo
	from Parametros 
	where Ecodigo = #Session.Ecodigo# 
	and Pcodigo = 30
</cfquery>	

<!--- Querys de Oficinas --->
<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Oficodigo, Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo = #session.Ecodigo#
	order by Oficodigo, Odescripcion
</cfquery>

<cfquery name="rsGE" datasource="#session.DSN#">
	select ge.GEid, ge.GEnombre
	from AnexoGEmpresa ge
		join AnexoGEmpresaDet gd
			on ge.GEid = gd.GEid
	where ge.CEcodigo = #session.CEcodigo#
	  and gd.Ecodigo = #session.Ecodigo#
	order by ge.GEnombre
</cfquery>

<cfquery name="rsGO" datasource="#session.DSN#">
	select GOid, GOnombre
	from AnexoGOficina
	where Ecodigo = #session.Ecodigo#
	order by GOnombre
</cfquery>

<!--- Querys del Maximo nivel que hay de acuerdo a la mascara --->
<cfquery name="rsNiveles" datasource="#Session.DSN#">
select Max(A.PCNid) as Nmax
from PCNivelMascara A, PCEMascaras B
where A.PCEMid = B.PCEMid
  and B.CEcodigo = #session.CEcodigo#
</cfquery>

<cfset VNmax = rsNiveles.Nmax>

<cfset rsPeriodos = QueryNew("Pvalor")>
<cfset temp = QueryAddRow(rsPeriodos,5)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPrePeriodo.periodo-2,1)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPrePeriodo.periodo-1,2)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPrePeriodo.periodo,3)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPrePeriodo.periodo+1,4)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPrePeriodo.periodo+2,5)>
<cfparam name="form.periodo" default="#rsPrePeriodo.periodo#">

<cfquery name="mes_actual" datasource="#session.DSN#">
	select p.Pvalor
	from Parametros p
	where p.Ecodigo = #Session.Ecodigo#
	  and p.Pcodigo = 40
</cfquery>
<cfparam name="form.mes" default="#mes_actual.Pvalor#">
<cfparam name="form.mesfin" default="#mes_actual.Pvalor#">


<cfquery name="monedas" datasource="#session.DSN#">
	select Mcodigo as Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
	from Monedas
	where Ecodigo = #Session.Ecodigo#
</cfquery>	

<!--- Definición de los meses --->
<cfset arrMeses = ArrayNew(1)>									
<cfset lstMeses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
<cfset arrMeses = listToArray(lstMeses)>

<!--- Formulario --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

	<cf_templateheader title="Reporte Gesti&oacute;n de Obras">
		<cfinclude template="../../portlets/pNavegacion.cfm">				
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Reporte Gesti&oacute;n de Obras">
		<cfif not isdefined("form.btnConsultar")>	
			<form action="ObrasRep.cfm" method="post" name="form1" id="form1" onSubmit="return fnVerificar()">
				<cfoutput>				  
				<table width="100%" border="0">
					<tr>
						<td  valign="top"width="38%"> <cf_web_portlet_start border="true" titulo="Reporte Gesti&oacute;n de Obras" skin="info1">
							<div align="center">
						  		<p align="justify">
									Muestra un resumen totalizado de las cuentas para un período
									en particular, agrupado por clasificación de catálogos.
								</p>
							</div>
							<cf_web_portlet_end> 
						</td>
						<td width="4%">&nbsp;</td>
						<td width="58%">
							<table width="100%" border="0">
								<tr>
									<td width="25%" align="right"><strong>Per&iacute;odo:</strong></td>
									<td width="30%">
										<select name="periodo" id="periodo" tabindex="1">
											<cfloop query="rsPeriodos">
												<option value="#Pvalor#" <cfif (isdefined("form.periodo") and len(trim(form.periodo)) and form.periodo eq Pvalor)>selected</cfif>>#Pvalor#</option>
											</cfloop>
										</select>
									</td>
								</tr>
								<tr>
									<td width="25%" align="right"><strong>Mes Inicial:</strong></td>
									<td width="30%">
										<select name="mes" id="mes" tabindex="1">
											<cfloop from="1" to="#ArrayLen(arrMeses)#" index="i">
												<option value="#i#" label="#arrMeses[i]#" <cfif form.mes eq #i#> selected</cfif>>#arrMeses[i]#</option>
											</cfloop>
										</select>									
									</td>
								</tr>
										
								<tr>
									<td width="25%" align="right"><strong>Mes Final:</strong></td>
									<td width="30%">
										<select name="mesfin" id="mesfin" tabindex="1">
											<cfloop from="1" to="#ArrayLen(arrMeses)#" index="i">
												<option value="#i#" label="#arrMeses[i]#" <cfif form.mesfin eq #i#> selected</cfif>>#arrMeses[i]#</option>
											</cfloop>
										</select>									
									</td>
								</tr>
								
								<tr>
									<td width="25%" align="right"><strong>Cuenta Mayor:&nbsp;</strong></td>
									<td colspan="3">
										<cf_sifCuentasMayor form="form1" tabindex="1" Cmayor="cmayor_ccuenta1" Cdescripcion="Cdescripcion1" size="50">
									</td>
								</tr>
								<tr>
									
									<td><strong>Oficina/Empresa:</strong></td>
									<td>
										<select name="ubicacion" style="width:200px">
											<optgroup label="Empresa">
											<option value="" <cfif isdefined("form.ubicacion") and  Len(form.ubicacion) EQ 0> selected</cfif>> #HTMLEditFormat(session.Enombre)#</option>
											</optgroup>
											<cfif rsGE.RecordCount>
											  <optgroup label="Grupo de Empresas">
											  <cfloop query="rsGE">
												<option value="ge,#rsGE.GEid#" <cfif isdefined("form.ubicacion") and form.ubicacion eq 'ge,' & rsGE.GEid>selected</cfif> > #HTMLEditFormat(rsGE.GEnombre)#</option>
											  </cfloop>
											  </optgroup>
											</cfif>
											<optgroup label="Oficina">
											<cfloop query="rsOficinas">
											  <option value="of,#rsOficinas.Ocodigo#"  <cfif isdefined("form.ubicacion") and form.ubicacion eq 'of,' & rsOficinas.Ocodigo>selected</cfif> >
												#rsOficinas.Oficodigo# - #HTMLEditFormat(rsOficinas.Odescripcion)#</option>
											</cfloop>
											</optgroup>
											<cfif rsGO.RecordCount>
											  <optgroup label="Grupo de Oficinas">
											  <cfloop query="rsGO">
												<option value="go,#rsGO.GOid#"  <cfif isdefined("form.ubicacion") and form.ubicacion eq 'go,' & rsGO.GOid>selected</cfif> > #HTMLEditFormat(rsGO.GOnombre)#</option>
											  </cfloop>
											  </optgroup>
											</cfif>
										 </select>
									</td>										
								</tr>
								<tr>
									
									<td><strong>Nivel de Detalle:</strong></td>
									<td>
										<select name="cbonivel" style="width:40px">
										  <cfloop index="i" from="0" to="#VNmax#">
											<option value="#i#">#i#</option>
										  </cfloop>																					
										 </select>
									</td>										
								</tr>								
								<tr>
									<td width="25%" align="right"><strong>Reporte:&nbsp;</strong></td>
									<td width="30" colspan="2">
										<select name="reporte" id="reporte" tabindex="1">
											<cfloop query="rsReporte">
												<option value="#rsReporte.clase#" label="#rsReporte.codigo# - #rsReporte.descripcion#" <cfif isdefined("form.clase") and form.clase eq rsReporte.clase>selected</cfif>>#rsReporte.codigo# - #rsReporte.descripcion#</option>
											</cfloop>
										</select>
									</td>
									<td width="30%" align="center">
										<input type="submit" name="Consultar" id="Consultar" value="Consultar" tabindex="1">
									</td>
								</tr>																
							</table>
							<table width="100%" border="0">
								<tr>
									<td>&nbsp;</td>
								  	<td width="80%" align="right">
									<td>
										<input type="hidden" name="mesDesde" id="mesDesde">
										<input type="hidden" name="mesHasta" id="mesHasta">
										<input type="hidden" name="cuentaDescrip" id="cuentaDescrip">
									</td>
								</tr>
							</table>
						</td> 
					</tr>
				</table> 
				</cfoutput>
			</form> 
		</cfif> 
		<cf_web_portlet_end>
	<cf_templatefooter> 

<script language="javascript">
	function fnVerificar() {
		var f2 = document.form1.elements;		
		for (i=1;i<=f2.length-1;i++) {
			if (f2[i].type == "select-one") {
				if (f2[i].name == "mes") {
					for (j=0;j<=f2[i].length-1;j++) {
						if (f2[i][j].selected) {
							form1.mesDesde.value = f2[i][j].label;
						}
					}
				}
				if (f2[i].name == "mesfin") {
					for (j=0;j<=f2[i].length-1;j++) {
						if (f2[i][j].selected) {
							form1.mesHasta.value = f2[i][j].label;
						}
					}
				}
			}
		}

		if (f2.cmayor_ccuenta1.value == '') {
			alert('Debe de digitar una cuenta de mayor.');
			f2.cmayor_ccuenta1.focus();
			return false;
		}
		f2.cuentaDescrip.value = f2.Cdescripcion1.value;
		return true;
	}
</script>