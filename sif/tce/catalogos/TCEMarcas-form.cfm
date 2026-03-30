<cfif isdefined("Form.Cambio")>
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
<cfif not isdefined("Form.modo") and isdefined("url.modo")>
	<cfset modo=url.modo>
</cfif>
<cfif not isdefined("Form.CBTMid") and isdefined("url.CBTMid")>
	<cfset Form.CBTMid=url.CBTMid>
</cfif>

</script>

<cfquery datasource="#Session.DSN#" name="rsMarcas">
 	select * from CBTMarcas
	
	<cfif isdefined("form.CBTMid") and form.CBTMid NEQ "">
		where CBTMid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBTMid#">
	</cfif>
</cfquery>

<form method="post" name="form1" onSubmit="if (document.form1.botonSel.value !='Baja' && document.form1.botonSel.value !='Nuevo'){ MM_validateForm('CBTMascara','','R');return document.MM_returnValue }else{ return true; }" action="TCEMarcas-sql.cfm">
	<table align="center">
		
		<tr valign="baseline"> 
               
               
			<td nowrap align="left">Marca</td>
			<td>
				<input type="text" name="CBTMarca" id="CBTMarca" maxlength="15" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsMarcas.CBTMarca#</cfoutput></cfif>" size="32" tabindex="1" onfocus="javascript: this.select();" alt="El campo Marca">
			</td>
          </tr>
          <tr valign="baseline">  
			<td nowrap align="left">Mascara</td>
			<td>
				<input type="text" name="CBTMascara" id="CBTMascara" maxlength="30" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsMarcas.CBTMascara#</cfoutput></cfif>" size="32" tabindex="1" onfocus="javascript: this.select();" alt="El campo Mascara">
				<input type="hidden" name="CBTMid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsMarcas.CBTMid#</cfoutput></cfif>">
			</td>
  		    <td>
              <cfsavecontent variable="helpmsj">
                    Formato de máscara que utilizaran las marcas de tarjetas<br />
                    &nbsp;&nbsp;'X'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;para N&uacute;meros.<br />
                    &nbsp;&nbsp;espacio:&nbsp;como Separador. <br />
                    Se puede ingresar numeros fijos, de ser necesario. <br />
              </cfsavecontent>
              <cfsavecontent variable="helpimg">
					<img src="../../imagenes/Help01_T.gif" width="25" height="23" border="0" style="margin-top: 0px; position: relative; top: 7px;"/>
				</cfsavecontent>
                         <cf_notas titulo="M&aacute;scara TCE" link="#helpimg#" pageIndex="1" msg = "#helpmsj#" animar="true" >
            </td>
 
		</tr>
		<tr> 
			<td colspan="2" align="center" nowrap>
				<input type="hidden" name="botonSel" value="" tabindex="-1">
				<input name="txtEnterSI" type="text" size="1" tabindex="-1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif modo EQ "ALTA">
					<input type="submit" name="Alta" value="Agregar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
					<input type="reset" name="Limpiar" value="Limpiar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>
					<input type="submit" name="Cambio" value="Modificar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; validaMon();">
					<input type="submit" name="Baja" value="Eliminar" tabindex="1" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('Est\u00e1 seguro(a) de que desea eliminar el registro ?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;} validaMon();">
					<input type="submit" name="Nuevo" value="Nuevo" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); validaMon();">
				</cfif>
			</td>
		</tr>
	</table>
	
	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
		 	method="toTimeStamp"
		 	returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsMarcas.ts_rversion#"/>
		</cfinvoke>
	</cfif>

	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
</form>


<cf_qforms>
<script language="javascript" type="text/javascript">
<!--//
objForm.CBTMascara.description = "Marca";
objForm.CBTMarca.description = "Mascara";

function validaMon(){
return true;
}

function habilitarValidacion(){
objForm.CBTMascara.required = true;
objForm.CBTMarca.required = true;
}
function deshabilitarValidacion(){
objForm.CBTMascara.required = false;
objForm.CBTMarca.required = false;
}
habilitarValidacion();
//-->
</script>

<script language="JavaScript" type="text/javascript">
	// Funciones para Manejo de Botones
	botonActual = "";

	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
				return (f["botonSel"].value == name);
		} else {
				return (botonActual == name);
		}
	}

</script>
