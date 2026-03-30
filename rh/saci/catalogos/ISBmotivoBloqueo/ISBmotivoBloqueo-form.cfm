
<!---cambio por berman, para validar que al borrar el motivo este asignado como parametro global--->

<cfset motivo_used = false>
	
<cfif isdefined('form.MBmotivo')>
	<cfquery datasource="#session.dsn#" name="check_param">
		select count(1) as tot from ISBparametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Pcodigo in (221,225,228)
		  and Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MBmotivo#">
	</cfquery>
		

	<cfif check_param.recordCount gt 0 and check_param.tot gt 0>
		<cfset motivo_used = true>
	</cfif>
</cfif>

<!---Fin cambio por berman //Query// & set de valor--->

<cfquery datasource="#session.dsn#" name="param">
	select Pvalor from ISBparametros 
    where Ecodigo = 235
      and Pcodigo = 777
</cfquery>

<cfset mayus = false>
<cfif param.recordCount gt 0 and param.Pvalor eq "TRUE">
	<cfset mayus = true>
</cfif>

<cfif isdefined('form.MBmotivo') and form.MBmotivo NEQ ''>
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<cfparam name="form.MBmotivo" default="">

<cfquery datasource="#session.dsn#" name="data">
	select 
		MBmotivo
		, Ecodigo
		, MBdescripcion
		, Habilitado
		, MBconCompromiso
		, MBsinCompromiso
		, MBautogestion
		, BMUsucodigo
		, MBdesbloqueable
		, MBbloqueable
		, MBagente
		, ts_rversion
	from  ISBmotivoBloqueo
	where MBmotivo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.MBmotivo#" null="#Len(form.MBmotivo) Is 0#">
</cfquery>

