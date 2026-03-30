<cfset modoAux =  'ALTA'>
<cfif isdefined("form.SSdestino") and isdefined("form.SMdestino") and isdefined("form.SPdestino")>
	<cfset modoAux =  'CAMBIO'>

	<cfquery name="data" datasource="asp" >
		select SSorigen, SMorigen, SPorigen, SSdestino, SMdestino, SPdestino, posicion, ocultar, ts_rversion
		from SProcesoRelacionado
		where SSorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SScodigo)#"> 
		  and SMorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SMcodigo)#"> 
		  and SPorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SPcodigo)#"> 
		  and SSdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SSdestino)#"> 
		  and SMdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SMdestino)#">
		  and SPdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SPdestino)#">
	</cfquery>

</cfif>

<cfoutput>
<table width="99%" cellpadding="2" cellspacing="0">
	<tr><td align="center" colspan="2" class="tituloPersona" style="text-align:center;">Procesos Relacionados</td></tr>

	<form style="margin:0;" name="form2" method="post" action="procesos-sql.cfm" onSubmit="return validar(this);">
		<!--- Sistema --->
		<tr>
			<td align="right" class="etiquetaCampo">Sistema:&nbsp;</td>
			<td align="left">
				<cfif modoAux eq 'ALTA'>
					<cfset defaultSScodigo="">
					<cfif IsDefined("form.fSScodigo") and not isdefined("form.SScodigo")>
						<cfset form.SScodigo = form.fSScodigo>
					</cfif>
					<cfif IsDefined("form.fSMcodigo") and not isdefined("form.SMcodigo")>
						<cfset form.SMcodigo = form.fSMcodigo>
					</cfif>
					<cfif isdefined("form.SScodigo")><cfset defaultSScodigo=form.SScodigo>
					<cfelseif isdefined("form.fSScodigo")><cfset defaultSScodigo=form.fSScodigo>
					</cfif>
					<select name="SSdestino" onChange="javascript:modulo_relacionado(this, document.form2);">
						<cfloop query="rsSistemas">
							<option value="#Trim(rsSistemas.SScodigo)#" <cfif Trim(defaultSScodigo) eq Trim(rsSistemas.SScodigo) >selected</cfif> >#rsSistemas.SSdescripcion#</option>
						</cfloop>
					</select>
				<cfelse>
					<cfquery name="sistema" datasource="asp" >
						select SScodigo, SSdescripcion
						from SSistemas
						where SScodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SSdestino)#">
					</cfquery>
					<b>#sistema.SScodigo# - #sistema.SSdescripcion#</b>
					<input name="SSdestino" type="hidden" value="#Trim(form.SSdestino)#">
				</cfif>	
			</td>
		</tr>

		<!--- Modulo --->
		<tr>
			<td align="right" class="etiquetaCampo" >M&oacute;dulo:&nbsp;</td>
			<td align="left">
				<cfif modoAux eq 'ALTA'>
					<select name="SMdestino"></select>
				<cfelse>
					<cfquery name="modulo" datasource="asp">
						select SMcodigo, SMdescripcion
						from SModulos
						where SScodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SSdestino)#">
						and SMcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SMdestino)#">
					</cfquery>
					<b>#modulo.SMcodigo# - #modulo.SMdescripcion#</b>
					<input name="SMdestino" type="hidden" value="#Trim(form.SMdestino)#">
				</cfif>
			</td>
		</tr>

		<tr>
			<td align="right" class="etiquetaCampo" >Proceso:&nbsp;</td>
			<td valign="top">
				<input type="hidden" name="SPdestino" value="<cfif modoAux neq 'ALTA'>#form.SPdestino#</cfif>">
				
				<cfif modoAux neq 'ALTA'>
					<cfquery name="dataProceso" datasource="asp">
						select SPdescripcion
						from SProcesos
						where SScodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SSdestino)#">
						  and SMcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SMdestino)#">
						  and SPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.SPdestino)#">
					</cfquery>
					<b>#form.SPdestino# - #dataProceso.SPdescripcion#</b>
				<cfelse>
					<input type="text" name="SPproceso" readonly size="55" maxlength="255" onFocus="this.select();" value="" >
					<a href="##"><img src="../../imagenes/Description.gif" alt="Lista de Procesos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisProcesos();"></a> 
				</cfif>
			</td>
		</tr>
		
		<!--- Posicion --->
		<tr>
			<td align="right" class="etiquetaCampo" >Posici&oacute;n:&nbsp;</td>
			<td align="left">
				<input type="text" name="posicion" size="4" maxlength="4" value="<cfif modoAux neq 'ALTA'>#data.posicion#</cfif>" onFocus="this.select();" >
			</td>
		</tr>

		<!--- ocultar --->
		<tr>
			<td align="right" class="etiquetaCampo" ></td>
			<td align="left">
				<input type="checkbox" style="border:0;" name="ocultar" <cfif modoAux neq 'ALTA' and data.ocultar eq 1>checked</cfif>>&nbsp;Ocultar
			</td>
		</tr>

		<!--- bidireccion --->
		<cfif modoAux eq 'ALTA'>
			<tr>
				<td align="right" class="etiquetaCampo" ></td>
				<td align="left">
					<input type="checkbox" style="border:0;" name="bidireccion" >&nbsp;Establecer relaci&oacute;n de forma bidireccional
				</td>
			</tr>
		</cfif>

		<tr>
			<td colspan="2" align="center">
				<cfif modoAux eq 'ALTA'>
					<input type="submit" name="AgregarRelacionado" value="Agregar">
				<cfelse>	
					<input type="submit" name="ModificarRelacionado" value="Modificar">
					<input type="submit" name="EliminarRelacionado" value="Eliminar" onClick="return confirm('Desea eliminar el registro?');">
					<input type="submit" name="Nuevo" value="Nuevo" >
				</cfif>
			</td>
		</tr>

		<input name="SScodigo" type="hidden" value="#Trim(form.SScodigo)#">
		<input name="SMcodigo" type="hidden" value="#Trim(form.SMcodigo)#">
		<input name="SPcodigo" type="hidden" value="#Trim(form.SPcodigo)#">

	</form>
		
	<cfquery name="dataRelacionados" datasource="asp">
		select SSdestino, SMdestino, SPdestino, SPdescripcion, '#trim(form.SScodigo)#' as SScodigo, '#trim(form.SMcodigo)#' as SMcodigo , '#trim(form.SPcodigo)#' as SPcodigo 
		from SProcesoRelacionado a
		
		inner join SProcesos b
		on a.SSdestino=b.SScodigo
		  and a.SMdestino=b.SMcodigo
		 and a.SPdestino=b.SPcodigo
		
		where a.SSorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SScodigo)#" >
		  and a.SMorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SMcodigo)#" >
		  and a.SPorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SPcodigo)#" >
		
		order by a.posicion  
	</cfquery>			  

		<tr><td align="center" colspan="2" >
			<table width="98%" align="center" border="0" cellpadding="2" cellspacing="0">
				<tr><td>
				<cfinvoke 
				 component="commons.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#dataRelacionados#"/>
					<cfinvokeargument name="desplegar" value="SPdescripcion"/>
					<cfinvokeargument name="etiquetas" value="Proceso"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="align" value="left"/>
					<cfinvokeargument name="formName" value="relacionados"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="procesos.cfm"/>
					<cfinvokeargument name="maxRows" value="0"/>
					<cfinvokeargument name="conexion" value="asp"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
				</cfinvoke>
				</td></tr>
			</table>	
		</td></tr>	
