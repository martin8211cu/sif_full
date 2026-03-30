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
<cfquery datasource="#Session.DSN#" name="rsCicloLectivo">	
	select 
		convert(varchar,m.CILcodigo) as CILcodigo
		, Mtipo			
		, MtipoCicloDuracion
		, convert(varchar,m.TRcodigo) as TRcodigo
		, convert(varchar,m.PEVcodigo) as PEVcodigo
		, MtipoCalificacion
		, convert(varchar,MpuntosMax) as MpuntosMax
		, convert(varchar,MunidadMin) as MunidadMin
		, Mredondeo
		, convert(varchar,m.TEcodigo) as TEcodigo
		, rtrim(ltrim(CILnombre)) as CILnombre
		, rtrim(ltrim(CILcicloLectivo)) as CILcicloLectivo
		, m.TTcodigoCurso
		, m.ts_rversion
	from Materia m
		, CicloLectivo cl
	where m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		and m.Ecodigo=cl.Ecodigo
		and m.CILcodigo=cl.CILcodigo
</cfquery>
	
<cfquery datasource="#Session.DSN#" name="rsTarifasCurso">
	Select 	convert(varchar,TTcodigo) as TTcodigoCurso,
				TTnombre
	from TarifasTipo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
	and TTtipo = 2
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsTablaResultado">
	Select 	convert(varchar,TRcodigo) as TRcodigo,
				TRnombre,  ts_rversion
	from TablaResultado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsPlanEvaluacion">
	Select 	convert(varchar,PEVcodigo) as PEVcodigo,
				substring(PEVnombre,1,50) as PEVnombre,  ts_rversion
	from PlanEvaluacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsTablaEvaluacion">
	Select 	convert(varchar,TEcodigo) as TEcodigo,
				TEnombre, TEtipo, ts_rversion
	from TablaEvaluacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
</cfquery>


<cfif not isdefined('form.PEScodigo') or form.PEScodigo EQ ''>
	<cfinclude template="encMateria.cfm">
</cfif>

