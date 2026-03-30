<!--- 
	Creado por Gustavo Fonseca Hernández
		Fecha: 16-8-2005.
		Motivo: Mantenimiento de la tabla DDVista.
 --->
<cfif isdefined("url.modo") and len(trim(url.modo)) and not isdefined("form.modo")>
	<cfset form.modo = url.modo>
</cfif>

<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<cf_templatecss>
<!--- <script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script> --->

<body>
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsDDTipo" datasource="#session.tramites.dsn#">
		select id_tipo, nombre_tipo, descripcion_tipo
		from DDTipo
		where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipo#">
	</cfquery>
</cfif>


<form action="vista_sql.cfm" method="post" name="form1" onSubmit="return validar();">
<cfoutput>
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
	<tr>
		<td bgcolor="##ECE9D8" style="padding:3px;" colspan="5"><font size="1"><cfif modo neq 'ALTA'>
				  Modificar&nbsp;la<cfelse>Agregar
				</cfif>&nbsp;Vista</font></td>
	</tr>
	<tr>
	  	<td  align="right" valign="top" width="1%"><strong>Documento:&nbsp;</strong></td>
		<td colspan="2">
			<cfif modo NEQ 'ALTA'>
				<cf_conlis title="Lista de Documentos"
						campos = "id_tipo,nombre_tipo" 
						desplegables = "N,S" 
						size = "0,30"
						values="#rsDDTipo.id_tipo#,#rsDDTipo.nombre_tipo#" 
						tabla="DDTipo"
						columnas="id_tipo,nombre_tipo,descripcion_tipo"
						filtro="clase_tipo='C' order by nombre_tipo"
						desplegar="nombre_tipo,descripcion_tipo"
						etiquetas="Nombre,Descripción"
						formatos="S,S"
						align="left,left"
						conexion="#session.tramites.dsn#">
			<cfelseif modo EQ 'ALTA'>
				<cf_conlis title="Lista de Documentos"
						campos = "id_tipo,nombre_tipo" 
						desplegables = "N,S" 
						size = "0,30"
						values="" 
						tabla="DDTipo"
						columnas="id_tipo,nombre_tipo,descripcion_tipo"
						filtro="clase_tipo='C' order by nombre_tipo"
						desplegar="nombre_tipo,descripcion_tipo"
						etiquetas="Nombre,Descripción"
						formatos="S,S"
						align="left,left"
						conexion="#session.tramites.dsn#">
			</cfif>
		</td>	
	</tr>
	<tr>
	  	<td align="right"><strong>Nombre&nbsp;Vista:</strong>&nbsp;</td>
		<td colspan="2">
			<input type="text" name="nombre_vista" size="60" maxlength="100" value="<cfif modo neq 'ALTA'>#Trim(rsVistas.nombre_vista)#</cfif>">
		</td>
	<!--- </tr>
	<tr> --->
		<td valign="top" align="right"><strong>T&iacute;tulo&nbsp;Vista:</strong>&nbsp;</td>
		<td valign="top"> 
			<input type="text" name="titulo_vista" size="60" value="<cfif modo neq 'ALTA'>#Trim(rsVistas.titulo_vista)#</cfif>">
		</td>
	</tr>
	<tr>
		<td align="right" nowrap><strong>Vigente&nbsp;Desde:&nbsp;</strong> </td>	
		<td colspan="2">
			<cfif modo NEQ 'ALTA' and len(trim(rsVistas.vigente_desde))>
				<cf_sifcalendario form="form1" value="#LSDateFormat(rsVistas.vigente_desde,'dd/mm/yyyy')#" name="vigente_desde"> 
			<cfelse>
				<cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="vigente_desde"> 
			</cfif>
		</td>
		<td align="right" nowrap><strong>Vigente&nbsp;Hasta:&nbsp;</strong> </td>	
		<td>
			<cfif modo NEQ 'ALTA' and len(trim(rsVistas.vigente_hasta))>
				<cf_sifcalendario form="form1" value="#LSDateFormat(rsVistas.vigente_hasta,'dd/mm/yyyy')#" name="vigente_hasta"> 
			<cfelse>
				<cf_sifcalendario form="form1" value="01/01/6100" name="vigente_hasta"> 
			</cfif>
		</td>
	</tr>
	
	<tr>
		<td align="right" valign="top" nowrap>&nbsp;</td>
		<td width="1%">
			<input type="checkbox" name="es_masivo" id="es_masivo" value="1" onChange="this.form.es_individual.checked |= !this.checked" <cfif modo neq 'ALTA' and isdefined("rsVistas") and rsVistas.es_masivo eq 1>checked</cfif> >		</td>
	  	<td><label for="es_masivo"> <strong>Permitir&nbsp;registro&nbsp;masivo</strong></label></td>
	  	<td colspan="2" align="right" valign="top" nowrap>&nbsp;</td>
    </tr>
	<tr>
		<td align="right" valign="top" nowrap>&nbsp;</td>
		<td>
			<input type="checkbox" name="es_individual" id="es_individual" value="1" onChange="this.form.es_masivo.checked |= !this.checked" <cfif modo neq 'ALTA' and isdefined("rsVistas") and rsVistas.es_individual eq 1>checked</cfif> >		</td>
	  	<td><label for="es_individual"> <strong>Permitir&nbsp;registro&nbsp;individual</strong></label></td>
	  	<td colspan="2" align="right" valign="top" nowrap>&nbsp;</td>
    </tr>
	<tr>
		<td align="right" valign="top" nowrap colspan="2">&nbsp;</td>
		<td colspan="3">
			<cfif modo neq 'ALTA'>
			
			<label for="es_persona">
		<strong>Los documentos de este tipo 
		<cfif isdefined("rsVistas") and rsVistas.es_persona eq 1>siempre<cfelse>NO</cfif>
		 est&aacute;n asociados a una persona</strong></label>
		</cfif>
		</td>
  	</tr>
	<!--- Botones --->
	<tr> 
		<td colspan="5" align="center" valign="top" nowrap> 
			<div align="center"> 
				<cf_botones modo="#modo#" include="Regresar" includevalues="Regresar a la lista">
			</div>
		</td>
	</tr>
	<tr>
	  	<td colspan="5" align="right" valign="top" nowrap>&nbsp;</td>
    </tr>
	<cfif modo neq "ALTA">
		<cfset ts = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsVistas.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
  	 <input type="hidden" name="id_vista" value="<cfif isdefined("form.id_vista") and len(trim(form.id_vista))>#form.id_vista#</cfif>"><!--- --->
	<input type="hidden" name="DGenerales" value="DGenerales">
</table>
</form>
</cfoutput>

<cf_qforms form="form1" objform="objform">
<script language="javascript" type="text/javascript">
	/*function funcAlta()
	{
		alert('En construcción');
		return false;
	}*/

function funcRegresar(){
	location.href = "listaVista.cfm";
	return false;
}

function validar(){
		var msj = '';
		
		if ( document.form1.id_tipo.value == '' ){
			msj += ' - El campo Tipo es requerido.\n';
		}
		
		if ( document.form1.nombre_vista.value == '' ){
			msj += ' - El campo Nombre Vista es requerido.\n';
		}

		if ( document.form1.titulo_vista.value == '' ){
			msj += ' - El campo Título Vista es requerido.\n';
		}
		
		if ( document.form1.vigente_desde.value == '' ){
			msj += ' - El campo Fecha Desde es requerido.\n';
		}

		if ( document.form1.vigente_hasta.value == '' ){
			msj += ' - El campo Fecha hasta es requerido.\n';
		}
		
		if ( msj != '' ){
			alert('Se presentaron los siguientes errores:\n' + msj)
			return false;
		}
		return true;
	}


</script>


