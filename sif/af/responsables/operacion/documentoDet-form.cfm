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
<cf_dbfunction name="now" returnvariable="hoy">
<!---►►Inclusion de JQUERY◄◄--->
<script>
	!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
</script>
<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>

<cfset paginado=5.00>

<cfif isdefined("form.CRDRdocori")>

	<cfquery name="rs" datasource="#Session.DSN#">
		select isnull(Pvalor,1) as Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#  
		  and Pcodigo = 200060
	</cfquery>
	<cfset TipoPlaca = rs.Pvalor>

	<cf_dbfunction name="concat" args="d.DEapellido1 + ' ' + d.DEapellido2 + ' ' + d.DEnombre" delimiters="+" returnvariable="LvarNombre">
	<cfset LvarNombre = "(( select min(#LvarNombre#) from DatosEmpleado d where d.DEid = a.DEid ))">
	<cfquery name="rs_infoT" datasource="#session.DSN#">
		select CEILING((count(1)/#paginado#))  as reg
		from CRDocumentoResponsabilidad a    
		where a.CRDRdocori =<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#form.CRDRdocori#">
		and a.CRDRestado = 0  
		and a.CRDR_TipoReg is not null 
	</cfquery>

	<cfset page=1>
	<cfif isdefined("url.pag") and len(trim(url.pag))>
		<cfset page=url.pag>
	<cfelse>
		<cfset page=1>
	</cfif>

	<cfquery name="rs_info" datasource="#session.DSN#">
		WITH C AS
		( 
		select 
				ROW_NUMBER() OVER(ORDER BY a.CRDRid) AS rownum,
                g.ACatId,
                (( select min(h1.AClaId)
                    from AClasificacion h1
                    where h1.Ecodigo 	= a.Ecodigo
                      and h1.ACid 		= a.ACid
                      and h1.ACcodigo 	= a.ACcodigo
                )) as idClase,
                a.CRDRid, 
                a.CRTDid, 
                a.CRTCid, 
                a.DEid, 
                a.CFid, 
                a.CRDRdescripcion, 
                a.CRDRfdocumento,
                a.CRDRplaca, 
                a.CRDRdescdetallada, 
                a.CRDRserie, 
                a.CRDRtipodocori, 
                a.CRDRdocori, 
                a.CRDRlindocori, 
                a.Monto,
                a.EOidorden, 
                a.DOlinea, 
                a.CRCCid,
                case when a.EOidorden is not null or a.DOlineas is not null then 2<!---Asociar a una Orden de Compra--->
                when a.CRDRdocori is not null then 1<!---Asociar a una Factura CXP--->
                else 0 end as TipoOrigen,<!---Sin asociacion--->
                a.ts_rversion, 
                a.CRorigen,
    			a.DOlineas, 
                a.DDlineas, 
                a.AFCMejora,
                a.AFCMid,
                ((select min(b1.CRTDcodigo)
                    from CRTipoDocumento b1
                    where b1.CRTDid = a.CRTDid
                    )) as CRTDcodigo,
                
                ((select min(b2.CRTDdescripcion)
                    from CRTipoDocumento b2
                    where b2.CRTDid = a.CRTDid
                    )) as CRTDdescripcion,
    
                ((select c1.CRTCcodigo
                    from CRTipoCompra c1 
                    where c1.CRTCid = a.CRTCid
                    )) as CRTCcodigo, 
                ((select c2.CRTCdescripcion
                    from CRTipoCompra c2 
                    where c2.CRTCid = a.CRTCid
                    )) as CRTCdescripcion, 
    
                (( select min(d.DEidentificacion) from DatosEmpleado d where d.DEid = a.DEid )) as DEidentificacion, 
                #preservesinglequotes(LvarNombre)# as DEnombrecompleto, 
    
                ((select min(e1.CFcodigo)
                    from CFuncional e1
                    where e1.CFid = a.CFid
                    )) as CFcodigo, 
                ((select min(e2.CFdescripcion)
                    from CFuncional e2
                    where e2.CFid = a.CFid
                    )) as CFdescripcion,
    
                ((select f1.CRCCcodigo
                    from CRCentroCustodia f1
                    where f1.CRCCid = a.CRCCid
                    )) as CRCCcodigo, 
                ((select f2.CRCCdescripcion
                    from CRCentroCustodia f2
                    where f2.CRCCid = a.CRCCid
                    )) as CRCCdescripcion,
    
                g.ACcodigo      as ACcodigo, 
                g.ACcodigodesc  as ACcodigodesc,
                g.ACdescripcion as ACdescripcion,
				<cfif TipoPlaca EQ 2>
					h.ACmascara     as ACmascara, 
				<cfelse>
					g.ACmascara     as ACmascara, 
				</cfif> 
                (( select min(h1.ACid)
                    from AClasificacion h1
                    where h1.Ecodigo 	= a.Ecodigo
                      and h1.ACid 		= a.ACid
                      and h1.ACcodigo 	= a.ACcodigo
                )) as ACid,
                
                (( select min(h2.ACcodigodesc)
                    from AClasificacion h2
                    where h2.Ecodigo	= a.Ecodigo
                      and h2.ACid 		= a.ACid
                      and h2.ACcodigo 	= a.ACcodigo
                )) as Cat_ACcodigodesc,
                
                (( select min(h3.ACdescripcion)
                    from AClasificacion h3
                    where h3.Ecodigo 	= a.Ecodigo
                      and h3.ACid 		= a.ACid
                      and h3.ACcodigo 	= a.ACcodigo
                )) as Cat_ACdescripcion,
    
                i.AFCcodigo,
                i.AFCcodigoclas,
                i.AFCdescripcion,
    
                j.AFMid,
                j.AFMcodigo,
                j.AFMdescripcion,
    
                k.AFMMid,
                k.AFMMcodigo,
                k.AFMMdescripcion,
    
                ((select l1.EOnumero
                    from DOrdenCM l1
                    where l1.DOlinea = a.DOlinea
                    )) as EOnumero, 
                    
                ((select l2.DOconsecutivo
                    from DOrdenCM l2
                    where l2.DOlinea = a.DOlinea
                    )) as DOconsecutivo,
                a.CRDR_TipoReg
            from CRDocumentoResponsabilidad a 
                   inner JOIN ACategoria g 
					ON g.Ecodigo = a.Ecodigo
					AND g.ACcodigo = a.ACcodigo
					inner JOIN AClasificacion h 
					ON h.Ecodigo = a.Ecodigo
					AND h.ACcodigo = a.ACcodigo
					and h.Acid=a.Acid
					inner JOIN AFClasificaciones i 
					ON i.Ecodigo = a.Ecodigo
					AND i.AFCcodigo = a.AFCcodigo
					left JOIN AFMarcas j 
					ON j.AFMid = a.AFMid
					left JOIN AFMModelos k 
					ON k.AFMMid = a.AFMMid
			where a.CRDRdocori =<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#form.CRDRdocori#">
			and a.CRDRestado = 0  
			and a.CRDR_TipoReg is not null 

		)
		SELECT *
		FROM C
		WHERE rownum BETWEEN ( 1 + (#paginado# * (#page#-1)) ) AND (#paginado# * #page#)
		ORDER BY CRDRid
	</cfquery>
	<!--- Tipo --->
	<cfquery name="rs_AFClasifi" datasource="#session.DSN#">
		select AFCcodigo,AFCcodigoclas,AFCdescripcion
		from AFClasificaciones 
		where Ecodigo = #Session.Ecodigo# 
		order by AFCcodigoclas,AFCdescripcion
	</cfquery>
	<!--- Tipo Documento --->
	<cfquery name="rs_CRTipoD" datasource="#session.DSN#">
		select CRTDid,CRTDcodigo,CRTDdescripcion
		from CRTipoDocumento   
		where Ecodigo = #Session.Ecodigo# 
		order by CRTDcodigo,CRTDdescripcion
	</cfquery>
	<!--- Tipo Compra --->
	<cfquery name="rs_CRTipoC" datasource="#session.DSN#">
		select CRTCid,CRTCcodigo,CRTCdescripcion
		from CRTipoCompra   
		where Ecodigo = #Session.Ecodigo# 
		order by CRTCcodigo,CRTCdescripcion
	</cfquery>
</cfif>



<cfif isdefined("form.CRDRdocori") and len(form.CRDRdocori) gt 0 and  rs_info.Recordcount gt 0>
	<cfset modo='cambio'>
	<!--- <cf_Dump var="#rs_info#"> --->
<cfelse>
	<cfset modo='alta'>
</cfif>
<!--- <cfif isdefined("form.CRDRdocori") and len(form.CRDRdocori) gt 0 and  rs_info.Recordcount gt 0>
	<cf_Dump var="#rs_info#">
</cfif> --->
<!--- Pintado del formulario --->

<style>
input[type="text"], select {
    font-size: 9px !important;
  }
</style>

<form action="documentoDet-sql.cfm" name="form1" id="form1" method="post" onSubmit="">
	<cfoutput>
	<br>
	<table width="80%" align="center" border="0" cellspacing="0" cellpadding="2">
				<!---2 Informacion General del Activo Fijo --->		
				<input type="hidden" name="page" 		 value="#page#" />
				<tr><td colspan="5" class="tituloAlterno"><div align="center"><cfoutput>Encabezado del Documento</cfoutput></div></td></tr>
				<tr><td colspan="5">&nbsp;</td></tr>
				<tr>
					<td >Factura CxP</td>
					<td colspan="4">
					<cfset ValuesArray=ArrayNew(1)>
					<cfset Ronly="no">
					<cfif modo EQ 'cambio'>
						<cfset Ronly="yes">
						<cfset ArrayAppend(ValuesArray,rs_info.CRDR_TipoReg[1])>
						<cfset ArrayAppend(ValuesArray,rs_info.CRDRdocori[1])>
					</cfif>
					<!--- <cf_Dump var="#ValuesArray#"> --->

					<cf_conlis title="Documentos CXP"
								campos = "IDdocumento, EDdocumento" 
								ValuesArray="#ValuesArray#"
								desplegables = "S,S" 
								modificables = "N,N" 
								size = "40,40"
								tabla="EDocumentosCxP cp
										 left outer join  CRDocumentoResponsabilidad a
											 on a.Ecodigo = cp.Ecodigo
											 and a.CRDRdocori=cp.EDdocumento 
											 and a.CRDR_TipoReg=cp.IDdocumento"
								columnas="cp.IDdocumento, cp.EDdocumento"
								filtro="cp.Ecodigo = #Session.Ecodigo# and cp.CPTcodigo = 'FA'
										  and  a.CRDRdocori is null
										  and  a.CRDR_TipoReg is null"
								desplegar="IDdocumento, EDdocumento"
								etiquetas="ID Documento, Documento"
								formatos="S,S"
								align="right,right"
								asignar="IDdocumento, EDdocumento"
								asignarformatos="I,S"
								showEmptyListMsg="true"
								debug="false"
								readonly="#Ronly#"
								tabindex="1">
					</td>
				</tr>

				<cfif modo NEQ 'cambio'>
					<tr>
						<td  colspan="5">
							<input type="submit" name="btnDocumentos" value="Generar Documentos">	
						</td>
					</tr>
				</cfif>
				<cfif modo EQ 'cambio'>
				<!---2 Informacion General del Activo Fijo --->
				<!--- <tr>
					<td colspan="5" class="tituloAlterno">
						<div align="center"><cfoutput>Informacion General del Activo Fijo</cfoutput></div>
					</td>
				</tr> --->
								<!--- <tr>
									<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</p>
									</td>
									<td>
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
										  <tr>
											<td>
												<INPUT TYPE="textbox" NAME="CFcodigo" SIZE="10" readonly="yes" MAXLENGTH="CFcodigo" ONBLUR="" ONFOCUS="this.select(); " VALUE="<cfif  modo EQ 'cambio'>#rs_info.CFcodigo[1]#</cfif>" ONKEYUP="" tabindex="-1" style="border: medium none; text-align:left; size:auto;"/>
											</td>
											<td>
												<input type="textbox" name="CFdescripcion" size="35" readonly="yes" maxlength="35" onblur="" onfocus="this.select(); " VALUE="<cfif  modo EQ 'cambio'>#rs_info.CFdescripcion[1]#</cfif>" tabindex="-1" onkeyup="" style="border: medium none; text-align:left; size:auto;"/>
												<input type="hidden" value="<cfif  modo EQ 'cambio'>#rs_info.CFid[1]#</cfif>" name="CFid" id="CFid"/>
											</td>
										  </tr>
										</table>
									</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel">
									</td>
									<td>
									</td>
									
								</tr> --->
								    <!---►►Tipo de Asociacion◄◄--->
								   <!---  <cfparam name="rsForm.TipoOrigen" default="0">
								    <td colspan="2" align="center">
								    	<select name="Asociar" id="Asociar" onchange="javascript: borrarT(this.value);">
								        	<option value="0" <cfif TRIM(rs_info.TipoOrigen[1]) EQ 0>selected="selected"</cfif>>Sin asociacion</option>
								            <option value="1" <cfif TRIM(rs_info.TipoOrigen[1]) EQ 1>selected="selected"</cfif>>Asociar a una Factura CXP</option>
								            <option value="2" <cfif TRIM(rs_info.TipoOrigen[1]) EQ 2>selected="selected"</cfif>>Asociar a una Orden de Compra</option>
								        </select>
								    </td> --->
				</cfif><!--- Modo cambio --->
		</table>

		<br><br><br><br>
		<!--- <cfdump var="#rs_info#"> --->
		<table width="80%" align="center" border="0" cellspacing="0" cellpadding="2" >
								<!--- DEtalle por inclusion  --->
								<tr>
									<td colspan="14" class="tituloAlterno">
										<div align="center"><cfoutput>Detalle por Documento de Inclusion</cfoutput>
									     </div>
									 </td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel">
										<p><cf_translate key="LB_Cons">Num.</cf_translate>&nbsp;</p>
									</td>
									<td nowrap="nowrap" class="fileLabel" align="center"> 
										<p><cf_translate key="LB_CCustodia">Centro Custodia</cf_translate>&nbsp;</p>
									</td>
									<td  nowrap="nowrap" class="fileLabel" align="center">
										<p><cf_translate key="LB_Categoria">Categor&iacute;a</cf_translate>&nbsp;</p>
									</td>
									<td nowrap="nowrap" class="fileLabel" align="center">
										<p><cf_translate key="LB_Clase">Clase</cf_translate>&nbsp;</p>
									</td>
									<td nowrap="nowrap" class="fileLabel" align="center">
										<p><cf_translate key="LB_Decripcion">Descripci&oacute;n</cf_translate>&nbsp;</p>
									</td>
									<td nowrap="nowrap" class="fileLabel" align="center">
										<p><cf_translate key="LB_Marca">Marca</cf_translate>&nbsp;</p>
									</td>
									<td nowrap="nowrap" class="fileLabel" align="center">
										<p><cf_translate key="LB_Modelo">Modelo</cf_translate>&nbsp;</p>
									</td>
									<td nowrap="nowrap" class="fileLabel" align="center">
										<p><cf_translate key="LB_DescripcionDetallada">Descripci&oacute;n Detallada</cf_translate></p>
									</td>
									<td nowrap="nowrap" class="fileLabel" align="center">
										<p><cf_translate key="LB_Tipo">Tipo</cf_translate>&nbsp;</p>
									</td>
									<td nowrap="nowrap" class="fileLabel" align="center">
										<p><cf_translate key="LB_Serie">Serie</cf_translate></p>
									</td>
									<td nowrap="NOWRAP" class="fileLabel" align="center">
										<p><cf_translate key="LB_TipoDeDocumentos">Tipo de Documento</cf_translate>:&nbsp;</p>
									</td>
									<td nowrap="nowrap" class="fileLabel" align="center">
										<p><cf_translate key="LB_Empleado">Empleado</cf_translate>&nbsp;</p>
									</td>
									<td nowrap="nowrap" class="fileLabel" align="center">
								  		<p><cf_translate key="LB_TipoDeCompra">Tipo de Compra</cf_translate> :&nbsp;</p>	
									</td>
									<td nowrap="nowrap" class="fileLabel" align="center">
								  		<p><cf_translate key="LB_Monto">Monto</cf_translate> :&nbsp;</p>	
									</td>
								</tr>
								<!--- Loop Detalles --->
								<cfif modo EQ 'cambio'>
									<cfset nume= ( 1 + (#paginado# * (#page#-1)) )>
									<cfloop query="rs_info">
											<tr class="#(nume MOD 2 ? 'listaNon':'listaPar')#">
												<td>
													#nume#.- <input type="hidden" name="CRDRid#rs_info.CRDRid#" value="#rs_info.CRDRid#" />
															 <input type="hidden" name="EOidorden#rs_info.CRDRid#" value="#rs_info.EOidorden#" />
															 <input type="hidden" name="DDlineas#rs_info.CRDRid#" value="#rs_info.DDlineas#" />
															 <input type="hidden" name="DOlineas#rs_info.CRDRid#" value="#rs_info.DOlineas#" />
															 
												</td>
												<!--- Centro Custodia --->
												<td>
													<cfif RSCentros.recordcount gt 0>
														<select name="CRCCid#rs_info.CRDRid#" tabindex="1"  style="width:90px" onchange="javascript: ResetFormCRCCid();">
															<cfloop query="RSCentros">
																<option value="#RSCentros.CRCCid#"  
																	<cfif modo EQ 'cambio' and rs_info.CRCCID EQ RSCentros.CRCCID> 
																		selected="selected"
																	</cfif>>
																#RSCentros.CRCCcodigo#-#RSCentros.CRCCdescripcion#
																</option>
															</cfloop>
														</select>
													<cfelse>
														<input name="CRCCid"  value="-1" tabindex="-1" type="hidden">
											  		</cfif>
												</td>
												<!--- Categoria --->
												<td>
			                                        <cf_conlis
														Campos="ACcodigo#rs_info.CRDRid#, ACcodigodesc#rs_info.CRDRid#, ACdescripcion#rs_info.CRDRid#, ACmascara#rs_info.CRDRid#"
														Desplegables="N,S,S,N"
														Modificables="N,S,N,N"
														Size="0,2,20,0"
														Values="#rs_info.ACcodigo#,#rs_info.ACcodigodesc#,#rs_info.ACdescripcion#,#rs_info.ACmascara#"
														Title="#LB_ListaDeCategorias#"
														tabindex="1"
														Tabla="ACategoria a"
														Columnas="ACcodigo as ACcodigo#rs_info.CRDRid#, ACcodigodesc as ACcodigodesc#rs_info.CRDRid#, ACdescripcion as ACdescripcion#rs_info.CRDRid#, ACmascara as ACmascara#rs_info.CRDRid#"
														Filtro="Ecodigo = #Session.Ecodigo# 
														order by ACcodigodesc, ACdescripcion"
														Desplegar="ACcodigodesc#rs_info.CRDRid#, ACdescripcion#rs_info.CRDRid#"
														Etiquetas="#LB_Codigo#,#LB_Descripcion#"
														filtrar_por="ACcodigodesc, ACdescripcion"
														Formatos="S,S"
														Align="left,left"
														Asignar="ACcodigo#rs_info.CRDRid#, ACcodigodesc#rs_info.CRDRid#, ACdescripcion#rs_info.CRDRid#, ACmascara#rs_info.CRDRid#"
														Asignarformatos="I,S,S,S"
			                                            />
			                                       
												</td>
												<!--- Clase --->
												<td>
			                                            <cf_conlis
														Campos="ACid#rs_info.CRDRid#, Cat_ACcodigodesc#rs_info.CRDRid#, Cat_ACdescripcion#rs_info.CRDRid#"
														Desplegables="N,S,S"
														Modificables="N,S,N"
														Size="0,10,22"
														tabindex="1"
														Values="#rs_info.ACid#,#rs_info.Cat_ACcodigodesc#,#rs_info.Cat_ACdescripcion#"
														Title="#LB_ListaDeClases#"
														Tabla="AClasificacion a"
														Columnas="ACid as ACid#rs_info.CRDRid#, ACcodigodesc as Cat_ACcodigodesc#rs_info.CRDRid#, ACdescripcion as Cat_ACdescripcion#rs_info.CRDRid# , ACdescripcion as CRDRdescripcion#rs_info.CRDRid#,ACmascara as ACmascara#rs_info.CRDRid#"
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
														Desplegar="Cat_ACcodigodesc#rs_info.CRDRid#, Cat_ACdescripcion#rs_info.CRDRid#"
														Etiquetas="#LB_Codigo#,#LB_Descripcion#"
														filtrar_por="ACcodigodesc, ACdescripcion"
														Formatos="S,S"
														Align="left,left"
														Asignar="ACid#rs_info.CRDRid#, Cat_ACcodigodesc#rs_info.CRDRid#,Cat_ACdescripcion#rs_info.CRDRid#,CRDRdescripcion#rs_info.CRDRid#, ACmascara#rs_info.CRDRid#"
														Asignarformatos="I,S,S,S"
														debug="false"/>
												</td>
												<!--- Descripcion  --->
												<td>
													<input type="text" tabindex="1" id="CRDRdescripcion#rs_info.CRDRid#" name="CRDRdescripcion#rs_info.CRDRid#" 
													<cfif modo EQ 'cambio'>
														value="#HTMLEditFormat(rs_info.CRDRdescripcion)#"
													</Cfif>size="20" maxlength="80">
												</td>
												<!--- MArca --->
												<td>
													<cfset VArrayMarc=ArrayNew(1)>
													<cfif 1 EQ 0>
														<cfset ArrayAppend(VArrayMarc,rs_info.AFMid[nume])>
														<cfset ArrayAppend(VArrayMarc,rs_info.AFMcodigo[nume])>
														<cfset ArrayAppend(VArrayMarc,rs_info.AFMdescripcion[nume])>
													</cfif>
													<cf_conlis
														Campos="AFMid#rs_info.CRDRid#,AFMcodigo#rs_info.CRDRid#,AFMdescripcion#rs_info.CRDRid#"
														Desplegables="N,S,S"
														Modificables="N,S,N"
														Size="0,3,14"
														form="form1"
														Values="#rs_info.AFMid#,#rs_info.AFMcodigo#,#rs_info.AFMdescripcion#"
														Title="#LB_ListaDeMarcas#"
														Tabla="AFMarcas"
														tabindex="1"
														Columnas="AFMid as AFMid#rs_info.CRDRid#,AFMcodigo as AFMcodigo#rs_info.CRDRid#,AFMdescripcion as AFMdescripcion#rs_info.CRDRid#"
														Filtro="Ecodigo = #Session.Ecodigo# order by AFMcodigo,AFMdescripcion"
														Desplegar="AFMcodigo#rs_info.CRDRid#,AFMdescripcion#rs_info.CRDRid#"
														Etiquetas="#LB_Codigo#,#LB_Descripcion#"
														filtrar_por="AFMcodigo,AFMdescripcion"
														Formatos="S,S"
														Align="left,left"
														Asignar="AFMid#rs_info.CRDRid#,AFMcodigo#rs_info.CRDRid#,AFMdescripcion#rs_info.CRDRid#"
														Asignarformatos="I,S,S"
														funcion="resetModelo"/>
												</td>
												<!---Modelo  --->
												<td>
													<cfset VArrayMod=ArrayNew(1)><cfif 1 EQ 0>
														<cfset ArrayAppend(VArrayMod,rs_info.AFMMid)>
														<cfset ArrayAppend(VArrayMod,rs_info.AFMMcodigo)>
														<cfset ArrayAppend(VArrayMod,rs_info.AFMMdescripcion)></cfif>
													<cf_conlis
														Campos="AFMMid#rs_info.CRDRid#,AFMMcodigo#rs_info.CRDRid#,AFMMdescripcion#rs_info.CRDRid#"
														Desplegables="N,S,S"
														Modificables="N,S,N"
														Size="0,7,15"
														Values="#rs_info.AFMMid#,#rs_info.AFMMcodigo#,#rs_info.AFMMdescripcion#"
														Title="#LB_ListaDeModelos#"
														Tabla="AFMModelos"
														tabindex="2"
														Columnas="AFMMid as AFMMid#rs_info.CRDRid#,AFMMcodigo as AFMMcodigo#rs_info.CRDRid#,AFMMdescripcion as AFMMdescripcion#rs_info.CRDRid#"
														Filtro="Ecodigo = #Session.Ecodigo# and AFMid = $AFMid#rs_info.CRDRid#,numeric$ order by AFMMcodigo,AFMMdescripcion"
														Desplegar="AFMMcodigo#rs_info.CRDRid#,AFMMdescripcion#rs_info.CRDRid#"
														Etiquetas="#LB_Codigo#,#LB_Descripcion#"
														filtrar_por="AFMMcodigo,AFMMdescripcion"
														Formatos="S,S"
														Align="left,left"
														Asignar="AFMMid#rs_info.CRDRid#,AFMMcodigo#rs_info.CRDRid#,AFMMdescripcion#rs_info.CRDRid#"
														Asignarformatos="I,S,S"/>
												</td>
												<!--- Descripcion detallada --->
												<td>
													<input type="text" tabindex="1" id="CRDRdescdetallada#rs_info.CRDRid#" name="CRDRdescdetallada#rs_info.CRDRid#"
														<cfif isdefined("rs_info.CRDRdescdetallada")>value="#HTMLEditFormat(rs_info.CRDRdescdetallada)#"</cfif> 
														size="20" maxlength="255">
												</td>
												<!--- Tipo --->
												<td nowrap="nowrap" class="fileLabel">
													<cfif rs_AFClasifi.recordcount gt 0>
														<select name="AFCcodigo#rs_info.CRDRid#" tabindex="1" style="width:110px">
															<cfloop query="rs_AFClasifi">
																<option value="#rs_AFClasifi.AFCcodigo#"  
																	<cfif modo EQ 'cambio' and rs_info.AFCcodigo EQ rs_AFClasifi.AFCcodigo> 
																		selected="selected"
																	</cfif>>
																#rs_AFClasifi.AFCcodigoclas#-#rs_AFClasifi.AFCdescripcion#
																</option>
															</cfloop>
														</select>
													<cfelse>
														<input name="AFClasifi#rs_info.CRDRid#"  value="-1" tabindex="-1" type="hidden">
											  		</cfif>
												</td>
												<!--- Serie --->
												<td>
													<input type="text" tabindex="1" id="CRDRserie#rs_info.CRDRid#" name="CRDRserie#rs_info.CRDRid#" 
														<cfif isdefined("rs_info.CRDRserie")>value="#HTMLEditFormat(rs_info.CRDRserie)#"</cfif>  
														size="15" maxlength="45" />
												</td>
												<!--- Tipo Documento --->
												<td nowrap="nowrap" class="fileLabel">
													<cfif rs_CRTipoD.recordcount gt 0>
														<select name="CRTDid#rs_info.CRDRid#" tabindex="1" style="width:100px">
															<cfloop query="rs_CRTipoD">
																<option value="#rs_CRTipoD.CRTDid#"  
																	<cfif modo EQ 'cambio' and rs_info.CRTDid EQ rs_CRTipoD.CRTDid> 
																		selected="selected"
																	</cfif>>
																#rs_CRTipoD.CRTDcodigo#-#rs_CRTipoD.CRTDdescripcion#
																</option>
															</cfloop>
														</select>
													<cfelse>
														<input name="CRTDid#rs_info.CRDRid#"  value="-1" tabindex="-1" type="hidden">
											  		</cfif>
												</td>
												<!--- Empleado --->
												<td>
													<cfset VArrayEid=ArrayNew(1)>
														<cfset ArrayAppend(VArrayEid,rs_info.DEid)>
														<cfset ArrayAppend(VArrayEid,rs_info.DEidentificacion)>
														<cfset ArrayAppend(VArrayEid,rs_info.DEnombrecompleto)>
													<cf_conlis
														Campos="DEid#rs_info.CRDRid#,DEidentificacion#rs_info.CRDRid#,DEnombrecompleto#rs_info.CRDRid#"
														ValuesArray="#VArrayEid#"
														Desplegables="N,S,S"
														Modificables="N,S,N"
														Size="0,5,30"
														form="form1"
														tabindex="1"
														Title="#LB_ListaDeEmpleados##rs_info.CRDRid#"
														Tabla=" CRCCCFuncionales cr
														 inner join CFuncional cf
														  on cf.CFid = cr.CFid
														 inner join EmpleadoCFuncional decf
														   on decf.CFid = cf.CFid
														  and #hoy# between decf.ECFdesde and decf.ECFhasta
														 inner join DatosEmpleado d
														  on d.DEid = decf.DEid "
														Columnas="d.DEid as DEid#rs_info.CRDRid#,
																  d.DEidentificacion as DEidentificacion#rs_info.CRDRid#,
																{fn concat(d.DEapellido1,{fn concat(' ',{fn concat(d.DEapellido2,{fn concat(' ',d.DEnombre)})})})} as DEnombrecompleto#rs_info.CRDRid#,
																cf.CFid as CFid#rs_info.CRDRid#,
																cf.CFcodigo as CFcodigo#rs_info.CRDRid#,
																cf.CFdescripcion as CFdescripcion#rs_info.CRDRid#"
														Filtro=" cr.CRCCid = #rs_info.CRCCid# order by DEidentificacion"
														Desplegar="DEidentificacion#rs_info.CRDRid#,DEnombrecompleto#rs_info.CRDRid#"
														Etiquetas="#LB_Identificacion#,#LB_Nombre#"
														filtrar_por="d.DEidentificacion|{fn concat(d.DEapellido1,{fn concat(' ',{fn concat(d.DEapellido2,{fn concat(' ',d.DEnombre)})})})}"
														filtrar_por_delimiters="|"
														Formatos="S,S"
														Align="left,left"
														Asignar="DEid#rs_info.CRDRid#,DEidentificacion#rs_info.CRDRid#,DEnombrecompleto#rs_info.CRDRid#,CFid#rs_info.CRDRid#,CFcodigo#rs_info.CRDRid#,CFdescripcion#rs_info.CRDRid#"
														Asignarformatos="S,S,S,I,S,S"
														MaxRowsQuery="200"/>	
												</td>
												<!--- Tipo Compra --->
												<td nowrap="nowrap" class="fileLabel">
													<cfif rs_CRTipoC.recordcount gt 0>
														<select name="CRTCid#rs_info.CRDRid#" tabindex="1" style="width:100px">
															<cfloop query="rs_CRTipoC">
																<option value="#rs_CRTipoC.CRTCid#"  
																	<cfif modo EQ 'cambio' and rs_CRTipoC.CRTCid EQ rs_info.CRTCid> 
																		selected="selected"
																	</cfif>>
																#rs_CRTipoC.CRTCcodigo#-#rs_CRTipoC.CRTCdescripcion#
																</option>
															</cfloop>
														</select>
													<cfelse>
														<input name="CRTCid#rs_info.CRDRid#"  value="-1" tabindex="-1" type="hidden">
											  		</cfif>
												</td>
												<!--- Monto --->
												<td style="font-size: 9px !important;">
													#NumberFormat(rs_info.Monto,',_.__')#
												</td>
											</tr>
											<cfset nume+=1>
									</cfloop>
								</cfif>
								<tr>
									<td  colspan="14" align="center">
										<cfloop index="i" from="1" to="#rs_infoT.reg#" >
											<input type="button" id="pag#i#" value="#i#" onclick="funcPag(#i#,'#form.CRDRdocori#');" <cfif page EQ #i#>style="background-color: ##3087a3; color: ##FFF;" </cfif>>
										</cfloop>
									</td>
								</tr>
								<tr><td colspan="14">&nbsp;</td></tr>
	</table>		
</cfoutput>		
	<!--- Definición de botones --->
		<cfset include = "">
		<cfset includeVal ="">
		<cfset exclude = "Nuevo">		
		<cfif modo EQ 'cambio'>
			<!--- <cfset include = ListAppend(include,'Regresar')>
			<cfset includeVal = ListAppend(includeVal,BTN_Regresar)> --->
				<cfset include = ListAppend(include,'Aplicar')>
				<cfset includeVal = ListAppend(includeVal,BTN_Aplicar)>
			
		<cfelse>
			<cfset exclude = ListAppend(exclude,'Baja')>			
		</cfif>

		<cfif modo EQ 'cambio'>
		<cf_botones modo="#modo#" include="#include#" exclude="#exclude#" includevalues="#includeVal#" tabindex="1">
		</cfif>
</form>

<script>
	function funcPag(i,doc){
		$('#form1').attr('action', 'documentoDet.cfm?pag='+i+'&CRDRdocori='+doc);
 		$("#form1").submit();
	}
</script>

<cf_qforms form = 'form1'>

<script language="javascript" type="text/javascript">
   objForm.IDdocumento.required=true;
   objForm.IDdocumento.description='Documento';
</script>