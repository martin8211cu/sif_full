<cfif isdefined("ACTUALIZAR")>

	<cfset VCJX12FEC = #LSdateformat(CJX12FEC,'yyyymmdd')#>

	<cfif ACTUALIZAR eq 0>
	
		<cfquery name="rsVerificaBorrar" datasource="#session.Fondos.dsn#">
			Select count(1) as cantidad
			from CJX012
			where TS1COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TS1COD#">
			and TR01NUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TR01NUT#">
			and CJX12AUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CJX12AUT#">
			and CJX12FEC = '#VCJX12FEC#'
			and PERCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#PERCOD#">
			and MESCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#MESCOD#">
			and CJX12IND = 'N'
			and CJX00NGC is null
		</cfquery>

		<cfif rsVerificaBorrar.cantidad eq 1>
	
			<cfquery name="rsInsBitacora" datasource="#session.Fondos.dsn#">
			
			<!--- Se incluye en la Bitacora --->
			insert CJX012B(	PERCOD,  MESCOD,TS1COD,  TR01NUT, CJX12AUT,CJX12FEC,CJM00COD,CJX12IMP,CJX12FAU,
					EMPCED,  EMPNOM,CJX12ORG,CJX12NIV,CJX12COM,CJX12CLA,CJX12CAT,CJX12IND,CJX12CNS,
					CJX00NGC,CJXIND,CJX12ICH,CJX12PAG,CP20ID,CJX12TIP,CJX12FIP,FECHA,USUARIO,CJX12ANT,CJX12ORI)
			select		PERCOD,  MESCOD,TS1COD,  TR01NUT, CJX12AUT,CJX12FEC,CJM00COD,CJX12IMP,CJX12FAU,
					EMPCED,  EMPNOM,CJX12ORG,CJX12NIV,CJX12COM,CJX12CLA,CJX12CAT,CJX12IND,CJX12CNS,
					CJX00NGC,CJXIND,CJX12ICH,CJX12PAG,CP20ID,  CJX12TIP,CJX12FIP,getdate(),'#session.usuario#',0,'B'              
			from CJX012
			where TS1COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TS1COD#">
			  and TR01NUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TR01NUT#">
			  and CJX12AUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CJX12AUT#">
			  and CJX12FEC = '#VCJX12FEC#'
			  and PERCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#PERCOD#">
			  and MESCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#MESCOD#">				
			</cfquery>		
		
			<cfquery name="rsBorrar" datasource="#session.Fondos.dsn#">

			<!--- Borrar --->
			Delete CJX012
			where TS1COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TS1COD#">
			  and TR01NUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TR01NUT#">
			  and CJX12AUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CJX12AUT#">
			  and CJX12FEC = '#VCJX12FEC#'
			  and PERCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#PERCOD#">
			  and MESCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#MESCOD#">
			</cfquery>

			<script>
				alert("El Voucher fue eliminado con exito");
				document.location = 'cjc_AdministracionBancaria.cfm'
			</script>
		
		<cfelse>
			<script>alert("No es posible eliminar el registro, ya que el mismo se encuentra conciliado")</script>
		</cfif>
		
	<cfelse>
	
		<!--- Modificar --->	
		<cfset MANT = replace(MANT,",","","all")>
		<cfset MACT = replace(CJX12IMP,",","","all")>	
		<cfset diferencia = MANT - MACT>
	
		<cfif diferencia lt 0><cfset diferencia = diferencia * -1></cfif>
		<cfif diferencia lt 1>
		
			<!--- Se Verifica en la Bitacora --->	
			<cfquery name="rsVerifica" datasource="#session.Fondos.dsn#">
			Select count(1) as cantidad
			from CJX012B
			where TS1COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TS1COD#">
			  and TR01NUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TR01NUT#">
			  and CJX12AUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CJX12AUT#">
			  and CJX12FEC = '#VCJX12FEC#'
			  and PERCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#PERCOD#">
			  and MESCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#MESCOD#">			
			  and CJX12ORI = 'M'
			</cfquery>
						
			<cfif rsVerifica.cantidad lt 2>
	
				<cftransaction>
				<cftry> 
					<!--- Se incluye en la Bitacora --->
					<cfquery name="rsInsBitacora" datasource="#session.Fondos.dsn#">
					INSERT CJX012B(PERCOD,  MESCOD,TS1COD,  TR01NUT, CJX12AUT,CJX12FEC,CJM00COD,CJX12IMP,CJX12FAU,
								   EMPCED,  EMPNOM,CJX12ORG,CJX12NIV,CJX12COM,CJX12CLA,CJX12CAT,CJX12IND,CJX12CNS,
								   CJX00NGC,CJXIND,CJX12ICH,CJX12PAG,CP20ID,CJX12TIP,CJX12FIP,FECHA,USUARIO,CJX12ANT,CJX12ORI)
					Select         PERCOD,  MESCOD,TS1COD,  TR01NUT, CJX12AUT,CJX12FEC,CJM00COD,CJX12IMP,CJX12FAU,
								   EMPCED,  EMPNOM,CJX12ORG,CJX12NIV,CJX12COM,CJX12CLA,CJX12CAT,CJX12IND,CJX12CNS,
								   CJX00NGC,CJXIND,CJX12ICH,CJX12PAG,CP20ID,  CJX12TIP,CJX12FIP,getdate(),'#session.usuario#',#MACT#,'M'              
					from CJX012
					where TS1COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TS1COD#">
					  and TR01NUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TR01NUT#">
					  and CJX12AUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CJX12AUT#">
					  and CJX12FEC = '#VCJX12FEC#'
					  and PERCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#PERCOD#">
					  and MESCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#MESCOD#">				
					</cfquery>
					
					<!--- Realiza la modificacion --->
					<cfquery name="rs1" datasource="#session.Fondos.dsn#">
					Update CJX012
					set CJX12IMP = <cfqueryparam cfsqltype="cf_sql_money" value="#MACT#">
					where TS1COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TS1COD#">
					  and TR01NUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TR01NUT#">
					  and CJX12AUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CJX12AUT#">
					  and CJX12FEC = '#VCJX12FEC#'
					  and PERCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#PERCOD#">
					  and MESCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#MESCOD#">	
					</cfquery>
				
					<cfcatch type="any">							
						<script language="JavaScript">
							var  mensaje = new String("<cfoutput>#trim(cfcatch.Detail)#</cfoutput>");
							mensaje = mensaje.substring(40,300)
							alert(mensaje)
							history.back()
						</script>
						<cfabort>
					</cfcatch> 
				</cftry> 
				<cftransaction action="commit">
				</cftransaction> 				
			
			<cfelse>
				<script>alert("No es posible modificar el registro, ya que el mismo ya ha sido modificado 2 veces anteriormente")</script>			
			</cfif>
		
		<cfelse>
			<cfoutput>
			<script>alert("No es posible actualizar el monto, ya que la diferencia es mayor a 0.99 centimos")</script>
			</cfoutput>
		</cfif>
	
	</cfif>

