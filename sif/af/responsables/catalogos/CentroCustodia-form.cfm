<cfif isdefined("url.CRCCid") and Len("url.CRCCid") gt 0>
	<cfset form.CRCCid = url.CRCCid >
	<cfset form.Cambio = "Cambiar" >
</cfif>
<cfset modo = 'ALTA'>
<cfif isdefined("form.CRCCid") and len(trim(form.CRCCid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif isdefined("Form.CRCCid") AND Len(Trim(Form.CRCCid)) GT 0 >
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select  CRCCid,DEid, 
				CRCCcodigo,
				CRCCdescripcion,
				ts_rversion
		from CRCentroCustodia 
		where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">							
	</cfquery>
</cfif>
<SCRIPT LANGUAGE='Javascript'  SRC="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
</SCRIPT>


<cfset ts = ""> 
<cfif modo NEQ "ALTA">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts">
	</cfinvoke>
</cfif>

<cfoutput>
<form action="CentroCustodia-sql.cfm" method="post" enctype="multipart/form-data" name="form1">
	<table width="50%" align="center" border="0" cellpadding="2" cellspacing="0">
		<tr>
			<td width="50%" valign="top">
				<table align="center" width="100%" cellpadding="2" cellspacing="0">
					<tr > 
						<td width="25%" nowrap align="right">C&oacute;digo:</td>
						<td width="70%">
							<input type="text" name="CRCCcodigo" tabindex="1"
							value="<cfif modo NEQ "ALTA">#rsDatos.CRCCcodigo#</cfif>" 
							size="10" maxlength="10" onfocus="javascript:this.select();" >
						</td>
					</tr>
					<tr > 
						<td nowrap align="right">Descripci&oacute;n:</td>
						<td>
							<input type="text" name="CRCCdescripcion"  tabindex="1"
							value="<cfif modo NEQ "ALTA">#rsDatos.CRCCdescripcion#</cfif>" 
							size="80" maxlength="80" onfocus="javascript:this.select();" >
						</td>
					</tr>
					<tr > 
						<td nowrap align="right">Responsable:</td>
						<td>
							<cfif modo NEQ "ALTA">
								<cf_rhempleado tabindex="1" size = "50" idempleado="#rsDatos.DEid#">
							<cfelse>	
								<cf_rhempleado tabindex="1" size = "50">
							</cfif>		
						</td>
					</tr>
					
					
				</table>
			</td>
			<!--- ********************************************************************************************* --->
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="baseline">
			<td colspan="2" align="center" nowrap>
				<input type="hidden" name="botonSel" value="">
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif modo NEQ "ALTA">
					<input type="submit" tabindex="1" class="btnGuardar"  	name="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; ">
					<input type="submit" tabindex="1" class="btnEliminar" 	name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Está seguro(a) de que desea eliminar el registro?') ){ if (window.deshabilitarValidacionIns) deshabilitarValidacionIns(); return true; }else{ return false;}">
					<input type="button" tabindex="1" class="btnNuevo" 		name="Nuevo" value="Nuevo" onClick="javascript: location.href='CentroCustodia.cfm'">
				<cfelse>
					<input type="submit" tabindex="1" class="btnGuardar" 	name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name;">
					<input type="reset"  tabindex="1" class="btnLimpiar"	name="Limpiar" value="Limpiar" >
				</cfif>
					<input type="button" tabindex="1" class="btnAnterior" name="Regresar" value="Listado de Centros" onClick="javascript: regresarCentros();">
			</td>
		</tr>		
	</table>
	
	
	
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
	<input type="hidden" name="CRCCid" value="<cfif modo NEQ "ALTA">#rsDatos.CRCCid#</cfif>">
</form>
</cfoutput>
<script language="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	Objform1ns = new qForm("form1");
	Objform1ns.CRCCcodigo.required = true;
	Objform1ns.CRCCcodigo.description="Código";				
	Objform1ns.CRCCdescripcion.required = true;
	Objform1ns.CRCCdescripcion.description="Descripción";				
	Objform1ns.DEid.required = true;
	Objform1ns.DEid.description="Empleado";				

	function deshabilitarValidacionIns(){
		Objform1ns.CRCCcodigo.required = false;
		Objform1ns.CRCCdescripcion.required = false;
		Objform1ns.DEid.required = false;
	}
	
	function regresarCentros(){
		location.href="listaCentroCustodia.cfm";
	}
</script>

<script language="javascript">
	document.form1.CRCCcodigo.focus();
</script>