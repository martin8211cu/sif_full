<body onLoad="MM_preloadImages('/cfmx/edu/Imagenes/date_d.gif')"><!-- InstanceBegin template="/Templates/LMenuCED.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../../Utiles/general.cfm">
<cf_template>
	<cf_templatearea name="title">
		Educaci&oacute;n
	</cf_templatearea>
	<cf_templatearea name="body">
		<!-- InstanceBeginEditable name="head" -->
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
<!-- InstanceEndEditable -->
		<link href="../../css/portlets.css" rel="stylesheet" type="text/css">
		<link href="../../css/edu.css" rel="stylesheet" type="text/css">
		<script language="JavaScript" type="text/JavaScript">
		<!--
		function MM_reloadPage(init) {  //reloads the window if Nav4 resized
		  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
			document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
		  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
		}
		MM_reloadPage(true);
		//-->
		</script>
		<script language="JavaScript" type="text/javascript">
			// Funciones para Manejo de Botones
			botonActual = "";
		
			function setBtn(obj) {
				botonActual = obj.name;
			}
			function btnSelected(name, f) {
				if (f != null) {
					return (f["botonSel"].value == name)
				} else {
					return (botonActual == name)
				}
			}
		</script>

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr> 
			<td width="154" rowspan="2" align="center" valign="top"><img src="../../Imagenes/logo.gif" width="154" height="62"></td>
			<td valign="bottom"> 
			  <!-- InstanceBeginEditable name="Ubica" -->
	<cfinclude template="../../portlets/pubica.cfm">
	<!-- InstanceEndEditable --> </td>
		  </tr>
		  <tr> 
			<td valign="top">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr class="area"> 
				  <td width="275" valign="middle">
					<cfset RolActual = 4>
					<cfset Session.RolActual = 4>
					<cfinclude template="../../portlets/pEmpresas2.cfm">
				  </td>
				  <td nowrap> 
					<div align="center"><span class="superTitulo">
					<font size="5">
			  <!-- InstanceBeginEditable name="Titulo" --> 
			Administraci&oacute;n del Centro de Estudio
      <!-- InstanceEndEditable -->	
					</font></span></div></td>
				</tr>
				<tr class="area" style="padding-bottom: 3px;"> 
				  <td nowrap style="padding-left: 10px;">
				  <cfinclude template="../../portlets/pminisitio.cfm">
				  </td>
				  <td valign="top" nowrap> 
			  <!-- InstanceBeginEditable name="MenuJS" --> 
            <cfinclude template="../jsMenuCED.cfm">
      <!-- InstanceEndEditable -->	
				  </td>
				</tr>
			  </table>
			</td>
		  </tr>
		</table>
		  
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr> 
			<td align="left" valign="top" nowrap></td>
			<td width="100%" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --><!-- InstanceEndEditable --></td>
		  </tr>
		  <tr> 
			<td valign="top" nowrap>
				<cfinclude template="/sif/menu.cfm">
			</td>
			<td valign="top" width="100%">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
				  <td width="2%"class="Titulo"><img  src="../../Imagenes/sp.gif" width="15" height="15" border="0"></td>
				  <td width="3%" class="Titulo" >&nbsp;</td>
				  <td width="94%" class="Titulo">
				  <!-- InstanceBeginEditable name="TituloPortlet" -->Registro 
            de Incidencias<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" --> 
			<script language="JavaScript" type="text/javascript">
				function MM_findObj(n, d) { //v4.01
				  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
					d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
				  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
				  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
				  if(!x && d.getElementById) x=d.getElementById(n); return x;
				}
			
				function MM_swapImgRestore() { //v3.0
				  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
				}
				
				function MM_swapImage() { //v3.0
				  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
				   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
				}
			</script>
			<cfif isdefined("Url.fNombreAl") and not isdefined("Form.fNombreAl")>
				<cfset Form.fNombreAl = Url.fNombreAl>
			</cfif>
			<cfif isdefined("Url.fIdescripcion") and not isdefined("Form.fIdescripcion")>
				<cfset Form.fIdescripcion = Url.fIdescripcion>
			</cfif>
			<cfif isdefined("Url.fITid") and not isdefined("Form.fITid")>
				<cfset Form.fITid = Url.fITid>
			</cfif>
			<cfif isdefined("Url.fIfecha") and not isdefined("Form.fIfecha")>
				<cfset Form.fIfecha = Url.fIfecha>
			</cfif>
			
			<cfif isdefined("Form.Cambio")>
				<cfset modo="CAMBIO">
			<cfelse>
              <cfif not isdefined("Form.modo")>
					<cfset modo="ALTA">
				<cfelseif Form.modo EQ "CAMBIO">
					<cfset modo="CAMBIO">
				<cfelse>
					<cfset modo="ALTA">
				</cfif>
			</cfif>
			<cfquery datasource="#Session.Edu.DSN#" name="rsIncidenciasTipo">
				select convert(varchar,ITid) as ITid, ITcodigo,  ITdescripcion, ITmonto 
				from IncidenciasTipo 
				order by ITdescripcion
			</cfquery>
			
			<cfif isdefined("Url.Iid") and not isdefined("Form.Iid")>
				<cfset Form.Iid = Url.Iid>
			</cfif>
			<cfif modo NEQ "ALTA">
				<cfquery datasource="#Session.Edu.DSN#" name="rsIncidencias">
					Select convert(varchar,a.Iid) as Iid,
					 convert(varchar,a.ITid) as ITid,
					 convert(varchar,a.Ecodigo) as Ecodigo, 
					 convert(varchar,a.CEcodigo) as CEcodigo,
					convert(varchar,a.Ifecha,103) as Ifecha, 
					a.Idescripcion, a.Imonto , 
					(c.Papellido1 + ' ' + c.Papellido2 + ',' + c.Pnombre) as Nombre
					from Incidencias a, Alumnos b, PersonaEducativo c
					where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and a.Iid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#">
					and a.Ecodigo = b.Ecodigo 
					  and b.persona = c.persona
					  
				</cfquery>
			</cfif>
			<script language="JavaScript" type="text/javascript"  src="../../js/calendar.js" >//</script>
			<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
			  
			<script language="JavaScript" type="text/javascript">
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("../../js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
				
				function validaForm(f) {
					//alert(f.obj.Ifecha.value);
					f.obj.Imonto.value = qf(f.obj.Imonto.value);
					return true;
				}
				var popUpWin=0;
				function popUpWindow(URLStr, left, top, width, height){
				  if(popUpWin) {
					if(!popUpWin.closed) popUpWin.close();
				  }
				  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
			
				function doConlis() {
					popUpWindow("../consultas/conlisAlumnos.cfm?form=formfactIncidencias"
								+"&Ecodigo=Ecodigo"
								+"&NombreAl=NombreAl",250,200,650,350);
				} 
				var montoConcepto = new Object();
				<cfloop query="rsIncidenciasTipo">
					montoConcepto['<cfoutput>#ITid#</cfoutput>'] = parseFloat(<cfoutput>#ITmonto#</cfoutput>);
				</cfloop>
				function changeMonto(id){
						//Sugiere el monto de la Incidencia en cero
						if (id != "") document.formfactIncidencias.Imonto.value = fm(montoConcepto[id],2);
				}
			</script>
			<cfinclude template="../../portlets/pNavegacionCED.cfm">
			<form name="formfactIncidencias" method="post" action="SQLfactIncidencias.cfm" onSubmit="javascript: return validaForm(this);">
			<input name="Iid" id="Iid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsIncidencias.Iid#</cfoutput></cfif>" type="hidden"> 
		      <table width="99%" border="0">
                <tr> 
                  <td align="right" valign="top">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                  <td valign="top" nowrap><strong>Tipo Incidencia</strong></td>
                  <td valign="top" nowrap> <select name="ITid" onChange="javascript: changeMonto(this.value);">
                      <cfoutput query="rsIncidenciasTipo"> 
                        <cfif modo NEQ "ALTA" and #rsIncidenciasTipo.ITid# EQ #rsIncidencias.ITid#>
                          <option value="#rsIncidenciasTipo.ITid#" selected>#rsIncidenciasTipo.ITdescripcion#</option>
                          <cfelse>
                          <option value="#rsIncidenciasTipo.ITid#">#rsIncidenciasTipo.ITdescripcion#</option>
                        </cfif>
                      </cfoutput> </select> </td>
                  <td valign="top" nowrap><strong>Monto</strong></td>
                  <td width="9%" align="left" valign="top" nowrap> <div align="left"> 
                      <input name="Imonto" align="left" type="text" id="Imonto2" size="22" maxlength="22" style="text-align: right;" value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsIncidencias.Imonto,'none')#</cfoutput></cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
                    </div>
                    <div align="left"></div></td>
                  <td width="4%" valign="top" nowrap><strong>Fecha</strong></td>
                  <td width="34%" valign="top" nowrap><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar11','','/cfmx/edu/Imagenes/date_d.gif',1)"> 
                    <input name="Ifecha" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfif modo NEQ "ALTA"><cfoutput>#rsIncidencias.Ifecha#</cfoutput><cfelse><cfoutput>#DateFormat(Now(),'DD/MM/YYYY')#</cfoutput></cfif>" size="12" maxlength="10" >
                    <img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar11" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.formfactIncidencias.Ifecha');"> 
                    </a></td>
                </tr>
                <tr> 
                  <td width="3%" align="right" valign="top">&nbsp;</td>
                  <td width="11%" valign="top" nowrap> <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar11','','/cfmx/edu/Imagenes/date_d.gif',1)"> 
                    </a><strong>Alumno</strong> </td>
                  <td width="31%" valign="top" nowrap><input name="NombreAl" type="text" id="NombreAl2" size="50" maxlength="180" readonly="true" value="<cfif modo NEQ "ALTA"><cfoutput>#rsIncidencias.Nombre#</cfoutput></cfif>"> 
                    <a href="#"> <img src="../../Imagenes/Description.gif" alt="Lista de Alumnos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();" > 
                    </a> </td>
                  <td width="8%" valign="top" nowrap><strong>Descripci&oacute;n</strong></td>
                  <td colspan="3" valign="top" nowrap><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar11','','/cfmx/edu/Imagenes/date_d.gif',1)"> 
                    </a> <input name="Idescripcion" type="text" id="Idescripcion5" onFocus="this.select()" value="<cfif modo NEQ "ALTA"><cfoutput>#rsIncidencias.Idescripcion#</cfoutput></cfif>" size="80" maxlength="100"> 
                    <div style="display: ;" id="verDiaEstud">&nbsp;</div></td>
                </tr>
                <tr> 
                  <td width="3%" valign="top">&nbsp;</td>
                  <td colspan="6" align="center" valign="top"><input name="Ecodigo" type="hidden" value="<cfif modo NEQ "ALTA"><cfoutput>#rsIncidencias.Ecodigo#</cfoutput></cfif>"> 
                    <cfinclude template="../../portlets/pBotones.cfm"> </td>
                </tr>
              </table>
		</form>
		<form action="" name="filtrofactIncidencias" method="post">
		      <table width="99%" height="28" border="0" class="areaFiltro">
                <tr>
                  <td align="right">&nbsp;</td>
                  <td align="right"><div align="left"><strong>Alumno</strong></div></td>
                  <td align="right">&nbsp;</td>
                  <td nowrap><strong>Fecha</strong></td>
                  <td nowrap>&nbsp;</td>
                  <td nowrap><strong>Tipo</strong></td>
                  <td nowrap>&nbsp;</td>
                  <td><strong>Descripci&oacute;n</strong></td>
                  <td align="center">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="0%" align="right">&nbsp;</td>
                  <td width="17%" align="right"><input name="fNombreAl" type="text" id="fNombreAl" size="35" onFocus="this.select()" maxlength="180" value="<cfif isdefined("Form.fNombreAl") AND #Form.fNombreAl# NEQ ""><cfoutput>#Form.fNombreAl#</cfoutput></cfif>"></td>
                  <td width="0%" align="right">&nbsp;</td>
                  <td width="7%" nowrap><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar1','','/cfmx/edu/Imagenes/date_d.gif',1)"> 
                    <input name="fIfecha" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfif isdefined("Form.fIfecha") AND #Form.fIfecha# NEQ "" ><cfoutput>#Form.fIfecha#</cfoutput></cfif>" size="12" maxlength="10" >
                    <img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.filtrofactIncidencias.fIfecha');"></a></td>
                  <td width="0%" nowrap>&nbsp;</td>
                  <td width="20%" nowrap><select name="fITid">
                      <cfif isdefined("form.fITid") and #form.fITid# EQ "-1">
                        <option value="-1" selected>-- Todos --</option>
                        <cfelse>
                        <option value="-1">-- Todos --</option>
                      </cfif>
                      <cfoutput query="rsIncidenciasTipo"> 
                        <cfif isdefined("form.fITid") and #form.fITid# EQ #rsIncidenciasTipo.ITid#>
                          <option value="#rsIncidenciasTipo.ITid#" selected>#rsIncidenciasTipo.ITdescripcion#</option>
                          <cfelse>
                          <option value="#rsIncidenciasTipo.ITid#">#rsIncidenciasTipo.ITdescripcion#</option>
                        </cfif>
                      </cfoutput> </select></td>
                  <td width="1%" nowrap>&nbsp;</td>
                  <td width="36%"><input name="fIdescripcion" type="text" id="fIdescripcion" onFocus="this.select()" value="<cfif isdefined("Form.fIdescripcion") AND #Form.fIdescripcion# NEQ "" ><cfoutput>#Form.fIdescripcion#</cfoutput></cfif>" size="80" maxlength="100"></td>
                  <td width="19%" align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar"></td>
                </tr>
              </table>
		</form>

		<cfinclude template="../facturacion/formFactIncidencias.cfm">
		    <script language="JavaScript">
		//------------------------------------------------------------------------------------------						
	function deshabilitarValidacion() {
		objForm.Ifecha.required = false;
		objForm.Imonto.required = false;
		objForm.Idescripcion.required = false;
		objForm.Ecodigo.required = false;
	}
//------------------------------------------------------------------------------------------						
	function habilitarValidacion() {
		objForm.Ifecha.required = true;
		objForm.Imonto.required = true;
		objForm.Idescripcion.required = true;
		objForm.Ecodigo.required = true;
	}	
//------------------------------------------------------------------------------------------							
			
			qFormAPI.errorColor = "#FFFFCC";
			objForm = new qForm("formfactIncidencias");
			
			<cfif modo EQ "ALTA" >
				objForm.Ifecha.required = true;
				objForm.Ifecha.description = "fecha";
				objForm.Imonto.required = true;
				objForm.Imonto.description = "monto";
				objForm.Idescripcion.required = true;
				objForm.Idescripcion.description = "descripción";
				objForm.Ecodigo.required = true;
				objForm.Ecodigo.description = "alumno";
			<cfelseif modo EQ "CAMBIO">
				objForm.Ifecha.required = true;
				objForm.Ifecha.description = "fecha";
				objForm.Imonto.required = true;
				objForm.Imonto.description = "monto";
				objForm.Idescripcion.required = true;
				objForm.Idescripcion.description = "descripción";
				objForm.Ecodigo.required = true;
				objForm.Ecodigo.description = "alumno";
			</cfif>	
			changeMonto(document.formfactIncidencias.ITid.value);
		</script>
		  <!-- InstanceEndEditable -->
				  </td>
				  <td class="contenido-brborder">&nbsp;</td>
				</tr>
			  </table>
			 </td>
		  </tr>
		</table>

	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->