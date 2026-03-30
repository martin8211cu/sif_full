<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 31-8-2005
		Motivo: Creación del reporte de Estado de Cuenta del Socio de Negocios por Clasificación (solo en CxC).
	Modificado por Gustavo Fonseca H.
		Fecha: 7-9-2005.
		Motivo: Se hace left outer join sobre la tabla HDocumentos para que no se tenga que reconstruir la tabla en México (JK Gudiño).
	Modificado por Mauricio Esquivel / Gustavo Fonseca H.
		Fecha: 10-9-2005.
		Motivo: Se optimizan lo querys forzando indices, y mejorando el rendimiento. Se crean dos nuevas opciones de reportes:
			Antigüedad por Cliente y Antigüedad Resumida.
	Modificado por Mauricio Esquivel / Gustavo Fonseca H.
		Fecha: 26-9-2005.
		Motivo: Se agrega el Cobrador en el Estado de Cuenta por Clasificación.
	Modificado por Gustavo Fonseca H.
		Fecha: 6-12-2005.
		Motivo: Se agrega check para que permita ordenar los estados de cuenta por número de Reclamo.

	Modificado por: Ana Villavicencio
	Fecha: 07 de marzo del 2006
	Motivo: Agregar el filtro de Clasificación por dirección.

 --->
<script language="JavaScript" src="../../js/fechas.js"></script>
<cf_templateheader title="SIF - Cuentas por Cobrar">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estado&nbsp;de&nbsp;Cuenta&nbsp;del&nbsp;Socio&nbsp;de&nbsp;Negocios&nbsp;por&nbsp;Clasificaci&oacute;n'>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<form name="form1" action="Estado_Cuenta_Cliente_ClasiF_sql.cfm" method="get">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>Datos del Reporte</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3">
						<input type="radio" id="radio1" name="TipoReporte" value="0" checked tabindex="1">
						<label for="radio1" style="font-style:normal; font-variant:normal;">Estado de Cuenta</label>
						<input type="radio" id="radio2" name="TipoReporte" value="1" tabindex="1">
						<label for="radio2" style="font-style:normal; font-variant:normal;">Antig&uuml;edad Resumida</label>
						<input type="radio" id="radio3" name="TipoReporte" value="2" tabindex="1">
						<label for="radio3" style="font-style:normal; font-variant:normal;">Antig&uuml;edad  Por Cliente Resumido</label>
						<!--- <td><input type="radio" name="TipoReporte" value="3"></td>
						<td>Antig&uuml;edad  Por Cliente Detallado</td> --->
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Clasificaci&oacute;n:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%"><strong>Valor&nbsp;Clasificaci&oacute;n&nbsp;desde:&nbsp;</strong></td>
					<td width="10%"><strong>Valor&nbsp;Clasificaci&oacute;n&nbsp;hasta:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid1" name="SNCDvalor1" desc="SNCDdescripcion1" tabindex="1"></td>					
					<td width="10%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid2" name="SNCDvalor2" desc="SNCDdescripcion2" tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Socio&nbsp;de&nbsp;Negocios&nbsp;Inicial:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>Socio&nbsp;de&nbsp;Negocios&nbsp;Final:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2  tabindex="1"></td>
					 <td align="left"><cf_sifsociosnegocios2 form ="form1" frame="frsocios2" SNcodigo="SNcodigob2" SNnombre="SNnombreb2" SNnumero="SNnumerob2"  tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Fecha&nbsp;Desde:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>Fecha&nbsp;Hasta:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left"><cf_sifcalendario name="fechaIni" value="#LSDateFormat(now(),'dd/mm/yyyy')#"  tabindex="1"></td>
					<td nowrap align="left"><cf_sifcalendario name="fechaFin" value="#LSDateFormat(now(),'dd/mm/yyyy')#"  tabindex="1"></td>
					<td colspan="4">&nbsp;</td>					
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td style="text-decoration:underline"><strong>Orden&nbsp;de&nbsp;la&nbsp;Consulta:</strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Clasificaci&oacute;n:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion id="SNCEid_Orden" name="SNCEcodigo_Orden" desc="SNCEdescripcion_orden" form="form1" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%">
					<input name="chk_cod_Direccion" id="chk_cod_Direccion" value="1" checked type="checkbox" tabindex="1" onclick="Verificar();">
					<label for="chk_cod_Direccion"  style="font-style:normal;font-weight:normal">&nbsp;<strong>Imprimir&nbsp;por&nbsp;C&oacute;digo&nbsp;de&nbsp;Direcci&oacute;n</strong></label></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%" nowrap><strong>Cobrador:</strong></td>
					<input type="hidden" name="DEidCobrador" value="" >
					<input type="hidden" name="Cobrador" value="Todos" >
				</tr>
				<tr id="sinSNDirecciones">
					<td>&nbsp;</td>	
					 <td width="10%" nowrap><!--- --->
					 <cf_conlis 
							title="Lista de Cobradores"
							campos = "DEidCobrador_SNegocios1, DEidentificacion1, Cobrador1" 
							desplegables = "N,S,S" 
							modificables = "N,S,N"
							size = "0,20,30"
							tabla=" SNegocios a
									inner join DatosEmpleado d
										on d.DEid = a.DEidCobrador"
							columnas="distinct
										a.DEidCobrador,
										a.DEidCobrador as DEidCobrador_SNegocios,
										d.DEid as DEid_DatosEmpleado,
										d.NTIcodigo,
										d.DEidentificacion as DEidentificacion1,
										d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ', ' #_Cat# d.DEnombre as Cobrador,
										d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ', ' #_Cat# d.DEnombre as Cobrador1"
							filtro="a.Ecodigo  =#session.Ecodigo#"
							filtrar_por ="DEidentificacion, d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ' ' #_Cat# d.DEnombre"
							desplegar="DEidentificacion1, Cobrador1"
							tabindex="1"
							etiquetas="Identificaci&oacute;n, Cobrador"
							formatos="S,S"
							align="left,left"
							asignar="DEidCobrador, Cobrador, DEidentificacion1, Cobrador1"
							asignarformatos="S, S,S,S">
					 </td> 
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr id="conSNDirecciones" style="display:none">
					<td>&nbsp;</td>	
					 <td width="10%" nowrap><!--- --->
					 <cf_conlis 
							title="Lista de Cobradores por Direcci&oacute;n"
							campos = "DEidCobrador_SNdirecciones2, DEidentificacion2, Cobrador2" 
							desplegables = "N,S,S" 
							modificables = "N,S,N"
							size = "0,20,30"
							tabla=" SNDirecciones a
									inner join DatosEmpleado d
										on d.DEid = a.DEidCobrador"
							columnas="	distinct
										a.DEidCobrador,
										a.DEidCobrador as DEidCobrador_SNdirecciones,
										d.DEid as DEid_DatosEmpleado ,
										d.NTIcodigo,
										d.DEidentificacion as DEidentificacion2,
										d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ', ' #_Cat# d.DEnombre as Cobrador,
										d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ', ' #_Cat# d.DEnombre as Cobrador2"
							filtro="a.Ecodigo  =#session.Ecodigo#"
							filtrar_por ="DEidentificacion, d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ' ' #_Cat# d.DEnombre"
							desplegar="DEidentificacion2, Cobrador2"
							tabindex="1"
							etiquetas="Identificaci&oacute;n, Cobrador"
							formatos="S,S"
							align="left,left"
							asignar="DEidCobrador, Cobrador, DEidentificacion2, Cobrador2"
							asignarformatos="S,S,S,S">
					 </td> 
					<td colspan="3">&nbsp;</td>
				</tr>				
				<tr>
					<td>&nbsp;</td>
					<td valign="middle"><input name="ordenado" id="ordenado" type="checkbox" value="1" tabindex="1" /><label for="ordenado"  style="font-style:normal;font-weight:normal"> <strong>Ordenar por Reclamo</strong></label></td>
					<td align="left" width="10%"><strong>Formato:&nbsp;</strong>
					
					<select name="Formato" id="Formato" tabindex="1">
						<option value="1">FLASHPAPER</option>
						<option value="2">PDF</option>
					</select>
					</td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				  	<td valign="middle">
						<input name="SaldoCero" id="SaldoCero" type="checkbox" value="1" tabindex="1" checked="checked">
						<label for="SaldoCero" style="font-style:normal;font-weight:normal">
							<strong>Incluir Estados de Cuenta sin Movimientos</strong>
						</label>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">
					<cf_botones values="Generar" names="Generar"  tabindex="1">
					</td>
				</tr>
			</table>
			</fieldset>			
		</td>	
	</tr>
