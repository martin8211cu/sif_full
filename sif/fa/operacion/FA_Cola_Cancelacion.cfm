<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Header" default="Facturaci&oacute;n" returnvariable="LB_Header"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cancelacion" default="" returnvariable="LB_Cancelacion" />
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CentroFuncionalDefault" default="Centro Funcional Default" returnvariable="LB_CentroFuncionalDefault" />
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentaDefault" default="Cuenta Default" returnvariable="LB_CuentaDefault" />
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SeleccionarTodos" default="Seleccionar Todos" returnvariable="LB_SeleccionarTodos" />
<!--- Sentencias para mantener el filtro de la Lista --->
<cfquery name="rsExisteVersion" datasource="#session.DSN#">
	select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 17200
</cfquery>

<cfparam name="Navegacion" default="">
<cfparam name="Registros" default="20">
<cfparam name="url.PageNum_lista" default="">
<cf_templateheader title="#LB_Header#">
	<cf_templatecss>
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Cancelacion#">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<cfinclude template="../../portlets/pNavegacion.cfm">
				</td>
			</tr>
			<tr align="center">
				<td  valign="top">
				<cfset session.validaCanc = 1>
				
						<!--- Filtro para la lista --->
						<!---RFC DEL EMISOR
						<input name="Actualizar" type="button" class="" value="Actualiza Estatus" onClick="javascript: funcActualizaEstatus(this.form); "> 
						<cfquery name="rsEmpresa" datasource="#session.dsn#">
							select  a.Eidentificacion 
							from Empresa a
								INNER JOIN Direcciones b
									on a.id_direccion = b.id_direccion
							where a.Ecodigo = #session.Ecodigosdc#
						</cfquery>
						<cfset rfcEmisor = rsEmpresa.Eidentificacion>
						<!---Iniciamos componente para verificar con Konesh el estatus de la cancelación --->
						<cftransaction>
        					<cfinvoke component="sif.Componentes.FA_CancelacionFactura"
							method="EstatusCancelacionKonesh"	
                            RfcEmisor = "#rfcEmisor#"
							Ecodigo = "#Session.Ecodigo#"
							usuario = "#Session.usuario#"
							USA_tran = "true"
						/> 
        				</cftransaction>--->
						<cfquery name="rsPF" datasource="#session.dsn#">
								select  Ddocumento, CCTcodigo, SNnombre, Tipo, Estado ,Estatus, Motivo, Aplicado, FechaCancelado from ColaCancelacionFactura 
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								<cfif isDefined('form.PFdocumento') and documentoN neq "">
									and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#documentoN#">
								<cfelse>
									 and SNcodigo = 
									<cfif isdefined('Form.SNcodigo') and len(trim(form.SNcodigo))>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
									<cfelse>
									SNcodigo
									</cfif>
								</cfif>
								ORDER BY SNnombre ASC, FechaCancelado ASC
						</cfquery>
						<input name="SNegocios"			id="SNegocios" 			type="hidden" value="<cfoutput>#rsPF.SNnombre#</cfoutput>">

						
						<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsPF#"/>
								<cfinvokeargument name="desplegar" value="Ddocumento, CCTcodigo, SNnombre, Tipo, Estado, Estatus, Motivo, Aplicado, FechaCancelado"/>
								<cfinvokeargument name="etiquetas" value="Documento, Transaccion, Socio, Tipo, Estado ,Estatus, Motivo, Aplicado, FechaCancelado"/>
								<cfinvokeargument name="formatos" value="S, S, S, S, S, S, S, S, S"/>
                                <cfinvokeargument name="cortes" value="SNnombre"/>
								<cfinvokeargument name="align" value="left, left, left, left, left, left,left,left,left"/>
								<cfinvokeargument name="ajustar" value="N, N, N, N, N"/>
								<cfinvokeargument name="keys" value="Ddocumento"/>
								<cfinvokeargument name="radios" value="N"/>
								<cfinvokeargument name="showlink" value="false"/>
								<cfinvokeargument name="includeForm" value="false"/>
								<cfinvokeargument name="formName" value="frListaPF"/>
								<cfinvokeargument name="showemptylistmsg" value="true"/>
                                <cfinvokeargument name="inactivecol" value=""/>
                                <cfinvokeargument name="MaxRows" value="#Registros#"/>
			                    <cfinvokeargument name="Navegacion" value="#Navegacion#"/>
						</cfinvoke>
						
					</form>
        			
						<form name = "ActualizaEstatus" action="FA_Cola_Cancelacion.cfm" method="POST">
						<a onClick="funcActualizaEstatus()">		<img src="/cfmx/sif/imagenes/all.gif"	border="0" style="cursor:pointer" class="" title="Actualiza Estatus"></a>
						</form>
				
				</td>
			</tr>
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript1.2" type="text/javascript">
function funcActualizaEstatus(){     			
				window.open("/cfmx/sif/tasks/facturas/CancelacionFacturas.cfm", 'mywindow','location=1, align= absmiddle,status=1,scrollbars=1, top=100, left=100 width=500,height=500');		
				document.ActualizaEstatus.action = "FA_Cola_Cancelacion.cfm";
				document.ActualizaEstatus.submit();		
}
</script>