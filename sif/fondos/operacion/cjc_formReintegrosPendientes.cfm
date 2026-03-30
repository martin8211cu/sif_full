<cfinclude template="encabezadofondos.cfm">

<cfif isdefined("bandera")>


	<cfquery name="Pendientes" datasource="#session.Fondos.dsn#">
	UPDATE CJX003
	set CJ3SEL='N'
	FROM CJM001 B
	WHERE CJX003.CJ3EST not in (3) 
	  AND CJX003.CJ3APL=1
	  AND CJX003.CJ01ID = B.CJ01ID 
	  AND B.CJM00COD = '#session.Fondos.fondo#'
	</cfquery>


	<cfif isdefined("FZ")>

		<cfloop list="#FZ#" delimiters="," index="LActual">
	
			<cfset pos = find("|",LActual,1)>
			<cfset Var_NLiq = Mid(LActual,1,pos-1)>
			<cfset Var_Caja = Mid(LActual,pos+1,len(LActual))>
		
			<cfquery name="Pendientes" datasource="#session.Fondos.dsn#">
			UPDATE CJX003 
			SET CJ3SEL='S' 
			WHERE CJ01ID='#Var_Caja#' 
			  and CJ3NUM=#Var_NLiq#
			</cfquery>
			
		</cfloop>
	
	</cfif>

</cfif>

<cfquery name="Pendientes" datasource="#session.Fondos.dsn#">
SELECT A.CJ01ID,CJ3NUM, CJ3DIM, convert(varchar,CJ3FEC,103) CJ3FEC,
	   CJ3DIA,  CJ3TGA, CJ3TVA, CJ3MRE, CJ3SEL 
FROM CJX003 A, CJM001 B
WHERE A.CJ3EST not in (3) 
  AND A.CJ3APL=1
  AND A.CJ01ID = B.CJ01ID 
  AND B.CJM00COD = '#session.Fondos.fondo#'
</cfquery>

<table width="100%" border="0" >	
<tr>
	<td  align="center" colspan="2" >

			<form name="form1" action="cjc_sqlReintegrosPendientes.cfm" method="post">
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
				<tr>
					<td align="left" colspan="10">
					
					
						<table border='0' cellspacing='0' cellpadding='0' width='100%'>
						<tr>
							<td class="barraboton">&nbsp;
								<a id ="ACEPTAR" href="javascript:document.form1.submit();" onmouseover="overlib('Aplicar',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Aplicar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Aplicar&nbsp;</span></a>
							</td>
							<td class=barraboton>
								<p align=center><font color='#FFFFFF'><b> </b></font></p>
							</td>
						</tr>
						</table>		
															
					</td>
				</tr>
				<tr><td height="40">&nbsp;</td></tr>
				<tr>
					<td>
					
						<font face='Arial,Helvetica' size='-1'>&nbsp;
						<a href='javascript:GO()'>Aceptar</a> - 
						<a href='javascript:doChecks(1)'>Seleccionar todos</a> - 
						<a href='javascript:doChecks(0)'>Limpiar todos</a>
						</font><br>
						<input type="hidden" name="bandera" value="1">
						<table border='0' cellspacing='1' cellpadding='1' style='font-family: Arial; font-size: 11px'>
						<tr>
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong></strong></font></td>
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>Caja</strong></font></td>
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>No. Liquidación</strong></font></td>	
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>Fecha</strong></font></td>
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>Disp. Manual</strong></font></td>
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>Disp. Auto.</strong></font></td>
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>Gastos</strong></font></td>
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>Vales</strong></font></td>
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>Reintegrar</strong></font></td>
						</tr>
						<cfoutput query="Pendientes">
						<cfif CJ3SEL eq 'S'>
							<cfset cfcolor = "##CECECE">
						<cfelse>
							<cfset cfcolor = "##EFEFEF">
						</cfif>
						<tr style='font-family: Arial; font-size: 11px'>
							<td align='center' bgcolor='#cfcolor#'><input type='checkbox' border="0" style="background-color:#cfcolor# "  <cfif CJ3SEL eq 'S'>checked</cfif> name='FZ' value='#CJ3NUM#|#trim(CJ01ID)#'></td>
							<td  align='left' bgcolor='#cfcolor#'>#CJ01ID#</td>	
							<td  align='right' bgcolor='#cfcolor#'>#CJ3NUM#</td>
							<td  align='left' bgcolor='#cfcolor#'>#CJ3FEC#</td>
							<td  align='right' bgcolor='#cfcolor#'>#numberformat(CJ3DIM,",9.99")#</td>
							<td  align='right' bgcolor='#cfcolor#'>#numberformat(CJ3DIA,",9.99")#</td>
							<td  align='right' bgcolor='#cfcolor#'>#numberformat(CJ3TGA,",9.99")#</td>
							<td  align='right' bgcolor='#cfcolor#'>#numberformat(CJ3TVA,",9.99")#</td>
							<td  align='right' bgcolor='#cfcolor#'>#numberformat(CJ3MRE,",9.99")#</td>
						</tr>
						</cfoutput>
						</table>
						</font>
						<font face='Arial,Helvetica' size='-1'>&nbsp;
						<a href='javascript:GO()'>Aceptar</a> - 
						<a href='javascript:doChecks(1)'>Seleccionar todos</a> - 
						<a href='javascript:doChecks(0)'>Limpiar todos</a></font><br>
						
					</td>
				</tr>
			</table>
			</form>
			
	</td>
</tr>
</table>

<SCRIPT>
	function doChecks(mode)
	{							
		var doc = document.forms[0]							
		var campos= document.forms[0].elements.length
				
		for( i=0 ; i<campos ; i++)
		{								
			if (doc.elements[i].name=='FZ')
			{
				if(mode==1)
					doc.elements[i].checked=true
				else
					doc.elements[i].checked=false
			}
		}
	}
						
	function GO()
	{
		document.forms[0].action = "cjc_ReintegrosPendientes.cfm";		
		document.forms[0].submit();		
	}						
</SCRIPT>