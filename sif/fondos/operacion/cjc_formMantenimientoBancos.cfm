<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Cuentas Bancarias</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<cfif isdefined("modo") and modo neq "ALTA">
	
	<cfquery name="rsCuentaSoin" datasource="#session.Fondos.dsn#">
	Select A.B01COD as Nid_bancosoin, B.BANDES as cuentasoindesc, B.BANCUE as cuentasoin, B01DES
	from B01ARC A, BANARC B
	where A.B01COD = B.B01COD
	  and A.B01COD = '#id_bancosoin#'
	  and B.BANCUE = '#cuentasoin#'
	</cfquery>
	
	<cfquery name="rsCuentaArq" datasource="#session.Fondos.dsn#">
	Select A.id_banco as Nid_bancoarq, A.nombre_banco, B.cuenta_corriente as cuentaarq, B.nombre_cuenta as cuentaarqdesc
	from arquitectura..EBA01C A, arquitectura..EBA02C B
	where A.id_banco = B.id_banco
	  and A.id_banco = #id_bancoarq#
	  and B.cuenta_corriente = '#cuentaarq#'
	</cfquery>

</cfif>

<body>
<script>
function Eliminar()
{
	document.frmbancos.MODO.value = 'BAJA';
	document.frmbancos.submit();
}
function Iratras()
{
	document.cambiopnt.submit();	
}
//Obtiene la descripción con base al código
function TraeDescripcionbancosoin(dato) {	
	var params ="";
	if (dato != "") {
		var frame = document.getElementById("frmcuentasoin");
		frame.src = "/cfmx/sif/fondos/Utiles/traebancodesc_soin.cfm?dato="+dato+"&form=frmbancos";		
		}
	else{
		document.frmbancos.nbancosoin.value = "";
	}
	return;
}
function TraeDescripcionbancoarq(dato) {	
	var params ="";
	if (dato != "") {
		var frame = document.getElementById("frmcuentaarq");
		frame.src = "/cfmx/sif/fondos/Utiles/traebancodesc_arq.cfm?dato="+dato+"&form=frmbancos";		
		}
	else{
		document.frmbancos.nbancoarq.value = "";
	}
	return;
}	
</script>

