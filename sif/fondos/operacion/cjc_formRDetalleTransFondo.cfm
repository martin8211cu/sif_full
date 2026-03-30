<!--- 
Archivo:  cjc_formRVouchersDigitados.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    26 Octubre 2006.              
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

<form action="cjc_excel.cfm?name=DetalleTransFondo" method="post" name="bjex"></form>

<cfinclude template="encabezadofondos.cfm">

<form name="form1" action="cjc_RDetalleTransFondo.cfm" method="post">
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
				<!--- Linea No. 01 del Filtro --->
				<tr>
					<td width="15%" align="left">C&oacute;digo de Fondo</td>
					<td > 
						<!--- Conlis de Fondos --->
						<cfset filfondo = false >
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
								SELECT CJM00COD as NCJM00COD, CJM00COD, CJM00DES 
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
					<td width="15%" align="left">C&oacute;digo de Caja</td>
					<td >
						<cfif not isdefined("NCJ01ID")>
							<cf_cjcConlis 	
								size		= "40"
								tabindex    = "2"
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
								tabindex    = "2"
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
				<!--- Linea No. 02 del Filtro --->
				<tr>
					<td width="15%" align="left">Periodo</td>
					<td >
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
					<td width="15%" align="left">Mes Inicial</td>
					<td>
						<select name="MESCODI" size="1" tabindex="4" style="font-size:8pt;  font-family: Courier New;">
							<option value="1" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq "1">selected</cfif>>-- Todos --</option>
							<option value="1" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq "1">selected</cfif>>1 - Enero</option>
							<option value="2" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq "2">selected</cfif>>2 - Febrero</option>
							<option value="3" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq "3">selected</cfif>>3 - Marzo</option>
							<option value="4" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq "4">selected</cfif>>4 - Abril</option>
							<option value="5" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq "5">selected</cfif>>5 - Mayo</option>
							<option value="6" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq "6">selected</cfif>>6 - Junio</option>
							<option value="7" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq "7">selected</cfif>>7 - Julio</option>
							<option value="8" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq "8">selected</cfif>>8 - Agosto</option>
							<option value="9" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq "9">selected</cfif>>9 - Setiembre</option>
							<option value="10" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq "10">selected</cfif>>10 - Octubre</option>
							<option value="11" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq "11">selected</cfif>>11 - Noviembre</option>
							<option value="12" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq "12">selected</cfif>>12 - Diciembre</option>
						</select>
					</td>
				</tr>
				<!--- Linea No. 03 del Filtro --->
				<tr>
					<td width="15%" align="left">Ver Reporte</td>
					<td >
						<select name="REPORTE" size="1" tabindex="5" style="font-size:8pt;  font-family: Courier New;">
							<option value="1" <cfif isdefined("form.REPORTE") and len(form.REPORTE) and form.REPORTE eq "1">selected</cfif>>Encabezado</option>
							<option value="2" <cfif isdefined("form.REPORTE") and len(form.REPORTE) and form.REPORTE eq "2">selected</cfif>>Detalle</option>
						</select>
					</td>
					<td width="15%" align="left">Mes Final</td>
					<td>
						 <select name="MESCODF" size="1" tabindex="6" style="font-size:8pt;  font-family: Courier New;">
							<option value="12"   <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq "12">selected</cfif>>-- Todos --</option>
							<option value="1"  <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq "1">selected</cfif>>1 - Enero</option>
							<option value="2"  <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq "2">selected</cfif>>2 - Febrero</option>
							<option value="3"  <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq "3">selected</cfif>>3 - Marzo</option>
							<option value="4"  <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq "4">selected</cfif>>4 - Abril</option>
							<option value="5"  <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq "5">selected</cfif>>5 - Mayo</option>
							<option value="6"  <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq "6">selected</cfif>>6 - Junio</option>
							<option value="7"  <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq "7">selected</cfif>>7 - Julio</option>
							<option value="8"  <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq "8">selected</cfif>>8 - Agosto</option>
							<option value="9"  <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq "9">selected</cfif>>9 - Setiembre</option>
							<option value="10" <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq "10">selected</cfif>>10 - Octubre</option>
							<option value="11" <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq "11">selected</cfif>>11 - Noviembre</option>
							<option value="12" <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq "12">selected</cfif>>12 - Diciembre</option>
						</select>
					</td>				
				</tr>
				<!--- Linea No. 04 del Filtro --->
				<tr>
					<td width="15%" align="left">Fecha Inicial</td>
					<td > 
						<cfif isdefined("FECHAINI")>
							<cfset FECHA_I = #FECHAINI#>
						<cfelse>
							<cfset FECHA_I = "">
						</cfif>
						<cf_CJCcalendario tabindex="7" name="FECHAINI" form="form1"  value="#FECHA_I#">
					</td>
					<td width="15%" align="left">Fecha Final</td>
					<td > 
						<cfif isdefined("FECHAFIN")>
							<cfset FECHA_F = #FECHAFIN#>
						<cfelse>
							<cfset FECHA_F = "">
						</cfif>
						<cf_CJCcalendario tabindex="8" name="FECHAFIN" form="form1"  value="#FECHA_F#">
					</td>											
				</tr>
				<!--- Linea No. 05 del Filtro --->
				<tr>
					<td width="15%" align="left">Objeto de Gasto Inicial</td>
					<td > 
						<cfif not isdefined("CP7SUBI")>
							<cf_cjcConlis 	
								size		= "40"
								tabindex	= "9"
								name 		= "CP7SUBI"
								desc 		= "CP7DESI"
								id		= "CP7SUBI"
								cjcConlisT 	= "cjc_traeGasto"
								sizecodigo	= 4
								frame		= "frm_gastos"
							>																
						<cfelse>
							<cfif isdefined("CP7SUBI") and trim(CP7SUBI) EQ "">
								<cfset _CP7SUBI = -1>
							<cfelse>
								<cfset _CP7SUBI = CP7SUBI>
							</cfif>
							<cfquery name="rsQryGastoIni" datasource="#session.Fondos.dsn#">
								select CP7SUB as CP7SUBI, CP7DES as CP7DESI
								from CPM007
								where CP7SUB = <cfqueryparam cfsqltype="cf_sql_integer" value="#_CP7SUBI#">
							</cfquery>
							<cf_cjcConlis 	
								size		= "40"
								tabindex	= "9"
								name 		= "CP7SUBI"
								desc 		= "CP7DESI"
								id		= "CP7SUBI"
								cjcConlisT 	= "cjc_traeGasto"
								query		= "#rsQryGastoIni#"
								sizecodigo	= 4
								frame		= "frm_gastos"
							>							
						</cfif>
					</td>
					<td width="15%" align="left">Objeto de Gasto Final</td>
					<td >
						<cfif not isdefined("CP7SUBF")>
							<cf_cjcConlis 	
								size		= "40"
								tabindex	= "10"
								name 		= "CP7SUBF"
								desc 		= "CP7DESF"
								id		= "CP7SUBF"
								cjcConlisT 	= "cjc_traeGasto"
								sizecodigo	= 4
								frame		= "frm_gastos"
							>							
						<cfelse>
							<cfif isdefined("CP7SUBF") and trim(CP7SUBF) EQ "">
								<cfset _CP7SUBF = -1>
							<cfelse>
								<cfset _CP7SUBF = CP7SUBF>
							</cfif>
							<cfquery name="rsQryGastoFin" datasource="#session.Fondos.dsn#">
								select CP7SUB as CP7SUBF, CP7DES as CP7DESF
								from CPM007
								where CP7SUB = <cfqueryparam cfsqltype="cf_sql_integer" value="#_CP7SUBF#">
							</cfquery>
							<cf_cjcConlis 	
								size		= "40"
								tabindex	= "10"
								name 		= "CP7SUBF"
								desc 		= "CP7DESF"
								id		= "CP7SUBF"
								cjcConlisT 	= "cjc_traeGasto"
								query		= "#rsQryGastoFin#"
								sizecodigo	= 4
								frame		= "frm_gastos"
							>						
						</cfif> 
					</td>											
				</tr>
				<!--- Linea No. 06 del Filtro --->
				<tr>
					<td width="15%" align="left">Empleado</td>
					<td>
						<cfif not isdefined("EMPCED")>
							<cf_cjcConlis 	
								size		="30" 
								tabindex	="11" 
								name 		="EMPCED" 
								desc 		="NOMBRE" 
								id		="EMPCOD" 
								name2		="DEPCOD"
								desc2		="DEPDES"
								cjcConlisT 	="cjc_traeEmpTrans"
								frame		="frm_empleado"
							>
						<cfelse>
							<cfquery name="rsEmpleado" datasource="#session.Fondos.dsn#">
								select EMPCOD, EMPCED, EMPNOM +' '+EMPAPA+' '+EMPAMA  as NOMBRE 
								from PLM001 
								where EMPCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPCED#" >
							</cfquery>
							<cf_cjcConlis 	
								size		="30"  
								tabindex	="11"
								name 		="EMPCED" 
								desc 		="NOMBRE" 
								id		="EMPCOD" 
								name2		="DEPCOD"
								desc2		="DEPDES"										
								cjcConlisT 	="cjc_traeEmpTrans"
								query		="#rsEmpleado#"
								frame		="frm_empleado"
							>			
						</cfif>
					</td>
					<td width="15%" align="left">Proveedor</td>
					<td>
						<cfif not isdefined("PROCED")>
							<cf_cjcConlis 	
								tabindex	="12"
								size		="30"  
								name 		="PROCED" 
								desc 		="PRONOM" 
								id		="PROCOD" 
								onfocus		="validaProv()" 
								cjcConlisT 	="cjc_traeProv"
								frame		="frm_proveedor"
							>
						<cfelse>						
							<cfquery name="rsProveedor" datasource="#session.Fondos.dsn#">
								select PROCED,PROCOD,PRONOM 
								from CPM002  
								where PROCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PROCED#">
							</cfquery>
							<cf_cjcConlis 	
								size		="30"  
								tabindex	="12"
								name 		="PROCED" 
								desc 		="PRONOM" 
								id		="PROCOD" 
								onfocus		="validaProv()" 
								cjcConlisT 	="cjc_traeProv"
								query		="#rsProveedor#"
								frame		="frm_proveedor"
							>
						</cfif>
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
		<cfif isdefined("NCJM00COD") and len(NCJM00COD)>			
			param = param + "&NCJM00COD=<cfoutput>#NCJM00COD#</cfoutput>"
		</cfif>
		<cfif isdefined("NCJ01ID") and len(NCJ01ID)>			
			param = param + "&NCJ01ID=<cfoutput>#NCJ01ID#</cfoutput>"
		</cfif>
		<cfif isdefined("PERCOD") and len(PERCOD)>			
			param = param + "&PERCOD=<cfoutput>#PERCOD#</cfoutput>"
		</cfif>
		<cfif isdefined("MESCODI") and len(MESCODI)>			
			param = param + "&MESCODI=<cfoutput>#MESCODI#</cfoutput>"
		</cfif>
		<cfif isdefined("MESCODF") and len(MESCODF)>			
			param = param + "&MESCODF=<cfoutput>#MESCODF#</cfoutput>"
		</cfif>
		<cfif isdefined("REPORTE") and len(REPORTE)>			
			param = param + "&REPORTE=<cfoutput>#REPORTE#</cfoutput>"
		</cfif>
		<cfif isdefined("FECHAINI") and len(FECHAINI)>			
			param = param + "&FECHAINI=<cfoutput>#FECHAINI#</cfoutput>"			
		</cfif>
		<cfif isdefined("FECHAFIN") and len(FECHAFIN)>			
			param = param + "&FECHAFIN=<cfoutput>#FECHAFIN#</cfoutput>"
		</cfif>
		<cfif isdefined("CP7SUBI") and len(CP7SUBI)>			
			param = param + "&CP7SUBI=<cfoutput>#CP7SUBI#</cfoutput>"
		</cfif>
		<cfif isdefined("CP7SUBF") and len(CP7SUBF)>			
			param = param + "&CP7SUBF=<cfoutput>#CP7SUBF#</cfoutput>"
		</cfif>
		<cfif isdefined("EMPCED") and len(EMPCED)>			
			param = param + "&EMPCED=<cfoutput>#EMPCED#</cfoutput>"
		</cfif>
		<cfif isdefined("PROCED") and len(PROCED)>			
			param = param + "&PROCED=<cfoutput>#PROCED#</cfoutput>"
		</cfif>
		
		<!--- alert(param); --->
		
		PURL = "../operacion/cjc_sqlRDetalleTransFondo.cfm?btnFiltrar=1" + param;		
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
		document.location = '../operacion/cjc_DetalleTransFondo.cfm';
		window.parent.frm_reporte.location = '../operacion/cjc_sqlRDetalleTransFondo.cfm';
	}
	
	function Printit() {
		window.parent.frm_reporte.focus();
		window.parent.frm_reporte.print();
	}
	
	function validar() {
		if(document.form1.NCJM00COD.value == "") {
			alert("Digite el Código de Fondo");
			document.form1.NCJM00COD.focus();
			return false;
		}
				 
		if(document.form1.CP7SUBI.value != "" && document.form1.CP7SUBF.value == "") {
			alert("Digite el Objeto de Gasto Final");
			document.form1.CP7SUBF.focus();
			return false;
		}
		
		if(document.form1.CP7SUBI.value == "" && document.form1.CP7SUBF.value != "") {
			alert("Digite el Objeto de Gasto Inicial");
			document.form1.CP7SUBI.focus();
			return false;
		}
		
		if(document.form1.FECHAINI.value != "" && document.form1.FECHAFIN.value == "") {
			alert("Digite la Fecha Final");
			document.form1.FECHAFIN.focus();
			return false;
		}
		
		if(document.form1.FECHAINI.value == "" && document.form1.FECHAFIN.value != "") {
			alert("Digite la Fecha Inicial");
			document.form1.FECHAINI.focus();
			return false;
		}
		
		if(document.form1.MESCODI.value != "" && document.form1.MESCODF.value == "") {
			alert("Seleccione el Mes Final");
			document.form1.MESCODF.focus();
			return false;
		}
		
		if(document.form1.MESCODI.value == "" && document.form1.MESCODF.value != "") {
			alert("Seleccione el Mes Inicial");
			document.form1.MESCODI.focus();
			return false;
		}

		if(document.form1.MESCODI.value > document.form1.MESCODF.value) {
			alert("Rango de Meses Inválido");
			document.form1.MESCODI.focus();
			return false;
		}
		return true;
		
	}

</script> 

