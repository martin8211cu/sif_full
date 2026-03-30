<cfset modo = 'ALTA'>
<cfif isdefined("form.CDcodigo") and len(trim(form.CDcodigo))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select CDdescripcion
		from ClasificacionesDato
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Ccodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
		  and CDcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDcodigo#">
	</cfquery>
</cfif>

<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<script language="javascript1.2" type="text/javascript"  >
	var valida  = true;
	var validaD = false;

	function validar(){
		var error = false;
		var mensaje = "Se presentaron los siguientes errores:\n";
		if (valida){
			// Validacion de Encabezado	
			if ( trim(document.form1.CDdescripcion.value) == '' ){
				error = true;
				mensaje += " - El campo Descripción es requerido.\n";
			}
		}
		
		if (validaD){
			// Validacion de Encabezado	
			if ( trim(document.form1.CVvalor.value) == '' ){
				error = true;
				mensaje += " - El campo Valor es requerido.\n";
			}
		}

		if ( error ){
			alert(mensaje);
			return false;
		}
		
		return true;
	}

	function nuevo(valor){
		document.form1.accion.value = '';
		document.form1.CVcodigo.value = '';
		document.form1.CVvalor.value = '';
		document.form1.AgregarD.name = 'AgregarD';
	}

	function modificar(valor, valor2){
		document.form1.accion.value = 2;
		document.form1.CVcodigo.value = valor;
		document.form1.CVvalor.value = valor2;
		document.form1.AgregarD.name = 'CambioD';
	}

	function eliminar(valor){
		if ( confirm('Desea eliminar el registro?') ) {
			document.form1.accion.value = 3;
			document.form1.CVcodigo.value = valor;
			document.form1.submit();
		}
	}



</script>

<CFOUTPUT>
<form style="margin:0;" name="form1" method="post" action="SQLClasificacionDato.cfm" onSubmit="return validar();">
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	
	<cfif isdefined('form.Pagina2')>
	<input name="Pagina2" type="hidden" tabindex="-1" value="#form.Pagina2#">	
	</cfif>
	
	
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right" width="30%"><strong>Descripci&oacute;n:&nbsp;</strong></td>
		  <td><input type="text" name="CDdescripcion" size="50" maxlength="30" value="<cfif modo neq 'ALTA'>#data.CDdescripcion#</cfif>" tabindex="1">		    </td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfset regresa = 'Clasificacion.cfm?arbol_pos=#form.Ccodigo#'>
				<cf_botones modo="#modo#" regresar="#regresa#" tabindex="1">
			</td>
		</tr>
		<cfif modo neq 'ALTA'>
			<input type="hidden" name="accion" value="">
			<input type="hidden" name="CVcodigo" value="">
			<tr><td colspan="2">
				<table width="90%" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td>
						<fieldset><legend><strong>Valores</strong></legend>
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td valign="bottom"><strong>Valor:&nbsp;</strong></td>
								<td valign="bottom"><input type="text" size="45" maxlength="50" name="CVvalor" tabindex="1"></td>
								<td valign="middle" align="center">
									<cfif modo neq "ALTA">
										<cfset masbotones = "AgregarD">
										<cfset masbotonesv = "Aceptar">
									<cfelse>
										<cfset masbotones = "">
										<cfset masbotonesv = "">
									</cfif>
									<cf_botones exclude="ALTA,CAMBIO,BAJA,LIMPIAR" include="#masbotones#"  includevalues="#masbotonesv#" tabindex="1" >
								</td>
							</tr>
							<tr><td colspan="3">&nbsp;</td></tr>
							<tr>
								<td colspan="3">
                                	<cfinclude template="../../Utiles/sifConcat.cfm">
									<cfquery name="rsLista" datasource="#session.DSN#">
										select CVcodigo, CVvalor, 
											  '<img style=''cursor:hand;'' alt=''Eliminar'' border=''0'' src=''../../imagenes/Borrar01_S.gif'' onClick=''javascript:eliminar('#_Cat#<cf_dbfunction name="to_char" args="CVcodigo">#_Cat#');''>' as imagen
										from ClasificacionesValor
										where CDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDcodigo#">
										order by CVvalor
									</cfquery>
									<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
									<cfparam name="form.Pagina2" default="1">
									<cfparam name="form.MaxRows2" default="10">
									<cfset navegacion = "">
									<cfset navegacion = "Ccodigo=#form.Ccodigo#">
									<cfset navegacion = navegacion &"&CDcodigo=#form.CDcodigo#">
									<cfinvoke 
									 component="sif.Componentes.pListas"
									 method="pListaQuery"
									 returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#rsLista#"/>
										<cfinvokeargument name="desplegar" value="CVvalor, imagen"/>
										<cfinvokeargument name="etiquetas" value="Valor, Eliminar"/>
										<cfinvokeargument name="formatos" value=""/>
										<cfinvokeargument name="align" value="left, center"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="irA" value="SQLClasificacionDato.cfm"/>
										<cfinvokeargument name="MaxRows" value="#form.MaxRows2#"/>
										<cfinvokeargument name="showLink" value="false"/>
										<cfinvokeargument name="showEmptyListMsg" value="true"/>
										<cfinvokeargument name="incluyeForm" value="false"/>
										<cfinvokeargument name="PageIndex" value="2"/>
										<cfinvokeargument name="navegacion" value="#navegacion#"/>
									</cfinvoke>

								</td>
							</tr>
						</table>
						</fieldset>
					</td>
				</tr>
				</table>
			</td></tr>
		</cfif>

		<tr><td>&nbsp;</td></tr>
	</table>

	<input type="hidden" name="Ccodigo" value="#form.Ccodigo#">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="CDcodigo" value="#form.CDcodigo#">
	</cfif>
	<cfif isdefined('form.MaxRows2')>
	<input name="MaxRows2" type="hidden" tabindex="-1" value="#form.MaxRows2#">	
	</cfif>
</form>
</CFOUTPUT>

<script language="javascript" type="text/javascript">
		document.form1.CDdescripcion.focus();
</script>