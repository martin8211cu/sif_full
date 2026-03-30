<!-- InstanceBegin template="/Templates/LMenuDOC.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../../Utiles/general.cfm">
<cf_template>
	<cf_templatearea name="title">
		Educaci&oacute;n
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="head" -->
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
		<td valign="top">
			<cfset RolActual = 5>
			<cfset Session.RolActual = 5>
			<cfinclude template="../../portlets/pEmpresas2.cfm">
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr class="area" style="padding-bottom: 3px;"> 
			  <td nowrap style="padding-left: 10px;">
			  <cfinclude template="../../portlets/pminisitio.cfm">
			  </td>
			  <td valign="top" nowrap> 
		  <!-- InstanceBeginEditable name="MenuJS" --><cfinclude template="../jsMenuDOC.cfm">
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
			  <!-- InstanceBeginEditable name="TituloPortlet" --> 
            Documentos<!-- InstanceEndEditable -->
			  </td>
			  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
			</tr>
			<tr> 
			  <td colspan="3" class="contenido-lbborder">
			  <!-- InstanceBeginEditable name="Mantenimiento2" -->
		  
	<cfinvoke 
	 component="edu.Componentes.usuarios"
	 method="get_usuario_by_cod"
	 returnvariable="usr">
		<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
		<cfinvokeargument name="sistema" value="edu"/>
		<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
		<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
		<cfinvokeargument name="roles" value="edu.docente"/>
	</cfinvoke>

	<cfquery datasource="#Session.Edu.DSN#" name="rsProfesor">
		select convert(varchar,Splaza) as Splaza
			, (Papellido1 + ' ' 
			+ Papellido2 + ','
			+ Pnombre) as nombre 
		from 	PersonaEducativo a
				, Staff b 
		where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.persona=b.persona 
			and a.CEcodigo=b.CEcodigo 
			and b.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
			and b.retirado = 0 
			and b.autorizado = 1 
	</cfquery>
<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function  fnConsultarDoc(doc,tipo,t_contenido, nombre, atributo, t_atributo, valor)
	{
		if (t_contenido == 'I' || t_contenido == 'T' || t_contenido == 'D'  || t_contenido == 'L' ) {
			link="/cfmx/edu/responsable/ConlisBusquedaMaterial.cfm?tipo="+tipo+"&documento="+doc+"&id_atributo="+atributo+"&tipo_atributo="+t_atributo+"&id_valor="+valor;
			LvarWin = window.open(link, "ConsultaMaterial", "left=100,top=50,scrollbars=yes,resiable=yes,width=800,height=600,alwaysRaised=yes");
			LvarWin.focus();
			return;
		} 
		else if (t_contenido == 'L') {
		 	link=""+nombre
			LvarWin = window.open(link);
			LvarWin.focus();
			return;
		}
		/*else if (t_contenido == 'D') {
			
		 	link="d:/My Documents/LO QUE SEMBRAMOS ES LO QUE RECOGEMOS.doc?tipo="+tipo+"&documento="+doc;
			LvarWin = window.open(link, "ConsultaMaterial", "left=100,top=50,scrollbars=yes,resiable=yes,width=800,height=600,alwaysRaised=yes");
			LvarWin.focus();
			return;
			
			location.href = "/jsp/DownloadServlet/MaterialApoyo/Documentos?id_documento="+doc;
		}*/
	}
</script>		  
		  
		  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  	<tr>
					<td valign="top">
						<cfinclude template="../../portlets/pNavegacionDOC.cfm">
					</td>
				</tr>
				<tr> 
				  <td class="tituloAlterno">
				  	Profesor Actual: <cfoutput>#rsProfesor.nombre#</cfoutput>
					<cfset plaza = rsProfesor.Splaza>
				  </td>
				</tr> 
				<tr> 
				  <td><cfinclude template="formDocumentos.cfm"></td>
				</tr> 				 
			</table>		  
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