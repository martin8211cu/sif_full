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

<!--- Consultas --->
<cfif isdefined("form.CILcodigo")>
	<cfquery name="rsCicloLectivo" datasource="#Session.DSN#">
		select CILnombre, 	convert(varchar,a.CILcodigo) as CILcodigo, CILcicloLectivo
		from CicloLectivo a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		   and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
	</cfquery>
	<cfquery name="rsCicloEvaluacion" datasource="#Session.DSN#">
		select CIEnombre, 	convert(varchar,a.CIEcodigo) as CIEcodigo, a.CIEsemanas
		from CicloEvaluacion a
		where a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
	</cfquery>
</cfif>


<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select convert(varchar,c.PEcodigo) as PEcodigo, 
		PEnombre ,
		CILnombre,
		b.PLnombre,
		convert(varchar,a.CILcodigo) as CILcodigo, 
		PEcorto,
		convert(varchar,c.PEinicio,103) as PEinicio, 
		convert(varchar,c.PEfinal,103) as PEfinal,
		c.ts_rversion
		from CicloLectivo a, PeriodoLectivo b, PeriodoEvaluacion c
		where a.CILcodigo = b.CILcodigo
		   and b.PLcodigo = c.PLcodigo
		   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		   and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
		   and b.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PLcodigo#">
		   and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo#">
	</cfquery>
	<!--- <cfdump var="#form#">
	<cfdump var="#rsForm#">	 --->
	<cfquery name="rsCicloEvaluacion" datasource="#Session.DSN#">
		select CIEnombre, 	convert(varchar,a.CIEcodigo) as CIEcodigo, a.CIEsemanas
		from CicloEvaluacion a
		where a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
	</cfquery>
</cfif>
<cf_templatecss>
<form name="formPeriodosEvaluacion" method="post" action="PeriodoEvaluacion_SQL.cfm">
<cfoutput> 

	<input type="hidden" name="CILcodigo" id="CILcodigo" value="<cfif isdefined("form.CILcodigo") and len(trim(form.CILcodigo)) neq 0>#Form.CILcodigo#</cfif>">	
	<input type="hidden" name="PLcodigo" id="PLcodigo" value="<cfif isdefined("form.PLcodigo") and len(trim(form.PLcodigo)) neq 0>#Form.PLcodigo#</cfif>">	
	<input type="hidden" name="PEcodigo" id="PEcodigo" value="<cfif isdefined("form.PEcodigo") and len(trim(form.PEcodigo)) neq 0>#Form.PEcodigo#</cfif>">	
	<input type="hidden" name="nivel" id="nivel" value="<cfif isdefined("form.nivel") and len(trim(form.nivel)) neq 0>#Form.nivel#</cfif>">	
	<input type="hidden" name="CIEsemanas" id="CIEsemanas" value="<cfif  modo NEQ 'ALTA'>#rsCicloEvaluacion.CIEsemanas#</cfif>">	

 <table width="100%" border="0" cellspacing="1" cellpadding="1">
		<tr>
		  <td class="tituloMantenimiento" colspan="3" align="center">
		  	<font size="3">
				<cfif modo eq "ALTA">
					Nuevo 
					  <cfelse>
					Modificar 
				</cfif>
				 Periodo de Evaluación </font>
				 <cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">
				 </td>
		</tr>
      <tr> 
        <td width="26%" align="right" nowrap class="fileLabel">Tipo de Ciclo Lectivo:</td>
        <td>
			<cfif isdefined("rsForm")>
				#rsForm.CILnombre#
			<cfelse>
				#rsCicloLectivo.CILnombre#
			</cfif>
		</td>
       
      </tr>
      <tr>
        <td height="24" align="right" class="fileLabel">Ciclo Lectivo:
        <td colspan="2"><input name="PLnombre" type="text" id="PLnombre" class="cajasinbordeb" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.PLnombre#<cfelse>#rsCicloLectivo.CILcicloLectivo# &nbsp; ????</cfif>" size="50" maxlength="50">
        </td>
      </tr>
      <tr>
        <td height="27" align="right" class="fileLabel">Periodo Evaluación:
        <td colspan="2">
		<input name="PEnombre" type="text" id="PEnombre" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.PEnombre#</cfif>" size="50" maxlength="50">
        </td>
      </tr>
      <tr>
        <td align="right" class="fileLabel">Nombre Corto Período:
        <td colspan="2"><input name="PEcorto" type="text" id="PEcorto" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.PEcorto#</cfif>" size="5" maxlength="5">
        </td>
      </tr>
      <tr>
        <td align="right" class="fileLabel">Fecha Inicial:
        <td colspan="2">
			<cfif modo eq "ALTA">
				<cfset fechaini = LSdateformat(Now(),"dd/mm/yyyy")>
				<cfset fechafin = LSdateformat(Now(),"dd/mm/yyyy")>
			<cfelse>
				<cfset fechaini = rsForm.PEinicio>
				<cfset fechafin = rsForm.PEfinal>
				 <!---  ts_rversion --->
				  <cfset ts = ""> 
				
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
			</cfif>
			<cf_sifcalendario name="PEinicio" value="#fechaini#" form="formPeriodosEvaluacion"> </td>
      </tr>
      <tr>
        <td align="right" class="fileLabel">Fecha Final:
        <td colspan="2">
			<cf_sifcalendario name="PEfinal" value="#fechafin#" form="formPeriodosEvaluacion">
		</td>
      </tr>
      <tr>
        <td align="center" colspan="2">
          <cfset mensajeDelete = "¿Desea Eliminar este periodo de Evaluación?">
          <!--- <cfinclude template="../../portlets/pBotones.cfm"> --->
		  <input name="Cambio" type="submit" onSelect="javascript: alert(select);" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); " value="Modificar">
        </td> 
      </tr>
	 </table>
