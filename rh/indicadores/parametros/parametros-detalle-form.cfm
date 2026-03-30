<cfinvoke component="sif.Componentes.Translate"
		  method="Translate"
		  Key="LB_Concepto"
		  Default="Concepto de Pago"
		  XmlFile="/rh/generales.xml"
		  returnvariable="LB_Concepto"/>
<cfinvoke component="sif.Componentes.Translate"
		  method="Translate"
		  Key="LB_Tipo"
		  Default="Tipo"
		  XmlFile="/rh/generales.xml"
		  returnvariable="LB_TIPO"/>		  
<cfinvoke component="sif.Componentes.Translate"
		  method="Translate"
		  Key="LB_Accion"
		  Default="Acción de Personal"
		  XmlFile="/rh/generales.xml"
		  returnvariable="LB_Accion"/>		  
<cfinvoke component="sif.Componentes.Translate"
		  method="Translate"
		  Key="BTN_Seleccionar"
		  Default="Seleccionar"
		  XmlFile="/rh/generales.xml"
		  returnvariable="BTN_Seleccionar"/>		  
		  
<cfquery name="rs_accion" datasource="#session.DSN#">
	select RHTid, RHTcodigo, RHTdesc
	from RHTipoAccion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and RHTid not in ( select RHIDllave 
					   from RHIndicadoresDetalle 
					   where RHIcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHIcodigo#"> 
					     and RHIDtipo = 'A' )
	order by RHTcodigo
</cfquery>

<cfoutput>
<form name="form2" method="post" action="parametros-detalle-sql.cfm" style="margin:0;">
<input type="hidden" name="RHIcodigo" value="#form.RHIcodigo#">
<table width="100%" border="0" cellpadding="2" cellspacing="0">
	<tr>
		<td width="1%" nowrap="nowrap"><strong>#LB_TIPO#:&nbsp;</strong></td>
		<td align="left">
			<select name="RHIDtipo" onChange="javascript: cambia_tipo(this.value);">
				<option value="">- #BTN_Seleccionar# -</option>
				<option value="A">#LB_Accion#</option>
				<option value="C">#LB_Concepto#</option>
			</select>
		</td>
	</tr>
	<tr id="tr_accion" style="display: none;" >
		<td><strong>#LB_Accion#:&nbsp;</strong></td>
		<td align="left">
			<select name="RHTid">
				<cfloop query="rs_accion">
					<option value="#rs_accion.RHTid#">#trim(rs_accion.RHTcodigo)#-#rs_accion.RHTdesc#</option>
				</cfloop>
			</select>
		</td>
	</tr>
	<tr id="tr_concepto" style="display: none;" >
		<td><strong>#LB_Concepto#:&nbsp;</strong></td>
		<td align="left"><cf_rhcincidentes form="form2"></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><cf_botones modo="ALTA" exclude="Limpiar"></td>
	</tr>
</table>
</form>



<cfquery name="rs_lista2" datasource="#session.DSN#">
	select 	a.RHIDid, 
			a.RHIDtipo,
			'#form.RHIcodigo#' as RHIcodigo,
			case a.RHIDtipo when 'A' then 'Acciones' else 'Conceptos' end as tipo_desc,
			a.RHIDllave, 
			case a.RHIDtipo when 'A' then (select rtrim(RHTcodigo) + ' - '+ RHTdesc from RHTipoAccion where RHTid=a.RHIDllave) 
									 else (select rtrim(CIcodigo) + ' - '+ CIdescripcion from CIncidentes where CIid=a.RHIDllave) end as linea,
			'<img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0'' onClick=''javascript:eliminar(' + convert(varchar, a.RHIDid) + ')''>' as imagen
	from RHIndicadoresDetalle a
	where a.RHIcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHIcodigo#">
	order by tipo_desc, a.RHIDtipo, linea
</cfquery>

<cfinvoke component="rh.Componentes.pListas"
		  method="pListaquery"
		  returnvariable="pListaRet">
	<cfinvokeargument name="query" 				value="#rs_lista2#"/>
	<cfinvokeargument name="desplegar" 			value="linea,imagen"/>
	<cfinvokeargument name="etiquetas" 			value="Acciones/Conceptos asociados al indicador,&nbsp;"/>
	<cfinvokeargument name="formatos" 			value="V,S"/>
	<cfinvokeargument name="align" 				value="left,center"/>
	<cfinvokeargument name="ajustar" 			value="N"/>
	<cfinvokeargument name="checkboxes" 		value="N"/>
	<cfinvokeargument name="showlink" 		  	value="false"/>
	<cfinvokeargument name="keys" 			  	value="RHIDid"/>
	<cfinvokeargument name="debug" 			  	value="N"/>
	<cfinvokeargument name="pageIndex" 		  	value="2"/>
	<cfinvokeargument name="showEmptyListMsg" 	value="true"/>	
	<cfinvokeargument name="Cortes" 			value="tipo_desc"/>
	<cfinvokeargument name="formname" 			value="lista2"/>
</cfinvoke>

</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function cambia_tipo( tipo ){
		if (tipo == '' ){
			document.getElementById('tr_accion').style.display = 'none';
			document.getElementById('tr_concepto').style.display = 'none';
		}
		if (tipo == 'A' ){
			document.getElementById('tr_accion').style.display = '';
			document.getElementById('tr_concepto').style.display = 'none';
		}
		if (tipo == 'C' ){
			document.getElementById('tr_accion').style.display = 'none';
			document.getElementById('tr_concepto').style.display = '';
		}
	}
	
	function eliminar(id){
		if ( confirm('Desea eliminar el registro?') ){
			document.lista2.action = 'parametros-detalle-sql.cfm';
			document.lista2.RHIDID.value = id;
			document.lista2.RHICODIGO.value = '<cfoutput>#form.RHIcodigo#</cfoutput>';
			document.lista2.submit();
		}
		else{
			document.lista2.RHIDID.value = '';
		}
	}
	
</script>



