<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfset modo='ALTA'>
<cfif isdefined("form.CMNid") and len(trim(form.CMNid))>
	<cfset modo = 'CAMBIO'> 
</cfif>

<cfif modo NEQ 'ALTA'>
    <cfquery name = "rsCantDias" datasource="#session.DSN#">
		select sum(CMNdiasDuracion) as DiasDur
		from   CMNotas
		where  CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value= "#session.compras.procesoCompra.CMPid#">
			and CMNid < <cfqueryparam cfsqltype="cf_sql_numeric" value= "#form.CMNid#">
	</cfquery>
	<cfquery name = "rsdata" datasource="#session.DSN#">
		select CMNid,CMTPAid, CMNnota, CMNtipo, CMNresp, CMNtel,CMNestado, CMNdiasDuracion,CMNfechaIni,CMNfechaFin, CMNemail,ts_rversion
		from   CMNotas
		where  CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value= "#session.compras.procesoCompra.CMPid#">
			and CMNid = <cfqueryparam cfsqltype="cf_sql_numeric" value= "#form.CMNid#">
	</cfquery>		
</cfif>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>


<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top" width="50%">
			<cfquery name="rsProcesoCompra" datasource="#Session.DSN#">
				select 
					CMPfechapublica,
					fechaalta
				from CMProcesoCompra
				where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
				and Ecodigo =  #Session.Ecodigo# 
			</cfquery>
			
			<cfif modo neq 'ALTA' and rsdata.CMNdiasDuracion neq 0>
				  <cfset LvarFechaBase = LSDateFormat(rsProcesoCompra.fechaalta, 'dd/mm/yyyy') >

				  <cfif rsCantDias.DiasDur neq ''>
				     <cfset LvarFecha= rsCantDias.DiasDur>					
				  <cfelse>
 				     <cfset LvarFecha= 0>
				  </cfif>
				  
				   <cfset LvarFechaInicial = DateAdd("d",#LvarFecha#,#LvarFechaBase#)>	
				   <cfset LvarFechaFinal =DateAdd("d",#rsdata.CMNdiasDuracion#,#LvarFechaInicial#)>
				   		   						
			</cfif>		
		    <cfquery name="rsNotasE" datasource="#Session.DSN#">
				select * 
				from   CMNotas 
				where  CMPid = <cfqueryparam cfsqltype = "cf_sql_numeric" value = "#session.compras.procesoCompra.CMPid#" >		 						
			</cfquery>

		     <cfquery name="rsEstados" datasource="#Session.DSN#">
				select count (1) cant 				 
				from   CMNotas 
				where  CMPid = <cfqueryparam cfsqltype = "cf_sql_numeric" value = "#session.compras.procesoCompra.CMPid#" >
				and CMNestado = 1				
			</cfquery>
			<cfif rsEstados.cant eq 0 and rsNotasE.recordcount gt 0>

                <cfquery name="rsMinCMNid" datasource="#Session.DSN#">
					select min(CMNid) as MinCMNid				 
					from   CMNotas 
					where  CMPid = <cfqueryparam cfsqltype = "cf_sql_numeric" value = "#session.compras.procesoCompra.CMPid#" >			
			    </cfquery>
			 	<cfquery name="rsUpdateEstado" datasource="#Session.DSN#">
					Update CMNotas 
					set CMNestado = 1				
					where  CMPid = <cfqueryparam cfsqltype = "cf_sql_numeric" value = "#session.compras.procesoCompra.CMPid#" >
					and CMNid = <cfqueryparam cfsqltype = "cf_sql_numeric" value = "#rsMinCMNid.MinCMNid#" >				
				</cfquery>		   
			</cfif>
			<cfquery name="rsNotas" datasource="#Session.DSN#">
				select CMNid, CMNtipo, CMNresp,CMNtel,CMNemail, 'Notas' as btnNotas, 
				case CMNestado 
				 when 0 then
				    'Cerrado'
				 when 1 then 
				    'Abierto'
				end		
				 as Estado,
				 <cf_dbfunction name="to_sdateDMY" args="CMNfechaIni"> as CMNfechaIni,
				 <cf_dbfunction name="to_sdateDMY" args="CMNfechaFin">  as CMNfechaFin
				from   CMNotas 
				where  CMPid = <cfqueryparam cfsqltype = "cf_sql_numeric" value = "#session.compras.procesoCompra.CMPid#" >
				order by CMNid Asc
			</cfquery>
         	<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsNotas#"/>
				<cfinvokeargument name="desplegar" value="CMNtipo,Estado, CMNresp,CMNfechaIni,CMNfechaFin"/>
				<cfinvokeargument name="etiquetas" value="Tipo Nota,Estado, Responsable,Fecha Inicio, Fecha Fin"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="align" value="left,left, left,left,left"/>
				<cfinvokeargument name="ajustar" value="N,N,N,N,N"/>
				<cfinvokeargument name="irA" value="compraProceso.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="CMNid"/>
		  </cfinvoke>

		</td>
		<td>
		<cfoutput>
		<form name="form1" method="post" action="compraProceso-notas-SQL.cfm" >
			<input type="hidden" name="opt" value="">
			<cfif modo NEQ 'ALTA'>
				<input type = "hidden" name="CMNid" value="#rsdata.CMNid#">
			</cfif>	
			<table width="100%" border="0">
				<tr>
					<td align="right" nowrap><strong>Tipo Nota: </strong></td>	
					<td>
					    <cfif modo neq 'ALTA' and #rsdata.CMTPAid# neq ''>
      					      <strong><cfdump var="#rsdata.CMNtipo#"></strong>
					     <cfelseif modo neq 'ALTA'>
	       				    <input name="CMNtipo" type="text" size="40" maxlength="40"  value="#rsdata.CMNtipo#">
     					<cfelseif modo eq 'ALTA'>
						    <input name="CMNtipo" type="text" size="40" maxlength="40"  value=""> 
						</cfif>
					</td>	
				</tr>
				<tr>
					<td align="right" nowrap><strong>Responsable: </strong> </td>	
					<td><input name="CMNresp" type="text" size="40" maxlength="120" value="<cfif modo neq 'ALTA'>#rsData.CMNresp#</cfif>"></td>	
				</tr>			
				<tr>
					<td align="right" nowrap><strong>Teléfono: </strong> </td>	
					<td><input name="CMNtel" type="text" size="20" maxlength="40" value="<cfif modo neq 'ALTA'>#rsData.CMNtel#</cfif>"></td>	
				</tr>									
				<tr>
					<td align="right" nowrap><strong>E-mail: </strong> </td>	
					<td><input name="CMNemail" type="text" size="20" maxlength="120" value="<cfif modo neq 'ALTA'>#rsData.CMNemail#</cfif>"></td>	
				</tr>
				<tr>
					<td align="right" nowrap><strong>Estado: </strong> </td>	
					<td>
					<select name="CMNestado">
					  <option value="1" <cfif modo neq 'ALTA' and #rsdata.CMNestado# eq 1> Selected</cfif> > Abierto</option>
					  <option value="0" <cfif modo neq 'ALTA' and #rsdata.CMNestado# eq 0> Selected<cfelseif modo eq 'ALTA'> Selected</cfif>>Cerrado</option>
				    </select>
					</td>	
				</tr>
				<tr>
					<td align="right" nowrap><strong>Tiempo Estimado: </strong> </td>	
					<td>
					<!---<input name="CMNdiasDuracion" type="text" size="10"  value="<cfif modo neq 'ALTA'>#rsData.CMNdiasDuracion#</cfif>">--->
				 <cfif modo neq 'ALTA'>
			        <cfset LvarValue= rsdata.CMNdiasDuracion>
			     <cfelse>
				   <cfset LvarValue= 0>
			      </cfif>
			    <cf_inputNumber name="CMNdiasDuracion"  value="#LvarValue#" enteros="6" decimales="0" negativos="false" comas="no">
					</td>	
				</tr>
				<tr>
				  <td align="right"><strong>Fecha Inicio:</strong></td>
			      <td>
				   <cfif modo neq 'ALTA'>
				  	  <cfif isdefined('rsData.CMNfechaIni') and len(trim(#rsData.CMNfechaIni#)) eq 0 and rsdata.CMNdiasDuracion neq 0>
				   	    <cfset LvarMostrarFIni= LvarFechaInicial>
				   	  <cfelse>
				        <cfset LvarMostrarFIni= rsData.CMNfechaIni>       
				      </cfif>				   
					     <cf_sifcalendario form="form1" value="#LSDateFormat(LvarMostrarFIni,'dd/mm/yyyy')#" name="CMNfechaIni" tabindex="1">
				   <cfelse>
				         <cf_sifcalendario form="form1" value="" name="CMNfechaIni" tabindex="1">
				   </cfif>
				  </td> 
				</tr>
				<tr>
				  <td align="right"><strong>Fecha Real Final:</strong></td>
			      <td>				 
				   <cfif modo neq 'ALTA'>
				   		   <cfif isdefined('rsData.CMNfechaFin') and len(trim(#rsData.CMNfechaFin#)) eq 0 and rsdata.CMNdiasDuracion neq 0> 
							 <cfset LvarMostrarFFIn= LvarFechaFinal>
						   <cfelse>
							 <cfset LvarMostrarFFIn= rsData.CMNfechaFin>       
						   </cfif>				   
				          <cf_sifcalendario form="form1" value="#LSDateFormat(LvarMostrarFFIn,'dd/mm/yyyy')#" name="CMNfechaFin" tabindex="1">
				   <cfelse>
				          <cf_sifcalendario form="form1" value="" name="CMNfechaFin" tabindex="1">
				   </cfif>
				  </td> 
				</tr>
				<tr>
				<cfif isdefined("rsdata.CMNid") and Len(Trim(rsdata.CMNid))>
				    <td nowrap align="center"><strong>Adjuntar Dctos </strong> <br />
				      <input  name="AlmObjecto" value="Almacenar Objetos" onClick="javascript:AlmacenarObjetos('#rsdata.CMNid#');" type="image" src="../../imagenes/ftv2folderopen.gif">			      
			    	</td>
				    <td nowrap align="center"><strong>Enviar Correo </strong> <br />
					<cfif len(rtrim(#rsdata.CMNresp#)) eq 0 > 
	                   <span class="style1">* Falta Responsable</span> </br>  	
					</cfif>   			
					<cfif len(rtrim(#rsdata.CMNfechaIni#)) eq 0 or #rsdata.CMNfechaIni# eq '' >
					    <span class="style1">* Falta Fecha Inicio</span> </br>
					</cfif>
					<cfif len(rtrim(#rsdata.CMNemail#)) eq 0 or #rsdata.CMNemail# eq ''>
					    <span class="style1">* Falta E-mail</span> </br>     				
					</cfif>
					<cfif len(rtrim(#rsdata.CMNresp#)) neq 0 and len(rtrim(#rsdata.CMNfechaIni#)) neq 0 and  len(rtrim(#rsdata.CMNemail#)) neq 0>
					  <input name="EnviaMail" value="Enviar Correo" onClick="javascript:EnviaMail('#rsdata.CMNid#');" type="image" src="../../imagenes/E-Mail Link.gif">
					</cfif>
					</td>
				</cfif>	
				</tr>
				<tr>
					<td colspan="2" align="center">
<!--*******************************Editor TEXTO************************************-->						
					<textarea name="CMNnota" id="CMNnota" rows="15" style="width: 100%"><cfoutput><cfif modo EQ 'CAMBIO'>#rsdata.CMNnota#</cfif></cfoutput></textarea>
						<script language="Javascript1.2">
							<!-- // load htmlarea
							_editor_url = "/cfmx/sif/Utiles/htmlarea/";  // URL to htmlarea files
							var win_ie_ver = parseFloat(navigator.appVersion.split("MSIE")[1]);
							if (navigator.userAgent.indexOf('Mac')        >= 0) { win_ie_ver = 0; }
							if (navigator.userAgent.indexOf('Windows CE') >= 0) { win_ie_ver = 0; }
							if (navigator.userAgent.indexOf('Opera')      >= 0) { win_ie_ver = 0; }
							if (win_ie_ver >= 5.5) {
							  document.write('<scr' + 'ipt src="' +_editor_url+ 'editor.js"');
							  document.write(' language="Javascript1.2"></scr' + 'ipt>');  
							} else { document.write('<scr'+'ipt>function editor_generate() { return false; }</scr'+'ipt>'); }
							// --> 
						</script>
						<script language="javascript1.2">
							var config = new Object();    // create new config object	
							config.width = "100%";
							config.height = "200px";
							config.bodyStyle = 'background-color: white; font-family: "Verdana"; font-size: x-small;';
							config.debug = 0;
							// NOTE:  You can remove any of these blocks and use the default config!
							config.toolbar = [
								['fontname'],
								['fontsize'],
								['fontstyle'],
								['linebreak'],
								['bold','italic','underline','separator'],
							//  ['strikethrough','subscript','superscript','separator'],
								['justifyleft','justifycenter','justifyright','separator'],
								['OrderedList','UnOrderedList','Outdent','Indent','separator'],
								['forecolor','backcolor','separator'],
								['HorizontalRule','Createlink','InsertImage','InsertTable','htmlmode'],
							//	['about','help','popupeditor'],
							];
							config.fontnames = {
								"Arial":           "arial, helvetica, sans-serif",
								"Courier New":     "courier new, courier, mono",
								"Georgia":         "Georgia, Times New Roman, Times, Serif",
								"Tahoma":          "Tahoma, Arial, Helvetica, sans-serif",
								"Times New Roman": "times new roman, times, serif",
								"Verdana":         "Verdana, Arial, Helvetica, sans-serif",
								"impact":          "impact",
								"WingDings":       "WingDings"
							};
							config.fontsizes = {
								"1 (8 pt)":  "1",
								"2 (10 pt)": "2",
								"3 (12 pt)": "3",
								"4 (14 pt)": "4",
								"5 (18 pt)": "5",
								"6 (24 pt)": "6",
								"7 (36 pt)": "7"
							  };
							//config.stylesheet = "http://www.domain.com/sample.css";
							config.fontstyles = [   // make sure classNames are defined in the page the content is being display as well in or they won't work!
							  { name: "headline",     className: "headline",  classStyle: "font-family: arial black, arial; font-size: 28px; letter-spacing: -2px;" },
							  { name: "arial red",    className: "headline2", classStyle: "font-family: arial black, arial; font-size: 12px; letter-spacing: -2px; color:red" },
							  { name: "verdana blue", className: "headline4", classStyle: "font-family: verdana; font-size: 18px; letter-spacing: -2px; color:blue" }
							// leave classStyle blank if it's defined in config.stylesheet (above), like this:
							//  { name: "verdana blue", className: "headline4", classStyle: "" }  
							];				
							editor_generate('CMNnota', config);
						</script>
<!--*******************************Editor TEXTO************************************-->
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<cfinclude template="../../portlets/pBotones.cfm">
						<input name="btnRegresar" type="button" class="btnAnterior" value="Regresar" onClick="javascript:location.href='compraProceso.cfm'" ></td>	
				</tr>
			</table>
			<cfif modo NEQ "ALTA">
				<cfset ts = "">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsdata.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name = "ts_rversion" value ="#ts#">
			</cfif>
		</form> 
		</cfoutput>		
		</td>
	</tr>
</table>
<cfoutput>
<script language="javascript">

		
	objForm = new qForm("form1");
   	qFormAPI.errorColor = "##FFFFCC";
	
	objForm.CMNtipo.required = true;
	objForm.CMNtipo.description="Tipo de nota";

	objForm.CMNresp.required = true;
	objForm.CMNresp.description="Responsable";
	
		
	function AlmacenarObjetos(valor){			
		if (valor != "") {			
			document.form1.action = 'ObjetosCompras.cfm?NotaId='+valor;
			objForm.CMNresp.required = false;
				objForm.CMNtipo.required = false;
			document.form1.submit();
		}
		return false;
	}
	
		function EnviaMail(valor){			
		if (valor != "") {			
			document.form1.action = 'MailCompras.cfm?NotaId='+valor;
			    objForm.CMNresp.required = false;
				objForm.CMNtipo.required = false;
			document.form1.submit();
		}
		return false;
	}	
	
	function deshabilitarValidacion(){
		objForm.CMNtipo.required = false;
		objForm.CMNresp.required = false;
	
	}

</script>
</cfoutput>


		