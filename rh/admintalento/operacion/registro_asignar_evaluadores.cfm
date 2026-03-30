<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Evaluador" default="Evaluador" returnvariable="LB_Evaluador"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Agregar" default="Agregar" returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Siguiente" default="Siguiente" returnvariable="BTN_Siguiente"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Regresar" default="Regresar" returnvariable="BTN_Regresar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CMB_Jefe" default="Jefe" returnvariable="CMB_Jefe"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CMB_Subordinado" default="Subordinado" returnvariable="CMB_Subordinado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CMB_Companero" default="Compañero" returnvariable="CMB_Companero"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="CMB_JefeAlterno" default="Jefe Alterno" returnvariable="CMB_JefeAlterno"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Autoevaluacion" default="Autoevaluaci&oacute;n" returnvariable="LB_Autoevaluacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NoSeEncontraronRegistros" default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_EstaSeguroQueDeseaEliminarElEvaluador" default="Esta seguro que desea eliminar el evaluador" returnvariable="MSG_EliminarEvaluador"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoHaSeleccionadoLaRelacion" default="No ha seleccionado la relaci&oacute;n" returnvariable="MSG_NoHaSeleccionadoLaRelacion"/>

<cfif isdefined("form.RHRSid") and len(trim(form.RHRSid)) and form.RHRSid NEQ -1>
	<cfquery name="rsEmpleado" datasource="#session.DSN#">
		select DEid , RHEid
		from RHEvaluados 
		where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
	</cfquery>
	<cfset form.DEid = rsEmpleado.DEid>
	<cfquery name="rsLista" datasource="#session.DSN#">
		select 	'#form.RHRSid#' as RHRSid
				,a.RHEVid
				,a.DEid
				,a.RHEVtipo
				,case a.RHEVtipo when 'J' then '#CMB_Jefe#'
								when 'S' then '#CMB_Subordinado#'
								when 'C' then '#CMB_Companero#'
								when 'E' then '#CMB_JefeAlterno#'
								when 'A' then  '#LB_Autoevaluacion#'
				end as Tipo
				,<cf_dbfunction name="concat" args="b.DEidentificacion,' - ',b.DEapellido1 ,' ',b.DEapellido2,' ',b.DEnombre"> as Evaluador
				,{fn concat('<a href=''javascript: funcBorrar(',{fn concat(<cf_dbfunction name="to_char" args="a.RHEVid"> ,');''><img src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>')})} as Borrar
		from RHEvaluadores a 
			inner join DatosEmpleado b
				on a.DEid = b.DEid
		where a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.RHEid#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfquery dbtype="query" name="rsJefe">
		select * from rsLista
		where RHEVtipo in ('J' ,'E')
	</cfquery>
	
	<!---Antes de eliminar el evaluador verificar que NO se hayan generado instancias----->
	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select 1
		from RHDRelacionSeguimiento
		where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
	</cfquery>


	<cfoutput>	
		<table width="95%" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td><cfinclude template="/rh/portlets/pEmpleado.cfm"></td>
			</tr>
			<!----Agregar evaluadores---->
			<tr>
				<td>
					<form name="formpaso2" method="post" action="registro_evaluadores_sql.cfm">
					<table width="95%" cellpadding="2" cellspacing="0">
						<tr>
							<td width="19%" align="right"><b>#LB_Evaluador#:</b>&nbsp;</td>
							<td width="81%">
								<cf_rhempleado tabindex="1" size="20" form="formpaso2">
							</td>
						</tr>
						<tr>
							<td align="right"><b>#LB_Tipo#:</b>&nbsp;</td>
							<td>
								<select name="RHEVtipo" tabindex="2">
									<cfif rsJefe.RecordCount eq 0>
										<option value="J">#CMB_Jefe#</option>
										<option value="E">#CMB_JefeAlterno#</option>									
									</cfif>
									<option value="S">#CMB_Subordinado#</option>									
									<option value="C"><cf_translate key="CMB_Companero">Compañero</cf_translate></option>									
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								<table cellpadding="5" cellspacing="0" align="center">
									<tr>
										<td><input type="button" name="btnRegresar" class="btnAnterior" value="#BTN_Regresar#" onClick="javascript: funcAnterior();"></td>
										<td ><input type="submit" name="btnAgregar" value="#BTN_Agregar#" class="btnGuardar"></td>
										<td><input type="button" name="btnSiguiente" class="btnSiguiente" value="#BTN_Siguiente#" onClick="javascript: funcSiguiente();"></td>
									</tr>
								</table>
								
							</td>
						</tr>
					</table>
					<input type="hidden" name="RHEid" value="#rsEmpleado.RHEid#">
					<input type="hidden" name="RHRSid" value="#form.RHRSid#">
					<input type="hidden" name="SEL" value="">
				</form>	
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>		
			<!----Lista de evaluadores---->
			<tr><td align="center"><strong style="font-size:13px;"><cf_translate key="LB_EvaluadoresAsignados">Evaluadores Asignados</cf_translate></strong></td></tr>	
			<tr>
				<td>				
					<cfinvoke component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfif rsVerifica.RecordCount EQ 0>
							<cfinvokeargument name="desplegar" value="Evaluador, Tipo, Borrar"/>						
							<cfinvokeargument name="etiquetas" value="#LB_Evaluador#, #LB_Tipo#, &nbsp;"/>
							<cfinvokeargument name="formatos" value="S,S,V"/>
							<cfinvokeargument name="align" value="left,left,left"/>
						<cfelse>
							<cfinvokeargument name="desplegar" value="Evaluador, Tipo"/>						
							<cfinvokeargument name="etiquetas" value="#LB_Evaluador#, #LB_Tipo#"/>
							<cfinvokeargument name="formatos" value="S,S"/>
							<cfinvokeargument name="align" value="left,left"/>
						</cfif>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="EmptyListMsg" value="---#LB_NoSeEncontraronRegistros#---"/>
						<cfinvokeargument name="maxRows" value="30"/>												
						<cfinvokeargument name="showLink" value="false"/>
						<cfinvokeargument name="irA" value="registro_evaluadores_sql.cfm"/>
						<!---<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="incluyeForm" value="false"/>	
						<cfinvokeargument name="formName" value="formpaso2"/>---->	
					</cfinvoke>
				</td>
			</tr>			
		</table>		
	<cf_qforms form='formpaso2'>		
		<cf_qformsrequiredfield args="DEid, #LB_Evaluador#">
	</cf_qforms>
	<script type="text/javascript" language="javascript1.3">
		function funcBorrar(prn_llave){
			if(confirm('#MSG_EliminarEvaluador#')){
				/*document.formpaso2.RHEVid.value = prn_llave;
				document.formpaso2.submit();*/
				document.lista.RHEVID.value=prn_llave;
				document.lista.RHRSID.value='#form.RHRSid#';
				document.lista.submit();
			}
		}
		function funcSiguiente(){
			location.href = 'registro_evaluacion.cfm?SEL=4&RHRSid=#form.RHRSid#';
		}
		function funcAnterior(){
			location.href = 'registro_evaluacion.cfm?SEL=2&RHRSid=#form.RHRSid#';
		}
	</script>
	</cfoutput>
<cfelse>
	<cfoutput><p><b>---#MSG_NoHaSeleccionadoLaRelacion#---</b></p></cfoutput>
</cfif>
