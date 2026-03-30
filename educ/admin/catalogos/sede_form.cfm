<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio")>
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

<!---  Consultas --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		Select convert(varchar,Scodigo) as Scodigo
			, Snombre
			, Scodificacion
			, Sorden
			, Sprefijo
			, ts_rversion
		from Sede
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and Scodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Scodigo#">
	</cfquery>

	<cfquery datasource="#Session.DSN#" name="rsHayPlanSede">
		Select *
		from PlanSede
		where Scodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Scodigo#">
	</cfquery>	
</cfif>

<cfquery name="qrySorden" datasource="#Session.DSN#">
	select Sorden
	from Sede
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/utilesMonto.js">//</script>

<form action="sede_SQL.cfm" method="post" name="formSede">
	<cfif modo neq 'ALTA'>
		<cfset ts = "">	
		<cfoutput>
			<input type="hidden" name="Scodigo" id="GAcodigo" value="#rsForm.Scodigo#">
			<cfinvoke component="educ.componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#" size="32">					
			<input type="hidden" name="HayPlanSede"  value="<cfif isdefined('rsHayPlanSede') and rsHayPlanSede.recordCount GT 0>#rsHayPlanSede.recordCount#<cfelse>0</cfif>">			
		</cfoutput>
	</cfif>
	
	<table width="95%" border="0" cellpadding="1" cellspacing="1" align="center">
		<tr>
		  <td class="tituloMantenimiento" colspan="3" align="center">
		  	<font size="3">
				<cfif modo eq "ALTA">
					Nueva Sede
					  <cfelse>
					Modificar Sede
				</cfif>
			</font>
		  </td>
		</tr>
		<tr>
          <td align="right" nowrap> C&oacute;digo: </td>
          <td align="left">
            <input name="Scodificacion" type="text" id="Scodificacion" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.Scodificacion#</cfoutput></cfif>" size="15" maxlength="15">
          </td>
	      <td align="right">
				<cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">
		  </td>
	  </tr>
		<tr>
          <td align="right" valign="baseline" nowrap>Nombre: </td>
          <td colspan="2" valign="baseline"><input name="Snombre" type="text" id="Snombre" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.Snombre#</cfoutput></cfif>" size="50" maxlength="50">
          </td>
	  </tr>
		<tr>
          <td align="right" nowrap>Prefijo para Edificio:</td>
          <td colspan="2" align="left"><input name="Sprefijo" type="text" id="Sprefijo" size="10" tabindex="1" maxlength="3" onFocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Sprefijo#</cfoutput></cfif>">
          </td>
	  </tr>
		<!---
		<tr> 
		  <td align="right"> Orden: </td>
		  <td align="left"><input name="Sorden" align="left" type="text" id="Sorden" size="8" maxlength="8" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.Sorden#</cfoutput></cfif>" onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,0);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>
		</tr>
		--->		
		<tr> 
		  <td align="center" colspan="3">
		  	<cfset mensajeDelete = "¿Desea Eliminar esta Sede ?">
		  	<cfinclude template="/educ/portlets/pBotones.cfm">
			<input name="btnLista" type="button" onClick="javascript: IrLista();" id="btnLista" value="Ir a Lista">
		  </td>
		</tr>
	  </table>
</form>	  

<script language="JavaScript">
	function IrLista(){
		<cfif modo NEQ "ALTA">
			document.formSede.Scodigo.value="";
		</cfif>	

		document.formSede.action="Sede.cfm";
		document.formSede.submit();
	}
//----------------------------------------------------------	
	<!---
	function validaSorden(){
		if(btnSelected('Alta',document.formSede) || btnSelected('Cambio',document.formSede)){
			if(document.formSede.Sorden.value != '') {
				var existeSorden = false;

				var ordenList = "<cfoutput>#ValueList(qrySorden.Sorden,',')#</cfoutput>"
				var ordenArray = ordenList.split(",");
				for (var i=0; i<ordenArray.length; i++) {
				<cfif modo NEQ "ALTA">
					if ((ordenArray[i] == document.formSede.Sorden.value) && (ordenArray[i] != <cfoutput>#rsForm.Sorden#</cfoutput>)) {
				<cfelse>
					if (ordenArray[i] == document.formSede.Sorden.value) {
				</cfif>
						existeSorden = true;
						break;
					}
				}
				if (existeSorden){
					alert('Error, el número del orden ya existe, favor digitar uno diferente');
					document.formSede.Sorden.focus();
					return false;
				}
			}else{
				if(btnSelected("Cambio",document.formSede)){
					document.formSede.Sorden.value = "<cfif isdefined('rsForm')><cfoutput>#rsForm.Sorden#</cfoutput></cfif>";
				}
			}
		}
		
		return true;
	}
	--->
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.Snombre.required = false;
		objForm.Scodificacion.required = false;
		objForm.Sprefijo.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.Snombre.required = true;
		objForm.Scodificacion.required = true;
		objForm.Sprefijo.required = true;				
	}
//---------------------------------------------------------------------------------------	
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
			// Valida que la Sede no tenga dependencias.
			var msg = "";
			if (new Number(this.obj.form.HayPlanSede.value) > 0) {
				msg = msg + "Planes de Sede";
			}
			if (msg != ""){
				this.error = "Usted no puede eliminar la Sede '" + this.obj.form.Snombre.value + "' porque éste tiene asociado: " + msg + ".";
				this.obj.form.Snombre.focus();
			}
		}
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isTieneDependencias", __isTieneDependencias);
	objForm = new qForm("formSede");
//---------------------------------------------------------------------------------------
	objForm.Snombre.required = true;
	objForm.Snombre.description = "Nombre";
	objForm.Sprefijo.required = true;
	objForm.Sprefijo.description = "Prefijo";
	<cfif modo NEQ "ALTA">
		objForm.Snombre.validateTieneDependencias();
	</cfif>	
	objForm.Scodificacion.required = true;
	objForm.Scodificacion.description = "Codificación";	
</script>