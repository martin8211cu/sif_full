<!--- OPARRALES 2019-02-06
	- Reporte de acumulados de Nomina
 --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nomina" default="Nomina" xmlfile="/rh/nomina/consultas/AcumuladoNomina.xml"	 returnvariable="vRelacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_CentroFuncional" default="Centro Funcional"	 xmlfile="/rh/generales.xml" returnvariable="vCentro" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Consultar" default="Consultar"	 xmlfile="/rh/generales.xml" returnvariable="vConsultar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_No_se_encontraron_registros" default="No se encontraron registros"	 xmlfile="/rh/generales.xml" returnvariable="vNoRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Desde" default="Desde"	 xmlfile="/rh/generales.xml" returnvariable="vDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Hasta" default="Hasta"	 xmlfile="/rh/generales.xml" returnvariable="vHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n"	 xmlfile="/rh/generales.xml" returnvariable="vDescripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Tipo_de_Nomina" default="Tipo de N&oacute;mina"	 xmlfile="/rh/generales.xml" returnvariable="vTipoNomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_EmpleadoDesde" default="Empleado Desde" returnvariable="LB_EmpleadoDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_EmpleadoHasta" default="Empleado Hasta" returnvariable="LB_EmpleadoHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificaci&oacute;n" returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ListaDeEmpleados" default="Lista de Empleados" returnvariable="LB_ListaDeEmpleados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaRige" Default="Fecha Rige" returnvariable="LB_FechaRige"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaVence" Default="Fecha Vence" returnvariable="LB_FechaVence"/>

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<!--- VERIFICA SI LA EMPRESA ES DE GUATEMALA PARA MOSTRAR OTROS DATOS --->
<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select 1
	from Empresa e
		inner join Direcciones d
		on d.id_direccion = e.id_direccion
		and Ppais = 'GT'
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>

