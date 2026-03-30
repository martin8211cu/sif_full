<!--- 
Archivo:  cjc_formRVouchersDigitados.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    28 Agosto 2006.              
--->
<script type="text/jscript" language="javascript">
	function SALVAEXCEL() {
		var EXCEL = document.getElementById("EXCEL");
		EXCEL.style.visibility='hidden';
		
		document.bjex.submit();  
	}
	
	function Mostrar() {
		var EXCEL = document.getElementById("EXCEL");
		EXCEL.style.visibility='visible';					
	}
	
</script>

<form action="cjc_excel.cfm?name=DetalleCuentaContable" method="post" name="bjex"></form>

<cfinclude template="encabezadofondos.cfm">

<form name="form1" action="cjc_RDetalleCuentaContable.cfm" method="post">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" colspan="2" >
			<input type="hidden" name="cons" value="0">
			<!--- Inicia pintado de la barra de botones --->
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="left" colspan="10">
						<table border='0' cellspacing='0' cellpadding='0' width='100%'>
							<tr>
								<td class="barraboton">&nbsp;
									<a id ="ACEPTAR" href="javascript:ACEPTAR();" onmouseover="overlib('Generar reporte',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Consultar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Consultar&nbsp;</span></a>
									<a id ="LIMPIAR" href="javascript:LIMPIAR();" onmouseover="overlib('Limpiar filtros',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Limpiar&nbsp;</span></a>
									<a id ="Printit" href="javascript:Printit();" onmouseover="overlib('Imprimir',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Imprimir'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Imprimir&nbsp;</span></a>
									<a id ="EXCEL"   href="javascript:SALVAEXCEL();" style="visibility:hidden" onmouseover="overlib('Exportar Excel',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Exportar Excel'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Exportar&nbsp;</span></a>
								</td>
								<td class=barraboton>
									<p align=center><font color='#FFFFFF'><b> </b></font></p>
								</td>
							</tr>
						</table>					
						<input type="hidden" id="btnFiltrar" name="btnFiltrar">
					</td>
				</tr>
			</table>
			<!--- Finaliza pintado de la barra de botones --->
		</td>
	</tr>

	<tr>
		<td>
			<table  border="0" cellspacing="1" cellpadding="1" width="100%">
				<tr>
					<td width="15%" align="left">C&oacute;digo de Fondo</td>
					<td > 
						<!--- Conlis de Fondos --->
						<cfset filfondo = false >
						<cfif not isdefined("NCJM00COD")>
							<cf_cjcConlis 	
								size		 = "40"
								tabindex     = "1"
								name 		 = "NCJM00COD"
								desc 		 = "CJM00DES"
								id			 = "CJM00COD"
								cjcConlisT 	 = "cjc_traefondo"
								sizecodigo	 = 4
								frame		 = "frm_fondos"
								filtrarfondo = "#filfondo#"
							>							
						<cfelse>				
							<cfquery name="rsQryFondo" datasource="#session.Fondos.dsn#">
								SELECT CJM00COD as NCJM00COD, CJM00COD,CJM00DES 
								FROM CJM000
								where  CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NCJM00COD#" >
							</cfquery>
							<cf_cjcConlis 	
								size		 = "40"  
								tabindex     = "1"
								name 		 = "NCJM00COD" 
								desc 		 = "CJM00DES" 
								id			 = "CJM00COD" 										
								cjcConlisT 	 = "cjc_traefondo"
								sizecodigo	 = 4
								query        = "#rsQryFondo#"
								frame		 = "frm_fondos"
								filtrarfondo = "#filfondo#"
							>									
						</cfif>													
					</td>
					<td colspan="2">&nbsp;</td>
				</tr>
				
				<tr>
					<td width="15%" align="left">Objeto de Gasto Inicial</td>
					<td > 
						<cfif not isdefined("CP7SUBI")>
							<cf_cjcConlis 	
								size		 = "40"
								tabindex     = "2"
								name 		 = "CP7SUBI"
								desc 		 = "CP7DESI"
								id			 = "CP7SUBI"
								cjcConlisT 	 = "cjc_traeGasto"
								sizecodigo	 = 4
								frame		 = "frm_gastos"
							>																
						<cfelse>
							<cfif isdefined("CP7SUBI") and trim(CP7SUBI) EQ "">
								<cfset _CP7SUBI = -1>
							<cfelse>
								<cfset _CP7SUBI = CP7SUBI>
							</cfif>
							<cfquery name="rsQryGastoIni" datasource="#session.Fondos.dsn#">
								select CP7SUB as CP7SUBI, CP7DES as CP7DESI
								from CPM007
								where CP7SUB = <cfqueryparam cfsqltype="cf_sql_integer" value="#_CP7SUBI#">
							</cfquery>
							<cf_cjcConlis 	
								size		 = "40"
								tabindex     = "2"
								name 		 = "CP7SUBI"
								desc 		 = "CP7DESI"
								id			 = "CP7SUBI"
								cjcConlisT 	 = "cjc_traeGasto"
								query        = "#rsQryGastoIni#"
								sizecodigo	 = 4
								frame		 = "frm_gastos"
							>							
						</cfif>
					</td>
					<td width="15%" align="left">Objeto de Gasto Final</td>
					<td >
						<cfif not isdefined("CP7SUBF")>
							<cf_cjcConlis 	
								size		 = "40"
								tabindex     = "3"
								name 		 = "CP7SUBF"
								desc 		 = "CP7DESF"
								id			 = "CP7SUBF"
								cjcConlisT 	 = "cjc_traeGasto"
								sizecodigo	 = 4
								frame		 = "frm_gastos"
							>							
						<cfelse>
							<cfif isdefined("CP7SUBF") and trim(CP7SUBF) EQ "">
								<cfset _CP7SUBF = -1>
							<cfelse>
								<cfset _CP7SUBF = CP7SUBF>
							</cfif>
							<cfquery name="rsQryGastoFin" datasource="#session.Fondos.dsn#">
								select CP7SUB as CP7SUBF, CP7DES as CP7DESF
								from CPM007
								where CP7SUB = <cfqueryparam cfsqltype="cf_sql_integer" value="#_CP7SUBF#">
							</cfquery>
							<cf_cjcConlis 	
								size		 = "40"
								tabindex     = "3"
								name 		 = "CP7SUBF"
								desc 		 = "CP7DESF"
								id			 = "CP7SUBF"
								cjcConlisT 	 = "cjc_traeGasto"
								query        = "#rsQryGastoFin#"
								sizecodigo	 = 4
								frame		 = "frm_gastos"
							>							
						</cfif> 
					</td>											
				</tr>
							
				<tr>
					<td width="15%" align="left">Cuenta Contable</td>
					<td colspan="3" nowrap="nowrap">
						<div style="vertical-align:top">
							<cfif isdefined("CMAYOR")>
								<cfset CTA_MAYOR = #CMAYOR#>
							<cfelse>
								<cfset CTA_MAYOR = "">
							</cfif>
							
							<input type="text" 
								name="CMAYOR" 
								maxlength="4" 
								size="4" 
								width="100%" 
								onBlur="javascript:CargarCajas(this.value)" 
								value="<cfoutput>#CTA_MAYOR#</cfoutput>" 
								tabindex="4" >
							
							<iframe marginheight="0" 
								marginwidth="0" 
								scrolling="no" 
								name="cuentasIframe" 
								id="cuentasIframe" 
								width="80%" 
								height="22" 
								<cfif isdefined("CMAYOR")>
									<cfoutput>
									src="../Utiles/generacajas.cfm?Cmayor=#CTA_MAYOR#&MODO=CAMBIO&formatocuenta=#CtaFinalCompleta#"
									</cfoutput>
								</cfif>										
								frameborder="0"></iframe>
						</div>	
					</td>
				</tr>
							
				<tr>
					<td width="15%" align="left">Fecha Inicial</td>
					<td > 
						<cfif isdefined("FECHAINI")>
							<cfset FECHA_I = #FECHAINI#>
						<cfelse>
							<cfset FECHA_I = "">
						</cfif>
						<cf_CJCcalendario tabindex="5" name="FECHAINI" form="form1"  value="#FECHA_I#">
					</td>
					<td width="15%" align="left">Fecha Final</td>
					<td > 
						<cfif isdefined("FECHAFIN")>
							<cfset FECHA_F = #FECHAFIN#>
						<cfelse>
							<cfset FECHA_F = "">
						</cfif>
						<cf_CJCcalendario tabindex="6" name="FECHAFIN" form="form1"  value="#FECHA_F#">
					</td>											
				</tr>
				<input type="hidden" name="CtaFinal" value="">
				<input type="hidden" name="CtaFinalCompleta" value="">
				
			</table>
		</td>
	</tr>
