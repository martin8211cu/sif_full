<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CaracteristicasDelCurso"
	Default="Caracter&iacute;sticas del Curso"
	returnvariable="LB_CaracteristicasDelCurso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_InformacionElCurso"
	Default="Informaci&oacute;n del Curso"
	returnvariable="LB_InformacionElCurso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_InstitucionQueLoImparte"
	Default="Instituci&oacute;n que lo imparte"
	returnvariable="LB_InstitucionQueLoImparte"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CursoBase"
	Default="Curso Base"
	returnvariable="LB_CursoBase"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Siglas"
	Default="Siglas"
	returnvariable="LB_Siglas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NombreDelCurso"
	Default="Nombre del curso"
	returnvariable="LB_NombreDelCurso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Profesor"
	Default="Profesor"
	returnvariable="LB_Profesor"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CostoEn"
	Default="Costo en"
	returnvariable="LB_CostoEn"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Seleccione"
	Default="Seleccione"
	returnvariable="LB_Seleccione"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ParaLaEmpresa"
	Default="Para la Empresa"
	returnvariable="LB_ParaLaEmpresa"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ParaElEmpleado"
	Default="Para el Empleado"
	returnvariable="LB_ParaElEmpleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cupo"
	Default="Cupo"
	returnvariable="LB_Cupo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Ocup"
	Default="Ocup."
	returnvariable="LB_Ocup"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TipoDeCurso"
	Default="Tipo de Curso"
	returnvariable="LB_TipoDeCurso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaInicio"
	Default="Fecha Inicio"
	returnvariable="LB_FechaInicio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaFinal"
	Default="Fecha Final"
	returnvariable="LB_FechaFinal"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_HoraInicio"
	Default="Hora Inicio"
	returnvariable="LB_HoraInicio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_HoraCierre"
	Default="Hora Cierre"
	returnvariable="LB_HoraCierre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DuracionHoras"
	Default="Duraci&oacute;n (Horas)"
	returnvariable="LB_DuracionHoras"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_LugarDeCapacitacion"
	Default="Lugar de capacitación"
	returnvariable="LB_LugarDeCapacitacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PermiteAutomatricula"
	Default="Permite Automatr&iacute;cula"
	returnvariable="LB_PermiteAutomatricula"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CobrarSiReprueba"
	Default="Cobrar si reprueba"
	returnvariable="LB_CobrarSiReprueba"/>

<!--- FIN VARIABLES DE TRADUCCION --->


<!--- Querys de Validación --->
<!--- Obtenemos la descripción de la Moneda --->
<cfquery datasource="#session.dsn#" name="monedas">
	select Mcodigo, Mnombre
	from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Mnombre
</cfquery>
<!--- Obtenemos la descripción del Tipo de Curso --->
<cfquery datasource="#session.dsn#" name="tipocurso">
	select RHTCid, RHTCdescripcion
	from RHTipoCurso
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by RHTCdescripcion
</cfquery>
<!--- Obtenemos la cantidad de cupos ocupados por curso --->
<cfquery datasource="#session.dsn#" name="cupocupado">
	select count(1) as cantidad
	from RHEmpleadoCurso
	where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#" null="#Len(url.RHCid) Is 0#">
</cfquery>

<cfparam name="url.RHCid" default="">

<!--- Obtenemos los datos de la pantalla --->
<cfquery datasource="#session.dsn#" name="data">
	select c.RHCid, c.RHIAid, c.Mcodigo, c.RHTCid,
		c.RHCcodigo, c.Ecodigo, c.RHCfdesde, c.RHCfhasta, RHCdirigido,
		c.RHCprofesor, c.RHCcupo, c.RHCautomat, c.RHECtotempresa,
		c.RHECtotempleado, c.idmoneda, c.RHECcobrar, c.BMfecha,
		c.BMUsucodigo, c.ts_rversion, c.RHCnombre,
		coalesce(c.horaini,getdate()) as horaini, coalesce(c.horafin,getdate()) as horafin,
		coalesce(c.duracion,0) as duracion, c.lugar, m.Mnombre, m.Msiglas, c.RHCexterno, c.RHCtipo,c.RHIid,RHTSid,RHCdisponible
	from  RHCursos c
		join RHMateria m
			on m.Mcodigo = c.Mcodigo
	where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#" null="#Len(url.RHCid) Is 0#">
