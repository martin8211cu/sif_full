<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_CODIGO" Default="C&oacute;digo" XmlFile="/sif/rh/generales.xml" returnvariable="LB_CODIGO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DESCRIPCION" Default="Descripci&oacute;n" XmlFile="/sif/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Agregar" Default="Agregar" XmlFile="/sif/rh/generales.xml" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Modificar" Default="Modificar" XmlFile="/sif/rh/generales.xml" returnvariable="BTN_Modificar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="BTN_Eliminar" Default="Eliminar" XmlFile="/sif/rh/generales.xml" returnvariable="BTN_Eliminar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Lista" Default="Lista" returnvariable="BTN_Lista" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_Parte" Default="Parte" returnvariable="LB_Parte" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DeseaEliminarElCuestionario" Default="Desea eliminar el Cuestionario?" returnvariable="MSG_DeseaEliminarElCuestionario" component="sif.Componentes.Translate" method="Translate"/>				
<cfinvoke Key="LB_Numero" Default="N&uacute;mero" returnvariable="LB_Numero" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Pregunta" Default="Pregunta" returnvariable="LB_Pregunta" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("url.pageNum_Lista") and not isdefined('form.pageNum_Lista') >
	<cfset form.pageNum_Lista = url.pageNum_Lista >
</cfif>
<cfif isdefined("url.fPCcodigo") and not isdefined('form.fPCcodigo') >
	<cfset form.fPCcodigo = url.fPCcodigo >
</cfif>
<cfif isdefined("url.fPCnombre") and not isdefined("form.fPCnombre") >
	<cfset form.fPCnombre = url.fPCnombre >
</cfif>
<cfif isdefined("url.fPCdescripcion") and not isdefined("form.fPCdescripcion") >
	<cfset form.fPCdescripcion = url.fPCdescripcion >
</cfif>
<cfif isdefined("url.PPparte") and not isdefined('form.pPPparte')>
	<cfset form.pPPparte = url.pPParte>
</cfif>
<cfif isdefined("url.PPid") and not isdefined('form.pPPid')>
	<cfset form.pPPid = url.PPid>
</cfif>

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
<!---
	<cfif modo neq 'ALTA'>
		<cf_rhimprime datos="/asp/portal/cuestionarios/cuestionario-imprimir.cfm" objetosform="false" paramsuri="?PCid=#form.PCid#">
	</cfif>
