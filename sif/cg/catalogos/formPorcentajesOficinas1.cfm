
<cf_templateheader title="Definir porcentajes por oficina">
<cfset titulo = 'Porcentajes de Oficina'>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
<cfoutput>
<cfif isdefined ('url.speriodo') and not isdefined('form.Speriodo')>
		<cfset form.speriodo=#url.speriodo#>
	</cfif>
	
	<cfif isdefined ('url.smes') and not isdefined('form.Smes')>
		<cfset form.smes=#url.smes#>
	</cfif>
	
	<cfif isdefined ('url.PCCEclaid') >
		<cfset form.PCCEclaid=#url.PCCEclaid#>
	</cfif>
	<cfif isdefined ('url.PCCDclaid') >
		<cfset form.PCCDclaid=#url.PCCDclaid#>
	</cfif>
<cfif isdefined ('url.chk')>
	<cfset bit=#url.chk#>
</cfif>

<form name="form1" method="post" action="SQLPorcentajesOficinas.cfm">
	<input type="hidden" name="PCCDclaid" value="#form.PCCDclaid#" />
	<input type="hidden" name="PCCEclaid" value="#form.PCCEclaid#" />
	<input type="hidden" name="smes" value="#url.smes#" />
	<input type="hidden" name="speriodo" value="#url.speriodo#" />
	
	<!---Copiar valores--->
	<script language="javascript1.1" type="text/javascript">
		var popUpWinSN=0;
		function popUpWindow(URLStr, left, top, width, height){
			if(popUpWinSN) {
				if(!popUpWinSN.closed) popUpWinSN.close();
			}
			popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			window.onfocus = closePopUp;
		}
		
		function doConlis(){
			<cfoutput>
				popUpWindow("/cfmx/sif/cg/catalogos/CopiaPorcentaje.cfm?PCCDclaid=#form.PCCDclaid#&PCCEclaid=#form.PCCEclaid#&smes=#smes#&speriodo=#speriodo#",300,300,350,200);<!---350*200--->
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
			document.form1.action='PorcentajesOficinas.cfm?PCCDclaid=#form.PCCDclaid#&PCCEclaid=#form.PCCEclaid#&smes=#smes#&speriodo=#speriodo#';
			document.form1.submit();
		</cfoutput>
		}
	</script>
<!---Mini Reporte--->
	<script language="javascript1.1" type="text/javascript">
		var popUpWinSN=0;
		function popUpWindow2(URLStr, left, top, width, height){
			if(popUpWinSN) {
				if(!popUpWinSN.closed) popUpWinSN.close();
			}
			popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			window.onfocus = closePopUp;
		}
		
		function doConlis2(Ocodigo){
			<cfoutput>
				popUpWindow("/cfmx/sif/cg/catalogos/Reporte_porcentaje_oficinas.cfm?PCCDclaid=#form.PCCDclaid#&PCCEclaid=#form.PCCEclaid#&smes=#smes#&speriodo=#speriodo#&ocodigo="+Ocodigo,150,200,700,400);<!---350*200--->
			</cfoutput>
		}
		
		function closePopUp2(){
			if(popUpWinSN) {
				if(!popUpWinSN.closed) popUpWinSN.close();
				popUpWinSN=null;
			}
		}
		
		function funcfiltro2(){
		<cfoutput>
			document.form1.action='PorcentajesOficinas.cfm?PCCDclaid=#form.PCCDclaid#&PCCEclaid=#form.PCCEclaid#&smes=#smes#&speriodo=#speriodo#';
			document.form1.submit();
		</cfoutput>
		}
	</script>
	<!------>
		<cfquery name="rsEnca" datasource="#session.dsn#">
			select PCCEcodigo,PCCEdescripcion from PCClasificacionE where PCCEclaid=#form.PCCEclaid#
		</cfquery>
	
		<cfquery name="rsDetalleCla" datasource="#session.dsn#">
			Select  PCCEclaid,	PCCDclaid,	PCCDvalor,	PCCDdescripcion,	PCCDactivo
			from PCClasificacionD
			where PCCEclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCEclaid#">
			and PCCDclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCDclaid#">
		</cfquery> 
	
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr bgcolor="CCCCCC">
			<td align="center"><font color="990033"><strong>Importante:</strong></font>
			<strong>Para que los cambios realizado en los porcentajes sean almacenados en la base de datos</br> 
			se debe de dar clic	en el botón de Grabar que se encuentra al final de la lista que contiene las oficinas</strong></td>
		</tr>
		<cfif isdefined ('url.speriodo') and len(trim(url.speriodo)) gt 0>
			<tr>
			<td><strong>Periodo:</strong>#url.speriodo#	
		</cfif>
