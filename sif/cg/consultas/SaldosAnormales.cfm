<!---
	Módulo      : Contabilidad General / Consultas
	Nombre      : Reporte de Saldos Anormales
	Descripción : 
		Genera información de los saldos de cuentas que contienen
		saldos inversos al estipulado en la cuenta contable (es decir,
		cuentas por cobrar con saldo acreedor por ejemplo).
	Hecho por   : Steve Vado Rodríguez
	Creado      : 13/12/2005
	Modificado  : 
 --->

<!--- Tabla temporal de reportes --->
<cf_dbtemp name="tReporte" returnvariable="tReporte">
    <cf_dbtempcol name="PCCEclaid"  		type="numeric"  	mandatory="yes">			
    <cf_dbtempcol name="descripcion"		type="varchar(50)"  mandatory="yes">
</cf_dbtemp>
<!--- Borra la tabla de reportes --->
<cfquery datasource="#session.DSN#">
    delete from #tReporte#
</cfquery>

<cfquery datasource="#session.DSN#">
	insert into #tReporte# (PCCEclaid,descripcion) values (1,'REPORTE DE OBRAS')
</cfquery>

<!--- Consultas --->
<cfquery name="rsReporte" datasource="#session.DSN#">
	select
		PCCEclaid as clase,
		descripcion as descripcion
	from #tReporte#
</cfquery>

<!--- Definición de los años --->
<cfquery name="rsPrePeriodo" datasource="#session.DSN#">
	select Pvalor as periodo
	from Parametros 
	where Ecodigo = #Session.Ecodigo# 
	and Pcodigo = 30
