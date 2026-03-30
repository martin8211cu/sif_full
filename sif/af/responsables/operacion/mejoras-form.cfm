<cfif isdefined('form.CRDRid') and len(trim(form.CRDRid)) and not isdefined('btnNuevo')>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>
<cf_dbfunction name="now" returnvariable="hoy">
<cfif modo neq "ALTA">
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 	a.CRDRid, 
				a.CRTDid, 
				a.CRTCid, 
				a.DEid, 
				a.CFid, 
				a.CRDRdescripcion, 
				a.CRDRfdocumento, 
				a.CRCCid, 
				a.CRDRplaca,
				a.CRDRdescdetallada,
				a.CRDRtipodocori,
				a.CRDRdocori, 
				a.ts_rversion,
				a.Ecodigo,
				a.AFMid,
				a.AFMMid,
				a.CRDRserie,
				a.ACid,
				a.ACcodigo,
				a.AFCcodigo,
				a.AFCMid,
				a.AFCMejora,
                d.DEidentificacion, 
				<cf_dbfunction name="concat" args="d.DEapellido1 ,' ',d.DEapellido2 ,' ' ,d.DEnombre"> as DEnombrecompleto,
				e.CFcodigo,   
				e.CFdescripcion,
				f.CRCCcodigo, 
				f.CRCCdescripcion,
				afr.AFRid, 
				act.Aplaca, 
				act.Adescripcion,
				afr.CRDRdescdetallada as CRDRdescdetallada2, 
				afr.CRTCid as CRDRtipodocori2,
				afr.CRDRdocori as CRDRdocori2,
				afr.AFRfini as CRDRfdocumento2,
				g.AFMid,
				g.AFMcodigo,
				g.AFMdescripcion,
				h.AFMMid,
				h.AFMMcodigo,
				h.AFMMdescripcion,
				act.AFMid as MarcaAct,
				act.AFMMid as ModeloAct,
				act.Aserie as SerieAct

		from CRDocumentoResponsabilidad a 
			inner join AFResponsables afr
				on afr.AFRid = a.AFRid
			inner join Activos act
				 on act.Aid = afr.Aid
			left outer join DatosEmpleado d 
				on d.DEid = a.DEid
			left join CFuncional e
				on e.CFid = a.CFid
			left outer join CRCentroCustodia f 
				on f.CRCCid = a.CRCCid
			left outer join AFMarcas g 
				on g.AFMid = a.AFMid
			left outer join AFMModelos h
				on h.AFMMid	= a.AFMMid																							
		where a.CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRDRid#">	
	</cfquery>

	<cfif isdefined('rsForm.CRTDid') and len(trim(rsForm.CRTDid))>
		<cfquery name="rsTipoDocumento" datasource="#session.dsn#">
			select
				b.CRTDcodigo, b.CRTDdescripcion
			from CRTipoDocumento b
			where b.CRTDid = #rsForm.CRTDid#
		</cfquery>
	</cfif>

	<cfif isdefined('rsForm.CRTCid') and len(trim(rsForm.CRTCid))>
		<cfquery name="rsTipoCompra" datasource="#session.dsn#">
			select 
				c.CRTCcodigo, c.CRTCdescripcion
			from CRTipoCompra c 
			where c.CRTCid = #rsForm.CRTCid#
		</cfquery>
	</cfif>

	<cfif isdefined('rsForm.CRDRtipodocori2') and len(trim(rsForm.CRDRtipodocori2))>
		<cfquery name="rsTipoCompraAnt" datasource="#session.dsn#">
			select 
				<cf_dbfunction name="concat" args="rtrim(c.CRTCcodigo),' - ' ,c.CRTCdescripcion" > as CRDRtipodocori2
			from CRTipoCompra c 
			where c.CRTCid = #rsForm.CRDRtipodocori2#
		</cfquery>
	<cfelse>
		<cfquery name="rsTipoCompraAnt" datasource="#session.dsn#">
			select 
				<cf_dbfunction name="concat" args="rtrim(c.CRTCcodigo),' - ' ,c.CRTCdescripcion" > as CRDRtipodocori2
			from CRTipoCompra c 
			where c.CRTCid = #rsForm.CRTCid#
		</cfquery>
	</cfif>
	
	<cfif isdefined('rsForm.ACcodigo') and len(trim(rsForm.ACcodigo))>
		<cfquery name="rsCategoria" datasource="#session.dsn#">
			select 
				g.ACcodigodesc, g.ACdescripcion, g.ACmascara
			from ACategoria g 
			where g.Ecodigo  = #rsForm.Ecodigo#
			  and g.ACcodigo = #rsForm.ACcodigo#
		</cfquery>
	</cfif>
	
	<cfif isdefined('rsForm.ACid') and len(trim(rsForm.ACid))>
		<cfquery name="rsClasificacion" datasource="#session.dsn#">
			select
				h.ACcodigodesc as Cat_ACcodigodesc, h.ACdescripcion as Cat_ACdescripcion
			from AClasificacion h 
			where h.Ecodigo  = #rsForm.Ecodigo#
			  and h.ACcodigo = #rsForm.ACcodigo#
			  and h.ACid     = #rsForm.ACid#
		</cfquery>
	</cfif>
	
	<cfif isdefined('rsForm.AFCcodigo') and len(trim(rsForm.AFCcodigo))>
		<cfquery name="rsClasificaciones" datasource="#session.dsn#">
			select
				i.AFCcodigoclas, i.AFCdescripcion
			from AFClasificaciones i 
			where i.Ecodigo   = #rsForm.Ecodigo#
			  and i.AFCcodigo = #rsForm.AFCcodigo#
		</cfquery>
	</cfif>

	<cfif isdefined('rsForm.MarcaAct') and len(trim(rsForm.MarcaAct))>
		<cfquery name="rsMarca" datasource="#session.dsn#">
			select
				j.AFMcodigo, j.AFMdescripcion
			from AFMarcas j 
			where j.AFMid = #rsForm.MarcaAct#
		</cfquery>
	</cfif>

	<cfif isdefined('rsForm.ModeloAct') and len(trim(rsForm.ModeloAct))>
		<cfquery name="rsModelo" datasource="#session.dsn#">
			select
				k.AFMMcodigo, k.AFMMdescripcion
			from AFMModelos k 
			where k.AFMMid = #rsForm.ModeloAct#
		</cfquery>
	</cfif>    
