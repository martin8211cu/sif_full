<cfset filtro = "">

<!--- Consultas --->
<cfif modo EQ "CAMBIO">
	<cfquery name="rsForm" datasource="#session.DSN#">
		select RHJid, RHJcodigo, Ecodigo, RHJdescripcion, RHJsun, RHJmon, RHJtue, RHJwed, RHJthu, RHJfri, RHJsat, RHJmarcar,
			RHJhoraini, RHJhorafin, RHJhoradiaria, RHJhorainicom, RHJhorafincom, ts_rversion
		from RHJornadas
		where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfif modoDet EQ "CAMBIO">
	<cfquery name="rsDetalle" datasource="#session.DSN#">
		select RHCJid, 
			   RHJid, 
			   {fn concat(rtrim(RHCJcomportamiento), rtrim(RHCJmomento))}  as Comportamiento, 
			   RHCJperiodot, 
			   RHCJfrige, 
			   RHCJfhasta, 
			   ts_rversion
		from RHComportamientoJornada
		where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.RHJid#">
		  and RHCJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCJid#">
	</cfquery>
</cfif>

<!--- Javascript --->
<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

</script>


<cfoutput>
<form name="form1" method="post" action="JornadasComp-sql.cfm">
  <cfif modo EQ "CAMBIO">
  	<input type="hidden" name="RHJid" value="#Form.RHJid#">
  </cfif>
  <cfif modoDet EQ "CAMBIO">
  	<input type="hidden" name="RHCJid" value="#Form.RHCJid#">
  </cfif>
  <table width="100%" border="0" cellspacing="0" cellpadding="2">
    <tr>
      <td class="fileLabel" align="right">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="fileLabel" align="right">#vFechaRige#: </td>
      <td>
	    <cfif modoDet EQ "CAMBIO">
			<cfset fecharige = LSDateFormat(rsDetalle.RHCJfrige, 'DD/MM/YYYY')>
		<cfelse>
			<cfset fecharige = "">
		</cfif>
	  	<cf_sifcalendario form="form1" name="RHCJfrige" value="#fecharige#">
	  </td>
    </tr>
    <tr>
      <td class="fileLabel" align="right">#vFechaVence#: </td>
      <td>
	    <cfif modoDet EQ "CAMBIO">
			<cfset fechavence = LSDateFormat(rsDetalle.RHCJfhasta, 'DD/MM/YYYY')>
		<cfelse>
			<cfset fechavence = "">
		</cfif>
	  	<cf_sifcalendario form="form1" name="RHCJfhasta" value="#fechavence#">
	  </td>
    </tr>
    <tr> 
      <td class="fileLabel" align="right">#vComportamiento#:</td>
      <td>
	  	 <select name="RHCJcomportamiento">
	  	   <option value="HA" <cfif modoDet EQ 'CAMBIO' and rsDetalle.Comportamiento EQ 'HA'> selected</cfif>>#vAntesdeEntrada#</option>
	  	   <option value="RD" <cfif modoDet EQ 'CAMBIO' and rsDetalle.Comportamiento EQ 'RD'> selected</cfif>>#vDespuesdeEntrada#</option>
	  	   <option value="RA" <cfif modoDet EQ 'CAMBIO' and rsDetalle.Comportamiento EQ 'RA'> selected</cfif>>#vAntesdeSalida#</option>
	  	   <option value="HD" <cfif modoDet EQ 'CAMBIO' and rsDetalle.Comportamiento EQ 'HD'> selected</cfif>>#vDespuesdeSalida#</option>
		 </select>
	  </td>
    </tr>
    <tr>
      <td class="fileLabel" align="right">#vPeriodo#: </td>
      <td>
	  	<input type="text" name="RHCJperiodot" size="4" maxlength="4" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modoDet EQ 'CAMBIO'>#rsDetalle.RHCJperiodot#</cfif>"> minutos
	  </td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
	<tr><td colspan="2" align="center">
		<cfif modoDet EQ "ALTA">
			<input type="submit" name="Alta" value="#vAgregar#">
		<cfelse>	
			<input type="submit" name="Cambio" value="#vModificar#" onClick="javascript: habilitarValidacion();">
			<input type="submit" name="Baja" value="#vEliminar#" onClick="javascript: inhabilitarValidacion();">
			<input type="submit" name="Nuevo" value="#vNuevo#" onClick="javascript: inhabilitarValidacion();">
		</cfif>
	</td></tr>
	<cfset ts = "">	
	<cfif modoDet EQ "CAMBIO">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsDetalle.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<tr><td colspan="2"><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>
  </table>  
