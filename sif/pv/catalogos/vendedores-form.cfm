
<cfif isdefined('url.FAX04CVD') and not isdefined('form.FAX04CVD')>
	<cfparam name="form.FAX04CVD" default="#url.FAX04CVD#">
</cfif>

<cfset modo = 'ALTA'>
<cfif  isdefined('url.FAX04CVD') and len(trim(url.FAX04CVD)) and not isdefined('form.FAX04CVD')>
	<cfset form.FAX04CVD = url.FAX04CVD>
</cfif>
<cfif  isdefined('form.FAX04CVD') and len(trim(form.FAX04CVD))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select 	Ecodigo, FAX04CVD, DEid, Usucodigo, CFid, FAM21NOM, FAM21PSW, 
				FAM21PUE, FAM21PAD, FAM21PCP, FAM21PCO, FAM21CDI, FAM21CED, 
				FAM21SUP, fechaalta, ts_rversion, BMUsucodigo
		from FAM021
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and FAX04CVD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAX04CVD#">
	</cfquery>
	<cfquery name="rsCentros" datasource="#session.DSN#">
		Select *
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CFid#">
	</cfquery>
</cfif>

<cfoutput>
<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<form name="form1" method="post" action="vendedores-sql.cfm">
<!---  Esta parte es para actualizar la tabla RolEmpleadoSNegocios en caso de q se modifiq un registro--->
	<cfif modo neq 'ALTA'>
		<input name="hiden_Ecodigo" type="hidden" value="#data.Ecodigo#">
		<input name="hiden_DEid" type="hidden" value="#data.DEid#">
		<input name="hiden_BMUsucodigo" type="hidden" value="data.BMUsucodigo">
	</cfif>	
 <!---  ***********************	--->
	<table width="100%" cellpadding="3" cellspacing="0">
      <cfif isdefined('form.FAM21CED_F') and len(trim(form.FAM21CED_F))>
        <input type="hidden" name="FAM21CED_F" value="#form.FAM21CED_F#">
      </cfif>
      <cfif isdefined('form.FAM21NOM_F') and len(trim(form.FAM21NOM_F))>
        <input type="hidden" name="FAM21NOM_F" value="#form.FAM21NOM_F#">
      </cfif>
      <tr>
        <td width="14%" align="left"><strong>C&oacute;digo</strong></td>
        	<td colspan="3"><input type="text" name="FAX04CVD"size="10" tabindex="1" maxlength="10" <cfif modo neq 'ALTA'> readonly="true"</cfif> value="<cfif modo neq 'ALTA'>#trim(data.FAX04CVD)#</cfif>">
        </td>
      </tr>
      
	  <tr>
        <td align="left"><strong>Empleado</strong></td>
        <td colspan="3">
			<cfif modo NEQ "ALTA">
            	<cf_rhempleado Nombre="Nombre" DEidentificacion="Pid" idempleado="#data.DEid#" tabindex="1">
            <cfelse>
            	<cf_rhempleado Nombre="Nombre" DEidentificacion="Pid" tabindex="1">
          	</cfif>
        </td>
      </tr>
      <tr>
        <td align="left" nowrap><strong>Centro Funcional</strong></td>
        <td colspan="3"><cfif modo neq 'ALTA'>
            <cf_rhcfuncional form="form1" query="#rsCentros#" tabindex="1">
            <cfelse>
            <cf_rhcfuncional form="form1" size="30" tabindex="1" titulo="Seleccione un Centro Funcional">
          </cfif>
        </td>
      </tr>
      <tr>
        <td align="left" ><strong>Identificaci&oacute;n</strong></td>
        <td width="29%" align="left"><input type="text" name="FAM21CED" size="25" tabindex="1" maxlength="40" value="<cfif modo neq 'ALTA'>#trim(data.FAM21CED)#</cfif>"></td>
        <td width="16%" align="left"><strong>Nombre</strong></td>
        <td width="41%"><input type="text" name="FAM21NOM" size="40" tabindex="1" maxlength="40" value="<cfif modo neq 'ALTA'>#trim(data.FAM21NOM)#</cfif>"></td>
      </tr>
      <tr>
        <td align="left"><strong>Contraseña</strong></td>
        <td width="29%" align="left"><input type="password" name="FAM21PSW" tabindex="1" size="25" maxlength="30" value="<cfif modo neq 'ALTA'>#trim(data.FAM21PSW)#</cfif>"></td>
        <td width="16%"><strong>Puesto</strong></td>
        <td width="41%"><input type="text" name="FAM21PUE" size="25" maxlength="40" tabindex="1" value="<cfif modo neq 'ALTA'>#trim(data.FAM21PUE)#</cfif>"></td>
      </tr>
      <tr>
        <td align="left"><strong>(%) Comisi&oacute;n</strong></td>
        <td width="29%"><input type="text" name="FAM21PCO" size="25" tabindex="1" maxlength="40" value="<cfif modo neq 'ALTA'>#trim(data.FAM21PCO)#</cfif>"></td>
        <td width="16%" align="left"><strong>Tipo de Comisi&oacute;n</strong></td>
        <td width="41%"><select name="FAM21CDI" tabindex="1" >
           	<option value="1"<cfif modo NEQ 'ALTA' and data.FAM21CDI EQ 1> selected </cfif>>Comision Directa</option>
            <option value="2"<cfif modo NEQ 'ALTA' and data.FAM21CDI EQ 2> selected </cfif>>Tracto sobre Venta</option>
            <option value="3"<cfif modo NEQ 'ALTA' and data.FAM21CDI EQ 3> selected </cfif>>Tracto sobre Utilidad</option>
            <option value="9"<cfif modo NEQ 'ALTA' and data.FAM21CDI EQ 9> selected </cfif>> Comision Variable</option>
        </select></td>
      </tr>
      <tr>
        <td align="left"><strong>Supervisor</strong></td>
        <td colspan="3"><cfif modo NEQ "ALTA">
            <cf_sifvendedores id="#data.FAM21SUP#" tabindex="1" fax04cvd="FAM21SUP" fam21nom="_FAM21NOM">
            <cfelse>
            <cf_sifvendedores fax04cvd="FAM21SUP" tabindex="1" fam21nom="_FAM21NOM">
          </cfif>
        </td>
      </tr>
      <tr>
        <td colspan="2" align="right"><input type="checkbox" name="FAM21PAD" tabindex="1" value="1" <cfif modo NEQ "AlTA" and data.FAM21PAD eq 1>checked</cfif>>
      <strong>Permitir Autorizar Descuentos</strong></td>
        <td colspan="2" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" tabindex="1" name="FAM21PCP"  value="1"<cfif modo NEQ "AlTA" and data.FAM21PCP eq 1>checked</cfif>>
      <strong>Permitir Cambio de Precios</strong></td>
      </tr>
      <tr>
        <td colspan="4" align="right">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="4" align="center">
			<cf_botones modo='#modo#' tabindex="1">
        </td>
      </tr>
    </table>
	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		
	</cfif>
	
