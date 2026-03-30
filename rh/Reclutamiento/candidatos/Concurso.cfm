
<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Agregar_a_un_concurso_los_oferentes_seleccionados"
		Default="Agregar a un concurso los oferentes seleccionados"
		returnvariable="Titulo"/>
		<cfoutput>#Titulo#</cfoutput>
</title>
 <cfif isdefined("url.oferentes") and len(trim(url.oferentes)) gt 0 and not isdefined("form.oferentes")  >
	<cfset form.oferentes = url.oferentes>
</cfif>
 
<cfquery name="rsCandidatos" datasource="#session.DSN#">
	select a.RHOnombre,a.RHOapellido1,a.RHOapellido2,b.NTIdescripcion,a.RHOidentificacion
	from DatosOferentes a
	inner join NTipoIdentificacion b
		on a.NTIcodigo = b.NTIcodigo
		and b.Ecodigo = #Session.Ecodigo#
	where  a.RHOid  in(#form.oferentes#)
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by a.RHOnombre,a.RHOapellido1,a.RHOapellido2
</cfquery>	
 <cf_templatecss>
 <cf_web_portlet_start border="true" titulo="#Titulo#" skin="#Session.Preferences.Skin#">
 <cfoutput>
 <form style="margin:0" name="form1" method="post" action="ConcursoSQL.cfm" <!--- onsubmit="return validar(this);" ---> >
	 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td  colspan="2">
				<fieldset><legend><cf_translate key="LB_Candidatos_Seleccionados">Candidatos Seleccionados</cf_translate></legend>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td   colspan="2" bgcolor="##CCCCCC"><strong><cf_translate key="LB_IDentificacion">IDentificaci&oacute;n</cf_translate></strong></td>
						<td  bgcolor="##CCCCCC"><strong><cf_translate key="LB_Nombre">Nombre</cf_translate></strong></td>
					</tr>
					<cfloop query="rsCandidatos">
						<tr>
							<td>#rsCandidatos.NTIdescripcion#</td>
							<td>#rsCandidatos.RHOidentificacion#</td>
							<td>#rsCandidatos.RHOnombre#&nbsp;#rsCandidatos.RHOapellido1#&nbsp;#rsCandidatos.RHOapellido2#</td>
						</tr>
					</cfloop>
				</table>	
				</fieldset>
			</td>
		</tr>		
		<tr>
			<td  colspan="2"><hr></td>
		</tr>		
		<tr>
			<td  valign="middle" width="15%">
				<font  style="font-size:11px"><cf_translate key="LB_Concurso">Concurso</cf_translate></font>
			 </td>
			<td  valign="bottom">
				<select name="Concurso" id="Concurso" style="font-size:11px" tabindex="1" onchange="javascript:pintaconlis();">
					<option value="1" <cfif isdefined("form.Concurso") and form.Concurso EQ 1> selected</cfif>><cf_translate key="CMB_Existente">Existente</cf_translate></option>
					<option value="0" <cfif isdefined("form.Concurso") and form.Concurso EQ 0> selected</cfif>><cf_translate key="CMB_Nuevo">Nuevo</cf_translate></option>

				</select>
			</td>
		</tr>
		<tr id="TDCEXISTE">
			<td></td>
			<td  valign="bottom">
				<cfset ArrayConcurso=ArrayNew(1)>

				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Concurso"
					Default="Concurso"
					returnvariable="LB_Concurso"/>
					
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Codigo"
					Default="C&oacute;digo"
					returnvariable="LB_CodigoConcurso"/>	
				
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Puesto"
					Default="Puesto"
					returnvariable="LB_Puesto"/>	
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Apertura"
					Default="Apertura"
					returnvariable="LB_Apertura"/>	
					
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Cierre"
					Default="Cierre"
					returnvariable="LB_Cierre"/>	
				
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Plazas"
					Default="Plazas"
					returnvariable="LB_Plazas"/>
					
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Plaza"
					Default="Plaza"
					returnvariable="LB_Plaza"/>		
				
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_ListaDeConcursosAbiertos"
					Default="Lista de Concursos Abiertos"
					returnvariable="LB_ListaConcursosAbiertos"/>		

				
				<cf_conlis
				Campos="RHCconcurso,RHCcodigo,RHCdescripcion"
				Desplegables="N,S,S"
				Modificables="N,S,N"
				Size="0,10,50"
				tabindex="1"
				ValuesArray="#ArrayConcurso#" 
				Title="#LB_ListaConcursosAbiertos#"
				Tabla=" RHConcursos a
						inner join RHPuestos b
							on b.RHPcodigo = a.RHPcodigo
							and b.Ecodigo = a.Ecodigo"
				Columnas="	a.RHCconcurso,
							a.RHCcodigo,
							a.RHCdescripcion,
							a.RHPcodigo, 
							b.RHPdescpuesto,
							a.RHCfapertura as fechaapertura,
							a.RHCfcierre as fechacierre,
							a.RHCcantplazas as cantidadplazas"
				Filtro=" a.Ecodigo = #Session.Ecodigo# and a.RHCestado in (10, 15, 40, 50, 60) order by fechacierre desc, fechaapertura"
				Desplegar="RHCcodigo,RHCdescripcion,RHPdescpuesto,fechaapertura,fechacierre,cantidadplazas"
				Etiquetas="#LB_CodigoConcurso#,#LB_Concurso#,#LB_Puesto#,#LB_Apertura#,#LB_Cierre#,#LB_Plazas#"
				filtrar_por="RHCcodigo,RHCdescripcion,RHPdescpuesto,fechaapertura,fechacierre,cantidadplazas"
				Formatos="S,S,S,D,D,S"
				Align="left,left,left,center,center,left"
				Asignar="RHCconcurso,RHCcodigo,RHCdescripcion"
				width  = "1000"
				height = "500"
				left   = "100"
				Asignarformatos="S,S,S"/>
			</td>												
		</tr>
		<tr>
			<td  colspan="2"><hr></td>
		</tr>
		<tr>					

			<td  colspan="2">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" id='TABLACONCURSO' style="display:none;">
					<tr>
						<td  align="right" width="25%" ><font  style="font-size:11px"><cf_translate key="LB_CodigoConcurso">C&oacute;digo del Concurso</cf_translate>:&nbsp;</font></td>
						<td>
						  <input style="font-size:11px" name="RHCcodigoN" type="text" value="" size="10" maxlength="5">
						</td>
					</tr>
					<tr>
						<td  align="right" ><font  style="font-size:11px"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</font></td>
						<td>
						  <input 	name="RHCdescripcionN" 
						  			type="text"  
									value=""  
									style="width: 100%; font-size:11px" maxlength="150" onFocus="this.select();">
						</td>	
					</tr>
					<tr>
						<td align="right"  nowrap><font  style="font-size:11px"><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</font></td>
						<td align="left">
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_SeleccioneElCentroFuncionalResponsable"
								Default="Seleccione el Centro Funcional Responsable"
								returnvariable="LB_SeleccioneElCentroFuncionalResponsable"/>

								<cf_rhcfuncional size="30"  name="CFcodigoresp" desc="CFdescripcionresp" titulo="#LB_SeleccioneElCentroFuncionalResponsable#" excluir="-1" >
						</td>					
					</tr>
					<tr>			
						<td align="right" nowrap><font  style="font-size:11px"><cf_translate key="LB_Puesto" XmlFile="/rh/generales.xml">Puesto</cf_translate>:&nbsp;</font></td>
						<td align="left">
							<cf_rhpuesto name="RHPcodigo">
						</td>
					</tr>
					<tr>
						<td align="right" nowrap><font  style="font-size:11px">&nbsp; &nbsp;<cf_translate key="FechaAperdura">Fecha Apertura</cf_translate>:&nbsp;</font></td>
						<td align="left">
							<cf_sifcalendario name="FechaA" value=""> 
						</td>
					</tr>
					<tr>	
						<td align="right"><font  style="font-size:11px"><cf_translate key="LB_FechaCierre">Fecha Cierre</cf_translate>:</font>&nbsp;</td>
						<td align="left" >
							<cf_sifcalendario name="FechaC" value=""> 
						</td>
					</tr>
					<tr>
						<td align="right" nowrap><font  style="font-size:11px"><cf_translate key="LB_Motivo">Motivo</cf_translate>:&nbsp;</font></td>
						<td align="left">
						  <select name="LAMotivo" id="LAMotivo" style="font-size:11px" >
							<option value="1"><cf_translate key="LB_Despido">Despido</cf_translate></option>
							<option value="2"><cf_translate key="LB_Renuncia">Renuncia</cf_translate></option>
							<option value="3"><cf_translate key="LB_Traslado">Traslado</cf_translate></option>
							<option value="4"><cf_translate key="LB_Temporal">Temporal</cf_translate></option>
							<option value="5"><cf_translate key="LB_Otro">Otro</cf_translate></option>
						  </select>
						</td>					
					</tr>
					<tr>
						<td align="right" nowrap valign="top"><font  style="font-size:11px"><cf_translate key="LB_Justificacion">Justificaci&oacute;n</cf_translate>:</font>&nbsp;</td>
						<td colspan="3">
						  <textarea name="RHCotrosdatos" id="RHCotrosdatos" rows="2" style="width: 100%;font-size:11px"></textarea>
						</td>
					</tr>
					 <tr>
						<td  colspan="2">
							<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" id="tbldynamic">
								<tr align="center" valign="middle">
								  <td>&nbsp;</td>
								  <td>&nbsp;</td>
								  <td>&nbsp;</td>
								  <td>&nbsp;</td>
							  </tr>
								<tr align="center" valign="middle">
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_lista_de_plazas"
									Default="lista de plazas"
									returnvariable="LB_lista_de_plazas"/>
									
									<td><font  style="font-size:11px"><cf_translate key="Plaza">Plaza</cf_translate>&nbsp;:&nbsp;</font></td>
									<td>
									<!--- <cf_dbfunction name="to_date" args="'#LSDateFormat(Now(), 'yyyymmdd')#'" returnvariable="vFECHA"> --->
									<cf_conlis
										Campos="RHPid2,RHPcodigo2,RHPdescripcion2"
										Desplegables="N,S,S"
										Modificables="N,N,S"
										Size="0,10,50"
										tabindex="1"
										Title="#LB_lista_de_plazas#"
										Tabla=" RHPlazas a
												left outer join LineaTiempo b
												on a.RHPid = b.RHPid
													and a.Ecodigo = b.Ecodigo
													and getdate() between b.LTdesde and b.LThasta"
										Columnas="a.RHPid as RHPid2, a.RHPcodigo as RHPcodigo2,a.RHPdescripcion as RHPdescripcion2"
										Filtro=" a.Ecodigo = #Session.Ecodigo# and a.RHPactiva = 1 and a.CFid = $CFid,numeric$ and ltrim(rtrim(a.RHPpuesto)) like  {fn concat('%',{fn concat($RHPcodigo,varchar$,'%')})}"
										Desplegar="RHPcodigo2,RHPdescripcion2"
										Etiquetas="#LB_CodigoConcurso#,#LB_Plaza#"
										filtrar_por="RHCcodigo,RHCdescripcion,RHPdescpuesto,fechaapertura,fechacierre,cantidadplazas"
										Formatos="S,S"
										Align="left,left"
										Asignar="RHPid2,RHPcodigo2,RHPdescripcion2"
										Asignarformatos="s,S,S"/> 
									</td>
									<td>&nbsp;</td>
									<td>
										<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Agregar"
											Default="Agregar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Agregar"/>
			
										<input type="button" name="<cfoutput>#BTN_Agregar#</cfoutput>" align="middle" value="+" 
										onClick="javascript: fnNuevoTR();">
									</td>
							  </tr>
							  <tr><td colspan="4">&nbsp;</td></tr>
							  <tbody>
							  </tbody>
							</table>
						</td>	
					</tr>
					 <tr>
						<td  colspan="2"><hr></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td  colspan="2">
				<cf_botones include = "btnAplicar,btnCerrar" includevalues = "Aplicar,Cerrar" regresarMenu='true' exclude='Alta'>
			</td>
		</tr>
	 </table>
	 <input type="hidden" name="oferentes" id="oferentes" value="#form.oferentes#"  >
	 <input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
	 <input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar Plaza" style="display:none;">
 	 <input type="hidden" name="RHCcantplazas" id="RHCcantplazas" value="0">
 </form>
 </cfoutput>
<cf_web_portlet_end>

<cf_qforms>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EsteValorYaFueAgregado"
	Default="Este valor ya fue agregado."
	returnvariable="MSG_EsteValorYaFueAgregado"/>

<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Se_presentaron_los_siguientes_errores"
		Default="Se presentaron los siguientes errores"
		returnvariable="LB_Se_presentaron_los_siguientes_errores"/>	
		
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_es_requerido"
		Default="es requerido"
		returnvariable="LB_es_requerido"/>		
		
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Codigo"
		Default="Código"
		returnvariable="LB_Codigo"/>
			
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Descripcion"
		Default="Descripción"
		returnvariable="LB_Descripcion2"/>	
			
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CentroFuncional"
		Default="Centro Funcional"
		returnvariable="LB_CentroFuncional"/>	

<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_FechaApertura"
		Default="Fecha Apertura"
		returnvariable="LB_FechaApertura"/>							

<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_FechaCierre"
		Default="Fecha Cierre"
		returnvariable="LB_FechaCierre"/>	

<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_NPlazas"
		Default="N&deg; Plazas"
		returnvariable="LB_NPlazas"/>	

<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Puesto"
		Default="Puesto"
		returnvariable="LB_Puesto"/>			
			
		
<script language="javascript" type="text/javascript">

	objForm.RHCconcurso.description 	= "<cfoutput>#LB_Concurso#</cfoutput>";
	objForm.RHCcodigoN.description      = "<cfoutput>#LB_Codigo#</cfoutput>";
	objForm.RHCdescripcionN.description = "<cfoutput>#LB_Descripcion2#</cfoutput>";
	objForm.CFid.description 			= "<cfoutput>#LB_CentroFuncional#</cfoutput>";
	objForm.RHPcodigo.description   	= "<cfoutput>#LB_Puesto#</cfoutput>";
	objForm.FechaA.description   		= "<cfoutput>#LB_FechaApertura#</cfoutput>";
	objForm.FechaC.description   		= "<cfoutput>#LB_FechaCierre#</cfoutput>";


	function pintaconlis() {
		var TDCEXISTE = document.getElementById("TDCEXISTE");
		var TABLACONCURSO = document.getElementById("TABLACONCURSO");
		if (document.form1.Concurso.value == 1){
			TDCEXISTE.style.display = "";
			TABLACONCURSO.style.display = "none";
			objForm.RHCconcurso.required 		= true;
			objForm.RHCcodigoN.required 		= false;	
			objForm.RHCdescripcionN.required 	= false;
			objForm.CFid.required 				= false;
			objForm.RHPcodigo.required 			= false;		
			objForm.FechaA.required 			= false;		
			objForm.FechaC.required 			= false;			
		}
		else{
			TABLACONCURSO.style.display = "";
			TDCEXISTE.style.display = "none";
			objForm.RHCconcurso.required 		= false;
			objForm.RHCcodigoN.required 		= true;	
			objForm.RHCdescripcionN.required 	= true;
			objForm.CFid.required 				= true;
			objForm.RHPcodigo.required 			= true;		
			objForm.FechaA.required 			= true;		
			objForm.FechaC.required 			= true;						
		}
	}
	function funcbtnCerrar() {
		objForm.RHCconcurso.required 		= false;
		objForm.RHCcodigoN.required 		= false;	
		objForm.RHCdescripcionN.required 	= false;
		objForm.CFid.required 				= false;
		objForm.RHPcodigo.required 			= false;		
		objForm.FechaA.required 			= false;		
		objForm.FechaC.required 			= false;
	}	
	
	pintaconlis();
	
	var GvarNewTD;
	
	//Función para agregar TRs
	function fnNuevoTR()
	{
	
	 
	  var LvarTable = document.getElementById("tbldynamic");
	 var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.form1.LastOne;
	  var p1 		= document.form1.RHPcodigo2.value;//codigo
	  var p2 		= document.form1.RHPdescripcion2.value;//desc
	  var p3		= document.form1.RHCcantplazas.value;//número de plazas
	  var p4		= document.form1.RHPid2.value;
	  // Valida no agregar vacíos
	  if (p1=="") return;
	  
	  // Valida no agregar repetidos
	  
	  if (existeCodigo(p1)) {alert('<cfoutput>#MSG_EsteValorYaFueAgregado#</cfoutput>');return;}

	  // Agrega Columna 1
	  sbAgregaTdInput (LvarTR, Lclass.value, p4,  "hidden", "RHCGidList");

	  // Agrega Columna 2
	  sbAgregaTdText  (LvarTR, Lclass.value, p1 + ' - ' + p2);
	  
	   // Agrega Columna 3
  	  sbAgregaTdInput (LvarTR, Lclass.value, p4, "hidden", "RHPidList");
	  
	  // Agrega Evento de borrado
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel");
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
	
	//Función para eliminar TRs
	function sbEliminarTR(e)
	{
	  var LvarTR;

	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;
	
	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;
		
	  LvarTR.parentNode.removeChild(LvarTR);
	}
	
	//Función para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre)
	{
	  // Copia una imagen existente
	  var LvarTDimg    = document.createElement("TD");
	  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
	  LvarImg.style.display="";
	  LvarTDimg.appendChild(LvarImg);
	  if (LprmClass != "") LvarTDimg.className = LprmClass;
	
	  GvarNewTD = LvarTDimg;
	  LprmTR.appendChild(LvarTDimg);
	}
	
	//Función para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarTxt   = document.createTextNode(LprmValue);
	  LvarTD.appendChild(LvarTxt);
	  if (LprmClass!="") LvarTD.className = LprmClass;
	  GvarNewTD = LvarTD;
	  LprmTR.appendChild(LvarTD);
	}
	
	//Función para agregar TDs con Objetos
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName)
	{
	  var LvarTD    = document.createElement("TD");
	
	  var LvarInp   = document.createElement("INPUT");
	  LvarInp.type = LprmType;
	  if (LprmName!="") LvarInp.name = LprmName;
	  if (LprmValue!="") LvarInp.value = LprmValue;
	  LvarTD.appendChild(LvarInp);
	  if (LprmClass!="") LvarTD.className = LprmClass;
	  GvarNewTD = LvarTD;
	  LprmTR.appendChild(LvarTD);
	}
	
	function existeCodigo(v){
		var LvarTable = document.getElementById("tbldynamic");
		for (var i=0; i<LvarTable.rows.length; i++)
		{
			if (fnTdValue(LvarTable.rows[i])==v){
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
</script>