<cfif isdefined ('url.CGCid') and isdefined ('form.CGCid') and len(trim(#form.CGCid#)) eq 0>
	<cfset form.CGCid=#url.CGCid#>
</cfif>

<cfif isdefined ('url.CGCid') and not isdefined ('form.CGCid')>
	<cfset form.CGCid=#url.CGCid#>
</cfif>

<cfif isdefined ('url.smes') and not isdefined('form.smes')>
	<cfset form.smes=#url.smes#>
</cfif>

<cfif isdefined ('url.speriodo') and not isdefined('form.speriodo')>
	<cfset form.speriodo=#url.speriodo#>
</cfif>

<cfif isdefined ('url.chk')>
	<cfset bit=#url.chk#>
</cfif>
<cfquery name="resultado" datasource="#session.dsn#">
	select CGCmodo, CGCidc,CGCdescripcion from CGConductores c
	where CGCid=#form.CGCid#
</cfquery>

<cfset id=#resultado.CGCidc#>
<!---Definicion si es categoria o clasificacion--->
<cfif resultado.CGCmodo eq 1>
	<cfset catego=1>
<cfelseif resultado.CGCmodo eq 2>
	<cfset clas=1>
</cfif>
<cf_dbfunction name="OP_concat" 				  returnvariable="_Cat">
<cf_dbfunction name='to_char' args="o.PCDvalor"   returnvariable='LvarPCDvalor'>
<cf_dbfunction name='to_char' args="o.PCCDvalor"  returnvariable='LvarPCCDvalor'>
<cf_dbfunction name='to_char' args="o.PCDcatid"   returnvariable='LvarPCDcatid'>
<cf_dbfunction name='to_char' args="o.PCCDclaid"  returnvariable='LvarPCCDclaid'>
<cf_dbfunction name="to_char_float"	args="coalesce(ox.CGCvalor,0)" dec="6" delimiters=";" returnvariable="LvarCGCvalor">


<!---pop_up para copiar valores--->
<script language="javascript1.1" type="text/javascript">
	var popUpWinSN=0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWinSN) {
			if(!popUpWinSN.closed) popUpWinSN.close();
		}
		popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbars=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUp;
	}
	
	function doConlis(){		
		<cfoutput>
			popUpWindow("/cfmx/sif/cg/catalogos/CGCCopiarValoresD.cfm?CGCid=#form.CGCid#&speriodo=#form.speriodo#&smes=#smes#",300,300,350,200);
		</cfoutput>
	}
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWinSN) {
			if(!popUpWinSN.closed) popUpWinSN.close();
		}
		popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUp;
	}

	function doConlis2(valor){		
		<cfoutput>
		<cfif resultado.CGCmodo eq 1>
			popUpWindow("/cfmx/sif/cg/catalogos/Valor_Conductor_Rep.cfm?CGCid=#form.CGCid#&speriodo=#form.speriodo#&smes=#smes#&valor="+valor+"&modo="+2,85,300,700,500);<!---350*200--->
		<cfelseif resultado.CGCmodo eq 2>
			popUpWindow("/cfmx/sif/cg/catalogos/Valor_Conductor_Rep.cfm?CGCid=#form.CGCid#&speriodo=#form.speriodo#&smes=#smes#&valor="+valor+"&modo="+1,85,300,700,500);<!---350*200--->
		</cfif>

		</cfoutput>
	}
	
	function closePopUp(){
		if(popUpWinSN) {
			if(!popUpWinSN.closed) popUpWinSN.close();
			popUpWinSN=null;
		}
	}
	
	function funcfiltro(){
	<cfoutput>
		document.form1.action='Valor_Conductor_form.cfm?CGCid=#form.CGCid#&speriodo=#form.speriodo#&smes=#smes#';
		document.form1.submit()
	</cfoutput>
	}
</script>

<!---Variables para la lista--->
<cfsavecontent variable="VR2">
	<cf_inputNumber name="Valor_AAAA" 
	value="111.000000" 
	onblur="modificar(AAAA, this.value);"
	enteros = "15" decimales = "6">
</cfsavecontent>
<cfset VR2	= replace(VR2,"'","''","ALL")>
<cfif isdefined ('catego')>		 
	<cfset VR2	= replace(VR2,"AAAA","' #_Cat##LvarPCDcatid##_Cat# '","ALL")>
<cfelse>
	<cfset VR2	= replace(VR2,"AAAA","' #_Cat##LvarPCCDclaid##_Cat# '","ALL")>
</cfif>
<cfset VR2	= replace(VR2,"111.000000","' #_Cat##LvarCGCvalor##_Cat# '","ALL")>

<cfsavecontent variable="des">
	<a href="javascript: doConlis2('111');">111</a>	
</cfsavecontent>
<cfset des	= replace(des,"'","''","ALL")>
<cfif isdefined ('catego')>	
	<cfset des	= replace(des,"111","' #_Cat##LvarPCDvalor##_Cat# '","ALL")>	 
<cfelse>
	<cfset des	= replace(des,"111","' #_Cat##LvarPCCDvalor##_Cat# '","ALL")>	
</cfif>

<cfsavecontent variable="EL">
	<a href="javascript: borraDet('AAAA');"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a>
</cfsavecontent>
<!---<cfset EL	= replace(EL,"'","''","ALL")>--->
<cfif isdefined ('catego')>			
	<cfset EL	= replace(EL,"AAAA"," #_Cat##LvarPCDcatid##_Cat# ","ALL")>	
<cfelse>
	<cfset EL	= replace(EL,"AAAA"," #_Cat##LvarPCCDclaid##_Cat# ","ALL")>
</cfif>

