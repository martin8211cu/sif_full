<cfif isdefined("url.modo") and len(trim(url.modo)) gt 0 >
	<cfset  form.modo = url.modo >
</cfif>
<cfif isdefined("url.CGM1IM") and len(trim(url.CGM1IM)) gt 0 >
	<cfset  form.CGM1IM = url.CGM1IM >
</cfif>
<cfif isdefined("url.CGC3TPOA") and len(trim(url.CGC3TPOA)) gt 0 >
	<cfset  form.CGC3TPOA = url.CGC3TPOA >
</cfif>

<!---********************************* --->
<!---** para entrar en modo cambio  ** --->
<!---********************************* --->
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo neq "ALTA">
	<cfquery datasource="#session.Conta.dsn#"  name="TraeSql" >	
		select CGM1IM,CGC3TPOA,CGC3SEG,
		case CGC3TPOA
		 when  1 then '1-Saldos acumulados'
		 when  2 then '2-Saldos del periodo'
		 when  3 then '3-Movimientos del mes'
		 when  4 then '4-Movimientos asiento del mes'
		 when  5 then '5-Movimientos asiento consecutivo del mes'
		 end as TIPO,		
		timestamp
		from  CGC003
		where CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.CGM1IM#" >
		and   CGC3TPOA = <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.CGC3TPOA#">
	</cfquery>
	<cfset ts = "">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#TraeSql.timestamp#" returnvariable="ts">
	</cfinvoke>
	
	<cfquery name="RSCuenta" datasource="#session.Conta.dsn#">
		select CGM1IM,CTADES
		from CGM001
		where CGM1IM = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CGM1IM#">
		and CGM1CD  is null 
	</cfquery>
	<cfset segmentos = TraeSql.CGC3SEG>
	<cfset segmentos  = "'" & replace(segmentos,",","','","All") & "'"> 
	<cfquery name="rsSucursal" datasource="#session.Conta.dsn#">
		select A.CGE5COD  as CGE5COD, CGE5DES as CGE5DES ,
		case when  A.CGE5COD   in (#PreserveSingleQuotes(segmentos)#) then 1 else 0 end  as chk
		from CGE005 A, CGE000 B
		WHERE A.CGE1COD = B.CGE1COD
	</cfquery>

<cfelse>
	<cfquery name="rsSucursal" datasource="#session.Conta.dsn#">
		select A.CGE5COD  as CGE5COD, CGE5DES as CGE5DES, 1 as chk
		from CGE005 A, CGE000 B
		WHERE A.CGE1COD = B.CGE1COD
	</cfquery>
</cfif>


<SCRIPT LANGUAGE='Javascript'  src="../js/utilies.js"></SCRIPT>
<cfoutput>
<form name="form1" method="post" action="cmn_RepCuentasFijasSQL.cfm" onSubmit="">
	<table width="100%" border="0">
  		<tr>
    		<td>
				<!--- ---------------------------------------- --->
				<!--- --     INICIA PINTADO DE LA PANTALLA     --->
				<!--- ---------------------------------------- --->
			  	<table width="100%" border="0">
			  		<tr>
						<td align="left" colspan="2">
						   <cfif modo eq 'ALTA' >
								<input type="submit" name="Alta"    value="Agregar" tabindex="10" onClick="javascript:habilitarValidacion();">
   						        <input type="submit" name="Generar" value="Generar"  tabindex="10" onClick="if ( confirm('Desea generar?') ){deshabilitarValidacion(); return true;} return false;">

						   <cfelse>
								<input type="submit" name="Cambio" 	value="Modificar" tabindex="10" onClick="javascript:habilitarValidacion();">
								<input type="submit" name="Baja"    value="Eliminar"  tabindex="10" onClick="if ( confirm('Desea eliminar el registro?') ){deshabilitarValidacion(); return true;} return false;">
								<input type="submit" name="Nuevo" 	value="Nuevo" 	  tabindex="10" onClick="javascript:deshabilitarValidacion();">
						   </cfif>
						</td>
					</tr>
					<!--- ********************************************************************************* --->
					<tr>
						<td  width="20%" align="left" nowrap><strong>Cuenta Mayor:</strong>&nbsp;</td>
						<td  width="80%" nowrap>
							<cfif modo eq 'ALTA' >
									<cf_cjcConlis 	
										size		="4"  
										tabindex    ="1"
										name 		="CGM1IM" 
										desc 		="CTADES" 
										cjcConlisT 	="cmn_traeCuentaMayor"
									>
							<cfelse>
								#RSCuenta.CGM1IM#-#RSCuenta.CTADES#
							</cfif>	
						</td>
					</tr>
					<!--- ********************************************************************************* --->
					<tr>
						<td align="left" nowrap><strong>Tipo  de archivo:</strong>&nbsp;</td>
					  	<td nowrap>
						<cfif modo eq 'ALTA' >
							<select name="CGC3TPOA"  id="CGC3TPOA" tabindex="5">
								<option value="1" >Saldos acumulados</option>
								<option value="2" >Saldos del periodo</option>
								<option value="3" >Movimientos del mes</option>
								<option value="4" >Movimientos asiento del mes</option>
								<option value="5" >Movimientos asiento consecutivo del mes</option>
							</select>
						<cfelse>
							#TraeSql.TIPO#
						</cfif>
					  	</td>
					</tr>
					<!---********************************************************************************* --->
					<tr>
						<td align="left" nowrap><strong>Fecha y Hora de Ejecucion:</strong>&nbsp;</td>
					  	<td nowrap>
							<table cellpadding="0" cellspacing="0">
						 	<tr>
								<td>
									<cf_CJCcalendario tabindex="1" 
											name="Fechaejec" 
											form="form1"  
											value="#dateformat(Now(),"dd/mm/yyyy")#">
								</td>							
								<td width="20">&nbsp;</td>
								<td>
									<select name="hora">
									<cfloop from="1" to="12" step="1" index="valor">
										<cfoutput>
										<option value="<cfif valor lt 10>0</cfif>#valor#" <cfif valor eq 8>selected</cfif>><cfif valor lt 10>0</cfif>#valor#</option>
										</cfoutput>
									</cfloop>
									</select>
								</td>
								<td>&nbsp;</td>
								<td>
									<select name="min">
									<cfloop from="0" to="59" step="1" index="valor">
										<cfoutput>
										<option value="<cfif valor lt 10>0</cfif>#valor#"><cfif valor lt 10>0</cfif>#valor#</option>
										</cfoutput>
									</cfloop>									
									</select>
								</td>
								<td>&nbsp;</td>
								<td>
									<select name="tiempo">
									<option value="AM">AM</option>
									<option value="PM" selected>PM</option>									
									</select>
								</td>																
							</tr>
							</table>
					  	</td>
					</tr>
					<!---********************************************************************************* --->										
					<tr>
						<td align="center" colspan="2" nowrap bgcolor="##CCCCCC"><strong>Segmentos</strong></td>
					</tr>
					<!---********************************************************************************* --->
				</table>
				<A HREF="javascript:checkALL()" style="color: ##000000; text-decoration: none; "><strong>Seleccionar todos</strong></A> 
				- 
				<A HREF="javascript:UncheckALL()" style="color: ##000000; text-decoration: none; "><strong>Limpiar todos</strong></A>
				
                <table width="100%" border="0">				
					<cfoutput>
					<cfset ubica = 0>
					<cfloop query="rsSucursal">
						<cfif ubica EQ 0>	
							<tr>
							<td nowrap><input tabindex="6" type="checkbox"  <cfif rsSucursal.chk EQ 1>checked</cfif>   value="#rsSucursal.CGE5COD#" name="CGE5COD"></td>					
							<td align="left" nowrap><strong>#rsSucursal.CGE5COD#-#rsSucursal.CGE5DES#</strong>&nbsp;</td>
							<cfset ubica = 1>
						<cfelse>
							<td nowrap><input tabindex="6" type="checkbox"   <cfif rsSucursal.chk EQ 1>checked</cfif> value="#rsSucursal.CGE5COD#" name="CGE5COD"></td>					
						    <td align="left" nowrap><strong>#rsSucursal.CGE5COD#-#rsSucursal.CGE5DES#</strong>&nbsp;</td>
							</tr>
							<cfset ubica = 0>
						</cfif>
					</cfloop>
					<cfif ubica EQ 1>
						</tr>
					</cfif>
					<cfif rsSucursal.recordcount gt 0>	
					<INPUT type="hidden" style="visibility:hidden" name="CANTIDAD" value="#rsSucursal.recordcount#">
					<cfelse>
					<INPUT type="hidden" style="visibility:hidden" name="CANTIDAD" value="0">
					</cfif>
					</cfoutput>	
					<!---********************************************************************************* --->
					<input type="hidden" name="ID_REPORTE" id="ID_REPORTE" value="3" tabindex="8">
					<INPUT type="hidden" name="NivelTotal" id="NivelTotal" value="" tabindex="8">
					<input type="hidden" name="NivelDetalle" id="NivelDetalle" value="3" tabindex="8">
					<INPUT type="hidden" style="visibility:hidden" name="ORIGEN" value="R" tabindex="8">
					<INPUT type="hidden" style="visibility:hidden" name="REP" value="L" tabindex="8">
					<input type="hidden" name="MODO" id="MODO" value="#modo#" tabindex="8">
				    <input 	name="timestamp" type="hidden" id="timestamp" value="<cfif modo NEQ "ALTA" ><cfoutput>#ts#</cfoutput></cfif>">		
					<input type="hidden" name="LIST_SEGMENTO" id="LIST_SEGMENTO" value="-" tabindex="8">

					<cfif modo neq 'ALTA' >
						<input type="hidden" name="CGC3TPOA" 		id="CGC3TPOA" value="#TraeSql.CGC3TPOA#" tabindex="8">
						<input type="hidden" name="CGM1IM"   		id="CGM1IM"   value="#TraeSql.CGM1IM#" tabindex="8">
					</cfif>
				</table>
				
				<!--- -------------------------------------- --->
				<!--- --     FIN PINTADO DE LA PANTALLA      --->
				<!--- -------------------------------------- --->
    		</td>
  		</tr>
	</table>
</form>
</cfoutput>
<!--- ********************** --->
<!--- ** AREA DE SCRIPTS  ** --->
<!--- ********************** --->
<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objform1 = new qForm("form1");
	objform1.CGM1IM.required = true;
	objform1.CGM1IM.description="debe selecionar una cuenta mayor";	 	
	objform1.LIST_SEGMENTO.required = true;
	objform1.LIST_SEGMENTO.description="debe selecionar al menos un segmento";	 
	_addValidator("isSEGMENTO",marcados);
	objform1.LIST_SEGMENTO.validateSEGMENTO();	
 
  // ****************************************************************************************************
	function deshabilitarValidacion(){
		objform1.CGM1IM.required = false;
		objform1.LIST_SEGMENTO.required = false;
	}
	function habilitarValidacion(){
		objform1.CGM1IM.required = true;
		objform1.LIST_SEGMENTO.required = true;
	}
  // ****************************************************************************************************
  	function marcados(){
		document.form1.LIST_SEGMENTO.value = "";
		var CANTIDAD 	= new Number(document.form1.CANTIDAD.value);
		for(var i=0; i<CANTIDAD; i++) {
			if(eval("document.form1.CGE5COD["+i+"].checked")){
				document.form1.LIST_SEGMENTO.value = document.form1.LIST_SEGMENTO.value + eval("document.form1.CGE5COD["+i+"].value") + ",";
			}		
		}
		valor = document.form1.LIST_SEGMENTO.value;
		if (valor.length > 0){
			valor = valor.substring(0,valor.length -1);
			document.form1.LIST_SEGMENTO.value = valor;
		}	
		
	}
  // ****************************************************************************************************
  	function cargarsegmentos(){
		var CGC3SEG     = document.form1.CGC3SEG.value;
		var CANTIDAD 	= new Number(document.form1.CANTIDAD.value);
		for(var i=0; i<CANTIDAD; i++) {
			if(eval("document.form1.CGE5COD["+i+"].checked")){
				document.form1.LIST_SEGMENTO.value = document.form1.LIST_SEGMENTO.value + eval("document.form1.CGE5COD["+i+"].value") + ",";
			}		
		}
		valor = document.form1.LIST_SEGMENTO.value;
		if (valor.length > 0){
			valor = valor.substring(0,valor.length -1);
			document.form1.LIST_SEGMENTO.value = valor;
		}	
		
	}
  // ****************************************************************************************************
   function checkALL(){
		var CANTIDAD 	= new Number(document.form1.CANTIDAD.value);
		for(var i=0; i<CANTIDAD; i++) {
			eval("document.form1.CGE5COD["+i+"].checked=true")
		}
	}
  // ****************************************************************************************************
   function UncheckALL(){
		var CANTIDAD 	= new Number(document.form1.CANTIDAD.value);
		for(var i=0; i<CANTIDAD; i++) {
			eval("document.form1.CGE5COD["+i+"].checked=false")
		}
	}
  // ****************************************************************************************************
</script> 
