<!--- 
Archivo:  cjc_formRVouchersDigitados.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    28 Agosto 2006.              
--->
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

<form action="cjc_excel.cfm?name=VouchersDigitados" method="post" name="bjex"></form>

<cfinclude template="encabezadofondos.cfm">

<form name="form1" action="cjc_RVouchersDigitados.cfm" method="post">
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
				<tr>
					<td width="15%" align="left">C&oacute;digo de Caja</td>
					<td > 
						<!--- Conlis de Cajas --->
						<cfif not isdefined("NCJ01ID")>
							<cf_cjcConlis 	
								size		= "40"
								tabindex    = "1"
								name 		= "NCJ01ID"
								desc 		= "CJ1DES"
								id			= "CJ01ID"
								sizecodigo	= 10
								cjcConlisT 	= "cjc_traecaja"
								frame		= "frm_cajas"
							>			
						<cfelse>				
							<cfquery name="rsQryCaja" datasource="#session.Fondos.dsn#">
								select CJ01ID as NCJ01ID, CJ01ID,CJ1DES
								from CJM001
								where CJ01ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NCJ01ID#" >
							</cfquery>						
							<cf_cjcConlis 	
								size		= "40"
								tabindex    = "1"
								name 		= "NCJ01ID"
								desc 		= "CJ1DES"
								id			= "CJ01ID"
								sizecodigo	= 10
								cjcConlisT 	= "cjc_traecaja"
								query       ="#rsQryCaja#"
								frame		= "frm_cajas"
							>			
						</cfif>													
					</td>
				</tr>
				
				<tr>
					<td width="15%" align="left">Fecha Inicial</td>
					<td > 
						<cfif isdefined("FECHAINI")>
							<cfset FECHA_I = #FECHAINI#>
						<cfelse>
							<cfset FECHA_I = "">
						</cfif>
						<cf_CJCcalendario tabindex="2" name="FECHAINI" form="form1"  value="#FECHA_I#">
					</td>					
				</tr>
				
				<tr>
					<td width="15%" align="left">Fecha Final</td>
					<td > 
						<cfif isdefined("FECHAFIN")>
							<cfset FECHA_F = #FECHAFIN#>
						<cfelse>
							<cfset FECHA_F = "">
						</cfif>
						<cf_CJCcalendario tabindex="3" name="FECHAFIN" form="form1"  value="#FECHA_F#">
					</td>											
				</tr>
				
			</table>
		</td>
	</tr>		
</table>
</form>

<!--- Área de Script's --->
<cfif isdefined("btnFiltrar")>
	<script>
		var param="";
		<cfif isdefined("NCJ01ID") and len(NCJ01ID)>			
			param = param + "&NCJ01ID=<cfoutput>#NCJ01ID#</cfoutput>"
		</cfif>
		<cfif isdefined("FECHAINI") and len(FECHAINI)>			
			param = param + "&FECHAINI='<cfoutput>#FECHAINI#</cfoutput>'"			
		</cfif>
		<cfif isdefined("FECHAFIN") and len(FECHAFIN)>			
			param = param + "&FECHAFIN='<cfoutput>#FECHAFIN#</cfoutput>'"
		</cfif>
		
		PURL = "../operacion/cjc_sqlRVouchersDigitados.cfm?btnFiltrar=1" + param;		
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
		document.location = '../operacion/cjc_VouchersDigitados.cfm';
		window.parent.frm_reporte.location = '../operacion/cjc_sqlRVouchersDigitados.cfm';
	}
	
	function Printit() {
		window.parent.frm_reporte.focus();
		window.parent.frm_reporte.print();
	}
	
	function validar() {
		if(document.form1.NCJ01ID.value == "") {
			alert("Digite el Fondo de Caja");
			document.form1.NCJ01ID.focus();
			return false;
		}
		if(document.form1.FECHAINI.value == "") {
			alert("Digite la Fecha Inicial");
			document.form1.FECHAINI.focus();
			return false;
		}
		if(document.form1.FECHAFIN.value == "") {
			alert("Digite la Fecha Final");
			document.form1.FECHAFIN.focus();
			return false;
		}

		return true;
	}
</script> 
