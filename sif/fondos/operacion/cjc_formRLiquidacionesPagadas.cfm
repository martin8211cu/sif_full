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

	function Validacion() {
		document.form1.submit();
	}
	
</script>

<form action="cjc_excel.cfm?name=LiquidacionesPagadas" method="post" name="bjex"></form>

<cfinclude template="encabezadofondos.cfm">
<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
<table width="100%" border="0" >	
<tr>
	<td  align="center" colspan="2" >
	
		<form name="form1" action="cjc_RLiquidacionesPagadas.cfm" method="post">
			<input type="hidden" name="cons" value="0">
			
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
				<tr>
					<td align="left" colspan="10">
						<table border='0' cellspacing='0' cellpadding='0' width='100%'>
							<tr>
								<td class="barraboton">&nbsp;
									<a id ="ACEPTAR" href="javascript:document.form1.cons.value=1;Validacion();" onmouseover="overlib('Generar reporte',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Consultar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Consultar&nbsp;</span></a>
									<a id ="LIMPIAR" href="javascript:document.location = '../operacion/cjc_LiquidacionesPagadas.cfm';window.parent.frm_reporte.location = '../operacion/cjc_sqlRLiquidacionesPagadas.cfm'" onmouseover="overlib('Limpiar filtros',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Limpiar&nbsp;</span></a>
									<a id ="Printit" href="javascript:Printit();" onmouseover="overlib('Imprimir',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Imprimir'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Imprimir&nbsp;</span></a>
									<a id ="EXCEL" style="visibility:hidden" href="javascript:SALVAEXCEL();" onmouseover="overlib('Exportar Excel',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Exportar Excel'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Exportar&nbsp;</span></a>
								</td>
								<td class=barraboton>
									<p align=center><font color='#FFFFFF'><b> </b></font></p>
								</td>
							</tr>
						</table>					
						<input type="hidden" id="btnFiltrar" name="btnFiltrar">
					</td>
				</tr>
				 
				<tr>
					<td width="15%" align="left">No. Orden de Pago</td>
					<td >
						<INPUT TYPE="text" tabindex="1"
							NAME="ORDEN_PAGO" 
							VALUE="<cfif isdefined("form.ORDEN_PAGO")><cfoutput>#form.ORDEN_PAGO#</cfoutput></cfif>" 
							SIZE="20"  
							MAXLENGTH="20" 
							ONBLUR="fm(this,-1); " 
							ONFOCUS="this.select(); " 
							ONKEYUP="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur(); ACEPTAR();}}" 
							style=" text-align:left;">							
					</td>
				</tr>
				
				<tr>
					<td width="15%" align="left">C&oacute;digo de Fondo</td>
					<td > 
						<!--- Conlis de Fondos --->
						<cfset filfondo = false >
						<cfif not isdefined("NCJM00COD")>
							<cf_cjcConlis 	
								size		 = "20"
								tabindex     = "2"
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
								size		 = "20"  
								tabindex     = "2"
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
					<td width="15%" align="left">Fecha de Pago</td>
					<td > 
						<cfif isdefined("FECHA_PAGO")>
							<cfset FECHA = #FECHA_PAGO#>
						<cfelse>
							<cfset FECHA = "">
						</cfif>
						<cf_CJCcalendario  tabindex="3" name="FECHA_PAGO" form="form1"  value="#FECHA#">
					</td>											
				</tr>
			</table>
						
		</form>
		
	</td>		
</tr>		
</table>


<!---********************** --->
<!---** AREA DE SCRIPTS  ** --->
<!---********************** --->
<cfif isdefined("btnFiltrar")>
	<script>		
		var param="";
		<cfif isdefined("NCJM00COD") and len(NCJM00COD)>			
			param = param + "&NCJM00COD=<cfoutput>#NCJM00COD#</cfoutput>"
		</cfif>
		<cfif isdefined("ORDEN_PAGO") and len(ORDEN_PAGO)>			
			param = param + "&ORDEN_PAGO=<cfoutput>#ORDEN_PAGO#</cfoutput>"
		</cfif>
		<cfif isdefined("FECHA_PAGO") and len(FECHA_PAGO)>			
			param = param + "&FECHA_PAGO='<cfoutput>#FECHA_PAGO#</cfoutput>'"			
		</cfif>
		
		window.parent.frm_reporte.location = "../operacion/cjc_sqlRLiquidacionesPagadas.cfm?btnFiltrar=1" + param;
	</script>
</cfif>

<cfif isdefined("form.cons") and form.cons eq 1>
	<script language="JavaScript1.2" type="text/javascript">
		Mostrar();
	</script>
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function Printit() {
		window.parent.frm_reporte.focus();
		window.parent.frm_reporte.print();
	}
</script> 
