<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="to_char"	args="rr.DRRid"  returnvariable="DRRid">

<!---Variables de traducción--->
<cfinvoke Key="LB_FECHAD" Default="Fecha desde:" XmlFile="/rh/generales.xml" returnvariable="LB_FECHAD" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FECHAH" Default="Fecha hasta:" XmlFile="/rh/generales.xml" returnvariable="LB_FECHAH" component="sif.Componentes.Translate" method="Translate"/>

<cfif isdefined ('url.DRRid') and len(trim(url.DRRid)) gt 0>
	<cfset form.DRRid=#url.DRRid#>
</cfif>

<cfif isdefined ('url.ERRid') and len(trim(url.ERRid)) gt 0 and (not isdefined ('form.ERRid') or len(trim(form.ERRid)) lt 0)>
	<cfset form.ERRid=#url.ERRid#>
</cfif>

			
<cfif isdefined ('form.ERRid')>
		<cfset EL	= '<a href="javascript: borraDet(AAAA);"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a>'>
		<cfset EL	= replace(EL,"'","''","ALL")>
		<cfset EL	= replace(EL,"AAAA","' #_Cat# #DRRid# #_Cat# '","ALL")>
		
	<cfquery name="rsForm" datasource="#session.dsn#">
		select * from ERegimenReparto where ERRid=#form.ERRid#
	</cfquery>
	
	<cfquery name="rsDERR" datasource="#session.dsn#">
		select rr.DRRid,ERRid,DRRinf,DRRsup,DRRporcentaje,DRRmontofijo,'#PreserveSingleQuotes(EL)#' as eli
		 from DRegimenReparto rr where rr.ERRid=#form.ERRid#
	</cfquery>
	
</cfif>
	