<<<<<<< .mine
			
		<cfif isdefined ('url.smes') and len(trim(url.smes)) gt 0>
			&nbsp;&nbsp;<strong>Mes:</strong>#url.smes#</td>
			</tr>
		</cfif>
		
		<cfif rsEnca.recordcount gt 0>
		<tr>
			<td><strong>Encabezado Descripci&oacute;n:&nbsp;</strong>#rsEnca.PCCEcodigo#-#rsEnca.PCCEdescripcion#</td>
		</tr>
		</cfif>
		<cfif rsDetalleCla.recordcount gt 0>
		<tr>
		  <td colspan="1"><strong>Detalle Descripci&oacute;n:&nbsp;</strong>#rsDetalleCla.PCCDvalor#-#rsDetalleCla.PCCDdescripcion#	</td>
		</tr>
		</cfif>
		<tr>
			<td align="right"><input type="submit" value="Regresar" id="reg" name="reg" /></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select * from OficinasxClasificacion where CGCmes=#url.smes# and CGCperiodo=#url.speriodo#
				and PCCDclaid=#form.PCCDclaid#
			</cfquery>
			<tr>
			<td>
				<input type="checkbox" id="chek" name="chek" onclick="this.form.submit();" <cfif isdefined('bit')>checked="checked"</cfif>/>Solo con valores
			</td>
			</tr>
			<tr>
				<cfif rsSQL.recordcount eq 0>
					<td colspan="3" align="center"> 
						<input type="submit" value="Importar" id="importar" name="importar" />
						<input type="button" value="Copiar Valores" id="copiar" name="copiar" onclick="doConlis()" />
					</td>
				</cfif>
			</tr>
			
	<!---Lista de Oficinas--->
	<cfset Navegacion ="">
	<cfset Navegacion = navegacion & 'PCCDclaid=' &#form.PCCDclaid#>
	
	<cfsavecontent variable="VR2">
		<cf_inputNumber name="Ovalor_AAAA" 
		value="111" 
		enteros = "10" decimales = "0"
		>
	</cfsavecontent>
	
		<cfset VR2	= replace(VR2,"'","''","ALL")>
		<cfset VR2	= replace(VR2,"AAAA","' + convert( varchar, o.Ocodigo)  + '","ALL")>
		<cfset VR2	= replace(VR2,"111","' + str(coalesce(CGCporcentaje, 0),3,0)  + '","ALL")>
	
	<!------>
	<cfsavecontent variable="oco">
	<a href="javascript: doConlis2(111);">
					111
				</a>	
	</cfsavecontent>
		<cfset oco	= replace(oco,"'","''","ALL")>
		<cfset oco	= replace(oco,"111","' + convert( varchar,o.Oficodigo)  + '","ALL")>
	<!------>
