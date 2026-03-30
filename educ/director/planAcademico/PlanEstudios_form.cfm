<!-- Establecimiento del modo -->
<cfparam name="form.PEScodigo" default="">
<cfif isdefined("form.PEScodigo") and form.PEScodigo NEQ ''>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif form.PEScodigo EQ "">
		<cfset modo="ALTA">
	<cfelseif isdefined("form.Cambio")>
		<cfset modo="CAMBIO">
	<cfelse>
		<cfif not isdefined("Form.modo")>
			<cfset modo="ALTA">
		<cfelseif form.modo EQ "CAMBIO">
			<cfset modo="CAMBIO">
		<cfelseif Find(form.modo,"MPalta*MPcambiar") gt 0>
			<cfset form.modo = "CAMBIO">
			<cfset modo="CAMBIO">
		<cfelse>
			<cfset modo="ALTA">
		</cfif>
	</cfif>
</cfif>

<!--- Consultas --->
<cfinclude template="../../queries/qryEscuela.cfm">
<cfquery name="rsEscuela" dbtype="query">
	select * from rsEscuela where EScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.EScodigo#">
</cfquery>

<cfquery name="rsCarrera" datasource="#Session.DSN#">
	select convert(varchar,a.CARcodigo) as CARcodigo, a.CARcodificacion, a.CARnombre
	from Carrera a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.CARcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CARcodigo#">
</cfquery>

<cfquery name="rsGradosAcademicos" datasource="#Session.DSN#">
	select convert(varchar,GAcodigo) as GAcodigo, GAnombre 
	from GradoAcademico
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by GAorden
</cfquery>

<cfquery name="rsCiclosLectivos" datasource="#Session.DSN#">
	select convert(varchar,CILcodigo) as CILcodigo, CILnombre
	from CicloLectivo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsSedes" datasource="#Session.DSN#">
	select distinct convert(varchar,b.Scodigo) as ScodigoSede, b.Snombre, convert(varchar,a.Scodigo) as ScodigoPlanSede 
	from PlanSede a, Sede b
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.Scodigo =* b.Scodigo
	<cfif isDefined("Form.PEScodigo") and Len(Trim(Form.PEScodigo)) GT 0>
	  and a.PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">
	</cfif>
	order by b.Sorden
</cfquery>

<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select convert(varchar,a.PEScodificacion) as PEScodificacion, convert(varchar,a.PEScodigo) as PEScodigo, 
			a.PESnombre, convert(varchar,a.CILcodigo) as CILcodigo, convert(varchar,a.GAcodigo) as GAcodigo, 
			a.PESestado, a.PESdesde, a.PEShasta, a.PESmaxima, 
			va.PEScodigo as PESversionAnterior, 
			vp.PEScodigo as PESversionPosterior, vp.PEShasta as PEShastaPosterior,
			a.ts_rversion
		from PlanEstudios a, PlanEstudios va, PlanEstudios vp
		where a.PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">
		  and a.CARcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CARcodigo#">
		  and va.PEScodigoSiguiente =* a.PEScodigo
		  and vp.PEScodigo =* a.PEScodigoSiguiente
	</cfquery>
		
	<cfquery name="rsCantAl" datasource="#Session.DSN#">
		Select count(*) as canAl
		from PlanEstudiosAlumno
		where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEScodigo#">
	</cfquery>
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(PEScodificacion) as PEScodificacion
	from PlanEstudios a, Carrera b
	where a.CARcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CARcodigo#">
	  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.CARcodigo = b.CARcodigo		
	<cfif modo neq 'ALTA'>
		and a.PEScodificacion <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.PEScodificacion#">
	</cfif>
</cfquery>

<cfif modo NEQ "ALTA">
	<cfquery name="rsPBL_MP" datasource="#session.DSN#">
		Select 	convert(varchar,pbl.PBLsecuencia) as PBLsecuencia, 
				pbl.PBLnombre,
				mp.MPcodigo,
				m.Mcodigo, 
				m.Mcodificacion, m.Mnombre, m.Mtipo, m.Mcreditos, isnull(ltrim(m.Mrequisitos),'--') as Mrequisitos
		from PlanEstudiosBloque pbl, MateriaPlan mp, Materia m
		where pbl.PEScodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
		  and pbl.PEScodigo    *= mp.PEScodigo
		  and pbl.PBLsecuencia *= mp.PBLsecuencia
		  and mp.Mcodigo       *= m.Mcodigo
		order by pbl.PBLsecuencia, mp.MPsecuencia
	</cfquery>
	<cfquery name="rsPBL" dbtype="query">
	  select count(1) as EnBlanco
		from rsPBL_MP
	   where MPcodigo is NULL
	</cfquery>
