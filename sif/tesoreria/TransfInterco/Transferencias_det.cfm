<cf_templateheader title="Transferencias Bancarias Intercompañías">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">						<!--- APLICACION DESDE LA LISTA--->						
			<cfif isdefined("Form.chk") AND isdefined("form.btnAplicar") >
				<cfset datos = ArrayNew(1)>
				<cfloop index = "index" list = "#Form.chk#" delimiters = ",">
					<cfset i = 1>
					<cfloop index = "index" list = "#index#" delimiters = "|">
						<cfset datos[i] = index >
						<cfset i = i + 1>
					</cfloop>
					<cfinvoke component="sif.Componentes.CP_MBPosteoTransferencias" method="PosteoTransferencias">
						<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
						<cfinvokeargument name="ETid" value="#datos[1]#"/>				
						<cfinvokeargument name="usuario" value="#session.usucodigo#"/>	
						<cfinvokeargument name="LoginUsuario" value="#session.Usulogin#"/>		
						<cfinvokeargument name="debug" value="N"/>							
					</cfinvoke>	
				</cfloop>
				<cflocation addtoken="no" url="Transferencias.cfm">
			</cfif>	
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Transferencias Bancarias Intercompañías'>
			<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
				<div align="center">				
				  <table border="0" width="100%" align="center" cellpadding="0" cellspacing="0">
					<tr> 
					  <td align="center"> <cfinclude template="formTransferencias.cfm"> </td>
					</tr>
					<tr> 
					  <td align="center">
					  <div align="center"> 
						<cfif isdefined('Form.ETid') and Form.ETid NEQ "">
							<cfinvoke 
										 component="sif.Componentes.pListas"
										 method="pListaRH"
										 returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="DTraspasos a"/>
								<cfinvokeargument name="columnas" value="ETid, DTid, a.DTdocumento,CBidori, CBiddest, BTidori, a.BTiddest, a.DTmontoori, a.DTmontodest,
																					 (select b.CBcodigo from CuentasBancos b where b.CBid = a.CBidori and Ecodigo = #session.Ecodigo# and b.CBesTCE = 0) as CBDidori,
																					 (select b.CBcodigo from CuentasBancos b where b.CBid = a.CBiddest and Ecodigo = #session.Ecodigo# and b.CBesTCE = 0) as CBDiddest,
																					 (select d.Mnombre from CuentasBancos b, Monedas d where b.CBid = a.CBidori and b.Mcodigo=d.Mcodigo and b.Ecodigo = #session.Ecodigo# and b.CBesTCE = 0) as oriMcodigo,
																					 (select d.Mnombre from CuentasBancos b, Monedas d where b.CBid = a.CBiddest and b.Mcodigo=d.Mcodigo and b.Ecodigo = #session.Ecodigo# and b.CBesTCE = 0) as destMcodigo"/>
								<cfinvokeargument name="desplegar" value="DTdocumento,CBDidori, oriMcodigo, DTmontoori, CBDiddest, destMcodigo, DTmontodest"/>
								<cfinvokeargument name="etiquetas" value="Documento, Cuenta, Moneda, Monto, Cuenta, Moneda, Monto"/>
								<cfinvokeargument name="formatos" value="V, V, V, M, V, V, M"/>
								<cfinvokeargument name="filtro" value=" a.ETid = #form.ETid#" />
								<cfinvokeargument name="align" value="left, left, left, right, center, left, right"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="n"/>
								<cfinvokeargument name="irA" value="Transferencias.cfm"/>
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
								<cfinvokeargument name="keys" value="DTid,ETid"/>
							</cfinvoke>
						<cfelse>
							<cfif not isdefined('Form.btnNuevo')>
								<!---cfinclude template="listaTransferencias.cfm"--->
								<cflocation addtoken="no" url='listaTransferencias.cfm'>
							</cfif>
						</cfif>
						</div>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				  </table>	
				</div>
	<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>