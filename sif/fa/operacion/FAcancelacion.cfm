<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Header" default="Facturaci&oacute;n" returnvariable="LB_Header"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cancelacion" default="" returnvariable="LB_Cancelacion" />
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CentroFuncionalDefault" default="Centro Funcional Default" returnvariable="LB_CentroFuncionalDefault" />
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentaDefault" default="Cuenta Default" returnvariable="LB_CuentaDefault" />
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SeleccionarTodos" default="Seleccionar Todos" returnvariable="LB_SeleccionarTodos" />
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_Cancelar" default="Desea CANCELAR la factura seleccionada?" returnvariable="MSG_Cancelar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DebeSeleccionar" default="Debe seleccionar al menos una factura antes de cancelar" returnvariable="MSG_DebeSeleccionar" />
<!--- Sentencias para mantener el filtro de la Lista --->
<cfquery name="rsExisteVersion" datasource="#session.DSN#">
	select Pvalor from Parametros where Pcodigo = 17200
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
						<!--- Filtro para la lista --->
						<cfinclude template="FAcancelacion-filtro.cfm">
       					<form style="margin: 0" action="FAcancelacion-sql.cfm" name="frListaPF" method="post" id="frListaPF">
						   <cfset documentoN=""> 
							<cfif isDefined('form.PFdocumento')>
								<cfset documentoN="#trim(form.PFdocumento)#"> 
							</cfif>
							<cfquery name="rsTransacc" datasource="#session.dsn#">
									SELECT DISTINCT CCTcodigoRef from FAPFTransacciones
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							</cfquery>

						<cfquery name="rsPF" datasource="#session.dsn#">
								select distinct	s.SNcodigo, a.Ddocumento, a.CCTcodigo, s.SNnombre, m.ClaveSAT, a.Dsaldo,a.Dfecha 
								from Documentos a 
								inner join Monedas m on (a.Ecodigo=m.Ecodigo and a.Mcodigo = m.Mcodigo) 
								inner join SNegocios s on (a.Ecodigo=m.Ecodigo and a.SNcodigo = s.SNcodigo)  
								--LEFT JOIN ColaCancelacionFactura fc ON (fc.Ecodigo = a.Ecodigo)
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								 and a.Dsaldo > 0.0
								 and a.Dsaldo >= a.Dtotal 
								 and (
									<cfloop  query="rsTransacc">
										a.CCTcodigo = '#rsTransacc.CCTcodigoRef#' or
									</cfloop>   
									 a.CCTcodigo = '' 
								)
								<!---Validamos que no exista en cola de cancelacion --->
								and (Not EXISTS
									(SELECT Ddocumento
										FROM ColaCancelacionFactura fc
										WHERE fc.Ddocumento = a.Ddocumento))
								<!---Validamos que no exista en cola de cancelacion --->
										
								<cfif isDefined('form.PFdocumento') and documentoN neq "">
									and fc.Estatus <> ''
									and a.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#documentoN#">
								<cfelse>
									 and a.SNcodigo = 
									<cfif isdefined('Form.SNcodigo') and len(trim(form.SNcodigo))>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
									<cfelse>
									a.SNcodigo
									</cfif>
								</cfif>
								ORDER BY SNnombre ASC, Dfecha DESC
						</cfquery>
						<input name="SNegocios"			id="SNegocios" 			type="hidden" value="<cfoutput>#rsPF.SNnombre#</cfoutput>">


						<cfquery name="rsMotivosCanc" datasource="sifcontrol">
							SELECT Id, CSATcodigo, CSATdescripcion 
							FROM CSAT_MotivoCanc 
							WHERE AceptadoCancel = 1
						</cfquery>
						<cfoutput>						
							<tr>												
								<td nowrap>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<b>Motivo de cancelaci&oacute;n:  </b>

									<select name="MCanc" id="MCanc">						
										<option value="">--Seleccione--</option>
										<cfloop query="rsMotivosCanc">
											<option value="#rsMotivosCanc.CSATcodigo#" ><cfoutput>#rsMotivosCanc.CSATcodigo#  - #rsMotivosCanc.CSATdescripcion#</cfoutput></option>
										</cfloop>
									</select>
								</td>
							</tr>
							<tr>
								<td colspan="3" valign="top">&nbsp;</td>
							</tr>
						</cfoutput>
						
						<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsPF#"/>
								<cfinvokeargument name="desplegar" value="Ddocumento, CCTcodigo, SNnombre,ClaveSAT,Dsaldo,Dfecha"/>
								<cfinvokeargument name="etiquetas" value="Documento, Transaccion, Socio, Moneda, Total, Fecha"/>
								<cfinvokeargument name="formatos" value="S, S, S, S, M, S"/>
                                <cfinvokeargument name="cortes" value="SNnombre"/>
								<cfinvokeargument name="align" value="left, left, left, left, right, center"/>
								<cfinvokeargument name="ajustar" value="N, N, N, N, N"/>
								<cfinvokeargument name="irA" value="FAcancelacion-sql.cfm"/>
								<cfinvokeargument name="keys" value="Ddocumento"/>
								<cfinvokeargument name="radios" value="S"/>
								<cfinvokeargument name="showlink" value="false"/>
								<cfinvokeargument name="includeForm" value="false"/>
								<cfinvokeargument name="botones" value="Cancelar_Factura"/>
								<cfinvokeargument name="formName" value="frListaPF"/>
								<cfinvokeargument name="showemptylistmsg" value="true"/>
                                <cfinvokeargument name="inactivecol" value=""/>
                                <cfinvokeargument name="MaxRows" value="#Registros#"/>
			                    <cfinvokeargument name="Navegacion" value="#Navegacion#"/>
						</cfinvoke>
						
					</form>
        			
				</td>
			</tr>
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript1.2" type="text/javascript">

	
	function funcCancelar_Factura(){

		if (document.getElementById("MCanc").value.length < 1){
			var mensaje = "Se presentaron los siguientes errores:\n";
			    mensaje += " - Debe seleccionar un valor para el campo Motivo de Cancelaci&oacute;n."
			alert(mensaje);
			return false;
			}
		
		if (document.frListaPF.chk) {

			var aplica = false;
			if (document.frListaPF.chk.value) {
				aplica = document.frListaPF.chk.checked;
				for (var i=0; i<document.frListaPF.chk.length; i++) {
					if (document.frListaPF.chk[i].checked) {
						aplica = true;
						return (confirm("<cfoutput>#MSG_Cancelar#</cfoutput>"));
					}
				}
				
			}else{
				
			}

		if (aplica) {
			if (aplica =! false)
			return (confirm("<cfoutput>#MSG_Cancelar#</cfoutput>"));
		} else {

			if (aplica == false)
			alert('<cfoutput>#MSG_DebeSeleccionar#</cfoutput>');
			return false;
		}
		
	}
	}


	

</script>