<link rel="stylesheet" type="text/css" href="/cfmx/educ/css/sif.css">
<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<form name="formParamMateria" method="post" action="materia_SQL.cfm" style="margin: 0">
	<cfoutput>
		<cfset ts = "">	
		<input type="hidden" name="Mcodigo" id="Mcodigo" value="#form.Mcodigo#">
			<cfinvoke component="educ.componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsCicloLectivo.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#" size="32"> 					
		<input type="hidden" name="CILcodigo" value="#rsCicloLectivo.CILcodigo#">						
		<input type="hidden" name="Mtipo" value="#rsCicloLectivo.Mtipo#">								
		<input type="hidden" name="T" value="<cfif isdefined('form.T') and form.T EQ 'M'>M<cfelse>E</cfif>">										
		<input type="hidden" name="tabsMateria" id="tabsMateria" value="#form.tabsMateria#">
		<input name="TabsPlan" id="TabsPlan" type="hidden" value="3">
		
			<!--- Parametros del mantenimiento de Materia Plan --->
			<cfif isdefined('form.CARcodigo') and form.CARcodigo NEQ ''>
				<input name="CARcodigo" type="hidden" value="#form.CARcodigo#">
			</cfif>
			<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
				<input name="PEScodigo" type="hidden" value="#form.PEScodigo#">
			</cfif>
			<cfif isdefined('form.PBLsecuencia') and form.PBLsecuencia NEQ ''>
				<input name="PBLsecuencia" type="hidden" value="#form.PBLsecuencia#">
			</cfif>
			<cfif isdefined('form.modo') and form.modo NEQ ''>
				<input name="modo" type="hidden" value="#form.modo#">  
				<input name="nivel" type="hidden" value="2">
			</cfif>
			 <!--- ********************************* --->		
		

		<table width="570" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="21%">&nbsp;</td>
		    <td width="1%">&nbsp;</td>
		    <td width="78%">&nbsp;</td>
		  </tr>		
		  <tr>
			<td width="21%" align="right"><strong>Los Cursos Duran:</strong></td>
		    <td width="1%">&nbsp;</td>
		    <td width="78%">
				<input type="hidden" name="MtipoCicloDuracion" value="#rsCicloLectivo.MtipoCicloDuracion#">
				<cfif rsCicloLectivo.MtipoCicloDuracion EQ 'E'>
					Solo un Periodo Evaluacion
				<cfelseif rsCicloLectivo.MtipoCicloDuracion EQ 'L'>
					Todo el Ciclo Lectivo			
				</cfif>
			</td>
		  </tr>		  		  		  		  		  
		  <tr>
			<td align="right" nowrap><strong>Aprobación del Curso:</strong></td>
		    <td>&nbsp;</td>
		    <td>
			<select name="TRcodigo" >
                <cfloop query="rsTablaResultado"> 
                  <option value="#rsTablaResultado.TRcodigo#" <cfif rsTablaResultado.TRcodigo EQ rsCicloLectivo.TRcodigo>selected</cfif>>#rsTablaResultado.TRnombre# 
                  </option>
                </cfloop> 
			  </select>
			</td>
		  </tr>		  
		  <tr>
			<td align="right"><strong>Plan de Evaluaci&oacute;n:</strong></td>
		    <td>&nbsp;</td>
		    <td>
			<select name="PEVcodigo" >
                <cfloop query="rsPlanEvaluacion"> 
                  <option value="#rsPlanEvaluacion.PEVcodigo#" <cfif rsPlanEvaluacion.PEVcodigo EQ rsCicloLectivo.PEVcodigo>selected</cfif>>#rsPlanEvaluacion.PEVnombre# 
                  </option>
                </cfloop> </select>
			</td>
		  </tr>		  
		  <tr>
			<td align="right"><strong>Tipo de Calificaci&oacute;n:</strong></td>
		    <td>&nbsp;</td>
		    <td><select name="MtipoCalificacion" id="MtipoCalificacion" tabindex="1" onChange="javascript: cambioTipoCalificacion(this);">
              <option value="1" <cfif #rsCicloLectivo.MtipoCalificacion# EQ 1>selected</cfif>>Porcentaje</option>
              <option value="2" <cfif #rsCicloLectivo.MtipoCalificacion# EQ 2>selected</cfif>>Puntaje</option>
              <option value="T" <cfif #rsCicloLectivo.MtipoCalificacion# EQ 'T'>selected</cfif>>Tabla de Evaluación</option>
            </select></td>
		  </tr>		  
		  <tr>
			<td align="right" height="40"></td>
		    <td>&nbsp;</td>
		    <td nowrap>
			  <div style="display: ; margin: 0; "  id="verTipoCalifica">Puntaje M&aacute;ximo 
                <input name="MpuntosMax" type="text" id="MpuntosMax" tabindex="3" size="6" maxlength="6"  value="#rsCicloLectivo.MpuntosMax#" style="text-align: right;" onBlur="javascript:fm(this,0); "  onFocus="javascript: this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
                Unidad M&iacute;nima 
                <input name="MunidadMin" type="text" id="MunidadMin" tabindex="3" size="6" maxlength="6"  value="#rsCicloLectivo.MunidadMin#" style="text-align: right;" onBlur="javascript:fm(this,2);"  onFocus="javascript: this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
                Redondeo
                <select name="Mredondeo" id="Mredondeo">
                  <option value="0" <cfif #rsCicloLectivo.Mredondeo# EQ 0>selected</cfif>>Al más cercano</option>
                  <option value="0.499" <cfif #rsCicloLectivo.Mredondeo# EQ 0.499>selected</cfif>>Hacia arriba</option>
                  <option value="-0.499" <cfif #rsCicloLectivo.Mredondeo# EQ -0.499>selected</cfif>>Hacia abajo</option>
                </select>
              </div>
              <div style="display: ; margin: 0;" id="verTablaEval"> Tabla de Evaluaci&oacute;n 
                <select name="TEcodigo" >
                  <cfloop query="rsTablaEvaluacion"> 
                    <option value="#rsTablaEvaluacion.TEcodigo#" <cfif rsTablaEvaluacion.TEcodigo EQ rsCicloLectivo.TEcodigo>selected</cfif>>#rsTablaEvaluacion.TEnombre# 
                    </option>
                  </cfloop> 
                </select>
              </div>			
			</td>
		  </tr>		  
          <tr> 
            <td align="left" nowrap><strong>Tipo Tarifa por Curso:</strong></td>
		    <td>&nbsp;</td>
            <td align="left" nowrap> 
				<select name="TTcodigoCurso" >
                  <cfloop query="rsTarifasCurso">
                    <option value="#rsTarifasCurso.TTcodigoCurso#" <cfif rsTarifasCurso.TTcodigoCurso EQ rsCicloLectivo.TTcodigoCurso>selected</cfif>>#rsTarifasCurso.TTnombre# 
                    </option>
                  </cfloop>
                </select>
			</td>
          </tr>
		  <tr>
			<td align="right">&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="3" align="center">
				<input name="CambioParam" type="submit" onSelect="javascript: alert(select);" value="Modificar">
				<input name="btnLista" type="button" id="btnLista" value="Ir a Lista" onClick="javascript: listaMaterias();">
			</td>
		  </tr>
		</table>
  </cfoutput>
</form>

<script language="JavaScript" type="text/javascript">
//---------------------------------------------------------------------------------------		
	function listaMaterias(){
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			document.formParamMateria.action="CarrerasPlanes.cfm";
			document.formParamMateria.modo.value='CAMBIO';
		<cfelse>
			document.formParamMateria.Mcodigo.value = '';
			document.formParamMateria.action="materia.cfm";		
		</cfif>	
	
		document.formParamMateria.submit();
	}
//---------------------------------------------------------------------------------------			
	function cambioTipoCalificacion(obj){
		var connverTipoCalifica = document.getElementById("verTipoCalifica");
		var connverTablaEval = document.getElementById("verTablaEval");
		
		if(obj.value == '1'){
			document.formParamMateria.MpuntosMax.value = 100;
			document.formParamMateria.MunidadMin.value = 0.01;
			document.formParamMateria.Mredondeo.value = "0";
		}
			
		if(obj.value == '2')
			connverTipoCalifica.style.display = "";
		else
			connverTipoCalifica.style.display = "none";
		if(obj.value == 'T')
			connverTablaEval.style.display = "";
		else
			connverTablaEval.style.display = "none";
	}
	
	var obj = document.getElementById("MtipoCalificacion");
	cambioTipoCalificacion(obj);	
</script>	