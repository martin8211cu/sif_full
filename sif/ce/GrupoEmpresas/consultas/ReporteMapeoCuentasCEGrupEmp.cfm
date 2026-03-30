<cfinvoke key="LB_Titulo" default="Reporte de Cuentas de Mapeo por grupo de empresa" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteMapeoCuentasCEGrupEmp.xml"/>
<cfinvoke key="LB_ListaMapeoCuentas" default="Lista Agrupadores de Cuentas" returnvariable="LB_ListaMapeoCuentas" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteMapeoCuentasCEGrupEmp.xml"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteMapeoCuentasCEGrupEmp.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteMapeoCuentasCEGrupEmp.xml"/>
<cfinvoke key="LB_Mapeo" default="Mapeo de Cuentas" returnvariable="LB_Mapeo" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteMapeoCuentasCEGrupEmp.xml"/>
<cfinvoke key="LB_Detalle" default="Detalle Cuentas Mapeadas" returnvariable="LB_Detalle" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteMapeoCuentasCEGrupEmp.xml"/>
<cfinvoke key="LB_Cuentas" default="Cuentas sin Mapear" returnvariable="LB_Cuentas" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteMapeoCuentasCEGrupEmp.xml"/>
<cfinvoke key="LB_Excluidas" default="Cuentas excluidas" returnvariable="LB_Excluidas" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteMapeoCuentasCEGrupEmp.xml"/>
<cfinvoke key="LB_NoIncluidas" default="Cuentas no incluidas" returnvariable="LB_NoIncluidas" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteMapeoCuentasCEGrupEmp.xml"/>

<!---  --->
<cfinvoke key="MSG_Cuenta_Inicial" default="Cuenta Inicial" returnvariable="MSG_Cuenta_Inicial" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteMapeoCuentasCEGrupEmp.xml"/>
<cfinvoke key="MSG_Cuenta_Final" default="Cuenta Final" returnvariable="MSG_Cuenta_Final" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteMapeoCuentasCEGrupEmp.xml"/>
<!---  --->
<cfinvoke key="LB_Excluir" default="Excluir" returnvariable="LB_Excluir" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteMapeoCuentasCEGrupEmp.xml"/>
<cfinvoke key="LB_Reporte" default="Reporte" returnvariable="LB_Reporte" component="sif.Componentes.Translate" method="Translate" xmlfile="ReporteMapeoCuentasCEGrupEmp.xml"/>


<cfset LvarReporte1   = 'SQLReportMapeoCuentCEGE.cfm'>
<cfset LvarReporte2   = 'SQLReportMapeoCuentDetCEGE.cfm'>
<cfset LvarReporte3   = 'SQLReportCuentSinMapearCEGE.cfm'>
<cfset LvarReporte4   = 'SQLCuentExcluidasCEGE.cfm'><!---  --->
<cfset LvarReporte5   = 'SQLCuentSinMapearExcluidasCEGE.cfm'><!---  --->
<cfset LvarReporte6   = 'SQLCuentasNoIncluidasCEGE.cfm'><!--- Cuentas no incluidas --->

<!---Consulta para ver si la empresa esta configurada como empresa de eliminación --->
<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor,Pdescripcion
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = 1310
</cfquery>

<!--- Consulto el nombre de grupo de empresa de eliminacion --->
<cfquery name="rsnameGE" datasource="#Session.DSN#">
select
	top 1 GEnombre
	from AnexoGEmpresa a
	inner join CEMapeoGE  cem on a.GEid = cem.GEid
		and cem.Ecodigo = #Session.Ecodigo#
	inner join CEAgrupadorCuentasSAT cea on cem.Id_Agrupador = cea.CAgrupador and cea.Status = 'Activo'
</cfquery>

<cfset rem = '<>&"'>
<cfquery name="rsPer" datasource="#Session.DSN#" cachedwithin="#createtimespan(0,0,5,0)#">
		select distinct Speriodo as Eperiodo
		from CGPeriodosProcesados
		where Ecodigo = #session.Ecodigo#
		order by Eperiodo desc
	</cfquery>

	<cfquery name="rsMeses" datasource="sifControl" cachedwithin="#createtimespan(0,1,0,0)#">
		select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc
		from Idiomas a, VSidioma b
		where a.Icodigo = '#Session.Idioma#'
			and a.Iid = b.Iid
			and b.VSgrupo = 1
		order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
	</cfquery>
