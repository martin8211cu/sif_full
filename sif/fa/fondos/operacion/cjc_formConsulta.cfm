
<!---*********************** --->
<!---** AREA DE PINTADO    ** --->
<!---************************ --->
 <cfquery name="Pagos" datasource="#session.Fondos.dsn#">
	select CJX23CON,case when CJX23TIP= 'C' then 'Cheque' when CJX23TIP= 'E' then 'Efectivo' when CJX23TIP= 'T' then 'Tarjeta' when CJX23TIP= 'V' then 'Vale' end CJX20TIP,
	CJX23MON * case when CJX23TTR = 'D' then -1 else 1 end CJX23MON,
	case 
	when CJX23TIP= 'C' then 'No.[' +CJX23CHK +']' 
	when CJX23TIP= 'E' then '-' 
	when CJX23TIP= 'T' then 'No.[' +TR01NUT +'] autorización [' +CJX23AUT +']' 
	when CJX23TIP= 'V' then 'No.['+convert(varchar,CJX5IDE,1)+']' 
	end DOCUMENTO
	from CJX023 , CJX019
	where CJX023.CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.CJX19REL#" >
	and CJX19EST = 'D'
	and CJX023.CJX19REL = CJX019.CJX19REL
</cfquery>

 <cfquery name="Facturas" datasource="#session.Fondos.dsn#">
	select CJX20NUM
	,case when CJX20TIP= 'A' then 'Ajuste' when CJX20TIP= 'F' then 'Factura' when CJX20TIP= 'V' then 'Viaticos y Otros' end CJX20TIP
	,convert(varchar(10),CJX20FEF,103)CJX20FEF
	,CJX20MNT
	,CJX20NUF 
	from CJX020, CJX019
	where CJX020.CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.CJX19REL#" >
	and CJX19EST = 'D'
	and CJX020.CJX19REL = CJX019.CJX19REL
</cfquery>

<!---********************************* --->
<!---** AREA DE IMPORTACION DE JS   ** --->
<!---********************************* --->
<SCRIPT LANGUAGE='Javascript'  src="../js/utilies.js"></SCRIPT>
<style type="text/css">
<!--
.style1 {color: #FFFFFF}
.style2 {color: #FFFF00}
-->
</style>


<table width="100%" border="0" >
	<tr>
		<td width="100%"  align="center" colspan="2" >
		<!---********************************************************************************* --->
		<!---** 					INICIA PINTADO DE LA PANTALLA 							** --->
		<!---********************************************************************************* --->
				<cfset navegacion = "&CJX19REL=#form.CJX19REL#" > 	
				<cfinvoke 
					component="sif.fondos.Componentes.pListas"
					method="pLista"
					returnvariable="pListaRet">
					<cfinvokeargument name="conexion" value="#session.Fondos.dsn#"/>
					<cfinvokeargument name="tabla" value="CJX019,CGX050"/>
					<cfinvokeargument name="columnas" value="CJX19REL,convert(varchar(10),CJX19FED,103) CJX19FED"/>
					<cfinvokeargument name="desplegar" value="CJX19REL,CJX19FED"/>
					<cfinvokeargument name="etiquetas" value="Relación,Fecha de creación"/>
					<cfinvokeargument name="formatos" value="S,S"/>
					<cfinvokeargument name="filtro" value=" CJX19EST = 'D' AND CJ1MES = MESCOD and CJ01ID ='#session.Fondos.Caja#'"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="MaxRows" value="10"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="keys" value="CJX19REL"/>
					<cfinvokeargument name="irA" value="cjc_PrincipalConsulta.cfm"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
				</cfinvoke>		
		<!---********************************************************************************* --->
		<!---** 					   FIN PINTADO DE LA PANTALLA 						    ** --->
		<!---********************************************************************************* --->
		</td>
	</tr>
	<tr>
		<td width="100%"  align="center" colspan="2" >
			<form action="../operacion/cjc_PrincipalGasto.cfm" method="post" name="form1"	>
			<cfif Form.CJX19REL gt "0">
				<input type="hidden" name="CJX19REL" value="<cfoutput>#Form.CJX19REL#</cfoutput>">
				<input name="seleccionar" type="submit" value="seleccionar">
			<cfelse>
				Debe seleccionar una relación para ver su contenido
			</cfif>
			
			</form>
		</td>		
	</tr>	
	<tr>
		<td width="40%"  valign="top">
		<cfif Form.CJX19REL gt "0">
			<table cellpadding="0" cellspacing="0" width="100%" bgcolor="steelblue" >
			<tr>
			<td colspan="5"  align="center" <strong><span class="style1">Facturas</span></strong></td>
			</tr>
			<tr>
				<td> <span class="style1">Línea</span></td>
				<td> <span class="style1">Tipo</span></td>
				<td> <span class="style1">Fecha</span></td>
				<td> <span class="style1">Documento</span></td>
				<td> <span class="style1">Monto</span></td>
			</tr>
			<cfoutput query="Facturas">
				<tr>               
					<td><span class="style2">#Facturas.CJX20NUM#</span></td>
					<td><span class="style2">#Facturas.CJX20TIP#</span></td>
					<td><span class="style2">#Facturas.CJX20FEF#</span></td>
					<td><span class="style2">#Facturas.CJX20NUF#</span></td>
					<td align="right"><span class="style2">#LsCurrencyFormat(Evaluate('#Trim(Facturas.CJX20MNT)#'),"none")#</span></td>
				</tr>
			</cfoutput>			
			</table>
		</cfif>
		</td>
		<td width="60%"  valign="top">
		<cfif Form.CJX19REL gt "0">
			<table cellpadding="0" cellspacing="0" width="100%" bgcolor="steelblue">
			<tr>
			<td colspan="4"  align="center" <strong><span class="style1">Pagos</span></strong></td>
			</tr>
			<tr>
				<td><span class="style1">Línea</span></td>
				<td><span class="style1">Tipo</span></td>
				<td><span class="style1">Documento</span></td>
				<td><span class="style1">Monto</span></td>
			</tr>		
			<cfoutput query="Pagos">
				<tr>                                       
					<td><span class="style2">#Pagos.CJX23CON#</span></td>
					<td><span class="style2">#Pagos.CJX20TIP#</span></td>
					<td><span class="style2">#Pagos.DOCUMENTO#</span></td>
					<td align="right"><span class="style2">#LsCurrencyFormat(Evaluate('#Trim(Pagos.CJX23MON)#'),"none")#</span></td>
				</tr>
			</cfoutput>					
			</table>		
		</cfif>
		</td>		
	</tr>
</table>

<!---********************** --->
<!---** AREA DE SCRIPTS  ** --->
<!---********************** --->
<script language="JavaScript1.2" type="text/javascript">
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
