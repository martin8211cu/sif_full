<cf_templateheader title="Par&aacute;metros Generales Interfaz">
	<cf_web_portlet_start titulo="Par&aacute;metros Generales Interfaz">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfset lvarCambio = false>

		<cfquery name="rsParametros" datasource="sifinterfaces">
			SELECT * FROM SIFLD_ParametrosAdicionales
			WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
			ORDER BY Pcodigo, Pdescripcion
		</cfquery>

		<cfquery name="rsMaxParametros" datasource="sifinterfaces">
			SELECT
			  COALESCE(MAX(Pcodigo), 0) + 1 AS maxPcodigo
			FROM SIFLD_ParametrosAdicionales
			WHERE Ecodigo = 1
		</cfquery>

		<cfif rsMaxParametros.RecordCount GT 0>
			<cfif LEN(rsMaxParametros.maxPcodigo) EQ 1>
				<cfset lVarMaxId = "0000"&rsMaxParametros.maxPcodigo>
			<cfelseif LEN(rsMaxParametros.maxPcodigo) EQ 2>
				<cfset lVarMaxId = "000"&rsMaxParametros.maxPcodigo>
			<cfelseif LEN(rsMaxParametros.maxPcodigo) EQ 3>
				<cfset lVarMaxId = "00"&rsMaxParametros.maxPcodigo>
			<cfelseif LEN(rsMaxParametros.maxPcodigo) EQ 4>
				<cfset lVarMaxId = "0"&rsMaxParametros.maxPcodigo>
			<cfelse>
			<cfset lVarMaxId = rsMaxParametros.maxPcodigo>
			</cfif>
		</cfif>

		<cfoutput>
			<form method="post" name="form1" id="form1" action="ParametrosGeneralesInterfaz.cfm">
				<cfif isDefined("form.pcodigo") AND form.pcodigo NEQ "">
					<cfset lvarCambio = true>
				</cfif>
				<input type="hidden" name="modo" id="modo" value="<cfif isDefined("form.modo")>#form.modo#</cfif>">

				<cfif isdefined("form.botonSel") AND #form.botonSel# EQ "btnNuevo" OR lvarCambio EQ true>
					<table border="0" width="60%" align="center">
						<tr>
							<td align="right"><strong>C&oacute;digo:&nbsp;&nbsp;</strong></td>
							<td><input type="text" name="codigo" id="codigo" maxlength="5" onkeypress="return soloNumeros(event)" value="<cfif #lvarCambio# EQ true>#form.pcodigo#<cfelse>#lVarMaxId#</cfif>" <cfif #lvarCambio# EQ true>readonly="true"</cfif> ></td>
							<td rowspan="4" width="35%" align="left">
								&nbsp;&nbsp;<input type="button" class="btnGuardar" name="btnGuardar" id="btnGuardar" value="Guardar" onclick="<cfif #lvarCambio# EQ true>validarUpdate();<cfelse>validar();</cfif>">&nbsp;
								<cfif #lvarCambio# EQ true>
									<br>
									<input type="button" class="btnEliminar" name="btnEliminar" id="btnEliminar" value="Eliminar" onclick="validaDelete();">&nbsp;
								</cfif>
							</td>
						</tr>
						<cfif isDefined("form.Pcodigo") AND #form..Pcodigo# EQ '00002'>
							<tr>
								<td align="right"><strong>Activo:&nbsp;&nbsp;</strong></td>
								<td><input type="checkbox" name="valor" id="valor" <cfif isDefined("form.pvalor") AND form.pvalor EQ "1">checked</cfif>></td>
							</tr>
						<cfelse>
							<tr>
								<td align="right"><strong>Valor:&nbsp;&nbsp;</strong></td>
								<td><input type="text" name="valor" id="valor" value="<cfif isDefined("form.pvalor") AND form.pvalor NEQ "">#form.pvalor#</cfif>"></td>
							</tr>
						</cfif>
						<tr>
							<td align="right"><strong>Descripci&oacute;n:&nbsp;&nbsp;</strong></td>
							<td><textarea rows="2" cols="40" name="descripcion" id="descripcion"><cfif isDefined("form.pdescripcion") AND form.pdescripcion NEQ "">#form.pdescripcion#</cfif></textarea></td>
						</tr>
						<tr>
							<td align="right"><strong>Observaciones:&nbsp;&nbsp;</strong></td>
							<td><textarea rows="2" cols="40" name="observaciones" id="observaciones"><cfif isDefined("form.pobservaciones") AND form.pobservaciones NEQ "">#form.pobservaciones#</cfif></textarea></td>
						</tr>
					</table>
				<cfelseif isDefined("form.modo") AND (form.modo EQ "Guardar" OR form.modo EQ "Update" OR form.modo EQ "Delete")>
					<cfinclude template="ParametrosGeneralesInterfaz_sql.cfm">
				<cfelse>
					<table border="0" width="80%" align="center">
						<tr>
							<td>
								<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
								          query="#rsParametros#"
										  maxrows="0"
										  desplegar="Pcodigo, Pvalor, Pdescripcion, Pobservaciones"
										  etiquetas="C&oacute;digo, Valor, Descripci&oacute;n, Observaciones"
										  formatos="S,S,S,S"
										  align="left,left,left,left"
										  ira="ParametrosGeneralesInterfaz.cfm"
										  form_method="post"
										  showEmptyListMsg="yes"
										  mostrar_filtro="true"
										  keys="Pcodigo"
										  botones="Nuevo"
										  formName="form1"
										  width="50%"
								/>
							</td>
						</tr>
					</table>
				</cfif>

				<br>

			</form>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>

<!--- VALIDACIONES JAVASCRIPT --->
<script language="javascript1.2" type="text/javascript">
	function validar(){
		var valor = document.getElementById('valor').value;
		var descripcion = document.getElementById('descripcion').value;

		if(valor == ""){
			alert('Favor de ingresar el valor del parámetro!')
		} else if (descripcion === ""){
			alert('Favor de ingresar la descripción del parámetro!')
		} else {
		    document.getElementById('modo').value = "Guardar";
			document.getElementById('form1').submit();
		}
	}

	function validarUpdate(){
		var valor = document.getElementById('valor').value;
		var descripcion = document.getElementById('descripcion').value;

		if(valor == ""){
			alert('Favor de ingresar el valor del parámetro!')
		} else if (descripcion === ""){
			alert('Favor de ingresar la descripción del parámetro!')
		} else {
		    document.getElementById('modo').value = "Update";
			document.getElementById('form1').submit();
		}
	}

	function validaDelete(){
		if(confirm("¿Desea eliminar el parámetro?")){
			document.getElementById('modo').value = "Delete";
			document.getElementById('form1').submit();
		}
	}

	function soloNumeros(evt) {
		//asignamos el valor de la tecla a keynum
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