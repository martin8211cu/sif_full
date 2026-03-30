
<cfif isdefined("url.RCNid") and Len(Trim(url.RCNid))>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Proceso_de_Pase_de_Presupuesto"
	Default="Proceso de Pase de Presupuesto"
	XmlFile="/rh/generales.xml"
	returnvariable="Proceso_de_Pase_de_Presupuesto"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LBDescripcion"
	Default="Descripcion"
	XmlFile="/rh/generales.xml"
	returnvariable="LBDescripcion"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LBEgreso"
	Default="Egreso"
	XmlFile="/rh/generales.xml"
	returnvariable="LBEgreso"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LBMonto"
	Default="Monto"
	XmlFile="/rh/generales.xml"
	returnvariable="LBMonto"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTContinuar"
	Default="Continuar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTContinuar"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LBArticulo"
	Default="Articulo"
	XmlFile="/rh/generales.xml"
	returnvariable="LBArticulo"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LBCambiarA"
	Default="Cambiar A"
	XmlFile="/rh/generales.xml"
	returnvariable="LBCambiarA"/>
	<style type="text/css">
  	body {
    font-family: Helvetica, Geneva, Arial,
         SunSans-Regular, sans-serif;
        font-size: 9;
    	}
 	 h1 {font-size:11px;
	   font-family: Helvetica, Geneva, Arial,
	   SunSans-Regular, sans-serif;
	   text-align:left; }
	   
	.LBtitulo0{font-size:12px;
	   font-family: Helvetica, Geneva, Arial,
	   SunSans-Regular, sans-serif;
	   font-weight:bold;
	   background-color: E6E6E6;
	    }
	    
	.LBtitulo{font-size:11px;
	   font-family: Helvetica, Geneva, Arial,
	   SunSans-Regular, sans-serif;
	   font-weight:bold;
	   background-color: E6E6E6;
	    }
	.LBtitulo2{font-size:11px;
	   font-family: Helvetica, Geneva, Arial,
	   SunSans-Regular, sans-serif;
	   font-weight:bold;
	    }
	.FontNum{font-size:12px;
	   font-family: Helvetica, Geneva, Arial,
	   SunSans-Regular, sans-serif;
	   }
    table {
	   font-size:10px;
	   font-family: Helvetica, Geneva, Arial,
	   SunSans-Regular, sans-serif;
	   text-align:left;}
	input {
	   font-size:10px;
	   font-family: Helvetica, Geneva, Arial,
	   SunSans-Regular, sans-serif;
	   text-align:left;}
	select {
	   font-size:10px;
	   font-family: Helvetica, Geneva, Arial,
	   SunSans-Regular, sans-serif;
	   text-align:left;}
	
  </style>
	
  	<!--- número constante --->
	<cfset num_interfase = 921>
	
	<cfif not isdefined("BTNRegresar")> <!--- si se devuelve de la pantalla de revision para que mantenga los valores que tenia--->
			<cfinclude template="InterfazPresupuestoBNV_datos.cfm">
	<cfelse>
		<cfquery datasource="#session.DSN#" name="rsSalarioBase">
	 		select sum(SEsalariobruto) as monto from HSalarioEmpleado where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
		</cfquery>
		<cfquery  datasource="#session.DSN#" name="rsInExcl">
			select coalesce(sum(a.ICmontores),0) as monto
			from hIncidenciascalculo a 
			inner join CIncidentes b
			on a.CIid= b.CIid
			and b.CInocargas = 1 
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
		</cfquery>
		
		<cfquery  datasource="#session.DSN#" name="rsSL">
			Select 
				   (select sum(a.SErenta) from hSalarioEmpleado a where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">) as Total_Renta
				,(select sum(a.CCvalorEmp)
										from hCargasCalculo a 
										inner join DCargas b
										on a.DClinea = b.DClinea
										where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
										and b.DClinea = 15 --Asevital
								)as Total_Asevital
				,(select sum(a.CCvalorEmp)
										from hCargasCalculo a 
										inner join DCargas b
										on a.DClinea = b.DClinea
										where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
										and b.DClinea = 3 --BP CCSS 1%
								) as Total_CCSS1 
				, (select sum(a.CCvalorEmp)
										from hCargasCalculo a 
										inner join DCargas b
										on a.DClinea = b.DClinea
										where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
										and b.DClinea = 1 --BP CCSS 8%
								)as Total_CCSS8
				, 
									(select sum(SEliquido)- <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInExcl.monto#"> from hSalarioEmpleado 
									where RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">)as Total_liquido
								
			from Dual					
		</cfquery>	
	</cfif>

	<cfquery datasource="sifinterfaces" name="rsDatos">
		select * from PRE_INTERFAZ_PRESUPUESTO order by ORDEN
	</cfquery>
		
	<cf_web_portlet_start titulo="#Proceso_de_Pase_de_Presupuesto#" >
	<br>
	<form name="form1" method="post" action="InterfazPresupuestoBNV_SQL.cfm" onsubmit="return validar();">
	<cfoutput>	
	
	<input type="hidden" name="RCNid" value="#url.RCNid#">
	
	<!---<table border=1 cellpadding="2" cellspacing="0">
		<tr class="LBtitulo"><td colspan="5">Montos Totales</td></tr>
		<tr><td>
			<table border=0 cellpadding="0" cellspacing="0">
				<tr class="LBtitulo2">
					<td>&nbsp;</td><td style="width:70">Salario</td>
					<td>&nbsp;</td><td style="width:70">CCSS 8%</td>
					<td>&nbsp;</td><td style="width:70">CCSS 1%</td>
					<td>&nbsp;</td><td style="width:70">Asevital</td>
					<td>&nbsp;</td><td style="width:70">Renta</td>
					<td>&nbsp;</td><td style="width:70">L&iacute;quido</td>
					<td>&nbsp;</td><td nowrap>Incidencias Sin Cargas</td>
					<td>&nbsp;</td><td nowrap><label onClick="javascript: Func_Articulos_BNV()">!</label></td>
				</tr><tr>
					<td>&nbsp;</td><td style="width:70">#LSNumberFormat(rsSalarioBase.monto,'9,999.99')#</td>
					<td>&nbsp;</td><td style="width:70">#LSNumberFormat(rsSL.Total_CCSS8,'9,999.99')#</td>
					<td>&nbsp;</td><td style="width:70">#LSNumberFormat(rsSL.Total_CCSS1,'9,999.99')#</td>
					<td>&nbsp;</td><td style="width:70">#LSNumberFormat(rsSL.Total_Asevital,'9,999.99')#</td>
					<td>&nbsp;</td><td style="width:70">#LSNumberFormat(rsSL.Total_Renta,'9,999.99')#</td>
					<td>&nbsp;</td><td style="width:70">#LSNumberFormat(rsSL.Total_liquido,'9,999.99')#</td>
					<td>&nbsp;</td><td align="center">#LSNumberFormat(rsInExcl.monto,'9,999.99')#</td>
					<td>&nbsp;</td><td nowrap>?</td>
				</tr>
			</table>
		</td></tr>
	</table>
	<br><br>--->
	<table width="100%" height="100" cellpadding="0" cellspacing="0" border="0">
	
	<tr class="LBtitulo0"><td height="30">Verificación de los datos de envío a presupuesto</td></tr>
	
	<tr class="LBtitulo2"><td valign='midlle'>
	 
		<table width="80%" cellpadding="0" cellspacing="0">
		<tr> <td><strong>Oficina</strong>
		 	<input type="text" name="oficina" value="07"  maxlength="2" style="width:50"></td>
		 	<td><strong>C&oacute;digo de Planificaci&oacute;n </strong>
		 	<input type="text" name="cod_plan" value="050701"  maxlength="6" style="width:50"></td>
		 	<td> <input type="checkbox" name="agrupar" value="0"> <strong>Agrupar</strong></td>
			<td><input type="button" name="MantenimientoArticulos" value="Articulos" onClick="javascript: Func_Articulos_BNV()" style="width:90"></td>
			<!--- <td><input  type="button" name="MantenimientoHomologacion" value="Homologacion" onClick="javascript: alert('pendiente')" style="width:90;"></td> --->
		 	</tr>
		</table>
	 
	 <td></tr>
	
	<tr><td valign='midlle'>
		<table border=0  cellpadding="0" cellspacing="0"><!--- align="center" --->
		<tr><td> 
			
			<table border=0 align="center" cellpadding="2" cellspacing="0">
			
			<tr class="LBtitulo"><td>&nbsp;</td><td colspan="5">Montos Totales</td></tr>
			<tr><td  colspan="6">
				<table border="0">
					<tr class="LBtitulo2">
						<td>&nbsp;</td><td style="width:70">Salario</td>
						<td>&nbsp;</td><td style="width:70">CCSS 8%</td>
						<td>&nbsp;</td><td style="width:70">CCSS 1%</td>
						<td>&nbsp;</td><td style="width:70">Asevital</td>
						<td>&nbsp;</td><td style="width:70">Renta</td>
						<td>&nbsp;</td><td style="width:70">L&iacute;quido</td>
						<td>&nbsp;</td><td style="width:70" nowrap>Incidencias sin Cargas</td>
					</tr><tr class="LBtitulo2">
						<td>&nbsp;</td><td style="width:70">#LSNumberFormat(rsSalarioBase.monto,'9,999.99')#</td>
						<td>&nbsp;</td><td style="width:70">#LSNumberFormat(rsSL.Total_CCSS8,'9,999.99')#</td>
						<td>&nbsp;</td><td style="width:70">#LSNumberFormat(rsSL.Total_CCSS1,'9,999.99')#</td>
						<td>&nbsp;</td><td style="width:70">#LSNumberFormat(rsSL.Total_Asevital,'9,999.99')#</td>
						<td>&nbsp;</td><td style="width:70">#LSNumberFormat(rsSL.Total_Renta,'9,999.99')#</td>
						<td>&nbsp;</td><td style="width:70">#LSNumberFormat(rsSL.Total_liquido,'9,999.99')#</td>
						<td>&nbsp;</td><td style="width:70">#LSNumberFormat(rsInExcl.monto,'9,999.99')#</td>
						
					</tr>
				</table>
			</td></tr>
			
			<tr class="LBtitulo">
			<td> <input type="checkbox" name="chktodos" value="0" onclick="javascript: fn_check_todos(this)" checked> </td>
			<td style="width:150">#LBDescripcion#</td>
			<td style="width:70">#LBArticulo#</td>
			<td style="width:70">#LBEgreso#</td>
			<td style="width:70">#LBMonto#</td>		
			<td style="width:300">#LBCambiarA#</td></tr>
						
			<cfset tip="">
			<cfloop query="rsDatos">
				<cfset ID_PIP = rsDatos.ID_PIP>
				<cfif trim(tip) neq trim(rsDatos.tipo)>
					<cfset tip = trim(rsDatos.tipo)>
					<cfif tip EQ 'C'>
						<tr class="LBtitulo"><td colspan="6">Cargas</td></tr>
					</cfif>
					<cfif tip EQ 'D'>
						<tr class="LBtitulo"><td colspan="6">Deducciones</td></tr>
					</cfif>
				</cfif>
			<tr>
				<td  nowrap="nowrap"><input type="checkbox" name="incluir" id="incluir#ID_PIP#" value="#ID_PIP#" checked></td>
				<td  nowrap="nowrap">
					<!---#rsDatos.desc_articulo#--->
					<input type="text" name="descripcion#ID_PIP#" value="#rsDatos.desc_articulo#"  maxlength="250" style="width:300">
				</td>
				<td><input type="text" name="articulo#ID_PIP#" value="#rsDatos.cod_articulo#"  maxlength="4" style="width:50"></td>
				<td nowrap="nowrap">
				<input type="text" name="egreso#ID_PIP#" value="#rsDatos.cod_egreso#"  maxlength="6" style="width:50">
				</td>
				<td align="right">
					#LSNumberFormat(rsDatos.Monto,'9,999.99')#
				</td>
					
				<cfquery datasource="sifinterfaces" name="rsHomo">
					Select * from INTP_ARTICULOS_BNV a
					where COD_ARTICULO_REMP = (Select COD_ARTICULO_REMP from INTP_ARTICULOS_BNV 
												WHERE COD_ARTICULO = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.cod_articulo#">)
						
					
					<!---select * from HOMOLOGA_PRESUPUESTO_BNV 
					where tipo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#tip#">
					<cfif len(trim(rsDatos.id_referencia)) >
					and id_referencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.id_referencia#">
					</cfif>
					--->
				</cfquery>
					
				<cfif rsHomo.RecordCount gt 1>
						<td nowrap="nowrap">	
							<select name="cod_homologo#ID_PIP#" id="cod_homologo#ID_PIP#" style="width:400" onchange="javascript: CambiarArt(this.value,'#ID_PIP#')">
								<option value="">--- Seleccione ---</option>	
								<cfloop query="rsHomo">
									<option value="#trim(rsHomo.cod_articulo)#">Art.#rsHomo.cod_articulo# - Egre.#rsHomo.cod_egreso# - #rsHomo.Desc_articulo#</option>
								</cfloop>
							</select>
							<cfloop query="rsHomo">
							<input type="hidden" name="h_articulo#ID_PIP#_#trim(rsHomo.cod_articulo)#" id="h_articulo#ID_PIP#_#trim(rsHomo.cod_articulo)#" value="#rsHomo.cod_articulo#">
							<input type="hidden" name="h_egreso#ID_PIP#_#trim(rsHomo.cod_articulo)#" id="h_egreso#ID_PIP#_#trim(rsHomo.cod_articulo)#" value="#rsHomo.cod_egreso#">
							<input type="hidden" name="h_descrip#ID_PIP#_#trim(rsHomo.cod_articulo)#" id="h_descrip#ID_PIP#_#trim(rsHomo.cod_articulo)#" value="#rsHomo.Desc_articulo#">
							</cfloop>
						</td>
					</cfif>
				</tr>
			</cfloop>
			
		</table>
		</td></tr>
		<tr><td>
			<center>
				<input type="button" value="Cerrar" name="Cerrar" onClick="javascript: window.close();">
				<input type="button" value="Limpiar" name="Valores Iniciales" onClick="javascript: document.location.href='http://#session.sitio.host#/cfmx/rh/pago/operacion/InterfazPresupuestoBNV.cfm?RCNid=#url.RCNid#'">
				<input type="submit" value="#BTContinuar#" name="Continuar">
			</center>
		</td></tr>
		
		</table>
	</cfoutput>
	</form>
	<cf_web_portlet_end>
		
	<cfoutput>	
	<script language="javascript1.1" type="text/javascript">
		function CambiarArt(id,id_pip){
			if((id != '') && (id_pip != '')){
				var h_artObj = eval("document.form1.h_articulo"+ id_pip + "_" +id);
				var h_egreObj = eval("document.form1.h_egreso"+ id_pip + "_" +id);
				var h_descObj = eval("document.form1.h_descrip"+ id_pip + "_" +id);
				
				var artObj = eval("document.form1.articulo"+ id_pip);
				var egreObj = eval("document.form1.egreso"+ id_pip);
				var descObj = eval("document.form1.descripcion"+ id_pip);
				
				artObj.value = h_artObj.value;
				egreObj.value = h_egreObj.value;
				descObj.value = h_descObj.value;
			}
		}
		
		function validar(){
			
			var mens= "";
			
			
			if (document.form1.oficina.value == ""){
				mens= mens + "Codigo de Oficina /n";	
			}
			if (document.form1.cod_plan.value == ""){
				mens= mens + "Codigo de Plan /n";	
			}
			
			<!--- alert(eval("document.form1.descripcion#rsDatos.id_pip#"));--->
			<cfloop query="rsDatos">
				objI = document.form1.incluir;
				objA = eval("document.form1.articulo#rsDatos.id_pip#");
				objE = eval("document.form1.egreso#rsDatos.id_pip#");
				objD = eval("document.form1.descripcion#rsDatos.id_pip#");
				
				if ((objA.value == "") || (objE.value == "") || (objD.value == "")){
					mens= mens + "#rsDatos.desc_articulo# \n";	
				}
			</cfloop>
			
			if (mens !=""){
				alert('Verifique que se especifique el egreso  \n y el codigo de articulo para los siguienes articulos presupuestales:  \n \n' + mens);
				return (false);	
			}
		}
		
			function fn_check_todos(obj){
			<cfloop query="rsDatos">
				objI = eval("document.getElementById('incluir#rsDatos.id_pip#')");
				if(obj.checked){
					objI.checked = true;
				}
				else{ 
					objI.checked = false;
				}
			</cfloop>
			}
			
			function Func_Articulos_BNV() { 
				var width = 850;
				var height = 470;
				var top = (screen.height - height) / 2;
				var left = (screen.width - width) / 2;
				<cfoutput>
				
			    var winConta = window.open('BNVArticulos.cfm?RCNid=#url.RCNid#','RepAsiento','resizable=yes,scrollbars=1,top='+top+',left='+left+',width='+width+',height='+height);
				</cfoutput>
				nuevo.focus();
			}
		</script>
	
	
	</cfoutput>	

</cfif>