</form>
<cfif modo eq 'CAMBIO' and data.FAM21CDI NEQ '1'>
	<fieldset><legend><strong>Comisiones por Vendedor</strong></legend>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfinclude template="comisionesvend.cfm">
				</td>								
			</tr>
		</table>
	</fieldset>			
</cfif>

<cf_qforms>
<script language="javascript">

	function funcBaja() {
		return confirm('¿Desea eliminar el registro del vendedor '+document.form1.Nombre.value+'?');
	}

	objForm.FAX04CVD.required = true;
	objForm.FAX04CVD.description = "Código";

	objForm.NTIcodigo.required = true;
	objForm.NTIcodigo.description = "Tipo de Identificación";
	
	objForm.CFid.required = true;
	objForm.CFid.description = "Centro Funcional";
	
	objForm.FAM21NOM.required = true;
	objForm.FAM21NOM.description = "Nombre";
	
	objForm.FAM21PUE.required = true;
	objForm.FAM21PUE.description = "Puesto";
	
	objForm.FAM21PCO.required = true;
	objForm.FAM21PCO.description = "Porcentaje de Comision";
	
	objForm.FAM21CED.required = true;
	objForm.FAM21CED.description = "Identificacion";	

	/*function funcDEid(){
		document.form1.FAM21CED.value = document.form1.Pid.value;
	}*/

</script>
</cfoutput>