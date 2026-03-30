<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha 23-5-2006.
		Motivo: Se implementa el componente de listas para utilizar la navegación y que no se generén páginas de 1MB.	
		
	Modificado por: Ana Villavicencio
	Fecha: 21 de noviembre del 2005
	Motivo: Mejorar despliegue de datos.

	Modificado por Gustavo Fonseca H.
		Fecha 19-10-2005.
		Motivo:Se modifica el query que trae las línes para que tome en cuenta solo las
		transacciones de la tabla "TransaccionesBanco".

	Modificado por Gustavo Fonseca H.
		Fecha 14-10-2005.
		Motivo: Se modifica el combo del detalle para que muestre las transacciones del banco.
 --->
<cfset LvarIrAformEstadosCuenta="formEstadosCuenta.cfm">
<cfset LvarIrAEC="EstadosCuenta.cfm">
<cfset LvarListaEC="listaEstadosCuenta.cfm">
<cfset LvarTitulo ="Bancos">
    <cfset LvarCreditos = "select cc.DCmontoloc 
						     from DCuentaBancaria cc
						 where cc.ECid = a.ECid
			     		   and cc.Linea = a.Linea
		    			   and  cc.Bid = a.Bid
	  			    	   and cc.BTEcodigo = a.BTEcodigo
     				       and cc.DCtipo = 'C'">   
<cfif isdefined("LvarTCEEstadoCuenta")>
    <cfset LvarCreditos = "select case when cc.DCmontoloc =  cc.DCmontoori 
	                        then  cc.DCmontoloc
							when cc.DCmontoloc = 0.00 and  cc.DCmontoori > 0.00  then 
							   cc.DCmontoori  
							end      
						  from DCuentaBancaria cc
						where cc.ECid = a.ECid
			     		  and cc.Linea = a.Linea
		    			  and  cc.Bid = a.Bid
	  			    	  and cc.BTEcodigo = a.BTEcodigo
     				      and cc.DCtipo = 'C'">
	<cfset LvarIrAEC="EstadosCuentaTCE.cfm">
	<cfset LvarListaEC="listaEstadosCuentaTCE.cfm">
 	<cfset LvarIrAformEstadosCuenta="../../tce/operaciones/formEstadosCuentaTCE.cfm">
	<cfif IsDefined("LvarIrConciliacion")>
		<cfset LvarIrAEC="EstadosCuentaCONCTCE.cfm">
		<cfset LvarListaEC="listaEstadosCuentaProcesoTCE.cfm">
		<cfset LvarIrAformEstadosCuenta="../../tce/operaciones/formEstadosCuentaCONCTCE.cfm">
 	</cfif>
	<cfset LvarTitulo ="Tarjetas de Crédito Empresarial">
</cfif>

