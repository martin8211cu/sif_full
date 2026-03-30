<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2724" default="0" returnvariable="LvarAprobarEducacion"/>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="BTN_Agregar" default="Agregar" xmlfile="/rh/generales.xml" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Limpiar" default="Limpiar" xmlfile="/rh/generales.xml" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Modificar" default="Modificar" xmlfile="/rh/generales.xml" returnvariable="BTN_Modificar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Eliminar" default="Eliminar" xmlfile="/rh/generales.xml" returnvariable="BTN_Eliminar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Nuevo" default="Nuevo" xmlfile="/rh/generales.xml" returnvariable="BTN_Nuevo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DeseaEliminarElRegistro" default="Desea eliminar el registro" returnvariable="MSG_DeseaEliminarElRegistro" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_MesDeInicio" default="Mes de inicio" returnvariable="LB_MesDeInicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_AnoDeInicio" default="Año de Inicio" returnvariable="LB_AnoDeInicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_MesDeFinalizacion" default="Mes de Finalización" returnvariable="LB_MesDeFinalizacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_AnoDeFinalizacion" default="Año de Finalización" returnvariable="LB_AnoDeFinalizacion" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_TituloObtenido" default="T&iacute;tulo obtenido" returnvariable="LB_TituloObtenido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_InstitucionEnQueEstudio" default="Instituci&oacute;n en que estudi&oacute;" returnvariable="LB_InstitucionEnQueEstudio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_OtraInstitucion" default="Otra instituci&oacute;n" returnvariable="LB_OtraInstitucion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaDeIngreso" default="Fecha de ingreso" returnvariable="LB_FechaDeIngreso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaDeFinalizacion" default="Fecha de finalizaci&oacute;n" returnvariable="LB_FechaDeFinalizacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NivelAlcanzado" default="Nivel alcanzado" returnvariable="LB_NivelAlcanzado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SinTerminar" default="Sin terminar" returnvariable="LB_SinTerminar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TituloObtenido" default="Título obtenido" returnvariable="LB_TituloObtenido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Enfasis" default="Énfasis" returnvariable="LB_Enfasis" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="LB_CapacitacionNoFormal" default="Capacitaci&oacute;n no formal" returnvariable="LB_CapacitacionNoFormal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_PendienteDeAprobar" default="Pendiente de Aprobar" returnvariable="LB_PendienteDeAprobar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Rechazada" default="Rechazada" returnvariable="LB_Rechazada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Observacion" default="Observación" returnvariable="LB_Observacion" component="sif.Componentes.Translate" method="Translate"/>


<!--- FIN VARIABLES DE TRADUCCION --->
	
<cfset modoEducacion = "ALTA">
<cfif isdefined("form.RHEElinea") and len(trim(form.RHEElinea))>
	<cfset modoEducacion = "CAMBIO">
</cfif>
<!--- Querys previos ---->
<cf_translatedata name="get" tabla="GradoAcademico" col="GAnombre" returnvariable="LvarGAnombre">
<cfquery name="rsGrados" datasource="#session.DSN#">
	select GAcodigo,#LvarGAnombre# as GAnombre,GAorden 
	from GradoAcademico
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by GAorden
</cfquery> 
<cf_dbfunction name="op_concat" returnvariable="concat">
<cf_dbfunction name="sPart"		args="RHIAnombre,1,50" returnvariable="vRHIAnombre">
<cfquery name="rsInstituciones" datasource="#session.DSN#">
	select RHIAid, case when <cf_dbfunction name="length"	args="RHIAnombre"> > 50 then #vRHIAnombre##concat#'...'  else RHIAnombre end as RHIAnombre
	from RHInstitucionesA
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	order by RHIAnombre
</cfquery>

<cfif modoEducacion neq 'ALTA'>
	<cf_translatedata name="get" tabla="RHOEnfasis" col="e.RHOEDescripcion" returnvariable="LvarRHOEDescripcion">
	<cfquery name="data" datasource="#session.DSN#">		
		select 	rh.RHEElinea, rh.RHIAid, rh.GAcodigo, rh.RHEotrains, rh.RHEtitulo,rh.RHOTid,
				rh.RHEfechaini, rh.RHEfechafin, rh.RHEsinterminar, rh.ts_rversion,rh.RHECapNoFormal,rh.RHEestado,
				e.RHOEid,#LvarRHOEDescripcion# as RHOEDescripcion, rh.RHEobservacion
		from RHEducacionEmpleado rh
			left join RHOEnfasis e
				on rh.RHOEid = e.RHOEid
		where rh.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				and rh.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
				and rh.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">	
			</cfif>	
			and rh.RHEElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEElinea#">
	</cfquery>