</cfquery>

<!--- Conversión de Horas  --->
<!--- Fecha Inicio --->
<cfset HORAI   =  Hour(data.horaini)>
<cfset MINUTOI = Minute(data.horaini)>
<cfset AMPMI   = 'AM'>
<cfif HORAI gt 12>
	<cfset HORAI = (HORAI - 12)>
<cfelseif  HORAI eq 0>
	<cfset HORAI = 12>
</cfif>
<cfif Hour(data.horaini) gte 12>
	<cfset AMPMI = 'PM'>
</cfif>

<!--- Fecha Final --->
<cfset HORAF   = Hour(data.horafin)>
<cfset MINUTOF = Minute(data.horafin)>
<cfset AMPMF   = 'AM'>
<cfif HORAF gt 12>
	<cfset HORAF = (HORAF - 12)>
<cfelseif  HORAF eq 0>
	<cfset HORAF = 12>
</cfif>
<cfif Hour(data.horafin) gte 12>
	<cfset AMPMF = 'PM'>
</cfif>


<cf_web_portlet_start titulo="#LB_CaracteristicasDelCurso#">
<cfoutput>

<script type="text/javascript">

	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: RHCursos - RHCursos


				// Columna: RHIAid ID de Institucion Académica numeric
				if (formulario.RHIAid.value == "") {
					error_msg += "\n - ID de Institucion Académica no puede quedar en blanco.";
					error_input = formulario.RHIAid;
				}
				// Columna: Mcodigo Mcodigo numeric
				if (formulario.Mcodigo.value == "") {
					error_msg += "\n - Mcodigo no puede quedar en blanco.";
					error_input = formulario.Mcodigo;
				}

				// Columna: RHTCid RHTCid numeric
				if (formulario.RHTCid.value == "") {
					error_msg += "\n - RHTCid no puede quedar en blanco.";
					error_input = formulario.RHTCid;
				}

				// Columna: RHCcodigo RHCcodigo char(15)
				if (formulario.RHCcodigo.value == "") {
					error_msg += "\n - RHCcodigo no puede quedar en blanco.";
					error_input = formulario.RHCcodigo;
				}
				// Columna: RHCnombre RHCnombre varchar(50)
				if (formulario.RHCnombre.value == "") {
					error_msg += "\n - RHCnombre no puede quedar en blanco.";
					error_input = formulario.RHCnombre;
				}
			// Columna: RHCfdesde Fecha desde del Curso datetime
				if (formulario.RHCfdesde.value == "") {
					error_msg += "\n - Fecha desde del Curso no puede quedar en blanco.";
					error_input = formulario.RHCfdesde;
				}
			// Columna: RHCfhasta Fecha hasta del Curso datetime
				if (formulario.RHCfhasta.value == "") {
					error_msg += "\n - Fecha hasta del Curso no puede quedar en blanco.";
					error_input = formulario.RHCfhasta;
				}
				// Columna: RHCcupo Cupo int
				if (formulario.RHCcupo.value == "") {
					error_msg += "\n - Cupo no puede quedar en blanco.";
					error_input = formulario.RHCcupo;
				}
				// Columna: RHCautomat Permite Automatrícula int
				if (formulario.RHCautomat.value == "") {
					error_msg += "\n - Permite Automatrícula no puede quedar en blanco.";
					error_input = formulario.RHCautomat;
				}
				// Columna: RHECcobrar Cobrar si reprueba bit
				if (formulario.RHECcobrar.value == "") {
					error_msg += "\n - Cobrar si reprueba no puede quedar en blanco.";
					error_input = formulario.RHECcobrar;
				}
				if (formulario.DURACION.value == "") {
					error_msg += "\n - la duración del curso no puede quedar en blanco.";
					error_input = formulario.RHECcobrar;
				}
				if (formulario.LUGAR.value == "") {
					error_msg += "\n - El lugar donde se dara el curso no puede quedar en blanco.";
					error_input = formulario.RHECcobrar;
				}


		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
