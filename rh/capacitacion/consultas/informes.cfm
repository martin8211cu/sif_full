<cf_templateheader title="Evaluaci&oacute;n de Cuestionarios"> 

 <cf_web_portlet_start border="true" titulo="Informes de Capacitaci&oacute;n y Desarrollo" skin="#Session.Preferences.Skin#">
 	<form name="form1" method="post" action="informes-reporte.cfm">
 	<table>
		<tr>
			<td width="50%">
				<cf_web_portlet_start border="true" titulo="Capacitaci&oacute;n y Desarrollo" skin="info1">
					<div align="justify">
						<p>Este reporte muestra los resultados obtenidos de la aplicaci&oacute;n de una capacitaci&oacute;n y muestra diferentes opciones para desplegar la informaci&oacute;n</p>
					</div>
				<cf_web_portlet_end>
			</td>
			<td width="50%">
				<table border="0" width="100%">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td>
							Fecha Desde:
						</td>
						<td>
							<cf_sifcalendario name="fdesde" index="1">
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap">
							Fecha Hasta:
						</td>
						<td>
							<cf_sifcalendario name="fhasta" index="2">
						</td>
					</tr>					
					<tr>
						<td colspan="2">
							<table width="100%">
								<tr>
									<td><input type="radio" name="radio1" value="0" checked="checked" onclick="funcPuestos(this.value)" />An&aacute;lisis de funcionarios capacitados por &aacute;rea</td>
								</tr>
								<tr>
									<td><input type="radio" name="radio1" value="1" checked="checked" onclick="funcPuestos(this.value)"/>Actividades de Capacitaci&oacute;n por &aacute;rea</td>
								</tr>
								<tr>
									<td><input type="radio" name="radio1" value="2" checked="checked" onclick="funcPuestos(this.value)" />Promedio de calificaci&oacute;n por curso</td>
								</tr>
								<tr style="display:none" id="tdcur">
									<td>
								<cfinvoke component="sif.Componentes.Translate" method="Translate"
										Key="LB_LISTADECURSOS"	Default="LISTA DE CURSOS" returnvariable="LB_LISTADECURSOS"/>
										<cf_conlis title="#LB_LISTADECURSOS#"
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
										etiquetas="Codigo,Nombre,Instituci&oacute;n,Fecha Desde,Fecha Hasta"
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
									<td><input type="radio" name="radio1" value="3" checked="checked" onclick="funcPuestos(this.value)" />Personal capacitado por Centro Funcional</td>
								</tr>
								<tr style="display:none" id="tdcf">
									<td width="7%">
										Centro Funcional:<cf_rhcfuncional>
									</td>	
								</tr>
								<tr>
									<td><input type="radio" name="radio1" value="4" checked="checked" onclick="funcPuestos(this.value)" />Certificaci&oacute;n cursos impartidos por instructor</td>
								</tr>	
								<tr id="tdci" style="display:none" >
									<td colspan="3" valign="top" >
                                    <cfinvoke component="sif.Componentes.Translate"	method="Translate"
										Key="LB_ListaInstructores" Default="Lista de Instructores" returnvariable="LB_ListaInstructores"/>	
										<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
										<cf_conlis
										Campos="RHIid,RHCprofesor"
										Desplegables="N,S"
										Modificables="N,N"
										Size="0,50"
										tabindex="1"
										Title="#LB_ListaInstructores#"
										Tabla="RHInstructores a"
										Columnas="a.RHIid,a.RHIidentificacion,a.RHInombre,a.RHIapellido1,a.RHIapellido2,coalesce(a.RHIapellido1,'') #LvarCNCT# ' ' #LvarCNCT# coalesce(a.RHIapellido2,'')#LvarCNCT# ' '#LvarCNCT# coalesce(a.RHInombre,'') as RHCprofesor"
										Filtro=" Ecodigo = #Session.Ecodigo# order by RHIapellido1,RHIapellido2,RHInombre "
										Desplegar="RHIidentificacion,RHCprofesor"
										Etiquetas="Identificaci&oacute;n,Nombre"
										filtrar_por="RHIidentificacion, a.RHIapellido1 #LvarCNCT# ' '+#LvarCNCT# a.RHIapellido2 #LvarCNCT# ' '#LvarCNCT#a.RHInombre"
										Formatos="S,S,S,S"
										Align="left,left,left,left"
										form="form1"
										Asignar="RHIid,RHCprofesor"
										Asignarformatos="S,S"
										/>		
								</td>	
								</tr>
								<tr>
									<td><input type="radio" name="radio1" value="5" checked="checked" onclick="funcPuestos(this.value)" />Personal capacitado por Puesto</td>
								</tr>	
								<td width="7%"  style="display:none" id="tdpuesto">
									Puesto:<cf_rhpuesto>
								</td>								
							</table>
						</td>
					</tr>
					<tr>
						<td align="center" colspan="2">
							<cf_botones names="Consultar,Limpiar" values="Consultar,Limpiar">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</form>
  <cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript">
function funcPuestos(m){

var objDA = document.getElementById('tdpuesto');
var objCF = document.getElementById('tdcf');
var objI = document.getElementById('tdci');
var objC = document.getElementById('tdcur');
	if (m==0){
	objCF.style.display = 'none';		
	objI.style.display = 'none';	
	objDA.style.display = 'none';
	objC.style.display = 'none';	
	}
	if (m==1){
	objCF.style.display = 'none';		
	objI.style.display = 'none';	
	objDA.style.display = 'none';
	objC.style.display = 'none';	
	}
	if (m==2){
	objCF.style.display = 'none';		
	objI.style.display = 'none';	
	objDA.style.display = 'none';
	objC.style.display = '';	
	}
	else{
	objC.style.display = 'none';}
	if (m==5){		
		objDA.style.display = '';
		objCF.style.display = 'none';		
		objI.style.display = 'none';
		objC.style.display = 'none';			
	}
	else{
	objDA.style.display = 'none';	
	}
	if (m==3){		
		objCF.style.display = '';
		objDA.style.display = 'none';
		objI.style.display = 'none';
		objC.style.display = 'none';			
	}
	else{
	objCF.style.display = 'none';	
	}
	if (m==4){		
		objI.style.display = '';
		objDA.style.display = 'none';
		objCF.style.display = 'none';	
		objC.style.display = 'none';			
	}
	else{
	objI.style.display = 'none';	
	}
}
</script>