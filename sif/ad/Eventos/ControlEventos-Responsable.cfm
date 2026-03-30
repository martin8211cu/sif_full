<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
	<tbody>
	<tr>
	  <td class="tituloListas" align="center" height="17" nowrap="nowrap" width="100%">Responsables del Evento</td>
	</tr>
	</tbody>
</table>
<form name="FormResponsable" action="/cfmx/sif/ad/Eventos/ControlEventos-sql.cfm" method="post">
	<input type="hidden" name="PaginaInicial" value="<cfoutput>#PaginaInicial#</cfoutput>">
	<cfif modo EQ 'CAMBIO'>
		<input type="hidden" name="CEVid" value="<cfoutput>#URL.CEVid#</cfoutput>"/>
	</cfif>
	<table align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>Responsables:</td>
			<td><cf_rhempleados size="40" form="FormResponsable"></td>
			<td><input type="submit" name="AGREGAR_RESP" value="Agregar" class="btnGuardar" /></td>
		</tr>
		<tr><td colspan="2">
			 <cfinvoke component="sif.Componentes.ControlEventos" method="GET_RESPONSABLE" returnvariable="rsResponsable">
				<cfinvokeargument name="CEVid"     value="#URL.CEVid#">
				<cfinvokeargument name="DEidName"  value="idEmpleado">
				<cfinvokeargument name="CEVidName" value="idEvento">
			 </cfinvoke>
			 
			 <cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
					<cfinvokeargument name="query" 				value="#rsResponsable#"/>
					<cfinvokeargument name="desplegar" 			value="Empleado,Borrar"/>
					<cfinvokeargument name="etiquetas" 			value="Responsable,"/>
					<cfinvokeargument name="formatos" 			value="S,US"/>
					<cfinvokeargument name="align" 				value="center,center"/>
					<cfinvokeargument name="formName" 			value="FormResponsable"/>
					<cfinvokeargument name="checkboxes" 		value="N"/>
					<cfinvokeargument name="keys" 				value="idEvento,idEmpleado"/>
					<cfinvokeargument name="ira" 				value="#CurrentPage#?CEVid=#URL.CEVid#"/>
					<cfinvokeargument name="MaxRows" 			value="10"/>
					<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
					<cfinvokeargument name="PageIndex" 			value="1"/>
					<cfinvokeargument name="lineaAzul" 			value="true"/>
					
				</cfinvoke>
				
		</td></tr>
	</table>
</form>
<script language="JavaScript">
	// Cambia el Action del Form
	function FunctionDelete() {
		if (confirm('¿Desea Eliminar el Responsable?')){
			document.FormResponsable.action = "/cfmx/sif/ad/Eventos/ControlEventos-sql.cfm?BAJARESP=true";
			}
		}
</script>