<form name="form_rr" action="RReparto_SQL.cfm" method="post" onsubmit="return Validar();">
<cfoutput>
	<cfif isdefined ('url.ERRid') and len(trim(url.ERRid)) gt 0 and not isdefined ('form.ERRid')>
		<cfset modo='Cambio'>
		<input type="hidden" value="#url.ERRid#" name="LvarERRid">
	<cfelseif isdefined ('form.ERRid') and len(trim(form.ERRid)) gt 0>
		<cfset modo='Cambio'>
		<input type="hidden" value="#form.ERRid#" name="LvarERRid">
	<cfelse>
		<cfset modo='Alta'>
	</cfif>
	
	<table border="0">
			<tr>
				<td nowrap="nowrap" align="left">#LB_FECHAD#</td>
				<cfif modo eq 'alta'>
					<cfset Lvarfechad = LSDateFormat(Now(),'dd/mm/yyyy')>
				<cfelse>
					<cfset Lvarfechad = LSDateFormat(#rsForm.ERRdesde#,'dd/mm/yyyy')>
				</cfif>
				<td align="left">
					<cf_sifcalendario form="form_rr" value="#Lvarfechad#" name="fechad" tabindex="1">
				</td>
				<td nowrap="nowrap">#LB_FECHAH#</td>
				<cfif modo eq 'alta'>
					<cfset Lvarfechah = LSDateFormat(Now(),'dd/mm/yyyy')>
				<cfelse>
					<cfset Lvarfechah = LSDateFormat(#rsForm.ERRhasta#,'dd/mm/yyyy')>
				</cfif>
				<cfif modo neq 'alta' and rsForm.ERRhasta eq '01/01/6100'>
					<td>Indefinido</td>
				<cfelseif modo neq 'alta' and rsForm.ERRhasta neq '01/01/6100'>
				<td nowrap="nowrap" align="left"><cf_sifcalendario form="form_rr" value="#Lvarfechah#" name="fechah" tabindex="1" readonly="true"></td>
				</cfif>
			</tr>
			<tr>
				<td nowrap="nowrap" colspan="4">
					<cfif modo eq 'Alta'>
					<cf_botones modo="#modo#">
					<cfelse>
					<cf_botones modo="#modo#">
						<cfif isdefined('rsForm') and rsForm.ERRestado eq 0>
							<cf_botones values="Aplicar" formName="form_rr" names="btnAplicar">
						</cfif>
					</cfif>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<cfif modo eq 'Cambio'>
			<tr>
				<td bgcolor="CCCCCC"colspan="5" align="center">Tabla de Retención</td>
				</tr>
				<tr>
					<!---<td><strong>Monto Desde:</strong></td>--->
					<td ><strong>Monto Hasta:</strong></td>
					<td><strong>Porcentaje:</strong></td>
					<td><strong>Monto Fijo:</strong></td>
				</tr>
					<tr>
					<cfif isdefined ('form.DRRid')>
						<input type="hidden" name="LvarDRRid" value="#form.DRRid#" />
						<cfquery name="rsDet" datasource="#session.dsn#">
							select DRRinf,DRRsup,DRRporcentaje,DRRmontofijo
							from DRegimenReparto
							where DRRid=#form.DRRid#
						</cfquery>
						<!---<td><cf_inputNumber name="montod" value="#rsDet.DRRinf#" size="15" enteros="13" decimales="2"></td>--->
						<td><cf_inputNumber name="montoh" value="#rsDet.DRRsup#"size="15" enteros="13" decimales="2"></td>
						<td><cf_inputNumber name="porc" value="#rsDet.DRRporcentaje#"size="15" enteros="13" decimales="2"></td>
						<td><cf_inputNumber name="montof" value="#rsDet.DRRmontofijo#" size="15" enteros="13" decimales="2"></td>
					<cfelse>
						<!---<td><cf_inputNumber name="montod" size="15" enteros="13" decimales="2"></td>--->
						<td><cf_inputNumber name="montoh" size="15" enteros="13" decimales="2"></td>
						<td><cf_inputNumber name="porc" size="15" enteros="13" decimales="2"></td>
						<td><cf_inputNumber name="montof" size="15" enteros="13" decimales="2"></td>
					</cfif>
					<td nowrap="nowrap">
						<cf_botones values="Agregar" formName="form_rr" names="btnAgregar">
						<input type="hidden" name="DRRid"  />
						<!---<input type="submit"  value="Aid" name="BorrarDet" id="BorrarDet" style="display:none"/>--->
					</td>
				</tr>
				<tr>
			
				</tr>				
			</td></tr>
			</cfif>
	</table>
</cfoutput>
</form>
	<cfif isdefined ('form.ERRid')>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#rsDERR#"
		desplegar="DRRinf,DRRsup,DRRporcentaje,DRRmontofijo,eli"
		etiquetas="Desde,Hasta,Porcentaje,Monto Fijo,Eliminar"
		formatos="M,M,S,M,S"
		align="right,right,right,right,center"
		ira="RReparto.cfm"
		showEmptyListMsg="yes"
		keys="DRRid"	
		MaxRows="10"
		navegacion="no"
		formName="ListaDetalle"
		PageIndex="2"
		showLink="false">
	</cfif>

<script language="JavaScript" type="text/JavaScript" src="/cfmx/rh/js/utilesMonto.js"></script>	
<script language="javascript">
	
	function Valida(){
		return confirm('¿Está seguro(a) de que desea eliminar el registro?')
	}
	
	function borraDet(DRRid){
			if (Valida()){
				document.form_rr.DRRid.value = DRRid;
				document.form_rr.submit();
				}	
					
	}
	
	function Validar(){
		//document.form_rr.montod.value=qf(document.form_rr.montod);
		document.form_rr.montoh.value=qf(document.form_rr.montoh);
		document.form_rr.porc.value=qf(document.form_rr.porc);
		document.form_rr.montof.value=qf(document.form_rr.montof);
		if (btnSelected('btnAgregar',document.form_rr)){
			var error_input;
			var error_msg = '';
			
			/*if (form_rr.montod.value == "") {
			error_msg += "\n - El monto desde no puede quedar en blanco.";
			error_input = form_rr.montod;
			}	*/
			
			if (trim(form_rr.montoh.value) == "") {
			error_msg += "\n - El monto hasta no puede quedar en blanco.";
			error_input = form_rr.montoh;
			}	
			
			
			if (trim(form_rr.porc.value) == "") {
			error_msg += "\n - El porcentaje no puede quedar en blanco.";
			error_input = form_rr.porc;
			}	
			
			if (trim(form_rr.montof.value) == "") {
			error_msg += "\n - El monto fijo no puede quedar en blanco.";
			error_input = form_rr.montof;
			}	
			if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
			}
		}
		return true;
	
	}
	function ltrim(str) { 
	for(var k = 0; k < str.length && isWhitespace(str.charAt(k)); k++);
	return str.substring(k, str.length);
	}
	function rtrim(str) {
		for(var j=str.length-1; j>=0 && isWhitespace(str.charAt(j)) ; j--) ;
		return str.substring(0,j+1);
	}
	function trim(str) {
		return ltrim(rtrim(str));
	}
	function isWhitespace(charToCheck) {
	var whitespaceChars = " \t\n\r\f";
	return (whitespaceChars.indexOf(charToCheck) != -1);
}

</script>
