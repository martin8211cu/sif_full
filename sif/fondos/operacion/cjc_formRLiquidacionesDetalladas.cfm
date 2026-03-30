<cfinclude template="encabezadofondos.cfm">
<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
<cfif isdefined("RbtnFiltrar")>gg</cfif>
<table width="100%" border="0" >	
<tr>
	<td  align="center" colspan="2" >

			<form name="form1" action="cjc_RLiquidacionesDetalladas.cfm" method="post">
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
				<tr>
					<td align="left" colspan="10">
					
					
						<table border='0' cellspacing='0' cellpadding='0' width='100%'>
						<tr>
							<td class="barraboton">&nbsp;
								<a id ="ACEPTAR" href="javascript:document.form1.submit();" onmouseover="overlib('Generar reporte',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Consultar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Consultar&nbsp;</span></a>
								<a id ="LIMPIAR" href="javascript:document.location = '../operacion/cjc_LiquidacionesDetalladas.cfm';window.parent.frm_reporte.location = '../operacion/cjc_sqlRLiquidacionesDetalladas.cfm'" onmouseover="overlib('Limpiar filtros',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Limpiar&nbsp;</span></a>
								<a id ="Printit" href="javascript:Printit();" onmouseover="overlib('Imprimir',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Imprimir'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Imprimir&nbsp;</span></a>
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
					<td width="14%" align="left">Fondo</td>
					<td width="34%"> 
						<!--- Conlis de Fondos --->
						<cfset filfondo = true >
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
		
					<td width="10%" align="left">Caja</td>
					<td width="42%"> 
						
						<cfif not isdefined("NCJ01ID")>
							<!--- Conlis de Cajas --->
							<cf_cjcConlis 	
								size		= "15"
								tabindex    = "1"
								name 		= "NCJ01ID"
								desc 		= "CJ1DES"
								id			= "CJ01ID"
								sizecodigo	= 10
								cjcConlisT 	= "cjc_traecaja"
								frame		= "frm_cajas">			
							
						<cfelse>				
						
							<cfquery name="rsQryCaja" datasource="#session.Fondos.dsn#">
								SELECT CJ01ID as NCJ01ID, CJ01ID,CJ1DES
								FROM CJM001
								where CJ01ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NCJ01ID#" >
							</cfquery>						
								
							<!--- Conlis de Cajas --->
							<cf_cjcConlis 	
								size		= "15"
								tabindex    = "1"
								name 		= "NCJ01ID"
								desc 		= "CJ1DES"
								id			= "CJ01ID"
								sizecodigo	= 10
								cjcConlisT 	= "cjc_traecaja"
								query       ="#rsQryCaja#"
								frame		= "frm_cajas">			
		
						
						</cfif>													
					</td>					
				</tr> 
				<tr>
					<td width="10%" align="left">Proveedor</td>
					<td width="42%"> 
						<!--- Conlis de Proveedores --->
						<cfif isdefined("PROCOD")>
								<cfquery name="rsProveedor" datasource="#session.Fondos.dsn#">
									SELECT PROCED, PROCOD, PRONOM
									FROM CPM002
									where  PROCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PROCOD#" >
								</cfquery>												
								
								<cf_cjcConlis 	
										size		="20"  
										tabindex    ="1"
										name 		="PROCED" 
										desc 		="PRONOM" 
										id			="PROCOD" 
										onfocus		="validaProv()" 
										cjcConlisT 	="cjc_traeProv"
										query       ="#rsProveedor#"
										frame		="PROCED_FRM"
								>
						<cfelse>	
								<cf_cjcConlis 	
										tabindex    ="1"
										size		="20"  
										name 		="PROCED" 
										desc 		="PRONOM" 
										id			="PROCOD" 
										onfocus		="validaProv()" 
										cjcConlisT 	="cjc_traeProv"
										frame		="PROCED_FRM"
								>
						</cfif>
		
					</td>					
					<td width="14%" align="left">Fecha Inicial</td>
					<td width="34%"> 
						<cfif isdefined("INI_FECHAINI")>
							<cfset F_INICIAL = #INI_FECHAINI#>
						<cfelse>
							<cfset F_INICIAL = "">
						</cfif>
						<cf_CJCcalendario  tabindex="1" name="INI_FECHAINI" form="form1"  value="#F_INICIAL#">
					</td>					
				</tr>				
				<tr>					
					<td width="10%" align="left">Empleado</td>
					<td width="42%"> 
						<cfif isdefined("EMPCOD")>
						
							<cfquery name="rsEmpleado" datasource="#session.Fondos.dsn#">
							SELECT EMPCOD,EMPCED,EMPNOM +' '+EMPAPA+' '+EMPAMA  NOMBRE FROM PLM001 
							where  EMPCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPCOD#" >
							</cfquery>						
						
							<cf_cjcConlis 	
									size		="20"  
									tabindex    ="1"
									name 		="EMPCED" 
									desc 		="NOMBRE" 
									id			="EMPCOD" 									
									cjcConlisT 	="cjc_traeEmpRLiq"
									query       ="#rsEmpleado#"
									frame		="EMPCED_FRM"
							>			
						<cfelse>
							<cf_cjcConlis 	
									size		="20" 
									tabindex    ="1" 
									name 		="EMPCED" 
									desc 		="NOMBRE" 
									id			="EMPCOD" 									
									cjcConlisT 	="cjc_traeEmpRLiq"
									frame		="EMPCED_FRM"
							>
						</cfif>				
					</td>	
					<td width="14%" align="left">Fecha Final</td>
					<td width="34%"> 
						<cfif isdefined("FIN_FECHAFIN")>
							<cfset F_FINAL = #FIN_FECHAFIN#>
						<cfelse>
							<cfset F_FINAL = "">
						</cfif>
						<cf_CJCcalendario  tabindex="1" name="FIN_FECHAFIN" form="form1"  value="#F_FINAL#">
					</td>											
				</tr>
				<tr>
					<td width="14%" align="left">Número liquidaci&oacute;n</td>
					<td width="34%" colspan="3"> 
					<INPUT TYPE="text" 
							NAME="CJ3NUM" 
							VALUE="<cfif isdefined("form.CJ3NUM")><cfoutput>#form.CJ3NUM#</cfoutput></cfif>" 
							SIZE="4"  
							MAXLENGTH="4" 
							ONBLUR="fm(this,-1); " 
							ONFOCUS="this.value=qf(this); this.select(); " 
							ONKEYUP="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur(); ACEPTAR();}}" 
							style=" text-align:left;">
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
		<cfif isdefined("PROCOD") and len(PROCOD)>			
			param = param + "&PROCOD=<cfoutput>#PROCOD#</cfoutput>"
		</cfif>
		<cfif isdefined("EMPCOD") and len(EMPCOD)>			
			param = param + "&EMPCOD=<cfoutput>#EMPCOD#</cfoutput>"
		</cfif>				
		<cfif isdefined("NCJM00COD") and len(NCJM00COD)>			
			param = param + "&NCJM00COD=<cfoutput>#NCJM00COD#</cfoutput>"
		</cfif>
		<cfif isdefined("NCJ01ID") and len(NCJ01ID)>			
			param = param + "&NCJ01ID=<cfoutput>#NCJ01ID#</cfoutput>"
		</cfif>
		<cfif isdefined("INI_FECHAINI") and len(INI_FECHAINI)>			
			param = param + "&INI_FECHAINI='<cfoutput>#INI_FECHAINI#</cfoutput>'"			
		</cfif>
		<cfif isdefined("FIN_FECHAFIN") and len(FIN_FECHAFIN)>			
			param = param + "&FIN_FECHAFIN='<cfoutput>#FIN_FECHAFIN#</cfoutput>'"
		</cfif>
		<cfif isdefined("CJ3NUM") and len(CJ3NUM)>			
			param = param + "&CJ3NUM=<cfoutput>#CJ3NUM#</cfoutput>"
		</cfif>		
		window.parent.frm_reporte.location = "../operacion/cjc_sqlRLiquidacionesDetalladas.cfm?btnFiltrar=1" + param;
		
	</script>

</cfif>


<script language="JavaScript1.2" type="text/javascript">
function Printit() {
	window.parent.frm_reporte.focus();
	window.parent.frm_reporte.print();
}
</script> 