<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.txtAnotac") and not isdefined("Form.txtAnotac")>
	<cfparam name="Form.txtAnotac" default="#Url.txtAnotac#">
</cfif>	
<cfif isdefined("Url.RHAtipoFiltro") and not isdefined("Form.RHAtipoFiltro")>
	<cfparam name="Form.RHAtipoFiltro" default="#Url.RHAtipoFiltro#">
</cfif>

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

<cfif modo EQ "CAMBIO" and isdefined('form.DEid') and isdefined('form.RHAid')>
	<cfquery datasource="#Session.DSN#" name="rsAnotacion">
		select RHAid,
			DEid,
			RHAfecha,
			RHAdescripcion,
			RHAtipo
		from RHAnotaciones
		where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAid#">
		and DEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>	
</cfif>

<cfset filtroAnot = "">
<cfset navegacionAnot = "">
<cfset f_anot = "">
<cfset f_tipo = "">
<cfset navegacionAnot = navegacionAnot & Iif(Len(Trim(navegacionAnot)) NEQ 0, DE("&"), DE("")) & "o=4">

<cfif isdefined("Form.txtAnotac") and Len(Trim(Form.txtAnotac)) NEQ 0>
	<cfset filtroAnot = filtroAnot & " and upper(RHAdescripcion) like '%" & #UCase(Form.txtAnotac)# & "%'">
<!--- 	<cfset f_anot = "txtAnotac='" & Form.txtAnotac & "',"> --->
	<cfset f_anot = "'" & Form.txtAnotac & "' as txtAnotac,">
	<cfset navegacionAnot = navegacionAnot & Iif(Len(Trim(navegacionAnot)) NEQ 0, DE("&"), DE("")) & "txtAnotac=" & Form.txtAnotac>
</cfif>
<cfif isdefined("Form.RHAtipoFiltro") and form.RHAtipoFiltro NEQ -1>
	<cfset filtroAnot = filtroAnot & " and RHAtipo=" & Form.RHAtipoFiltro>
	<cfset f_tipo = "'" & Form.RHAtipoFiltro & " as RHAtipoFiltro" &  ",">		
	<cfset navegacionAnot = navegacionAnot & Iif(Len(Trim(navegacionAnot)) NEQ 0, DE("&"), DE("")) & "RHAtipoFiltro=" & Form.RHAtipoFiltro>
