<!--- Funcionalidad Especial El Usuario Funciona como Id del Documento por Falta de ID de Documento --->
<cf_dbfunction name="now" returnvariable="hoy">
<cfoutput>
  <table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td>
		<form action="traspaso_responsable-sql.cfm" name="form1" onSubmit="return validar();" method="post" style="margin:0">
			<table width="100%" border="0" cellspacing="0" cellpadding="2">
				<tr>
					<td colspan="2"><input type="hidden" value="o" name="o" id="o" /></td>
				</tr>
				<tr>
					<td valign="top" nowrap="NOWRAP" class="tituloSub">
						
							<fieldset>
								<legend>Filtro Origen</legend>
								<table width="100%"  border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td nowrap="nowrap" class="fileLabel">Centro de Custodia:&nbsp;</td>
										<td>
											<cfquery name="rsCRCC" datasource="#Session.Dsn#">
												select a.CRCCid as value, <cf_dbfunction name="concat" args="rtrim(a.CRCCcodigo) ,' - ' , rtrim(a.CRCCdescripcion)"> as description
												from CRCentroCustodia a
													inner join CRCCUsuarios b
													on a.CRCCid = b.CRCCid
													and b.Usucodigo = #Session.Usucodigo#
												where a.Ecodigo = #Session.Ecodigo# 
												order by a.CRCCcodigo
											</cfquery>
											<cfif rsCRCC.recordcount eq 0>
											<cf_errorCode	code = "50135" msg = "Usted no tiene asociado ningún Centro de Custodia, no puede utilizar este proceso, Proceso Cancelado!">
											</cfif>
											
											<select  tabindex="1" name="CRCCid">
												<!---<option value="">--Todos--</option>--->
												<cfloop query="rsCRCC">	
												<option value="#value#">#description#</option>
												</cfloop>
											</select>
										</td>
									</tr>
									<tr>
										<td  class="fileLabel">Tipo de Documento:&nbsp;</td>
										<td>
											<cfquery name="rsCRTD" datasource="#Session.Dsn#">
												select CRTDid as value,<cf_dbfunction name="concat" args="rtrim(CRTDcodigo) ,' - ' , rtrim(CRTDdescripcion)">  as description
												from CRTipoDocumento
												where Ecodigo = #Session.Ecodigo# 
												order by CRTDcodigo,CRTDdescripcion
											</cfquery>
											<select tabindex="2"  name="CRTDid">
												<option value="">--Todos--</option>
												<cfloop query="rsCRTD">	
												<option value="#value#">#description#</option>
												</cfloop>
											</select>
										</td>
									</tr>
									<tr>
										<td class="fileLabel">Placa:&nbsp;</td>
										<td>
											<cf_conlis
												tabindex="3"
												Campos="Aplacai,Adescripcioni"
												Desplegables="S,S"
												Modificables="S,N"
												Size="15,35"
												Title="Placas"
												Tabla="Activos A
														inner join AFResponsables  B
															on A.Ecodigo = B.Ecodigo
															and A.Aid = B.Aid
															and B.CRCCid = $CRCCid,numeric$
															and #hoy# between B.AFRfini and B.AFRffin"
												Columnas="Aplaca as Aplacai,Adescripcion as Adescripcioni"
												Filtro="A.Ecodigo = #Session.Ecodigo# and A.Astatus = 0 order by Aplaca "
												Desplegar="Aplacai,Adescripcioni"
												Etiquetas="Placa,Descripci&oacute;n"
												filtrar_por="Aplaca,Adescripcion"
												Formatos="S,S"
												Align="left,left"
												Asignar="Aplacai,Adescripcioni"
												Asignarformatos="S,S,S,S"
												MaxRowsQuery="200"/>
										</td>
									</tr>
									<tr>
										<td class="fileLabel">Empleado:&nbsp;</td>
										<td>
											<cf_dbfunction name="concat" args="A.DEapellido1 ,' ' ,A.DEapellido2 ,' ',A.DEnombre" returnvariable="DEnombrecompleto">
											<cf_conlis
												Campos="DEid,DEidentificacion,DEnombrecompleto"
												tabindex="5"
												Desplegables="N,S,S"
												Modificables="N,S,N"
												Size="0,15,35"
												Title="Lista de Empleados"
												Tabla="DatosEmpleado A 
													   inner join  AFResponsables B
														on A.DEid = B.DEid
														and A.Ecodigo = B.Ecodigo 
														and B.CRCCid = $CRCCid,numeric$
														and #hoy# between B.AFRfini and B.AFRffin"
												Columnas="distinct A.DEid ,A.DEidentificacion, #PreserveSingleQuotes(DEnombrecompleto)# as DEnombrecompleto"
												Filtro="A.Ecodigo = #Session.Ecodigo# order by DEidentificacion,DEnombrecompleto"
												Desplegar="DEidentificacion,DEnombrecompleto"
												Etiquetas="Identificaci&oacute;n,Nombre"
												filtrar_por="A.DEidentificacion,#PreserveSingleQuotes(DEnombrecompleto)#"
												Formatos="S,S"
												Align="left,left"
												Asignar="DEid,DEidentificacion,DEnombrecompleto"
												Asignarformatos="I,S,S"/>											
										</td>
									</tr>
														
									<tr>
										<td class="fileLabel">Centro Funcional:&nbsp;</td>
										<td>
											<cf_conlis
												Campos="CFid,CFcodigo,CFdescripcion"
												tabindex="6"
												Desplegables="N,S,S"
												Modificables="N,S,N"
												Size="0,15,35"
												Title="Lista de Centros Funcionales"
												Tabla="CRCCCFuncionales a
														inner join CFuncional b
														on a.CFid = b.CFid
														and b.Ecodigo = #Session.Ecodigo#
														inner join CRCentroCustodia c
														on a.CRCCid = c.CRCCid 
														and c.CRCCid = $CRCCid,numeric$"
												Columnas="b.CFid,b.CFcodigo,b.CFdescripcion"
												Filtro="1=1 order by CFcodigo,CFdescripcion"
												Desplegar="CFcodigo,CFdescripcion"
												Etiquetas="C&oacute;digo,Descripci&oacute;n"
												filtrar_por="b.CFcodigo,b.CFdescripcion"
												Formatos="S,S"
												Align="left,left"
												Asignar="CFid,CFcodigo,CFdescripcion"
												Asignarformatos="I,S,S"
												funcion="resetEmpleado"/>
										</td>
									</tr>

								</table>	
							</fieldset>
						
					</td>
					<td  valign="top"  nowrap="NOWRAP" class="tituloSub">
						
							<fieldset>
								<legend>Datos Destino</legend>
								<table width="100%"  border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td class="fileLabel">Empleado:&nbsp;</td>
										<td>
										<cf_dbfunction name="concat" args="d.DEapellido1 ,' ' , d.DEapellido2 ,' ',d.DEnombre" returnvariable="DEnombrecompleto2">
											<cf_conlis
												tabindex="7"
												Campos="DEid2,DEidentificacion2,DEnombrecompleto2"
												Desplegables="N,S,S"
												Modificables="N,S,N"
												Size="0,10,35"
												Title="Lista de Empleados"
												Tabla="DatosEmpleado d
														left outer join LineaTiempo a
															on a.DEid = d.DEid
															and #hoy# between a.LTdesde and a.LThasta
														left outer join RHPlazas b 
															on b.RHPid = a.RHPid
															
														left outer join EmpleadoCFuncional decf
															on decf.DEid = d.DEid
															and #hoy# between decf.ECFdesde and decf.ECFhasta
														
														inner join CFuncional cf
															on cf.CFid = coalesce(b.CFid,decf.CFid)"
												Columnas="d.DEid as DEid2,d.DEidentificacion as DEidentificacion2,#PreserveSingleQuotes(DEnombrecompleto2)# as DEnombrecompleto2,cf.CFid as CFid2,cf.CFcodigo as CFcodigo2,cf.CFdescripcion as CFdescripcion2"
												Filtro="d.Ecodigo = #Session.Ecodigo# order by DEidentificacion2,DEnombrecompleto2"
												Desplegar="DEidentificacion2,DEnombrecompleto2"
												Etiquetas="Identificaci&oacute;n,Nombre"
												filtrar_por="d.DEidentificacion,#PreserveSingleQuotes(DEnombrecompleto2)#"
												Formatos="S,S"
												Align="left,left"
												Asignar="DEid2,DEidentificacion2,DEnombrecompleto2,CFid2,CFcodigo2,CFdescripcion2"
												Asignarformatos="I,S,S,I,S,S"
												MaxRowsQuery="200"/>								</td>
									</tr>
									<tr>
										<td  nowrap="nowrap" class="fileLabel">Centro Funcional:&nbsp;</td>
									  <td>
										<INPUT 	TYPE="textbox" 
												NAME="CFcodigo2" 
												VALUE="" 
												SIZE="10" 
												readonly="yes"
												MAXLENGTH="" 
												ONBLUR="" 
												ONFOCUS="this.select(); " 
												ONKEYUP="" 
												tabindex="-1"
												style="border: medium none; text-align:left; size:auto;"
										>
										<input 	type="textbox" 
												name="CFdescripcion2" 
												VALUE="" 
												size="35" 
												readonly="yes"
												maxlength="35" 
												onblur="" 
												onfocus="this.select(); " 
												tabindex="-1"
												onkeyup="" 
												style="border: medium none; text-align:left; size:auto;" />
										<input name="CFid2"  value="" type="hidden">			
											
								
										</td>
									</tr>
									<tr>
										<td class="fileLabel">Fecha:&nbsp;</td>
										<td>
											<cf_sifcalendario name="Fecha" tabindex="8" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">								</td>
								  </tr>
									<tr>
										<td class="fileLabel">&nbsp;</td>
										<td><input tabindex="9" type="checkbox" name="CHK_ACT_CMB" 
											onclick="javascript:ActivaCombo();">
										&nbsp;Cambiar Tipo de Documento
										</td>
									</tr>								  
								  
								  <tr>
									<td class="fileLabel">&nbsp;</td>
									<td>
										<cfquery name="rsCRTD2" datasource="#Session.Dsn#">
										  select CRTDid as value,<cf_dbfunction name="concat" args="rtrim(CRTDcodigo) ,' - ' , rtrim(CRTDdescripcion)"> as description
										  	from CRTipoDocumento
										  where Ecodigo = #Session.Ecodigo# 
										  order by CRTDcodigo,CRTDdescripcion
									  	</cfquery>
										<select name="CRTDid2" id="CRTDid2" tabindex="10">
										  <option value="">--Mantener mismo tipo--</option>
										  <cfloop query="rsCRTD2">
											<option value="#value#">#description#</option>
										  </cfloop>
										</select>
									</td>
								  </tr>
								
								
								</table>	
							</fieldset>
						
					</td>
				</tr>
				<tr>
					<td colspan="2"><cf_botones values="Agregar, Importar" names="btnAgregarMasivo, btnImportar" tabindex="11"></td>
				</tr>				
			</table>
		</form>
	  </td>
	</tr>
  </table>