</form>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
    <tr>
      <td colspan="2">
		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="RHComportamientoJornada"/>
			<cfinvokeargument name="columnas" value="RHCJid, RHJid, 
													case when {fn concat(rtrim(RHCJcomportamiento), rtrim(RHCJmomento))} = 'HA' then '#vAntesdeEntrada#'
													when {fn concat(rtrim(RHCJcomportamiento), rtrim(RHCJmomento))} = 'RD' then '#vDespuesdeEntrada#'
													when {fn concat(rtrim(RHCJcomportamiento), rtrim(RHCJmomento))} = 'RA' then '#vAntesdeSalida#'
													when {fn concat(rtrim(RHCJcomportamiento), rtrim(RHCJmomento))} = 'HD' then '#vDespuesdeSalida#'
													else '&nbsp;'
													end as Comportamiento, 
													RHCJperiodot, RHCJfrige, RHCJfhasta"/>
			<cfinvokeargument name="desplegar" value="RHCJfrige, RHCJfhasta, Comportamiento, RHCJperiodot"/>
			<cfinvokeargument name="etiquetas" value="#vFechaRige#, #vFechaVence#, #vComportamiento#, #vTiempo#"/>
			<cfinvokeargument name="formatos" value="D, D, V, V"/>
			<cfinvokeargument name="filtro" value="RHJid = #Form.RHJid#"/>
			<cfinvokeargument name="align" value="center, center, left, right"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="JornadasComp.cfm"/>
			<cfinvokeargument name="formName" value="listaComportamientos"/>
			<cfinvokeargument name="maxRows" value="15"/>
			<cfinvokeargument name="keys" value="RHJid, RHCJid"/>
			<cfinvokeargument name="navegacion" value="RHJid=#RHJid#"/>
			<cfinvokeargument name="PageIndex" value="1"/>
		</cfinvoke>
	  </td>
    </tr>
	<tr>
	  <td align="center">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2" class="ayuda">
		  <tr>
			<td><strong>#vComportamiento#</strong></td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    </tr>
		  <tr>
		    <td><strong>#vAntesdeEntrada#:</strong><cf_translate key="MSG_Antes_de_Entrada">Tiempo que debe haber laborado el Empleado antes de la Jornada para que se le reconozca Tiempo extraordinario</cf_translate>.
		    </td>
		  </tr>
		  <tr>
		    <td><strong>#vDespuesdeEntrada#:</strong><cf_translate key="MSG_Despues_de Entrada">Per&iacute;odo de Tiempo que concede la Empresa antes de establecer la marca como llegada tard&iacute;a</cf_translate>.</td>
		    </tr>
		  <tr>
		    <td><strong>#vAntesdeSalida#:</strong><cf_translate key="MSG_Antes_de_Salida">&iacute;odo de Tiempo que concede la Empresa antes de establecer la marca como salida anticipada</cf_translate>.</td>
		    </tr>
		  <tr>
		    <td><strong>#vDespuesdeSalida#:</strong><cf_translate key="MSG_Despues_de_Salida">Tiempo que debe haber laborado el Empleado despu&eacute;s de la Jornada para que se le reconozca Tiempo extraordinario</cf_translate>.</td>
		    </tr>
		</table>
	  </td>
	</tr>
</table>


<script language="JavaScript1.2" type="text/javascript">
	function habilitarValidacion() {
		objForm.RHCJfrige.required = true;
		objForm.RHCJfhasta.required = true;
		objForm.RHCJcomportamiento.required = true;
		objForm.RHCJperiodot.required = true;
	}

	function inhabilitarValidacion() {
		objForm.RHCJfrige.required = false;
		objForm.RHCJfhasta.required = false;
		objForm.RHCJcomportamiento.required = false;
		objForm.RHCJperiodot.required = false;
	}

	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");

	objForm.RHCJfrige.required = true;
	objForm.RHCJfrige.description = "#vFechaRige#";
	objForm.RHCJfhasta.required = true;
	objForm.RHCJfhasta.description = "#vFechaVence#";
	objForm.RHCJcomportamiento.required = true;
	objForm.RHCJcomportamiento.description = "#vComportamiento#";
	objForm.RHCJperiodot.required = true;
	objForm.RHCJperiodot.description = "#vPeriodo#";
	
</script>
</cfoutput>