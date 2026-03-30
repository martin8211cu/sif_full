<!---►►Moneda Local◄◄--->
<cfinvoke component="sif.Componentes.Monedas" method="getMonedaLocal" returnvariable="rsMonedaLocal"/>

<!---►►Centro de Custodia◄◄--->
<cfif not isdefined("RSCentros")>
	<cfinvoke component="sif.Componentes.AF_CentroCustodia" method="get" Usucodigo="#session.Usucodigo#" returnvariable="RSCentros"/>
</cfif>
<cfif RSCentros.recordcount eq 0>
	<cfthrow message="#MSG_ErrorUstedNoTieneAsociadoNingunCentroDeCustodiaNoPuedeUtilizarEsteProcesoProcesoCancelado#!">
</cfif>
<cfif not isdefined("form.CRCCid") or (isdefined("form.CRCCid") and len(trim(form.CRCCid)) eq 0) >
	<cfset form.CRCCid = RSCentros.CRCCid>
</cfif>

<!---►►Definición del modo de precarga y el modo de la pantalla, el modo de precarga precarga los valores de la pantalla  con los últimos valores digitados por el usuario, útil para agilizar las labores de los usuarios de esta pantalla◄◄--->		
<cfif isdefined("form.PRECARGA") and len(trim(form.PRECARGA))>
	<cfset precargar = "SI">
<cfelse>
	<cfset precargar = "NO">
</cfif>
<cfif isdefined("form.CRDRid") and len(trim(form.CRDRid)) and not isdefined('form.PRECARGA')>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<!---►►Otras variables◄◄--->
<cf_dbfunction name="now" returnvariable="hoy">

<!---►►Inclusion de JQUERY◄◄--->
<script>
	!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
</script>
<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>

<!--- Consulta último registro digita por el usuario para un centro de custodia para el modo precarga --->
<cfquery datasource="#session.dsn#" name="RSUltimo">
	select  coalesce(max(CRDRid),0) as CRDRid
	from CRDocumentoResponsabilidad a 
		 inner join CRCentroCustodia  b
			on b.CRCCid   = a.CRCCid 
		 inner join CRCCUsuarios c
			on c.CRCCid  = b.CRCCid 
	where a.Ecodigo     = #session.Ecodigo#
	  and a.BMUsucodigo = #session.Usucodigo#
	  and a.CRDRestado  = 0
      and c.Usucodigo   = #session.Usucodigo#
	  and c.CRCCid      = #form.CRCCid#
</cfquery>

<!---►►Consulta del modo cambio o precarga para llenar campos con valores iniciales ya sea en modo cambio para una modificación o en modo precarga para dar de alta un nuevo registro --->
<cfif modo NEQ "ALTA" or precargar EQ "SI">
	<cfinvoke component="sif.Componentes.AF_DocumentoResponsable" method="GetDocTransito" returnvariable="rsForm">
    	<cfif precargar neq "SI">
			<cfinvokeargument name="CRDRid" value="#form.CRDRid#">
		<cfelse>
			<cfinvokeargument name="CRDRid" value="#RSUltimo.CRDRid#">
            <cfinvokeargument name="CRCCid" value="#form.CRCCid#">
		</cfif>	
    </cfinvoke>
    <cfquery datasource="#session.dsn#" name="rsConceptoMejora">
        select  AFCMid, AFCMcodigo, AFCMdescripcion
        from AFConceptoMejoras 
        where Ecodigo = #session.Ecodigo#
	</cfquery>
</cfif>
<!--- En modo cambio se define Centro de Custodia guardado en la BD para el registro consultado --->
<cfif (modo neq "ALTA") >
	<cfset form.CRCCid = rsForm.CRCCid>
</cfif>
<!--- Para Manejo de la funcionalidad de la placa, validaciones. --->

<!---SML. 27/02/2014. Parametro para la generación de mascara automatica---> 
<cfquery name="rsMascaraAut" datasource="#session.DSN#">
	select Pvalor
	from Parametros 
	where Ecodigo = #session.Ecodigo#
		  and Pcodigo = '200050'
</cfquery>

<!---SML. 27/02/2014. Parametro para saber si el consecutivo se generará por por categoria o por clasificacion---> 
<cfquery name="rsGenAutPor" datasource="#session.DSN#">
	select coalesce(Pvalor,0) as Pvalor
	from Parametros 
	where Ecodigo = #session.Ecodigo#
		  and Pcodigo = '200060'
</cfquery>

<iframe frameborder="0" name="fr" height="0" width="0" src=""></iframe>

<cfif (modo eq "CAMBIO") >
	<cfset paramsUri = ''>
	<cfset paramsUri = paramsUri & '&CRDRid=#form.CRDRid#'>
</cfif>
<!---►►Inicializacion de Variables◄◄--->
<CF_NAVEGACION NAME="PageNum" 				  default="1">
<CF_NAVEGACION NAME="Pagina" 				  default="#form.PageNum#">
<CF_NAVEGACION NAME="Filtro_FechasMayores" 	  default="">
<CF_NAVEGACION NAME="Filtro__CRTipoDocumento" default="">
<CF_NAVEGACION NAME="Filtro__DatosEmpleado"   default="">
<CF_NAVEGACION NAME="Filtro_CRDRplaca"   	  default="">
<CF_NAVEGACION NAME="Filtro_Usulogin"   	  default="">
<CF_NAVEGACION NAME="Filtro_CRDRfdocumento"   default="">
<CF_NAVEGACION NAME="ts"   					  default="">