<cfquery name="rsTiposNomina" datasource="#session.dsn#">
	select Tdescripcion,Ttipopago+1 as Ttipopago,Tcodigo from TiposNomina 
	where Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cf_web_portlet_start border="true" titulo="Acumulado de N&oacute;mina" >
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
	<cfoutput>
		<form style="margin:0" action="AcumuladoNomina.cfm" method="get" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >

				<!--- =============== INICIO FILTRO SEMANAL ============== --->
				<tr>
					<td align="right" valign="middle" width="40%"><strong><cf_translate key="LB_Consultar_por" xmlfile="/rh/nomina/consultas/AcumuladoNomina.xml">Mostrar acumulado</cf_translate>:&nbsp;</strong></td>
					<td>
						<select name="TAcumulado" id="TAcumulado" onchange="javascript:TacumuladoS();">
							<option value="1"><cf_translate key="LB_Semanal" xmlfile="/rh/nomina/consultas/AcumuladoNomina.xml">Semanal</cf_translate></option>
							<option value="2"><cf_translate key="LB_Mensual" xmlfile="/rh/nomina/consultas/AcumuladoNomina.xml">Mensual</cf_translate></option>
							<option value="3">Bisemanal</option>
							<option value="4">Quincenal</option>
							
						</select>
					</td>
				</tr>

				<!--- =============== INICIO FILTRO TIPO DE NOMINA ============== --->
				<tr>
					<td align="right" valign="middle" width="40%"><strong><cf_translate key="LB_Tipo_nomina" xmlfile="/rh/nomina/consultas/AcumuladoNomina.xml">Tipo de Nomina</cf_translate>:&nbsp;</strong></td>
					<td>
						<select name="TNomina" id="TNomina">
							<cfloop query="rsTiposNomina">
								<cfif #Ttipopago# eq 1>
									<option value="#Tcodigo#">#Tdescripcion#</option>
								</cfif>
							</cfloop>
						</select>
					</td>
				</tr>
				<!--- =============== FIN FILTRO SEMANAL ============== --->

				<!--- <tr id="id_cerradas">
					<td align="right" valign="middle"><strong>#vRelacion#:&nbsp;</strong></td>
					<td>
						<cf_conlis
							campos="htipo,HRCNid,HTcodigo,HTdescripcion,HRCDescripcion,HRCdesde,HRChasta"
							desplegables="N,N,N,N,S,N,N"
							modificables="N,N,N,N,N,N,N"
							size="0,0,5,25,50,12,12"
							title="Lista de Relaciones de C&aacute;lculo"
							tabla="HRCalculoNomina a
									inner join TiposNomina b
									on b.Ecodigo=a.Ecodigo
									and b.Tcodigo=a.Tcodigo "
							columnas="	'Relaciones de C&aacute;lculo Cerradas' as tipodesc,
										'H' as htipo,
										a.RCNid as HRCNid,
										a.Tcodigo as HTcodigo,
										{fn concat(a.Tcodigo,{fn concat(' - ',b.Tdescripcion)})} as Hdescripcion,
										b.Tdescripcion as HTdescripcion,
										a.RCDescripcion as HRCDescripcion,
										a.RCdesde as HRCdesde,
										a.RChasta as HRChasta"
							filtro="a.Ecodigo=#session.Ecodigo#
									order by 1,4,7,8"
							desplegar="HRCDescripcion,HRCdesde,HRChasta"
							filtrar_por="RCDescripcion,RCdesde,RChasta"
							etiquetas="#vRelacion#,#vDesde#,#vHasta#"
							formatos=",S,D,D"
							align=",left,left,left"
							asignar="HRCNid,HRCDescripcion,htipo,HTcodigo"
							asignarformatos="S,S,S,S"
							showEmptyListMsg="true"
							EmptyListMsg="-- #vNoRegistros# --"
							tabindex="1"
							top="100"
							left="200"
							width="650"
							height="600"
							Cortes="tipodesc,Hdescripcion"
							alt="tipo,#vRelacion#,#vRelacion#,#vRelacion#">
					</td>
				</tr> --->

				<!--- ================ INICIO FILTRO MENSUAL ============= --->
				<!--- <cfset arrMeses = ArrayNew(1)>
				<cfset arrayAppend(arrMeses,"ENERO")>
				<cfset arrayAppend(arrMeses,"FEBRERO")>
				<cfset arrayAppend(arrMeses,"MARZO")>
				<cfset arrayAppend(arrMeses,"ABRIL")>
				<cfset arrayAppend(arrMeses,"MAYO")>
				<cfset arrayAppend(arrMeses,"JUNIO")>
				<cfset arrayAppend(arrMeses,"JULIO")>
				<cfset arrayAppend(arrMeses,"AGOSTO")>
				<cfset arrayAppend(arrMeses,"SEPTIEMBRE")>
				<cfset arrayAppend(arrMeses,"OCTUBRE")>
				<cfset arrayAppend(arrMeses,"NOVIEMBRE")>
				<cfset arrayAppend(arrMeses,"DICIEMBRE")> --->
				<!--- <tr id="idMensual">
					<td align="right" valign="middle" width="40%"><strong><cf_translate key="LB_Consultar_por_Mes" xmlfile="/rh/nomina/consultas/AcumuladoNomina.xml">Seleccione Mes</cf_translate>:&nbsp;</strong></td>
					<td>
						<select name="cboMesIni">
							<cfset countM = 1>
							<cfloop array="#arrMeses#" index="unMes">
								<option value="#countM#"><cf_translate key="LB_Relaciones_de_#unMes#" xmlfile="/rh/nomina/consultas/AcumuladoNomina.xml">#unMes#</cf_translate></option>
								<cfset countM++>
							</cfloop>
						</select>
					</td>
				</tr> --->
				<!--- ================== FIN FILTRO MENSUAL ============== --->
				<tr>
					<td align="right" valign="middle"><strong>#vCentro#:&nbsp;</strong></td>
					<td><cf_rhcfuncional></td>
				</tr>
		
				<tr>
					<td align="right" width="272">
						<strong>Tipo de filtro :&nbsp;</strong></td>
							<td width="238">
								<input type="radio" checked onclick="javascript:mostrarTR(1);"  name="Tfiltro" value="1" />
								Periodo
							</td>
							<td width="317" >
								<input onclick="javascript:mostrarTR(2);" type="radio" name="Tfiltro" value="2" />
							  	Rango de Fechas
							</td>
				</tr>
				<tr id="TR_Periodo">
					<td align="right" valign="middle" width="40%"><strong>Periodo:&nbsp;</strong></td>
					<td>
						<cfquery name="rsCPperiodo" datasource="#session.dsn#">
							select distinct CPperiodo from CalendarioPagos
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						</cfquery>
						<select name="CPperiodo" id="CPperiodo">
							<cfif rsCPperiodo.RecordCount NEQ 0>
								<cfloop query="rsCPperiodo">
									<option value="#rsCPperiodo.CPperiodo#">#rsCPperiodo.CPperiodo#</option>
								</cfloop>
							</cfif>
						</select>
					</td>
				</tr>
				<tr id="TR_FechaDesde" style="display:none">
					<td nowrap align="right"> #LB_FechaRige#: </td>
					<td><cf_sifcalendario form="form1" tabindex="1" name="FechaDesde"></td>
					<cfset paso = 2>
				</tr>
	
				<tr id="TR_FechaHasta" style="display:none">
					<td nowrap align="right"> #LB_FechaVence#: </td>
					<td><cf_sifcalendario form="form1" tabindex="1" name="FechaHasta"></td>
				</tr>
				<tr>
					<td></td>
					<td>
						<table width="100%" cellpadding="1" cellspacing="0">
							<tr>
								<td width="1%"><input type="checkbox" name="dependencias" id="dependencias"/></td>
								<td width="100%" nowrap="nowrap"><label for="dependencias"><cf_translate key="LB_Incluir_Centros_Funcionales_dependientes" xmlfile="/rh/nomina/consultas/AcumuladoNomina.xml">&nbsp;&nbsp;Incluir Centros Funcionales dependientes</cf_translate></label></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td></td>
					<td>
						<table cellpadding="1" cellspacing="0" border="0">
							<tr align="right">
								<td><input type="checkbox" name="corteEmp" id="corteEmp"/></td>
								<td nowrap="nowrap"><label for="corteEmp"><cf_translate key="LB_CorteXEmp" xmlfile="/rh/nomina/consultas/AcumuladoNomina.xml">&nbsp;Corte por Empleados&nbsp;&nbsp;</cf_translate></label></td>
							</tr>
						</table>
					</td>
				</tr>

				<cfif rsEmpresa.RecordCount NEQ 0>
					<tr>
						<td align="right" valign="middle"></td>
						<td>
							<table width="100%" cellpadding="1" cellspacing="0">
								<tr>
									<td width="1%"><input type="checkbox" name="corteBoleta" id="corteBoleta"/></td>
									<td width="100%" nowrap="nowrap"><label for="corteBoleta"><cf_translate key="LB_CortePorBoleta">Corte por boleta</cf_translate></label></td>
								</tr>
							</table>
						</td>
					</tr>
				</cfif>
				<tr>
					<td colspan="2" align="center"><input type="submit" name="btnConsultar" value="#vConsultar#" class="btnNormal" /></td>
				</tr>
			</table>

			<input type="hidden" name="CFidconta" value=""  />
			<input type="hidden" name="RCNid" value=""  />
			<input type="hidden" name="tipo" value="H" id="tipo" />
		</form>
	</cfoutput>
