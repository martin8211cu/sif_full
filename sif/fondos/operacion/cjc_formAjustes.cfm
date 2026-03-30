<cfset session.sitio.template = "/plantillas/Fondos/Plantilla.cfm">

<SCRIPT LANGUAGE='Javascript' SRC="../js/utiles.js"></SCRIPT>
<SCRIPT LANGUAGE='Javascript' SRC="../js/calendar.js"></SCRIPT>
<SCRIPT LANGUAGE='Javascript'  src="../../js/qForms/qforms.js"></SCRIPT>

<cf_templateheader title="Pantalla de Ajustes a Relaciones">

<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">

<!--- Se va a ajustar un gasto --->
<cfif isdefined("CJX23CON")>

	<cfif not isdefined("MODO")>

		<cfquery name="Pago" datasource="#session.Fondos.dsn#">
		Select B.EMPCED,convert(varchar,B.EMPNOM + ' ' + B.EMPAPA + ' ' + B.EMPAMA) as Nombre,A.* 
		from CJX023 A, PLM001 B
		where A.EMPCOD = B.EMPCOD
		  and CJX19REL = #CJX19REL# 
		  and CJX23CON=#CJX23CON#
		</cfquery>
	
		<cfoutput query="Pago">
		<FORM name="form1" method="post">
	
		<link rel='stylesheet' type='text/css' href='/js/cs_estilo_entrada.css'>
		<link rel='stylesheet' type='text/css' href='/js/cs_estilo_boton.css'>
		<div id=overDiv style='POSITION:absolute; Z-INDEX:1'></div>
		<table border='0' cellspacing='5' cellpadding='0' width='100%'>
		<tr><td width='100%'>
		<div id=principal style='display:;'>
		<table border='0' cellspacing='0' cellpadding='0' width='100%'><tr>
		</tr></table>
		</div>
		</td></tr></table>
		<table border='0' cellspacing='0' cellpadding='0' width='100%'>
		<tr><td width='100%'>
		</td></tr></table>
		<script language='javascript' src='/js/global.js'></script>
		<script language='javascript' src='/js/overlib.js'></script><TABLE  BORDER="0" cellspacing="1" cellpadding="1">
		<TR>
		<TD><INPUT TYPE="HIDDEN" NAME="AJUSTE" VALUE="D"></TD>
		</TR>
		<TR>
		<TD>Relacion</TD>
		<TD>&nbsp</TD>
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="LLAVE" VALUE="#CJX19REL#" SIZE="11" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="LLAVETXT" VALUE="" SIZE="40" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>
		<TD>Consecutivo</TD>
		<TD>&nbsp</TD>
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="CJX23CON" VALUE="#CJX23CON#" SIZE="11" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>
		<TD>Empleado</TD>
		<TD>&nbsp</TD>
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="EMPCED" VALUE="#EMPCED#" SIZE="12" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="NOMBRE" VALUE="#Nombre#" SIZE="45" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<!---
		<TR>
		<TD>Autorizador</TD>
		<TD>&nbsp</TD>
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="CP9COD" VALUE="#CP9COD#" SIZE="10" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="CP9DES" VALUE="" SIZE="20" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		--->
		<TR>
		<TD>Monto</TD>
		<TD>&nbsp</TD>
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="MONTO" VALUE="#CJX23MON#" SIZE="15" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>
		<TD>Tipo de pago</TD>
		<TD>&nbsp</TD>
		<TD><cfif isdefined("CJX23TIP") and CJX23TIP eq 'T'>Tarjeta<cfelse>Cheque</cfif></TD>
		</TR>
		<TR>
		<TD>Fecha de documento</TD>
		<TD>&nbsp;</TD>	
		<cfif isdefined("CJX23TIP") and CJX23TIP eq 'T'>
			<TD><cf_CJCcalendario tabindex="1" name="FECHA" form="form1" formato="dd/mm/yyyy" value="#dateformat(CJX23FEC,"dd/mm/yyyy")#"></TD>		
		<cfelse>
			<td>#dateformat(CJX23FEC,"dd/mm/yyyy")#</td>
		</cfif>	
		</TR>
		<TR>
		<TD>Tipo de tarjeta</TD>
		<TD>&nbsp</TD>
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="TS1COD" VALUE="#TS1COD#" SIZE="5" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<cfif isdefined("CJX23TIP") and CJX23TIP eq 'T'>
		<TR>
		<TD>Documento</TD>
		<TD>&nbsp</TD>				
		<TD><INPUT TYPE="textbox" NAME="TR01NUT" VALUE="#TR01NUT#" SIZE="20" MAXLENGTH="20" ONFOCUS="this.select(); "  style=""> <!---ONKEYUP="if(sstring(this,event)){if(Key(event)=='13'){this.blur(); ACEPTAR();} }" ONBLUR="CARGATJ()"---></TD>				
		</TR>
		</cfif>
		<cfif isdefined("CJX23TIP") and CJX23TIP eq 'T'>
		<TR>
		<TD>No.Autorizacin</TD>
		<TD>&nbsp</TD>		
		<TD><INPUT TYPE="textbox" NAME="AUTORIZACION" VALUE="#CJX23AUT#" SIZE="20" MAXLENGTH="20" ONFOCUS="this.select(); " style=""><!--- ONBLUR="llenar_string(this,0,'0')" ONKEYUP="if(sstring(this,event)){if(Key(event)=='13'){this.blur(); ACEPTAR();} }" ---></TD>		
		</TR>
		</cfif>
		<cfif isdefined("CJX23TIP") and CJX23TIP eq 'C'>
		<tr>
		<td><INPUT TYPE="HIDDEN" NAME="CJX23CHK" VALUE="#CJX23CHK#"></td>	
		</tr>
		</cfif>
		<TR>
		<TD><INPUT TYPE="HIDDEN" NAME="PAGO" VALUE="3"></TD>
		</TR>
		<TR>
		<TD><!---<INPUT TYPE="HIDDEN" NAME="timestamp" VALUE="#timestamp#">---></TD>
		</TR>
		<TR>
		<TD><INPUT TYPE="HIDDEN" NAME="MODO" VALUE="CAMBIO"></TD>
		</TR>
		</TR>
		<TR>
		<TD><INPUT TYPE="HIDDEN" NAME="CJX19REL" VALUE="#CJX19REL#"></TD>
		</TR>
		<TR>
		<TD><INPUT TYPE="HIDDEN" NAME="cmb_tdoc" VALUE="#TD#"></TD>
		</TR>		
		</TR>
		<TR>
		<TD><INPUT TYPE="HIDDEN" NAME="CJX23TIP" VALUE="#CJX23TIP#"></TD>
		</TR>			
		<div id=principal style='display:;'>
		<table border='0' cellspacing='0' cellpadding='0' width='100%'>
		<tr>
			<td class=barraboton>
			<input type="submit" name="btnAceptar" value="Aceptar" onClick="document.form1.action = 'cjc_formAjustes.cfm';document.form1.submit();">
			<input type="submit" name="btnCancelar" value="Cancelar" onClick="document.form1.action = 'cjc_AjusteRelacion.cfm';document.form1.submit();">		
			</td>
			<td class=barraboton><p align=center><font color='##FFFFFF'><b> </b></font></p></td>
		</tr>
		</table>
		</div>	
		<!---
		<SCRIPT LANGUAGE='Javascript' SRC="/cjc_js/cjc_Ajustes.js"></SCRIPT>--->
		</TABLE>
		</FORM>
		</cfoutput>
		<br>
			
	<cfelse>
			
		<cfset Pfecha = #dateformat(trim(form.FECHA),"yyyymmdd")#>		
		<cftry>	
	

			<!---Inicio de la modificacion de las tablas 23 y 11 --->	
			<cfquery datasource="#session.Fondos.dsn#" name="sql">
			    set nocount on
		
				exec sp_Ajusta_RelacionMasiva
				@CJX19REL 	 = #trim(form.LLAVE)#,
				@CONSECUTIVO = #trim(form.CJX23CON)#,
				@CJM00COD	 = '#trim(session.Fondos.Fondo)#',
				@TS1COD		 = '#trim(form.TS1COD)#',
				@TIPO		 = 2,
				@TIPOANT     = '#trim(form.CJX23TIP)#',				
				<!--- Solo Tarjetas --->
				<cfif CJX23TIP eq 'T'>
					@FECHA		 = '#trim(Pfecha)#',	
					@TR01NUT = '#trim(form.TR01NUT)#',
					@AUTORIZACION = '#trim(form.AUTORIZACION)#'				
				</cfif>
				<!--- Solo Cheques --->
				<cfif CJX23TIP eq 'C'>
					@NUMCHK = '#trim(form.CJX23CHK)#'	
				</cfif>

				set nocount off
			</cfquery>		
		
					
			<cfcatch type="any">
				<script language="JavaScript">
				   var  mensaje = "<cfoutput>#trim(cfcatch.Detail)#</cfoutput>"
				   mensaje = mensaje.substring(40,300)				   
				   alert(mensaje)
				   history.back()
				</script>
				<cfabort>
			</cfcatch>
			
		</cftry>	
		<cfset MSG = sql.Resultado>
		<script language="JavaScript">
		   <cfoutput>
			   alert('#MSG#')				   				   
			   location = "cjc_formAjustes.cfm?CJX19REL=#CJX19REL#&CJX23CON=#CJX23CON#&TD=#cmb_tdoc#&CJX23TIP=#CJX23TIP#"
		   </cfoutput>
		</script>	
		
	</cfif>
	
