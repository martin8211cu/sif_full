<cfset t=createObject("component", "sif.Componentes.Translate")>
<cfset LB_MensajeDeErrorParaElUsuario =t.translate('LB_MensajeDeErrorParaElUsuario','Mensaje para Usuario','/index.xml')>
<cfset LB_NoSeHanRegistradoAccionesCorrectivasATomar =t.translate('LB_NoSeHanRegistradoAccionesCorrectivasATomar','No se han registrado Acciones Correctivas a tomar','/index.xml')>
<cfset LB_Regresar =t.translate('LB_Regresar','Regresar','/index.xml')>
<cfset LB_DescripcionDelError =t.translate('LB_DescripcionDelError','Descripción del Error','/index.xml')>
<cfset LB_AccionesATomar =t.translate('LB_AccionesATomar','Acciones a tomar','/index.xml')>
<cfset LB_EnviarReportePorCorreo =t.translate('LB_EnviarReportePorCorreo','Enviar reporte por correo','/index.xml')>
<cfset LB_VerDetallesTecnicos =t.translate('LB_VerDetallesTecnicos','Ver detalles técnicos','/index.xml')>
<cfset LB_NoHayDetallesTenicosParaEstemensaje =t.translate('LB_NoHayDetallesTenicosParaEstemensaje','No hay detalles técnicos para este mensaje','/index.xml')>
<cfset LB_ReporteDeErrorNumero =t.translate('LB_ReporteDeErrorNumero','Reporte de Error número','/index.xml')>
<cfset LB_ReporteDeError =t.translate('LB_ReporteDeError','Reporte de Error','/index.xml')>


<cfset _fnDisplayObtieneInformacionError()>
<cftry>
	<cfcontent type="text/html; charset=utf-8">
	<cfheader name="Content-Disposition" value="inline" >
	<cfcatch type="any">
		<!--- en caso de que la pagina haya usado cfflush --->
	</cfcatch>