</cfif>

<cfif modo EQ 'ALTA'>
	<cfset PESstatus = "INACTIVO">
	<cfset LvarModificarBloques = true>
	<cfset LvarBtnActivarVersion = false>
	<cfset LvarbtnPESNuevaVersion = false>
	<cfset LvarBtnCerrarVersion = false>
<cfelseif rsForm.PESestado EQ 0>
	<cfset PESstatus = "INACTIVO">
	<cfset LvarModificarBloques = true>
	<cfset LvarBtnActivarVersion = true>
	<cfset LvarbtnPESNuevaVersion = false>
	<cfset LvarBtnCerrarVersion = false>
<cfelseif rsForm.PESestado EQ 2>
	<cfset PESstatus = "CERRADO">
	<cfset LvarModificarBloques = false>
	<cfset LvarBtnActivarVersion = true>
	<cfset LvarbtnPESNuevaVersion = false>
	<cfset LvarBtnCerrarVersion = false>
<cfelseif lsDateFormat(now(),"YYYYMMDD") LT lsDateFormat(rsForm.PESdesde,"YYYYMMDD")>
	<cfset PESstatus = "ESTARA VIGENTE A PARTIR DE #lsDateFormat(rsForm.PESdesde,"DD/MM/YYYY")#">
	<cfset LvarModificarBloques  = true>
	<cfset LvarBtnActivarVersion = false>
	<cfset LvarbtnPESNuevaVersion   = false>
	<cfset LvarBtnCerrarVersion  = true>
<cfelseif rsForm.PEShasta EQ "" or lsDateFormat(now(),"YYYYMMDD") LTE lsDateFormat(rsForm.PEShasta,"YYYYMMDD")>
	<cfif rsForm.PEShasta EQ "">
		<cfset PESstatus = "VIGENTE PARA ESTUDIANTES NUEVOS">
	<cfelse>
		<cfset PESstatus = "VIGENTE PARA ESTUDIANTES NUEVOS HASTA #lsDateFormat(rsForm.PEShasta,"DD/MM/YYYY")#">
	</cfif>
	<cfset LvarModificarBloques = false>
	<cfset LvarBtnActivarVersion = false>
	<cfset LvarbtnPESNuevaVersion = true>
	<cfset LvarBtnCerrarVersion  = true>
<cfelseif rsForm.PESmaxima EQ "" or lsDateFormat(now(),"YYYYMMDD") LTE lsDateFormat(rsForm.PESmaxima,"YYYYMMDD")>
	<cfif rsForm.PESmaxima EQ "">
		<cfset PESstatus = "VIGENTE PARA ESTUDIANTES ANTIGUOS">
	<cfelse>
		<cfset PESstatus = "VIGENTE PARA ESTUDIANTES ANTIGUOS HASTA #lsDateFormat(rsForm.PESmaxima,"DD/MM/YYYY")#">
	</cfif>
	<cfset LvarModificarBloques = false>
	<cfset LvarBtnActivarVersion = false>
	<cfset LvarbtnPESNuevaVersion = false>
	<cfset LvarBtnCerrarVersion  = true>
<cfelse>
	<cfset PESstatus = "OBSOLETO DESDE #lsDateFormat(rsForm.PESdesde,"DD/MM/YYYY")#">
	<cfset LvarModificarBloques = false>
	<cfset LvarBtnActivarVersion = false>
	<cfset LvarbtnPESNuevaVersion = false>
	<cfset LvarBtnCerrarVersion  = true>
</cfif>
<cfif modo neq "ALTA" and (rsPBL.EnBlanco GT 0 OR rsPBL_MP.recordCount EQ 0)>
	<cfset LvarBtnActivarVersion = false>
	<cfset PESstatus = PESstatus & " (PLAN INCOMPLETO)">
