<link rel='stylesheet' type='text/css' href='../js/cs_estilo_entrada.css'>
<link rel='stylesheet' type='text/css' href="../js/cs_estilo_boton.css">
<script language='javascript' src="../js/overlib.js"></script>
<script>	
	var win = null;
	function newWindow(mypage,myname,w,h,features) 
	{
		  var winl = (screen.width-w)/2;
		  var wint = (screen.height-h)/2;
		  if (winl < 0) winl = 0;
		  if (wint < 0) wint = 0;
		  var settings = 'height=' + h + ',';
		  settings += 'width=' + w + ',';
		  settings += 'top=' + wint + ',';
		  settings += 'left=' + winl + ',';
		  settings += features;
		  win = window.open(mypage,myname,settings);
		  win.window.focus();
	}

	function Consulta()
	{		
	
		if (document.form1.CJM00COD.value != "")
		{
			if (document.form1.CJX04NUM1.value != "")
			{
				document.form1.submit();
			}
			else
				alert("No es posible hacer la consulta ya que si digita un\n fondo debe digitar tambien un numero de liquidacion");
		}
		else
		{
			if (document.form1.CJX04NUM1.value != "")
			{
				alert("No es posible hacer la consulta ya que si digita un\n fondo debe digitar tambien un numero de liquidacion");		
			}
			else
				document.form1.submit();
		}	
	}
</script>

<cfif isdefined("modo")>

	<cfset filtro="CJX04REF2 is not null">
	<cfif isdefined("form.CJM00COD") or isdefined("form.CJX04REF2") or isdefined("form.CJX04NUM1")>
		
		<cfif isdefined("form.CJM00COD") and len(form.CJM00COD)>
			<cfset filtro = filtro & " AND CJM00COD = '" & #form.CJM00COD# & "'">
		</cfif>
		<cfif isdefined("form.CJX04REF2") and len(form.CJX04REF2)>
			<cfset filtro = filtro & " AND CJX04REF2 = '" & #form.CJX04REF2# & "'">
		</cfif>
		<cfif isdefined("form.CJX04NUM1") and len(form.CJX04NUM1)>
			<cfset filtro = filtro & " AND CJX04NUM = " & #form.CJX04NUM1#>
		</cfif>
		
	</cfif>
	
	<cfquery name="rsMuestraRef" datasource="#session.Fondos.dsn#">
	Select distinct CJX04REF2, CJX04FRD, CJX04URD, 
	(Select count(1) from CJX004 B where A.CJX04REF2 = B.CJX04REF2) as totalliq,
	(Select sum(isnull(CJX04MON,0) + isnull(CJX04TGT,0)) from CJX004 B where A.CJX04REF2 = B.CJX04REF2) as Montototal
	from CJX004 A
	WHERE #PreserveSingleQuotes(filtro)#
	</cfquery>

</cfif>

<SCRIPT LANGUAGE='Javascript'  src="../js/utilies.js"></SCRIPT>
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

<table width="100%" border="0" cellpadding="2" cellspacing="0">
<tr>
	<td>
		<table cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="barraboton">
				<a id ='CONSULTAR' href="javascript:Consulta()" onmouseover="overlib('Consultar',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Consultar'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Consultar&nbsp;</span></a>
				<a id ='LIMPIAR' href="javascript:document.location = '../operacion/cjc_ReimpReferencias.cfm';" onmouseover="overlib('Limpiar filtros',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Limpiar&nbsp;</span></a>				
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
	
		<form name="form1" method="post" action="cjc_ReimpReferencias.cfm">
		<table width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr>
			<td width="24%" align="left">No. de Referencia:</td>
			<td width="76%"> 
				<INPUT TYPE="text" 
					   NAME="CJX04REF2" 
					   VALUE="<cfif isdefined("CJX04REF2") and CJX04REF2 neq ""><cfoutput>#CJX04REF2#</cfoutput></cfif>"
					   SIZE="20" 
					   MAXLENGTH="20" 
					   ONBLUR=""
					   style=" text-align:left;" 
					   tabindex="1">
			</td>	
		</tr>		
		<tr>
			<td width="24%" align="left">Fondo de Caja:</td>
			<td width="76%">
			 	<cfset filfondo = false >
				<cfif not isdefined("CJM00COD")>
					<cf_cjcConlis 	
						size		 = "30" 
						tabindex     = "2" 
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
						tabindex     = "2"
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
			<td width="24%" align="left">No. de Liquidacion:</td>
			<td width="76%"> 
				<INPUT TYPE="text" 
					   NAME="CJX04NUM1" 
					   VALUE="<cfif isdefined("CJX04NUM1") and CJX04NUM1 neq ""><cfoutput>#CJX04NUM1#</cfoutput></cfif>"
					   SIZE="4" 
					   ONKEYPRESS="if (event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;"
					   MAXLENGTH="4"
					   style=" text-align:left;" 
					   tabindex="3">
			</td>	
		</tr>		
		</table>			
		<input type="hidden" name="modo" value="Cambio">
		</form>

	</td>
</tr>
<cfif isdefined("modo")>

	<tr><td>&nbsp;</td></tr>
	<cfif rsMuestraRef.recordcount gt 0>	
	<tr>
		<td>	
		
			<form name="form2" method="post" action="cjc_AsignarReferenciasSQL.cfm">
			<input type="hidden" name="VTPrevia" value="0">
			<table border='0' cellspacing='1' cellpadding='1' style='font-family: Arial; font-size: 9pt' width="100%">  		
			<tr>    
				<td align='center' bgcolor='#008080'><font color='#FFFFFF'><strong>No. Referencia</strong></font></td>
				<td align='center' bgcolor='#008080'><font color='#FFFFFF'><strong>Fecha de Asignacion</strong></font></td>
				<td align='center' bgcolor='#008080'><font color='#FFFFFF'><strong>Usuario que Asigno</strong></font></td>
				<td align='center' bgcolor='#008080'><font color='#FFFFFF'><strong>Cantidad de Liquidaciones</strong></font></td>
				<td align='center' bgcolor='#008080'><font color='#FFFFFF'><strong>Monto Total</strong></font></td>
			</tr>
			<cfset indice=0>
			<cfoutput query="rsMuestraRef">
			<cfif (indice mod 2) eq 0>
				<cfset color = "##CECECE">
			<cfelse>
				<cfset color = "##EFEFEF">
			</cfif>
			<cfset indice= indice + 1>
			<TR>
				<td  align='left' bgcolor='#color#'><a href="javascript:newWindow('cjc_CaratulaReferencias.cfm?soloconsulta=1&ReferenciaGen=#CJX04REF2#','','700','500','resizable,scrollbars');"><font color="##000000">#CJX04REF2#</font></a></td>
				<td  align='left' bgcolor='#color#'>#dateformat(CJX04FRD,"dd/mm/yyyy")#</td>
				<td  align='left' bgcolor='#color#'>#CJX04URD#</td>
				<td  align='center' bgcolor='#color#'>#totalliq#</td>
				<td  align='right' bgcolor='#color#'>#NumberFormat(Montototal,",9.99")#</td>
			</TR>
			</cfoutput>
			</TABLE>
			</form>		
		</td>
	</tr>
	<cfelse>
		<tr><td align="center"><strong>-- La Consulta solicitada no genera ning&uacute;n resultado --</strong></td></tr>
	</cfif>

</cfif>
</table>	