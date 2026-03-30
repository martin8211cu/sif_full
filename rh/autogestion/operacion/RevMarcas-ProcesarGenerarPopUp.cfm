<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso"
	Default="Usted no tiene grupos asociados. No puede acceder este proceso."
	returnvariable="MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Procesamiento_de_marcas_de_reloj"
	Default="Procesamiento de marcas de reloj"	
	returnvariable="LB_Procesamiento_de_marcas_de_reloj"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaInicialMenorAHoy"
	Default="La fecha hasta no puede ser mayor que hoy"	
	returnvariable="MSG_FechaInicialMenorAHoy"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Grupo"
	Default="Grupo"	
	returnvariable="LB_Grupo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Todos"
	Default="Todos"	
	returnvariable="LB_Todos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaFinal"
	Default="Fecha Final"	
	returnvariable="LB_FechaFinal"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"	
	returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEmpleados"
	Default="Lista de Empleados"	
	returnvariable="LB_ListaDeEmpleados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificación"	
	returnvariable="LB_Identificacion"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NoSeEncontraronRegistros"
	Default="No se encontraron registros"	
	returnvariable="LB_NoSeEncontraronRegistros"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate></title>
</head>
<body>
<cf_templatecss>
<cf_web_portlet_start titulo="#LB_Procesamiento_de_marcas_de_reloj#">
<cfoutput>
	<cfquery name="rsGrupos" datasource="#session.DSN#">
		select  b.Gid, b.Gdescripcion
		from RHCMAutorizadoresGrupo a
			inner join RHCMGrupos b
				on a.Gid = b.Gid
				and a.Ecodigo = b.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.Usucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
	<cfif rsGrupos.recordcount eq 0>
		<cf_throw message="#MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso#" errorcode="5110">
	</cfif>	
	<cfset vs_fechaActual = LSDateFormat(now(),'dd/mm/yyyy')>
	<form name="form1" method="post" action="RevMarcas-ProcesarGenerarPopUp-sql.cfm">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="right" nowrap><strong>#LB_Grupo#:&nbsp;</strong></td>
					<td>
						<cfif rsGrupos.RecordCount LTE 1>
							<input type="hidden" name="FAGrupo" value="#rsGrupos.Gid#">
							#rsGrupos.Gdescripcion#
						<cfelse>
							<select name="FAGrupo" tabindex="1">
								<option value="">--- #LB_Todos# ---</option>
								<cfloop query="rsGrupos">
									<option value="#rsGrupos.Gid#">#rsGrupos.Gdescripcion#</option>
								</cfloop>
							</select>
						</cfif>
					</td>
					<td align="right" nowrap><strong>#LB_FechaFinal#:&nbsp;</strong></td>
					<td>
						<cf_sifcalendario  tabindex="2" form="form1" name="FAfechaFinal" value="#vs_fechaActual#">
					</td>
				</tr>
				<tr>
					<td align="right" nowrap><strong>#LB_Empleado#:&nbsp;</strong></td>
					<td colspan="4">
						<cf_conlis
						   campos="FADEid,FADEidentificacion,FANombre"
						   desplegables="N,S,S"
						   modificables="N,S,N"
						   size="0,20,40"
						   title="#LB_ListaDeEmpleados#"
						   tabla=" RHCMAutorizadoresGrupo a
									inner join RHCMEmpleadosGrupo b
										on a.Gid = b.Gid
										and a.Ecodigo = b.Ecodigo
										
										inner join DatosEmpleado c
											on b.DEid = c.DEid
											and b.Ecodigo = c.Ecodigo"
						   columnas="b.DEid as FADEid, c.DEidentificacion as FADEidentificacion, {fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)} as FANombre"
						   filtro="a.Ecodigo = #session.Ecodigo#
									and a.Usucodigo = #session.Usucodigo#"
						   desplegar="FADEidentificacion,FANombre"
						   filtrar_por="c.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)}"
						   filtrar_por_delimiters="|"
						   etiquetas="#LB_Identificacion#,#LB_Empleado#"
						   formatos="S,S"
						   align="left,left"
						   form="form1"
						   asignar="FADEid,FADEidentificacion,FANombre"
						   asignarformatos="S,S,S"
						   showEmptyListMsg="true"
						   EmptyListMsg="-- #LB_NoSeEncontraronRegistros# --"
						   tabindex="1">
					</td>
				</tr>								
				<tr><td>&nbsp;</td></tr>								
			</table>
			<cf_botones values="Generar, Cerrar">
	</form>
	<script type="text/javascript" language="javascript1.2">
		<!--//
		function funcGenerar() {
			var inicio = document.form1.FAfechaFinal.value.split('/');
			var fechainicio = inicio[2] + inicio[1] + inicio[0];
			var fechaactual = '#vs_fechaActual#';
			var fechaactual = fechaactual.split('/');
			var fechaactual = fechaactual[2]+fechaactual[1]+fechaactual[0]
			if (fechainicio > fechaactual){
				alert("#MSG_FechaInicialMenorAHoy#");
				document.form1.FAfechaFinal.value = '#vs_fechaActual#';
				return false;
			}			
			return true;
		}
		function funcCerrar(){
			window.close();
		}
		//-->
	</script>
</cfoutput>
<cf_web_portlet_end>
</body>
</html>