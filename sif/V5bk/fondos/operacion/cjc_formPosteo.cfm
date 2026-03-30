	<cfset GASTOS = "0.00">
	<cfset FACTURAS = "0.00">
	<cfset VIATICOS = "0.00">
	<cfset AJUSTES = "0.00">
	<cfset PAGOS = "0.00">
	<cfset CHEQUE = "0.00">
	<cfset EFECTIVO = "0.00">
	<cfset TARJETAS = "0.00">
	<cfset VALES = "0.00">
	<cfset DIFERENCIA = "0.00">
<cfif form.CJX19REL  neq  0>	
	<cfquery name="rsTotales" datasource="#session.Fondos.dsn#">
		select  A.CJX19REL X, 
		  'FACTURAS' = isnull((select sum(CJX20MNT)
			  from CJX020 B
			  where A.CJX19REL = B.CJX19REL
			 AND CJX20TIP = 'F'
			 ),0.00),
		  'VIATICOS' = isnull((select sum(CJX20MNT)
			  from CJX020 B
			  where A.CJX19REL = B.CJX19REL
			 AND CJX20TIP = 'V'
			 ),0.00),
		  'AJUSTES' = isnull((select sum(CJX20MNT)
			  from CJX020 B
			  where A.CJX19REL = B.CJX19REL
			 AND CJX20TIP = 'A'
			 ),0.00),
		  'CHEQUES' = isnull((select sum(CJX23MON)
			  from CJX023 B
			  where A.CJX19REL = B.CJX19REL
			 AND CJX23TIP = 'C'
			 ),0.00),
		  'EFECTIVO' = isnull((select sum(CJX23MON)
			  from CJX023 B
			  where A.CJX19REL = B.CJX19REL
			 AND CJX23TIP = 'E'
			 ),0.00),
		  'TARJETA' = isnull((select sum(CJX23MON * (case when CJX23TTR = 'D' then -1 else 1 end))
			  from CJX023 B
			  where A.CJX19REL = B.CJX19REL
			 AND CJX23TIP = 'T'
			 ),0.00),
		  'VALE' = isnull((select sum(CJX23MON)
			  from CJX023 B
			  where A.CJX19REL = B.CJX19REL
			 AND CJX23TIP = 'V'
			 ),0.00),
		  'GASTOS' = isnull((select sum(CJX20MNT)
			  from CJX020 B
			  where A.CJX19REL = B.CJX19REL
			 ),0.00),
		  'PAGOS' = isnull((select sum(CJX23MON * (case when CJX23TTR = 'D' then -1 else 1 end))
			  from CJX023 B
			  where A.CJX19REL = B.CJX19REL
			 ),0.00)
		from CJX019 A
		where A.CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.CJX19REL#" >
		and A.CJX19EST = 'D'
	 </cfquery>
	<cfset GASTOS 	=  #LSNumberFormat(rsTotales.GASTOS,',9.00')#>
	<cfset FACTURAS =  #LSNumberFormat(rsTotales.FACTURAS,',9.00')#>
	<cfset VIATICOS =  #LSNumberFormat(rsTotales.VIATICOS,',9.00')#>
	<cfset AJUSTES 	=  #LSNumberFormat(rsTotales.AJUSTES,',9.00')#>
	<cfset PAGOS 	=  #LSNumberFormat(rsTotales.PAGOS,',9.00')#>
	<cfset CHEQUE 	=  #LSNumberFormat(rsTotales.CHEQUES,',9.00')#>
	<cfset EFECTIVO =  #LSNumberFormat(rsTotales.EFECTIVO,',9.00')#>
	<cfset TARJETAS =  #LSNumberFormat(rsTotales.TARJETA,',9.00')#>
	<cfset VALES 	=  #LSNumberFormat(rsTotales.VALE,',9.00')#>
	<cfset DIFERENCIA = #rsTotales.GASTOS#-#rsTotales.PAGOS#>
	<cfif DIFERENCIA  lt  0>
		<cfset DIFERENCIA = DIFERENCIA * -1>
	</cfif>
	<cfset DIFERENCIA = #LSNumberFormat(DIFERENCIA,',9.00')#>
</cfif>

<!---*********************** --->
<!---** AREA DE PINTADO    ** --->
<!---************************ --->
<cfquery name="rsRelacion" datasource="#session.Fondos.dsn#">
	select   CJX19REL,'REL-'+ convert(varchar,CJX19REL) CJX19DES from CJX019 
	WHERE  CJ01ID  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Caja#">
	AND CJX19EST = 'D'