</table>

<script language="javascript1.2" type="text/javascript">
	// ---------------------------------------------------
	// FUNCIONES PARA LA PARTE DE RELACION ENTRE PROCESOS
	// ---------------------------------------------------
	<cfif modo neq 'ALTA'>
		function validar(form){
			var error = false;
			var mensaje = 'Se presentaron los siguientes errores:\n';
			if ( form.SSdestino.value == '' ){
				error = true;
				mensaje += ' - El campo Sistema es requerido.\n'
			}
			
			if ( form.SMdestino.value == '' ){
				error = true;
				mensaje += ' - El campo Módulo es requerido.\n'
			}
	
			if ( form.SPdestino.value == '' ){
				error = true;
				mensaje += ' - El campo Proceso es requerido.\n'
			}
			
			if ( isNaN(document.form2.posicion.value) ){
				document.form2.posicion.value = '';
			}
			
			if (error){
				alert(mensaje);
			}
			
			return !error;
		}
		
		function modulo_relacionado(obj, form){
			combo = form.SMdestino;
			combo.length = 0;
			var cont = 0;
	
			<cfloop query="rsModulos">
			if ( obj.value == '<cfoutput>#Trim(rsModulos.SScodigo)#</cfoutput>' ) {
				combo.length = cont+1;
				combo.options[cont].value = '<cfoutput>#Trim(rsModulos.SMcodigo)#</cfoutput>';
				combo.options[cont].text = '<cfoutput>#rsModulos.SMdescripcion#</cfoutput>';	
				
				<cfif modo neq 'ALTA' and rsModulos.SMcodigo eq form.SMcodigo >
					combo.options[cont].selected = true;
				<cfelseif isdefined("form.fSMcodigo") and #trim(rsModulos.SMcodigo)# eq #trim(form.fSMcodigo)# >
					combo.options[cont].selected = true;
				</cfif>
				
				cont++; 
			}
			</cfloop>
		}
		<cfif modoAux eq 'ALTA'>
		modulo_relacionado(document.form2.SSdestino, document.form2 )
		</cfif>

		function procesar_relacionado(sistema, modulo, proceso){
			document.form2.SSdestino.value = sistema;
			document.form2.SMdestino.value = modulo;
			document.form2.SPdestino.value = proceso;
			document.form2.action = '';
			document.form2.submit();
		}
		
	</cfif>
</script>
</cfoutput>