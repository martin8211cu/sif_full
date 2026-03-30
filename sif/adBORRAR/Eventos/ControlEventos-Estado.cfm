<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
	<tbody>
	<tr>
	  <td class="tituloListas" align="center" height="17" nowrap="nowrap" width="100%">Seguimiento de los Estado del Evento</td>
	</tr>
	</tbody>
</table>
<form name="formEstado" action="/cfmx/sif/ad/Eventos/ControlEventos-sql.cfm" method="post">
	<input type="hidden" name="PaginaInicial" value="<cfoutput>#PaginaInicial#</cfoutput>">
	<cfif modo EQ 'CAMBIO'>
		<input type="hidden" name="CEVid" value="<cfoutput>#URL.CEVid#</cfoutput>"/>
	</cfif>
	<table border="0" cellspacing="2" cellpadding="2" align="center">
		<tr>
			<td> Estado:</td>
			 <td>
				 <cfinvoke component="sif.Componentes.ControlEventos" method="GET_ESTADOS" returnvariable="rsEstado">
					<cfinvokeargument name="TEVid" value="#rsEvento.TEVid#">
				 </cfinvoke>
				<select name="TEVECodigo">
					<cfloop query="rsEstado">
						<option value="<cfoutput>#rsEstado.TEVECodigo#</cfoutput>"><cfoutput>#rsEstado.TEVEDescripcion#</cfoutput></option>
					</cfloop>
				</select>
			  </td>
		</tr>
		<tr>
			<td>Justificación</td>
			<td>
			<textarea name="SEVDescripcion" cols="35">
			</textarea>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" name="AGREGAR_EST" value="Agregar" class="btnGuardar" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				 <cfinvoke component="sif.Componentes.ControlEventos" method="GET_SEGUIMIENTO" returnvariable="rsSeguimiento">
					<cfinvokeargument name="CEVid" value="#URL.CEVid#">
				 </cfinvoke>

				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
					<cfinvokeargument name="query" 				value="#rsSeguimiento#"/>
					<cfinvokeargument name="desplegar" 			value="TEVEDescripcion,justificacion,Usuario,FechaAlta"/>
					<cfinvokeargument name="etiquetas" 			value="Estado,Justificación,usuario, FechaAlta"/>
					<cfinvokeargument name="formatos" 			value="S,S,S,D"/>
					<cfinvokeargument name="align" 				value="left,center,left,left"/>
					<cfinvokeargument name="formName" 			value="formEstado"/>
					<cfinvokeargument name="checkboxes" 		value="N"/>
					<cfinvokeargument name="keys" 				value="SEVid,CEVid"/>
					<cfinvokeargument name="funcion" 			value="return false;"/>
					<cfinvokeargument name="MaxRows" 			value="10"/>
					<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
					<cfinvokeargument name="PageIndex" 			value="2"/>
					<cfinvokeargument name="lineaAzul" 			value="true"/>
				</cfinvoke>
			</td>
		</tr>
	</table>
</form>
<cf_qforms form="formEstado" objForm="formEstado">
      <cf_qformsRequiredField name="TEVECodigo" description="Estado">
	  <cf_qformsRequiredField name="SEVDescripcion" description="Justificación">
</cf_qforms> 