</cfif>
 <cfif isdefined("Form.DEid")>
	<cfset navegacionAnot = navegacionAnot & Iif(Len(Trim(navegacionAnot)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif> 
 <cfif isdefined("Form.sel")>
	<cfset navegacionAnot = navegacionAnot & Iif(Len(Trim(navegacionAnot)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
</cfif> 

<cfif modo EQ "CAMBIO">
	<script language="javascript" type="text/javascript">
		function funcImprimir() {
			var width = 650;
			var height = 400;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			<cfoutput>
			var params = "?DEid=#Form.DEid#&RHAid=#Form.RHAid#";
			</cfoutput>
			var nuevo = window.open('anotaciones-formulario.cfm'+params,'Anotaciones','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
			nuevo.focus();
			return false;
		}
	</script>
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Anotacion"
	Default="Anotaci&oacute;n"
	returnvariable="vAnotacion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Tipo"
	Default="Tipo"
	xmlfile="/rh/generales.xml"
	returnvariable="vTipo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Fecha"
	Default="Fecha"
	xmlfile="/rh/generales.xml"
	returnvariable="vFecha"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Positiva"
	Default="Positiva"
	returnvariable="vPositiva"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Negativa"
	Default="Negativa"
	returnvariable="vNegativa"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Texto_de_la_anotacion"
	Default="Texto de la anotaci&oacute;n"
	returnvariable="vTexto"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Imprimir"
	Default="Imprimir"
	xmlfile="/rh/generales.xml"
	returnvariable="vImprimir"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_El_texto_supera_la_cantidad_de_caracteres_permitidos"
	Default="El texto supera la cantidad de caracteres permitidos"
	returnvariable="LB_El_texto_supera_la_cantidad_de_caracteres_permitidos"/>

<table width="100%" border="0" cellspacing="0" cellpadding="0">	
	  <tr>
		<td>
			<cfinclude template="/rh/portlets/pEmpleado.cfm">
		</td>
	  </tr>
	  <tr>
		<td>
		  <table width="95%" border="0" cellspacing="0" cellpadding="0" style="margin-left: 10px; margin-right: 10px;">
			<tr> 
			  <td width="10%" align="center" valign="top">
				<table width="100%" border="0" cellspacing="3" cellpadding="3">
				  <tr>
					<td>
						<form name="formFiltroListaAnot" method="post" action="expediente-cons.cfm">
							<input type="hidden" name="DEid" value="<cfoutput>#form.DEid#</cfoutput>">
							<input name="sel" type="hidden" value="1">
							<input type="hidden" name="o" value="4">				
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
							  <tr> 
								<td class="fileLabel"><cfoutput>#vAnotacion#</cfoutput></td>
								<td class="fileLabel"><cfoutput>#vTipo#</cfoutput></td>
								<td rowspan="2">
									<input name="btnFiltrarAnot" type="submit" id="btnFiltrarAnot4" value="<cfoutput>#vFiltrar#</cfoutput>">
								</td>
							  </tr>
							  <tr> 
								<td><input name="txtAnotac" type="text" id="txtAnotac3" size="35" maxlength="260" value="<cfif isdefined('form.txtAnotac')><cfoutput>#form.txtAnotac#</cfoutput></cfif>"></td>
								<td><select name="RHAtipoFiltro" id="select7">
									<option value="-1" <cfif isdefined('form.RHAtipoFiltro') and form.RHAtipoFiltro EQ -1> selected</cfif>>--<cf_translate key="LB_Todos" xmlfile="/rh/generales.xml">Todos</cf_translate>--</option>
									<option value="1" <cfif isdefined('form.RHAtipoFiltro') and form.RHAtipoFiltro EQ 1> selected</cfif>><cfoutput>#vPositiva#</cfoutput></option>
									<option value="2" <cfif isdefined('form.RHAtipoFiltro') and form.RHAtipoFiltro EQ 2> selected</cfif>><cfoutput>#vNegativa#</cfoutput></option>
								  </select>
								</td>
							  </tr>
							</table>
						  </form>							
							</td>
						  </tr>
						  <tr>
							<td nowrap>
								<cfquery name="rsLista" datasource="#session.DSN#">
									select 	#PreserveSingleQuotes(f_anot)# 
											#PreserveSingleQuotes(f_tipo)# 
											RHAid, 
											DEid, 
											RHAfecha, 
											<cf_dbfunction name="string_part"   args="RHAdescripcion,1,25">  as RHAdescripcion,
											case when RHAtipo=1 then '#vPositiva#' when RHAtipo=2 then '#vNegativa#' end RHAtipo,
											4 as o,
											1 as sel
									from RHAnotaciones

									where  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">  

									<cfif isdefined("filtroAnot") and Len(trim(filtroAnot))>
										#PreserveSingleQuotes(filtroAnot)#
									</cfif>

									order by RHAfecha, RHAdescripcion
								</cfquery>
								
								<cfinvoke 
								 component="rh.Componentes.pListas"
								 method="pListaQuery"
								 returnvariable="pListaFam">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="RHAdescripcion,RHAfecha,RHAtipo"/>
									<cfinvokeargument name="etiquetas" value="#vAnotacion#,#vFecha#,#vTipo#"/>
									<cfinvokeargument name="formatos" value="V,D,V"/>
									<cfinvokeargument name="formName" value="listaAnotaciones"/>	
									
									<cfinvokeargument name="align" value="left,left,center"/>
									<cfinvokeargument name="ajustar" value="N"/>			
									<cfinvokeargument name="irA" value="expediente-cons.cfm"/>			
									<cfinvokeargument name="navegacion" value="#navegacionAnot#"/>
								</cfinvoke>							
								<!--- 
								<cfinvoke 
								 component="rh.Componentes.pListas"
								 method="pListaRH"
								 returnvariable="pListaFam">
									<cfinvokeargument name="tabla" value="RHAnotaciones"/>
									<!--- <cfinvokeargument name="columnas" value="#f_anot# #f_tipo# RHAid, DEid, RHAfecha,(case when datalength(RHAdescripcion) > 25 then substring(RHAdescripcion,1,25) || '...' else substring(RHAdescripcion,1,25) end) as RHAdescripcion, case when RHAtipo=1 then 'Positiva' when RHAtipo=2 then 'Negativa' end RHAtipo,3 as o,1 as sel"/> --->
									<cfinvokeargument name="columnas" value="#f_anot# #f_tipo# RHAid, DEid, RHAfecha, substring(RHAdescripcion,1,25) as RHAdescripcion, case when RHAtipo=1 then 'Positiva' when RHAtipo=2 then 'Negativa' end RHAtipo,3 as o,1 as sel"/>
									<cfinvokeargument name="desplegar" value="RHAdescripcion,RHAfecha,RHAtipo"/>
									<cfinvokeargument name="etiquetas" value="Anotacion,Fecha,Tipo"/>
									<cfinvokeargument name="formatos" value="V,D,V"/>
									<cfinvokeargument name="formName" value="listaAnotaciones"/>	
									<cfinvokeargument name="filtro" value="DEid=#form.DEid# #filtroAnot# order by RHAdescripcion"/>
									<cfinvokeargument name="align" value="left,left,center"/>
									<cfinvokeargument name="ajustar" value="N"/>			
									<cfinvokeargument name="irA" value="expediente-cons.cfm"/>			
									<cfinvokeargument name="navegacion" value="#navegacionAnot#"/>
								</cfinvoke>
								--->
							</td>
						  </tr>
						</table>
				  </td>
				  <td valign="top" nowrap> 
					<form method="post" enctype="multipart/form-data" name="formAnotacionesEmpl" action="SQLanotaciones.cfm">
						<input type="hidden" name="DEid" value="<cfoutput>#form.DEid#</cfoutput>">
						<input type="hidden" name="RHAid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsAnotacion.RHAid#</cfoutput></cfif>">
						  <table width="100%" border="0" cellspacing="6" cellpadding="0">
							<tr> 
							  <td colspan="2" class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>" style="padding-left: 5px;"><cf_translate key="LB_Datos_de_la_anotacion">Datos de la anotaci&oacute;n</cf_translate></td>
							</tr>
							<tr> 
							  <td width="250" class="fileLabel"><cfoutput>#vFecha#</cfoutput></td>
							  <td width="549" class="fileLabel"><cfoutput>#vTipo#</cfoutput></td>
							</tr>
							<tr> 
							  <td> <cfif modo NEQ 'ALTA'>
								  	<cfset fecha = LSDateFormat(rsAnotacion.RHAfecha, "DD/MM/YYYY")>
								  <cfelse>
								  	<cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>
								  </cfif> 
								  <cf_sifcalendario form="formAnotacionesEmpl" value="#fecha#" name="RHAfecha"> 
							  </td>
							  <td>
								<select name="RHAtipo" id="RHAtipo">
								  <option value="1" <cfif modo NEQ 'ALTA' and rsAnotacion.RHAtipo EQ 1> selected</cfif>><cfoutput>#vPositiva#</cfoutput></option>
								  <option value="2" <cfif modo NEQ 'ALTA' and rsAnotacion.RHAtipo EQ 2> selected</cfif>><cfoutput>#vNegativa#</cfoutput></option>
								</select>							  
							  </td>
							</tr>
							<tr> 
							  
                 			 <td class="fileLabel"><cfoutput>#vTexto#</cfoutput></td>
							  <td class="fileLabel">&nbsp;</td>
							</tr>
							<tr> 
							  <td colspan="2" align="center"> <div align="left">
							     <textarea name="RHAdescripcion" cols="60" rows="10" id="textarea"  onkeyup="ok(1023,this)"><cfif modo NEQ 'ALTA'><cfoutput>#rsAnotacion.RHAdescripcion#</cfoutput></cfif></textarea> 
						      </div></td>
							</tr>
							<tr> 
							  <td colspan="2" align="center"> 
							  	<cfif modo EQ "CAMBIO">
									<cf_botones modo="#modo#" includebefore="Imprimir" includebeforevalues="#vImprimir#">
								<cfelse>
									<cf_botones modo="#modo#">
								</cfif>
							  </td>
							</tr>
						  </table>
					</form>
				  </td>
				</tr>	
			  </table>
		
      
    </td>
	  </tr>
	</table>
  
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js">//</script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/javascript">
//------------------------------------------------------------------------------------------
 function ok(maxchars,obj) {
 if(obj.value.length > maxchars) {
   alert('<cfoutput>#LB_El_texto_supera_la_cantidad_de_caracteres_permitidos#</cfoutput>' )
   	obj.value = obj.value.substring(0,maxchars) 
   
   }
}	
	
	
	function deshabilitarValidacion(){
		objForm.RHAfecha.required = false;
		objForm.RHAtipo.required = false;
		objForm.RHAdescripcion.required = false;
	}
//------------------------------------------------------------------------------------------
	function habilitarValidacion(){
		objForm.RHAfecha.required = true;
		objForm.RHAtipo.required = true;
		objForm.RHAdescripcion.required = true;
	}
//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formAnotacionesEmpl");
	
	<cfoutput>
	objForm.RHAfecha.required = true;
	objForm.RHAfecha.description = "#vFecha#";	
	objForm.RHAtipo.required = true;
	objForm.RHAtipo.description = "#vTipo#";
	objForm.RHAdescripcion.required = true;
	objForm.RHAdescripcion.description = "#vTexto#";	
	</cfoutput>
</script>