</cfif>
<cfif isdefined('rsForm') and rsForm.PESversionPosterior NEQ "">
	<cfset LvarbtnPESNuevaVersion = false>
</cfif>

<form name="formPlanEstudios" method="post" action="PlanEstudios_SQL.cfm" onSubmit="javascript: return validar();">
<cfoutput> 
	<input type="hidden" name="nivel" id="nivel" value="#Form.nivel#">
	<input type="hidden" name="EScodigo" id="EScodigo" value="#Form.EScodigo#">
    <table width="100%" border="0" cellspacing="1" cellpadding="1">
		<tr>
		  <td class="tituloMantenimiento" colspan="3" align="center">
		  	<font size="3">
				<cfif modo eq "ALTA">
					Nuevo Plan de Estudios
					  <cfelse>
					Modificar Plan de Estudios
				</cfif></font></td>
		</tr>
      <tr> 
        <td align="right" class="fileLabel">#session.parametros.Facultad#:</td>
        <td class="fileLabel">
			<cfif isdefined("rsEscuela")>
				#rsEscuela.ESfacultad#
			</cfif>
		</td>
        <td align="right" rowspan="2">
			<cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">
		</td>
      </tr>
      <tr> 
        <td align="right" class="fileLabel">#session.parametros.Escuela#:</td>
        <td class="fileLabel">
			<cfif isdefined("rsEscuela")>
				#rsEscuela.ESescuela#
			</cfif>
		</td>
      </tr>
      <tr> 
        <td width="26%" align="right" class="fileLabel">Carrera: 
          <input type="hidden" name="CARcodigo" value="#form.CARcodigo#"></td>
        <td class="fileLabel" colspan="2">#rsCarrera.CARnombre# (#rsCarrera.CARcodificacion#)</td>
      </tr>
      <tr> 
        <td align="right" class="fileLabel">C&oacute;digo de Plan: 
          <input type="hidden" name="PEScodigo" value="<cfif modo NEQ 'ALTA'>#Form.PEScodigo#</cfif>">           
        </td>
        <td colspan="2"><input type="text" name="PEScodificacion" <cfif modo NEQ 'ALTA'>disabled</cfif> value="<cfif modo NEQ 'ALTA'>#rsForm.PEScodificacion#</cfif>" size="15" maxlength="15"></td>
      </tr>
      <tr> 
        <td align="right" class="fileLabel">Nombre de Plan:</td>
        <td colspan="2"><select name="GAcodigo">
            <cfloop query="rsGradosAcademicos">
              <option value="#GAcodigo#" <cfif modo NEQ 'ALTA' and rsForm.GAcodigo EQ GAcodigo> selected </cfif>>#GAnombre# 
              en</option>
            </cfloop>
          </select> <input type="text" name="PESnombre" value="<cfif modo NEQ 'ALTA'>#rsForm.PESnombre#</cfif>" size="50" maxlength="50"></td>
      </tr>
      <tr> 
        <td align="right" class="fileLabel">Tipo Ciclo Lectivo:</td>
        <td colspan="2"> <select name="CILcodigo">
            <cfloop query="rsCiclosLectivos">
              <option value="#CILcodigo#" <cfif modo NEQ 'ALTA' and rsForm.CILcodigo EQ CILcodigo> selected </cfif>>#CILnombre#</option>
            </cfloop>
          </select> </td>
      </tr>
	  <tr> 
        <td align="right" class="fileLabel">Estado:</td>
        <td colspan="2"><strong>#PESstatus#</strong></td>
	  </tr>
      <cfif modo EQ 'ALTA'>
		  <tr> 
		    <td align="right" class="fileLabel">Vigente desde:</td>
		    <td colspan="2"><cf_sifcalendario name="PESdesde" form="formPlanEstudios"></td>
		  </tr>
      <cfelse>
		  <tr>
		    <td align="right" class="fileLabel">Vigencia:</td>
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" dwcopytype="CopyTableCell">
					<tr> 
					  <td width="20%" title="Fecha en que empieza a utilizarse el plan.">
							<strong>desde</strong><br>
					  </td>
					  <td>&nbsp;</td>
					  <td width="19%" title="Fecha en que se inactiva la versión actual y se activa la nueva versión.">
							<strong>hasta</strong><br>											  
					  </td>
					  <td>&nbsp;</td>
					  <td width="42%" title="Un alumno inscrito en un plan descontinuado, podrá continuar en dicho plan hasta la fecha máxima.">
							<strong>m&aacute;xima</strong><br>
					  </td>
				  </tr>
					<tr> 
					  <td width="20%" title="Fecha en que empieza a utilizarse el plan.">
						<cfif MODO EQ "ALTA">
							<cf_sifcalendario name="PESdesde" value="" form="formPlanEstudios" image=true>
						<cfelseif rsForm.PESversionAnterior EQ "">
							<cf_sifcalendario name="PESdesde" value="#lsDateFormat(rsForm.PESdesde,'DD/MM/YYYY')#" form="formPlanEstudios" image=true>
						<cfelse>
							<input type="text"  size="10" class="Cajasinbordeb" name="PESdesde" value="#lsDateFormat(rsForm.PESdesde,'DD/MM/YYYY')#" readonly>
						</cfif>
					  </td>
					  <td>&nbsp;</td>
					  <td width="19%" title="Fecha en que se inactiva la versión actual y se activa la nueva versión.">
						<cfif MODO EQ "ALTA">
							<cf_sifcalendario name="PEShasta" value="" form="formPlanEstudios" image=true>
						<cfelse>
							<cf_sifcalendario name="PEShasta" value="#lsDateFormat(rsForm.PEShasta,'DD/MM/YYYY')#" form="formPlanEstudios" image=true>
						</cfif>
					  </td>
					  <td>&nbsp;</td>
					  <td width="42%" title="Un alumno inscrito en un plan descontinuado, podrá continuar en dicho plan hasta la fecha máxima.">
					  	<cfif MODO NEQ "ALTA" AND rsForm.PEShasta NEQ "">
						  	<cf_sifcalendario name="PESmaxima" value="#lsDateFormat(rsForm.PESmaxima,'DD/MM/YYYY')#" form="formPlanEstudios" image=true>
						</cfif>
					  </td>
				  </tr>
				</table>
			</td>
		  </tr>
      </cfif>
      <tr id="sedes"> 
		<td>&nbsp;</td>
        <td>
		<fieldset style="width: 70%">
          <legend id="sedesLabel">Sedes</legend>
          <!--- checks --->
          <table width="50%" border="0" cellspacing="1" cellpadding="1">
            <cfif rsSedes.RecordCount GT 0>
              <cfloop query="rsSedes">
                <tr> 
                  <td class="fileLabel"><input type="checkbox" name="Scodigo" value="#ScodigoSede#" <cfif modo NEQ 'ALTA' and Len(Trim(ScodigoPlanSede)) GT 0> checked</cfif>> 
                    #Snombre#</td>
                </tr>
              </cfloop>
              <cfelse>
              <tr> 
                <td align="center" class="fileLabel">No hay sedes disponibles</td>
              </tr>
            </cfif>
          </table>
		</fieldset>
         </td>
		<td>&nbsp;</td>
      </tr>
      <tr> 
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr> 
        <td align="center" colspan="3">
		  <cfset mensajeDelete = "¿Desea Eliminar este Plan de Estudios?"> 
          <cfinclude template="../../portlets/pBotones.cfm">
			<input type="button" name="btnIrALista" value="Ir a Lista"
				onClick="javascript: this.form.botonSel.value = this.name; if (window.inhabilitarValidacion) inhabilitarValidacion(); irALista();">
          <!---  ts_rversion --->
          <cfset ts = ""> 
          <cfif modo NEQ "ALTA">
            
            <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts">
            </cfinvoke>
          </cfif> 
		  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
        </td>
      </tr>
      <tr> 
        <td colspan="3" align="center">
		  <cfif LvarBtnActivarVersion>
			&nbsp; 
			<input type="submit" name="btnPESActivar" value="Activar"
				onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion();">
		  </cfif> 
		  <cfif LvarbtnPESNuevaVersion> 
			&nbsp; <input type="submit" name="btnPESNuevaVersion" value="Nueva Version"
				onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion();">
		  </cfif>
		  <cfif LvarBtnCerrarVersion> 
			&nbsp; <input type="submit" name="btnPESInactivar" value="Inactivar"
				onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion();">
			&nbsp; <input type="submit" name="btnPESCerrar" value="Cerrar"
				onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion();">
		  </cfif>
		</td>
      </tr>
    </table>
