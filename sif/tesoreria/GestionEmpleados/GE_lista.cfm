<!---
Creado por: José Madrigal Arias
Fecha:04 de febrero del 2008
descripci&oacute;n: Filtros para creacion de Anticipos y liquidaciones asi como revicion de liquidaciones, nesesario GE_lista_GASTO.cfm(Liquidaciones) o GE_lista_ANTICIPO.cfm(Anticpos de Empleados)
--->
<!--- verificacion--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CentroFuncional" default ="Centro Funcional" returnvariable="LB_CentroFuncional" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Solicitante" default ="Solicitante" returnvariable="LB_Solicitante" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Empleado" default ="Empleado" returnvariable="LB_Empleado" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default ="Fecha" returnvariable="LB_Fecha" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Hasta" default ="Hasta" returnvariable="LB_Hasta" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NumAnticipo" default ="N&uacute;m. Anticipo" returnvariable="LB_NumAnticipo" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NumAnticipos" default ="N&uacute;m. Anticipos" returnvariable="LB_NumAnticipos" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NumLiquidacion" default ="N&uacute;m. Liquidaci&oacute;n" returnvariable="LB_NumLiquidacion" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NumLiquidaciones" default ="N&uacute;m. Liquidaciones" returnvariable="LB_NumLiquidaciones" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NumTransaccion" default ="N&uacute;m. Transacci&oacute;n" returnvariable="LB_NumTransaccion" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NumTransacciones" default ="N&uacute;m. Transacciones" returnvariable="LB_NumTransacciones" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default ="Moneda" returnvariable="LB_Moneda" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NumComision" default ="N&uacute;m. Comisi&oacute;n" returnvariable="LB_NumComision" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_NumComisiones" default ="N&uacute;m. Comisiones" returnvariable="LB_NumComisiones" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TodasLasMonedas" default ="Todas las monedas" returnvariable="LB_TodasLasMonedas" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CualquierTipo" default ="Cualquier Tipo" returnvariable="LB_CualquierTipo" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SolicitudAnticipos" default ="Solicitud de Anticipos" returnvariable="LB_SolicitudAnticipos" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SolicitudComision" default ="Solicitud de Comisi&oacute;n" returnvariable="LB_SolicitudComision" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_LiquidacionGastos" default ="Liquidaci&oacute;n de Gastos" returnvariable="LB_LiquidacionGastos" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Filtrar" default ="Filtrar" returnvariable="BTN_Filtrar" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ListarCancelados" default ="Listar Cancelados" returnvariable="LB_ListarCancelados" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ListarComisionesCerradas" default ="Listar Comisiones Cerradas" 
returnvariable="LB_ListarComisionesCerradas" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_LaListaNoHaSidoFiiltrada" default ="La lista no ha sido filtrada" returnvariable="MSG_LaListaNoHaSidoFiiltrada" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_AsegureseDeQueHayaSeleccionadoLosFiltrosAdecuadosAntesDePresionar" default ="Aseg&uacute;rese de que haya seleccionado los filtros adecuados antes de presionar" returnvariable="MSG_AsegureseDeQueHayaSeleccionadoLosFiltrosAdecuadosAntesDePresionar" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MotivoCancelacion" default ="Motivo Cancelaci&oacute;n" returnvariable="LB_MotivoCancelacion" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MotivoRechazoAnterior" default ="Motivo Rechazo Anterior" returnvariable="LB_MotivoRechazoAnterior" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MotivoRechazo" default ="Motivo Rechazo" returnvariable="LB_MotivoRechazo" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_AunNoHayUnaListaImplementadaParaElTipo" default ="Aun no hay una lista implementada para el tipo" returnvariable="MSG_AunNoHayUnaListaImplementadaParaElTipo" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_ElUsuario" default ="El Usuario" returnvariable="MSG_ElUsuario" xmlfile = "GE_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoEstaRegistradoComoEmpleado" default ="no ha sido registrado como Empleado de la Empresa" returnvariable="MSG_NoEstaRegistradoComoEmpleado" xmlfile = "GE_lista.xml">

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfparam name="Attributes.Tipo"				default="">
<cfparam name="Attributes.Estado"			default="0">
<cfparam name="Attributes.ListarCancelados" default="yes" type="boolean">
<cfparam name="Attributes.Botones" 			default=""    type="string">
<cfparam name="Attributes.PorEmpleado" 		default="no"  type="boolean">
<cfparam name="Attributes.PorSolicitante"	default="no"  type="boolean">
<cfparam name="Attributes.FormaPago" 	    default=""    type="string">
<cfparam name="Attributes.CancelacionLiq"	default="no"  type="boolean">