</script>
<script type="text/javascript">
 //Browser Support Code
	function ajaxFunction1_TipoS()
	{
		var ajaxRequest1;  // The variable that makes Ajax possible!
		var vID_tipo ='';
		//var vmodoD1 ='';
		vID_tipo = document.form1.RHIid.value;
		//vmodoD1 = document.form1.modoDep.value;
		try
		{
			// Opera 8.0+, Firefox, Safari
			ajaxRequest1 = new XMLHttpRequest();
		}
		catch (e)
		{
			// Internet Explorer Browsers
			try
			{
			ajaxRequest1 = new ActiveXObject("Msxml2.XMLHTTP");
			}
				catch (e)
				{
					try
					{
					ajaxRequest1 = new ActiveXObject("Microsoft.XMLHTTP");
					}
					catch (e)
					{
					// Something went wrong
					alert("Your browser broke!");
					return false;
					}
				}
		}

		//ajaxRequest1.open("GET", '/cfmx/sif/tesoreria/GestionEmpleados/ComboConcepto.cfm?GETid='+vID_tipo_gasto1+'&modoD='+vmodoD1, false);
		ajaxRequest1.open("GET", '/cfmx/rh/capacitacion/operacion/cursos/ComboTipo.cfm?RHIid='+vID_tipo, false);
		ajaxRequest1.send(null);
		document.getElementById("contenedor_Tipo1").innerHTML = ajaxRequest1.responseText;
	}
</script>