<!---cf_dump var="#replace(replace(replace(replace(rem,'&','&amp;','All'),'<','&lt;','All'),'>','&gt;','All'),'"','&quot;','All')#"--->

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<br>
		<cfif #rs.RecordCount#  EQ 0 or rs.Pvalor NEQ Session.Ecodigo><!--- Si no esta configurada como empresa de eliminación --->
			<cfoutput>
				<div style="margin:10px; text-align: center;" >
					Este proceso solo se puede usar en una Empresa que este configurada como Empresa de Eliminaci&oacute;n.
					<p style="font-size: 10px;">Porfavor realiza la configuracion.
						<a href="../../../../otrassol/consolidacion/Catalogos/ParametrosCtaEliminacion.cfm?_"><span style="color: blue;">Clic aqui</span></a>
					</p>
				<div>
			</cfoutput>
		<cfelse><!--- Si esta configurada como empresa de eliminación --->
		<cfoutput>
			<form name="form1" method="post" action="" onsubmit="return Valida();">
				<table width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr>
						<td>
							<input type="radio" name="Reporte" value="1" id="Reporte1" onclick="document.form1.action='#LvarReporte1#';hidden_idmapeo(this.value)">
							<label for="Reporte1">#LB_Mapeo#</label>
						</td>
						<td>
							<input type="radio" name="Reporte" value="2" id="Reporte2" onclick="document.form1.action='#LvarReporte2#';hidden_idmapeo(this.value)">
							<label for="Reporte2">#LB_Detalle#</label>
						</td>
						<td>
							<input type="radio" name="Reporte" value="3" id="Reporte3" onclick="hidden_idmapeo(this.value)">
							<label for="Reporte3">#LB_Cuentas#</label>
						</td>
						<td>
							<input type="radio" name="Reporte" value="4" id="Reporte4" onclick="document.form1.action='#LvarReporte4#';hidden_idmapeo(this.value)">
							<label for="Reporte4">#LB_Excluidas#</label>
						</td>
						<td><!--- Nueva Opcion --->
							<input type="radio" name="Reporte" value="5" id="Reporte5" onclick="document.form1.action='#LvarReporte6#';hidden_idmapeo(this.value)">
							<label for="Reporte5">#LB_NoIncluidas#</label>
						</td>
					</tr>
					<!---Filtros para cuentas sin mapear  --->
					<tr id="trXML" style="display:none">
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td colspan="3">
							<table style="margin-top:20px">
								<tr>
									<td>
										<label for="Reporte2">Periodo</label>
										<select name="periodo">
											<option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
											<cfloop query="rsPer">
												<option value="#Eperiodo#"
													<cfif isdefined("form.periodo") and form.periodo eq Eperiodo>selected</cfif>
												>
													#Eperiodo#
												</option>
											</cfloop>
										</select>
									</td>
									<td>
										<label for="Reporte3">Mes</label>
										<select name="mes">
											<option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
											<cfloop query="rsMeses">
												<option value="#VSvalor#"
													<cfif isdefined("form.mes") and form.mes eq VSvalor>selected</cfif>
												>
													#VSdesc#
												</option>
											</cfloop>
										</select>
									</td>
								</tr>
								<tr>
									<td><input type="radio" name="R_Excluidas" id="R_Excluidas" value="1" checked>
										<label>#LB_Reporte#</label>
									</td>
									<td><input type="radio" name="R_Excluidas" id="R_Excluidas" value="2">
										<label>#LB_Excluir#</label>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<!--- Campos para realizar filtros en Cuentas excluidas --->
					<tr id="hidden_exclu"  style="display:none">
						<td colspan="3">
						</td>
						<td nowrap colspan="2">
							<div><cfoutput>#MSG_Cuenta_Inicial#</cfoutput>:&nbsp;
								<cf_sifCuentasMayor form="form1" Cmayor="cmayor_ccuenta1" Cdescripcion="Cdescripcion1"
								size="50" tabindex="9">
							</div>
							<div><cfoutput>#MSG_Cuenta_Final#:</cfoutput>&nbsp;
								<cf_sifCuentasMayor form="form1" Cmayor="cmayor_ccuenta2" Cdescripcion="Cdescripcion2"
								size="50" tabindex="10">
							</div>
							<div style="padding:5px; font-size: 12px;"><strong>Nota:</strong> Si no se genera un filtro, la consulta se tardara varios minutos</div>
						</td>
					</tr>
					<!--- Fin filtros en Cuentas excluidas --->
					<tr>
						<td colspan="5">&nbsp;</td>
					</tr>
					<tr id="idmapeo">
						<td>&nbsp;</td>
						<td align="right" ><strong><cf_translate key=LB_Mapeo>Mapeo</cf_translate>:</strong>&nbsp;</td>
						<td align="left" colspan="3">
								<!--- Con el inner join CEMapeoGE verificamos que los mapeos
								consultados tenga una empresa configurada como empresa de eliminacion --->
								<cf_conlis
									Campos="Id_Agrupador, CAgrupador, Descripcion"
									Desplegables="N,S,S"
									Modificables="N,S,N"
									Size="0,10,65"
									tabindex="1"
									Title="#LB_ListaMapeocuentas#"
									Tabla="CEAgrupadorCuentasSAT cea inner join CEMapeoGE cem on cea.CAgrupador = cem.Id_Agrupador and cem.Ecodigo = #Session.Ecodigo#"
									Columnas="cea.Id_Agrupador, cea.CAgrupador, cea.Descripcion"
									Filtro= "cea.Status = 'Activo'"
									Desplegar="CAgrupador, Descripcion"
									Etiquetas="#LB_Codigo#, #LB_Nombre#"
									filtrar_por="CAgrupador, Descripcion"
									Formatos="S,S"
									Align="left,left"
									form="form1"
									Asignar="Id_Agrupador, CAgrupador, Descripcion"
									Asignarformatos="S,S,S"
									/>
						</td>
					</tr>
					<cfif #rsnameGE.RecordCount#  GT 0><!--- Mostramos nombre de grupo de empresa --->
					<tr>
						<td colspan="5">
							<p style="font-size: 10px; text-align: center; font-weight:bold;">GRUPO DE EMPRESA: #rsnameGE.GEnombre#</p>
						</td>
					</tr>
					</cfif>
					<tr>
						<td colspan="5">
						<cfif #rsnameGE.RecordCount#  GT 0><!--- Desactivamos boton --->
							<cf_botones values="Generar" tabindex="1">
						<cfelse>
							<p style="font-size: 11px; text-align: center;">Nota: Falta asignar al grupo de empresas</p>
						</cfif>
						</td>
					</tr>
				</table>
			</form>
		</cfoutput>
		</cfif><!--- Fin del if empresa de eliminación --->
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript" type="text/javascript">
	 //Actualizado 21/04/2015
 	function funcGenerar(){
		var res;
 		var resultado="ninguno";
 		var aux;

		// Recorremos todos los valores del radio button para encontrar el
        // seleccionado
        var porNombre=document.getElementsByName("Reporte");
        for(var i=0;i<porNombre.length;i++){
            if(porNombre[i].checked)
                resultado=porNombre[i].value;
        }
        //Cuentas sin mapear
        if(resultado == 3){
        	var rbt = document.getElementById("R_Excluidas");
 			if(rbt.checked){
 				form1.action = 'SQLReportCuentSinMapearCEGE.cfm';
 			}
 			else{
 				form1.action = 'SQLCuentSinMapearExcluidasCEGE.cfm';
 			}

        }
		//Cuando se elige cuentas excluidas
		if(resultado == 4 || resultado == 5){
			res = true;
		}else{
			//Se muestra el mensaje, que es necesario seleccionar el campo CAgrupador para la consulta
			if(document.getElementById("CAgrupador").value == ''){
				alert('Debes de seleccionar un mapeo');
				res= false;
			}
		 }
		return res;
	}

	function toggleit(str){
		var temp = str;
		var element =  document.getElementById('trXML');
			if (typeof(element) != 'undefined' && element != null){
				  if ((temp == 3)) {
				  		document.getElementById('trXML').style.display = ''
				  		//event.preventDefault();
			      } else {
			            document.getElementById('trXML').style.display = 'none';
			            //event.preventDefault();
			      }
			} else {
					//alert('Elemento no encontrado')	;
			}
	}
	 //Creado 17/04/2015
	 //Metodo para ocultar y mostrar etiquetas
	function hidden_idmapeo(v1){
		var elemento = v1;

		if(elemento==4){
			document.getElementById('idmapeo').style.display = 'none';
			document.getElementById('trXML').style.display = 'none';
			document.getElementById('hidden_exclu').style.display = '';
			document.getElementById('Msg_C_Mapear').style.display = 'none';
		}
		if(elemento==3){
			document.getElementById('trXML').style.display = '';
			document.getElementById('idmapeo').style.display = '';
			document.getElementById('hidden_exclu').style.display = 'none';
			document.getElementById('Msg_C_Mapear').style.display = '';
		}
		if(elemento==1){
			document.getElementById('trXML').style.display = 'none';
			document.getElementById('idmapeo').style.display = '';
			document.getElementById('hidden_exclu').style.display = 'none';
			document.getElementById('Msg_C_Mapear').style.display = 'none';
		}if(elemento==2){
			document.getElementById('trXML').style.display = 'none';
			document.getElementById('idmapeo').style.display = '';
			document.getElementById('hidden_exclu').style.display = 'none';
			document.getElementById('Msg_C_Mapear').style.display = 'none';
		}if(elemento==5){
			document.getElementById('trXML').style.display = 'none';
			document.getElementById('idmapeo').style.display = 'none';
			document.getElementById('hidden_exclu').style.display = 'none';
			document.getElementById('Msg_C_Mapear').style.display = 'none';
		}

	}


</script>