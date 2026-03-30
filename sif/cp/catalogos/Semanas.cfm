<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TITULO = t.Translate('LB_TITULO','Semanas para pron&oacute;stico de pagos','/sif/Semanas.xml')>
<cfset LB_ANIO = t.Translate('LB_ANIO','A&ntilde;o','/sif/Semanas.xml')>
<cfset LB_SEMANA = t.Translate('LB_SEMANA','Semana','/sif/Semanas.xml')>
<cfset LB_FECHA_INICIO = t.Translate('LB_FECHA_INICIO','Fecha Inicial','/sif/Semanas.xml')>
<cfset LB_FECHA_FIN = t.Translate('LB_FECHA_FIN','Fecha Final','/sif/Semanas.xml')>

<cfquery datasource="#session.dsn#" name="lista">
	SELECT * FROM CPSemanaPronostico
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	<cfif isdefined("form.filtro_Anio") AND TRIM(form.filtro_Anio) NEQ "">
		AND Anio LIKE '%#form.filtro_Anio#%'
	</cfif>
	<cfif isdefined("form.filtro_NoSemana") AND TRIM(form.filtro_NoSemana) NEQ "">
		AND NoSemana LIKE '%#form.filtro_NoSemana#%'
	</cfif>
	<cfif isdefined("form.filtro_FechaInicio") AND TRIM(form.filtro_FechaInicio) NEQ "">
		<cfset FechaIni = form.filtro_FechaInicio.Split("/")>
		<cfset FechaIni = FechaIni[3]&"-"&FechaIni[2]&"-"&FechaIni[1]>
		AND FechaInicio = <cfqueryparam cfsqltype="cf_sql_date" value="#FechaIni#">
	</cfif>
	<cfif isdefined("form.filtro_FechaFin") AND TRIM(form.filtro_FechaFin) NEQ "">
		<cfset FechaFi = form.filtro_FechaFin.Split("/")>
		<cfset FechaFi = FechaFi[3]&"-"&FechaFi[2]&"-"&FechaFi[1]>
		AND FechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(FechaFi, "yyyy-mm-dd")#">
	</cfif>
	ORDER BY FechaInicio DESC
</cfquery>

