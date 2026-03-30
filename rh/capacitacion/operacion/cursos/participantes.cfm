<cfset t = createObject("component", "sif.Componentes.Translate")>

<cf_templateheader title="Participantes">
<cf_web_portlet_start titulo="Detalle de Participantes">
<cfif isdefined('url.RHCid') and len(trim(url.RHCid)) gt 0 and not (isdefined('form.RHCid') and len(trim(form.RHCid)))>
	<cfset form.RHCid=#url.RHCid#>
</cfif>

<cfparam name="FORM.RHCid" type="numeric">
<!--- Consultas--->
<!--- Departamentos--->
<cfquery name="rsCurso" datasource="#session.dsn#">
	select RHCcodigo,RHCnombre
	from RHCursos where RHCid=#form.RHCid#
</cfquery>
<cfquery name="rsDepartamentos" datasource="#session.DSN#">
	select Dcodigo, Ddescripcion
	from Departamentos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Ddescripcion
</cfquery>
<!--- Oficinas --->
<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Odescripcion
</cfquery>

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_EstaSeguroQueDeseaContinuarYPerderLaConfiguracionActual" Default="Esta seguro que desea continuar y perder la configuración actual?" returnvariable="MSG_EstaSeguroQueDeseaContinuarYPerderLaConfiguracionActual"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_EsteCentroFuncionalYaFueAgregado" Default="Este Centro Funcional ya fue agregado" returnvariable="MSG_EsteCentroFuncionalYaFueAgregado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_EstaOficinaDepartamentoYaFueAgregada" Default="Esta Oficina / Departamento. ya fue agregada" returnvariable="MSG_EstaOficinaDepartamentoYaFueAgregada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_EstePuestoYaFueAgregado" Default="Este Puesto ya fue agregado" returnvariable="MSG_EstePuestoYaFueAgregado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_EsteEmpleadoYaFueAgregado" Default="Este Empleado ya fue agregado" returnvariable="MSG_EsteEmpleadoYaFueAgregado" component="sif.Componentes.Translate" method="Translate"/>



<!--- VARIABLES DEL FILTRO --->
<cfif isdefined("Url.Filtro_Nombre") and not isdefined("Form.Filtro_Nombre")>
	<cfparam name="Form.Filtro_Nombre" default="#Url.Filtro_Nombre#">
</cfif>
<cfif isdefined("Url.Filtro_DEidentificacion") and not isdefined("Form.Filtro_DEidentificacion")>
	<cfparam name="Form.Filtro_DEidentificacion" default="#Url.Filtro_DEidentificacion#">
</cfif>
<cfif isdefined("Url.Filtro_Puesto") and not isdefined("Form.Filtro_Puesto")>
	<cfparam name="Form.Filtro_Puesto" default="#Url.Filtro_Puesto#">
</cfif>
<cfif isdefined("Url.Filtro_CF") and not isdefined("Form.Filtro_CF")>
	<cfparam name="Form.Filtro_CF" default="#Url.Filtro_CF#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif isdefined("Form.Filtro_DEidentificacion") and Len(Trim(Form.Filtro_DEidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and upper(DEidentificacion)  like '%" & UCase(Form.Filtro_DEidentificacion) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_DEidentificacion=" & Form.Filtro_DEidentificacion>
</cfif>
<cfif isdefined("Form.Filtro_Nombre") and Len(Trim(Form.Filtro_Nombre)) NEQ 0>
	<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) }) like '%" & #UCase(Form.Filtro_Nombre)# & "%'">

	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Nombre=" & Form.Filtro_Nombre>
</cfif>
<cfif isdefined("Form.Filtro_Puesto") and Len(Trim(Form.Filtro_Puesto)) NEQ 0>
	<cfset filtro = filtro & " and upper(RHPdescpuesto) like '%" & #UCase(Form.Filtro_Puesto)# & "%'">

	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_Puesto=" & Form.Filtro_Puesto>
