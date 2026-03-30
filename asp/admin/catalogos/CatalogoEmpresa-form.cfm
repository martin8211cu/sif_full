<cfparam name="url.selEcodigo" default="">
<cfparam name="url.tabla" default="">

<cfquery datasource="asp" name="data">
	select Ecodigo, tabla, modalidad, ts_rversion
	from  CatalogoEmpresa ce
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.selEcodigo#" null="#Len(url.selEcodigo) Is 0#">
	  and tabla = <cfqueryparam cfsqltype="cf_sql_char" value="#url.tabla#" null="#Len(url.tabla) Is 0#">
</cfquery>

<cfquery datasource="asp" name="empresa">
	select CEcodigo, Ecodigo, Enombre
	from  Empresa ce
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.selEcodigo#" null="#Len(url.selEcodigo) Is 0#">
</cfquery>

<cfquery datasource="asp" name="tabla">
	select tabla, descripcion
	from  CatalogoEditable 
	where tabla = <cfqueryparam cfsqltype="cf_sql_char" value="#url.tabla#" null="#Len(url.tabla) Is 0#">
</cfquery>


<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: CatalogoEmpresa - CatalogoEmpresa
				// Columna: tabla Tabla varchar(30)
				if (formulario.tabla.value == "") {
					error_msg += "\n - Tabla no puede quedar en blanco.";
					error_input = formulario.tabla;
				}
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
//-->
</script>

<form action="CatalogoEmpresa-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table width="456" summary="Tabla de entrada">
	<tr>
	  <td colspan="3" class="subTitulo">
	Cat&aacute;logo para Empresa
	</td>
	</tr>
	
		<tr>
		  <td width="31" valign="top">&nbsp;</td>
		  <td colspan="2" valign="top">Empresa</td>
	  </tr>
		<tr>
		  <td valign="top">&nbsp;</td>
		  <td colspan="2" valign="top"><input name="Enombre" type="text" id="Enombre"
				onfocus="this.select()" value="#HTMLEditFormat(empresa.Enombre)#" size="60" 
				maxlength="60" readonly  ></td>
	  </tr>
		<tr>
		  <td valign="top">&nbsp;</td>
		  <td colspan="2" valign="top">Tabla</td>
	  </tr>
		<tr><td valign="top">&nbsp;</td><td colspan="2" valign="top">		
			<input name="tabla_descripcion" type="text" id="tabla_descripcion"
				onfocus="this.select()" value="#HTMLEditFormat(tabla.tabla)# - #HTMLEditFormat(tabla.descripcion)#" size="60" 
				maxlength="60" readonly  >		
		</td></tr>
		<tr>
		  <td valign="top">&nbsp;</td>
		  <td colspan="2" valign="top">Modalidad de modificaci&oacute;n</td>
	  </tr>
		<tr><td valign="top">&nbsp;</td><td width="24" valign="middle">
		
				<input type="radio" name="modalidad" value="" id="modalidadNULL" <cfif Len(data.modalidad) EQ 0>checked</cfif> >
				</td>
		  <td width="344" valign="middle"><label for="modalidadNULL"><strong>No Aplica</strong></label></td>
		</tr>
	    <tr>
	      <td class="formButtons">&nbsp;</td>
	      <td rowspan="2" valign="top" class="formButtons"> <input type="radio" name="modalidad"  id="modalidad1" value="1" <cfif data.modalidad is '1'>checked</cfif> >
            <label for="modalidad5"></label></td>
      <td rowspan="2" valign="middle" class="formButtons"><label for="modalidad1"><strong>Alta/Importa</strong>        <br>
          Puedo hacer altas solo para mi empresa y puedo importar del corporativo. </label></td>
      </tr>
	    <tr>
	      <td class="formButtons">&nbsp;</td>
      </tr>
	    <tr>
	      <td class="formButtons">&nbsp;</td>
	      <td rowspan="2" valign="top" class="formButtons">            <input type="radio" name="modalidad"  id="modalidad2" value="2" <cfif data.modalidad is '2'>checked</cfif> >
            <label for="modalidad5"></label></td>
      <td rowspan="2" valign="middle" class="formButtons"><label for="modalidad2"><strong>Alta Corporativa/Importa</strong>      <br>
        Todas las altas para mi empresa se replican en el corporativo, y tambi&eacute;n puedo importar del corporativo.</label>   </td>
      </tr>
	    <tr>
	      <td class="formButtons">&nbsp;</td>
      </tr>
	    <tr>
	      <td class="formButtons">&nbsp;</td>
	      <td rowspan="2" valign="top" class="formButtons">            <input type="radio" name="modalidad"  id="modalidad3" value="3" <cfif data.modalidad is '3'>checked</cfif> >
            <label for="modalidad5"></label></td>
      <td rowspan="2" valign="middle" class="formButtons"><label for="modalidad3"><strong>Alta/Alta Corporativa/Importa</strong><br>
        Permite realizar altas solo para mi empresa, o altas que se repliquen en el corporativo, y tambi&eacute;n puedo importar del corporativo. </label></td>
      </tr>
	    <tr>
	      <td class="formButtons">&nbsp;</td>
      </tr>
	    <tr>
	      <td colspan="3" class="formButtons">&nbsp;</td>
      </tr>
      <tr><td colspan="3" class="formButtons" align="center">
	  	<input type="submit" name="Alta" value="Guardar">
	  	<input type="reset" name="reset" value="Limpiar">
	</td></tr>
	</table>
			<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(empresa.Ecodigo)#">
			<input type="hidden" name="CEcodigo" value="#HTMLEditFormat(empresa.CEcodigo)#">
			<input type="hidden" name="tabla" value="#HTMLEditFormat(tabla.tabla)#">
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
</form>

</cfoutput>


