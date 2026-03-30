<!--- Generado 21/09/2004 12:27:33 --->

		
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
						<tr><td  colspan="6" align="center" class="xl25">De Agosto 2002 a Agosto 2002</td></tr>
					</table>
				</td>
			</tr>
			<tr><td><hr></td></tr>
			<tr>
				<td>
					<table width="100%" cellpadding="0" cellspacing="0" border="0" >
											
							
						<tr><td align="center" colspan="6"  class="xl26">
							
								Reporte Resumido
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
								
									<td nowrap class="xl27">0009</td>
									<td nowrap class="xl27">Bancos</td>
									<td nowrap align="right" class="xl27">0.00</td>
									<td nowrap align="right" class="xl27">1,048,489.00</td>
									<td nowrap align="right" class="xl27">8,934,619.00</td>
									<td nowrap align="right" class="xl27">-7,886,130.00</td>
								
							</tr> 
					
						
						
						
						 
					
						
							
						
	
											
							
							 <tr>
								
									<td nowrap class="xl27">0009 001</td>
									<td nowrap class="xl27">Bancos nacionales</td>
									<td nowrap align="right" class="xl27">0.00</td>
									<td nowrap align="right" class="xl27">1,048,489.00</td>
									<td nowrap align="right" class="xl27">8,934,619.00</td>
									<td nowrap align="right" class="xl27">-7,886,130.00</td>
								
							</tr> 
					
						
						
						
						 
					
						
							
						
	
											
							
							 <tr>
								
									<td nowrap class="xl28">0009 001001002</td>
									<td nowrap class="xl28" >BANCRECER CTA. 01297</td>
									<td nowrap align="right" class="xl28">0.00</td>
									<td nowrap align="right" class="xl28">1,140.00</td>
									<td nowrap align="right" class="xl28">0.00</td>
									<td nowrap align="right" class="xl28">1,140.00</td>
								
							</tr> 
					
						
						
						
						 
					
						
							
						
	
											
							
							 <tr>
								
									<td nowrap class="xl28">0009 001001003</td>
									<td nowrap class="xl28" >DEP. REFERENCIADOS C</td>
									<td nowrap align="right" class="xl28">0.00</td>
									<td nowrap align="right" class="xl28">0.00</td>
									<td nowrap align="right" class="xl28">1,140.00</td>
									<td nowrap align="right" class="xl28">-1,140.00</td>
								
							</tr> 
					
						
						
						
						 
					
						
							
						
	
											
							
							 <tr>
								
									<td nowrap class="xl28">0009 001001004</td>
									<td nowrap class="xl28" >PEMEX CTA:0013023518</td>
									<td nowrap align="right" class="xl28">-10,979.50</td>
									<td nowrap align="right" class="xl28">21,959.00</td>
									<td nowrap align="right" class="xl28">300.00</td>
									<td nowrap align="right" class="xl28">10,679.50</td>
								
							</tr> 
					
						
						
						
						 
					
						
							
						
	
											
							
							 <tr>
								
									<td nowrap class="xl28">0009 001001005</td>
									<td nowrap class="xl28" >BANCRECER CTA. 01324</td>
									<td nowrap align="right" class="xl28">0.00</td>
									<td nowrap align="right" class="xl28">0.00</td>
									<td nowrap align="right" class="xl28">100.00</td>
									<td nowrap align="right" class="xl28">-100.00</td>
								
							</tr> 
					
						
						
						
						 
					
						
							
						
	
						
						
						 
					
						
							
						
	
											
							
							 <tr>
								
									<td nowrap class="xl28">0009 001002999</td>
									<td nowrap class="xl28" >Cualquier valor</td>
									<td nowrap align="right" class="xl28">10,979.50</td>
									<td nowrap align="right" class="xl28">210.00</td>
									<td nowrap align="right" class="xl28">21,959.00</td>
									<td nowrap align="right" class="xl28">-10,769.50</td>
								
							</tr> 
					
						
						
						
						 
					
						
							
						
	
						
						
						 
					
						
							
						
	
											
							
							 <tr>
								
									<td nowrap class="xl28">0009 001005001</td>
									<td nowrap class="xl28" >sucursal San José</td>
									<td nowrap align="right" class="xl28">0.00</td>
									<td nowrap align="right" class="xl28">0.00</td>
									<td nowrap align="right" class="xl28">8,911,120.00</td>
									<td nowrap align="right" class="xl28">-8,911,120.00</td>
								
							</tr> 
					
						
						
						
						 
					
						
							
						
	
						
						
						 
					
						
							
						
	
											
							
							 <tr>
								
									<td nowrap class="xl28">0009 001008001</td>
									<td nowrap class="xl28" >BANCO SANTANDER MEXI</td>
									<td nowrap align="right" class="xl28">0.00</td>
									<td nowrap align="right" class="xl28">1,025,180.00</td>
									<td nowrap align="right" class="xl28">0.00</td>
									<td nowrap align="right" class="xl28">1,025,180.00</td>
								
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
							
								
										
									
									<td colspan="3"  align="left" class="xl28">000 9</td>
								
							
							
							
								<td width="41%">&nbsp;</td>
							
						</tr>
						
				</table>
			</td>
		</tr>
		<tr><td><hr></td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	
