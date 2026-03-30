<cfinvoke component="sif.Componentes.Translate"	method="Translate" key="LB_ListaDeGruposDeNivelesDeEvaluacion" default="Lista de Grupos de Niveles de Evaluaci&oacute;n" returnvariable="ListaGruposNivel"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Codigo" default="C&oacute;digo" xmlfile="/rh/generales.xml" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Competencia" default="Competencias" returnvariable="LB_Competencia"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Objetivo" default="Objetivo" returnvariable="LB_Objetivo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Inicia" default="Inicia" returnvariable="LB_Inicia"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Finaliza" default="Finaliza" returnvariable="LB_Finaliza"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_GenerarEvaluacionesCada" default="Generar evaluaciones cada" returnvariable="LB_FrecuenciaCada"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CantidadDeEvaluaciones" default="Cantidad de Evaluaciones" returnvariable="LB_CantidadDeEvaluaciones"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DiasHabil" default="Dias que permanecera abierta la evaluacion" returnvariable="MSG_DiasHabil"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_Descripcion" default="Descripcion" returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_EmpleadoAEvaluar" default="Empleado a Evaluar" returnvariable="LB_EmpleadoAEvaluar"/>
		
<cfset va_arraGruposNivel=ArrayNew(1)>
<cfif isdefined("form.RHRSid") and len(trim(form.RHRSid)) and form.RHRSid NEQ -1>
	<cfset Form.modo='CAMBIO'>	
	<cfquery name="rsForm" datasource="#session.DSN#">
		select a.RHRSdescripcion, a.RHRStipo, a.RHRSinicio, a.RHRSfin,
			a.RHRStipofrecuencia, a.RHRSfrecuencia, a.RHRScantidad,
			a.RHRSdiashabil, a.RHRS360, a.RHGNid, a.RHRSestado, a.RHRSid,
			case a.RHRStipo when 'C' then '#LB_Competencia#' else '#LB_Objetivo#' end as DescTipo,
			b.DEid
		from RHRelacionSeguimiento a
			inner join RHEvaluados b
				on a.RHRSid = b.RHRSid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
	</cfquery>
	<!---Empleado a evaluar---->
	<cfif rsForm.RecordCount NEQ 0 and len(trim(rsForm.DEid))>
		<cfquery name="rsQuery" datasource="#session.DSN#">
			 select a.NTIcodigo, 
					a.DEid, 
					a.DEidentificacion, 
					<cf_dbfunction name="concat" args="a.DEapellido1 ,' ',a.DEapellido2,' ',a.DEnombre"> as NombreEmp
			from DatosEmpleado a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.DEid#">
		</cfquery>
	</cfif>
	<!----Grupos de nivel (si es objetivo)---->
	<cfif rsForm.RecordCount NEQ 0 and len(trim(rsForm.RHGNid))>
		<cfquery name="rsGrupo" datasource="#session.DSN#">
			select RHGNid, RHGNcodigo, RHGNdescripcion
			from RHGrupoNivel
			where RHGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.RHGNid#">
		</cfquery>
		<cfif rsGrupo.RecordCount NEQ 0>
			<cfset ArrayAppend(va_arraGruposNivel, rsGrupo.RHGNid)>
			<cfset ArrayAppend(va_arraGruposNivel, rsGrupo.RHGNcodigo)>
			<cfset ArrayAppend(va_arraGruposNivel, rsGrupo.RHGNdescripcion)>
		</cfif>		
	</cfif>	
</cfif>

