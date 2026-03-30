<!--- VARIABLES DE TRADUCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined('url.RHTTid') and not isdefined('form.RHTTid')>
	<cfset form.RHTTid = url.RHTTid>
</cfif>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="">
			<script src="/cfmx/sif/js/qForms/qforms.js"></script>
			<script language="JavaScript" type="text/JavaScript">
				<!--//
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
				//-->
				
				function funcEliminar(prn_llave){
					if( confirm('¿Desea Eliminar el Registro?') ){
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
				<cfquery name="rsTabla" datasource="#session.DSN#">
					select RHTTcodigo, RHTTdescripcion
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
				<cfquery name="rsPuestosCategoria" datasource="#session.DSN#">
					select 	a.RHCid,
							a.RHMPPid,
							a.RHTTid,
							c.RHTTcodigo,
							c.RHTTdescripcion,
							d.RHMPPcodigo,
							d.RHMPPdescripcion,
							b.RHCcodigo,
							b.RHCdescripcion,
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
					order by d.RHMPPcodigo, d.RHMPPdescripcion, c.RHTTcodigo, c.RHTTdescripcion
				</cfquery>
			</cfif>	
			
			<table width="98%" border="0" cellspacing="0" align="center">			  
			  <tr><td colspan="6"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
			  	<form name="form1" action="TablaPuestoCategoria-sql.cfm" method="post">
					<input type="hidden" name="RHCPlinea" value="">
					<cfif isdefined("form.RHTTid") and len(trim(form.RHTTid))>
						<tr>
							<td colspan="5" class="titulolistas">
								<strong style="font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;"><cfoutput>Tabla: #rsTabla.RHTTcodigo# - #rsTabla.RHTTdescripcion#</cfoutput></strong>
							</td>
						</tr>
					</cfif>
					<tr>
						<td width="2%">&nbsp;</td>
						<td width="27%" id="LabelTabla" <cfif isdefined("form.RHTTid") and len(trim(form.RHTTid))>style="display:none"</cfif>><strong>Tabla Salarial</strong></td>
						<td><strong>Puesto</strong></td>
						<td width="24%" ><strong>Categor&iacute;a</strong></td>
						<td colspan="2">&nbsp;</td>
					</tr>					
					<tr>
						<td width="2%">&nbsp;</td>
						<td width="27%" id="Tabla" <cfif isdefined("form.RHTTid") and len(trim(form.RHTTid))>style="display:none"</cfif>>							
							<cf_conlis 
								campos="RHTTid,RHTTcodigo,RHTTdescripcion"
								asignar="RHTTid,RHTTcodigo,RHTTdescripcion"
								size="0,10,30"
								desplegables="N,S,S"
								modificables="N,S,N"
								valuesArray="#ValuesCambioTablas#"
								title="Lista de Tablas Salariales"
								tabla="RHTTablaSalarial"
								columnas="RHTTid,RHTTcodigo,RHTTdescripcion"
								filtro="Ecodigo = #Session.Ecodigo# 
										and RHTTid not in (select distinct RHTTid
															from RHCategoriasPuesto 
															where Ecodigo = #Session.Ecodigo#
															)
										Order by RHTTcodigo,RHTTdescripcion"
								filtrar_por="RHTTcodigo,RHTTdescripcion"
								desplegar="RHTTcodigo,RHTTdescripcion"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"						
								asignarFormatos="S,S,S"
								form="form1"
								showEmptyListMsg="true"
								EmptyListMsg=" --- No se encontraron registros --- "/>
					  </td>										
					  <td width="26%">							
							<cfset ValuesCambioPuesto = ArrayNew(1)>
							<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>								
								<cfset ArrayAppend(ValuesCambioPuesto, form.RHMPPid)>
								<cfset ArrayAppend(ValuesCambioPuesto, rsPuestosCategoria.RHMPPcodigo)>
								<cfset ArrayAppend(ValuesCambioPuesto, rsPuestosCategoria.RHMPPdescripcion)>
							</cfif>
							<cf_conlis 
								campos="RHMPPid,RHMPPcodigo,RHMPPdescripcion"
								asignar="RHMPPid,RHMPPcodigo,RHMPPdescripcion"
								size="10,10,30"
								desplegables="N,S,S"
								modificables="N,S,N"
								title="Lista de Puestos Presupuestarios"
								tabla="RHMaestroPuestoP"
								columnas="RHMPPid,RHMPPcodigo,RHMPPdescripcion"
								valuesArray="#ValuesCambioPuesto#"
								filtro="Ecodigo = #Session.Ecodigo# Order by RHMPPcodigo,RHMPPdescripcion"
								filtrar_por="RHMPPcodigo,RHMPPdescripcion"
								desplegar="RHMPPcodigo,RHMPPdescripcion"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S,S,"
								align="left,left"						
								asignarFormatos="S,S,S"
								form="form1"
								showEmptyListMsg="true"
								EmptyListMsg=" --- No se encontraron registros --- "/>
					  </td>
					  <td>
							<cfset ValuesCambioCateg = ArrayNew(1)>
							<cfif isdefined("form.RHCid") and len(trim(form.RHCid))>								
								<cfset ArrayAppend(ValuesCambioCateg, form.RHCid)>
								<cfset ArrayAppend(ValuesCambioCateg, rsPuestosCategoria.RHCcodigo)>
								<cfset ArrayAppend(ValuesCambioCateg, rsPuestosCategoria.RHCdescripcion)>
							</cfif>
					  		<cf_conlis 
								campos="RHCid,RHCcodigo,RHCdescripcion"
								size="0,10,30"
								desplegables="N,S,S"
								modificables="N,S,N"
								title="Lista de Categor&iacute;as"
								tabla="RHCategoria"
								columnas="RHCid as RHCid, RHCcodigo as RHCcodigo, RHCdescripcion as RHCdescripcion"
								valuesArray="#ValuesCambioCateg#"
								filtro="Ecodigo = #Session.Ecodigo# Order by RHCcodigo,RHCdescripcion"
								filtrar_por="RHCcodigo, RHCdescripcion"
								desplegar="RHCcodigo, RHCdescripcion"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"
								asignar="RHCid,RHCcodigo, RHCdescripcion"
								asignarFormatos="S,S,S"
								form="form1"
								showEmptyListMsg="true"
								EmptyListMsg=" --- No se encotraron registros --- "/>
					  </td>
					  <td width="18%" nowrap="nowrap">
					  	<cf_botones values="Agregar" Regresar="TablaPuestoCategoria-lista.cfm">
						<!--- <input type="submit" name="btn_agregar" value="Agregar" onClick="javascript: habilitarValidacion();">
					 	<input type="button" name="btn_regresar" value="Regresar" onClick="javascript: location.href='TablaPuestoCategoria-lista.cfm';"> --->
					  </td>
					</tr>
					<cfif isdefined('form.RHTTid') and LEN(TRIM(form.RHTTid))>
					<tr>
						<td colspan="6">
							<cfset navegacion = "">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHTTid=" & Form.RHTTid>
								<cf_dbfunction name="concat" args="RHCcodigo,' - ',RHCdescripcion" returnvariable="Lvar_Categoria">
								<cfinvoke 
									 component="rh.Componentes.pListas"
									 method="pListaRH"
									 returnvariable="pListaRet">
										<cfinvokeargument name="tabla" value="RHCategoriasPuesto a
																				inner join RHTTablaSalarial c
																					on a.RHTTid = c.RHTTid
																				inner join RHMaestroPuestoP d
																					on a.RHMPPid = d.RHMPPid
																				left outer join RHCategoria b
																					on a.RHCid = b.RHCid"/>
										<cfinvokeargument name="columnas" value="a.RHCPlinea as RHCPlineaL,
																					a.RHCid as RHCidL,
																					a.RHMPPid as RHMPPidL,
																					a.RHTTid as RHTTidL,
																					c.RHTTcodigo as RHTTcodigoL,
																					c.RHTTdescripcion as RHTTdescripcionL,
																					d.RHMPPcodigo as RHMPPcodigoL,
																					d.RHMPPdescripcion as RHMPPdescripcionL,
																					b.RHCcodigo as RHCcodigoL,
																					b.RHCdescripcion as RHCdescripcionL,
																					#Lvar_Categoria# as Categoria"/>
										<cfinvokeargument name="filtro" value=" a.RHTTid = #form.RHTTid# order by b.RHCid,d.RHMPPcodigo, d.RHMPPdescripcion, c.RHTTcodigo, c.RHTTdescripcion"/>
										<cfinvokeargument name="desplegar" value="RHMPPcodigoL, RHMPPdescripcionL"/>
										<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
										<cfinvokeargument name="formatos" value=",S,S"/>
										<cfinvokeargument name="align" value="left,left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="S"/>
										<cfinvokeargument name="botones" value="Eliminar"/>
										<cfinvokeargument name="cortes" value="Categoria"/>
										<cfinvokeargument name="irA" value=""/>
										<cfinvokeargument name="keys" value="RHCPlineaL"/>
										<cfinvokeargument name="MaxRows" value="25"/>
										<cfinvokeargument name="debug" value="N"/>
										<cfinvokeargument name="showEmptyListMsg" value="yes"/>
										<cfinvokeargument name="mostrar_filtro" value="yes"/>
										<cfinvokeargument name="filtrar_automatico" value="yes"/>
										<cfinvokeargument name="filtrar_por" value="RHMPPcodigo,RHMPPdescripcion"/>
										<cfinvokeargument name="showLink" value="no"/>
										<cfinvokeargument name="navegacion" value="#navegacion#"/>
										<cfinvokeargument name="formName" value="form1"/>
									</cfinvoke>						</td>
					</tr>
					</cfif>
				</form>
				<tr><td>&nbsp;</td></tr>
			</table>
			<script language="JavaScript" type="text/javascript">	
				qFormAPI.errorColor = "#FFFFCC";
				objForm = new qForm("form1");
			
				objForm.RHTTid.description="Tabla Salarial";				
				objForm.RHMPPid.description="Puesto Presupuestario";	
				objForm.RHCid.description="Categoría";	
				
				function deshabilitarValidacion(){
					objForm.RHTTid.required = false;
					objForm.RHMPPid.required = false;	
					objForm.RHCid.required = false;									
				}
				function habilitarValidacion(){
					objForm.RHTTid.required = true;
					objForm.RHMPPid.required = true;
					objForm.RHCid.required = true;	
				}
			</script>
		<cf_web_portlet_end>
	<cf_templatefooter>