<!--- Pintado del formulario --->
<cfoutput>
	<form action="documento-sql.cfm" name="form1" method="post" onSubmit="javascript:return finalizar();">
		<input type="hidden" name="Pagina" 					 value="#Form.Pagina#" />
		<input type="hidden" name="Filtro_FechasMayores" 	 value="#Form.Filtro_FechasMayores#"/>
        <input type="hidden" name="HFiltro_FechasMayores" 	 value="#Form.Filtro_FechasMayores#"/>
        <input type="hidden" name="Filtro__CRTipoDocumento"  value="#Form.Filtro__CRTipoDocumento#"/>
        <input type="hidden" name="HFiltro__CRTipoDocumento" value="#Form.Filtro__CRTipoDocumento#"/>
        <input type="hidden" name="Filtro__DatosEmpleado"    value="#Form.Filtro__DatosEmpleado#" />
        <input type="hidden" name="HFiltro__DatosEmpleado"   value="#Form.Filtro__DatosEmpleado#" />
		<input type="hidden" name="Filtro_CRDRplaca"  		 value="#Form.Filtro_CRDRplaca#" />
        <input type="hidden" name="HFiltro_CRDRplaca" 		 value="#Form.Filtro_CRDRplaca#" />
        <input type="hidden" name="Filtro_Usulogin" 		 value="#Form.Filtro_Usulogin#" />
        <input type="hidden" name="HFiltro_Usulogin" 		 value="#Form.Filtro_Usulogin#" />
        <input type="hidden" name="Filtro_CRDRfdocumento"    value="#Form.Filtro_CRDRfdocumento#" />
        <input type="hidden" name="HFiltro_CRDRfdocumento"   value="#Form.Filtro_CRDRfdocumento#" />
        <!---SML. 28/02/2014 Guardar Parametros para su consulta en documento-sql.cfm--->
        <input type="hidden" name="Param_GenerarAutPlaca"    value="#rsMascaraAut.Pvalor#" />
        <input type="hidden" name="Param_GenerarAutPlacaPor" value="#rsGenAutPor.Pvalor#" />
		
		<cfif (modo neq "ALTA")>
			<input type="hidden" name="CRDRid" 	   id="CRDRid" 	   value="#rsForm.CRDRid#">
			<input type="hidden" name="AF_CATEGOR" id="AF_CATEGOR" value="#rsForm.ACatId#">
			<input type="hidden" name="AF_CLASIFI" id="AF_CLASIFI" value="#rsForm.idClase#">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts" artimestamp="#rsForm.ts_rversion#"/>
			<input type="hidden" name="ts_rversion" id="ts_rversion" value="#ts#">
		</cfif>
		<table width="500" align="center" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td width="150" nowrap="NOWRAP" class="fileLabel">
			  		<p><cf_translate key="LB_CentroDeCustodia">Centro de Custodia</cf_translate>:&nbsp;</p>
				</td>				
				<td width="824"   colspan="3" >
					<cfif RSCentros.recordcount gt 0>
						<cfif RSCentros.recordcount eq 1>
							<input name="CRCCid" value="#RSCentros.CRCCid#" type="hidden" tabindex="-1">
							#RSCentros.CRCCcodigo#-#RSCentros.CRCCdescripcion#
						<cfelse>
							<select name="CRCCid" tabindex="1" onchange="javascript: ResetFormCRCCid();">
							<cfloop query="RSCentros">
								<option value="#RSCentros.CRCCid#"  
								<cfif isdefined("form.CRCCid") and len(trim(form.CRCCid)) and form.CRCCid eq RSCentros.CRCCid> 
								selected="selected"</cfif>>
								#RSCentros.CRCCcodigo#-#RSCentros.CRCCdescripcion#</option>
							</cfloop>
							</select>
						</cfif>
					<cfelse>
						<input name="CRCCid"  value="-1" tabindex="-1" type="hidden">
			  		</cfif>
				</td>
				<cfif (modo eq "CAMBIO") >
				<td><cf_rhimprime datos="/sif/af/responsables/operacion/documento-Impr.cfm" paramsuri="#paramsUri#"></td>
				</cfif>
			</tr>		
			<tr><td  colspan="5">&nbsp;</td></tr>
			
			<tr>
				<td  colspan="5"  nowrap="NOWRAP" class="subtitulo_seccion_small">
					<!--- INI Información del Activo --->
					<div id="div_CF" style="display:;">
						<fieldset>
							<legend>
							<cf_translate key="LB_InformacionDelActivo">Informaci&oacute;n del Activo</cf_translate>
							</legend>
							<table width="100%"  border="0" cellspacing="0" cellpadding="2">
								<tr>
									<td height="36" nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Categoria">Categor&iacute;a</cf_translate>:&nbsp;</p>
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif  isdefined("rsForm")>
											<cfset ArrayAppend(ValuesArray,rsForm.ACcodigo)>
											<cfset ArrayAppend(ValuesArray,rsForm.ACcodigodesc)>
											<cfset ArrayAppend(ValuesArray,rsForm.ACdescripcion)>
											<cfset ArrayAppend(ValuesArray,rsForm.ACmascara)>
										</cfif>
                                        <!---SML. 27/02/2014. Modificacion para que se muestre se muestre la mascara de acuerdo al parametro de 200060 --->
                                        <cfif isdefined("rsGenAutPor") and (rsGenAutPor.Pvalor EQ 1 or rsGenAutPor.RecordCount EQ 0)>
										<cf_conlis
											Campos="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
											Desplegables="N,S,S,N"
											Modificables="N,S,N,N"
											Size="0,10,40,0"
											ValuesArray="#ValuesArray#"
											Title="#LB_ListaDeCategorias#"
											tabindex="1"
											Tabla="ACategoria a"
											Columnas="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
											Filtro="Ecodigo = #Session.Ecodigo# 
											order by ACcodigodesc, ACdescripcion"
											Desplegar="ACcodigodesc, ACdescripcion"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#"
											filtrar_por="ACcodigodesc, ACdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
											Asignarformatos="I,S,S,S"
											funcion="resetClase"/>
                                        <cfelse>
                                        <cf_conlis
											Campos="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
											Desplegables="N,S,S,N"
											Modificables="N,S,N,N"
											Size="0,10,40,0"
											ValuesArray="#ValuesArray#"
											Title="#LB_ListaDeCategorias#"
											tabindex="1"
											Tabla="ACategoria a"
											Columnas="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
											Filtro="Ecodigo = #Session.Ecodigo# 
											order by ACcodigodesc, ACdescripcion"
											Desplegar="ACcodigodesc, ACdescripcion"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#"
											filtrar_por="ACcodigodesc, ACdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
											Asignarformatos="I,S,S,S"
                                            />
                                        </cfif>
                                            
									</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Clase">Clase</cf_translate>:&nbsp;</p>
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
                                        <!---<cfif not (isdefined("form.PRECARGA") and len(trim(form.PRECARGA)))>--->
										<cfif  isdefined("rsForm")>
											<cfset ArrayAppend(ValuesArray,rsForm.ACid)>
											<cfset ArrayAppend(ValuesArray,rsForm.Cat_ACcodigodesc)>
											<cfset ArrayAppend(ValuesArray,rsForm.Cat_ACdescripcion)>
										</cfif>
										<!---</cfif>--->
                                        <!---SML. 27/02/2014. Modificacion para que se muestre se muestre la mascara de acuerdo al parametro de 200060 --->
                                        <cfif isdefined("rsGenAutPor") and rsGenAutPor.Pvalor EQ 2>
										<cf_conlis
											Campos="ACid, Cat_ACcodigodesc, Cat_ACdescripcion"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,35"
											tabindex="1"
											ValuesArray="#ValuesArray#"
											Title="#LB_ListaDeClases#"
											Tabla="AClasificacion a"
											Columnas="ACid, ACcodigodesc as Cat_ACcodigodesc, ACdescripcion as Cat_ACdescripcion , ACdescripcion as CRDRdescripcion,ACmascara"
											Filtro="Ecodigo = #Session.Ecodigo# 
											and ACcodigo = $ACcodigo,numeric$ 
											and case 
												when exists (	
													select 1 
													from CRAClasificacion 
													where CRCCid = $CRCCid,numeric$
												) then 
													case 
														when not exists ( 
															select 1 
															from CRAClasificacion 
															where CRCCid = $CRCCid,numeric$
																and ACcodigo = a.ACcodigo 
																and ACid = a.ACid 
														) then 1
													else 0
													end
												when exists ( 
													select 1 
													from CRAClasificacion 
													where CRCCid <> $CRCCid,numeric$
														and ACcodigo = a.ACcodigo 
														and ACid = a.ACid 
												) then 1
												else 0
											end = 0
											order by Cat_ACcodigodesc, Cat_ACdescripcion"
											Desplegar="Cat_ACcodigodesc, Cat_ACdescripcion"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#"
											filtrar_por="ACcodigodesc, ACdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="ACid, Cat_ACcodigodesc,Cat_ACdescripcion,CRDRdescripcion, ACmascara"
											Asignarformatos="I,S,S,S"
											debug="false"
											funcion="resetClase" />
                                            <cfelse>
                                            <cf_conlis
											Campos="ACid, Cat_ACcodigodesc, Cat_ACdescripcion"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,35"
											tabindex="1"
											ValuesArray="#ValuesArray#"
											Title="#LB_ListaDeClases#"
											Tabla="AClasificacion a"
											Columnas="ACid, ACcodigodesc as Cat_ACcodigodesc, ACdescripcion as Cat_ACdescripcion , ACdescripcion as CRDRdescripcion,ACmascara"
											Filtro="Ecodigo = #Session.Ecodigo# 
											and ACcodigo = $ACcodigo,numeric$ 
											and case 
												when exists (	
													select 1 
													from CRAClasificacion 
													where CRCCid = $CRCCid,numeric$
												) then 
													case 
														when not exists ( 
															select 1 
															from CRAClasificacion 
															where CRCCid = $CRCCid,numeric$
																and ACcodigo = a.ACcodigo 
																and ACid = a.ACid 
														) then 1
													else 0
													end
												when exists ( 
													select 1 
													from CRAClasificacion 
													where CRCCid <> $CRCCid,numeric$
														and ACcodigo = a.ACcodigo 
														and ACid = a.ACid 
												) then 1
												else 0
											end = 0
											order by Cat_ACcodigodesc, Cat_ACdescripcion"
											Desplegar="Cat_ACcodigodesc, Cat_ACdescripcion"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#"
											filtrar_por="ACcodigodesc, ACdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="ACid, Cat_ACcodigodesc,Cat_ACdescripcion,CRDRdescripcion, ACmascara"
											Asignarformatos="I,S,S,S"
											debug="false"/>
                                            </cfif>
											
									</td>
								</tr>
								<tr>
									<!---<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Placa">Placa</cf_translate>:&nbsp;</p>
									</td>
									<td nowrap="nowrap">
                                    	<input type="text" tabindex="1" name="CRDRplaca" size="25" maxlength="20" style="text-transform:uppercase" 
											onblur="javascript:ValidarPlaca(this);" <cfif isdefined("rsForm.CRDRplaca")>value="#rsForm.CRDRplaca#"</cfif>/>
									  	<input type="text" name="CRDRplaca_text" tabindex="-1" size="20" disabled readonly="true" class="cajasinbordeb">
										<input type="text" name="CRDRplaca_text2" tabindex="-1" size="20" disabled readonly="true" class="cajasinbordeb">
									</td>--->
                                    <td nowrap="nowrap" class="fileLabel">
                                    	<cfif isdefined("rsMascaraAut") and rsMascaraAut.Pvalor EQ 1>
										<p><cf_translate key="LB_Mejora">Mejora</cf_translate>:&nbsp;</p>
                                        </cfif>
									</td>
									<td nowrap="nowrap">
										<input type="hidden" name="valorMejora" id="valorMejora" value="0"/>
                                    	<cfif isdefined("rsMascaraAut") and rsMascaraAut.Pvalor EQ 1>
                                    	<input type="checkbox" name="chkMejora" onchange="javascript:fnActivar(form);"  />
                                        </cfif>
									</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Decripcion" XmlFile="/sif/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</p>
									</td>
									<td>
										<input type="text" tabindex="1" id="CRDRdescripcion" name="CRDRdescripcion" 
										<cfif isdefined("rsForm.CRDRdescripcion")>value="#HTMLEditFormat(rsForm.CRDRdescripcion)#"</cfif> size="50" maxlength="80">
									</td>
								</tr>
								<tr>
                                	<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Placa">Placa</cf_translate>:&nbsp;</p>
									</td>
									<td nowrap="nowrap">
                                    
                                    <input type="text" tabindex="1" name="CRDRplaca" id="CRDRplaca" size="25" maxlength="20" style="text-transform:uppercase" onblur="javascript:ValidarPlaca(this);"  <cfif isdefined("rsForm.CRDRplaca")>value="#rsForm.CRDRplaca#"</cfif> <cfif isdefined("rsMascaraAut") and rsMascaraAut.Pvalor EQ 1> readonly="true" </cfif> />
                                    
                                     <input type="text" tabindex="1" name="CRDRplacaA" id="CRDRplacaA" size="25" maxlength="20" style="text-transform:uppercase;display:none" onblur="javascript:ValidarPlaca(this);"/>
                                    
								    <input type="text" name="CRDRplaca_text" tabindex="-1" size="20" disabled readonly="true" class="cajasinbordeb">
									<input type="text" name="CRDRplaca_text2" tabindex="-1" size="20" disabled readonly="true" class="cajasinbordeb">
									</td>
									<!---<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Marca">Marca</cf_translate>:&nbsp;</p>
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif  isdefined("rsForm")>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMid)>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMcodigo)>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMdescripcion)>
										</cfif>
										<cf_conlis
											Campos="AFMid,AFMcodigo,AFMdescripcion"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											ValuesArray="#ValuesArray#"
											Title="#LB_ListaDeMarcas#"
											Tabla="AFMarcas"
											tabindex="1"
											Columnas="AFMid,AFMcodigo,AFMdescripcion"
											Filtro="Ecodigo = #Session.Ecodigo# order by AFMcodigo,AFMdescripcion"
											Desplegar="AFMcodigo,AFMdescripcion"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#"
											filtrar_por="AFMcodigo,AFMdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="AFMid,AFMcodigo,AFMdescripcion"
											Asignarformatos="I,S,S"
											funcion="resetModelo"/>
									</td>--->
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Modelo">Modelo</cf_translate>:&nbsp;</p>
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif  isdefined("rsForm")>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMMid)>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMMcodigo)>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMMdescripcion)>
										</cfif>
										<cf_conlis
											Campos="AFMMid,AFMMcodigo,AFMMdescripcion"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,35"
											ValuesArray="#ValuesArray#"
											Title="#LB_ListaDeModelos#"
											Tabla="AFMModelos"
											tabindex="1"
											Columnas="AFMMid,AFMMcodigo,AFMMdescripcion"
											Filtro="Ecodigo = #Session.Ecodigo# and AFMid = $AFMid,numeric$ order by AFMMcodigo,AFMMdescripcion"
											Desplegar="AFMMcodigo,AFMMdescripcion"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#"
											filtrar_por="AFMMcodigo,AFMMdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="AFMMid,AFMMcodigo,AFMMdescripcion"
											Asignarformatos="I,S,S"/>
									</td>
								</tr>
								<tr>
                                	<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Marca">Marca</cf_translate>:&nbsp;</p>
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif  isdefined("rsForm")>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMid)>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMcodigo)>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMdescripcion)>
										</cfif>
										<cf_conlis
											Campos="AFMid,AFMcodigo,AFMdescripcion"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											ValuesArray="#ValuesArray#"
											Title="#LB_ListaDeMarcas#"
											Tabla="AFMarcas"
											tabindex="1"
											Columnas="AFMid,AFMcodigo,AFMdescripcion"
											Filtro="Ecodigo = #Session.Ecodigo# order by AFMcodigo,AFMdescripcion"
											Desplegar="AFMcodigo,AFMdescripcion"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#"
											filtrar_por="AFMcodigo,AFMdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="AFMid,AFMcodigo,AFMdescripcion"
											Asignarformatos="I,S,S"
											funcion="resetModelo"/>
									</td>
									<!---<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Tipo">Tipo</cf_translate>:&nbsp;</p>
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif  isdefined("rsForm")>
											<cfset ArrayAppend(ValuesArray,rsForm.AFCcodigo)>
											<cfset ArrayAppend(ValuesArray,rsForm.AFCcodigoclas)>
											<cfset ArrayAppend(ValuesArray,rsForm.AFCdescripcion)>
										</cfif>										
										<cf_conlis
											Campos="AFCcodigo,AFCcodigoclas,AFCdescripcion"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											ValuesArray="#ValuesArray#"
											Title="#LB_ListaDeClasificaciones#"
											Tabla="AFClasificaciones"
											tabindex="1"
											Columnas="AFCcodigo,AFCcodigoclas,AFCdescripcion"
											Filtro="Ecodigo = #Session.Ecodigo# order by AFCcodigoclas,AFCdescripcion"
											Desplegar="AFCcodigoclas,AFCdescripcion"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#"
											filtrar_por="AFCcodigoclas,AFCdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="AFCcodigo,AFCcodigoclas,AFCdescripcion"
											Asignarformatos="I,S,S"/>
									</td>--->
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>	
									<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_DescripcionDetallada">Descripci&oacute;n Detallada</cf_translate>:&nbsp;</p>
									</td>
									<td>
										<input type="text" tabindex="1" id="CRDRdescdetallada" name="CRDRdescdetallada" 
											<cfif isdefined("rsForm.CRDRdescdetallada")>value="#HTMLEditFormat(rsForm.CRDRdescdetallada)#"</cfif> 
											size="50" maxlength="255">
									</td>
								</tr>
								<tr>
                                	<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Tipo">Tipo</cf_translate>:&nbsp;</p>
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif  isdefined("rsForm")>
											<cfset ArrayAppend(ValuesArray,rsForm.AFCcodigo)>
											<cfset ArrayAppend(ValuesArray,rsForm.AFCcodigoclas)>
											<cfset ArrayAppend(ValuesArray,rsForm.AFCdescripcion)>
										</cfif>										
										<cf_conlis
											Campos="AFCcodigo,AFCcodigoclas,AFCdescripcion"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											ValuesArray="#ValuesArray#"
											Title="#LB_ListaDeClasificaciones#"
											Tabla="AFClasificaciones"
											tabindex="1"
											Columnas="AFCcodigo,AFCcodigoclas,AFCdescripcion"
											Filtro="Ecodigo = #Session.Ecodigo# order by AFCcodigoclas,AFCdescripcion"
											Desplegar="AFCcodigoclas,AFCdescripcion"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#"
											filtrar_por="AFCcodigoclas,AFCdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="AFCcodigo,AFCcodigoclas,AFCdescripcion"
											Asignarformatos="I,S,S"/>
									</td>
                                    <td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Serie">Serie</cf_translate>:&nbsp;</p>
									</td>
									<td>
										<input type="text" tabindex="1" id="CRDRserie" name="CRDRserie" 
											<cfif not (isdefined("form.PRECARGA") and len(trim(form.PRECARGA)))><cfif isdefined("rsForm.CRDRserie")>value="#HTMLEditFormat(rsForm.CRDRserie)#"</cfif></cfif>  
											size="60" maxlength="45" />
									</td>
                                    </tr>
                                    <tr>
                                    <input type="hidden" name="AFCMejora" <cfif isdefined("rsForm.AFCMejora")>value="#rsForm.AFCMejora#"</cfif>/>
                                    <cfif modo neq "ALTA" and isdefined("rsForm.AFCMejora") and rsForm.AFCMejora>
                                    	<td nowrap="nowrap" class="fileLabel">
                                            <p><cf_translate key="LB_ConceptoMejora">Concepto de Mejora</cf_translate>:&nbsp;</p>
                                        </td>
                                        <td>
                                            <select name="AFCMid" tabindex="1">
                                            <option value="-1">- Sin Definir -</option>
                                            <cfloop query="rsConceptoMejora">
                                                <option value="#rsConceptoMejora.AFCMid#"  
                                                <cfif isdefined("rsForm.AFCMid") and len(trim(rsForm.AFCMid)) and rsForm.AFCMid eq rsConceptoMejora.AFCMid> 
                                                selected="selected"</cfif>>
                                                #rsConceptoMejora.AFCMcodigo#-#rsConceptoMejora.AFCMdescripcion#</option>
                                            </cfloop>
                                            </select>
                                        </td>
                                    </cfif>
                                </tr>
							</table>
						</fieldset>
					</div>
					<!--- FIN Información del Activo --->
				</td>				
			</tr>
			<tr>
				<td  colspan="5" nowrap="nowrap" class="fileLabel">&nbsp;</td>
			</tr>
			<tr>
				<td  colspan="5"  nowrap="NOWRAP" class="subtitulo_seccion_small">
					<!--- Información del Documento --->
					<div id="div_CF" style="display:;">
						<fieldset>
							<legend><cf_translate key="LB_InformacionDelDocumento">Informaci&oacute;n del Documento</cf_translate></legend>
							<table width="100%"  border="0" cellspacing="0" cellpadding="2">
								<tr>
									<td width="14%" nowrap="NOWRAP" class="fileLabel">
										<p><cf_translate key="LB_TipoDeDocumentos">Tipo de Documento</cf_translate>:&nbsp;</p>
									</td>
									<td width="8%">
										<cfset ValuesArray=ArrayNew(1)>
										<cfif  isdefined("rsForm")>
											<cfset ArrayAppend(ValuesArray,rsForm.CRTDid)>
											<cfset ArrayAppend(ValuesArray,rsForm.CRTDcodigo)>
											<cfset ArrayAppend(ValuesArray,rsForm.CRTDdescripcion)>
										</cfif>
								  		<cf_conlis
											Campos="CRTDid,CRTDcodigo,CRTDdescripcion"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											tabindex="1"
											ValuesArray="#ValuesArray#"
											Title="#LB_ListaDeTiposDeDocumentos#"
											Tabla="CRTipoDocumento"
											Columnas="CRTDid,CRTDcodigo,CRTDdescripcion"
											Filtro="Ecodigo = #Session.Ecodigo# order by CRTDcodigo,CRTDdescripcion"
											Desplegar="CRTDcodigo,CRTDdescripcion"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#"
											Formatos="S,S"
											Align="left,left"
											Asignar="CRTDid,CRTDcodigo,CRTDdescripcion"
											Asignarformatos="S,S,S"/>
									</td>
									<td width="2%" nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td width="19%" nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Fecha">Fecha</cf_translate>:&nbsp;</p>
									</td>
									<td width="57%" colspan="4">
										<cfif (modo neq "ALTA")>
											<cfset Fecha = rsForm.CRDRfdocumento>
										<cfelse>
											<cfset Fecha = Now()>
										</cfif>
								  		<cf_sifcalendario name="CRDRfdocumento" tabindex="1" value="#LSDateFormat(Fecha,'dd/mm/yyyy')#">
									</td>
								</tr>
								<cfif not Lvar_Autogestion>
								<tr>
									<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;</p>
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif (modo neq "ALTA")>
											<cfset ArrayAppend(ValuesArray,rsForm.DEid)>
											<cfset ArrayAppend(ValuesArray,rsForm.DEidentificacion)>
											<cfset ArrayAppend(ValuesArray,rsForm.DEnombrecompleto)>
										</cfif>

										<cf_conlis
											Campos="DEid,DEidentificacion,DEnombrecompleto"
											ValuesArray="#ValuesArray#"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											form="form1"
											tabindex="1"
											Title="#LB_ListaDeEmpleados#"
											Tabla=" CRCCCFuncionales cr
											 inner join CFuncional cf
											  on cf.CFid = cr.CFid
											 inner join EmpleadoCFuncional decf
											   on decf.CFid = cf.CFid
											  and #hoy# between decf.ECFdesde and decf.ECFhasta
											 inner join DatosEmpleado d
											  on d.DEid = decf.DEid "
											Columnas="d.DEid,d.DEidentificacion,
													{fn concat(d.DEapellido1,{fn concat(' ',{fn concat(d.DEapellido2,{fn concat(' ',d.DEnombre)})})})} as DEnombrecompleto,
													cf.CFid,cf.CFcodigo,cf.CFdescripcion"
											Filtro=" cr.CRCCid = $CRCCid,numeric$ order by DEidentificacion"
											Desplegar="DEidentificacion,DEnombrecompleto"
											Etiquetas="#LB_Identificacion#,#LB_Nombre#"
											filtrar_por="d.DEidentificacion|{fn concat(d.DEapellido1,{fn concat(' ',{fn concat(d.DEapellido2,{fn concat(' ',d.DEnombre)})})})}"
											filtrar_por_delimiters="|"
											Formatos="S,S"
											Align="left,left"
											Asignar="DEid,DEidentificacion,DEnombrecompleto,CFid,CFcodigo,CFdescripcion"
											Asignarformatos="S,S,S,I,S,S"
											MaxRowsQuery="200"/>	
									</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</p>
									</td>
									<td>
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
										  <tr>
											<td>
												<INPUT TYPE="textbox" NAME="CFcodigo" SIZE="10" readonly="yes" MAXLENGTH="CFcodigo" ONBLUR="" ONFOCUS="this.select(); " VALUE="<cfif isdefined("rsForm.CFcodigo") and (modo neq "ALTA")>#rsForm.CFcodigo#</cfif>" ONKEYUP="" tabindex="-1" style="border: medium none; text-align:left; size:auto;"/>
											</td>
											<td>
												<input type="textbox" name="CFdescripcion" size="35" readonly="yes" maxlength="35" onblur="" onfocus="this.select(); " VALUE="<cfif isdefined("rsForm.CFdescripcion") and (modo neq "ALTA")>#rsForm.CFdescripcion#</cfif>" tabindex="-1" onkeyup="" style="border: medium none; text-align:left; size:auto;"/>
												<input type="hidden" value="<cfif isdefined("rsForm.CFid") and (modo neq "ALTA")>#rsForm.CFid#</cfif>" name="CFid" id="CFid"/>
											</td>
										  </tr>
										</table>
									</td>
								</tr>
								<cfelse>
									<input type="hidden" value="<cfif isdefined("rsEmpleado.DEid")>#rsEmpleado.DEid#</cfif>" name="DEid" id="DEid"/>
									<input type="hidden" value="<cfif isdefined("rsEmpleado.CFid")>#rsEmpleado.CFid#</cfif>" name="CFid" id="CFid"/>
									<input type="hidden" value="-auto" name="Autogestion" id="Autogestion" />
								</cfif>
							</table>
						</fieldset>
					</div>
				</td>
			</tr>
			<tr>
				<td  colspan="5" nowrap="nowrap" class="fileLabel">&nbsp;</td>
			</tr>			
			<tr>
                <cfset ValuesArray=ArrayNew(1)>
                <cfif  isdefined("rsForm")>
                    <cfset ArrayAppend(ValuesArray,rsForm.CRTCid)>
                    <cfset ArrayAppend(ValuesArray,rsForm.CRTCcodigo)>
                    <cfset ArrayAppend(ValuesArray,rsForm.CRTCdescripcion)>
                </cfif>
				<td  colspan="5"  nowrap="NOWRAP" class="subtitulo_seccion_small">
					<!--- Información del Documento Origen (Factura, Orden de Compra) --->
					<div id="div_CF" style="display:;">
						<fieldset>
							<legend><cf_translate key="LB_InformacionDelOrigen">Informaci&oacute;n del Origen</cf_translate></legend>
							<table width="100%"  border="0" cellspacing="0" cellpadding="2">
								<tr>
                                	<!---►►Tipo de Compra◄◄--->
									<td width="14%" nowrap="nowrap" class="fileLabel">
								  		<p><cf_translate key="LB_TipoDeCompra">Tipo de Compra</cf_translate> :&nbsp;</p>	
									</td>
									<td width="23%">
								  		<cf_conlis
											Campos="CRTCid,CRTCcodigo,CRTCdescripcion"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,6,25"
											tabindex="1"
											ValuesArray="#ValuesArray#"
											Title="#LB_ListaDeTiposDeCompra#"
											Tabla="CRTipoCompra"
											Columnas="CRTCid,CRTCcodigo,CRTCdescripcion"
											Filtro="Ecodigo = #Session.Ecodigo# order by CRTCcodigo,CRTCdescripcion"
											Desplegar="CRTCcodigo,CRTCdescripcion"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#"
											filtrar_por="CRTCcodigo,CRTCdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="CRTCid,CRTCcodigo,CRTCdescripcion"
											Asignarformatos="I,S,S"/>
									</td>
									<td width="2%" nowrap="nowrap" class="fileLabel">&nbsp;</td>
                                    <!---►►Tipo de Asociacion◄◄--->
                                    <cfparam name="rsForm.TipoOrigen" default="0">
                                    <td colspan="2" align="center">
                                    	<select name="Asociar" id="Asociar" onchange="javascript: borrarT(this.value);">
                                        	<option value="0" <cfif TRIM(rsForm.TipoOrigen) EQ 0>selected="selected"</cfif>>Sin asociacion</option>
                                            <option value="1" <cfif TRIM(rsForm.TipoOrigen) EQ 1>selected="selected"</cfif>>Asociar a una Factura CXP</option>
                                            <option value="2" <cfif TRIM(rsForm.TipoOrigen) EQ 2>selected="selected"</cfif>>Asociar a una Orden de Compra</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
									<!---►►Origen◄◄--->
                                    <cfset OrigenA = ObtenerDato(1110)>
									<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Origen"><cfif OrigenA.RecordCount gt 0 and len(trim(OrigenA.Pvalor))><cfoutput>#OrigenA.Pvalor#</cfoutput><cfelse>Origen</cfif></cf_translate>:&nbsp;</p>
									</td>
									<td>
										<input type="text" id="CRorigen" tabindex="1" name="CRorigen" 
										<cfif isdefined("rsForm.CRorigen")>value="#rsForm.CRorigen#"</cfif> size="4" maxlength="4">
									</td>
                                    <td>&nbsp;</td>
									<td nowrap="nowrap" rowspan="4" colspan="4" class="fileLabel">
                                     <!---►►Campos Ocultos de Interez◄◄--->
                                     <input type="hidden" id="DOlinea"   tabindex="-1" name="DOlinea" <cfif isdefined("rsForm.DOlinea")>value="#rsForm.DOlinea#"</cfif> size="20" maxlength="20" readonly>
                                     <input type="hidden" id="EOidorden" tabindex="-1" name="EOidorden" <cfif isdefined("rsForm.EOidorden")>value="#rsForm.EOidorden#"</cfif> size="20" maxlength="20" readonly>
                                   
                                    	<table id="ListDocs" border="0" width="100" align="center">
                                        	<!---►►Titulo de las listas◄◄--->
                                            <tr>
                                            	<td width="13%" nowrap="nowrap" class="fileLabel">
                                                    <div id="LabelCP"><strong>Documento CxP</strong></div>
                                                </td>
                                            </tr>
                                            <tr>
                                            	 <td>
                                                	<div id="LineaCP">
                                                        <input type="text" id="CRDRdocori2"  tabindex="1" name="CRDRdocori2" <cfif isdefined("rsForm.CRDRdocori") and LISTLEN(rsForm.DOlineas) GT 0>value="#rsForm.CRDRdocori#"</cfif> size="20" maxlength="20">
                                                    </div>
                                                </td>
                                            </tr>
                                        	<tr>
                                            	<td width="48%" nowrap="nowrap" class="fileLabel">
                                                    <div id="LabelOC"><strong>Orden de Compra</strong></div>
                                                    <div id="LabelFC"><strong>Documento CxP</strong></div>
                                                </td>
                                                <td width="13%" nowrap="nowrap" class="fileLabel">
                                                    <div id="LabelLinea"><strong>Linea</strong></div>
                                                </td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                
                                            </tr>
                                            <!---►►Input de OC o FC◄◄--->
                                            <tr>
                                                <td>
                                                    <div id="InputFC">
                                                        <input type="text" id="CRDRdocori"  tabindex="1" name="CRDRdocori" <cfif isdefined("rsForm.CRDRdocori") and LISTLEN(rsForm.DDlineas) GT 0>value="#rsForm.CRDRdocori#"</cfif> size="20" maxlength="20">
                                                    </div>
                                                    <div id="InputOC">
                                                        <input type="text" id="EOnumero" tabindex="-1" name="EOnumero" <cfif isdefined("rsForm.EOnumero")>value="#rsForm.EOnumero#"</cfif> size="20" maxlength="20" readonly>
                                                    </div>
                                                </td>
												<!---►►Linea◄◄--->
                                                <td>
                                                    <div id="LineaFC">
                                                        <cf_monto name="DDlinea" value="" decimales="0" size="18" tabindex="1">
                                                    </div>
                                                    <div id="LineaOC">
                                                        <input type="text" id="DOconsecutivo" tabindex="-1" name="DOconsecutivo" <cfif isdefined("rsForm.DOconsecutivo")>value="#rsForm.DOconsecutivo#"</cfif> size="20" maxlength="20" readonly>
                                                    </div>
                                                </td>
                                                <td>
                                                	<div id="PopUpOC">
                                                		<a href="##"><img src="/cfmx/sif/imagenes/Description.gif" alt="#ALT_ListaDeOrdenesDeCompra#" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisDOlinea();'></a>
                                                	</div>
                                                </td>
                                                <td><input type="button" name="AddDoc" class="btnNormal" value="Agregar" onclick="AgregarDoc($('##CRDRdocori').val(),$('##DDlinea').val(),$('##EOnumero').val(),$('##DOconsecutivo').val(),$('##DOlinea').val(),true);" /></td>
                                               
                                 		</tr>
                                        <tr id="trListDoc">
                                        	<td colspan="3" align="center">
                                            	<ul id="fiel">
                                                	
												</ul>
                                            </td>
                                        </tr>
                                     </table>
                                  </td>
                                </tr>
                                 <tr>
                                 	<!---►►Monto◄◄---> 
									<td nowrap="nowrap" class="fileLabel" valign="top">
										<p><cf_translate key="LB_Monto">Monto</cf_translate>:&nbsp;</p>
									</td>
									<td valign="top">
										<cfset Monto="0.00">
										<cfif isdefined("rsForm.Monto") and len(trim(rsForm.Monto)) and rsForm.Monto GT 0.00>
											<cfset Monto=rsForm.Monto>
										</cfif>
										<cf_monto name="Monto" value="#Monto#" decimales="2" tabindex="1">
										<input type="hidden" value="" name="CRDRtipodocori" id="CRDRtipodocori" >
										#rsMonedaLocal.Miso4217#
									</td>
                                    <td nowrap="nowrap" class="fileLabel">&nbsp;</td>
								</tr>
							</table>
						</fieldset>
					</div>
				</td>
			</tr>
			<cfif modo NEQ 'ALTA'>
				<!---Datos Variables--->
				<tr><td colspan="5">
					<cfset Tipificacion = StructNew()>
					<cfset temp = StructInsert(Tipificacion, "AF", "")> 
					<cfset temp = StructInsert(Tipificacion, "AF_CATEGOR", "#rsForm.ACatId#")> 
					<cfset temp = StructInsert(Tipificacion, "AF_CLASIFI", "#rsForm.idClase#")> 
					<fieldset>
						<legend><cf_translate key="LB_InformacionOtrosDatos">Otros Datos del Activo</cf_translate></legend>
						<cfinvoke component="sif.Componentes.DatosVariables" method="PrintDatoVariable" returnvariable="Cantidad">
							<cfinvokeargument name="DVTcodigoValor" value="AF">
							<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
							<cfinvokeargument name="DVVidTablaVal"  value="#rsForm.CRDRid#">
							<cfinvokeargument name="NumeroColumas"  value="3">
							<cfinvokeargument name="DVVidTablaSec" 	value="1"><!---1 (CRDocumentoResponsabilidad) --->
						</cfinvoke>
						<cfif Cantidad EQ 0>
							<div align="center">No Existen Datos Variables Asignados al Activo</div>
						</cfif>
					</fieldset>
				</td></tr>
			</cfif>		
		</table>
		
		<!--- Definición de botones --->
		<cfset include = "">
		<cfset includeVal ="">
		<cfset exclude = "">		
		<cfif not Lvar_Autogestion>
			<cfset include = ListAppend(include,'Regresar')>
			<cfset includeVal = ListAppend(includeVal,BTN_Regresar)>
			<cfif modo neq "ALTA">
				<cfset include = ListAppend(include,'Aplicar')>
				<cfset includeVal = ListAppend(includeVal,BTN_Aplicar)>
			</cfif>
		<cfelse>
			<cfset exclude = ListAppend(exclude,'Baja')>			
		</cfif>
		<cfif RSUltimo.recordcount gt 0 and RSUltimo.CRDRid gt 0 >
			<cfset include    = ListAppend(include,'PreCarga')>
			<cfset includeVal = ListAppend(includeVal,BTN_PreCarga)>
		</cfif>
		<cf_botones modo="#modo#" include="#include#" exclude="#exclude#" includevalues="#includeVal#" tabindex="1">
	</form>