<cfoutput>
<form name="formpaso1"﻿ action="registro_evaluacion_sql.cfm" method="post" onsubmit="javascript: habilitar();">
	<table width="98%" cellpadding="2" cellspacing="0" align="center">
		<tr><td>&nbsp;</td></tr>

		<tr><td width="25%">&nbsp;</td>
			<td width="15%" align="left" valign="top"><b>#LB_Descripcion#:</b>&nbsp;</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td width="85%">
				<textarea name="RHRSdescripcion" cols="65" rows="3" tabindex="1"><cfif modo NEQ 'ALTA'>#rsForm.RHRSdescripcion#</cfif></textarea>
			</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td align="left"><b><cf_translate key="LB_Tipo">Tipo</cf_translate>:</b>&nbsp;</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td>
				<cfif modo NEQ 'ALTA'>
					#rsForm.DescTipo#
				<cfelse>
					<select name="RHRStipo" onChange="javascript: funcCambioTipo(this.value);" tabindex="2">
						<option id="C" value="C" >#LB_Competencia#</option>
						<option id="O" value="O" >#LB_Objetivo#</option>
					</select>
				</cfif>
			</td>
		</tr>		<tr id="LBL_GrupoNivel" style="display:none;"><td width="25%">&nbsp;</td>
			<td align="left"  >
				<b><cf_translate key="LB_GrupoDeNivelesDeEvaluacion">Grupo de Niveles de Evaluaci&oacute;n</cf_translate>:</b>&nbsp;
			</td>
		</tr>		<tr id="CON_GrupoNivel" style="display:none;"><td width="25%">&nbsp;</td>
			<td  >
				<cf_conlis title="#ListaGruposNivel#"
					campos = "RHGNid,RHGNcodigo,RHGNdescripcion" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,10,20"
					asignar="RHGNid,RHGNcodigo,RHGNdescripcion"
					asignarformatos="I,S,S"
					tabla="	RHGrupoNivel a"																	
					columnas="RHGNid,RHGNcodigo,RHGNdescripcion"
					filtro="a.Ecodigo =#session.Ecodigo#"
					desplegar="RHGNcodigo,RHGNdescripcion"
					etiquetas="	#LB_Codigo#, 
								#LB_Descripcion#"
					formatos="S,S"
					align="left,left"
					showEmptyListMsg="true"
					debug="false"
					form="formpaso1"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="RHGNcodigo,RHGNdescripcion"
					valuesarray="#va_arraGruposNivel#">
			</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td align="left"><b>#LB_EmpleadoAEvaluar#:</b>&nbsp;</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td>
				<cfif modo NEQ 'ALTA'>
					#rsQuery.DEidentificacion# - #rsQuery.nombreemp#
					<input type="hidden" name="DEid" value="#rsQuery.DEid#" />
				<cfelse>
					<cf_rhempleado tabindex="11" size="45" form="formpaso1">
				</cfif>				
			</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td align="left"><b>#LB_Inicia#:</b>&nbsp;</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td>
				<cfif modo neq 'AlTA' and isdefined("rsForm.RHRSinicio") and len(trim(rsForm.RHRSinicio))>
					<cf_sifcalendario name="RHRSinicio" value="#LSDateFormat(rsForm.RHRSinicio,'dd/mm/yyyy')#" tabindex="4" form="formpaso1">
					<input type="hidden" name="RHRSinicio_BD" value="#LSDateFormat(rsForm.RHRSinicio,'dd/mm/yyyy')#"  />
				<cfelse>
					<cf_sifcalendario name="RHRSinicio" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="4" form="formpaso1">
				</cfif>
			</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td align="left"><b>#LB_Finaliza#:</b>&nbsp;</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td>
				<cfif modo neq 'AlTA' and isdefined("rsForm.RHRSfin") and len(trim(rsForm.RHRSfin))>
					<cf_sifcalendario name="RHRSfin" tabindex="5" value="#LSDateFormat(rsForm.RHRSfin,'dd/mm/yyyy')#" form="formpaso1">
					<input type="hidden" name="RHRSfin_BD" value="#LSDateFormat(rsForm.RHRSfin,'dd/mm/yyyy')#"  />					
				<cfelse>
					<cf_sifcalendario name="RHRSfin" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="5" form="formpaso1">
				</cfif>
			</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td align="left"><b>#LB_FrecuenciaCada#:</b>&nbsp;</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td>
				<input name="RHRSfrecuencia"  value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsForm.RHRSfrecuencia, 'none')#<cfelse>1</cfif>" type="text" size="5" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,0);"  onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;"  tabindex="6">
				&nbsp;
				<select name="RHRStipofrecuencia" id="RHRStipofrecuencia" tabindex="7">
					<option id="D" <cfif modo NEQ 'ALTA' and rsForm.RHRStipofrecuencia EQ 'D'>selected</cfif>><cf_translate key="LB_Dias">D&iacute;as</cf_translate></option>
					<option id="S" <cfif modo NEQ 'ALTA' and rsForm.RHRStipofrecuencia EQ 'S'>selected</cfif>><cf_translate key="LB_Semanas">Semanas</cf_translate></option>
					<option id="M" <cfif modo NEQ 'ALTA' and rsForm.RHRStipofrecuencia EQ 'M'>selected</cfif>><cf_translate key="LB_Meses">Meses</cf_translate></option>
					<option id="A" <cfif modo NEQ 'ALTA' and rsForm.RHRStipofrecuencia EQ 'A'>selected</cfif>><cf_translate key="LB_Annos">A&ntilde;os</cf_translate></option>
				</select>
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="RHRSfrecuencia_BD" value="#LSCurrencyFormat(rsForm.RHRSfrecuencia, 'none')#" />
					<input type="hidden" name="RHRStipofrecuencia_BD" value="#rsForm.RHRStipofrecuencia#" />
				</cfif>
			</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td align="left"><b>#LB_CantidadDeEvaluaciones#:</b>&nbsp;</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td>
				<input name="RHRScantidad" value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsForm.RHRScantidad, 'none')#<cfelse>1</cfif>" type="text" size="5" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,0);"  onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;"  tabindex="8">
			</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td align="left" nowrap><b><cf_translate key="LB_DiasHabil">D&iacute;as que permanecer&aacute; abierta la evaluaci&oacute;n</cf_translate>:</b>&nbsp;</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td>
				<input name="RHRSdiashabil" value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsForm.RHRSdiashabil, 'none')#<cfelse>1</cfif>" type="text" size="5" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,0);"  onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;"  tabindex="9">
			</td>
		</tr>		<tr><td width="25%">&nbsp;</td>
			<td>
				<table width="1%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%"><input <cfif modo neq 'ALTA'>disabled="disabled"</cfif> name="RHRS360" type="checkbox" <cfif modo NEQ "ALTA" and rsForm.RHRS360 EQ 1>checked</cfif> tabindex="10"></td>
						<td nowrap="nowrap"><b><cf_translate key="LB_Evaluacion360">Evaluaci&oacute;n 360</cf_translate></b></td>
					</tr>
				</table>				
			</td>
		</tr>		
		<tr><td>&nbsp;</td>
		</tr>		
		<tr>
			<td colspan="3" align="center">
				<cfif modo NEQ 'ALTA' <!---and rsForm.RHRSestado NEQ 20 ---> >
					<cf_botones modo="#modo#" include="Siguiente,Regresar">
				<cfelse>
					<cf_botones modo="#modo#" include="Regresar" exclude="Baja">
				</cfif>
			</td>	
		</tr>
		<input type="hidden" name="RHRSid" value="<cfif modo NEQ 'ALTA'>#rsform.RHRSid#</cfif>">
		<input type="hidden" name="SEL" value="">
	</table>