<cf_templateheader title="#LB_TITULO#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TITULO#'>
		<cfoutput>
			<br>
			<!--- FORM NUEVO/CAMBIO--->
			<cfif isdefined("form.btnNuevo") OR isdefined("form.btnModificar") OR (isdefined("form.modo") AND #form.modo# EQ 'CAMBIO')>
				<form action="" method="post" name="form1" id="form1">
					<table width="50%" cellpadding="5" align="center" border="0">
						<tr>
							<td class="fileLabel" align="right"><strong>#LB_ANIO#:&nbsp;</strong></td>
							<td>
								<cfif isDefined("form.Anio") AND TRIM(form.Anio) NEQ "">
									#form.Anio#
								<cfelse>
									<select id="cboAnio" name="cboAnio" default="-1">
										<option value="-1">--- Seleccione ---</option>
										<option value="#Year(now())+2#">#Year(now())+2#</option>
										<option value="#Year(now())+1#">#Year(now())+1#</option>
										<option value="#Year(now())#" Selected>#Year(now())#</option>
										<cfloop from="1" to="5" index="i" step="1">
											<cfset anioOption = #Year(now())#-#i#>
											<option value="#anioOption#">#anioOption#</option>
										</cfloop>
									</select>
								</cfif>

							</td>
							<td rowspan="4" align="center">
								<cfif isdefined("form.modo") AND #form.modo# EQ "CAMBIO">
									<input name="btnModificar" class="btnModificar" type="button" id="btnModificar" onclick="validaDatosU();" value="Modificar">
									<br>
									<input name="btnEliminar" class="btnEliminar" type="button" id="btnEliminar" onclick="eliminarSem();" value="Eliminar">
								<cfelse>
									<input name="btnRegistrar" class="btnNuevo" type="button" id="btnRegistrar" onclick="validaDatos();" value="Registrar">
								</cfif>
							</td>
						</tr>
						<tr>
							<td align="right"><strong>#LB_SEMANA#:&nbsp;</strong></td>
							<td>
								<cfif isDefined("form.NoSemana") AND TRIM(form.NoSemana) NEQ "">
									#form.NoSemana#
									<input type="hidden" name="idSemana" id="idSemana" value="#form.IdSemana#">
								<cfelse>
									<input type="text" size="10" name="semana" id="semana" onkeypress="return soloNumeros(event)">
								</cfif>
							</td>
						</tr>
						<tr>
							<td align="right"><strong>#LB_FECHA_INICIO#:&nbsp;</strong></td>
							<td>
								<cfif isdefined("form.FechaInicio") AND TRIM(form.FechaInicio) NEQ "">
									<cf_sifcalendario name="fechaInicio" value="#LSDateFormat(form.FechaInicio,'dd/mm/yyyy')#">
								<cfelse>
									<cf_sifcalendario name="fechaInicio" value="#LSDateFormat(now(),'dd/mm/yyyy')#">
								</cfif>
							</td>
						</tr>
						<tr>
							<td align="right"><strong>#LB_FECHA_FIN#:&nbsp;</strong></td>
							<td>
								<cfif isdefined("form.FechaFin") AND TRIM(form.FechaFin) NEQ "">
									<cf_sifcalendario name="fechaFin" value="#LSDateFormat(form.FechaFin,'dd/mm/yyyy')#">
								<cfelse>
									<cf_sifcalendario name="fechaFin" value="#LSDateFormat(now(),'dd/mm/yyyy')#">
								</cfif>
							</td>
						</tr>
					</table>
				</form>
			<cfelse>
				<table width="60%" cellpadding="5" align="center" border="0">
					<tr>
						<td>
							<!--- PLISTAS --->
							<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
								query="#lista#"
								maxrows="0"
								desplegar="Anio, NoSemana, FechaInicio, FechaFin"
								etiquetas="#LB_ANIO#, #LB_SEMANA#, #LB_FECHA_INICIO#, #LB_FECHA_FIN#"
								formatos="I,S,D,D"
								align="left,left,left,left"
								ira="Semanas.cfm"
								form_method="post"
								showEmptyListMsg="yes"
								mostrar_filtro="true"
								keys="IdSemana"
								botones="Nuevo"
								formName="form1"
								width="60%"
							/>
						</td>
					</tr>
				</table>
			</cfif>

			<br>

		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>

<!--- VALIDACIONES JAVASCRIPT --->
<script language="javascript1.2" type="text/javascript">
	function filtrar_Plista(){
		<cfset form.modo = "FILTRO">
		document.getElementById('form1').submit();
	}
	<!--- Funcion para eliminar semana, por ajax --->
	function eliminarSem(){
		if (confirm("¿Desea eliminar la semana?")) {
			<cfoutput>
				$.ajax({
			        method: "post",
			        url: "ajaxSemanas.cfc",
			        async: false,
			        data: {
			            method: "deleteSemana",
			            returnFormat: "JSON",
			            idSemana: document.form1.idSemana.value,
			        },
			        dataType: "json",
			        success: function(obj) {
			            if (obj.MSG == 'deleteOK') {
			                alert('Semana eliminada correctamente!');
			                document.getElementById('form1').submit();
			            } else {
			                alert(obj.MSG);
			            }
			        }
			    });
			</cfoutput>
		}
	}

	<!--- Valida los datos para insertar --->
	function validaDatos(){
		var anio = document.getElementById('cboAnio').value;
		var semana = document.getElementById('semana').value;
		var fechaInicio = document.getElementById('fechaInicio').value;
		var fechaFin = document.getElementById('fechaFin').value;
		if(anio == -1){
			alert("Favor de seleccionar el año!")
		} else if(semana > 54){
			alert("La semana no puede ser superior a 54!")
		} else if(semana == ""){
			alert("Favor de ingresar el número de semana!")
		} else if(fechaInicio == ""){
			alert("Favor de ingresar la fecha inicio!")
		} else if(fechaFin == ""){
			alert("Favor de ingresar la fecha fin!")
		} else {
			if(validaFechas(fechaInicio, fechaFin)){
				insertSemana();
			}
		}
	}

	<!--- Valida los datos para actualizar --->
	function validaDatosU(){
		var fechaInicio = document.getElementById('fechaInicio').value;
		var fechaFin = document.getElementById('fechaFin').value;
		if(fechaInicio == ""){
			alert("Favor de ingresar la fecha inicio!")
		} else if(fechaFin == ""){
			alert("Favor de ingresar la fecha fin!")
		} else {
			if(validaFechas(fechaInicio, fechaFin)){
				updateSemana();
				return false;
			}
		}
	}

	<!--- Valida la fecha inicio y fin, que la primera no sea mayor a la segunda --->
	function validaFechas(fechaInicio, fechaFin){
			var Fecha_Inicio = fechaInicio.split("/");
 			var FechaI = new Date(parseInt(Fecha_Inicio[2]),parseInt(Fecha_Inicio[1]-1),parseInt(Fecha_Inicio[0]));
 			var Fecha_Fin = fechaFin.split("/");
 			var FechaF = new Date(parseInt(Fecha_Fin[2]),parseInt(Fecha_Fin[1]-1),parseInt(Fecha_Fin[0]));
 			if(FechaI > FechaF){
 				alert('La fecha inicio no puede ser mayor a la fecha fin!')
 				return false;
 			} else {
 				return true;
 			}
	}

	function fechaSql(fecha){
		var fecha_split = fecha.split("/");
		var fecha_Format = fecha_split[2] + '-' + fecha_split[1] + '-' + fecha_split[0];
		return fecha_Format;
	}

	<!--- Inserta por Ajax, la semana --->
	function insertSemana() {
		<cfoutput>
			$.ajax({
		        method: "post",
		        url: "ajaxSemanas.cfc",
		        async: false,
		        data: {
		            method: "insertSemana",
		            returnFormat: "JSON",
		            anio: document.form1.cboAnio.value,
		            semana: document.form1.semana.value,
		            fechaInicio: fechaSql(document.form1.fechaInicio.value),
		            fechaFin: fechaSql(document.form1.fechaFin.value),
		        },
		        dataType: "json",
		        success: function(obj) {
		            if (obj.MSG == 'InsertOK') {
		                alert('Semana guardada correctamente!');
		                document.getElementById('form1').submit();
		            } else {
		                alert(obj.MSG);
		            }
		        }
		    });
		</cfoutput>
	}

	<!--- Actualiza por Ajax, la semana --->
	function updateSemana() {
		<cfoutput>
			$.ajax({
		        method: "post",
		        url: "ajaxSemanas.cfc",
		        async: false,
		        data: {
		            method: "updateSemana",
		            returnFormat: "JSON",
		            idSemana: document.form1.idSemana.value,
		            fechaInicio: fechaSql(document.form1.fechaInicio.value),
		            fechaFin: fechaSql(document.form1.fechaFin.value),
		        },
		        dataType: "json",
		        success: function(obj) {
		            if (obj.MSG == 'updateOK') {
		                alert('Semana actualizada correctamente!');
		                document.getElementById('form1').submit();
		            } else {
		                alert(obj.MSG);
		            }
		        }
		    });
		</cfoutput>
	}

	function soloNumeros(evt) {
		if (window.event) {// IE
			keynum = evt.keyCode;
		} else {
			keynum = evt.which;
		}
		//comprobamos si se encuen­tra en el rango
		if (keynum > 47 && keynum < 58 || keynum == 8) {
			return true;
		} else {
			return false;
		}
	}
</script>