</cfquery>
<!---********************************* --->
<!---** AREA DE IMPORTACION DE JS   ** --->
<!---********************************* --->
<SCRIPT LANGUAGE='Javascript'  src="../../js/utilies.js"></SCRIPT>

<table width="100%" border="0" >
	<tr>
		<td width="50%"  align="left" >
		<!---********************************************************************************* --->
		<!---** 					INICIA PINTADO DE LA PANTALLA 							** --->
		<!---********************************************************************************* --->
			<form action="cjc_SqlPosteo.cfm" method="post" name="form1" 
			onSubmit="javascript:finalizar();">
			<cfoutput>
					<table width="100%" border="0">
					  <!---********************************************************* --->
					  <tr>
						<td width="10%"><strong>SubFondo:</strong></td>
						<td width="10%">#session.Fondos.Caja#</td>
						<td width="10%"><strong>Usuario :</strong></td>
						<td width="80%">#session.usuario#</td>
					  </tr>
  					  <!---********************************************************* --->
					  <tr>
						<td><strong>Moneda :</strong></td>
						<td>#session.Fondos.MonedaDes#</td>
						<td><strong>Relaci&oacute;n :</strong></td>
						<td width="50%"><select name="CJX19REL" onChange="validaREL()">
                      		<option value="0">Seleccionar</option>
							<cfloop query="rsRelacion"> 
                        	<option value="#CJX19REL#" <cfif Form.CJX19REL EQ rsRelacion.CJX19REL>selected</cfif>>#CJX19DES#</option>
                      		</cfloop> </select>
						</td>
					  </tr>
					  <!---********************************************************* --->	
					 <!---  <tr>
						<td colspan="4"><hr></td>
					  </tr> --->
					  <!---********************************************************* --->	
					  <tr>
						<td colspan="3"><strong>Total Gastos :</strong></td>
						<td >
							<INPUT 	TYPE="textbox" 
							NAME="GASTOS" 
							VALUE="<cfoutput>#GASTOS#</cfoutput>" 
							SIZE="20" 
							DISABLED 
							MAXLENGTH="11" 
							ONBLUR="" 
							ONFOCUS="this.select(); " 
							ONKEYUP="" 
							style="border: medium none; text-align:left; size:auto;"
							>
						</td>											
					  </tr>
					  <!---********************************************************* --->	
					  <tr>
					    <td >&nbsp;</td>
						<td ><strong>Facturas </strong></td>
						<td >
							<INPUT 	TYPE="textbox" 
							NAME="FACTURAS" 
							VALUE="<cfoutput>#FACTURAS#</cfoutput>" 
							SIZE="20" 
							DISABLED 
							MAXLENGTH="11" 
							ONBLUR="" 
							ONFOCUS="this.select(); " 
							ONKEYUP="" 
							style="border: medium none; text-align:left; size:auto;"
							>
						</td>						
					  </tr>				  
					   <!---********************************************************* --->	
					  <tr>
					    <td >&nbsp;</td>
						<td ><strong>Viaticos </strong></td>
						<td >
							<INPUT 	TYPE="textbox" 
							NAME="VIATICOS" 
							VALUE="<cfoutput>#VIATICOS#</cfoutput>" 
							SIZE="20" 
							DISABLED 
							MAXLENGTH="11" 
							ONBLUR="" 
							ONFOCUS="this.select(); " 
							ONKEYUP="" 
							style="border: medium none; text-align:left; size:auto;"
							>
						</td>						
					  </tr>				  
					   <!---********************************************************* --->	
					  <tr>
					    <td >&nbsp;</td>
						<td ><strong>Ajustes </strong></td>
						<td >
							<INPUT 	TYPE="textbox" 
							NAME="AJUSTES" 
							VALUE="<cfoutput>#AJUSTES#</cfoutput>" 
							SIZE="20" 
							DISABLED 
							MAXLENGTH="11" 
							ONBLUR="" 
							ONFOCUS="this.select(); " 
							ONKEYUP="" 
							style="border: medium none; text-align:left; size:auto;"
							>
						</td>						
					  </tr>				  
					   <!---********************************************************* --->	
					  <tr>
						<td colspan="3"><strong>Total Pagos :</strong></td>
						<td >
							<INPUT 	TYPE="textbox" 
							NAME="PAGOS" 
							VALUE="<cfoutput>#PAGOS#</cfoutput>" 
							SIZE="20" 
							DISABLED 
							MAXLENGTH="11" 
							ONBLUR="" 
							ONFOCUS="this.select(); " 
							ONKEYUP="" 
							style="border: medium none; text-align:left; size:auto;"
							>
						</td>						
					  </tr>
					  <!---********************************************************* --->	
					  <tr>
					    <td >&nbsp;</td>
						<td ><strong>Cheques </strong></td>
						<td >
								<INPUT 	TYPE="textbox" 
								NAME="CHEQUE" 
								VALUE="<cfoutput>#CHEQUE#</cfoutput>" 
								SIZE="20" 
								DISABLED 
								MAXLENGTH="11" 
								ONBLUR="" 
								ONFOCUS="this.select(); " 
								ONKEYUP="" 
								style="border: medium none; text-align:left; size:auto;"
								>
						</td>
					  </tr>				  
					   <!---********************************************************* --->	
					  <tr>
					    <td >&nbsp;</td>
						<td ><strong>Efectivo </strong></td>
						<td >
							<INPUT 	TYPE="textbox" 
							NAME="EFECTIVO" 
							VALUE="<cfoutput>#EFECTIVO#</cfoutput>" 
							SIZE="20" 
							DISABLED 
							MAXLENGTH="11" 
							ONBLUR="" 
							ONFOCUS="this.select(); " 
							ONKEYUP="" 
							style="border: medium none; text-align:left; size:auto;"
							>
						</td>						
					  </tr>				  
					   <!---********************************************************* --->	
					  <tr>
					    <td >&nbsp;</td>
						<td ><strong>Tarjetas </strong></td>
						<td >
							<INPUT 	TYPE="textbox" 
							NAME="TARJETAS" 
							VALUE="<cfoutput>#TARJETAS#</cfoutput>" 
							SIZE="20" 
							DISABLED 
							MAXLENGTH="11" 
							ONBLUR="" 
							ONFOCUS="this.select(); " 
							ONKEYUP="" 
							style="border: medium none; text-align:left; size:auto;"
							>
						</td>						
					  </tr>				  
					   <!---********************************************************* --->	
					  <tr>
					    <td >&nbsp;</td>
						<td ><strong>Vales </strong></td>
						<td >
							<INPUT 	TYPE="textbox" 
							NAME="VALES" 
							VALUE="<cfoutput>#VALES#</cfoutput>" 
							SIZE="20" 
							DISABLED 
							MAXLENGTH="11" 
							ONBLUR="" 
							ONFOCUS="this.select(); " 
							ONKEYUP="" 
							style="border: medium none; text-align:left; size:auto;"
							>
						</td>						
					
					  </tr>				  
					   <!---********************************************************* --->
					  <tr>
						<td colspan="3"><strong>Diferencia :</strong></td>
						<td >
							<INPUT 	TYPE="textbox" 
							NAME="DIFERENCIA" 
							VALUE="<cfoutput>#DIFERENCIA#</cfoutput>" 
							SIZE="20" 
							DISABLED 
							MAXLENGTH="11" 
							ONBLUR="" 
							ONFOCUS="this.select(); " 
							ONKEYUP="" 
							style="border: medium none; text-align:left; size:auto;"
							>
						</td>											
					  </tr>
					  <!---********************************************************* --->	
					    <cfif form.CJX19REL  neq  0>	
						  <tr>
							<td colspan="4">
								<cfinclude  template="../../portlets/BotonPosteo.cfm">
							</td>
						  </tr>
						</cfif>
  
					  <!---********************************************************* --->	
				</table>	
			</cfoutput>		  
		    </form>
		<!---********************************************************************************* --->
		<!---** 					   FIN PINTADO DE LA PANTALLA 						    ** --->
		<!---********************************************************************************* --->
		</td>
	</tr>
</table>

<!---********************** --->
<!---** AREA DE SCRIPTS  ** --->
<!---********************** --->
<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objform1 = new qForm("form1");
	objform1.DIFERENCIA.required = true;
	objform1.DIFERENCIA.description="La diferencia no puede ser vacio";	 
	function Cantidad_valida(){
		var Cantidad = new Number(qf(this.value))	
		if ( Cantidad != 0){
			this.error = "La diferencia debe ser igual a cero";
		}		
	}
	_addValidator("isCantidad", Cantidad_valida);
	objform1.DIFERENCIA.validateCantidad();
	
	function finalizar(){
	}
	function validaREL(){
		<!---********************************************* --->
		<!--- se invoca el mismo cfm por medio de submit() --->
		<!--- para refrescar la lista segun la relacion    --->
		<!--- que se selecciona en el combo                --->
		<!---********************************************* --->
		doc = document.form1 ;
		doc.action = "";
		doc.submit();
	}


</script> 