--->	
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
		<form name="form1" method="post" action="cuestionario-sql.cfm" onSubmit="return validar(this);" style="margin:0; ">
			<cfif modo neq 'ALTA'>
				<input type="hidden" name="PCid" value="#pcdata.PCid#">
			</cfif>
			<cfparam  name="form.pageNum_lista" default="1">			
			<input type="hidden" name="pagenum_lista" value="<cfif isdefined("form.pagenum_lista") >#form.pagenum_lista#<cfelse>1</cfif>" />
			<input name="fPCcodigo" 		type="hidden"	value="<cfif isdefined('form.fPCcodigo')>#trim(form.fPCcodigo)#</cfif>"/>
			<input name="fPCnombre" 		type="hidden"	value="<cfif isdefined('form.fPCnombre')>#trim(form.fPCnombre)#</cfif>"/>
			<input name="fPCdescripcion" 	type="hidden" 	value="<cfif isdefined('form.fPCdescripcion')>#trim(form.fPCdescripcion)#</cfif>" />			
            <tr>
				<td colspan="6" align="center">
				<table align="center" cellpadding="0" cellspacing="0" width="99%">
					<tr>
						<cfif modo neq 'ALTA'>
							<td align="center" colspan="3" width="99%" class="tituloPersona" style="text-align:center;">
							<cf_translate key="LB_Cuestionarios">Cuestionarios</cf_translate>
							</td>
							
							<td>
								<a href="##" tabindex="-1">
								<img src="/cfmx/sif/imagenes/search.gif" 
									alt="Previsualizar" 
									name="imagen" 
									border="0" 
									align="absmiddle" 
									onClick='javascript: ver(#form.PCid#);'>	
								</a>
							</td>
						<cfelse>
						<td align="center" colspan="4" width="99%" class="tituloPersona" style="text-align:center;">
							<cf_translate key="LB_Cuestionarios">Cuestionarios</cf_translate>
							</td>
						</cfif>	
					</tr>
				</table>
				</td>
			</tr>
            
            <tr>
				<td align="right" width="1%"><cfoutput>#LB_CODIGO#</cfoutput>:&nbsp;</td>
				<td><input type="text" name="PCcodigo" size="10" maxlength="10" onFocus="restaurar_color(this); this.select(); " value="<cfif modo neq 'ALTA'>#trim(pcdata.PCcodigo)#</cfif>"></td>
				<td align="right" width="1%"><cf_translate key="LB_Cuestionario">Cuestionario</cf_translate>:&nbsp;</td>
				<td><input type="text" name="PCnombre" size="60" maxlength="60" onFocus="restaurar_color(this); this.select(); " value="<cfif modo neq 'ALTA'>#trim(pcdata.PCnombre)#</cfif>"></td>
			</tr>
			
			<tr>
				<td align="right" width="1%" ><cfoutput>#LB_DESCRIPCION#</cfoutput>:&nbsp;</td>
				<td><input type="text" name="PCdescripcion" size="60" maxlength="255" onFocus="restaurar_color(this); this.select();" value="<cfif modo neq 'ALTA'>#trim(pcdata.PCdescripcion)#</cfif>">
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

			<tr><td colspan="6" align="center">
				<cfif modo eq 'ALTA'>
					<input type="submit" name="PCAgregar" value="<cfoutput>#BTN_Agregar#</cfoutput>">
				<cfelse>
					<input type="submit" name="PCModificar" value="<cfoutput>#BTN_Modificar#</cfoutput>" onClick="javascript:btnSelected='Modificar';">
					<input type="submit" name="PCEliminar" value="<cfoutput>#BTN_Eliminar#</cfoutput>" onClick="javascript:if (confirm('<cfoutput>#MSG_DeseaEliminarElCuestionario#</cfoutput>')){ btnSelected='Eliminar'; return true;} return false;">
				</cfif>
				<input type="button" name="PCLista" value="<cfoutput>#BTN_Lista#</cfoutput>" onClick="javascript:location.href='cuestionario-lista.cfm?pagenum_lista='+this.form.pagenum_lista.value+'&fPCcodigo='+this.form.fPCcodigo.value+'&fPCnombre='+this.form.fPCnombre.value+'&fPCdescripcion='+this.form.fPCdescripcion.value">
			</td></tr>
		</form>

		<cfif modo neq 'ALTA'>
			<form name="form2" method="post" action="cuestionario-sql.cfm" onSubmit="return validar(this);" style="margin:0; ">
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="PCid" value="#pcdata.PCid#">
				</cfif>
				<input type="hidden" name="pagenum_lista" value="<cfif isdefined("form.pagenum_lista") >#form.pagenum_lista#<cfelse>1</cfif>" />
				<input name="fPCcodigo" 		type="hidden"	value="<cfif isdefined('form.fPCcodigo')>#trim(form.fPCcodigo)#</cfif>"/>
				<input name="fPCnombre" 		type="hidden"	value="<cfif isdefined('form.fPCnombre')>#trim(form.fPCnombre)#</cfif>"/>
				<input name="fPCdescripcion" 	type="hidden" 	value="<cfif isdefined('form.fPCdescripcion')>#trim(form.fPCdescripcion)#</cfif>" />			

				<!--- SECCION DE PARTES --->
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr><td colspan="6">
					<table width="99%" cellpadding="0" cellspacing="1" align="center" >
						<tr><td align="center" colspan="2" class="tituloPersona" style="text-align:center;"><cf_translate key="LB_Partes">Partes</cf_translate></td></tr>
						<tr>
							<td valign="top" width="40%">
								<cfquery name="rsListaPartes" datasource="sifcontrol">
									select PPparte as pPPparte, PCPdescripcion as pPCPdescripcion
									from PortalCuestionarioParte
									where PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
									order by PPparte
								</cfquery>
								
								<cfset navegacion = "&PCid=#form.PCid#" >
								<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
									<cfinvokeargument name="query" 			value="#rsListaPartes#">
									<cfinvokeargument name="desplegar" 		value="pPPparte,pPCPdescripcion">
									<cfinvokeargument name="etiquetas" 		value="#LB_Parte#,#LB_DESCRIPCION#">
									<cfinvokeargument name="formatos" 		value="S,S">
									<cfinvokeargument name="align" 			value="left,left">
									<cfinvokeargument name="ira" 			value="cuestionario.cfm">
									<cfinvokeargument name="keys" 			value="pPPparte">
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
				<input type="hidden" name="pagenum_lista" value="<cfif isdefined("form.pagenum_lista") >#form.pagenum_lista#<cfelse>1</cfif>" />
				<input name="fPCcodigo" 		type="hidden"	value="<cfif isdefined('form.fPCcodigo')>#trim(form.fPCcodigo)#</cfif>"/>
				<input name="fPCnombre" 		type="hidden"	value="<cfif isdefined('form.fPCnombre')>#trim(form.fPCnombre)#</cfif>"/>
				<input name="fPCdescripcion" 	type="hidden" 	value="<cfif isdefined('form.fPCdescripcion')>#trim(form.fPCdescripcion)#</cfif>" />			

				<!--- SECCION DE PREGUNTAS --->
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr><td colspan="6">
					<table width="99%" cellpadding="0" cellspacing="1" align="center" >
						<tr><td align="center" colspan="2" class="tituloPersona" style="text-align:center;"><cf_translate key="LB_Preguntas">Preguntas</cf_translate></td></tr>
						<tr>
							<td valign="top" width="40%">
								<cfif isdefined('form.pPParte') and form.pPParte GT 0>
									<cfquery name="rsListaPreguntas" datasource="sifcontrol">
										select 	PPid as pPPid,
												PPnumero as pPPnumero, 
												{fn concat(	'#LB_Parte#', 
															 <cf_dbfunction name="to_char" args="PPparte" datasource="sifcontrol"> 
														   )
												} as pPPpartedesc, 
												PPpregunta as pPPpregunta, 
												PPtipo as pPPtipo, 
												PPvalor as pPPvalor,
												PPparte as pPPparte
	  
										from PortalPregunta
										where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
										  and PPparte = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pPParte#">
										order by PPparte, PPnumero, PPorden
									</cfquery>
	
									<cfset navegacion = "&PCid=#form.PCid#" >
									
									<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
										<cfinvokeargument name="query" 			value="#rsListaPreguntas#">
										<cfinvokeargument name="desplegar" 		value="pPPnumero,pPPpregunta">
										<cfinvokeargument name="etiquetas" 		value="#LB_Numero#,#LB_Pregunta#">
										<cfinvokeargument name="formatos" 		value="S,S">
										<cfinvokeargument name="align" 			value="left,left">
										<cfinvokeargument name="ira" 			value="cuestionario.cfm">
										<cfinvokeargument name="keys" 			value="pPPid">
										<cfinvokeargument name="showEmptyListMsg" value="true">
										<cfinvokeargument name="incluyeform" 	value="false">
										<cfinvokeargument name="formname"		value="form3">
										<cfinvokeargument name="ajustar"		value="S">
										<cfinvokeargument name="navegacion"		value="#navegacion#">
										<cfinvokeargument name="cortes"			value="pPPpartedesc">
										<cfinvokeargument name="PageIndex"		value="2">
									</cfinvoke>	
								</cfif>
							</td>
	
							<td align="center" width="60%" valign="top">
								<cfinclude template="preguntas-form.cfm">
							</td>
						</tr>
					</table>
				</td></tr>
			</form>
		</cfif>
	</table>
