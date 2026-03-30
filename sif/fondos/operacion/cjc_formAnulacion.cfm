<!---*********************** --->
<!---** AREA DE PINTADO    ** --->
<!---************************ --->
<cfif isdefined("Form.CJX19REL") and len(trim(Form.CJX19REL)) gt 0 >
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
		and CJX19EST = 'P'
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
		and CJX19EST = 'P'
		and CJX020.CJX19REL = CJX019.CJX19REL
	</cfquery>
</cfif>

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
				<cfif isdefined("url.CJX19REL") and len(trim(url.CJX19REL)) gt 0 >
					<cfset navegacion = "&CJX19REL=#url.CJX19REL#"> 	
					<cfset Filtro2   = " and CJX19REL >= #url.CJX19REL#"> 	
				<cfelse>
					<cfset navegacion = "" > 	
					<cfset Filtro2 = "" >
				</cfif>
				<cfinvoke 
					component="sif.fondos.Componentes.pListas"
					method="pLista"
					returnvariable="pListaRet">
					<cfinvokeargument name="conexion" value="#session.Fondos.dsn#"/>
					<cfinvokeargument name="tabla" value="CJX019"/>
					<cfinvokeargument name="columnas" value="CJX19REL,convert(varchar(10),CJX19FED,103) CJX19FED,convert(varchar(10),CJX19FEP,103) CJX19FEP"/>
					<cfinvokeargument name="desplegar" value="CJX19REL,CJX19FED,CJX19FEP"/>
					<cfinvokeargument name="etiquetas" value="Relación,Fecha de creación,Fecha de Posteo"/>
					<cfinvokeargument name="formatos" value="S,S,S"/>
					<cfinvokeargument name="filtro" value=" CJX19EST = 'P' and CJ01ID ='#session.Fondos.Caja#' #Filtro2#"/>
					<cfinvokeargument name="align" value="left,left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="MaxRows" value="10"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="keys" value="CJX19REL"/>
					<cfinvokeargument name="irA" value="cjc_Anulacion.cfm"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
				</cfinvoke>		
		<!---********************************************************************************* --->
		<!---** 					   FIN PINTADO DE LA PANTALLA 						    ** --->
		<!---********************************************************************************* --->
		</td>
	</tr>
	<tr>
		<td width="100%"  align="center" colspan="2" >
			<form action="../operacion/cjc_SqlAnulacion.cfm" method="post" name="form1"	>
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td width="9%" align="left"><strong>Relaci&oacute;n</strong></td>
				<td width="14%"> 
					<INPUT 	TYPE="textbox" 
							NAME="CJX19REL" 
							VALUE="<cfif isdefined("Form.CJX19REL")><cfoutput>#Form.CJX19REL#</cfoutput></cfif>" 
							SIZE="15" 
							MAXLENGTH="15"  
							ONBLUR="javascript: fm(this,0);" 
							ONFOCUS="javascript: this.value=qf(this); this.select(); " 
							ONKEYUP="javascript: if(snumber(this,event,0)){ if(Key(event)=='13'){}} " >
				</td>
				<td width="77%" align="left">
					<input type="submit"  id="btnFiltrar" name="btnFiltrar" value="Filtrar" onClick="filtrar();">
				</td>
			</tr>
			<tr>
				<td align="center"><input type="checkbox" name="chk_conservar" value="1" border="0"></td>
				<td colspan="2">Anular la Relacion y crear una nueva</td>
			</tr>
		</table>			
		<cfif isdefined("Form.CJX19REL") and len(trim(Form.CJX19REL)) gt 0 >
				<input name="Anular" id="Anular" type="submit" value="Anular">
			<cfelse>
			<strong> Debe seleccionar una relación para ver su contenido y poder anularla</strong>			
			</cfif>
			
			</form>
		</td>		
	</tr>	
	<tr>
		<td width="40%"  valign="top">
		<cfif isdefined("Form.CJX19REL") and len(trim(Form.CJX19REL)) gt 0 >
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
		<cfif isdefined("Form.CJX19REL") and len(trim(Form.CJX19REL)) gt 0 >
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
	function filtrar(){
		

	}


</script> 

