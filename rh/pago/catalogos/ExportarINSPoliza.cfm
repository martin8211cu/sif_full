<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="No_se_ha_definido_el_formato_para_la_exportacion_Revise_los_definicion_de_la_Poliza"
Default="No se ha definido el formato para la exportaci&oacute;n. Revise los definici&oacute;n de la P&oacute;liza."
returnvariable="MG_FormatoExportacion"/> 


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
<!--- Busca el exportador --->

<cfquery name="rsRHParametros" datasource="#session.DSN#">
	select EIid as Pvalor, RHDDVcodigo as codigo, RHDDVdescripcion as descripcion
	from RHDDatosVariables
	where RHDDVlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDDVlinea#">
</cfquery>

<cfif rsRHParametros.Recordcount gt 0 and len(trim(rsRHParametros.Pvalor)) gt 0 >
	<cfquery name="rsExportaciones" datasource="sifcontrol">
		select EIid, EIcodigo
		from EImportador
		where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHParametros.Pvalor#">
	</cfquery>
<cfelse>
	<cf_throw message="MG_FormatoExportacion" errorcode="6010">
</cfif>
<cfif isdefined("rsExportaciones") and  not rsExportaciones.Recordcount>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoExisteElFormatoRequerido"
	Default="Error!, No existe el Formato Requerido!, Proceso Cancelado!"
	returnvariable="MSG_NoExisteElFormatoRequerido"/> 
	
	<cf_throw message="#MSG_NoExisteElFormatoRequerido#" errorcode="6015">
<cfelseif not isdefined("rsExportaciones")>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSeHaDefinidoElParametroParaLaExportacion"
	Default="Error!, No se ha definido el Parámetro para la exportación!, Proceso Cancelado!"
	returnvariable="MSG_NoSeHaDefinidoElParametroParaLaExportacion"/> 
	
	<cf_throw message="#MSG_NoSeHaDefinidoElParametroParaLaExportacion#" errorcode="6020">
</cfif>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_ExportacionDeRiesgosDelTrabajo"
Default="Exportación de Riesgos del Trabajo"
returnvariable="LB_ExportacionDeRiesgosDelTrabajo"/> 

<cfsavecontent variable="IMPORTAR">
	<cf_sifimportar eiid="#rsExportaciones.eiid#" eicodigo="#rsExportaciones.EIcodigo#" mode="out">
		<!--- Ecodigo --->
		<cf_sifimportarparam name="Ecodigo" value="#session.Ecodigo#">
		<!--- Periodo --->
		<cf_sifimportarparam name="CPperiodo" value="#Year(Now())#">
		<!--- Mes --->
		<cf_sifimportarparam name="CPmes" value="#Month(Now())#">
		<!--- Tipo de Reporte --->
		<cf_sifimportarparam name="poliza" value="#form.RHDDVLINEA#">
	</cf_sifimportar>
</cfsavecontent>

<cfset form.CPperiodo = Year(Now())>
<cfset form.CPmes = Month(Now())>
<cfset form.tiporep = ' ' >

<cfsavecontent variable="AYUDA">
<cf_web_portlet_start LB_ExportacionDeRiesgosDelTrabajo="#LB_ExportacionDeRiesgosDelTrabajo#" skin="info1">
	<table width="100%">
		<tr><td><p>
		<cf_translate  key="AYUDA_EsteProcesoPermiteRealizarLaExportacionDeLaInformacionMensualReferenteALosSalariosDevengados">
		Este proceso permite realizar la exportación de la información mensual referente a los salarios devengados por cada uno de 
		los empleados de la empresa; este archivo se genera con base en la estructura solicitada por el Instituto Nacional de Seguros y que se utilizará para 
		su posterior carga automática.
		</cf_translate>
		</p></td></tr>
	</table>
<cf_web_portlet_end>
</cfsavecontent>
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#LB_ExportacionDeRiesgosDelTrabajo#</cfoutput>
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet_start titulo="#LB_ExportacionDeRiesgosDelTrabajo#">
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
							<table width="100%"  border="0" cellspacing="0" cellpadding="2">
								<tr>
									<td>#IMPORTAR#</td>
									<td>
										<form action="" method="post" name="formexport2">
										<table border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td nowrap="nowrap"><strong><cf_translate  key="LB_Tipo_de_Poliza">Tipo de P&oacute;liza</cf_translate>:&nbsp;</strong></td>
												<td nowrap="nowrap"><cfoutput>#trim(rsRHParametros.codigo)# - #rsRHParametros.descripcion#</cfoutput></td>
											</tr>
											<tr>
												<td nowrap="nowrap"><strong><cf_translate  key="LB_Periodo">Periodo</cf_translate>:&nbsp;</strong></td>
												<td><select onChange="javascript:fnChangePeriodo();" name="CPperiodo"><cfloop query="rsPeriodo"><option value="#Pvalor#" <cfif Year(Now()) eq Pvalor>selected</cfif>>#Pvalor#</option></cfloop></select></td>
												<td>&nbsp;&nbsp;&nbsp;</td>
											</tr>
											<tr>
												<td nowrap="nowrap"><strong><cf_translate  key="LB_Mes">Mes</cf_translate>:&nbsp;</strong></td>
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