</cftry>
<cf_templateheader title="#LvarTitle#">
	<cfoutput>
	<script type="text/javascript">
	<!--
		if (window.top != window) {
			top.location.replace ( '/cfmx/home/public/error/display.cfm?errSS=#URLEncodedFormat(url.errSS)#&errSM=#URLEncodedFormat(url.errSM)#&errSP=#URLEncodedFormat(url.errSP)#<cfif isdefined("Request.Error.Backs")>&ErrBacks=#URLEncodedFormat(Request.Error.Backs)#</cfif>' );
		}
	//-->
	</script>
	</cfoutput>
	<table width="918" border="0" cellspacing="0" cellpadding="2">
		<tr> 
			<td width="77">&nbsp;</td>
			<td colspan="3">&nbsp;</td>
		</tr>
		<cfoutput>
		<tr> 
			<td>&nbsp;</td>
			<td width="25" bgcolor="##0088A6">
				<!--- <font color="##FFFFFF">
					
					<i class="fa fa-exclamation-triangle fa-2x" aria-hidden="true"></i>
				</font> --->
				<!--- <img src="/cfmx/home/public/error/#LvarIMG#" width="25" height="25" style="padding:1px"> --->
			</td>
			<td width="722" bgcolor="##0088A6" align="center">
			<span style="color:white;font-family:Verdana, Arial, Helvetica, sans-serif;font-size:16px;font-weight:bold ">
					#LvarTitle#
			</td>
			<td width="78">&nbsp;</td>
		</tr>
		</cfoutput>
		<cfoutput>
		<tr> 
			<td>&nbsp;</td>
			<td valign="top" nowrap bgcolor="##F5F5F5" class="contenido-lborder">
				<div align="right">&nbsp;</div>
			</td>
			<td valign="top" bgcolor="##F5F5F5" class="contenido-rborder" >
				<br/>
				<p><i class="fa fa-exclamation-triangle fa-lg" aria-hidden="true"></i>
					#LB_ReporteDeErrorNumero# <strong># HTMLEditFormat( REReplace( Request.errorid, "([0-9]{3})([0-9])", "\1-\2", "all" ) )#</strong>
					<br>
				</p>
			</td>
		</tr>
		</cfoutput>
		<cfoutput>
		<tr>
		  <td>&nbsp;</td>
		  <td valign="top" bgcolor="##F5F5F5" class="contenido-rborder">&nbsp;</td>
		  <td valign="top" nowrap bgcolor="##F5F5F5" class="contenido-lborder" style="color:#LvarColor#;font-weight:bold">
	<cfif LvarWithCode>
		  ERROR CODE : #LvarErrorCOD# <BR>
	</cfif>
		  &nbsp;				
		  </td>
		  <td>&nbsp;</td>
		</tr>
		</cfoutput>
		<cfoutput>
		<tr> 
			<td>&nbsp;</td>
			<td valign="top" nowrap bgcolor="##F5F5F5" class="contenido-lborder">&nbsp;</td>
			<td valign="top" bgcolor="##F5F5F5" class="contenido-rborder"  
				style="color:#LvarColor#;font-size:14px;font-weight:bold; padding-right:20px">
				<cfif NativeErrorCode IS 547 and LvarDS EQ "sqlserver">
					<!---
						547 = sqlserver: Error de Constraint Foreing key, delete, check
					--->
					ERROR DE INTEGRIDAD DE BASE DE DATOS:<BR>
					<cfset LvarMSG = HTMLEditFormat (REReplace(LvarMSG,'.*\]', '', 'one'))>
					<cfif find("&lt;br&gt;",LvarMSG)>
						<cfset LvarMSG = mid(LvarMSG,1,find("&lt;br&gt;",LvarMSG)-1)>
					</cfif>
					#LvarMSG#
				<cfelseif NativeErrorCode IS 2601 OR NativeErrorCode IS 2627 OR NativeErrorCode IS 1 OR NativeErrorCode IS -803>
					<!---	PRIMARY/UNIQUE KEY
						2601 = sybase
						2627 = sqlserver
						0001 = oracle
						-803 = db2
					--->			
					ERROR DE INTEGRIDAD DE BASE DE DATOS:<BR>
					El registro que desea insertar ya existe.
				<cfelseif NativeErrorCode IS 233 OR NativeErrorCode IS 515 OR NativeErrorCode IS 1400 OR NativeErrorCode IS -407>
					<!---	NOT NULL
						233 = sybase
						515 = sqlserver
						1400 = oracle
						-407 = db2
					--->
					ERROR DE INTEGRIDAD DE BASE DE DATOS:<BR>
					Se está intentando registrar un dato en blanco que no es permitido.
				<cfelseif NativeErrorCode IS 546 OR NativeErrorCode IS 2291 OR NativeErrorCode IS -530>
					<!---	FOREING KEY
						546 = sybase
						2291 = oracle
						-530 = db2
					--->
					ERROR DE INTEGRIDAD DE BASE DE DATOS:<BR>
					Se está intentando registrar un dato que no posee referencia en otra tabla.
				<cfelseif NativeErrorCode IS 547 OR NativeErrorCode IS 2292  OR NativeErrorCode IS -532>
					<!---	DEPENDENCIAS: DELETE SOBRE FOREING KEY
						547 = sybase
						2292 = oracle
						-532 = db2
					--->
					ERROR DE INTEGRIDAD DE BASE DE DATOS:<BR>
					El registro no puede ser eliminado, pues posee dependencias con otros datos.
				<cfelseif NativeErrorCode IS 548 OR NativeErrorCode IS 2290 OR NativeErrorCode IS -545>
					<!---	CHECK CONSTRAINT
						548 = sybase
						2290 = oracle
						-545 = db2
					--->
					ERROR DE INTEGRIDAD DE BASE DE DATOS:<BR>
					Se está intentando registrar un valor que no es permitido.
				<cfelseif NativeErrorCode IS 40000 >
					<cfset LvarMSG = HTMLEditFormat (REReplace(LvarMSG,'.*\]', '', 'one'))>
					<cfif find("&lt;br&gt;",LvarMSG)>
						<cfset LvarMSG = mid(LvarMSG,1,find("&lt;br&gt;",LvarMSG)-1)>
					</cfif>
					#LvarMSG#
				<cfelse>
					<cfset LvarPto = find("The error occurred on line ", LvarMSG)>
					<cfif LvarInfo AND LvarPto GT 0>
						#Replace(  (mid(LvarMSG,1,LvarPto-1)), "]", "]<br>", "all" )#
					<cfelse>
						#Replace(  (LvarMSG), "]", "]<br>", "all" )#
					</cfif>
				</cfif>
		  </td>
			<td>&nbsp;</td>
		</tr>
		</cfoutput>
		<tr> 
		</tr>	
		<tr> 
			<td>&nbsp;</td>
			<td colspan="2" valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lrborder" align="center">
				<cfoutput>
				<form action="" method="get" style="margin:0 ">
					<br/>	
					<input type="button" name="GoBack" value="#LB_Regresar#" class="btnAnterior" onClick="#HTMLEditFormat( BackAction )#">
				</form>
				</cfoutput>
			</td>
			<td>&nbsp;</td>
		</tr>
	
		<tr>
		  <td>&nbsp;</td>
		  <td colspan="2" align="center" valign="middle" nowrap bgcolor="#F5F5F5" class="contenido-lbrborder">&nbsp;</td>
		  <td>&nbsp;</td>
		</tr>
			<cfset DetalleExtra = data.detalle_extra>
			<cfif Find("Java Stack Trace:", DetalleExtra) GT 1>
				<cfset DetalleExtra = Mid(DetalleExtra , 1, Find("Java Stack Trace:", DetalleExtra)-1)>
			</cfif>
		 
			<cfset mailbody = DetalleExtra>
			<cfset ref = REFind('Template Stack Trace.*(?=<br id=tssend>)', data.detalle_extra, 1, True)>
			<cfset dex2 = "ref.pos1:" & ref.pos[1] & ", ref.len1:" & ref.len[1]>
			<cfif ref.pos[1] neq 0 >
				<cfset dex2 = Mid(DetalleExtra, ref.pos[1], ref.len[1])>
				<cfif Len(data.titulo)>
					<cfset dex2 = Replace(dex2,data.titulo,'')>
				</cfif>
				<cfset dex2 = Replace(dex2,'<br>',chr(13)&chr(10),'all')>
				<cfset dex2 = REReplace(dex2,'<[^>]+>','','all')>
			</cfif>
			<cfset mailbody = 
				"Reporte de error ocurrido el " & LSDateFormat(data.Cuando) & " " & LSTimeFormat(data.Cuando) & chr(13) & chr(10) &
				data.Titulo & chr(13) & chr(10) &
				 dex2>
				 
	<cfif LvarWithCode and LvarErrorDES NEQ "">
		<tr onClick="switchDetail('descrip')" style="cursor:pointer;"> 
			<td>&nbsp;</td>
			<td bgcolor="#003366" >
				<img src="/cfmx/home/public/error/arrow_dn.gif" width="17" height="17" id="descripflecha">
			</td>
			<td bgcolor="#003366" >
				<span style="color:white;font-family:Verdana, Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold">
					<cfoutput>#LB_DescripcionDelError#</cfoutput>
				</span>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" valign="middle" bgcolor="#F5F5F5" class="contenido-lbrborder" >
				<div style="width:747px;overflow:hidden;font-size:12px;word-break:break-all;word-wrap:break-word;display:inline" id="descrip">
					<BR><cfoutput>#LvarErrorDES#</cfoutput><BR><BR>
				</div>
			</td>
			<td>&nbsp;</td>
		</tr>
	</cfif>
	<cfif LvarWithCode>
		<tr onClick="switchDetail('acciones')" style="cursor:pointer;"> 
			<td>&nbsp;</td>
			<td bgcolor="#003366" >
				<img src="/cfmx/home/public/error/arrow_dn.gif" width="17" height="17" id="accionesflecha">
			</td>
			<td bgcolor="#003366" >
				<span style="color:white;font-family:Verdana, Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold">
					<cfoutput>#LB_AccionesATomar#</cfoutput>
				</span>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" valign="middle" bgcolor="#F5F5F5" class="contenido-lbrborder" >
			<div style="width:747px;overflow:hidden;font-size:12px;word-break:break-all;word-wrap:break-word;display:inline" id="acciones">
				<BR><cfoutput>#LvarErrorCOR#</cfoutput><BR><BR>
			</div></td>
			<td>&nbsp;</td>
		</tr>
	</cfif>
		<tr> 
			<td>&nbsp;</td>
			<!--- Se omite la tilde de "Núm" por "Num" para evitar problemas de locale/charset --->
			<td bgcolor="#0088A6" >
				<cfoutput>
				<a href="mailto:?subject=Error%20Num%20#Request.errorid#&body=#URLEncodedFormat(mailbody)#">
					<img src="/cfmx/home/public/error/arrow_rt.gif" width="17" height="17" border="0">
					</a>
				</cfoutput>
			</td>
			<td bgcolor="#0088A6" >
				<cfoutput>
				<a style="color:white;font-family:Verdana, Arial, Helvetica, sans-serif;font-size:12px;font-weight:bold"
					href="mailto:?subject=Error%20Num%20#Request.errorid#&body=#URLEncodedFormat(mailbody)#">
						#LB_EnviarReportePorCorreo# 
				</a>
				</cfoutput>
			</td>
			<td>&nbsp;</td>
		</tr>
	<cfif ListFind('0,1', error_detalles)>
		<!---
		<cfif LvarWithCode AND Len(DetalleExtra) GT 0>
			<cfset LvarPto = 0>
			<cfset LvarBuscar ="url:,form:,headers:,session:,Java Stack Trace:">
			<cfloop list="#LvarBuscar#" index="LvarBusca">
				<cfset LvarPto = find("<strong>#LvarBusca#",DetalleExtra)>
				<cfif LvarPto GT 0>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif LvarPto GT 0>
				<cfset DetalleExtraVer = "#left(DetalleExtra,LvarPto-1)#">
				<cfset DetalleExtra = mid(DetalleExtra,LvarPto,len(DetalleExtra))>
				<tr> 
					<td>&nbsp;</td>
					<td colspan="2" valign="middle" bgcolor="#F5F5F5" class="contenido-lbrborder" style="font-size:11px;">
					<cfset LvarPto = find("<br>",DetalleExtraVer)>
					<cfoutput>
						<cfset LvarPto = findNocase("<",DetalleExtraVer,5)>
						<strong>#mid(DetalleExtraVer,1,LvarPto-1)#</strong>
						#mid(DetalleExtraVer,LvarPto,len(DetalleExtraVer))#
					</cfoutput>
					</td>
					<td>&nbsp;</td>
				</tr>
			</cfif>
		</cfif>
		--->
		<tr onClick="switchDetail('extra')" style="cursor:pointer;"> 
			<td>&nbsp;</td>
			<td bgcolor="#0088A6" >

				  <img src="/cfmx/home/public/error/
				<cfif  error_detalles is 1 OR LvarInfo>
					arrow_rt.gif
				<cfelse>
					arrow_dn.gif
				</cfif>" width="17" height="17" id="extraflecha">
			</td>
			<td bgcolor="#0088A6" >
				<span style="color:white;font-family:Verdana, Arial, Helvetica,sans-serif;font-size:12px;font-weight:bold">
					<cfoutput>#LB_VerDetallesTecnicos#</cfoutput>
				</span>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			
			<td bgcolor="#F5F5F5">&nbsp;</td>
			<td colspan="1" valign="middle" bgcolor="#F5F5F5" class="contenido-lbr	order" >
			<div>&nbsp;</div>
				<div style=" width:747px;position:relative;overflow:hidden;font-size:11px;word-break:break-all;word-wrap:break-word;display:<cfif error_detalles is 0 AND NOT LvarInfo>inline<cfelse>none</cfif>" id="extra">
				<cfif Len(DetalleExtra) is 0>
				<cfoutput>#LB_NoHayDetallesTenicosParaEstemensaje#</cfoutput>.
				<cfelse><cfoutput>#DetalleExtra#</cfoutput></cfif>
				</div>
			</td>
			<td>&nbsp;</td>
		</tr>
	</cfif>
		<tr> 
			<td>&nbsp;</td>
			<td colspan="2" align="center" valign="middle" nowrap ><div align="center">&nbsp;</div></td>
			<td>&nbsp;</td>
		</tr>
	
		<tr> 
			<td>&nbsp;</td>
			<td colspan="2" align="center" valign="middle" nowrap ><div align="center">&nbsp;</div></td>
			<td>&nbsp;</td>
		</tr>
	
	</table>
	<script type="text/javascript">
	<!--
		function $(x) {
			return (document.all) ?
				document.all[x] :
				document.getElementById(x);
		}
		function switchDetail(LvarTipo) {
			var extra = $(LvarTipo);
			var extraflecha = $(LvarTipo+'flecha');
			extra.style.display = (extra.style.display == 'inline') ? 'none' : 'inline';
			extraflecha.src = (extra.style.display == 'inline') ? 
				'/cfmx/home/public/error/arrow_dn.gif' : '/cfmx/home/public/error/arrow_rt.gif';
		}
		//switchDetail();
	//-->
	</script>