</cfif>


<cfinclude template="encabezadofondos.cfm">
<script language='javascript' src='/js/global.js'></script>
<script language='javascript' src='/js/overlib.js'></script>
<script language="javascript1.2" type="text/javascript" src="../../../plantillas/Fondos/utiles.js"></script>

<cfset VCJX12FEC = #LSdateformat(CJX12FEC,'yyyymmdd')#>
<cfquery name="rs1" datasource="#session.Fondos.dsn#">
Select TS1COD,  TR01NUT,CJX12AUT, convert(varchar,CJX12FEC,110) CJX12FEC,
	   CJX12IMP,EMPNOM, CJX12COM, PERCOD, MESCOD
from CJX012
where TS1COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TS1COD#">
  and TR01NUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TR01NUT#">
  and CJX12AUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CJX12AUT#">
  and CJX12FEC = '#VCJX12FEC#'
  and PERCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#PERCOD#">
  and MESCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#MESCOD#">
</cfquery>


<form name="form1" action="cjc_AdministracionBancaria.cfm" method="post">
<input type="hidden" name="pan" value="1">
<input type="hidden" name="ACTUALIZAR" value="1">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td  align="left" colspan="2" >

			<table width="100%" border="0" cellpadding="0" cellspacing="0"
			>
			<tr>
				<td align="left" colspan="10">
										
					<table border='0' cellspacing='0' cellpadding='0' width='100%'>
					<tr>
						<td class="barraboton">&nbsp;
							<a id ='ACEPTAR' href="javascript:document.form1.submit();" onmouseover="overlib('Modificar',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Modificar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Modificar&nbsp;</span></a>
							<a id ='BORRAR' href="javascript:if (confirm('Esta seguro que desea eliminar el Voucher')){document.form1.ACTUALIZAR.value=0;document.form1.submit();}" onmouseover="overlib('Borrar',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Aceptar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Borrar&nbsp;</span></a>							
							<a id ='ATRAS' href="javascript:document.location = '../operacion/cjc_AdministracionBancaria.cfm'" onmouseover="overlib('Atras',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Atras'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Atras&nbsp;</span></a>
							<!--- <a id = 'ACEPTAR' href="javascript:ACEPTAR('S');" onmouseover="overlib('Exportar a excel',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Exportar'; return true;" onmouseout="nd();"><span class=LeftNavOff buttonType=LeftNav>&nbsp;Exportar&nbsp;</span></a> --->
						</td>
						<td class="barraboton">
							<p align=center><font color='#FFFFFF'><b> </b></font></p>
						</td>
					</tr>
					</table>					
					<input type="hidden" id="btnFiltrar" name="btnFiltrar">
				</td>
			</tr>
			</table>
	</td>
