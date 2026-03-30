<!---
	Creado por Andres Lara
		Fecha: 26-06-2017
 --->


<cf_templateheader title="Portal - Mantenimiento a Usuarios Proceso">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Mantenimiento a Usuarios Proceso'>

<cfquery datasource="asp" name="elim">
		  select Usulogin,a.SScodigo,sm.SMdescripcion,sp.SPdescripcion
	 from vUsuarioProcesos a
		  inner join Usuario u
			on a.Usucodigo = u.Usucodigo
		  inner join SModulos sm
			on a.SMcodigo = sm.SMcodigo
		  inner join SProcesos sp
			on a.SPcodigo = sp.SPcodigo
				and a.SScodigo = sp.SScodigo
				and a.SMcodigo = sp.SMcodigo
		   where   (
					select count(1)
							  from vUsuarioProcesosCalc
							 where Usucodigo = a.Usucodigo
							   and Ecodigo	 = a.Ecodigo
							   and SScodigo	 = a.SScodigo
							   and SMcodigo	 = a.SMcodigo
							   and SPcodigo  = a.SPcodigo ) = 0
</cfquery>
<!---- Variables ---->

<cfset etiquetA = "Sistema,Modulo,Proceso">

<!------------------------>

<cfoutput>
	<form name="form1" method="post" action="../../../sif/tasks/UsuarioProcesosManual.cfm" target="_blank">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">

	<label>&nbsp; Se debe tener cuidado que este proceso no se invoque de manera
	frecuente, porque si se hace podría afectar de
	manera negativa el rendimiento del servidor o causar
	deadlocks</label>
		<tr>
			<td valign="top" align="center">
				<table  width="100%" align="center" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>

					<!--- <cfif elim.recordcount gt 0> --->

							<tr>
								<td align="center" nowrap="nowrap" colspan="2"><b>Datos a eliminar:</b></td>
										<tr><td colspan="2">&nbsp;</td></tr>
							</tr>
							<tr>
								<cfinvoke
								 component="sif.Componentes.pListas"
								 method="pListaQuery"
								 returnvariable="pListaRet">
									<cfinvokeargument name="query" 				value="#elim#"/>
									<cfinvokeargument name="desplegar" 			value="Usulogin,SScodigo,SMdescripcion,SPdescripcion"/>
									<cfinvokeargument name="etiquetas" 			value="Usuario,Sistema,Modulo,Proceso"/>
									<cfinvokeargument name="formatos" 			value="S,S,S,S"/>
									<cfinvokeargument name="align" 				value="left,left, rigth, right"/>
									<cfinvokeargument name="ajustar" 			value="S"/>
									<cfinvokeargument name="maxrows" 			value="50"/>
								</cfinvoke>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr><td colspan="2"><cf_botones values="Procesar" names="Procesar" tabindex="1"></td></tr>
					<!--- <cfelse>
						<tr>
								<td align="center" nowrap="nowrap" colspan="2">No existen datos por procesar</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
					</cfif> --->

				</table>
				</fieldset>
			</td>
		</tr>
	</table>
	</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>



