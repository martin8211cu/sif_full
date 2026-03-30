<cf_template template="/plantillas/autogestion/plantilla.cfm">
<cf_templatearea name="title">Autogesti&oacute;n</cf_templatearea>
<cf_templatearea name="body">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr bgcolor="#EAE4D3" valign="top">
	<td align="center" width="27%" background="images/fon_1.gif"> 
	<br>
		<table width="241" border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td><img src="images/t11.gif" width="10" height="22" alt="" border="0"></td>
		<td background="images/fon_top.gif"><img src="images/t12.gif" width="29" height="22" alt="" border="0"></td>
		<td background="images/fon_top.gif">
			<table border="0" cellpadding="0" cellspacing="0" width="164" height="22">
			<tr>
			<td background="images/t_top.gif"><p class="title01">AUTOGESTI&Oacute;N</p></td>
			</tr>
			</table>
		</td>
		<td background="images/fon_top.gif" align="right"><img src="images/t13.gif" width="29" height="22" alt="" border="0"></td>
		<td><img src="images/t14.gif" width="9" height="22" alt="" border="0"></td>
		</tr>
		<tr valign="top">
		<td background="images/fon_left.gif"><img src="images/t21.gif" width="10" height="333" alt="" border="0"></td>
		<td colspan="3" rowspan="2" bgcolor="#FFFFFF">
		<p class="left" align="justify"><a href="/cfmx/sif/rh/expediente/consultas/expediente-cons.cfm">Mi expediente </a></p>		
		<p class="left" align="justify"><a href="/cfmx/sif/rh/expediente/consultas/lineaTiempoEmp.cfm">Cambios Salariales</a></p>
		<p class="left" align="justify"><a href="/cfmx/sif/rh/autogestion/autogestion.cfm?o=3">Iniciar Tr&aacute;mite</a></p>
		<p class="left" align="justify"><a href="/cfmx/sif/tr/consultas/pendientes.cfm">Tr&aacute;mites Pendientes </a></p>
		<p class="left" align="justify"><a href="/cfmx/sif/tr/consultas/aprobacion.cfm">Aprobaci&oacute;n de Tr&aacute;mites</a></p>		
		<!---
		<p class="left" align="justify"><a href="/cfmx/sif/af/operacion/AdquisicionVales.cfm">Registro de Activos </a></p>
		<p class="left" align="justify"><a href="/cfmx/sif/af/operacion/TransferenciaResponsable.cfm">Transferencia de Activos </a></p>
		--->
		<p class="left" align="justify"><a href="/cfmx/sif/rh/autogestion/CitaMedica/MiAgenda.cfm">Citas M&eacute;dicas </a></p>
		<cfquery name="rsCFuresponsable" datasource="#session.DSN#">
			select distinct CFuresponsable as responsable  
			from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CFuresponsable = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">
		</cfquery>
		
		<cfoutput>
 		<cfif rsCFuresponsable.Recordcount EQ 1>
			<p class="left" align="left">
				<a href="/cfmx/sif/rh/Reclutamiento/operacion/concursoProcesoAuto.cfm?flag=1">Solicitud de Apertura de Concursos</a>
			</p>
		</cfif>
		</cfoutput>
		<p class="left" align="left">
			<a href="/cfmx/sif/rh/Reclutamiento/operacion/concursoabierto.cfm">Concursos Abiertos</a>
		</p>
		<p class="left" align="left">
			<a href="/cfmx/sif/rh/reloj/autogestion.cfm">Reloj Marcador</a>
		</p>
		<p class="left" align="left">
			<a href="/cfmx/sif/af/operacion/vales_adquisicion.cfm">Adquisici&oacute;n de Activos Fijos con Vale</a>
		</p>
		<p class="left" align="left">
			<a href="/cfmx/sif/af/operacion/vales_responsale_auto.cfm">Transferencia de Responsable de Activos Fijos con Vale</a></p>
		</td>
		<td background="images/fon_right.gif"><img src="images/t24.gif" width="9" height="333" alt="" border="0"></td>
		</tr>
		<tr valign="bottom">
		<td background="images/fon_left.gif"><img src="images/t31.gif" width="10" height="7" alt="" border="0"></td>
		<td background="images/fon_right.gif"><img src="images/t34.gif" width="9" height="7" alt="" border="0"></td>
		</tr>
		<tr>
		<td><img src="images/t41.gif" width="10" height="15" alt="" border="0"></td>
		<td background="images/fon_bot.gif"><img src="images/t42.gif" width="29" height="15" alt="" border="0"></td>
		<td background="images/fon_bot.gif"><img src="images/fon_bot.gif" width="31" height="15" alt="" border="0"></td>
		<td background="images/fon_bot.gif" align="right"><img src="images/t43.gif" width="29" height="15" alt="" border="0"></td>
		<td><img src="images/t44.gif" width="9" height="15" alt="" border="0"></td>
		</tr>
	  </table>
	<br>
	</td>
	<td align="center" width="27%" background="images/fon_1.gif"> 
	<br>
		<table border="0" cellpadding="0" cellspacing="0" width="241">
		<tr>
		<td><img src="images/t11.gif" width="10" height="22" alt="" border="0"></td>
		<td background="images/fon_top.gif"><img src="images/t12.gif" width="29" height="22" alt="" border="0"></td>
		<td background="images/fon_top.gif">
			<table border="0" cellpadding="0" cellspacing="0" width="164" height="22">
			<tr>
			<td background="images/t_top.gif"><p class="title01">DESARROLLO</p></td>
			</tr>
			</table>
		</td>
		<td background="images/fon_top.gif" align="right"><img src="images/t13.gif" width="29" height="22" alt="" border="0"></td>
		<td><img src="images/t14.gif" width="9" height="22" alt="" border="0"></td>
		</tr>

			<tr valign="top">
				<td background="images/fon_left.gif"><img src="images/t21.gif" width="10" height="333" alt="" border="0"></td>
				<td colspan="3" rowspan="2" bgcolor="#FFFFFF">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td nowrap class="left">
							<a href="/cfmx/sif/rh/evaluaciondes/operacion/evaluar_des-lista.cfm?tipo=auto"><br>
							<strong>Autoevaluación del Desempeño</strong></a>
						</td>
						</tr>
						<tr><td class="left">Autoevaluaci&oacute;n de mi desempeño.<br></td></tr>

						<tr>
						  <td nowrap class="left">
							<a href="/cfmx/sif/rh/evaluaciondes/operacion/evaluar_des-lista.cfm?tipo=otros"><strong>Evaluaciones del Desempe&ntilde;o Pendientes </strong></a>
						</td>
						</tr>
						<tr><td class="left">Realizar evaluación de desempe&ntilde;o para compa&ntilde;eros o subordinados.<br>						</td></tr>

						<tr>
						  <td nowrap class="left">&nbsp;</td>
					  </tr>
						<tr>
						  <td nowrap class="left"><a href="/cfmx/sif/rh/capacitacion/operacion/automatricula/index.cfm"><strong>Automatr&iacute;cula de Cursos</strong></a>
					      <!--- Consulta si el usuario conectado en autogestion es responsable de alg&uacute;n Centro funcional ---></td>
					  </tr>
						<tr>
						  <td nowrap class="left">Matricular cursos disponibles para m&iacute; mismo..<br>					      </td>
					  </tr>
						<tr>
                          <td nowrap class="left"><a href="/cfmx/sif/rh/capacitacion/operacion/solicitudmatricula/"><strong>Solicitud de Capacitaci&oacute;n </strong></a></td>
					  </tr>
						<tr>
                          <td class="left" >Autoevaluaci&oacute;n para capacitaci&oacute;n y desarrollo.<br></td>
					  </tr>
						<tr>
						  <td nowrap class="left">&nbsp;</td>
					  </tr>
						<tr>
						  <td nowrap class="left">&nbsp;</td>
					  </tr>
						<tr><td nowrap class="left">
							<a href="/cfmx/sif/rh/capacitaciondes/consultas/PlanDesIndivAuto.cfm?tipo=auto"><strong>Plan de Desarrollo Individual</strong></a>
						</td></tr>
						<tr><td class="left" >Plan de Desarrollo Individual.<br></td></tr>

						<tr><td nowrap class="left">
							<a href="/cfmx/sif/rh/capacitaciondes/consultas/CursosColabHistAuto.cfm?tipo=auto"><strong>Hist&oacute;rico de la Base de Entrenamiento</strong></a>
						</td></tr>
						<tr><td class="left" >Hist&oacute;rico de la Base de Entrenamiento.<br></td></tr>
					</table>
				</td>
				<td background="images/fon_right.gif"><img src="images/t24.gif" width="9" height="333" alt="" border="0"></td>
			</tr>
			
			<tr valign="bottom">
				<td background="images/fon_left.gif"><img src="images/t31.gif" width="10" height="7" alt="" border="0"></td>
				<td background="images/fon_right.gif"><img src="images/t34.gif" width="9" height="7" alt="" border="0"></td>
			</tr>
	
			<tr>
				<td><img src="images/t41.gif" width="10" height="15" alt="" border="0"></td>
				<td background="images/fon_bot.gif"><img src="images/t42.gif" width="29" height="15" alt="" border="0"></td>
				<td background="images/fon_bot.gif"><img src="images/fon_bot.gif" width="31" height="15" alt="" border="0"></td>
				<td background="images/fon_bot.gif" align="right"><img src="images/t43.gif" width="29" height="15" alt="" border="0"></td>
				<td><img src="images/t44.gif" width="9" height="15" alt="" border="0"></td>
			</tr>
		
		</table>
	<br>
	</td>
	<td align="center" width="46%" background="images/fon_2.gif">
	<br>
		<table border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td><img src="images/t11.gif" width="10" height="22" alt="" border="0"></td>
		<td background="images/fon_top.gif"><img src="images/t12.gif" width="29" height="22" alt="" border="0"></td>
		<td background="images/fon_top.gif">
			<table border="0" cellpadding="0" cellspacing="0" width="164" height="22">
			<tr>
			<td background="images/t_top.gif"><p class="title01">BIENVENIDO</p></td>
			</tr>
			</table>
		</td>
		<td background="images/fon_top.gif" align="right"><img src="images/t13.gif" width="29" height="22" alt="" border="0"></td>
		<td><img src="images/t14.gif" width="9" height="22" alt="" border="0"></td>
		</tr>
		<tr valign="top">
		<td background="images/fon_left.gif"><img src="images/t21.gif" width="10" height="333" alt="" border="0"></td>
		<td colspan="3" rowspan="2" bgcolor="#FFFFFF" width="390">
			<table border="0" cellpadding="5" cellspacing="0" width="100%">
			<tr valign="top">
			<td>
			<img src="images/temp01.gif" width="129" height="127" alt="" border="0"><br>
			<img src="images/temp02.gif" width="129" height="130" alt="" border="0">
			</td>
			<td>
			<p align="justify">La Autogesti&oacute;n consiste en la posibilidad y capacidad que puede tener cada funcionario de una entidad organizada en gestionar de forma eficiente y eficaz todas aquellas actividades diarias sin necesidad de contactar con el departamento de recursos humanos. Adem&aacute;s, le permite organizar y controlar sus propios beneficios e incluso cambiar datos de su historial y todo desde su puesto de trabajo de manera autom&aacute;tica.</p>
			</td>
			</tr>
			</table>
		</td>
		<td background="images/fon_right.gif"><img src="images/t24.gif" width="9" height="333" alt="" border="0"></td>
		</tr>
		<tr valign="bottom">
		<td background="images/fon_left.gif"><img src="images/t31.gif" width="10" height="7" alt="" border="0"></td>
		<td background="images/fon_right.gif"><img src="images/t34.gif" width="9" height="7" alt="" border="0"></td>
		</tr>
		<tr>
		<td><img src="images/t41.gif" width="10" height="15" alt="" border="0"></td>
		<td background="images/fon_bot.gif"><img src="images/t42.gif" width="29" height="15" alt="" border="0"></td>

		<td background="images/fon_bot.gif"><img src="images/fon_bot.gif" width="31" height="15" alt="" border="0"></td>
		<td background="images/fon_bot.gif" align="right"><img src="images/t43.gif" width="29" height="15" alt="" border="0"></td>
		<td><img src="images/t44.gif" width="9" height="15" alt="" border="0"></td>
		</tr>
		</table>
	</td>
	</tr>
	</table>
</cf_templatearea>
</cf_template>