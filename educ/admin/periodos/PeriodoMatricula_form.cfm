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
<cfquery name="rsFechaMax" datasource="#Session.DSN#">
	select convert(varchar,max(c.PEfinal),103) as PEfinal
		from CicloLectivo a, PeriodoLectivo b, PeriodoEvaluacion c
		where a.CILcodigo = b.CILcodigo
		   and b.PLcodigo = c.PLcodigo
</cfquery>		   

<cfif isdefined("form.CILcodigo")>
	<cfquery name="rsCicloLectivo" datasource="#Session.DSN#">
		select CILnombre, 	convert(varchar,a.CILcodigo) as CILcodigo, a.CILtipoCicloDuracion
		from CicloLectivo a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		   and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
	</cfquery>
	<cfquery name="rsCicloEvaluacion" datasource="#Session.DSN#">
		select CIEnombre, 	convert(varchar,a.CIEcodigo) as CIEcodigo, a.CIEsemanas
		from CicloEvaluacion a
		where a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
	</cfquery>
	<cfquery name="rsPeriodoEvaluacion" datasource="#Session.DSN#">
		select convert(varchar,c.PEcodigo) as PEcodigo, 
		CILnombre,
		c.PEnombre,
		b.PLnombre,
		convert(varchar,a.CILcodigo) as CILcodigo, 
		convert(varchar,c.PEinicio,103) as PEinicio, 
		convert(varchar,c.PEfinal,103) as PEfinal,
		c.ts_rversion
		from CicloLectivo a, PeriodoLectivo b, PeriodoEvaluacion c
		where a.CILcodigo = b.CILcodigo
		   and b.PLcodigo = c.PLcodigo
		   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		   and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
		   <cfif isdefined("form.PLcodigo") and len(trim(form.PLcodigo)) neq 0>
		   		and c.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PLcodigo#">
		   </cfif>
		   <cfif form.CILtipoCicloDuracion NEQ 'L'>
		   		and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo#">
		   </cfif>
		   
	</cfquery>
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select convert(varchar,d.PMcodigo) as PMcodigo, 
		CILnombre,
		c.PEnombre,
		d.PMtipo,
		convert(varchar,a.CILcodigo) as CILcodigo, 
		convert(varchar,d.PMinicio,103) as PMinicio, 
		convert(varchar,d.PMfinal,103) as PMfinal,
		a.CILtipoCicloDuracion,
		d.ts_rversion
		from CicloLectivo a, PeriodoLectivo b, PeriodoEvaluacion c, PeriodoMatricula d
		where a.CILcodigo = b.CILcodigo
		   and b.PLcodigo = c.PLcodigo
		   and c.PLcodigo = d.PLcodigo
		   
		   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		   and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
		   <cfif isdefined("form.PLcodigo") and len(trim(form.PLcodigo)) NEQ 0>
		   		and d.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PLcodigo#">
		   </cfif>
		  <cfif form.CILtipoCicloDuracion NEQ 'L'>
		   		and c.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo#">
				and c.PEcodigo = d.PEcodigo
		   </cfif>
		    <cfif isdefined("form.PMcodigo") and len(trim(form.PMcodigo)) NEQ 0>
		   		and d.PMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PMcodigo#">
		   </cfif>
		   
	</cfquery>
	<cfquery name="rsCicloEvaluacion" datasource="#Session.DSN#">
		select CIEnombre, 	convert(varchar,a.CIEcodigo) as CIEcodigo, a.CIEsemanas
		from CicloEvaluacion a
		where a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
	</cfquery>
</cfif>

