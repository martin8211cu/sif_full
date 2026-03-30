<!--- VARIABLES DE TRADUCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Componentes" Default="Ver Componentes" returnvariable="LB_Componentes" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_TablaSalarial" Default="Tabla Salarial" returnvariable="LB_TablaSalarial" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Categoria" Default="Categoría" returnvariable="LB_Categoria" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Puesto" Default="Puesto" returnvariable="LB_Puesto" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_CodigoCategoria" Default="Código de Categoría" returnvariable="LB_CodigoCategoria" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_DescripcionCategoria" Default="Descripción de Categoría" returnvariable="LB_DescripcionCategoria" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_CodigoPuesto" Default="Código del Puesto" returnvariable="LB_CodigoPuesto" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_DescripcionPuesto" Default="Descripción del Puesto" returnvariable="LB_DescripcionPuesto" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Agregar" Default="Agregar" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_ListaDeTablasSalariales" Default="Lista de tablas salariales" returnvariable="LB_ListaDeTablasSalariales" component="sif.Componentes.Translate" method="Translate">
<cfinvoke Key="LB_ListaDeCategorias" Default="Lista de categorías" returnvariable="LB_ListaDeCategorias" component="sif.Componentes.Translate" method="Translate">
<cfinvoke Key="LB_ListaDePuestosPresupuestarios" Default="Lista de puestos presupuestarios" returnvariable="LB_ListaDePuestosPresupuestarios" component="sif.Componentes.Translate" method="Translate">
<cfinvoke Key="LB_TablaSalarial" Default="Tabla salarial" returnvariable="LB_TablaSalarial" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml">
<cfinvoke Key="LB_DeseaEliminarElRegistro" Default="¿Desea Eliminar el Registro?" returnvariable="LB_DeseaEliminarElRegistro" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml">


<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined('url.RHTTid') and not isdefined('form.RHTTid')>
	<cfset form.RHTTid = url.RHTTid>