<!---	<cfset EL	= '<a href="javascript: borraDet(AAAA);"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a>'>
	<cfset EL	= replace(EL,"'","''","ALL")>
	<cfset EL	= replace(EL,"AAAA","' + convert( varchar, ox.Id)  + '","ALL")>
	--->
	<cfif isdefined('bit')>
		<cfquery name="rsOfi" datasource="#session.dsn#">	
			select  
			o.Ocodigo
			,o.Odescripcion
			,o.Oficodigo
			,ox.Id
			, coalesce(ox.CGCporcentaje,0) as CGCporcentaje 
			,'#PreserveSingleQuotes(VR2)#' as valor
			,'#PreserveSingleQuotes(oco)#' as oco
			from Oficinas o 
				inner  join OficinasxClasificacion ox
					on ox.Ocodigo=o.Ocodigo
					and ox.Ecodigo=o.Ecodigo 
					and ox.PCCDclaid = #form.PCCDclaid#
					and ox.CGCperiodo=#url.speriodo#
					and ox.CGCmes=#url.smes#
				where o.Ecodigo=#session.Ecodigo#
				</cfquery>
		<tr>
			<td>
		
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#rsOfi#"
					columnas="Ocodigo,Oficodigo,Odescripcion,valor"
					desplegar="oco,Odescripcion,valor"
					etiquetas="Cod.Oficina,Descripci&oacute;n,Porcentaje"
					formatos="S,S,S"
					align="left,left,left"
					ira="formPorcentajesOficinas.cfm"
					showlink="false"
					form_method="post"
					showEmptyListMsg="yes"
					keys="Ocodigo"	
					MaxRows="0"
					navegacion="#Navegacion#"	
					fparams="Ocodigo"
					/>	
			</td>
		</tr>
	<cfelse>		
		<cfquery name="rsOfi" datasource="#session.dsn#">	
		select  
		o.Ocodigo
		,o.Odescripcion
		,o.Oficodigo
		, coalesce(ox.CGCporcentaje,0) as CGCporcentaje 
		,'#PreserveSingleQuotes(VR2)#' as valor
		,'#PreserveSingleQuotes(oco)#' as oco
		from Oficinas o 
			left outer  join OficinasxClasificacion ox
				on ox.Ocodigo=o.Ocodigo
				and ox.Ecodigo=o.Ecodigo 
				and ox.PCCDclaid = #form.PCCDclaid#
				and ox.CGCperiodo=#url.speriodo#
				and ox.CGCmes=#url.smes#
			where o.Ecodigo=#session.Ecodigo#
			</cfquery>
=======
			
		<cfif isdefined ('url.smes') and len(trim(url.smes)) gt 0>
			&nbsp;&nbsp;<strong>Mes:</strong>#url.smes#</td>
			</tr>
		</cfif>
		
		<cfif rsEnca.recordcount gt 0>
		<tr>
			<td><strong>Encabezado Descripci&oacute;n:&nbsp;</strong>#rsEnca.PCCEcodigo#-#rsEnca.PCCEdescripcion#</td>
		</tr>
		</cfif>
		<cfif rsDetalleCla.recordcount gt 0>
		<tr>
		  <td colspan="1"><strong>Detalle Descripci&oacute;n:&nbsp;</strong>#rsDetalleCla.PCCDvalor#-#rsDetalleCla.PCCDdescripcion#	</td>
		</tr>
		</cfif>
		<tr>
			<td align="right"><input type="submit" value="Regresar" id="reg" name="reg" /></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select * from OficinasxClasificacion where CGCmes=#url.smes# and CGCperiodo=#url.speriodo#
				and PCCDclaid=#form.PCCDclaid#
			</cfquery>
			<tr>
			<td>
				<input type="checkbox" id="chek" name="chek" onclick="this.form.submit();" <cfif isdefined('bit')>checked="checked"</cfif>/>Solo con valores
			</td>
			</tr>
			<tr>
				<cfif rsSQL.recordcount eq 0>
					<td colspan="3" align="center"> 
						<input type="submit" value="Importar" id="importar" name="importar" />
						<input type="button" value="Copiar Valores" id="copiar" name="copiar" onclick="doConlis()" />
					</td>
				</cfif>
			</tr>
			
	<!---Lista de Oficinas--->
	<cfset Navegacion ="">
	<cfset Navegacion = navegacion & 'PCCDclaid=' &#form.PCCDclaid#>
	
	<cfsavecontent variable="VR2">
		<cf_inputNumber name="Ovalor_AAAA" 
		value="111" 
		onblur="<!---modificar(AAAA,this.value);--->"
		enteros = "10" decimales = "0"
		>
	</cfsavecontent>
	
		<cfset VR2	= replace(VR2,"'","''","ALL")>
		<cfset VR2	= replace(VR2,"AAAA","' + convert( varchar, o.Ocodigo)  + '","ALL")>
		<cfset VR2	= replace(VR2,"111","' + convert( varchar, coalesce(CGCporcentaje, 0))  + '","ALL")>
	
	<!---invento--->
	<cfsavecontent variable="oco">
	<a href="javascript: doConlis2(111);">
					111
				</a>	
	</cfsavecontent>
		<cfset oco	= replace(oco,"'","''","ALL")>
		<cfset oco	= replace(oco,"111","' + convert( varchar,o.Oficodigo)  + '","ALL")>
	<!------>
