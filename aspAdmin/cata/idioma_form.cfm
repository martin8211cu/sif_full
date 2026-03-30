<!--- Establecimiento del modo --->

<cfif isdefined("form.IrPadre") and form.IrPadre NEQ "">
	<cfset modo="CAMBIO">
	<cfset form.Iid = form.IrPadre>
<cfelseif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif #form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		Select convert(varchar,Iid) as Iid
			, rtrim(i.Icodigo) as Icodigo
			, i.Descripcion
			, i.Inombreloc			
			, i.Iactivo
			, i.Iid_idioma
		from Idioma i
		where Iid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#">
	</cfquery>
</cfif>

<cfparam name="form.Iid_padre" default="">
<cfif form.Iid_padre NEQ "">
	<cfquery name="rsPadre" datasource="#session.DSN#">
		Select rtrim(Icodigo) as Icodigo
			  , Iid_idioma
		from Idioma i
		where Iid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid_padre#">
	</cfquery>
</cfif>

<cfquery name="qryCodigos" datasource="#Session.DSN#">
	Select rtrim(ltrim(Icodigo)) as Icodigo
	from Idioma
</cfquery>

<script language="JavaScript" src="../js/qForms/qforms.js">//</script>
<form action="idioma_SQL.cfm" method="post" name="formIdioma">
	<cfif modo neq 'ALTA'>
		<cfoutput>
			<input type="hidden" name="Iid" value="#rsForm.Iid#">					
			<input type="hidden" name="Iid_idioma" value="#rsForm.Iid_idioma#">					
			<input type="hidden" name="Iid_padre" value="#rsForm.Iid_idioma#">					
		</cfoutput> 
	<cfelse>
		<cfoutput>
			<input type="hidden" name="Iid_idioma" value="#form.Iid_padre#">					
			<input type="hidden" name="Iid_padre" value="#form.Iid_padre#">					
		</cfoutput> 
	</cfif>
	
	<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
		<tr>
		  	<td class="tituloMantenimiento" colspan="3" align="center">
				<cfif modo eq "ALTA">
					Nuevo Idioma
					<cfelse>
					Modificar Idioma
				</cfif>
			</td>
		</tr>	
		<tr> 
		  <td align="right"><strong><cf_LocaleTranslate Etiqueta="Codigo" Default="C&oacute;digo">:</strong>&nbsp;</td>
		  <td valign="baseline">
	  		<input name="IrPadre" type="hidden" value="">
		  	<cfif modo neq 'ALTA'>
				<strong><cfoutput>#rsForm.Icodigo#</cfoutput></strong>
		  		<input name="Icodigo" type="hidden" value="<cfoutput>#rsForm.Icodigo#</cfoutput>">
			<cfelseif form.Iid_padre EQ "">
		  		<input name="Icodigo" type="text" size="2" maxlength="2" onfocus="javascript:this.select();">
			<cfelse>
		  		<input name="Icodigo" type="hidden" value="">
		  		<cfoutput>#rsPadre.Icodigo#_<input name="IcodigoX" type="text" value="" size="2" maxlength="<cfif len(rsPadre.Icodigo) LT 8>2<cfelse>1</cfif>" onfocus="javascript:this.select();"  onKeyUp="javascript:this.form.Icodigo.value='#rsPadre.Icodigo#_' + this.value;"></cfoutput>
			</cfif>
		  </td>
		</tr>		
		<tr> 
		  <td align="right"><strong>Descripci&oacute;n:</strong>&nbsp;</td>
		  <td valign="baseline"><input name="Descripcion" type="text" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.Descripcion#</cfoutput></cfif>" size="60" maxlength="60" onfocus="javascript:this.select();"></td>
		</tr>
		<tr> 
		  <td align="right"><strong>Localizaci&oacute;n:</strong></td>
		  <td><input name="Inombreloc" type="text" id="Inombreloc" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.Inombreloc#</cfoutput></cfif>" size="60" maxlength="60"></td>
		</tr>		
		<tr> 
		  <td align="right"><strong>Activo:</strong></td>
		  <td><input name="Iactivo" type="checkbox" id="Iactivo" value="1" <cfif modo neq 'ALTA' and rsForm.Iactivo EQ 1> checked</cfif> ></td>
		</tr>
		<tr> 
		  <td align="center">&nbsp;</td>
		  <td align="center">&nbsp;</td>
		</tr>		
		<tr> 
		    <td align="center" colspan="2">
				<cfset mensajeDelete = "¿Desea Eliminar el Idioma ?">
				<cfinclude template="../portlets/pBotones.cfm">
			</td>
		</tr>
		<tr> 
		    <td align="center" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;
			<cfif modo neq "ALTA" AND len(rsForm.Icodigo) LTE 9>
				<input type="submit" name="btnDialecto" value="Dialectos"
					onclick="javascript:this.form.action='';this.form.Iid_padre.value = this.form.Iid.value;">
			</cfif>
			<cfif form.Iid_padre NEQ "">
				<input type="submit" name="btnPadre" value="Ir al Padre"
					onclick="javascript:this.form.action='';this.form.IrPadre.value = this.form.Iid_padre.value; this.form.Iid_padre.value = '<cfoutput>#rsPadre.Iid_idioma#</cfoutput>';deshabilitarValidacion();">
			</cfif>
			</td>
		</tr>
	  </table>
</form>	  

<script language="JavaScript">
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.Icodigo.required = false;
		objForm.Descripcion.required = false;		
		objForm.Inombreloc.required = false;				
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.Icodigo.required = true;	
		objForm.Descripcion.required = true;		
		objForm.Inombreloc.required = true;
	}	
//---------------------------------------------------------------------------------------	
	// Se aplica al codigo del idioma 
	function __isValidaCodigo() {
		if(btnSelected("Alta", this.obj.form) || btnSelected("Cambio", this.obj.form)) {
			if(this.value != '') {
				var existeIcodigo = false;
	
				var ordenList = "<cfoutput>#ValueList(qryCodigos.Icodigo,'~')#</cfoutput>"
				var codigosArray = ordenList.split("~");
				for (var i=0; i<codigosArray.length; i++) {
					<cfif modo NEQ "ALTA">
						if ((this.value == codigosArray[i]) && (codigosArray[i] != '<cfoutput>#rsForm.Icodigo#</cfoutput>')) {
					<cfelse>
						if (codigosArray[i] == this.value) {
					</cfif>
						existeIcodigo = true;
						break;
					}
				}
				
				if (existeIcodigo){
					this.error = "El código del idioma ya existe, favor digitar uno diferente";				
					this.focus();
				}
			}else{
				if(btnSelected("Cambio",this.obj.form)){
					this.value = "<cfif isdefined('rsForm')><cfoutput>#rsForm.Icodigo#</cfoutput></cfif>";
				}
			}		
		}
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isValidaCodigo", __isValidaCodigo);
	objForm = new qForm("formIdioma");
//---------------------------------------------------------------------------------------
	objForm.Icodigo.required = true;
	objForm.Icodigo.description = "Código";		
	objForm.Descripcion.required = true;
	objForm.Descripcion.description = "Descripción";		
	objForm.Inombreloc.required = true;
	objForm.Inombreloc.description = "Nombre de la localización";			
	objForm.Icodigo.validateValidaCodigo();
</script>