</cfif>
	<cf_templateheader template="#session.sitio.template#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#">
			<script src="/cfmx/sif/js/qForms/qforms.js"></script>
			<script language="JavaScript" type="text/JavaScript">
				<!--//
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
				//-->
				
				function funcEliminar(prn_llave){
					if( confirm('<cfoutput>#LB_DeseaEliminarElRegistro#</cfoutput>') ){
						document.form1.RHCPlinea.value = prn_llave;  
						document.form1.submit();					
					}
				}
				function funcAgregar(){
					habilitarValidacion();
				}
				
			</script>
			<cfset ValuesCambioTablas = ArrayNew(1)>
			<cfif isdefined("form.RHTTid") and len(trim(form.RHTTid))>
				<cf_translatedata name="get" tabla="RHTTablaSalarial" col="RHTTdescripcion" returnvariable="LvarRHTTdescripcion">
				<cfquery name="rsTabla" datasource="#session.DSN#">
					select RHTTcodigo, #LvarRHTTdescripcion# as RHTTdescripcion
					from RHTTablaSalarial
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#"> 
				</cfquery>
				<cfset ArrayAppend(ValuesCambioTablas, form.RHTTid)>
				<cfset ArrayAppend(ValuesCambioTablas, rsTabla.RHTTcodigo)>
				<cfset ArrayAppend(ValuesCambioTablas, rsTabla.RHTTdescripcion)>
			</cfif>
			
			<cfif not isdefined("form.btnNuevo") and isdefined("form.RHTTid") and len(trim(form.RHTTid))>
			<cf_dbfunction name="to_char" args="a.RHCPlinea" returnvariable="Lvar_RHCPlinea">
			<cf_dbfunction name="concat" args="'<img border=''0'' onClick=''javascript: funcEliminar('	|#preservesinglequotes(Lvar_RHCPlinea)#|');'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''>'" returnvariable="Lvar_img" delimiters="|">
				<cf_translatedata name="get" tabla="RHTTablaSalarial" col="c.RHTTdescripcion" returnvariable="LvarRHTTdescripcion"> 
				<cf_translatedata name="get" tabla="RHMaestroPuestoP" col="d.RHMPPdescripcion" returnvariable="LvarRHMPPdescripcion"> 
				<cf_translatedata name="get" tabla="RHCategoria" col="b.RHCdescripcion" returnvariable="LvarRHCdescripcion"> 
				
				<cfquery name="rsPuestosCategoria" datasource="#session.DSN#">
					select 	a.RHCid,
							a.RHMPPid,
							a.RHTTid,
							c.RHTTcodigo,
							#LvarRHTTdescripcion# as RHTTdescripcion,
							d.RHMPPcodigo,
							#LvarRHMPPdescripcion# as RHMPPdescripcion,
							b.RHCcodigo,
							#LvarRHCdescripcion# as RHCdescripcion,
							#preservesinglequotes(Lvar_img)# as eliminar,
							<cf_dbfunction name="concat" args="RHCcodigo,' - ',RHCdescripcion"> as Categoria
					from RHCategoriasPuesto a
						inner join RHTTablaSalarial c
							on a.RHTTid = c.RHTTid
						inner join RHMaestroPuestoP d
							on a.RHMPPid = d.RHMPPid
						left outer join RHCategoria b
							on a.RHCid = b.RHCid
					where a.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
					<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
						and a.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">
					</cfif>
					<cfif isdefined("form.RHCid") and len(trim(form.RHCid))>
						and a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
					</cfif>
					order by d.RHMPPcodigo, #LvarRHMPPdescripcion#, c.RHTTcodigo, #LvarRHTTdescripcion#
				</cfquery>
			</cfif>	
			<cfoutput> 
			<table width="98%" border="0" cellspacing="0" align="center">			  
			  <tr><td colspan="6"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
			  	<form name="form1" action="TablaPuestoCategoria-sql.cfm" method="post">
					<input type="hidden" name="RHCPlinea" value="">
					<cfif isdefined("form.RHTTid") and len(trim(form.RHTTid))>
						<tr>
							<td colspan="5" class="titulolistas">
								<strong style="font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;"><cfoutput>#LB_TablaSalarial#: #rsTabla.RHTTcodigo# - #rsTabla.RHTTdescripcion#</cfoutput></strong>
							</td>
						</tr>
					</cfif>
					<tr>
						<td width="2%">&nbsp;</td>
						<td width="27%" id="LabelTabla" <cfif isdefined("form.RHTTid") and len(trim(form.RHTTid))>style="display:none"</cfif>><strong>#LB_TablaSalarial#</strong></td>
						<td width="24%" ><strong>#LB_Categoria#</strong></td>
                        <td><strong>#LB_Puesto#</strong></td>
						<td colspan="2">&nbsp;</td>
					</tr>					
					<tr>
						<td width="2%">&nbsp;</td>
						<td width="27%" id="Tabla" <cfif isdefined("form.RHTTid") and len(trim(form.RHTTid))>style="display:none"</cfif>>			
							<cf_translatedata name="get" tabla="RHTTablaSalarial" col="RHTTdescripcion" returnvariable="LvarRHTTdescripcion"> 

							<cf_conlis 
								campos="RHTTid,RHTTcodigo,RHTTdescripcion"
								asignar="RHTTid,RHTTcodigo,RHTTdescripcion"
								size="0,10,30"
								desplegables="N,S,S"
								modificables="N,S,N"
								valuesArray="#ValuesCambioTablas#"
								title="#LB_ListaDeTablasSalariales#"
								tabla="RHTTablaSalarial"
								columnas="RHTTid,RHTTcodigo,#LvarRHTTdescripcion# as RHTTdescripcion"
								filtro="Ecodigo = #Session.Ecodigo# 
										and RHTTid not in (select distinct RHTTid
															from RHCategoriasPuesto 
															where Ecodigo = #Session.Ecodigo#
															)
										Order by RHTTcodigo,RHTTdescripcion"
								filtrar_por="RHTTcodigo,RHTTdescripcion"
								desplegar="RHTTcodigo,RHTTdescripcion"
								etiquetas="#LB_Codigo#,#LB_Descripcion#"
								formatos="S,S"
								align="left,left"						
								asignarFormatos="S,S,S"
								form="form1"
								translatedatacols="RHTTdescripcion"
								showEmptyListMsg="true"
								/>
					  </td>										
					  <td>
							<cfset ValuesCambioCateg = ArrayNew(1)>
							<cfif isdefined("form.RHCid") and len(trim(form.RHCid))>								
								<cfset ArrayAppend(ValuesCambioCateg, form.RHCid)>
								<cfset ArrayAppend(ValuesCambioCateg, rsPuestosCategoria.RHCcodigo)>
								<cfset ArrayAppend(ValuesCambioCateg, rsPuestosCategoria.RHCdescripcion)>
							</cfif>
							<cf_translatedata name="get" tabla="RHCategoria" col="RHCdescripcion" returnvariable="LvarRHCdescripcion"> 

					  		<cf_conlis 
								campos="RHCid,RHCcodigo,RHCdescripcion"
								size="0,10,30"
								desplegables="N,S,S"
								modificables="N,S,N"
								title="#LB_ListaDeCategorias#"
								tabla="RHCategoria"
								columnas="RHCid as RHCid, RHCcodigo as RHCcodigo, #LvarRHCdescripcion# as RHCdescripcion"
								valuesArray="#ValuesCambioCateg#"
								filtro="Ecodigo = #Session.Ecodigo# Order by RHCcodigo,#LvarRHCdescripcion#"
								filtrar_por="RHCcodigo, RHCdescripcion"
								desplegar="RHCcodigo, RHCdescripcion"
								etiquetas="#LB_Codigo#,#LB_Descripcion#"
								formatos="S,S"
								align="left,left"
								translatedatacols="RHCdescripcion"
								asignar="RHCid,RHCcodigo, RHCdescripcion"
								asignarFormatos="S,S,S"
								form="form1"
								showEmptyListMsg="true"/>
					  </td>
                      
                      <td width="26%">							
							<cfset ValuesCambioPuesto = ArrayNew(1)>
							<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>								
								<cfset ArrayAppend(ValuesCambioPuesto, form.RHMPPid)>
								<cfset ArrayAppend(ValuesCambioPuesto, rsPuestosCategoria.RHMPPcodigo)>
								<cfset ArrayAppend(ValuesCambioPuesto, rsPuestosCategoria.RHMPPdescripcion)>
							</cfif>
							<cf_translatedata name="get" tabla="RHMaestroPuestoP" col="RHMPPdescripcion" returnvariable="LvarRHMPPdescripcion"> 

							<cf_conlis 
								campos="RHMPPid,RHMPPcodigo,RHMPPdescripcion"
								asignar="RHMPPid,RHMPPcodigo,RHMPPdescripcion"
								size="10,10,30"
								desplegables="N,S,S"
								modificables="N,S,N"
								title="#LB_ListaDePuestosPresupuestarios#"
								tabla="RHMaestroPuestoP"
								columnas="RHMPPid,RHMPPcodigo,#LvarRHMPPdescripcion# as RHMPPdescripcion"
								valuesArray="#ValuesCambioPuesto#"
								filtro="Ecodigo = #Session.Ecodigo# Order by RHMPPcodigo,RHMPPdescripcion"
								filtrar_por="RHMPPcodigo,RHMPPdescripcion"
								desplegar="RHMPPcodigo,RHMPPdescripcion"
								etiquetas="#LB_Codigo#,#LB_Descripcion#"
								formatos="S,S,S,"
								align="left,left"						
								asignarFormatos="S,S,S"
								form="form1"
								translatedatacols="RHMPPdescripcion"
								showEmptyListMsg="true"
								/>
					  </td>
					  
					  <td width="18%" nowrap="nowrap">
					  	<cf_botones values="#BTN_Agregar#" names="btnAgregar"  Regresar="TablaPuestoCategoria-lista.cfm">
					  </td>
					</tr>
					<cfif isdefined('form.RHTTid') and LEN(TRIM(form.RHTTid))>
					<tr>
						<td colspan="6">
					<cfoutput>		
					<table class="PlistaTable" align="center" border="0" cellspacing="0" cellpadding="0" width="100%"> 
						<tbody>
							<tr>
								<td class="tituloListas" align="left" valign="bottom"></td> 
								<td class="tituloListas" align="left" valign="bottom"><strong>#LB_CodigoCategoria#</strong></td>
								<td class="tituloListas" align="left" valign="bottom"><strong>#LB_DescripcionCategoria#</strong></td> 
								<td class="tituloListas" align="left" valign="bottom"><strong>#LB_CodigoPuesto#</strong></td>
								<td class="tituloListas" align="left" valign="bottom"><strong>#LB_DescripcionPuesto#</strong></td> 
							</tr> 
							<tr>
								<td class="tituloListas" align="left" width="1%"> <input type="checkbox" name="chkAllItems" value="1" style="border:none; background-color:inherit;" onClick="javascript: funcFiltroChkAllform1(this);"> </td>
								<td class="tituloListas" align="left">  
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tbody>
											<tr>
												<td width="100%" align="left">
													<input type="text" size="6" maxlength="30" style="width:100%" onFocus="this.select()" name="filtro_RHCcodigoL" value="<cfif isdefined("form.FILTRO_RHCCODIGOL")><cfoutput>#form.FILTRO_RHCCODIGOL#</cfoutput></cfif>">
													<input type="hidden" name="hfiltro_RHCcodigoL" value="">
												</td>
											</tr>
										</tbody>
									</table> 
								</td> 
								<td class="tituloListas" align="left">  
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tbody>
											<tr>  
												<td width="100%" align="left">
													<input type="text" size="6" maxlength="30" style="width:100%" onFocus="this.select()" name="filtro_RHCdescripcionL" value="<cfif isdefined("form.FILTRO_RHCDESCRIPCIONL")><cfoutput>#form.FILTRO_RHCDESCRIPCIONL#</cfoutput></cfif>">
													<input type="hidden" name="hfiltro_RHCdescripcionL" value="">
												</td>
											</tr>
										</tbody>
									</table> 
								</td> 
								<td class="tituloListas" align="left">  
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tbody>
											<tr>
												<td width="100%" align="left">
													<input type="text" size="6" maxlength="30" style="width:100%" onFocus="this.select()" name="filtro_RHMPPcodigoL" value="<cfif isdefined("form.FILTRO_RHMPPCODIGOL")><cfoutput>#form.FILTRO_RHMPPCODIGOL#</cfoutput></cfif>">
													<input type="hidden" name="hfiltro_RHMPPcodigoL" value="">
												</td>
											</tr>
										</tbody>
									</table> 
								</td> 
								<td class="tituloListas" align="left">  
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tbody>
											<tr>
												<td width="100%" align="left">
													<input type="text" size="6" maxlength="30" style="width:100%" onFocus="this.select()" name="filtro_RHMPPdescripcionL" value="<cfif isdefined("form.FILTRO_RHMPPDESCRIPCIONL")><cfoutput>#form.FILTRO_RHMPPDESCRIPCIONL#</cfoutput></cfif>">
													<input type="hidden" name="hfiltro_RHMPPdescripcionL" value="">
												</td>
												<td>
													<table cellspacing="1" cellpadding="0">
										 <tbody>
											<tr>
												<td><input type="submit" value="Filtrar" class="btnFiltrar" onClick="javascript:return filtrar_Plista();"></td>
											</tr>
										 </tbody>
									</table> 
								</td>
							</tr>
						</tbody>
					</table>
					</cfoutput>
					</td></tr>
							<cfset filtro=' 1 = 1 '>
							<cfif isdefined("form.FILTRO_RHCCODIGOL")> 
								<cfset filtro=filtro&" and upper(b.RHCcodigo) like '%" & ucase(trim(form.FILTRO_RHCCODIGOL)) &"%'">
							</cfif>	

							<cfif isdefined("form.FILTRO_RHCDESCRIPCIONL")> 
								<cfset filtro=filtro&" and upper(b.RHCdescripcion) like '%" & ucase(trim(form.FILTRO_RHCDESCRIPCIONL)) &"%'">
							</cfif>

							<cfif isdefined("form.FILTRO_RHMPPCODIGOL")>
								<cfset filtro=filtro&" and upper(d.RHMPPcodigo) like '%" & ucase(trim(form.FILTRO_RHMPPCODIGOL)) &"%'">
							</cfif>
							
							<cfif isdefined("form.FILTRO_RHMPPDESCRIPCIONL")>
								<cfset filtro=filtro&" and upper(d.RHMPPdescripcion) like '%" & ucase(trim(form.FILTRO_RHMPPDESCRIPCIONL)) &"%'">
							</cfif>

							<cf_dbfunction name="to_char" args="a.RHCPlinea" returnvariable="Lvar_RHCPlinea">
							<cf_dbfunction name="OP_concat" returnvariable="concat">
							<cf_dbfunction name="concat" args="'<img src=/cfmx/rh/imagenes/Magnifier.gif   onclick=mostrarComponentes(' | #Lvar_RHCPlinea# |') style=cursor:pointer />'" delimiters="|" returnvariable="Lvar_Componentes">
							<!---20140312 ljimenez se agrega el ecodigo a las condiciones del where ya que en el iica estaba duplicando los codigo
							se cambia el orden en que se muestran las categorias --->
							<cf_translatedata name="get" tabla="RHTTablaSalarial" col="c.RHTTdescripcion" returnvariable="LvarRHTTdescripcion"> 
							<cf_translatedata name="get" tabla="RHMaestroPuestoP" col="d.RHMPPdescripcion" returnvariable="LvarRHMPPdescripcion"> 
							<cf_translatedata name="get" tabla="RHCategoria" col="b.RHCdescripcion" returnvariable="LvarRHCdescripcion"> 

							<cfquery datasource="#session.DSN#" name="rsLista">
							select a.RHCPlinea as RHCPlineaL,
								a.RHCid as RHCidL,
								a.RHMPPid as RHMPPidL,
								a.RHTTid as RHTTidL,
								c.RHTTcodigo as RHTTcodigoL,
								#LvarRHTTdescripcion# as RHTTdescripcionL,
								d.RHMPPcodigo as RHMPPcodigoL,
								#LvarRHMPPdescripcion# as RHMPPdescripcionL,
								b.RHCcodigo as RHCcodigoL,
								#LvarRHCdescripcion# as RHCdescripcionL,
								RHCcodigo #concat# ' - ' #concat# #LvarRHCdescripcion# as Categoria,
								#preservesinglequotes(Lvar_Componentes)# as Componentes
							from RHCategoriasPuesto a
								inner join RHTTablaSalarial c
									on a.RHTTid = c.RHTTid
                                    and a.Ecodigo = c.Ecodigo
								left outer join RHMaestroPuestoP d
									on a.RHMPPid = d.RHMPPid
                                    and a.Ecodigo = d.Ecodigo
								inner join RHCategoria b
									on a.RHCid = b.RHCid
                                    and a.Ecodigo = b.Ecodigo
							where a.RHTTid = #form.RHTTid# and #preservesinglequotes(filtro)#
                            and a.Ecodigo = #session.Ecodigo#
							order by b.RHCcodigo, d.RHMPPcodigo, #LvarRHMPPdescripcion#, c.RHTTcodigo, #LvarRHTTdescripcion#		
							</cfquery>
							
							<!---<cfdump var="#rsLista#" />--->
							<cfset navegacion = "">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHTTid=" & Form.RHTTid>
								
								<cfinvoke 
									 component="rh.Componentes.pListas"
									 method="pListaQuery"
									 returnvariable="pListaRet">
										<cfinvokeargument name="tabla" value=""/>
										<cfinvokeargument name="query" value="#rsLista#"/>
										<cfinvokeargument name="desplegar" value="RHMPPcodigoL, RHMPPdescripcionL,Componentes"/>
										<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_Componentes#"/>
										<cfinvokeargument name="formatos" value="S,S,S"/>
										<cfinvokeargument name="align" value="left,left,center"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="S"/>
										<cfinvokeargument name="botones" value="Eliminar"/>
										<cfinvokeargument name="cortes" value="Categoria"/>
										<cfinvokeargument name="keys" value="RHCPlineaL"/>
										<cfinvokeargument name="showLink" value="false">
										<cfinvokeargument name="MaxRows" value="25"/>
										<cfinvokeargument name="debug" value="N"/>
										<cfinvokeargument name="showEmptyListMsg" value="yes"/>
										<cfinvokeargument name="navegacion" value="#navegacion#"/>
										<cfinvokeargument name="formName" value="form1"/>
								</cfinvoke>						</td>
					</tr>
					</cfif>
				</form>
				<tr><td>&nbsp;</td></tr>
			</table>
			</cfoutput> 
			<script language="JavaScript" type="text/javascript">	
				qFormAPI.errorColor = "#FFFFCC";
				objForm = new qForm("form1");
			
				objForm.RHTTid.description="#LB_TablaSalarial#";				
				<!---objForm.RHMPPid.description="Puesto Presupuestario";--->	
				objForm.RHCid.description="#LB_Categoria#";	
				
				function deshabilitarValidacion(){
					objForm.RHTTid.required = false;
					<!---objForm.RHMPPid.required = false;--->	
					objForm.RHCid.required = false;									
				}
				function habilitarValidacion(){
					objForm.RHTTid.required = true;
					<!---objForm.RHMPPid.required = true;--->
					objForm.RHCid.required = true;	
				}


				var popUpWin=0;
				function popUpWindow(URLStr, width, height){
					var left = ((screen.width/2)-(width/2)); 
					var top=((screen.height/2)-(height/2)); 
				  if(popUpWin) {
					if(!popUpWin.closed) popUpWin.close();
				  }
				  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
			
				function mostrarComponentes(RHCPlinea) {
						popUpWindow("/cfmx/rh/estructurasalarial/catalogos/RHCPcomponentes.cfm?RHCPlinea="+RHCPlinea ,500,400);
				}

			</script>
		<cf_web_portlet_end>
	<cf_templatefooter>
