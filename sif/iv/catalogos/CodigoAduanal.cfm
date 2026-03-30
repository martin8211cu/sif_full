	<!--- establecimiento de los modos (ENC y DET)--->	
	<cfset modo  = 'ALTA'>
	<cfset dmodo = 'ALTA'>
	<cfif isdefined("form.CAid") and len(trim(form.CAid))>
		<cfset modo = 'CAMBIO'>
		<cfif isdefined("form.CAid") and len(trim(form.CAid)) and isdefined("form.Ppaisori") and len(trim(form.Ppaisori))>
			<cfset dmodo = 'CAMBIO'>
		</cfif>
	</cfif>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
		
		<cfif modo NEQ 'ALTA'>
			<cfif isdefined("url.Ppaisori") and len(trim(url.Ppaisori))>
				<cfset form.Ppaisori = url.Ppaisori>
			</cfif>									
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
			<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
				<cfset form.Pagina2 = url.Pagina2>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
				<cfset form.Pagina2 = url.PageNum_Lista2>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
				<cfset form.Pagina2 = form.PageNum2>
			</cfif>					
			<cfif isdefined('url.filtro_Pnombre') and not isdefined('form.filtro_Pnombre')>
				<cfset form.filtro_Pnombre = url.filtro_Pnombre>
			</cfif>			
			<cfif isdefined('url.filtro_Idescripcion2') and not isdefined('form.filtro_Idescripcion2')>
				<cfset form.filtro_Idescripcion2 = url.filtro_Idescripcion2>
			</cfif>												
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina2" default="1">	
						
			<cfset navegacionDet = "">							
			<cfset campos_extraDet = '' >
			<cfif isdefined("form.Pagina2") and len(trim(form.Pagina2))>
				<cfset navegacionDet = navegacionDet & "&Pagina2=#form.Pagina2#">
				<cfset campos_extraDet = campos_extraDet & ",'#form.Pagina2#' as Pagina2" >
			</cfif>
			<cfif isdefined("form.Pagina") and form.Pagina NEQ ''>
				<cfset campos_extraDet = campos_extraDet & ",'#form.Pagina#' as Pagina" >
				<cfset navegacionDet = navegacionDet & "&Pagina=#form.Pagina#">
			</cfif>
			<cfif isdefined("form.filtro_CAcodigo") and form.filtro_CAcodigo NEQ ''>
				<cfset campos_extraDet = campos_extraDet & ",'#form.filtro_CAcodigo#' as filtro_CAcodigo" >
				<cfset navegacionDet = navegacionDet & "&filtro_CAcodigo=#form.filtro_CAcodigo#">
			</cfif>
			<cfif isdefined("form.filtro_CAdescripcion") and form.filtro_CAdescripcion NEQ ''>
				<cfset campos_extraDet = campos_extraDet & ",'#form.filtro_CAdescripcion#' as filtro_CAdescripcion" >
				<cfset navegacionDet = navegacionDet & "&filtro_CAdescripcion=#form.filtro_CAdescripcion#">
			</cfif>											
			<cfif isdefined("form.filtro_Idescripcion") and form.filtro_Idescripcion NEQ ''>
				<cfset campos_extraDet = campos_extraDet & ",'#form.filtro_Idescripcion#' as filtro_Idescripcion" >
				<cfset navegacionDet = navegacionDet & "&filtro_Idescripcion=#form.filtro_Idescripcion#">
			</cfif>	
			<cfif isdefined("form.CAid") and form.CAid NEQ ''>
				<cfset navegacionDet = navegacionDet & "&CAid=#form.CAid#">
			</cfif>	
			<cfif isdefined("form.Ppaisori") and form.Ppaisori NEQ ''>
				<cfset navegacionDet = navegacionDet & "&Ppaisori=#form.Ppaisori#">
			</cfif>	
		</cfif>

		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
		<form action="SQLCodigoAduanal.cfm" method = "post" name = "form1" onSubmit="return valida();">
			<cfoutput>
				<cfif modo neq "ALTA">
					<input type="hidden" name="CAid" value="#form.CAid#">
				</cfif>
				<cfif isdefined('form.Pagina2')>
					<input name="Pagina2" type="hidden" tabindex="-1" value="#form.Pagina2#">
				</cfif>
				<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">							
				<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
				<input type="hidden" name="filtro_CAcodigo" value="<cfif isdefined('form.filtro_CAcodigo') and form.filtro_CAcodigo NEQ ''>#form.filtro_CAcodigo#</cfif>">
				<input type="hidden" name="filtro_CAdescripcion" value="<cfif isdefined('form.filtro_CAdescripcion') and form.filtro_CAdescripcion NEQ ''>#form.filtro_CAdescripcion#</cfif>">					
				<input type="hidden" name="filtro_Idescripcion" value="<cfif isdefined('form.filtro_Idescripcion') and form.filtro_Idescripcion NEQ ''>#form.filtro_Idescripcion#</cfif>">					
				<input type="hidden" name="filtro_Pnombre" value="<cfif isdefined('form.filtro_Pnombre') and form.filtro_Pnombre NEQ ''>#form.filtro_Pnombre#</cfif>">									
				<input type="hidden" name="filtro_Idescripcion2" value="<cfif isdefined('form.filtro_Idescripcion2') and form.filtro_Idescripcion2 NEQ ''>#form.filtro_Idescripcion2#</cfif>">					
			</cfoutput>
			<tr><td colspan="2">
				<table width="100%" cellpadding="0" cellspacing="0" align="center">
					<tr><td align="center" bgcolor="#CCCCCC" class="subTitulo"><strong><font size="2">Encabezado del Código Aduanal</font></strong></td>
					</tr>
					<tr> 
						<td align="center"><cfinclude template="codigoAduanalE.cfm"></td>
					</tr>
					
					<!---******** Select trae todos los codigos aduanales(CAcodigo)******---->	
						<cfquery name="rsCAcodigo" datasource="#Session.DSN#">
							select CAcodigo 
							from CodigoAduanal
							where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
								<cfif modo EQ'CAMBIO'>
									and  CAcodigo != <cfqueryparam value="#trim(rsEncabezado.CAcodigo)#" cfsqltype="cf_sql_char">
								</cfif>
						</cfquery>

					  
					<cfif modo neq "ALTA">
						<tr><td class="subTitulo" bgcolor="#CCCCCC" align="center"><strong><font size="2">Detalle del Código Aduanal</font></strong></td></tr>
						<tr> 
							<td><cfinclude template="codigoAduanalD.cfm"></td>
						</tr>
					</cfif>		

					<!--- ============================================================================================================ --->
					<!---  											Botones													           --->
					<!--- ============================================================================================================ --->		
					<tr><td >&nbsp;</td></tr>
					<!-- Caso 1: Alta de Encabezados -->
					<cfif modo EQ 'ALTA'>
						<tr>
							<td align="center">
								<cf_Botones modo="ALTA" sufijo="E" include="Regresar" includevalues="Regresar" tabindex="1">
							</td>	
						</tr>
					</cfif>
					
					<!-- Caso 2: Cambio de Encabezados / Alta de detalles -->
					<cfif modo neq 'ALTA' and dmodo eq 'ALTA' >
						<tr>
							<td align="center" valign="baseline" colspan="8">
								<cf_Botones 
									modo="CAMBIO" 
									names="btnModificarE,btnAgregarD,btnBorrarE,btnNuevo,Regresar"
									values="Modificar Encabezado,Agregar,Borrar Codigo Aduanal,Nuevo C&oacute;digo Aduanal,Regresar"
									tabindex="1">
							</td>
						</tr>
					</cfif>
					
					<!-- Caso 3: Cambio de Encabezados / Cambio de detalle -->		
					<cfif modo neq 'ALTA' and dmodo neq 'ALTA' >
						<tr>
							<td align="center" valign="baseline" colspan="8">
								<cf_Botones 
									modo="CAMBIO" 
									names="btnCambiarD,btnBorrarD,btnBorrarE,btnNuevoD,Regresar"
									values="Cambiar,Borrar L&iacute;nea,Borrar Codigo Aduanal,Nueva L&iacute;nea,Regresar"
									tabindex="1">
							</td>
						</tr>
					</cfif>
		</form>
					<!-- ============================================================================================================ -->
					<!-- ============================================================================================================ -->		
					<tr><td>&nbsp;</td></tr>
					<!---***************	Lista con el detalle del Codigo Aduanal (tabla=ImpuestosCodigoAduanal)
					Pnombre = Pais(tabla=Ppais), Idescripcion = descripcion del impuesto (tabla=Impuestos)****************--->
						<cfif modo NEQ 'ALTA'>
							<tr>
								<td>
									<cfinvoke 
									component="sif.Componentes.pListas"
									method="pListaRH"
									returnvariable="pListaRet"> 
										<cfinvokeargument name="tabla" value="ImpuestosCodigoAduanal a
																			inner join CodigoAduanal b
																				on a.CAid = b.CAid
																			inner join Pais c
																				on a.Ppaisori = c.Ppais	
																			inner join Impuestos d
																				on a.Icodigo = d.Icodigo 
																				and a.Ecodigo=d.Ecodigo"/> 
										<cfinvokeargument name="columnas" value="a.CAid,
																				a.Ppaisori,
																				a.Icodigo,
																				a.porcCIF,
																				a.porcFOB,
																				a.porcSegLoc,
																				a.porcFletLoc,
																				a.porcAgeAdu,
																				b.CAcodigo,
																				c.Pnombre,
																				d.Idescripcion as Idescripcion2
																				#preservesinglequotes(campos_extraDet)#"/> 
										<cfinvokeargument name="desplegar" value="Pnombre, Idescripcion2"/> 
										<cfinvokeargument name="etiquetas" value="Pa&iacute;s,Descripción Impuesto"/> 
										<cfinvokeargument name="formatos" value="S,S"/> 
										<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
																				and a.CAid = #form.CAid#
																				order by a.Ppaisori"/> 
										<cfinvokeargument name="align" value="left,left"/> 
										<cfinvokeargument name="ajustar" value="N"/> 
										<cfinvokeargument name="checkboxes" value="N"/> 
										<cfinvokeargument name="irA" value="listaCodigoAduanal.cfm"/> 								
										<cfinvokeargument name="showEmptyListMsg" value="true"/>
										<cfinvokeargument name="keys" value="Ppaisori"/> 
										<cfinvokeargument name="debug" value="N"/>
										<cfinvokeargument name="PageIndex" value="2"/>
										<cfinvokeargument name="navegacion" value="#navegacionDet#"/>
										<cfinvokeargument name="mostrar_filtro" value="true"/>
										<cfinvokeargument name="filtrar_automatico" value="true"/>														
										<cfinvokeargument name="filtrar_por" value="c.Pnombre,d.Idescripcion"/>			
										<cfinvokeargument name="maxRows" value="15"/>
									</cfinvoke>											
								</td>
							</tr>
						</cfif>
				</table>	
			</td></tr>
	</table>
	<!----*************************************************************--->
	<script language="JavaScript1.2" type="text/javascript">
	var validar = true;
	var ModificaEncabezado ='';
	
	function validaExiste(obj){
		if (obj.value != ''){
			<cfoutput>
			var codigo = '';
			<cfloop query="rsCAcodigo">
				codigo = '#rsCAcodigo.CAcodigo#';
				if ( trim(obj.value) == trim(codigo) ){
					alert('El Código Aduanal digitado ya existe!');
					obj.value = '';
					return false;
				}
			
			</cfloop>
			</cfoutput>
		}	
	}
	function valida(){
		if (validar){
			var error = false;
			var mensaje = "Se presentaron los siguientes errores:\n";
			// Validacion de Encabezado	
			if ( trim(document.form1.CAcodigo.value) == '' ){
				error = true;
				mensaje += " - El campo Código es requerido.\n";
			}

			if ( trim(document.form1.CAdescripcion.value) == '' ){
				error = true;
				mensaje += " - El campo Descripción es requerido.\n";
			}

			if ( trim(document.form1.porcCIF.value) == '' ){
				error = true;
				mensaje += " - El campo % Gastos y Fletes CIF del Encabezado es requerido.\n";
			}
			
			if ( trim(document.form1.porcFOB.value) == '' ){
				error = true;
				mensaje += " - El campo % Gastos y Fletes FOB  del Encabezado es requerido.\n";
			}

			if ( trim(document.form1.porcSegLoc.value) == '' ){
				error = true;
				mensaje += " - El campo % Seguros Locales  del Encabezado es requerido.\n";
			}

			if ( trim(document.form1.porcFletLoc.value) == '' ){
				error = true;
				mensaje += " - El campo Fletes Locales  del Encabezado es requerido.\n";
			}

			if ( trim(document.form1.porcAgeAdu.value) == '' ){
				error = true;
				mensaje += " - El campo % Gastos Agencia Aduanal del Encabezado es requerido.\n";
			}
			
			if ( trim(document.form1.LImpuestos.value) == '' ){
				error = true;
				mensaje += " - El campo Impuestos  del Encabezado es requerido.\n";
			}

			/* Valida campos encabezado sean menor a 100 */
			if ( new Number(qf(document.form1.porcCIF.value)) > 100 ){
				error = true;
				mensaje += " - El campo % Gastos y Fletes CIF  del Encabezado  debe ser menor que 100.\n";
			}
			
			if ( new Number(qf(document.form1.porcFOB.value)) > 100 ){
				error = true;
				mensaje += " - El campo % Gastos y Fletes FOB debe ser menor que 100.\n";
			}
			
			if ( new Number(qf(document.form1.porcSegLoc.value)) > 100 ){
				error = true;
				mensaje += " - El campo % Seguros Locales  del Encabezado  debe ser menor que 100.\n";
			}
			
			if ( new Number(qf(document.form1.porcFletLoc.value)) > 100 ){
				error = true;
				mensaje += " - El campo % Fletes Locales del Encabezado  debe ser menor que 100.\n";
			}
			
			if ( new Number(qf(document.form1.porcAgeAdu.value)) > 100 ){
				error = true;
				mensaje += " - El campo % Gastos de Agencia Aduanal  del Encabezado debe ser menor que 100.\n";
			}
		<!--- ************************** Validacion del detalle ************************ --->
		<cfif modo neq 'ALTA'>
		 	if (ModificaEncabezado != 'btnModificarE'){
				if ( trim(document.form1.DporcCIF.value) == '' ){
					error = true;
					mensaje += " - El campo % Gastos y Fletes CIF del Detalle es requerido.\n";
				}
				
				if ( trim(document.form1.DporcFOB.value) == '' ){
					error = true;
					mensaje += " - El campo % Gastos y Fletes FOB del Detalle es requerido.\n";
				}

				if ( trim(document.form1.DporcSegLoc.value) == '' ){
					error = true;
					mensaje += " - El campo % Seguros Locales del Detalle es requerido.\n";
				}

				if ( trim(document.form1.DporcFletLoc.value) == '' ){
					error = true;
					mensaje += " - El campo Fletes Locales del Detallees requerido.\n";
				}

				if ( trim(document.form1.DporcAgeAdu.value) == '' ){
					error = true;
					mensaje += " - El campo % Gastos Agencia Aduanal del Detalle es requerido.\n";
				}
				
				if ( trim(document.form1.DLImpuestos.value) == '' ){
					error = true;
				mensaje += " - El campo Impuestos del Detalle es requerido.\n";
				}
				
				if ( trim(document.form1.LPaises.value) == '' ){
					error = true;
					mensaje += " - El campo País del Detalle es requerido.\n";
				}	
				/* Valida campos del detalle sean menor a 100 */
				if ( new Number(qf(document.form1.DporcCIF.value)) > 100 ){
					error = true;
					mensaje += " - El campo % Gastos y Fletes CIF del Detalle debe ser menor que 100.\n";
				}
				
				if ( new Number(qf(document.form1.DporcFOB.value)) > 100 ){
					error = true;
					mensaje += " - El campo % Gastos y Fletes FOB del Detalle debe ser menor que 100.\n";
				}
				
				if ( new Number(qf(document.form1.DporcSegLoc.value)) > 100 ){
					error = true;
					mensaje += " - El campo % Seguros Locales del Detalle debe ser menor que 100.\n";
				}
				
				if ( new Number(qf(document.form1.DporcFletLoc.value)) > 100 ){
					error = true;
					mensaje += " - El campo % Fletes Locales del Detalle debe ser menor que 100.\n";
				}
				
				if ( new Number(qf(document.form1.DporcAgeAdu.value)) > 100 ){
					error = true;
					mensaje += " - El campo % Gastos de Agencia Aduanal del Detalle debe ser menor que 100.\n";
				}
			}
			document.form1.LPaises.disabled = false;
		</cfif>	
			
			if ( error ){
				alert(mensaje);
				return false;
			}else{
				return true;
			}
		}
	}

	function porcentaje(obj) {
		if ( parseFloat(qf(obj.value)) > 100) {
			alert(obj.alt + " no puede ser mayor a cien!");
			obj.value='0.00';
			return false;
		}
	}		
	<cfif modo EQ 'ALTA'>
		function funcRegresarE(){
	<cfelse>
		function funcRegresar(){
	</cfif>				
			validar=false;
		}

	function funcbtnModificarE(){
		ModificaEncabezado = 'btnModificarE';
	}	
	function funcbtnBorrarE(){
		if ( confirm('Desea eliminar el Código Aduanal?') ){
			validar=false; 
			return true;
		}else{
			return false;
		}
	}		
	function funcbtnNuevo(){
		validar=false;
	}						
	function funcbtnNuevoD(){
		validar=false;			
	}
	function funcbtnBorrarD(){
		if ( confirm('Desea eliminar el impuesto de detalle?') ){
			document.form1.LPaises.disabled = false;
			validar=false; 
			return true;
		}else{
			return false;
		}			
	}
	<cfif modo EQ 'ALTA'>
		document.form1.CAcodigo.focus();
	<cfelse>
		document.form1.DporcCIF.focus();
	</cfif>
	function funcFiltrar2(){
		<cfoutput>
			<cfif isdefined("form.Pagina") and len(trim(form.Pagina))>
				document.lista.PAGINA.value ='#form.Pagina#';
			</cfif>	
			<cfif isdefined("form.Pagina2") and len(trim(form.Pagina2))>
				document.lista.PAGINA2.value ='#form.Pagina2#';
			</cfif>	

			<cfif isdefined("form.FILTRO_CACODIGO") and len(trim(form.FILTRO_CACODIGO))>
				document.lista.FILTRO_CACODIGO.value ='#form.FILTRO_CACODIGO#';
			</cfif>							
			<cfif isdefined("form.FILTRO_CADESCRIPCION") and len(trim(form.FILTRO_CADESCRIPCION))>
				document.lista.FILTRO_CADESCRIPCION.value ='#form.FILTRO_CADESCRIPCION#';
			</cfif>	
			<cfif isdefined("form.FILTRO_IDESCRIPCION") and len(trim(form.FILTRO_IDESCRIPCION))>
				document.lista.FILTRO_IDESCRIPCION.value ='#form.FILTRO_IDESCRIPCION#';
			</cfif>			
			<cfif isdefined("form.CAID") and len(trim(form.CAID))>
				document.lista.CAID.value ='#form.CAID#';
			</cfif>
			<cfif isdefined("form.PPAISORI") and len(trim(form.PPAISORI))>
				document.lista.PPAISORI.value ='#form.PPAISORI#';
			</cfif>		
		</cfoutput>		 
		document.lista.submit();																	
	}
</script>