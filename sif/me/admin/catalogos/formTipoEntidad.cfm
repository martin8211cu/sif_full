<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
			select convert(varchar, METEid) as METEid, METEformato, METEdesc, METEmenu, 
				METEident, METEemail, METEimagen, METEtext, 
				METEfacturable, METEfechareg, METEusuario, 
				METEetiqident, METEetiqemail, METEetiqimagen, 
				METEetiqtext, METEetiqnom, ts_rversion
			from METipoEntidad
			where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
	</cfquery>

	<!--- Cuenta el número de entidades relacionadas a este tipo de entidad --->
	<cfquery name="rsEntidadesPorTipo" datasource="#Session.DSN#">		
		select count(1) as cantidad from MEEntidad
		where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.METEid#">
	</cfquery>	
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(METEformato) as METEformato
	from METipoEntidad
	<cfif modo neq 'ALTA'>
		where METEid <>  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
	</cfif>
</cfquery>


<cfoutput>
  <form name="form1" style="margin:0;" action="SQLTipoEntidad.cfm" method="post" onSubmit="return validar();">
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
		  <td width="2%">&nbsp;</td>
		  <td colspan="3">
			<input type="hidden" name="TABSEL" id="TABSEL" value="#Form.TABSEL#">
			<!---  METEid y ts_rversion para el cambio --->
			<cfif modo NEQ "ALTA">
			  <cfset ts = "">
			  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts">
			  </cfinvoke>
			  <input name="METEid" type="hidden" value="#rsForm.METEid#">
			  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
			</cfif>
		  </td>
	    </tr>
		<tr>
			<td>&nbsp;</td>
			<td width="20%" align="right" nowrap>Código:&nbsp;</td>
			<td width="35%" nowrap><input name="METEformato" type="text" <cfif modo neq 'ALTA'>disabled</cfif> onFocus="javascript:this.select();" onBlur="javascript:codigos(this);" value="<cfif modo neq 'ALTA'>#trim(rsForm.METEformato)#</cfif>" size="12" maxlength="10"></td>
			<td width="2%" align="right" nowrap>&nbsp;</td>
		</tr>
		<tr>
		  <td>&nbsp;</td>
		  <td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
		  <td nowrap><input name="METEdesc" type="text" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.METEdesc#</cfif>" size="45" maxlength="80"></td>
		  <td align="right" nowrap>&nbsp;</td>
	    </tr>
		<tr>
		  <td>&nbsp;</td>
		  <td align="right" nowrap>Etiqueta Email:&nbsp;</td>
		  <td nowrap><input name="METEetiqemail" type="text" id="METEetiqemail" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#trim(rsForm.METEetiqemail)#<cfelse>Email</cfif>" size="20" maxlength="30">
	      <input type="checkbox" name="METEemail" <cfif modo neq 'ALTA' and rsForm.METEemail eq '1'>checked</cfif> >
	      Mostrar Email</td>
		  <td nowrap align="right">&nbsp;</td>
	    </tr>
		<tr>
          <td>&nbsp;</td>
          <td align="right" nowrap>Etiqueta Text:&nbsp;</td>
          <td nowrap><input name="METEetiqtext" type="text" id="METEetiqtext" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#trim(rsForm.METEetiqtext)#<cfelse>Observaciones</cfif>" size="20" maxlength="30">
          <input type="checkbox" name="METEtext" <cfif modo neq 'ALTA' and rsForm.METEtext eq '1'>checked</cfif> >
          Mostrar Text</td>
          <td nowrap align="right">&nbsp;</td>
      </tr>
		<tr>
		  <td>&nbsp;</td>
		  <td align="right" nowrap>Etiqueta Ident.:&nbsp;</td>
		  <td nowrap><input name="METEetiqident" type="text" id="METEetiqident" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#trim(rsForm.METEetiqident)#<cfelse>Identificación</cfif>" size="20" maxlength="30">
	      <input type="checkbox" name="METEident" <cfif modo neq 'ALTA' and rsForm.METEident eq '1'>checked</cfif> >
	      Mostrar Identificaci&oacute;n</td>
		  <td nowrap align="right">&nbsp;</td>
	    </tr>
		<tr>
		  <td>&nbsp;</td>
		  <td align="right" nowrap>Etiqueta Imagen:&nbsp;</td>
		  <td nowrap><input name="METEetiqimagen" type="text" id="METEetiqimagen" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#trim(rsForm.METEetiqimagen)#<cfelse>Foto</cfif>" size="20" maxlength="30">
	      <input type="checkbox" name="METEimagen" <cfif modo neq 'ALTA' and rsForm.METEimagen eq '1'>checked</cfif> >
	      Mostrar Imagen</td>
		  <td nowrap align="right">&nbsp;</td>
	    </tr>
		<tr>
		  <td>&nbsp;</td>
          <td align="right" nowrap>Etiqueta Nombre:&nbsp;</td>
          <td nowrap><input name="METEetiqnom" type="text" id="METEetiqnom" onFocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#trim(rsForm.METEetiqnom)#<cfelse>Nombre Completo</cfif>
          " size="20"></td>
          <td nowrap align="right">&nbsp;</td>
	    </tr>
		<tr>
		  <td>&nbsp;</td>
          <td align="right" nowrap>&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td nowrap align="right">&nbsp;</td>
        </tr>
		<tr>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
		  <td nowrap>		    <input name="METEmenu" type="checkbox" id="METEmenu" <cfif modo neq 'ALTA' and rsForm.METEmenu eq '1'>checked</cfif> >
