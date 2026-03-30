<script type="text/jscript" language="javascript">
	function SALVAEXCEL() {
		var EXCEL = document.getElementById("EXCEL");
		EXCEL.style.visibility='hidden';
		
		document.bjex.submit();  
	}
	
	function Mostrar() {
		var EXCEL = document.getElementById("EXCEL");
		EXCEL.style.visibility='visible';					
	}
</script>

<form action="cjc_excel.cfm?name=RecepcionVouchers" method="post" name="bjex"></form>

<cfinclude template="encabezadofondos.cfm">
<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">

<form name="form1" action="cjc_RRepRecepcionVauchers.cfm" method="post">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" colspan="2" >
			<input type="hidden" name="cons" value="0">
			<!--- Inicia pintado de la barra de botones --->
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="left" colspan="10">
						<table border='0' cellspacing='0' cellpadding='0' width='100%'>
							<tr>
								<td class="barraboton">&nbsp;
									<a id ="ACEPTAR" href="javascript:ACEPTAR();" onmouseover="overlib('Generar reporte',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Consultar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Consultar&nbsp;</span></a>
									<a id ="LIMPIAR" href="javascript:LIMPIAR();" onmouseover="overlib('Limpiar filtros',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Limpiar&nbsp;</span></a>
									<a id ="Printit" href="javascript:Printit();" onmouseover="overlib('Imprimir',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Imprimir'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Imprimir&nbsp;</span></a>
									<a id ="EXCEL"   href="javascript:SALVAEXCEL();" style="visibility:hidden" onmouseover="overlib('Exportar Excel',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Exportar Excel'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Exportar&nbsp;</span></a>
								</td>
								<td class=barraboton>
									<p align=center><font color='#FFFFFF'><b> </b></font></p>
								</td>
							</tr>
						</table>					
						<input type="hidden" id="btnFiltrar" name="btnFiltrar">
					</td>
				</tr>
			</table>
			<!--- Finaliza pintado de la barra de botones --->
		</td>
	</tr>	

	<tr>
		<td>
			<table  border="0" cellspacing="1" cellpadding="1" width="100%">
				<!--- Línea No. 1 --->
				<tr>
					<td width="15%" align="left">Fondo de Caja</td>
					<td width="25%">  
						<!--- Conlis de Fondos --->
						<cfset filfondo = true >
						<cfif not isdefined("NCJM00COD")>
							<cf_cjcConlis 	
								size		 = "40"
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
								size		 = "40"  
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
					<td width="10%">&nbsp;</td>
					<td width="15%">Fecha Recepci&oacute;n</td>
					<td width="25%">
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<cfif isdefined("form.CJX12IRC")>
								<cfif trim(form.CJX12IRC) EQ 1>
									<tr id="tr_fecha" >
								<cfelse>
									<tr id="tr_fecha" style="display: none">
								</cfif>
							<cfelse>
								<tr id="tr_fecha" style="display: none">
							</cfif>
								<td>
									<cfif isdefined("FECHA_VOUCHER")>
										<cfset F_FINAL = #FECHA_VOUCHER#>
									<cfelse>
										<cfset F_FINAL = "">
									</cfif>
									<cf_CJCcalendario tabindex="6" name="FECHA_VOUCHER" form="form1" value="#F_FINAL#">
								</td>
							</tr>
							<cfif isdefined("form.CJX12IRC")>
								<cfif trim(form.CJX12IRC) EQ 1>
									<tr id="tr_campo" style="display: none">
								<cfelse>
									<tr id="tr_campo" >
								</cfif>
							<cfelse>
								<tr id="tr_campo" >
							</cfif>
								<td>
									<INPUT TYPE="textbox" 
										NAME="FECHA" 
										VALUE="" 
										SIZE="10" 
										MAXLENGTH="10" 
										tabindex="6"
										DISABLED >
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<!--- Línea No. 2 --->
				<tr>
					<td width="15%">Periodo</td>
			  		<td width="25%">
						<cfquery datasource="#session.Fondos.dsn#" name="rsPeriodo">
							Select PERCOD
							from CGX051
							order by PERCOD
						</cfquery>
						<cfif not isdefined("form.PERCOD")>
							<cfset form.PERCOD = year(now())>
						</cfif>
						<select name="PERCOD" size="1" tabindex="3" style="font-size:8pt;  font-family: Courier New;">
                       		<cfoutput query="rsPeriodo">
                           		<option value="#PERCOD#" 
									<cfif isdefined("form.PERCOD") and isdefined("rsPeriodo") 
									and len(form.PERCOD) and len(rsPeriodo.PERCOD)
					  				and form.PERCOD eq rsPeriodo.PERCOD>selected</cfif>>
									#PERCOD#
								</option>
                       		</cfoutput>
                       	</select>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Mes Inicial</td>
					<td width="25%">
						<cfif not isdefined("form.MESCODI")>
							<cfset form.MESCODI = month(now())>
						</cfif>
						<select name="MESCODI" size="1" tabindex="4" style="font-size:8pt;  font-family: Courier New;">
							<cfloop from="1" to="12" step="1" index="indmes">
								<option value="<cfoutput>#indmes#</cfoutput>" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq indmes>selected</cfif>>
									<cfoutput>#indmes#</cfoutput><cfif indmes lt 10>&nbsp;</cfif>&nbsp;-
									<cfswitch expression="#indmes#">
										<cfcase value="1">ENERO</cfcase>
										<cfcase value="2">FEBRERO</cfcase>
										<cfcase value="3">MARZO</cfcase>
										<cfcase value="4">ABRIL</cfcase>
										<cfcase value="5">MAYO</cfcase>
										<cfcase value="6">JUNIO</cfcase>
										<cfcase value="7">JULIO</cfcase>
										<cfcase value="8">AGOSTO</cfcase>
										<cfcase value="9">SETIEMBRE</cfcase>
										<cfcase value="10">OCTUBRE</cfcase>
										<cfcase value="11">NOVIEMBRE</cfcase>
										<cfcase value="12">DICIEMBRE</cfcase>
									</cfswitch>
								</option>
							</cfloop>			
						</select>
					</td>
				</tr>
				<!--- Línea No. 3 --->
				<tr>
					<td width="15%">Empleado</td>
					<td width="25%">
						<cfif isdefined("EMPCOD")>
							<cfquery name="rsEmpleado" datasource="#session.Fondos.dsn#">
								select EMPCOD,EMPCED,EMPNOM +' '+EMPAPA+' '+EMPAMA  NOMBRE 
								from PLM001 
								where  EMPCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPCOD#" >
							</cfquery>
							<cf_cjcConlis 	
									size		="30"  
									name 		="EMPCED" 
									desc 		="NOMBRE" 
									id			="EMPCOD"
									desc2		="TR01NUT"
									cjcConlisT 	="cjc_traeEmpVoucherRep"
									query       ="#rsEmpleado#"
									form		="form1"
									tabindex    ="7"
							>			
						<cfelse>
							<cf_cjcConlis 	
									size		="30"  
									name 		="EMPCED" 
									desc 		="NOMBRE" 
									id			="EMPCOD" 
									desc2		="TR01NUT"
									cjcConlisT 	="cjc_traeEmpVoucherRep"
									form   		="form1"
									tabindex    ="7"
							>
						</cfif>				
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Mes Final</td>
					<td width="25%">
						<cfif not isdefined("form.MESCODF")>
							<cfset form.MESCODF = month(now())>
						</cfif>
						<select name="MESCODF" size="1" tabindex="6" style="font-size:8pt;  font-family: Courier New;">
							<cfloop from="1" to="12" step="1" index="indmes">
								<option value="<cfoutput>#indmes#</cfoutput>" <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq indmes>selected</cfif>>
									<cfoutput>#indmes#</cfoutput><cfif indmes lt 10>&nbsp;</cfif>&nbsp;-
									<cfswitch expression="#indmes#">
										<cfcase value="1">ENERO</cfcase>
										<cfcase value="2">FEBRERO</cfcase>
										<cfcase value="3">MARZO</cfcase>
										<cfcase value="4">ABRIL</cfcase>
										<cfcase value="5">MAYO</cfcase>
										<cfcase value="6">JUNIO</cfcase>
										<cfcase value="7">JULIO</cfcase>
										<cfcase value="8">AGOSTO</cfcase>
										<cfcase value="9">SETIEMBRE</cfcase>
										<cfcase value="10">OCTUBRE</cfcase>
										<cfcase value="11">NOVIEMBRE</cfcase>
										<cfcase value="12">DICIEMBRE</cfcase>
									</cfswitch>
								</option>
							</cfloop>			
						</select>
					</td>
				</tr>		
				<!--- Línea No. 4 --->
				<tr>
					<td width="15%">Estado</td>
					<td width="25%">
						<select name="CJX12IRC" size="1" tabindex="9" style="font-size:8pt;  font-family: Courier New;" onchange="javascript: HabilitarFecha(this.value)">
							<cfloop from="0" to="1" step="1" index="indmes">
								<option value="<cfoutput>#indmes#</cfoutput>" <cfif isdefined("form.CJX12IRC") and len(form.CJX12IRC) and form.CJX12IRC eq indmes>selected</cfif>>
									<cfoutput>#indmes#</cfoutput>&nbsp;-
									<cfswitch expression="#indmes#">																				
										<cfcase value="0">Pendientes</cfcase>
										<cfcase value="1">Recibidos</cfcase>
									</cfswitch>
								</option>
							</cfloop>			
						</select>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">No. de Tarjeta:&nbsp;</td>
					<td width="25%">
                   		<INPUT TYPE="textbox" 
							NAME="TR01NUT" 
							ID  ="TR01NUT" 
							tabindex="8"
							VALUE="<cfif isdefined("TR01NUT")><cfoutput>#TR01NUT#</cfoutput></cfif>" 
							SIZE="20" 
							MAXLENGTH="20" 
							ONFOCUS="this.select(); " 
							ONKEYUP="" 
							style="visibility:">
					</td>
				</tr>
				<!--- Línea No. 5 --->			
				<tr>
					<td width="15%">Tipo de Voucher</td>
					<td width="25%">
						<cfif not isdefined("form.CJX12TIP")>
							<cfset form.CJX12TIP = "0">
						</cfif>	
						<select name="CJX12TIP" size="1" tabindex="5" style="font-size:8pt;  font-family: Courier New;">
							<option value="0" <cfif isdefined("form.CJX12TIP") and len(form.CJX12TIP) and form.CJX12TIP eq 0>selected</cfif>>- Todos -</option>
							<option value="1" <cfif isdefined("form.CJX12TIP") and len(form.CJX12TIP) and form.CJX12TIP eq 1>selected</cfif>>CD - Compra Directa</option>
							<option value="2" <cfif isdefined("form.CJX12TIP") and len(form.CJX12TIP) and form.CJX12TIP eq 2>selected</cfif>>RC - Retiro de Cajero</option>
							<option value="3" <cfif isdefined("form.CJX12TIP") and len(form.CJX12TIP) and form.CJX12TIP eq 3>selected</cfif>>DE - Devoluci&oacute;n</option>
							<option value="4" <cfif isdefined("form.CJX12TIP") and len(form.CJX12TIP) and form.CJX12TIP eq 4>selected</cfif>>RV - Reversi&oacute;n Devoluciones</option>
						</select>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">No. Autorizaci&oacute;n</td>
					<td width="25%">
                   		<input type="textbox" 
							name="CJX12AUT" 
							id  ="CJX12AUT"
							tabindex="10" 
							value="<cfif isdefined("CJX12AUT")><cfoutput>#CJX12AUT#</cfoutput></cfif>" 
							size= "20" 
							maxlength="20" 					
							onFocus="this.select(); " 
							onKeyUp="" 
							style="visibility:">
					</td>
				</tr>
				<!--- Línea No. 6 --->			
				<tr>
					<td width="15%">Ordenar Datos Por</td>
					<td width="25%">
						<cfif not isdefined("form.ORDENAR")>
							<cfset form.ORDENAR = "1">
						</cfif>	
						<select name="ORDENAR" size="1" tabindex="11" style="font-size:8pt;  font-family: Courier New;">
							<cfloop from="1" to="8" step="1" index="indmes">
								<option value="<cfoutput>#indmes#</cfoutput>" <cfif isdefined("form.ORDENAR") and len(form.ORDENAR) and form.ORDENAR eq indmes>selected</cfif>>
									<cfoutput>#indmes#</cfoutput>&nbsp;-
									<cfswitch expression="#indmes#">																				
										<cfcase value="1">Fecha Voucher</cfcase>
										<cfcase value="2">C&eacute;dula</cfcase>
										<cfcase value="3">Autorizaci&oacute;n</cfcase>
										<cfcase value="4">No. Tarjeta</cfcase>
										<cfcase value="5">Monto</cfcase>
										<cfcase value="6">Empleado</cfcase>
										<cfcase value="7">D&iacute;as Atraso</cfcase>
										<cfcase value="8">Fecha Recepci&oacute;n</cfcase>
									</cfswitch>
								</option>
							</cfloop>			
						</select>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">&nbsp;</td>
					<td width="25%">&nbsp;</td>
				</tr>
			</table>
		</td>		
	</tr>		
