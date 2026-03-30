<!--- Recibe form, tr01nut, percod y mescod --->
<script language="JavaScript" type="text/javascript">
	function Asignar(autorizar,monto,fecha,recibido,tipo) {
		if (window.opener != null) {
			<cfoutput>
				window.opener.document.#Url.form#.CJX23AUT.value = autorizar;
				window.opener.document.#Url.form#.CJX23MON.value = Math.abs(monto);
				window.opener.document.#Url.form#.CJX23FEC.value = fecha;
				if(tipo == 'C') {
					window.opener.document.#Url.form#.CJX23TTR[0].checked = true;
				}
				if(tipo == 'D') {
					window.opener.document.#Url.form#.CJX23TTR[1].checked = true;
				}
				if(tipo == 'R') {
					window.opener.document.#Url.form#.CJX23TTR[2].checked = true;
				}
			</cfoutput>
			window.close();
		}
	}
</script>


<!--- Parámetros recibidos de la pantalla padre --->
<cfif isdefined("Url.TR01NUT") and not isdefined("Form.TR01NUT")>
	<cfparam name="Form.TR01NUT" default="#Url.TR01NUT#">
</cfif>
<cfif isdefined("Url.PERCOD") and not isdefined("Form.PERCOD")>
	<cfparam name="Form.PERCOD" default="#Url.PERCOD#">
</cfif>
<cfif isdefined("Url.MESCOD") and not isdefined("Form.MESCOD")>
	<cfparam name="Form.MESCOD" default="#Url.MESCOD#">
</cfif>
<cfif isdefined("Url.CJX19REL") and not isdefined("Form.CJX19REL")>
	<cfparam name="Form.CJX19REL" default="#Url.CJX19REL#">
</cfif>
<cfif isdefined("Url.CJX23TIP") and not isdefined("Form.CJX23TIP")>
	<cfparam name="Form.CJX23TIP" default="#Url.CJX23TIP#">
</cfif>
<cfif isdefined("Url.TS1COD") and not isdefined("Form.TS1COD")>
	<cfparam name="Form.TS1COD" default="#Url.TS1COD#">
</cfif>
<cfif isdefined("Url.EMPCOD") and not isdefined("Form.EMPCOD")>
	<cfparam name="Form.EMPCOD" default="#Url.EMPCOD#">
</cfif>
<cfif isdefined("Url.CJM00COD") and not isdefined("Form.CJM00COD")>
	<cfparam name="Form.CJM00COD" default="#Url.CJM00COD#">
</cfif>

<!--- 
<cfif isdefined("Url.CJX23CHK") and not isdefined("Form.CJX23CHK")>
	<cfparam name="Form.CJX23CHK" default="#Url.CJX23CHK#">
</cfif>
<cfif isdefined("Url.CP9COD") and not isdefined("Form.CP9COD")>
	<cfparam name="Form.CP9COD" default="#Url.CP9COD#">
</cfif>
<cfif isdefined("Url.CJX23TTR") and not isdefined("Form.CJX23TTR")>
	<cfparam name="Form.CJX23TTR" default="#Url.CJX23TTR#">
</cfif>
<cfif isdefined("Url.CJX5IDE") and not isdefined("Form.CJX5IDE")>
	<cfparam name="Form.CJX5IDE" default="#Url.CJX5IDE#">
</cfif>
--->

<!--- Parámetros para utilizar el filtro --->
<cfset filtro = "">
<cfset navegacion = "">
<cfset cond = "">
<cfif isdefined("Form.tarjeta") and Len(Trim(Form.tarjeta)) NEQ 0>
	<cfset cond = " and">
	<cfset filtro = filtro & cond & " TR01NUT like '%" & #Form.tarjeta# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "tarjeta=" & Form.tarjeta>