</cfoutput>
<script language="javascript" type="text/javascript">
	var validarFormulario;
	
	function funcbtnImportar(){
		validarFormulario = false;
	}
	
	function funcbtnAgregarMasivo()
	{
		validarFormulario = true;
	}
	
	function validar() {	
		var errores = "";
	  if (validarFormulario != false)
	   {	
		if (document.form1.Aplacai.value.length == 0 && 
			document.form1.CFid.value.length == 0 && 
			document.form1.DEid.value.length == 0 ) {
			errores = errores + '- Es necesario seleccionar alguno de los filtros del origen .\n';
		}	
			
		if (document.form1.DEid2.value.length == 0) {
			errores = errores + '- El campo del empleado ( Datos Destino ) es requerido.\n';
		}
		
		if (document.form1.Fecha.value.length == 0) {
			errores = errores + '- El campo Fecha ( Datos Destino ) es requerido.\n';
		}

		if (errores != "") {
			alert('Se presentaron los siguientes errores:\n' + errores);
			return false;
		}
	  }	
	}	
	
	
	<!--// cÃ³digo javascript
		//validaciones utilizando API qforms
		/*
		objForm.o.description="o";
		objForm.CRTDid.description="Tipo de Documentos";
		objForm.CRCCid.description="Centro de Custodia Origen";
		objForm.CFid.description="Centro Funcional Origen";
		objForm.DEid.description="Empleado Origen (Alternativamente, puede selccionar un rango de placas)";
		objForm.DEid2.description="Empleado Destino";
		objForm.Fecha.description="Fecha";
		objForm.Aplacai.description="Placa Inicial";
		objForm.Aplacaf.description="Placa Final";
		requeridos = "CRCCid,CRCCid2,CFid2,DEid2,Fecha";
		otrosrequeridos = "";
		*/
		
		function habilitarValidacion(){
			/*
			deshabilitarValidacion();
			objForm.o.required=true;
			objForm.required(requeridos+otrosrequeridos,true);
			*/
		}
		function deshabilitarValidacion(){
			/*
			objForm.o.required=false;
			objForm.required(requeridos+otrosrequeridos,false);
			*/
		}
		function resetCFuncional(){
			/*document.form1.CFid.value=''; document.form1.CFcodigo.value=''; document.form1.CFdescripcion.value='';
			resetEmpleado();*/
		}
		function resetCFuncional2(){
			/*document.form1.CFid2.value=''; document.form1.CFcodigo2.value=''; document.form1.CFdescripcion2.value='';
			resetEmpleado2();*/
		}
		function resetEmpleado(){
			/*
			document.form1.DEid.value=''; document.form1.DEidentificacion.value=''; document.form1.DEnombrecompleto.value='';
			*/
		}
		function resetEmpleado2(){
			/*
			document.form1.DEid2.value=''; document.form1.DEidentificacion2.value=''; document.form1.DEnombrecompleto2.value='';
			*/
		}
		
		document.form1.CRCCid.focus();
		function ActivaCombo(){
			var CRTDid2 = document.getElementById("CRTDid2");
			if (document.form1.CHK_ACT_CMB.checked){
				CRTDid2.style.display = '';
			}
			else{
				CRTDid2.style.display = 'none';
			}
		}
		ActivaCombo();
	//-->
</script>