<form action="RHCursos-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">

	<table summary="Tabla de entrada" border="0">
		<tr><td colspan="3" class="subTitulo">#LB_InformacionElCurso#</td></tr>
		<tr><td colspan="3" valign="top">#LB_InstitucionQueLoImparte#</td>
		</tr>
		<tr>
			<td colspan="3" valign="top">
			<!---
			<select name="RHIAid"  >
				<cfloop query="inst">
					<option value="#HTMLEditFormat(inst.RHIAid)#" <cfif inst.RHIAid eq data.RHIAid>selected</cfif>>#HTMLEditFormat(inst.RHIAnombre)#</option>
				</cfloop>
			</select>
			--->

			<cfset inst_id  = '' >
			<cfset inst_nombre = '' >
			<cfif isdefined("data.RHIAid") and len(trim(data.RHIAid)) >
				<cfquery name="rs_traeinst" datasource="#session.DSN#">
					select RHIAid, RHIAnombre
					from RHInstitucionesA
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHIAid#">
				</cfquery>
				<cfset inst_id  = rs_traeinst.RHIAid >
				<cfset inst_nombre = replace(rs_traeinst.RHIAnombre,",","¸","ALL")>
			</cfif>

			<cf_conlis title="Listado de Instituciones"
				campos = "RHIAid,RHIAnombre"
				desplegables = "N,S"
				modificables = "N,N"
				values="#inst_id#,#inst_nombre#"
				size = "0,45"
				asignar="RHIAid,RHIAnombre"
				asignarformatos="S,S"
				tabla="	RHInstitucionesA"
				columnas="RHIAid, RHIAnombre"
				filtro="Ecodigo = #session.Ecodigo# order by RHIAnombre"
				desplegar="RHIAnombre"
				etiquetas="Instituci&oacute;n"
				formatos="S"
				align="left"
				showEmptyListMsg="true"
				debug="false"
				form="form1"
				width="450"
				height="500"
				left="350"
				top="300"
				maxrows="20"
				tabindex="1"
				filtrar_por="RHIAnombre"
				filtrar_por_delimiters="/">
			</td>
		</tr>
		<tr><td colspan="3" valign="top">#LB_CursoBase#</td></tr>
		<tr>
			<td colspan="3">
				<table cellpadding="1" cellspacing="0">
					<td colspan="2" valign="top">
						<input 	name="Msiglas"
								type="text"
								id="Msiglas"
								readonly
								onfocus="this.select()"
								value="#HTMLEditFormat(data.Msiglas)#"
								size="15" tabindex="1"
								maxlength="15">
					</td>
					<td valign="top">
						<input 	name="Mnombre"
								id="Mnombre"
								type="text"
								value="#HTMLEditFormat(data.Mnombre)#"
								maxlength=""
								size="35"  tabindex="1"
								onfocus="this.select()"
								readonly
						>
						<input	name="Mcodigo"
								type="hidden"
								id="Mcodigo"
								value="#HTMLEditFormat(data.Mcodigo)#" >
					</td>

				</table>
			</td>
		</tr>

		<tr>
			<td colspan="3">
				<table cellpadding="1" cellspacing="0">
					<tr>
						<td colspan="2" valign="top">#LB_Siglas#</td>
						<td valign="top">#LB_NombreDelCurso#</td>
					</tr>
					<tr>
						<td colspan="2" valign="top">
							<input name="RHCcodigo" type="text" id="RHCcodigo"
							onfocus="this.select()" value="#HTMLEditFormat(trim(data.RHCcodigo))#" size="15"
							maxlength="15" tabindex="1" >
						</td>
						<td valign="top" nowrap>
							<input name="RHCnombre" type="text" id="RHCnombre"
							onFocus="this.select()" value="#HTMLEditFormat(data.RHCnombre)#" size="35"
							maxlength="50" tabindex="1" ><input tabindex="1" type="button" style="width:18px " value="=" onclick="this.form.RHCnombre.value = this.form.Mnombre.value">
						</td>
					</tr>
				</table>
			</td>
		</tr>

		<tr>
			<td colspan="3" valign="top">#LB_Profesor#</td>
		</tr>
		<tr>
			<td colspan="3" valign="top">
				<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
				<cfset ArrayProf=ArrayNew(1)>
				<cfif isdefined("data.RHCprofesor") and len(trim(data.RHCprofesor))>
					<cfset ArrayAppend(ArrayProf,data.RHIid)>
					<cfset ArrayAppend(ArrayProf,data.RHCprofesor)>
				</cfif>
                <cfinvoke component="sif.Componentes.Translate"	method="Translate"
				Key="LB_ListaDeInstructores" Default="Lista de Instructores" returnvariable="LB_ListaDeInstructores"/>
					<cf_conlis
					Campos="RHIid,RHCprofesor"
					ValuesArray="#ArrayProf#"
					Desplegables="N,S"
					Modificables="N,N"
					Size="0,50"
					tabindex="1"
					Title="#LB_ListaDeInstructores#"
					Tabla="RHInstructores a"
					Columnas="a.RHIid,a.RHIidentificacion,a.RHInombre,a.RHIapellido1,a.RHIapellido2,coalesce(a.RHIapellido1,'') #LvarCNCT# ' ' #LvarCNCT# coalesce(a.RHIapellido2,'')#LvarCNCT# ' '#LvarCNCT# coalesce(a.RHInombre,'') as RHCprofesor"
					Filtro=" Ecodigo = #Session.Ecodigo# order by RHIapellido1,RHIapellido2,RHInombre "
					Desplegar="RHIidentificacion,RHCprofesor"
					Etiquetas="Identificación,Nombre"
					filtrar_por="a.RHIidentificacion~coalesce(a.RHIapellido1,ltrim(' ')) #LvarCNCT# ' ' #LvarCNCT# coalesce(a.RHIapellido2,ltrim(' '))#LvarCNCT# ' '#LvarCNCT# coalesce(a.RHInombre,ltrim(' '))"
					filtrar_por_delimiters="~"
					Align="left,left,left,left"
					form="form1"
					Asignar="RHIid,RHCprofesor"
					Asignarformatos="S,S"
					funcion="ajaxFunction1_TipoS()"
					/>
			</td>
		</tr>
		<tr>
			<td nowrap="nowrap" align="left" valign="top">Tipo de Servicio: </td>
			<td>
				<cfquery name="rsServ" datasource="#session.dsn#">
					select s.RHTSid,RHTScodigo,RHTSdescripcion
					from RHTiposServxInst si
					inner join RHTiposServ s
					on s.RHTSid=si.RHTSid
					and s.Ecodigo=si.Ecodigo
					where s.Ecodigo=#session.Ecodigo#
					<cfif isdefined('data') and data.recordcount gt 0 and len(trim(data.RHIid)) gt 0>
						and RHIid=#data.RHIid#
					</cfif>
				</cfquery>
				<cfif rsServ.RecordCount eq 0>
					<cfquery name="rsServ" datasource="#session.dsn#">
						select s.RHTSid,RHTScodigo,RHTSdescripcion
						from RHTiposServ s
						where s.Ecodigo=#session.Ecodigo#
						<cfif isdefined('data') and data.recordcount gt 0 and len(trim(data.RHTSid)) gt 0>
							and RHTSid=#data.RHTSid#
						</cfif>
					</cfquery>
				</cfif>

				<span id="contenedor_Tipo1">
					<select name="RHTSid" id="RHTSid">
						<cfif rsServ.RecordCount>
							<cfloop query="rsServ">
								<option value="#rsServ.RHTSid#"<cfif isdefined('data') and data.RHTSid eq rsServ.RHTSid> selected="selected" </cfif>> #rsServ.RHTScodigo#-#rsServ.RHTSdescripcion#</option>
							</cfloop>
						</cfif>
					</select>
				</span>
			</td>
		</tr>
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2116" default="" returnvariable="UsaDir"/>
		<cfif UsaDir gt 0>
		<tr>
			<td colspan="2">Dirigido a:&nbsp;
			<input type="text" size="40" maxlength="255" name="txtDir" value="<cfif isdefined('data') and len(trim(data.RHCdirigido)) gt 0>#data.RHCdirigido#</cfif>" /></td>
		</tr>
		</cfif>
		<tr>
			<td valign="top">#LB_CostoEn#: </td>
			<td valign="top" colspan="2">
				<select name="idmoneda" id="idmoneda"  tabindex="1" >
				<option value="">-#LB_Seleccione#-</option>
					<cfloop query="monedas">
						<option value="#HTMLEditFormat(monedas.Mcodigo)#" <cfif monedas.Mcodigo eq data.idmoneda>selected</cfif>>#HTMLEditFormat(monedas.Mnombre)#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2" valign="top"> #LB_ParaLaEmpresa# </td>
			<td valign="top">#LB_ParaElEmpleado#</td>
		</tr>
		<tr>
			<td colspan="2" valign="top">
				<input name="RHECtotempresa" type="text" tabindex="1" id="RHECtotempresa" style="text-align:right; "
				onfocus="this.select()" value="<cfif Len(data.RHECtotempresa)>#NumberFormat(data.RHECtotempresa,',0.00')#</cfif>" size="15"
				maxlength="30"  >
			</td>
			<td valign="top">
				<input name="RHECtotempleado" tabindex="1" type="text" id="RHECtotempleado" style="text-align:right; "
				onFocus="this.select()" value="<cfif Len(data.RHECtotempleado)>#NumberFormat(data.RHECtotempleado,',0.00')#</cfif>" size="15"
				maxlength="30"  >
			</td>
		</tr>
		<tr>
			<td valign="top"> #LB_Cupo#</td>
			<td valign="top">#LB_Ocup#</td>
			<td valign="top">#LB_TipoDeCurso#</td>
		</tr>
		<tr>
			<td  valign="top">
				<input name="RHCcupo" type="text" id="RHCcupo" tabindex="1"
				style="text-align:right"		onFocus="this.select()" value="#NumberFormat(data.RHCcupo,',0')#" size="5"
				maxlength="11"  >
			</td>
			<td valign="top">
				<input name="CupoOcupado" type="text" id="CupoOcupado" readonly="" disabled tabindex="1"
				style="text-align:right"		onFocus="this.select()" value="#NumberFormat(cupocupado.cantidad,',0')#" size="5"
				maxlength="11"  >
			</td>
			<td valign="top">
				<select name="RHTCid"  tabindex="1">
				<cfloop query="tipocurso">
					<option value="#HTMLEditFormat(tipocurso.RHTCid)#" <cfif tipocurso.RHTCid eq data.RHTCid>selected</cfif>>#HTMLEditFormat(tipocurso.RHTCdescripcion)#</option>
				</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2" valign="top">#LB_FechaInicio# </td>
			<td valign="top">#LB_FechaFinal# </td>
		</tr>
		<tr>
			<td colspan="2" valign="top"><cf_sifcalendario tabindex="1" form="form1" name="RHCfdesde" nameFechaFin="RHCfhasta" value="#DateFormat(data.RHCfdesde,'dd/mm/yyyy')#"> </td>
			<td valign="top"><cf_sifcalendario tabindex="1" form="form1" name="RHCfhasta" nameFechaInicio="RHCfdesde" value="#DateFormat(data.RHCfhasta,'dd/mm/yyyy')#"> </td>
		</tr>
		<tr>
			<td colspan="2"valign="top">#LB_HoraInicio#</td>
			<td colspan="2"valign="top">#LB_HoraCierre#</td>
		</tr>
		<tr>
			<td colspan="2" valign="top" nowrap="nowrap">
				<select id="HORAINI" name="HORAINI" tabindex="1">
				<cfloop from="1" to="12" index="H">
					<cfif H LT 10>
						<option value="#H#" <cfif H EQ HORAI>selected</cfif>>0#H#</option>
					<cfelse>
						<option value="#H#" <cfif H EQ HORAI>selected</cfif>>#H#</option>
					</cfif>
				</cfloop>
				</select>

				<select id="MINUTOSINI"  name="MINUTOSINI" tabindex="1">
				<cfloop from="0" to="59" index="M">
					<cfif M LT 10>
						<option value="#M#" <cfif M EQ MINUTOI>selected</cfif>>0#M#</option>
					<cfelse>
						<option value="#M#" <cfif M EQ MINUTOI>selected</cfif>>#M#</option>
					</cfif>
				</cfloop>
				</select>

				<select  id="PMAMINI" name="PMAMINI" tabindex="1">
					<option value="AM" <cfif "AM" EQ AMPMI>selected</cfif> >AM</option>
					<option value="PM" <cfif "PM" EQ AMPMI>selected</cfif>  >PM</option>
				</select>&nbsp;&nbsp;&nbsp;

				<input type="hidden" id="_HORAINI" 		name="_HORAINI" 	value="#HORAI#">
				<input type="hidden" id="_MINUTOSINI" 	name="_MINUTOSINI" 	value="#MINUTOI#">
				<input type="hidden" id="_PMAMINI" 		name="_PMAMINI" 	value="#AMPMI#">

			</td>
			<td colspan="2" valign="top" nowrap="nowrap" >
				<select id="HORAFIN" name="HORAFIN" tabindex="1">
				<cfloop from="1" to="12" index="H">
					<cfif H LT 10>
						<option value="#H#" <cfif H EQ HORAF>selected</cfif>>0#H#</option>
					<cfelse>
						<option value="#H#" <cfif H EQ HORAF>selected</cfif>>#H#</option>
					</cfif>
				</cfloop>
				</select>

				<select id="MINUTOSFIN"  name="MINUTOSFIN" tabindex="1">
				<cfloop from="0" to="59" index="M">
					<cfif M LT 10>
						<option value="#M#" <cfif M EQ MINUTOF>selected</cfif>>0#M#</option>
					<cfelse>
						<option value="#M#" <cfif M EQ MINUTOF>selected</cfif>>#M#</option>
					</cfif>
				</cfloop>
				</select>

				<select  id="PMAMFIN" name="PMAMFIN" tabindex="1">
					<option value="AM" <cfif "AM" EQ AMPMF>selected</cfif> >AM</option>
					<option value="PM" <cfif "PM" EQ AMPMF>selected</cfif>>PM</option>
				</select>

				<input type="hidden" id="_HORAFIN" 		name="_HORAFIN" 	value="#HORAF#">
				<input type="hidden" id="_MINUTOSFIN" 	name="_MINUTOSFIN" 	value="#MINUTOF#">
				<input type="hidden" id="_PMAMFIN" 		name="_PMAMFIN" 	value="#AMPMF#">
			</td>
		</tr>
		<tr><td  colspan="2" valign="top">#LB_DuracionHoras#</td>
					<td valign="top" >Modalidad</td>
		</tr>
		<tr>
			<td  colspan="2" valign="top">
				<input  name="DURACION"   tabindex="1"
				type="text"
				id="DURACION"
				value="#HTMLEditFormat(data.DURACION)#"
				size="8"
				maxlength="8"
				style="text-align: right;"
				onBlur="javascript:fm(this,2);"
				onFocus="javascript:this.value=qf(this); this.select();"
				onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
			</td>
			<td>				<select  id="RHCtipo" name="RHCtipo" tabindex="1" >
					<option value="P" <cfif isdefined("data.RHCtipo") and data.RHCtipo eq 'P'>selected</cfif>>Participaci&oacute;n</option>
					<option value="A" <cfif isdefined("data.RHCtipo") and data.RHCtipo eq 'A'>selected</cfif>>Aprovechamiento</option>
				</select>
			</td>

		</tr>
		<tr><td colspan="3" valign="top">#LB_LugarDeCapacitacion#</td></tr>
		<tr>
			<td colspan="3" valign="top">
				<input  name="LUGAR"  tabindex="1"
				type="text"
				id="LUGAR"
				onFocus="this.select()"
				value="#HTMLEditFormat(data.LUGAR)#"
				size="50"
				maxlength="100" >
			</td>
		</tr>

		<tr>
			<td colspan="3" valign="top">
				<input name="RHCautomat" tabindex="1" id="RHCautomat" type="checkbox" value="1" <cfif Len(data.RHCautomat) And data.RHCautomat>checked</cfif> >
				<label for="RHCautomat">#LB_PermiteAutomatricula#</label>
			</td>
		</tr>
		<tr>
			<td colspan="3" valign="top">
				<input name="RHECcobrar" tabindex="1" id="RHECcobrar" type="checkbox" value="1" <cfif Len(data.RHECcobrar) And data.RHECcobrar>checked</cfif> >
				<label for="RHECcobrar">#LB_CobrarSiReprueba#</label>
			</td>
		</tr>
		<tr>
		<td colspan="2" valign="top">
			<input name="RHCexterno" tabindex="1" id="RHCexterno" type="checkbox" value="1" <cfif isdefined("data.RHCexterno") and data.RHCexterno eq 1>checked</cfif> >
			<label for="RHCexterno">Es curso externo</label></td>
		</tr>
		<tr>
			<td colspan="2">
				<input name="chkDisponibles" type="checkbox" tabindex="1"
				<cfif isdefined('data') and data.RHCdisponible gt 0>checked</cfif> >
				<label for="MostrarDisponible">Mostrar Campos Disponibles en Cursos</label>
			</td>
		</tr>
		<tr>
			<td colspan="3" class="formButtons">
				<cfif data.RecordCount>
					<cf_botones modo='CAMBIO' include="" tabindex="2">
				<cfelse>
					<cf_botones modo='ALTA' tabindex="2">
				</cfif>
			</td>
		</tr>
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2117" default="" returnvariable="UsaFiltro"/>

		<cfif data.RecordCount>
		<tr>
			<td colspan="3" nowrap="nowrap">
				<cfif UsaFiltro gt 0>
					<cf_botones tabindex="2" values="Participantes" names="Participantes">
				</cfif>
					<cf_botones tabindex="2" values="Detallar Programaci&oacute;n" names="Programar">
			</td>
		</tr>
		</cfif>
	</table>
	<input type="hidden" name="RHCid" value="#HTMLEditFormat(data.RHCid)#">
	<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(data.Ecodigo)#">
	<input type="hidden" name="BMfecha" value="#HTMLEditFormat(data.BMfecha)#">
	<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#data.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<cfinclude template="url_hidden.cfm">
</form>

</cfoutput>
<cf_web_portlet_end>