<!---	<cfset EL	= '<a href="javascript: borraDet(AAAA);"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a>'>
	<cfset EL	= replace(EL,"'","''","ALL")>
	<cfset EL	= replace(EL,"AAAA","' + convert( varchar, ox.Id)  + '","ALL")>
	--->
	<cfif isdefined('bit')>
		<cfquery name="rsOfi" datasource="#session.dsn#">	
			select  
			o.Ocodigo
			,o.Odescripcion
			,o.Oficodigo
			,ox.Id
			, coalesce(ox.CGCporcentaje,0) as CGCporcentaje 
			,'#PreserveSingleQuotes(VR2)#' as valor
			,'#PreserveSingleQuotes(oco)#' as oco
			from Oficinas o 
				inner  join OficinasxClasificacion ox
					on ox.Ocodigo=o.Ocodigo
					and ox.Ecodigo=o.Ecodigo 
					and ox.PCCDclaid = #form.PCCDclaid#
					and ox.CGCperiodo=#url.speriodo#
					and ox.CGCmes=#url.smes#
				where o.Ecodigo=#session.Ecodigo#
				</cfquery>
		<tr>
			<td>
		
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#rsOfi#"
					columnas="Ocodigo,Oficodigo,Odescripcion,valor"
					desplegar="oco,Odescripcion,valor"
					etiquetas="Cod.Oficina,Descripci&oacute;n,Porcentaje"
					formatos="S,S,S"
					align="left,left,left"
					ira="formPorcentajesOficinas.cfm"
					showlink="false"
					form_method="post"
					showEmptyListMsg="yes"
					keys="Ocodigo"	
					MaxRows="0"
					navegacion="#Navegacion#"	
					fparams="Ocodigo"
					/>	
			</td>
		</tr>
	<cfelse>		
		<cfquery name="rsOfi" datasource="#session.dsn#">	
		select  
		o.Ocodigo
		,o.Odescripcion
		,o.Oficodigo
		, coalesce(ox.CGCporcentaje,0) as CGCporcentaje 
		,'#PreserveSingleQuotes(VR2)#' as valor
		,'#PreserveSingleQuotes(oco)#' as oco
		from Oficinas o 
			left outer  join OficinasxClasificacion ox
				on ox.Ocodigo=o.Ocodigo
				and ox.Ecodigo=o.Ecodigo 
				and ox.PCCDclaid = #form.PCCDclaid#
				and ox.CGCperiodo=#url.speriodo#
				and ox.CGCmes=#url.smes#
			where o.Ecodigo=#session.Ecodigo#
			</cfquery>
>>>>>>> .r16462
	<tr>
		<td>
	
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#rsOfi#"
				columnas="Ocodigo,Oficodigo,Odescripcion,valor"
				desplegar="oco,Odescripcion,valor"
				etiquetas="Cod.Oficina,Descripci&oacute;n,Porcentaje"
				formatos="S,S,S"
				align="left,left,left"
				ira="formPorcentajesOficinas.cfm"
				showlink="false"
				form_method="post"
				showEmptyListMsg="yes"
				keys="Ocodigo"	
				MaxRows="0"
				navegacion="#Navegacion#"	
				fparams="Ocodigo"
				/>	
		</td>
	</tr>
	</cfif>
	<tr>
	
		<td align="center">
			<input name="grabar" id="grabar" type="submit" value="Grabar">
		</td>
	
	</tr>
</form>
</cfoutput>
<cfoutput>
<!---<iframe name="ifrBorrarDet" id="ifrBorrarDet" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
<script language="javascript1.1" type="text/javascript">
	function borraDet(id){
	window.location='SQLPorcentajesOficinas.cfm?PCCDclaid='+#form.PCCDclaid#+'&PCCEclaid='+#form.PCCEclaid#+'&smes='+#smes#+'&speriodo='+#speriodo#+'&borrar='+1+'&id='+id+'';

	}
</script>--->
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>