</cfoutput>
</form>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<script language="JavaScript">

//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.PEnombre.required = false;
		objForm.PEinicio.required = false;
		objForm.PEfinal.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.PEnombre.required = true;
		objForm.PEinicio.required = true;
		objForm.PEfinal.required = true;
	}
//---------------------------------------------------------------------------------------	
	function __isFechaValida() {
	  if (this.required) {
	   var a = this.obj.form.PEinicio.value.split("/");
	   var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
	   var b = this.obj.form.PEfinal.value.split("/");
	   var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
	   //alert(ini);
	   //alert(fin);
	   if (new Date(ini) < new Date(fin)) {
		} else {
		this.error = "La fecha inicial no puede ser mayor a  la fecha final.";
	   }
	  }
	 }


	// Se aplica la descripcion del Concepto 
/*	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
			// Valida que no tenga dependencias.
			var msg = "";
			if (new Number(this.obj.form.HayPlanEstudios.value) > 0) {
				msg = msg + "Planes de Estudio"
			}
			if (msg != ""){
				this.error = "Usted no puede eliminar La carrera '" + this.obj.form.PEnombre.value + "' porque éste tiene asociado: " + msg + ".";
				this.obj.form.PEnombre.focus();
			}
		}
	}	*/
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	//_addValidator("isTieneDependencias", __isTieneDependencias);
	_addValidator("isFechaValida", __isFechaValida);
	
	objForm = new qForm("formPeriodosEvaluacion");
//---------------------------------------------------------------------------------------
	objForm.PEnombre.required = true;
	objForm.PEnombre.description = "Nombre del Periodo de Evaluación";
	objForm.PEinicio.required = true;
	objForm.PEinicio.description = "Fecha Inicio";
	objForm.PEinicio.validateFechaValida();
	objForm.PEfinal.required = true;
	objForm.PEfinal.description = "Fecha Final";
		
/*	<cfif modo NEQ "ALTA">
		objForm.PEnombre.validateTieneDependencias();
	</cfif>	*/
</script>