</cfif>
<cfif isdefined("Form.Filtro_CF") and Len(Trim(Form.Filtro_CF)) NEQ 0>
	<cfset filtro = filtro & " and upper(CFdescripcion) like '%" & #UCase(Form.Filtro_CF)# & "%'">

	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Filtro_CF=" & Form.Filtro_CF>
</cfif>
<cfif isdefined("Form.RHCid") and LEN(TRIM(form.RHCid)) >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHCid=" & form.RHCid>
</cfif>


<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<input type="image" id="imgCheck" src="/cfmx/rh/imagenes/checked.gif" title="" style="display:none;">
<input type="image" id="imgUnCheck" src="/cfmx/rh/imagenes/unchecked.gif" title="" style="display:none;">
<form action="participantes-sql.cfm" method="post" name="formParticipantes" enctype="multipart/form-data">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0">
		<tr>
			<cfoutput><td colspan="6" align="center" class="listaNon"><strong>Curso:</strong>#rsCurso.RHCcodigo#-#rsCurso.RHCnombre#
			</td></cfoutput>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td rowspan="8">&nbsp;</td>
			<td colspan="5">
				<p>
				<cf_translate key="LB_SeleccioneLosCriteriosParaAgregarEmpleadosALaRelacion">Seleccione los criterios para agregar empleados a la Relaci&oacute;n</cf_translate>:
				</p>
			</td>
			<td rowspan="8">&nbsp;</td>
		</tr>
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td colspan="5">
				<table width="100%"  border="0" cellspacing="0" cellpadding="1">
					<tr>
						<td valign="middle" nowrap="nowrap" width="1%"><input type="radio" checked="checked" name="radfecha" value="0" onclick="javascript: funcfecha(this.value)" /><strong><cf_translate key="LB_EmpleadosIncluidosAntesDe">Empleados incluidos antes de</cf_translate>:</strong></td>
						<td valign="middle" style="display:''" id="date1" ><cf_sifcalendario name="fechaini" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1"></td>
					</tr>
					<tr>
						<td valign="middle" nowrap="nowrap" width="1%"><input type="radio" name="radfecha" value="1" onclick="javascript: funcfecha(this.value)" /><strong><cf_translate key="LB_Despuesde">Después de</cf_translate>:</strong></td>
						<td valign="middle" style="display:none" id="date2" ><cf_sifcalendario name="fechafin" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="2"></td>
					</tr>
					<tr>
						<td colspan="2">
							<table width="50%"  border="0" cellspacing="0" cellpadding="1">
								<td valign="middle" width="1%"><input type="radio" name="opt" value="0" tabindex="1" onClick="javascript: mostrar_div('CF');"></td>
								<td valign="middle" nowrap="nowrap"><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate></td>
								<td valign="middle" width="1%"><input type="radio" name="opt" value="1" tabindex="1" onClick="javascript: mostrar_div('OD');"></td>
								<td valign="middle" nowrap="nowrap"><cf_translate key="LB_OficinaDepartamento">Oficina/Departamento</cf_translate></td>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td valign="top" width="88%" colspan="3" >
				<div id="div_CF" style="display:;" >
					<table width="100%"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
						<tr>
							<td class="subtitulo_seccion_small">&nbsp;<cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate></td>
						</tr>
						<tr>
							<td>
								<table id="tblcf" width="100%"    border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td></td>
										<td><strong><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:</strong>&nbsp;</td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td></td>
										<td><cf_rhcfuncional size="20" tabindex="2" form="formParticipantes"><!--- CFid, CFcodigo, CFdescripcion ---></td>

										<td nowrap>
											<input type="checkbox" name="CFdependencias" tabindex="2"><strong><cf_translate key="LB_IncluirDependencias">Incluir Dependencias</cf_translate></strong></td>
										<td align="right">
											<input type="hidden" name="LastOneCF" id="LastOneCF" value="ListaNon">
											<input type="button" name="agregarCF" onClick="javascript:if (window.fnNuevoCF) fnNuevoCF();" value="+" tabindex="2">
										</td>
									</tr>
									<tbody>
									</tbody>
								</table>
							</td>
						</tr>

						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				</div>

				<div id="div_OD" style="display:none;">
					<table width="100%"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
						<tr><td class="subtitulo_seccion_small">&nbsp;<cf_translate key="LB_OficinaDepartamento">Oficina/Departamento</cf_translate></td></tr>
						<tr>
							<td>
								<table id="tblod" width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td></td>
										<td><strong><cf_translate key="LB_Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate>:</strong>&nbsp;</td>
										<td><strong><cf_translate key="LB_Departamento"  XmlFile="/rh/generales.xml">Departamento</cf_translate>:</strong>&nbsp;</td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td></td>
										<td>
											<select name="Ocodigo" tabindex="2" >
												<cfoutput query="rsOficinas">
													<option value="#rsOficinas.Ocodigo#|#rsOficinas.Odescripcion#">#rsOficinas.Odescripcion#</option>
												</cfoutput>
											</select>
										</td>
										<td>
											<select name="Dcodigo" tabindex="2">
												<cfoutput query="rsDepartamentos">
													<option value="#rsDepartamentos.Dcodigo#|#rsDepartamentos.Ddescripcion#">#rsDepartamentos.Ddescripcion#</option>
												</cfoutput>
											</select>
										</td>
										<td align="right">
											<input type="hidden" name="LastOneOD" id="LastOneOD" value="ListaNon">
											<input type="button" name="agregarOD" onClick="javascript:if (window.fnNuevoOD) fnNuevoOD();" value="+" tabindex="2">
										</td>
									</tr>
									<tbody>
									</tbody>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				</div>
				<script language="JavaScript" type="text/javascript">
					$( document ).ready(function() {
					   mostrar_div('CF');
					});
				</script>
			</td>
			<td width="2%">&nbsp;</td>
			<br />
		</tr>

		<tr>
			<td>
				<br />
				<table width="100%"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
					<tr><td class="subtitulo_seccion_small">&nbsp;<cf_translate key="LB_Puestos" XmlFile="/rh/generales.xml">Puestos</cf_translate></td></tr>
					<tr>
						<td>
							<table id="tblpuesto" width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td></td>
									<td><strong><cf_translate key="LB_Puesto" XmlFile="/rh/generales.xml">Puesto</cf_translate>:</strong>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td></td>
									<td>
										<cf_rhpuesto size="20" tabindex="3" form="formParticipantes">
									</td>
									<td align="right">
										<input type="hidden" name="LastOnePuesto" id="LastOnePuesto" value="ListaNon" tabindex="3">
										&nbsp;<input type="button" name="agregarPuesto" onClick="javascript:if (window.fnNuevoPuesto) fnNuevoPuesto();" value="+" tabindex="3">
									</td>
								</tr>
								<tbody>
								</tbody>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<br />
				<table id="tblempleado" width="100%"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
					<tr><td class="subtitulo_seccion_small" colspan="3">&nbsp;<cf_translate key="LB_Empleados" XmlFile="/rh/generales.xml">Empleados</cf_translate></td></tr>
					<tr>
						<td></td>
						<td><strong><cf_translate key="LB_Empleado" XmlFile="/rh/generales.xml">Empleado</cf_translate>:</strong>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<cf_rhempleado size="40" form="formParticipantes">
						</td>
						<td align="right"><!----align="right"---->
							<input type="hidden" name="LastOneEmpleado" id="LastOneEmpleado" value="ListaNon" tabindex="4">
							&nbsp;<input type="button" name="agregarEmpleado" onClick="javascript:if (window.fnNuevoEmpleado) fnNuevoEmpleado();" value="+" tabindex="4">
						</td>
					</tr>

					<tbody>
					</tbody>
				</table>
                <tr><td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td></tr>
			</td>
		</tr>

			<tr>
		<td colspan="5">&nbsp;</td>
		</tr>
		<tr>
		<td colspan="5">&nbsp;</td>
		</tr>

		<tr>
			<td colspan="6" align="center" nowrap="nowrap">
				<cfoutput>
				<input type="hidden" name="SEL" value="">
				<input type="hidden" name="RHCid" value="#form.RHCid#">
				<input type="button" name="Regresar" class="btnAnterior" value="Regresar" tabindex="5" onclick="javascript:location.href='index.cfm?RHCid=#form.RHCid#'">
				<input type="submit" name="Actualizar" class="btnAplicar" value="Generar" tabindex="6" />
                <input type="submit" name="EnviarEmail" class="btnAplicar" value="Enviar Correo" tabindex="7" />

				</cfoutput>
			</td>
		</tr>
        <tr><td colspan="6">&nbsp;</td></tr>
        <cf_dbfunction name="concat" args="DEapellido1,' ',DEapellido2,' ',DEnombre" returnvariable="LvarNombre">
        <cf_dbfunction name="spart" args="#LvarNombre#,1,30" returnvariable="LvarNombreS">

		<!---check plistas--->
        <cfset checked = "<img src=''/cfmx/rh/imagenes/checked.gif'' border=''0''>">
        <cfset unchecked = "<img src=''/cfmx/rh/imagenes/unchecked.gif'' border=''0''>">

        <!--- LISTA  DE PARTICIPANTES --->
        <cfquery name="Participantes" datasource="#session.DSN#">
        	select distinct 
            #preservesinglequotes(LvarNombreS)# as nombre,
            a.RHCid,a.DEid,DEidentificacion,
            <cf_dbfunction name="spart" args="p.RHPdescpuesto,1,30"> as Puesto,CFdescripcion as CF
            ,case coalesce(a.RHECnotificado,0) when 1 then '#checked#' else '#unchecked#' end as RHECnotificado
            from RHCursos cr
            inner join RHEmpleadosporCurso a
                on cr.RHCid = a.RHCid
            inner join DatosEmpleado b
                on b.DEid = a.DEid
            inner join LineaTiempo c
                on c.DEid = a.DEid
            inner join RHPlazas pl
                on pl.RHPid = c.RHPid
            inner join CFuncional d
                on d.CFid = pl.CFid
            inner join RHPuestos p
                on p.RHPcodigo = pl.RHPpuesto
						where a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
						and c.LTid = (select Max(lt2.LTid) from LineaTiempo lt2 inner join RHTipoAccion ta2 on ta2.RHTid = lt2.RHTid and ta2.RHTcomportam in (1,6) where lt2.DEid = c.DEid)
            
			      <cfif isdefined("filtro") and len(trim(filtro))>
                #PreserveSingleQuotes(filtro)#
            </cfif>
             union

             select distinct  #preservesinglequotes(LvarNombreS)# as nombre,
             a.RHCid,a.DEid,DEidentificacion,p.RHPdescpuesto as Puesto,CFdescripcion as CF
             ,case coalesce(a.RHECnotificado,0) when 1 then '#checked#' else '#unchecked#' end as RHECnotificado
            from RHCursos cr
            inner join RHEmpleadosporCurso a
                on cr.RHCid = a.RHCid
            inner join DatosEmpleado b
                on b.DEid = a.DEid
            inner join LineaTiempoR c
                on c.DEid = a.DEid
            inner join RHPlazas pl
                on pl.RHPid = c.RHPid
            inner join CFuncional d
                on d.CFid = pl.CFid
            inner join RHPuestos p
                on p.RHPcodigo = pl.RHPpuesto
            where a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
            
			<cfif isdefined("filtro") and len(trim(filtro))>
                #PreserveSingleQuotes(filtro)#
            </cfif>
        </cfquery>

    </table>
