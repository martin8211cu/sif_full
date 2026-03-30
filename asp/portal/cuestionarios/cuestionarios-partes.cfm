<cfif modo neq 'ALTA'>
	<form name="form2" method="post" action="cuestionario-sql.cfm" onSubmit="return validar2(this);" style="margin:0; ">
		<cfoutput>
			<cfif modo neq 'ALTA'>
				<input type="hidden" name="PCid" value="#pcdata.PCid#">
			</cfif>
			
			<input type="hidden" name="pagenum_lista" value="<cfif isdefined("form.pagenum_lista") >#form.pagenum_lista#<cfelse>1</cfif>" />
			<input name="fPCcodigo" 		type="hidden"	value="<cfif isdefined('form.fPCcodigo')>#trim(form.fPCcodigo)#</cfif>"/>
			<input name="fPCnombre" 		type="hidden"	value="<cfif isdefined('form.fPCnombre')>#trim(form.fPCnombre)#</cfif>"/>
			<input name="fPCdescripcion" 	type="hidden" 	value="<cfif isdefined('form.fPCdescripcion')>#trim(form.fPCdescripcion)#</cfif>" />			
			
			<!--- SECCION DE PARTES --->
			<table width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr class="listaPar">
					<td colspan="6" align="center"><strong>#pcdata.PCcodigo#-#pcdata.PCdescripcion#</strong></td>
				</tr>
				<tr><td colspan="6">
					<table width="99%" cellpadding="0" cellspacing="1" align="center" >
						<tr>
							<td align="center" colspan="2" class="tituloPersona" style="text-align:center;"><cf_translate key="LB_Partes">Partes</cf_translate></td>
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
							</tr>
							<tr>
							<td valign="top" width="35%">
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
							<cfinvokeargument name="ira" 			value="cuestionario.cfm?tab=2">
							<cfinvokeargument name="keys" 			value="pPPparte">
							<cfinvokeargument name="showEmptyListMsg" value="true">
							<cfinvokeargument name="incluyeform" 	value="false">
							<cfinvokeargument name="formname"		value="form2">
							<cfinvokeargument name="ajustar"		value="S">
							<cfinvokeargument name="navegacion"		value="#navegacion#">
							<cfinvokeargument name="PageIndex"		value="1">
							</cfinvoke>	
							</td>							
							<td align="center" width="65%" valign="top">
							<cfinclude template="partes-form.cfm">
							</td>
						</tr>
					</table>
				</td></tr>
			</table>
		</cfoutput>
	</form>
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

	function validar2(form){
		var mensaje = '<cfoutput>#MSG_SePresentaronLosSiguientesErrores#</cfoutput>:\n';
		var error = false;

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
	</cfif>
				
		if (error){
			alert(mensaje);
		}

		return !error;
	
		}
</script>



