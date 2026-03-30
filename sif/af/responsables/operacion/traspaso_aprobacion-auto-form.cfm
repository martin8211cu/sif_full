<cfif isdefined("url.o") and len(trim(url.o))>
	<cfparam name="form.o" default="#url.o#">
</cfif>
<cfparam name="form.o" default="1">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfset LvarEspacio = "char(32)">
<cf_dbfunction name="now" returnvariable="hoy">
	<cf_tabs width="100%">
		<!--- Variables de Traduccion --->		
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="TAB_DocumentosTransferidos" Default="Documentos Transferidos" returnvariable="TAB_DocumentosTransferidos"/>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Placa" 					Default="Placa" 				  returnvariable="LB_Placa"/>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" 			Default="Descripción" 			  returnvariable="LB_Descripcion"/>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha"   				Default="Fecha" 				  returnvariable="LB_Fecha"/>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estado"   				Default="Estado" 				  returnvariable="LB_Estado"/>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ResponsableOrigen"   	Default="Responsable Origen"      returnvariable="LB_ResponsableOrigen"/>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ResponsableDestino"   	Default="Responsable Destino" 	  returnvariable="LB_ResponsableDestino"/>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Aprobar" 				Default="Aprobar"				  returnvariable="BTN_Aprobar"/>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Rechazar" 				Default="Rechazar" returnvariable="BTN_Rechazar"/>

		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Documentos" 			Default="Documento(s)" returnvariable="MSG_Documentos"/>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RequiereDeSuAprobacion" 	Default="Requiere de su Aprobación" returnvariable="LB_RequiereDeSuAprobacion"/>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Rechazado" 				Default="Rechazado" returnvariable="LB_Rechazado"/>

		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_" 						Default="" returnvariable="LB_"/>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RequiereDeLaAprobacionDe" Default="Requiere de la Aprobación de" returnvariable="LB_RequiereDeLaAprobacionDe"/>
					<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RequiereAprobacionDelEncargadoDelCentrofuncional" Default="Requiere aprobación del<br> encargado del centro funcional" returnvariable="LB_RequiereAprobacionDelEncargadoDelCentrofuncional"/>
			
		<!--- Verifica mediante el parametro de la aplicación si se sigue la jerarquía
		de jefes de centros funcionales, o se hace la aprobación por medio del encargado
		del centro de custodia --->	
		<cfquery name="rsTipoAprobacion" datasource="#session.dsn#">
			select Pvalor as TAprob
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 990
				and Mcodigo = 'AF'
		</cfquery>			
		<cfif rsTipoAprobacion.recordcount eq 0>
			<cfset TAprob = 0>
		<cfelse>
			<cfset TAprob = rsTipoAprobacion.TAprob>
		</cfif>
		
		<cfif isdefined("TAprob") and TAprob eq 0>
			<!--- Modalidad por Jefes --->
		
			<cf_tab text="#TAB_DocumentosTransferidos#" selected="#o eq 1#" id="1">	
				<cfif o eq 1>
					<form action="traspaso_aprobacion-auto-sql.cfm" method="post" name="lista" style="margin:0px">
						<cfparam name="url.PageNum_Lista" default="1">
						<input type="hidden" name="PageNum_Lista" value="<cfoutput>#url.PageNum_Lista#</cfoutput>" />
						<input type="hidden" name="o" value="1" />
						<input type="checkbox" name="chk" value="" style="visibility:hidden" /><!--- Para que el objeto exista cuando no hay items y no de error en el api de qforms --->
						<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
							debug="N"
							tabla="AFTResponsables aftr
											inner join AFResponsables afr
												inner join Activos act
													on act.Ecodigo = afr.Ecodigo
													and act.Aid = afr.Aid
												on afr.AFRid = aftr.AFRid
												and #hoy#
												between afr.AFRfini and afr.AFRffin
											
											inner join CFuncional cf1 
												on cf1.CFid = aftr.AFTRCFid1
											"
							columnas="aftr.AFTRid, act.Aplaca,	afr.AFRid, coalesce(afr.CRDRdescdetallada, afr.CRDRdescripcion, act.Adescripcion) as Descripcion, afr.AFRfini, 
											case when aftr.AFTRestado = 20 then '#LB_Rechazado#' 
											else 
												case when aftr.AFTRaprobado1 = 0 then '#LB_RequiereDeSuAprobacion#'													
												when aftr.AFTRaprobado2 = 0 then '#LB_RequiereAprobacionDelEncargadoDelCentrofuncional#<br> ' #_Cat# 
													(select cf.CFcodigo #_Cat# '-' #_Cat# cf.CFdescripcion 
                                                          from CFuncional cf 
                                                       where cf.CFid = aftr.AFTRCFid2)
												else '#LB_RequiereDeLaAprobacionDe# <br>' #_Cat# 
															(select de.DEidentificacion #_Cat# '-' #_Cat# de.DEnombre #_Cat# de.DEapellido1
															  from DatosEmpleado de
															where de.DEid = aftr.DEid)
												end
											end as Estado,
											(	select (de.DEnombre #_Cat# #LvarEspacio# #_Cat# de.DEapellido1)
												from DatosEmpleado de  
													where de.DEid = afr.DEid 
													and Ecodigo = #session.Ecodigo#
											) as ResponsableOrigen,
											(	select (de.DEnombre #_Cat# #LvarEspacio# #_Cat# de.DEapellido1)
												from DatosEmpleado de  
													where de.DEid = aftr.DEid 
													      and Ecodigo = #session.Ecodigo#
											) as ResponsableDestino,
											case 
												when 
													aftr.AFTRestado = 10 
													and aftr.AFTRaprobado1 = 0 then -1
												else AFTRid
											end as lr
											"
							linearoja="lr EQ AFTRid"
							inactivecol="lr"
							filtro="( cf1.CFuresponsable = #session.Usucodigo#
											or exists (select 1 
															from LineaTiempo 
															where DEid = #Form.DEid# 
															and RHPid = cf1.RHPid 
															and #hoy# 
															between LTdesde and LThasta)
											or exists (select 1 
															from EmpleadoCFuncional 
															where CFid = aftr.AFTRCFid1
															and DEid = #Form.DEid# 
															and ECFencargado= 1 
															and #hoy#
															between ECFdesde and ECFhasta))
											and aftr.AFTRestado in (10,20)
											order by act.Aplaca"
							desplegar="Aplaca,
											Descripcion,
											AFRfini,
											ResponsableOrigen,
											ResponsableDestino,
											Estado"
							filtrar_por_array="#ListToArray('act.Aplaca| coalesce(afr.CRDRdescdetallada, afr.CRDRdescripcion, act.Adescripcion)| afr.AFRfini|(select (de.DEnombre #_Cat# #LvarEspacio# #_Cat# de.DEapellido1) from DatosEmpleado de  where de.DEid = afr.DEid and Ecodigo = #session.Ecodigo#)|(select (de.DEnombre #_Cat# #LvarEspacio# #_Cat# de.DEapellido1) from DatosEmpleado de  where de.DEid = aftr.DEid and Ecodigo = #session.Ecodigo#)| ','|')#"
							etiquetas="#LB_Placa#, #LB_Descripcion#, #LB_Fecha#, #LB_ResponsableOrigen#,#LB_ResponsableDestino#,#LB_Estado#"
							formatos="S,S,D,S,S,U"
							align="left,left,center,left,left,left"
							ajustar="N"
							showLink="false"
							checkboxes="S"
							keys="AFTRid"
							incluyeForm="false"
							formname="lista"
							showEmptyListMsg="true"
							mostrar_filtro="true"
							filtrar_automatico="true"
							maxrows="8"
							maxrowsquery="100"
						/>
						<cf_botones values="#BTN_Aprobar#, #BTN_Rechazar#" names="Aprobar1, Rechazar1" form="lista" tabindex="1">
					</form>
					<cf_qforms form="lista" objForm="olista">
						<cf_qformsrequiredfield name="chk" description="#MSG_Documentos#"/>
					</cf_qforms>
				</cfif>
			</cf_tab>
			<!--- Variable de Traduccion --->
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="TAB_DocumentosPorRecibir"
				Default="Documentos Por Recibir"
				returnvariable="TAB_DocumentosPorRecibir"/>
			<cf_tab text="#TAB_DocumentosPorRecibir#" selected="#o eq 2#" id="2">
				<cfif o eq 2>
					<form action="traspaso_aprobacion-auto-sql.cfm" method="post" name="lista" style="margin:0px">
						<cfparam name="url.PageNum_Lista" default="1">
						<input type="hidden" name="PageNum_Lista" value="<cfoutput>#url.PageNum_Lista#</cfoutput>" />
						<input type="hidden" name="o" value="2" />
						<input type="checkbox" name="chk" value="" style="visibility:hidden" /><!--- Para que el objeto exista cuando no hay items y no de error en el api de qforms --->
						<cfinvoke 
							component="sif.Componentes.pListas"
							method="pLista"
							returnvariable="pListaRet"
							debug="N"
							tabla="AFTResponsables aftr
											inner join AFResponsables afr
												inner join Activos act
													on act.Ecodigo = afr.Ecodigo
													and act.Aid = afr.Aid
												on afr.AFRid = aftr.AFRid
												and #hoy#
												between afr.AFRfini and afr.AFRffin
											
											inner join CFuncional cf2 
												on cf2.CFid = aftr.AFTRCFid2
											"
							columnas="aftr.AFTRid, act.Aplaca,	afr.AFRid, coalesce(afr.CRDRdescdetallada, afr.CRDRdescripcion, act.Adescripcion) as Descripcion, afr.AFRfini, 
											case 
											when aftr.AFTRestado = 20
											then '#LB_Rechazado#' 
											else 
												case 
												when aftr.AFTRaprobado1 = 0 
												then '#LB_RequiereAprobacionDelEncargadoDelCentrofuncional#<br> ' #_Cat# 
															(select cf.CFcodigo #_Cat# '-' #_Cat# cf.CFdescripcion)}
															  from CFuncional cf
															where cf.CFid = aftr.AFTRCFid1)
												when aftr.AFTRaprobado2 = 0 
												then '#LB_RequiereDeSuAprobacion#'
												else '#LB_RequiereDeLaAprobacionDe# <br>' #_Cat#
															(select de.DEidentificacion #_Cat# '-' #_Cat# de.DEnombre #_Cat# de.DEapellido1
															  from DatosEmpleado de
															 where de.DEid = aftr.DEid)
												end
											end as Estado,
											case 
												when 
													aftr.AFTRestado = 10 
													and aftr.AFTRaprobado1 = 1
													and aftr.AFTRaprobado2 = 0 then -1
												else AFTRid
											end as lr
											"
							linearoja="lr EQ AFTRid"
							inactivecol="lr"
							filtro="( cf2.CFuresponsable = #session.Usucodigo#
											or exists (select 1 
															from LineaTiempo 
															where DEid = #Form.DEid# 
															and RHPid = cf2.RHPid 
															and #hoy#
															between LTdesde and LThasta)
											or exists (select 1 
															from EmpleadoCFuncional 
															where CFid = aftr.AFTRCFid2
															and DEid = #Form.DEid# 
															and ECFencargado= 1 
															and #hoy#
															between ECFdesde and ECFhasta))
											and aftr.AFTRestado in (10,20)
											order by act.Aplaca"
							desplegar="Aplaca,
											Descripcion,
											AFRfini,
											Estado"
							filtrar_por_array="#ListToArray('act.Aplaca| coalesce(afr.CRDRdescdetallada, afr.CRDRdescripcion, act.Adescripcion)| afr.AFRfini| ','|')#"
							etiquetas="#LB_Placa#, #LB_Descripcion#, #LB_Fecha#, #LB_Estado#"
							formatos="S,S,D,U"
							align="left,left,center,left"
							ajustar="N"
							showLink="false"
							checkboxes="S"
							keys="AFTRid"
							incluyeForm="false"
							formname="lista"
							showEmptyListMsg="true"
							mostrar_filtro="true"
							filtrar_automatico="true"
							maxrows="8"
							maxrowsquery="100"
						/>
						<cf_botones values="#BTN_Aprobar#,#BTN_Rechazar#" names="Aprobar2, Rechazar2" form="lista" tabindex="1">
					</form>
					<cf_qforms form="lista" objForm="olista">
						<cf_qformsrequiredfield name="chk" description="#MSG_Documentos#"/>
					</cf_qforms>
				</cfif>
			</cf_tab>
	
		<cfelse>
		
			<!--- Modalidad de Autorizacion según centros de custodia --->

			<!--- 
			1. Se verifica a cuales centros de custodia está asociado el centro funcional 
			2. Se listan los vales que se esten trasladando que pertencen a esos centros de custodia
			--->

			<cf_tab text="#TAB_DocumentosTransferidos#" selected="#o eq 1#" id="1">
				<cfif o eq 1>
					<form action="traspaso_aprobacion-auto-sql.cfm" method="post" name="lista" style="margin:0px">
						<cfparam name="url.PageNum_Lista" default="1">
						<input type="hidden" name="PageNum_Lista" value="<cfoutput>#url.PageNum_Lista#</cfoutput>" />
						<input type="hidden" name="o" value="1" />
						<input type="checkbox" name="chk" value="" style="visibility:hidden" /><!--- Para que el objeto exista cuando no hay items y no de error en el api de qforms --->
						<cfinvoke 
							component="sif.Componentes.pListas"
							method="pLista"
							returnvariable="pListaRet"
							debug="N"
							tabla="AFTResponsables aftr
											inner join AFResponsables afr
												inner join Activos act
													on act.Ecodigo = afr.Ecodigo
													and act.Aid = afr.Aid
												on afr.AFRid = aftr.AFRid
												and #hoy# between afr.AFRfini and afr.AFRffin
											
											inner join CFuncional cf1 
												on cf1.CFid = aftr.AFTRCFid1
											"
							columnas="aftr.AFTRid, act.Aplaca,	afr.AFRid, coalesce(afr.CRDRdescdetallada, afr.CRDRdescripcion, act.Adescripcion) as Descripcion, afr.AFRfini, 
											case 
											when aftr.AFTRestado = 20
											then '#LB_Rechazado#' 
											else 
												case 
												when aftr.AFTRaprobado2 = 0 then 
													'#LB_RequiereDeSuAprobacion#'													
												else 
													'#LB_RequiereDeLaAprobacionDe# <br>' #_Cat# 
															(select de.DEidentificacion #_Cat# '-' #_Cat# de.DEnombre #_Cat# de.DEapellido1
															  from DatosEmpleado de
															where de.DEid = aftr.DEid)
												end
											end as Estado, 
											(	select (de.DEnombre #_Cat# #LvarEspacio# #_Cat# de.DEapellido1)
												from DatosEmpleado de  
													where de.DEid = afr.DEid 
													and Ecodigo = #session.Ecodigo#
											) as ResponsableOrigen,
											(	select (de.DEnombre #_Cat# #LvarEspacio# #_Cat# de.DEapellido1)
												from DatosEmpleado de  
													where de.DEid = aftr.DEid 
													      and Ecodigo = #session.Ecodigo#
											) as ResponsableDestino,
											case 
												when 
													aftr.AFTRestado = 10 
													and aftr.AFTRaprobado2 = 0 then -1
												else AFTRid
											end as lr
											"
							linearoja="lr EQ AFTRid"
							inactivecol="lr"
							filtro=" exists (Select 1
											  from CRCentroCustodia a
													inner join DatosEmpleado b
														on a.DEid = b.DEid
														and a.Ecodigo = b.Ecodigo
											  where a.Ecodigo = #session.ecodigo#
											    and a.CRCCid = aftr.CRCCid
											    and b.DEid = #Form.DEid#)
									 and aftr.AFTRestado in (10,20)
											order by act.Aplaca"
							desplegar="Aplaca,
											Descripcion,
											AFRfini,
											ResponsableOrigen,
											ResponsableDestino,
											Estado"
							filtrar_por_array="#ListToArray('act.Aplaca| coalesce(afr.CRDRdescdetallada, afr.CRDRdescripcion, act.Adescripcion)| afr.AFRfini|(select (de.DEnombre #_Cat# #LvarEspacio# #_Cat# de.DEapellido1) from DatosEmpleado de  where de.DEid = afr.DEid and Ecodigo = #session.Ecodigo#)|(select (de.DEnombre #_Cat# #LvarEspacio# #_Cat# de.DEapellido1) from DatosEmpleado de  where de.DEid = aftr.DEid and Ecodigo = #session.Ecodigo#)| ','|')#"
							etiquetas="#LB_Placa#, #LB_Descripcion#, #LB_Fecha#, #LB_ResponsableOrigen#,#LB_ResponsableDestino#,#LB_Estado#"
							formatos="S,S,D,S,S,U"
							align="left,left,center,left,left,left"
							ajustar="N"
							showLink="false"
							checkboxes="S"
							keys="AFTRid"
							incluyeForm="false"
							formname="lista"
							showEmptyListMsg="true"
							mostrar_filtro="true"
							filtrar_automatico="true"
							maxrows="8"
							maxrowsquery="100"
						/>
						
						<cf_botones values="#BTN_Aprobar#, #BTN_Rechazar#" names="Aprobar2, Rechazar2" form="lista" tabindex="1">
					</form>
					<cf_qforms form="lista" objForm="olista">
						<cf_qformsrequiredfield name="chk" description="#MSG_Documentos#"/>
					</cf_qforms>
				</cfif>			
			</cf_tab>
			
		</cfif>

	</cf_tabs>
	
<!--- Variables de Traduccion --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ConfirmeQueDesea"
	Default="Confirme que desea"
	returnvariable="MSG_ConfirmeQueDesea"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_LosDocumentosMarcados"
	Default="los documentos marcados"
	returnvariable="MSG_LosDocumentosMarcados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_AprobarLaTransferencia"
	Default="Aprobar la Transferencia"
	returnvariable="MSG_AprobarLaTransferencia"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_AprobarLaRecepcion"
	Default="Aprobar la Recepción"
	returnvariable="MSG_AprobarLaRecepcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_RechazarLaTransferencia"
	Default="Rechazar la Transferencia"
	returnvariable="MSG_RechazarLaTransferencia"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_RechazarLaRecepcion"
	Default="Rechazar la Recepción"
	returnvariable="MSG_RechazarLaRecepcion"/>

<script language="javascript" type="text/javascript">
	function funcFiltrar() {
		deshabilitarValidacion();
		return true;
	}
	function tab_set_current (n) {
		location.href='traspaso_aprobacion-auto.cfm?o='+escape(n);
	}
	function confirmar(msg) {
		return olista.validate() && confirm('<cfoutput>#MSG_ConfirmeQueDesea#</cfoutput> ' + msg + ' <cfoutput>#MSG_LosDocumentosMarcados#</cfoutput>.');
	}
	function funcAprobar1() {
		return confirmar('<cfoutput>#MSG_AprobarLaTransferencia#</cfoutput>');
	}
	function funcAprobar2() {
		return confirmar('<cfoutput>#MSG_AprobarLaRecepcion#</cfoutput>');
	}
	function funcRechazar1() {
		return confirmar('<cfoutput>#MSG_RechazarLaTransferencia#</cfoutput>');
	}
	function funcRechazar2() {
		return confirmar('<cfoutput>#MSG_RechazarLaRecepcion#</cfoutput>');
	}
</script>
