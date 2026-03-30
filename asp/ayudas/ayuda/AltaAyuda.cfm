<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>
<cfparam name="form.AyudaCabId" default="">
<cfparam name="form.SScodigo" default="">
<cfparam name="form.SMcodigo" default="">
<cfparam name="form.SPcodigo" default="">
	<cfif isDefined("url.modo")>
			<cfset form.modo = url.modo>
		<cfelse>
			<cfset form.modo = 'CONSULTA'>
	</cfif>

	<!---	validacion del modal	--->

	<cfif isdefined('url.modal') >

		<cfset lvarAyudaDetalleId="0">
		<cfif isdefined('url.AyudaDetalleId') and len(url.AyudaDetalleId) GT 0 >
		  <cfset form.lvarAyudaDetalleId="#url.AyudaDetalleId#">
		</cfif>

		<cfset lvarAyudaCabId="0">
		<cfif isdefined('url.AyudaCabId') and len(url.AyudaCabId) GT 0 >
		    <cfset form.lvarAyudaCabId="#url.AyudaCabId#">    
		</cfif>

			<cfquery name="rsForm" datasource="asp">
		    	select AyudaCabId, AyudaDetalleId, AyudaDetalleTitulo, AyudaDetallePos, AyudaDetalleText from AyudaDetalle where 1=1 

		        <cfif isdefined("form.lvarAyudaCabId") and #Len(Trim("form.lvarAyudaCabId"))# gt 0 >	       
		            and AyudaCabId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.AyudaCabId#">
		       </cfif>

		        <cfif isdefined("form.lvarAyudaDetalleId") and #Len(Trim("form.lvarAyudaDetalleId"))# gt 0 >
		            and AyudaDetalleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.AyudaDetalleId#">
		        </cfif>
		    </cfquery>	

				<cfquery name="rsInfoCab" datasource="asp">
					SELECT *
					FROM AyudaCabecera
					WHERE AyudaCabId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.lvarAyudaCabId#">
				</cfquery>

				<cfquery name="rsLanguagesCode" datasource="sifcontrol">
					SELECT DISTINCT (LTRIM(RTRIM(Icodigo))) AS Icodigo
					FROM Idiomas
				</cfquery>

				<!--- Creacion de tabla temporal --->
				<cf_dbtemp name="TabLanguajesTemp" returnvariable="TabLanguajesTemp" datasource="#session.dsn#">
					<cf_dbtempcol name="IdLanguage" type="numeric" identity="true" mandatory="true">
					<cf_dbtempcol name="Codigo" type="varchar(20)">
					<cf_dbtempcol name="Description" type="varchar(250)">
				</cf_dbtemp>
				<cfset LvarTablaTemp = TabLanguajesTemp>

				<cfif rsLanguagesCode.recordCount GT 0>
					<cfoutput query="rsLanguagesCode">
						<cfquery name="rsLanguagesDescrip" datasource="#session.dsn#">
							SELECT MIN(Descripcion) as Descripcion FROM Idiomas WHERE Icodigo = <cf_jdbcquery_param value='#Icodigo#' cfsqltype="cf_sql_varchar">
						</cfquery>
					<cfquery name="rsInsertTempCode" datasource="#session.dsn#">
						INSERT INTO #LvarTablaTemp# (Codigo, Description)
						values (<cf_jdbcquery_param value='#Icodigo#' cfsqltype="cf_sql_varchar">,
						<cf_jdbcquery_param value='#rsLanguagesDescrip.Descripcion#' cfsqltype="cf_sql_varchar">)
					</cfquery>
					</cfoutput>
				</cfif>

				<cfquery name="rsLanguages" datasource="#session.dsn#">
					SELECT *
					FROM #LvarTablaTemp#
					WHERE Codigo =  <cf_jdbcquery_param value='#rsInfoCab.AyudaIdioma#' cfsqltype="cf_sql_varchar">
					ORDER BY Description
				</cfquery>

	</cfif> 

	<cfif isDefined("url.AyudaCabIdVar")>
		<cfset form.AYUDACABID = url.AyudaCabIdVar>
	</cfif>

	<cfif isDefined("url.SScodigo")>
		<cfset form.SScodigo = url.SScodigo></cfif>

	<cfif isDefined("url.SMcodigo")>
		<cfset form.SMcodigo = url.SMcodigo></cfif>

	<cfif isDefined("url.SPcodigo")>
		<cfset form.SPcodigo = url.SPcodigo></cfif>

	<cfif isDefined("url.fSScodigo")>
		<cfset form.fSScodigo = url.fSScodigo>
	</cfif>
	<cfif isDefined("url.fSMcodigo")>
		<cfset form.fSMcodigo = url.fSMcodigo>
	</cfif>
	<cfif isDefined("url.fSPcodigo")>
		<cfset form.fSPcodigo = url.fSPcodigo>
	</cfif>

	<cfif (isdefined("form.modo") and Len(Trim(form.modo)) gt 0)>
		<cfelse>
			<cfset form.modo="ALTA"/>
	</cfif>

	<cfquery name="rsSelect" datasource="asp">
		select ac.AyudaCabId as AyudaCabId, ac.AyudaCabTitulo as AyudaCabTitulo, ss.SSdescripcion as SSdescripcion,
		sm.SMdescripcion as SMdescripcion,  sp.SPdescripcion as SPdescripcion, ac.SScodigo, ac.SMcodigo, ac.SPcodigo
		from AyudaCabecera ac
		join SSistemas ss on ac.SScodigo = ss.SScodigo
		join SModulos sm on ac.SMcodigo = sm.SMcodigo
		left join SProcesos sp on ac.SPcodigo = sp.SPcodigo where 1=1
	</cfquery>

		<cfquery name="rsSistemas" datasource="asp">
			select SScodigo, SSdescripcion
			from SSistemas
			order by SSdescripcion
		</cfquery>

		<cfquery name="rsModulos" datasource="asp">
			select SScodigo, SMcodigo, SMdescripcion
			from SModulos
			order by SMdescripcion
		</cfquery>

	    <cfquery name="rsProcesos" datasource="asp">
			select SScodigo, SMcodigo, SPcodigo, SPdescripcion from SProcesos
			order by SScodigo, SMcodigo, SPcodigo
		</cfquery>

				<cfset filtroAlta = '' >
				<cfif isdefined("form.fSScodigo") and len(trim(form.fSSCodigo)) gt 0>
					<cfset filtroAlta = " and a.SScodigo = '#form.fSScodigo#' ">
				</cfif>
				<cfif isdefined("form.fSMcodigo") and len(trim(form.fSMCodigo)) gt 0>
					<cfset filtroAlta = filtroAlta & " and a.SMcodigo = '#form.fSMcodigo#' ">
				</cfif>
				<cfif isdefined("form.fSPcodigo") and len(trim(form.fSPCodigo)) gt 0>
					<cfset filtroAlta = filtroAlta & " and a.SMcodigo = '#form.fSPcodigo#' ">
				</cfif>

		<cfif isdefined("form.Agregar") and len(trim(form.Agregar)) gt 0>

			<cfif ToString(form.FSSCODIGO) eq 0 || ToString(form.FSMCODIGO) eq 0>
				<cflocation url="AltaAyuda.cfm?modo=ALTA">
			<cfelse>
				<cfquery name="insert_FMT001" datasource="asp">
					insert into AyudaCabecera (AyudaCabTitulo, Usucodigo, SScodigo, SMcodigo, SPcodigo)
						values(
							<cf_jdbcquery_param value="#form.nombre#"   cfsqltype="cf_sql_varchar">,
							<cf_jdbcquery_param value="#session.usucodigo#" cfsqltype="cf_sql_integer">,
							<cf_jdbcquery_param value="#form.FSSCODIGO#"   cfsqltype="cf_sql_varchar">,
							<cf_jdbcquery_param value="#form.FSMCODIGO#"   cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#form.FSPCODIGO#"   cfsqltype="cf_sql_varchar"  >
						)
				</cfquery>
				<cflocation url="ListaAyuda.cfm?_">
			</cfif>

		</cfif>

		<cfif isdefined("form.btnGuardar") and len(trim(form.Agregar)) gt 0>
			<cfquery name="insertCab" datasource="asp">
				insert into AyudaCabecera (AyudaCabTitulo, Usucodigo, SScodigo, SMcodigo, SPcodigo)
 					values(
						<cf_jdbcquery_param value="#form.nombre#"   cfsqltype="cf_sql_varchar">,
						<cf_jdbcquery_param value="#session.usucodigo#" cfsqltype="cf_sql_integer">,
						<cf_jdbcquery_param value="#form.FSSCODIGO#"   cfsqltype="cf_sql_varchar">,
						<cf_jdbcquery_param value="#form.FSMCODIGO#"   cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#form.FSPCODIGO#"   cfsqltype="cf_sql_varchar"  >
					)
			</cfquery>
			<cflocation url="ListaAyuda.cfm?_">
		</cfif>

		<cfif isdefined("form.btnModificarCab")>
			<cfquery name="updateAyudaCab" datasource="asp">
				update AyudaCabecera
					set
					AyudaCabTitulo=<cf_jdbcquery_param value="#form.nombre#"   cfsqltype="cf_sql_varchar">,
					SScodigo = <cf_jdbcquery_param value="#form.FSSCODIGO#"   cfsqltype="cf_sql_varchar">,
					SMcodigo = <cf_jdbcquery_param value="#form.FSMCODIGO#"   cfsqltype="cf_sql_varchar">,
					SPcodigo= <cf_jdbcquery_param value="#form.FSPCODIGO#"   cfsqltype="cf_sql_varchar">
					where AyudaCabId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ayudaCabIdHidden#">
			</cfquery>
			<cflocation url="ListaAyuda.cfm?_">
		</cfif>

		<cfif modo neq 'ALTA'>
			<cfif isDefined("url.AyudaCabId")>
				<cfset form.AYUDACABID = url.AyudaCabId>
			</cfif> 

			<cfquery name="Cabecera" datasource="asp">
				select AyudaCabTitulo, SScodigo, SMcodigo, SPcodigo, AyudaIdioma from AyudaCabecera where AyudaCabId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AYUDACABID#">
			</cfquery>
		</cfif>

		<cfquery name="rsLanguagesCode" datasource="sifcontrol">
		SELECT DISTINCT (LTRIM(RTRIM(Icodigo))) AS Icodigo
		FROM Idiomas
	</cfquery>

	<!--- Creacion de tabla temporal --->
	<cf_dbtemp name="TabLanguajesTemp" returnvariable="TabLanguajesTemp" datasource="#session.dsn#">
		<cf_dbtempcol name="IdLanguage" type="numeric" identity="true" mandatory="true">
		<cf_dbtempcol name="Codigo" type="varchar(20)">
		<cf_dbtempcol name="Description" type="varchar(250)">
	</cf_dbtemp>
	<cfset LvarTablaTemp = TabLanguajesTemp>

	<cfif rsLanguagesCode.recordCount GT 0>
		<cfoutput query="rsLanguagesCode">
			<cfquery name="rsLanguagesDescrip" datasource="#session.dsn#">
				SELECT MIN(Descripcion) as Descripcion FROM Idiomas WHERE Icodigo = <cf_jdbcquery_param value='#Icodigo#' cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfquery name="rsInsertTempCode" datasource="#session.dsn#">
			INSERT INTO #LvarTablaTemp# (Codigo, Description)
			values (<cf_jdbcquery_param value='#Icodigo#' cfsqltype="cf_sql_varchar">,
			<cf_jdbcquery_param value='#rsLanguagesDescrip.Descripcion#' cfsqltype="cf_sql_varchar">)
		</cfquery>
		</cfoutput>
	</cfif>


	<cfquery name="rsLanguages" datasource="#session.dsn#">
		SELECT *
		FROM #LvarTablaTemp#
		WHERE
		<cfif isdefined("Cabecera.AyudaIdioma")>
			Codigo =  <cf_jdbcquery_param value='#Cabecera.AyudaIdioma#' cfsqltype="cf_sql_varchar">
		<cfelse>
			Codigo =  <cf_jdbcquery_param value='#session.Idioma#' cfsqltype="cf_sql_varchar">
		</cfif>
		ORDER BY Description
	</cfquery>

	<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
		<script type="text/javascript" src="/cfmx/jquery/librerias/jquery.bootstrap.wizard.min.js"></script>

		<script type="text/javascript" src="/cfmx/rh/js/ckeditor/ckeditor.js"></script>
		<!---	funcion de correcion de error -show dialog (select vacio al perder el focus)--->
		<script type="text/javascript">
			$.widget( "ui.dialog", $.ui.dialog, {

					_allowInteraction: function( event ) {
					if ( this._super( event ) ) {
					  return true;
					}

					if ( event.target.ownerDocument != this.document[ 0 ] ) {
					  return true;
					}

					if ( $( event.target ).closest( ".cke_dialog" ).length ) {
					  return true;
					}

					if ( $( event.target ).closest( ".cke" ).length ) {
					  return true;
					}
					},

			  	_moveToTop: function ( event, silent ) {
				    if ( !event || !this.options.modal ) {
				      this._super( event, silent );
				    }
				  }
			});</script>
        <script type="text/javascript">
                          
			var editor, html = '';
			var config = {};

			function removeEditor(){
		        if ( !editor )
		                return;
		        editor.destroy();
		        editor = null;
			}
    	</script>
	    <div id="editor" style="display: none;">
		    	<cfif isdefined('url.modal') >
		    		<form name="form"  method="post" action="SQLAyuda.cfm" enctype="multipart/form-data"> 		    		
		    			<br/>
			    		<table width="100%" class="areaFiltro">
			            <tr>
							<td width="2%"></td>
							<td colspan="2"><b>Idioma cabecera:</b></td>
							<cfoutput><td colspan="4">#rsLanguages.Description#&nbsp;</td></cfoutput>
						</tr>
						<tr>
			                <td width="2%"></td>

						<input name="AyudaCabId" type="hidden" value=
							<cfif isdefined('url.AyudaCabId')>
								"<cfoutput>#url.AyudaCabId#</cfoutput>"
							<cfelse>
								"<cfoutput>#form.lvarAyudaCabId#</cfoutput>"
							</cfif>
						>			
			                <cfif isdefined("url.AyudaDetalleId") and #Len(Trim("url.AyudaDetalleId"))# gt 0 >
			                		
			                    <td width="1%">
			                        <b>Orden:</b>
			                    </td>
			                    <td width="18%">                        
			                            <input size="10" maxlength="10" name="AyudaDetallePos" value="<cfoutput>#rsForm.AyudaDetallePos#</cfoutput>" alt="C&oacute;digo">
			                    </td>
			                <cfelse>
			                    <td width="1%">
			                        <b>Orden:</b>
			                    </td>
			                    <td width="18%">                        
			                            <input size="10" maxlength="10" name="AyudaDetallePos" value="">                                                
			                    </td>
			                </cfif> 
			                <td width="3%">
			                    <b>Título:</b>
			                </td>
			                <td>
			                    <cfif isdefined("url.AyudaDetalleId") and #Len(Trim("url.AyudaDetalleId"))# gt 0 >
			                        <input name="AyudaDetalleTitulo" value="<cfoutput>#rsForm.AyudaDetalleTitulo#</cfoutput>" size="35" maxlenght="50" alt="Titulo">
			                    <cfelse>
			                        <input name="AyudaDetalleTitulo" value="" size="35" maxlenght="50" alt="Titulo">
			                    </cfif>			                    	                                                   
			                </td>              
			                <td width="30%"></td>
			                <td>                  
			                    <cfif isdefined("url.AyudaDetalleId") and #Len(Trim("url.AyudaDetalleId"))# gt 0 >
			                        <input type="submit" name="btnModificar" class="btnGuardar" value="Guadar" onclick="javascript:h( this );" >
			                    <cfelse>
			                        <input type="submit" name="btnGuardar" class="btnGuardar" value="Guadar" onclick="javascript:h( this );" >
			                    </cfif>                  
			                </td>             
			            </tr>
			        	</table>
			        	<br/>
			        	<cfif isdefined("url.AyudaDetalleId") and #Len(Trim("url.AyudaDetalleId"))# gt 0 >
				            <input type="hidden" name="AyudaDetalleText" value='<cfoutput>#rsForm.AyudaDetalleText#</cfoutput>' >
				        <cfelse>
				            <input type="hidden" name="AyudaDetalleText" value='' >
				            
				        </cfif>

				        <cfif isdefined("url.AyudaDetalleId") and #Len(Trim("url.AyudaDetalleId"))# gt 0 >
				            <input type="hidden" name="AyudaDetalleId" value='<cfoutput>#rsForm.AyudaDetalleId#</cfoutput>' >
				        <cfelse>
				            <input type="hidden" name="AyudaDetalleId" value='' >			            
				        </cfif>

				        <!---	textarea del modal	--->
				        <textarea id="editor1" name="editor1">	        	
				        </textarea>  

			        </form>

		        </cfif>			
	    </div>
        
		<!---	validacion del modal	--->
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Mantenimiento de Ayuda'>
			<cfinclude template="/home/menu/pNavegacion.cfm">
				<div class="container-fluid">
				<div class="row">
					<div class="col-md-12">
						<cfoutput>
							<form name="filtroAlta"  method="post" onSubmit="return validar();" action="AltaAyuda.cfm" enctype="multipart/form-data" autocomplete="off">
									<cfif isdefined("form.AYUDACABID") and len(trim(form.AYUDACABID)) gt 0>
										<input type="hidden" name="ayudaCabIdHidden" value="#form.AYUDACABID#">
									</cfif>

									<cfif isdefined("form.fSScodigo") and len(trim(form.fSScodigo)) gt 0>
										<input type="hidden" name="fSScodigo" value="#form.fSScodigo#">
									</cfif>
									<cfif isdefined("form.fSMcodigo") and len(trim(form.fSMcodigo)) gt 0>
										<input type="hidden" name="fSMcodigo" value="#form.fSMcodigo#">
									</cfif>
									<cfif isdefined("form.fProceso" ) and len(trim(form.fProceso )) gt 0>
										<input type="hidden" name="fProceso" value="#form.fProceso#">
									</cfif>
								<div class="row">&nbsp;</div>
								<div class="row">
									<div class="col-md-12">
										<div align="right" class="col-md-10">
											<b>Idioma:&nbsp;</b>
										</div>
										<div  align="left" class="col-md-2">
											<cfif isdefined("rsLanguages.Description")>
												<cfoutput>&nbsp;#rsLanguages.Description#</cfoutput>
											<cfelse>
												&nbsp;
											</cfif>

										</div>
									</div>
								</div>
								<div class="row">&nbsp;</div>
								<div class="row">
									<div class="col-md-12">
										<div class="col-md-3">
											<b class="sistema">Sistema:</b>
										</div>
										<div class="col-md-3">
											<b class="modulo">M&oacute;dulo:</b>
										</div>
										<div class="col-md-3">
											<b class="proceso">Proceso:</b>
										</div>
										<div class="col-md-3">
											<b class="proceso">Nombre:</b>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-md-12">
										<div class="col-md-3">
											<select name="fSScodigo" class="fSScodigo" style="width:222px" onChange="javascript:change_sistema( document.filtroAlta);">
												<option value="0">--Todos--</option>
														<cfloop query="rsSistemas">
															<option value="#rsSistemas.SScodigo#"
																<cfif modo neq 'ALTA' and '#Cabecera.SScodigo#' eq '#rsSistemas.SScodigo#'>
																	selected
																</cfif>>
																#rsSistemas.SScodigo#
															</option>
														</cfloop>
											</select>
										</div>
										<div class="col-md-3">
											<select name="fSMcodigo" class="fSMcodigo" style="width:222px" onChange="javascript:change_modulo( document.filtroAlta);">
												<option value="">--Todos--</option>
											</select>
										</div>
										<div class="col-md-3">
											<select name="fSPcodigo" class="fSPcodigo" style="width:222px">
												<option value="0">--Ninguno--</option>
											</select>
										</div>
										<div class="col-md-3">
										<cfif modo neq 'ALTA'>
											<input class="nombre" name="nombre" type="text" required="true" style="width:222px" value="#cabecera.AyudaCabTitulo#" >
										<cfelse>
											<input class="nombre" name="nombre" placeholder="Nombre" type="text" required="true" style="width:222px">
										</cfif>
										</div>
									</div>
								</div>
								<div class="row">&nbsp;</div>
								<div class="row">
									<div class="col-md-12">
										<div class="text-center">
											<cfif modo neq 'ALTA'>

														<input type="submit" name="btnModificarCab" value="Guardar" class="btnModificarCab">

														<input type="button" name="Eliminar" value="Eliminar" class="BtnEliminar" onClick="EliminarAyudaCabecera();">

													<cfelse>
														<input type="submit" name="Agregar" value="Agregar"  class="btnGuardar" onClick="validarInput();">
											</cfif>
										</div>
									</div>
								</div>
								<div id="popupViewNew" style="display: none;"></div>
								<div class="row">
									<div class="col-md-12">
										&nbsp;
									</div>
								</div>
								<cfif modo neq 'ALTA'>
									<div class="row">
										<div class="col-md-12">
											<!-- Nav tabs -->
											<ul class="nav nav-tabs" role="tablist">
												<li role="presentation" class="active">
													<a href="##Articulos" aria-controls="Articulos" role="tab" data-toggle="tab">Art&iacute;culos</a>
												</li>
												<li role="presentation">
													<a href="##relacionados" aria-controls="relacionados" role="tab" data-toggle="tab">Art&iacute;culos relacionados</a>
												</li>
											</ul>
											<!-- Tab panes -->
												<div class="tab-content">
													<div role="tabpanel" class="tab-pane active" id="Articulos">
															<div id="TablaArticulos"></div>
													</div>
													<div role="tabpanel" class="tab-pane" id="relacionados">
															<div id="TablaArticulosRelacionados"></div>
													</div>
												</div>
										</div>
									</div>
								</cfif>

								<div class="row">
									<div class="col-md-12">
										&nbsp;
								</div>
							</form>


						</cfoutput>
					</div>
				</div>
				</div>

				<div id="popupEditar" style="display: none;">
				</div>

				<div id="dialog-confirmEli"></div>

		<cf_web_portlet_end>
	<cf_templatefooter>

	<script language="javascript1.2" type="text/javascript">

		function validarInput(){
			var mensaje = 'Los campos de Sistema y Módulo deben tener asignados valores\n';

			if ( $('.fSScodigo option:selected').text() == '--Todos--' || $('.fSMcodigo option:selected').text() == '')
				{	alert(mensaje);	}
		}

		function validar(){
			var error   = false;
			var mensaje = 'Se presentaron los siguientes errores:\n';
			if ( String($('.fSScodigo option:selected').val()) == '' ){
				error = true;
				mensaje += ' - El campo Sistema es requerido.\n'
			}
			if ( String($('.fSMcodigo option:selected').val()) == '' ){
				error = true;
				mensaje += ' - El campo Módulo es requerido.\n'
			}
			if ( error ){
				alert(mensaje);
				return false;
			}
			return true;
		}

		function translateArticulo(detHelpId, cabHelpId){
			$.ajax({
					type: "GET",
					url: "/cfmx/asp/ayudas/ayuda/ModalTranslateArticle.cfm?AyudaDetalleId="+detHelpId+"&AyudaCabId="+cabHelpId,
					success: function(result){
						$("#popupEditar").html(result);
					}
				});
				$("#popupEditar").dialog({
					width: 960,
					modal:true,
					title:"Traducir articulo",
					height: 550,
					resizable: "false",
				});
		}

		function openEditor()
		{
       		if (editor){
	                return;}

	        $("#editor").bind('dialogopen', function()
	        {
	            editor = CKEDITOR.replace( 'editor1', {
			        on: {
				            instanceReady: function( evt ) {
				            var oEditor = CKEDITOR.instances.editor1;
				            var texto = $('input[name=AyudaDetalleText]').val();  
				            oEditor.insertHtml(texto);
				            }
				        }
	    		});

	        }).bind('dialogclose', function()
	        {
                removeEditor();
                $(this).dialog('destroy');
	        })
	        .dialog({autoOpen: false,
                maxHeight:0.95 * $(window).height(),
                width: 900,
                modal: true,
                position:  ['center',60],
                resizable: true,
                autoResize: true }).dialog('open');
		}

		function NuevoArticulosModal()
		{				
			window.location.replace("AltaAyuda.cfm?AyudaCabId="+

				<cfif isdefined("form.AYUDACABID") and len(trim(form.AYUDACABID)) gt 0>
					<cfoutput>#form.AYUDACABID#</cfoutput>
				<cfelse>
					0
				</cfif>
			+"&modal=NEW");
		}

		function EliminarAyudaCabecera(){
				<cfoutput>#form.AYUDACABID#</cfoutput>
				$("#dialog-confirmEli").html("Deseas eliminar esta cabecera?");
				$("#dialog-confirmEli").dialog({
					resizable: false,
					modal: true,
					title: "Eliminar Articulo",
					height: 120,
					width: 250,
					buttons: {
						"Si": function () {
							var url = "SQLAyuda.cfm?EliminarCab=1&AyudaCabId="+
							<cfif  modo neq 'ALTA'>
								<cfoutput>#form.AYUDACABID#</cfoutput>
							<cfelse>
								0
							</cfif>;
							$(location).attr('href',url);
							$(this).dialog('close');
							callback(true);
						},
							"No": function () {
							$(this).dialog('close');
							callback(false);
						}
					}
				});
		}

		function GuardarAyudaCabecera(){
				<cfoutput>#form.AYUDACABID#</cfoutput>
				$("#dialog-confirmEli").html("Deseas Actualizar esta cabecera?");
				$("#dialog-confirmEli").dialog({
					resizable: false,
					modal: true,
					title: "Actualizar cabecera",
					height: 120,
					width: 250,
					buttons: {
						"Si": function () {
							var url = "SQLAyuda.cfm?ActualizarCab=1&AyudaCabId="+

							<cfif  modo neq 'ALTA'>
								<cfoutput>#form.AYUDACABID#</cfoutput>
							<cfelse>
								0
							</cfif>;
							$(location).attr('href',url);
							$(this).dialog('close');
							callback(true);
						},
							"No": function () {
							$(this).dialog('close');
							callback(false);
						}
					}
				});
		}

		function eliminarModal(AyudaDetalleId, AyudaCabId){
				$("#dialog-confirmEli").html("Deseas eliminar el artículo?");
				// Define the Dialog and its properties.
				$("#dialog-confirmEli").dialog({
					resizable: false,
					modal: true,
					title: "Eliminar artículo",
					height: 120,
					width: 250,
					buttons: {
						"Si": function () {
							var url = "SQLAyuda.cfm?Eliminar=1&AyudaDetalleId="+AyudaDetalleId+"&AyudaCabId="+AyudaCabId;
							$(location).attr('href',url);
							$(this).dialog('close');
							callback(true);
						},
							"No": function () {
							$(this).dialog('close');
							callback(false);
						}
					}
				});
		}

		function eliminarModalRef(AyudaODId, AyudaCabId){
				$("#dialog-confirmEli").html("Deseas eliminar el artículo relacionado?");
				// Define the Dialog and its properties.
				$("#dialog-confirmEli").dialog({
					resizable: false,
					modal: true,
					title: "Eliminar artículo",
					height: 120,
					width: 250,
					buttons: {
						"Si": function () {
							var url = "SQLAyuda.cfm?EliminarRef=1&AyudaODId="+AyudaODId+"&AyudaCabId="+AyudaCabId;
							$(location).attr('href',url);
							$(this).dialog('close');
							callback(true);
						},
							"No": function () {
							$(this).dialog('close');
							callback(false);
						}
					}
				});
		}

		function CerrarModal(){
			$("#popupEditar").dialog({
					modal:false,
			});
		}

		function editarModal(AyudaDetalleId, AyudaCabId){				
			window.location.replace("AltaAyuda.cfm?modo=CONSULTA&AyudaDetalleId="+AyudaDetalleId+"&AyudaCabId="+AyudaCabId+"&modal=ON");
		}

		function NuevoArticulosRelModal()
				{
				$.ajax({
					type: "POST",
					url: '/cfmx/asp/ayudas/ayuda/ModalAyudaRel.cfm?AyudaCabIdVar='+
					<cfif  modo neq 'ALTA'>
					<cfoutput>#form.AYUDACABID#</cfoutput>
					<cfelse>
					0
					</cfif>,
					success: function(result){
						$("#popupEditar").html(result);
					}
				});

				$("#popupEditar").dialog({
					width: 360,
					modal:true,
					title:"Editar sección de ayuda",
					height: 200,
					resizable: "false",
				});
		}

		function funcTablaArticulos(AyudaCabId){

			$.ajax({
				type: 'POST',
				url:'/cfmx/asp/ayudas/ayuda/ODAyudaAjax.cfc?method=TablaArticulosF&AyudaCabIdVar='+AyudaCabId,
				success: function(results) {
					$("#TablaArticulos").html(results);
				},
				error: function() {
					console.log("error");  }
			});
		}

		function funcTablaArticulosRelacionados(AyudaCabId){
			$.ajax({
				type: 'POST',
				url:'/cfmx/asp/ayudas/ayuda/ODAyudaAjax.cfc?method=funcTablaArticulosRelacionados&AyudaCabIdVarRel='+AyudaCabId,
				data: $("#FormVariablesSql").serialize(),
				success: function(results) {
					$("#TablaArticulosRelacionados").html(results);
				},
				error: function() {

				}
			});
		}

		window.onload = funcTablaArticulos(<cfoutput>#form.AYUDACABID#</cfoutput>);
		window.onload = funcTablaArticulosRelacionados(<cfoutput>#form.AYUDACABID#</cfoutput>);

		function change_sistema(form){
			var obj1=$('.fSScodigo option:selected');
					if (form.name == 'filtroAlta'){
						combo = filtroAlta.fSMcodigo;
						}
					combo.length = 0;
					var cont = 0;

					if (form.name != 'filtroAlta'){
						combo.length = cont+1;
						combo.options[cont].value = '';
						combo.options[cont].text = '--Todos--';
						cont = 1;
					}

					<cfloop query="rsModulos">
						if ((obj1.val().replace(/\s/g, '')) == ("<cfoutput>#rsModulos.SScodigo#</cfoutput>").replace(/\s/g, '')) {
							combo.length = cont+1;
							combo.options[cont].value = '<cfoutput>#rsModulos.SMcodigo#</cfoutput>';
							combo.options[cont].text = '<cfoutput>#rsModulos.SMdescripcion#</cfoutput>';

							<cfif  modo neq 'ALTA'>

									if( "<cfoutput>#Cabecera.SMcodigo#</cfoutput>"=="<cfoutput>#rsModulos.SMcodigo#</cfoutput>"){
										$('.fSMcodigo option[value="<cfoutput>#rsModulos.SMcodigo#</cfoutput>"]').attr("selected", "selected");
									}
							</cfif>

							cont = cont + 1;
						}
					</cfloop>
					change_modulo(document.filtroAlta);
		}

		function change_modulo(form){
					var obj2=$('.fSMcodigo option:selected');
					var combo1;
					if (form.name == 'filtroAlta'){
						combo1 = filtroAlta.fSPcodigo;
					}
					combo1.length = 0;
					var cont1 = 0;
						combo1.length = cont1+1;
						combo1.options[cont1].value = '0';
						combo1.options[cont1].text = '--Ninguno--';
						cont1 = 1;
					<cfloop query="rsProcesos">
						if ((obj2.val().replace(/\s/g, '')) == ("<cfoutput>#rsProcesos.SMcodigo#</cfoutput>").replace(/\s/g, '')) {
							combo1.length = cont1+1;
							combo1.options[cont1].value = '<cfoutput>#rsProcesos.SPcodigo#</cfoutput>';
							combo1.options[cont1].text = '<cfoutput>#rsProcesos.SPdescripcion#</cfoutput>';
						<cfif  modo neq 'ALTA'>
							if("<cfoutput>#cabecera.SPcodigo#</cfoutput>"=="<cfoutput>#rsProcesos.SPcodigo#</cfoutput>"){
								combo1.options[cont1].selected = true;
							}
						</cfif>
							cont1 = cont1 + 1;
						}
					</cfloop>
		}

		change_sistema(document.filtroAlta);
	</script>

	<!---	trigger de post para el modal	--->
	<cfif isdefined('url.modal') >
	    <script language="javascript">
			openEditor();
		</script>
	</cfif>