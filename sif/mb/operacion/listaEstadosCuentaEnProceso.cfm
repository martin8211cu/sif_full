<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 23 de noviembre del 2005
	Motivo: Se cambio la fecha del filtro de la lista. Antes estaba la fecha del registro del estado de cuenta, 
			se cambio por la fecha de corte del estado de cuenta.
	
	Modificado por: Ana Villavicencio
	Fecha: 14 de noviembre del 2005
	Motivo: Se agregó un icono en la lista de estados de cuenta en proceso, 
			para que el proceso de conciliación de un estado de cuenta determinado pueda reiniciarse, 
			esto es limpiar la tablas de trabajo(CDBancos y CDLibros).
			Se agrego dentro de las indicaciones la información relacionada con el proceso de 
			reiniciar la conciliación.
			
	Modificado por: Ana Villavicencio
	Fecha: 19 de octubre del 2005
	Motivo:  Utilizar Funcionalidad 100% del Componente de Listas (Filtros, Navegación, Lista)
	
	Modificado por: Ana Villavicencio
	Fecha: 07 de octubre del 2005
	Motivo:  modificar el diseño de la forma, se cambio el estilo de los radio para q fuera del color del fondo.
	
	Creado por: Desconocido
	Fecha: Desconocido
	Motivo: Desconocido	
--->
 <cfset title1="Conciliaci&oacute;n Bancaria">
<cfset title2="Lista de Estados de Cuenta En Proceso">
<cfset LvarIrAFrameConfig="frame-config.cfm">
<cfset LvarIrAFrameProgreso="frame-Progreso.cfm">
<cfset LvarIrAEC="EstadosCuenta.cfm">
<cfset LvarIrAConAuto="ConciliacionAutomatica.cfm">
<cfset LvarIrAlistECP="listaEstadosCuentaEnProceso.cfm">
<cfset LvarCBesTCE=0><!---Filtro para los querys TCE o CuentasBancarias--->
<cfif isdefined("LvarTCEstadosCuentaProceso")>
	<cfset LvarIrAFrameConfig="../../tce/operaciones/TCEframe-config.cfm">
	<cfset LvarIrAFrameProgreso="../../tce/operaciones/TCEframe-Progreso.cfm">
 	<cfset LvarIrAEC="EstadosCuentaCONCTCE.cfm">
	<cfset LvarIrAConAuto="TCEConciliacionAutomatica.cfm">
	<cfset LvarIrAlistECP="listaEstadosCuentaProcesoTCE.cfm">
	<cfset LvarCBesTCE=1><!---Filtro para los querys TCE o CuentasBancarias--->
</cfif>

<!---<cf_dump var=#LvarCBesTCE#>
--->
<!--- <cf_dump var="#form#"> --->

