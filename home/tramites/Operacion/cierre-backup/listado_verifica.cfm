<!--- 
	Creado por Gustavo Fonseca Hernández.
		Fecha: 10-8-2005.
		Motivo: Nuevo porlet de Cierre de trámites.
 --->
<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Verificaci&oacute;n de Tr&aacute;mites por Cerrar</title>
<cf_templatecss>
</head>
<!--- Style para que los botones sean de colores --->
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">

<body style="margin:0">


<cfquery name="rsLista" datasource="#session.tramites.dsn#">
	select 
		p.identificacion_persona as cedula,
		substring((rtrim(p.nombre) || ' ' || rtrim(p.apellido1) || ' '  || rtrim(p.apellido2)),1,25) as nombre,
		rtrim(t.nombre_tramite) as tramite,
		a.fecha_inicio as fecha,
		a.id_instancia
		<!--- a.id_instancia as checked --->
	
	from TPInstanciaTramite a
	
		inner join TPPersona p
			on a.id_persona = p.id_persona
	
		inner join TPTramite t
			on a.id_tramite = t.id_tramite
	
	
	where a.completo =0
	and not exists (
				select b.id_instancia 
				from TPInstanciaRequisito b
				where a.id_instancia = b.id_instancia 
				and b.completado =0
				   )
   <cfif isdefined("form.chk") and len(trim(form.chk))>
		and a.id_instancia in (#form.chk#)
	<cfelse>
	 	and 1 = 0
	</cfif>
	order by t.nombre_tramite,	a.fecha_inicio
</cfquery>

<cfquery name="rsInstitucion" datasource="#session.tramites.dsn#">
	select nombre_inst, codigo_inst
	from TPInstitucion
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
</cfquery>

<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
<form name="form2" method="post" action="listado_sql.cfm" style="margin:0" >
<cfif isdefined("form.chk") and len(trim(form.chk))>
	<cfoutput><input name="chk" type="hidden" value="#form.chk#"></cfoutput>
</cfif>
	<table width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr style="background-color:#ededed">
			<td colspan="4" style="border-bottom:1px solid black">
				<table border="0" cellpadding="0" cellspacing="0">
					<tr style="background-color:#ededed">
					  <td rowspan="2"><img src="fischel.gif" width="146" height="59"></td>
					  <td style="font-size:16px">&nbsp;</td>
					  <td colspan="4" style="font-size:16px"><cfoutput>#rsInstitucion.nombre_inst#</cfoutput></td>
					</tr>
					<tr style="background-color:#ededed">
					  <td style="font-size:14px">&nbsp;</td>
					  <td colspan="4" style="font-size:14px"><strong>Verificaci&oacute;n de Tr&aacute;mites por Cerrar</strong></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#rsLista#">
					<cfinvokeargument name="desplegar" value="cedula, nombre, fecha"/>
					<cfinvokeargument name="etiquetas" value="Cédula, Nombre, Fecha"/>
					<cfinvokeargument name="formatos" value="S,S,D"/>
					<cfinvokeargument name="align" value="left, left, left"/>
					<cfinvokeargument name="ajustar" value="S,N,S"/>
					<cfinvokeargument name="Cortes" value="tramite"/>
					<cfinvokeargument name="incluyeForm" value="no"/>
					<cfinvokeargument name="formName" value="form2"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="irA" value=""/>
					<cfinvokeargument name="keys" value="id_instancia"/>
					<cfinvokeargument name="MaxRows" value="10"/>
				</cfinvoke> 
					<!--- <cfinvokeargument name="checkedcol" value="checked"/> --->
			</td>
		</tr>
		<tr>
			<td align="center">
				<cfif rsLista.recordcount gt 0>
				  <input type="button"  onClick="javascript:funcCerrar();" value="Cerrar" class="boton">			
				</cfif>
				<input type="button"  onClick="javascript:funcCancelar();" value="Cancelar" class="boton">
			</td>
		</tr>
	</table>
</form>

<script type="text/javascript">
<!--
	function funcCerrar(){
		//alert('En construcción');
		document.form2.submit();
	}
	function funcCancelar(){
		document.form2.action="listado_form.cfm";
		document.form2.submit();
	}
//-->
</script>

</body>
</html>