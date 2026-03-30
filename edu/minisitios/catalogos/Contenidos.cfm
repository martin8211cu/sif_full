<!-- InstanceBegin template="/Templates/LMenuCED.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../../Utiles/general.cfm">
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
				<cfset RolActual = 4>
				<cfset Session.RolActual = 4>
				<cfinclude template="../../portlets/pEmpresas2.cfm">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr class="area" style="padding-bottom: 3px;"> 
				  <td nowrap style="padding-left: 10px;">
				  <cfinclude template="../../portlets/pminisitio.cfm">
				  </td>
				  <td valign="top" nowrap> 
			  <!-- InstanceBeginEditable name="MenuJS" --> 
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
			<td width="100%" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --> <!-- InstanceEndEditable --></td>
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
		  	Contenidos
		  <!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
				<cfif isdefined("Url.PageNum_lista") and not isdefined("Form.PageNum_lista")>
					<cfset Form.PageNum_lista = Url.PageNum_lista>
				</cfif>
				<cfif isdefined("Url.PageNum") and not isdefined("Form.PageNum")>
					<cfset Form.PageNum = Url.PageNum>
				</cfif>
				<cfif isdefined("Form.PageNum_lista")>
					<cfset Form.PageNum = Form.PageNum_lista>
				</cfif>
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacionMIN.cfm"></td></tr>
					<tr>
						<td valign="top" width="40%">
							<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
								<cfset Pagenum_lista = #Form.Pagina#>
							</cfif> 
						 
							<cfinvoke 
							 component="edu.Componentes.pListas"
							 method="pListaEdu"
							 returnvariable="pListaEduRet">
								<cfinvokeargument name="tabla" value="MSContenido a,MSCategoria b"/>
								<cfinvokeargument name="columnas" value="convert(varchar, MSCcontenido) as MSCcontenido,MSCnombre, substring(MSCtitulo,1,35) + case when char_length(MSCtitulo)  > 35 then '...' else '' end as MSCtitulo ,convert(varchar,MSCexpira,103) as MSCexpira, MSCexpira as Expiracion,(select count(1) from MSImagen c where c.MSCcontenido = a.MSCcontenido and c.Scodigo = #session.Scodigo#) as cant_images"/>
								<cfinvokeargument name="desplegar" value="MSCtitulo,MSCexpira,cant_images"/>
								<cfinvokeargument name="etiquetas" value="T tulo,Expira,Imgenes"/>
								<cfinvokeargument name="formatos" value="S,S,S"/>
								<cfinvokeargument name="filtro" value="a.Scodigo = #session.Scodigo# and a.MSCcategoria=b.MSCcategoria order by Expiracion desc, MSCnombre,MSCtitulo"/>
								<cfinvokeargument name="align" value="left,left,left"/>
								<cfinvokeargument name="ajustar" value="N,N,N"/>
								<cfinvokeargument name="irA" value="Contenidos.cfm"/>
								<cfinvokeargument name="Conexion" value="sdc"/>
								<cfinvokeargument name="cortes" value="MSCnombre"/>
								<cfinvokeargument name="debug" value="N"/>
								<cfinvokeargument name="maxrows" value="17"/>
								<cfinvokeargument name="keys" value="MSCcontenido"/>
							</cfinvoke>
						</td>
						<td valign="top" width="60%"><cfinclude template="formContenidos.cfm"></td>
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