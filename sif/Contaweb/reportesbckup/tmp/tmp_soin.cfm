<!--- Generado 20/09/2004 15:02:36 --->


<script language="javascript1.2" type="text/javascript">
	function regresar() {
		if (1 == 1) {
			document.location = "../reportes/cmn_SaldosCuentas.cfm";
		}
		if (1 == 2) {
			document.location = "../reportes/cmn_SaldosRangoCuentas.cfm";
		}
		if (1 == 3) {
			document.location = "../reportes/cmn_SaldosAsientoCuentas.cfm";
		}
	}

	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		window.print()	
        tablabotones.style.display = ''

	}

	function SALVAEXCEL() {
		var EXCEL = document.getElementById("EXCEL");
		EXCEL.style.visibility='hidden';
		var file =  "../reportes/cmn_excel.cfm" ;
		var string=  "width=400,height=200,toolbar=no,directories=no,menubar=yes,resizable=yes,dependent=yes"    
		hwnd = window.open(file,'excel',string) ;                    
		if (navigator.appName == "Netscape") {   
			 hwnd.focus()   
        }   
	}
</script>
<table  id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
	<tr>
		<td align="right" nowrap>
			<input type="button"  id="EXCEL" name="EXCEL" value="Exportar a Excel" onClick="SALVAEXCEL();">
			<input type="button"  id="Regresar" name="Regresar" value="Regresar" onClick="regresar();">
			<input type="button"  id="Imprimir" name="Imprimir" value="Imprimir" onClick="imprimir();">
		</td>
	</tr>
	<tr><td><hr></td></tr>
</table>


<style>
H1.Corte_Pagina
{
PAGE-BREAK-AFTER: always
}
<!--table
	{mso-displayed-decimal-separator:"\.";
	mso-displayed-thousand-separator:"\,";}
@page
	{margin:1.0in .75in 1.0in .75in;
	mso-header-margin:.5in;
	mso-footer-margin:.5in;}
tr
	{mso-height-source:auto;}
col
	{mso-width-source:auto;}
br
	{mso-data-placement:same-cell;}
.style0
	{mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	white-space:nowrap;
	mso-rotate:0;
	mso-background-source:auto;
	mso-pattern:auto;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial;
	mso-generic-font-family:auto;
	mso-font-charset:0;
	border:none;
	mso-protection:locked visible;
	mso-style-name:Normal;
	mso-style-id:0;}
td
	{mso-style-parent:style0;
	padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial;
	mso-generic-font-family:auto;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	border:none;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:locked visible;
	white-space:nowrap;
	mso-rotate:0;}
.xl24
	{mso-style-parent:style0;
	mso-number-format:Standard;}
.xl25
	{mso-style-parent:style0;
	font-size:9.0pt;
	font-weight:700;
	text-align:center;
	background:silver;
	mso-pattern:auto none;
	white-space:normal;}
.xl26
	{mso-style-parent:style0;
	font-weight:700;
	font-family:Arial, sans-serif;
	mso-font-charset:0;}
.xl27
	{mso-style-parent:style0;
	font-size:8.0pt;
	font-weight:bold;
	font-family:Arial, sans-serif;
	mso-font-charset:0;}
.xl28
	{mso-style-parent:style0;
	font-size:8.0pt;
	font-family:Arial, sans-serif;
	mso-font-charset:0;}
.xl29
	{mso-style-parent:style0;
	font-size:8.0pt;
	font-family:Arial, sans-serif;
	mso-number-format:"\@";}
