<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CODIGO"
Default="C&oacute;digo"
XmlFile="/rh/generales.xml"
returnvariable="LB_CODIGO"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_DESCRIPCION"
Default="Descripci&oacute;n"
XmlFile="/rh/generales.xml"
returnvariable="LB_DESCRIPCION"/>

<cfset modo = 'ALTA'>
<cfif isdefined("form.PCid") and len(trim(form.PCid))>
	<cfset modo = 'CAMBIO'>
	
	<cfquery name="pcdata" datasource="sifcontrol">
		select PCid, PCcodigo, PCnombre, PCdescripcion, PCtipo
		from PortalCuestionario
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
	</cfquery>
</cfif>

<cfoutput>
<script language="javascript1.2" type="text/javascript" src="utilesMonto.js"></script>
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
		<form name="form1" method="post" action="cuestionario-sql.cfm" onSubmit="return validar(this);" style="margin:0; ">
			<cfif isdefined("form.pageNum_lista")>
				<input type="hidden" name="pageNum_lista" value="#form.pageNum_lista#">
			</cfif>
			<cfif isdefined("form.fPCcodigo")>
				<input type="hidden" name="fPCcodigo" value="#form.fPCcodigo#">
			</cfif>
			<cfif isdefined("form.fPCnombre")>
				<input type="hidden" name="fPCnombre" value="#form.fPCnombre#">
			</cfif>
			<cfif isdefined("form.fPCdescripcion")>
				<input type="hidden" name="fPCdescripcion" value="#form.fPCdescripcion#">
			</cfif>

			<cfif modo neq 'ALTA'>
				<input type="hidden" name="PCid" value="#pcdata.PCid#">
			</cfif>

			<!---<tr><td colspan="2" align="center"><table align="center" cellpadding="0" cellspacing="0" width="99%"><tr><td align="center" colspan="4" width="99%" class="tituloPersona" style="text-align:center;"><cf_translate key="LB_Cuestionarios">Cuestionarios</cf_translate></td></tr></table></td></tr>--->
			<tr>
				<td align="right" width="35%"><cf_translate key="LB_Cuestionario">Cuestionario</cf_translate>:&nbsp;</td>
				<td><input type="text" name="PCnombre" size="60" maxlength="60" onFocus="restaurar_color(this); this.select(); " value="<cfif modo neq 'ALTA'>#trim(pcdata.PCnombre)#</cfif>"></td>
			</tr>

			<tr>
				<td align="right" width="1%"><cfoutput>#LB_CODIGO#</cfoutput>:&nbsp;</td>
				<td><input type="text" name="PCcodigo" size="10" maxlength="10" onFocus="restaurar_color(this); this.select(); " value="<cfif modo neq 'ALTA'>#trim(pcdata.PCcodigo)#</cfif>"></td>
			</tr>
			
			<tr>
				<td align="right" width="1%" ><cfoutput>#LB_DESCRIPCION#</cfoutput>:&nbsp;</td>
				<td><input type="text" name="PCdescripcion" size="60" maxlength="255" onFocus="restaurar_color(this); this.select();" value="<cfif modo neq 'ALTA'>#trim(pcdata.PCdescripcion)#</cfif>">
			</tr>

			<tr>
				<td align="right" width="1%" ><cf_translate key="LB_Tipo">Tipo</cf_translate>:&nbsp;</td>
				<td>
					<select name="PCtipo" class="flat">
						<option value="0" <cfif modo neq 'ALTA' and pcdata.PCtipo eq 0 >selected</cfif> ><cf_translate key="CMB_Cuestionario">Cuestionario</cf_translate></option>
						<option value="10" <cfif modo neq 'ALTA' and pcdata.PCtipo eq 10 >selected</cfif>><cf_translate key="CMB_Encuesta">Encuesta</cf_translate></option>
						<option value="20" <cfif modo neq 'ALTA' and pcdata.PCtipo eq 20 >selected</cfif>><cf_translate key="CMB_Benziger">Benziger</cf_translate></option>
						<option value="30" <cfif modo neq 'ALTA' and pcdata.PCtipo eq 30 >selected</cfif>><cf_translate key="CMB_Test">Test</cf_translate></option>
						<option value="40" <cfif modo neq 'ALTA' and pcdata.PCtipo eq 40 >selected</cfif>><cf_translate key="CMB_Otros">Otros</cf_translate></option>
					</select>
				</td>
			</tr>

			<tr><td colspan="2" align="center">
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Agregar"
				Default="Agregar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Agregar"/>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Modificar"
				Default="Modificar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Modificar"/>	

				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Eliminar"
				Default="Eliminar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Eliminar"/>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Lista"
				Default="Lista"
				returnvariable="BTN_Lista"/>	
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Parte"
				Default="Parte"
				returnvariable="LB_Parte"/>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_DeseaEliminarElCuestionario"
				Default="Desea eliminar el Cuestionario?"
				returnvariable="MSG_DeseaEliminarElCuestionario"/>				

													
			
				<cfif modo eq 'ALTA'>
					<input type="submit" name="PCAgregar" class="btnGuardar" value="<cfoutput>#BTN_Agregar#</cfoutput>">
				<cfelse>
					<input type="submit" name="PCModificar" class="btnGuardar" value="<cfoutput>#BTN_Modificar#</cfoutput>" onClick="javascript:btnSelected='Modificar';">
					<input type="submit" name="PCEliminar" class="btnEliminar" value="<cfoutput>#BTN_Eliminar#</cfoutput>" onClick="javascript:if (confirm('<cfoutput>#MSG_DeseaEliminarElCuestionario#</cfoutput>')){ btnSelected='Eliminar'; return true;} return false;">
				</cfif>
				
				<cfset params = '' >
				<cfif isdefined("form.pageNum_lista")>
					<cfset params = params & '&pageNum_lista=#form.pageNum_lista#' >
				</cfif>
				<cfif isdefined("form.fPCcodigo")>
					<cfset params = params & '&fPCcodigo=#form.fPCcodigo#' >
				</cfif>
				<cfif isdefined("form.fPCnombre")>
					<cfset params = params & '&fPCnombre=#form.fPCnombre#' >
				</cfif>
				<cfif isdefined("form.fPCdescripcion")>
					<cfset params = params & '&fPCdescripcion=#form.fPCdescripcion#' >
				</cfif>
				
				<input type="button" name="PCLista" class="btnAnterior" value="<cfoutput>#BTN_Lista#</cfoutput>" onClick="javascript:location.href='cuestionario-lista.cfm?DUMMY=OK#PARAMS#'">
			</td></tr>
		</form>

		<!---
		<cfif modo neq 'ALTA'>
			<form name="form2" method="post" action="cuestionario-sql.cfm" onSubmit="return validar(this);" style="margin:0; ">
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="PCid" value="#pcdata.PCid#">
				</cfif>

				<!--- SECCION DE PARTES --->
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr><td colspan="6">
					<table width="99%" cellpadding="0" cellspacing="1" align="center" >
						<tr><td align="center" colspan="2" class="tituloPersona" style="text-align:center;"><cf_translate key="LB_Partes">Partes</cf_translate></td></tr>
						<tr>
							<td valign="top" width="40%">
								<cfquery name="rsListaPartes" datasource="sifcontrol">
									select PPparte as _PPparte, PCPdescripcion as _PCPdescripcion
									from PortalCuestionarioParte
									where PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
									order by PPparte
								</cfquery>
								
								<cfset navegacion = "&PCid=#form.PCid#" >
								<cfinvoke component="rh.Componentes.pListas" method="pListaQuery">
									<cfinvokeargument name="query" 			value="#rsListaPartes#">
									<cfinvokeargument name="desplegar" 		value="_PPparte,_PCPdescripcion">
									<cfinvokeargument name="etiquetas" 		value="#LB_Parte#,#LB_DESCRIPCION#">
									<cfinvokeargument name="formatos" 		value="S,S">
									<cfinvokeargument name="align" 			value="left,left">
									<cfinvokeargument name="ira" 			value="cuestionario.cfm">
									<cfinvokeargument name="keys" 			value="_PPparte">
									<cfinvokeargument name="showEmptyListMsg" value="true">
									<cfinvokeargument name="incluyeform" 	value="false">
									<cfinvokeargument name="formname"		value="form2">
									<cfinvokeargument name="ajustar"		value="S">
									<cfinvokeargument name="navegacion"		value="#navegacion#">
									<cfinvokeargument name="PageIndex"		value="1">
								</cfinvoke>	
							</td>
	
							<td align="center" width="60%" valign="top">
								<cfinclude template="partes-form.cfm">
							</td>
						</tr>
					</table>
				</td></tr>
			</form>

			<form name="form3" method="post" action="cuestionario-sql.cfm" onSubmit="return validar(this);" style="margin:0; ">
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="PCid" value="#pcdata.PCid#">
				</cfif>

				<!--- SECCION DE PREGUNTAS --->
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr><td colspan="6">
					<table width="99%" cellpadding="0" cellspacing="1" align="center" >
						<tr><td align="center" colspan="2" class="tituloPersona" style="text-align:center;"><cf_translate key="LB_Preguntas">Preguntas</cf_translate></td></tr>
						<tr>
							<td valign="top" width="40%">
								<cfquery name="rsListaPreguntas" datasource="sifcontrol">
									select PPid as _PPid, {fn concat('<cf_translate key="LB_Parte">Parte</cf_translate>', <cf_dbfunction name="to_char" args="PPparte" datasource="sifcontrol"> )} as _PPpartedesc, PPnumero as _PPnumero, PPpregunta as _PPpregunta, PPtipo as _PPtipo, PPvalor as _PPvalor
									from PortalPregunta
									where PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
									order by PPparte, PPnumero, PPorden
								</cfquery>
								<cfset navegacion = "&PCid=#form.PCid#" >
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Numero"
								Default="Número"
								returnvariable="LB_Numero"/>
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Pregunta"
								Default="Pregunta"
								returnvariable="LB_Pregunta"/>								
								
								<cfinvoke component="rh.Componentes.pListas" method="pListaQuery">
									<cfinvokeargument name="query" 			value="#rsListaPreguntas#">
									<cfinvokeargument name="desplegar" 		value="_PPnumero,_PPpregunta">
									<cfinvokeargument name="etiquetas" 		value="#LB_Numero#,#LB_Pregunta#">
									<cfinvokeargument name="formatos" 		value="S,S">
									<cfinvokeargument name="align" 			value="left,left">
									<cfinvokeargument name="ira" 			value="cuestionario.cfm">
									<cfinvokeargument name="keys" 			value="_PPid">
									<cfinvokeargument name="showEmptyListMsg" value="true">
									<cfinvokeargument name="incluyeform" 	value="false">
									<cfinvokeargument name="formname"		value="form3">
									<cfinvokeargument name="ajustar"		value="S">
									<cfinvokeargument name="navegacion"		value="#navegacion#">
									<cfinvokeargument name="cortes"			value="_PPpartedesc">
								</cfinvoke>	
							</td>
	
							<td align="center" width="60%" valign="top">
								<cfinclude template="preguntas-form.cfm">
							</td>
						</tr>
					</table>
				</td></tr>
			</form>
		</cfif>
		--->
	</table>