<form name="formPeriodosMatricula" method="post" action="PeriodoMatricula_SQL.cfm">
<cfoutput> 

	<input type="hidden" name="CILcodigo" id="CILcodigo" value="<cfif isdefined("form.CILcodigo") and len(trim(form.CILcodigo)) neq 0>#Form.CILcodigo#</cfif>">	
	<input type="hidden" name="PLcodigo" id="PLcodigo" value="<cfif isdefined("form.PLcodigo") and len(trim(form.PLcodigo)) neq 0>#Form.PLcodigo#</cfif>">	
	<input type="hidden" name="PEcodigo" id="PEcodigo" value="<cfif isdefined("form.PEcodigo") and len(trim(form.PEcodigo)) neq 0>#Form.PEcodigo#</cfif>">	
	<input type="hidden" name="PMcodigo" id="PMcodigo" value="<cfif isdefined("form.PMcodigo") and len(trim(form.PMcodigo)) neq 0>#Form.PMcodigo#</cfif>">	
	<input type="hidden" name="PMsecuencia" id="PMsecuencia" value="<cfif isdefined("form.PMsecuencia") and len(trim(form.PMsecuencia)) neq 0>#Form.PMsecuencia#</cfif>">	
	<input type="hidden" name="CILtipoCicloDuracion" id="CILtipoCicloDuracion" value="<cfif isdefined("form.CILtipoCicloDuracion") and len(trim(form.CILtipoCicloDuracion)) neq 0>#Form.CILtipoCicloDuracion#</cfif>">		

	<input type="hidden" name="Maxfinal" id="Maxfinal" value="<cfif isdefined("rsFechaMax.PEfinal") and len(trim(rsFechaMax.PEfinal)) neq 0>#rsFechaMax.PEfinal#</cfif>">	
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
				 Periodo de Matrícula </font>
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
        <td height="27" align="right" class="fileLabel">Ciclo Lectivo:      
        <td colspan="2" class="cajasinbordeb"><cfoutput>#rsPeriodoEvaluacion.PLnombre#</cfoutput></td>
      </tr> 
     <cfif isdefined("rsCicloLectivo") and rsCicloLectivo.CILtipoCicloDuracion EQ 'E'>
		  <tr>
			
          <td align="right"  nowrap class="fileLabel">Per&iacute;odo 
            de Evaluacion: 
          <td colspan="2" class="cajasinbordeb"><cfif modo NEQ 'ALTA'><cfoutput>#rsForm.PEnombre#</cfoutput><cfelse><cfoutput>#rsPeriodoEvaluacion.PEnombre#</cfoutput></cfif></td>
		  </tr>
	 </cfif>
      <tr>
        <td align="right" class="fileLabel">Tipo de Matr&iacute;cula:     
        <td colspan="2"><select name="PMtipo" id="PMtipo" tabindex="1">
          <option value="1" <cfif modo NEQ 'ALTA' and #rsForm.PMtipo# EQ '1'>selected</cfif>>Ordinario</option>
          <option value="2" <cfif modo NEQ 'ALTA' and #rsForm.PMtipo# EQ '2'>selected</cfif>>Extraordinario</option>
          <option value="3" <cfif modo NEQ 'ALTA' and #rsForm.PMtipo# EQ '3'>selected</cfif>>Retiro Justificado
	      <option value="4" <cfif modo NEQ 'ALTA' and #rsForm.PMtipo# EQ '4'>selected</cfif>>Retiro Injustificado</option>
        </select></td>
      </tr>
      <tr>
        <td align="right" class="fileLabel">Fecha  Inicial:
        <td colspan="2">
			<cfif modo eq "ALTA">
				<!--- <cfset fechaini = LSdateformat(Now(),"dd/mm/yyyy")>
				<cfset fechafin = LSdateformat(Now(),"dd/mm/yyyy")> --->
				<cfset fechaini = "">
				<cfset fechafin = "">
			<cfelse>
				<cfset fechaini = rsForm.PMinicio>
				<cfset fechafin = rsForm.PMfinal>
				 <!---  ts_rversion --->
				  <cfset ts = ""> 
				
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
			</cfif>
			<cf_sifcalendario name="PMinicio" value="#fechaini#" form="formPeriodosMatricula"> </td>
      </tr>
      <tr>
        <td align="right" class="fileLabel">Fecha Final:      
        <td colspan="2">
			<cf_sifcalendario name="PMfinal" value="#fechafin#" form="formPeriodosMatricula">
		</td>
      </tr>
      <tr>
        <td align="center" colspan="2">
          <cfset mensajeDelete = "¿Desea Eliminar este periodo de Matrícula?">
         <cfinclude template="/educ/portlets/pBotones.cfm"> 
		 <!---   <input name="Cambio" type="submit" onSelect="javascript: alert(select);" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); " value="Modificar">
      --->  </td> 
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
		//objForm.PEnombre.required = false;
		objForm.PMinicio.required = false;
		objForm.PMfinal.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		//objForm.PEnombre.required = true;
		objForm.PMinicio.required = true;
		objForm.PMfinal.required = true;
	}
//---------------------------------------------------------------------------------------	
	function __isFechaValida() {
	  if (this.required) {
	   var a = this.obj.form.PMinicio.value.split("/");
	   var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
	   var b = this.obj.form.PMfinal.value.split("/");
	   var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
	   var c = this.obj.form.Maxfinal.value.split("/");
	   var Maxfin = new Date(parseInt(c[2], 10), parseInt(c[1], 10)-1, parseInt(c[0], 10));
	   
		if (ini > fin) {
			this.error = "La fecha inicial no puede ser mayor o igual a  la fecha final.";
		}
		if (ini > Maxfin) {
			this.error = "La fecha inicial no puede ser mayor que " +  this.obj.form.Maxfinal.value;
		}
		if (fin > Maxfin) {
			this.error = "La fecha Final no puede ser mayor que " +  this.obj.form.Maxfinal.value;
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
	
	objForm = new qForm("formPeriodosMatricula");
//---------------------------------------------------------------------------------------
//	objForm.PEnombre.required = true;
//	objForm.PEnombre.description = "Nombre del Periodo de Evaluación";
	objForm.PMinicio.required = true;
	objForm.PMinicio.description = "Fecha Inicial";
	objForm.PMinicio.validateFechaValida();
	objForm.PMfinal.required = true;
	objForm.PMfinal.description = "Fecha Final";
		
/*	<cfif modo NEQ "ALTA">
		objForm.PEnombre.validateTieneDependencias();
	</cfif>	*/
</script>