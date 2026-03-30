<cfinclude template="encabezadofondos.cfm">

<script>
function esconder(ban) {
	var tablabotones = document.getElementById("tablaboton");	
	if (ban == 1)
		tablabotones.style.display = 'none';
	else
		tablabotones.style.display = ''
}
function Validacion()
{
	if (document.form1.CJX19RELini.value == "" && 
	    document.form1.CJX19RELfin.value == "" && 
		document.form1.NCJM00COD.value == "" && 
		document.form1.NCJ01ID.value == "")
		alert("Es necesario proporcionar al menos uno de los filtros solicitados")
	else
		document.form1.submit();
}
</script>

<table width="100%" border="0" >	
<tr>
	<td  align="center" colspan="2" >

			<form name="form1" action="../operacion/cjc_EEstadoRelaciones.cfm" method="post">
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
				<tr>
					<td align="left" colspan="10">
					
					
						<table border='0' cellspacing='0' cellpadding='0' width='100%'>
						<tr>
							<td class="barraboton">&nbsp;
								<a id ='ACEPTAR' href="javascript:Validacion();" onmouseover="overlib('Generar reporte',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Aceptar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Consultar&nbsp;</span></a>								
								<a id ='REGRESAR' href="javascript:esconder(1);history.go(-1);" onmouseover="overlib('Generar reporte',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Aceptar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav id="tablaboton" style="display:none ">&nbsp;Regresar&nbsp;</span></a>
								<a id ='LIMPIAR' href="javascript:document.location = '../operacion/cjc_EstadoRelaciones.cfm';window.parent.frm_fondos.location = '../operacion/cjc_sqlEstadoRelaciones.cfm'" onmouseover="overlib('Limpiar filtros',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Limpiar&nbsp;</span></a>
								<a id ='Printit' href="javascript:Printit();" onmouseover="overlib('Imprimir',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Imprimir'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Imprimir&nbsp;</span></a>
								<!--- <a id = 'ACEPTAR' href="javascript:ACEPTAR('S');" onmouseover="overlib('Exportar a excel',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Exportar'; return true;" onmouseout="nd();"><span class=LeftNavOff buttonType=LeftNav>&nbsp;Exportar&nbsp;</span></a> --->								
							</td>
							<td class=barraboton>
								<p align=center><font color='#FFFFFF'><b> </b></font></p>
							</td>
						</tr>
						</table>					
						<input type="hidden" id="btnFiltrar" name="btnFiltrar">
					</td>
				</tr>