</cfoutput>
</form>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/educ/js/utilesEduc.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formPlanEstudios");

	objForm.PEScodificacion.required = true;
	objForm.PEScodificacion.description="Código";
	objForm.PESnombre.required = true;
	objForm.PESnombre.description="Nombre";
	objForm.GAcodigo.required = true;
	objForm.GAcodigo.description = "Grado Académico"
	objForm.CILcodigo.required = true;
	objForm.CILcodigo.description = "Ciclo Lectivo"
	objForm.Scodigo.required = true;
	objForm.Scodigo.description = "Sede"
	objForm.PESdesde.required = true;
	objForm.PESdesde.description = "Vigente desde"

	function irALista(){
		location.href='/cfmx/educ/director/planAcademico/CarrerasPlanes.cfm';
	}
	
	function validar(){
		var varform = document.formPlanEstudios;
		document.formPlanEstudios.PEScodificacion.disabled = false;
		<cfoutput>
			<cfif isdefined('rsForm') and rsForm.PESversionPosterior NEQ "">
				if(varform.PEShasta.value == ""){
					alert('ERROR: exite una nueva version del plan de estudios, por tanto la fecha de vigencia "hasta" no puede quedar en blanco');
					return false;				
				}
				<cfif rsForm.PEShastaPosterior NEQ "">
					if(!comparaFechas(varform.PEShasta.value,"#lsDateFormat(rsForm.PEShastaPosterior,"DD/MM/YYYY")#",3)){
						alert('ERROR: exite una nueva version del plan de estudios, y la fecha de vigencia "hasta" debe ser menor que la fecha "hasta" de esa nueva version (#lsDateFormat(rsForm.PEShastaPosterior,"DD/MM/YYYY")#)');
						return false;				
					}
				</cfif>
			</cfif>
		</cfoutput>
		
		<cfif modo NEQ "ALTA">
		if(btnSelected('Alta',varform) || btnSelected('Cambio',varform))
		{
			if(varform.PEShasta.value != '' && !comparaFechas(varform.PESdesde.value,varform.PEShasta.value,3))
			{
				alert('ERROR: la fecha de vigencia "desde" debe ser menor que la fecha "hasta"');
				return false;				
			}		
			if(varform.PESmaxima && varform.PESmaxima.value != '')
			{
				if(varform.PEShasta.value == '')
				{
					alert('ERROR: la fecha de vigencia "máxima" sólo se puede digitar si existe fecha "hasta"');
					return false;				
				}
				if(!comparaFechas(varform.PEShasta.value,varform.PESmaxima.value,3)){
					alert('ERROR: la fecha de vigencia "desde" debe ser menor que la fecha "hasta"');
					return false;				
				}
			}
		}
		</cfif>
		if(btnSelected('btnPESNuevaVersion',varform)){
			if (varform.PEShasta.value == ''){
			  alert('ERROR: debe digitar la fecha de vigencia "hasta" para crear una <Nueva Version>');
			  return false;
			}
			if (!confirm('La nueva version será una copia de la versión actual \ncon una fecha de vigencia desde ' + varform.PEShasta.value + '\n\n¿Desea continuar?'))			  
				return false;	
		}
				
		return true;
	}
	
	function deshabilitarValidacion(){
		objForm.PEScodificacion.required = false;
		objForm.PESnombre.required = false;
		objForm.GAcodigo.required = false;		
		objForm.CILcodigo.required = false;
		<cfif modo EQ 'ALTA'>
		objForm.PESdesde.required = false;
		</cfif>
	}
	
	function codigos(obj){
		if (obj.value != "") {
			var dato    = obj.value;
			var temp    = new String();
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.PEScodificacion#</cfoutput>'
				if (dato == temp){
					alert('El Código del Plan de Estudios ya existe.');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}
		return true;
	}

	activa_desactiva();

	function activa_desactiva() 
	{
		var f = document.formPlanEstudios;				
		var tablaChecksSedes = document.getElementById('sedes');
		var labelChecksSedes = document.getElementById('sedesLabel');
	}	
  var GvarColor;
</script>
