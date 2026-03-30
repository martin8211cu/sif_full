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
<!--- Busca el Par&aacute;metro para la Importacion del Seguro Social --->
<cfquery name="rsRHParametros" datasource="#Session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Pcodigo = 310
</cfquery>
<cfif rsRHParametros.Recordcount>
	<cfquery name="rsExportaciones" datasource="sifcontrol">
		select EIid
		from EImportador
		where EIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRHParametros.Pvalor#">
	</cfquery>
</cfif>
<cfif isdefined("rsExportaciones") and  not rsExportaciones.Recordcount>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_NoExisteElFormatoRequerido"
		Default="Error!, No existe el Formato Requerido!, Proceso Cancelado!"
		returnvariable="LB_NoExisteElFormatoRequerido"/> 
	
	<cf_throw message="#LB_NoExisteElFormatoRequerido#" errorcode="6025">
<cfelseif not isdefined("rsExportaciones")>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_NoSeHaDefinidoElParametroParaLaExportacion"
		Default="Error!, No se ha definido el Par&aacute;metro para la exportaci&oacute;n!, Proceso Cancelado!"
		returnvariable="LB_NoSeHaDefinidoElParametroParaLaExportacion"/> 

	<cf_throw message="#LB_NoSeHaDefinidoElParametroParaLaExportacion#" errorcode="6030">
</cfif> 
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ExportacionDeSeguroSocial"
		Default="Exportaci&oacute;n de Seguro Social"
		returnvariable="LB_ExportacionDeSeguroSocial"/>

<cfsavecontent variable="IMPORTAR">
	<cf_sifimportar eiid="#rsExportaciones.eiid#" eicodigo="#rsRHParametros.Pvalor#" mode="out">
		<!--- Ecodigo --->
		<cf_sifimportarparam name="Ecodigo" value="#session.Ecodigo#">
		<!--- Periodo --->
		<cf_sifimportarparam name="CPperiodo" value="#Year(Now())#">
		<!--- Mes --->
		<cf_sifimportarparam name="CPmes" value="#Month(Now())#">
		<!--- Tipo de Reporte --->
		<cf_sifimportarparam name="tiporep" value="D">
	</cf_sifimportar>
</cfsavecontent>
<cfsavecontent variable="AYUDA">
<cf_web_portlet_start titulo="#LB_ExportacionDeSeguroSocial#" skin="info1">
	<table width="100%">
		<tr><td><p>
		<cf_translate  key="AYUDA_EsteProcesoPermiteRealizarLaExportacionDeLaInformacionMensualReferenteALosSalariosDevengados">
		Este proceso permite realizar la exportaci&oacute;n de la informaci&oacute;n mensual referente a los salarios devengados por cada uno de 
		los empleados de la empresa; este archivo se genera con base en la estructura solicitada por el Seguro Social y que se utilizar&aacute; para 
		su posterior carga autom&aacute;tica.
		</cf_translate>
		</p></td></tr>
	</table>
<cf_web_portlet_end>
</cfsavecontent>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start titulo="#LB_ExportacionDeSeguroSocial#">
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
									<td>#IMPORTAR#</td>
									<td>
										<form action="" method="post" name="formexport2">
										<table border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td><cf_translate  key="LB_Periodo">Periodo</cf_translate>&nbsp;</td>
												<td><select onChange="javascript:fnChangePeriodo();" name="CPperiodo"><cfloop query="rsPeriodo"><option value="#Pvalor#" <cfif Year(Now()) eq Pvalor>selected</cfif>>#Pvalor#</option></cfloop></select></td>
												<td>&nbsp;&nbsp;&nbsp;</td>
											</tr>
											<tr>
												<td><cf_translate  key="LB_Mes">Mes</cf_translate>&nbsp;</td>
												<td><select onChange="javascript:fnChangeMes();" name="CPmes"><cfloop query="rsMeses"><option value="#Pvalor#" <cfif Month(Now()) eq Pvalor>selected</cfif>>#Pdescripcion#</option></cfloop></select></td>
												<td>&nbsp;&nbsp;&nbsp;</td>
											</tr>
										</table>
										</form>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>
<script language="javascript" type="text/javascript">
<!--// //poner a codigo javascript 
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