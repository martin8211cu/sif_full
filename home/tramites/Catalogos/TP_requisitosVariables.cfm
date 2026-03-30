<cfset modoreq2 = 'ALTA' >
<cfif isdefined("form.id_dato")>
	<cfset modoreq2 = 'CAMBIO' >
</cfif>
<cfif modoreq2 neq 'ALTA'>
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		select * 
		from TPDatoRequisito
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#" >
		and id_dato = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_dato#">
	</cfquery>
	<cfquery name="rsDatos2" datasource="#session.tramites.dsn#">
		select * 
		from TPCriterioAprobacion
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#" >
		and id_dato = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_dato#">
	</cfquery>	
</cfif>

<cfoutput>
<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="50%" valign="top">
		<form name="form5" method="post" style="margin:0;"  action="TP_requisitosVariablessql.cfm" onsubmit="return validar2();">
		<table width="100%" cellpadding="2" cellspacing="0">
				<tr><td bgcolor="##ECE9D8" style="padding:3px;" colspan="2"><font size="1"><cfif modoreq2 eq 'ALTA'>Agregar<cfelse>Modificar</cfif>&nbsp;Datos al requisito</font></td></tr>
				<tr><td>&nbsp;</td></tr>			
				<tr valign="baseline"> 
					<td width="19%" align="right" nowrap>C&oacute;digo:</td>
					<td width="81%">
						<input type="text" name="codigo_dato" id="codigo_dato" style="text-transform:uppercase;" 
						value="<cfif modoreq2 NEQ "ALTA">#trim(rsDatos.codigo_dato)#</cfif>" 
						size="10" maxlength="10" onfocus="javascript:this.select();" >
					</td>
				</tr>
				<tr valign="baseline"> 
					<td nowrap align="right">Nombre:</td>
					<td>
					  <input type="text" name="nombre_dato" 
						value="<cfif modoreq2 NEQ "ALTA">#rsDatos.nombre_dato#</cfif>" 
						size="30" maxlength="30" onFocus="javascript:this.select();" >
					</td>
				</tr>
				<tr valign="baseline"> 
					<td nowrap align="right">Tipo de Dato:</td>
					<td>
						<select name="tipo_dato" onChange="javascript: Activacampos(this.value);">
							<cfif modoreq2 EQ "ALTA">
								<option value="">-Seleccione un tipo-</option>
							</cfif>
							<option value="F" <cfif modoreq2 NEQ "ALTA" and  isdefined('rsDatos.tipo_dato') and rsDatos.tipo_dato eq 'F'>selected</cfif>>Fecha</option>
							<option value="N" <cfif modoreq2 NEQ "ALTA" and  isdefined('rsDatos.tipo_dato') and rsDatos.tipo_dato eq 'N'>selected</cfif>>Numérico</option>
							<option value="B" <cfif modoreq2 NEQ "ALTA" and  isdefined('rsDatos.tipo_dato') and rsDatos.tipo_dato eq 'B'>selected</cfif>>SI/NO</option>
							<option value="S" <cfif modoreq2 NEQ "ALTA" and  isdefined('rsDatos.tipo_dato') and rsDatos.tipo_dato eq 'S'>selected</cfif>>Alfanumérico</option>
						</select>	
					</td>
				</tr>
				<tr id="TRNO" style="display:none" valign="baseline"> 
					<td  align="right">&nbsp;</td>
					<td>
						<input type="radio" name="Tpo_Formato" id="con_tipo" onClick="javascript: Activatexto(this.value);"
							<cfif modoreq2  NEQ "ALTA" and  isdefined('rsDatos.lista_valores')  and Len(trim(rsDatos.lista_valores)) eq 0>checked <cfelseif modoreq2 EQ "ALTA">checked</cfif>
							value="NO">
						<label for="con_tipo">&nbsp;Formato Libre</label>
					</td>
				</tr>		
				<tr  id="TRSI" style="display:none" valign="baseline"> 
					<td   align="right">&nbsp;</td>
					<td>
						<input type="radio" name="Tpo_Formato" id="con_tipo" onClick="javascript: Activatexto(this.value);"
							<cfif modoreq2  NEQ "ALTA" and  isdefined('rsDatos.lista_valores')  and Len(trim(rsDatos.lista_valores)) gt 0>checked</cfif>
							value="SI">
						<label for="con_tipo">&nbsp;Permite solamente estos valores (separados por comas) </label></td>
				</tr>		
				<tr id="TRTEXT" style="display:none" valign="baseline"> 
					<td   align="right">&nbsp;</td>
					<td>
					  <input type="text" name="lista_valores" 
						value="<cfif modoreq2 NEQ "ALTA">#rsDatos.lista_valores#</cfif>" 
						size="50" maxlength="255" onFocus="javascript:this.select();" >
					</td>
				</tr>		
				<tr valign="baseline"> 
					<td nowrap align="right">Criterio de Aprobaci&oacute;n:</td>
					<td>
						<select name="operador">
							<cfif modoreq2 EQ "ALTA" or rsDatos2.recordcount eq 0>
								<option value="">-Seleccione un operador-</option>
							</cfif>
							<option value="="  <cfif modoreq2 NEQ "ALTA" and  isdefined('rsDatos2.operador') and rsDatos2.operador eq '='>selected</cfif>>Igual a</option>
							<option value="!=" <cfif modoreq2 NEQ "ALTA" and  isdefined('rsDatos2.operador') and rsDatos2.operador eq '!='>selected</cfif>>Diferente a</option>
							<option value="<=" <cfif modoreq2 NEQ "ALTA" and  isdefined('rsDatos2.operador') and rsDatos2.operador eq '<='>selected</cfif>>Menor Igual que</option>
							<option value="<"  <cfif modoreq2 NEQ "ALTA" and  isdefined('rsDatos2.operador') and rsDatos2.operador eq '<'>selected</cfif>>Menor que</option>
							<option value=">=" <cfif modoreq2 NEQ "ALTA" and  isdefined('rsDatos2.operador') and rsDatos2.operador eq '>='>selected</cfif>>Mayor Igual que</option>
							<option value=">"  <cfif modoreq2 NEQ "ALTA" and  isdefined('rsDatos2.operador') and rsDatos2.operador eq '>'>selected</cfif>>Mayor que</option>
						</select>
						&nbsp;	
						<input type="text" name="valor" 
						value="<cfif modoreq2 NEQ "ALTA">#rsDatos2.valor#</cfif>" 
						size="30" maxlength="30" onFocus="javascript:this.select();" >
					</td>
				</tr>				
				<tr>
					<td colspan="4" align="center">
						<cfif modoreq2 neq 'ALTA'>
							<input type="submit" name="Modificar" value="Modificar">
							<input type="submit" name="Eliminar" value="Eliminar" onClick="javascript: if ( confirm('Desea eliminar el registro?') ){  deshabilitarValidacion(); return true;} return false;">
							<input type="button" name="Nuevo" value="Nuevo" onClick="javascript:location.href='Tp_Requisitos.cfm?id_requisito=#form.id_requisito#&tab=4';">
						<cfelse>
							<input type="submit" name="Agregar" value="Agregar" >
						</cfif>
						<input type="button" name="Lista" value="Ir a lista" onClick="javascript:location.href='Tp_RequisitosList.cfm';">
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
			<cfset ts = "">
			<cfif modoreq2 NEQ "ALTA">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsDatos.ts_rversion#" returnvariable="ts"></cfinvoke>
			</cfif>
			<input type="hidden" name="ts_rversion" value="<cfif modoreq2 NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
			<input type="hidden" name="id_requisito" value="#form.id_requisito#" >
			<input type="hidden" name="id_dato" value="<cfif modoreq2 NEQ "ALTA"><cfoutput>#rsDatos.id_dato#</cfoutput></cfif>">
		</form>
		<script type="text/javascript" language="javascript1.2">
			function validar2(){
				var msj = '';
				
				if ( document.form5.codigo_dato.value == '' ){
					var msj = msj + ' - El código es requerido.\n';
				}
				if ( document.form5.nombre_dato.value == '' ){
					var msj = msj + ' - El Nombre es requerido.\n';
				}
				if ( document.form5.tipo_dato.value == '' ){
					var msj = msj + ' - El tipo es requerido.\n';
				}		
				if ( document.form5.tipo_dato.value == 'S' && document.form5.Tpo_Formato.value == 'SI'){
					if ( document.form5.lista_valores.value == '' ){
						var msj = msj + ' - la lista de valores es requerida.\n';
					}		
				}
				if ( document.form5.operador.value != '' ){
					if ( document.form5.valor.value == '' ){
						var msj = msj + ' - El valor del criterio de evaluación es requerido.\n';
					}	
				}			
				if ( msj != ''){
					msj = 'Se presentaron los siguientes errores:\n' + msj;
					alert(msj)
					return false;
				}
				return true
			}
			function Activacampos(valor){
				if(valor=='S'){
					document.getElementById('TRSI').style.display = '';
					document.getElementById('TRNO').style.display = '';
				}
				else{
					document.getElementById('TRSI').style.display = 'none';
					document.getElementById('TRNO').style.display = 'none';
				}
			}
			function Activatexto(valor){
				if(valor == 'SI'){
					document.getElementById('TRTEXT').style.display = '';
				}
				else{
					document.getElementById('TRTEXT').style.display = 'none';
				}
			}
			<cfif modoreq2 NEQ "ALTA">
				Activacampos(document.form5.tipo_dato.value);
				if ( document.form5.tipo_dato.value == 'S' && document.form5.lista_valores.value != ''){
					document.getElementById('TRTEXT').style.display = '';
				}
			</cfif>	
		</script>
	</td>
	<td width="50%" valign="top">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td bgcolor="##ECE9D8" style="padding:3px;" colspan="2"><font size="1">Datos del requisito</font></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>
					<cfquery name="rsLista3" datasource="#session.tramites.dsn#">
						select id_dato,id_requisito,codigo_dato,nombre_dato , '4' as tab  
						from TPDatoRequisito
						where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
						order by nombre_dato
					</cfquery>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista3#"/>
						<cfinvokeargument name="desplegar" value="codigo_dato,nombre_dato"/>
						<cfinvokeargument name="etiquetas" value="Código,Nombre"/>
						<cfinvokeargument name="formatos" value="V,V"/>
						<cfinvokeargument name="align" value="left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="Tp_Requisitos.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys" value="id_dato,id_requisito,tab"/>
						<cfinvokeargument name="formname" value="lista3"/>
					</cfinvoke>
				</td>
			</tr>
		</table>				
	</td>
</tr>
</table>


</cfoutput>


