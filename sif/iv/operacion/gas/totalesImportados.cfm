<html>
<head>
<title>MTotales Importados de Cuentas por Estaci&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<style type="text/css">
<!--
.style1 {
	font-size: 18px;
	font-weight: bold;
}
.style5 {font-size: 14px; font-weight: bold; }
-->
</style>
</head>
<body>

<cfoutput>
	<cfif isdefined("url.ID_salprod") and not isdefined('form.ID_salprod')>
		<cfset form.ID_salprod = url.ID_salprod>
	</cfif>		
	<cfset nombreProd = "">	
	<cfset listaCods = "">	
	<cfset LvarListaNon = -1>
	
	<cfquery name="rsTotCuentas" datasource="#session.DSN#">
		Select a.ID_salprod
			, b.TDCid
			, b.TDCtipo
			, <cf_dbfunction name="to_sdateDMY"	args="SPfecha"> as SPfecha
			, TDCtotal
			, c.CFformato
			, c.CFdescripcion
			, a.Ocodigo
			, d.Oficodigo			
			, d.Odescripcion
			, a.SPestado
		
		from ESalidaProd a
			inner join TotDebitosCreditos b
				on b.Ecodigo=a.Ecodigo
					and b.ID_salprod=a.ID_salprod
		
			inner join CFinanciera c
				on c.Ecodigo=b.Ecodigo	
					and c.CFformato=b.TDCformato
			
			inner join Oficinas d
				on d.Ecodigo=c.Ecodigo
					and d.Ocodigo=a.Ocodigo
		
		where a.Ecodigo= #session.Ecodigo# 
		  and a.ID_salprod=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_salprod#">
	</cfquery>	
	
	<cfset totSal = 0>
	<cfset estado = 0>	
	
	<cfif isdefined('rsTotCuentas') and rsTotCuentas.recordCount GT 0>	
		<cfset listaCods = ValueList(rsTotCuentas.TDCid)>			
		
		<cfquery name="rsEstadoImp" dbtype="query" maxrows="1">
			select SPestado
			from rsTotCuentas
		</cfquery>
		
		<cfif isdefined('rsEstadoImp') and rsEstadoImp.recordCount GT 0>
			<cfset estado = rsEstadoImp.SPestado>
		</cfif>
		
		<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js">//</script>
		<form style="margin:0;" name="frame_Vend" method="post" action="totalesImportados.cfm" onSubmit="javascript: return formatea();">
			<input type="hidden" name="ID_salprod" value="<cfif isdefined('form.ID_salprod') and form.ID_salprod NEQ ''>#form.ID_salprod#</cfif>">		
			<input type="hidden" name="listaCods" value="<cfif isdefined('listaCods') and listaCods NEQ ''>#listaCods#</cfif>">
			
		  <table width="100%" cellpadding="0" cellspacing="0" border="0">  
			<tr>
			  <td colspan="6" align="center">&nbsp;</td>
			</tr>		
			<tr>
			  <td colspan="6" align="center">&nbsp;</td>
			</tr>		
			<tr>
			  <td colspan="6" align="center"><span class="style1">Montos Totales de Cuentas Contables </span></td>
			</tr>	
			<tr>
			  <td colspan="6" align="center">&nbsp;</td>
			</tr>		
			<cfif isdefined('rsTotCuentas') and rsTotCuentas.recordCount GT 0>
				<tr>
				  <td colspan="6" align="center"><span class="style5">Estaci&oacute;n: <cfoutput>
					  #rsTotCuentas.Oficodigo#-#rsTotCuentas.Odescripcion#
					</cfoutput>
				  </span></td>
				</tr>				
				<tr>
				  <td colspan="6" align="center"><span class="style5">Fecha:
					  <cfoutput>
					    #rsTotCuentas.SPfecha#			        </cfoutput>
				  </span></td>
				</tr>
			</cfif>
			<tr>
			  <td colspan="6" align="center">&nbsp;</td>
			</tr>		
			<tr>
			  <td colspan="6" align="center"><hr></td>
			</tr>				  
			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>		
			<tr class="areaFiltro">
			  <td width="10%" align="center">&nbsp;</td>
			  <td width="54%" nowrap="nowrap"><strong>Cuenta Contable </strong></td>
			  <td width="2%">&nbsp;</td>
			  <td width="25%" align="right" nowrap="nowrap"><strong>Monto  </strong></td>
			  <td width="9%" align="center"><strong>Tipo</strong></td>
			  <td width="9%" align="center">&nbsp;</td>
			</tr>
			<tr>
			  <td colspan="6" align="center">&nbsp;</td>
			</tr>			
			<cfif isdefined('rsTotCuentas') and rsTotCuentas.recordCount GT 0>
				<cfloop query="rsTotCuentas">
					<cfset LvarListaNon = (CurrentRow MOD 2)>	
					<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onMouseOver="this.className='listaParSel';" onMouseOut="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
					  <td align="right" nowrap="nowrap">(#CFformato#)&nbsp;</td>
					  <td nowrap="nowrap">#CFdescripcion#</td>
					  <td>&nbsp;</td>
					  <td align="right"><input 
								type="text" 
								tabindex="-1"
								name="cant_#TDCid#" 
								size="25" 
								maxlength="25" 
								style="text-align: right;" 
								onBlur="javascript:fm(this,2);"  
								onFocus="javascript:this.value=qf(this); this.select();"  
								onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}calcTotal();}"
								value="#LSCurrencyFormat(TDCtotal, 'none')#"></td>
					  <td align="center"><label>
					    <select name="TDCtipo_#TDCid#">
							<option value="D" <cfif rsTotCuentas.TDCtipo EQ 'D'> selected="selected"</cfif>>D&eacute;bito</option>	
							<option value="C" <cfif rsTotCuentas.TDCtipo EQ 'C'> selected="selected"</cfif>>C&eacute;dito</option>								
				      	</select>
					  </label></td>
					  <td align="center">&nbsp;</td>
					</tr>
				</cfloop>
			</cfif>
			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>			
			<tr>
			  <td>&nbsp;</td>
			  <td align="right"><strong>Total</strong></td>
			  <td>&nbsp;</td>
			  <td align="right"><strong><input 
						type="text" 
						class="cajasinbordeb"
						readonly="true" tabindex="-1"
						name="total" 
						size="25" 
						maxlength="25" 
						style="text-align: right;" 
						onBlur="javascript:fm(this,2);"  
						onFocus="javascript:this.value=qf(this); this.select();"  
						onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
						value=""></strong></td>
			  <td align="center">&nbsp;</td>
			  <td align="center">&nbsp;</td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>						
			<tr>
			  <td colspan="6" align="center">
			  	<cfif estado NEQ 10>
					<input type="submit" name="btnGuardar" value="Guardar y Cerrar">
				<cfelse>
					<input type="button" onClick="javascript: cerrar();" name="Cerrar" value="Cerrar">
				</cfif>			  </td>
			</tr>		
		  </table>
		</form>	
		
	<cfelse>
		<table width="100%" border="0">
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td align="center"><strong>---		No existen datos de totales de cuentas para esta estaciÃ³n en este dÃ­a		---</strong></td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>		  		  
		  <tr>
			<td>&nbsp;</td>
		  </tr>		  		  
		  <tr>
			<td align="center">
			    <input type="button" onClick="javascript: cerrar();" name="Cerrar" value="Cerrar">
			</td>
		  </tr>		  
		</table>
	</cfif>

	<cfif isdefined('form.btnGuardar') and isdefined('rsTotCuentas') and rsTotCuentas.recordCount GT 0>
		<!--- Actualizando los datos de las ventas por vendedor --->
		<cfif isdefined("rsTotCuentas") and rsTotCuentas.recordCount GT 0>
			<cfloop query="rsTotCuentas">
				<cfset valor = evaluate("form.cant_#rsTotCuentas.TDCid#")>				
				<cfset tipo = evaluate("form.TDCtipo_#rsTotCuentas.TDCid#")>								
				
 				<cfquery datasource="#session.DSN#">
					update TotDebitosCreditos set
						TDCtotal=<cfqueryparam cfsqltype="cf_sql_float" value="#valor#">
						, TDCtipo=<cfqueryparam cfsqltype="cf_sql_char" value="#tipo#">
					where TDCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTotCuentas.TDCid#">						
				</cfquery>						
			</cfloop>			
		</cfif>
	</cfif>
