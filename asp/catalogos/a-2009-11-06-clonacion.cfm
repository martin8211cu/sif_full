<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_ClonacionEmpesas"
Default="Clonaci&oacute;n de Empresas"
XmlFile="clonacion/rh/Etiquetas.xml"
returnvariable="LB_ClonacionEmpesas"/>

<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_EsteEmpleadoYaFueAgregado"
		Default="Este Empleado Ya Fue Agregado"
		XmlFile="/rh/generales.xml"
		returnvariable="MSG_EsteEmpleadoYaFueAgregado"/>

<cfoutput>
	<script>
	
	function errorHandler(code, msg)
	{
		<cfoutput>
		htmlAdjunto = "<div class='error'><img src='' border=0> "+msg+"</div>";
		</cfoutput>
		document.getElementById("divMensajesX").innerHTML = htmlAdjunto;	
	}
	
	function myerror(code, msg)
	{<!---alert(msg)
		<cfoutput>
		htmlAdjunto = "<div class='error'><img src='' border=0> "+msg+"</div>";
		</cfoutput>
		document.getElementById("divMensajesX").innerHTML = htmlAdjunto;--->	
	}
	
	
	function mostrarTD(c){
		
			var TD_EcodigoO	 = document.getElementById("tdEcodigoO");
			var TD_EcodigoD	 = document.getElementById("tdEcodigoD");
			var TD_Ayuda	 = document.getElementById("tdAyuda");
			var TD_Cuenta	 = document.getElementById("tdCuenta");
			var TD_Empresa	 = document.getElementById("tdEmpresa");
			var chk	 		= document.getElementById("chkSQL");
			
			
			if (c.checked==true){
				TD_EcodigoO.style.display = "none";
				TD_Cuenta.style.display   = "none";
				TD_Empresa.style.display  = "none";
				TD_EcodigoD.style.display = "";
				TD_Ayuda.style.display = "";
				chk.value = '1';
			}
			else{
				TD_EcodigoO.style.display = "";
				TD_Cuenta.style.display   = "";
				TD_Empresa.style.display  = "";
				TD_EcodigoD.style.display = "none";
				TD_Ayuda.style.display = "none";
				chk.value = ''
			}
			//alert(chk.value)
		}
		
		
		var vnContadorListas = 0;
	
			function showConlis(tr,chk){
				if(chk){
					tr.style.display = "";
				}else{
					tr.style.display = "none";
				}
			}
			
			function Marcar(c) {
				if (c.checked) {
						for (counter = 0; counter < document.form1.Clonar.length; counter++)
						{
							if ((!document.form1.Clonar[counter].checked) && (!document.form1.Clonar[counter].disabled))
								{  document.form1.Clonar[counter].checked = true;}
						}
						if ((counter==0)  && (!document.form1.Clonar.disabled)) {
							document.form1.Clonar.checked = true;
						}
					}
					else {
						for (var counter = 0; counter < document.form1.Clonar.length; counter++)
						{
							if ((document.form1.Clonar[counter].checked) && (!document.form1.Clonar[counter].disabled))
								{  document.form1.Clonar[counter].checked = false;}
						};
						if ((counter==0) && (!document.form1.Clonar.disabled)) {
							document.form1.Clonar.checked = false;
						}
					};
				}
				
				
		function fnNuevoEmpleado()
		{		
		  if (document.form1.DEid.value != '' && document.form1.DEidentificacion.value != ''){
			vnContadorListas = vnContadorListas + 1;
		  }
		  
		  var LvarTable = document.getElementById("tblempleado");
		  var LvarTbody = LvarTable.tBodies[0];
		  var LvarTR    = document.createElement("TR");
		  
		  var Lclass 	= document.form1.LastOneEmpleado;
		  var p1 		= document.form1.DEid.value.toString();//cod
		  var p2 		= document.form1.NombreEmp.value;//desc
		
		  document.form1.DEid.value="";
		  document.form1.DEidentificacion.value="";
		  document.form1.NombreEmp.value="";
	
		  // Valida no agregar vacíos
		  if (p1=="") return;
		  
		  // Valida no agregar repetidos
		  if (existeEmpleado(p1)) {alert('<cfoutput>#MSG_EsteEmpleadoYaFueAgregado#</cfoutput>.');return;}
		  
		  // Agrega Columna 0
		  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "EmpleadoidList");
	
		  // Agrega Columna 1
		  sbAgregaTdText  (LvarTR, Lclass.value, p2);
			
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
		}
				
		function existeEmpleado(v){
			var LvarTable = document.getElementById("tblempleado");
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
		function sbAgregaTdText (LprmTR, LprmClass, LprmValue)
		{
		  var LvarTD    = document.createElement("TD");
		
		  var LvarTxt   = document.createTextNode(LprmValue);
		  LvarTD.appendChild(LvarTxt);
		  if (LprmClass!="") LvarTD.className = LprmClass;
	
		  GvarNewTD = LvarTD;
	
		  LvarTD.noWrap = true;
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

	</script>
</cfoutput>

<cf_templateheader title="#LB_ClonacionEmpesas#">	
	<table width="100%" cellpadding="0" cellspacing="0" border="1">
	<tr><td>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=#LB_ClonacionEmpesas#>
			<cfinclude template="/home/menu/navegacion.cfm">
			<cfset listadatasourse = "">
			<cfset factory = CreateObject("java", "coldfusion.server.ServiceFactory")>
			<cfset ds_service = factory.datasourceservice>
			<cfset datasources = ds_service.getDatasources()>
			
			<cfloop collection="#datasources#" item="i">
				<cftry>
					<cfset thisdatasource = datasources[i]>
					<cfset listadatasourse = listadatasourse & thisdatasource.name  & ",">
				<cfcatch type="any"></cfcatch>
				</cftry>
			</cfloop>
		
			<cfset listadatasourse = listadatasourse & "x">
			<cfset arreglo = listtoarray(listadatasourse,",")>
			
			<!---<cfset listadatasourse = "">
			<cfset dsinfo = StructNew()>
			<cfset factory = CreateObject("java", "coldfusion.server.ServiceFactory")>
			<cfset ds_service = factory.datasourceservice>
			<cfset datasources = ds_service.getDatasources()>
			
			<cfloop collection="#datasources#" item="i">
				<cftry>
					<cfset thisdatasource = datasources[i]>
					<cfif IsDefined('thisdatasource.class')>
						<cfset dsinfoitem = StructNew()>
						<cfset dsinfoitem.name        = thisdatasource.name>
						<cfset dsinfoitem.driverClass = thisdatasource.class>
						<cfset dsinfoitem.driverName  = thisdatasource.driver>
						<cfset dsinfoitem.url         = thisdatasource.url>
						<cfset dsinfoitem.type        =  LCase(thisdatasource.driver)>
						<cfset dsinfo[datasources[i].name] = dsinfoitem>
						<cfset listadatasourse = listadatasourse & thisdatasource.name  & ",">
							
					</cfif>
					<cfcatch type="any"></cfcatch>
				</cftry>
			</cfloop>
			
			<cfset Application.dsinfo = dsinfo>
			<cfset listadatasourse = listadatasourse & "x">
			<cfset arreglo = listtoarray(listadatasourse,",")>	
			--->
			<cfquery name="rsSSO" datasource="asp">
				select SScodigo, SSdescripcion
					from SSistemas
				order by SScodigo
			</cfquery>
			
		<cfif not (IsDefined("form.CDPid") and Len(Trim(form.CDPid))
		and IsDefined("form.btnReporte") and Len(Trim(form.btnReporte)))>

		<script language="JavaScript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
		

		<cfajaxproxy cfc="clonacion"/>
		<cfajaximport tags="cfform"/>
		<div id="divMensajesX"></div>
				
		<cfform name="formfiltrosup" 	method="post" action="" style="margin:0">
				
			<table width="100%" align="center" style="margin:0" border ="0"	cellspacing="0"	cellpadding="0"	class="tituloListas" cols="4">
				<tr><tr><td class="etiqueta" nowrap>

					Sistema&nbsp;:&nbsp;<cfselect name="SScodigoO" value="SScodigo" display="SSdescripcion" bind="cfc:clonacion.getSSO()"  bindonload="true" onError="errorHandler"/>
				</td></tr>
				<tr><td>
					<cfif isdefined("form.chkSQL")>
						<cfinput  name="chkSQL" value="1" checked="checked" type="checkbox" onClick="javascript:mostrarTD(this);">Generar SCRIPT-SQL
					<cfelse>
						<cfinput  name="chkSQL" value="1" type="checkbox" onClick="javascript:mostrarTD(this);">Generar SCRIPT-SQL
					</cfif>
				</td></tr>
				<tr>
				
				<td width="100%" align="left">
				<table align="center" style="margin:0" border ="0" cellspacing="0" cellpadding="0" class="tituloListas" >
					<tr><td nowrap="nowrap"></td> 
						<td class="etiqueta" nowrap align="left">
							Empresa Origen						</td>
						 <td class="etiqueta" nowrap align="left">
							Empresa Destino						</td>
					</tr>
					<tr>
						<td width="1%" class="etiqueta" nowrap>
							DataSource&nbsp;:&nbsp;	</td>
						<td width="1%">
							<cfselect name="DSNO">
								<option value= "">-- Seleccione --</option>
								<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
									<cfset selected = iif(IsDefined("form.DSNO") and form.DSNO eq #arreglo[i]#,DE("selected"),DE(""))>
									<cfoutput><option value= "#arreglo[i]#"#selected#>#arreglo[i]#</option></cfoutput>
								</cfloop>
							</cfselect>
						</td>	
						<td width="1%" id="tdEcodigoO" <cfif isdefined('form.chkSQL')>style="display:none"</cfif>>
							<cfinput name="temp" type="hidden" value="#listadatasourse#">
							
							<cfselect name="DSND" style="width:150px;"  value="CEcodigo" display="CEnombre" bind="cfc:clonacion.getDSND(EcodigoO={formfiltrosup:EcodigoO},lista={formfiltrosup:temp})" bindonload="true" />		
						</td>
						<td width="1%" id="tdEcodigoD" <cfif not isdefined('form.chkSQL')>style="display:none"</cfif>>
							<cfset valtemp  = ''>
							<cfif isdefined("form.EcodigoDE") and len(trim(form.EcodigoDE)) gt 0 >
								<cfset valtemp  = form.EcodigoDE>
							</cfif>
							Ecodigo:
							<cfinput 
								type="text" 
								name="EcodigoDE"  
								size="5" 
								maxlength="5"
								onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
								value="#valtemp#" 
								onFocus="javascript:this.select();" 
								>
						</td>
						
					</tr>
					<tr>
						<td width="1%" class="etiqueta" nowrap>
							Cuenta Empresarial&nbsp;:&nbsp;	</td>
						<td width="1%">
							<cfselect name="CEcodigoO" style="width:150px;"  value="CEcodigo" display="CEnombre" bind="cfc:clonacion.getCEO(DSNO={formfiltrosup:DSNO})" bindonload="true" />
						</td>
						<td width="1%" id="tdCuenta"  <cfif isdefined('form.chkSQL')>style="display:none"</cfif>>
							<cfselect name="CEcodigoD" style="width:150px;"  value="CEcodigo" display="CEnombre" bind="cfc:clonacion.getCED(DSNO={formfiltrosup:DSNO},DSND={formfiltrosup:DSND})" bindonload="true" />
							</td>
					</tr>
						<tr>
							<td class="etiqueta" nowrap>Empresa&nbsp;:&nbsp;</td>
							<td>
								<cfselect name="EcodigoO" style="width:150px;"  value="Ecodigo" display="Edescripcion" bind="cfc:clonacion.getEO(DSNO={formfiltrosup:DSNO},CEcodigoO={formfiltrosup:CEcodigoO})" bindonload="true" />
							</td>
							<td id="tdEmpresa" <cfif isdefined('form.chkSQL')>style="display:none"</cfif>>
							 <cfselect name="EcodigoD" style="width:150px;"  value="Ecodigo" display="Edescripcion" bind="cfc:clonacion.getED(CEcodigoO={formfiltrosup:CEcodigoO},DSNO={formfiltrosup:DSNO},EcodigoO={formfiltrosup:EcodigoO},DSND={formfiltrosup:DSND},CEcodigoD={formfiltrosup:CEcodigoD})" bindonload="true" />
							</td>
							<td valign="top" id="tdAyuda" <cfif not isdefined('form.chkSQL')>style="display:none"</cfif>>
								<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ayuda" Default="Ayuda" returnvariable="LB_ayuda"/>
								<cf_web_portlet_start tipo="mini" titulo="#LB_ayuda#" tituloalign="left" wifth="50" height="50">
								<p>
								<cf_translate  key="LB_texto_de_ayuda">
									El Ecodigo que se debe de digitar es el que esta en la tabla Empresas (minisif)
								</cf_translate>
								</p>
								<cf_web_portlet_end>
							</td>
						</tr>
				
				</table>
				</td>
				</tr>
				</table>
			</cfform>
		</cfif>
		
		<br>
		
		<cfdiv id="divForm" onbinderror="myerror" bind="url:clonacion_form.cfm?SScodigoO={formfiltrosup:SScodigoO}&chkSQL={formfiltrosup:chkSQL}&DSNO={formfiltrosup:DSNO}&DSND={formfiltrosup:DSND}&EcodigoO={formfiltrosup:EcodigoO}&EcodigoD={formfiltrosup:EcodigoD}&CEcodigoO={formfiltrosup:CEcodigoO}&CEcodigoD={formfiltrosup:CEcodigoD}&EcodigoDE={formfiltrosup:EcodigoDE}"/>
		
		<!---<cfif (isdefined("form.EcodigoO") and form.EcodigoO GT 0) >
			<cfinclude template="clonacion-form.cfm">
		</cfif>--->
	
	<cf_web_portlet_end>
	</td></tr>
</table>
<cf_templatefooter>