</table>
</form>


<!---********************** --->
<!---** AREA DE SCRIPTS  ** --->
<!---********************** --->
<cfif isdefined("btnFiltrar")>
	<script>		
		var param="";
		<cfif isdefined("PERCOD") and len(PERCOD)>
			param = param + "&PERCOD=<cfoutput>#PERCOD#</cfoutput>"	
		</cfif>
		<cfif isdefined("MESCODI") and len(MESCODI)>
			param = param + "&MESCODI=<cfoutput>#MESCODI#</cfoutput>"	
		</cfif>
		<cfif isdefined("MESCODF") and len(MESCODF)>
			param = param + "&MESCODF=<cfoutput>#MESCODF#</cfoutput>"	
		</cfif>
		<cfif isdefined("NCJM00COD") and len(NCJM00COD)>			
			param = param + "&NCJM00COD=<cfoutput>#NCJM00COD#</cfoutput>"
		</cfif>
		<cfif isdefined("FECHA_VOUCHER") and len(FECHA_VOUCHER)>
			param = param + "&FECHA_VOUCHER='<cfoutput>#FECHA_VOUCHER#</cfoutput>'"	
		</cfif>
		<cfif isdefined("TR01NUT") and len(TR01NUT)>
			param = param + "&TR01NUT=<cfoutput>#TR01NUT#</cfoutput>"
		</cfif>
		<cfif isdefined("CJX12AUT") and len(CJX12AUT)>
			param = param + "&CJX12AUT=<cfoutput>#CJX12AUT#</cfoutput>"
		</cfif>
		<cfif isdefined("CJX12IRC") and len(CJX12IRC)>
			<cfif CJX12IRC eq 0 >
				param = param + "&CJX12IRC=(CJX12IRC is null or CJX12IRC != 1)"
			</cfif>					
			<cfif CJX12IRC eq 1 >
				param = param + "&CJX12IRC=1"
			</cfif>
		</cfif>	
		<cfif isdefined("CJX12TIP") and len(CJX12TIP)>
			param = param + "&CJX12TIP=<cfoutput>#CJX12TIP#</cfoutput>"
		</cfif>
		<cfif isdefined("ORDENAR") and len(ORDENAR)>
			<cfif ORDENAR eq 1 >
				param = param +"&ORDENAR=order by a.CJX12FAU desc"
			</cfif>					
			<cfif ORDENAR eq 2 >
				param = param +"&ORDENAR=order by EMPCED"
			</cfif>
			<cfif ORDENAR eq 3 >
				param = param +"&ORDENAR=order by a.CJX12AUT"
			</cfif>
			<cfif ORDENAR eq 4 >
				param = param +"&ORDENAR=order by a.TR01NUT"
			</cfif>
			<cfif ORDENAR eq 5 >
				param = param +"&ORDENAR=order by a.CJX12IMP"
			</cfif>
			<cfif ORDENAR eq 6 >
				param = param +"&ORDENAR=order by EMPNOM"
			</cfif>
			<cfif ORDENAR eq 7 >
				param = param +"&ORDENAR=order by a.DIAS_DIF desc"
			</cfif>
			<cfif ORDENAR eq 8 >
				param = param +"&ORDENAR=order by a.CJX12FRC desc"
			</cfif>
		</cfif>	
				
		PURL = "../operacion/cjc_sqlRRepRecepcionVauchers.cfm?btnFiltrar=1" + param;		
		window.parent.frm_reporte.location = PURL;
	</script>
</cfif>

<cfif isdefined("form.cons") and form.cons eq 1>
	<script language="JavaScript1.2" type="text/javascript">
		Mostrar();
	</script>
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function ACEPTAR() {
		if (validar()) {
			document.form1.cons.value=1;
			document.form1.submit();
		}
	}
	
	function LIMPIAR() {
		document.location = '../operacion/cjc_RepRecepcionVauchers.cfm';
		window.parent.frm_reporte.location = '../operacion/cjc_sqlRRepRecepcionVauchers.cfm';
	}
	
	function Printit() {
		window.parent.frm_reporte.focus();
		window.parent.frm_reporte.print();
	}
		
	function validar() {
		if(document.form1.NCJM00COD.value == "") {
			alert("Digite el Fondo de Caja");
			document.form1.NCJM00COD.focus();
			return false;
		}
		return true;
	}

	function HabilitarFecha(valor) {
		var vFecha = document.getElementById("tr_fecha");
		var vCampo = document.getElementById("tr_campo");

		if (valor == 0) {
			vFecha.style.display = "none";			
			vCampo.style.display = "";
		}
		else {
			vFecha.style.display = "";			
			vCampo.style.display = "none";			
		}
	}
	
</script> 
