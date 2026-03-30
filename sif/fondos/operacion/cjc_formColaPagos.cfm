<cfinclude template="encabezadofondos.cfm">

<cfquery name="Pendientes" datasource="#session.Fondos.dsn#">
SELECT A.orden_pago,  id_banco,  		  cuenta_corriente,  
       documento,   consecutivo_fax,  tipo_documento,    A.Monto
FROM CJINTESPI A, CJINTDSPI B
WHERE A.orden_pago = B.orden_pago
</cfquery>

<table width="100%" border="0" >	
<tr>
	<td  align="center" colspan="2" >

			<form name="form1" action="cjc_sqlColaPagos.cfm" method="post">
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
						<a href='javascript:doChecks(1)'>Seleccionar todos</a> - 
						<a href='javascript:doChecks(0)'>Limpiar todos</a>
						</font><br>
						<input type="hidden" name="bandera" value="1">
						<table border='0' cellspacing='1' cellpadding='1' style='font-family: Arial; font-size: 11px'>
						<tr>						
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong></strong></font></td>
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>Order de Pago</strong></font></td>
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>Banco</strong></font></td>	
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>Cuenta Corriente</strong></font></td>
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>Documento</strong></font></td>
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>Consecutivo Fax</strong></font></td>
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>Tipo Documento</strong></font></td>
							<td  align='center' bgcolor='#006699'><font face='Arial,Helvetica' color='#FFFFFF' size='2'><strong>Monto</strong></font></td>
						</tr>
						<cfoutput query="Pendientes">
						<cfset cfcolor = "##EFEFEF">						
						
						<tr style='font-family: Arial; font-size: 11px'>
							<td align='center' bgcolor='#cfcolor#'><input type='checkbox' border="0" style="background-color:#cfcolor# "  name='OP' value='#orden_pago#'></td>
							<td  align='left' bgcolor='#cfcolor#'>#orden_pago#</td>
							<td  align='left' bgcolor='#cfcolor#'>#id_banco#</td>
							<td  align='right' bgcolor='#cfcolor#'>#cuenta_corriente#</td>
							<td  align='right' bgcolor='#cfcolor#'>#documento#</td>
							<td  align='right' bgcolor='#cfcolor#'>#consecutivo_fax#</td>
							<td  align='right' bgcolor='#cfcolor#'>#tipo_documento#</td>
							<td  align='right' bgcolor='#cfcolor#'>#numberformat(Monto,",9.99")#</td>
						</tr>
						</cfoutput>
						</table>
						</font>
						<font face='Arial,Helvetica' size='-1'>&nbsp;						
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