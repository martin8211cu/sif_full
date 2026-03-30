<cfif modo neq 'ALTA'>
	<cfif not isdefined ('form.pPPparte')>
	<cfquery name="rsSQLR" datasource="sifcontrol">
		select min(PPparte) as PPparte from PortalCuestionarioParte where PCid=#form.PCid#
	</cfquery>
	</cfif>
	<cfoutput>
	<form name="form3" method="post" action="cuestionario-sql.cfm" onSubmit="return validar(this);" style="margin:0; ">
		<cfif modo neq 'ALTA'>
			<input type="hidden" name="PCid" value="#pcdata.PCid#">
		</cfif>
		<input name="pagenum_lista" 	type="hidden" 	value="<cfif isdefined("form.pagenum_lista") >#form.pagenum_lista#<cfelse>1</cfif>" />
		<input name="fPCcodigo" 		type="hidden"	value="<cfif isdefined('form.fPCcodigo')>#trim(form.fPCcodigo)#</cfif>"/>
		<input name="fPCnombre" 		type="hidden"	value="<cfif isdefined('form.fPCnombre')>#trim(form.fPCnombre)#</cfif>"/>
		<input name="fPCdescripcion" 	type="hidden" 	value="<cfif isdefined('form.fPCdescripcion')>#trim(form.fPCdescripcion)#</cfif>" />			
		<!--- SECCION DE PREGUNTAS --->
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr class="listaPar">
				<td colspan="6" align="center"><strong>#pcdata.PCcodigo#-#pcdata.PCdescripcion#</strong></td>
			</tr>
			<tr>
				<td colspan="6">
					<table width="99%" cellpadding="0" cellspacing="1" align="center" >
						<tr>
							<td align="center" colspan="2" class="tituloPersona" style="text-align:center;">
								<cf_translate key="LB_Preguntas">Preguntas</cf_translate>
							</td>
							<td>
								<a href="##" tabindex="-1">
									<img src="/cfmx/sif/imagenes/search.gif" 
									alt="Previsualizar" 
									name="imagen" 
									border="0" 
									align="absmiddle" 
									onClick='javascript: ver(#form.PCid#);'>	<!---necesito la funcion ver--->
								</a>
							</td>
						</tr>
						<tr>
							<td valign="top" width="40%">
								<cfif isdefined ('rsSQLR') and rsSQLR.recordcount gt 0 and len(trim(rsSQLR.PPparte)) gt 0>
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
										and PPparte = #rsSQLR.PPparte#
										order by PPparte, PPnumero, PPorden
									</cfquery>
									
									<cfif not isdefined('form.PPparte')>
										<cfset form.PPparte=rsSQLR.PPparte>
									</cfif>
									<cfset navegacion = "&PCid=#form.PCid#">
									<cfif isdefined("form.PPparte")>
										<cfset navegacion =  navegacion & "&PPparte=#form.PPparte#">
									</cfif>								
									
									<span id="contenedor_Concepto1">
										<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
											<cfinvokeargument name="query" 			value="#rsListaPreguntas#">
											<cfinvokeargument name="desplegar" 		value="pPPnumero,pPPpregunta">
											<cfinvokeargument name="etiquetas" 		value="#LB_Numero#,#LB_Pregunta#">
											<cfinvokeargument name="formatos" 		value="S,S">
											<cfinvokeargument name="align" 			value="left,left">
											<cfinvokeargument name="ira" 			value="cuestionario.cfm?tab=3">
											<cfinvokeargument name="keys" 			value="pPPid">
											<cfinvokeargument name="showEmptyListMsg" value="true">
											<cfinvokeargument name="incluyeform" 	value="false">
											<cfinvokeargument name="formname"		value="form3">
											<cfinvokeargument name="ajustar"		value="S">
											<cfinvokeargument name="navegacion"		value="#navegacion#">
											<cfinvokeargument name="cortes"			value="pPPpartedesc">
											<cfinvokeargument name="PageIndex"		value="30">
										</cfinvoke>	
									</span>
							<cfelse>
								<cfif isdefined('form.pPPparte') and form.pPPparte GT 0>
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
										  and PPparte = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pPPparte#"> 
										order by PPparte, PPnumero, PPorden
									</cfquery>	
									
									<cfset navegacion = "&PCid=#form.PCid#" >
									<cfif isdefined("form.PPparte")>
										<cfset navegacion =  navegacion & "&PPparte=#form.PPparte#">
									</cfif>
									
									<span id="contenedor_Concepto1">
										<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
										<cfinvokeargument name="query" 			value="#rsListaPreguntas#">
										<cfinvokeargument name="desplegar" 		value="pPPnumero,pPPpregunta">
										<cfinvokeargument name="etiquetas" 		value="#LB_Numero#,#LB_Pregunta#">
										<cfinvokeargument name="formatos" 		value="S,S">
										<cfinvokeargument name="align" 			value="left,left">
										<cfinvokeargument name="ira" 			value="cuestionario.cfm?tab=3">
										<cfinvokeargument name="keys" 			value="pPPid">
										<cfinvokeargument name="showEmptyListMsg" value="true">
										<cfinvokeargument name="incluyeform" 	value="false">
										<cfinvokeargument name="formname"		value="form3">
										<cfinvokeargument name="ajustar"		value="S">
										<cfinvokeargument name="navegacion"		value="#navegacion#">
										<cfinvokeargument name="cortes"			value="pPPpartedesc">
										<cfinvokeargument name="PageIndex"		value="30">
									</cfinvoke>	
									</span>
								</cfif>
							</cfif>
							</td>
	
							<td align="center" width="60%" valign="top">
								<cfinclude template="preguntas-form.cfm">
							</td>
						
						</tr>						
					</table>
				</td></tr>
			</form>
	</cfoutput>
<cfelse>
	<strong>Debe de ingresar un cuestionario</strong>
</cfif>

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

	<cfif modo neq 'ALTA'>
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