</form>
<form action="" method="post" name="formParticipantesFiltro" enctype="multipart/form-data">
	<cfoutput>
	<input type="hidden" name="RHCid" value="#form.RHCid#">
	</cfoutput>
    <table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0">
        <tr>
        	<td colspan="6">
            	<table width="100%" align="center" cellpadding="0" cellspacing="0">
					<cfset LB_Identificacion = t.translate('LB_Identificacion','Identificación','/rh/generales.xml')>
					<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')>
					<cfset LB_Puesto = t.translate('LB_Puesto','Puesto','/rh/generales.xml')>
					<cfset LB_CentroFuncional = t.translate('LB_CentroFuncional','Centro Funcional','/rh/generales.xml')>
					<cfset LB_Notificado = t.translate('LB_Notificado','Notificado','/rh/generales.xml')>
					<cfset LB_Noexistenparticipantes = t.translate('LB_Noexistenparticipantes','NO SE HAN REGISTRADO PARTICIPANTES','/rh/generales.xml')>
                	<tr>
                    	<td>
                        	<cfinvoke component="rh.Componentes.pListas" method="pListaQuery" mostrar_filtro="no" >
                                <cfinvokeargument name="query" value="#Participantes#"/>
                                <cfinvokeargument name="desplegar" value="DEidentificacion,Nombre,Puesto,CF,RHECnotificado"/>
                                <cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Nombre#,#LB_Puesto#, #LB_CentroFuncional#, #LB_Notificado#"/>
                                <cfinvokeargument name="formatos" value="S,S,S,S,I"/>
                                <cfinvokeargument name="align" value="left,left,left,left,center"/>
                                <cfinvokeargument name="ajustar" value="N"/>
                                <cfinvokeargument name="checkboxes" value="S">
                                <cfinvokeargument name="checkall" value="S">
                                <cfinvokeargument name="keys" value="RHCid,DEid">
                                <cfinvokeargument name="formName" value="Filtro">
                                <cfinvokeargument name="incluyeform" value="true">
                                <cfinvokeargument name="irA" value="participantes-sql.cfm"/>
                                <cfinvokeargument name="showEmptyListMsg" value="true">
                                <cfinvokeargument name="botones" value="Eliminar"/>
                                <cfinvokeargument name="EmptyListMsg" value="">
                                <cfinvokeargument name="mostrar_filtro" value="true"/>
                                <cfinvokeargument name="filtrar_automatico" value="true"/>
                                <cfinvokeargument name="filtrar_por" value="DEidentificacion"/>
                                <cfinvokeargument name="navegacion" value="#navegacion#">
                                <cfinvokeargument name="showLink" value="false">
                            </cfinvoke>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
	</table>