</cfoutput>


<!--- Validaciones utilizando API qforms --->
<cf_qforms>
	<cf_qformsRequiredField args="CRCCid, #MSG_CentroDeCustodia#">
	<cf_qformsRequiredField args="ACcodigo, #MSG_Categoria#">
	<cf_qformsRequiredField args="ACid, #MSG_Clase#">
	<cf_qformsRequiredField args="CRDRdescripcion, #MSG_Descripcion#">
	<cf_qformsRequiredField args="AFMid, #MSG_Marca#">
	<cf_qformsRequiredField args="AFMMid, #MSG_Modelo#">
	<cf_qformsRequiredField args="AFCcodigo, #MSG_Tipo#">
	<cf_qformsRequiredField args="CRDRdescdetallada, #MSG_DescripcionDetallada#">
	<cf_qformsRequiredField args="CRTDid, #MSG_TipoDeDocumento#">
	<cf_qformsRequiredField args="CRDRfdocumento, #MSG_FechaDelDocumento#">
	<cf_qformsRequiredField args="DEid, #MSG_Empleado#">
	<cf_qformsRequiredField args="CRTCid, #MSG_CRTCid#">
</cf_qforms>
<cfif modo NEQ 'ALTA' AND Cantidad GT 0>
	<cfinvoke component="sif.Componentes.DatosVariables" method="QformDatoVariable">
		<cfinvokeargument name="DVTcodigoValor" value="AF">
		<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
		<cfinvokeargument name="DVVidTablaVal"  value="#rsForm.CRDRid#">
		<cfinvokeargument name="DVVidTablaSec" 	value="1"> <!---1 (CRDocumentoResponsabilidad)--->
		<cfinvokeargument name="objForm" 		value="objForm">
	</cfinvoke>
