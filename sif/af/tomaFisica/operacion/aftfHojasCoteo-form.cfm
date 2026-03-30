<cf_dbfunction name="now" returnvariable="hoy">
<cfsilent>

<cfif (modo NEQ "ALTA")>
	<cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" method="getHojaConteoById" 
			returnvariable="rsForm" AFTFid_hoja="#Form.AFTFid_hoja#"/>
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" 
			returnvariable="ts" artimestamp="#rsForm.ts_rversion#"/>
</cfif>

<cfif (mododet NEQ "LISTA") and (mododet NEQ "ALTA")>
	<cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" method="getDHojaConteoById" 
			returnvariable="rsFormDet" AFTFid_detallehoja="#Form.AFTFid_detallehoja#"/>
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" 
			returnvariable="tsdet" artimestamp="#rsFormDet.ts_rversion#"/>
</cfif>

</cfsilent>

<cfoutput>

<form action="aftfHojasCoteo-sql.cfm" method="post" name="form1" style="margin:0px">
<cfif (modo NEQ "ALTA")>
<input type="hidden" id="AFTFid_hoja" name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
<input type="hidden" name="ts_rversion" value="#ts#" >
</cfif>
<cfinclude template="aftfHojasCoteo-hiddens.cfm">
<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right" class="fileLabel" nowrap>Descripci&oacute;n&nbsp;:&nbsp;</td>
    <td>
		<input type="text" <cfif (modo NEQ "ALTA")>value="#HTMLEditFormat(rsForm.AFTFdescripcion_hoja)#"</cfif>
			<cfif (modo NEQ 'ALTA') and (rsform.AFTFestatus_hoja gt 0)> 
				tabindex="-1"
				readonly
				style="border:solid 1px ##CCCCCC; background:inherit;"
			<cfelse>
				tabindex="1"
				onFocus="javascript:this.select();"
			</cfif>
			id="AFTFdescripcion_hoja" name="AFTFdescripcion_hoja" size="60" maxlength="80">
	</td>
	<td>&nbsp;</td>
	<td align="right" class="fileLabel" nowrap><cfif (modo NEQ "ALTA")>Estatus&nbsp;:</cfif>&nbsp;</td>
	<td nowrap>
		<input type="text" id="AFTFestatus_hoja_text" name="AFTFestatus_hoja_text"
			tabindex="-1"
			readonly
			style="border:solid 1px ##CCCCCC; background:inherit;"
			size="30"
		<cfif (modo NEQ 'ALTA')><cfloop query='rsAFTFestatus_hoja'>
			<cfif value EQ rsForm.AFTFestatus_hoja>
				value="#description#"
			</cfif>
		</cfloop></cfif>>
	</td>
	<cfif (modo NEQ 'ALTA') and (rsform.AFTFestatus_hoja gt 0)>
	<td rowspan="3">&nbsp;</td>
	<td rowspan="3">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td nowrap>Fecha Conteo:&nbsp;</td>
			<td><cf_sifcalendario readOnly="true" name="AFTFfecha_conteo_hoja" query="#rsForm#" tabindex="1"></td>
		  </tr>
		  <tr>
			<td nowrap>Fecha Aplicaci&oacute;n:&nbsp;&nbsp;</td>
			<td><cf_sifcalendario readOnly="true" name="AFTFfecha_aplicacion" query="#rsForm#" tabindex="1"></td>
		  </tr>
		  <tr>
			<td colspan="2" nowrap>
				<cfif (mododet EQ "LISTA") and (modo NEQ "IMPORTAR")>
					<cf_botones values="Imprimir,Lista">
				<cfelse>
					&nbsp;					
				</cfif>
			</td>
		  </tr>
		</table>
	</td>
	</cfif>
  </tr>
  <tr>
  	<td align="right" class="fileLabel" nowrap>Dispositivo&nbsp;:&nbsp;</td>
	<td>
		<cfset valuesArray = ArrayNew(1)>
		<cfif (modo NEQ "ALTA")>
			<cfset ArrayAppend(valuesArray,rsForm.AFTFid_dispositivo)>
			<cfset ArrayAppend(valuesArray,rsForm.AFTFcodigo_dispositivo)>
			<cfset ArrayAppend(valuesArray,rsForm.AFTFnombre_dispositivo)>
		</cfif>
		<cf_conlis maxrowsquery="200"
			readOnly="#(modo NEQ 'ALTA') and (rsform.AFTFestatus_hoja gt 0)#"
			campos="AFTFid_dispositivo, AFTFcodigo_dispositivo, AFTFnombre_dispositivo" 
			size="0,20,34"
			desplegables="N,S,S"
			modificables="N,S,N"
			asignar="AFTFid_dispositivo, AFTFcodigo_dispositivo, AFTFnombre_dispositivo" 
			asignarformatos="I,S,S" 
			columnas="AFTFid_dispositivo, AFTFcodigo_dispositivo, AFTFnombre_dispositivo" 
			tabla="AFTFDispositivo"
			filtro="CEcodigo = #session.CEcodigo# and AFTFestatus_dispositivo = 1" 
			desplegar="AFTFcodigo_dispositivo, AFTFnombre_dispositivo" 
			formatos="S,S"
			align="left,left"
			etiquetas="C&oacute;digo, Descripci&oacute;n" 
			filtrar_por="AFTFcodigo_dispositivo, AFTFnombre_dispositivo" 
			tabindex="1" 
			title="Lista de Dispositivos"
			valuesArray="#valuesArray#"
			/>			
	</td>
	<td>&nbsp;</td>
	<td align="right" class="fileLabel" nowrap>Fecha&nbsp;:&nbsp;</td>
	<td>
		<cfif (modo NEQ "ALTA")>
			<cf_sifcalendario readOnly="#(modo NEQ 'ALTA') and (rsform.AFTFestatus_hoja gt 0)#" name="AFTFfecha_hoja" query="#rsForm#" tabindex="1">
		<cfelse>
			<cf_sifcalendario name="AFTFfecha_hoja" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
		</cfif>
	</td>
  </tr>
  <tr>
  	<td align="right" class="fileLabel" nowrap>Emp. Resp.&nbsp;:&nbsp;</td>
	<td>
		<cfset valuesArray = ArrayNew(1)>
		<cfif (modo NEQ "ALTA")>
			<cfset ArrayAppend(valuesArray,rsForm.DEid)>
			<cfset ArrayAppend(valuesArray,rsForm.DEidentificacion)>
			<cfset ArrayAppend(valuesArray,rsForm.DEnombre)>
		</cfif>
		<cf_conlis maxrowsquery="200"
			readOnly="#(modo NEQ 'ALTA') and (rsform.AFTFestatus_hoja gt 0)#"
			campos="DEid,DEidentificacion,DEnombre" 
			size="0,20,34"
			desplegables="N,S,S"
			modificables="N,S,N"
			asignar="DEid,DEidentificacion,DEnombre" 
			asignarformatos="I,S,S" 
			columnas="de.DEid, de.DEidentificacion, {fn concat(de.DEapellido1, {fn concat(' ', {fn concat(de.DEapellido2, {fn concat(' ', de.DEnombre)})})})} as DEnombre" 
			tabla="DatosEmpleado de"
			filtro="Ecodigo = #session.Ecodigo#
				and 
				(exists 
					( select 1 from LineaTiempo lt 
					where lt.DEid = de.DEid
					and #hoy# between lt.LTdesde and lt.LThasta  )
				or exists
					( select 1 from EmpleadoCFuncional ecf 
					where ecf.DEid = de.DEid
					and #hoy# between ecf.ECFdesde and ecf.ECFhasta )
				)"
			desplegar="DEidentificacion, DEnombre" 
			formatos="S,S"
			align="left,left"
			etiquetas="C&oacute;digo, Descripci&oacute;n" 
			filtrar_por="de.DEidentificacion| {fn concat(de.DEapellido1, {fn concat(' ', {fn concat(de.DEapellido2, {fn concat(' ', de.DEnombre)})})})}" 
			filtrar_por_delimiters="|"
			tabindex="1" 
			title="Lista de Dispositivos"
			valuesArray="#valuesArray#"
			funcion="setResponsable"
			fparams="DEid,DEidentificacion,DEnombre"
			/>			
	</td>
	<td>&nbsp;</td>
	<td align="right" class="fileLabel" nowrap>Resp. Conteo&nbsp;:&nbsp;</td>
	<td>
		<input type="text" <cfif (modo NEQ "ALTA")>value="#HTMLEditFormat(rsForm.AFTFresponsable_hoja)#"</cfif>
			<cfif (modo NEQ 'ALTA') and (rsform.AFTFestatus_hoja gt 0)> 
				tabindex="-1"
				readonly
				style="border:solid 1px ##CCCCCC; background:inherit;"
			<cfelse>
				tabindex="1"
				onFocus="javascript:this.select();"
			</cfif>
			id="AFTFresponsable_hoja" name="AFTFresponsable_hoja" size="30" maxlength="80">
	</td>
  </tr>
</table>
<!--- DEFINICIÓN DE LOS BOTONES DEL PROCESO --->
<cfif (modo EQ "ALTA")>
	<cf_botones modo="#modo#" tabindex="1" include="Lista">
<cfelseif ((modo NEQ "ALTA") and (rsform.AFTFestatus_hoja eq 0))>
	<cf_botones modo="#modo#" tabindex="1" include="Aplicar,Imprimir,Lista">
</cfif>
</form>
<cfif (modo NEQ "ALTA")>
	<cfswitch expression="#rsform.AFTFestatus_hoja#">
		<cfcase value="0">
			<cfinclude template="aftfHojasCoteo-formhoja.cfm">
			<cfinclude template="aftfHojasCoteo-listahoja.cfm">
		</cfcase>
		<cfcase value="2">
			<cfif (modo EQ "IMPORTAR")>
				<cfinclude template="aftfHojasCoteo-RPIMP_AFTFRC.cfm">
			<cfelse>
				<cfif (mododet EQ "LISTA")>
					<cfinclude template="aftfHojasCoteo-listahoja.cfm">
				<cfelse>
					<cfinclude template="aftfHojasCoteo-formactivo.cfm">
				</cfif>
			</cfif>
		</cfcase>
		<cfdefaultcase>
			<cfinclude template="aftfHojasCoteo-listahoja.cfm">
		</cfdefaultcase>
	</cfswitch>
</cfif>

</cfoutput>

<cf_qforms>
	<cf_qformsrequiredfield args="AFTFdescripcion_hoja,Descripción">
	<cf_qformsrequiredfield args="AFTFfecha_hoja,Fecha">
	<cf_qformsrequiredfield args="AFTFresponsable_hoja,Resp. Conteo">
</cf_qforms>

<script language="javascript" type="text/javascript">
	<!--//
	/*Funciones Especiales*/
	function setResponsable(DEid,DEidentificacion,DEnombre){
		if (objForm.AFTFresponsable_hoja.getValue()==''){
			objForm.AFTFresponsable_hoja.obj.value=DEnombre;
		}
	}
	function funcLista(){
		deshabilitarValidacion();
		if (objForm.AFTFid_hoja) objForm.AFTFid_hoja.obj.value = "";
		objForm.obj.action="aftfHojasCoteo.cfm";
	}
	function funcRegresar(){
		deshabilitarValidacion();
		objForm.obj.action="aftfHojasCoteo.cfm";
	}
	/*Funciones de los Botones*/
	function funcNuevo(){
		deshabilitarValidacion();
		if (objForm.AFTFid_hoja) objForm.AFTFid_hoja.obj.value = "";
		objForm.obj.action="aftfHojasCoteo.cfm";
	}
	
	function funcImprimir(){
		<cfoutput>
		document.lista2.AFTFID_HOJA.value="#Form.AFTFid_hoja#";
		document.lista2.action = "aftfHojasCoteo-rpthoja.cfm?imprimir=1&#JSStringFormat(Gvar_navegacion_Lista1)#";
		document.lista2.submit();
		</cfoutput>
		return false;
	}
	/*Foco Inicial de la Pantalla*/
	<cfif (modo EQ 'ALTA') or ((modo NEQ 'ALTA') and (rsform.AFTFestatus_hoja eq 0))>
	objForm.AFTFdescripcion_hoja.obj.focus();
	</cfif>
	//-->
</script>