</cfif>

<cfoutput>
<cfif isDefined("LvarAuto")>
	<cfset Lvar_Accion = 'educacion-sql.cfm'>
<cfelseif isdefined('Lvar_EducAuto')>
	<cfset Lvar_Accion = '../capacitacion/expediente/educacion-sql.cfm'>
<cfelse>
	<cfset Lvar_Accion = '../../capacitacion/expediente/educacion-sql.cfm'>
</cfif>
<form name="formEducacion" action="#Lvar_Accion#" method="post">
	<input type="hidden" name="DEid" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">
	<input type="hidden" name="RHOid" value="<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>#form.RHOid#</cfif>">
	<input name="sel" type="hidden" value="1">
	<input type="hidden" name="o" value="3">		
	<cfif isdefined('Lvar_EducAuto')><input name="Lvar_EducAuto" type="hidden" value="#Lvar_EducAuto#"></cfif>
	<table width="100%" cellpadding="2" cellspacing="0">
    	<tr>
			<td width="20%" align="right"><strong>#LB_TituloObtenido#:&nbsp;</strong></td>
			<td width="32%">
				<cfset ArrayTIT=ArrayNew(1)>
				<cfif  modoEducacion neq 'ALTA' and isdefined("data.RHOTid") and len(trim(data.RHOTid))>
					<cfset ArrayAppend(ArrayTIT,data.RHOTid)>
					<cfset ArrayAppend(ArrayTIT,data.RHEtitulo)>
				</cfif>
				<cf_translatedata name="get" tabla="RHOTitulo" col="RHOTDescripcion" returnvariable="LvarRHOTDescripcion">
                <cfinvoke component="sif.Componentes.Translate"	method="Translate"
				Key="LB_ListaTitulosObtenidos" Default="Lista de Títulos Obtenidos" returnvariable="LB_ListaTitulosObtenidos"/>
				<cf_conlis
					Campos="RHOTid,RHOTDescripcion"
					Desplegables="N,S"
					Modificables="N,S"
					Size="0,50"
					tabindex="1"
					form="formEducacion"
					ValuesArray="#ArrayTIT#" 
					Title="#LB_ListaTitulosObtenidos#"
					Tabla="RHOTitulo"
					Columnas="RHOTid,#LvarRHOTDescripcion# as RHOTDescripcion"
					Filtro=" CEcodigo = #Session.CEcodigo# order by #LvarRHOTDescripcion#"
					Desplegar="RHOTDescripcion"
					Etiquetas="#LB_TituloObtenido#"
					filtrar_por="RHOTDescripcion"
					Formatos="S"
					Align="left"
					Asignar="RHOTid,RHOTDescripcion"
					translatedatacols="RHOTDescripcion"
					Asignarformatos="S,S"/>
			</td>
		</tr>
		<!---- enfasis----->
		<tr>
			<td width="20%" align="right"><strong>#LB_Enfasis#:&nbsp;</strong></td>
			<td width="32%">
				<cfset ArrayTIT=ArrayNew(1)>
				<cfif  modoEducacion neq 'ALTA' and isdefined("data.RHOEid") and len(trim(data.RHOEid))>
					<cfset ArrayAppend(ArrayTIT,data.RHOEid)>
					<cfset ArrayAppend(ArrayTIT,data.RHOEDescripcion)>
				</cfif>
                 <cfinvoke component="sif.Componentes.Translate"	method="Translate"
				Key="LB_ListaEnfasis" Default="Lista de Títulos Énfasis" returnvariable="LB_ListaEnfasis"/>
				<cf_translatedata name="get" tabla="RHOEnfasis" col="RHOEDescripcion" returnvariable="LvarRHOEDescripcion">

				<cf_conlis
					Campos="RHOEid,RHOEDescripcion"
					Desplegables="N,S"
					Modificables="N,S"
					Size="0,50"
					tabindex="1"
					form="formEducacion"
					ValuesArray="#ArrayTIT#" 
					Title="#LB_ListaEnfasis#"
					Tabla="RHOEnfasis"
					Columnas="RHOEid,#LvarRHOEDescripcion# as RHOEDescripcion"
					Filtro=" CEcodigo = #Session.CEcodigo#"
					Desplegar="RHOEDescripcion"
					Etiquetas="#LB_Enfasis#"
					filtrar_por="RHOEDescripcion"
					Formatos="S"
					Align="left"
					translatedatacols="RHOEDescripcion"
					Asignar="RHOEid,RHOEDescripcion"
					Asignarformatos="S,S"/>
			</td>
		</tr>
		<!----- fin del enfasis----->

      	<tr>
			<td align="right" nowrap><strong>#LB_InstitucionEnQueEstudio#:&nbsp;</strong></td>
        	<td>
				<select name="RHIAid" id="RHIAid" onchange="javascript: funcHabilitar();">
            		<option value="">(<cf_translate key="CMB_Otra">Otra</cf_translate>)</option>
            		<cfloop query="rsInstituciones">
              			<option value="#rsInstituciones.RHIAid#" <cfif modoEducacion NEQ 'ALTA' and rsInstituciones.RHIAid EQ data.RHIAid>selected</cfif>>#HTMLEditFormat(rsInstituciones.RHIAnombre)#</option>
           			</cfloop>
          		</select>
			</td>
      	</tr>
      	<tr>
			<td align="right"><strong>#LB_OtraInstitucion#:&nbsp;</strong></td>
			<td><input type="text" maxlength="60" size="50" name="RHEotrains" <cfif modoEducacion NEQ 'ALTA' and len(trim(data.RHIAid))>disabled</cfif>  value="<cfif modoEducacion neq 'ALTA'>#data.RHEotrains#</cfif>"></td>
      	</tr>
      	<tr>
			<td align="right"><strong>#LB_FechaDeIngreso#:</strong></td>
			<td>
				<table>
					<tr>
						<td>
							<cfset Lvar_MesIni = ''>
							<cfif modoEducacion NEQ 'ALTA' and isdefined("data.RHEfechaini") and len(trim(data.RHEfechaini))>
								<cfset Lvar_MesIni = month(data.RHEfechaini)>
							 </cfif>
							<cf_meses name="mesIni" value="#Lvar_MesIni#">
						</td>
						<td>&nbsp;</td>
						<td><!---<strong>&nbsp;A&ntilde;o&nbsp;</strong>---->
							<select name="anoIni" id="anoIni">
								<option value="">(<cf_translate key="LB_Anno">a&ntilde;o</cf_translate>)</option>
								<cfloop from="#year(now())#" to="#year(now())-50#" index="i" step="-1">
									<option value="#i#" <cfif modoEducacion NEQ 'ALTA' and isdefined("data.RHEfechaini") and len(trim(data.RHEfechaini)) and year(data.RHEfechaini) EQ i>selected</cfif>>#i#</option>
								</cfloop>
							</select>
						</td>
					</tr>
				</table>
			</td>
      	</tr>
	  	<tr>
			<td nowrap align="right"><strong>#LB_FechaDeFinalizacion#:</strong></td>
			<td width="32%">
				<table>
					<tr>
						<td>
							<cfset Lvar_MesFin = ''>
							<cfif modoEducacion NEQ 'ALTA' and isdefined("data.RHEfechafin") and len(trim(data.RHEfechafin))>
								<cfset Lvar_MesFin = month(data.RHEfechafin)>
							</cfif>
							<cf_meses name="mesFin" value="#Lvar_MesFin#">
						</td>
						<td>&nbsp;</td>
						<td><!---<strong>&nbsp;A&ntilde;o&nbsp;</strong>---->
							<select name="anoFin" id="anoFin">
								<option value="">(<cf_translate key="LB_Anno">a&ntilde;o</cf_translate>)</option>
								<cfloop from="#year(now())#" to="#year(now())-50#" index="i" step="-1">
									<option value="#i#" <cfif modoEducacion NEQ 'ALTA' and isdefined("data.RHEfechafin") and len(trim(data.RHEfechafin)) and year(data.RHEfechafin) EQ i>selected</cfif>>#i#</option>
								</cfloop>
							</select>              
						</td>
					</tr>
				</table>
			</td>
	  	</tr>
		<tr>
			<td align="right"><strong>#LB_NivelAlcanzado#:</strong></td>
			<td nowrap>
				<select name="GAcodigo" id="GAcodigo">
					<option value="">(<cf_translate key="CMB_SinDefinir">Sin definir</cf_translate>)</option>
					<cfloop query="rsGrados">
						<option value="#rsGrados.GAcodigo#" <cfif modoEducacion NEQ 'ALTA' and rsGrados.GAcodigo EQ data.GAcodigo>selected</cfif>>#HTMLEditFormat(rsGrados.GAnombre)#</option>
					</cfloop>
				</select>
				&nbsp; <input type="checkbox" name="RHEsinterminar" <cfif modoEducacion neq 'ALTA' and data.RHEsinterminar EQ 1>checked=""</cfif>><label><strong>#LB_SinTerminar#</strong></label>
			</td>
		</tr>
        <!---20140718 - ljimenez  se crea campo para observacion 255 caracteres (IICA)--->
        <tr>
        	<td align="right"><strong>#LB_Observacion#:</strong></td>
        	<td><textarea tabindex="1" name="RHEobservacion" cols="80" rows="4"><cfif modoEducacion NEQ 'ALTA'> #data.RHEobservacion #</cfif></textarea></td>
        </tr>
        
        
		<tr><td align="right"><strong>#LB_CapacitacionNoFormal#:&nbsp;</strong></td>
		<td>&nbsp;</td></tr>
		<tr>			
			<td colspan="2">
				<cfif modoEducacion neq 'ALTA'>
					<cf_rheditorhtml name="RHECapNoFormal" width="99%" height="200" value="#trim(data.RHECapNoFormal)#">
				<cfelse>
					<cf_rheditorhtml name="RHECapNoFormal" width="99%" height="200">
				</cfif>
			</td>
		</tr>
		<cfif modoEducacion NEQ 'ALTA' and  isdefined('Lvar_EducAuto')>
		<tr><td><strong><cfif data.RHEestado EQ 0>#LB_PendienteDeAprobar#<cfelseif data.RHEestado EQ 2>#LB_Rechazada#</cfif></strong></td></tr>
		</cfif>	  
      	<!--- Botones --->
      	<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td colspan="4" align="center">
				<cfif modoEducacion eq 'ALTA'>
					<input type="submit" name="Alta" value="#BTN_Agregar#" onclick="javascript: habilitarValidacion();">
					<input type="reset" name="Limpiar" value="#BTN_Limpiar#">
				<cfelse>
					<cfif not (isdefined('Lvar_EducAuto') and data.RHEestado eq 1 and LvarAprobarEducacion)>
						<input type="submit" name="Cambio" value="#BTN_Modificar#" onclick="habilitarValidacion();">
						<input type="submit" name="Baja" value="#BTN_Eliminar#" onclick="if ( confirm('#MSG_DeseaEliminarElRegistro#') ){deshabilitarValidacion(); return true;} return false;">
					<cfelse>
						<div class="alert alert-dismissable alert-info text-center">
						 <cf_Translate key="MSG_NoPuedeEditarEstarInformacionAprobacionPrevia" xmlFile="/rh/generales.xml">No puede editar esta información debido a una aprobación previa</cf_Translate>
						</div>	
					</cfif>							
					<input type="submit" name="Nuevo" value="#BTN_Nuevo#" onclick="deshabilitarValidacion();">
				</cfif>
			</td>
      	</tr>
      	<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<cfif modoEducacion neq 'ALTA'>
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="RHEElinea" value="#data.RHEElinea#">
		<input type="hidden" name="tab" value="4">
	</cfif>
