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
<cfif isdefined("form.CILcodigo") and form.CILcodigo NEQ "">
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
		select convert(varchar,b.PLcodigo) as PLcodigo, 
		PLnombre ,
		CILnombre,
		convert(varchar,a.CILcodigo) as CILcodigo, 
		convert(varchar,b.PLinicio,103) as PLinicio, 
		convert(varchar,b.PLfinal,103) as PLfinal,
		b.PLcorto,
		b.ts_rversion
		from CicloLectivo a, PeriodoLectivo b
		where a.CILcodigo = b.CILcodigo
		   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		   and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
		   and b.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PLcodigo#">
	</cfquery>
	<!--- <cfdump var="#form#">
	<cfdump var="#rsForm#">	 --->
	<cfquery name="rsCicloEvaluacion" datasource="#Session.DSN#">
		select CIEnombre, 	convert(varchar,a.CIEcodigo) as CIEcodigo, a.CIEsemanas
		from CicloEvaluacion a
		where a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
	</cfquery>
	
	<cfquery name="rsPerEvaluac" datasource="#Session.DSN#">
		Select count(*) cantPerMatricula
		from PeriodoMatricula pm
			, PeriodoLectivo pl
		where pm.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and pm.PLcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PLcodigo#">
			and pm.Ecodigo=pl.Ecodigo
			and pm.PLcodigo=pl.PLcodigo
	</cfquery>
</cfif>

<form name="formCiclosLectivos" method="post" action="PeriodoLectivo_SQL.cfm" onSubmit="return validaDet(this);">
<cfoutput> 

	<input type="hidden" name="CILcodigo" id="CILcodigo" value="<cfif isdefined("form.CILcodigo") and len(trim(form.CILcodigo)) neq 0>#Form.CILcodigo#</cfif>">	
	<input type="hidden" name="PLcodigo" id="PLcodigo" value="<cfif isdefined("form.PLcodigo") and len(trim(form.PLcodigo)) neq 0>#Form.PLcodigo#</cfif>">	
	<input type="hidden" name="nivel" id="nivel" value="<cfif isdefined("form.nivel") and len(trim(form.nivel)) neq 0>#Form.nivel#</cfif>">	
	<input type="hidden" name="CIEsemanas" id="CIEsemanas" value="<cfif  modo NEQ 'ALTA'>#rsCicloEvaluacion.CIEsemanas#</cfif>">	

 <table width="100%" border="0" cellspacing="1" cellpadding="1">
		<tr>
		  <td class="tituloMantenimiento" colspan="3" align="center">		  	<font size="3">
				<cfif modo eq "ALTA">
					Nuevo 
					  <cfelse>
					Modificar 
				</cfif>
			    Ciclo Lectivo </font>
				 <cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">
				 </td>
		</tr>
      <tr> 
        <td width="26%" nowrap align="right" class="fileLabel">Tipo de Ciclo Lectivo:</td>
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
        <td colspan="2"><input name="PLnombre" type="text" id="PLnombre" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.PLnombre#<cfelse>#rsCicloLectivo.CILcicloLectivo# ????</cfif>" size="50" maxlength="50"></td>
      </tr>
      <tr>
        <td align="right" class="fileLabel">Nombre Corto Ciclo:
        <td colspan="2"><input name="PLcorto" type="text" id="PLcorto" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.PLcorto#</cfif>" size="10" maxlength="7"></td>
      </tr>
      <tr>
        <td align="right" class="fileLabel">Fecha Inicial:
        <td colspan="2">
			<cfif modo eq "ALTA">
				<!--- <cfset fechaini = LSdateformat(Now(),"dd/mm/yyyy")>
				<cfset fechafin = LSdateformat(Now(),"dd/mm/yyyy")> --->
				<cfset fechaini = "">
				<cfset fechafin = "">
			<cfelse>
				<cfset fechaini = rsForm.PLinicio>
				<cfset fechafin = rsForm.PLfinal>
				 <!---  ts_rversion --->
				  <cfset ts = ""> 
				
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
			</cfif>
			<cf_sifcalendario name="PLinicio" value="#fechaini#" form="formCiclosLectivos"> </td>
      </tr>
      <tr>
        <td align="right" class="fileLabel">Fecha Final:      
        <td colspan="2">
			<cf_sifcalendario name="PLfinal" value="#fechafin#" form="formCiclosLectivos">
		</td>
      </tr>
      <tr>
        <td align="center" colspan="2">
          <cfset mensajeDelete = "¿Desea Eliminar este Ciclo Lectivo?">
          <cfinclude template="/educ/portlets/pBotones.cfm">
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
	function validaDet(){
		if(btnSelected('Baja', document.formCiclosLectivos)){
			<cfif isdefined('rsPerEvaluac') and rsPerEvaluac.recordCount GT 0 and rsPerEvaluac.cantPerMatricula GT 0>
				alert('Error, no se permite el borrado del Periodo Lectivo <cfoutput>#rsForm.PLnombre#</cfoutput> porque posee Periodos de Matricula asignados')
				return false;
			</cfif>
		}
		
		return true;
	}
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.PLnombre.required = false;
		objForm.PLinicio.required = false;
		objForm.PLfinal.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.PLnombre.required = true;
		objForm.PLinicio.required = true;
		objForm.PLfinal.required = true;
	}
//---------------------------------------------------------------------------------------	
	function __isFechaValida() {
	  if (this.required) {
	   var a = this.obj.form.PLinicio.value.split("/");
	   var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
	   var b = this.obj.form.PLfinal.value.split("/");
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
				this.error = "Usted no puede eliminar La carrera '" + this.obj.form.PLnombre.value + "' porque éste tiene asociado: " + msg + ".";
				this.obj.form.PLnombre.focus();
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
	
	objForm = new qForm("formCiclosLectivos");
//---------------------------------------------------------------------------------------
	objForm.PLnombre.required = true;
	objForm.PLnombre.description = "Nombre del Periodo";
	objForm.PLinicio.required = true;
	objForm.PLinicio.description = "Fecha Inicial";
	objForm.PLinicio.validateFechaValida();
	objForm.PLfinal.required = true;
	objForm.PLfinal.description = "Fecha Final";
		
/*	<cfif modo NEQ "ALTA">
		objForm.PLnombre.validateTieneDependencias();
	</cfif>	*/
</script>