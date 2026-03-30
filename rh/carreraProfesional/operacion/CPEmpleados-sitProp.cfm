<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>

<!--- CONCEPTOS DE PAGO REGISTRADOS --->
<cfquery name="rsSitActual" datasource="#session.DSN#">
	select 	b.CCPid, CCPcodigo, CCPdescripcion,
			CCPvalor,
			UECPdescripcion
			,TCCPdesc
			,c.CCPequivalenciapunto as puntos
			,(coalesce(c.CCPmaxpuntos,0)-coalesce(b.LTvalor,0)) as faltante			
	from RHAccionesCarreraP a
	inner join LineaTiempoCP b
		on b.DEid = a.DEid
	inner join ConceptosCarreraP c
		on c.CCPid = b.CCPid
	inner join UnidadEquivalenciaCP d
		on d.UECPid = c.UECPid
	inner join TipoConceptoCP e
		on e.TCCPid = c.TCCPid
	where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
	order by TCCPdesc
</cfquery>
<!--- CONCEPTOS DE PAGO DE LA ACCION --->
<cfquery name="rsConceptoPA" datasource="#session.DsN#">
	select b.CCPid,b.CIid, rtrim(CCPcodigo) as CCPcodigo, rtrim(CCPdescripcion) as CCPdescripcion,
			valor as CCPvalor,
			UECPdescripcion,TCCPdesc
			,coalesce(a.Mcodigo,-1) as Mcodigo
			,coalesce(f.Msiglas,'') as Msiglas
			,coalesce(f.Mnombre,'') as Mnombre
			,coalesce(b.CCPmaxpuntos,0) as maximo
	from DRHAccionesCarreraP a
		inner join ConceptosCarreraP b
			on b.CCPid = a.CCPid
		inner join UnidadEquivalenciaCP c
			on c.UECPid = b.UECPid
		inner join TipoConceptoCP e
			on e.TCCPid = b.TCCPid
		left outer join RHMateria f
			on a.Mcodigo = f.Mcodigo
	where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
	order by TCCPdesc
</cfquery>
<cfquery name="rsUnidadEq" datasource="#session.DSN#">
	select UECPid,UECPdescripcion
	from UnidadEquivalenciaCP 
	order by UECPid