<form name="cambiopnt" action="cjc_MantenimientoBancos.cfm"></form>
<SCRIPT LANGUAGE='Javascript'  src="../js/utilies.js"></SCRIPT>
<style type="text/css">
<!--
.style1 {color: #FFFFFF}
.style2 {color: #FFFF00}
-->
</style>

<script language='javascript' src='/js/global.js'></script>
<script language='javascript' src='/js/overlib.js'></script>
<TABLE  BORDER="0" cellspacing="1" cellpadding="1" width="100%">
<tr>
	<td>
		<form name="frmbancos" action="cjc_MantenimientoBancos.cfm" method="post">

		<TABLE  BORDER="0" cellspacing="1" cellpadding="1" width="100%">			
		<tr>
			<td>
		
				<TABLE  BORDER="0" cellspacing="1" cellpadding="1" class="areaFiltro" width="100%">
				<TR>
					<TD width="27%">Banco de Soin</TD>		
					<TD width="17%">										
					
							<table cellpadding="0" cellspacing="0"> 
							<tr>
								<td>
									<INPUT TYPE="textbox" 
									NAME="id_bancosoin" 
									<cfif isdefined("modo") and modo eq "CAMBIO">readonly</cfif> 
									VALUE="<cfif isdefined("Form.id_bancosoin")><cfoutput>#Form.id_bancosoin#</cfoutput></cfif>" 
									SIZE="20" 
									MAXLENGTH="20" 
									ONBLUR="javascript:TraeDescripcionbancosoin(this.value)"   <!---if(isUp(this)){}" --->
									ONFOCUS="this.select(); " 
									ONCHANGE="if(isUp(this)){}" 
									ONKEYUP="if(sstring(this,event)){if(Key(event)=='13'){this.blur(); ACEPTAR();} }" 
									style=" text-transform:uppercase;">
								</td>													
								<td nowrap>
									<input type="text"
									name="nbancosoin" id="nbancosoin"
									tabindex="-1" disabled
									value="<cfif isdefined("rsCuentaSoin.B01DES")><cfoutput>#rsCuentaSoin.B01DES#</cfoutput></cfif>"
									size="30" 
									maxlength="80"
									style="border: medium none; visibility:visible; background-color:#E8E8E8">
								</td>
							</tr>
							</table>
							
					</TD>
					<TD width="32%">Banco Conc. Banc.</TD>
					<TD width="24%">		
							<table cellpadding="0" cellspacing="0"> 
							<tr>
								<td>
									<INPUT 	TYPE="textbox" 
									NAME="id_bancoarq" 
									VALUE="<cfif isdefined("Form.id_bancoarq")><cfoutput>#Form.id_bancoarq#</cfoutput></cfif>" 
									SIZE="20" 
									MAXLENGTH="20"  
									ONBLUR="javascript:TraeDescripcionbancoarq(this.value);" 
									ONFOCUS="javascript: this.value=qf(this); this.select(); " 
									ONKEYUP="javascript: if(snumber(this,event,0)){ if(Key(event)=='13'){}} " >											
								</td>													
								<td nowrap>
									<input type="text"
									name="nbancoarq" id="nbancoarq"
									tabindex="-1" disabled
									value="<cfif isdefined("rsCuentaArq.nombre_banco")><cfoutput>#rsCuentaArq.nombre_banco#</cfoutput></cfif>"
									size="30" 
									maxlength="80"
									style="border: medium none; visibility:visible; background-color:#E8E8E8">
								</td>
							</tr>
							</table>					
					</TD>					
				</TR> 
				<TR>
					<TD>Cuenta Soin</TD>
					<TD>
						<cfif not isdefined("rscuentasoin")>
						<cf_cjcConlis 	
							size		="30" 
							tabindex    ="1" 
							form		="frmbancos"
							name 		="cuentasoin" 
							desc 		="cuentasoindesc"							 
							id			="Nid_bancosoin" 
							cjcConlisT 	="cjc_traeCuentaSoin"
							frame		="frmcuentasoin"
							colorfondo  ="##E8E8E8"
						>
						<cfelse>
						<cf_cjcConlis 	
							size		="30" 
							tabindex    ="1"
							form		="frmbancos"
							name 		="cuentasoin"
							desc 		="cuentasoindesc"
							id			="Nid_bancosoin" 
							cjcConlisT 	="cjc_traeCuentaSoin"
							query       ="#rsCuentaSoin#"
							frame		="frmcuentasoin"
							colorfondo  ="##E8E8E8"
						>
						</cfif>								
						<!---					
						<INPUT TYPE="textbox" NAME="cuentasoin" <cfif isdefined("modo") and modo eq "CAMBIO">readonly</cfif> VALUE="<cfif isdefined("Form.cuentasoin")><cfoutput>#Form.cuentasoin#</cfoutput></cfif>" SIZE="20" MAXLENGTH="20" ONBLUR="" ONFOCUS="this.select(); " ONKEYUP="if(sstring(this,event)){if(Key(event)=='13'){this.blur(); ACEPTAR();} }" style="">
						--->
					</TD>
					<TD>Cta. Conc. Bancarias</TD>
					<TD>
						<cfif not isdefined("rscuentaarq")>
						<cf_cjcConlis 	
							size		="30" 
							tabindex    ="1" 
							form		="frmbancos"
							name 		="cuentaarq" 
							desc 		="cuentaarqdesc"							 
							id			="Nid_bancoarq" 
							cjcConlisT 	="cjc_traeCuentaArq"
							frame		="frmcuentaarq"
							colorfondo  ="##E8E8E8"
						>
						<cfelse>
						<cf_cjcConlis 	
							size		="30" 
							tabindex    ="1"
							form		="frmbancos"
							name 		="cuentaarq"
							desc 		="cuentaarqdesc"
							id			="Nid_bancoarq" 
							cjcConlisT 	="cjc_traeCuentaArq"
							query       ="#rsCuentaArq#"
							frame		="frmcuentaarq"
							colorfondo  ="##E8E8E8"
						>
						</cfif>							
						<!--- 
						<INPUT TYPE="textbox" NAME="cuentaarq" VALUE="<cfif isdefined("Form.cuentaarq")><cfoutput>#Form.cuentaarq#</cfoutput></cfif>" SIZE="20" MAXLENGTH="20" ONBLUR="" ONFOCUS="this.select(); " ONKEYUP="if(sstring(this,event)){if(Key(event)=='13'){this.blur(); ACEPTAR();} }" style="">
						 --->
					</TD>

				</TR>				
				<TR>
					<TD><INPUT TYPE="HIDDEN" NAME="timestamp" VALUE=""></TD>
				</TR>
				<cfif not isdefined("modo")>
				<TR>
					<TD><INPUT TYPE="HIDDEN" NAME="MODO" VALUE="ALTA"></TD>
				</TR>
				<cfelse>
				<TR>
					<TD><INPUT TYPE="HIDDEN" NAME="MODO" VALUE="<cfoutput>#modo#</cfoutput>"></TD>
				</TR>				
				<TR>
					<TD><INPUT TYPE="HIDDEN" NAME="BAN" VALUE="1"></TD>
				</TR>				
				</cfif>				
				
				<SCRIPT LANGUAGE='Javascript' SRC="/cjc_js/cjc_Formatos.js"></SCRIPT>
				</TABLE>
			
			</td>
		</tr>
		<tr>
			<td> 
			<cfif isdefined("modo") and modo eq "CAMBIO">
				<input type="submit" name="Aceptar" value="Eliminar" onClick="javascript:Eliminar();">
				<input type="button" name="Aceptar" value="Regresar" onClick="javascript:Iratras()">
			<cfelse>
				<input type="submit" name="Aceptar" value="Aceptar"> 			
				<input type="reset" name="Limpiar" value="Limpiar">			
			</cfif>
			</td>
		</tr>		
		</TABLE>
		</FORM>
		
	</td>
</tr>
<tr>
	<td>
	
				<cfif isdefined("url.id_bancosoin") and len(trim(url.id_bancosoin)) gt 0 and isdefined("url.cuentasoin") and len(trim(url.cuentasoin)) gt 0>
					<cfset navegacion = "&id_bancosoin=#url.id_bancosoin#&cuentasoin=#url.cuentasoin#&modo='CAMBIO'"> 						
				<cfelse>
					<cfset navegacion = "" > 						
				</cfif>
				<cfinvoke 
					component="sif.fondos.Componentes.pListas"
					method="pLista"
					returnvariable="pListaRet">
					<cfinvokeargument name="conexion" value="#session.Fondos.dsn#"/>
					<cfinvokeargument name="tabla" value="CJINT03"/>
					<cfinvokeargument name="columnas" value="id_bancosoin, cuentasoin, id_bancoarq, cuentaarq"/>
					<cfinvokeargument name="desplegar" value="id_bancosoin, cuentasoin, id_bancoarq, cuentaarq"/>
					<cfinvokeargument name="etiquetas" value="Codigo Banco SOIN,Cuenta SOIN, Codigo Banco PAGOS, Cuenta PAGOS"/>
					<cfinvokeargument name="formatos" value="S,S,S,S"/>
					<cfinvokeargument name="filtro" value=""/>
					<cfinvokeargument name="align" value="left,left,left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="MaxRows" value="10"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="keys" value="id_bancosoin, cuentasoin"/>
					<cfinvokeargument name="irA" value="cjc_MantenimientoBancos.cfm"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
				</cfinvoke>			
	
	</td>
</tr>
</table>


</body>
</html>