</table>
</form>

<!--- Área de Script's --->
<cfif isdefined("btnFiltrar")>
	<script>
		var param="";
		<cfif isdefined("NCJM00COD") and len(NCJM00COD)>			
			param = param + "&NCJM00COD=<cfoutput>#NCJM00COD#</cfoutput>"
		</cfif>
		<cfif isdefined("CP7SUBI") and len(CP7SUBI)>			
			param = param + "&CP7SUBI=<cfoutput>#CP7SUBI#</cfoutput>"
		</cfif>
		<cfif isdefined("CP7SUBF") and len(CP7SUBF)>			
			param = param + "&CP7SUBF=<cfoutput>#CP7SUBF#</cfoutput>"
		</cfif>
		<cfif isdefined("CMAYOR") and len(CMAYOR)>			
			param = param + "&CMAYOR=<cfoutput>#CMAYOR#</cfoutput>"
		</cfif>
		<cfif isdefined("CtaFinal") and len(CtaFinal)>			
			param = param + "&CtaFinal=<cfoutput>#CtaFinal#</cfoutput>"
		</cfif>
		<cfif isdefined("CtaFinalCompleta") and len(CtaFinalCompleta)>			
			param = param + "&CtaFinalCompleta=<cfoutput>#CtaFinalCompleta#</cfoutput>"
		</cfif>				
		<cfif isdefined("FECHAINI") and len(FECHAINI)>			
			param = param + "&FECHAINI=<cfoutput>#FECHAINI#</cfoutput>"			
		</cfif>
		<cfif isdefined("FECHAFIN") and len(FECHAFIN)>			
			param = param + "&FECHAFIN=<cfoutput>#FECHAFIN#</cfoutput>"
		</cfif>

		//alert(param);
		
		PURL = "../operacion/cjc_sqlRDetalleCuentaContable.cfm?btnFiltrar=1" + param;		
		window.parent.frm_reporte.location = PURL;
	</script>
