<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
<cfset LobjColaProcesos.fnActivarMotor (session.CEcodigo,".")>
<cfquery name="rsMotor" datasource="sifinterfaces">
	select Activo, urlServidorMotor, spFinalTipo, spFinal, MsgError, FechaActividad, FechaActivacion
		, Bitacora_S_AP, Bitacora_S_FP, Bitacora_S_DE, Bitacora_D_AP, Bitacora_D_FP, Bitacora_D_DE, Bitacora_A_IP, Bitacora_A_AT, Bitacora_A_AI, Bitacora_A_AP, Bitacora_A_FP, Bitacora_A_DE
	from InterfazMotor
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
</cfquery>
<cfquery name="rsCE" datasource="asp">
	select CEaliaslogin
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
</cfquery>
<!--- Determina si se ha utilizado localhost, y cual es el host y localhost --->
<cfset LvarLocal = find('/localhost:0/',rsMotor.urlServidorMotor) GT 0>
<cfset LvarHost = rsMotor.urlServidorMotor>
<cfif trim(LvarHOST) EQ "">
	<cfset LvarHost = "http://SERVER:PORT/cfmx/">
</cfif>
<cfset LvarLocalhost = "localhost:0">

<cfif rsMotor.Activo NEQ 0>
	<cfinclude template="motor.cfm">