Mostrar en Men&uacute; </td><td nowrap align="right">&nbsp;</td>
	    </tr>
		<tr>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
		  <td nowrap>                <input name="METEfacturable" type="checkbox" id="METEfacturable" <cfif modo neq 'ALTA' and rsForm.METEfacturable eq '1'>checked</cfif> >
    Facturable</td><td nowrap align="right">&nbsp;</td>
	  </tr>
		<tr>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
		  <td nowrap>                <input name="METEusuario" type="checkbox" id="METEusuario" <cfif modo neq 'ALTA' and rsForm.METEusuario eq '1'>checked</cfif> >
    Usuario</td><td nowrap align="right">&nbsp;</td>
	  </tr>
		<tr>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
	  </tr>
		<tr>
          <td>&nbsp;</td>
          <td colspan="3" align="center" nowrap>
            <cf_templatecss>
            <script language="JavaScript" type="text/javascript">
					// Funciones para Manejo de Botones
					botonActual = "";
				
					function setBtn(obj) {
						botonActual = obj.name;
					}
					
					function btnSelected(name, f) {
						if (f != null) {
							return (f["botonSel"].value == name)
						} else {
							return (botonActual == name)
						}
					}
			</script>
            <input type="hidden" name="botonSel" value="">
            <input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
            <cfif modo EQ "ALTA">
              <input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
              <input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
              <cfelse>
              <input type="submit" name="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion();">
              <input type="submit" name="Baja" value="Eliminar" onclick="javascript:return validaNoExiste();">
              <input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
            </cfif>
          </td>
      </tr>
		<tr>
		  <td>&nbsp;</td>
		  <td colspan="3">&nbsp;</td>
	  </tr>
	</table>
  </form>
</cfoutput>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.METEformato.required = true;
	objForm.METEformato.description="Código";
	objForm.METEdesc.required = true;
	objForm.METEdesc.description="Descripción";
	
	function validar(){
		document.form1.METEformato.disabled = false;
		return true;
	}
	
	function deshabilitarValidacion(){
		objForm.METEformato.required = false;
		objForm.METEdesc.required = false;
	}
	
	function codigos(obj){
		if (obj.value != "") {
			var dato    = obj.value;
			var temp    = new String();
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.METEformato#</cfoutput>'
				if (dato == temp){
					alert('El Código de Tipo de Entidad ya existe.');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}
		return true;
	}
	
	<cfif MODO neq "ALTA">
	function validaNoExiste(){
		<cfif rsEntidadesPorTipo.cantidad GT 0 and 1 eq 2>
			alert('No se puede eliminar debido a que hay entidades asociadas con este tipo');
			return false;
		<cfelse>							
			document.form1.botonSel.value = this.name;
			if ( confirm('¿Desea Eliminar el Registro?') )
			{
				if (window.deshabilitarValidacion)
					deshabilitarValidacion(); 
				return true;
			}
			else{
				return false;
			}
		</cfif>
	}
	</cfif>
</script>
