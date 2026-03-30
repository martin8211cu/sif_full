<cfparam name="FORM.RHEEID" type="numeric">
<cfparam name="FORM.DEID" type="numeric" default="-1">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Autoevaluacion" default="Autoevaluación" returnvariable="LB_Autoevaluacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Jefe" default="Jefe" returnvariable="LB_Jefe"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Companero" default="Compañero" returnvariable="LB_Companero" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Subordinado" default="Colaborador" returnvariable="LB_Subordinado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_JefeAlterno" default="Jefe Alterno" returnvariable="LB_JefeAlterno" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="MSG_DeseaEliminarElEvaluadorDeLaListaDeEvaluadoresDeEsteEmpleado" default="¿Desea eliminar el evaluador de la lista de evaluadores de este empleado?" returnvariable="MSG_DeseaEliminarElEvaluadorDeLaListaDeEvaluadoresDeEsteEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Deseahabilitarestaevaluacionnuevamente" default="¿Desea habilitar esta evaluación nuevamente?" returnvariable="MSG_Deseahabilitarestaevaluacionnuevamente" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="MSG_EliminarHabilidadRequeridaParaEstePuesto" default="Eliminar habilidad requerida para este puesto." returnvariable="MSG_EliminarHabilidadRequeridaParaEstePuesto" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="BTN_Agregar" default="Agregar" xmlfile="/rh/generales.xml" returnvariable="BTN_Agregar" component="sif.Componentes.Translate"method="Translate"/>
<cfinvoke key="LB_EliminarElemento" default="Eliminar elemento" returnvariable="LB_EliminarElemento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_HabilitarElemento" default="Habilitar Evaluación" returnvariable="LB_HabilitarElemento" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="MSG_EsteEvaluadorYaEstaAgregadoALaListaDeEvaluadoresDeEsteEmpleadoNoPuedeAgregarloMasDeUnaVez" default="Este evaluador ya está agregado a la lista de evaluadores de este empleado, no puede agregarlo más de una vez.." returnvariable="MSG_EsteEvaluadorYaEstaAgregadoALaListaDeEvaluadoresDeEsteEmpleadoNoPuedeAgregarloMasDeUnaVez" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Evaluador" default="Evaluador" returnvariable="LB_Evaluador" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TipoDeEvaluador" default="Tipo de Evaluador" returnvariable="LB_TipoDeEvaluador" component="sif.Componentes.Translate" method="Translate"/>

