<!---
	 Modificacion: Jmadrigal
	 Fecha: 03-set-2008
	 Motivo: Se modifico la mascara del SN, para utilizar la configurada en Administracion general

	Modificado por: Ana Villavicencio
	Fecha: 27de febrero del 2006
	Motivo: se cambio el direccionamiento del link de Consulta del Saldo del socio,
			para q este llevara el socio al q estoy consultando.

	Modificado por: Gustavo Fonseca H.
		Fecha: 6-12-2005.
		Motivo: Se le agrega un link a la consulta del estado de cuenta de CxC.
	Modificado por: Ana Villavicencio
	Fecha: 31 de Agosto del 2005
	Motivo: Permitir ingresar la identificacion (fiscal o juridica) en caso de q no se tenga una mascara asignada
			en Parametros Adicionales.
	Lineas: 166
	Modificado por: Gustavo Fonseca H.
		Fecha: 8-12-2005.
		Motivo: Se le agrega un rtrim para quitar espacios en blanco y permitir que el combo de IDIOMA funcione
		correctamente.

	Modificado por: Ana Villavicencio
	Fecha: 08 de diciembre del 2005
	Motivo: Agregar una etiqueta para indicar si el socio de negocios tiene clasificacion.
 --->


<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_SociosNegociosCorporativos" default = "Socios de Negocios Corporativos" returnvariable="LB_SociosNegociosCorporativos" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_SeleccionarSocio" default = "Seleccionar un Socio" returnvariable="LB_SeleccionarSocio" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_SociosNegocio" default = "Socios de Negocio" returnvariable="LB_SociosNegocio" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_DatosGenerales" default = "Datos Generales" returnvariable="LB_DatosGenerales" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Adenda" default = "Asignacion de Adendas al Socio de Negocios" returnvariable="LB_Adenda" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Identificacion" default = "Identificaci&oacute;n" returnvariable="LB_Identificacion" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ModalidadCorp" default = "Modalidad Corp" returnvariable="LB_ModalidadCorp" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NumeroSocio" default = "N&uacute;mero de Socio" returnvariable="LB_NumeroSocio" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Correo" default = "Correo" returnvariable="LB_Correo" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Clasificaciones" default = "Clasificaciones" returnvariable="LB_Clasificaciones" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ConsultarSaldoSocio" default = "Consultar Saldo del Socio" returnvariable="LB_ConsultarSaldoSocio" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_InformacionCreditoVentas" default = "Informaci&oacute;n Cr&eacute;dito/Ventas" returnvariable="LB_InformacionCreditoVentas" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_InformacionCrediticiaVentas" default = "Informaci&oacute;n Crediticia y de Ventas" returnvariable="LB_InformacionCrediticiaVentas" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_InformacionContable" default = "Informaci&oacute;n Contable" returnvariable="LB_InformacionContable" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Contactos" default = "Contactos" returnvariable="LB_Contactos" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ContactosSociosNegocio" default = "Contactos de Socios de Negocio" returnvariable="LB_ContactosSociosNegocio" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Anotaciones" default = "Anotaciones" returnvariable="LB_Anotaciones" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_AnotacionesSocioNegocio" default = "Anotaciones del Socio de Negocio" returnvariable="LB_AnotacionesSocioNegocio" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Documento" default = "Documento" returnvariable="LB_Documento" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ObjetosSocioNegocios" default = "Objetos del Socio de Negocios" returnvariable="LB_ObjetosSocioNegocios" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ClasificacionGeneral" default = "Clasificaci&oacute;n General" returnvariable="LB_ClasificacionGeneral" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Clasificacion" default = "Clasificaci&oacute;n" returnvariable="LB_Clasificacion" xmlfile = "Socios.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ComponenteIne" default = "Complemento INE para Socio de Negocios" returnvariable="LB_ComponenteIne" xmlfile = "Socios.xml">

