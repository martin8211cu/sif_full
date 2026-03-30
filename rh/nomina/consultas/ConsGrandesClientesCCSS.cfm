<cfset rsPeriodo = QueryNew("Pvalor")>
<cfset temp = QueryAddRow(rsPeriodo,3)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",Year(Now())-2,1)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",Year(Now())-1,2)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",Year(Now()),3)>
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>
<cfset TITULO = "Reporte de Grandes Clientes del Seguro Social">


<cfsavecontent variable="AYUDA">

<cf_web_portlet_start titulo="#TITULO#" skin="info1">
	<table width="100%">
		<tr><td><p>Este proceso se encarga de llenar el reporte de la caja para grandes clientes, generando un archivo de formato tipo ASCII.</p></td></tr>
	</table>
<cf_web_portlet_end>
</cfsavecontent>

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#TITULO#</cfoutput>
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet_start titulo="#TITULO#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfoutput>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr><td>&nbsp;</td><td>&nbsp;</td></tr>
					<tr>
						<td width="50%" valign="top">
							<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>#AYUDA#</td>
								</tr>
							</table>
						</td>
						<td width="50%" valign="top">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									
									<td colspan="2">
										<form action="GrandesClientesCCSS-sql.cfm" method="post" name="formexport2">
										
										<table border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td>Periodo:&nbsp;</td>
												<td><select onChange="javascript:fnChangePeriodo();" name="CPperiodo"><cfloop query="rsPeriodo"><option value="#Pvalor#" <cfif Year(Now()) eq Pvalor>selected</cfif>>#Pvalor#</option></cfloop></select></td>
												<td>&nbsp;&nbsp;&nbsp;</td>
											</tr>
											<tr>
												<td>Mes:&nbsp;</td>
												<td><select onChange="javascript:fnChangeMes();" name="CPmes"><cfloop query="rsMeses"><option value="#Pvalor#" <cfif Month(Now()) eq Pvalor>selected</cfif>>#Pdescripcion#</option></cfloop></select></td>
												<td>&nbsp;&nbsp;&nbsp;</td>
											</tr>
											<tr>
											<td>Grupo de Planillas:</td>
											<td><input name="GrupoPlanilla" type="text" id="GrupoPlanilla" size="6" maxlength="5" value="" onFocus="javascript:this.select();"></td>
											<td></td>
											</tr>
											<tr>
												<td>Detallar:</td>
												<td colspan="2"><input name="ckDetalle" type="checkbox" value="0" checked></td>
											</tr>
											<tr>
												<td colspan="3"><input type="submit" value="Consultar"></td>
												
											</tr>
										</table>
										</form>
									</td>
								</tr>
								<tr>
									<td>&nbsp;
									</td>
									<td>&nbsp;
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</cfoutput>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>
<script language="javascript" type="text/javascript">
<!--// //poner a código javascript 
	function fnChangePeriodo(){
		var formO = document.formexport2;
		var formD = document.formexport;
		formD.CPperiodo.value = formO.CPperiodo.value;
	}
	function fnChangeMes(){
		var formO = document.formexport2;
		var formD = document.formexport;
		formD.CPmes.value = formO.CPmes.value;
	}
	fnChangePeriodo();
	fnChangeMes();
//-->
</script>