<cfsetting enablecfoutputonly="yes">
<cfif isdefined('url.LvarGenera') and LvarGenera eq 'true'>
	<cfset LvarReporte = "#GetTempDirectory()#ReporteInventarios_#dateformat(now(),'dd_mm_yyy')#_#hour(now())#.xls">
	<cfset generaReporte()>
	<cfcontent type="application/vnd.ms-excel" file="#LvarReporte#" deletefile="yes">
	<cfheader name="Content-Disposition" value="attachment; filename=ReporteInventarios_#dateformat(now(),'dd-mm-yyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls">
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
</cfif>

<cffunction name="generaReporte" output="no">

	<cfquery datasource="#session.DSN#" name="rsArticulo" maxrows="10000"><!--- 14000 --->
			select 
			c.cuentac as objetoGasto,	
			p.FPPAPrecio as precio_estimado,
	      a.Aestado,
			(case when Aestado = 1 then 'Activo' when Aestado = 0 then 'Inactivo' else ' ' end) as Estado,
			a.Acodigo as CodArticulo, 
			b.Udescripcion as Unidad, 
			c.Cdescripcion as Clasificacion, 
			a.Adescripcion as Articulo, 
			e.Bdescripcion as Bodega, 
			f.Odescripcion as Oficina, 
			d.Eestante as Estante, 
			d.Ecasilla as Casilla, 
			coalesce(d.Eexistencia,0.00) as Existencia, 
			coalesce(d.Ecostou,0.00) as Costou, 
			coalesce(d.Ecostototal,0.00) as CostoTotal 
		from Almacen e 
       inner join Oficinas f 
            on f.Ecodigo = e.Ecodigo 
			and f.Ocodigo = e.Ocodigo
        inner join Existencias d
            on d.Alm_Aid = e.Aid 
        inner join Articulos a
            on a.Ecodigo = d.Ecodigo 
				and a.Aid = d.Aid 
        left outer join FPPreciosArticulo p
            on p.Aid = a.Aid
            and p.CPPid = #url.CPPid#            
        inner join Clasificaciones c
            on c.Ecodigo = a.Ecodigo 
			and c.Ccodigo = a.Ccodigo 
        inner join Unidades b
			on b.Ecodigo = a.Ecodigo 
			and b.Ucodigo = a.Ucodigo 
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Bdescripcion, Odescripcion, Cdescripcion, Adescripcion
</cfquery>

<cfset generaHTML()>
</cffunction>

<cffunction name="write_to_buffer" output="no">
	<cfargument name="contents" type="string" required="yes">
	<cfset bufferAjax.append(JavaCast("string", Arguments.contents))>
</cffunction>
	
<cffunction name="write_to_file" output="no">
	<cfargument name="action" type="string" default="append">

	<cffile action	= "#arguments.action#" 
			file	= "#LvarReporte#" 
			output	= "#bufferAjax.toString()#"
	>
	<cfset bufferAjax.setLength(0)>
</cffunction>

<cffunction name="generaHTML" output="no">
	<cfobject type = "Java"	action = "Create" class = "java.lang.StringBuffer" name = "bufferAjax">
	<cfset write_to_buffer('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"')>
	<cfset write_to_buffer('	"http://www.w3.org/TR/html4/loose.dtd">')>
	<cfset write_to_buffer('<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">')>
	<cfset write_to_buffer('	<head>')>
	<cfset write_to_buffer('		<title>Consulta Reporte de Recuperados</title>')>
	<cfset write_to_buffer('		<style type="text/css">')>
	<cfset write_to_buffer('			table')>
	<cfset write_to_buffer('			{mso-displayed-decimal-separator:"\.";')>
	<cfset write_to_buffer('			mso-displayed-thousand-separator:"\,";}')>
	<cfset write_to_buffer('			.numWithoutDec {mso-number-format:\##\,\##\##0?;text-align:right;}')>
	<cfset write_to_buffer('			.numWith2Dec {mso-number-format:Standard;text-align:right}')>
	<cfset write_to_buffer('			.date {mso-number-format:dd\/mm\/yyyy\;\@}')>
	<cfset write_to_buffer('		</style>')>
	<cfset write_to_buffer('		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">')>
	<cfset write_to_buffer('		<meta http-equiv="content-language" content="es" />')>
	<cfset write_to_buffer('	</head>')>
	<cfset write_to_buffer('	<table>')>
	<cfset write_to_file('write')>		
	
	<cfset write_to_buffer('		<tr>')>
	<cfset write_to_buffer('			<td colspan="10">&nbsp;</td>')>
	<cfset write_to_buffer('		</tr>')>
	
	<cfset write_to_buffer('		<tr>')>
	<cfset write_to_buffer('			<td align="left" nowrap="nowrap"><strong>C&oacute;digo del Art&iacute;culo</strong></td>')>
	<cfset write_to_buffer('			<td align="left" nowrap="nowrap"><strong>Art&iacute;culo</strong></td>')>
	<cfset write_to_buffer('			<td align="left"><strong>Unidad</strong></td>')>
	<cfset write_to_buffer('			<td align="left"><strong>Estado</strong></td>')>
	
	<cfset write_to_buffer('			<td align="left"><strong>Clasificaci&oacute;n</strong></td>')>
	<cfset write_to_buffer('			<td align="left"><strong>Objeto de Gasto</strong></td> ')>
	<cfset write_to_buffer('			<td align="left"><strong>Costo Unitario(seg&uacute;n Inventario)</strong></td>')>
	<cfset write_to_buffer('			<td align="left"><strong>Precio Unitario(Estimaci&oacute;n Presupuestal)</strong></td>')>
	<cfset write_to_buffer('		</tr>')>
	<cfset write_to_file()>
			
			<cfloop query="rsArticulo">
				<cfset write_to_buffer('<tr>')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="left">#rsArticulo.CodArticulo#</td>')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="left">#rsArticulo.Articulo#</td>')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="left">#rsArticulo.Unidad#</td>')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="left">#rsArticulo.Estado#</td>')>
				
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="left">#rsArticulo.Clasificacion#</td>')>
				<cfset write_to_buffer('	<td x:str style="font-size:12px" align="left">#rsArticulo.objetoGasto#</td>')>
				<cfset write_to_buffer('	<td x:numWith2Dec style="font-size:12px" align="right">#LSNumberFormat(rsArticulo.Costou,',9.00')#</td>')>
				<cfset write_to_buffer('	<td x:numWith2Dec style="font-size:12px" align="right">#LSNumberFormat(precio_estimado, ',9.00')#</td>')>
				<cfset write_to_buffer('</tr>')>
				<cfset write_to_file()>
			</cfloop>
			
			<cfset write_to_buffer('<tr>')>
			<cfset write_to_buffer(' <td>&nbsp;</td>')>
			<cfset write_to_buffer('</tr>')>
		<cfset write_to_buffer('</table>')>
		<cfset write_to_file()>
</cffunction>