<cf_templatefooter>

<cffunction name="_fnDisplayObtieneInformacionError" access="private" output="no">
	<!---Leer configuración de la pantalla de errores--->
	<!---
	error_detalles:
		indica si los detalles técnicos se muestran desde
		un inicio en la pantalla de errores, o si hay que hacer clic para ver
		los detalles técnicos.
	Valores válidos:
		0: Mostrar desde el inicio (Comportamiento default anterior)
		1: No mostrar en un inicio (Ocultar detalles técnicos de los usuarios)
		2: Según cfcatch.Type is Application (Actualmente no se almacena en MonErrores)
	--->
	<cfset error_detalles = 1>
	<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
	<cfset error_detalles = Politicas.trae_parametro_global("error.detalles")>
	<cfif Len(error_detalles) is 0>
		<cfset error_detalles = 1>
	</cfif>
	
	<cfif IsDefined('session.errorid')>
		<cfparam name="request.errorid" type="numeric" default="#session.errorid#">
	<cfelse>
		<cfparam name="request.errorid" type="numeric" default="0">
	</cfif>
	
	<cfif Request.errorid is 0>
	  <cfset data = QueryNew('errorid,titulo,detalle,detalle_extra,cuando')>
	  <cfset QueryAddRow(data)>
	  <cfset data.errorid = Request.errorid>
	  <cfset data.titulo = 'Reporte de error archivado'>
	  <cfset data.cuando = Now()>
	  <cfset data.detalle = 'El reporte de error con el n&uacute;mero solicitado ha sido archivado.<br />'
		& 'Por favor contacte al administrador del sistema para más información.'>
	<cfelse>
		<cfquery datasource="aspmonitor" name="data">
			select * from MonErrores
			where errorid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.errorid#">
		</cfquery>
		
		<cfif data.RecordCount is 0>
		  <cfset data = QueryNew('errorid,titulo,detalle,detalle_extra,cuando')>
		  <cfset QueryAddRow(data)>
		  <cfset data.errorid = Request.errorid>
		  <cfset data.titulo = 'Reporte de error archivado'>
		  <cfset data.cuando = Now()>
		  <cfset data.detalle = 'No se encuentra el reporte de error con el n&uacute;mero solicitado.<br />'
			& 'Por favor contacte al administrador del sistema para más información.'>
		</cfif>
	</cfif>
	<cfset NativeErrorCode = REReplace(data.titulo, "(^.*\[NativeErrorCode )|(\]$)", "",'all')>
	<cfset LvarPto = find("<strong>DataSource</strong>:", data.detalle_extra)>
	<cfif LvarPto EQ 0>
		<cfset LvarDS = "">
	<cfelse>
		<cfset LvarDS = mid(data.detalle_extra, LvarPto+29,20)>
		<cfset LvarDS = mid(LvarDS, 1, find("<",LvarDS)-1)>
		<cfif structKeyExists(application.dsinfo,LvarDS)>
			<cfset LvarDS = application.dsinfo[LvarDS].type>
		</cfif>
	</cfif>
	<!---
	<cfif isdefined('NativeErrorCode')>
		<cfdump var="#NativeErrorCode#">
	</cfif>
	--->	<cfif Not IsNumeric(NativeErrorCode)>
		<cfset NativeErrorCode = "">
	</cfif>
	
	<cfparam name="session.monitoreo.SScodigo" default="">
	<cfparam name="session.monitoreo.SMcodigo" default="">
	<cfparam name="session.monitoreo.SPcodigo" default="">
	
	<cfparam name="url.errSS" default="#session.monitoreo.SScodigo#">
	<cfparam name="url.errSM" default="#session.monitoreo.SMcodigo#">
	<cfparam name="url.errSP" default="#session.monitoreo.SPcodigo#">
	
	<cfif isdefined("url.ErrBacks")>
		<cfset request.Error.Backs = url.ErrBacks>
	</cfif>
	
	<cfquery datasource="asp" name="back">
		select SPhomeuri, SMhomeuri, SShomeuri
		from SSistemas s, SModulos m, SProcesos p
		where p.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.errSS#" null="#Len(url.errSS) IS 0#">
		  and p.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.errSM#" null="#Len(url.errSM) IS 0#">
		  and p.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.errSP#" null="#Len(url.errSP) IS 0#">
		  and m.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.errSS#" null="#Len(url.errSS) IS 0#">
		  and m.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.errSM#" null="#Len(url.errSM) IS 0#">
		  and s.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.errSS#" null="#Len(url.errSS) IS 0#">
	</cfquery>
	
	<cfif IsDefined("Request.Error.URL") and Len(Request.Error.URL)>
		<cfset BackAction = "location.href='" & JSStringFormat(Request.Error.URL) & "'">
	<cfelseif IsDefined("Request.Error.Backs") and IsNumeric(Request.Error.Backs)>
		<cfset BackAction = "history.go(-#Abs(Request.Error.Backs)#);">
	<cfelseif Len(back.SPhomeuri) GT 1>
		<cfset BackAction = "location.href='" & JSStringFormat("/cfmx" & back.SPhomeuri) & "'">
	<cfelseif Len(back.SMhomeuri) GT 1>
		<cfset BackAction = "location.href='" & JSStringFormat("/cfmx" & back.SMhomeuri) & "'">
	<cfelseif Len(back.SShomeuri) GT 1>
		<cfset BackAction = "location.href='" & JSStringFormat("/cfmx" & back.SShomeuri) & "'">
	<cfelseif Len(url.errSS)>
		<cfset BackAction = "location.href='" & JSStringFormat("/cfmx/home/menu/proceso.cfm?s=" & url.errSS & "&m=" & url.errSM & "&p=" & url.errSP) & "'">
	<cfelse>
		<cfset BackAction = "history.go(-1);">
	</cfif>
	
	<cfset LvarWithCode = (findNocase("ErrorCode: ",data.detalle) EQ 1)> 
	<cfif LvarWithCode>
		<cfset LvarErrorCOD = mid(data.detalle,12,20)>
		<cfset LvarErrorCOD = mid(LvarErrorCOD,1,find("<",LvarErrorCod)-1)>
			<cftry>
				<!---- se agrega la lógica para seleccionar los cambios entre idiomas----->
				<cfset suf=''>
				<cfif isDefined("session.idioma") and findnocase('en',session.idioma)><!---- idioma ingles---->
					<cfset suf='_en'>
				</cfif>
				<cf_jdbcquery_open name="rsSQL" datasource="sifcontrol">
					<cfoutput>
					select
						CERRcod,
						coalesce(CERRmsg#suf#,CERRmsg) as CERRmsg,
						CERRdes#suf# as CERRdes,
						CERRcor#suf# as CERRcor,
						CERRref
					 from CodigoError
					where CERRcod = #LvarErrorCOD#
					</cfoutput>
				</cf_jdbcquery_open>

				<cfset LvarErrorDES = "">
				<cfset LvarErrorCOR = "">
				<cfoutput query="rsSQL">
					<cfset LvarErrorDES = CERRdes>
					<cfset LvarErrorCOR = CERRcor>
				</cfoutput>
				<cfif isDefined("error.RootCause.Detail") and len(trim(error.RootCause.Detail))>
					<cfset LvarErrorDES = error.RootCause.Detail>	
				</cfif>
				<cf_jdbcquery_close>
			<cfcatch type="any">
				<cf_jdbcquery_close>
				<cfrethrow>
			</cfcatch>
			</cftry>
		<cfif not len(trim(LvarErrorCOR))>
			<cfset LvarErrorCOR = LB_NoSeHanRegistradoAccionesCorrectivasATomar>
		</cfif>
		<cfset data.detalle = mid(data.detalle,find(">",data.detalle)+1,255)>
	</cfif>
	<cfset LvarToUser = isdefined("error.rootCause.type") AND ucase("toUser") EQ error.rootCause.type>
	<cfif LvarToUser OR LvarWithCode>
		<cfset LvarInfo		= true>
		<cfset LvarTitle	= LB_MensajeDeErrorParaElUsuario>
		<cfset LvarIMG		= "warning.png">
		<cfset LvarColor	= "##ff4d4d">
		<cfif not isdefined("request.error")>
			<cfset BackAction	= "history.go(-1);">
		</cfif>
		<cfif data.detalle EQ "" OR LvarWithCode>
			<cfset LvarMSG		= data.detalle>
		<cfelse>
			<cfset LvarMSG		= data.detalle_extra>
		</cfif>
	<cfelse>
		<cfset LvarInfo		= false>
		<cfset LvarTitle	= LB_ReporteDeError>
		<cfset LvarIMG		= "Stop01_T.gif">
		<cfset LvarColor	= "##ff4d4d">
		<cfset LvarMSG		= data.detalle>
	</cfif>
</cffunction>