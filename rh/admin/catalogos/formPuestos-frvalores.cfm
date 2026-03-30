<cfif isdefined("Aprobacion") and len(trim(Aprobacion)) and Aprobacion eq 'A'>
	<!-- Establecimiento del modo -->
	<cfif isdefined("form.Cambio") or isdefined('form.RHPcodigo') and len(trim(form.RHPcodigo)) gt 0>
		<cfset modo="CAMBIO">
	<cfelse>
		<cfif not isdefined("Form.modo")>
			<cfset modo="ALTA">
		<cfelseif form.modo EQ "CAMBIO">
			<cfset modo="CAMBIO">
		<cfelse>
			<cfset modo="ALTA">
		</cfif>
	</cfif>
	
	
	<cfif modo eq 'ALTA'>
			<cf_translate key="MSG_DebeSeleccionarUnPuestoParaVerEstaOpcion">Debe seleccionar un Puesto para ver esta opción</cf_translate>.
		<cfabort>
	</cfif>
	
	<!--- Consultas --->
	
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">

		select a.RHTPid, coalesce(a.RHPcodigoext, a.RHPcodigo) as RHPcodigoext,a.RHPcodigo, a.RHPdescpuesto, 
			a.RHOcodigo, b.RHOdescripcion, 
			a.RHTPid, c.RHTPdescripcion
		from RHPuestos a left outer join RHOcupaciones b
		  on a.RHOcodigo = b.RHOcodigo left outer join RHTPuestos c
		  on a.RHTPid = c.RHTPid
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	</cfquery>
	
	<cfquery name="rsvalores" datasource="#session.dsn#">
		select	b.RHECGid, b.RHECGcodigo, b.RHECGdescripcion, c.RHDCGid, c.RHDCGcodigo, c.RHDCGdescripcion,RHVPtipo
		from 	RHValoresPuesto a, RHECatalogosGenerales b, RHDCatalogosGenerales c, RHPuestos d
		where 	d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		  and 	d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and 	a.RHECGid = b.RHECGid
		  and 	a.RHDCGid = c.RHDCGid
		  and 	b.RHECGid = c.RHECGid
		  and   a.Ecodigo = d.Ecodigo
		  and   a.RHPcodigo = d.RHPcodigo
		order by b.RHECGcodigo, b.RHECGdescripcion, c.RHDCGcodigo, c.RHDCGdescripcion
	</cfquery>
	
	
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_EsteValorYaFueAgregado"
		Default="Este valor ya fue agregado."
		returnvariable="MSG_EsteValorYaFueAgregado"/>
	<!--- Javascript --->
	<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
	<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
	<script language="JavaScript1.2" type="text/javascript">
		<!--//
		
		//**************************************QForms**************************************************
		
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
		
		
		//**********************************Tabla Dinámica**********************************************
		
		var GvarNewTD;
		
		//Función para agregar TRs
		function fnNuevoTR()
		{
		  var LvarTable = document.getElementById("tbldynamic");
		  var LvarTbody = LvarTable.tBodies[0];
		  var LvarTR    = document.createElement("TR");
		  
		  var Lclass 	= document.form1.LastOne;
		  
		  var p1 		= document.form1.RHECGid.value;//id
		  var p2 		= document.form1.RHECGcodigo.value;//cod
		  var p3 		= document.form1.RHECGdescripcion.value;//desc
		  
		  var p1d 		= document.form1.RHDCGid.value;//id
		  var p2d 		= document.form1.RHDCGcodigo.value;//cod
		  var p3d 		= document.form1.RHDCGdescripcion.value;//desc
		  var tipo      = '00';
		  var Etiqueta_Tipo = ''
		  if(document.form1.RHVPtipo.value != ""){
			 tipo      = document.form1.RHVPtipo.value;
			 if(document.form1.RHVPtipo.value == "10"){
				Etiqueta_Tipo = "(Deseable)";			
			 }
			 if (document.form1.RHVPtipo.value == "20"){
				Etiqueta_Tipo = "(Intercambiable)";	
			 }
			 if (document.form1.RHVPtipo.value == "30"){
				Etiqueta_Tipo = "(Requerido)";	
			 }
		
		  }
			
		   
		  // Valida no agregar vacíos
		  if (p1=="" || p1d=="") return;
		  
		  // Valida no agregar repetidos
		  if (existeCodigo(p1+'|'+p1d+'|'+tipo)) {alert('<cfoutput>#MSG_EsteValorYaFueAgregado#</cfoutput>');return;}
		
		  // Agrega Columna 1
		  sbAgregaTdInput (LvarTR, Lclass.value, p1+'|'+p1d+'|'+tipo, "hidden", "RHCGidList");
		
		  // Agrega Columna 2
		  sbAgregaTdText  (LvarTR, Lclass.value, p3 + ' ' + p3d + ' ' + Etiqueta_Tipo );
		
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
				var  valor = fnTdValue(LvarTable.rows[i]);
				if (valor==v){
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
		
		//-->
	</script>
	
	<form name="form1" method="post" action="SQLPuestos-frvalores.cfm">
	<cfoutput>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_EliminarConocimientoRequeridaParaEstePuesto"
			Default="Eliminar conocimiento requerida para este puesto."
			returnvariable="MSG_EliminarConocimientoRequeridaParaEstePuesto"/>
	
	<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="#MSG_EliminarConocimientoRequeridaParaEstePuesto#" style="display:none;">
		<table id="tbldynamic" align="center" width="80%" border="0" cellspacing="0" cellpadding="0">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
				<tr> 
					<td nowrap align="right"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</strong></td>
					<td nowrap>#Trim(rsForm.RHPcodigoext)#</td>
				</tr>
				<tr>
					<td nowrap align="right"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</strong></td>
					<td nowrap>#rsForm.RHPdescpuesto# </td>
				</tr>
				<tr>
					<td nowrap align="right"><strong>
					<cf_translate key="LB_Tipo">Tipo</cf_translate>
					:&nbsp;</strong></td>
					<td nowrap valign="middle">
						<table width="0%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>
								<select name="RHVPtipo" tabindex="1">
									<option value="" selected><cf_translate key="CMB_Niguno">Niguno</cf_translate></option>
									<option value="10"><cf_translate key="CMB_Deseable">Deseable</cf_translate></option>
									<option value="20"><cf_translate key="CMB_Intercambiable">Intercambiable</cf_translate></option>
									<option value="30"><cf_translate key="CMB_Requerido">Requerido</cf_translate></option>
								</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>		
				<tr>
					<td nowrap align="right"><strong><cf_translate key="LB_Encabezado">Encabezado</cf_translate>:&nbsp;</strong></td>
					<td nowrap valign="middle"><cf_rhvalores encabezado="true" tabindex="1"></td>
				</tr>
				<tr>
					<td nowrap align="right"><strong><cf_translate key="LB_Detalle">Detalle</cf_translate>:&nbsp;</strong></td>
					<td nowrap valign="middle">
						<table width="0%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td><cf_rhvalores encabezado="false" tabindex="1"></td>
								<td>&nbsp;<input type="button" name="Agregar" value="+" onClick="javascript: habilitarValidacion(); if (objForm.validate()) fnNuevoTR();"></td>
							</tr>
						</table>
					</td>
				</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td nowrap colspan="2" align="center">
					<table width="0%" align="center"  border="0" cellspacing="0" cellpadding="0" class="ayuda">
						<tr><td colspan="5">&nbsp;&nbsp;</td></tr>
						<tr>
							<td>&nbsp;&nbsp;</td>
							<td>
								<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Actualizar"
									Default="Actualizar"
									XmlFile="/rh/generales.xml"
									returnvariable="BTN_Actualizar"/>
								<input type="submit" name="Cambio" value="#BTN_Actualizar#" onClick="javascript: deshabilitarValidacion(); "></td>
							<td>&nbsp;&nbsp;</td>
							<td><cf_translate key="MSG_PresioneEsteBotonParaActualizarLaInformacionModificada">Presione este bot&oacute;n para actualizar <br>la informaci&oacute;n modificada</cf_translate>.</td>
							<td>&nbsp;&nbsp;</td>
						</tr>
						<tr><td colspan="5">&nbsp;&nbsp;</td></tr>
					</table>
				</td>
			</tr>
			<tr>
				<td nowrap colspan="2">
					<input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
					<input type="hidden" name="RHPcodigo" id="RHPcodigo" value="#Trim(rsForm.RHPcodigo)#">
				</td>
			</tr>
		</table>
	</cfoutput>
	</form>
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Encabezado"
		Default="Encabezado"
		XmlFile="/rh/generales.xml"
		returnvariable="MSG_Encabezado"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Detalle"
		Default="Detalle"
		XmlFile="/rh/generales.xml"
		returnvariable="MSG_Detalle"/>
	
	<script language="JavaScript1.2" type="text/javascript">
	
		<!--//
	
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
		<cfoutput>
		objForm.RHECGid.required = true;
		objForm.RHECGid.description = "#MSG_Encabezado#";
		objForm.RHDCGid.required = true;
		objForm.RHDCGid.description = "#MSG_Detalle#";
	</cfoutput>
		
		function deshabilitarValidacion(){
			objForm.RHECGid.required = false;
			objForm.RHDCGid.required = false;
		}
		function habilitarValidacion(){
			objForm.RHECGid.required = true;
			objForm.RHDCGid.required = true;
		}
		
		<cfoutput query="rsvalores">
			objForm.RHECGid.obj.value = "#RHECGid#";
			objForm.RHECGcodigo.obj.value = "#RHECGcodigo#";
			objForm.RHECGdescripcion.obj.value = "#RHECGdescripcion#";
			objForm.RHDCGid.obj.value = "#RHDCGid#";
			objForm.RHDCGcodigo.obj.value = "#RHDCGcodigo#";
			objForm.RHDCGdescripcion.obj.value = "#RHDCGdescripcion#";
			objForm.RHVPtipo.obj.value = "#RHVPtipo#";
			fnNuevoTR();
		</cfoutput>
	
		objForm.RHECGid.obj.value = "";
		objForm.RHECGcodigo.obj.value = "";
		objForm.RHECGdescripcion.obj.value = "";
		objForm.RHDCGid.obj.value = "";
		objForm.RHDCGcodigo.obj.value = "";
		objForm.RHDCGdescripcion.obj.value = "";
		
		objForm.RHECGcodigo.obj.focus();
	
		//-->
		
	</script>
<cfelse>

	<cfquery name="rsvalores" datasource="#session.dsn#">
		select	
			{fn concat(b.RHECGdescripcion,{fn concat(' ',c.RHDCGdescripcion)})} as valores
		from 	RHValoresPuesto a, RHECatalogosGenerales b, RHDCatalogosGenerales c, RHPuestos d
		where 	d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		  and 	d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and 	a.RHECGid = b.RHECGid
		  and 	a.RHDCGid = c.RHDCGid
		  and 	b.RHECGid = c.RHECGid
		  and   a.Ecodigo = d.Ecodigo
		  and   a.RHPcodigo = d.RHPcodigo
		order by b.RHECGcodigo, b.RHECGdescripcion, c.RHDCGcodigo, c.RHDCGdescripcion
	</cfquery>
	<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_CatalogosGenerales"
				Default="Catalogos Generales"
				returnvariable="LB_CatalogosGenerales"/>
	<table width="100%" border="0">
		<tr>
			<td>
				<cfinvoke
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet"> 
					<cfinvokeargument name="query" value="#rsvalores#"/> 
					<cfinvokeargument name="desplegar" value="valores"/> 
					<cfinvokeargument name="etiquetas" value="#LB_CatalogosGenerales#"/> 
					<cfinvokeargument name="formatos" value="S"/> 
					<cfinvokeargument name="align" value="left"/> 
					<cfinvokeargument name="keys" value="valores"/> 
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
				</cfinvoke> 
			</td>
		</tr>
		<tr>
			<td class="ayuda"><cf_translate key="MSG_ParaPoderAgregarOModificarvaloresDebeDeRealizarloDesdeElPerfilIdealDelPuesto">Para poder agregar o modificar valores debe de realizarlo desde el perfil ideal del puesto</cf_translate>.</td>
		</tr>		
	</table>
</cfif>	
