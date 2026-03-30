<cfif isdefined("url.COTRid") and (url.COTRid gt 0) and not isdefined("form.COTRid")>
	<cfset form.COTRid = url.COTRid>
</cfif>
<cfset modo = "ALTA">
<cfif isDefined("Form.COTRid") and len(trim(#Form.COTRid#)) NEQ 0> <!--- me lo da la lista --->
	<cfquery name="rsConsulta" datasource="#Session.DSN#">
		Select 	COTRid,COTRCodigo,COTRDescripcion,Ecodigo,COTRGenDeposito,CcuentaGarantiaRecibida,
				CcuentaGarantiaPagar,CcuentaIngresoGarantia, COTRmodificar, BMUsucodigo,ts_rversion
		from COTipoRendicion
		where COTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COTRid#">
	</cfquery>
	<cfif rsConsulta.recordcount GT 0>
		<cfset modo = "CAMBIO">
	</cfif>
</cfif> 

<cfif modo neq 'ALTA'>
		
	<cfquery name="rsCcuentaGarantiaRecibida" datasource="#Session.DSN#">
		select Ccuenta, Cformato, Cdescripcion
		 from CContables 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.CcuentaGarantiaRecibida#" null="#Len(rsConsulta.CcuentaGarantiaRecibida) is 0#">
	</cfquery>
	
	<cfquery name="rsCcuentaGarantiaPagar" datasource="#Session.DSN#">
		select Ccuenta, Cformato, Cdescripcion
		 from CContables 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.CcuentaGarantiaPagar#" null="#Len(rsConsulta.CcuentaGarantiaPagar) is 0#">
	</cfquery>
	
	<cfquery name="rsCcuentaIngresoGarantia" datasource="#Session.DSN#">
		select Ccuenta, Cformato, Cdescripcion
		 from CContables 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.CcuentaIngresoGarantia#" null="#Len(rsConsulta.CcuentaIngresoGarantia) is 0#">
	</cfquery>
		
</cfif>

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
<form name="form1" method="post" action="TiposDeRendicion-SQL.cfm">
<!---<cfif modo NEQ 'ALTA'> --->
<fieldset>
<legend>Catálogo de Rendición:</legend>
<table width="50%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="3" align="left" valign="baseline" class="tituloListas subTitulo" nowrap>Rendición</td>		
	</tr>
	<tr>		
		<td>Código:&nbsp;</td>
		<td>Modificable</td>					
        <td  style="padding-left: 8px;">Genera Deposito</td>
	</tr>
	<tr> 		
		<td>		
			<input type="text" name="COTRCodigo" style="width:100px" maxlength="25" size="25" value="<cfif #modo#  NEQ "ALTA">#rsConsulta.COTRCodigo#</cfif>" onFocus="javascript:this.select();" onBlur="javascript:validar_identificacion(this);" alt="El campo Identificación" tabindex="1">
		</td>		
		<td align="center">             
              <input type="checkbox" name="COTRmodificar" id="COTRmodificar" tabindex="1" <cfif modo NEQ "ALTA" and #rsConsulta.COTRmodificar# EQ 1>checked</cfif>>
		</td>	
        <td align="center">             
              <input type="checkbox" name="COTRGenDeposito" id="COTRGenDeposito" tabindex="1" <cfif #modo# NEQ "ALTA" and #rsConsulta.COTRGenDeposito# EQ 1>checked</cfif>>
		</td>
	</tr>
	<tr>		
		<td valign="baseline" >Descripción:</td>
		<td valign="baseline" >&nbsp;</td>
	</tr>
	<tr>		
		<td valign="baseline" >
			<input type="text" name="COTRDescripcion" size="75"  value="<cfif #modo# NEQ "ALTA">#trim(rsConsulta.COTRDescripcion)#</cfif>" onFocus="javascript:this.select();" tabindex="1">
		</td>
	    
	    <td valign="baseline" >&nbsp;</td>
	</tr>
		
	<tr id='tr_cuentaGarantiaRecibida'  >
			<td align="left" nowrap>Cuenta Garantía Recibida</td>
			
			<tr><td align="left" nowrap>
				<cfif #modo# NEQ "ALTA">
					<cf_cuentas form="form1" tabindex="1" Conexion="#Session.DSN#" Conlis="S" query="#rsCcuentaGarantiaRecibida#" auxiliares="N" movimiento="S" frame="frame1" ccuenta="CcuentaGarantiaRecibida" cdescripcion="CGRdescripcion" cformato="CGRformato" >	  
				<cfelse>
					<cf_cuentas form="form1" tabindex="1" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" frame="frame1" ccuenta="CcuentaGarantiaRecibida" cdescripcion="CGRdescripcion" cformato="CGRformato">
				</cfif>			</tr></td>
	</tr>
	
	<tr id='tr_cuentaGarantiaPagar'  >
			<td align="left" nowrap>Cuenta Garantía a Pagar</td>
	  <tr><td align="left" nowrap>
				<cfif #modo# NEQ "ALTA">
					<cf_cuentas form="form1" tabindex="1" Conexion="#Session.DSN#" Conlis="S" query="#rsCcuentaGarantiaPagar#" auxiliares="N" movimiento="S" frame="frame2" ccuenta="CcuentaGarantiaPagar" cdescripcion="CGPdescripcion" cformato="CGPformato">	  
				<cfelse>
					<cf_cuentas form="form1" tabindex="1" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" frame="frame2" ccuenta="CcuentaGarantiaPagar" cdescripcion="CGPdescripcion" cformato="CGPformato">
				</cfif>			</tr></td>
	</tr>
	
	<tr id='tr_cuentaIngresoGarantia' >
			<td align="left" nowrap>Cuenta Ingreso Garantía</td>
	  <tr><td align="left" nowrap>
				<cfif #modo# NEQ "ALTA">
					<cf_cuentas form="form1" tabindex="1" Conexion="#Session.DSN#" Conlis="S" query="#rsCcuentaIngresoGarantia#" auxiliares="N" movimiento="S" frame="frame3" ccuenta="CcuentaIngresoGarantia" cdescripcion="CIGdescripcion" cformato="CIGformato">	  
				<cfelse>
					<cf_cuentas form="form1" tabindex="1" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" frame="frame3" ccuenta="CcuentaIngresoGarantia" cdescripcion="CIGdescripcion" cformato="CIGformato">
				</cfif>			</tr></td>
	</tr>	
	<!--- Botones --->
	<tr> 
		<td colspan="4" align="right" valign="baseline" nowrap> 
		<div align="center"> 
		<cf_botones modo=#modo#>
		</div>
		</td>
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
	<input name="COTRid" type="hidden" value="#rsConsulta.COTRid#">
	</cfif>
</form>


<cf_qforms>
	<cf_qformsRequiredField name="CcuentaGarantiaPagar" description="Cuenta Garantia Pagar">
	<cf_qformsRequiredField name="CcuentaGarantiaRecibida" description="Cuenta Garantia Recibida">
	<cf_qformsRequiredField name="CcuentaIngresoGarantia" description="Cuenta Ingreso Garantia">
	<cf_qformsRequiredField name="COTRCodigo" description="Codigo">
	<cf_qformsRequiredField name="COTRDescripcion" description="Descripcion">
</cf_qforms>

<!---<cf_qforms form= "form1" > --Otra forma de validar los campos
<script language= javascript1  type= text/javascript >
	objForm.COTRCodigo.description =  "Codigo" ;
	objForm.COTRDescripcion.description =  "Descripcion" ;
	objForm.CcuentaGarantiaPagar.description =  "Cuenta Garantia Pagar" ;
	objForm.CcuentaIngresoGarantia.description =  "Cuenta Ingreso Garantia" ;
	objForm.CcuentaGarantiaRecibida.description =  "Cuenta Garantia Recibida" ;
	
	objForm.COTRCodigo.required = true;
	objForm.COTRDescripcion.required = true;
	objForm.CcuentaGarantiaPagar.required = true;
	objForm.CcuentaIngresoGarantia.required = true;
	objForm.CcuentaGarantiaRecibida.required = true;
</script>--->

</cfoutput>





