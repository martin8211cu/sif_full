<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_ConfirmeQueDesea" 		Default="Confirme que desea" 	  returnvariable="MSG_ConfirmeQueDesea"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_LosDocumentosMarcados" 	Default="los documentos marcados" returnvariable="MSG_LosDocumentosMarcados"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Transferir" 			Default="Transferir" 			  returnvariable="MSG_Transferir"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Recibir" 				Default="Recibir" 				  returnvariable="MSG_Recibir"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Rechazar" 				Default="Rechazar" 				  returnvariable="MSG_Rechazar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="TAB_DocumentosAsignados"    Default="Documentos Asignados" 	  returnvariable="TAB_DocumentosAsignados"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="TAB_DocumentosPorRecibir"   Default="Documentos Por Recibir"  returnvariable="TAB_DocumentosPorRecibir"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Placa" 					Default="Placa" 				  returnvariable="LB_Placa"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" 			Default="Descripci&oacute;n"      returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" 					Default="Fecha" 				  returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estado" 					Default="Estado" 			 	  returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Rechazado" 				Default="Rechazado" 			  returnvariable="LB_Rechazado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Normal" 					Default="Normal" 				  returnvariable="LB_Normal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Recibir" 				Default="Recibir" 				  returnvariable="BTN_Recibir"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Rechazar" 				Default="Rechazar" 				  returnvariable="BTN_Rechazar"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Documentos" 			Default="Documento(s)" 			  returnvariable="MSG_Documentos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Empleado" 				Default="Empleado" 				  returnvariable="MSG_Empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Fecha" 					Default="Fecha" 				  returnvariable="MSG_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Transferir" 		    Default="Transferir" 			  returnvariable="BTN_Transferir"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Documentos" 			Default="Documento(s)" 			  returnvariable="MSG_Documentos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RequiereAprobacionDelEncargadoDelCentrodeCustodia" Default="Requiere aprobación del<br> encargado del centro de custodia" returnvariable="LB_RequiereAprobacionDelEncargadoDelCentrodeCustodia"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RequiereAprobacionDelEncargadoDelCentroFuncional"  Default="Requiere aprobación del<br> encargado del centro funcional" returnvariable="LB_RequiereAprobacionDelEncargadoDelCentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RequiereAprobacionDelEmpleado" Default="Requiere Aprobación del empleado" returnvariable="LB_RequiereAprobacionDelEmpleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RequiereDeSuAprobacion"        Default="Requiere de su Aprobación" returnvariable="LB_RequiereDeSuAprobacion"/>			

<cfif isdefined("url.o") and len(trim(url.o))>
	<cfparam name="form.o" default="#url.o#">
</cfif>
<cfparam name="form.o" default="1">
<cf_dbfunction name="now" returnvariable="hoy">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

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

<cfquery name="rsBoleta" datasource="#session.dsn#">
	select Pvalor as value 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		and Pcodigo = 3800
</cfquery>

