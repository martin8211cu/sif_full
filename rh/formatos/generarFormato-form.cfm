<cfquery name="rsListaFormatos" datasource="#Session.DSN#">
	select a.EFid, {fn concat({fn concat(rtrim(a.EFcodigo) , ' - ' )},  a.EFdescripcion )} as descripcion
	from EFormato a, TFormatos b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and a.TFid = b.TFid
	and upper(b.TFdescripcion) like '%RH%'
	order by 2
</cfquery>
<br />
<cfoutput>

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<form name="form1" action="generarFormato-sql.cfm" method="post" onsubmit="return validar()">
	<fieldset><legend><cf_translate key="LB_DatosDeLaCertificacionDocumentoAGenerar">Datos de la Certificaci&oacute;n / Documento A Generar</cf_translate></legend>
	<table width="100%" border="0" cellspacing="2" cellpadding="2">
		<cfif rsListaFormatos.recordCount gt 0>
			<tr>
				<td class="fileLabel"><cf_translate key="LB_Formato">Formato</cf_translate>:</td>
				<td>
					<select name="EFid" id="EFid">
						<cfloop query="rsListaFormatos">
							<option value="#EFid#">#descripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>

			<tr>
				<td class="fileLabel"><input type="radio" name="radio1" id="radio1" value="1" onclick="RadioVal(this.value)" checked="checked" /><cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;</td>
				<td style="display:''" id="tdemp"><cf_rhempleado></td>
			</tr>
			<tr>
				<td><input type="radio" name="radio1"  id="radio1" value="2"  onclick="RadioVal(this.value)"/><cf_translate key="LB_Curso">Cursos</cf_translate>:&nbsp;</td>
				<td  style="display:none" id="tdcur">
										<cf_conlis title="LISTA DE CURSOS"
										campos = "RHCid,RHCcodigo,RHCnombre,RHIAnombre,RHCfdesde,RHCfhasta" 
										desplegables = "N,S,S,N,N,N" 
										modificables = "N,S,N,N,N,N" 
										size = "0,15,34,0,0,0"
										asignar="RHCid,RHCcodigo,RHCnombre,RHIAnombre,RHCfdesde,RHCfhasta"
										asignarformatos="S,S"
										tabla="RHCursos a inner join RHInstitucionesA b on a.RHIAid=b.RHIAid"
										columnas="RHCid,RHCcodigo,RHCnombre,RHIAnombre,RHCfdesde,RHCfhasta"
										filtro="a.Ecodigo = #Session.Ecodigo#"
										desplegar="RHCcodigo,RHCnombre,RHIAnombre,RHCfdesde,RHCfhasta"
										etiquetas="Codigo,Nombre,Institución,Fecha Desde,Fecha Hasta"
										formatos="S,S,S,D,D"
										align="left,left,left,left,left"
										showEmptyListMsg="true"
										EmptyListMsg=""
										form="form1"
										width="1000"
										height="500"
										left="70"
										top="20"
										fparams="RHCid"/> 
					       	
				</td>
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
		Key="MSG_Curso"
		Default="Curso"
		returnvariable="MSG_Curso"/>	
	
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Fecha"
		Default="Fecha"
		returnvariable="MSG_Fecha"/>		
		
	//-->
</script>

<script language="javascript">	
	function RadioVal(m){
	var objEmp = document.getElementById('tdemp');
	var objCur = document.getElementById('tdcur');
		if (m==1){
		objEmp.style.display = '';
		objCur.style.display = 'none';
		}
		
		if (m==2){
		objCur.style.display = '';
		objEmp.style.display = 'none';
		}
	}	
	function radioSelected(){
		var i
		for (i=0;i<document.form1.radio1.length;i++){
		   if (document.form1.radio1[i].checked)
			  break;
		} 
		return (document.form1.radio1[i].value);
	}
	
	function validar(){
	
		var err="";
		if (document.getElementById('EFid').value == ""){
			err= err +  "Debe seleccionar a un Formato.\n";
		}
		if (document.getElementById('CSEfrecoge').value == ""){
			err= err + "Debe seleccionar una fecha de solicitud.\n";
		}
		var sel = radioSelected();
		if (sel == 1){
			if (document.form1.DEid.value == ""){
				err= err + "Debe seleccionar a un empleado. \n";
			}
		}
		if (sel == 2){
			if (document.getElementById('RHCid').value == ""){
				err = err + "Debe seleccionar a un curso.\n";
			}
		}	
		if(err == ""){
			return true;
		}else {
			alert(err);
			return false;
		}
		
	
	}
	
</script>
</cfoutput>