<cfset LvarSAporComision = isdefined('caller.LvarSAporComision') and caller.LvarSAporComision>
	
<cfset LvarPrimera = false>
<cfset LvarHoy = createODBCdate(now())>
<cfset LvarHaceUnMes = dateadd("d",-7, LvarHoy)>
							
<cf_navegacion name="CFid_F" 				session default="">
<cf_navegacion name="Usucodigo"				session default="">
<cf_navegacion name="Usucodigo2"			session default="">
<cf_navegacion name="UsucodigoSP_F"			session default="">
<cf_navegacion name="Usucodigo2_F"			session default="">
<cf_navegacion name="DEid_F" 				session default="">
<cf_navegacion name="DEid"	 				session default="">
<cf_navegacion name="DEidentificacion"		session>
<cf_navegacion name="DEnombreTodo"			session>
<cf_navegacion name="TESSPfechaPago_I" 		session default="">
<cf_navegacion name="TESSPfechaPago_F" 		session default="">
<cf_navegacion name="McodigoOri_F"			session default="">

	<!---<cfif isdefined("form.cboCFid")>
		<cfset form.CFid = form.cboCFid>
	</cfif>
	<cfset form.cboCFid = form.CFid>--->
	
	<!--- Por Empleado solo puede ver sus Liquidaciones --->
	<cfif Attributes.PorEmpleado>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select llave as DEid
			  from UsuarioReferencia
			 where Usucodigo= #session.Usucodigo#
			   and Ecodigo	= #session.EcodigoSDC#
			   and STabla	= 'DatosEmpleado'
		</cfquery>
		<cfif rsSQL.recordCount EQ 0>
			<cf_errorCode	code = "50737"
							msg  = "#MSG_ElUsuario# '@errorDat_1@' #MSG_NoEstaRegistradoComoEmpleado#"
							errorDat_1="#session.Usulogin#"
			>
		</cfif>
		<cfset form.DEid = rsSQL.DEid>
	</cfif>

	<cfif Attributes.PorEmpleado AND NOT LvarSAporComision>
		<cfset form.UsucodigoSP_F = session.usucodigo>
	<cfelseif isdefined("form.Usucodigo")>	
		<cfset form.UsucodigoSP_F = form.Usucodigo>
	</cfif>
	<cfset form.Usucodigo = form.UsucodigoSP_F>
	
	<cfif isdefined("form.Usucodigo2")>	
		<cfset form.Usucodigo2_F = form.Usucodigo2>
	</cfif>
	<cfset form.Usucodigo2 = form.Usucodigo2_F>
	
	<cfif isdefined("form.DEid")>	
		<cfset form.DEid_F = form.DEid>
	</cfif>
	<cfset form.DEid = form.DEid_F>
	
	<cfif Attributes.Tipo EQ 6>
		<cfset label="#LB_NumAnticipo#">
		<cfset labels="#LB_NumAnticipos#">
	<cfelseif Attributes.Tipo EQ 7>
		<cfset label="#LB_NumLiquidacion#">
		<cfset labels="#LB_NumLiquidaciones#">
	<cfelseif Attributes.Tipo EQ 8>
		<cfset label="#LB_NumTransaccion#">
		<cfset labels="#LB_NumTransacciones#">
	<cfelseif Attributes.Tipo EQ 9 >
		<cfset label="#LB_NumTransaccion#">
		<cfset labels="#LB_NumTransacciones#">
	<cfelseif Attributes.Tipo EQ 16 >
		<cfset label="#LB_NumComision#">
		<cfset labels="#LB_NumComisiones#">
	</cfif>