<cfquery name="rsQueryLista" datasource="#session.dsn#">
	select 
	<cfif isdefined ('bit')>
		'#PreserveSingleQuotes(EL)#' as eli,
	</cfif>
		'#PreserveSingleQuotes(VR2)#' as VR2,
		'#PreserveSingleQuotes(des)#' as des,	
	<!---En caso de que sea categoria--->
	<cfif isdefined ('catego')>
			o.PCDcatid as modo,
			o.PCDvalor as valor,
			o.PCDdescripcion as descrip,
			<cf_dbfunction name="to_integer" args="coalesce(ox.CGCvalor, 0)"> as CGCporcentaje,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#id#"> as id,
			'cate' as tipo
		from PCECatalogo e
			inner join PCDCatalogo o
				on o.PCEcatid=e.PCEcatid
			<cfif isdefined ('bit')>inner<cfelse>left outer</cfif> join CGParamConductores ox
				on ox.PCDcatid=o.PCDcatid
				and ox.CGCperiodo=#url.Speriodo#
				and ox.CGCmes=#url.Smes#
				and ox.CGCid=#form.CGCid#
		where e.PCEcatid=#id#								
	</cfif>
	<!---En caso de que sea clasificacion--->
	<cfif isdefined ('clas')>
			o.PCCDdescripcion as descrip,
			o.PCCDvalor as valor,
			o.PCCDclaid as modo,
			<cf_dbfunction name="to_integer" args="coalesce(ox.CGCvalor, 0)"> as CGCporcentaje,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#id#"> as id,
			'clas' as tipo
		from PCClasificacionE e
			inner join PCClasificacionD o
				on o.PCCEclaid=e.PCCEclaid	
			<cfif isdefined ('bit')>inner<cfelse>left outer</cfif> join CGParamConductores ox
				on ox.PCCDclaid=o.PCCDclaid
				and ox.CGCperiodo=#url.Speriodo#
				and ox.CGCmes=#url.Smes#
				and ox.CGCid=#form.CGCid#
		where e.PCCEclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">		
	</cfif>	
	<cfif isdefined ('bit')>
		  and ox.CGCvalor !=0
	</cfif>
</cfquery>

<!---  Manejo de la Pantalla --->
<cf_templateheader title="Conductor"> 
	<cf_web_portlet_start border="true" titulo="Valores por Conductor" skin="#Session.Preferences.Skin#">
		<form action="Valor_Conductor_sql.cfm" method="post" name="form1">
			<cfoutput>
				<input type="hidden" name="CGCid"  	  value="#form.CGCid#">
				<input type="hidden" name="smes"  	  value="#form.smes#">
				<input type="hidden" name="speriodo"  value="#form.speriodo#">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" >
					<tr bgcolor="DDDDDD">
						<td align="center" colspan="2"><font color="990033"><strong>Importante:</strong></font>
						<strong>Los cambios realizados en el campo de valor son almacenados en forma automática.</strong>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td><strong>Periodo:</strong> #url.Speriodo#</td>
                    	<td><strong>Mes:</strong> #url.Smes#</td>
					</tr>
					<tr>
						<td><strong>Conductor:</strong> #resultado.CGCdescripcion#</td>
						<td><strong>Tipo:</strong> <cfif isdefined ('catego')>Catalogo<cfelseif isdefined ('clas')>Clasificaci&oacute;n</cfif><br></td>
					</tr>		
					<tr>
						<td align="left">
							<input type="checkbox" name="chek" onclick="this.form.submit();" <cfif isdefined('bit')>checked="checked"</cfif>/>Solo con valores
						</td>
						<td align="right" colspan="2">
							<input name="imp" type="submit" value="Importar" />
							<input name="copiar" type="button" value="CopiarValores" onclick="doConlis()" />
							<input name="reg1" type="submit" value="Regresar" />
						</td>
					</tr>
				</table>
			</cfoutput>
			<table width="100%">
				<tr>&nbsp;</tr>
				<tr>
					<cfif isdefined ('bit')><td>Eliminar</td></cfif>
                    <td><strong>Codigo</strong></td>
                    <td><strong>Catalogo/UEN</strong></td>
                    <td><strong>Valor</strong></td>
                </tr>
				<cfoutput query="rsQueryLista">
					<tr>
                    	<cfif isdefined ('bit')><td>#preservesinglequotes(eli)#</td></cfif>
                        <td>#des#</td>
                        <td>#descrip#</td>
                        <td align="left">#preservesinglequotes(VR2)#</td>
                    </tr>
				</cfoutput>
			</table>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>
<iframe name="ifrCambioVal" id="ifrvalores" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
<!---valor=qf(value)--->
<cfoutput>
	<script language="javascript1.2" type="text/javascript">
		function modificar(id,value){
		var modo='';
		valor=value
			if (id != "" )
			{
			<cfif isdefined ('catego')>
				var modo=1
			</cfif>
			<cfif isdefined ('clas')>
				var modo=2
			</cfif>
			document.getElementById('ifrvalores').src = 'ifrvalores.cfm?valor='+qf(valor)+'&id='+id+'&speriodo='+#form.Speriodo#+'&smes='+#form.smes#+'&CGCid='+#form.CGCid#+'&modo='+modo+'';
			}
			//else
			//document.form1.("Valor_" + id).value ="0.00";
		}
		function borraDet(id){
		<cfif isdefined ('catego')>
				var modo=1
			</cfif>
			<cfif isdefined ('clas')>
				var modo=2
			</cfif>
		document.getElementById('ifrvalores').src = 'ifrvalores.cfm?id='+id+'&speriodo='+#form.Speriodo#+'&smes='+#form.smes#+'&CGCid='+#form.CGCid#+'&modo='+modo+'&borra='+1+'';		
		}		
	</script>
</cfoutput>