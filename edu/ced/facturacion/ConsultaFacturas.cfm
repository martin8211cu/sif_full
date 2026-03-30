<body onLoad="MM_preloadImages('/cfmx/edu/Imagenes/date_d.gif')"><!-- InstanceBegin template="/Templates/LMenuCED.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../../Utiles/general.cfm">
<cf_template>
	<cf_templatearea name="title">
		Educaci&oacute;n
	</cf_templatearea>
	<cf_templatearea name="body">
		<!-- InstanceBeginEditable name="head" -->
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
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
			<td width="100%" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" -->
	<!-- InstanceEndEditable --></td>
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
				  <!-- InstanceBeginEditable name="TituloPortlet" -->
		  	Consulta de Facturas Generadas
		  <!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
		  	<cfif isdefined("Url.fEFnombredoc") and not isdefined("Form.fEFnombredoc")>
				<cfset Form.fEFnombredoc = Url.fEFnombredoc>
			</cfif>
			<cfif isdefined("Url.fEFnumdoc") and not isdefined("Form.fEFnumdoc")>
				<cfset Form.fEFnumdoc = Url.fEFnumdoc>
			</cfif>
			<cfif isdefined("Url.fEFfechadoc") and not isdefined("Form.fEFfechadoc")>
				<cfset Form.fEFfechadoc = Url.fEFfechadoc>
			</cfif>
			<cfif isdefined("Url.fEFfechavenc") and not isdefined("Form.fEFfechavenc")>
				<cfset Form.fEFfechavenc = Url.fEFfechavenc>
			</cfif>
			
			<script language="JavaScript" type="text/javascript"  src="../../js/calendar.js" >//</script>
			<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
			  
			<script language="JavaScript" type="text/javascript">
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("../../js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
			</script>	
			<script language="JavaScript" type="text/JavaScript">
				<!--
				function MM_swapImgRestore() { //v3.0
				  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
				}
				
				function MM_preloadImages() { //v3.0
				  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
					var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
					if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
				}
				
				function MM_findObj(n, d) { //v4.01
				  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
					d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
				  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
				  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
				  if(!x && d.getElementById) x=d.getElementById(n); return x;
				}
				
				function MM_swapImage() { //v3.0
				  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
				   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
				}
				//-->
				</script>

			<cfinclude template="../../portlets/pNavegacionCED.cfm">
			
				<cfif isdefined("Form.EFid")>
					<cfinclude template="detalleConsultaFacturas.cfm">
				<cfelse>
					<form action="" name="formConFact" method="post">
					 <table width="100%" border="0" class="areaFiltro">
						<tr> 
						  <td nowrap class="subTitulo">&nbsp;</td>
						  <td align="left" nowrap class="subTitulo"><strong>No. Documento</strong></td>
						  <td class="subTitulo"><input name="fEFnumdoc" type="text" size="15" onFocus="this.select()" maxlength="60" value="<cfif isdefined("Form.fEFnumdoc") AND #Form.fEFnumdoc# NEQ "" ><cfoutput>#Form.fEFnumdoc#</cfoutput></cfif>"></td>
						  <td align="left" class="subTitulo"><strong>Nombre</strong></td>
						  <td class="subTitulo"><input name="fEFnombredoc" type="text" id="fEFnombredoc" size="60" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.fEFnombredoc") AND #Form.fEFnombredoc# NEQ "" ><cfoutput>#Form.fEFnombredoc#</cfoutput></cfif>"></td>
						  <td width="5%" rowspan="2" align="center" class="subTitulo"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" ></td>
						</tr>
						<tr> 
						  <td width="10%" nowrap class="subTitulo">&nbsp;</td>
						  <td width="10%" align="left" nowrap class="subTitulo"><strong>Fecha Doc.</strong></td>
						  <td width="5%" nowrap class="subTitulo"><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar1','','/cfmx/edu/Imagenes/date_d.gif',1)"> 
							<input name="fEFfechadoc" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfif isdefined("Form.fEFfechadoc") and len(trim(Form.fEFfechadoc)) neq 0><cfoutput>#Form.fEFfechadoc#</cfoutput></cfif>" size="15" maxlength="10" >
							</a><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar11','','/cfmx/edu/Imagenes/date_d.gif',1)"><img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar11" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.formConFact.fEFfechadoc');"></a></td>
						  <td width="9%" align="left" nowrap class="subTitulo"><strong>Fecha Venc.</strong></td>
						  <td width="37%" class="subTitulo"><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar1','','/cfmx/edu/Imagenes/date_d.gif',1)"> 
							<input name="fEFfechavenc" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfif isdefined("Form.fEFfechavenc") and len(trim(Form.fEFfechavenc)) neq 0><cfoutput>#Form.fEFfechavenc#</cfoutput></cfif>" size="15" maxlength="10" >
							</a><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar1','','/cfmx/edu/Imagenes/date_d.gif',1)"><img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.formConFact.fEFfechavenc');"></a></td>
						</tr>
					  </table>
					</form>
					<!--- <cfinclude template="filtros/filtroConsultaFacturas.cfm"> --->
					<cfinclude template="formConsultaFacturas.cfm">
				</cfif>
			
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