<cf_web_portlet_end>

<cf_qforms>

<cfoutput>
	<script type="text/javascript" language="javascript1.2">
		<!---
		objForm.CFid.required = true;
		objForm.CFid.description = '#vCentro#';
		 --->
		document.form1.tipo.value = 'H';
		if(document.form1.CFid.value != '' && document.form1.CFid.value > 0)
		{
			document.form1.CFidconta.value = document.form1.CFid.value;
		}

		function mostrarTR(opcion){
		switch(opcion){
			case 1:{
				document.form1.FechaDesde.value = '';
				document.form1.FechaHasta.value = '';
				TR_Periodo.style.display = "";
				TR_FechaDesde.style.display  = "none";
				TR_FechaHasta.style.display  = "none";
				objForm.FechaHasta.required = false;
				objForm.FechaDesde.required = false;
			}
			break;
			case 2:{
				TR_Periodo.style.display = "none";
				TR_FechaDesde.style.display  = "";
				TR_FechaHasta.style.display  = "";
				objForm.FechaHasta.required = true;
				objForm.FechaDesde.required = true;
				objForm.FechaHasta.description = '#LB_FechaVence#';
				objForm.FechaDesde.description = '#LB_FechaRige#';
			}
			break;
		}	
	}
	
	function TacumuladoS(){
		var selected = document.getElementById("TAcumulado").value;

		switch(selected){
			case '2':{
				selected = '*';
			}
			break;
			case '3':{
				selected = 2 ;
			}
			break;
			case '4':{
				selected = 3 ;
			}
			break;
		}

		var select = document.getElementById("TNomina")
		select.options.length = 0;
		<cfloop query="rsTiposNomina">
			if(selected == '#Ttipopago#' || selected == '*'){
				var opt = document.createElement('option');
				opt.innerHTML='#Tdescripcion#';
				opt.value = '#Tcodigo#';
    			select.appendChild(opt);
			}
		</cfloop>
	}

	</script>
</cfoutput>
<cf_templatefooter>