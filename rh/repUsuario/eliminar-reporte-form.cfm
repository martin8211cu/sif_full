
<cfquery name="datos" datasource="#session.DSN#">
	select 	RHRURid as id, 
			RHRURcodigo as codigo, 
			RHRURnombre as archivo, 
			RHRURdescripcion as descripcion, 
			RHRURsistema as sistema, 
			RHRURcategoria as categoria, 
			RHRURfechaModificacion as fecha
	from RHRUReportes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by RHRURsistema, RHRURcategoria, RHRURcodigo
</cfquery>
<br>
<form name="form1" method="post" action="eliminar-reporte-sql.cfm" >
	<cfoutput>
	<table width="98%" border="0" cellpadding="2">
		<tr><td colspan="2"><strong>#vProceso#</strong></td></tr>
		<tr><td colspan="2"><strong>#vListado#</strong></td></tr>
	</table>
	</cfoutput>

	<table width="98%%" align="center" cellpadding="2" cellspacing="0">
		<cfoutput>
		<tr class="tituloListas">
			<td style="padding-left:0px;">#vReporte#</td>
			<td>#vDescripcion#</td>
			<td>#vArchivo#</td>
			<td align="center">#vFecha#</td>
			<td align="center"></td>
			<td></td>
		</tr>
		</cfoutput>
		<cfoutput query="datos" group="sistema">
				<tr>
					<td colspan="7" bgcolor="##f5f5f5"><strong>#vSistema#: #datos.sistema# - #vcategoria#: <cfif datos.categoria eq 'estructura'>#vestructura#<cfelseif datos.categoria eq 'empleados'>#vEmpleados#<cfelseif datos.categoria eq 'nomina'>#vnomina#<cfelseif datos.categoria eq 'parametros'>#vparametros#</cfif></strong></td>
				</tr>
				<cfoutput>
					<tr>
						<td style="padding-left:15px;">#datos.codigo#</td>
						<td>#datos.descripcion#</td>
						<td>#datos.archivo#</td>
						<td align="center">#LSDateFormat(datos.fecha, 'dd/mm/yyyy')#  #LSTimeFormat(datos.fecha, 'hh:mm tt')#</td>
						<td align="center" title="#vModificarRegistro#"><a href="javascript:modificar('#datos.id#');"><img border="0" src="/cfmx/rh/imagenes/edit_o.gif"></a></td>
						<td align="center" title="#vEliminarEste#"><a href="javascript:eliminar('#datos.id#');"><img border="0" src="/cfmx/rh/imagenes/Borrar01_S.gif"></a></td>
					</tr>
				</cfoutput>
		</cfoutput>
		<cfif datos.recordcount eq 0>
			<tr><td colspan="6" align="center"><strong><cf_translate key="MSG_NoSeEncontraronRegistros" xmlfile="rh/generales.xml">No se encontraron registros</cf_translate></strong></td></tr>
		</cfif>
		<!---
		<cfif datos.recordcount gt 0>
			<cfoutput>
			<tr><td colspan="6" align="center"><input type="submit" class="btnEliminar" name="btnEliminar" value="#vEliminar#" onClick="javascript:return eliminar();"></td></tr>
			</cfoutput>
		</cfif>
		--->
	</table>
	<input type="hidden" name="chk" value="">
</form>

<script language="javascript1.2" type="text/javascript">
	var seleccionados = 0;
	
	function modificar_seleccionados(obj){
		if (obj.checked){
			seleccionados++;
		}
		else{
			seleccionados--;
		}

		if (seleccionados < 0){ seleccionados = 0; }
		<cfoutput>
		if (seleccionados > #datos.recordcount#){ seleccionados = #datos.recordcount#; }
		</cfoutput>
	}

	function eliminar(id){
		if ( confirm('<cfoutput>#vEliminarSel#</cfoutput>') ){
			document.form1.chk.value = id;
			document.form1.submit();
		}
	}
	
	function modificar(id){
		window.open('modificar-reporte.cfm?id='+id,'modicarReporte','menu=no,scrollbars=yes,top=250,left=350,width=420,height=230');
	}
	
</script> 

