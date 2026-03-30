<!---
	Módulo      : Gestión de Activos Fijos / Consultas
	Nombre      : Transacciones Aplicadas
	Descripción : 
		Muestra un reporte de la bitácora de gestión de activos
		fijos, para aquellas que fueron aplicadas, en un período,
		mes, concepto y documento.
	Hecho por   : Steve Vado Rodríguez
	Creado      : 14/12/2005
	Modificado  :
		08/02/2006 - Steve:
			Se cambió el combo de períodos y se hace manual, mostrando los dos antes y
			dos después del período contable actual.
			
			Modificado: Yessica
			Se agregó un tag para validar el campo Documento y permitir únicamente ingresar números.
 --->

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
			<form action="gabtransaccionesRep.cfm" method="post" name="form1" onSubmit="return fnVerificar()">
				<cfoutput>				  
				<table width="100%" border="0">
					<tr>
						<td  valign="top"width="45%"> <cf_web_portlet_start border="true" titulo="Transacciones Aplicadas" skin="info1">
							<div align="center">
						  		<p align="justify">
								Muestra un reporte de la bitácora de gestión de activos
								fijos, para aquellas que fueron aplicadas, en un período,
								mes, concepto y documento.
								</p>
							</div>
							<cf_web_portlet_end> 
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
										<select name="mes" id="mes" tabindex="1">
											<cfloop from="1" to="#ArrayLen(arrMeses)#" index="i">
												<option value="#i#" label="#arrMeses[i]#" <cfif form.mes eq #i#> selected</cfif>>#arrMeses[i]#</option>
											</cfloop>
										</select>									
									</td>									
								</tr>
								<tr>
									<td width="10%" align="right"><strong>Concepto:</strong></td>
									<td colspan="3">
										<select name="concepto" tabindex="1">
											<option value="" label="Todos">Todos</option>
											<cfloop query="rsConceptos">
												<option value="#value#" label="#description#">#description#</option>
											</cfloop>
										</select>
									</td>
								</tr>
								<tr>
									<td width="10%" align="right"><strong>Documento:</strong></td>
									<td colspan="3">
										<cf_inputNumber name="Edocumento"  size="15" enteros="4" decimales="0" comas= "false">
									</td>
								</tr>
								<tr>
									<td width="8%" align="right">
										<input type="checkbox" name="Vbajar_arch" id="Vbajar_arch" tabindex="6">
									</td>
									<td colspan="3"><strong>Bajar Archivo</strong></td>
								</tr>
								<tr>
									<td align="center" colspan="4">
									<cf_botones values="Consultar" tabindex="1">
									<input type="hidden" name="mesDescrip" id="mesDescrip" tabindex="-1">
									<input type="hidden" name="conceptoDescrip" id="conceptoDescrip" tabindex="-1">
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
			}
		}
				
		return true;
	}
</script>