<table width="100%" border="0" cellspacing="6">
		<tr>
			<td width="50%" valign="top">
			<form name="formFiltro" method="post" action="<cfoutput>#Attributes.IrA#</cfoutput>" style="margin: '0' ">
			<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
		<tr>
<!--------------------FILTRO DE CENTRO FUNCIONAL--->
			<td nowrap align="right"><strong><cfoutput>#LB_CentroFuncional#</cfoutput>:</strong></td>
			<td nowrap>	
					<cf_cboCFid form="formFiltro" todos="yes">
					<cfset form.CFid_F = session.Tesoreria.CFid>
			</td>
<!---------------------FILTRO DE SOLICITANTE                                        --->				
			<td nowrap align="right"><strong><cfoutput>#LB_Solicitante#</cfoutput>:</strong></td>
			<td colspan="2">
            <cfif isdefined ('form.Usucodigo') and len(trim(form.Usucodigo)) gt 0>
				<!---<cfif #Attributes.PorSolicitante#>--->
                    <!---<cfquery name="rsUsuario" datasource="#session.dsn#">
                        select u.Usucodigo, u.Usulogin
                            , dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre
                          from Usuario u 
                            inner join DatosPersonales dp
                               on dp.datos_personales = u.datos_personales
                         where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                    </cfquery>
                    <cfoutput>
                        &nbsp;#rsUsuario.Usunombre#
                    </cfoutput>
                <cfelseif form.UsucodigoSP_F EQ "" OR NOT (LvarSAporComision and isdefined("url._"))>
                    <cf_sifusuario conlis="true" size="20" form="formFiltro" >			
                <cfelse>
                    <cfinclude template="../../Utiles/sifConcat.cfm">
                    <cfquery name="rsSQL" datasource="#session.dsn#">
                        select u.Usucodigo, u.Usulogin
                            , dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre
                          from Usuario u 
                            inner join DatosPersonales dp
                               on dp.datos_personales = u.datos_personales
                         where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.UsucodigoSP_F#">
                    </cfquery>
                    <cf_sifusuario conlis="true" size="20" form="formFiltro" query="#rsSQL#" readonly="#Attributes.PorEmpleado AND NOT LvarSAporComision#">--->
                    <cfinclude template="../../Utiles/sifConcat.cfm">
							<cfquery name="rsSQL" datasource="#session.dsn#">
								select u.Usucodigo, u.Usulogin
                            , dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre
                          from Usuario u 
                            inner join DatosPersonales dp
                               on dp.datos_personales = u.datos_personales
                         where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
							</cfquery>
						<cf_sifusuario conlis="true" size="20" form="formFiltro" query="#rsSQL#">	
					<cfelse>
						<cf_sifusuario conlis="true" size="20" form="formFiltro">
                </cfif>
			</td>
		</tr>										
		<tr>
<!-------------------FILTRO DE EMPLEADO--->
			<td nowrap align="right"><strong><cfoutput>#LB_Empleado#</cfoutput>:</strong></td>
			<td nowrap>	
			<!---<cfif isdefined('form.DEid') and len(trim(form.DEid)) and form.DEid NEQ "">					
				<cf_rhempleados form="formFiltro" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2" idempleado="#form.DEid#" readonly="#Attributes.PorEmpleado#">
			<cfelse>
				<cf_rhempleados form="formFiltro" tabindex="1" DEid="DEid" Usucodigo="Usucodigo2">
				</cfif>--->
				<cf_conlis title=""<!---#LB_ListaEmpleados#--->
					campos = "DEid, DEidentificacion, DEnombreTodo" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,15,34"
					asignar="DEid, DEidentificacion, DEnombreTodo"
					asignarformatos="S,S,S"
					tabla="DatosEmpleado"
					columnas="DEid, DEidentificacion, DEnombre +' '+ DEapellido1 +' '+ DEapellido2 as DEnombreTodo,DEnombre,DEapellido1,DEapellido2"
					filtro="Ecodigo = #Session.Ecodigo#"
					desplegar="DEidentificacion, DEnombre,DEapellido1,DEapellido2"
					etiquetas=""<!---#LB_Identificacion#,#LB_Nombre#,#LB_ApellidoPaterno#,#LB_ApellidoMaterno#--->
					formatos="S,S,S,S"
					align="left,left,left,left"
					showEmptyListMsg="true"
					EmptyListMsg=""
					form="formFiltro"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="DEidentificacion,DEnombre,DEapellido1,DEapellido2"
					index="1"			
					fparams="DEid"
					/>        
			</td>			