<!--- 				<tr>	
					<td align="center" colspan="4" nowrap bgcolor="#CCCCCC">
							<strong>Filtros</strong>
					</td>
				</tr>     --->	
				<tr>
					<td width="17%" align="left">Relaci&oacute;n inicial</td>
					<td width="34%"> 
						<!--- Conlis de Relaciones --->
						<INPUT 	TYPE="textbox" 
									NAME="CJX19RELini" 
									VALUE="<cfif isdefined("form.CJX19RELini")><cfoutput>#form.CJX19RELini#</cfoutput></cfif>" 
									SIZE="10" 
									MAXLENGTH="10" 
									ONBLUR="" 
									ONFOCUS="this.select();" 
									ONKEYUP="" 
									tabindex="1"
							>
					</td>
					<td width="15%" align="left">Relaci&oacute;n final</td>
					<td width="34%"> 
						<!--- Conlis de Relaciones --->
						<INPUT 	TYPE="textbox" 
									NAME="CJX19RELfin" 
									VALUE="<cfif isdefined("form.CJX19RELfin")><cfoutput>#form.CJX19RELfin#</cfoutput></cfif>" 
									SIZE="10" 
									MAXLENGTH="10" 
									ONBLUR="" 
									ONFOCUS="this.select();" 
									ONKEYUP="" 
									tabindex="1"
							>						
					</td>					
				</tr>
				<tr>
					<td width="17%" align="left">Fondo</td>
					<td width="34%"> 
						<!--- Conlis de Fondos --->
						<cfset filfondo = true >
						<cfif not isdefined("NCJM00COD")>
							<cf_cjcConlis 	
								size		= "20"
								tabindex    = "1"
								name 		= "NCJM00COD"
								desc 		= "CJM00DES"
								id			= "CJM00COD"
								cjcConlisT 	= "cjc_traefondo"
								sizecodigo	= 4
								frame		= "frm_fondos"
								filtrarfondo = "#filfondo#"
							>							
						<cfelse>				
							<cfquery name="rsQryFondo" datasource="#session.Fondos.dsn#">
								SELECT CJM00COD as NCJM00COD, CJM00COD,CJM00DES 
								FROM CJM000
								where  CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NCJM00COD#" >
							</cfquery>						
								
							<cf_cjcConlis 	
								size		="20"  
								tabindex    ="1"
								name 		="NCJM00COD" 
								desc 		="CJM00DES" 
								id			="CJM00COD" 										
								cjcConlisT 	="cjc_traefondo"
								sizecodigo	= 4
								query       ="#rsQryFondo#"
								frame		="frm_fondos"
								filtrarfondo = "#filfondo#"
							>				
						</cfif>				
					</td>
					<td width="15%" align="left">Caja</td>
					<td width="34%"> 
						
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
					<td width="17%" align="left">Digitada Desde</td>
					<td width="34%"> 
						<cfif isdefined("INI_CJX19FED")>
							<cfset F_INICIAL = #INI_CJX19FED#>
						<cfelse>
							<cfset F_INICIAL = "">
						</cfif>
						<cf_CJCcalendario  tabindex="1" name="INI_CJX19FED" form="form1"  value="#F_INICIAL#">
					</td>
					<td width="15%" align="left">Digitada Hasta</td>
					<td width="34%"> 
						<cfif isdefined("FIN_CJX19FED")>
							<cfset F_FINAL = #FIN_CJX19FED#>
						<cfelse>
							<cfset F_FINAL = "">
						</cfif>
						<cf_CJCcalendario  tabindex="1" name="FIN_CJX19FED" form="form1"  value="#F_FINAL#">
					</td>					
				</tr>	
				<tr>
					<td width="17%" align="left">Estado</td>
					<td width="34%"> 
						<select name="RELEST">						
							<option value="1" <cfif isdefined("RELEST") and RELEST eq 1>selected</cfif>>TODAS</option>
							<option value="2" <cfif isdefined("RELEST") and RELEST eq 2>selected</cfif>>CONCILIADA</option>
							<option value="3" <cfif isdefined("RELEST") and RELEST eq 3>selected</cfif>>NO CONCILIADA</option>
						</select>
					</td>
					<td width="17%" align="left">Documentos</td>
					<td width="34%"> 
						<select name="INFOSEG">						
							<option value="1" <cfif isdefined("INFOSEG") and INFOSEG eq 1>selected</cfif>>ENCABEZADO</option>
							<option value="2" <cfif isdefined("INFOSEG") and INFOSEG eq 2>selected</cfif>>DETALLES</option>
						</select>
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
		<cfif isdefined("CJX19RELini") and len(CJX19RELini)>			
			param = param + "&CJX19RELini=<cfoutput>#CJX19RELini#</cfoutput>"
		</cfif>
		<cfif isdefined("CJX19RELfin") and len(CJX19RELfin)>			
			param = param + "&CJX19RELfin=<cfoutput>#CJX19RELfin#</cfoutput>"
		</cfif>				
		<cfif isdefined("NCJM00COD") and len(NCJM00COD)>			
			param = param + "&NCJM00COD=<cfoutput>#NCJM00COD#</cfoutput>"
		</cfif>
		<cfif isdefined("NCJ01ID") and len(NCJ01ID)>			
			param = param + "&NCJ01ID=<cfoutput>#NCJ01ID#</cfoutput>"
		</cfif>
		<cfif isdefined("INI_CJX19FED") and len(INI_CJX19FED)>			
			param = param + "&INI_CJX19FED='<cfoutput>#INI_CJX19FED#</cfoutput>'"			
		</cfif>
		<cfif isdefined("FIN_CJX19FED") and len(FIN_CJX19FED)>			
			param = param + "&FIN_CJX19FED='<cfoutput>#FIN_CJX19FED#</cfoutput>'"
		</cfif>
		<cfif isdefined("RELEST")>			
			param = param + "&RELEST=<cfoutput>#RELEST#</cfoutput>"
		</cfif>
		<cfif isdefined("INFOSEG")>			
			param = param + "&INFOSEG=<cfoutput>#INFOSEG#</cfoutput>"
		<cfelse>
			param = param + "&INFOSEG=1"
		</cfif>				
		window.parent.frm_fondos.location = "../operacion/cjc_sqlEstadoRelaciones.cfm?btnFiltrar=1" + param;
		
	</script>

</cfif>


<script language="JavaScript1.2" type="text/javascript">
function Printit() {
	window.parent.frm_fondos.focus();
	window.parent.frm_fondos.print();	
}
</script> 