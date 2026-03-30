<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 01 de setiembre del 2005
	Motivo: Permitir ingresar el dato de identificación sin formato especifico. 
			Se quito la aplicación del formato (onblur="blur_cedula(this)").
 --->

<fieldset><legend>Datos Personales:</legend>
	<table width="100%"  align="center" cellpadding="0" cellspacing="0">
		<tr>
		  <td align="left" nowrap><strong>Nombre:</strong>&nbsp;</td>
		  <td colspan="2" align="left" nowrap ><strong>Identificaci&oacute;n:</strong>&nbsp;</td>
	  	</tr>
		<tr>
		  	<td align="left" nowrap>
				<input name="CDnombre" type="text" tabindex="1"
					value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDnombre)#</cfoutput></cfif>" 
					size="35" maxlength="100" onFocus="this.select();"  alt="El Nombre del Cliente">
			</td>
		  	<td colspan="2" align="left" nowrap><!--- onblur="blur_cedula(this)"   --->
				<input name="CDidentificacion" type="text" tabindex="1"  
					value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDidentificacion)#</cfoutput></cfif>" 
					size="35" maxlength="60" onFocus="this.select();" 
					alt="La Identificaci&oacute;n del Cliente">
			</td>
	  	</tr>
		<tr>
			<td align="left" nowrap width="50%"><strong>Primer Apellido:</strong>&nbsp;</td>
			<td colspan="2" align="left" nowrap width="50%"><strong>Segundo Apellido:</strong>&nbsp;</td>
		</tr>
		<tr>
			<td width="50%">
				<input name="CDapellido1" type="text" tabindex="1"
					value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDapellido1)#</cfoutput></cfif>" size="35" maxlength="80" onfocus="this.select();"  alt="El Primer apellido  del Cliente">
			</td>
			<td colspan="2" width="50%">
				<input name="CDapellido2" type="text" tabindex="1"
					value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsClienteDetallista.CDapellido2)#</cfoutput></cfif>" size="35" maxlength="80" onfocus="this.select();"  alt="El Segundo apellido  del Cliente">			
			</td>
		</tr>
		<tr>
			<td align="left" nowrap width="50%"><strong>Estado Civil:</strong></td>
			<td align="left" nowrap width="50%"><strong>Fecha Nacimiento:</strong>&nbsp;</td>
			<td align="left" nowrap width="25%"><strong>Sexo:</strong></td>
		</tr>
		<tr nowrap>
			<td nowrap valign="top" width="50%">
				<select name="CDcivil" id="CDcivil" tabindex="1">
				  <option value="0" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDcivil EQ 0> selected</cfif>>Soltero(a)</option>
				  <option value="1" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDcivil EQ 1> selected</cfif>>Casado(a)</option>
				  <option value="2" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDcivil EQ 2> selected</cfif>>Divorciado(a)</option>
				  <option value="3" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDcivil EQ 3> selected</cfif>>Viudo(a)</option>
				  <option value="4" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDcivil EQ 4> selected</cfif>>Union Libre</option>
				  <option value="5" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDcivil EQ 5> selected</cfif>>Separado(a)</option>
		  		</select>
			</td>
		  	<td valign="top" nowrap width="50%"><cfif modo NEQ 'ALTA'>
				<cfset fecha = dateformat(rsClienteDetallista.CDfechanac,"dd/mm/yyyy")>
				<cfelse>
					<cfset fecha = dateformat(Now(),"dd/mm/yyyy")>
				</cfif>
				<cf_sifcalendario form="form" value="#fecha#" name="CDfechanac" tabindex="1">
		 	</td>
			<td valign="top" nowrap width="25%">
		  		<select name="CDsexo" id="CDsexo" tabindex="1">
					<option value="M" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDsexo EQ 'M'> selected</cfif>>Masculino</option>
					<option value="F" <cfif modo NEQ 'ALTA' and rsClienteDetallista.CDsexo EQ 'F'> selected</cfif>>Femenino</option>
			  	</select>
			</td>
		</tr>
		<tr valign="middle">
			<td align="left" nowrap><strong>Tipo de Cliente:</strong>&nbsp; </td>
			<td colspan="2" align="left" nowrap><strong>Status:</strong></td>
	  	</tr>
		<tr valign="middle">
			<td align="left" nowrap> 
				<select name="CDTid" id="CDTid" tabindex="1">
	 				<option value="" <cfif modo NEQ 'ALTA' and rsClienteDetallistaTipo.CDTid EQ ''> selected</cfif>>No especificado</option>
				  	<cfoutput query="rsClienteDetallistaTipo"> 
					<option value="#rsClienteDetallistaTipo.CDTid#"<cfif modo NEQ 'ALTA' and rsClienteDetallista.CDTid EQ rsClienteDetallistaTipo.CDTid> selected</cfif>>#rsClienteDetallistaTipo.CDTdescripcion#</option>
				  </cfoutput>
			  </select>
			</td>
			<td colspan="2" align="left" nowrap>
				<cfif modo NEQ 'ALTA'><cfoutput>#rsClienteDetallista.rotulo#</cfoutput><cfelse>En Proceso</cfif>
			</td>
		</tr>
	</table>
</fieldset>		