<cf_templateheader title="#LvarTitulo#">
	<cfif isdefined("Form.Cambio")>
		<cfset modo="CAMBIO">
	<cfelse>
		<cfif not isdefined("Form.modo")>
			<cfset modo="ALTA">
		<cfelseif Form.modo EQ "CAMBIO">
			<cfset modo="CAMBIO">
		<cfelse>
			<cfset modo="ALTA">
		</cfif>
	</cfif>
	<cfif not isdefined("Form.modoDet")>
		<cfset modoDet = "ALTA">
	</cfif>
	<cfif isDefined("Form.NuevoE")>
		<cfset modo = "ALTA">
		<cfset modoDet = "ALTA">
	</cfif>

	<cfif isDefined("Form.datos") and Form.datos NEQ "">
		<cfset modo = "CAMBIO">
		<cfset modoDet = "ALTA">
	</cfif>

	<cfif isdefined("Form.btnNuevo")>
		<cfset modo = "ALTA">
	</cfif>	
	<cfif isdefined('url.ECid') and not isdefined('form.ECid')>
		<cfset form.ECid = url.ECid>
		<cfset modo = "CAMBIO">
		<cfset modoDet = "ALTA">
	</cfif>
	
	<cfif modo eq "CAMBIO">
		<cfquery name="rsStatus" datasource="#session.dsn#">
			select ECStatus 
			from ECuentaBancaria              
			where  ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">       
		</cfquery>	
		<cfset LvarRevisa = "#rsStatus.ECStatus#">
	</cfif>
    
	<cfif modo eq "CAMBIO" and isdefined("LvarTCEEstadoCuenta")>
    	<cfquery name="rsEstado" datasource="#session.dsn#">
			select coalesce ((select e.CBPTCestatus  
                             from CBEPagoTCE e inner join CBDPagoTCEdetalle d
						   		on e.CBPTCid = d.CBPTCid
						  	 where
						   		d.ECid = a.ECid
						    	and not exists (select 1 from CBEPagoTCE g where g.CBPTCidOri= e.CBPTCid)
                            	),0) as CBPTCestatus 
			from ECuentaBancaria a            
			where  a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">       
		</cfquery>	
		<cfset LvarEstado = rsEstado.CBPTCestatus>
    </cfif>
 	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estados de Cuenta Bancarios'>

					<cfset ECid = "">
					<cfset Linea = "">
					
					<cfif not isDefined("Form.NuevoE")>            
						<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >                
							<cfset arreglo = ListToArray(Form.datos,"|")>
							<cfset ECid = Trim(arreglo[1])>	
							<!---<cfset dLinea = Trim(arreglo[2])>	--->
						<cfelseif isDefined("Form.ModificarEC") and isDefined("Form.opt") and Len(Trim(Form.opt)) GT 0 >
							<cfparam name="Form.ECid" default="#Form.opt#">
							<cfset ECid = Form.ECid>
							<cfset modo = "CAMBIO">		
						<cfelseif isDefined("Form.AgregarEC") >
							<cfset modo = "ALTA">
						<cfelseif isDefined("Form.ModificarEstado") >
							<cfset ECid = Form.ECid>
							<cfset modo = "CAMBIO">
						<cfelse>
							<cfif not isDefined("Form.ECid") >
 								<!--- Redireccion de listaEstadosCuenta.cfm o TCElistaEstadoCuenta.cfm (Tarjetas de Credito)--->                  
								<cflocation addtoken="no" url="#LvarListaEC#">	
							<cfelse>
								<cfif isDefined("Form.ECid") and Len(Trim(Form.ECid )) GT 0>			
									<cfset ECid = Form.ECid>
								<cfelseif not isdefined('btnNuevo')>
									<!---Redireccion de listaEstadosCuenta.cfm o TCElistaEstadoCuenta.cfm (Tarjetas de Credito)--->
									<cflocation addtoken="no" url="#LvarListaEC#">	
								</cfif>
							</cfif>
						</cfif>
					</cfif>
 					<cfif Len(Trim(ECid)) NEQ 0 >
						<cfquery name="rsSaldo" datasource="#Session.DSN#">
							select ECsaldoini from ECuentaBancaria where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
						</cfquery>
					</cfif>
					
					<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr> 
							<td >
								<cfoutput>
									<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##DFDFDF">
										<tr align="left"> 
											<td><cfinclude template="../../portlets/pNavegacion.cfm"></td>
										</tr>
									</table>
								</cfoutput>							
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						
						<!---<cf_dump var="LvarTCEstadosCuenta =#LvarTCEEstadoCuenta#">--->
 						
 						<!---Redireccion formEstadosCuenta.cfm o formEstadosCuentaTCE.cfm--->
						<tr><td><cfinclude  template="#LvarIrAformEstadosCuenta#">&nbsp;</td></tr>
						<cfif Len(Trim(ECid)) NEQ 0 and not isDefined("Form.Aplicar")>
							<tr> 
								<td class="subTitulo" width="100%">
									<!--- registro seleccionado --->
									<cfif isDefined("Linea") and Len(Trim(Linea)) GT 0 >
										<cfset seleccionado = Linea >
									<cfelse>
										<cfset seleccionado = "" >
									</cfif>
									<!---Redireccióm EstadosCuenta.cfm o TCEEstadoCuenta(Tarjetas de Credito)--->
									<form action="<cfoutput>#LvarIrAEC#</cfoutput>" method="post" name="form2">
										<input name="datos" type="hidden" value="">
                                        <input name="ECid" type="hidden" value="">
										<cfif modo eq "cambio">                                        
                                          <input name="Status" type="hidden" value="<cfoutput>#LvarRevisa#</cfoutput>">
                                        </cfif>  
										<table width="100%">
											<tr>
												<td>
													
													<cf_dbforceindex name="PK_TRANSACCIONESBANCO" returnvariable="indice">
                                                    
                                                    <cf_dbfunction name='to_char' args='a.ECid' returnvariable='LvarECid'>
                                                    <cf_dbfunction name='to_char' args='a.Linea' returnvariable='LvarLinea'>
                                                    <cf_dbfunction name='to_char' args='a.Bid' returnvariable='LvarBid'>
                                                    
													<cf_dbfunction name="concat" args="#LvarECid# + '|' + #LvarLinea# + '|' + #LvarBid# +'|'+ b.BTEcodigo" returnvariable="Lvarconcat" delimiters="+">
													<cf_navegacion name="ECid"			default="" session>
													<cfif modoDet eq "CAMBIO">
                                                    	<cfset LineaN = Linea>
                                                    <cfelse>
                                                    	<cfset LineaN = "null">
                                                    </cfif>
                                                    <cf_navegacion name="Linea"			value ="#LineaN#" default="" session>
													<cf_navegacion name="Bid" 			default="" session>
													<cf_navegacion name="BTEcodigo" 	default="" session>
                                                    
                                                    <cfinvoke 
														component="sif.Componentes.pListas" 
														method="pLista">
														<cfinvokeargument name="columnas"  	value="	
																									a.BTEcodigo,
																									1 as CF_CurrentRow,
																									a.ECid, 
																									a.Linea,
																									a.BTid,
																									a.Bid,
																									a.DCfecha,			
																									a.Documento,
																									a.DCReferencia,
																									a.DCconciliado,
																									a.DCmontoori,
																									a.DCmontoloc,
																									a.DCtipo,
																									a.DCtipocambio,
																									#Lvarconcat# as data, 
																									(select bb.DCmontoloc 
																										from DCuentaBancaria bb
																									where bb.ECid = a.ECid
																									  and bb.Linea = a.Linea
																									  and  bb.Bid = a.Bid
																									  and bb.BTEcodigo = a.BTEcodigo
																									  and bb.DCtipo = 'D'
																									  ) as Debitos, 
																									  (#preserveSingleQuotes(LvarCreditos)#
																									  ) as Creditos,
																									a.ts_rversion,
																									b.BTEdescripcion"/>
														<cfinvokeargument name="tabla"  	value="DCuentaBancaria a, TransaccionesBanco b #indice#"/>
														<cfinvokeargument name="filtro"  	value="a.ECid = #ECid#
																									  and  b.Bid = a.Bid
																									  and b.BTEcodigo = a.BTEcodigo
																									order by a.Linea "/>
									
														<cfinvokeargument name="desplegar"  		value="CF_CurrentRow, BTEdescripcion, Documento, DCReferencia, DCfecha, Debitos, Creditos"/>
														<!---<cfinvokeargument name="filtrar_por"		value="a.CCTcodigo,EDdocumento,EDusuario,a.Mcodigo,EDfecha,EDtotal,esp"/>--->													
                                                        <cfinvokeargument name="etiquetas"  		value="Línea, Movimiento, Documento, Referencia, Fecha, Débitos, Créditos"/>
														<cfinvokeargument name="formatos"  			value="S,S,S,S,D,M,M"/>
														<cfinvokeargument name="align"  			value="center, left, left, left, left, right,right"/>
												 		<cfinvokeargument name="usaAjax"  			value="no"/>
                                                        <cfinvokeargument name="conexion"  			value="#session.dsn#"/>
														<cfinvokeargument name="funcion"  			value="Editar"/>
														
														<cfinvokeargument name="fparams"  			value="data"/>
														<cfinvokeargument name="keys"  				value="ECid, Linea, Bid, BTEcodigo"/>
														<cfinvokeargument name="maxrows"  			value="15"/>
														<cfinvokeargument name="navegacion"  		value="#navegacion#"/>
														
														<!--- <cfinvokeargument name="mostrar_filtro"  	value="true"/>
														<cfinvokeargument name="filtrar_automatico"	value="true"/> --->
														<cfinvokeargument name="tabindex"  			value="1"/>
														<!--- <cfinvokeargument name="rsCCTdescripcion" 	value="#rsTransacciones#"/>
														<cfinvokeargument name="rsMnombre" 			value="#rsMonedas#"/>
														<cfinvokeargument name="rsEDusuario"		value="#rsUsuarios#"/> --->
														<cfinvokeargument name="totales"		    value="Debitos,Creditos"/>
														<cfinvokeargument name="totalgenerales"		value="Debitos,Creditos"/>
														<cfinvokeargument name="formName"			value="form2"/>
														<cfinvokeargument name="incluyeform" 		value="false"/>
                                                        <cfinvokeargument name="pageindex"  		value="2"/>
													 </cfinvoke> 
												
												</td>
											</tr>
										</table>
										
									</form>
								</td>
							</tr>
						</cfif>			  
					</table>
					<script language="JavaScript1.2">
						function Editar(data) 
						{
						varRevision = document.form2.Status.value;
						<cfoutput>
							<cfif isdefined("LvarTCEEstadoCuenta") and isdefined("LvarEstado") and LvarEstado neq 0>
							
							<cfelse>		
								if(varRevision == 0){
									if (data!="") {
										<!---Redireccióm EstadosCuenta.cfm o TCEEstadoCuenta(Tarjetas de Credito)--->
										document.form2.action='#LvarIrAEC#';
										document.form2.datos.value=data;
										document.form2.ECid.value='#form.ECid#';
										document.form2.submit();
										}
								}else{return true;}
							</cfif>
						}
						</cfoutput>
					</script>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>