</form>
<script language="javascript1.2" type="text/javascript">
	$( document ).ready(function() {
		//inicializa el form
		qFormAPI.errorColor = "#FFFFCC";
		var objForm = new qForm("formParticipantes");
		//objForm.fecha.obj.focus();
	});
</script>
<!--- JavaScript --->
<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="javascript1.2" type="text/javascript">
 	<!--//

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	// funciones del form


	var vnContadorListas = 0;

	function funcAnterior(){
		document.form1.SEL.value = "1";
		document.form1.action = "registro_evaluacion.cfm";
		return true;
	}
	function mostrar_div(which){
		var div_cf = document.getElementById("div_CF");
		var div_od = document.getElementById("div_OD");
		if (which=="CF"){
			div_cf.style.display = '';
			div_od.style.display = 'none';
			document.formParticipantes.opt[0].checked = true;
			document.formParticipantes.opt[1].checked = false;}
		else{
			div_cf.style.display = 'none';
			div_od.style.display = '';
			document.formParticipantes.opt[0].checked = false;
			document.formParticipantes.opt[1].checked = true;}
	}

	function funcSiguiente(){
		if (vnContadorListas <= 0){
			document.form1.SEL.value = "3";
			document.form1.action = "registro_evaluacion.cfm";
			return true;
		}
		else{
			if (confirm("<cfoutput>#MSG_EstaSeguroQueDeseaContinuarYPerderLaConfiguracionActual#</cfoutput>")){
				document.form1.SEL.value = "3";
				document.form1.action = "registro_evaluacion.cfm";
				return true;
			}
			else {return false;}
		}
	}

	function funcfecha(m){
		if (m==0){
			var objD1 = document.getElementById('date1');
			var objD2 = document.getElementById('date2');
			objD1.style.display = '';
			objD2.style.display='none';
		}
		if(m==1){
			var objD1 = document.getElementById('date1');
			var objD2 = document.getElementById('date2');
			objD1.style.display = 'none';
			objD2.style.display='';
		}
	}


	//**********************************Tabla Dinámica**********************************************

	var GvarNewTD;

	//Función para agregar TRs
	function fnNuevoCF()
	{
	  if (document.formParticipantes.CFcodigo.value != '' && document.formParticipantes.CFid.value != ''){
	  	vnContadorListas = vnContadorListas + 1;
	  }

	  var LvarTable = document.getElementById("tblcf");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");

	  var Lclass 	= document.formParticipantes.LastOneCF;
	  var p1 		= document.formParticipantes.CFid.value.toString();//id
	  var p2 		= document.formParticipantes.CFcodigo.value;//cod
	  var p3 		= document.formParticipantes.CFdescripcion.value;//desc
	  var p4 		= document.formParticipantes.CFdependencias.checked;//agregar dependencias

	  document.formParticipantes.CFid.value = "";
	  document.formParticipantes.CFcodigo.value = "";
	  document.formParticipantes.CFdescripcion.value = "";
	  document.formParticipantes.CFdependencias.checked = false;

	  // Valida no agregar vacíos
	  if (p1=="") return;

	  // Valida no agregar repetidos
	  if (existeCodigoCF(p1)) {alert('<cfoutput>#MSG_EsteCentroFuncionalYaFueAgregado#</cfoutput>.');return;}

	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1 + "|" + ((p4) ? "1" : "0"), "hidden", "CFidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2 + ' - ' + p3);

	  // Agrega Columna 2
	  sbAgregaTdImage (LvarTR, Lclass.value, ((p4) ? "imgCheck" : "imgUnCheck"), "right");

	  // Agrega Evento de borrado en Columna 3
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);

	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);

	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}

	function fnNuevoOD()
	{
	 if (document.formParticipantes.Ocodigo.value != '' && document.formParticipantes.Dcodigo.value != ''){
      	vnContadorListas = vnContadorListas + 1;
	 }

	  var LvarTable = document.getElementById("tblod");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");

	  var Lclass 	= document.formParticipantes.LastOneOD;
	  var p1t 		= document.formParticipantes.Ocodigo.value.toString();//Oficina
	  var p2t 		= document.formParticipantes.Dcodigo.value;//Departamento

	  document.formParticipantes.Ocodigo.options[0].selected = true;
	  document.formParticipantes.Dcodigo.options[0].selected = true;

	  var p1d		= p1t.split("|");
	  var p2d		= p2t.split("|");

	  var p1		= p1d[0];
	  var p2		= p1d[1];
	  var p3		= p2d[0];
	  var p4		= p2d[1];

	  // Valida no agregar vacíos
	  if (p1=="") return;
	  if (p3=="") return

	  // Valida no agregar repetidos
	  if (existeCodigoOD(p1,p3)) {alert('<cfoutput>#MSG_EstaOficinaDepartamentoYaFueAgregada#</cfoutput>.');return;}

	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1 + "|" + p3, "hidden", "ODidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);

	  // Agrega Columna 2
	  sbAgregaTdText  (LvarTR, Lclass.value, p4);

	  // Agrega Evento de borrado en Columna 3
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);

	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);

	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}

	function fnNuevoPuesto()
	{
	  if (document.formParticipantes.RHPcodigo.value != '' && document.formParticipantes.RHPdescpuesto.value != ''){
	  	vnContadorListas = vnContadorListas + 1;
	  }

	  var LvarTable = document.getElementById("tblpuesto");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");

	  var Lclass 	= document.formParticipantes.LastOnePuesto;
	  var p1 		= document.formParticipantes.RHPcodigo.value.toString();//cod
	  var p2 		= document.formParticipantes.RHPdescpuesto.value;//desc

	  document.formParticipantes.RHPcodigo.value="";
	  document.formParticipantes.RHPcodigoext.value="";
	  document.formParticipantes.RHPdescpuesto.value="";

	  // Valida no agregar vacíos
	  if (p1=="") return;

	  // Valida no agregar repetidos
	  if (existeCodigoPuesto(p1)) {alert('<cfoutput>#MSG_EstePuestoYaFueAgregado#</cfoutput>.');return;}

	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "PuestoidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);

	  // Agrega Evento de borrado en Columna 2
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);

	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);

	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}
