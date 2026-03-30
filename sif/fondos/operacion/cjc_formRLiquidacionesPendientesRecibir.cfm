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

<form action="cjc_excel.cfm?name=LiquidacionesPendientes" method="post" name="bjex"></form>

<cfinclude template="encabezadofondos.cfm">
<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
<table width="100%" border="0" >	
<tr>
	<td  align="center" colspan="2" >
	
		<form name="form1" action="cjc_RLiquidacionesPendientesRecibir.cfm" method="post">
			<input type="hidden" name="cons" value="0">
			
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
				<tr>
					<td align="left" colspan="10">
						<table border='0' cellspacing='0' cellpadding='0' width='100%'>
							<tr>
								<td class="barraboton">&nbsp;
									<a id ="ACEPTAR" href="javascript:document.form1.cons.value=1;document.form1.submit();" onmouseover="overlib('Generar reporte',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Consultar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Consultar&nbsp;</span></a>
									<a id ="LIMPIAR" href="javascript:document.location = '../operacion/cjc_LiquidacionesPendientesRecibir.cfm';window.parent.frm_reporte.location = '../operacion/cjc_sqlRLiquidacionesPendientesRecibir.cfm'" onmouseover="overlib('Limpiar filtros',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Limpiar&nbsp;</span></a>
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
					<td width="15%" align="left">C&oacute;digo de Fondo</td>
					<td > 
						<!--- Conlis de Fondos --->
						<cfset filfondo = false >
						<cfif not isdefined("NCJM00COD")>
							<cf_cjcConlis 	
								size		 = "20"
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
								size		 = "20"  
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
					<td width="20%" align="left">No. Liquidaci&oacute;n Inicial</td>
					<td >
						<INPUT TYPE="text"  tabindex="2" 
							NAME="CJ4NUM1" 
							VALUE="<cfif isdefined("form.CJ4NUM1")><cfoutput>#form.CJ4NUM1#</cfoutput></cfif>" 
							SIZE="4"  
							MAXLENGTH="4" 
							ONBLUR="fm(this,-1); " 
							ONFOCUS="this.value=qf(this); this.select(); " 
							ONKEYUP="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur(); ACEPTAR();}}" 
							style=" text-align:left;">							
					</td>
				</tr>

				<tr>
					<td width="20%" align="left">No. Liquidaci&oacute;n Final</td>
					<td >
						<INPUT TYPE="text" tabindex="3" 
							NAME="CJ4NUM2" 
							VALUE="<cfif isdefined("form.CJ4NUM2")><cfoutput>#form.CJ4NUM2#</cfoutput></cfif>" 
							SIZE="4"  
							MAXLENGTH="4" 
							ONBLUR="fm(this,-1); " 
							ONFOCUS="this.value=qf(this); this.select(); " 
							ONKEYUP="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur(); ACEPTAR();}}" 
							style=" text-align:left;">							
					</td>
				</tr>
								
				<tr>
					<td width="15%" align="left">Tipo de Liquidaci&oacute;n</td>
				  	<td > 
						<select name="CJ4TIP" tabindex="4" >					
							<option value="0" <cfif isdefined("CJ4TIP") and CJ4TIP eq "0">selected</cfif>>Todas</option>
							<option value="1" <cfif isdefined("CJ4TIP") and CJ4TIP eq "1">selected</cfif>>Efectivo</option>
							<option value="2" <cfif isdefined("CJ4TIP") and CJ4TIP eq "2">selected</cfif>>Tarjeta</option>
						</select>							
					</td>															
				</tr>
				
				<tr>					
					<td width="15%" align="left">Fecha</td>
					<td > 
						<cfif isdefined("FECHA_CALCULO")>
							<cfset FECHA = #FECHA_CALCULO#>
						<cfelse>
							<cfset FECHA = "">
						</cfif>
						<cf_CJCcalendario  tabindex="5" name="FECHA_CALCULO" form="form1"  value="#FECHA#">
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
		<cfif isdefined("CJ4NUM1") and len(CJ4NUM1)>			
			param = param + "&CJ4NUM1=<cfoutput>#CJ4NUM1#</cfoutput>"
		</cfif>
		<cfif isdefined("CJ4NUM2") and len(CJ4NUM2)>			
			param = param + "&CJ4NUM2=<cfoutput>#CJ4NUM2#</cfoutput>"
		</cfif>
		<cfif isdefined("CJ4TIP") and len(CJ4TIP)>			
			param = param + "&CJ4TIP=<cfoutput>#CJ4TIP#</cfoutput>"
		</cfif>
		<cfif isdefined("FECHA_CALCULO") and len(FECHA_CALCULO)>			
			param = param + "&FECHA_CALCULO='<cfoutput>#FECHA_CALCULO#</cfoutput>'"			
		</cfif>
		
		window.parent.frm_reporte.location = "../operacion/cjc_sqlRLiquidacionesPendientesRecibir.cfm?btnFiltrar=1" + param;
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