</cfif>
<br>
<form action="parametrosMotor-sql.cfm" method="post" name="frmMotor" style="border:0; margin:0 ">
	<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<cfoutput>
		<cfif rsMotor.Activo EQ 0>
			<tr>
				<td nowrap="nowrap" style="font-weight:bold; text-align:right">
					Estado del Motor:
				</td>
				<td>&nbsp;
					
				</td>
				<td>
					<font style = "color: ##FF0000">Inactivo <cfif rsMotor.MsgError NEQ "">: #rsMotor.MsgError#</cfif></font>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold; text-align:right">
					Url Servidor: 
				</td>
				<td>&nbsp;
					
				</td>
				<td>
						<input 	type="text" name="urlServidorMotor" size="60" 
						<cfif LvarLocal>
							readonly="true"
							value="http://#LvarLocalhost#/cfmx/"
						<cfelse> 
							value="#LvarHost#" 
						</cfif>
							onblur="return sbUrlServidor(this);"
					>
					&nbsp;
					<input type="checkbox" name="localhost" value="1"
							onclick="if (this.checked) {this.form.urlServidorMotor.value = 'http://#LvarLocalhost#/cfmx/'; this.form.urlServidorMotor.readOnly = true;} else {this.form.urlServidorMotor.value = 'http://SERVER:PORT/cfmx/'; this.form.urlServidorMotor.readOnly = false; this.form.urlServidorMotor.select(); this.form.urlServidorMotor.focus();}"
							<cfif LvarLocal>checked</cfif>
					>
					Utilizar <strong>localhost</strong> (para ambientes de desarrollo)
				</td>
			</tr>
			<tr>
				<td colspan="3">&nbsp;
					
				</td>
			</tr>
			<tr>
				<td colspan="3" align="center" style="font-weight:bold; border-top:1px solid ##CCCCCC">
					Procesamiento Final
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold; text-align:right;">
					Tipo: 
				</td>
				<td>&nbsp;
					
				</td>
				<td>
					<select name="spFinalTipo">
						<option value="S">StoreProcedure Base Datos</option>
						<option value="C">Componente Coldfusion</option>
					</select>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold; text-align:right">
					Nombre: 
				</td>
				<td>&nbsp;
					
				</td>
				<td>
					<input type="text" name="spFinal" size="60" value="#rsMotor.spFinal#">
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold; text-align:right;">
					Parámetros: 
				</td>
				<td>&nbsp;
					
				</td>
				<td style="font-family:'Courier New', Courier, mono; font-size:11px;">
					(NumeroInterfaz, IdProceso)
				</td>
			</tr>
			<tr>
				<td colspan="3">&nbsp;
					
				</td>
			</tr>
			<tr>
				<td colspan="3" align="center" style="font-weight:bold; border-top:1px solid ##CCCCCC">
					<cfset fnBitacora()>
				</td>
			</tr>
			<tr>
				<td colspan="3" align="center">
					<input type="submit" name="Cambiar" value="Cambiar" />
					<input type="submit" name="Activar" value="Activar" />
				</td>
			</tr>
		<cfelse>
			<tr>
			<tr>
				<td colspan="3">&nbsp;
					
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold; text-align:right">
					Url Servidor: 
				</td>
				<td>&nbsp;
					
				</td>
				<td style="font-family:'Courier New', Courier, mono; font-size:11px;border-top:1px solid ##CCCCCC;border-bottom:1px solid ##CCCCCC">
					<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
					#LobjColaProcesos.fnUrlLocalhost (rsMotor.urlServidorMotor, true)#
				</td>
			</tr>
		</cfif>
		<cfif rsMotor.Activo EQ 1 and isdefined("LvarActivarMotor")>
			<tr>
				<td style="font-weight:bold; text-align:right;">
					WebService: 
				</td>
				<td>&nbsp;
					
				</td>
				<td style="font-family:'Courier New', Courier, mono; font-size:11px;border-bottom:1px solid ##CCCCCC">
					interfazToSoin('#rsMotor.urlServidorMotor#interfacesSoin/webService/interfaz-service.cfm', '#rsCE.CEaliasLogin#', '#session.EcodigoSDC#', '&LT;UID_SIF&GT;','&LT;PWD_SIF&GT;','&LT;NUM_INTERFAZ&GT;','&LT;ID_PROCESO&GT;')
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold; text-align:right">
					WebServiceXML: 
				</td>
				<td>&nbsp;
					
				</td>
				<td style="font-family:'Courier New', Courier, mono; font-size:11px;border-bottom:1px solid ##CCCCCC">
					interfazToSoinXML('#rsMotor.urlServidorMotor#interfacesSoin/webService/interfaz-service.cfm', '#rsCE.CEaliasLogin#', '#session.EcodigoSDC#', '&LT;UID_SIF&GT;','&LT;PWD_SIF&GT;','&LT;NUM_INTERFAZ&GT;','&LT;XML_IE&GT;','&LT;XML_ID&GT;','&LT;XML_IS&GT;',&LT;DEVOLVER_XML_OUT 0 ó 1&GT;)
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold; text-align:right">
					WebServiceSQL: 
				</td>
				<td>&nbsp;
					
				</td>
				<td style="font-family:'Courier New', Courier, mono; font-size:11px;border-bottom:1px solid ##CCCCCC">
					interfazToSoinSQL('#rsMotor.urlServidorMotor#interfacesSoin/webService/interfaz-service.cfm', '#rsCE.CEaliasLogin#', '#session.EcodigoSDC#', '&LT;UID_SIF&GT;','&LT;PWD_SIF&GT;','&LT;NUM_INTERFAZ&GT;','&LT;SQL_IE&GT;','&LT;SQL_ID&GT;','&LT;SQL_IS&GT;',&LT;DEVOLVER_XML_OUT 0 ó 1&GT;)
				</td>
			</tr>
			<tr>
				<td nowrap style="font-weight:bold; text-align:right">
					Scheduled&nbsp;Task: 
				</td>
				<td>&nbsp;
					
				</td>
				<td nowrap="nowrap" style="font-family:'Courier New', Courier, mono; font-size:11px;border-bottom:1px solid ##CCCCCC">
					Tarea Asincrona Motor Interfaces CE=#session.CEcodigo#: #LobjColaProcesos.fnUrlLocalhost (rsMotor.urlServidorMotor)#interfacesSoin/tareaAsincrona/activarCola.cfm?CE=#session.CEcodigo#
				</td>
			</tr>
			<tr>
				<td nowrap style="font-weight:bold; text-align:right">
					Procesamiento&nbsp;Final: 
				</td>
				<td>&nbsp;
					
				</td>
				<td nowrap="nowrap" style="font-family:'Courier New', Courier, mono; font-size:11px; height:22px;;border-bottom:1px solid ##CCCCCC">
					<cfif rsMotor.spFinalTipo EQ "S">StoreProcedure:</cfif>
					<cfif rsMotor.spFinalTipo EQ "C">Componente Coldfusion:</cfif>
					<font style="font-family:'Courier New', Courier, mono;">
					#rsMotor.spFinal# (NumeroInterfaz, IdProceso)
					</font>
				</td>
			</tr>
			<tr>
				<td nowrap style="font-weight:bold; text-align:right;">
					Bitácora Coldfusion:
				</td>
				<td>&nbsp;</td>
				<td nowrap="nowrap" style="font-family:'Courier New', Courier, mono; font-size:11px; height:22px;">
					#expandPath("/WEB-INF/cfusion/logs/")#InterfacesSoin#DateFormat(now(),"YYYYMMDD")#.log
				</td>
			</tr>
				<td colspan="2">&nbsp;</td>
				<td nowrap="nowrap" style="font-family:'Courier New', Courier, mono; font-size:11px;">
					<input type="button" value="Download Log" onclick="sbDownloadLog();">
				</td>
			<tr>
				<td colspan="2">&nbsp;</td>
				<td nowrap="nowrap" style="font-family:'Courier New', Courier, mono; font-size:11px;border-bottom:1px solid ##CCCCCC">
					<cfset fnBitacora()>
				</td>
			<tr>
				<td colspan="3" align="center">
					<cfif LobjColaProcesos.fnMismoServidor(rsMotor.urlServidorMotor)>
					<input type="submit" name="CambiarLog" value="Cambiar" />
					<input type="submit" name="Inactivar" value="Inactivar" 
						 onclick="return confirm('Si el Motor de Interfaces está Inactivo, todas las invocaciones Externas darán error, y las originadas desde SOIN SIF se ejecutarán sin sincronizar ¿Desea inactivar el motor de Interfaces?')"
					/>
					<cfelse>
						<br>
						<font color="##FF0000"><strong>No se permite Administrar Remotamente. Debe concetarse a '#rsMotor.urlServidorMotor#'</strong></font>	
					</cfif>
				</td>
			</tr>
		</cfif>
		</cfoutput>
	</table>