</cfif>
<cfquery datasource="#session.dsn#" name="rsConceptoMejora">
    select  AFCMid, AFCMcodigo, AFCMdescripcion
    from AFConceptoMejoras 
    where Ecodigo = #session.Ecodigo#
</cfquery>
<cfoutput>
	<form action="mejoras-sql.cfm" name="form1" method="post" style="margin:0">
		<input type="hidden" value="o" name="o" id="o" />
		
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class="tituloIndicacion"   align="center">Documento de Mejora</td>
		  </tr>
	  </table>
		<table width="500" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td  colspan="5"  nowrap="NOWRAP" class="tituloSub">
					<div id="div_CF" style="display:;">
						<fieldset>
							<legend>Documento</legend>
							<table width="100%"  border="0" cellspacing="0" cellpadding="2">
								<tr>
									<td width="15%" nowrap="NOWRAP" class="fileLabel" >Placa:&nbsp; </td>
									<td colspan="4">
										<cfset ts = "">
										<cfif (modo neq "ALTA")>
											<input type="hidden" tabindex="-1" name="CRDRid" id="CRDRid" value="#rsForm.CRDRid#">
											<cfinvoke component="sif.Componentes.DButils" 
												method="toTimeStamp" 
												returnvariable="ts" 
												artimestamp="#rsForm.ts_rversion#"/>
											<input type="hidden" tabindex="-1" name="ts_rversion" id="ts_rversion" value="#ts#">
											<input type="hidden" tabindex="-1" name="AFRid" id="AFRid" value="#rsForm.AFRid#">
											#rsForm.Aplaca# - #rsForm.Adescripcion#
										<cfelse>
										<cf_dbfunction name="concat" args="d.DEapellido1 +' ' + d.DEapellido2 +' ' + d.DEnombre"  returnvariable="Nombre" delimiters= "+">
										<cf_dbfunction name="concat" args="rtrim(tc.CRTCcodigo)+' - '+ tc.CRTCdescripcion "  returnvariable="CRDRtipodocori2" delimiters= "+">
										<cf_dbfunction name="to_sdateDMY" args="afr.AFRfini" returnvariable="AFRfini">
										<cf_conlis
											Campos="AFRid, Aplaca,Adescripcion"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											tabindex="1"
											Title="Placas"
											Tabla="CRCCUsuarios x
													inner join 	AFResponsables afr
														on afr.CRCCid = x.CRCCid 
													inner join Activos act
														on act.Aid = afr.Aid
													left outer join CRTipoCompra tc
														on tc.CRTCid = afr.CRTCid
													left outer join CRTipoDocumento b 
														on b.CRTDid = afr.CRTDid
													left outer join DatosEmpleado d 
														on d.DEid = afr.DEid
													left outer join CFuncional e
														on e.CFid = afr.CFid
													left outer join CRCentroCustodia f 
														on f.CRCCid = afr.CRCCid
													left outer join ACategoria g 
														on g.ACcodigo = act.ACcodigo
														and g.Ecodigo = act.Ecodigo
													left outer join AClasificacion h 
														on h.ACcodigo = act.ACcodigo
														and h.ACid = act.ACid
														and h.Ecodigo = act.Ecodigo
													left outer join AFClasificaciones i 
														on i.AFCcodigo = act.AFCcodigo
														and i.Ecodigo = act.Ecodigo
													left outer join AFMarcas j 
														on j.AFMid = act.AFMid
													left outer join AFMModelos k 
														on k.AFMMid = act.AFMMid"
											Columnas="afr.AFRid, act.Aplaca, act.Adescripcion, afr.CRDRdescripcion, afr.AFRfini
														,afr.CRDRdescdetallada, afr.CRDRtipodocori, afr.CRDRdocori, 
														act.Aplaca as CRDRplaca, afr.CRDRdescdetallada as CRDRdescdetallada2, 
														#PreserveSingleQuotes(AFRfini)# as CRDRfdocumento2, 
														tc.CRTCid, tc.CRTCcodigo, tc.CRTCdescripcion, 
														b.CRTDcodigo, b.CRTDdescripcion, 
														d.DEidentificacion, #PreserveSingleQuotes(Nombre)# as DEnombrecompleto, 
														e.CFcodigo, e.CFdescripcion,
														f.CRCCcodigo, f.CRCCdescripcion,
														g.ACcodigo,g.ACcodigodesc,g.ACdescripcion,g.ACmascara,
														h.ACid,h.ACcodigodesc as Cat_ACcodigodesc,h.ACdescripcion as Cat_ACdescripcion,
														i.AFCcodigo,i.AFCcodigoclas,i.AFCdescripcion,
														j.AFMid,j.AFMcodigo,j.AFMdescripcion,
														j.AFMid as AFMid1,j.AFMcodigo as AFMcodigo1,j.AFMdescripcion as AFMdescripcion1,
														k.AFMMid,k.AFMMcodigo,k.AFMMdescripcion,
														k.AFMMid as AFMMid1,k.AFMMcodigo as AFMMcodigo1,k.AFMMdescripcion as AFMMdescripcion1,
														afr.CRDRtipodocori as CRDRtipodocori3, 
														#PreserveSingleQuotes(CRDRtipodocori2)# as CRDRtipodocori2,
														afr.CRDRdocori as CRDRdocori2, act.Aserie as CRDRserie"
											Filtro="x.Usucodigo = #Session.Usucodigo# 
														and #hoy# between afr.AFRfini and afr.AFRffin 
														and not exists(	select 1
																		from CRDocumentoResponsabilidad z
																		where z.CRDRplaca = act.Aplaca
																			and z.Ecodigo = act.Ecodigo
																			and z.CRDRestado = 5 )
														and not exists(	Select 1 
																		from AFTResponsables aftr 
																		where aftr.AFRid = afr.AFRid )
												   		and not exists(	Select 1
																		from CRCRetiros crret
																		where act.Ecodigo = crret.Ecodigo
																   			and act.Aid = crret.Aid )														
														and act.Astatus = 0
													/*order by 1, 2*/"
											Desplegar="Aplaca,Adescripcion"
											Etiquetas="Placa,Activo"
											Formatos="S,S"
											Align="left,left"
											Asignar="AFRid, Aplaca, Adescripcion, CRDRdescdetallada, CRDRdocori, 
													CRTCid, CRTCcodigo, CRTCdescripcion, CRTDcodigo,CRTDdescripcion, 
													CRCCcodigo,CRCCdescripcion,  CFcodigo,CFdescripcion, DEidentificacion, 
													DEnombrecompleto,CRDRfdocumento2, ACcodigodesc,ACdescripcion, Cat_ACcodigodesc,
													Cat_ACdescripcion, CRDRplaca, CRDRdescripcion, CRDRdescdetallada2, AFMcodigo,
													AFMdescripcion, AFMMcodigo,AFMMdescripcion, AFCcodigoclas,AFCdescripcion,
													CRTDcodigo,CRTDdescripcion, CRDRtipodocori2,CRDRdocori2,AFMid1,
													AFMcodigo1,AFMdescripcion1,AFMMid1,AFMMcodigo1,AFMMdescripcion1,CRDRserie"
											Asignarformatos="I,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,D,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S"
											maxrows="20"
											maxrowsquery="200"
											showEmptyListMsg="true"
											EmptyListMsg="--- No se encontraron Documentos ---"
											/>
										</cfif>
								  </td>
								</tr>
								
								<tr>
									<td nowrap="nowrap" class="fileLabel">
											Descripci&oacute;n Detallada:&nbsp;
									</td>
									<td width="40%">
										<input type="text" tabindex="2" id="CRDRdescdetallada" name="CRDRdescdetallada" <cfif isdefined("rsForm.CRDRdescdetallada")>value="#rsForm.CRDRdescdetallada#"</cfif> size="60" maxlength="255">
									</td>
									
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel">Marca</td>
									<td ><cfset ValuesArray=ArrayNew(1)>
										<!--- <cfif (modo neq "ALTA") > --->
										<cfif  isdefined("rsForm")>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMid)>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMcodigo)>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMdescripcion)>
										</cfif>
										<cf_conlis
											Campos="AFMid1,AFMcodigo1,AFMdescripcion1"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											ValuesArray="#ValuesArray#"
											Title="Lista de Marcas"
											Tabla="AFMarcas"
											tabindex="3"
											Columnas="AFMid as AFMid1,AFMcodigo as AFMcodigo1,AFMdescripcion as AFMdescripcion1"
											Filtro="Ecodigo = #Session.Ecodigo# order by AFMcodigo,AFMdescripcion"
											Desplegar="AFMcodigo1,AFMdescripcion1"
											Etiquetas="C&oacute;digo,Descripci&oacute;n"
											filtrar_por="AFMcodigo,AFMdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="AFMid1,AFMcodigo1,AFMdescripcion1"
											Asignarformatos="I,S,S"
											funcion="resetModelo"/>
									</td>
								</tr>
								
								
								<tr>
									<td nowrap="nowrap" class="fileLabel">
											Tipo de Compra:&nbsp;
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<!--- <cfif (modo neq "ALTA") > --->
										<cfif  isdefined("rsForm.CRTCid") and len(trim(rsForm.CRTCid))>
											<cfset ArrayAppend(ValuesArray,rsForm.CRTCid)>
											<cfset ArrayAppend(ValuesArray,rsTipoCompra.CRTCcodigo)>
											<cfset ArrayAppend(ValuesArray,rsTipoCompra.CRTCdescripcion)>
										<cfelse>
											<cfset ArrayAppend(ValuesArray," ")>
											<cfset ArrayAppend(ValuesArray," ")>
											<cfset ArrayAppend(ValuesArray," ")>
										</cfif>
										<cf_conlis
											Campos="CRTCid,CRTCcodigo,CRTCdescripcion"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											tabindex="3"
											ValuesArray="#ValuesArray#"
											Title="Lista de Tipos de Compra"
											Tabla="CRTipoCompra"
											Columnas="CRTCid,CRTCcodigo,CRTCdescripcion"
											Filtro="Ecodigo = #Session.Ecodigo# order by CRTCcodigo,CRTCdescripcion"
											Desplegar="CRTCcodigo,CRTCdescripcion"
											Etiquetas="C&oacute;digo,Descripci&oacute;n"
											filtrar_por="CRTCcodigo,CRTCdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="CRTCid,CRTCcodigo,CRTCdescripcion"
											Asignarformatos="I,S,S"/>				
									
									</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel">Modelo</td>
									<td >
										<cfset ValuesArray=ArrayNew(1)>
										<cfif  isdefined("rsForm")>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMMid)>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMMcodigo)>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMMdescripcion)>
										</cfif>
										<cf_conlis
											Campos="AFMMid1,AFMMcodigo1,AFMMdescripcion1"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,35"
											ValuesArray="#ValuesArray#"
											Title="Lista de Modelos"
											Tabla="AFMModelos"
											tabindex="3"
											Columnas="AFMMid as AFMMid1,AFMMcodigo as AFMMcodigo1,AFMMdescripcion as AFMMdescripcion1"
											Filtro="Ecodigo = #Session.Ecodigo# and AFMid = $AFMid1,numeric$ order by AFMMcodigo,AFMMdescripcion"
											Desplegar="AFMMcodigo1,AFMMdescripcion1"
											Etiquetas="C&oacute;digo,Descripci&oacute;n"
											filtrar_por="AFMMcodigo,AFMMdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="AFMMid1,AFMMcodigo1,AFMMdescripcion1"
											Asignarformatos="I,S,S"/>
									</td>

								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel">
											Documento Origen:&nbsp;
									</td>
									<td >
										<input type="text" tabindex="4" id="CRDRdocori" name="CRDRdocori" <cfif isdefined("rsForm.CRDRdocori")>value="#rsForm.CRDRdocori#"</cfif> size="20" maxlength="20">
									</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
									<td nowrap="nowrap" class="fileLabel">Serie</td>
									<td >
										<input type="text" tabindex="5" id="CRDRserie" name="CRDRserie" <cfif isdefined("rsForm.CRDRserie")>value="#HTMLEditFormat(rsForm.CRDRserie)#"</cfif> size="60" maxlength="45" />
									</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel">
											Fecha Mejora:&nbsp;
									</td>
									<td >
										<cfif (modo neq "ALTA")>
											<cfset Fecha = rsForm.CRDRfdocumento>
										<cfelse>
											<cfset Fecha = Now()>
										</cfif>
										<cf_sifcalendario name="CRDRfdocumento" tabindex="5" value="#LSDateFormat(Fecha,'dd/mm/yyyy')#">
									</td>
									<td colspan="1" nowrap="nowrap" class="fileLabel">&nbsp;</td>
                                    
									<input type="hidden" name="AFCMejora" <cfif isdefined("rsForm.AFCMejora")>value="#rsForm.AFCMejora#"<cfelse>value="0"</cfif>/>
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
								</tr>
							</table>
						</fieldset>
					</div>
				</td>
			</tr>
			<tr>
				<td  colspan="5" nowrap="nowrap" class="fileLabel">&nbsp;</td>
			</tr>			
			<tr>
				<td  colspan="5"  nowrap="NOWRAP" class="tituloSub">
					<div id="div_CF" style="display:;">
						<fieldset>
							<legend>Informaci&oacute;n General</legend>
							<table width="100%"  border="0" cellspacing="0" cellpadding="2">
								<tr>
									<td class="fileLabel" nowrap="NOWRAP">
										
											Tipo de Documento:&nbsp;
					
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif (modo neq "ALTA")>
											<cfset ArrayAppend(ValuesArray,rsForm.CRTDid)>
											<cfif isdefined('rsTipoDocumento')>
												<cfset ArrayAppend(ValuesArray,rsTipoDocumento.CRTDcodigo)>
												<cfset ArrayAppend(ValuesArray,rsTipoDocumento.CRTDdescripcion)>
											<cfelse>
												<cfset ArrayAppend(ValuesArray," ")>
												<cfset ArrayAppend(ValuesArray," ")>
											</cfif>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="CRTDcodigo"  tabindex="-1" type="text" value="#ValuesArray[2]#" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="CRTDdescripcion" tabindex="-1" type="text" value="#ValuesArray[3]#" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										<cfelse>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="CRTDcodigo" type="text" tabindex="-1" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="CRTDdescripcion" type="text" tabindex="-1" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										</cfif>
									</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;
										
									</td>
									<td nowrap="nowrap" class="fileLabel">
											Centro de Custodia:&nbsp;
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif (modo neq "ALTA")>
											<cfset ArrayAppend(ValuesArray,rsForm.CRCCid)>
											<cfset ArrayAppend(ValuesArray,rsForm.CRCCcodigo)>
											<cfset ArrayAppend(ValuesArray,rsForm.CRCCdescripcion)>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="CRCCcodigo" tabindex="-1" type="text" value="#ValuesArray[2]#" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="CRCCdescripcion" tabindex="-1" type="text" value="#ValuesArray[3]#" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										<cfelse>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="CRCCcodigo" tabindex="-1" type="text" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="CRCCdescripcion" tabindex="-1" type="text" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										</cfif>
									</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel">
											Centro Funcional:&nbsp;
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif (modo neq "ALTA")>
											<cfset ArrayAppend(ValuesArray,rsForm.CFid)>
											<cfset ArrayAppend(ValuesArray,rsForm.CFcodigo)>
											<cfset ArrayAppend(ValuesArray,rsForm.CFdescripcion)>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="CFcodigo" tabindex="-1" type="text" value="#ValuesArray[2]#" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="CFdescripcion" tabindex="-1" type="text" value="#ValuesArray[3]#" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										<cfelse>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="CFcodigo" tabindex="-1" type="text" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="CFdescripcion" tabindex="-1" type="text" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										</cfif>
									</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;
										
									</td>
									<td nowrap="nowrap" class="fileLabel">
											Empleado:&nbsp;
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif (modo neq "ALTA")>
											<cfset ArrayAppend(ValuesArray,rsForm.DEid)>
											<cfset ArrayAppend(ValuesArray,rsForm.DEidentificacion)>
											<cfset ArrayAppend(ValuesArray,rsForm.DEnombrecompleto)>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="DEidentificacion" tabindex="-1" type="text" value="#ValuesArray[2]#" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="DEnombrecompleto" tabindex="-1" type="text" value="#ValuesArray[3]#" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										<cfelse>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="DEidentificacion" tabindex="-1" type="text" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="DEnombrecompleto" tabindex="-1" type="text" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										</cfif>
									</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel">
											Fecha:&nbsp;
									</td>
									<td colspan="4">
										<cfif (modo neq "ALTA")>
											<input name="CRDRfdocumento2" tabindex="-1" type="text" value="#LSDateFormat(rsForm.CRDRfdocumento2,'dd/mm/yyyy')#" size="20" class="cajasinbordeb" readonly/>
										<cfelse>
											<input name="CRDRfdocumento2" tabindex="-1" type="text" size="20" class="cajasinbordeb" readonly/>
										</cfif>
									</td>
								</tr>							
							</table>
						</fieldset>
					</div>
				</td>
			</tr>

			<tr>
				<td  colspan="5" nowrap="nowrap" class="fileLabel">&nbsp;</td>
			</tr>
			<tr>
				<td  colspan="5"  nowrap="NOWRAP" class="tituloSub">
					<div id="div_CF" style="display:;">
						<fieldset>
							<legend>Informaci&oacute;n del Activo </legend>
							<table width="100%"  border="0" cellspacing="0" cellpadding="2">
								<tr>
									<td nowrap="nowrap" class="fileLabel">
											Categor&iacute;a:&nbsp;
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif (modo neq "ALTA") and isdefined("rsForm.ACcodigo") and len(trim(rsForm.ACcodigo))>
											<cfset ArrayAppend(ValuesArray,rsForm.ACcodigo)>
											<cfset ArrayAppend(ValuesArray,rsCategoria.ACcodigodesc)>
											<cfset ArrayAppend(ValuesArray,rsCategoria.ACdescripcion)>
											<cfset ArrayAppend(ValuesArray,rsCategoria.ACmascara)>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="ACcodigodesc" tabindex="-1" type="text" value="#ValuesArray[2]#" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="ACdescripcion" tabindex="-1" type="text" value="#ValuesArray[3]#" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										<cfelse>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="ACcodigodesc" tabindex="-1" type="text" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="ACdescripcion" tabindex="-1" type="text" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										</cfif>
									</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;
										
									</td>
									<td nowrap="nowrap" class="fileLabel">
											Clase:&nbsp;
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif (modo neq "ALTA") and isdefined("rsForm.ACid") and len(trim(rsForm.ACid))>
											<cfset ArrayAppend(ValuesArray,rsForm.ACid)>
											<cfset ArrayAppend(ValuesArray,rsClasificacion.Cat_ACcodigodesc)>
											<cfset ArrayAppend(ValuesArray,rsClasificacion.Cat_ACdescripcion)>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="Cat_ACcodigodesc" tabindex="-1" type="text" value="#ValuesArray[2]#" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="Cat_ACdescripcion" tabindex="-1" type="text" value="#ValuesArray[3]#" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										<cfelse>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="Cat_ACcodigodesc" tabindex="-1" type="text" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="Cat_ACdescripcion" tabindex="-1" type="text" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										</cfif>
									</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel">
											Placa:&nbsp;
									</td>
									<td>
										<cfif (modo neq "ALTA")>
											<input name="CRDRplaca" tabindex="-1" type="text" value="#rsForm.CRDRplaca#" size="20" class="cajasinbordeb" readonly/>
										<cfelse>
											<input name="CRDRplaca" tabindex="-1" type="text" size="20" class="cajasinbordeb" readonly/>
										</cfif>
									</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;
										
									</td>
									<td nowrap="nowrap" class="fileLabel">
											Descripci&oacute;n:&nbsp;
									</td>
									<td>
										<cfif (modo neq "ALTA")>
											<input name="CRDRdescripcion" tabindex="-1" type="text" value="#rsForm.CRDRdescripcion#" size="60" class="cajasinbordeb" readonly/>
										<cfelse>
											<input name="CRDRdescripcion" tabindex="-1" type="text" size="60" class="cajasinbordeb" readonly/>
										</cfif>
									</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel">
											Marca:&nbsp;
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>

										<cfif (modo neq "ALTA") and isdefined("rsForm.AFMid") and len(trim(rsForm.AFMid))>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMid)>
											<cfset ArrayAppend(ValuesArray,rsMarca.AFMcodigo)>
											<cfset ArrayAppend(ValuesArray,rsMarca.AFMdescripcion)>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="AFMcodigo" tabindex="-1" type="text" value="#ValuesArray[2]#" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="AFMdescripcion" tabindex="-1" type="text" value="#ValuesArray[3]#" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										<cfelse>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="AFMcodigo" tabindex="-1" type="text" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="AFMdescripcion" tabindex="-1" type="text" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										</cfif>
									</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;
										
									</td>
									<td nowrap="nowrap" class="fileLabel">
											Modelo:&nbsp;
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif (modo neq "ALTA") and isdefined("rsForm.AFMMid") and len(trim(rsForm.AFMMid))>
											<cfset ArrayAppend(ValuesArray,rsForm.AFMMid)>
											<cfset ArrayAppend(ValuesArray,rsModelo.AFMMcodigo)>
											<cfset ArrayAppend(ValuesArray,rsModelo.AFMMdescripcion)>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="AFMMcodigo" tabindex="-1"  type="text" value="#ValuesArray[2]#" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="AFMMdescripcion" tabindex="-1" type="text" value="#ValuesArray[3]#" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										<cfelse>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="AFMMcodigo" tabindex="-1" type="text" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="AFMMdescripcion" tabindex="-1" type="text" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										</cfif>
									</td>
								</tr>
								<tr>
									<td nowrap="nowrap" class="fileLabel">
											Clasificaci&oacute;n:&nbsp;
									</td>
									<td>
										<cfset ValuesArray=ArrayNew(1)>
										<cfif (modo neq "ALTA") and isdefined("rsForm.AFCcodigo") and len(trim(rsForm.AFCcodigo))>
											<cfset ArrayAppend(ValuesArray,rsForm.AFCcodigo)>
											<cfset ArrayAppend(ValuesArray,rsClasificaciones.AFCcodigoclas)>
											<cfset ArrayAppend(ValuesArray,rsClasificaciones.AFCdescripcion)>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="AFCcodigoclas" tabindex="-1" type="text" value="#ValuesArray[2]#" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="AFCdescripcion" tabindex="-1" type="text" value="#ValuesArray[3]#" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										<cfelse>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td><input name="AFCcodigoclas" tabindex="-1" type="text" size="10" class="cajasinbordeb" readonly/></td>
												<td><input name="AFCdescripcion" tabindex="-1" type="text" size="40" class="cajasinbordeb" readonly/></td>
											  </tr>
											</table>
										</cfif>
									</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;
										
									</td>	
									<td nowrap="nowrap" class="fileLabel">
											Descripci&oacute;n Detallada:&nbsp;
									</td>
									<td>
										<cfif (modo neq "ALTA")>
											<input name="CRDRdescdetallada2" tabindex="-1" type="text" value="#rsForm.CRDRdescdetallada2#" size="60" class="cajasinbordeb" readonly/>
										<cfelse>
											<input name="CRDRdescdetallada2" tabindex="-1" type="text" size="60" class="cajasinbordeb" readonly/>
										</cfif>
									</td>
								</tr>
							</table>
						</fieldset>
					</div>				
				</td>				
			</tr>
			<tr>
				<td  colspan="5" nowrap="nowrap" class="fileLabel">&nbsp;</td>
			</tr>
			<tr>
				<td  colspan="5"  nowrap="NOWRAP" class="tituloSub">
					<div id="div_CF" style="display:;">
						<fieldset>
							<legend>Informaci&oacute;n del Origen</legend>
							<table width="100%"  border="0" cellspacing="0" cellpadding="2">
								<tr>
									<td nowrap="nowrap" class="fileLabel">
											Tipo de Compra:&nbsp;
									</td>
									<td nowrap="nowrap" class="fileLabel">
										<cfif (modo neq "ALTA")>
											<input name="CRDRtipodocori2" tabindex="-1" type="text" value="#rsTipoCompraAnt.CRDRtipodocori2#" size="20" class="cajasinbordeb" readonly/>
										<cfelse>
											<input name="CRDRtipodocori2" tabindex="-1" type="text" size="20" class="cajasinbordeb" readonly/>
										</cfif>
									</td>
									<td nowrap="nowrap" class="fileLabel">&nbsp;</td>				
									<td nowrap="nowrap" class="fileLabel">
											Documento Origen:&nbsp;
									</td>
									<td>
										<cfif (modo neq "ALTA")>
											<input name="CRDRdocori2" tabindex="-1" type="text" value="#rsForm.CRDRdocori2#" size="20" class="cajasinbordeb" readonly/>
										<cfelse>
											<input name="CRDRdocori2" tabindex="-1" type="text" size="20" class="cajasinbordeb" readonly/>
										</cfif>
									</td>
								</tr>
												
							</table>
						</fieldset>
					</div>				
				</td>
			</tr>
			<tr>
				<td  colspan="5" nowrap="nowrap" class="fileLabel">&nbsp;</td>
			</tr>
		</table>

		<cfset include = iif(modo neq "ALTA",DE(",Regresar,Aplicar"),DE(",Regresar"))>
		<cf_botones modo="#modo#" include="#include#" tabindex="6">
	</form>