</form>
</cfoutput>

<cf_qforms objForm="objForm4" form='formEducacion'>
	<cf_qformsrequiredfield args="mesIni, #LB_MesDeInicio#">
	<cf_qformsrequiredfield args="mesFin, #LB_MesDeFinalizacion#">
	<cf_qformsrequiredfield args="anoIni, #LB_AnoDeInicio#">
	<cf_qformsrequiredfield args="anoFin, #LB_AnoDeFinalizacion#">
</cf_qforms>
<!--- FUNCIONES Y DEMAS EN JAVASCRIPT ---->
<script language="JavaScript" type="text/javascript">	

	
	function habilitarValidacion(){
		objForm4.mesIni.required = true;
		objForm4.anoIni.required = true;
		if(document.formEducacion.RHEsinterminar.checked){
			objForm4.anoFin.required = false;
			objForm4.mesFin.required = false;
		} else {
			objForm4.anoFin.required = true;
			objForm4.mesFin.required = true;
		}
	}

	function deshabilitarValidacion(){
		objForm4.mesIni.required = false;
		objForm4.mesFin.required = false;
		objForm4.anoIni.required = false;
		objForm4.anoFin.required = false;
		<!--- objForm4.RHOTid.required = false; --->
	}
	
	function funcHabilitar(){
		if (document.formEducacion.RHIAid.value != ''){
			document.formEducacion.RHEotrains.disabled = true;
			document.formEducacion.RHEotrains.value = '';
		}
		else{
			document.formEducacion.RHEotrains.disabled = false;
		}
	}		
</script>