<!-------------------FILTRO DE FECHA--->				
			<td nowrap align="right"><strong><cfoutput>#LB_Fecha#</cfoutput>:</strong></td>
			<td colspan="2">
				<table cellpadding="0" cellspacing="0" border="0">
					  <tr>
						<td nowrap valign="middle">
						<cf_sifcalendario form="formFiltro" value="#form.TESSPfechaPago_I#" name="TESSPfechaPago_I" tabindex="1">											  					  	</td>
						<td nowrap align="right" valign="middle"><strong>&nbsp;<cfoutput>#LB_Hasta#</cfoutput>:</strong></td>
						<td nowrap valign="middle">
						<cf_sifcalendario form="formFiltro" value="#form.TESSPfechaPago_F#" name="TESSPfechaPago_F" tabindex="1">									 						</td>
					  </tr>
					</table>
			</td>
		</tr>		
		<tr>
<!-----------------FILTRO DE NU. ANTICIPO o LIQUIDACIÓN--->
			<td nowrap align="right"><strong><cfoutput>#label#:</cfoutput></strong></td>
			<td nowrap>
			<cfif Attributes.Tipo EQ 9 >
				<cfif isdefined("url._")>
					<cf_navegacion name="TipoTransaccion" value="" session>
				<cfelse>
					<cf_navegacion name="TipoTransaccion" default="" session>
				</cfif>
				<select name="TipoTransaccion">
					<option value="">(<cfoutput>#LB_CualquierTipo#</cfoutput>)</option>
					<option value="ANTICIPO" <cfif form.TipoTransaccion EQ "ANTICIPO">selected</cfif>><cfoutput>#LB_SolicitudAnticipos#</cfoutput></option>
					<option value="COMISION" <cfif form.TipoTransaccion EQ "COMISION">selected</cfif>><cfoutput>#LB_SolicitudComision#</cfoutput></option>
					<option value="GASTO"    <cfif form.TipoTransaccion EQ "GASTO">   selected</cfif>><cfoutput>#LB_LiquidacionGastos#</cfoutput></option>
				</select>
			</cfif>
				<input type="text" name="numAnti" />
			</td>							
<!-----------------FILTRO DE MONEDA--->				
			<td nowrap align="right"><strong><cfoutput>#LB_Moneda#</cfoutput></strong></td>
			<td colspan="2">
					<cfquery name="rsMonedas" datasource="#session.DSN#">
						select Mcodigo, Mnombre
						  from Monedas m 
						  where m.Ecodigo = #session.Ecodigo#
					</cfquery>	
					<select name="McodigoOri_F" tabindex="1" onchange="this.form.submit();">
						<option value="">(<cfoutput>#LB_TodasLasMonedas#</cfoutput>)</option>
						<cfoutput query="rsMonedas">
						<option value="#Mcodigo#" <cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F)) and form.McodigoOri_F EQ Mcodigo>selected</cfif>>#Mnombre#</option>
						</cfoutput>
					</select>	
			</td>
		</tr>
		<cfif LvarSAporComision or Attributes.Tipo EQ 9>
		<tr>