-->
</style>
<table width="100%" cellpadding="0" cellspacing="0" border="0" >
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" >
				<tr><td  colspan="6" align="center" class="xl25">INSTITUTO COSTARRICENSE DE ELECTRICIDAD</td></tr>
				<tr><td  colspan="6" align="center" class="xl25">Reporte de Saldos por Cuenta</td></tr>
				<tr><td  colspan="6" align="center" class="xl25">De Agosto 2004 a Agosto 2004</td></tr>
			</table>
		</td>
	</tr>
	<tr><td><hr></td></tr>
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" >
									
					
				<tr><td align="center" colspan="6"  class="xl26">
					
						Reporte Detallado por Asiento
					</td></tr>
				<tr><td  align="center" colspan="6"  class="xl26">Segmento:&nbsp;Todos</td></tr>
			</table>
		</td>
	</tr>
	<tr><td><hr></td></tr>
	<tr>
		<td nowrap>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" >
				<tr>
					<td nowrap class="xl25">Cuenta</td>
					<td nowrap class="xl25">Descripci&oacute;n</td>
					<td nowrap align="right" class="xl25">Inicial</td>
					<td nowrap align="right" class="xl25">D&eacute;bitos</td>
					<td nowrap align="right" class="xl25">Cr&eacute;ditos</td>
					<td nowrap align="right" class="xl25">Final</td>
				</tr>


						 <tr>
							
								<td nowrap class="xl27">020                           </td>
								<td nowrap class="xl27">CUENTAS DE ORDEN ACR</td>
								<td nowrap align="right" class="xl27">-94,617,212,239.76</td>
								<td nowrap align="right" class="xl27">9,018,820.41</td>
								<td nowrap align="right" class="xl27">18,967,681.83</td>
								<td nowrap align="right" class="xl27">-94,627,161,101.18</td>
							
						</tr> 
					

						 <tr>
							
								<td nowrap class="xl27">020  01                       </td>
								<td nowrap class="xl27">DEPOSITOS POR DEVOLV</td>
								<td nowrap align="right" class="xl27">-84,258,732,933.72</td>
								<td nowrap align="right" class="xl27">9,018,820.41</td>
								<td nowrap align="right" class="xl27">18,967,681.83</td>
								<td nowrap align="right" class="xl27">-84,268,681,795.14</td>
							
						</tr> 
					

						 <tr>
							
								<td nowrap class="xl28">020  0101                     </td>
								<td nowrap class="xl28" >CUMPLIMIENTO        </td>
								<td nowrap align="right" class="xl28">-55,548,282,296.74</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">-55,548,282,296.74</td>
							
						</tr> 
					

						 <tr>
							
								<td nowrap class="xl28">020  0102                     </td>
								<td nowrap class="xl28" >PARTICIPACION       </td>
								<td nowrap align="right" class="xl28">-27,799,395,088.11</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">-27,799,395,088.11</td>
							
						</tr> 
					

						 <tr>
							
								<td nowrap class="xl28">020  0103                     </td>
								<td nowrap class="xl28" >GARANTIAS DE LICITAC</td>
								<td nowrap align="right" class="xl28">51,273,467.11</td>
								<td nowrap align="right" class="xl28">340,000.00</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">51,613,467.11</td>
							
						</tr> 
					

								<tr>
									<td nowrap>&nbsp;</td>
									<td nowrap  align="right" colspan="4">
										<table width="80%" cellpadding="0" cellspacing="0" border="1" >
											
											
											<tr>
												
														
															<td nowrap  width="10%" align="right" class="xl25">Seg</td>
														
														<td nowrap  width="10%" align="right" class="xl25">A&ntilde;o</td>
														<td nowrap  width="10%" align="right" class="xl25">Mes</td>
														<td nowrap  width="20%" align="right" class="xl25">Asiento</td>
														<td nowrap  width="20%"align="right" class="xl25">D&eacute;bitos</td>
														<td nowrap  width="20%"align="right" class="xl25">Cr&eacute;ditos</td>
														
											</tr>
								


												
												
												<tr>
													
															
																<td nowrap align="right" class="xl29">60</td>
															
															<td nowrap align="right" class="xl28">2004</td>
															<td nowrap align="right" class="xl28">8</td>
															<td nowrap align="right" class="xl28">120</td>														
															<td nowrap align="right" class="xl28">340,000.00</td>
															<td nowrap align="right" class="xl28">0.00</td>
															
												</tr>
												
												

										</table>
									</td>
									<td nowrap>&nbsp;</td>
								</tr>
								

						 <tr>
							
								<td nowrap class="xl28">020  0104                     </td>
								<td nowrap class="xl28" >GARANTIAS RECAUDADOR</td>
								<td nowrap align="right" class="xl28">-856,092,609.90</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">-856,092,609.90</td>
							
						</tr> 
					

						 <tr>
							
								<td nowrap class="xl28">020  0105                     </td>
								<td nowrap class="xl28" >GARANTIAS DE LICITAC</td>
								<td nowrap align="right" class="xl28">-57,046,137.97</td>
								<td nowrap align="right" class="xl28">7,359,868.74</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">-49,686,269.23</td>
							
						</tr> 
					

								<tr>
									<td nowrap>&nbsp;</td>
									<td nowrap  align="right" colspan="4">
										<table width="80%" cellpadding="0" cellspacing="0" border="1" >
											
											
											<tr>
												
														
															<td nowrap  width="10%" align="right" class="xl25">Seg</td>
														
														<td nowrap  width="10%" align="right" class="xl25">A&ntilde;o</td>
														<td nowrap  width="10%" align="right" class="xl25">Mes</td>
														<td nowrap  width="20%" align="right" class="xl25">Asiento</td>
														<td nowrap  width="20%"align="right" class="xl25">D&eacute;bitos</td>
														<td nowrap  width="20%"align="right" class="xl25">Cr&eacute;ditos</td>
														
											</tr>
								


												
												
												<tr>
													
															
																<td nowrap align="right" class="xl29">60</td>
															
															<td nowrap align="right" class="xl28">2004</td>
															<td nowrap align="right" class="xl28">8</td>
															<td nowrap align="right" class="xl28">120</td>														
															<td nowrap align="right" class="xl28">7,359,868.74</td>
															<td nowrap align="right" class="xl28">0.00</td>
															
												</tr>
												
												

										</table>
									</td>
									<td nowrap>&nbsp;</td>
								</tr>
								

						 <tr>
							
								<td nowrap class="xl28">020  0106                     </td>
								<td nowrap class="xl28" >GARANTIAS DE LICITAC</td>
								<td nowrap align="right" class="xl28">-17,923,008.65</td>
								<td nowrap align="right" class="xl28">182,408.00</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">-17,740,600.65</td>
							
						</tr> 
					

								<tr>
									<td nowrap>&nbsp;</td>
									<td nowrap  align="right" colspan="4">
										<table width="80%" cellpadding="0" cellspacing="0" border="1" >
											
											
											<tr>
												
														
															<td nowrap  width="10%" align="right" class="xl25">Seg</td>
														
														<td nowrap  width="10%" align="right" class="xl25">A&ntilde;o</td>
														<td nowrap  width="10%" align="right" class="xl25">Mes</td>
														<td nowrap  width="20%" align="right" class="xl25">Asiento</td>
														<td nowrap  width="20%"align="right" class="xl25">D&eacute;bitos</td>
														<td nowrap  width="20%"align="right" class="xl25">Cr&eacute;ditos</td>
														
											</tr>
								


												
												
												<tr>
													
															
																<td nowrap align="right" class="xl29">40</td>
															
															<td nowrap align="right" class="xl28">2004</td>
															<td nowrap align="right" class="xl28">8</td>
															<td nowrap align="right" class="xl28">120</td>														
															<td nowrap align="right" class="xl28">182,408.00</td>
															<td nowrap align="right" class="xl28">0.00</td>
															
												</tr>
												
												

										</table>
									</td>
									<td nowrap>&nbsp;</td>
								</tr>
								

						 <tr>
							
								<td nowrap class="xl28">020  0107                     </td>
								<td nowrap class="xl28" >GARANTIAS DE LICITAC</td>
								<td nowrap align="right" class="xl28">-31,267,259.46</td>
								<td nowrap align="right" class="xl28">1,136,543.67</td>
								<td nowrap align="right" class="xl28">18,967,681.83</td>
								<td nowrap align="right" class="xl28">-49,098,397.62</td>
							
						</tr> 
					

								<tr>
									<td nowrap>&nbsp;</td>
									<td nowrap  align="right" colspan="4">
										<table width="80%" cellpadding="0" cellspacing="0" border="1" >
											
											
											<tr>
												
														
															<td nowrap  width="10%" align="right" class="xl25">Seg</td>
														
														<td nowrap  width="10%" align="right" class="xl25">A&ntilde;o</td>
														<td nowrap  width="10%" align="right" class="xl25">Mes</td>
														<td nowrap  width="20%" align="right" class="xl25">Asiento</td>
														<td nowrap  width="20%"align="right" class="xl25">D&eacute;bitos</td>
														<td nowrap  width="20%"align="right" class="xl25">Cr&eacute;ditos</td>
														
											</tr>
								


												
												
												<tr>
													
															
																<td nowrap align="right" class="xl29">40</td>
															
															<td nowrap align="right" class="xl28">2004</td>
															<td nowrap align="right" class="xl28">8</td>
															<td nowrap align="right" class="xl28">100</td>														
															<td nowrap align="right" class="xl28">1,136,543.67</td>
															<td nowrap align="right" class="xl28">18,967,681.83</td>
															
												</tr>
												
												

										</table>
									</td>
									<td nowrap>&nbsp;</td>
								</tr>
								

						 <tr>
							
								<td nowrap class="xl27">020  02                       </td>
								<td nowrap class="xl27">DOCUMENTOS POR DEVOL</td>
								<td nowrap align="right" class="xl27">-7,964,489,659.80</td>
								<td nowrap align="right" class="xl27">0.00</td>
								<td nowrap align="right" class="xl27">0.00</td>
								<td nowrap align="right" class="xl27">-7,964,489,659.80</td>
							
						</tr> 
					

						 <tr>
							
								<td nowrap class="xl28">020  0201                     </td>
								<td nowrap class="xl28" >PAGARES POR GIROS Y </td>
								<td nowrap align="right" class="xl28">-3,299,659.80</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">-3,299,659.80</td>
							
						</tr> 
					

						 <tr>
							
								<td nowrap class="xl28">020  0202                     </td>
								<td nowrap class="xl28" >AVALES Y FINANZAS   </td>
								<td nowrap align="right" class="xl28">-7,961,190,000.00</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">-7,961,190,000.00</td>
							
						</tr> 
					

						 <tr>
							
								<td nowrap class="xl27">020  03                       </td>
								<td nowrap class="xl27">OTROS               </td>
								<td nowrap align="right" class="xl27">-2,393,989,646.24</td>
								<td nowrap align="right" class="xl27">0.00</td>
								<td nowrap align="right" class="xl27">0.00</td>
								<td nowrap align="right" class="xl27">-2,393,989,646.24</td>
							
						</tr> 
					

						 <tr>
							
								<td nowrap class="xl28">020  0301                     </td>
								<td nowrap class="xl28" >EQUIPOS PRESTADOS   </td>
								<td nowrap align="right" class="xl28">-3,300,689.61</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">-3,300,689.61</td>
							
						</tr> 
					

						 <tr>
							
								<td nowrap class="xl28">020  0302                     </td>
								<td nowrap class="xl28" >RESPONSABILIDAD AVAL</td>
								<td nowrap align="right" class="xl28">-2,336,190,000.00</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">-2,336,190,000.00</td>
							
						</tr> 
					

						 <tr>
							
								<td nowrap class="xl28">020  0303                     </td>
								<td nowrap class="xl28" >SERVICIOS VARIOS    </td>
								<td nowrap align="right" class="xl28">-54,498,956.63</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">0.00</td>
								<td nowrap align="right" class="xl28">-54,498,956.63</td>
							
						</tr> 
					

			</table>
		</td>
	</tr>
	<tr><td><hr></td></tr>
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" >
				<tr><td  colspan="6"  align="center" class="xl25">Par&aacute;metros</td></tr>
				<tr>
					<td colspan="3"  align="left"   class="xl25">Cuentas:</td>
					<td colspan="3"   align="right" class="xl25">Asientos Fijos:</td>
				</tr>

				
				
				
						
				
				
				
					
				

				
					
				
					<tr>
						<td width="11%">&nbsp;</td>
						
							
									
								
								<td colspan="3"  align="left" class="xl28">020 </td>
							
						
						
						
							<td width="41%">&nbsp;</td>
						
					</tr>
					
			</table>
		</td>
	</tr>
	<tr><td><hr></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

