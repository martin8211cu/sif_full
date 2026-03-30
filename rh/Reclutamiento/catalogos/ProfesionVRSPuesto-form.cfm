		<cfif not REFind('erp.css',session.sitio.CSS)>
		  <cfinclude template="/eticket/libs.cfm">
		</cfif>
			
		<cfparam name="form.tabselect" default="1">
		<cfset session.setFiltroPuesto='0'>
 		<style type="text/css">
		.imgLoad {background:url("/cfmx/plantillas/Cloud/images/ajax-loader.gif") no-repeat 0 0;cursor:pointer;height: 16px;margin-right: 0px;width: 16px;vertical-align:middle;display:inline-block;}
 		</style>
			<i class="imgLoad" id="msjSave" style="display:none;position:absolute;z-index:99"></i>
 			<script language="javascript" type="text/javascript">
				var idSeleccionado='';

				function fnSetFiltroSession(){
					$.ajax("ProfesionVRSPuesto-SQL.cfm", {
				    	"type": "post",   
				    	"success": function(result) {
				    		//fnGridReload2();
				    	},
					    "error": function(result) {
					    //	fnShowMessage("msjError");
					    },
					    "complete":function(result) {
					    	//fnGridReload2();
					    },
					    "beforeSend":function(result) {
					    //	PopUpAbrir4();
					    },
					    "data": {setFiltroPuesto: idSeleccionado},
					    "async": false,
					});
				}


				function fnAgregarQuitar(i,e){
					var p = $(i);
					var offset = p.offset();
					
					$.ajax("ProfesionVRSPuesto-SQL.cfm", {
				    	"type": "post",   
				    	"success": function(result) {
				    	//	fnShowMessage("msjRstDel"); 
				    	},
					    "error": function(result) {
					    //	fnShowMessage("msjError");
					    },
					    "complete":function(result) {
					    	$('#msjSave').hide(1000);
					    	$(i).show(500);
					    },
					    "beforeSend":function(result) {
					    	$(i).hide(); 
							$('#msjSave').css({left: offset.left,top: offset.top}).show();
					    },
					    <cfif form.tabselect eq 1>
					     	"data": {modo:'update',RHOPid: e,RHPcodigo:idSeleccionado},
						<cfelse>	
						 	"data": {modo:'update',RHOPid: idSeleccionado,RHPcodigo:e},
						</cfif>
					   
					    "async": false,
					});
				}

				function fnClickSelect(e){console.log(e);
					$("#mensaje").hide();
					$("#divPuestoShow").show();
					<cfif form.tabselect eq 1>
						$("#divNombre").html('<h4>'+$("#list1 #"+e+" td:nth-child(1) span").html()+' - '+$("#list1 #"+e+" td:nth-child(2) span").html()+'</h4>').show();
					<cfelse>
						$("#divNombre").html('<h4>'+$("#list3 #"+e+" td:nth-child(1) span").html()+'</h4>').show();
					</cfif>
					idSeleccionado = e;
					fnSetFiltroSession();
					<cfif form.tabselect eq 1>
						fnGridReload2();
					<cfelse>	
						fnGridReload4();
					</cfif>
				}

				function tab_set_current(e){
					document.setTab.tabselect.value=e;
					document.setTab.submit();
				}
			</script>
			<!----- traduccion de etiquetas---->
			<cfset t = createObject("component", "sif.Componentes.Translate")>
			<cfset LB_PuestosInternos = t.translate('LB_PuestosInternos','Puestos Internos')>
			<cfset LB_PuestosInternosAsociados = t.translate('LB_PuestosInternosAsociados','Puestos Internos asociados')>
			<cfset LB_PuestosExternos = t.translate('LB_PuestosExternos','Puestos Externos')>
			<cfset LB_PuestosExternosAsociados = t.translate('LB_PuestosExternosAsociados','Puestos Externos asociados')>
			<cfset LB_SeleccionePrimeroUnPuestoInternoDeLaLista = t.translate('LB_SeleccionePrimeroUnPuestoInternoDeLaLista','Seleccione primero un Puesto Interno de la lista')>
			<cfset LB_SeleccionePrimeroUnPuestoExternoDeLaLista = t.translate('LB_SeleccionePrimeroUnPuestoExternoDeLaLista','Seleccione primero un Puesto Externo de la lista')>

			<form id="setTab" name="setTab" action="" method="post">
				<input type="hidden" name="tabselect" id="tabselect" value="1">
			</form>	
			
			<!----- traduccion de datos------>
			<cfif not StructKeyExists(session, "gridTranslatedataCols")>
			  <cfset session.gridTranslatedataCols= structNew()>
			</cfif>
			<cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="gestLvarRHPdescpuesto">
			<cfset session.gridTranslatedataCols["gestLvarRHPdescpuesto"]= gestLvarRHPdescpuesto>
			<cfset LvarStrings = ArrayNew(1)>		 
				<cfset a = structNew()>
			<cfset a.valor1="'999'">
			<cfset a.valor2 ="##session.gridTranslatedataCols['gestLvarRHPdescpuesto']##">
			<cfset arrayAppend(LvarStrings, a)> 

			<cfset session.gridTranslatedataCols["LvarRHPdescpuestoSuf"]= 'a.RHPdescpuesto'>
			<cfif isdefined("request.useTranslateData") and request.useTranslateData eq 1>
				<cfset session.gridTranslatedataCols["LvarRHPdescpuestoSuf"] &= '_#session.idioma#'>
			</cfif>


			<cfset a = structNew()>
			<cfset a.valor1="'9101'">
			<cfset a.valor2 ="'<cf_translate key='LB_Si' xmlfile='/rh/generales.xml'>Si</cf_translate>'">
			<cfset arrayAppend(LvarStrings, a)>
			<cfset a = structNew()>
			<cfset a.valor1="'9102'">
			<cfset a.valor2 ="'<cf_translate key='LB_No' xmlfile='/rh/generales.xml'>No</cf_translate>'">
			<cfset arrayAppend(LvarStrings, a)>

				<cfquery datasource="#session.dsn#" name="rsAgregado">
					select null as value, '- #LB_Todos# -' as description,  1 as ord from dual
					union
					select 1 as value, '#LB_Si#' as description,  2 as ord from dual
					union
					select 0 as value, '#LB_No#' as description,  3 as ord from dual
				</cfquery>	

				<cf_tabs width="100%">
					<!---- tab de interno hace referencia a los puestos de RHPuestos, esto se asociarán a los oficios externos---->
					<cf_tab text="#LB_PuestosInternos#" selected="#form.tabselect eq 1#">
						<cfif form.tabselect eq 1>
							<div class="row">
								
	        					<div class="col-md-6">	
	        						<div class="well">
	        						<fieldset>
	        						<legend><cfoutput>#LB_PuestosInternos#</cfoutput></legend>
	        						<cf_translatedata name="get" tabla="RHPuestos" col="a.RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
				 					<cfinvoke component="commons.Componentes.Grid" method="PlistaJquery">
										<cfinvokeargument name="rowList"  value="10,50,100" >
								        <cfinvokeargument name="IrA"  value="">
								        <cfinvokeargument name="caption"  value=""> 
								        <cfinvokeargument name="etiquetas"  value="#LB_Codigo#,#LB_Descripcion#,#LB_Asociado#">
										<cfinvokeargument name="columnas"   value="distinct rtrim(ltrim(a.RHPcodigo)) as RHPcodigo, '999' as RHPdescpuesto, case when rtrim(a.RHPcodigo) = rtrim(b.RHPcodigo) then '9101' else '9102' end as procesar">
										<cfinvokeargument name="tabla"   value="RHPuestos a
																				 left join RHOPuestoEquival  b
																					on rtrim(a.RHPcodigo) = rtrim(b.RHPcodigo)
																					">  
						                <cfinvokeargument name="filtro"   value="Ecodigo = #session.Ecodigo#"> 
						                <cfinvokeargument name="desplegar"   value="RHPcodigo,RHPdescpuesto,procesar">
						      			<cfinvokeargument name="formato"     value="string,string,int">
						      			<cfinvokeargument name="mostrarFiltroColumnas" value="true,true,true"> 
						      			<cfinvokeargument name="width"      value="100,300,100">
						      			<cfinvokeargument name="sortname"       value="RHPdescpuesto">
						      			<cfinvokeargument name="sortorder"      value="desc">
						      			<cfinvokeargument name="key"          value="RHPcodigo">
						      			<cfinvokeargument name="rowNum"        value="10">
						      			<cfinvokeargument name="PageIndex"      value="1">
						      			<cfinvokeargument name="ModoProgramador"  value="false">
						      			<cfinvokeargument name="fnClick"      value="fnClickSelect">
						      			<cfinvokeargument name="rsprocesar"      value="#rsAgregado#">
						      			<cfinvokeargument name="DefaultValueprocesar"      value="">
	                              		<cfinvokeargument name="PreFiltroprocesar"   value="case when rtrim(a.RHPcodigo) = rtrim(b.RHPcodigo) then 1 else 0 end = ">
	                              		<cfinvokeargument name="PreFiltroRHPcodigo"   value=" rtrim(a.RHPcodigo) like ">
						      			<cfinvokeargument name="columnasReplace"    value="#LvarStrings#">
						      			<cfinvokeargument name="sortname"       value="3">
						      			<cfinvokeargument name="PreFiltroRHPdescpuesto"   value=" upper(rtrim(##session.gridTranslatedataCols['LvarRHPdescpuestoSuf']##)) like ">
						      			<cfinvokeargument name="sortorder"       value="desc">
					      			</cfinvoke>
					      			</fieldset>
	        						</div>
	        					</div>	
	       						<div class="col-md-6" >
	       							<div class="well">
	        						<fieldset>
	        						<legend><cfoutput>#LB_PuestosExternosAsociados#</cfoutput><div id="divNombre" style="display:none"></div></legend>

	        						<div id="mensaje" align="center" class="alert alert-dismissable alert-success"><cfoutput>#LB_SeleccionePrimeroUnPuestoInternoDeLaLista#</cfoutput></div>
	        						<div id="divPuestoShow" style="display:none" align="center">

									<cf_dbfunction name="to_char" args="a.RHOPid" returnvariable="LvarRHOPid">
										
									<cfinvoke component="commons.Componentes.Grid" method="PlistaJquery">
										<cfinvokeargument name="rowList"  value="10,50" >
								        <cfinvokeargument name="IrA"  value="">
								        <cfinvokeargument name="caption"  value=""> 
								        <cfinvokeargument name="etiquetas"  value="#LB_Descripcion#,#LB_Asociado#">
										<cfinvokeargument name="columnas"   value="distinct a.RHOPid, '<input type=checkbox ' + 
																				   case when '##session.setFiltroPuesto##' = rtrim(ltrim(b.RHPcodigo)) then
																				   		 'checked=checked ' 
																				  	else '' 
																				  	end +
																				  	' onclick=fnAgregarQuitar(this,'+#LvarRHOPid#+')>'
																				  	as procesar,
																				   RHOPDescripcion, case when '##session.setFiltroPuesto##' = rtrim(ltrim(b.RHPcodigo)) then 1 else 0 end as ordenar ">
										<cfinvokeargument name="tabla"   value="RHOPuesto a
																				 left join RHOPuestoEquival  b
																					on a.RHOPid = b.RHOPid">  
						                <cfinvokeargument name="filtro"   value=" a.CEcodigo = #Session.CEcodigo#"> 
						                <cfinvokeargument name="desplegar"   value="RHOPDescripcion,procesar">
						      			<cfinvokeargument name="formato"     value="string,int">
						      			<cfinvokeargument name="mostrarFiltroColumnas" value="true,true"> 
						      			<cfinvokeargument name="width"      value="250,100">
						      			<cfinvokeargument name="sortname"       value="4">
						      			<cfinvokeargument name="sortorder"       value="desc">
						      			<cfinvokeargument name="key"          value="RHOPid">
						      			<cfinvokeargument name="rowNum"        value="10">
						      			<cfinvokeargument name="PageIndex"      value="2">
						      			<cfinvokeargument name="ModoProgramador"  value="false">
						      			<cfinvokeargument name="rsprocesar"      value="#rsAgregado#">
						      			<cfinvokeargument name="DefaultValueprocesar"      value="">
	                              		<cfinvokeargument name="PreFiltroprocesar"   value=" case when '##session.setFiltroPuesto##' = rtrim(ltrim(RHPcodigo)) then  1 else 0 end = ">
					      			</cfinvoke>
					      			</div>
					      			</fieldset>
					      			</div>
							    </div>
							</div>
						</cfif>
					</cf_tab>
					<cf_tab text="#LB_PuestosExternos#" selected="#form.tabselect eq 2#">
						<cfif form.tabselect eq 2>
							<div class="row">
	        					<div class="col-md-6">
	        						<div class="well" >
	        						<fieldset >
	        						<legend><cfoutput>#LB_PuestosExternos#</cfoutput></legend>
				 					<cfinvoke component="commons.Componentes.Grid" method="PlistaJquery">
										<cfinvokeargument name="rowList"  value="10,50,100" >
								        <cfinvokeargument name="IrA"  value="">
								        <cfinvokeargument name="caption"  value=""> 
								        <cfinvokeargument name="etiquetas"  value="Descripcion,#LB_Asociado#">
										<cfinvokeargument name="columnas"   value="distinct a.RHOPid,RHOPDescripcion,case when a.RHOPid = b.RHOPid then '9101' else '9102' end as procesar">
										<cfinvokeargument name="tabla"   value="RHOPuesto a
																				left join RHOPuestoEquival  b
																					on a.RHOPid = b.RHOPid">  
						                <cfinvokeargument name="filtro"   value="CEcodigo = #Session.CEcodigo#"> 
						                <cfinvokeargument name="desplegar"   value="RHOPDescripcion,procesar">
						      			<cfinvokeargument name="formato"     value="string,int">
						      			<cfinvokeargument name="mostrarFiltroColumnas" value="true,true"> 
						      			<cfinvokeargument name="width"      value="350,100">
						      			<cfinvokeargument name="sortname"       value="3">
						      			<cfinvokeargument name="sortorder"      value="desc,2 asc">
						      			<cfinvokeargument name="key"          value="RHOPid">
						      			<cfinvokeargument name="rowNum"        value="10">
						      			<cfinvokeargument name="PageIndex"      value="3">
						      			<cfinvokeargument name="ModoProgramador"  value="false">
						      			<cfinvokeargument name="fnClick"      value="fnClickSelect">
						      			<cfinvokeargument name="rsprocesar"      value="#rsAgregado#">
						      			<cfinvokeargument name="DefaultValueprocesar"      value="">
						      			<cfinvokeargument name="columnasReplace"    value="#LvarStrings#">
	                              		<cfinvokeargument name="PreFiltroprocesar"   value=" case when '##session.setFiltroPuesto##' = rtrim(ltrim(RHPcodigo)) then  1 else 0 end = ">
					      			</cfinvoke>
					      			</fieldset>
					      			</div>
	        					</div>
	       						<div class="col-md-6">
	       							<div class="well">
       								
	        						<fieldset >
	        						<legend><cfoutput>#LB_PuestosInternosAsociados#</cfoutput><div id="divNombre" style="display:none"></div></legend>
	        						<div id="mensaje" align="center" class="alert alert-dismissable alert-success"><cfoutput>#LB_SeleccionePrimeroUnPuestoExternoDeLaLista#</cfoutput></div>
	        						<div id="divPuestoShow" style="display:none" align="center">
	       							<cfquery datasource="#session.dsn#" name="rsAgregado">
										select null as value, '- #LB_Todos# -' as description,  1 as ord from dual
										union
										select 1 as value, '#LB_Si#' as description,  2 as ord from dual
										union
										select 0 as value, '#LB_No#' as description,  3 as ord from dual
									</cfquery>	
									<cf_dbfunction name="to_char" args="b.RHOPid" returnvariable="LvarRHOPid">
									<cf_dbfunction name="to_char" args="RHOPid" returnvariable="LvarRHOPidChar">
									<cf_translatedata tabla="RHPuestos" col="RHPdescpuesto" name="get" returnvariable="LvarRHPdescpuesto"/>	

									<cfset session.gridTranslatedataCols["LvarRHPdescpuestoSuf"]= 'a.RHPdescpuesto'>
									<cfif isdefined("request.useTranslateData") and request.useTranslateData eq 1>
										<cfset session.gridTranslatedataCols["LvarRHPdescpuestoSuf"] &= '_#session.idioma#'>
									</cfif>


									<cfinvoke component="commons.Componentes.Grid" method="PlistaJquery">
										<cfinvokeargument name="rowList"  value="10,50" >
								        <cfinvokeargument name="IrA"  value="">
								        <cfinvokeargument name="caption"  value=""> 
								        <cfinvokeargument name="etiquetas"  value="#LB_Codigo#,#LB_Descripcion#,#LB_Asociado#">
										<cfinvokeargument name="columnas"   value="distinct a.RHPcodigo,  '<input type=checkbox ' + 
																				   case when (select max(RHPcodigo) from RHOPuestoEquival where #LvarRHOPidChar# = '##session.setFiltroPuesto##') = rtrim(b.RHPcodigo) then
																				   		 ' checked=checked ' 
																				  	else '' 
																				  	end +
																				  	' onclick=fnAgregarQuitar(this,'''+ltrim(rtrim(a.RHPcodigo))+''')>'
																				  	as procesar,
																				   '999' as RHPdescpuesto,
																				   case when (select max(RHPcodigo) from RHOPuestoEquival where #LvarRHOPidChar# = '##session.setFiltroPuesto##') = rtrim(b.RHPcodigo) then
																				   		 1
																				  	else 0 
																				  	end as ordenar">
										<cfinvokeargument name="tabla"   value="RHPuestos a
																				 left join RHOPuestoEquival  b
																					on rtrim(a.RHPcodigo) = rtrim(b.RHPcodigo)">  
						                <cfinvokeargument name="filtro"   value=" a.Ecodigo = #Session.Ecodigo#"> 
						                <cfinvokeargument name="desplegar"   value="RHPcodigo,RHPdescpuesto,procesar">
						      			<cfinvokeargument name="formato"     value="string,string,int">
						      			<cfinvokeargument name="mostrarFiltroColumnas" value="true,true,true"> 
						      			<cfinvokeargument name="width"      value="100,250,100">
						      			<cfinvokeargument name="sortname"       value="4">
						      			<cfinvokeargument name="sortorder"       value="desc">
						      			<cfinvokeargument name="key"          value="RHPcodigo">
						      			<cfinvokeargument name="rowNum"        value="10">
						      			<cfinvokeargument name="PageIndex"      value="4">
						      			<cfinvokeargument name="ModoProgramador"  value="false">
						      			<cfinvokeargument name="rsprocesar"      value="#rsAgregado#">
						      			<cfinvokeargument name="DefaultValueprocesar"      value="">
						      			<cfinvokeargument name="columnasReplace"    value="#LvarStrings#">
						      			<cfinvokeargument name="PreFiltroRHPcodigo"   value=" upper(rtrim(a.RHPcodigo)) like ">
	                              		<cfinvokeargument name="PreFiltroprocesar"   value=" case when '##session.setFiltroPuesto##' = #LvarRHOPid# then  1 else 0 end = ">
	                              		<cfinvokeargument name="PreFiltroRHPdescpuesto"   value=" upper(rtrim(##session.gridTranslatedataCols['LvarRHPdescpuestoSuf']##)) like ">
					      			</cfinvoke>
					      			</div>
					      			</fieldset>
					      			</div>
							    </div>
							</div>
						</cfif>	
					</cf_tab>
				
				</cf_tabs>