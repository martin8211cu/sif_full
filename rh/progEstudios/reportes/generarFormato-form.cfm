<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
<cfquery name="rsListaFormatos" datasource="#Session.DSN#">
	select a.EFid, a.EFcodigo #_CAT# ' - '  #_CAT# a.EFdescripcion  as descripcion
	from EFormato a
    	inner join TFormatos b
        	on a.TFid = b.TFid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and upper(b.TFdescripcion) like '%RH%'
    and TFdescripcion = 'rh.becas'
	order by 2
</cfquery>
<br />
<cfoutput>
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<form name="form1" action="generarFormato-sql.cfm" method="post">
	<fieldset><legend><cf_translate key="LB_DatosDeLaCertificacionDocumentoAGenerar">Datos de la Certificaci&oacute;n / Documento A Generar</cf_translate></legend>
	<table width="100%" border="0" cellspacing="2" cellpadding="2">
		<cfif rsListaFormatos.recordCount gt 0>
			<tr>
				<td class="fileLabel"><cf_translate key="LB_Formato">Formato</cf_translate>:</td>
				<td>
					<select name="EFid">
						<cfloop query="rsListaFormatos">
							<option value="#EFid#">#descripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>

			<tr>
				<td class="fileLabel"><cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;</td>
				<td>
                	<cf_conlis
                    campos="DEid,DEidentificacion,Empleado"
                    desplegables="N,S,S"
                    modificables="N,S,N"
                    size="0,10,50"
                    title="Lista De Empleados"
                    tabla="DatosEmpleado"
                    columnas="DEid, DEidentificacion, DEnombre#_CAT#' '#_CAT#DEapellido1#_CAT#' '#_CAT#DEapellido2 as Empleado"
                    filtro="Ecodigo = #session.Ecodigo#"
                    desplegar="DEidentificacion, Empleado"
                    filtrar_por="DEidentificacion|DEnombre#_CAT#' '#_CAT#DEapellido1#_CAT#' '#_CAT#DEapellido1"
                    filtrar_por_delimiters="|"
                    etiquetas="Identificación,Empleado"
                    formatos="S,S"
                    align="left,left"
                    asignar="DEid, DEidentificacion, Empleado"
                    asignarformatos="I,S,S"
                    showEmptyListMsg="true"
                    form = "form1"
                    tabindex = "2"
                    funcion="fnLimpiar()"
                	funcionValorEnBlanco="fnLimpiar()">
                </td>
			</tr>
            <tr>
				<td class="fileLabel">Beca:&nbsp;</td>
				<td><cf_conlis
                    campos="RHEBEid,RHTBid,RHTBcodigo,RHTBdescripcion"
                    desplegables="N,N,S,S"
                    modificables="N,N,S,N"
                    size="0,0,10,50"
                    title="Becas del Empleado"
                    tabla="RHEBecasEmpleado eb inner join RHTipoBeca tb on tb.RHTBid = eb.RHTBid"
                    columnas="eb.RHEBEid,tb.RHTBid, RHTBcodigo, RHTBdescripcion, RHEBEfecha"
                    filtro="(RHTBesCorporativo = 1 or (RHTBesCorporativo = 0 and  eb.Ecodigo = #session.Ecodigo#)) and eb.DEid = $DEid,numeric$ and eb.RHEBEestado = 70"
                    desplegar="RHTBcodigo, RHTBdescripcion,RHEBEfecha"
                    filtrar_por="RHTBcodigo|RHTBdescripcion|RHEBEfecha"
                    filtrar_por_delimiters="|"
                    etiquetas="Codigo,Descripción,Fecha"
                    formatos="S,S,D"
                    align="left,left,left"
                    asignar="RHEBEid,RHTBid,RHTBcodigo,RHTBdescripcion"
                    asignarformatos="I,S,S,D"
                    showEmptyListMsg="true"
                    form = "form1"
                    tabindex = "1"
                ></td>
			</tr>

			<tr>
				<td class="fileLabel"><cf_translate key="LB_FechaDeSolicitud">Fecha de Solicitud</cf_translate>:&nbsp;</td>
				<td><cf_sifcalendario name="CSEfrecoge" value="#LSDateFormat(Now(), 'dd/mm/yyyy')#"></td>
			</tr>
				
			<tr>
				<td colspan="2"><cf_botones values="Generar" names="btnSolicitar"></td>
			</tr>
		<cfelse>
			<tr><td align="center"><strong><cf_translate key="MSG_DebeDefinirFormatosAntesDeProcederAGenerarAlguno">Debe definir formatos antes de proceder a generar alguno</cf_translate></strong></td></tr>
		</cfif>		
	</table>

	</fieldset>
</form>
</td>
</tr>
</table>
<br />
<cf_qforms>
<script language="javascript">
	<!--//
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Formato"
		Default="Formato"
		returnvariable="MSG_Formato"/>		
	
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Empleado"
		Default="Empleado"
		returnvariable="MSG_Empleado"/>		
	
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Fecha"
		Default="Fecha"
		returnvariable="MSG_Fecha"/>
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Beca"
		Default="Beca"
		returnvariable="MSG_Beca"/>			
		
		objForm.EFid.description = "<cfoutput>#MSG_Formato#</cfoutput>";
		objForm.DEid.description = "<cfoutput>#MSG_Empleado#</cfoutput>";
		objForm.RHEBEid.description = "<cfoutput>#MSG_Beca#</cfoutput>";
		objForm.CSEfrecoge.description = "<cfoutput>#MSG_Fecha#</cfoutput>";
		objForm.EFid.required = true;
		objForm.DEid.required = true;
		objForm.RHEBEid.required = true;
		objForm.CSEfrecoge.required = true;
	//-->
	
	function fnLimpiar(){
		document.form1.RHEBEid.value = "";
		document.form1.RHTBid.value = "";
		document.form1.RHTBcodigo.value = "";
		document.form1.RHTBdescripcion.value = "";
	}
</script>
</cfoutput>