</tr>
<tr>
	<td>

		<cfoutput query="rs1">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" background="../index.jpg" height="55">
		<tr><td colspan="3">&nbsp;</td></tr>
		<TR>
		<TD width="19%">Tipo de Tarjeta</TD>
		<TD width="81%"><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="LLAVE" VALUE="#TS1COD#" SIZE="11" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>
		<TD>Tarjeta</TD>
		
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="LLAVE" VALUE="#TR01NUT#" SIZE="20" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>
		<TD>AutorizaciÃ³n</TD>
		
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="LLAVE" VALUE="#CJX12AUT#" SIZE="11" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>
		<TD>Fecha</TD>
		
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="LLAVE" VALUE="#CJX12FEC#" SIZE="11" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>
		<TD>Empleado</TD>
		
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="LLAVE" VALUE="#EMPNOM#" SIZE="40" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>
		<TD>Comercio</TD>
		
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="LLAVE" VALUE="#CJX12COM#" SIZE="40" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>
		<TD>Periodo</TD>
		
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="LLAVE" VALUE="#PERCOD#" SIZE="11" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>
		<TD>Mes</TD>
		
		<TD><INPUT  tabindex="-1" ONFOCUS="this.blur();" NAME="LLAVE" VALUE="#MESCOD#" SIZE="11" style=" border: medium none; color:##0000FF; background-color:##FFFFFF;"></TD>
		</TR>
		<TR>	
		<TD>Monto</TD>
				
		<TD>
			<INPUT 	TYPE="textbox" 
					NAME="CJX12IMP" 
					VALUE="#numberformat(CJX12IMP,',9.99')#" 
					SIZE="20" 
					MAXLENGTH="15" 
					ONBLUR="javascript: fm(this,2);"
					ONFOCUS="javascript: this.value=qf(this); this.select(); " 
					ONKEYUP="javascript: if(snumber(this,event,2)){ if(Key(event)=='13'){this.blur();}} " 
					tabindex="1"
				>
		</TR>		
		</TABLE>		
		</cfoutput>		
	</td>
</tr>
</table>
<cfoutput>
<input type="hidden" name="TS1COD" value="#TS1COD#">
<input type="hidden" name="TR01NUT" value="#TR01NUT#">
<input type="hidden" name="CJX12AUT" value="#CJX12AUT#">
<input type="hidden" name="CJX12FEC" value="#CJX12FEC#">
<input type="hidden" name="PERCOD" value="#PERCOD#">
<input type="hidden" name="MESCOD" value="#MESCOD#">
<input type="hidden" name="MANT" value="#CJX12IMP#">
</cfoutput>
</form>
