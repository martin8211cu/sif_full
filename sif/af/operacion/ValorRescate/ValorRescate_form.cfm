<cfif isdefined('form.AFTRid') and len(trim(form.AFTRid))>
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<cfif isdefined ('url.AFTRid') and not isdefined('form.AFTRid')>
<cfset form.AFTRid=#url.AFTRid#>
<cfset modo='CAMBIO'>
</cfif>
<cfif modo NEQ 'ALTA'>

	<cfquery datasource="#session.dsn#" name="rsForm">
			select
				AFTRid,
				Ecodigo,
				AFTRdescripcion,
				AFTRdocumento,
				Usucodigo,
				AFTRfecha,
				AFTRaplicado,
				AFTRtipo
			from
				AFTRelacionCambio
			where AFTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFTRid#">
					and Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>



<script language="javascript1.1" type="text/javascript">
var popUpWinSN=0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
  	}
  	popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp;
}

function doConlis(){
	<cfoutput>
	popUpWindow("/cfmx/sif/af/operacion/ValorRescate/ValorRescate_filtro.cfm?AFTRid=#form.AFTRid#",150,150,550,375);
	</cfoutput>
}

function closePopUp(){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
		popUpWinSN=null;
  	}
}

function funcfiltro(){
<cfoutput>
	document.detAFVR.action='ValorRescate.cfm?AFTRid=#form.AFTRid#';
	document.detAFVR.submit();
</cfoutput>
}
</script>
</cfif>



<cfoutput>
	<form action="ValorRescate_sql.cfm"  method="post"  name="form1" id="form1" style= "margin: 0;">
	<input type="hidden" name="modo" value="#modo#" />
<cfif modo NEQ 'ALTA'>
	<input type="hidden" name="AFTRid" value="#rsForm.AFTRid#" />
</cfif>
	    <table align="center" summary="Tabla de entrada"  width="100%" border="0">

		<tr>
			<td nowrap="nowrap" valign="top" align="left" colspan="2">
				<cfif modo NEQ 'ALTA'>
				<strong>Número de Documento:</strong>
					<strong>#rsForm.AFTRdocumento#</strong>
					<input type="hidden" name="AFTRdocumento" value="#rsForm.AFTRdocumento#">
				<cfelse>
				<strong>Número de Documento:</strong>
					&nbsp;&nbsp; -- Nuevo Documento --
				</cfif>
			</td>

			<td valign="top" nowrap="nowrap"align="right"><strong>Fecha:</strong></td>
			<td valign="top" nowrap="nowrap" align="left">
				<cfif modo neq 'ALTA'>
					<strong>#LSDateFormat(rsForm.AFTRfecha,"DD/MM/YYYY")#</strong>
				<cfelse>
					&nbsp;&nbsp;<strong>#LSDateFormat(now(),"DD/MM/YYYY")#</strong>
			  </cfif>
	      </td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width="10%" align="right" ><strong>Descripci&oacute;n:</strong></td>
			<td valign="top" nowrap="nowrap" align="left">
				<input
				tabindex="1"
				name="AFTRdescripcion"
				id="AFTRdescripcion"
				type="text"
				size="80"
				maxlength="80"
				value="<cfif modo NEQ 'ALTA'>#trim(rsForm.AFTRdescripcion)#</cfif>"/>
			</td>
		  </tr>
			<tr>
			<td align="right" valign="top"><strong>Tipo:</strong></td>
			<td align="left"nowrap="nowrap" valign="top">
				<select name="AFTRtipo"  id="AFTRtipo" tabindex="1">
					<cfif modo neq 'ALTA'>
						<option 	value="#rsForm.AFTRtipo#">
						<cfif rsForm.AFTRtipo EQ 1>
							Valor Rescate
						<cfelseif rsForm.AFTRtipo EQ 2>
							Descripción
						<cfelseif rsForm.AFTRtipo EQ 4>
							Fecha
						<cfelseif rsForm.AFTRtipo EQ 5><!---Se agrega para cambio por garantía RVD 04/06/2014--->
                        	Garantía
						<cfelse>
							Todos
						</cfif>
						</option>
					<cfelse>
						<option value=1>Valor Rescate</option>
						<option value=2>Descripción</option>
						<option value=4>Fecha</option>
						<option value=3>Todos</option>
                        <option value=5>Garantía</option><!---Se agrega para cambio por garantía RVD 04/06/2014--->
					</cfif>
				</select>

			</td>
	</tr>
	<tr><td>&nbsp;</td></tr>

	<tr>
	<td>&nbsp;</td>
	<td align="center" nowrap="nowrap" valign="top">

			<cfif modo neq 'ALTA'>
				<input type="submit"  value="Nuevo" name="nuevo" id="Nuevo" onClick="javascript: inhabilitarValidacion(); "/>
				<input type="submit"  value="Modificar" name="modifica" id="modifica" onClick="javascript: inhabilitarValidacion(); MensajeModificar(); "/>
				<input type="submit" name="Baja" value="Eliminar" tabindex="1" onclick="javascript: return funEli() " />
				<input type="button" value="Generar" onclick="doConlis();javascript: inhabilitarValidacion(); " />
				<input type="submit"  value="Exportar" name="Exporta" id="Exporta" onClick="javascript: inhabilitarValidacion(); "/>
				<input type="submit"  value="Importar" name="Importa" id="Importa" onClick="javascript: inhabilitarValidacion(); "/>
				<input type="submit"  value="Aplicar" name="aplicar" id="aplicar" onClick="javascript: inhabilitarValidacion(); "//>
				<input type="submit"  value="Reporte" name="Reporte" id="Reporte" onClick="javascript: Reporte(); "/>
				<input type="submit"  value="Regresar" name="irLista" id="irLista" onClick="javascript: inhabilitarValidacion(); "/>

			<cfelse>
			<input type="submit"  value="Agrega" name="Agrega" id="Agrega" onClick="javascript: habilitarValidacion(); "/>
			<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: inhabilitarValidacion(); " >
			<input type="submit"  value="Regresar" name="irLista" id="irLista" onClick="javascript: inhabilitarValidacion(); "/>

			</cfif>
			<input type="submit"  value="Aid" name="BorrarDet" id="BorrarDet" style="display:none"/>

		</td>
		</tr>
		</table>
  </form>
</cfoutput>


<!---ValidacionesFormulario--->
<cf_qforms>
<script language="javascript" type="text/javascript">
function funEli(){
 return confirm('¿Está seguro(a) de que desea eliminar el registro?')
}

	function funcBajaAnt(){
		inhabilitarValidacion();
		return confirm("Desea Eliminar el Registro?")
	}
	function inhabilitarValidacion() {
		objForm.AFTRdescripcion.required = false;
	}

	function habilitarValidacion() {
		objForm.AFTRdescripcion.required = true;
	}

	objForm.AFTRdescripcion.description = "Debe digitar esto";

	function Reporte(){
		document.form1.action = 'VRreporte_form.cfm'

	}

	<!--- JMRV. Mensaje al dar click en modificar. 18/07/2014 --->
	function MensajeModificar(){
		alert("Se han agregado los datos a modificar");
	}

</script>


<cfif modo neq "ALTA">
		<cfinclude template="ValorRescate_det.cfm">
	</cfif>