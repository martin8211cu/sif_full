<cfif isdefined("url.modoC") and len(trim(url.modoC)) and not isdefined("form.modoC")>
	<cfparam name="form.modoC" default="#Url.modoC#"> <!--- <cfdump var="#form#"> --->
	<cfset form.modoC = url.modoC>
</cfif>
<cfif isdefined("Form.Cambio")>
	<cfset modoC="ALTA">
<cfelse>
	<cfif not isdefined("Form.modoC")>
		<cfset modoC="ALTA">
	<cfelseif #Form.modoC# EQ "CAMBIO">
		<cfset modoC="CAMBIO">
	<cfelse>
		<cfset modoC="ALTA">
	</cfif>
</cfif>
<cfif isdefined("url.SNCcodigo") and len(trim(url.SNCcodigo)) and not isdefined("form.SNCcodigo")>
	<cfset form.SNCcodigo = url.SNCcodigo>
</cfif>
<cfif isDefined("session.Ecodigo") and isDefined("Form.SNcodigo") and len(trim(#Form.SNcodigo#))>
	<cfquery name="rsContactos" datasource="#Session.DSN#">
		select Ecodigo, SNcodigo, SNCcodigo, SNCidentificacion, SNCnombre , 
		SNCdireccion, SNCtelefono, SNCfax, SNCemail, SNCfecha,ts_rversion     
			from SNContactos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif  isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo))>
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">		  
		</cfif>  				  
		<cfif  isdefined("Form.SNCcodigoLista") and len(trim(Form.SNCcodigoLista))>
				and SNCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCcodigoLista#">
		</cfif>  				  
		order by SNCnombre asc
	</cfquery>
</cfif>
<cfoutput>
<form action="SQLContactos.cfm" method="post" name="form4">
  <table width="67%" height="75" align="center" cellpadding="0" cellspacing="0">
    <tr bgcolor="FFFFFF"> 
      <td width="27%" align="right" valign="baseline" nowrap>&nbsp;</td>
    </tr>
    <tr bgcolor="FFFFFF"> 
      <td align="right" valign="middle" nowrap>Nombre:&nbsp;</td>
      <td width="73%" valign="middle"> <input name="SNCnombre" type="text" onFocus="javascript: this.select();" value="<cfif modoC NEQ "ALTA">#rsContactos.SNCnombre#</cfif>" size="45" maxlength="255" alt="El Nombre"></td>
    </tr>
    <tr bgcolor="FFFFFF">
      <td valign="middle" nowrap><div align="right">Identificaci&oacute;n:&nbsp;</div></td>
      <td valign="middle" nowrap>
        <input name="SNCidentificacion" type="text" onFocus="javascript: this.select();" value="<cfif modoC NEQ "ALTA">#rsContactos.SNCidentificacion#</cfif>" size="20" maxlength="30" alt="La Identificación">
      </td>
    </tr>
    <tr bgcolor="FFFFFF">
      <td valign="middle" nowrap><div align="right">Fecha:&nbsp;</div></td>
      <td valign="middle">
			<cfoutput>
				<cfset fechadoc = LSDateFormat(Now(),'dd/mm/yyyy') >
				<cfif modoC neq 'ALTA'>
					<cfset fechadoc = LSDateFormat(rsContactos.SNCfecha,'dd/mm/yyyy') >
				</cfif>
			</cfoutput>			
			<cf_sifcalendario value="#fechadoc#" form="form4" tabindex="5" name="SNCfecha">			  
      </td>
    </tr>
    <tr bgcolor="FFFFFF">
      <td valign="middle" nowrap><div align="right">E-Mail:&nbsp;</div>
      </td>
      <td valign="middle">
        <input name="SNCemail" type="text" onFocus="javascript: this.select();" onBlur="return document.MM_returnValue" value="<cfif modoC NEQ "ALTA">#rsContactos.SNCemail#</cfif>" size="45" maxlength="100" alt="El E-mail">
      </td>
    </tr>
    <tr bgcolor="FFFFFF">
      <td align="right" valign="middle" nowrap>Tel&eacute;fono:&nbsp;</td>
      <td valign="middle"><input name="SNCtelefono" type="text" onFocus="javascript: this.select();" value="<cfif modoC NEQ "ALTA">#rsContactos.SNCtelefono#</cfif>" size="20" maxlength="30" alt="El Teléfono">
      </td>
    </tr>
    <tr bgcolor="FFFFFF">
      <td valign="middle" nowrap>
        <div align="right">Fax:&nbsp;</div>
      </td>
      <td><input name="SNCFax" type="text" onFocus="javascript: this.select();" value="<cfif modoC NEQ "ALTA">#rsContactos.SNCFax#</cfif>" size="18" maxlength="30" alt="El Fax">
      </td>
    </tr>
    <tr> 
      <td align="right" valign="top" nowrap>Direcci&oacute;n:&nbsp;</td>
      <td colspan="7" align="left" valign="baseline" nowrap> <textarea name="SNCdireccion" cols="40" rows="4" onFocus="javascript: this.select();" alt="La Dirección del Contacto"><cfif modoC NEQ "ALTA">#rsContactos.SNCdireccion#</cfif></textarea> 
        <div align="right"></div></td>
    </tr>
    <tr> 
      <td valign="baseline" nowrap> <div align="right"></div></td>
      <td valign="baseline">&nbsp;</td>
    </tr>
    <tr> 
      <td align="right" valign="baseline" nowrap>&nbsp;</td>
      <td align="right" valign="baseline" nowrap>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="8" align="right" valign="baseline" nowrap> <div align="center"> 
		 <cf_botones modo=#modoC# sufijo="Contacto" form="form4">        
        </div>
	   </td>
    </tr>
  </table>
<cfset ts = "">
  <cfif modoC NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsContactos.ts_rversion#"/>
	</cfinvoke>
</cfif>  
  <input type="hidden" name="ts_rversion" value="<cfif modoC NEQ "ALTA">#ts#</cfif>" size="32">
  <input type="hidden" name="SNcodigo" value="#Form.SNcodigo#" alt="El campo Id del Socio" > 
  <input type="hidden" name="SNCcodigolista" value="<cfif rsContactos.recordcount GT 0>#rsContactos.SNCcodigo#</cfif>"
  	alt="El campo Código de Contacto">
	<input type="hidden" name="modo" value="<cfif isdefined("form.modo")>#form.modo#</cfif>">
  <input type="hidden" name="modoC" value="#modoC#">
</form>
</cfoutput>
<cf_qforms form="form4">
<script language="javascript1" type="text/javascript">
	function funcRegresar()
	{
		document.form4.method='post';
		document.form4.action='SQLContactos.cfm';
	}		
		objForm.SNCnombre.description = "Nombre del contacto";
		objForm.SNCtelefono.description = "Telefono del contacto";		
	function habilitarValidacion() 
	{
		objForm.SNCnombre.required = true;
		objForm.SNCtelefono.required = true;
	}
</script>