</cfoutput>

<script type="text/javascript" language="javascript1.2">
	var btnSelected = '';

	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
	
	function restaurar_color(obj){
		obj.style.backgroundColor = '#FFFFFF';
	}

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SePresentaronLosSiguientesErrores"
	Default="Se presentaron los siguientes errores:"
	returnvariable="MSG_SePresentaronLosSiguientesErrores"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoCodigoEsRequerido"
	Default="El campo Código es requerido."
	returnvariable="MSG_ElCampoCodigoEsRequerido"/>	

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoNombreEsRequerido"
	Default="El campo Nombre es requerido"
	returnvariable="MSG_ElCampoNombreEsRequerido"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoDescripcionEsRequerido"
	Default="El campo Descripción es requerido"
	returnvariable="MSG_ElCampoDescripcionEsRequerido"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoParteEsRequerido"
	Default="El campo Parte es requerido"
	returnvariable="MSG_ElCampoParteEsRequerido"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoDescripcionEsRequerido"
	Default="El campo Descripción es requerido"
	returnvariable="MSG_ElCampoDescripcionEsRequerido"/>	

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoParteEsRequerido"
	Default="El campo Parte es requerido"
	returnvariable="MSG_ElCampoParteEsRequerido"/>	

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoTipoEsRequerido"
	Default="El campo Tipo es requerido."
	returnvariable="MSG_ElCampoTipoEsRequerido"/>

	function validar(form){
		var mensaje = '<cfoutput>#MSG_SePresentaronLosSiguientesErrores#</cfoutput>:\n';
		var error = false;

		if (form.name == 'form1'){
			if ( trim(form.PCcodigo.value) == '' ){
				mensaje = mensaje + ' - <cfoutput>#MSG_ElCampoCodigoEsRequerido#</cfoutput>\n' 
				form.PCcodigo.style.backgroundColor = '#FFFFCC';
				error = true;
			}
	
			if ( trim(form.PCnombre.value) == '' ){
				mensaje = mensaje + ' - <cfoutput>#MSG_ElCampoNombreEsRequerido#</cfoutput>\n' 
				form.PCnombre.style.backgroundColor = '#FFFFCC';
				error = true;
			}
	
			if ( trim(form.PCdescripcion.value) == '' ){
				mensaje = mensaje + ' - <cfoutput>#MSG_ElCampoDescripcionEsRequerido#</cfoutput>\n' 
				form.PCdescripcion.style.backgroundColor = '#FFFFCC';
				error = true;
			}
		}
		
		<cfif modo neq 'ALTA'>
			if (form.name == 'form2'){
				if ( btnSelected != 'Eliminar' && btnSelected != 'Modificar'){
					if ( trim(form.PPparte.value) == '' ){
						mensaje = mensaje + ' - <cfoutput>#MSG_ElCampoParteEsRequerido#</cfoutput>\n' 
						form.PPparte.style.backgroundColor = '#FFFFCC';
						error = true;
					}
					if ( trim(form.PCPdescripcion.value) == '' ){
						mensaje = mensaje + ' - <cfoutput>#MSG_ElCampoDescripcionEsRequerido#</cfoutput>\n' 
						form.PCPdescripcion.style.backgroundColor = '#FFFFCC';
						error = true;
					}
				}
			}

			if (form.name == 'form3'){
				if ( btnSelected != 'Eliminar' && btnSelected != 'Modificar'){
					if ( trim(form.PPparte.value) == '' ){
						mensaje = mensaje + ' - <cfoutput>#MSG_ElCampoParteEsRequerido#</cfoutput>\n' 
						form.PPparte.style.backgroundColor = '#FFFFCC';
						error = true;
					}
		
					if ( trim(form.PPtipo.value) == '' ){
						mensaje = mensaje + ' - <cfoutput>#MSG_ElCampoTipoEsRequerido#</cfoutput>\n' 
						form.PPtipo.style.backgroundColor = '#FFFFCC';
						error = true;
					}
				}
			}
			
		</cfif>
		
		if (error){
			alert(mensaje);
		}

		return !error;
	}
</script>