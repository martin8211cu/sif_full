<cfif isdefined("Form.CRid") and Len(Trim(Form.CRid))>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfif modo EQ "CAMBIO">
	<!--- Recupera los valores de la tabla CMCompradores --->
	<cfquery name="datosCourier" datasource="sifcontrol">
		select CRid, rtrim(CRcodigo) as CRcodigo, CRdescripcion, Usucodigo, Curl, 
			   CEcodigo, Ecodigo, EcodigoSDC, ts_rversion
		from Courier
		where CRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRid#">
	</cfquery>
	<!--- Cuando el mantenimiento no es para el PSO, hay que determinar cuales registros se pueden modificar --->
	<cfif not (isdefined("Request.courier") and Request.courier EQ "PSO")>
		<cfset CourierReadOnly = (Len(Trim(datosCourier.CEcodigo)) EQ 0 and Len(Trim(datosCourier.Ecodigo)) EQ 0 and Len(Trim(datosCourier.EcodigoSDC)) EQ 0)>
	<cfelse>
		<cfset CourierReadOnly = false>
	</cfif>

</cfif>

<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>
<form action="Courier-sql.cfm" method="post" name="form1">
	<cfif isdefined("Request.courier") and Request.courier EQ "PSO">
		<input type="hidden" name="courier" value="pso">
	</cfif>
	<table width="100%" border="0" cellspacing="2" cellpadding="0">
		<cfif modo EQ "CAMBIO" and CourierReadOnly>
		<tr>
      		<td colspan="2" align="center" style="color: ##FF0000; font-weight:bold; ">El usuario actual no tiene derechos para modificar este Courier</td>
    	</tr>
		</cfif>
		<tr>
		  <td align="right" nowrap><strong>C&oacute;digo:</strong>&nbsp;</td>
		  <td nowrap>
		  	<input type="text" name="CRcodigo" id="CRcodigo" value="<cfif modo neq "ALTA">#JSStringFormat(datosCourier.CRcodigo)#</cfif>" size="10" maxlength="10" onFocus="this.select();"  alt="El C&oacute;digo del Courier"<cfif modo EQ 'CAMBIO' and CourierReadOnly> readonly</cfif>>
		  </td>
	    </tr>
		<tr>
		  <td align="right" nowrap><strong>Descripci&oacute;n:</strong>&nbsp;</td>
		  <td nowrap>
			<input type="text" name="CRdescripcion" id="CRdescripcion" value="<cfif modo neq "ALTA">#JSStringFormat(datosCourier.CRdescripcion)#</cfif>" size="40" maxlength="80" onFocus="this.select();"  alt="Descripci&oacute;n del Courier"<cfif modo EQ 'CAMBIO' and CourierReadOnly> readonly</cfif>>
		  </td>
   		</tr>
		<tr>
		  <td align="right" nowrap><strong>Url:</strong>&nbsp;</td>
		  <td nowrap>
			<input type="text" name="Curl" id="Curl" value="<cfif modo neq "ALTA">#JSStringFormat(datosCourier.Curl)#</cfif>" size="40" maxlength="255" onFocus="this.select();"  alt="Url del Courier"<cfif modo EQ 'CAMBIO' and CourierReadOnly> readonly</cfif>>
		  </td>
   		</tr>
		<tr>
      		<td colspan="2">&nbsp;</td>
    	</tr>
		<tr>
      		<td colspan="2" align="center">
        		<cfif modo EQ "ALTA">
          			<input type="submit" name="Alta" value="Agregar">
          			<input type="reset" name="Limpiar" value="Limpiar">
          		<cfelse>
					<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#datosCourier.ts_rversion#"/>
					</cfinvoke>
					<input type="hidden" name="ts_rversion" value="#ts#">
					<input type="hidden" name="CRid" value="#datosCourier.CRid#">
					<cfif not CourierReadOnly>
          			<input type="submit" name="Cambio" value="Modificar" ><!-----onClick="javascript:cambio();"----->
          			<input type="submit" name="Baja" value="Eliminar" onClick="javascript:if( confirm('¿Desea Eliminar el Registro?') ){deshabilitarValidacion(); return true;} return false;">
					</cfif>
          			<input type="submit" name="Nuevo" value="Nuevo"  onClick="javascript:deshabilitarValidacion();" >
        		</cfif>
      		</td>
    	</tr>
		<tr>
		  <td colspan="2" align="center">&nbsp;</td>
	    </tr>
	</table>

</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
		
	objForm.CRcodigo.required = true;
	objForm.CRcodigo.description="Código";
	objForm.CRdescripcion.required = true;
	objForm.CRdescripcion.description="Descripción";
		
	function deshabilitarValidacion(){
		objForm.CRcodigo.required = false;
		objForm.CRdescripcion.required = false;		
	}
</script>