</cfif>
<script language="javascript" type="text/javascript">
	var tipo = <cfoutput>#rsForm.TipoOrigen#</cfoutput>;
	var popUpWin = 0;
	var LvarCambio = false;
	function popUpWindowDOlinea(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function doConlisDOlinea() {
		var documento = document.form1.CRDRdocori2.value;
		popUpWindowDOlinea("documento-conlis-linea-compra.cfm?documentoOri="+documento,50,50,1060,600);
	}
	function limpiarDOlinea() {
		document.form1.EOidorden.value="";
		document.form1.EOnumero.value="";
		document.form1.DOlinea.value="";
		document.form1.DOconsecutivo.value="";
	}
<!---►►Funcion para agregar Doc de CXP o OC◄◄--->
	num=0;
	function AgregarDoc(docCxP,lineaCxP,docCM,lineaCM,DOlinea,Cambio){
		LvarCambio = Cambio;
		$("#Asociar option:selected").each(function () {
		   if($(this).val() == 0){<!--NINGUNO-->
			  alert('Debe seleccionar un tipo de Asociación');
			  return ;
		   }
		   else if ($(this).val() == 1){<!--FC-->
				if(docCxP == ""){
					alert('Debe digitar un documento de CxP valido');
					return ;
				}
				if(lineaCxP == "" || lineaCxP == 0 ){
					alert('Debe digitar una Linea del Documento de CxP valido');
					return ;
				}
				num++;
				 
				 if (document.getElementById('divFC_'+lineaCxP) != null){
					 $("#DDlinea").val("");
					return ;
				 }
				 
				 //--►►Se crea el contenedor
					 fi            = document.getElementById('fiel'); 
					 contenedor    = document.createElement('li');
					 contenedor.id = 'divFC_'+lineaCxP;
					 fi.appendChild(contenedor); 				
				 //--►►Crea el campo que se ver en pantalla
					 ele 		   = document.createElement('label');
					 ele.id 	   = 'div'+num; 
					 ele.innerHTML ='Doc.'+docCxP+' - Lin. '+lineaCxP;
					 contenedor.appendChild(ele);
				 //--►►Crea el boton de Eliminar
					 ele       	 = document.createElement('img'); 
					 ele.src     = '../../../imagenes/Borrar01_S.gif';
					 ele.name    = 'divFC_'+lineaCxP;
					 ele.id 	 = num; 
					 ele.onclick = function () {borrar(this.name, this.id)}
					 contenedor.appendChild(ele); 
				 //--►►Se Crea el Campo Oculto que se pasara como una lista al sql
					 ele = document.createElement('input');
					 ele.type = 'hidden'; 
					 ele.name = 'DDlineas'; 
					 ele.value = lineaCxP;
					 contenedor.appendChild(ele); 
				 //--►►Se Resetea la linea y no se permite cambiar el Documento de CxP
					 $("#DDlinea").val("");
					 $("#CRDRdocori").attr('readonly','true');					   
			}
			else if ($(this).val()== 2){<!--OC-->
				if(docCM == ""){
					alert('Debe digitar una orden de Compra valida');
					return ;
				}
				if(lineaCM == "" || lineaCM == 0 ){
					alert('Debe digitar una Linea del Documento de CxP valido');
					return ;
				}
				var CRDRdocori2 = document.form1.CRDRdocori2.value;
				if(CRDRdocori2 == "" || CRDRdocori2 == 0 ){
					alert('Debe digitar una Linea del Documento de CxP valido');
					return ;
				}
				 num++;
				 if (document.getElementById('divCM_'+DOlinea) != null){
					 $("#DDlinea").val("");
					return ;
				 }
				 
				 //--►►Se crea el conetenedor
					 fi            = document.getElementById('fiel'); 
					 contenedor    = document.createElement('li');
					 contenedor.id = 'divCM_'+DOlinea;
					 fi.appendChild(contenedor); 				
				 //--►►Crea el campo que se ver en pantalla
					 ele           = document.createElement('label');
					 ele.id        = 'div'+num; 
					 ele.innerHTML = 'OC.'+docCM+' - Lin. '+lineaCM;
					 contenedor.appendChild(ele);				 
				 //--►►Crea el boton de Eliminar
					 ele         = document.createElement('img'); 
					 ele.src     = '../../../imagenes/Borrar01_S.gif';
					 ele.name 	 = 'divCM_'+DOlinea;
					 ele.id 	 = num; 
					 ele.onclick = function () {borrar(this.name,this.id)}
					 contenedor.appendChild(ele); 
				 //--►►Se Crea el Campo Oculto que se pasara como una lista al sql
					 ele = document.createElement('input');
					 ele.type  = 'hidden'; 
					 ele.name  = 'DOlineas'; 
					 ele.value = DOlinea;
					 contenedor.appendChild(ele); 
				  //--►►Se recetea el Id, la OC y el consecutivo de la OC.
					 $("#DOlinea").val("");
					 $("#EOnumero").val("");
					 $("#DOconsecutivo").val("");
					 $("#CRDRdocori2").attr('readonly','true');
			}
			else{<!--OTRO-->
				alert('Debe seleccionar un tipo de Asociación');
				return ;
			}
		});
	}
	
	function borrar(obj,id) {
	  var linea = $("#div"+id).text();
	  if (confirm("¿Est\u00e1 seguro de que desea eliminar la Linea: "+linea+"?")){
		fi = document.getElementById('fiel');
	    fi.removeChild(document.getElementById(obj)); 
	  }
	  else{
		return false;
	  }
	}
	
	function borrarT(val) {
	  <cfoutput>
	  	  if (tipo != val){
			fi = document.getElementById('fiel');
			$('li',$(fi)).remove();
			tipo = val;
			
		  }
	  </cfoutput>
	}
	<cfif UCASE(TRIM(modo)) EQ 'CAMBIO' AND LISTLEN(rsForm.DDlineas) GT 0>
		<cfloop list="#rsForm.DDlineas#" index="LvarDDlinea">
			AgregarDoc(<cfoutput>'#rsForm.CRDRdocori#','#LvarDDlinea#','','','',false</cfoutput>);
		</cfloop>		
	<cfelseif UCASE(TRIM(modo)) EQ 'CAMBIO' AND LISTLEN(rsForm.DOlineas) GT 0>
		<cfoutput>
			<cfloop list="#rsForm.DOlineas#" index="LvarDOlinea">
				<cfquery name="rsSelec" datasource="#session.DSN#">
					select l1.EOnumero, l1.DOconsecutivo
						from DOrdenCM l1
						where l1.DOlinea = #LvarDOlinea#
				</cfquery>	
				AgregarDoc('','','#rsSelec.EOnumero#','#rsSelec.DOconsecutivo#','#LvarDOlinea#',false);
			</cfloop>
		</cfoutput>
	</cfif>
	
	<!--//
		// crea el objeto Mask	
		oStringMask = new Mask("");
		oStringMask.attach(objForm.CRDRplaca.obj,oStringMask.mask,"string","ValidarPlaca(document.form1.CRDRplaca);");
		
		var validarDocOrigen = false;
		function strReplace(str,oldc,newc){
		   var HILERA="";
		   var CARACTER="";
		   for (var i=0; i<str.length; i++){
			  CARACTER=str.substring(i,i+1)
			  if (CARACTER==oldc)  
				{CARACTER=newc}
			  HILERA=HILERA+CARACTER;
		   }
		   return HILERA;
		}		
		function rtrim(tira){
			if (tira.name)
			  {VALOR=tira.value}
			  else {VALOR=tira}
			var CARACTER=""
			var HILERA=VALOR
			INICIO = VALOR.lastIndexOf(" ")
			   if(INICIO>-1){
				 for(var i=VALOR.length; i>0; i--){  
					 CARACTER= VALOR.substring(i,i-1)
					 if(CARACTER==" ")
						HILERA = VALOR.substring(0,i-1)
					 else
						i=-200
				  }
			   }
			return HILERA
		}
		<cfif (modo neq "ALTA")>
		function funcAplicar(){
			if(LvarCambio){
				alert ("Se realizaron cambios en algunos elmentos, debes guardarlos para aplicar");	
				return false;
			}
			else{
				if (!confirm("<cfoutput>#MSG_DeseaAplicarElDocumento#</cfoutput>")){
					return false;
				}
				else{
					validarDocOrigen = true;
				}
			}
		}
		</cfif>
		function resetCategoria(){
			//document.form1.ACcodigo.value=''; document.form1.ACcodigodesc.value=''; document.form1.ACdescripcion.value='';
			//resetClase();
		}
		function resetClase(){
			//document.form1.ACid.value=''; document.form1.Cat_ACcodigodesc.value=''; document.form1.Cat_ACdescripcion.value='';
			var placa = document.form1.CRDRplaca.value;
			CambiarMascara();
			if(rtrim(placa).length > 0){
				document.form1.CRDRplaca.value = placa ;
			}
		}
		function resetModelo(){
			//document.form1.AFMMid.value=''; document.form1.AFMMcodigo.value=''; document.form1.AFMMdescripcion.value='';
		}
		function CambiarMascara(){
			var mascara = "";
			objForm.CRDRplaca.obj.value="";
			objForm.CRDRplaca_text.obj.value = "";
			mascara = objForm.ACmascara.getValue();

			if (mascara.length > 0) {
				var strErrorMsg="<cfoutput>#MSG_ElValorDeLaPlacaNoConcuerdaConElFormato#</cfoutput> "+mascara;
				oStringMask.mask = mascara.replace(/X/g,"*");
				objForm.CRDRplaca.obj.disabled=false;
				objForm.CRDRplaca_text.obj.value = mascara.replace(/X/g,"X");
				return true;
			}
			<!---objForm.CRDRplaca.obj.disabled=true;--->
			objForm.CRDRplaca.obj.value='';
		}
		function ValidarPlaca(obj) {
			var placa = obj.value;
			<cfoutput>
			<cfif (modo neq "ALTA")>
			document.all["fr"].src="valida_placa.cfm?CRDRid=#form.CRDRid#&nomPlaca=CRDRplaca&placa="+placa;
			<cfelse>
			document.all["fr"].src="valida_placa.cfm?nomPlaca=CRDRplaca&placa="+placa+"&valorMejoraUrl="+document.getElementById("valorMejora").value;
			</cfif>
			</cfoutput>			
		}
		function limpiarEmpleadoCFuncional(){
			objForm.CFid.obj.value="";
			objForm.CFcodigo.obj.value="";
			objForm.CFdescripcion.obj.value="";
			objForm.DEid.obj.value="";
			objForm.DEidentificacion.obj.value="";
			objForm.DEnombrecompleto.obj.value="";
			resetCategoria();
		}
		<cfset Lvar_jsAutogestion = "">
		<cfif Lvar_Autogestion>	
			<cfset Lvar_jsAutogestion = "-auto">
		</cfif>
		function ResetFormCRCCid() {
			document.form1.action = 'documento<cfoutput>#Lvar_jsAutogestion#</cfoutput>.cfm?btnNuevo=1';
			document.form1.submit();
		}		
		function funcPreCarga() {
			document.form1.action="documento<cfoutput>#Lvar_jsAutogestion#</cfoutput>.cfm";
			deshabilitarValidacion();
			validarDocOrigen = false;
		}
		function funcRegresar() {
			document.form1.action="documento<cfoutput>#Lvar_jsAutogestion#</cfoutput>.cfm";
			<cfif (modo neq "ALTA")>
			document.form1.CRDRid.value="";
			</cfif>
			deshabilitarValidacion();
			validarDocOrigen = false;
		}
		function funcCambio() {
			ValidarPlaca(document.form1.CRDRplaca);
			validarDocOrigen = true;
		}
		function funcAlta()   {validarDocOrigen = true;}
		function funcNuevo()  {validarDocOrigen = true;}
		function funcBaja()   {validarDocOrigen = false;}

		function finalizar() {
				var Documento = document.form1.CRDRdocori.value;
				var OC = document.form1.DOlineas.value;
			if (validarDocOrigen)
			{	
				if(rtrim(Documento).length <= 0 & rtrim(OC).length <= 0){ 
					alert("En la información del Origen deben digitar Documento o Orden de Compra");
					return false;
				}
				else if(rtrim(Documento).length > 0 & rtrim(OC).length > 0){ 
					alert("En la Información del Origen no puede digitar Documento y Orden de Compra a la vez");
					return false;
				}
			}
			
			return true;
		}
		CambiarMascara();
		<cfif (MODO neq "ALTA")>
				objForm.CRDRplaca.obj.value="<cfoutput>#Trim(rsForm.CRDRplaca)#</cfoutput>";
				ValidarPlaca(objForm.CRDRplaca.obj);
		</cfif> 
		//Pone el enfoque.
		document.form1.ACcodigodesc.focus();				
	//-->

	
<!---►►Oculta y visualiza Div, depediente de los que se seleccione en combo◄◄--->	
	$(document).ready(function(){
		 $("#Asociar").change(function () {
          var str = "";
          $("#Asociar option:selected").each(function () {
               if($(this).val() == 0){<!--NINGUNO-->
				   $("#ListDocs").hide("slow"); 
			   }
				else if ($(this).val() == 1){<!--FC-->
				   $("#ListDocs").show(1000);
					$("#LabelOC").hide("slow");
					$("#LabelCP").hide("slow");
					 $("#LabelFC").show(1000);
					  $("#LabelLinea").show(1000);
					   $("#InputOC").hide("slow");
					    $("#InputFC").show(1000);
						 $("#LineaOC").hide("slow");
						  $("#LineaCP").hide("slow");
						  $("#LineaFC").show(1000);
						   $("#PopUpOC").hide("slow");
						   
				}
				else if ($(this).val()== 2){<!--OC-->
				  $("#ListDocs").show(1000);
					$("#LabelFC").hide("slow");
					 $("#LabelOC").show(1000);
					  $("#LabelCP").show(1000);	
					  $("#LabelLinea").show(1000);
					   $("#InputFC").hide("slow");
					    $("#InputOC").show(1000);
						 $("#LineaFC").hide("slow");
						  $("#LineaOC").show(1000);
						  $("#LineaCP").show(1000);
						   $("#PopUpOC").show(1000);
						   
				}
				else{<!--OTRO-->
					$("#ListDocs").hide("slow");
				}
              });
        })
        .change();
	});
	
	<!---SML Activar TextBox cuando se seleccione el chkMejora y se tenga una mejora --->
	function fnActivar(form)
	{
		if (form.chkMejora.checked == true)	
		{
			document.getElementById("CRDRplaca").readOnly=false;
			document.getElementById("CRDRplaca").style.display = "none";
			document.getElementById("CRDRplacaA").style.display = "";
			document.getElementById("CRDRplacaA").required = true;
			document.getElementById("valorMejora").value="1";
		}
		else
		{
			document.getElementById("CRDRplaca").value = "";
			document.getElementById("CRDRplaca").readOnly=true;
			document.getElementById("CRDRplaca").style.display = "";
			document.getElementById("CRDRplacaA").style.display = "none";
			document.getElementById("CRDRplacaA").required = false;
			document.getElementById("valorMejora").value="0"
		}
	} 
	
</script>
<!---►►►Funciones◄◄--->
<cffunction name="ObtenerDato" returntype="query" access="private" hint="Obtiene los datos de la tabla de Parámetros según el pcodigo">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = #Arguments.pcodigo#
	</cfquery>
	<cfreturn rs>
</cffunction>