/*--------------------------------------------Tabla dinamica para los Empleados-----------------------------------------------------------------------*/
	function fnNuevoEmpleado()
	{
	  if (document.formParticipantes.DEid.value != '' && document.formParticipantes.DEidentificacion.value != ''){
	  	vnContadorListas = vnContadorListas + 1;
	  }

	  var LvarTable = document.getElementById("tblempleado");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");

	  var Lclass 	= document.formParticipantes.LastOneEmpleado;
	  var p1 		= document.formParticipantes.DEid.value.toString();//cod
	  var p2 		= document.formParticipantes.NombreEmp.value;//desc

	  document.formParticipantes.DEid.value="";
	  document.formParticipantes.NombreEmp.value="";

	  // Valida no agregar vacíos
	  if (p1=="") return;

	  // Valida no agregar repetidos
	  if (existeEmpleado(p1)) {alert('<cfoutput>#MSG_EsteEmpleadoYaFueAgregado#</cfoutput>.');return;}

	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "EmpleadoidList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);

	  // Agrega Evento de borrado en Columna 2
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);

	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);

	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}

	function existeEmpleado(v){
		var LvarTable = document.getElementById("tblempleado");
		for (var i=0; i<LvarTable.rows.length; i++)
		{

			var value = new String(fnTdValue(LvarTable.rows[i]));

			var data = value.split('|');

			if (data[0] == v){
				return true;
			}
		}
		return false;
	}

	//Función para eliminar TRs
	function sbEliminarTR(e)
	{
	  vnContadorListas = vnContadorListas - 1;

	  var LvarTR;

	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;

	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;

	  LvarTR.parentNode.removeChild(LvarTR);
	}

	//Función para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align)
	{
	  // Copia una imagen existente
	  var LvarTDimg    = document.createElement("TD");
	  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
	  LvarImg.style.display="";
	  LvarImg.align=align;
	  LvarTDimg.appendChild(LvarImg);
	  if (LprmClass != "") LvarTDimg.className = LprmClass;

	  GvarNewTD = LvarTDimg;
	  LprmTR.appendChild(LvarTDimg);
	}

	//Función para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue)
	{
	  var LvarTD    = document.createElement("TD");

	  var LvarTxt   = document.createTextNode(LprmValue);
	  LvarTD.appendChild(LvarTxt);
	  if (LprmClass!="") LvarTD.className = LprmClass;

	  GvarNewTD = LvarTD;

	  LvarTD.noWrap = true;
	  LprmTR.appendChild(LvarTD);
	}

	//Función para agregar TDs con Objetos
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName)
	{
	  var LvarTD    = document.createElement("TD");

	  var LvarInp   = document.createElement("INPUT");
	  LvarInp.type = LprmType;
	  if (LprmName!="") LvarInp.name = LprmName;
	  if (LprmValue!="") LvarInp.value = LprmValue;
	  LvarTD.appendChild(LvarInp);
	  if (LprmClass!="") LvarTD.className = LprmClass;
	  GvarNewTD = LvarTD;
	  LprmTR.appendChild(LvarTD);
	}

	function existeCodigoCF(v){
		var LvarTable = document.getElementById("tblcf");
		for (var i=0; i<LvarTable.rows.length; i++)
		{

			var value = new String(fnTdValue(LvarTable.rows[i]));

			var data = value.split('|');

			if (data[0] == v){
				return true;
			}
		}
		return false;
	}

	function existeCodigoOD(v1,v2){
		var LvarTable = document.getElementById("tblod");
		for (var i=0; i<LvarTable.rows.length; i++)
		{

			var value = new String(fnTdValue(LvarTable.rows[i]));

			var data = value.split('|');

			if (data[0] == v1 && data[1] == v2){
				return true;
			}
		}
		return false;
	}

	function existeCodigoPuesto(v){
		var LvarTable = document.getElementById("tblpuesto");
		for (var i=0; i<LvarTable.rows.length; i++)
		{

			var value = new String(fnTdValue(LvarTable.rows[i]));

			var data = value.split('|');

			if (data[0] == v){
				return true;
			}
		}
		return false;
	}

	function fnTdValue(LprmNode)
	{
	  var LvarNode = LprmNode;

	  while (LvarNode.hasChildNodes())
	  {
		LvarNode = LvarNode.firstChild;
		if (document.all == null)
		{
		  if (!LvarNode.firstChild && LvarNode.nextSibling != null &&
			LvarNode.nextSibling.hasChildNodes())
			LvarNode = LvarNode.nextSibling;
		}
	  }
	  if (LvarNode.value)
		return LvarNode.value;
	  else
		return LvarNode.nodeValue;
	}

		function hayMarcados()
		{
			var form = document.formParticipantesFiltro;
			var result = false;
			var varChk = document.formParticipantesFiltro.chk;

			if(!checkvalida())
			{
				alert('¡Debe seleccionar al menos un registro para relizar esta acción!');
				return false;
			}
			return true;
		}

		function checkvalida()
		{
			if(document.formParticipantesFiltro.chk.length === undefined)
			{
				return document.formParticipantesFiltro.chk.checked;
			}
			else
			{
				var checks = document.formParticipantesFiltro.chk;
			  	for (var i = 0; i < checks.length; i++)
			  	{
			  		var lcheck = checks[i];
					if (lcheck.checked)
					{
						return true;
					}
				}
				return false;
			}
		}

		function funcEliminar(){
			var form = document.formParticipantes;
			var msg = "¿Desea eliminar del Curso, los empleados marcados?";
			result = (hayMarcados()&&confirm(msg));
			if (result)
			{
				document.formParticipantesFiltro.action = "participantes-sql.cfm";
        		document.formParticipantesFiltro.submit();
				return true;
			}
			return false;
		}


		function funcFiltroChkAllFiltro(c){
			if (document.formParticipantesFiltro.chk) {
				if (document.formParticipantesFiltro.chk.value) {
					if (!document.formParticipantesFiltro.chk.disabled) {
						document.formParticipantesFiltro.chk.checked = c.checked;
					}
				} else {
					for (var counter = 0; counter < document.formParticipantesFiltro.chk.length; counter++) {
						if (!document.formParticipantesFiltro.chk[counter].disabled) {
							document.formParticipantesFiltro.chk[counter].checked = c.checked;
						}
					}
				}
			}
		}
		function funcFiltroChkThisFiltro(c){
			checked = true;
			if (document.formParticipantesFiltro.chk) {
				if (document.formParticipantesFiltro.chk.value) {
					if (!document.formParticipantesFiltro.chk.disabled) {
						if (!document.formParticipantesFiltro.chk.checked) {
							checked = false;
						}
					}
				} else {
					for (var counter = 0; counter < document.formParticipantesFiltro.chk.length; counter++) {
						if (!document.formParticipantesFiltro.chk[counter].disabled) {
							if (!document.formParticipantesFiltro.chk[counter].checked) {
								checked = false;
							}
						}
					}
				}
			}
			document.formParticipantesFiltro.chkAllItems.checked = checked;
		}

</script>

<cf_templatefooter>