</cfquery>
<cfquery name="rsMaterias" datasource="#session.DSN#">
	select Mcodigo,Msiglas,Mnombre
	from RHMateria
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

	<table width="100%" border="0" cellspacing="0" cellpadding="3" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">		
		<tr><td class="<cfoutput>#Session.Preferences.Skin#</cfoutput>_thcenter" colspan="5"><div align="center"><cf_translate key="LB_Situacion_Propuesta">Situaci&oacute;n Propuesta</cf_translate></div></td></tr>
		<cfoutput>
		<tr class="listTitle">
			<td>#LB_Codigo#</td>
			<td>#LB_Descripcion#</td>
			<td >#LB_Valor#</td>
			<td>#LB_Puntos#</td>
			<td>#LB_Faltante#</td>
		</tr>
		</cfoutput>
		<cfif isdefined('rsSitActual') and rsSitActual.RecordCount>
			<cfoutput query="rsSitActual" group="TCCPdesc">
				<tr><td headers="20" colspan="5" class="corteLista">#TCCPdesc#</td></tr>
				<cfoutput>
					<tr height="20">
						<td nowrap="nowrap">&nbsp;#CCPcodigo#</td>
						<td nowrap="nowrap">&nbsp;#CCPdescripcion#</td>
						<td>&nbsp;&nbsp;#LSNumberFormat(CCPvalor,'9.99')#&nbsp;#UECPdescripcion#</td>
						<td>#LSNumberFormat(puntos,'9.99')#</td>
						<td>#faltante#</td>
					</tr>
				</cfoutput>
			</cfoutput>
		</cfif>
		<tr>
			<td colspan="5" width="100%">
				<table id="tblConcepto" width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="7">
							<table border="0" width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td align="right" nowrap="nowrap"> <strong><cf_translate key="LB_ConceptoDePago">Concepto de Pago</cf_translate>:</strong>&nbsp;</td>
									<td colspan="3">
										<cf_conlis
											campos="CCPid,CIid,CCPcodigo,CCPdescripcion,CCPvalor,UECPdescripcion,TCCPdesc,TCCPid,CCPmaxpuntos"
											desplegables="N,N,S,S,N,N,N,N,N"
											modificables="N,N,S,N,N,N,N,N,N"
											size="0,0,10,25,0,0,0,10,0"
											title="#LB_ListaDeConceptosDeCarreraProfesional#"
											tabla="ConceptosCarreraP a
													inner join UnidadEquivalenciaCP b
														on b.UECPid = a.UECPid
													inner join TipoConceptoCP d
														on d.TCCPid = a.TCCPid"
											columnas="CCPid,CIid,CCPcodigo,CCPdescripcion,CCPvalor,UECPdescripcion,TCCPdesc,a.TCCPid,CCPmaxpuntos"
											filtro="Ecodigo = #SESSION.ECODIGO# 
													and (CCPpuestosEspecificos = 1 
													and exists(select 1 
															from PuestosxConceptoCP p 
															where p.CCPid = a.CCPid 
															  and p.RHPcodigo = '#rsDatos.RHPcodigo#') 
													 or CCPpuestosEspecificos = 0)
													order by TCCPdesc,CCPcodigo"
											desplegar="CCPcodigo,CCPdescripcion,CCPvalor,UECPdescripcion"
											filtrar_por="CCPcodigo, CCPdescripcion,CCPvalor,UECPdescripcion"
											Cortes = "TCCPdesc"
											etiquetas="#LB_Codigo#, #LB_Descripcion#, #LB_Valor#, #LB_Unidad#"
											formatos="S,S,M,S"								
											align="left,left,right"
											asignar="CCPid,CIid, CCPcodigo, CCPdescripcion,CCPvalor,UECPdescripcion,TCCPdesc,TCCPid,CCPmaxpuntos"
											asignarformatos="S, S, S,S,M,S"
											showEmptyListMsg="true"
											EmptyListMsg="-- #MSG_NoSeEncontraronRegistros# --"
											tabindex="1"
											Funcion="funcMuestraMaterias">
									</td>
									<td align="right" rowspan="2" valign="middle">
										<input type="hidden" name="LastOneConcepto" id="LastOneConcepto" value="ListaNon" tabindex="3">
										&nbsp;<input type="button" name="agregarConcepto" onclick="javascript:if (window.fnNuevoConcepto) fnNuevoConcepto();" value="+" tabindex="1">
									</td>									
								</tr>
								<tr>
									<td id="cursolabel" style="display:none;" align="right" nowrap="nowrap"> <strong><cf_translate key="LB_Curso">Curso</cf_translate>:</strong>&nbsp;</td>
									<td id="cursoconlis" style="display:none;">
										<cf_conlis
											campos="Mcodigo,Msiglas,Mnombre"
											desplegables="N,S,S"
											modificables="N,S,N"
											size="0,10,25"
											title="#LB_ListaDeCursos#"
											tabla="RHMateria"
											columnas="Mcodigo,Msiglas,Mnombre"
											filtro="Ecodigo = #SESSION.ECODIGO#"
											desplegar="Msiglas,Mnombre"
											filtrar_por="Msiglas,Mnombre"											
											etiquetas="#LB_Siglas#, #LB_Curso#"
											formatos="S,S"								
											align="left,left"
											asignar="Mcodigo,Msiglas,Mnombre"
											asignarformatos="S,S,S"
											showEmptyListMsg="true"
											EmptyListMsg="-- #MSG_NoSeEncontraronRegistros# --"
											tabindex="1">						
									</td>									
								</tr>
								<tr><td>&nbsp;</td></tr>								
							</table>
						</td>
					</tr>					
					<tr class="tituloListas">
						<td>&nbsp;</td><!----Llaves--->
						<td colspan="2"><strong><cf_translate key="LB_ConceptoDePago">Concepto de Pago</cf_translate></strong></td><!----Codigo/Descripcion Concepto pago---->
						<cfoutput>
							<td><strong>#LB_Valor#</strong></td><!---Valor digitable--->
							<td>&nbsp;</td>						<!----Unidad---->
							<td>&nbsp;</td>						<!----Mcodigo---->
							<td><strong>#LB_Curso#</strong></td><!---Curso--->
							<td>&nbsp;</td>	
						</cfoutput>
					</tr>					
					<tr id="sindatoslabel" <cfif rsConceptoPA.RecordCount NEQ 0>style="display:none;"</cfif>>
						<td colspan="7" align="center">---<cf_translate key="LB_NoSeHanAgregadoConceptosDePagoALaAccion">No se han agregado conceptos de pago a la acci&oacute;n</cf_translate>---</td>
					</tr>					
					<tbody>
					</tbody>
				</table>
			</td>
		</tr>
		<tr><td colspan="3">&nbsp;</td></tr>
	</table>
	<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" size="25" title="Eliminar" style="display:none;">