<cfif isdefined('InicioConc') and form.InicioConc EQ 0>
	<!--- <cfquery name="valMovEC_CDL_CDB" datasource="#conexion#">
	select 
		case when (
			(
				SELECT 
				 count(*) as ECmov
				from DCuentaBancaria edc
				where ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
				and Ecodigo =#Session.Ecodigo# 
			)=
			(
				SELECT count(*) as CDBmov
				from CDBancos
				where CDBconciliado like 'S'
				and Ecodigo =#Session.Ecodigo# 
				and ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ECid#">
			)
		)
		then 
			 1	
		else 0
		end as balED
	</cfquery> --->

	<!--- <cfif isdefined("valMovEC_CDL_CDB.balED") and valMovEC_CDL_CDB.balED EQ	 1> --->
		<!--- JARR Se modifico el proceos para reprocesar la conciliacion 
		se reinician los mov. pendientes de aplicar con base al id del Estado de Cuenta
		 --->
		<cftry>
		<cfquery name="deleteCDLibros" datasource="#session.DSN#">
			update CDLibros 
			Set CDLPreconciliado='N',
			 CDLconciliado = 'N',
			 CDLacumular=0
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
			and  CDLPreconciliado <> 'P'
		</cfquery>
		<!--- <cfquery name="deleteCDLibros" datasource="#session.DSN#">
			delete from CDLibros
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
		</cfquery> --->
		<!--- Actuliza el monto con base al Estado de cuenta --->

		<!--- OPARRALES 2018-10-17 
			- Se eliminan los registros cargados en la conciliacion que ya no existan en los estados de cuenta
		 --->
		<cfquery name="deleteCDBancos" datasource="#session.DSN#">
			delete from CDBancos
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
			AND CDBlinea not in (select Linea 
									from DCuentaBancaria 
									where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
									and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								)
		</cfquery>
		
		<cfquery name="deleteCDLibros" datasource="#session.DSN#">
			update CDBancos
			set CDBconciliado ='N',
			CDBgrupo = null
			where ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
			and BTid is null
			and CDBconciliado = 'S'
		</cfquery>

		<cfquery name="deleteCDLibros" datasource="#session.DSN#">
			update CDBancos
			set CDBmonto =(select DCmontoori from DCuentaBancaria where Linea =CDBancos.CDBlinea)
			where ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
			and CDBconciliado <> 'S'
		</cfquery>

		<cfquery name="deleteCDLibros" datasource="#session.DSN#">
			insert into CDBancos (ECid, 
										  CDBlinea, 
										  CDBdocumento, 
										  CDBidtrans, 
										  CDBmonto, 
										  CDBfechabanco, 
										  CDBconciliado, 
										  CDBmanual, 
										  CDBtipomov, 
										  CDBfecha, 
										  CDBusuario, 
										  CDBecref,
										  Ecodigo,
										  Bid,
										  BTEcodigo,
										  CDBlinref) 
							select dc.ECid, 
							   dc.Linea, 
							   dc.Documento, 
							   null, 
							   dc.DCmontoori, 
							   dc.DCfecha, 
							   dc.DCconciliado, 
							   'S', 
							   dc.DCtipo, 
							   <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">, 
							    '#Session.Usucodigo#',
							   dc.ECid,
							   dc.Ecodigo,
							   dc.Bid,
							   dc.BTEcodigo,
							   dc.Linea
							from DCuentaBancaria dc
							inner join ECuentaBancaria ec
							   on dc.ECid 		 = ec.ECid
							  and ec.EChistorico = 'N'
							inner join CuentasBancos cb
							   on ec.CBid 	 = cb.CBid
							  and cb.Ecodigo = #Session.Ecodigo#
							where ec.ECid 	 = #form.ECid#
							and dc.Linea not in (select CDBlinea from CDBancos where ECid =#form.ECid#)
		</cfquery>

		<cfcatch type="any">

			<cfif isdefined("cfcatch.Message")>
                <cfset Mensaje="#cfcatch.Message#">
            <cfelse>
                <cfset Mensaje="">
            </cfif>
            <cfif isdefined("cfcatch.Detail")>
                <cfset Detalle="#cfcatch.Detail#">
            <cfelse>
                <cfset Detalle="">
            </cfif>
            <cfif isdefined("cfcatch.sql")>
                <cfset SQL="#cfcatch.sql#">
            <cfelse>
                <cfset SQL="">
            </cfif>
            <cfif isdefined("cfcatch.where")>
                <cfset PARAM="#cfcatch.where#">
            <cfelse>
                <cfset PARAM="">
            </cfif>
            <cfif isdefined("cfcatch.StackTrace")>
                <cfset PILA="#cfcatch.StackTrace#">
            <cfelse>
                <cfset PILA="">
            </cfif>
			<cfthrow message="Problema al Reiniciar la Conciliacion : #Mensaje#.  #Detalle#  #SQL#  #PARAM#">
		</cfcatch>
	</cftry>
	<!--- </cfif> --->
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<!--- <cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent> --->
<cfset form.ECid = ''>
<!--- <cf_templateheader title="#nav__SPdescripcion#"> --->
	<cfinclude template="#LvarIrAFrameConfig#">
	<style type="text/css">
		input {background-color: #FAFAFA; font-family: Tahoma, sans-serif; font-size: 8pt; border:1px solid gray}
	</style>
<cf_templateheader title="#title1#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#title2#'>
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<form name="frmGO" action="" method="post" style="margin: 0; ">
			<input type="hidden" name="ECid" value="<cfif isdefined("Form.ECid")><cfoutput>#Form.ECid#</cfoutput></cfif>">
			<input type="hidden" name="modo" value="CAMBIO">
			<input type="hidden" name="InicioConc" value="1">
		</form>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="85%" valign="top">
						 <!---redireccion listaEstadosCuentaEnProceso.cfm o listaEstadosCuentaProcesoTCE.cfm (TCE)--->
 						<form name="form1" action="<cfoutput>#LvarIrAlistECP#</cfoutput>" method="post">
							<input type="hidden" name="ECid" value="<cfif isdefined("Form.ECid")><cfoutput>#Form.ECid#</cfoutput></cfif>">
							<input type="hidden" name="paso1" value="1">
							<cfquery name="rsBancos" datasource="#Session.dsn#">
								<!---Solo bancos con estados de cuenta asociados--->
								<cfif isdefined("LvarTCEstadosCuentaProceso")>
									select 
										-1 as value, '-- Todos --' as description from dual	union all	
									select distinct
										a.Bid as value, 
										b.Bdescripcion as description 
									from ECuentaBancaria a 
										inner join Bancos b
											on a.Bid = b.Bid 
										inner join CuentasBancos c
											on c.CBid = a.CBid
									where 	
											c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
										and c.CBesTCE = 1
										and a.CBid = c.CBid 
								<cfelse>
									select -1 as value, '-- Todos --' as description from dual
									union all
									select Bid as value, Bdescripcion as description
									from Bancos
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
								</cfif>
								
							</cfquery>
							<!---Filtro para Tarjetas de Crédito LvarCBesTCE---> 
							<cfquery name="rsCuentasBancos" datasource="#Session.dsn#">
								<!---Solo bancos con estados de cuenta asociados--->
								<cfif isdefined("LvarTCEstadosCuentaProceso")>
									select -1 as value, '-- Todos --' as description, -1 as Bid from dual
									union all
									select distinct c.CBid as value, CBdescripcion as description, b.Bid
									from ECuentaBancaria a 
										inner join Bancos b
											on a.Bid = b.Bid 
										inner join CuentasBancos c
											on c.CBid = a.CBid
									where 	
											c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
										and c.CBesTCE = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarCBesTCE#">
										and a.CBid = c.CBid
										and a.EChistorico = <cfqueryparam cfsqltype="cf_sql_char" value="N">
										and a.ECStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
								<cfelse>
									select -1 as value, '-- Todos --' as description, -1 as Bid from dual
									union all
									select CBid as value, CBdescripcion as description, Bid
									from CuentasBancos
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
										and CBesTCE = #LvarCBesTCE#
								</cfif>
								
							</cfquery>			
							<cfquery name="rsEstado" datasource="#session.DSN#">
								select '' as value, '-- Todos --' as description from dual
								union
								select 'S' as value, 'LISTO' as description from dual
								union
								select 'N' as value, 'EN PROCESO' as description from dual
								order by value
							</cfquery>
							<cf_dbfunction name="to_char" returnvariable="ECid" args="a.ECid">
							<cf_dbfunction name="concat" returnvariable="LvarReporte" args="'<img src=''/cfmx/sif/imagenes/iedit.gif'' title=''Editar'' width=''16'' height=''16'' border=''0'' onClick=''javascript: ModificarEstadoCuenta('+#ECid#+');''>'"delimiters="+">
							<cf_dbfunction name="concat" returnvariable="LvarReiniciar" args="'<img src=''/cfmx/sif/imagenes/refresh_o.gif'' title=''Reiniciar Proceso''width=''16'' height=''16'' border=''0'' onClick=''javascript: ReiniciaConciliacion('+#ECid#+');''>'"delimiters="+">
							<cfinvoke 
									 component="sif.Componentes.pListas"
									 method="pLista"
									 returnvariable="pListaRet">
								<!---Variable LvarCBesTCE tarjetas de credito de 0 a 1--->
								<cfinvokeargument name="columnas"  				value="	c.CBTCid,
																						a.ECid, 
																						a.Bid, 
																						b.Bdescripcion, 
																						a.ECfecha, 
																						c.CBdescripcion, 
																						a.ECdescripcion, 
																						b.Bdescripcion, 
																						a.EChasta, 
																						case  when a.ECaplicado = 'S' then 'LISTO' 	
																							else 'EN PROCESO' end as Estado, 
																						#LvarReporte# as reporte,
																						#LvarReiniciar# as reiniciar"/>
																						
								<cfinvokeargument name="tabla"  				value="ECuentaBancaria a 
	
																						inner join Bancos b
																							on a.Bid = b.Bid 
																					
																						inner join CuentasBancos c
																							on c.CBid = a.CBid"/>
								
								<!---Filtro para el Status en EcuentaBancaria TCE o Bancos--->
								<cfif isdefined("LvarTCEstadosCuentaProceso")>
										<cfinvokeargument name="filtro"    value="		c.Ecodigo = #Session.Ecodigo#
																					and c.CBesTCE = #LvarCBesTCE#
																					and a.CBid = c.CBid 
																					and a.EChistorico in ('N','P') 
																					and a.ECStatus = 1
																					and c.CBTCid in (	
																										select CBTCid  
																										from CBDusuarioTCE cd
																											inner join CBUsuariosTCE cbu
																												on cbu.CBUid = cd.CBUid
																										where cbu.Usucodigo= #Session.Usucodigo# 
                                                                                                        and cd.Conciliador = 1
																									) "/>
  							 	<cfelse>
										<cfinvokeargument name="filtro"    value="b.Ecodigo = #Session.Ecodigo#
																				  and c.CBesTCE = #LvarCBesTCE#
																				  and a.Bid = b.Bid 
																				  and a.CBid = c.CBid 
																				  and a.EChistorico in ('N','P')  
																				 order by a.Bid,a.CBid"/>
 								</cfif>
  								
								<cfinvokeargument name="desplegar"  			value="Bdescripcion, CBdescripcion, EChasta, Estado, reporte, reiniciar"/>
								<cfinvokeargument name="filtrar_por"  			value="b.Bid, c.CBid, a.EChasta, a.ECaplicado, '', ''"/>
								
								<!---Filtrado de etiquetas para Bancos o TCE--->
 								<cfif isdefined("LvarTCEstadosCuentaProceso")>
									<cfinvokeargument name="etiquetas"  			value="Banco, Tarjetas de Cr&eacute;dito, Fecha, Estado, , "/>
 							 	<cfelse>
									<cfinvokeargument name="etiquetas"  			value="Banco, Cuenta Bancaria, Fecha, Estado, , "/>
								</cfif>
								<!---Fin del Filtro de etiquetas--->
								
								<cfinvokeargument name="formatos"   			value="S,S,D,S,G,G"/>
								<cfinvokeargument name="align"      			value="left,left,left,left,left,left"/>
								<cfinvokeargument name="ajustar"    			value="N"/>
								<cfinvokeargument name="irA"        			value=""/>
								<cfinvokeargument name="showLink" 				value="false"/>
								<cfinvokeargument name="radios" 	 	 	    value="S"/>
								<cfinvokeargument name="botones"    			value="Siguiente"/>
								<cfinvokeargument name="showEmptyListMsg" 		value="true"/>
								<cfinvokeargument name="maxrows" 				value="15"/>
								<cfinvokeargument name="keys"             		value="ECid"/>
								<cfinvokeargument name="mostrar_filtro"			value="true"/>
								<cfinvokeargument name="filtrar_automatico"		value="true"/>
								<cfinvokeargument name="formname"				value="form1"/>
								<cfinvokeargument name="incluyeform"			value="false"/>
								<cfinvokeargument name="rsBdescripcion"			value="#rsBancos#"/>
								<cfinvokeargument name="rsCBdescripcion"		value="#rsCuentasBancos#"/>
								<cfinvokeargument name="rsEstado"				value="#rsEstado#"/>
							</cfinvoke>
						</form>
						<cf_qforms>
						<script>
							objForm.filtro_Bdescripcion.addEvent('onChange', 'llenarCuentasBancarias(this.value);', true);
							function llenarCuentasBancarias(v){
								var combo = objForm.filtro_CBdescripcion.obj;
								var cont = 0;
								combo.length=0;
								<cfoutput query="rsCuentasBancos">
									if (#rsCuentasBancos.Bid#==v)
									{
										combo.length=cont+1;
										combo.options[cont].value='#rsCuentasBancos.value#';
										combo.options[cont].text='#rsCuentasBancos.description#';
										<cfif isdefined("form.filtro_CBdescripcion") and len(trim(form.filtro_CBdescripcion))>
											if (#form.filtro_CBdescripcion#==#rsCuentasBancos.value#) combo.options[cont].selected = true;
										</cfif>
										cont++;
									};
								</cfoutput>
							}
							llenarCuentasBancarias(objForm.filtro_Bdescripcion.getValue());
						</script>
				</td>
			    <td width="15%" valign="top" >
					<cfinclude template="#LvarIrAFrameProgreso#">
					<br>
					<div class="ayuda">
						<strong>&nbsp;Indicaciones:</strong><br><br>
						&nbsp;Seleccione el Estado de Cuenta que desea conciliar y presione el bot&oacute;n de 
						<font color="#003399"><strong>Siguiente >></strong></font>.<br><br> 
						&nbsp;Si desea modificar los documentos del Estado de Cuenta haga click en el icono 
						<img src="/cfmx/sif/imagenes/iedit.gif" width="16" height="16" border="0"><br><br> 
						&nbsp;Si desea reiniciar el proceso de conciliaci&oacute;n para un Estado de Cuenta haga click en el icono 
						<img src="/cfmx/sif/imagenes/refresh_o.gif" width="16" height="16" border="0"><br><br> 
						&nbsp;Tambi&eacute;n puede utilizar el cuadro de <font color="#003399"><strong>Pasos</strong></font> 
						para saltar a las dem&aacute;s opciones<br><br>
					</div>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>	
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="javaScript" type="text/javascript">
		<!--//
		function ModificarEstadoCuenta(id) {
			<!---redireccion EstadosCuenta.cfm o EstadosCuentaTCE.cfm (TCE)--->
			document.frmGO.action='<cfoutput>#LvarIrAEC#</cfoutput>';
			document.frmGO.ECid.value = id;
			document.frmGO.submit();
		}
		function funcSiguiente() {
			if (document.form1.chk && document.form1.chk.value) {
				document.frmGO.ECid.value = document.form1.chk.value;
			} else if (document.form1.chk) {
				for (var i=0; i<document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) {
						document.frmGO.ECid.value = document.form1.chk[i].value;
						break;
					}
				}
			}
			
			if (document.frmGO.ECid.value != '') {
					<!---redireccion ConciliacionAutomatica.cfm o TCEConciliacionAutomatica.cfm (TCE)--->
					document.frmGO.action='<cfoutput>#LvarIrAConAuto#</cfoutput>';
				document.frmGO.submit();
			} else {
				alert('No hay ningún Estado de Cuenta Seleccionado');
			}
			return false;
		}
		
		function ReiniciaConciliacion(id){
		
			<!--- confirmar si desea reiniciar conciliacion --->
			if(confirm("¿Esta Seguro que Desea Reiniciar el Proceso de Conciliación?"))
			{
				<!---redireccion listaEstadosCuentaEnProceso.cfm o listaEstadosCuentaProcesoTCE.cfm (TCE)--->
				document.frmGO.action='<cfoutput>#LvarIrAlistECP#</cfoutput>';
				document.frmGO.ECid.value = id;
				document.frmGO.InicioConc.value = 0;
				document.frmGO.submit();
			}
		}
		//-->
	</script>