</cfoutput>
<cf_qforms>
<script language="javascript" type="text/javascript">
	<!--// cÃ³digo javascript
		//validaciones utilizando API qforms
		objForm.o.description="o";
		objForm.AFRid.description="Documento";
		objForm.CRDRdescdetallada.description="Descripcion Detallada";		
		objForm.CRTCid.description="Tipo de Compra";
		objForm.CRDRdocori.description="Documento Origen";
		objForm.CRDRfdocumento.description="Fecha";
		objForm.AFMid1.description="Marca";
		objForm.AFMMid1.description="Modelo";
		requeridos = "AFRid,CRDRdescdetallada,CRTCid,CRDRdocori,CRDRfdocumento";
		// crea el objeto Mask	
		function habilitarValidacion(){
			deshabilitarValidacion();
			objForm.o.required=true;
			objForm.required(requeridos,true);
		}
		function deshabilitarValidacion(){
			objForm.o.required=false;
			objForm.required(requeridos,false);
		}
		<cfif (modo neq "ALTA")>
			function funcAplicar(){
				objForm.o.required=true;
				objForm.required(requeridos,true);
			}
			document.form1.CRDRdescdetallada.focus();
		<cfelse>
			document.form1.Aplaca.focus();
		</cfif>
	//-->
</script>
