<link rel='stylesheet' type='text/css' href='../js/cs_estilo_entrada.css'>
<link rel='stylesheet' type='text/css' href="../js/cs_estilo_boton.css">
<script language='javascript' src='/js/global.js'></script>
<script language='javascript' src="../js/overlib.js"></script>
<SCRIPT LANGUAGE='Javascript'  src="../js/utilies.js"></SCRIPT>
<SCRIPT LANGUAGE='Javascript'  src="../../js/qForms/qforms.js"></SCRIPT>
<script>
var bandera = "false";
function Validacion(Previo)
{
	var frame = document.getElementById("frm_validacion");		
	frame.src = "/cfmx/sif/fondos/operacion/validamarcas.cfm?Previo=" + Previo;			
	return;
}	
/*
function Validacion(Previo)
{
	//si hay mas de una liquidacion para marcar
	
	if (document.form2.DCM.length > 1)
	{
		for (i = 0; i < document.form2.DCM.length; i++) {
			
			if (document.form2.DCM[i].checked == true) {
				bandera = "true";
				break;
			}
			
		}
		if (bandera == "true") 			
		{			
			document.form2.VTPrevia.value = Previo;
			document.form2.submit(); 
		}
		else 
			alert('Debe Marcar al menos una liquidacion para poder asignar una referencia')
	}
	else
		if (document.form2.DCM.checked == true)			
		{			
			document.form2.VTPrevia.value = Previo;	
			document.form2.submit(); 
		}
		else 
			alert('Debe Marcar la liquidacion para poder asignarle la referencia')	
}*/
</script>

<cfif not isdefined("modo")>

	<cfquery name="rsListaLiq" datasource="#session.Fondos.dsn#">
	execute cj_trae_reintegrospend 
		@cjm00cod = null, 
		@numini = null, 
		@numfin = null, 
		@cjx04fli = null, 
		@rpt = 2
	</cfquery>

<cfelse>

	<cfif isdefined("CJX04FLI") and CJX04FLI neq "">
		<cfset F_CJX04FLI = #lsdateformat(CJX04FLI,"yyyymmdd")#>
	</cfif>

	<cfquery name="rsListaLiq" datasource="#session.Fondos.dsn#">
	execute cj_trae_reintegrospend 
		@cjm00cod = <cfif isdefined("CJM00COD") and CJM00COD neq "">'#CJM00COD#'<cfelse>null</cfif>, 
		@numini = <cfif isdefined("CJX04NUM1") and CJX04NUM1 neq "">#CJX04NUM1#<cfelse>null</cfif>, 
		@numfin = <cfif isdefined("CJX04NUM2") and CJX04NUM2 neq "">#CJX04NUM2#<cfelse>null</cfif>, 
		@cjx04fli = <cfif isdefined("F_CJX04FLI") and F_CJX04FLI neq "">'#F_CJX04FLI#'<cfelse>null</cfif>, 
		@rpt = 2
	</cfquery>

</cfif>