</cfoutput>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_SePresentaronLosSiguientesErrores" Default="Se presentaron los siguientes errores:" returnvariable="MSG_SePresentaronLosSiguientesErrores" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_ElCampoCodigoEsRequerido" Default="El campo Código es requerido." returnvariable="MSG_ElCampoCodigoEsRequerido" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_ElCampoNombreEsRequerido" Default="El campo Nombre es requerido" returnvariable="MSG_ElCampoNombreEsRequerido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ElCampoDescripcionEsRequerido" Default="El campo Descripción es requerido" returnvariable="MSG_ElCampoDescripcionEsRequerido" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_ElCampoParteEsRequerido" Default="El campo Parte es requerido" returnvariable="MSG_ElCampoParteEsRequerido" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_ElCampoDescripcionEsRequerido" Default="El campo Descripción es requerido" returnvariable="MSG_ElCampoDescripcionEsRequerido" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_ElCampoParteEsRequerido" Default="El campo Parte es requerido" returnvariable="MSG_ElCampoParteEsRequerido" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_ElCampoTipoEsRequerido" Default="El campo Tipo es requerido." returnvariable="MSG_ElCampoTipoEsRequerido" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<script type="text/javascript" language="javascript1.2">
	var btnSelected = '';

	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
	
	function restaurar_color(obj){
		obj.style.backgroundColor = '#FFFFFF';
	}

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
	
	function ver(llave){
		var PARAM  = "previo.cfm?PCid="+ llave
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
	}

</script>