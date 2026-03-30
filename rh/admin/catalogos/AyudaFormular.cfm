<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Ayuda"
		Default="Ayuda"
		returnvariable="LB_Ayuda"/>
		<cfoutput>#LB_Ayuda#</cfoutput>
</title>
<table width="100%" border="0">
	<tr>
		<td>
			<fieldset>
				<table width="100%" border="0">
					<tr>
						<td align="center" bgcolor="#CCCCCC">
							<font size="+2">
								<cf_translate key="LB_ParametrizacionDeLaPantallaDeFormulacionDeConceptoDePagos">Parametrizaci&oacute;n de la pantalla de formulaci&oacute;n de concepto de pagos</cf_translate>
							</font>
						</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_EstaPantallaEsUtilizadaParaGenerarUnCalculo">
							Esta pantalla es utilizada para generar un c&aacute;lculo a un determinado concepto de pago.<br>
							A continuaci&oacute;n se muestra una breve descripci&oacute;n de la cada unos campos y el rol que desempe&ntilde;an a la hora de realizar el c&aacute;lculo.
							</cf_translate>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_CuandoElUsuarioSeleccionaElBotonFormular">
							Cuando el usuario selecciona el bot&oacute;n formular (siempre y cuando el m&eacute;todo es de tipo c&aacute;lculo)
							desde la pantalla de conceptos de pago, aparece la siguiente pantalla.				
							</cf_translate>
						</td>
					</tr> 
					<tr>
						<td>&nbsp;</td>
					</tr> 
					<tr>
						<td>
							<img src="images/pantalla.JPG" />
						</td>
					</tr> 
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_ElPrimerCheckQueApareceNosIndicaSiTenemosONoQueLimitarElAmbitoDelTiempoDelCalculo">
							El primer check que aparece nos indica si tenemos o no  que limitar el &aacute;mbito del tiempo del c&aacute;lculo, <br>
							esto quiere decir que si es necesario indicarle al c&aacute;lculo que tiene que retroceder en un determinado periodo para realizar el c&aacute;lculo.				
							</cf_translate>
						</td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_SiElUsuarioHabilitaElCheckApareceLaSiguienteInformacion">
							Si el usuario habilita el check aparece la siguiente informaci&oacute;n.				
							</cf_translate>
						</td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
					</tr> 
					<tr>
						<td>
							<img src="images/check.JPG" />
						</td>
					</tr> 
					<tr>	
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_EnDondeSeSolicitaLoSiguiente">
							En donde se solicita lo siguiente:
							</cf_translate>
						</td>
					</tr>	
					<tr>
						<td>
							<li>
								<cf_translate key="LBParrafo_SeIndicaCuantoTiempoHayQueRetrocederParaRealizarElCalculo.">
								Se indica cuanto tiempo (d&iacute;as, semanas, meses o a&ntilde;os) hay  que retroceder para realizar el c&aacute;lculo.
								</cf_translate>
							</li>
						</td>
					</tr>	
					<tr>
						<td>
							<li>
								<cf_translate key="LBParrafo_UnaVezQueSeIndiqueCuantoSeVaARetrocer">
								Una vez que se indique cuanto se va a retrocer. Se especifica si es necesario indicar una fecha de finalizaci&oacute;n del c&aacute;lculo.
								</cf_translate>
							</li>
						</td>
					</tr>	
					<tr>
						<td>
							<li>
								<cf_translate key="LBParrafo_EsCasoDeQueNoSeaNecesarioIndicarLaFechaSeDejaElCheckDesmarcado">
								En caso de que no sea necesario indicar la fecha se deja el check desmarcado.  
								</cf_translate>
							</li>
						</td>
					</tr>
					<tr>
						<td>
							<li>
								<cf_translate key="LBParrafo_TeniendoDefinidoElRangoAUtilizarParaRealizarElCalculo">
								Teniendo definido el rango a utilizar para realizar el c&aacute;lculo. Es necesario indicar como se van a sumarizar los montos, <br>
								ya sea hasta la fecha de vigencia o para un determinado periodo  (d&iacute;as, semanas, meses o a&ntilde;os) <br> 
								el cual depender&aacute; de la parametrizaci&oacute;n que se le dio en el retroceso. 
								</cf_translate>
							</li>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_TeniendoEstaAreaDebidamenteParametrizada">
							Teniendo esta &aacute;rea debidamente parametrizada, podemos continuar con la creaci&oacute;n del c&aacute;lculo. 
							</cf_translate>
						</td>
					</tr>				  
					<tr>
						<td>&nbsp;</td>
					</tr> 
					<tr>
						<td>
							<img src="images/calculo.JPG" />
						</td>
					</tr> 
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_ComoPodemosVerTenemosUnAreaDeTrabajoDondeElUsuarioIntroduceElCalculo">
							Como podemos ver tenemos un &aacute;rea de trabajo donde el usuario introduce el c&aacute;lculo  <br>
							y en caso que sea necesario invocar o referenciar una variable (entrada)  <br>
							ya definida se pueden incluir a c&oacute;digo como lo indican las instrucciones.
							</cf_translate>
						</td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_CuandoSeTengaQueDefinirUnaFuncionEnEspecialEnElAreaDelCalculo">
							Cuando se tenga que definir una funci&oacute;n en especial en el &aacute;rea del c&aacute;lculo y no se sabe como hacer, <br>
							se puede presionar el bot&oacute;n de ayuda para el c&aacute;lculo.
							</cf_translate>
						</td>
					</tr>				
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_UnaVezCreadoElCalculoYParametrizadaLaParteSuperior">
							Una vez creado el c&aacute;lculo y parametrizada la parte superior, <br>
							se puede validar el c&aacute;lculo y as&iacute; asegurarnos que a nivel de sintaxis el c&oacute;digo sea correcto.  
							</cf_translate>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_ParaUnMejorEntendimientoSeMuestraElSiguienteEjemplo">
							Para un mejor entendimiento se muestra el siguiente ejemplo.
							</cf_translate>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_SupongamosQueDeseamosRealizarElSiguienteCalculo">
							Supongamos que deseamos realizar el siguiente c&aacute;lculo:
							</cf_translate>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_CalcularLaSumatoriaDeLosSalariosDeUnAnno">
							Calcular la sumatoria de los salarios de un a&ntilde;o para un empleado, pero haciendo el corte al primero de dic. 
							</cf_translate>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_YQueLaSumatoriaDeLosMontosSeRealiceHastaLaFechaDeVigencia">
							Y que la sumatoria de los montos  se realice hasta la fecha de vigencia.
							</cf_translate>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<img src="images/ejemplo.JPG" />
						</td>
					</tr> 
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_EnDondeSeSolicitaLoSiguiente">
							La parametrizaci&oacute;n quedar&iacute;a de la siguiente manera.
							</cf_translate>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<img src="images/ejemplo2.JPG" />
						</td>
					</tr>
				</table>
			</fieldset>		
		</td>
	</tr>
</table>		


