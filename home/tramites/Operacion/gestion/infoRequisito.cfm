<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Informaci&oacute;n De Requisitos</title>
</head>

<body>
	<cf_templatecss>
	
<style type="text/css">
	.tituloMantenimiento2 {
		font-weight: bolder;
		text-align: center;
		vertical-align: middle;
		font-size: small;
		padding: 2px;
		background-color: #CCE3F8;
		border: 1px solid #356595;
	}	
</style>	
	

	<!--- FALTA filtrar por el id_tramite --->
	<cfquery name="data" datasource="#session.tramites.dsn#">
		select r.id_requisito, 
			   r.codigo_requisito, 
			   r.nombre_requisito, 
			   r.descripcion_requisito, 
			   t.codigo_tramite, 
			   t.nombre_tramite 
		from TPRequisito r
		
		left outer join TPRReqTramite rt
		on rt.id_requisito = r.id_requisito
		and rt.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
		
		left outer join TPTramite t
		on t.id_tramite = rt.id_tramite
		and t.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
		
		where r.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">
	</cfquery>
	
	<cfquery name="docs" datasource="#session.tramites.dsn#">
		select rd.nombre_archivo,
			   rd.tipo_mime, 
			   contenido,
			   resumen
		from TPRequisitoDoc rd	   
 		where rd.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">
	</cfquery>
	
	<table width="100%" cellpadding="4" cellspacing="0" >
		<tr><td class="tituloMantenimiento2" colspan="3"><font size="2">Informaci&oacute;n de Requisitos</font></td></tr>
		<cfoutput>
		<tr><td  colspan="3"><font size="2"><strong>Tr&aacute;mite:</strong> #trim(data.codigo_tramite)#-#data.nombre_tramite#</font></td></tr>
		<tr><td  colspan="3"><font size="2"><strong>Requisito:</strong> #trim(data.codigo_requisito)#-#data.nombre_requisito#</font></td></tr>
		<cfif len(data.descripcion_requisito) >
		<tr><td  colspan="3" style="padding-bottom:0px;"><font size="2"><strong>Descripci&oacute;n:</strong></font></td></tr>
		<tr><td  colspan="3"><font size="2">#trim(data.descripcion_requisito)#</font></td></tr>
		</cfif>
		</cfoutput>
		
		<cfif docs.recordcount gt 0 >
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="3" class="tituloMantenimiento2"><font size="2">Lista de Documentaci&oacute;n adicional</font></td></tr>
			<cfoutput query="docs">
				<tr>
					<td width="1%" valign="top"><img src="/cfmx/home/tramites/images/download.bmp"></td>
					<td width="30%" valign="top"><font size="2"><a href="##">#docs.nombre_archivo#</a></font></td>
					<td valign="top"><font size="2">#docs.resumen#</font></td>
				</tr>
			</cfoutput>
		</cfif>
		<tr><td colspan="3" class="subTitulo">&nbsp; </td></tr>
		<tr>
			<td colspan="3" >
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr>
						<td width="1%" valign="middle"><a href="javascript: window.close();"><img border="0" src="/cfmx/home/tramites/images/cerrar.gif"></a></td>
						<td valign="middle"><a href="javascript: window.close();"><FONT color="#003399">cerrar ventana</FONT></a></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>