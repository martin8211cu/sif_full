<cfif isdefined("url.Aid")and len(trim(url.Aid))>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfif modo NEQ "ALTA">
	<cfquery datasource="#session.dsn#" name="data">
		select *
		from  ISBatributo
		where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Aid#" null="#Len(url.Aid) Is 0#">
	</cfquery>
</cfif>

<cfoutput>

<script type="text/javascript">
<!--
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	// Funciones para Manejo de Botones
	var botonActual = "";
	function validar(formulario)
	{
		if(botonActual != "Eliminar"){
			var error_input;
			var error_msg = '';
			// Validando tabla: ISBatributo - Atributo Extendido
			
					// Columna: Aetiq Etiqueta varchar(25)
					if (formulario.Aetiq.value == "") {
						error_msg += "\n - Etiqueta no puede quedar en blanco.";
						error_input = formulario.Aetiq;
					}
					// Columna: Adesc Descripcin varchar(1024)
					if (formulario.Adesc.value == "") {
						error_msg += "\n - Descripcin no puede quedar en blanco.";
						error_input = formulario.Adesc;
					}
					// Columna: AtipoDato Tipo de dato char(1)
					if (formulario.AtipoDato.value == "") {
						error_msg += "\n - Tipo de dato no puede quedar en blanco.";
						error_input = formulario.AtipoDato;
					}
					// Columna: Aorden Ordenamiento numeric
					if (formulario.Aorden.value == "") {
						error_msg += "\n - Ordenamiento no puede quedar en blanco.";
						error_input = formulario.Aorden;
					}else{
						if (parseInt(formulario.Aorden.value) == 0) {
							error_msg += "\n - Ordenamiento no puede ser cero.";
							error_input = formulario.Aorden;
						}
					}
					// Columna: AapFisica Aplica a persona fsica bit
					if (formulario.AapFisica.value == "") {
						error_msg += "\n - Aplica a persona fsica no puede quedar en blanco.";
						error_input = formulario.AapFisica;
					}
					// Columna: AapJuridica Aplica a persona jurdica bit
					if (formulario.AapJuridica.value == "") {
						error_msg += "\n - Aplica a persona jurdica no puede quedar en blanco.";
						error_input = formulario.AapJuridica;
					}
					// Columna: AapCuenta Aplica a Cuentas bit
					if (formulario.AapCuenta.value == "") {
						error_msg += "\n - Aplica a Cuentas no puede quedar en blanco.";
						error_input = formulario.AapCuenta;
					}
					// Columna: AapAgente Aplica a Agentes bit
					if (formulario.AapAgente.value == "") {
						error_msg += "\n - Aplica a Agentes no puede quedar en blanco.";
						error_input = formulario.AapAgente;
					}
					// Columna: Habilitado Habilitado bit
					if (formulario.Habilitado.value == "") {
						error_msg += "\n - Habilitado no puede quedar en blanco.";
						error_input = formulario.Habilitado;
					}
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}
		}
		return true;
	}
	function funcBaja(){
		botonActual = 'Eliminar';
	}
	function funcNuevo(){
		location.href = 'ISBatributo.cfm';
		return false;
	}
	function doConlisMantValores() {
		<cfset nomb="">
		<cfif modo NEQ "ALTA">
			<cfset nomb=UrlEncodedFormat(data.Aetiq)>
		</cfif>
		popUpWindow("ISBatributoValor.cfm?id_tipo="+document.form1.Aid.value+"&nombre=#nomb#",250,100,650,500);<!--- 250,100,650,500 --->
	}
//-->
</script>