<cf_tabs width="100%">
	<cf_tab text="#TAB_DocumentosAsignados#" selected="#o eq 1#" id="1">
	
	<cfif #rsBoleta.value# eq 1>
	<script language="javascript1.1" type="text/javascript">
		var popUpWinSN=0;
		function popUpWindow(URLStr, left, top, width, height){
			if(popUpWinSN) {
				if(!popUpWinSN.closed) popUpWinSN.close();
			}
			popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			window.onfocus = closePopUp;
		}
		
		function doConlis(DEid){
			<cfoutput>
			popUpWindow("/cfmx/sif/af/responsables/operacion/traspaso_resposable-auto-rpt.cfm?DEid=+#form.DEid#",150,150,800,500);
			</cfoutput>
		}
		
		function closePopUp(){
			if(popUpWinSN) {
				if(!popUpWinSN.closed) popUpWinSN.close();
				popUpWinSN=null;
			}
		}
	</script>

		<fieldset>
		<legend>Lista de Activos (<a href="##" onClick="javascript:doConlis();">Imprimir</a> <a href="##" onClick="javascript:doConlis();"><img src="/cfmx/sif/imagenes/impresora.gif" border="0"></a>)</legend>
	</cfif>
		<cfif o eq 1>
			<form action="traspaso_resposable-auto-sql.cfm" method="post" name="lista" style="margin:0px">
				<cfparam name="url.PageNum_Lista" default="1">
				<input type="hidden" name="PageNum_Lista" value="<cfoutput>#url.PageNum_Lista#</cfoutput>" />
				<input type="hidden" name="o" value="1" />
				<input type="hidden" name="eliminar" value="" />
				<input type="checkbox" name="chk" value="" style="visibility:hidden" /><!--- Para que el objeto exista cuando no hay items y no de error en el api de qforms --->
				
				<cf_dbfunction name="to_char" args="AFTRid" returnvariable="LvarAFTRid">
				<cf_dbfunction name="to_char" args="afr.Aid" returnvariable="LvarAid">

				<cfif isdefined("TAprob") and TAprob eq 0>
						<!--- JERARQUIA POR CENTROS FUNCIONALES --->					
                    <cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet" debug="N"
                        tabla="AFResponsables afr
                                        inner join Activos act
                                            on act.Ecodigo = afr.Ecodigo
                                            and act.Aid = afr.Aid"
                        
                        columnas="act.Aplaca,afr.AFRid,act.Adescripcion as Descripcion, afr.AFRfini,
                                        case 
                                        when not exists(select 1 from AFTResponsables aftr where aftr.AFRid = afr.AFRid) then '#LB_Normal#' 
                                        when not exists(select 1 from AFTResponsables aftr where aftr.AFRid = afr.AFRid and aftr.AFTRestado <> 20)then '#LB_Rechazado#' 
                                        else 
                                            case 
                                            when exists(select 1 from AFTResponsables aftr where aftr.AFRid = afr.AFRid and aftr.AFTRaprobado1 = 0) 
                                              then 
                                                    '#LB_RequiereAprobacionDelEncargadoDelCentroFuncional#<br> ' #_Cat# 
                                                        (select MAX(cf.CFcodigo #_Cat#  '-' #_Cat# cf.CFdescripcion) 
                                                          from AFTResponsables aftr
                                                            inner join CFuncional cf
                                                              on cf.CFid = aftr.AFTRCFid1
                                                        where aftr.AFRid = afr.AFRid
                                                        and aftr.AFTRaprobado1 = 0)
                                            when exists (select 1 from AFTResponsables aftr where aftr.AFRid = afr.AFRid and aftr.AFTRaprobado2 = 0 ) 
                                              then 
                                                    '#LB_RequiereAprobacionDelEncargadoDelCentroFuncional#<br> ' #_Cat# 
                                                        (select MAX(cf.CFcodigo #_Cat#  '-' #_Cat#  cf.CFdescripcion)
                                                          from AFTResponsables aftr
                                                            inner join CFuncional cf
                                                              on cf.CFid = aftr.AFTRCFid2
                                                         where aftr.AFRid = afr.AFRid
                                                           and aftr.AFTRaprobado2 = 0)
                                            else 
                                                    '#LB_RequiereAprobacionDelEmpleado#<br>' #_Cat# 
                                                    (select de.DEidentificacion #_Cat#  '-' #_Cat#  de.DEnombre #_Cat# ' ' #_Cat#  de.DEapellido1
                                                      from AFTResponsables aftr
                                                        inner join DatosEmpleado de
                                                            on de.DEid = aftr.DEid
                                                     where aftr.AFRid = afr.AFRid)
                                            end end as Estado,
                                        '<a href=''javascript: ver(' #_Cat# #LvarAid# #_Cat# ');''><img src=''/cfmx/sif/imagenes/find.small.png'' border=''0''></a>' as ver,
                                        case 
                                         when exists (select 1 from AFTResponsables aftr where aftr.AFRid = afr.AFRid) then AFRid
                                         else -1 end as lr,
                                        case 
                                         when exists ( select 1 from AFTResponsables aftr where aftr.AFRid = afr.AFRid and AFTRestado = 20) 
                                          then '<a href=''##'' onclick=''javascript:document.lista.eliminar.value=' #_Cat# 
                                                (select #LvarAFTRid#
                                                   from AFTResponsables aftr
                                                 where aftr.AFRid = afr.AFRid) #_Cat# 
                                                ';document.lista.submit();''><img src=''/cfmx/sif/imagenes/delete.small.png'' border=''0'' width=''16'' height=''16'' /></a>'
                                        else '' end as img"
                        linearoja="lr EQ AFRid"
                        inactivecol="lr"
                        filtro="afr.Ecodigo = #Session.Ecodigo#
                                        and afr.DEid = #Form.DEid#
                                        and #hoy#
                                        between afr.AFRfini and afr.AFRffin
                                        order by act.Aplaca"
                        desplegar="Aplaca,
                                        Descripcion,
                                        AFRfini,
                                        Estado,
                                        ver,
                                        img"
                        filtrar_por_array="#ListToArray('act.Aplaca| act.Adescripcion| afr.AFRfini| | | ','|')#"
                        etiquetas="#LB_Placa#, #LB_Descripcion#, #LB_Fecha#,#LB_Estado#,&nbsp;, "
                        formatos="S,S,D,U,U,U"
                        align="left,left,center,left,left,left"
                        ajustar="N"
                        showLink="false"
                        checkboxes="S"
                        keys="AFRid"
                        incluyeForm="false"
                        formname="lista"
                        showEmptyListMsg="true"
                        mostrar_filtro="true"
                        filtrar_automatico="true"
                        maxrows="75"
                        maxrowsquery="100"
                    />
					
					<cfelse>
						<!--- JERARQUIA POR CENTRO DE CUSTODIA --->
						<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet" debug="N"
							tabla="AFResponsables afr
											inner join Activos act
												on act.Ecodigo = afr.Ecodigo
												and act.Aid = afr.Aid"							
							columnas="act.Aplaca,	afr.AFRid, act.Adescripcion as Descripcion, afr.AFRfini,
											case 
											when not exists (
													select 1
													from AFTResponsables aftr
													where aftr.AFRid = afr.AFRid
											) then '#LB_Normal#' 
											when not exists (
													select 1
													from AFTResponsables aftr
													where aftr.AFRid = afr.AFRid
													and aftr.AFTRestado <> 20
											) then '#LB_Rechazado#' 
											else 
												case 
												when exists (
														select 1
														from AFTResponsables aftr
														where aftr.AFRid = afr.AFRid
														and aftr.AFTRaprobado2 = 0
												) then 
													'#LB_RequiereAprobacionDelEncargadoDelCentrodeCustodia#<br> ' #_Cat#  
														coalesce( (
																   select MAX(crcc.CRCCcodigo #_Cat#  '-' #_Cat# crcc.CRCCdescripcion)
                                                                    from AFTResponsables aftr
                                                                        inner join CRCentroCustodia crcc
                                                                            on crcc.CRCCid = aftr.CRCCid
                                                                            and crcc.Ecodigo = #session.ecodigo#
                                                                    where aftr.AFRid         = afr.AFRid
                                                                      and aftr.AFTRaprobado2 = 0
                                                                      and aftr.Usucodigo     = #Session.Usucodigo#),'')
												else 
													'#LB_RequiereAprobacionDelEmpleado#<br>' #_Cat# 
														(select max (de.DEidentificacion #_Cat#  '-' #_Cat# de.DEnombre #_Cat#  ' ' #_Cat#  de.DEapellido1)
														  from AFTResponsables aftr
															inner join DatosEmpleado de
																on de.DEid = aftr.DEid
														where aftr.AFRid = afr.AFRid)
												end
											end as Estado,
											'<a href=''javascript: ver(' #_Cat# #LvarAid# #_Cat# ');''><img src=''/cfmx/sif/imagenes/find.small.png'' border=''0''></a>' as ver,
											case when exists (select 1
													           from AFTResponsables aftr
													          where aftr.AFRid = afr.AFRid) then AFRid
											else -1
											end as lr,
											case 
											when exists (
													select 1
													from AFTResponsables aftr
													where aftr.AFRid = afr.AFRid
													and AFTRestado = 20
											) then '<a href=''##'' onclick=''javascript:document.lista.eliminar.value=' #_Cat# 
													(select max(#LvarAFTRid#)
													from AFTResponsables aftr
													where aftr.AFRid = afr.AFRid) #_Cat# 
													';document.lista.submit();''><img src=''/cfmx/sif/imagenes/delete.small.png'' border=''0'' width=''16'' height=''16'' /></a>'
											else ''
											end as img"		
							linearoja="lr EQ AFRid"
							inactivecol="lr"
							filtro="afr.Ecodigo = #Session.Ecodigo#
											and afr.DEid = #Form.DEid#
											and #hoy#
											between afr.AFRfini and afr.AFRffin
											order by act.Aplaca"
							desplegar="Aplaca,
											Descripcion,
											AFRfini,
											Estado,
											ver,
											img"
							filtrar_por_array="#ListToArray('act.Aplaca| act.Adescripcion| afr.AFRfini| | | ','|')#"
							etiquetas="#LB_Placa#, #LB_Descripcion#, #LB_Fecha#,#LB_Estado#,&nbsp;, "
							formatos="S,S,D,U,U,U"
							align="left,left,center,left,left,left"
							ajustar="N"
							showLink="false"
							checkboxes="S"
							keys="AFRid"
							incluyeForm="false"
							formname="lista"
							showEmptyListMsg="true"
							mostrar_filtro="true"
							filtrar_automatico="true"
							maxrows="75"
							maxrowsquery="100"
						/>
					</cfif>							
					
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:0px">
					  <tr>
						<td nowrap>
							<cf_rhempleado form="lista" size="60" tabindex="1">
						</td>
						<td nowrap>
							<cf_sifcalendario value="#LSDateFormat(Now(),'dd/mm/yyyy')#" form="lista" tabindex="1">
						</td>
					  </tr>
					</table>
					<cf_botones values="#BTN_Transferir#" form="lista" tabindex="1">
				</form>
				<cf_qforms form="lista" objForm="olista">
					<cf_qformsrequiredfield name="chk" description="#MSG_Documentos#"/>
					<cf_qformsrequiredfield name="DEid" description="#MSG_Empleado#"/>
					<cf_qformsrequiredfield name="fecha" description="#MSG_Fecha#"/>
				</cf_qforms>
			</cfif>
		</cf_tab>
		<cf_tab text="#TAB_DocumentosPorRecibir#" selected="#o eq 2#" id="2">
			<cfif o eq 2>
				<form action="traspaso_resposable-auto-sql.cfm" method="post" name="lista" style="margin:0px">
					<cfparam name="url.PageNum_Lista" default="1">
					<input type="hidden" name="PageNum_Lista" value="<cfoutput>#url.PageNum_Lista#</cfoutput>" />
					<input type="hidden" name="o" value="2" />
					<input type="checkbox" name="chk" value="" style="visibility:hidden" /><!--- Para que el objeto exista cuando no hay items y no de error en el api de qforms --->
					<cf_dbfunction name="to_char" args="afr.Aid" returnvariable="LvarAid">
					
					<cfif isdefined("TAprob") and TAprob eq 0>
					
						<!--- Aprobación por Encargado de Centro Funcional --->
						<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet" debug="N"
							tabla="AFTResponsables aftr
											inner join AFResponsables afr
												inner join Activos act
													on act.Ecodigo = afr.Ecodigo
													and act.Aid = afr.Aid
												on afr.AFRid = aftr.AFRid
												and #hoy#
												between afr.AFRfini and afr.AFRffin
											"
							columnas="aftr.AFTRid, act.Aplaca,	afr.AFRid, coalesce(afr.CRDRdescdetallada, afr.CRDRdescripcion, act.Adescripcion) as Descripcion, afr.AFRfini, 
											case 
											when aftr.AFTRestado = 20
											then '#LB_Rechazado#' 
											else 
												case 
												when aftr.AFTRaprobado1 = 0
												then '#LB_RequiereAprobacionDelEncargadoDelCentroFuncional#<br> ' #_Cat#  
															(select cf.CFcodigo #_Cat#  '-' #_Cat#  cf.CFdescripcion
															   from CFuncional cf
															 where cf.CFid = aftr.AFTRCFid1)
												when aftr.AFTRaprobado2 = 0
												then '#LB_RequiereAprobacionDelEncargadoDelCentroFuncional#<br> ' #_Cat#  
															(select cf.CFcodigo #_Cat#  '-' #_Cat#  cf.CFdescripcion
															  from CFuncional cf
															 where cf.CFid = aftr.AFTRCFid2)
												else '#LB_RequiereDeSuAprobacion#'
												end
											end as Estado,
											'<a href=''javascript: ver(' #_Cat#  #LvarAid# #_Cat# ');''><img src=''/cfmx/sif/imagenes/find.small.png'' border=''0''></a>' as ver,
											case 
											when aftr.AFTRestado = 20 then AFTRid
											when aftr.AFTRaprobado1 = 0 then AFTRid
											when aftr.AFTRaprobado2 = 0 then AFTRid
											else -1
											end as lr
											"
							linearoja="lr EQ AFTRid"
							inactivecol="lr"
							filtro="aftr.DEid = #Form.DEid#
											and aftr.AFTRestado in (10,20)
											order by act.Aplaca"
							desplegar="Aplaca,
											Descripcion,
											AFRfini,
											Estado,
											ver"
							filtrar_por_array="#ListToArray('act.Aplaca| coalesce(afr.CRDRdescdetallada, afr.CRDRdescripcion, act.Adescripcion)| afr.AFRfini| | ','|')#"
							etiquetas="#LB_Placa#, #LB_Descripcion#, #LB_Fecha#, #LB_Estado#"
							formatos="S,S,D,U,U"
							align="left,left,center,left,left"
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
						
					<cfelse>
						<!--- Aprobación por Encargado de Centro de Custodia --->
						<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet" debug="N"
							tabla="AFTResponsables aftr
											inner join AFResponsables afr
												inner join Activos act
													on act.Ecodigo = afr.Ecodigo
													and act.Aid = afr.Aid
												on afr.AFRid = aftr.AFRid
												and #hoy#
												between afr.AFRfini and afr.AFRffin
											"
							columnas="aftr.AFTRid, act.Aplaca,	afr.AFRid, coalesce(afr.CRDRdescdetallada, afr.CRDRdescripcion, act.Adescripcion) as Descripcion, afr.AFRfini, 
											case 
											when aftr.AFTRestado = 20
											then '#LB_Rechazado#' 
											else 
																								
												case 
												when exists (
														select 1
														from AFTResponsables aftr
														where aftr.AFRid = afr.AFRid
														and aftr.AFTRaprobado2 = 0
												) then 
														'#LB_RequiereAprobacionDelEncargadoDelCentrodeCustodia#<br> ' #_Cat#  
															(coalesce( (
															select MAX(crcc.CRCCcodigo #_Cat# '-' #_Cat# crcc.CRCCdescripcion)
															from AFTResponsables aftr
																inner join CRCentroCustodia crcc
																	on crcc.CRCCid = aftr.CRCCid
																	and crcc.Ecodigo = #session.Ecodigo#
															where aftr.AFRid = afr.AFRid
															and aftr.AFTRaprobado2 = 0),'')
															)
												else 
													'#LB_RequiereAprobacionDelEmpleado#<br>' #_Cat# 
														(select de.DEidentificacion #_Cat# '-' #_Cat# de.DEnombre #_Cat# ' ' #_Cat# de.DEapellido1
														  from AFTResponsables aftr
															inner join DatosEmpleado de
																on de.DEid = aftr.DEid
														 where aftr.AFRid = afr.AFRid)
												end												
												
												
											end as Estado,
											'<a href=''javascript: ver(' #_Cat# #LvarAid# #_Cat# ');''><img src=''/cfmx/sif/imagenes/find.small.png'' border=''0''></a>' as ver,
											case 
											when aftr.AFTRestado = 20 then AFTRid
											when aftr.AFTRaprobado1 = 0 then AFTRid
											when aftr.AFTRaprobado2 = 0 then AFTRid
											else -1
											end as lr
											"
							linearoja="lr EQ AFTRid"
							inactivecol="lr"
							filtro="aftr.DEid = #Form.DEid#
											and aftr.AFTRestado in (10,20)
											order by act.Aplaca"
							desplegar="Aplaca,
											Descripcion,
											AFRfini,
											Estado,
											ver"
							filtrar_por_array="#ListToArray('act.Aplaca| coalesce(afr.CRDRdescdetallada, afr.CRDRdescripcion, act.Adescripcion)| afr.AFRfini| | ','|')#"
							etiquetas="#LB_Placa#, #LB_Descripcion#, #LB_Fecha#, #LB_Estado#"
							formatos="S,S,D,U,U"
							align="left,left,center,left,left"
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
					</cfif>						
					<cf_botones values="#BTN_Recibir#, #BTN_Rechazar#" form="lista" tabindex="1">
				</form>
				<cf_qforms form="lista" objForm="olista">
					<cf_qformsrequiredfield name="chk" description="#MSG_Documentos#"/>
				</cf_qforms>
			</cfif>
		</cf_tab>
	</cf_tabs>
	

<script language="javascript" type="text/javascript">
	function funcFiltrar() {
		deshabilitarValidacion();
		return true;
	}
	function tab_set_current (n) {
		location.href='traspaso_resposable-auto.cfm?o='+escape(n);
	}
	function confirmar(msg) {
		return olista.validate() && confirm('<cfoutput>#MSG_ConfirmeQueDesea#</cfoutput> ' + msg + ' <cfoutput>#MSG_LosDocumentosMarcados#</cfoutput>.');
	}
	function funcTransferir() {
	<cfif #rsBoleta.value# eq 1>
		if(confirmar('<cfoutput>#MSG_Transferir#</cfoutput>'))
		{
			var listAidchecked = '';
			for(var i=1; i < document.lista.chk.length; i++)
			{
				if(document.lista.chk[i].checked)
				{
					listAidchecked = listAidchecked + document.lista.chk[i].value+ ','; 
				}
				
			} valores = listAidchecked.substring(0,listAidchecked.length-1)
			var PARAM  = "TrapasoActivosF.cfm?AFRid="+ valores+"&DEid="+<cfoutput>#form.DEid#</cfoutput>+"&DEidT="+document.lista.DEid.value;
			open(PARAM,'aa','left=100,top=150,scrollbars=yes,resizable=yes,width=900,height=500')
			return true;
		}
		else return false;
	<cfelse>
		return confirmar('<cfoutput>#MSG_Transferir#</cfoutput>');
	</cfif>
	}
	
	function funcRecibir() {
		return confirmar('<cfoutput>#MSG_Recibir#</cfoutput>');
	}
	function funcRechazar() {
		return confirmar('<cfoutput>#MSG_Rechazar#</cfoutput>');
	}
	function ver(llave) {
		var PARAM  = "../../catalogos/Activos_frameInformacion.cfm?Auto=S&aid="+ llave;
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=900,height=500')
	}
</script>
