<!--- Definición del modo. --->
<cfset modo = "ALTA">
<cfif isdefined("url.CRTCid") and len(trim(url.CRTCid))>
	<cfset form.CRTCid = url.CRTCid>
</cfif>
<cfif isdefined("url.CRTCcodigo") and len(trim(url.CRTCcodigo))>
	<cfset form.CRTCcodigo= url.CRTCcodigo>
</cfif>
<cfif isdefined("url.CRTCdescripcion") and len(trim(url.CRTCdescripcion))>
	<cfset form.CRTCdescripcion = url.CRTCdescripcion>
</cfif>
<cfif isdefined("form.CRTCid") and len(trim(form.CRTCid))>
	<cfset modo = "CAMBIO">
</cfif>

<!--- Consultas --->
<cfquery name="rsLista" datasource="#session.DSN#">	
	select 
		A.Ecodigo,
		A.CRTCid,
		A.CRTCcodigo,
		A.CRTCdescripcion,
		A.ts_rversion
	from CRTipoCompra A
	
	<cfif isdefined("form.CRTCid") and len(trim(form.CRTCid))>
 		where A.CRTCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRTCid#">
	</cfif>
</cfquery>

<!--- Pintado del Formulario --->
<cfoutput>
<form action="tcompra-sql.cfm" method="post" name="form1">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="3" class="tituloAlterno"><div align="center"> 
				<cfif modo eq 'ALTA'>Nuevo Tipo Compra<cfelse>Modificar Tipo Compra</cfif></div>
			</td>
		</tr>	  	
		<tr>
			<td class="fileLabel" align="right">C&oacute;digo:</td>
			<td>
				<input type="text" name="CRTCcodigo" id="CRTCcodigo" maxlength="10" size="10" onFocus="this.select()"
				value="<cfif isdefined("form.CRTCcodigo") and len(trim(form.CRTCcodigo))>#trim(form.CRTCcodigo)#</cfif>">
			</td>			
			<cfif modo eq "CAMBIO">
				<td>
					<input type="hidden" name="CRTCcodigoL" id="CRTCcodigoL" value="#trim(rsLista.CRTCcodigo)#">
				</td>			
			</cfif>
		</tr>
		<tr> 
			<td class="fileLabel" align="right">Descripci&oacute;n:</td>
			<td>
				<input type="text" name="CRTCdescripcion" id="CRTCdescripcion" maxlength="80" size="30"  onFocus="this.select()"
				value="<cfif isdefined("form.CRTCdescripcion") and len(trim(form.CRTCdescripcion))>#form.CRTCdescripcion#</cfif>">
			</td>			
		</tr>
		<tr>
			<td>
				<input type="hidden" name="CRTCid" id="CRTCid" value="<cfif isdefined("form.CRTCid") and len(trim(form.CRTCid))>#form.CRTCid#</cfif>">
			</td>
		</tr>

		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsLista.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<tr>
			<td>
				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">
			</td>
		</tr>		
	</table>
	<cf_botones modo="#modo#">
</form>

<!--- Validaciones del Form --->
<cf_qforms>
<script language="javascript" type="text/javascript">

	//1. Definir las descripciones de los objetos
	objForm.CRTCcodigo.description = "#JSStringFormat('Código')#";
	objForm.CRTCdescripcion.description = "#JSStringFormat('Descripción')#";
	
	//2. Definir la función de validacion
	function habilitarValidacion(){
		objForm.CRTCcodigo.required="true";
		objForm.CRTCdescripcion.required="true";
	}
	
	//3. Definir la función de desabilitar la validacion
	function deshabilitarValidacion(){
		objForm.CRTCcodigo.required="false";
		objForm.CRTCdescripcion.required="false";
	}
	
	function funcNuevo() {
		document.form1.CRTCcodigo.value=".";
	}

	function funcBaja() {
		funcNuevo();
	}	
</script>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	document.form1.CRTCcodigo.focus();
</script>