</cfoutput>

</body>
</html>

<script language="javascript" type="text/javascript">
	function cerrar(){
		<cfif estado NEQ 10>
			window.opener.document.form_fSalidas.btnConsultar.value = 'btnConsultar';
			window.opener.document.form_fSalidas.submit();		
		</cfif>
		window.close();
	}
	
	function formatea(){
		var objts = "<cfoutput>#listaCods#</cfoutput>";
		
		if (objts != ''){
			var arrObjts = objts.split(",");
			
			for (var i=0; i < arrObjts.length; i++){
				if(arrObjts[i] != ''){
					eval("document.frame_Vend.cant_" + arrObjts[i] + ".value=qf(document.frame_Vend.cant_" + arrObjts[i] + ")");
				}
			}	
		}	
	}
	
	function calcTotal(){
		var sumaObjst = 0;
		var totSalVend = 0;				
		var objts = "<cfoutput>#listaCods#</cfoutput>";
		
		if (objts != ''){
			var arrObjts = objts.split(",");
			for (var i=0; i < arrObjts.length; i++){
				if(arrObjts[i] != ''){
					eval("document.frame_Vend.cant_" + arrObjts[i] + ".value=qf(document.frame_Vend.cant_" + arrObjts[i] + ")");
					sumaObjst += eval("new Number(document.frame_Vend.cant_" + arrObjts[i] + ".value);");
				}
			}
			totSalVend = new Number(sumaObjst);			
		}
			
		document.frame_Vend.total.value = totSalVend;
		document.frame_Vend.total.value = fm(document.frame_Vend.total.value,2);
	}
	calcTotal();
	<cfif isdefined('form.btnGuardar')>
		cerrar();	
	</cfif>	
</script>
