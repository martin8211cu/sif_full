<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Material Did&aacute;ctico</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
.TxtNormal {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 11;
    margin: 0px;
    padding: 1px;
}
.BoxNormal {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 11;
    margin: 0px;
    padding: 1px;
    background-color: #E6E6E6;
}
.HdrNormal {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 11;
    margin: 0px;
    padding: 0px;
    border: 0px solid;
}
.CeldaTxt {
    text-indent: -9;
    margin-left: 12;
    margin-right: -4;
    margin-top: 0;
    margin-bottom: 0;
}
.CeldaHdr {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 14;
    font-weight:bold;
    color: #E6E6E6;
    background-color: #666666;
    vertical-align: middle;
    border-right: 1px solid;
    border-top: 1px solid;
    margin: 0px;
    padding: 1px;
    text-align: center;
}
.CeldaNoCurso {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: normal;
    background-color: #E6E6E6;
    vertical-align: top;
    border-right: 1px solid;
    border-top: 1px solid;
    margin: 0px;
    padding: 1px;
}
.CeldaCurso {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: normal;
    background-color: #C0C0C0;
    vertical-align: top;
    border-right: 1px solid;
    border-top: 1px solid;
    margin: 0px;
    padding: 1px;
}
.CeldaFeriado {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: normal;
    background-color: #E6E6E6;
	vertical-align: top;
	border-right: 1px solid;
	border-top: 1px solid;
	margin: 0px;
	padding: 1px;
	color: #CC0000;
}
.CeldaRef {
    text-decoration:none; 
    color:#000000; 
    font-size: 10px;
    font-weight: normal;
}
.CeldaFechaRef {
    text-decoration:none; 
    color:#000000; 
    font-size: 11px;
    font-weight: normal;
}
.LinPar {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: normal;
    background-color: #E6E6E6;
    text-align: left;
    vertical-align: top;
    border: 0px;
    margin: 0px;
    padding: 1px;
}
.LinImpar {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: normal;
    background-color: #C0C0C0;
    text-align: left;
    vertical-align: top;
    border: 0px;
    margin: 0px;
    padding: 1px;
}
-->
</style>


</head>
<body style="background-color: #E6E6E6">
<cfif isdefined("Url.tipo") and not isdefined("Form.tipo")>
	<cfparam name="Form.tipo" default="#Url.tipo#">
</cfif>
<cfif isdefined("Url.documento") and not isdefined("Form.documento")>
	<cfparam name="Form.documento" default="#Url.documento#">
</cfif>

<cfif isdefined("Url.id_atributo") and not isdefined("Form.id_atributo")>
	<cfparam name="Form.id_atributo" default="#Url.id_atributo#">
</cfif>
<cfif isdefined("Url.tipo_atributo") and not isdefined("Form.tipo_atributo")>
	<cfparam name="Form.tipo_atributo" default="#Url.tipo_atributo#">
</cfif>

<cfif isdefined("Url.id_valor") and not isdefined("Form.id_valor")>
	<cfparam name="Form.id_valor" default="#Url.id_valor#">
</cfif>

<cfif isdefined("form.documento") and len(trim(form.documento)) neq 0 >
	<cfquery datasource="#Session.Edu.DSN#" name="rsMADocumento">
		select convert(varchar,a.id_tipo) as id_tipo,  convert(varchar,a.id_documento) as id_documento,
			a.titulo, a.resumen, convert(varchar,a.fecha,103) as fecha , a.autor, a.contenido, a.tipo_contenido, a.nom_archivo ,
			b.nombre_tipo
		from MADocumento a, MATipoDocumento b
		where a.id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.documento#">
		<cfif isdefined("form.tipo") and len(trim(form.tipo)) neq 0 and form.tipo NEQ "-1">
			and a.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.tipo#">
		</cfif> 
		and a.id_tipo = b.id_tipo
	</cfquery>