</cfquery>	
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

	<cf_templateheader title="Reporte Saldos Anormales">
		<cfinclude template="../../portlets/pNavegacion.cfm">				
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Reporte Saldos Anormales">
		<cfif not isdefined("form.btnConsultar")>	
			<form action="SaldosAnormalesRep.cfm" method="post" name="form1" onSubmit="return fnVerificar()">
				<cfoutput>				  
				<table width="100%" border="0">
					<tr>
						<td valign="top"width="35%"> <cf_web_portlet_start border="true" titulo="Reporte Saldos Anormales" skin="info1">
							<div align="center">
						  		<p align="justify">
									Genera información de los saldos de cuentas que contienen
									saldos inversos al estipulado en la cuenta contable (es decir,
									cuentas por cobrar con saldo acreedor por ejemplo).
								</p>
							</div>
							<cf_web_portlet_end> 
						</td>
						<td width="2%">&nbsp;</td>
						<td>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="19%" height="30" align="right"><strong>Per&iacute;odo:&nbsp;</strong></td>
									<td colspan="3" align="left">
										<select tabindex="1" name="periodo" id="periodo">
											<cfloop query="rsPeriodos">
												<option value="#Pvalor#" <cfif (isdefined("form.periodo") and len(trim(form.periodo)) and form.periodo eq Pvalor)>selected</cfif>>#Pvalor#</option>
											</cfloop>
										</select>
									</td>
								</tr>
								<tr>
									<td width="19%" height="27" align="right"><strong>Mes Inicial:&nbsp;</strong></td>
									<td align="left">
										<select tabindex="2" name="mes" id="mes">
											<cfloop from="1" to="#ArrayLen(arrMeses)#" index="i">
												<option value="#i#" label="#arrMeses[i]#" <cfif form.mes eq #i#> selected</cfif>>#arrMeses[i]#</option>
											</cfloop>
									  </select>
								    <strong>&nbsp;&nbsp;&nbsp;&nbsp;</strong></td>
								<td align="right"><strong> Final:&nbsp;</strong> </td>
								    <td align="left">
									<select tabindex="3" name="mes2" id="mes2">
                                      <cfloop from="1" to="#ArrayLen(arrMeses)#" index="i">
                                        <option value="#i#" label="#arrMeses[i]#" <cfif form.mes eq #i#> selected</cfif>>#arrMeses[i]#</option>
                                      </cfloop>
                                    </select></td>
								    <td width="1%" align="left">&nbsp;</td>
								    <td width="1%" align="left">&nbsp;</td>
								</tr>
								<tr>
									<td height="25" align="right"><strong>Cuenta Inicial:&nbsp;</strong></td>
									<td colspan="5" align="left">
										<cf_cuentas NoVerificarPres="yes"
											cformato="Cformato1"
											cdescripcion="Cdescripcion1"
											ccuenta="Ccuenta1"
											MOVIMIENTO="S"
											AUXILIARES="N"
											frame="frcuenta1"
											tabindex="4"
											descwidth="35">
									</td>
								</tr>						  
								<tr>
									<td height="25" align="right"><strong>Cuenta Final:&nbsp;</strong></td>
									<td colspan="5" align="left">
										<cf_cuentas NoVerificarPres="yes"
											cformato="Cformato2"
											cdescripcion="Cdescripcion2"
											ccuenta="Ccuenta2"
											MOVIMIENTO="S"
											AUXILIARES="N"
											frame="frcuenta2"
											tabindex="5"
											descwidth="35">
									</td>
								</tr>						  
								<tr>
									<td height="24" align="right"><strong>Oficina:&nbsp;</strong></td>
									<td colspan="3">
										<cfset ArrayOF=ArrayNew(1)>
										<cf_conlis
											Campos="Ocodigo,Oficodigo,Odescripcion"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											ValuesArray="#ArrayOF#" 
											Title="Lista de Oficinas"
											Tabla="Oficinas"
											Columnas="Ocodigo,Oficodigo,Odescripcion"
											Filtro="Ecodigo = #Session.Ecodigo#"
											Desplegar="Oficodigo,Odescripcion"
											Etiquetas="C&oacute;digo,Descripci&oacute;n"
											filtrar_por="Oficodigo,Odescripcion"
											Formatos="S,S"
											tabindex="6"
											Align="left,left"
											Asignar="Ocodigo,Oficodigo,Odescripcion"
											Asignarformatos="S,S,S"/>
									</td>
								</tr>
								<tr>
									<td width="19%" height="28" align="right"><strong>Moneda:&nbsp;</strong></td>
									<td width="25%">
										<select tabindex="7" name="Mcodigo" id="Mcodigo">
											<cfloop query="monedas">
												<option value="#monedas.Mcodigo#" label="#monedas.Mnombre#" <cfif isdefined("form.Mcodigo") and form.Mcodigo eq monedas.Mcodigo>selected</cfif>>#monedas.Mnombre#</option>
											</cfloop>
										</select>
									</td>
							</table>
							<table width="100%" border="0">
								<tr>
									<td>&nbsp;</td>
									<td width="85%" align="right"><input type="submit" tabindex="8" name="Consultar" value="Consultar">
									<td><input type="hidden" name="monedaDescrip" id="monedaDescrip"></td>
									<td><input type="hidden" name="mesDesde" id="mesDesde"></td>
									<td><input type="hidden" name="mesHasta" id="mesHasta"></td>
									<td><input type="hidden" name="cuenta1D" id="cuenta1D"></td>
									<td><input type="hidden" name="cuenta2D" id="cuenta2D"></td>
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

<script language="javascript1.2" type="text/javascript">
	function fnVerificar() {
		//Combos.
		var f2 = document.form1.elements;
		for (i=1;i<=f2.length-1;i++) {
			if (f2[i].type == "select-one") {
				if (f2[i].name == "Mcodigo") {
					for (j=0;j<=f2[i].length-1;j++) {
						if (f2[i][j].selected) {
							form1.monedaDescrip.value = f2[i][j].label;
						}
					}
				}

				if (f2[i].name == "mes") {
					for (j=0;j<=f2[i].length-1;j++) {
						if (f2[i][j].selected) {
							form1.mesDesde.value = f2[i][j].label;
						}
					}
				}

				if (f2[i].name == "mes2") {
					for (j=0;j<=f2[i].length-1;j++) {
						if (f2[i][j].selected) {
							form1.mesHasta.value = f2[i][j].label;
							break;
						}
					}
				}
			}
		}
		
		//Cuentas.
		document.form1.cuenta1D.value = document.form1.Cdescripcion1.value;
		document.form1.cuenta2D.value = document.form1.Cdescripcion2.value;
		return true;
	}
</script>