<!-----------------FILTRO DE NUMERO COMISION--->
			<td nowrap align="right"><strong><cfoutput>#LB_NumComision#:</cfoutput></strong></td>
			<td nowrap>
				<input type="text" name="numComision" />
			</td>
		</tr>
		</cfif>
<!-----------------FILTRAR--->		
		<tr>
			<td ></td>
			<td ><div align="right">
			         <input name="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>" tabindex="2" />				   
	             </div>
			</td>
		</tr>
		</table>
<!-----------------FILTRO ANTICIPOS CANCELADOS--->	
			<cfif #Attributes.ListarCancelados#>
				<input type="checkbox" name="chkCancelados"
				<cfif isdefined("form.chkCancelados")>checked</cfif>
				onclick="if (this.checked && this.form.chkCerrados) {this.form.chkCerrados.checked=false};this.form.submit();"
				tabindex="1"
				> <cfoutput>#LB_ListarCancelados#</cfoutput>&nbsp;&nbsp;&nbsp;
			</cfif>
			<cfif Attributes.Tipo EQ 6 AND LvarSAporComision>
				<input type="checkbox" name="chkCerrados"
				<cfif isdefined("form.chkCerrados")>checked</cfif>
				onclick="if (this.checked && this.form.chkCancelados) {this.form.chkCancelados.checked=false};this.form.submit();"
				tabindex="1"
				> <cfoutput>#LB_ListarComisionesCerradas#</cfoutput>
			</cfif>
			<cfset LvarPrimera = false>				
		</form>
		<cfif FALSE AND LvarPrimera>
			</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center" bgcolor="#CCCCCC">
					<strong><cfoutput>#MSG_LaListaNoHaSidoFiiltrada#</cfoutput></strong><BR>
					<cfoutput>#MSG_AsegureseDeQueHayaSeleccionadoLosFiltrosAdecuadosAntesDePresionar#</cfoutput><strong><cfoutput>#BTN_Filtrar#</cfoutput></strong>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</table>
			<cfabort>
		<cfelse>
			<cfif isdefined("form.chkCancelados")>
				<cfset LvarMSGrechazo = "#LB_MotivoCancelacion#">
			<cfelseif Attributes.Tipo NEQ "">
				<cfset LvarMSGrechazo = "#LB_MotivoRechazoAnterior#">
			<cfelse>
				<cfset LvarMSGrechazo = "#LB_MotivoRechazo#">
			</cfif>

			<cfif #Attributes.Tipo# EQ 6><!---Anticipos--->
						<cfinclude template="GE_lista_ANTICIPO.cfm">
			<cfelseif Attributes.Tipo EQ 7><!---Liquidaciones--->
						<cfinclude template="GE_lista_GASTO.cfm">
			<cfelseif #Attributes.Tipo# EQ 8><!---Todas--->
						<cfinclude template="GE_lista_CUSTODIO.cfm">
			<cfelseif Attributes.Tipo EQ 9> <!---Transacciones de Usuario--->
						<cfinclude template="GE_lista_TRANSACCION.cfm">
			<cfelseif #Attributes.Tipo# EQ 16><!---Anticipos Comision--->
						<cfinclude template="GE_lista_ANTICIPO.cfm">
			<cfelseif Attributes.Tipo EQ 17><!---Liquidaciones Comision--->
						<cfinclude template="GE_lista_GASTO.cfm">
			<cfelse>
				<cfoutput><div align="center">#MSG_AunNoHayUnaListaImplementadaParaElTipo# #Attributes.Tipo#</div></cfoutput>
			</cfif>		
		</cfif>
	</td>
  </tr>
</table>

<iframe name="ifrDescripcion" id="ifrDescripcion" src="" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" >
</iframe>
<script language="javascript">
	function sbVer(TESSPid)
	{
		var LvarIframe = document.getElementById("ifrDescripcion");
		<cfoutput>
		LvarIframe.src = "#Attributes.IrA#?sbVer=1&SP=" + TESSPid;
		</cfoutput>
		document.lista.nosubmit = true;		
	}
</script>




