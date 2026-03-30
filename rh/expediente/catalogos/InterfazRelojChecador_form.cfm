<cfinvoke Default="Interfaz de Reloj Checador" returnvariable="nombre_proceso" component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" VSgrupo="103"/>
<cfinvoke Default="Seleccione su Archivo" returnvariable="LB_SeleccioneArchivo" component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" VSgrupo="103"/>
<cfinvoke key="LB_No_se_encontraron_registros" default="No se encontraron registros"	 xmlfile="/rh/generales.xml" returnvariable="vNoRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Desde" default="Desde"	 xmlfile="/rh/generales.xml" returnvariable="vDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Hasta" default="Hasta"	 xmlfile="/rh/generales.xml" returnvariable="vHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nomina" default="Calendario de Pago" xmlfile="/rh/nomina/consultas/AcumuladoNomina.xml"	 returnvariable="vRelacion" component="sif.Componentes.Translate" method="Translate"/>

<cfif IsDefined('form.ProcesoTerminado')>
	<script>
		alert('Proceso Completado');
	</script>
</cfif>
<cf_templateheader title="#nombre_proceso#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" titulo="<cfoutput>#nombre_proceso#</cfoutput>" skin="#Session.Preferences.Skin#">

		<form name="form1" method="post" action="InterfazRelojChecador_sql.cfm" enctype="multipart/form-data">
			<table align="center" border="0">
				<tr>
					<td align="right"><cf_translate key="LB_Archivo"><strong>Archivo:</strong></cf_translate>&nbsp;</td>
					<td nowrap="nowrap">
						<input name="archivo" type="file" id="archivo">
						<!---
							<input size="1" style="border:none;" onclick="if (this.value == '*') this.form.importar.disabled = false;">
						 --->
					</td>
				</tr>
				<cfquery name="rsTNoms" datasource="#session.dsn#">
					select
						Tcodigo,
						Tdescripcion
					from
						TiposNomina
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					order by Tcodigo
				</cfquery>
				<cfoutput>
				<tr>
					<td align="right"><cf_translate key="LB_Archivo"><strong>Tipo N&oacute;mina:</strong></cf_translate>&nbsp;</td>
					<td>
						<select name="cboTN" id="cboTN" onChange="javascript: validaTN(this);">
							<cfloop query="rsTNoms">
								<option value="#Trim(Tcodigo)#">#Trim(Tdescripcion)#</option>
							</cfloop>
						</select>
					</td>
				</tr>

				<tr id="id_Temp">
					<td align="right" valign="middle"><strong>#vRelacion#:&nbsp;</strong>&nbsp;</td>
					<td>
						<cf_conlis
							campos="TCPid,TCPcodigo,TCPdesde,TCPhasta,TTcodigo"
							desplegables="N,S,N,N,N"
							modificables="N,N,N,N,N"
							size="0,31,15,15,0"
							title="Lista de Calendarios de Pago"
							tabla="CalendarioPagos cp inner join TiposNomina tn on tn.Tcodigo = cp.Tcodigo"
							columnas="cp.CPid as TCPid,cp.CPcodigo as TCPcodigo,cp.CPdesde as TCPdesde,cp.CPhasta as TCPhasta,cp.Tcodigo as TTcodigo,concat(tn.Tcodigo,' ',tn.Tdescripcion) TTdescripcion"
							filtro="cp.Ecodigo = #session.Ecodigo# and cp.CPfcalculo is null and cp.Tcodigo='02' order by cp.CPdesde"
							desplegar="TCPcodigo,TCPdesde,TCPhasta,TTcodigo"
							filtrar_por="TCPcodigo,TCPdesde,TCPhasta"
							etiquetas="#vRelacion#"
							formatos="S,S,S,S"
							asignar="TCPid,TCPcodigo,TCPdesde,TCPhasta,TTcodigo"
							asignarformatos="S,S,S,S"
							showEmptyListMsg="true"
							EmptyListMsg="-- #vNoRegistros# --"
							alt="#vRelacion#">
					</td>
				</tr>

				<tr id="id_Sem">
					<td align="right" valign="middle"><strong>#vRelacion#:&nbsp;</strong>&nbsp;</td>
					<td>
						<cf_conlis
							campos="CPid,CPcodigo,CPdesde,CPhasta,Tcodigo"
							desplegables="N,S,N,N,N"
							modificables="N,N,N,N,N"
							size="0,31,15,15,0"
							title="Lista de Calendarios de Pago"
							tabla="CalendarioPagos cp inner join TiposNomina tn on tn.Tcodigo = cp.Tcodigo"
							columnas="cp.CPid,cp.CPcodigo,cp.CPdesde,cp.CPhasta,cp.Tcodigo,concat(tn.Tcodigo,' ',tn.Tdescripcion) Tdescripcion"
							filtro="cp.Ecodigo = #session.Ecodigo# and cp.CPfcalculo is null and cp.Tcodigo='01' order by cp.CPdesde"
							desplegar="CPcodigo,CPdesde,CPhasta,Tcodigo"
							filtrar_por="CPcodigo,CPdesde,CPhasta"
							etiquetas="##"
							formatos="S,S,S,S"
							asignar="CPid,CPcodigo,CPdesde,CPhasta,Tcodigo"
							asignarformatos="S,S,S,S"
							showEmptyListMsg="true"
							EmptyListMsg="-- #vNoRegistros# --"
							alt="#vRelacion#">
					</td>
				</tr>
				</cfoutput>
				<tr>
					<td colspan="2" align="center">
						<input type="submit" name="btnProcesar" value="Procesar" id="btnProcesar">
					</td>
				</tr>
			</table>
		</form>
<cf_qforms>
<script type="text/javascript" language="javascript1.2">

	objForm.archivo.required = true;
	objForm.archivo.description = 'Archivo de Reloj Checador';

	objForm.cboTN.required = true;
	objForm.cboTN.description = 'Tipo de Nomina';

	validaTN(document.getElementById('cboTN'));
	function validaTN(obj)
	{
		var objSel = obj.value;
		if(objSel.trim() == '01')
		{
			document.getElementById('id_Sem').style.display = '';
			document.getElementById('id_Temp').style.display = 'none';
			objForm.CPid.required = true;
			objForm.CPid.description = 'Nomina Semanal';
			objForm.TCPid.required = false;
			objForm.TCPid.description = '';
		}
		else if(objSel.trim() == '02')
		{
			document.getElementById('id_Temp').style.display = '';
			document.getElementById('id_Sem').style.display = 'none';
			objForm.CPid.required = false;
			objForm.CPid.description = '';
			objForm.TCPid.required = true;
			objForm.TCPid.description = 'Nomina Temporal';
		}
	}

</script>
	<cf_web_portlet_end>
<cf_templatefooter>