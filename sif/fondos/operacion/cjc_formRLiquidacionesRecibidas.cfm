<!--- 
Archivo:  cjc_formRLiquidacionesRecibidas.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    09 Noviembre 2006.              
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

<form action="cjc_excel.cfm?name=LiquidacionesRecibidas" method="post" name="bjex"></form>

<cfinclude template="encabezadofondos.cfm">

<form name="form1" action="cjc_RLiquidacionesRecibidas.cfm" method="post">
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
									<a id ="ACEPTAR" href="javascript:ACEPTAR();" onMouseOver="overlib('Generar reporte',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Consultar'; return true;" onMouseOut="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Consultar&nbsp;</span></a>
									<a id ="LIMPIAR" href="javascript:LIMPIAR();" onMouseOver="overlib('Limpiar filtros',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onMouseOut="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Limpiar&nbsp;</span></a>
									<a id ="Printit" href="javascript:Printit();" onMouseOver="overlib('Imprimir',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Imprimir'; return true;" onMouseOut="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Imprimir&nbsp;</span></a>
									<a id ="EXCEL"   href="javascript:SALVAEXCEL();" style="visibility:hidden" onMouseOver="overlib('Exportar Excel',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Exportar Excel'; return true;" onMouseOut="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Exportar&nbsp;</span></a>
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
				</tr>
				
				<tr>
					<td width="15%" align="left">Usuario</td>
					<td >
						<cfif not isdefined("NCGE20NOL")>
							<cf_cjcConlis 	
								size		 = "50"
								tabindex     = "2"
								name 		 = "NCGE20NOL"
								desc 		 = "CGE20NOC"
								id			 = "CGE20NOL"
								cjcConlisT 	 = "cjc_traeUsuario"
								sizecodigo	 = 30
								frame		 = "frm_usuario"
							>																
						<cfelse>
							<cfquery name="rsQryUsuarios" datasource="#session.Fondos.dsn#">
								select CGE20NOL as NCGE20NOL, CGE20NOL, CGE20NOC 
								from CGE020
								where CGE20NOL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NCGE20NOL#">
							</cfquery>
							<cf_cjcConlis 	
								size		 = "50"
								tabindex     = "2"
								name 		 = "NCGE20NOL"
								desc 		 = "CGE20NOC"
								id			 = "CGE20NOL"
								cjcConlisT 	 = "cjc_traeUsuario"
								query        = "#rsQryUsuarios#"
								sizecodigo	 = 30
								frame		 = "frm_usuario"
							>							
						</cfif>
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
						<cf_CJCcalendario tabindex="3" name="FECHAINI" form="form1"  value="#FECHA_I#">
					</td>
				</tr>

				<tr>
					<td width="15%" align="left">Fecha Final</td>
					<td > 
						<cfif isdefined("FECHAFIN")>
							<cfset FECHA_F = #FECHAFIN#>
						<cfelse>
							<cfset FECHA_F = "">
						</cfif>
						<cf_CJCcalendario tabindex="4" name="FECHAFIN" form="form1"  value="#FECHA_F#">
					</td>											
				</tr>

				<tr>
					<td width="15%" align="left">Ver Reporte</td>
					<td >
						<select name="REPORTE" size="1" tabindex="5" style="font-size:8pt;  font-family: Courier New;">
							<option value="1" <cfif isdefined("form.REPORTE") and len(form.REPORTE) and form.REPORTE eq "1">selected</cfif>>Detallado</option>
							<option value="2" <cfif isdefined("form.REPORTE") and len(form.REPORTE) and form.REPORTE eq "2">selected</cfif>>Resumido</option>
						</select>
					</td>
				</tr>
				
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
		<cfif isdefined("NCGE20NOL") and len(NCGE20NOL)>			
			param = param + "&NCGE20NOL=<cfoutput>#NCGE20NOL#</cfoutput>"
		</cfif>
		<cfif isdefined("FECHAINI") and len(FECHAINI)>			
			param = param + "&FECHAINI=<cfoutput>#FECHAINI#</cfoutput>"			
		</cfif>
		<cfif isdefined("FECHAFIN") and len(FECHAFIN)>			
			param = param + "&FECHAFIN=<cfoutput>#FECHAFIN#</cfoutput>"
		</cfif>
		<cfif isdefined("REPORTE") and len(REPORTE)>			
			param = param + "&REPORTE=<cfoutput>#REPORTE#</cfoutput>"
		</cfif>

		PURL = "../operacion/cjc_sqlRLiquidacionesRecibidas.cfm?btnFiltrar=1" + param;		
		window.parent.frm_reporte.location = PURL;
	</script>
</cfif>

<cfif isdefined("form.cons") and form.cons eq 1>
	<script language="JavaScript1.2" type="text/javascript">
		Mostrar();
	</script>
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function ACEPTAR() {
		if (validar()) {
			document.form1.cons.value=1;
			document.form1.submit();
		}
	}
	
	function LIMPIAR() {
		document.location = '../operacion/cjc_LiquidacionesRecibidas.cfm';
		window.parent.frm_reporte.location = '../operacion/cjc_sqlRLiquidacionesRecibidas.cfm';
		document.form1.NCJM00COD.focus();
	}
	
	function Printit() {
		window.parent.frm_reporte.focus();
		window.parent.frm_reporte.print();
	}
	
	function validar() {
		if(document.form1.FECHAINI.value == "" && document.form1.FECHAFIN.value == "") {
			alert("Digite el Rango de Fechas (Fecha Inicial - Fecha Final)");
			document.form1.FECHAINI.focus();
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

		return true;
	}
</script> 
