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
<cfif isdefined("Url.CLTtipoLectivo") and not isdefined("form.CLTtipoLectivo")>
	<cfset Form.CLTtipoLectivo = Url.CLTtipoLectivo>
</cfif>
<!---
Ecodigo                        numeric                        9           18   0     0                                                                                                  0
CLTtipoLectivo                 varchar                        50                     1                                                                                                  0
CLTciclos                      tinyint                        1                      0                                                                                                  0
CLTsemanas                     tinyint                        1                      0                                                                                                  0
ts_rversion                      ts_rversion                      8                      1                                                                                                  0
--->

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		Select convert(varchar,Ecodigo) as Ecodigo
			, CLTcicloEvaluacion
			, CLTciclos
			, CLTsemanas
			, CLTvacaciones
			, ts_rversion
		from CicloLectivoTipo
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CLTcicloEvaluacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CLTcicloEvaluacion#">
	</cfquery>

	<cfquery datasource="#Session.DSN#" name="rsHayCicloLectivo">
		Select *
		from CicloLectivo
		where CLTcicloEvaluacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CLTcicloEvaluacion#">
	</cfquery>	

</cfif>

<script type="text/javascript" language="JavaScript">
	function irALista() {
		location.href = "CicloLectivoTipo.cfm";
	}
</script>

<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/utilesMonto.js">//</script>

<form action="CicloLectivoTipo_SQL.cfm" method="post" name="formTipoCiclo" >
	<cfif modo neq 'ALTA'>
		<cfset ts = "">	
		<cfoutput>
			
			<cfinvoke component="educ.componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#" size="32">					
			<input type="hidden" name="HayCicloLectivo"  value="<cfif isdefined('rsHayCicloLectivo') and rsHayCicloLectivo.recordCount GT 0>#rsHayCicloLectivo.recordCount#<cfelse>0</cfif>">			
		</cfoutput>
	</cfif>
  <table width="100%" border="0" cellpadding="1" cellspacing="1">
    <tr> 
      <td class="tituloMantenimiento" colspan="3" align="center"> <font size="3"> 
        <cfif modo eq "ALTA">
          Nuevo 
          <cfelse>
          Modificar Tipo de Per&iacute;odo 
        </cfif>
        </font></td>
    </tr>
    <tr> 
      <td align="right" valign="baseline">Tipo Per&iacute;odo de Evaluaci&oacute;n:</td>
      <td valign="baseline"><input name="CLTcicloEvaluacion" type="text" id="CLTcicloEvaluacion"  <cfif modo neq 'ALTA'>readonly</cfif> onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.CLTcicloEvaluacion#</cfoutput></cfif>" size="15" maxlength="15"></td>
      <td valign="middle" align="right">
	  	<cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">
	  </td>
    </tr>
    <tr> 
      <td align="right"> N&uacute;mero de Per&iacute;odos por Ciclos: </td>
      <td colspan="2" align="left"> <input name="CLTciclos" type="text" id="CLTciclos" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.CLTciclos#</cfoutput></cfif>" size="3" maxlength="4" onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"> 
      </td>
    </tr>
    <tr> 
      <td align="right"> Semanas lectivas de cada Per&iacute;odo: </td>
      <td colspan="2" align="left"><input name="CLTsemanas" align="left" type="text" id="CLTsemanas" size="8" maxlength="8" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.CLTsemanas#</cfoutput></cfif>"  onfocus="javascript: this.select();" onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
    </tr>
    <tr> 
      <td align="right"> Semanas vacaciones despues de cada Per&iacute;odo: </td>
      <td colspan="2" align="left"><input name="CLTvacaciones" align="left" type="text" id="CLTvacaciones" size="8" maxlength="8" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.CLTvacaciones#</cfoutput></cfif>"  onfocus="javascript: this.select();" onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"> (excluyendo el último)</td>
    </tr>
    <tr> 
      <td align="center">&nbsp;</td>
      <td colspan="2" align="center">&nbsp;</td>
    </tr>
    <tr> 
      <td align="center" colspan="3"> <cfset mensajeDelete = "¿Desea Eliminar esta Tipo de Período?"> 
        <cfinclude template="/educ/portlets/pBotones.cfm">
		<input type="button" name="btnLista"  tabindex="1" value="Lista de Tipos de Per&iacute;odo" onClick="javascript: irALista();">
	  </td>
    </tr>
  </table>
</form>	  

<script language="JavaScript">
	
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.CLTcicloEvaluacion.required = false;
		objForm.CLTciclos.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.CLTcicloEvaluacion.required = true;
		objForm.CLTciclos.required = true;				
	}
//---------------------------------------------------------------------------------------	
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
			// Valida que el tipo de ciclo Lectivo no tenga dependencias.
			var msg = "";
			if (new Number(this.obj.form.HayCicloLectivo.value) > 0) {
				msg = msg + "Ciclo Lectivo";
			}
			if (msg != ""){
				this.error = "Usted no puede eliminar el tipo de Per&iacute;odo de Evaluaci&oacute;n'" + this.obj.form.CLTcicloEvaluacion.value + "' porque éste tiene asociado: " + msg + ".";
				this.obj.form.CLTcicloEvaluacion.focus();
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
	objForm = new qForm("formTipoCiclo");
//---------------------------------------------------------------------------------------
	objForm.CLTcicloEvaluacion.required = true;
	objForm.CLTcicloEvaluacion.description = "Nombre";
	objForm.CLTsemanas.required = true;
	objForm.CLTsemanas.description = "Semanas";
	objForm.CLTvacaciones.required = true;
	objForm.CLTvacaciones.description = "Semanas de vacaciones";
	
	<cfif modo NEQ "ALTA">
		objForm.CLTcicloEvaluacion.validateTieneDependencias();
	</cfif>	
	objForm.CLTciclos.required = true;
	objForm.CLTciclos.description = "Número de Periodos por Ciclos";	
</script>
