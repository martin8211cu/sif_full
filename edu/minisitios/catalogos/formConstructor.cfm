<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo NEQ "ALTA">
	<cfquery name="rsTitulo" datasource="sdc">
		select convert(varchar,MSCcontenido) as MSCcontenido, MSCtitulo
		from MSContenido
		where Scodigo = #Session.Scodigo#
		order by 2
	</cfquery>	

	<cffunction name="contArea" returntype="string">
		<cfargument name="area" type="string" required="true">	
		<cfargument name="MSCcontenido" type="string" required="true">	
		<cfargument name="MSPAnombre" type="string" required="true">
		
		<cfquery name="rscontArea" datasource="sdc">
			select convert(varchar,MSCcontenido) as MSCcontenido, MSCtitulo
			from MSContenido
			where Scodigo = #Session.Scodigo#
			order by 2
		</cfquery>	
		
		<cfsavecontent variable="listaContenidosArea">
		<cfoutput>
		<div id='selectarea#area#' height='100px' >
			<strong>#Arguments.MSPAnombre#</strong>
			<select name="pagina#area#" style='font-size:8pt; font-face:arial; width:100%; '
                 onclick='javascript: clickPagina(this, #area#)'
                 onchange='javascript: clickPagina(this, #area#)' >
				<option value="">(ninguna)</option>
				<cfloop query="rscontArea">
					<option value="#rscontArea.MSCcontenido#" <cfif rscontArea.MSCcontenido EQ arguments.MSCcontenido>selected</cfif> >
					#rscontArea.MSCtitulo#</option>
				</cfloop>
			</select>
			</div>
            <iframe frameborder='0' border='0' id='contentarea#area#' height='100px' width='100%' 
			<cfif Len(Trim(arguments.MSCcontenido)) GT 0> src="SQLConstructorContenido.cfm?MSCcontenido=#arguments.MSCcontenido#"</cfif> >
             Visualizacion no disponible
			 </iframe>
		</cfoutput>
		</cfsavecontent>

		<cfreturn #listaContenidosArea#>				
	</cffunction>

	<cfquery name="rsMSPcodigo" datasource="sdc">
		select MSPcodigo
		from MSMenu 
		where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
		  and MSMmenu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMmenu#">	
	</cfquery>

	<cfif rsMSPcodigo.RecordCount EQ 0 >
		Esta opción de menú no tiene página relacionada.
		<cfabort>
	</cfif>
	<cfset MSPcodigo = rsMSPcodigo.MSPcodigo >
	
	<cfquery name="rsDatos" datasource="sdc">
		select MSPcodigo, convert(varchar,MSCcategoria) as MSCcategoria, MSPplantilla, MSPtitulo
		from MSPagina 
		where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
		  and MSPcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPcodigo#"> 
	</cfquery>

	<cfif rsDatos.RecordCount EQ 0 >
		<div align="center"><strong><font color="#FF0000" size="2">La página asociada a este menú no existe.</font></strong></div>
		<cfabort>
	</cfif>

	<cfset MSPcodigo    = rsDatos.MSPcodigo >	
	<cfset MSCcategoria = rsDatos.MSCcategoria >
	<cfset MSPplantilla = rsDatos.MSPplantilla >
	<cfset MSPtitulo    = rsDatos.MSPtitulo >

	<cfset MSPaginaAreaArray = ArrayNew(1) > <!--- para que los datos comiencen en el elemento 1 --->

	<cfquery name="rs" datasource="sdc">
		select convert(varchar,MSCcontenido) as MSCcontenido, MSPAnombre
		from MSPaginaArea
		where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
		  and MSPcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPcodigo#">
		order by MSPAarea	
	</cfquery>    

	<cfloop query="rs">
		<cfset obj = StructNew() >
		<cfset StructInsert(obj, "MSCcontenido", rs.MSCcontenido) >
		<cfset StructInsert(obj, "MSPAnombre", rs.MSPAnombre) >
		<cfset ArrayAppend(MSPaginaAreaArray,obj) >	
	</cfloop>

	<cfquery name="rsDatosPlantilla" datasource="sdc">
		select MSPtexto, MSPareas, MSPnombre
		from MSPlantilla 
		where MSPplantilla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPplantilla#">
	</cfquery>
	
	<cfif rsDatosPlantilla.RecordCount EQ 0 >
		<div align="center"><strong><font color="#FF0000" size="2">La plantilla asociada a la página de este menú no existe.</font></strong></div>		
		<cfabort>
	</cfif>

	<cfset MSPtexto  = rsDatosPlantilla.MSPtexto >
	<cfset MSPareas  = rsDatosPlantilla.MSPareas >
	<cfset MSPnombre = rsDatosPlantilla.MSPnombre >

	<cfset plantilla = MSPtexto>	

	<script language="JavaScript1.2">
		function validarConstructor(f)
		{
			var MSPareas = f.MSPareas.value, cnt1, cnt2;
			//alert(MSPareas);
			//return false;
			if (MSPareas >= 1) {
				for (n1 = 1; n1 <= MSPareas; n1++) {
					cnt1 = f["pagina" + n1]
					if (cnt1.value == "") {
						alert ("Por favor seleccione el contenido del menú '" + f.MSMtexto.value + "'.");
						cnt1.focus();
						return false;
					}
					for (n2 = 1; n2 <= MSPareas; n2++) {
						if (n1 != n2) {
							cnt2 = f["pagina" + n2]
							if (cnt1.value == cnt2.value) {
								alert("El contenido de las áreas " + n1 + " y " + n2 
									+ " está repetido.\r\nPor favor, seleccione"
									+ " contenidos distintos para áreas distintas.");
								cnt2.focus();
								return false;
							}
						}
					}
				}
			}
			
			return true;
		}
		
		
		function clickPagina(elem, numero)
		{
			// llenar el iframe
			var frameId = "contentarea" + numero;
			var theFrame = document.all ? document.all[frameId] : document.getElementById("frameId");
			
			if (theFrame != null) {
				var newsrc = '';
				window.status = 'value:' + elem.value + ';';
				
				if (elem.value != "") {
					newsrc = 'SQLConstructorContenido.cfm?MSCcontenido='
						+ escape(elem.value);
					window.status += ("newsrc:" + newsrc + ';');
				}
				if (theFrame.src != newsrc) {
					theFrame.src = newsrc;
				} else {
					window.status += ("/iguales: " + theFrame.src + " = " + newsrc + ';');
				}
			}
		}
	
	</script>

	<form name="form1" method="post" action="SQLConstructor.cfm" onSubmit="return validarConstructor(this);">

		<cfloop index="area" from="1" to="#MSPareas#">
			<cfset src = "AREA-" & area & "-" >
			
			<cfif area LE ArrayLen(MSPaginaAreaArray) >
				<cfset aux = MSPaginaAreaArray[area].MSCcontenido >
				<cfset aux2 = MSPaginaAreaArray[area].MSPAnombre >
			<cfelse>
				<cfset aux = "null" >
				<cfset aux2 = "null" >
			</cfif>

			<cfset dst = contArea(area, aux, aux2) >
			<cfset plantilla = Replace(plantilla,src,dst,"all")>
		</cfloop>


	<cfoutput>
	<style type='text/css'>
		 table.plantilla { 
			 width:100%; 
			 border:none; } 
		 td.plantilla {
			 height:120px;
			 border:none; 
			 vertical-align:top;
			 text-align:left; } 
		</style>
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
		  <tr>
			<td class="tituloMantenimiento">Asociar Men&uacute;es y P&aacute;ginas</td>
		  </tr>
		  <tr>
			<td>&nbsp;<strong>Men&uacute;:</strong>&nbsp;#Trim(Form.MSMtexto)#&nbsp;&nbsp;&nbsp;<strong>P&aacute;gina:</strong>&nbsp;#Trim(MSPcodigo)#</td>
		  </tr>		  
		</table>
		
		#plantilla#
		
	</cfoutput>
	
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
	<cfoutput>
	
	  <tr>
		<td><input name="MSPareas" type="hidden" value="#MSPareas#">
		<input name="MSPcodigo" type="hidden" value="#MSPcodigo#">		
		<input name="MSMmenu" type="hidden" value="#MSMmenu#">
		<input name="MSMtexto" type="hidden" value="#Form.MSMtexto#">
		</td>
		<td>&nbsp;</td>
	  </tr>
	  
	  <tr>
		<td colspan="2" align="center"><input name="Guardar" type="submit" value="Guardar"></td>
	  </tr>	  
	 </cfoutput> 
	</table>
	</form>

<cfelse>
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
		  <tr>
			<td class="tituloMantenimiento">Seleccione un Men&uacute; de la lista</td>
		  </tr>
		</table>
	
</cfif>