</form>
<script language="javascript">
	function sbDownloadLog()
	{
		window.open("parametrosMotor.cfm?log=1", "_self");
	}
	function sbUrlServidor(o)
	{
		var n = o.value.length; 
		if (o.value.substr(0,7) != 'http://') 
			o.value = 'http://' + o.value; 
		if (o.value.substr(n-6,6) != '/cfmx/') 
			o.value = o.value + '/cfmx/';
		if (o.value.indexOf("//localhost")>=0 && (o.value != "http://localhost:0/cfmx/") )
		{
			alert('No se permite utilizar localhost');
			o.value = "http://SERVER:PORT/cfmx/";
			return false;
		}
		return true;
	}	
</script>
<br>
<cffunction name="fnBitacora" output="true">
							<table align="center" cellpadding="0" cellspacing="0">
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td>&nbsp;</td>
									<td colspan="3" nowrap="nowrap" style="font-size:11px;">
										<strong>PROCESOS A REGISTRAR EN BITÁCORA COLDFUSION&nbsp;&nbsp;</strong>
									</td>
									<td>&nbsp;</td>
								</tr>

								<tr><td>&nbsp;</td></tr>
								<cfset fnOpcionBitacora("Procesos Asincrónicos","")>
								<cfset fnOpcionBitacora("&nbsp;&nbsp;&nbsp;&nbsp;Inclusión en la Cola","Bitacora_A_IP")>
								<cfset fnOpcionBitacora("&nbsp;&nbsp;&nbsp;&nbsp;Activación Tarea Asíncrona","Bitacora_A_AT")>
								<cfset fnOpcionBitacora("&nbsp;&nbsp;&nbsp;&nbsp;Activación Cola por tipo de  Interfaz","Bitacora_A_AI")>
								<cfset fnOpcionBitacora("&nbsp;&nbsp;&nbsp;&nbsp;Activación Proceso","Bitacora_A_AP")>
								<cfset fnOpcionBitacora("&nbsp;&nbsp;&nbsp;&nbsp;Finalización Proceso","Bitacora_A_FP")>
								<tr><td>&nbsp;</td></tr>
								<cfset fnOpcionBitacora("Procesos Sincrónicos","")>
								<cfset fnOpcionBitacora("&nbsp;&nbsp;&nbsp;&nbsp;Activación Proceso","Bitacora_S_AP")>
								<cfset fnOpcionBitacora("&nbsp;&nbsp;&nbsp;&nbsp;Finalización Proceso","Bitacora_S_FP")>
								<tr><td>&nbsp;</td></tr>
								<cfset fnOpcionBitacora("Procesos Directos","")>
								<cfset fnOpcionBitacora("&nbsp;&nbsp;&nbsp;&nbsp;Activación Proceso","Bitacora_D_AP")>
								<cfset fnOpcionBitacora("&nbsp;&nbsp;&nbsp;&nbsp;Finalización Proceso","Bitacora_D_FP")>
							</table>
</cffunction>
<cffunction name="fnOpcionBitacora" output="true">
	<cfargument name="Texto" 	required="yes" type="string">
	<cfargument name="Opcion" 	required="yes" type="string">
	
	<cfif Arguments.Opcion NEQ "SI" AND Arguments.Opcion NEQ "">
		<cfparam name="rsMotor.#Arguments.Opcion#" default="0">
	</cfif>
	<cfoutput>
								<tr>
									<td>&nbsp;</td>
									<td nowrap="nowrap" style="font-size:11px;">
										#Arguments.Texto#
									</td>
									<td>&nbsp;</td>
									<td align="center">
									<cfif Arguments.Opcion EQ "SI">
										SI								
									<cfelseif Arguments.Opcion NEQ "">
										<input 	type="checkbox" value="1"
												name="#Arguments.Opcion#"
												id="#Arguments.Opcion#"
												<cfif evaluate("rsMotor.#Arguments.Opcion#") EQ 1>
													checked="checked"
												</cfif>
										/>
									</cfif>
									</td>
									<td>&nbsp;</td>
								</tr>
	</cfoutput>
</cffunction>