</table>	
</form>
<cf_web_portlet_end>
<cf_templatefooter>
<script language="javascript" type="text/javascript">
	function funcVisualizar(){
		document.getElementById("sinSNDirecciones").style.display='none'; 
		document.getElementById("conSNDirecciones").style.display='';
		document.form1.DEidCobrador_SNdirecciones2.value='';
		document.form1.DEidentificacion2.value='';
		document.form1.Cobrador2.value='';
		document.form1.DEidCobrador_SNegocios1.value='';
		document.form1.DEidentificacion1.value='';
		document.form1.Cobrador1.value='';
		document.form1.DEidCobrador.value= '';
	}
	function funcDesVisualizar(){
		document.getElementById("conSNDirecciones").style.display='none'; 
		document.getElementById("sinSNDirecciones").style.display=''
		document.form1.DEidCobrador_SNdirecciones2.value='';
		document.form1.DEidentificacion2.value='';
		document.form1.Cobrador2.value='';
		document.form1.DEidCobrador_SNegocios1.value='';
		document.form1.DEidentificacion1.value='';
		document.form1.Cobrador1.value='';
		document.form1.DEidCobrador.value = '';
	}

	function Verificar(){
		if (document.getElementById("chk_cod_Direccion").checked == true){
			funcVisualizar();
			}
		else{
			funcDesVisualizar();		
		}
	}
	Verificar();
</script>
 
<cf_qforms form ="form1">
<script language="javascript" type="text/javascript">
<!-- //
	objForm.SNcodigo.required = true;
	objForm.SNcodigo.description="Socio de Negocios Inicial";
	objForm.SNcodigob2.required = true;
	objForm.SNcodigob2.description="Socio de Negocios Final";
	objForm.fechaIni.required = true;
	objForm.fechaIni.description="Fecha Desde";
	objForm.fechaFin.required = true;
	objForm.fechaFin.description="Fecha Hasta";
	objForm.SNCEid.required = true;
	objForm.SNCEid.description="Clasificación";
	objForm.SNCDid1.required = true;
	objForm.SNCDid1.description="Valor Clasificación desde";
	objForm.SNCDid2.required = true;
	objForm.SNCDid2.description="Valor Clasificación desde";
	objForm.SNCEid_Orden.required = true;
	objForm.SNCEid_Orden.description="Orden de impresión por Clasificación";

	function funcGenerar(){ 
	if (datediff(document.form1.fechaIni.value, document.form1.fechaFin.value) < 0) 
		{	
				alert ('La Fecha Hasta debe ser mayor a la Fecha Desde');
				return false;
		} 
	}
//-->	
</script>