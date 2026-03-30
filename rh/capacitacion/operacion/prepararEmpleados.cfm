<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Preparar_empleados_para_Capacitacion"
	Default="Preparar empleados para Capacitaci&oacute;n"
	returnvariable="LB_Preparar_empleados_para_Capacitacion"/>    

<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
	  <cf_web_portlet_start border="true" titulo="#LB_Preparar_empleados_para_Capacitacion#" skin="#Session.Preferences.Skin#">
	  		<cfquery name="rsCuentas" datasource="asp">
				select distinct a.CEcodigo, a.CEcuenta, a.CEnombre
				from CuentaEmpresarial a, ModulosCuentaE b
				where a.CEcodigo = b.CEcodigo
				and b.SScodigo = 'RH'
				order by a.CEcuenta, a.CEnombre
			</cfquery>
			
			<cfif rsCuentas.recordCount GT 0>
				<cfif not isdefined("Form.Cuenta")>
					<cfset Form.Cuenta = rsCuentas.CEcodigo>
				</cfif>
				<cfquery name="rsEmpresasCuenta" datasource="asp">
					select Ecodigo, Enombre
					from Empresa
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cuenta#">
				</cfquery>
			</cfif>
	  		
	  		<script language="javascript" type="text/javascript">
				function Listo() {
					alert('Proceso completado con éxito');
				}
				
				function funcPreparar() {
					var width = 500;
					var height = 50;
					var top = (screen.height - height) / 2;
					var left = (screen.width - width) / 2;
					window.open("prepararEmpleados_SQL.cfm?EmpresaCuenta="+ document.form1.EmpresaCuenta.value + "&EnviarEmail="+ document.form1.EnviarEmail.checked + "&activarUsuario="+ document.form1.activarUsuario.checked,"PrepararEmpleados",'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,height='+height+',width='+width+',left='+left+',top='+top);
				}
			</script>
	  
			<cfset titulo = "Preparar Empleados"> 
			<cfset Regresar = "/cfmx/rh/capacitaciondes/indexCapacitacion.cfm">
			<cfset navBarItems = ArrayNew(1)> 
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarItems[1] = "Capacitaci&oacute;n y Desarrollo">
			<cfset navBarLinks[1] = "/cfmx/rh/capacitaciondes/indexCapacitacion.cfm">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<form name="form1" action="prepararEmpleados.cfm" method="post" style="margin: 0; ">
				<input type="hidden" name="opcion" value="2">
				<br>
				<table width="90%"  border="0" cellspacing="0" cellpadding="0" align="center" class="Ayuda">
				  <tr>
				    <td>&nbsp;</td>
				    <td>&nbsp;</td>
				    <td>&nbsp;</td>
			      </tr>
				  <tr>
				    <td>&nbsp;</td>
				    <td><strong>Seleccione una Cuenta Empresarial y una Empresa antes de Continuar</strong></td>
				    <td>&nbsp;</td>
			      </tr>
				  <tr>
				    <td>&nbsp;</td>
				    <td><table width="100%"  border="0" cellspacing="0" cellpadding="2">
                      <tr>
                        <td width="20%" align="right" style="padding-right: 10px;" nowrap>Cuenta Empresarial:</td>
                        <td nowrap>
							<select name="Cuenta" onChange="javascript: this.form.submit();">
							<cfoutput>
							<cfloop query="rsCuentas">
								<option value="#rsCuentas.CEcodigo#" <cfif isdefined("Form.Cuenta") and Form.Cuenta EQ rsCuentas.CEcodigo> selected</cfif>>#rsCuentas.CEnombre#</option>
							</cfloop>
							</cfoutput>
							</select>
						</td>
                      </tr>
                      <tr>
                        <td align="right" nowrap>Empresa:</td>
                        <td nowrap>
							<select name="EmpresaCuenta">
							<cfoutput>
							<cfloop query="rsEmpresasCuenta">
								<option value="#rsEmpresasCuenta.Ecodigo#">#rsEmpresasCuenta.Enombre#</option>
							</cfloop>
							</cfoutput>
							</select>
						</td>
                      </tr>
                    </table></td>
				    <td>&nbsp;</td>
			      </tr>
				  <tr>
				    <td>&nbsp;</td>
				    <td>&nbsp;</td>
				    <td>&nbsp;</td>
			      </tr>
				  <tr>
					<td width="10%">&nbsp;</td>
					<td>
						<strong>Este proceso permite preparar los datos de los empleados para que puedan matricular cursos de capacitaci&oacute;n y desarrollo.</strong><br><br>
						1. Para cada empleado se le crea un usuario en el portal y si tiene correo electrónico se le envía el usuario y password con el cual puede acceder al portal.<br><br>
						2. Se le asigna el Rol de Alumno.<br><br>
						3. Se le asigna el Rol de Autogestión.<br>
					</td>
					<td width="10%">&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="3">&nbsp;</td>
				  </tr>
				  
                  <tr>
					<td>&nbsp;</td>
                    <td colspan="2" align="left"><input type="checkbox" name="activarUsuario" id="activarUsuario"/>  <cf_translate key="LB_Activar_Usuarios">Activar Usuarios</cf_translate> 
                    </td></tr>
                    
                    <tr>
					<td>&nbsp;</td>
                    <td colspan="2" align="left"><input type="checkbox" name="EnviarEmail" id="EnviarEmail"/>  <cf_translate key="LB_Enviar_Contrasena_Correo">Enviar Contraseña por correo</cf_translate> 
                    </td></tr>
 					<tr>
					<td colspan="3">&nbsp;</td>
				  	</tr>
                  
                  <tr>
					<td align="center" colspan="3">
						<input name="btnPreparar" type="button" id="btnPreparar" value="Preparar" onClick="javascript: if (confirm('¿Está seguro de que desea correr este proceso?')) funcPreparar();">
					</td>
				  </tr>
				  
                  <tr>
					<td colspan="3">&nbsp;</td>
				  </tr>
				</table>
				<br>
			</form>
	  <cf_web_portlet_end>
<cf_templatefooter>