<cfif (FORM.DEID gt 0)>
	<link href="STYLE.CSS" rel="stylesheet" type="text/css">
	<!--- Consultas --->
	<cfquery name="rsEvaluado" datasource="#session.dsn#">
		Select b.DEid, b.DEidentificacion, 
			{fn concat(b.DEapellido1,{fn concat(' ',{fn concat( b.DEapellido2,{fn concat(' ',b.DEnombre)})})})} as NombreEmp
		from DatosEmpleado b
		where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID#"> 
	</cfquery>	
	
    <cf_dbfunction name="to_char" args="a.RHEEid" returnvariable="vRHEEid">	
    <cf_dbfunction name="to_char" args="b.DEid" returnvariable="vDEid">		
    <cf_dbfunction name="OP_CONCAT"  returnvariable="concat">		
	<cfquery name="rsEvaluadoresLista" datasource="#session.dsn#">
		select 	a.Estado, 
				b.DEid, 
				b.DEidentificacion, 
				{fn concat(b.DEapellido1,{fn concat(' ',{fn concat( b.DEapellido2,{fn concat(' ',b.DEnombre)})})})} as NombreEmp, 
				a.RHEDtipo, 
				case a.RHEDtipo 	when 'A' then '#LB_Autoevaluacion#' 
												when 'J' then '#LB_Jefe#' 
												when 'S' then '#LB_Subordinado#' 
												when 'C' then '#LB_Companero#' 
												when 'E' then '#LB_JefeAlterno#' 
				end as RHEDtipodesc,
				case a.RHEDtipo 	when 'A' then 
                							'<a href="javascript: reporte(' #concat# #vRHEEid# #concat# ',' #concat# #vDEid# #concat# ',''A'');">
                                            	<img src=/cfmx/rh/imagenes/findsmall.gif border=0>
                                             </a>'
											when 'J' then 
                							'<a href="javascript: reporte(' #concat# #vRHEEid# #concat# ',' #concat# #vDEid# #concat# ',''J'');">
                                            	<img src=/cfmx/rh/imagenes/findsmall.gif border=0>
                                             </a>'
											when 'S' then 
                							'<a href="javascript: reporte(' #concat# #vRHEEid# #concat# ',' #concat# #vDEid# #concat# ',''S'');">
                                            	<img src=/cfmx/rh/imagenes/findsmall.gif border=0>
                                             </a>'                                       
											when 'C' then 
                							'<a href="javascript: reporte(' #concat# #vRHEEid# #concat# ',' #concat# #vDEid# #concat# ',''C'');">
                                            	<img src=/cfmx/rh/imagenes/findsmall.gif border=0>
                                             </a>'
											when 'E' then 
                							'<a href="javascript: reporte(' #concat# #vRHEEid# #concat# ',' #concat# #vDEid# #concat# ',''E'');">
                                            	<img src=/cfmx/rh/imagenes/findsmall.gif border=0>
                                             </a>'
			  end as imprimir
		from RHEvaluadoresDes a, DatosEmpleado b
		where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID#">
		and a.DEideval = b.DEid
		order by RHEDtipo
	</cfquery>

	<cfquery dbtype="query" name="rsJefe">
		select * from rsEvaluadoresLista
		where RHEDtipo in ('J' ,'E')
	</cfquery>
	
	<!--- Javascript --->
	<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
	<script src="/cfmx/sif/js/qForms/qforms.js"></script>
	<script language="JavaScript1.2" type="text/javascript">
	
		<!--//
		
		//**************************************QForms**************************************************
		
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");

		function funcAnterior(){
			document.form1.SEL.value = "3";
			document.form1.action = "registro_evaluacion.cfm";
			deshabilitarValidacion();
			return true;
		}
		function funcSiguiente(){
			document.form1.SEL.value = "5";
			document.form1.action = "registro_evaluacion.cfm";
			deshabilitarValidacion();
			return true;
		}
		function funcAgregar(){
			//habilitarValidacion();
		}
		function funcEliminar(id){
			if (confirm('<cfoutput>#MSG_DeseaEliminarElEvaluadorDeLaListaDeEvaluadoresDeEsteEmpleado#</cfoutput>')) {
				<cfoutput>
				window.location.href = "registro_criterios_evaluadores_sql.cfm?ELIMINAR&RHEEID=#FORM.RHEEID#&DEID=#FORM.DEID#&DEID1="+id;
				</cfoutput>
				return false;
			}
			return false;
		}
		
		
		function funcHabilitar(id){
			if (confirm('<cfoutput>#MSG_Deseahabilitarestaevaluacionnuevamente#</cfoutput>')) {
				<cfoutput>
				window.location.href = "registro_criterios_evaluadores_sql.cfm?HABILITAR&RHEEID=#FORM.RHEEID#&DEID=#FORM.DEID#&DEID1="+id;
				</cfoutput>
				return false;
			}
			return false;
		}
		
		
		function reporte(RHEEid,DEidotro,Cual){
		
			 var PARAM  = "/cfmx/rh/evaluaciondes/consultas/evaluacion-respuestas.cfm?Cual="+ Cual +"&RHEEid="+ RHEEid + "&DEid=<cfoutput>#form.DEId#</cfoutput>" + "&DEidotro=" +DEidotro
			open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')  
		} 
		//-->
	
	</script>
	<cfoutput>
	<form action="registro_criterios_evaluadores_sql.cfm" method="post" name="form1">
		<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="<cfoutput>#MSG_EliminarHabilidadRequeridaParaEstePuesto#</cfoutput>" style="display:none;">
		<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td rowspan="7">&nbsp;</td>
				<td colspan="4" height="23">
					<div align="center">
						<em><cf_translate key="LB_ListaDeEvaluadoresDe">Lista de Evaluadores de</cf_translate> #rsEvaluado.NombreEmp#</em>
					</div>
				</td>
				<td rowspan="7">&nbsp;</td>
		  	</tr>
		   <tr>
			<td colspan="4">

				<table width="75%" align="center"  border="0" cellspacing="0" cellpadding="2">
					<tr>
						<td nowrap="nowrap"><strong><cf_translate key="LB_Evaluador">Evaluador</cf_translate>:</strong>&nbsp;</td>
						<td><cf_rhempleado index="1" tabindex="1" size="25"></td>
					</tr>
					<tr>
						<td nowrap="nowrap"><strong><cf_translate key="LB_Tipo">Tipo</cf_translate>:</strong>&nbsp;</td>
						<td>
							<select name="RHEDtipo" tabindex="1">
								<cfif rsJefe.RecordCount eq 0>
									<option value="J"><cf_translate key="CMB_Jefe">Jefe</cf_translate></option>
									<option value="E"><cf_translate key="CMB_JefeAlterno">Jefe Alterno</cf_translate></option>
								</cfif>
								<option value="S"><cf_translate key="CMB_Subordinado">Colaborador</cf_translate></option>
								<option value="C"><cf_translate key="CMB_Companero">Compañero</cf_translate></option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<input type="submit" name="AgregarEval" class="btnGuardar" value="<cfoutput>#BTN_Agregar#</cfoutput>" onclick="javascript:funcAgregar();" tabindex="1">
						</td>
					</tr>

					<tr><td>&nbsp;</td></tr>
				</table>

				<table id="tbldynamic" width="75%" align="center"  border="0" cellspacing="0" cellpadding="0">
					<thead>
						<td></td>
						<td class="tituloListas"><strong><cf_translate key="LB_IdentificacionNombre">Identificaci&oacute;n/Nombre</cf_translate>:&nbsp;</strong></td>
						<td class="tituloListas" nowrap="nowrap"><strong><cf_translate key="LB_TipoDeEvaluador">Tipo de Evaluador</cf_translate>:&nbsp;</strong></td>
						<td class="tituloListas">&nbsp;</td>
                        <td class="tituloListas">&nbsp;</td>
						<td class="tituloListas">&nbsp;</td>
						<td></td>
					</thead>
	
					<tbody>
						<cfloop query="rsEvaluadoresLista">
							<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
								<td></td>
								<td>#DEidentificacion# #NombreEmp#</td>
								<td>#RHEDtipodesc#</td>
								<td>
									<cfif Estado EQ 1>
										<img src="/cfmx/rh/imagenes/checked.gif">
									<cfelse>
										<img src="/cfmx/rh/imagenes/unchecked.gif">
									</cfif>
								</td>
                               <td>
                               #imprimir#
                               </td>
								<td>
									<cfif RHEDtipo neq 'A' and Estado NEQ 1>
										<input  name="btnEliminar" type="image" alt="<cfoutput>#LB_EliminarElemento#</cfoutput>" onclick="javascript: return funcEliminar(#DEid#);" src="/cfmx/rh/imagenes/Borrar01_S.gif" tabindex="2">
									</cfif>
								</td>
								<td>
									<cfif Estado EQ 1>
										<input  name="btnHabilitar" type="image" alt="<cfoutput>#LB_HabilitarElemento#</cfoutput>" onclick="javascript: return funcHabilitar(#DEid#);" src="/cfmx/rh/imagenes/Documentos2.gif" tabindex="2">
									</cfif>
								</td>
							</tr>
						</cfloop>
					</tbody>
				</table>			
			</td>
		  </tr>
		  <tr><td colspan="4">&nbsp;</td></tr>
		  <tr>
			<td colspan="4" align="center">
				<input type="hidden" name="SEL" value="">
				<input type="hidden" name="RHEEid" value="#form.RHEEid#">
				<input type="hidden" name="DEid" value="#form.DEid#">
				<input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
				<cf_botones values="Anterior,Siguiente" names="Anterior,Siguiente" nbspbefore="4" nbspafter="4" tabindex="3">
			</td>
		  </tr>
		</table>
	</form>
	</cfoutput>
	<script language="javascript" type="text/javascript">
		<!--//

		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");

		function _validarCodigo(){
			<cfoutput query="rsEvaluadoresLista">
			if (this.getValue()=='#DEID#') this.error = "<cfoutput>#MSG_EsteEvaluadorYaEstaAgregadoALaListaDeEvaluadoresDeEsteEmpleadoNoPuedeAgregarloMasDeUnaVez#</cfoutput>";
			</cfoutput>
		}
		_addValidator("isCodigo", _validarCodigo);
		<cfoutput>
		objForm.DEid1.required = true;
		objForm.DEid1.description = "#LB_Evaluador#";
		objForm.DEid1.validateCodigo();
		objForm.RHEDtipo.description = "#LB_TipoDeEvaluador#";
		objForm.RHEDtipo.required = true;
		</cfoutput>
		function deshabilitarValidacion(){
			objForm.DEid1.required = false;
			objForm.RHEDtipo.required = false;
		}
		function habilitarValidacion(){
			objForm.DEid1.required = true;
			objForm.RHEDtipo.required = true;
		}
		
		objForm.NTIcodigo1.obj.focus();
		
		//-->
		
	</script>
<cfelse>
	<h4><cf_translate key="LB_SeleccioneUnEmpleadoAlQueDeseaAgregarEvaluadores">Seleccione un empleado al que desea agregar evaluadores</cf_translate>:</h4>
	<cfinclude template="frame-Empleados.cfm">
	<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="4" align="center">
		<script language="javascript" type="text/javascript">
			function funcAnterior(){
				document.form0.SEL.value = "3";
				document.form0.action = "registro_evaluacion.cfm";
				return true;
			}
			function funcSiguiente(){
				document.form0.SEL.value = "5";
				document.form0.action = "registro_evaluacion.cfm";
				return true;
			}
		</script>
		<form action="registro_evaluacion.cfm" method="post" name="form0">
			<cfoutput>
				<input type="hidden" name="SEL" value="">
				<input type="hidden" name="RHEEid" value="#form.RHEEid#">
			</cfoutput>
			<cf_botones values="Anterior,Siguiente" names="Anterior,Siguiente" functions="return false;,return false;" nbspbefore="4" nbspafter="4" tabindex="2">
		</form>
		</td>
	  </tr>
	</table>
</cfif>