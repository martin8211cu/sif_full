<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
<cfset rsMotor = LobjColaProcesos.fnActivarMotor (session.CEcodigo,".")>
<cfquery name="Motor" datasource="sifinterfaces">
	select Activo, urlServidorMotor, spFinal, MsgError, FechaActividad
	from InterfazMotor
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
</cfquery>
<cfquery name="rsCE" datasource="asp">
	select CEaliaslogin
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
</cfquery>
<br>
<form action="parametros.cfm" method="post" name="frmMotor" style="border:0; margin:0 ">
	<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<fieldset><legend style="font-weight:bold;">Motor de Interfaces</legend>
				<table border="0" cellpadding="1" cellspacing="1">
					<cfoutput>
					<tr>
						<td style="width:100px;font-weight:bold; text-align:right">
							Url Servidor: 
						</td>
						<td>&nbsp;
							
						</td>
						<td>
							<cfif Motor.Activo EQ 0>
								<cfif isdefined("LvarActivarMotor")>
									<input type="text" name="urlServidorMotor" size="60" value="http://#session.sitio.host#/cfmx/" onKeyPress="return false;" onChange="this.value='http://#session.sitio.host#/cfmx/';">
								<cfelse>
									#Motor.urlServidorMotor#
								</cfif>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<span style = "color: ##FF0000">#Motor.MsgError#</span>
							<cfelse>
								#Motor.urlServidorMotor#
							</cfif>
						</td>
					</tr>
					<tr>
						<td style="width:100px;font-weight:bold; text-align:right">
							Store Procedure Final: 
						</td>
						<td>&nbsp;
							
						</td>
						<td>
							<cfif Motor.Activo EQ 0>
								<cfif isdefined("LvarActivarMotor")>
									<input type="text" name="spFinal" size="60" value="#Motor.spFinal#">
								<cfelse>
									#Motor.spFinal# <cfif trim(#Motor.spFinal#) neq ""> (NumeroInterfaz, IdProceso)</cfif>
								</cfif>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<span style = "color: ##FF0000">#Motor.MsgError#</span>
							<cfelse>
								#Motor.spFinal#  <cfif trim(#Motor.spFinal#) neq ""> (NumeroInterfaz, IdProceso)</cfif>
							</cfif>
						</td>
					</tr>
				<cfif Motor.Activo EQ 1 and isdefined("LvarActivarMotor")>
					<tr>
						<td style="width:100px;font-weight:bold; text-align:right">
							WebService: 
						</td>
						<td>&nbsp;
							
						</td>
						<td>
							interfazToSoin('#Motor.urlServidorMotor#interfacesSoin/webService/interfaz-service.cfm','#rsCE.CEaliasLogin#','#session.EcodigoSDC#','UID_SIF','PWD_SIF','NUM_INTERFAZ','ID_PROCESO')
						</td>
					</tr>
					<tr>
						<td style="width:100px;font-weight:bold; text-align:right">
							Tarea Asíncrona: 
						</td>
						<td>&nbsp;
							
						</td>
						<td>
							Tarea Asincrona Motor Interfaces CE=#session.CEcodigo#: #Motor.urlServidorMotor#interfacesSoin/tareaAsincrona/activarCola.cfm?CE=#session.CEcodigo#
						</td>
					</tr>
				</cfif>
					</cfoutput>
					<tr>
						<td style="width:100px;font-weight:bold; text-align:right">
							Estado:
						</td>
						<td>&nbsp;
							
						</td>
						<td>
							<span style = "color: #<cfif Motor.Activo EQ 0>FF0000<cfelse>0000FF</cfif>"><cfif Motor.Activo EQ 0>Inactivo<cfelse>Activo</cfif></span>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<cfif isdefined("LvarActivarMotor")>
								<input type="submit"
								<cfif Motor.Activo EQ 0>
									id="doMotor" name="doMotor" value="Activar"
								<cfelse>
									id="undoMotor" name="undoMotor" value="Inactivar"
								</cfif>
									onclick="return fnMotor();"
								>
							</cfif>
							<cfif Motor.Activo EQ 1>
							<cfoutput>
								<strong>Hora Actual:</strong> #timeformat(now(), "HH:MM:SS")#
								<strong>Ultima Actividad:</strong> #timeformat(motor.FechaActividad, "HH:MM:SS")#
							</cfoutput>
							</cfif>
						</td>
					</tr>
				
				</table>
				</fieldset>
			</td>
		</tr>
	</table>
</form>
<cfoutput>
<script language="javascript">
	function fnMotor()
	{
		if (confirm('¿Ya borró la "Tarea Asincrona Motor Interfaces CE=#session.CEcodigo#" desde el Administrador de ColdFusion?'))
			return true;
		else if (confirm('¿Desea abrir el Administrador de ColdFusion?\n (Una vez Autenticado, debe entrar a la opción Scheduled Tasks\n y borrar: Tarea Asincrona Motor Interfaces CE=#session.CEcodigo#)'))
			location.href='#Motor.urlServidorMotor#CFIDE/Administrator';
		return false;			
	}
</script>
</cfoutput>
<br>