<cfoutput>
	<script type="text/javascript">
	<!--
		function validar(formulario){
			var error_input;
			var error_msg = '';
			// Validando tabla: ISBmotivoBloqueo - Motivos de Bloqueo
			
			if(btnSelected('Baja', formulario))
				return true;

			
			if (! (/^[A-Za-z]*$/.test(formulario.MBmotivo.value))) 
			{
				error_msg += "\n - El campo Motivo sólo se permite el ingreso de letras.";
				error_input = formulario.MBmotivo;
			}
			
			
			<!--- if(!btnSelected('Regresar', formulario)) --->
			if(!btnSelected('Regresar', formulario) && !btnSelected('Baja', formulario) && !btnSelected('Nuevo', formulario))
			{
			
				// Columna: MBmotivo Motivo char(2)
				if (formulario.MBmotivo.value == "") 
				{
					error_msg += "\n - Motivo no puede quedar en blanco.";
					error_input = formulario.MBmotivo;
				}

				// Columna: MBdescripcion Descripción varchar(1024)
				if (formulario.MBdescripcion.value == "") 
				{
					error_msg += "\n - Descripción no puede quedar en blanco.";
					error_input = formulario.MBdescripcion;
				}
		
				// Columna: Habilitado Habilitado smallint
				if (formulario.Habilitado.value == "") 
				{
					error_msg += "\n - Habilitado no puede quedar en blanco.";
					error_input = formulario.Habilitado;
				}
			}
			
			// Validacion terminada
			if (error_msg.length != "") 
			{
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}
			return true;
		}
		
		function funcNuevo()
		{
			location.href = 'ISBmotivoBloqueo-edit.cfm';
			return false;
		}
		
		///cambio de Berman---!
		function funcBaja()
		{
			<cfif motivo_used>
				if (!confirm("El motivo está asignado como Parámetro Global\n¿Desea continuar?"))
				{
					return false;
				}
				else
				{	
					document.form1.delParam.value = "Y";
				}
			<cfelse>
				return true;
			</cfif>
		}
		///fin de cambio de Berman---!
	//-->
	</script>
	<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
	<form action="ISBmotivoBloqueo-apply.cfm" onsubmit="return validar(this);"  enctype="multipart/form-data" method="post" name="form1" id="form1">
		<cfinclude template="ISBmotivoBloqueo-hiddens.cfm">
		<input type="hidden" value="N" name="delParam" id="delParam" />
		<table width="100%" border="0" cellpadding="0" cellspacing="2" summary="Tabla de entrada">
			<tr>
				<td colspan="4" class="subTitulo">
					Motivos de Bloqueo
				</td>
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>		
			<tr>
				<td width="248" align="right" valign="top">
					<label for="MBmotivo">Motivo:</label>
				</td>
				<td colspan="3" valign="top">
					<input name="MBmotivo" type="text" id="MBmotivo" tabindex="1"
						onfocus="this.select()" 
						onblur="javascript: validaBlancos(this);"
						value="#Trim(HTMLEditFormat(data.MBmotivo))#" size="4" 
						<cfif modo NEQ 'ALTA'>
							readonly="true"						
						</cfif>
						maxlength="2"  >
					
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="MBdescripcion">Descripci&oacute;n:</label>
				</td>
				<td colspan="3" valign="top">
					<textarea name="MBdescripcion" 
						cols="77" rows="3" id="MBdescripcion" 
						onblur="javascript: validaBlancos(this);" 
						<cfif mayus>
						onblur="this.value = this.value.toUpperCase();"
						</cfif>						
						tabindex="1" 						 
						onFocus="this.select()">#HTMLEditFormat(data.MBdescripcion)#</textarea>
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="Habilitado">Estado:</label>
				</td>
				<td colspan="3" valign="top">
					<select name="Habilitado" id="Habilitado" tabindex="1">
						<option value="0" <cfif data.Habilitado is '0'>selected</cfif> >
							Inactivo temporal
						</option>
						<option value="1" <cfif data.Habilitado is '1'>selected</cfif> >
							Activo
						</option>
						<option value="3" <cfif data.Habilitado is '3'>selected</cfif> >
							En creaci&oacute;n
						</option>
					</select>
				</td>
			</tr>
			<tr>
				<td align="right" valign="top">
					<label for="Con Compromiso">Con Compromiso:</label>
				</td>
				<td width="153" valign="top"><input type="checkbox" name="MBconCompromiso" id="MBconCompromiso" value="1" <cfif isdefined('data') and data.MBconCompromiso EQ 1> checked</cfif>>

				</td>
			<td width="256" valign="top" align="right"><label for="MBdesbloqueable">Permite Desbloqueo por Pantalla:</label></td>
			<td width="305" valign="top"><input type="checkbox" name="MBdesbloqueable" id="MBdesbloqueable" value="1" <cfif isdefined('data') and data.MBdesbloqueable EQ 1> checked</cfif>></td>
			</tr>
			
						
			<tr>
				<td align="right"><label for="Con Compromiso">Autogesti&oacute;n:</label></td>
				<td>				   
			      <input type="checkbox" name="MBautogestion" id="MBautogestion" value="1" <cfif isdefined('data') and data.MBautogestion EQ 1> checked</cfif>> 
			    </td>
			<td align="right"><label for="MBBloqueable">Permite Bloqueo por Pantalla:</label></td>
			<td><input type="checkbox" name="MBbloqueable" id="MBbloqueable" value="1" <cfif isdefined('data') and data.MBbloqueable EQ 1> checked</cfif>></td>
			</tr>
			<tr>
			<td align="right"><label for="Agentes">Utilizar Agente:</label></td>
			<td>				   
			    <input type="checkbox" name="MBagente" id="MBagente" value="1" <cfif isdefined('data') and data.MBagente EQ 1> checked</cfif>> 
			</td>   				
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>	
			<tr><td colspan="4">&nbsp;</td></tr>		
			<tr>
				<td colspan="4" class="formButtons">
					<cf_botones modo="#modo#" tabindex="1" include="Regresar" includeValues="Regresar">
				</td>
			</tr>
	  	</table>
		<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(data.Ecodigo)#">
		<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
		<input type="hidden" name="MBsinCompromiso" value="#HTMLEditFormat(data.MBsinCompromiso)#">		
		
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</form>
</cfoutput>