<cfset rsPeriodo = QueryNew("Pvalor")>
<cfset temp = QueryAddRow(rsPeriodo,3)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",Year(Now())-2,1)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",Year(Now())-1,2)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",Year(Now()),3)>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="No_se_ha_definido_el_formato_para_la_exportacion_Revise_los_parametros_de_Recursos_Humanos"
Default="No se ha definido el formato para la exportaci&oacute;n. Revise los par&aacute;metros de Recursos Humanos."
returnvariable="MG_FormatoExportacion"/> 

<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>
<!--- Busca el Parámetro para la Importacion del las polizas de riesgos laboral (INS) --->
<cfquery name="rsRHParametros" datasource="#Session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Pcodigo = 320
</cfquery>
<cfif rsRHParametros.Recordcount gt 0 and len(trim(rsRHParametros.Pvalor)) gt 0 >
	<cfquery name="rsExportaciones" datasource="sifcontrol">
		select EIid
		from EImportador
		where EIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRHParametros.Pvalor#">
	</cfquery>
<cfelse>
	<cf_throw message="#MG_FormatoExportacion#" errorcode="6010">
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

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="311" default="N" returnvariable="vPolizaDE"/>

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="420" default="" returnvariable="vPolizaINS"/>

<cfif #vPolizaDE# EQ 'S'>
	<cfquery datasource="#session.dsn#" name="rsPolizasIns">
		select distinct rtrim(ltrim(coalesce(DEdato4,'#vPolizaINS#'))) as NumPoliza
		from DatosEmpleado
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by NumPoliza
	</cfquery>
</cfif>


<cfsavecontent variable="IMPORTAR">
	<cf_sifimportar eiid="#rsExportaciones.eiid#" eicodigo="#rsRHParametros.Pvalor#" mode="out">
		<!--- Ecodigo --->
		<cf_sifimportarparam name="Ecodigo" value="#session.Ecodigo#">
		<!--- Periodo --->
		<cf_sifimportarparam name="CPperiodo" value="#Year(Now())#">
		<!--- Mes --->
		<cf_sifimportarparam name="CPmes" value="#Month(Now())#">
		<!--- Tipo de Reporte --->
		<cf_sifimportarparam name="tiporep" value=" ">
		<!--- NumPoliza --->
		<cf_sifimportarparam name="NumPoliza" value="">
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
						<td width="35%" valign="top">
							<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>#AYUDA#</td>
								</tr>
							</table>
						</td>
						<td width="55%" valign="top">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="45%">#IMPORTAR#</td>
									<td>
										<form action="" method="post" name="formexport2">
										<table border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td><cf_translate  key="LB_Periodo">Periodo</cf_translate>&nbsp;</td>
												<td><select onChange="javascript:fnChangePeriodo();" name="CPperiodo"><cfloop query="rsPeriodo"><option value="#Pvalor#" <cfif Year(Now()) eq Pvalor>selected</cfif>>#Pvalor#</option></cfloop></select></td>
												<!---<td>&nbsp;&nbsp;&nbsp;</td>--->
											</tr>
											<tr>
												<td><cf_translate  key="LB_Mes">Mes</cf_translate>&nbsp;</td>
												<td><select onChange="javascript:fnChangeMes();" name="CPmes">
														<cfloop query="rsMeses"><option value="#Pvalor#" <cfif Month(Now()) eq Pvalor>selected</cfif>>#Pdescripcion#</option>
														</cfloop>
													</select>
												</td>
												<!---<td>&nbsp;&nbsp;&nbsp;</td>--->
											</tr>
											<cfif #vPolizaDE# EQ 'S'>
												<tr>
													<td><cf_translate  key="LB_NumerodePolizaINS">N&uacute;mero de p&oacute;liza del INS</cf_translate>&nbsp;</td>
													<td>
													<select onChange="javascript:fnChangePoliza();" name="NumPoliza"> 
														<option value="" >-- Seleccionar P&oacute;liza--</option>
														<cfloop query="rsPolizasIns">
															<option value="#rsPolizasIns.NumPoliza#"> #rsPolizasIns.NumPoliza# </option>
														</cfloop>
													</select>
												</tr>
											</cfif>
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
	function fnChangePoliza(){
		var formO = document.formexport2;
		var formD = document.formexport;
		formD.NumPoliza.value = formO.NumPoliza.value;
	}
	fnChangePeriodo();
	fnChangeMes();
	fnChangePoliza();
//-->
</script>