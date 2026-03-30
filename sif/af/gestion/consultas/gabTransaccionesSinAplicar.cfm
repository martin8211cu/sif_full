<!---
	Módulo      : Gestión de Activos Fijos / Consultas
	Nombre      : Transacciones Sin Aplicar
	Descripción : 
		Muestra un reporte de la bitácora de gestión de activos
		fijos, para aquellas que no han sido aplicadas,
		en un período, mes, concepto y documento.
	Hecho por   : Steve Vado Rodríguez
	Creado      : 20/12/2005
	Modificado  : 
		08/02/2006 - Steve:
			Se cambió el combo de períodos y se hace manual, mostrando los dos antes y
			dos después del período contable actual.
 --->
<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<!--- Definición de los años --->
<cfquery name="rsPrePeriodo" datasource="#session.DSN#">
	select Pvalor as periodo
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
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

<!--- Definición de los meses --->
<cfset arrMeses = ArrayNew(1)>									
<cfset lstMeses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
<cfset arrMeses = listToArray(lstMeses)>

<cfquery name="mes_actual" datasource="#session.DSN#">
	select p.Pvalor
	from Parametros p
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and p.Pcodigo = 40
</cfquery>
<cfparam name="form.mes" default="#mes_actual.Pvalor#">

<!--- Consultas --->
<cfquery name="rsConceptos" datasource="#session.dsn#">
	select Cconcepto as value, Cdescripcion as description
	from ConceptoContableE
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<!--- Formulario --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">			
		<cfoutput>#pNavegacion#</cfoutput>
		<cfif not isdefined("form.btnConsultar")>	
			<form action="gabTransaccionesSinAplicarRep.cfm" method="post" name="form1" onSubmit="return fnVerificar()">
				<cfoutput>				  
				<table width="100%" border="0">
					<tr>
						<td  valign="top"width="45%"> <cf_web_portlet border="true" titulo="Transacciones Sin Aplicar" skin="info1">
							<div align="center">
						  		<p align="justify">
									Muestra un reporte de la bitácora de gestión de activos
									fijos, para aquellas que no han sido aplicadas,
									en un período, mes, concepto y documento.
								</p>
							</div>
							</cf_web_portlet> 
						</td>
						<td width="4%">&nbsp;</td>
						<td width="58%">
							<table width="100%" border="0">
								<tr>
									<td width="10%" align="right"><strong>Per&iacute;odo:</strong></td>
									<td width="10%">
										<select name="periodo" tabindex="1">
											<cfloop query="rsPeriodos">
												<option value="#Pvalor#" <cfif (isdefined("form.periodo") and len(trim(form.periodo)) and form.periodo eq Pvalor)>selected</cfif>>#Pvalor#</option>
											</cfloop>
										</select>
									</td>
									<td width="8%" align="right"><strong>Mes:</strong></td>
									<td width="52%">
										<select name="mes" id="mes" tabindex="2">
											<cfloop from="1" to="#ArrayLen(arrMeses)#" index="i">
												<option value="#i#" label="#arrMeses[i]#" <cfif form.mes eq #i#> selected</cfif>>#arrMeses[i]#</option>
											</cfloop>
										</select>									
									</td>									
								</tr>
								<tr>
									<td width="10%" align="right"><strong>Concepto:</strong></td>
									<td width="10%" colspan="3">
										<select name="concepto" id="concepto" onChange="javascript:fnSinAsignar();" tabindex="3">
											<option value="" label="Todos">Todos</option>
											<cfloop query="rsConceptos">
												<option value="#value#" label="#description#">#description#</option>
											</cfloop>
											<option value="-10" label="Sin Asignar">Sin Asignar</option>
										</select>
									</td>
								</tr>
								<tr>
									<td width="10%" align="right"><strong>Documento:</strong></td>
									<td colspan="3">
										<input type="text" name="Edocumento" tabindex="4" style="text-align:right"
										onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">										
										<!--- <cf_monto id="Edocumento" name="Edocumento" decimales="0" tabindex="4">--->
									</td>
								</tr>
								<tr>
									<td width="8%" align="right"><strong>Estado:</strong></td>
									<td>
										<select name="estado" id="estado" tabindex="5">
											<option value="-1" label="Todos">-- Todos --</option>
											<option value="0" label="Incompleta">Incompleta</option>
											<option value="1" label="Completa">Completa</option>
											<option value="2" label="Conciliada">Conciliada</option>
											<option value="3" label="Aplicada">Aplicada</option>
										</select>									
									</td>								
								</tr>
								<tr>
									<td width="8%" align="right">
										<input type="checkbox" name="resumido" id="resumido" tabindex="6">
									</td>
									<td colspan="3"><strong>Resumido</strong></td>
								</tr>
								<tr>
									<td width="8%" align="right">
										<input type="checkbox" name="Vbajar_arch" id="Vbajar_arch" tabindex="6">
									</td>
									<td colspan="3"><strong>Bajar Archivo</strong></td>
								</tr>								
								<tr>
									<td colspan="4" align="center">
									<cf_botones values="Consultar" tabindex="1">
									<input type="hidden" name="mesDescrip" id="mesDescrip" tabindex="-1">
									<input type="hidden" name="conceptoDescrip" id="conceptoDescrip" tabindex="-1">
									<input type="hidden" name="estadoDescrip" id="estadoDescrip" tabindex="-1"></td>
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
		var f2 = document.form1.elements;
		for (i=1;i<=f2.length-1;i++) {
			if (f2[i].type == "select-one") {
				if (f2[i].name == "mes") {
					for (j=0;j<=f2[i].length-1;j++) {
						if (f2[i][j].selected) {
							form1.mesDescrip.value = f2[i][j].label;
						}
					}
				}

				if (f2[i].name == "concepto") {
					for (j=0;j<=f2[i].length-1;j++) {
						if (f2[i][j].selected) {
							form1.conceptoDescrip.value = f2[i][j].label;							
						}
					}
				}

				if (f2[i].name == "estado") {
					for (j=0;j<=f2[i].length-1;j++) {
						if (f2[i][j].selected) {
							form1.estadoDescrip.value = f2[i][j].label;
						}
					}
				}
			}
		}						
		return true;
	}
	
	function fnSinAsignar() {
		var f2 = document.form1.elements;
		for (i=1;i<=f2.length-1;i++) {
			if (f2[i].type == "select-one") {
				if (f2[i].name == "concepto") {
					for (j=0;j<=f2[i].length-1;j++) {
						if (f2[i][j].selected) {
							if (f2[i][j].value == -10) {
								form1.Edocumento.value = -10;
								form1.Edocumento.disabled = true;
								break;
							} else {
								form1.Edocumento.disabled = false;
								form1.Edocumento.value = '';
								break;
							}
						}
					}
				}
			}
		}
	}
	document.form1.Edocumento.value = '';
</script>