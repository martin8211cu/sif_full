<!--- Definición del modo. --->
<cfset modo = "ALTA">
<cfif isdefined("url.CRTDid") and len(trim(url.CRTDid))>
	<cfset form.CRTDid = url.CRTDid>
</cfif>
<cfif isdefined("url.CRTDcodigo") and len(trim(url.CRTDcodigo))>
	<cfset form.CRTDcodigo= url.CRTDcodigo>
</cfif>
<cfif isdefined("url.CRTDdescripcion") and len(trim(url.CRTDdescripcion))>
	<cfset form.CRTDdescripcion = url.CRTDdescripcion>
</cfif>
<cfif isdefined("url.CRTDdefault") and len(trim(url.CRTDdefault))>
	<cfset form.CRTDdefault = url.CRTDdefault>
</cfif>
<cfif isdefined("form.CRTDid") and len(trim(form.CRTDid))>
	<cfset modo = "CAMBIO">
</cfif>

<!--- Consultas --->
<cfquery name="rsLista" datasource="#session.DSN#">	
	select 
		A.Ecodigo,
		A.CRTDid,
		A.CRTDcodigo,
		A.CRTDdescripcion,
		A.CRTDdefault,
		A.ts_rversion	
	from CRTipoDocumento A
	
	<cfif isdefined("form.CRTDid") and len(trim(form.CRTDid))>
 		where A.CRTDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRTDid#">
	</cfif>
</cfquery>

<!--- Pintado del Formulario --->
<cfoutput>
<form action="tdocumento-sql.cfm" method="post" name="form1">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="3" class="tituloAlterno"><div align="center">
				<cfif modo eq 'ALTA'>Nuevo Tipo Documento<cfelse>Modificar Tipo Documento</cfif></div>
			</td>
		</tr>	  	
		<tr>
			<td class="fileLabel" align="right">C&oacute;digo:</td>
			<td>
				<input type="text" name="CRTDcodigo" id="CRTDcodigo" maxlength="10" size="10" onFocus="this.select()"
				value="<cfif isdefined("form.CRTDcodigo") and len(trim(form.CRTDcodigo))>#trim(form.CRTDcodigo)#</cfif>">
			</td>			
			<cfif modo eq "CAMBIO">
				<td>
					<input type="hidden" name="CRTDcodigoL" id="CRTDcodigoL" value="#trim(rsLista.CRTDcodigo)#">
				</td>			
			</cfif>
		</tr>
		<tr>
			<td class="fileLabel" align="right">Descripci&oacute;n:</td>
			<td>
				<input type="text" name="CRTDdescripcion" id="CRTDdescripcion" maxlength="80" size="30"  onFocus="this.select()"
				value="<cfif isdefined("form.CRTDdescripcion") and len(trim(form.CRTDdescripcion))>#form.CRTDdescripcion#</cfif>">
			</td>			
		</tr>

		<tr>
			<td class="fileLabel" align="right">Default:</td>
			<td>
				<input type="checkbox" name="CRTDdefault" id="CRTDdefault" 	<cfif isdefined("rsLista.CRTDdefault") and rsLista.CRTDdefault eq 1>checked="checked"</cfif> value="" >
			</td>
		</tr>
		<tr>
			<td>
				<input type="hidden" name="CRTDid" id="CRTDid" value="<cfif isdefined("form.CRTDid") and len(trim(form.CRTDid))>#form.CRTDid#</cfif>">
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
	objForm.CRTDcodigo.description = "#JSStringFormat('Código')#";
	objForm.CRTDdescripcion.description = "#JSStringFormat('Descripción')#";
	
	//2. Definir la función de validacion
	function habilitarValidacion(){
		objForm.CRTDcodigo.required="true";
		objForm.CRTDdescripcion.required="true";
	}
	
	//3. Definir la función de desabilitar la validacion
	function deshabilitarValidacion(){
		objForm.CRTDcodigo.required="false";
		objForm.CRTDdescripcion.required="false";
	}
	
	function funcNuevo() {
		document.form1.CRTDcodigo.value=".";
	}

	function funcBaja() {
		funcNuevo();
	}	
</script>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	document.form1.CRTDcodigo.focus();
</script>