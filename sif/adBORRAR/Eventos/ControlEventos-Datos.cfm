<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
	<tbody>
	<tr>
	  <td class="tituloListas" align="center" height="17" nowrap="nowrap" width="100%">Datos Específicos del Evento</td>
	</tr>
	</tbody>
</table>
	<cfset Tipificacion = StructNew()>
	<cfset temp = StructInsert(Tipificacion, "TEV", "#rsEvento.TEVid#")>
<form name="otrosDatos" action="/cfmx/sif/ad/Eventos/ControlEventos-sql.cfm" method="post">
	<input type="hidden" name="PaginaInicial" value="<cfoutput>#PaginaInicial#</cfoutput>">
	<cfif modo EQ 'CAMBIO'>
		<input type="hidden" name="CEVid" value="<cfoutput>#URL.CEVid#</cfoutput>"/>
		<input type="hidden" name="TEVid" value="<cfoutput>#rsEvento.TEVid#</cfoutput>"/>
	</cfif>
	<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr><td>
			<p>
				<cfinvoke component="sif.Componentes.DatosVariables" method="PrintDatoVariable" returnvariable="Cantidad">
					<cfinvokeargument name="DVTcodigoValor" value="TEV">
					<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
					<cfinvokeargument name="DVVidTablaVal"  value="#rsEvento.CEVid#">
					<cfinvokeargument name="form" 			value="otrosDatos">
					<cfinvokeargument name="NumeroColumas"  value="4">
				</cfinvoke>
			</p>
				<cfif Cantidad EQ 0>
					<div align="center">No Existen Datos Variables Asignados al Activo</div>
				<cfelse>
					<div align="center"><input type="submit" name="AGREGAR_VALOR" value="Guardar Valores" class="btnGuardar" /></div>
				</cfif>
		</td></tr>
	</table>
</form>
<cfinvoke component="sif.Componentes.DatosVariables" method="QformDatoVariable">
	<cfinvokeargument name="DVTcodigoValor" value="TEV">
	<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
	<cfinvokeargument name="DVVidTablaVal"  value="#URL.CEVid#">
	<cfinvokeargument name="form" 			value="otrosDatos">
</cfinvoke>