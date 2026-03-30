<!--- 
Archivo:  cjc_formRConsultaUsuarios.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    18 y 19 Octubre 2006.              
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

<form action="cjc_excel.cfm?name=ConsultaUsuarios" method="post" name="bjex"></form>

<cfinclude template="encabezadofondos.cfm">

<form name="form1" action="cjc_RConsultaUsuarios.cfm" method="post">
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
									<a id ="ACEPTAR" href="javascript:ACEPTAR();" onMouseOver="overlib('Generar reporte',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Consultar'; return true;" onMouseOut="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Consultar&nbsp;</span></a>
									<a id ="LIMPIAR" href="javascript:LIMPIAR();" onMouseOver="overlib('Limpiar filtros',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onMouseOut="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Limpiar&nbsp;</span></a>
									<a id ="Printit" href="javascript:Printit();" onMouseOver="overlib('Imprimir',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Imprimir'; return true;" onMouseOut="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Imprimir&nbsp;</span></a>
									<a id ="EXCEL"   href="javascript:SALVAEXCEL();" style="visibility:hidden" onMouseOver="overlib('Exportar Excel',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Exportar Excel'; return true;" onMouseOut="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Exportar&nbsp;</span></a>
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
				</tr>
				
				<tr>
					<td width="15%" align="left">Tipo de Usuario</td>
					<td > 
						<cfif not isdefined("form.CJM10TIP")>
							<cfset form.CJM10TIP = "0">
						</cfif>	
						<select name="CJM10TIP" size="1" tabindex="5" style="font-size:8pt;  font-family: Courier New;">
							<option value="0" <cfif isdefined("form.CJM10TIP") and len(form.CJM10TIP) and form.CJM10TIP eq 0>selected</cfif>>- Todos -</option>
							<option value="1" <cfif isdefined("form.CJM10TIP") and len(form.CJM10TIP) and form.CJM10TIP eq 1>selected</cfif>>AG - Autorizador de Gastos</option>
							<option value="2" <cfif isdefined("form.CJM10TIP") and len(form.CJM10TIP) and form.CJM10TIP eq 2>selected</cfif>>AL - Autorizador de Liquidaciones</option>
							<option value="3" <cfif isdefined("form.CJM10TIP") and len(form.CJM10TIP) and form.CJM10TIP eq 3>selected</cfif>>UC - Usuario de Caja</option>
							<option value="4" <cfif isdefined("form.CJM10TIP") and len(form.CJM10TIP) and form.CJM10TIP eq 4>selected</cfif>>UF - Usuario de Fondo</option>
							<option value="5" <cfif isdefined("form.CJM10TIP") and len(form.CJM10TIP) and form.CJM10TIP eq 5>selected</cfif>>CO - Usuario de Consulta</option>
						</select>
					</td>					
				</tr>
				
				<tr>
					<td width="15%" align="left">Estado del Usuario</td>
					<td >
						<cfif not isdefined("form.CJM10EST")>
							<cfset form.CJM10EST = "T">
						</cfif>	
						<select name="CJM10EST" size="1" tabindex="5" style="font-size:8pt;  font-family: Courier New;">
							<option value="T" <cfif isdefined("form.CJM10EST") and len(form.CJM10EST) and form.CJM10EST eq "T">selected</cfif>>- Ambos -</option>
							<option value="A" <cfif isdefined("form.CJM10EST") and len(form.CJM10EST) and form.CJM10EST eq "A">selected</cfif>>A - Activo</option>
							<option value="I" <cfif isdefined("form.CJM10EST") and len(form.CJM10EST) and form.CJM10EST eq "I">selected</cfif>>I - Inactivo</option>
						</select>
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
		<cfif isdefined("CJM10TIP") and len(CJM10TIP)>			
			param = param + "&CJM10TIP=<cfoutput>#CJM10TIP#</cfoutput>"			
		</cfif>
		<cfif isdefined("CJM10EST") and len(CJM10EST)>			
			param = param + "&CJM10EST=<cfoutput>#CJM10EST#</cfoutput>"
		</cfif>
		
		PURL = "../operacion/cjc_sqlRConsultaUsuarios.cfm?btnFiltrar=1" + param;		
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
		document.location = '../operacion/cjc_ConsultaUsuarios.cfm';
		window.parent.frm_reporte.location = '../operacion/cjc_sqlRConsultaUsuarios.cfm';
		document.form1.NCJM00COD.focus();
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

		return true;
	}
</script> 
