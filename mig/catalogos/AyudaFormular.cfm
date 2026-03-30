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
								<cf_translate key="LB_ParametrizacionDeLaPantallaDeFormulacionDeMetricasyIndicadores">Parametrizaci&oacute;n de la pantalla de formulaci&oacute;n de M&eacute;tricas y Indicadores</cf_translate>
							</font>
						</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_EstaPantallaEsUtilizadaParaGenerarUnCalculoDeMetricasyIndicadores">
							Esta pantalla es utilizada para generar un c&aacute;lculo a una determinada M&eacute;trica o Indicador.<br>
							A continuaci&oacute;n se muestra una breve descripci&oacute;n de la cada unos campos y el rol que desempe&ntilde;an a la hora de realizar el c&aacute;lculo.
							</cf_translate>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_CuandoElUsuarioSeleccionaElBotonFormularDeMetricasyIndicadores">
							Cuando el usuario selecciona el bot&oacute;n formular desde la pantalla del Maestro de M&eacute;tricas o la del Maestro de Indicadores, aparece la siguiente pantalla.				
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
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>				
					<tr>
						<td>
							<cf_translate key="LBParrafo_ComoPodemosVerTenemosUnAreaDeTrabajoDondeElUsuarioIntroduceElCalculoDeMetricasyIndicadores">
							Como podemos ver tenemos un &aacute;rea de trabajo donde el usuario introduce el c&aacute;lculo de la M&eacute;trica o del Indicador.  <br>
							Tenemos un &aacute;rea de c&aacute;lculo en que pondremos la f&oacute;rmula de la m&eacute;trica o del Indicador, un combo del cu&aacute; se selecciona las variables de la f&oacute;rmula (m&eacute;trica e indicadores), 
							la salida que muestra el resultado de validar una f&oacute;rmula.
						
						   
														
							</cf_translate>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					
					<tr> 
						<td>
							<cf_translate key="LBParrafo_ProcesoFormularDeMetricasyIndicadores">	
					
					 		El proceso de formular consiste en agregar  el comod&iacute;n '>>' en el lugar donde vamos a colocar las variables (m&eacute;tricas o indicadores), este comod&iacute;n es sustituido por 
                            la variable que corresponde, de manera que la f&oacute;rmula va a estar constituida de una relaci&oacute;n de c&oacute;digos los cu&aacute;les se relacionan mediante operadores matem&aacute;ticos ('+,-,*,/ etc'), 
							cada c&oacute;digos en representación de una métrica ó indicador.
							</cf_translate>
						</td>
					</tr>		
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_CuandoSeTengaQueDefinirUnaFuncionEnEspecialEnElAreaDelCalculoDeMetricasyIndicadores">
							Cuando se tenga que definir una funci&oacute;n en especial en el &aacute;rea del c&aacute;lculo y no se sabe como hacer, se puede presionar el bot&oacute;n de ayuda para el c&aacute;lculo.
							</cf_translate>
						</td>
					</tr>				
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_UnaVezCreadoElCalculoYParametrizadaLaParteSuperiorDeMetricasyIndicadores">
							Una vez creado el c&aacute;lculo, se puede validar el c&aacute;lculo y as&iacute; asegurarnos que a nivel de sintaxis el c&oacute;digo sea correcto, 
							si existiera alg&uacute;n error este se mostrar&aacute; en la parte inferior de la ventana en el &aacute;rea de salidas, para el siguiente caso por ejemplo el c&oacute;digos que se muestra en la salida no existe.  
							</cf_translate>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<img src="images/pantalla2.JPG" />
						</td>
					</tr> 
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<cf_translate key="LBParrafo_SalvarFormulaDeMetricasyIndicadores">
							Al validar la f&oacute;rmula hay que verificar que al presionar validar en el &aacute;rea de la salida no aparezca nada, así  podremos salvar la f&oacute;rmula,
                            Con doble click en el icono de Salvar, Si se desea restablecer los c&aacute;lculos basta con doble click en esta opci&oacute;n.

							</cf_translate>
						</td>
					</tr>										
				</table>
			</fieldset>		
		</td>
	</tr>
</table>		