<script language="javascript1.2" type="text/javascript">
 	function funcMuestraMaterias(){
		if (document.form1. TCCPid.value=='20'){
			document.getElementById('cursolabel').style.display = '';
			document.getElementById('cursoconlis').style.display = '';
		}
		else{
			document.getElementById('cursolabel').style.display = 'none';
			document.getElementById('cursoconlis').style.display = 'none';
		}
	}
	
	<!--//
	<cfif isdefined("rsConceptoPA") and rsConceptoPA.recordcount gt 0 >
		<cfloop query="rsConceptoPA">
			fnLConcepto('<cfoutput>#rsConceptoPA.CCPid#</cfoutput>','<cfoutput>#rsConceptoPA.CIid#</cfoutput>','<cfoutput>#rsConceptoPA.CCPcodigo#</cfoutput>','<cfoutput>#rsConceptoPA.CCPdescripcion#</cfoutput>','<cfoutput>#rsConceptoPA.CCPvalor#</cfoutput>','<cfoutput>#rsConceptoPA.UECPdescripcion#</cfoutput>','<cfoutput>#rsConceptoPA.Mcodigo#</cfoutput>','<cfoutput>#rsConceptoPA.Msiglas#</cfoutput>','<cfoutput>#rsConceptoPA.Mnombre#</cfoutput>','<cfoutput>#rsConceptoPA.maximo#</cfoutput>');
		</cfloop>
	</cfif>	

	var vnContadorListas = 0;
	
	var cont = 0;
	
	<cfif isdefined("rsConceptoPA") and rsConceptoPA.recordcount gt 0 >
		<cfoutput>cont = '#rsConceptoPA.recordcount#';</cfoutput>
	</cfif>	

	//**********************************Tabla Dinámica**********************************************
	function fnLConcepto(p1,p2,p3,p4,p5,p6,p7,p8,p9,mp)
	{
	  var LvarTable = document.getElementById("tblConcepto");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneConcepto;

	  // Valida no agregar vacíos
	  if (p1=="" && p2=="" && p3=="") return;
	  
	  // Valida no agregar repetidos
	  if (existeCodigoConcepto(p1)) {alert('<cfoutput>#MSG_EsteConceptoYaFueAgregado#</cfoutput>');return;}
    
  	  p4 = p4.substring(0,15); //Corta el texto del concepto de pago a 15 caracteres
	  p9 = p9.substring(0,10); //Corta el texto de la materia a 10 caracteres

	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1+'|'+p5+'|'+p7, "hidden", "ConceptoidList",'','');
	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value,  p3, "left");
	  // Agrega Columna 2
	  sbAgregaTdText  (LvarTR, Lclass.value,  p4, "left");
	  // Agrega Columna 3
	  sbAgregaTdInput (LvarTR, Lclass.value,  p5, "", "valores",mp,"60px");
  	  // Agrega Columna 4
	  sbAgregaTdText  (LvarTR, Lclass.value,  p6, "left");
  	 //Agrega columna 5 Mcodigo (input hidden)
	  sbAgregaTdInput  (LvarTR, Lclass.value, p7,"hidden","left",'',"60px");
	  // Agrega Columna 6 (Materia)
	  sbAgregaTdText  (LvarTR, Lclass.value,  p8+' '+p9, "left");

	  // Agrega Columna 1
	 // sbAgregaTdText  (LvarTR, Lclass.value,  p3 + ' - ' + p4 + ' ' + p5, "left");
	  	
	  // Agrega Evento de borrado en Columna 2
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}

	var GvarNewTD;
	function fnNuevoConcepto()
	{	

	  if (document.form1.CCPcodigo.value != '' && document.form1.CCPdescripcion.value != ''){
	  	vnContadorListas = vnContadorListas + 1;
	  }

	  var LvarTable = document.getElementById("tblConcepto");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOneConcepto;
	  var p1 		= document.form1.CCPid.value.toString();//id
	  var p2 		= document.form1.CIid.value.toString();//id
	  var p3		= document.form1.CCPcodigo.value.toString();//cod
	  var p4 		= document.form1.CCPdescripcion.value;//desc
	  var p5 		= document.form1.CCPvalor.value.toString();//valor
	  var p6 		= document.form1.UECPdescripcion.value.toString();//desc UE
	  
  	  var p7 		= document.form1.Mcodigo.value.toString();//Id Materia
	  var p8 		= document.form1.Msiglas.value.toString();//Sigla
	  var p9 		= document.form1.Mnombre.value.toString();//nombre

	  p4 = p4.substring(0,15); //Corta el texto del concepto de pago a 15 caracteres
	  p9 = p9.substring(0,10); //Corta el texto de la materia a 10 caracteres
	  
	  document.form1.CCPid.value="";
	  document.form1.CIid.value="";
	  document.form1.CCPcodigo.value="";
	  document.form1.CCPdescripcion.value="";
	  document.form1.CCPvalor.value="";
	  document.form1.UECPdescripcion.value="";

	  document.form1.Mcodigo.value="";
	  document.form1.Msiglas.value="";
	  document.form1.Mnombre.value="";

	  // Valida no agregar vacíos
	  if (p1=="" && p2=="" && p3=="") return;
	  
	  if(p7==""){
	  	p7 = '-1';
	  }
	  	  
	  // Valida no agregar repetidos
	  if (existeCodigoConcepto(p1)) {alert('<cfoutput>#MSG_EsteConceptoYaFueAgregado#</cfoutput>');return;}

	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1+'|'+p5+'|'+p7, "hidden", "ConceptoidList",'','');  	  
	  // Agrega Columna 1 - Codigo del concepto
	  sbAgregaTdText  (LvarTR, Lclass.value,  p3, "left");
	  // Agrega Columna 2 - Descripcion del concepto
	  sbAgregaTdText  (LvarTR, Lclass.value,  p4,"left");
	  // Agrega Columna 3 - cantidad
	  sbAgregaTdInput (LvarTR, Lclass.value,  p5, "", "valores",document.form1.CCPmaxpuntos.value,"60px");
	  //sbAgregaTdText  (LvarTR, Lclass.value,  p5,"left");
	  //Agrega columna 4 - (Unidad de ekivalencia)	
	  sbAgregaTdText  (LvarTR, Lclass.value,  p6,"left");
	  //Agrega columna 5 Mcodigo (input hidden)
	  sbAgregaTdInput  (LvarTR, Lclass.value, p7,"hidden","left",'',"60px");
	  //Agrega columna 6 - (Materia)	
	  sbAgregaTdText  (LvarTR, Lclass.value, p8+' '+p9,"left");
	  	
	  // Agrega Evento de borrado en Columna 2
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
		
		cont++;
		
		document.getElementById('cursolabel').style.display = 'none';
		document.getElementById('cursoconlis').style.display = 'none';
		
		if (cont > 0){
			document.getElementById('sindatoslabel').style.display = 'none';
		}
	}

	//Función para eliminar TRs
	function sbEliminarTR(e)
	{
	  vnContadorListas = vnContadorListas - 1;
	  
	  var LvarTR;
	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;
	
	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;
		
	  LvarTR.parentNode.removeChild(LvarTR);

	  cont--;
	  if (cont == 0){
		document.getElementById('sindatoslabel').style.display = '';
	  }
	}
	
	//Función para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align)
	{
	  // Copia una imagen existente
	  var LvarTDimg    = document.createElement("TD");
	  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
	  LvarImg.style.display="";
	  LvarImg.align=align;
	  LvarTDimg.appendChild(LvarImg);
	  if (LprmClass != "") LvarTDimg.className = LprmClass;
	
	  GvarNewTD = LvarTDimg;
	  LprmTR.appendChild(LvarTDimg);
	}
	
	//Función para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue, align)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarTxt   = document.createTextNode(LprmValue);
	  LvarTD.appendChild(LvarTxt);
	  if (LprmClass!="") LvarTD.className = LprmClass;

	  GvarNewTD = LvarTD;

	  LvarTD.noWrap = true;
	  LvarTD.align = align;
	  LvarTD.title = LprmValue;
	  LprmTR.appendChild(LvarTD);
	}

	function funcValidaMax(prn_input,prn_max){
		//alert('Digitado:'+prn_input.value+' Maximo:'+prn_max);
		if(parseFloat(prn_input.value) > parseFloat(prn_max)){
			<cfoutput>alert('#MSG_MaximoValor#'+parseFloat(prn_max));</cfoutput>
			prn_input.value = 0;
		}	
	}	
	//Función para agregar TDs con Objetos
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName, LprValor,LprmSize)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarInp   = document.createElement("INPUT");
	  LvarInp.type = LprmType;
	  if (LprmName!="") LvarInp.name = LprmName;
	  if (LprmValue!="") LvarInp.value = LprmValue;
	  if (LprmName!="") LvarInp.id = LprmName;
	  if (LprmSize!="") LvarInp.style.width = LprmSize;	  
	  LvarTD.appendChild(LvarInp);
	  
		if(LprmName=='valores'){
		  LvarInp.onblur=function(){funcValidaMax(this,LprValor);};
		}  

	  if (LprmClass!="") LvarTD.className = LprmClass;
	  GvarNewTD = LvarTD;
	  LprmTR.appendChild(LvarTD);
	}
	
	function existeCodigoConcepto(v){
		var LvarTable = document.getElementById("tblConcepto");
		for (var i=0; i<LvarTable.rows.length; i++)
		{

			var value = new String(fnTdValue(LvarTable.rows[i]));
			var data = value.split('|');
			if (data[0] == v){
				return true;
			}
		}
		return false;
	}

	function fnTdValue(LprmNode)
	{
	  var LvarNode = LprmNode;
	
	  while (LvarNode.hasChildNodes())
	  {
		LvarNode = LvarNode.firstChild;
		if (document.all == null)
		{
		  if (!LvarNode.firstChild && LvarNode.nextSibling != null &&
			LvarNode.nextSibling.hasChildNodes())
			LvarNode = LvarNode.nextSibling;
		}
	  }
	  if (LvarNode.value)
		return LvarNode.value;
	  else
		return LvarNode.nodeValue;
	}
	
	function funcValidar(){
		//Hay N elementos (conceptos de pago) dinamicos
		if ( cont > 1 ){
			if(document.form1.valores.length ){
				for(i=0;i<=document.form1.valores.length-1;i++){
					if(document.form1.valores[i].value==''){
						document.form1.valores[i].value = '0.00';
					}	
				}
			}
		}
		//Hay un solo elemento (concepto de pago) dinamico
		else{
			if(cont == 1){
				if(document.form1.valores.value==''){
					document.form1.valores.value = '0.00';
				}
			}
		}		
		return true;
	}	
</script>
