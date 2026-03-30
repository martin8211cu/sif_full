<cfif isdefined("url.SNCcodigo") and (url.SNCcodigo gt 0) and not isdefined("form.SNCcodigo")>
	<cfset form.SNCcodigo = url.SNCcodigo>
</cfif>
<cfset modo = "ALTA">

<cfif isDefined("Form.SNCcodigo") and len(trim(#Form.SNCcodigo#)) NEQ 0> <!--- me lo da la lista --->
	<cfquery name="rsConsulta" datasource="#Session.DSN#">
		Select CEcodigo, SNCcodigo, SNCidentificacion, SNCtipo, SNCnombre, SNCdireccion, Ppais, SNCtelefono, 
			SNCFax, SNCemail, LOCidioma, SNCcertificado, SNCactivoportal, SNCrlegal, 
			SNCfecha, ts_rversion
		from SNegociosCorporativo
		where SNCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCcodigo#">
	</cfquery>
	<cfif rsConsulta.recordcount GT 0>
		<cfset modo = "CAMBIO">
	</cfif>
</cfif>

<cfquery name="rsIdiomas" datasource="sifcontrol">
	select rtrim(Icodigo) as LOCIdioma, Descripcion as LOCIdescripcion
	from Idiomas
	order by 1, 2
</cfquery>

<!--- ****** Lista de paises **********************************  --->
<cfquery name="rsPaises" datasource="asp">
	select Ppais, Pnombre
	from Pais
</cfquery>


<style type="text/css">
	.cuadro{
		border: 1px solid 999999;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: CCCCCC;
	}
</style>

<cf_templatecss>
<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>

<cfoutput>
<form name="form1" method="post" action="SNcorporativo-SQL.cfm">
<cfif modo NEQ 'ALTA'> 
<fieldset><legend>Socio de Negocios Corporativo:</legend>
<table width="50%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="3" align="left" valign="baseline" class="tituloListas subTitulo" nowrap>Datos Generales </td>
		<td width="9">&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline" >Nombre:&nbsp;</td>
		<td valign="baseline" >&nbsp;</td>
	</tr>
	<tr> 
		<td align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline" >
			<input type="text" name="SNCnombre" style="width:400px" maxlength="255" size="75" value="<cfif modo NEQ "ALTA">#rsConsulta.SNCnombre#</cfif>" onFocus="javascript:this.select();">
		</td>
		<td valign="baseline" >&nbsp;</td>
	</tr>
	<tr>
		<td valign="baseline" nowrap>&nbsp;</td>
		<td valign="baseline" >C&eacute;dula o Identificaci&oacute;n:&nbsp;</td>
		<td valign="baseline" >Tipo&nbsp;de&nbsp;persona:</td>
		<td valign="baseline" >&nbsp;</td>
	</tr>
	<tr>
		<td valign="baseline" nowrap><div align="right"></div></td>
		<td valign="baseline" >
			<input type="text" name="SCNidentificacion" size="30"  value="<cfif #modo# NEQ "ALTA">#trim(rsConsulta.SNCidentificacion)#</cfif>" onFocus="javascript:this.select();" onBlur="javascript:validar_identificacion(this);" alt="El campo Identificación del socio">
		</td>
	    <td valign="baseline" >
			<cfif isdefined("rsConsulta") and rsConsulta.SNCtipo EQ 'F'>
				Físico
			<cfelseif isdefined("rsConsulta") and rsConsulta.SNCtipo EQ 'J'>
				Jurídico
			<cfelseif isdefined("rsConsulta") and rsConsulta.SNCtipo EQ 'E'>
				Extranjero
			</cfif>
		</td>
	    <td valign="baseline" >&nbsp;</td>
	</tr>
	<tr>
		<td valign="baseline" align="right" nowrap>&nbsp;</td>
		<td valign="baseline">Tel&eacute;fono:</td>
		<td valign="baseline">Fax:&nbsp;</td>
		<td valign="baseline">&nbsp;</td>
	</tr>
	<tr>
		<td valign="baseline" align="right" nowrap>&nbsp;</td>
		<td valign="baseline"> 
			<input name="SNCtelefono" type="text" size="30" maxlength="30" value="<cfif #modo# NEQ "ALTA">#trim(rsConsulta.SNCtelefono)#</cfif>" onFocus="javascript:this.select();">
		</td>
		<td valign="baseline"><input name="SNCFax" type="text" onFocus="javascript:this.select();" value="<cfif modo NEQ "ALTA">#trim(rsConsulta.SNCFax)#</cfif>" size="30" maxlength="30"></td>
		<td valign="baseline">&nbsp;</td>
	</tr>

	<tr>
		<td align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline">Correo electr&oacute;nico </td>
		<td valign="baseline">&nbsp;</td>
	</tr>
	<tr>
		<td height="26" align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline"> 
			<input name="SNCemail" type="text" size="75" style="width:400px"  maxlength="100" value="<cfif modo NEQ "ALTA">#rsConsulta.SNCemail#</cfif>" onFocus="javascript:this.select();">
		</td>
		<td valign="baseline">&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline">Pa&iacute;s </td>
		<td valign="baseline">&nbsp;</td>
	</tr>
	<tr>
		<td height="26" align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline"> 
			<select name="LPaises" id="LPaises">
				<option value="">- No especificado -</option> 
					<cfloop query="rsPaises">
						<option value="#rsPaises.Ppais#" <cfif modo NEQ 'ALTA' and rsPaises.Ppais EQ rsConsulta.Ppais>selected</cfif>>#HTMLEditFormat(rsPaises.Pnombre)#</option></cfloop>
			</select></td>			
		<td valign="baseline">&nbsp;</td>
	</tr>
	
	<tr>
		<td height="26" align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline"> 	
			<input type="checkbox" name="SNCcertificado" id="SNCcertificado" <cfif modo NEQ "ALTA" and rsConsulta.SNCcertificado eq 9999 >disabled</cfif> value="1" 
			<cfif modo NEQ "ALTA" and rsConsulta.SNCcertificado EQ 1>checked</cfif>>
		  <label for="SNinactivo">Certificado ISO </label></td>
		 </td>
	</tr>
	<tr>
		<td valign="baseline" align="right">&nbsp;</td>
		<td colspan="2" valign="baseline">Fecha:&nbsp;</td>
		<td valign="baseline">&nbsp;</td>
	</tr>
	<tr> 
		<td valign="baseline" align="right">&nbsp;</td>
		<td colspan="2" valign="baseline"> 
			<input type="text" name="SNCFecha" readonly="" size="12" value="<cfif #modo# NEQ "ALTA">#LSDateFormat(rsConsulta.SNCFecha, 'dd/mm/yyyy')#<cfelse>#LSDateFormat(Now(),"DD/MM/YYYY")#</cfif>">
		</td>
	    <td valign="baseline">&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline" >Idioma:&nbsp;</td>
		<td valign="baseline" >&nbsp;</td>
	</tr>
	<tr> 
		<td align="right" valign="baseline" nowrap>&nbsp;</td>
		<td colspan="2" valign="baseline" >
			<select name="LOCIdioma" id="LOCIdioma">
				<option value="-1">-- Ninguno --</option>			
				<cfloop query="rsIdiomas">
					<option value="#rsIdiomas.LOCIdioma#" <cfif modo NEQ 'ALTA' and rsIdiomas.LOCIdioma EQ rsConsulta.LOCIdioma>selected</cfif>>#HTMLEditFormat(rsIdiomas.LOCIdescripcion)#</option>
				</cfloop>
			</select>
		</td>
		<td valign="baseline" >&nbsp;</td>
	</tr>	
	<tr>
		<td align="right" valign="middle" nowrap>&nbsp;</td>
		<td colspan="2">Direcci&oacute;n:&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="middle" nowrap>&nbsp;</td>
		<td colspan="2">
			<textarea name="SNCdireccion" cols="75" rows="3" style="width:400px;font-family:Arial, Helvetica, sans-serif;font-size:10px " onFocus="javascript:this.select();"><cfif #modo# NEQ "ALTA">#trim(rsConsulta.SNCdireccion)#</cfif></textarea>
		</td>
	    <td>&nbsp;</td>
	</tr>
	

	<tr><td colspan="4" align="right" valign="baseline" nowrap>&nbsp;</td></tr>

	<!--- Botones --->
	<tr> 
		<td colspan="4" align="right" valign="baseline" nowrap> 
		<div align="center"> 
		<cf_botones modo=#modo# include='Mensajes' includevalues='Mensajes' exclude='Baja,Nuevo'><!--- <input name="btnActivarUsuario" type="button" value="Activar como Usuario" onClick="location.href='SociosActivar.cfm?SNcodigo=#rsSocios.SNcodigo#'"> --->
		</div>
		</td>
	</tr>
	<tr>
		<td colspan="4" align="right" valign="baseline" nowrap>&nbsp;</td>
    </tr>
	<cfif modo neq "ALTA">
		<cfset ts = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsConsulta.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>	
</table>
</fieldset>
	<cfif modo neq "ALTA">
	<input name="SNCcodigo" type="hidden" value="#rsConsulta.SNCcodigo#">
	</cfif>
<cfelse>
<table align="center">
	<tr>
		<td><strong><em></em>Debe&nbsp;escoger&nbsp;un&nbsp;Socio&nbsp;de&nbsp;Negocios&nbsp;Corporativo</strong></td>
	</tr>
</table>

</cfif>
</form>
</cfoutput>

<cf_qforms form="form1">
<SCRIPT LANGUAGE="JavaScript">
	<cfif modo NEQ 'ALTA'> 
		objForm.SNCnombre.required = true;
		objForm.SNCnombre.description="Nombre de Empleado";
	</cfif>
	
	function funcMensajes() {
	
		document.form1.action='MensajesPV.cfm';
		document.form1.submit();
	}

	function funcCambio(){
		if (confirm('¿Desea cambiar el nombre del Socio de Negocios Corporativo?')){
			return true;
		}else{
			return false;
		}
	}
	
</SCRIPT> 