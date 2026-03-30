
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<title>Untitled Document</title>
</head>
<!--- Style para que los botones sean de colores --->
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">

<body style="margin:0" onload="resize_parent()">

<cfinclude template="../portlet/ventanilla_sql.cfm">

<cfif isdefined("url.identificacion_persona") and not isdefined("form.identificacion_persona")>
	<cfparam name="form.identificacion_persona" default="#url.identificacion_persona#">
</cfif>
<cfif isdefined("url.id_tipoident") and not isdefined("form.id_tipoident")>
	<cfparam name="form.id_tipoident" default="#url.id_tipoident#">
</cfif>


<cfset frame_height = 130>
<cfif isdefined("url.identificacion_persona") and Len(Trim(url.identificacion_persona)) GT 0>
	<cfset frame_height = 750>
</cfif>
<script type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function resize_parent(){
		if (window.parent && document.all) {
			// usar solamente en Internet Explorer
			var nw_height = document.body.parentNode.scrollHeight;
			var fr = window.parent.document.getElementById('iframe_gestion');
			if (fr) {
				//fr.height = nw_height;
				fr.style.height = nw_height + "px";
			}
		}
	}
</script>

	<cfif isdefined("url.id_tramite") and len(trim(url.id_tramite))>
		<cfquery name="infoTramite" datasource="#session.tramites.dsn#">
			select codigo_tramite, nombre_tramite
			from TPTramite
			where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
		</cfquery>
	</cfif>

<table width="540" border="0" align="center">
	<tr><td colspan="3">

		<cfoutput>
		<cfquery name="tipoidentificacion" datasource="#session.tramites.dsn#">
			select id_tipoident, codigo_tipoident, nombre_tipoident 
			from TPTipoIdent
		</cfquery>


		<form name="form1" action="" method="get" style="margin:0;" onSubmit="return validar_form1(this);">
		<input type="hidden" name="loc" value="gestion">
		<cfif isdefined("url.id_instancia") and len(trim(url.id_instancia))>
			<input type="hidden" name="id_instancia" value="<cfoutput>#url.id_instancia#</cfoutput>">
		</cfif>
		<table border="0" cellpadding="5" cellspacing="0" width="520">
			<tr>
				<td valign="top">

					<table width="510" cellpadding="2" cellspacing="0">
						<tr>
							<td colspan="3" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong>Informaci&oacute;n de Tr&aacute;mites </strong></td>
						</tr> 
						<tr>
							<td colspan="3" align="center">
								Seleccione uno de los tr&aacute;mites de la siguiente lista , 							   
								 para ver su detalle.
							</td>
						</tr>
						
						
						

						<tr>
							<td >&nbsp;</td>
							<td colspan="2">
							</td>
						</tr>
						
					<cfinvoke component="home.tramites.componentes.tramites"
						method="permisos_obj"
						id_funcionario="#session.tramites.id_funcionario#"
						tipo_objeto="T"
						returnvariable="tramites_validos" >
					</cfinvoke>
						
						<cfquery name="rsLista" datasource="#session.tramites.dsn#">
							select id_tramite, codigo_tramite, nombre_tramite 
							from TPTramite
							<cfif Len(tramites_validos)>
							where id_tramite in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#tramites_validos#" list="yes">)
							<cfelse>
							where 1=0
							</cfif>
							order by id_tipotramite
						</cfquery>
						<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="codigo_tramite,nombre_tramite"/>
							<cfinvokeargument name="etiquetas" value="C&oacute;digo, nombre"/>
							<cfinvokeargument name="formatos" value="S,S"/>
							<cfinvokeargument name="align" value="left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="info_tramite-form.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="id_tramite"/>
							<cfinvokeargument name="formname" value="form1"/> 
							<cfinvokeargument name="funcion" value="infoTramite"/>
							<cfinvokeargument name="fparams" value="id_tramite"/> 
						</cfinvoke>
			
						<!--- <cfloop query="combotramite">
							<tr>
								<td colspan="2">
								<a href="javascript:infoTramite(#id_tramite#)">
									#trim(HTMLEditFormat(codigo_tramite))# - #HTMLEditFormat(nombre_tramite)#
								</a>
								</td>
							</tr>

						</cfloop> --->

						<tr>
							<td colspan="2" align="center">
								<input type="button" value="Volver" class="boton" onclick="location.href='/cfmx/home/tramites/Operacion/ventanilla/buscar-form.cfm'">
							</td>
						</tr>	
						
					</table>

				</td>
			</tr>
			
			
		</table>

		</form>
		</cfoutput>
	</td></tr>
		
	
	

	<script language="javascript1.2" type="text/javascript">
				
		function infoTramite(tramite) {
			var params ="";
			params = "?id_tramite="+tramite;
			popUpWindow("/cfmx/home/tramites/Operacion/gestion/infoTramite.cfm"+params,250,200,650,400);
		}
		
		
	</script>
</table>


</body>
</html>
