<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio") and isdefined('form.Mcodigo') and form.Mcodigo NEQ ''>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif (form.modo EQ "CAMBIO" OR form.modo EQ "MPcambio") and isdefined('form.Mcodigo') and form.Mcodigo NEQ ''>
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
 	<cfquery name="rsForm" datasource="#session.DSN#">
		Select convert(varchar,Mcodigo) as Mcodigo
			, convert(varchar,CILcodigo) as CILcodigo
			, Mtipo
			, Mcodificacion
			, Mnombre
			, Mactivo
			, MobjetivoGeneral
			, MobjetivosEspecificos
			, Mobservaciones
			, Mcreditos
			, MhorasTeorica
			, MhorasEstudio
			, MhorasPractica
			, convert(varchar,EScodigo) as EScodigo
			, convert(varchar,GAcodigo) as GAcodigo
			, Mrequisitos
			, MotrasCarreras
			, McualquierCarrera
			, McursoLibre
			, ts_rversion
		from Materia
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	</cfquery> 	
	<cfquery datasource="#Session.DSN#" name="rsEsRequisito">
		select count(*) as cant from MateriaRequisito where McodigoRequisito  = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>	
	<cfquery datasource="#Session.DSN#" name="rsEsElegible">
		select count(*) as cant from MateriaElegible where McodigoElegible  = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsHayMateriaPlan">
		select count(*) as cant from MateriaPlan where Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsHayCurso">
		select count(*) as cant from Curso where Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsHayDocenteMateria">
		select count(*) as cant from DocenteMateria where Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
</cfif>

<cfquery name="rsPlanEval" datasource="#session.DSN#">
	Select convert(varchar,PEVcodigo) as PEVcodigo
		, convert(varchar(30),PEVnombre) + case when datalength(PEVnombre) > 30 then '...' end as PEVnombre
	from PlanEvaluacion
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by PEVnombre
</cfquery>

<cfquery name="qryCodificacion" datasource="#Session.DSN#">
	Select Mcodificacion
	from Materia
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">		
	order by Mcodificacion
</cfquery>

<cfquery name="qryGradoAcad" datasource="#Session.DSN#">
	Select convert(varchar, GAcodigo) as GAcodigo,GAnombre 
	from GradoAcademico
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">		
	order by GAorden, GAnombre
</cfquery>

<cfquery name="qryCicloLect" datasource="#Session.DSN#">
	Select 
		(convert(varchar,isnull(TRcodigo,-1)) + '~' +
		convert(varchar,isnull(PEVcodigo,-1)) + '~' +
		CILtipoCalificacion + '~' +
		convert(varchar,isnull(CILpuntosMax,-1)) + '~' +
		convert(varchar,isnull(CILunidadMin,-1)) + '~' +
		convert(varchar,CILredondeo) + '~' +
		convert(varchar,isnull(TEcodigo,-1)) + '~' +
		convert(varchar,CILcodigo)) as CILcodigo
		, CILnombre
	from CicloLectivo
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by CILnombre
</cfquery>

<cfinclude template="../../queries/qryEscuela.cfm">

<link rel="stylesheet" type="text/css" href="../../css/sif.css">
<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
<form name="formMaterias" method="post" action="materia_SQL.cfm" onSubmit="return validaCodificacion();" style="margin: 0">
	<cfoutput>
		<cfif modo neq 'ALTA'>
			<cfset ts = "">	
			<input type="hidden" name="Mcodigo" id="Mcodigo" value="#rsForm.Mcodigo#">
			<cfinvoke component="educ.componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#" size="32">					
			<input type="hidden" name="EsRequisito"  value="#rsEsRequisito.cant#">						
			<input type="hidden" name="EsElegible"  value="#rsEsElegible.cant#">
			<input type="hidden" name="HayMateriaPlan"  value="#rsHayMateriaPlan.cant#">
			<input type="hidden" name="HayCurso"  value="#rsHayCurso.cant#">
			<input type="hidden" name="HayDocenteMateria"  value="#rsHayDocenteMateria.cant#">
		</cfif>
		<input type="hidden" name="Mrequisitos" value="">
		<input type="hidden" name="TRcodigo" value="">
		<input type="hidden" name="PEVcodigo" value="">				
		<input type="hidden" name="MtipoCalificacion" value="">		
		<input type="hidden" name="MpuntosMax" value="">		
		<input type="hidden" name="MunidadMin" value="">		
		<input type="hidden" name="Mredondeo" value="">		
		<input type="hidden" name="TEcodigo" value="">
		<input type="hidden" name="CILcodigo" value="">						

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="38%" align="right"><strong>#session.parametros.Escuela#:</strong></td>
			<td width="2%">&nbsp;</td>
			<td width="60%"><select name="EScodigo" id="EScodigo" onChange="javascript: cambioEscuela(this);" tabindex="1">
              <cfloop query="rsEscuela">
                <option value="#rsEscuela.EScodigo#" <cfif modo NEQ 'ALTA' and rsForm.EScodigo EQ rsEscuela.EScodigo> selected</cfif>>#rsEscuela.ESnombre#</option>
              </cfloop>
            </select></td>
		  </tr>
		  <tr>
			<td align="right"><strong>Tipo:</strong></td>
			<td>&nbsp;</td>
			<td><strong>
			  <select name="Mtipo" id="Mtipo" tabindex="2" disabled> <!---  onChange="javascript: cambioTipo(this);" --->
                <option value="M" <cfif isdefined('form.T') and form.T EQ 'M'> selected</cfif>>Regular</option>
                <option value="E" <cfif isdefined('form.T') and form.T EQ 'E'> selected</cfif>>Electiva</option>
              </select>
			</strong></td>
		  </tr>
		  <tr>
			<td align="right"><strong>C&oacute;digo:</strong></td>
			<td>&nbsp;</td>
			<td><input name="Mcodificacion" type="text" id="Mcodificacion" tabindex="3" value="<cfif modo NEQ "ALTA">#rsForm.Mcodificacion#</cfif>" size="15" maxlength="15" alt="El c&oacute;digo de la materia"></td>
		  </tr>		  
		  <tr>
			<td align="right"><strong>Nombre:</strong></td>
			<td>&nbsp;</td>
			<td><input name="Mnombre" type="text" value="<cfif modo NEQ "ALTA">#rsForm.Mnombre#</cfif>" size="50" maxlength="50" tabindex="4" alt="La descripci&oacute;n del Nivel"></td>
		  </tr>
		  <tr>
			<td colspan="3" align="center">
PROGRAMA
			</td>
		  </tr>		  		  		  		  		  
		</table>
  </cfoutput>
</form>