</cfif>
<cfif isdefined("form.documento") and len(trim(form.documento)) neq 0 >
	<cfquery datasource="#Session.Edu.DSN#" name="rsMAAtributoDocumento">
		select convert(varchar,MAAD.id_documento) as id_documento
			, convert(varchar,MAAD.id_atributo) as id_atributo
			, convert(varchar,MAAD.id_valor) as id_valor
			, valor
			, nombre_atributo
			, tipo_atributo
		from MAAtributoDocumento MAAD, MAAtributo MAA
		where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.documento#">
		  and MAAD.id_atributo = MAA.id_atributo 
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsDocumentoMateriaTipo">
		select convert(varchar,MT.MTcodigo) as MTcodigo, MT.MTdescripcion
		from MateriaTipo MT, DocumentoMateriaTipo DMT
			where MT.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  and DMT.id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.documento#">
			  and MT.MTcodigo = DMT.MTcodigo
	</cfquery>
	<cfif  #rsMAAtributoDocumento.tipo_atributo# EQ 'V' >
		<cfquery datasource="#Session.Edu.DSN#" name="rsMAValorAtributo">
			select convert(varchar,id_valor) as id_valor,  convert(varchar,id_atributo) as id_atributo,
				contenido, orden_valor
			from MAValorAtributo
			where id_valor = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMAAtributoDocumento.id_valor#">  
			  and id_atributo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMAAtributoDocumento.id_atributo#">  
		</cfquery>
	</cfif>
</cfif>

<cfif isdefined("form.tipo") and len(trim(form.tipo)) neq 0 >
	<cfquery datasource="#Session.Edu.DSN#" name="rsMATipoDocumento">
		select convert(varchar,id_tipo) as id_tipo,  convert(varchar,id_biblioteca) as id_biblioteca,
			nombre_tipo
		from MATipoDocumento 
		where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMADocumento.id_tipo#">  
	</cfquery>
</cfif>
<cfquery datasource="#Session.Edu.DSN#" name="rsMAAtributo">
	select convert(varchar,id_atributo) as id_atributo,  nombre_atributo,
		tipo_atributo, orden_atributo
	from MAAtributo 
	where id_atributo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMAAtributoDocumento.id_atributo#">