</form>
</cfoutput>
<cf_qforms form='formpaso1'>
	<cf_qformsrequiredfield args="RHRSdescripcion, #MSG_Descripcion#">
	<cf_qformsrequiredfield args="RHRSinicio, #LB_Inicia#">
	<cf_qformsrequiredfield args="RHRSfin, #LB_Finaliza#">
	<cf_qformsrequiredfield args="RHRSfrecuencia, #LB_FrecuenciaCada#">
	<cf_qformsrequiredfield args="RHRScantidad, #LB_CantidadDeEvaluaciones#">
	<cf_qformsrequiredfield args="RHRSdiashabil, #MSG_DiasHabil#">
	<cf_qformsrequiredfield args="DEid, #LB_EmpleadoAEvaluar#">
</cf_qforms>
<script type="text/javascript" language="javascript1.3">
	function funcCambioTipo(prn_sel){
		if(prn_sel == 'O'){
			document.getElementById("LBL_GrupoNivel").style.display = '';
			document.getElementById("CON_GrupoNivel").style.display = '';
		}
		else{
			document.getElementById("LBL_GrupoNivel").style.display = 'none';
			document.getElementById("CON_GrupoNivel").style.display = 'none';		
		}
	}
	function funcSiguiente(){
		document.formpaso1.SEL.value = "2";
		document.formpaso1.action = "registro_evaluacion.cfm";
		return true;
	}
	function funcRegresar(){
		location.href = 'registro_evaluacion.cfm';
	}
	function habilitar(){
		document.formpaso1.RHRS360.disabled = false;
	}
</script>