</cfif>
<cfif isdefined("Form.autorizar") and Len(Trim(Form.autorizar)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " CJX12AUT like '%" & #Form.autorizar# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "autorizar=" & Form.autorizar>
</cfif>
<cfif isdefined("Form.monto") and Len(Trim(Form.monto)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " CJX12IMP >=" & #Form.monto# >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "monto=" & Form.monto>
</cfif>			
<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " CJX12FEC ='" & #LSdateformat(Form.fecha,"yyyymmdd")# & "'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fecha=" & Form.fecha>
</cfif>

<cfif isdefined("Form.recibido") and Len(Trim(Form.recibido)) NEQ 0>
	<cfset cond = " and">
 	<cfset filtro = filtro & cond & " isnull(CJX12IRC, 0) = " & #Form.recibido#>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "recibido=" & Form.recibido>
<!---
<cfelse>
	<cfif not isdefined("Form.recibido")>
		<cfset cond = " and">
	 	<cfset filtro = filtro & cond & " CJX12IRC = 1">
	</cfif>
--->
</cfif>


<!--- Pintado de la Lista --->
<html>
<head>
<title>Cat&aacute;logo de Vouchers</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">
</head>
<body>

<form name="ord" method="post" action="cjc_traeVoucher.cfm?form=form1">
	<input type="hidden" name="ordenarpor" value="">
	<input type="hidden" name="TR01NUT" value="<cfoutput>#form.TR01NUT#</cfoutput>">
	<input type="hidden" name="PERCOD" value="<cfoutput>#form.PERCOD#</cfoutput>">
	<input type="hidden" name="MESCOD" value="<cfoutput>#form.MESCOD#</cfoutput>">
	<input type="hidden" name="CJX19REL" value="<cfoutput>#form.CJX19REL#</cfoutput>">
	<input type="hidden" name="CJX23TIP" value="<cfoutput>#form.CJX23TIP#</cfoutput>">
	<input type="hidden" name="TS1COD" value="<cfoutput>#form.TS1COD#</cfoutput>">
	<input type="hidden" name="EMPCOD" value="<cfoutput>#form.EMPCOD#</cfoutput>">
	<input type="hidden" name="CJM00COD" value="<cfoutput>#form.CJM00COD#</cfoutput>">
	<!--- 	
	<input type="hidden" name="CJX23CHK" value="<cfoutput>#form.CJX23CHK#</cfoutput>">
	<input type="hidden" name="CP9COD" value="<cfoutput>#form.CP9COD#</cfoutput>">
	<input type="hidden" name="CJX23TTR" value="<cfoutput>#form.CJX23TTR#</cfoutput>">
	<input type="hidden" name="CJX5IDE" value="<cfoutput>#form.CJX5IDE#</cfoutput>">
	 --->
	<input type="hidden" name="autorizar" value="<cfoutput><cfif isdefined("form.autorizar")>#form.autorizar#</cfif></cfoutput>">
	<input type="hidden" name="monto" value="<cfoutput><cfif isdefined("form.monto")>#form.monto#</cfif></cfoutput>">
	<input type="hidden" name="fecha" value="<cfoutput><cfif isdefined("form.fecha")>#form.fecha#</cfif></cfoutput>">
	<input type="hidden" name="recibido" value="<cfoutput><cfif isdefined("form.recibido")>#form.recibido#</cfif></cfoutput>">
</form>

<cfset filordenar = "">
<cfif isdefined("form.ordenarpor") and form.ordenarpor neq "">
	<cfset filordenar = " Order by " & form.ordenarpor>
</cfif>

<cfoutput>
	<form style="margin:0; " name="filtroVouchers" method="post">
		<input type="hidden" name="TR01NUT" value="<cfoutput>#form.TR01NUT#</cfoutput>">
		<input type="hidden" name="PERCOD" value="<cfoutput>#form.PERCOD#</cfoutput>">
		<input type="hidden" name="MESCOD" value="<cfoutput>#form.MESCOD#</cfoutput>">
		<input type="hidden" name="CJX19REL" value="<cfoutput>#form.CJX19REL#</cfoutput>">
		<input type="hidden" name="CJX23TIP" value="<cfoutput>#form.CJX23TIP#</cfoutput>">
		<input type="hidden" name="TS1COD" value="<cfoutput>#form.TS1COD#</cfoutput>">
		<input type="hidden" name="EMPCOD" value="<cfoutput>#form.EMPCOD#</cfoutput>">
		<input type="hidden" name="CJM00COD" value="<cfoutput>#form.CJM00COD#</cfoutput>">
		<!--- 		
		<input type="hidden" name="CJX23TTR" value="<cfoutput>#form.CJX23TTR#</cfoutput>">
		<input type="hidden" name="CJX5IDE" value="<cfoutput>#form.CJX5IDE#</cfoutput>">
		<input type="hidden" name="CJX23CHK" value="<cfoutput>#form.CJX23CHK#</cfoutput>">
		<input type="hidden" name="CP9COD" value="<cfoutput>#form.CP9COD#</cfoutput>">
		 --->
		 
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="center" nowrap><strong>Autorización</strong></td>
				<td align="center" nowrap> 
					<input name="autorizar" type="text" id="autorizar" size="20" maxlength="20" value="<cfif isdefined("Form.autorizar")>#Form.autorizar#</cfif>">
				</td>
				<td align="center" nowrap><strong>Monto</strong></td>
				<td align="center" nowrap> 
					<input name="monto" type="text" id="monto" size="8" maxlength="8" value="<cfif isdefined("Form.monto")>#Form.monto#</cfif>">
				</td>
				<td align="center" nowrap><strong>Fecha</strong></td>
				<td align="center" nowrap> 
					<cfif isdefined("fecha")>
						<cfset F_VOUCHER = #fecha#>
					<cfelse>
						<cfset F_VOUCHER = "">
					</cfif>
					<cf_CJCcalendario  tabindex="1" name="fecha" form="filtroVouchers"  value="#F_VOUCHER#">	
				</td>
				<td align="center" nowrap><strong>Recibido</strong></td>
				<td align="center" nowrap>
                  <select name="recibido" id="recibido">
						<option value=""  <cfif isdefined("form.recibido") and len(form.recibido) eq 0 and trim(form.recibido) eq "">selected</cfif>>TODOS</option>
						<option value="1" <cfif isdefined("form.recibido") and len(form.recibido) and trim(form.recibido) eq "1">selected</cfif>>SI</option>
						<option value="0" <cfif isdefined("form.recibido") and len(form.recibido) and trim(form.recibido) eq "0">selected</cfif>>NO</option>
                  </select>				
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
				</td>
			</tr>
		</table>
		<hr>
		<table width="100%" border="0" cellpadding="2" cellspacing="0">
			<tr bgcolor="##CCCCCC">
				<td width="6%" nowrap><strong>No. Tarjeta:</strong>&nbsp;</td>
				<td width="94%" nowrap><strong>#Form.TR01NUT#</strong></td>
			</tr>
			<tr>
				<td colspan="2" nowrap>
					<cfinvoke 
					 component="sif.fondos.Componentes.pListas"
					 method="pLista"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="CJX012 a"/> 	
						<cfinvokeargument name="columnas" value="	a.CJX12AUT,
																	convert(varchar,a.CJX12FEC,103) as CJX12FEC,
																	case 
																		when a.CJX12TIP in (1,2,4) then a.CJX12IMP else (a.CJX12IMP * -1) 
																	end as CJX12IMP,
																	case 
																		when a.CJX12TIP = 1 then 'C'
																		when a.CJX12TIP in (2,4) then 'R'
																		when a.CJX12TIP in (3,5,7) then 'D'
																	end as CJX12TIP,
																	case a.CJX12IRC
																		when 0 then 'NO'
																		when 1 then convert(varchar,a.CJX12FRC,103)
																	end as CJX12XIRC,
																	case 
																		when datediff(dd,a.CJX12FIP,getdate()) <= 2 then '**'
																	end as  CJX12YFIP "/>
						<cfinvokeargument name="desplegar" value="CJX12AUT,CJX12IMP,CJX12FEC,CJX12XIRC,CJX12YFIP"/>
						<cfinvokeargument name="etiquetas" value="  <a href='javascript:Ordenar(1);'>Autorizacion</a>,
																	<a href='javascript:Ordenar(2);'>Monto</a>,
																	<a href='javascript:Ordenar(3);'>Fecha</a>,
																	<a href='javascript:Ordenar(4);'>Recibido</a>, "/>
						<cfinvokeargument name="formatos" value="S,M,S,S,S"/>	
						<!--- 
						Se solicitud por parte de Mauricio Arias y Cristian Barrantes el dia 06/Julio/2006 quitar PERDOD Y MESCOD del Filtro
						<cfinvokeargument name="filtro" value=" CJX12IND!='S' and PERCOD=#Form.PERCOD# and MESCOD=#Form.MESCOD# and TR01NUT='#Form.TR01NUT#' #filtro# #filordenar#"/> 
						--->
						<cfif isdefined("form.ordenarpor") and form.ordenarpor neq "">
							<cfinvokeargument name="filtro" value=" CJX12IND!='S' 
																		and TR01NUT='#Form.TR01NUT#' 
																		and not exists(	select 1 
																						from CJX011 b
																						where b.TS1COD     = a.TS1COD
																							and b.TR01NUT  = a.TR01NUT
																							and b.CJM00COD = a.CJM00COD
																							and b.CJX11AUT = a.CJX12AUT)
																		and CJ12TRAN is null
																		#filtro# #filordenar#"/>
						<cfelse>
							<cfinvokeargument name="filtro" value=" CJX12IND!='S' 
																		and TR01NUT='#Form.TR01NUT#' 
																		and not exists(	select 1 
																						from CJX011 b
																						where b.TS1COD     = a.TS1COD
																							and b.TR01NUT  = a.TR01NUT
																							and b.CJM00COD = a.CJM00COD
																							and b.CJX11AUT = a.CJX12AUT)
																		and CJ12TRAN is null
																		#filtro# Order by CJX12AUT"/>
						</cfif>
						<cfinvokeargument name="align" value="left,right,center,center,center"/>
						<cfinvokeargument name="ajustar" value="S,S,S,S,S"/>
						<cfinvokeargument name="formName" value="listaVoucher"/>
						<cfinvokeargument name="MaxRows" value="20"/>
						<cfinvokeargument name="funcion" value="Asignar"/>
						<cfinvokeargument name="fparams" value="CJX12AUT,CJX12IMP,CJX12FEC,CJX12XIRC,CJX12TIP"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="Conexion" value="#session.Fondos.dsn#"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="checkboxes" value="S"/>
					</cfinvoke>
				</td>			
			</tr>
			<tr>
				<td colspan="2" nowrap="nowrap" align="center">
					<input name="btnAceptar" type="button" value="Aceptar" onClick="javascript: Aplicar();" >
				</td>
			</tr>
			<tr>
				<td colspan="2" nowrap>&nbsp;</td>
			</tr>
			<tr bgcolor="##CCCCCC">
				<td colspan="2" nowrap><strong>** - Documento de reciente importaci&oacute;n (menos de 2 días) </strong></td>
			</tr>
	  </table>
	</form>
</cfoutput>


<script>
	function Ordenar(campo)
	{
		switch (campo){
			case 1:
				document.ord.ordenarpor.value = "CJX12AUT";
				break;
			case 2:
				document.ord.ordenarpor.value = "CJX12IMP";
				break;
			case 3:
				document.ord.ordenarpor.value = "CJX12FEC";
				break;
			case 4:
				document.ord.ordenarpor.value = "CJX12IRC";
				break;
		}
		document.ord.submit();
	}
	
	function Aplicar(){
		<cfif isdefined("pListaRet")>
			if (ValidaChecks()) {
				document.filtroVouchers.action = "cjc_traeVouchers-sql.cfm";
				document.filtroVouchers.submit();
			}
			else {
				alert("Es necesario seleccionar al menos un voucher");
			}
		<cfelse>
			alert("Es necesario seleccionar al menos un voucher");
		</cfif>
	}
	
	function ValidaChecks() {		
		<cfif isdefined("pListaRet") and pListaRet neq 0>
			<cfif isdefined("pListaRet") and pListaRet eq 1>				
				if (document.filtroVouchers.chk.checked == true) {
					return true;
				}
				return false;
			<cfelse>
				var field = document.filtroVouchers.chk;		
				for (i = 0; i < field.length; i++) {
					if (field[i].checked == true) {	
						return true;
					}
				}
				return false;
			</cfif>
		<cfelse>
			return false;
		</cfif>
	}


</script>

</body>
</html>