<form action="ISBatributo-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1" style="margin:0">
	
	<!--- campos ocultos para la pagina y de los filtros --->
	<!--- <input type="Pagina" name="Pagina" value="#HTMLEditFormat(url.Pagina)#">
	<input type="Pagina" name="Filtro_Aetiq" value="#HTMLEditFormat(url.Filtro_Aetiq)#">
	<input type="Pagina" name="Filtro_Adesc" value="#HTMLEditFormat(url.Filtro_Adesc)#">
	<input type="Pagina" name="Filtro_AtipoDato" value="#HTMLEditFormat(url.Filtro_AtipoDato)#"> --->
	
	<cfif modo NEQ "ALTA">
		<input type="hidden" name="Aid" value="#HTMLEditFormat(data.Aid)#">
	</cfif>
	
	<table summary="Tabla de entrada" cellpadding="2" cellspacing="0" border="0" width="100%">
	
		<tr align="center"><td colspan="2"class="tituloAlterno">
			Datos
		</td></tr>
		<tr><td align="right" width="25%"><label>Etiqueta</label>
		</td><td valign="top">
		
			<input name="Aetiq" id="Aetiq" type="text" value="<cfif modo NEQ "ALTA">#HTMLEditFormat(data.Aetiq)#</cfif>" maxlength="25"  style="width: 100%"	onfocus="this.select()">
		
		</td></tr>
	
		<tr>
		  <td valign="top" align="right"><label>Descripci&oacute;n</label>		</td>
		  <td valign="top">
		<textarea name="Adesc" cols="30" rows="3" id="Adesc" style="width: 100%" onFocus="this.select()"><cfif modo NEQ "ALTA">#HTMLEditFormat(data.Adesc)#</cfif></textarea>		</td></tr>
		
		<tr><td align="right"><label>Tipo de dato</label>
		</td><td valign="top">
		
			<select name="AtipoDato" id="AtipoDato" tabindex="1">
			
				<option value="T" <cfif modo NEQ "ALTA"><cfif data.AtipoDato is 'T'>selected</cfif></cfif> >
					Texto				</option>
			
				<option value="V" <cfif modo NEQ "ALTA"><cfif data.AtipoDato is 'V'>selected</cfif></cfif> >
					Lista de valores				</option>
			
				<option value="F"<cfif modo NEQ "ALTA"><cfif data.AtipoDato is 'F'>selected</cfif></cfif> >
					Fecha				</option>
			
				<option value="N" <cfif modo NEQ "ALTA"><cfif data.AtipoDato is 'N'>selected</cfif></cfif> >
					Num&eacute;rico				</option>
			</select>
			<cfif modo NEQ "ALTA" and data.AtipoDato is 'V'>
				<input name="btnValores" id="btnValores" type="button" value="Valores" onClick="javascript:doConlisMantValores();">
			</cfif>
		</td></tr>
		
		<tr><td align="right"><label>Ordenamiento</label>
		</td><td valign="top">
			<cfset valAorden = "">
			<cfif modo NEQ 'ALTA'>
				<cfset valAorden = "#HTMLEditFormat(data.Aorden)#">
			</cfif>					
			
			<cf_campoNumerico 
				name="Aorden" 
				decimales="-1" 
				size="10" 
				maxlength="4" 
				value="#valAorden#" 
				tabindex="1">	
		</td></tr>
		
		<tr>
		<td align="right"><input name="AapFisica" id="AapFisica" type="checkbox" value="1" <cfif modo NEQ "ALTA"><cfif Len(data.AapFisica) And data.AapFisica> checked</cfif></cfif> tabindex="1"></td>
		<td valign="top" align="left">
			<label for="AapFisica">Aplica a persona f&iacute;sica </label></td>
		</tr>
		
		<tr>
		<td align="right"><input name="AapJuridica" id="AapJuridica" type="checkbox" value="1" <cfif modo NEQ "ALTA"><cfif Len(data.AapJuridica) And data.AapJuridica> checked</cfif></cfif> tabindex="1"></td>
		<td valign="top">
			<label for="AapJuridica">Aplica a persona jur&iacute;dica</label>
		</td>
		</tr>
		
		<tr>
		<td align="right"><input name="AapCuenta" id="AapCuenta" type="checkbox" value="1" <cfif modo NEQ "ALTA"><cfif Len(data.AapCuenta) And data.AapCuenta> checked</cfif></cfif> tabindex="1"></td>
		<td valign="top">
			<label for="AapCuenta">Aplica a Cuentas</label>
		</td>
		</tr>

		<tr>
		<td align="right"><input name="AapAgente" id="AapAgente" type="checkbox" value="1" <cfif modo NEQ "ALTA"><cfif Len(data.AapAgente) And data.AapAgente> checked</cfif></cfif> tabindex="1"></td>
		<td valign="top">
			<label for="AapAgente">Aplica a Agentes</label>
		</td>
		</tr>
		
		<tr>
		<td align="right"><input name="Habilitado" id="Habilitado" type="checkbox" value="1" <cfif modo NEQ "ALTA"><cfif Len(data.Habilitado) And data.Habilitado> checked</cfif></cfif> tabindex="1"></td>
		<td valign="top">
			<label for="Habilitado" >Habilitado</label>
		</td>
		</tr>
		
	<tr><td colspan="2" class="formButtons">
		<cf_botones regresar="" modo="#modo#" tabindex="1">
	</td></tr>
	</table>

</form>

</cfoutput>


<script language="javascript" type="text/javascript">
	function funcBaja(){
		if(!confirm('Desea borrar este atributo ?'))
			return false;
		return true;
	}
</script>