<cfelse>

	<!--- GASTOS --->
	<cfif not isdefined("MODO")>

		<cfquery name="Gasto" datasource="#session.Fondos.dsn#">
		Select B.EMPCED,convert(varchar,B.EMPNOM + ' ' + B.EMPAPA + ' ' + B.EMPAMA) as Nombre,A.*,C.CJ1DE1,C.TS1COD
		from CJX020 A, PLM001 B, CJX001 C
		where A.EMPCOD = B.EMPCOD
		  and A.CJX19REL = C.CJX19REL
		  and A.CJX20NUM = C.CJX20NUM
		  and A.CJX19REL = #CJX19REL# 
		  and A.CJX20NUM=#CJX20NUM#
		</cfquery>
	
		<cfoutput query="Gasto">
		<FORM name="form1" method="post">
	
		<link rel='stylesheet' type='text/css' href='/js/cs_estilo_entrada.css'>
		<link rel='stylesheet' type='text/css' href='/js/cs_estilo_boton.css'>
		<div id=overDiv style='POSITION:absolute; Z-INDEX:1'></div>
		<table border='0' cellspacing='5' cellpadding='0' width='100%'>
		<tr><td width='100%'>
		<div id=principal style='display:;'>
		<table border='0' cellspacing='0' cellpadding='0' width='100%'><tr>
		</tr></table>
		</div>
		</td></tr></table>
		<table border='0' cellspacing='0' cellpadding='0' width='100%'>
		<tr><td width='100%'>
		</td></tr></table>
		<script language='javascript' src='/js/global.js'></script>
		<script language='javascript' src='/js/overlib.js'></script><TABLE  BORDER="0" cellspacing="1" cellpadding="1">
		<TR>
		<TD><INPUT TYPE="HIDDEN" NAME="AJUSTE" VALUE="G"></TD>
		</TR>
		<TR>
		<TD>Relacion</TD>
		<TD>&nbsp</TD>
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="LLAVE" VALUE="#CJX19REL#" SIZE="11" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="LLAVETXT" VALUE="" SIZE="40" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>
		<TD>Consecutivo</TD>
		<TD>&nbsp</TD>
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="CJX20NUM" VALUE="#CJX20NUM#" SIZE="11" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<cfif CJX20TIP eq "F">
		<TR>
		<TD>No.Factura</TD>
		<TD>&nbsp</TD>
		<TD><INPUT TYPE="textbox" NAME="CJX20NUF" VALUE="#CJX20NUF#" SIZE="20" MAXLENGTH="20" ONFOCUS="this.select(); " style=""><!--- ONKEYUP="if(sstring(this,event)){if(Key(event)=='13'){this.blur(); ACEPTAR();} }" ONBLUR="llenar_string(this,0,'0')" ---></TD>
		</TR>	
		</cfif>	
		<TR>
		<TD>Empleado</TD>
		<TD>&nbsp</TD>
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="EMPCED" VALUE="#EMPCED#" SIZE="12" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="NOMBRE" VALUE="#Nombre#" SIZE="45" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>
		<TD>Autorizador</TD>
		<TD>&nbsp</TD>
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="AUTORIZADOR" VALUE="#CP9COD#" SIZE="10" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="CP9DES" VALUE="" SIZE="20" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>
		<TD>Descripcin</TD>
		<TD>&nbsp</TD>
		<TD><TEXTAREA NAME="DESCRIPCION" ROWS="2" COLS="23" ONFOCUS="this.select(); " ONKEYUP="">#CJ1DE1#</TEXTAREA><!--- ONBLUR="return maxLength(this,50);" ---></TD>
		</TR>		
		<TR>
		<TD>Monto</TD>
		<TD>&nbsp</TD>
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="MONTO" VALUE="#CJX20MNT#" SIZE="15" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>
		<TD>Tipo de pago</TD>
		<TD>&nbsp</TD>
		<TD>Tarjeta</TD>
		</TR>
		<TR>
		<TD>Fecha de documento</TD>
		<TD>&nbsp;</TD>		
		<TD><cf_CJCcalendario tabindex="1" name="FECHA" form="form1" formato="dd/mm/yyyy" value="#dateformat(CJX20FEF,"dd/mm/yyyy")#"></TD>		
		</TR>
		<TR>
		<TD>Tipo de tarjeta</TD>
		<TD>&nbsp</TD>
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="TS1COD" VALUE="#TS1COD#" SIZE="5" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<!---
		<TR>
		<TD>Documento</TD>
		<TD>&nbsp</TD>
		<TD><INPUT TYPE="textbox" NAME="DOCUMENTO" VALUE="#TR01NUT#" SIZE="20" MAXLENGTH="20" ONBLUR="CARGATJ()" ONFOCUS="this.select(); " ONKEYUP="if(sstring(this,event)){if(Key(event)=='13'){this.blur(); ACEPTAR();} }" style=""></TD>
		</TR>
		
		<TR>
		<TD>No.Autorizacin</TD>
		<TD>&nbsp</TD>
		<TD><INPUT TYPE="textbox" NAME="AUTORIZACION" VALUE="#CJX23AUT#" SIZE="20" MAXLENGTH="20" ONBLUR="llenar_string(this,0,'0')" ONFOCUS="this.select(); " ONKEYUP="if(sstring(this,event)){if(Key(event)=='13'){this.blur(); ACEPTAR();} }" style=""></TD>
		</TR>
		--->
		<TR>
		<TD><INPUT TYPE="HIDDEN" NAME="CJX20TIP" VALUE="#CJX20TIP#"></TD>
		</TR>
		<TR>
		<TD><INPUT TYPE="HIDDEN" NAME="MODO" VALUE="CAMBIO"></TD>
		</TR>
		</TR>
		<TR>
		<TD><INPUT TYPE="HIDDEN" NAME="CJX19REL" VALUE="#CJX19REL#"></TD>
		</TR>
		<TR>
		<TD><INPUT TYPE="HIDDEN" NAME="cmb_tdoc" VALUE="#TD#"></TD>
		</TR>		
		<div id=principal style='display:;'>
		<table border='0' cellspacing='0' cellpadding='0' width='100%'>
		<tr>
			<td class=barraboton>
			<input type="submit" name="btnAceptar" value="Aceptar" onClick="document.form1.action = 'cjc_formAjustes.cfm';document.form1.submit();">
			<input type="submit" name="btnCancelar" value="Cancelar" onClick="document.form1.action = 'cjc_AjusteRelacion.cfm';document.form1.submit();">		
			</td>
			<td class=barraboton><p align=center><font color='##FFFFFF'><b> </b></font></p></td>
		</tr>
		</table>
		</div>	
		<!---
		<SCRIPT LANGUAGE='Javascript' SRC="/cjc_js/cjc_Ajustes.js"></SCRIPT>--->
		</TABLE>
		</FORM>
		</cfoutput>
	
	<cfelse>
		
		<cfset Pfecha = #dateformat(trim(form.FECHA),"yyyymmdd")#>			
		
		<cftry>

	
			<!--- Inicio de la modificacion de las tablas 20 y 01 --->			 
			<cfquery name="sql" datasource="#session.Fondos.dsn#">
				set nocount on
			
				exec sp_Ajusta_RelacionMasiva
				@CJX19REL 	 = #trim(form.LLAVE)#,
				@CONSECUTIVO = #trim(form.CJX20NUM)#,
				@CJM00COD	 = '#trim(session.Fondos.Fondo)#',
				@TIPO		 = 1,
				@FECHA		 = '#trim(Pfecha)#',
				@TIPOFAC	 = '#trim(form.CJX20TIP)#',
				<cfif isdefined("CJX20NUF")>
					@NUMFACT = '#trim(form.CJX20NUF)#',
				</cfif>						
				@DESCRIPCION = '#trim(form.DESCRIPCION)#'
				
				set nocount off
			</cfquery>
		
			<cfcatch type="any">												
				<script language="JavaScript">
				   var  mensaje = "<cfoutput>#trim(cfcatch.Detail)#</cfoutput>"
				   mensaje = mensaje.substring(40,300)
				   alert(mensaje)
				   history.back()
				</script>
				<cfabort>
			</cfcatch>			
		</cftry>
		<cfset MSG = sql.Resultado>
		
		<script language="JavaScript">				   
			<cfoutput>
				alert('#MSG#');				   	
				location = "cjc_formAjustes.cfm?CJX19REL=#CJX19REL#&CJX20NUM=#CJX20NUM#&TD=#cmb_tdoc#";  		
			</cfoutput>
		</script>	
		
	</cfif>

</cfif>
<cf_templatefooter>

