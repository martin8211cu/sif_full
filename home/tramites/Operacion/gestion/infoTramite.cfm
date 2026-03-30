<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Informaci&oacute;n De Tr&aacute;mites</title>
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
		select t.id_tramite, 
			   t.codigo_tramite, 
			   t.nombre_tramite, 
			   t.descripcion_tramite 
		from TPTramite t
		where t.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">		
	</cfquery>
	
	<cfquery name="docs" datasource="#session.tramites.dsn#">
		select td.nombre_archivo,
			   td.tipo_mime, 
			   td.contenido,
			   td.resumen
		from TPTramiteDoc td
 		where td.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
	</cfquery>

	
	<cfquery name="reqs" datasource="#session.tramites.dsn#">
		select rq.nombre_requisito,
			   rq.codigo_requisito,
			   r.numero_paso,
			   rq.descripcion_requisito,
			   rq.id_requisito
		from TPRequisito rq
			join TPRReqTramite r
				on r.id_requisito = rq.id_requisito
 		where r.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
		order by r.numero_paso
	</cfquery>
	
	<table width="100%" cellpadding="4" cellspacing="0" >
		<tr>
		  <td class="tituloMantenimiento2" colspan="2"><font size="2">Informaci&oacute;n del Tr&aacute;mite</font></td>
		</tr>
		<cfoutput>
		<tr><td  colspan="2"><font size="2"><strong>Tr&aacute;mite:</strong> #trim(data.codigo_tramite)#-#data.nombre_tramite#</font></td></tr>
		<cfif len(data.descripcion_tramite) >
		<tr><td  colspan="2" style="padding-bottom:0px;"><font size="2"><strong>Descripci&oacute;n:</strong></font></td></tr>
		<tr><td  colspan="2"><font size="2">#trim(data.descripcion_tramite)#</font></td></tr>
		</cfif>
		</cfoutput>
		
		<cfif docs.recordcount gt 0 >
			<tr><td>&nbsp;</td></tr>
			<tr><td  colspan="2" class="tituloMantenimiento2"><font size="2">Lista de Documentaci&oacute;n adicional</font></td></tr>
			<cfoutput query="docs">
				<tr>
					<td width="30%" valign="top"><font size="2"><a href="##">#docs.nombre_archivo#</a></font></td>
					<td valign="top"><font size="2">#docs.resumen#</font></td>
				</tr>
			</cfoutput>
		</cfif>


		
		<cfif reqs.recordcount gt 0 >
			<tr><td>&nbsp;</td></tr>
			<tr><td  colspan="2" class="tituloMantenimiento2"><font size="2">Requisitos del Tr&aacute;mite</font></td></tr>
			<tr><td colspan="2"><table width="100%" border="0">
			<cfoutput query="reqs">
				<tr>
					<td width="10%" valign="top"><font size="2">#CurrentRow#</font></td>
					<td valign="top"><a href="infoRequisito.cfm?id_tramite=#id_tramite#&id_requisito=#id_requisito#">
						<font size="2"><strong>#nombre_requisito#</strong></font></a></td>
				</tr>
				<cfif Len(Trim(descripcion_requisito)) GT 0 and Trim(descripcion_requisito) NEQ '&nbsp;'>
				<tr>
					<td></td>
					<td valign="top">#descripcion_requisito#</td>
				</tr>
				</cfif>
			</cfoutput>
			</table></td></tr>
		</cfif>
		
		<tr><td colspan="2" class="subTitulo">&nbsp; </td></tr>
		<tr>
			<td colspan="2" >
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