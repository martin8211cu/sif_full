<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TransferenciasBancarias" default="Transferencias Bancarias" returnvariable="LB_TransferenciasBancarias" xmlfile="Transferencias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TransferenciasCuentas" default="Transferencias entre Cuentas" returnvariable="LB_TransferenciasCuentas" xmlfile="Transferencias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" returnvariable="LB_Documento" xmlfile="Transferencias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" xmlfile="Transferencias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" xmlfile="Transferencias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Monto" default="Monto" returnvariable="LB_Monto" xmlfile="Transferencias.xml"/>

<cf_templateheader title="#LB_TransferenciasBancarias#">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">						
				<!--- APLICACION DESDE LA LISTA--->						
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
					<cflocation addtoken="no" url="listaTransferencias.cfm">
				</cfif>	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TransferenciasCuentas#'>
			<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
			<div align="center">				
              <table border="0" width="100%" align="center" cellpadding="0" cellspacing="0">
                <tr> 
                  <td> 
				  	<cfoutput> 
                      <table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##DFDFDF">
						<tr align="left"> 
							<td><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
						 </tr>
                      </table>
                    </cfoutput> </td>
                </tr>
                <tr> 
                  <td align="center"> <cfinclude template="formTransferencias.cfm"> </td>
                </tr>
                <tr> 
                  <td align="center">
				  <div align="center"> 
                  	<cfif isdefined('Form.ETid') and Form.ETid NEQ "" and (not isdefined('form.modo') or form.modo eq 'CAMBIO')>
						<cfinvoke 
									 component="sif.Componentes.pListas"
									 method="pListaRH"
									 returnvariable="pListaRet">
                            <cfinvokeargument name="tabla" value="DTraspasos a"/>
                            <cfinvokeargument name="columnas" value="ETid, DTid, a.DTdocumento,CBidori, CBiddest, BTidori, a.BTiddest, a.DTmontoori, a.DTmontodest,
																				 (select b.CBcodigo from CuentasBancos b where b.CBid = a.CBidori and b.CBesTCE = 0 and Ecodigo = #session.Ecodigo#) as CBDidori,
																				 (select b.CBcodigo from CuentasBancos b where b.CBid = a.CBiddest and b.CBesTCE = 0 and Ecodigo = #session.Ecodigo#) as CBDiddest,
																				 (select d.Mnombre from CuentasBancos b, Monedas d where b.CBid = a.CBidori and b.CBesTCE = 0 and b.Mcodigo=d.Mcodigo and b.Ecodigo = #session.Ecodigo#) as oriMcodigo,
																				 (select d.Mnombre from CuentasBancos b, Monedas d where b.CBid = a.CBiddest and b.CBesTCE = 0 and b.Mcodigo=d.Mcodigo and b.Ecodigo = #session.Ecodigo#) as destMcodigo"/>
                            <cfinvokeargument name="desplegar" value="DTdocumento,CBDidori, oriMcodigo, DTmontoori, CBDiddest, destMcodigo, DTmontodest"/>
                            <cfinvokeargument name="etiquetas" value="#LB_Documento#, #LB_Cuenta#, #LB_Moneda#, #LB_Monto#, #LB_Cuenta#, #LB_Moneda#, #LB_Monto#"/>
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