</cfquery>
<script language="JavaScript" src="BusquedaMaterial_00.js"></script>
<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">
<link href="../css/edu.css" rel="stylesheet" type="text/css">
<form name="frmConsulta" method="POST" action="ConlisBusquedaMaterial.cfm" >
<cfoutput>
<cfif not isdefined("Url.ver") or (isdefined("Url.ver") and #Url.ver# EQ 'NO')>
	<cfif rsMADocumento.Recordcount NEQ 0>
		<cfset t_atributo = ''>
		<cfset contenido = ''>
		<cfset filas = 0> <!--- Es para controlar el numero de filas en el atributo --->
		
    <table width="100%" border="0" cellpading="0" cellspacing="0" class="TxtNormal">
      <cfloop query="rsMADocumento">
        <tr> 
          <td colspan="6"> 
		  	<cfif #rsMADocumento.tipo_contenido# EQ 'L' >
			  <cfset filas = 5 + #rsMAAtributoDocumento.RecordCount#>
			<cfelse>
			  <cfset filas = 4 + #rsMAAtributoDocumento.RecordCount#>
			</cfif>
            <input type="hidden" name="documento"  value="<cfif isdefined("form.documento")>#form.documento#</cfif>">	
            <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;"> 
                <font size="3">#rsMADocumento.titulo#</font> 
            </div></td>
        </tr>
        <tr> 
         <cfif #rsMADocumento.tipo_contenido# EQ 'I'  or #rsMADocumento.tipo_contenido# EQ 'D' or #rsMADocumento.tipo_contenido# EQ 'L' or #rsMADocumento.tipo_contenido# EQ 'T' >
          <cfset id_doc = " #Url.documento# ">
          <cfif #form.tipo# NEQ -1>
            <cfset tipo_doc = " and id_tipo = #form.tipo# ">
            <cfelse>
            <cfset tipo_doc = "">
          </cfif>
          <cfset contenido = #rsMADocumento.tipo_contenido#>
		  <cfif #rsMADocumento.tipo_contenido# EQ 'I'  >
          <td width="12%" rowspan="#filas#" valign="top"> 
            <a href="/cfmx/edu/responsable/ConlisBusquedaMaterial.cfm?ver=SI&documento=#form.documento#&tipo=#form.tipo#"><!--- <cf_Educleerimagen Tabla="MADocumento" border="false" ruta="/cfmx/edu/Utiles/sifleerimagencont.cfm" Campo="contenido" Condicion="id_documento=#id_doc# #tipo_doc# " Conexion="#Session.Edu.DSN#" autosize="false" height="100"> ---><cf_LoadImage tabla="MADocumento" columnas="contenido, id_documento as codigo" condicion="id_documento=#id_doc# #tipo_doc# " imgname="Material" height="100"></a><br>Haga click en la imagen para ver tamaño real 
          </td>
          <cfelseif #rsMADocumento.tipo_contenido# EQ 'D'  >
          <td width="12%" rowspan="#filas#" valign="top" align="center"><a href="/cfmx/edu/Utiles/downloadMA.cfm?cod=#form.documento#"><img border='0' alt='Descargar Documento' src='/cfmx/edu/Imagenes/documento.gif'><br>Descargar Documento
            </a> </td>
          <cfelseif #rsMADocumento.tipo_contenido# EQ 'L'  >
          <td width="12%" rowspan="#filas#" valign="top" align="center"><a href="#rsMADocumento.nom_archivo#" ><img src="/cfmx/edu/Imagenes/web.gif" alt="Visitar Link" border="0" align="baseline"><br>Visitar Link</a> 
          </td>
          <cfelseif #rsMADocumento.tipo_contenido# EQ 'T'  >
          <td  colspan="6" style="border: 1px solid ##000000"> 
           #rsMADocumento.resumen# </td>
        </tr>
		</cfif>
        <tr> 
          <td nowrap><strong>Tipo de Documento:</strong></td>
          <td colspan="4" nowrap>#rsMADocumento.nombre_tipo#</td>
        </tr>
        <tr>
          <td width="9%" nowrap><strong>Tipo de Materia:</strong></td>
          <td colspan="4" nowrap>#rsDocumentoMateriaTipo.MTdescripcion#</td>
        </tr>
		<cfif rsMADocumento.tipo_contenido EQ 'L'>
			<tr> 		
				<td nowrap><strong>Liga de Referencia:</strong></td>
				<td colspan="4" nowrap><a href="#rsMADocumento.nom_archivo#">#rsMADocumento.nom_archivo#</a></td>
			</tr>
        </cfif>
        <tr> 
        <td colspan="6"> </td>
        </tr>
        <cfloop query="rsMAAtributoDocumento">
          <tr> 
            <td nowrap> <strong>#rsMAAtributoDocumento.nombre_atributo#</strong>: </td>
            <td colspan="4" nowrap> <cfif rsMAAtributo.tipo_atributo EQ 'V'>
                #rsMAValorAtributo.contenido# 
                <cfelse>
                #rsMAAtributoDocumento.valor# </cfif> 
            </td>
          </tr>
        </cfloop>
        </cfif>
      </cfloop>
      <tr> 
        <td  colspan="6"> <div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">&nbsp;</div></td>
      </tr>
      <tr> 
        <td colspan="6" align="center"><input name="btnSalir" type="submit" value="Salir" onClick="javascript: window.close();"> 
        </td>
      </tr>
    </table>
	<cfelse>
		<table width="100%" border="0" cellspacing="0"> 			
				<tr> 
					<td colspan="5" class="subTitulo" ><div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;">No existen documentos</div></td>
				</tr>
				<tr> 
					<td colspan="5" align="center"><div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;"> ------------------ 1 - La materia solicitada no tiene documentos en esta biblioteca  ------------------ </div></td>
				</tr>
				<tr> 
					<td colspan="5" align="center"><div class="CeldaHdr" style="border-top:1px solid ##E6E6E6;"> ------------------ Fin de la Consulta ------------------ </div></td>
				</tr>
			</table>
	</cfif>
<cfelse>
	<cfif #rsMADocumento.tipo_contenido# EQ 'I' and isdefined("Url.ver")>
		<cfset id_doc = " #Url.documento# ">
		<cfif #form.tipo# NEQ -1>
			<cfset tipo_doc = " and id_tipo = #form.tipo# ">
		<cfelse>
			<cfset tipo_doc = "">
		</cfif>
		<table width="100%" border="0" cellspacing="0"> 			
			<tr>
				<td  align="center" width="12%" rowspan="5" ><a href="/cfmx/edu/responsable/ConlisBusquedaMaterial.cfm?ver=NO&documento=#form.documento#&tipo=#form.tipo#"><!--- <cf_Educleerimagen Tabla="MADocumento" ruta="/cfmx/edu/Utiles/sifleerimagencont.cfm" Campo="contenido" Condicion="id_documento=#id_doc# #tipo_doc# " Conexion="#Session.Edu.DSN#" autosize="true" > ---> <cf_LoadImage tabla="MADocumento" columnas="contenido, id_documento as codigo" condicion="id_documento=#id_doc# #tipo_doc# " imgname="Material"></a> 
				</td>
			</tr>		
		</table>
	</cfif>
</cfif>
</cfoutput>
</form>
</body>
</html>
