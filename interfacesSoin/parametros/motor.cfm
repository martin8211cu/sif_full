<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
<cfset rsMotorEnc = LobjColaProcesos.fnActivarMotor (session.CEcodigo,".")>
<cfquery name="rsMotorEnc" datasource="sifinterfaces">
	select Activo, urlServidorMotor, spFinal, MsgError, FechaActividad, FechaActivacion, <cf_dbfunction name="now" datasource="sifinterfaces"> as now
	from InterfazMotor
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
</cfquery>
<cfquery name="rsCE" datasource="asp">
	select CEaliaslogin
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
</cfquery>
<br>
<cfoutput>
<form name="formMotor" style="border:0; margin:0 ">
	<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<fieldset><legend style="font-weight:bold;">Motor de Interfaces</legend>
				<table border="0" cellpadding="1" cellspacing="1">
					<tr>
						<td style="width:100px;font-weight:bold; text-align:right">
							Url Servidor: 
						</td>
						<td>&nbsp;
							
						</td>
						<td style="font-family:'Courier New', Courier, mono; font-size:11px;">
							<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
							#LobjColaProcesos.fnUrlLocalhost (rsMotorEnc.urlServidorMotor, true)#
						</td>
					</tr>
					<tr>
						<td style="width:100px;font-weight:bold; text-align:right">
							Estado:
						</td>
						<td>&nbsp;
							
						</td>
						<td>
							<cfif rsMotorEnc.Activo EQ 0>
							<font style = "color: ##FF0000">Inactivo</font>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								#rsMotorEnc.MsgError#
							<cfelse>
								<cfif rsMotorEnc.FechaActividad EQ "">
									<font style = "color: ##CC0000">Activando...</font>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<strong>Activado:</strong> #dateformat(rsMotorEnc.FechaActivacion, "DD-MMM")# #timeformat(rsMotorEnc.FechaActivacion, "HH:MM:SS")#
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<strong>No hay actividad</strong>
								<cfelseif abs(dateDiff("n",rsMotorEnc.FechaActividad,rsMotorEnc.now)) GT 5>
									<font style = "color: ##CC0000">Dormido</font>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<strong>Activado:</strong> #dateformat(rsMotorEnc.FechaActivacion, "DD-MMM")# #timeformat(rsMotorEnc.FechaActivacion, "HH:MM:SS")#
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<strong>Ultima Actividad:</strong> #dateformat(rsMotorEnc.FechaActividad, "DD-MMM")# #timeformat(rsMotorEnc.FechaActividad, "HH:MM:SS")# 
								<cfelse>
									Activo
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<strong>Activado:</strong> #dateformat(rsMotorEnc.FechaActivacion, "DD-MMM")# #timeformat(rsMotorEnc.FechaActivacion, "HH:MM:SS")#
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<strong>Ultima Actividad:</strong> #timeformat(rsMotorEnc.FechaActividad, "HH:MM:SS")#
								</cfif>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<strong>Hora Actual:</strong> #timeformat(rsMotorEnc.now, "HH:MM:SS")#
							</cfif>
						</td>
					</tr>
				</table>
				</fieldset>
			</td>
		</tr>
	</table>
</form>
</cfoutput>
<br>