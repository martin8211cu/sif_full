<cfset modo = "ALTA">
<cfif isdefined('form.SOid') and form.SOid NEQ ''>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select SOid
			, SOfechasol
			, SOtipo
			, SOestado
			, case SOestado
				when 'I' then 'Incluida'
				when 'A' then 'Autorizada'				
				when 'D' then 'Devuelta'				
				when 'M' then 'Modificada'				
				when 'N' then 'Anulada'				
				when 'R' then 'Rechazada'				
				when 'E' then 'Revisión'				
			end  SOestadoDesc
			, SOfechapro
			, SOtiposobre
			, SOcantidad
			, SOgenero
			, SOPrefijo
			, SOobservaciones
			, SOenviada
			, BMusucodigo
			, ts_rversion
		from ISBsolicitudes
		where SOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SOid#" null="#Len(form.SOid) Is 0#">
	</cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="rsPrefijos">
	select *
	from ISBprefijoPrepago
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by prefijo
</cfquery>

<cfoutput>
	
	<form action="ISBsolicitudes-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
		<cfinclude template="ISBsolicitudes-hiddens.cfm">
		
		<table summary="Tabla de entrada"  border="0" width="100%" cellpadding="0" cellspacing="2">
		<tr>
			<td colspan="3" class="subTitulo">Solicitud de Sobres / Tarjetas Prepago:</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>			
		<tr>
			<td width="16%" align="right" valign="top">
				<label for="SOtipo">Tipo de solicitud:</label>
			</td>
			<td width="1%" valign="top">&nbsp;</td>
			<td width="83%" valign="top">
				<select name="SOtipo" id="SOtipo" onChange="javascript: cambioTipo(this);">
					<option value="P" <cfif modo NEQ 'ALTA' and data.SOtipo is 'P'>selected</cfif>>Prepago</option>
					<option value="S" <cfif modo NEQ 'ALTA' and data.SOtipo is 'S'>selected</cfif>>Sobre</option>
				</select>
			</td>
		</tr>				
		<tr id="tipoP">
			<td align="right"><label for="SOPrefijo">Prefijo:</label></td>
			<td>&nbsp;</td>
			<td>
				<select name="SOPrefijo" id="SOPrefijo">
					<cfif isdefined('rsPrefijos') and rsPrefijos.recordCount GT 0>
						<cfloop query="rsPrefijos">
							<option value="#rsPrefijos.prefijo#" <cfif modo NEQ 'ALTA' and data.SOprefijo EQ rsPrefijos.prefijo>selected</cfif>>#rsPrefijos.prefijo#</option>
						</cfloop>
					</cfif>
				</select>			
			</td>
		</tr>		
		<tr id="tipoS">
			<td align="right"><label for="SOtiposobre">Tipo Sobre:</label></td>
			<td>&nbsp;</td>
			<td>
				<select name="SOtiposobre" id="select">
					<option value="F" <cfif modo NEQ 'ALTA' and data.SOtiposobre is 'F'>selected</cfif>>F&iacute;sico</option>
					<option value="V" <cfif modo NEQ 'ALTA' and data.SOtiposobre is 'V'>selected</cfif>>Virtual</option>
				</select>
			</td>
		</tr>		
		<tr id="tipoS2">
			<td align="right"><label for="SOgenero">G&eacute;nero:</label></td>
			<td>&nbsp;</td>		
			<td>
				<select name="SOgenero" id="SOgenero">
					<option value="A" <cfif modo NEQ 'ALTA' and data.SOgenero is 'A'>selected</cfif>>Acceso</option>
					<option value="C" <cfif modo NEQ 'ALTA' and data.SOgenero is 'C'>selected</cfif>>Correo</option>
					<option value="U" <cfif modo NEQ 'ALTA' and data.SOgenero is 'U'>selected</cfif>>Ambos</option>
					<!---<option value="N" <cfif modo NEQ 'ALTA' and data.SOgenero is 'N'>selected</cfif>>No Aplica</option>--->
				</select>
			</td>
		</tr>			
		<tr>
			<td align="right" valign="top" nowrap>
				<label for="SOfechasol">Fecha de Solicitud:</label>
			</td>
			<td width="1%" nowrap>&nbsp;</td>
			<td width="83%" nowrap>
				<cfif modo EQ 'CAMBIO'>
					#DateFormat(data.SOfechasol,'dd/mm/yyyy')#
					<input type="hidden" name="SOfechasol" value="#data.SOfechasol#">
				<cfelse>
					#DateFormat(Now(),'dd/mm/yyyy')#
					<input type="hidden" name="SOfechasol" value="#Now()#">
				</cfif>									
			</td>
		</tr>		
		<tr>
			<td align="right" valign="top">
				<label for="SOcantidad">Cantidad:</label>
			</td>
			<td width="1%" valign="top">&nbsp;</td>
			<td width="83%" valign="top">
				<cfset SOcantidad = 0>
				<cfif modo EQ 'CAMBIO'>
					<cfset SOcantidad = HTMLEditFormat(data.SOcantidad)>
				</cfif>
				
				<cf_campoNumerico 
					readonly="false" 
					name="SOcantidad" 
					decimales="0" 
					size="10" 
					maxlength="8" 
					value="#SOcantidad#" 
					tabindex="1">				
			</td>
		</tr>			
		<tr>
			<td align="right" valign="top">
				<label for="SOestado">Estado:</label>
			</td>
			<td width="1%" valign="top">&nbsp;</td>
			<td width="83%" valign="top">
				<cfif modo EQ 'CAMBIO'>
					#data.SOestadoDesc#
					<input type="hidden" name="SOestado" value="#data.SOestado#">
				<cfelse>
					Incluida
					<input type="hidden" name="SOestado" value="I">
				</cfif>					
			</td>
		</tr>			
		<tr>
			<td align="right" valign="top">
				<label for="SOobservaciones">Observaciones:</label>
			</td>
			<td width="1%" valign="top">&nbsp;</td>
			<td width="83%" valign="top">
				<textarea name="SOobservaciones" cols="75" rows="3" id="textarea" tabindex="1" onFocus="this.select()"><cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.SOobservaciones)#</cfif></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>		
		<tr>
			<td colspan="3" class="formButtons">
				<cfset incBot = "">
				<cfset excBot = "">
				<cfif modo NEQ 'ALTA'>
					<!--- Ya se llamo a la interfaz para esta solicitud --->
					<cfif data.SOenviada EQ 1>
						<cfset incBot = "Regresar">
						<cfset excBot = "Cambio,Baja">
					<cfelse>
						<cfset incBot = "Enviar_Solicitud,Regresar">
					</cfif>
				<cfelse>
					<cfset incBot = "Regresar">
					<cfset incBotValues = "Regresar">
				</cfif>
				<cf_botones modo="#modo#" exclude="#excBot#" include="#incBot#" includevalues="#incBot#" tabindex="1">
			</td>
		</tr>
	</table>
		<cfif modo NEQ 'ALTA' and isdefined('data')>			
			<input type="hidden" name="SOid" value="#form.SOid#">
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		</cfif>
	</form>
	
	<script type="text/javascript">
	<!--
		function validar(formulario){
			var error_input;
			var error_msg = '';

			if(!btnSelected('Regresar', formulario) && !btnSelected('Baja', formulario) && !btnSelected('Nuevo', formulario)){			
				if (formulario.SOtipo.value == "") {
					error_msg += "\n - Tipo de solicitud no puede quedar en blanco.";
					error_input = formulario.SOtipo;
				}
				if (formulario.SOfechasol.value == "") {
					error_msg += "\n - Fecha de la solicitud no puede quedar en blanco.";
					error_input = formulario.SOfechasol;
				}
				if (formulario.SOestado.value == "") {
					error_msg += "\n - El estado de la solicitud no puede quedar en blanco.";
					error_input = formulario.SOestado;
				}																	
				if (formulario.SOcantidad.value == "") {
					error_msg += "\n - La cantidad no puede quedar en blanco.";
					error_input = formulario.SOcantidad;
				}else{
					if (parseInt(formulario.SOcantidad.value) <= 0) {
						error_msg += "\n - La cantidad debe ser mayor a cero.";
						error_input = formulario.SOcantidad;
					}
				}
			}
						
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}
			
			if(btnSelected('A_Interfaz', formulario)){
				if(!confirm("Realmente desea enviar estos datos a la interfaz ?"))
					return false;
			}

			return true;
		}	
		function cambioTipo(obj){
			if(obj.value == "P"){
				document.getElementById("tipoP").style.display='';
				document.getElementById("tipoS").style.display='none';				
				document.getElementById("tipoS2").style.display='none';								
			}else{
				document.getElementById("tipoP").style.display='none';
				document.getElementById("tipoS").style.display='';				
				document.getElementById("tipoS2").style.display='';								
			}
		}
		cambioTipo(document.form1.SOtipo);
		-->
	</script>
</cfoutput>