<style type="text/css">
<!--
.style1 {color: #FFFFFF}
.style2 {color: #FFFF00}
-->
.barraboton {
	background-color :  006699;
	border-color :  006699;
	color :  006699;
	border-bottom-color : Black;
	border-bottom-style : solid;
	border-bottom-width : 2px;
	border-top : 2px solid #B0C4DE;
}
.LeftNavOff  {
	BACKGROUND-COLOR : #006699;
	BORDER-BOTTOM : #006699 1px solid;
	BORDER-LEFT : #006699 1px solid;
	BORDER-RIGHT : #006699 1px solid;
	BORDER-TOP : #006699 1px solid;
	COLOR : White;
	CURSOR : hand;
	FONT-FAMILY : Verdana, Geneva, Arial, Helvetica, sans-serif;
	FONT-SIZE : 10px;
	FONT-WEIGHT : bold;
	LETTER-SPACING : 0pt;
	PADDING-BOTTOM : 0px;
	PADDING-LEFT : 3px;
	PADDING-RIGHT : 3px;
	PADDING-TOP : 0px;
	TEXT-DECORATION : none;
	WIDTH : auto;
	LINE-HEIGHT : 10pt;
	height : 10px;
	margin : 0px 0px;
}
</style>
<div id=overDiv style='POSITION:absolute; Z-INDEX:1'></div>

<table width="100%" border="0" cellpadding="2" cellspacing="0" onClick="javascript:PierdeFoco()">
<tr>
	<td>
		<table cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="barraboton">
				<script>
				function test()
				{
					var letra= document.getElementById("colores");
					alert(letra.color);
				}
				</script>
			
				<a id ='CONSULTAR' href="javascript:document.form1.cnscolor.value = '#FFFF33';document.form1.submit();" onmouseover="overlib('Consultar',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Imprimir'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;<font id="letra">Consultar</font>&nbsp;</span></a>
				<a id ='LIMPIAR' href="javascript:document.location = '../operacion/cjc_Referencias.cfm?lmpcolor=FFFF33';" onmouseover="overlib('Limpiar filtros',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;<font id="letra1">Limpiar</font>&nbsp;</span></a>				
				<a id ='VPREVIA' href="javascript:Validacion('1');" onmouseover="overlib('Vista Previa',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Aceptar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;<font id="letra2">Vista Previa</font>&nbsp;</span></a>								
				<a id ='APLICAR' href="javascript:Validacion('0');" onmouseover="overlib('Aplicar',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Aceptar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;<font id="letra3">Aplicar</font>&nbsp;</span></a>
			</td>
			<td class=barraboton>
				<p align=center><font color='#FFFFFF'><b> </b></font></p>
			</td>
		</tr>
		</table>
	
	</td>
</tr>
<tr>
	<td>                                

		<form name="form1" method="post" action="cjc_Referencias.cfm">
		
		<input type="hidden" name="cnscolor" value="<cfif isdefined('form.cnscolor')><cfoutput>#form.cnscolor#</cfoutput><cfelse>#FFFFFF</cfif>">
		<input type="hidden" name="lmpcolor" value="#<cfif isdefined('url.lmpcolor')><cfoutput>#url.lmpcolor#</cfoutput><cfelse>FFFFFF</cfif>">
		<input type="hidden" name="vprcolor" value="#<cfif isdefined('url.vprcol')><cfoutput>#url.vprcol#</cfoutput><cfelse>FFFFFF</cfif>">
		<input type="hidden" name="aplcolor" value="#<cfif isdefined('url.aplcolor')><cfoutput>#url.aplcolor#</cfoutput><cfelse>FFFFFF</cfif>">
		
		<table width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr>
			<td width="24%" align="left">Fondo de Caja:</td>
			<td width="76%">
				<cfset filfondo = false > 
				<cfif not isdefined("CJM00COD")>
					<cf_cjcConlis 	
						size		 = "30" 
						tabindex     = "1" 
						name 		 = "CJM00COD" 
						desc 		 = "CJM00DES" 
						id			 = "CJM00COD" 
						cjcConlisT 	 = "cjc_traefondo"
						frame		 = "FONDOS_FRM"
						colorfondo   = "##E8E8E8"
						filtrarfondo = "#filfondo#"
					>	
				<cfelse>				
				
					<cfquery name="rsQryFondo" datasource="#session.Fondos.dsn#">
						SELECT CJM00COD as NCJM00COD, CJM00COD,CJM00DES 
						FROM CJM000
						where  CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CJM00COD#" >
					</cfquery>						
								
					<cf_cjcConlis 	
						size		 = "20"  
						tabindex     = "1"
						name 		 = "CJM00COD" 
						desc 		 = "CJM00DES" 
						id			 = "CJM00COD" 										
						cjcConlisT 	 = "cjc_traefondo"
						query        = "#rsQryFondo#"
						frame		 = "frm_fondos"
						filtrarfondo = "#filfondo#"
					>					
				</cfif>								
			</td>
		</tr>
		<tr>
			<td width="24%" align="left">No. de Liquidacion Inicial:</td>
			<td width="76%"> 
				<INPUT TYPE="text" 
					   NAME="CJX04NUM1" 
					   VALUE="<cfif isdefined("CJX04NUM1") and CJX04NUM1 neq ""><cfoutput>#CJX04NUM1#</cfoutput></cfif>"
					   SIZE="4" 
					   MAXLENGTH="4" 
					   ONBLUR="fm(this,-1); " 
					   ONFOCUS="this.value=qf(this); this.select();" 
					   ONKEYUP="javascript: if(snumber(this,event,0)){ if(Key(event)=='13'){}}" 
					   style=" text-align:left;" 
					   tabindex="2">
			</td>	
		</tr>
		<tr>
			<td width="24%" align="left">No. de Liquidacion final:</td>
			<td width="76%"> 
				<INPUT TYPE="text" 
					   NAME="CJX04NUM2" 
					   VALUE="<cfif isdefined("CJX04NUM2") and CJX04NUM2 neq ""><cfoutput>#CJX04NUM2#</cfoutput></cfif>" 
					   SIZE="4" 
					   MAXLENGTH="4" 
					   ONBLUR="fm(this,-1); " 
					   ONFOCUS="this.value=qf(this); this.select(); " 
					   ONKEYUP="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur(); ACEPTAR();}}" 
					   style=" text-align:left;" 
					   tabindex="3">
			</td>	
		</tr>
		<tr>
			<td width="24%" align="left">Fecha de Pago:</td>
			<td width="76%"> 
				<cfif isdefined("CJX04FLI")>
					<cfset F_INICIAL = #CJX04FLI#>
				<cfelse>
					<cfset F_INICIAL = "">
				</cfif>
				<cf_CJCcalendario  tabindex ="3" name="CJX04FLI" form="form1" value="#F_INICIAL#">
			</td>	
		</tr>
		<tr>
			<td width="24%" align="left">Fecha:</td>
			<td width="76%"> 
				<table align="center" width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="2">
					<INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="CJX04FRD" VALUE="<cfoutput>#dateformat(Now(),"dd/mm/yyyy")#</cfoutput>" SIZE="12" style=" border: medium none; color:#0000FF; background-color:#FFFFFF;">					
					<!--- <cf_CJCcalendario  tabindex ="3" name="CJX04FRD" form="form1" > --->
					</td>
					<!--- 
					<td align="right">					
					<input type="button" name="aplicar" value="Aplicar" style="width:80px" onClick="javascript:Validacion()">
					<input type="reset" name="limpiar" value="Limpiar" style="width:80px">
					<input type="submit"  id="btnFiltrar" name="btnFiltrar" value="Consultar" style="width:80px">&nbsp;&nbsp;&nbsp; 
					</td>--->
				</tr>
				</table>
			</td>	
		</tr>
		
		</table>			
		<input type="hidden" name="modo" value="Cambio">
		</form>

	</td>
</tr>
<tr><td>&nbsp;</td></tr>
<tr>
	<td>	
	
		<form name="form2" method="post" action="cjc_AsignarReferenciasSQL.cfm">
		<input type="hidden" name="VTPrevia" value="0">
		<table border='0' cellspacing='1' cellpadding='1' style='font-family: Arial; font-size: 9pt' width="100%">  
		<tr>
			<td>
			<iframe id="FRAMEMARCAS" name="FRAMEMARCAS" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>		
			</td>
		</tr>				
		<tr>    
			<td  align='center' bgcolor='#008080'><font color='#FFFFFF'><strong></strong></font></td>
			<td  align='center' bgcolor='#008080'><font color='#FFFFFF'><strong>C&oacute;digo</strong></font></td>
			<td  align='center' bgcolor='#008080'><font color='#FFFFFF'><strong>Fondo</strong></font></td>
			<td  align='center' bgcolor='#008080'><font color='#FFFFFF'><strong>Relaci&oacute;n de reintegro</strong></font></td>
			<td  align='center' bgcolor='#008080'><font color='#FFFFFF'><strong>Fecha Pago</strong></font></td>
			<td  align='center' bgcolor='#008080'><font color='#FFFFFF'><strong>Usuario del fondo</strong></font></td>
			<td  align='center' bgcolor='#008080'><font color='#FFFFFF'><strong>Monto a reintegrar</strong></font></td>  
			<td  align='center' bgcolor='#008080'><font color='#FFFFFF'><strong>Tipo</strong></font></td>  
			<td  align='center' bgcolor='#008080'><font color='#FFFFFF'><strong>Usuario</strong></font></td>  			
		</tr>
		<cfset indice=0>
		<cfset ctacampo=1>
		<cfoutput query="rsListaLiq">
		<cfif (indice mod 2) eq 0>
			<cfset color = "##CECECE">
		<cfelse>
			<cfset color = "##EFEFEF">
		</cfif>
		<TR>
			<td align='center' bgcolor='#color#'>
			<input type='checkbox' name='DCM' <cfif #CJX04IND# eq 'S'>checked</cfif> cancheck='true' style="background-color: #color# " value='#CJM00COD#-#CJX04NUM#' onClick="javascript:MarcarLiquidacion('#CJM00COD#','#CJX04NUM#',this,document.form2.campousr#ctacampo#,'#indice#')">
			</td>
			<td  align='left' bgcolor='#color#'>#CJM00COD#</td>
			<td  align='left' bgcolor='#color#'>#CJM00DES#</td>
			<td  align='center' bgcolor='#color#'>#CJX04NUM#</td>
			<td  align='left' bgcolor='#color#'>#CJX04FLI#</td>
			<td  align='right' bgcolor='#color#'>#CJX04URF#</td>
			<td  align='right' bgcolor='#color#'>#COMPUTED_COLUMN_6#</td>
			<td  align='center' bgcolor='#color#'>#Tipo#</td>
			<td  id="usr" align='center' bgcolor='#color#'>			
					<INPUT  tabindex="-1" 
							ONFOCUS="this.blur();" 
							NAME="campousr#ctacampo#" 
							VALUE="#CJX04UMK#" 
							size="6"  
							style=" border: medium none;
									text-align:left; 
									font:'Times New Roman'; 
									font-size:13px;
									background:#color#"
							tabindex="2"
						>				
			</td>
		</TR>
		<cfset indice= indice + 1>
		<cfset ctacampo=ctacampo+1>
		</cfoutput>
		</TABLE>
		</form>		
	</td>
</tr>
</table>


<script>
	var ltr = document.getElementById("letra");
	var ltr1 = document.getElementById("letra1");
	var ltr2 = document.getElementById("letra2");
	var ltr3 = document.getElementById("letra3");
	
	ltr.style.color  = document.form1.cnscolor.value
	ltr1.style.color = document.form1.lmpcolor.value
	ltr2.style.color = document.form1.vprcolor.value
	ltr3.style.color = document.form1.aplcolor.value
	
	function PierdeFoco()
	{		
		var ltr = document.getElementById("letra");
		var ltr1 = document.getElementById("letra1");
		var ltr2 = document.getElementById("letra2");
		var ltr3 = document.getElementById("letra3");
		ltr.style.color = "#FFFFFF";
		ltr1.style.color = "#FFFFFF";
		ltr2.style.color = "#FFFFFF";
		ltr3.style.color = "#FFFFFF";
	}


	function MarcarLiquidacion(fondo,liquidacion,obj,objtxt,indice) {
		var CJM00COD = fondo;
		var CJX04NUM = liquidacion;
		var PARAMS = "?CJM00COD="+CJM00COD+"&CJX04NUM="+CJX04NUM+"&indice="+indice
		var frame  = document.getElementById("FRAMEMARCAS");
		frame.src 	= "/cfmx/sif/fondos/operacion/cjc_Marcaliquidacion.cfm" + PARAMS;
		
		if (obj.checked == true)
			objtxt.value = '<cfoutput>#session.usuario#</cfoutput>';		
		else
			objtxt.value = '';
	}
</script>
<iframe name="frm_validacion" id="frm_validacion" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility:hidden"></iframe>
