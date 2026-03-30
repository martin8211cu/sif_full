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
<!-- modo para el detalle -->
<cfif isdefined("form.DTlinea")>
	<cfset modoDet="CAMBIO">
<cfelse>
	<cfif not isdefined("form.DTlinea")>
		<cfset modoDet="ALTA">
	<cfelseif form.modoDet EQ "CAMBIO">
		<cfset modoDet="CAMBIO">
	<cfelse>
		<cfset modoDet="ALTA">
	</cfif>
</cfif>

<cfquery name="rsTransforma" datasource="#Session.DSN#">
	select ETid 
	 from ETransformacion 
	where Ecodigo = #Session.Ecodigo#
	and ETfechaProc is null
</cfquery>

<cfif isdefined("rsTransforma") and len(trim(rsTransforma.ETid)) NEQ 0> 
	<cfset form.ETid = rsTransforma.ETid>
	<cfset modo="CAMBIO">
</cfif>

<!--- Consultas --->
<cfif modo NEQ 'ALTA'>
	<!--- Datos del Encabezado --->
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select ETid, ETdocumento, ETfecha, ETfechaProc,  
			ETobservacion, Usucodigo, Ulocalizacion, coalesce(ETcostoProd, 0.00) as ETcostoProd, ts_rversion 
		from ETransformacion
		where Ecodigo = #Session.Ecodigo#
		  and ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">
		  and ETfechaProc is null
	</cfquery>
</cfif>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript1.2" src="/cfmx/sif/js/NumberFormat150.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	// función similar al fm pero mejorada
	function fm_2(campo,decimales) 
	{
		var nf = new NumberFormat();
		
		nf.setNumber(campo.value);
		nf.setPlaces(decimales); 
		nf.setCommas(true);
		nf.setCurrency(false); 
	
		var s = nf.toFormatted();
		campo.value = s;
	}
</script>
<cf_templatecss>

<cfoutput>
  <cfif modo NEQ "ALTA">
   
  	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Encabezado">
	<table width="100%" border="0" cellspacing="1" cellpadding="1">  	
  	<tr>
		<td><div align="right"><strong>Documento:</strong></div></td>
		<td><input type="text" name="ETdocumento" size="20" maxlength="20" onFocus="javascript:document.form1.ETdocumento.select();" value="#Trim(rsForm.ETdocumento)#" ></td>
		<td><div align="right"><strong>Fecha:</strong></div></td>
	    <td>&nbsp;<input type="text" name="ETfecha" value="#LSDateFormat(rsForm.ETfecha, 'DD/MM/YYYY')#" class="cajasinbordeb" size="11" maxlength="11" readonly></td>
  	    <td nowrap><div align="right"><strong>Gastos:</strong></div></td>
  	    <td>
			#LSNumberFormat(rsForm.ETcostoProd,',9.00')#
		</td>
  	</tr>
  	<tr>
  	  <td valign="top"><div align="right"><strong>Observaci&oacute;n:</strong></div></td>
  	  <td colspan="5">
	  	<textarea name="ETobservacion" rows="3" style="width:100%">#rsForm.ETobservacion#</textarea>
	  </td>
  	  </tr>
  	<tr>
  	  <td>&nbsp;</td>
  	  <td>&nbsp;</td>
  	  <td nowrap>&nbsp;</td>
  	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
  	</tr>
  	<tr>
    <td colspan="6"><div align="center">

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
		
		<cfif not isdefined('modo')>
			<cfset modo = "ALTA">
		</cfif>
		
		<input type="hidden" name="botonSel" value="">		
		<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
		
		<!--- Botones --->		
		<input  type="button" name="Anterior" value="<< Anterior" onClick="javascript: goPrevious(this.form);">
		<input  type="submit" name="btnCambiarE" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name;" >
		<input  type="submit" name="btnBorrarE" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea Eliminar el Documento?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
		<input  type="button" name="Siguiente" value="Siguiente >>" onClick="javascript: goNext(this.form);">
		</div>
		<!--- / Botones --->
		<cfset tsE = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="tsE">
		</cfinvoke>
		<input name="ETid" type="hidden" value="#rsForm.ETid#">
		<input type="hidden" name="timestampE" value="#tsE#">
	  </td>
	</tr>	
	</table>
	<cf_web_portlet_end>
  </cfif>  
</cfoutput>