</cfif>

<cfif isdefined("form.cons") and form.cons eq 1>
	<script language="JavaScript1.2" type="text/javascript">
		Mostrar();
	</script>
</cfif>


<script language="javascript" type="text/javascript">
<!---<script language="JavaScript1.2" type="text/javascript">--->
	function ACEPTAR() {
		if (validar()) {
			document.form1.cons.value=1;
			document.form1.submit();
		}
	}
	
	function LIMPIAR() {
		document.location = '../operacion/cjc_DetalleCuentaContable.cfm';
		window.parent.frm_reporte.location = '../operacion/cjc_sqlRDetalleCuentaContable.cfm';
	}
	
	function Printit() {
		window.parent.frm_reporte.focus();
		window.parent.frm_reporte.print();
	}
	
	function validar() {
		if(document.form1.NCJM00COD.value == "") {
			alert("Digite el Código de Fondo");
			document.form1.NCJM00COD.focus();
			return false;
		}
		
		if(document.form1.CP7SUBI.value == "" && document.form1.CP7SUBF.value == "" && document.form1.CMAYOR.value == "" ) {
			alert("Digite el Objeto de Gasto o la Cuenta Contable");
			document.form1.CP7SUBI.focus();
			return false;
		}
		 
		if(document.form1.CP7SUBI.value != "" && document.form1.CP7SUBF.value == "") {
			alert("Digite el Objeto de Gasto Final");
			document.form1.CP7SUBF.focus();
			return false;
		}
		
		if(document.form1.CP7SUBI.value == "" && document.form1.CP7SUBF.value != "") {
			alert("Digite el Objeto de Gasto Inicial");
			document.form1.CP7SUBI.focus();
			return false;
		}
		
		if(document.form1.FECHAINI.value != "" && document.form1.FECHAFIN.value == "") {
			alert("Digite la Fecha Final");
			document.form1.FECHAFIN.focus();
			return false;
		}
		
		if(document.form1.FECHAINI.value == "" && document.form1.FECHAFIN.value != "") {
			alert("Digite la Fecha Inicial");
			document.form1.FECHAINI.focus();
			return false;
		}
		
		if (document.form1.CMAYOR.value != "") {
			FrameFunction();		
		}
		
		return true;
		
	}
	
	function CargarCajas(CMAYOR) {
		var fr = document.getElementById("cuentasIframe");
		fr.src =  "../Utiles/generacajas.cfm?Cmayor="+document.form1.CMAYOR.value
	}
	
	function FrameFunction() {
		//window.frames["cuentasIframe"].RetornaDetalleCuenta();
		window.frames["cuentasIframe"].RetornaDetalleCuentas();
	}		

</script> 