<cfinclude template="SociosModalidad.cfm">
<cf_templateheader title="#LB_SociosNegocio#">
		<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>
		<cfset Request.jsMask = true>

		<!--- --->
		<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) and (not isdefined("form.SNcodigo") or not len(trim(form.SNcodigo))) >
			<cfset form.SNcodigo = url.SNcodigo>
		</cfif>

		<cfparam name="form.SNcodigo" default="">
		<cfif isdefined("url.tab") and not isdefined("form.tab")>
			<cfset form.tab = url.tab >
		</cfif>
		<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5,6,7,8', form.tab) )>
			<cfset form.tab = 1 >
		</cfif>

		<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript" type="text/JavaScript">
		<!--//
			// specify the path where the "/qforms/" subfolder is located
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// loads all default libraries
			qFormAPI.include("*");
		//-->
		</script>
		<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

		<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
			<cfquery name="rsSocios" datasource="#Session.DSN#" >
				select yo.SNplazoentrega,yo.SNplazocredito,rtrim(yo.LOCidioma) as LOCidioma,yo.Ecodigo, yo.SNcodigo, yo.SNidentificacion,yo.SNidentificacion2, yo.SNtiposocio, yo.SNnombre, yo.SNdireccion,
				 yo.CSNid, yo.GSNid, yo.ESNid, yo.DEidEjecutivo, yo.DEidVendedor, yo.DEidCobrador, yo.SNnombrePago,
				 yo.SNtelefono, yo.SNFax, yo.SNemail, yo.SNFecha, yo.SNtipo, yo.SNvencompras, yo.SNvenventas, yo.SNinactivo, yo.usaINE, coalesce (yo.ZCSNid,-1) as ZCSNid,
				 yo.Mcodigo, yo.SNmontoLimiteCC, yo.SNdiasVencimientoCC, yo.SNdiasMoraCC, yo.SNdocAsociadoCC,
				 coalesce(yo.SNactivoportal, 0) as SNactivoportal, yo.SNnumero, yo.ts_rversion, yo.Ppais, yo.SNcertificado, yo.SNcodigoext, yo.cuentac,
				 yo.id_direccion, yo.SNidPadre, padre.SNcodigo as SNcodigoPadre, yo.SNid, yo.SNidCorporativo,
				 coalesce (yo.EcodigoInclusion, yo.Ecodigo) as EcodigoInclusion, einc.Edescripcion	 as EnombreInclusion,
				 yo.esIntercompany,yo.Intercompany,yo.TESRPTCid,yo.TESRPTCidCxC, yo.SNMid,yo.saldoCliente,yo.SNcontratos,
                 yo.remisionProveedor, yo.sincIntfaz,yo.Nacional,yo.IdFisc, yo.SNcontratos
				from SNegocios yo
					left join SNegocios padre
						on yo.SNidPadre = padre.SNid
					left join Empresas einc
						on einc.Ecodigo = coalesce (yo.EcodigoInclusion, yo.Ecodigo)
				where yo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and yo.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#">
				order by yo.SNnombre asc
			</cfquery>

		</cfif>
		<script language="javascript" type="text/javascript">
			function doConlisTransacciones(sncod){
				popUpWindow("conlisTransacciones.cfm?form=form3&cctdesc=CCTdescripcion&cctcod=CCTcodigo&sncod="+sncod,250,200,650,350);
			}
			function MM_findObj(n, d) { //v4.01
			  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
				d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
			  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
			  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
			  if(!x && d.getElementById) x=d.getElementById(n); return x;
			}
			function MM_preloadImages() { //v3.0
			  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
				var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
				if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
			}
			function socios_validateForm(form) { //MM_validateForm modificado para recibir argumento form
				var i,p,q,nm,test,num,min,max,errors='',args=socios_validateForm.arguments;
				for (i=1; i<(args.length-2); i+=3) {
					test=args[i+2];
					val=form[args[i]];
					if (val) {
						if (val.alt!="") nm=val.alt; else nm=val.name; if ((val=val.value)!="") {
							if (test.indexOf('isEmail')!=-1) {
					  			p=val.indexOf('@');
								if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una direccion de correo electronica valida.\n';
						  		}
						  	else if (test!='R') {
						  		num = parseFloat(val);
								if (isNaN(val)) errors+='- '+nm+' debe ser numerico.\n';
								if (test.indexOf('inRange') != -1) {
									p=test.indexOf(':');
						  			min=test.substring(8,p);
						  			max=test.substring(p+1);
						  			if (num<min || max<num) errors+='- '+nm+' debe ser un numero entre '+min+' y '+max+'.\n';
									}
								}
						  	}
						else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n';
						}
			  		}
			  if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
			  document.MM_returnValue = (errors == '');
			}
		</script>

		<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:bottom; ">
			<TR><TD valign="top">
				<cf_web_portlet_start border="true" titulo="#LB_SociosNegociosCorporativos#" >
				<cfinclude template="../../portlets/pNavegacion.cfm">

				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td>

						<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
							<table align="center" cellpadding="2" cellspacing="3" border="0">
								<tr>
									<td nowrap="nowrap"><strong><cfoutput>#LB_SociosNegocio#</cfoutput>:</strong></td>
									<td nowrap="nowrap"><cfoutput>#HTMLEditFormat(rsSocios.SNnombre)#</cfoutput></td>

									<td nowrap="nowrap"><strong><cfoutput>#LB_Identificacion#</cfoutput>:</strong></td>
									<td nowrap="nowrap"><cfoutput>#HTMLEditFormat(rsSocios.SNidentificacion)#</cfoutput></td>

									<td nowrap="nowrap"><strong><cfoutput>#LB_ModalidadCorp#</cfoutput>:</strong></td>
									<td nowrap="nowrap"><cfoutput>#HTMLEditFormat(modalidad.nombre)#</cfoutput></td>
								</tr>
								<tr>
									<td nowrap="nowrap"><strong><cfoutput>#LB_NumeroSocio#</cfoutput>:</strong></td>
									<td nowrap="nowrap"><cfoutput>#rsSocios.SNnumero#</cfoutput></td>

									<td nowrap="nowrap"><strong><cfoutput>#LB_Correo#</cfoutput>:</strong></td>
									<td nowrap="nowrap"><cfoutput>#rsSocios.SNemail#</cfoutput></td>

									<td nowrap="nowrap">
										<strong><cfoutput>#LB_Clasificaciones#</cfoutput>:</strong>
									</td>
									<td nowrap="nowrap">
										<cfquery name="rsConsultaCorp" datasource="asp">
											select 1
											from CuentaEmpresarial
											where Ecorporativa is not null
											  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
										</cfquery>
										<cfif isdefined('session.Ecodigo') and
											  isdefined('session.Ecodigocorp') and
											  session.Ecodigo NEQ session.Ecodigocorp and
											  rsConsultaCorp.RecordCount GT 0>
											  <cfset filtro = " and b.Ecodigo=#session.Ecodigo#">
										<cfelse>
											  <cfset filtro = " and b.Ecodigo is null">
										</cfif>
										<cfquery name="rsSNClasificacionE1" datasource="#session.dsn#">
											select b.SNCEdescripcion
											from SNClasificacionE b
											where b.CEcodigo=#session.CEcodigo# #filtro#
											and b.Ecodigo is null
											and b.PCCEobligatorio = 1
											and b.PCCEactivo = 1
											<cfif rsSocios.SNtiposocio eq 'P'>
												and b.SNCtiposocio in ('A', 'P')
											<cfelseif rsSocios.SNtiposocio eq 'C'>
												and b.SNCtiposocio in ('A', 'C')
											</cfif>
											and (
										         (  select count(1)
										            from SNClasificacionSN sn, SNClasificacionD a
										            where a.SNCDid = sn.SNCDid
										              and a.SNCEid = b.SNCEid
										              and sn.SNid = #rsSocios.SNid#)
										     ) = 0
										</cfquery>

										<cfquery name="rsSNClasificacionE2" datasource="#session.dsn#">
											select b.SNCEdescripcion
											from SNClasificacionE b
											where b.CEcodigo=#session.CEcodigo# #filtro#
												and b.SNCEalertar = 1
												and b.PCCEactivo = 1
												<cfif rsSocios.SNtiposocio eq 'P'>
													and b.SNCtiposocio in ('A', 'P')
												<cfelseif rsSocios.SNtiposocio eq 'C'>
													and b.SNCtiposocio in ('A', 'C')
												</cfif>
												and ((select count(1)
																from SNClasificacionSN sn,
																		SNClasificacionD a
																where sn.SNid = #rsSocios.SNid#
																and  a.SNCDid = sn.SNCDid
																and  a.SNCEid = b.SNCEid)) = 0
										</cfquery>

										<cfif rsSNClasificacionE1.recordcount gt 0>
											Requeridas
											<a href="##" onclick = "javascript: doConlisAlertas(<cfoutput>#rsSocios.SNid#</cfoutput>)"><img title="Faltan Clasificaciones Requeridas"  border="0" src="/cfmx/sif/imagenes/stop.gif"></a>
										</cfif>
										<cfif rsSNClasificacionE2.recordcount gt 0>
											<cfif rsSNClasificacionE1.recordcount eq 0>
												Alertas
											<cfelse>
												y Alertas
											</cfif>
											<a href="##" onclick = "javascript: doConlisAlertas(<cfoutput>#rsSocios.SNid#</cfoutput>)"><img title="Faltan Clasificaciones con Alertas"  border="0" src="/cfmx/sif/imagenes/stop4.gif"></a>
										</cfif>
										<cfif rsSNClasificacionE2.recordcount eq 0 and rsSNClasificacionE1.recordcount eq 0>
											Completas
										</cfif>
										<script language="javascript" type="text/javascript">
												var popUpWinAlertas=null;
												function popUpWindowAlertas(URLStr, left, top, width, height)
												{
												  if(popUpWinAlertas)
												  {
													if(!popUpWinAlertas.closed) popUpWinAlertas.close();
												  }
												  popUpWinAlertas = open(URLStr, 'popUpWinAlertas', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
												  if (! popUpWinAlertas && !document.popupblockerwarning) {
													alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nesta evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
													document.popupblockerwarning = 1;
												  }
												}
												function doConlisAlertas(SNid){
													if ((SNid)&&(SNid>0)) {
														popUpWindowAlertas('listaSocios-PopupAlerta.cfm?SNid='+SNid,150,150,600,400);
													}
													return false;
												}
										</script>
									</td>
								</tr>
							</table>
						</cfif>

					</td>
					<td>

							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td align="right"><a href="listaSocios.cfm"><cfoutput>#LB_SeleccionarSocio#</cfoutput></a></td>
									<td align="right"><a href="listaSocios.cfm"><img alt="Seleccionar un Socio"  border="0" src="/cfmx/sif/imagenes/find.small.png"></a></td>
								</tr>
								<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
									<cfquery name="rsTipoSocio" datasource="#session.DSN#">
										select SNtiposocio
										from SNegocios
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
									</cfquery>
									<cfif rsTipoSocio.recordcount EQ 1 and rsTipoSocio.SNtiposocio eq 'C' or rsTipoSocio.SNtiposocio eq 'A'>
										<tr>
											<td align="right"><a href="../../cc/consultas/analisisSocio.cfm?SNcodigo=<cfoutput>#form.SNcodigo#</cfoutput>&Ocodigo_F=-1&CatSoc=1"><cfoutput>#LB_ConsultarSaldoSocio#</cfoutput></a></td>
											<td align="right"><a href="../../cc/consultas/analisisSocio.cfm?SNcodigo=<cfoutput>#form.SNcodigo#</cfoutput>&Ocodigo_F=-1&CatSoc=1"><img alt="Consultar Saldo del Socio"  border="0" src="/cfmx/sif/imagenes/SP_D.gif"></a></td>
										</tr>
									</cfif>
								</cfif>
							</table>

					</td>
				  </tr>
				</table>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td align="center" valign="top" height="600">
						<cf_tabs width="99%">
							<cf_tab text="#LB_DatosGenerales#" selected="#form.tab eq 1#">
								<cf_web_portlet_start border="true" titulo="#LB_DatosGenerales#" >
									<cfinclude template="SociosDGenerales.cfm">
								<cf_web_portlet_end>
							</cf_tab>

							<cfif Len(form.SNcodigo)>
								<cf_tab text="#LB_InformacionCreditoVentas#" selected="#form.tab eq 2#">
									<cf_web_portlet_start border="true" titulo="#LB_InformacionCrediticiaVentas#" >
										<cfinclude template="SociosICrediticia.cfm">
									<cf_web_portlet_end>
								</cf_tab>
								<cf_tab text="#LB_InformacionContable#" selected="#form.tab eq 3#">
									<cf_web_portlet_start border="true" titulo="#LB_InformacionContable#" >
										<cfinclude template="SociosIContable.cfm">
									<cf_web_portlet_end>
								</cf_tab>
								<cf_tab text="#LB_Contactos#" selected="#form.tab eq 4#">
									<cf_web_portlet_start border="true" titulo="#LB_ContactosSociosNegocio#" >
										  <cfinclude template="Contactos.cfm">
									<cf_web_portlet_end>
								</cf_tab>
								<cf_tab text="#LB_Anotaciones#" selected="#form.tab eq 5#">
									<cf_web_portlet_start border="true" titulo="#LB_AnotacionesSocioNegocio#" >
										 <cfinclude template="Anotaciones.cfm">
									<cf_web_portlet_end>
								</cf_tab>
								<cf_tab text="#LB_Documento#" selected="#form.tab eq 6#">
									<cf_web_portlet_start border="true" titulo="#LB_ObjetosSocioNegocios#" >
										 <cfinclude template="ObjetosSN.cfm">
									<cf_web_portlet_end>
								</cf_tab>
								<cf_tab text="#LB_ClasificacionGeneral#" selected="#form.tab eq 7#">
									<cf_web_portlet_start border="true" titulo="#LB_Clasificacion#" >
										 <cfinclude template="SociosClasif.cfm">
									<cf_web_portlet_end>
								</cf_tab>
								<!--- <cf_tab text="Direcci&oacute;n" selected="#form.tab eq 8#">
									<cf_web_portlet_start border="true" titulo="Direcci&oacute;n" >
										 <cfinclude template="SociosDireccion.cfm">
									<cf_web_portlet_end>
								</cf_tab> --->

								<cf_tab text="Adenda" selected="#form.tab eq 8#">
									<!---Falta agregar a la base de datos el text de "Adendas del Socio de Negocios" que probablemente seria "#LB_Adendas#" --->
									<cf_web_portlet_start border="true" titulo="#LB_Adenda#" >
										<cfinclude template="Adenda.cfm">
									<cf_web_portlet_end>
								</cf_tab>
								<cfif rsSocios.usaINE eq 1>
									<cf_tab text="Complemento INE" selected="#form.tab eq 9#">
										<cf_web_portlet_start border="true" titulo="#LB_ComponenteIne#" >
											 <cfinclude template="ComplementoINE.cfm">
										<cf_web_portlet_end>
									</cf_tab>
								</cfif>

							</cfif>
						</cf_tabs>
					</td>
					</tr>
					<TR><td>&nbsp;</td></TR>
				</table>

				<cf_web_portlet_end>
			</TD></TR>
		</table>
<cf_templatefooter>

<script language="JavaScript" type="text/javascript">
	var f = document.form;
	<cfoutput>
	<cfset MascaraSN = #Replace(MascaraNumeroSN,'?','x','ALL')#>
	var SociosNegociosMask = new Mask("#replace(MascaraSN,'X','##','ALL')#", "string");
	SociosNegociosMask.attach(document.form.SNnumero, SociosNegociosMask.mask, "string");

		<cfif LvarSNtipo EQ ''>
			<cfset LvarSNtipo = 'F'>
		</cfif>
		var oCedulaMask = new Mask("#replace(LvarSNtipo,'X','##','ALL')#", "string");
		oCedulaMask.attach(document.form.SNidentificacion, oCedulaMask.mask, "string");
		function cambiarMascara(v)
		{
			document.form.SNidentificacion.value = "";
			if (v == 'F')
			{
				oCedulaMask.mask = "#replace(rsMasks.Fisica,'X','##','ALL')#";
				document.form.SNmask.value = "#rsMasks.Fisica#";
			}
			else if (v == 'J')
			{
				oCedulaMask.mask = "#replace(rsMasks.Juridica,'X','##','ALL')#";
				document.form.SNmask.value = "#rsMasks.Juridica#";
			}
			else if (v == 'E')
			{
				oCedulaMask.mask = "#replace(rsMasks.Extranjera,'X','##','ALL')#";
				document.form.SNmask.value = "#rsMasks.Extranjera#";
			}
		}

		try{
			document.form.SNnumero.focus();
		}catch(e){
		}
		<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
			function funcDirecciones(){
				document.form.action='SociosDireccion.cfm?SNcodigo=#form.SNcodigo#&SNcat=1';
				document.form.submit();
			}
		</cfif>
	</cfoutput>

</script>
