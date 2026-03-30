<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" 
xmlfile ="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Identificacion" default="Identificacion" returnvariable="LB_Identificacion" 
xmlfile ="GEReportes_filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" xmlfile ="GEReportes_filtro.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TituloLista" default="Lista Empleados" returnvariable="LB_TituloLista" xmlfile ="GEReportes_filtro.xml"/>

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<form  action="" method="post" name="form1" id="form1">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select llave as DEid
			from UsuarioReferencia
			where Ecodigo= #session.Ecodigo#
			and STabla	= 'DatosEmpleado'
		</cfquery>
		<cfset LvarDEID=#rsSQL.DEid#>
		
		<!---Query para la el combo de las cajas--->
		<cfquery  name="rsCajaChica" datasource="#session.dsn#">
			select 
				c.CCHid,
				c.CCHdescripcion,
				c.CCHcodigo,
				m.Miso4217
			from CCHica c
				inner join Monedas m
					on m.Mcodigo=c.Mcodigo
			where c. Ecodigo=#session.Ecodigo#
			and c.CCHestado='ACTIVA'
		</cfquery>
	
			<table width="100%">

				<tr>
				  <td nowrap="nowrap" align="right"><strong><cf_translate key=LB_Empleado>Empleado</cf_translate>: </strong> </td>
				  <td align="left"> 
					  <cf_conlis title="#LB_TituloLista#"
					campos = "DEid, DEidentificacion, DEnombre" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,15,34"
					asignar="DEid, DEidentificacion, DEnombre"
					asignarformatos="S,S,S"
					tabla="DatosEmpleado"
					columnas="DEid, DEidentificacion, DEnombre #LvarCNCT#' '#LvarCNCT# DEapellido1 #LvarCNCT#' '#LvarCNCT# DEapellido2 as DEnombre"
					filtro="Ecodigo = #Session.Ecodigo#"
					desplegar="DEidentificacion, DEnombre"
					etiquetas="#LB_Identificacion#,#LB_Nombre#"
					formatos="S,S"
					align="left,left"
					showEmptyListMsg="true"
					EmptyListMsg=""
					form="form1"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="DEidentificacion,DEnombre"
					index="1"			
					traerInicial="#LvarDEID NEQ ''#"
					traerFiltro="DEid=#LvarDEid#"
					funcion="funcCambiaDEid"
					fparams="DEid"
					/>   
				 	</td>
				</tr>
				<tr>
					<td align="right" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_Estado>Estado</cf_translate>:</strong></td>
					<td align="left" valign="top"nowrap="nowrap">
						<select name="AFTRtipo" id="AFTRtipo" tabindex="1">
						<option value="-1"><cf_translate key=LB_Todos>TODOS</cf_translate></option>
						<option value="0"><cf_translate key=LB_EnPreparacion>En Preparación</cf_translate></option>
						<option value="1"><cf_translate key=LB_EnAprobacion>En Aprobación</cf_translate></option>
						<option value="2"><cf_translate key=LB_Aprobadas>Aprobadas</cf_translate></option>
						<option value="3"><cf_translate key=LB_Rechazadas>Rechazadas</cf_translate></option>
						<option value="4"><cf_translate key=LB_Finalizada>Finalizada</cf_translate></option>
						<option value="5"><cf_translate key=LB_PorReintegrar>Por Reintegrar</cf_translate></option>
						<option value="4"><cf_translate key=LB_Pagada>Pagada</cf_translate></option>
						<option value="5"><cf_translate key=LB_Liquidada>Liquidada</cf_translate></option>
						<option value="6"><cf_translate key=LB_Terminada>Terminada</cf_translate></option>
						</select>			
				  </td>
				</tr>
				<tr>
					<td align="right" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_FormaPago> Forma de Pago</cf_translate>:</strong></td>
					<td align="left" valign="top"nowrap="nowrap">
						<select name="FormaPago" id="FormaPago">
						<option value="">--</option>
						<option value="0"><cf_translate key=LB_Tesoreria>Tesoreria</cf_translate> </option>
						<cfif rsCajaChica.RecordCount>
							<cfoutput query="rsCajaChica" group="CCHid">
								<option value="#rsCajaChica.CCHid#">#rsCajaChica.CCHcodigo#/#rsCajaChica.CCHdescripcion#-#rsCajaChica.Miso4217#</option>
							</cfoutput>
						</cfif>                       
						</select>
					</td>
				</tr>
				<tr>
				<cfset fechainicial=DateFormat(Now(),'DD/MM/YYYY')>
					<td align="right" nowrap="nowrap"><strong><cf_translate key=LB_FechaDesde>Fecha desde</cf_translate>:</strong></td>
					<td><cf_sifcalendario name="desde" value="#fechainicial#" tabindex="1"></td>
				</tr>
				<tr>
				<cfset fechafinal=DateFormat(Now(),'DD/MM/YYYY')>
					<td align="right" nowrap="nowrap"><strong><cf_translate key =LB_FechaHasta>Fecha hasta</cf_translate>:</strong></td>
					<td><cf_sifcalendario name="hasta"  value="#fechafinal#" tabindex="1"></td>
				</tr>
				<tr><td align="center" colspan="5">
                	<cfoutput><input type="button" value="#BTN_Consultar#" name="Generar" id="Generar" onclick="return sbSubmit(this);"/></cfoutput>
                </td></tr>
			</table>
	
	</form>
<script language="javascript">
	function sbSubmit()
	{
		/*validar();*/
		var x=validar();
		if (x == false){
		return false;
		}
		else{
		if (document.form1.DEid.value == "")
		{
			document.form1.action = "GEReportes_form.cfm";
		}
		else
		{	
			<cfoutput>
			document.form1.action = "ReporteTramitesform.cfm?LvarSAporEmpleadoSolicitante=#LvarSAporEmpleadoSolicitante#&LvarCFM=#LvarCFM#";
			</cfoutput>
		}
		
		document.form1.submit();
		}
	}
	function validar()
	{
		var error_input;
      	var error_msg = '';

		if (document.form1.AFTRtipo.value != 0 && document.form1.AFTRtipo.value != 1 && document.form1.DEid.value=="")
		{	
			if (document.form1.desde.value == "")
			{
				error_msg += "\n - La Fecha Desde no puede quedar en blanco.";
				error_input = document.form1.desde;
			}
			if (document.form1.hasta.value == "")
			{
				error_msg += "\n - La Fecha Hasta no puede quedar en blanco.";
				error_input = document.form1.hasta;
			}
		}
		
		if (error_msg.length != "")
		{
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
		
	}
</script>