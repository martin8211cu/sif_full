<cfparam name="Attributes.formName" 			default="form1" 						type="String">
<cfparam name="Attributes.name" 					default="garantia" 					type="string">
<cfparam name="Attributes.nameId" 				default="#Attributes.name#Id" 	type="string">
<cfparam name="Attributes.valores" 				default=""								type="string">
<cfparam name="Attributes.CMPid" 				default="-1"							type="integer">

<cfparam name="Attributes.ESidsolicitud" 		default="-1"							type="integer">

<cfparam name="Attributes.left" 					default="100" 							type="integer">
<cfparam name="Attributes.top" 					default="200" 							type="integer">
<cfparam name="Attributes.width" 				default="815" 							type="integer">
<cfparam name="Attributes.height" 				default="400" 							type="integer">
<cfparam name="Attributes.Ecodigo" 				default="#session.Ecodigo#" 		type="numeric">
<cfparam name="Attributes.CEcodigo" 			default="#session.CEcodigo#" 		type="numeric">
<cfparam name="Attributes.readonly"				default="false" 						type="boolean">
<cfparam name="Attributes.mostrarConceptos" default="false" type="boolean">
<cfparam name="rsSolicitudesTodo.recordcount" type="integer" default="0">
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.funcionT" type="string" default=""> <!--- Funcion a ejecutar al final del proceso --->
<cfparam name="Attributes.funcionI" type="string" default=""> <!--- Funcion a ejecutar al inicio del proceso --->
<cfparam name="Attributes.columnas" type="string" default=""> <!--- Columnas a pasar en la funcion --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->

	<cfparam name="Request.jsTree" default="false">
	<cfif Request.jsTree EQ false>
		<cfset Request.jsTree = true>
		<link href="/cfmx/sif/js/xtree/xtree.css" rel="stylesheet" type="text/css">
		<script language="JavaScript" src="/cfmx/sif/js/xtree/xtree.js"></script>
	</cfif>
	<cfparam name="Request.jsPopupDiv" default="false">
	<cfif Request.jsPopupDiv EQ false>
		<cfset Request.jsPopupDiv = true>
		<script type="text/javascript" src="/cfmx/sif/js/popupDiv.js"></script>
	</cfif>
	
	<cfoutput>
	<table border="0" cellpadding="0" cellspacing="0">
			<tr>	
				<td width="6">
					<cf_dbfunction name="OP_concat" returnvariable="_Cat">
					<cfquery name="rsSolicitudesTodo" datasource="#Session.DSN#">
						select distinct
							CMPid,
							CMPProceso,
							CMPLinea,
							CMPid_CM
						from CMProceso
						where Ecodigo = #session.Ecodigo# 
						<cfif isdefined('Attributes.CMPid') and  Attributes.CMPid NEQ -1>
						and CMPid = #Attributes.CMPid#
						<cfelse>
						and 1=2
						</cfif>
					</cfquery>
				 </td>
			</tr>
		</table>
						
	<table border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td> 
					<input type="hidden" name="#Attributes.name#" id="#Attributes.name#_codigo" 
							style="text-transform:uppercase"
							tabindex="#Attributes.tabindex#" 
							onBlur="javascript:traerDatos_#Attributes.name#(this);"
							value="<cfif rsSolicitudesTodo.recordcount>#rsSolicitudesTodo.CMPid#</cfif>">
				</td>
				<td>
					<input type="text" name="#Attributes.name#_descripcion" id="#Attributes.name#_descripcion" 
							maxlength="80" 
							tabindex="-1"
							readonly
							style="border:solid 1px ##CCCCCC; background:inherit;"
							value="<cfif rsSolicitudesTodo.recordcount>#rsSolicitudesTodo.CMPProceso#</cfif>"
							size="30">
				</td>
				
				
				<td nowrap="nowrap">
					<iframe name="ProcesosGarantiasC_#Attributes.name#" id="ProcesosGarantiasC_#Attributes.name#" marginheight="0" marginwidth="10" frameborder="0" height="200" width="500" scrolling="auto" style="display:none"></iframe>
						<cfif not Attributes.readonly>
						<a href="javascript:doConlisTagActividad_#Attributes.name#();" id = "href_#Attributes.name#" tabindex="-1">
							<img src="/cfmx/sif/imagenes/agenda.gif" 
								alt="Lista de Cuentas Financieras" 
								name="imagen" 
								id = "img_#Attributes.name#"
								width="18" height="14" 
								border="0" align="absmiddle" 
							>
						</a>
						</cfif>
				</td>
				<td nowrap="nowrap">
					<iframe name="ifrCambioDatos_#Attributes.name#" id="ifrCambioDatos_#Attributes.name#" marginheight="0" marginwidth="10" frameborder="0" height="0" width="0" scrolling="auto"></iframe>	
				</td>
			</tr>
		</table>	

	<script language="javascript1.2" type="text/javascript">
		var popUpWin=null;
		function popUpWindow_#Attributes.name#(URLStr, left, top, width, height){
		  if(popUpWin){
			if(!popUpWin.closed)
				popUpWin.close();
		  }
		  	<cfif isdefined('Attributes.funcionI') and Len(Trim(Attributes.funcionI))>
				<cfoutput>#Attributes.funcionI#</cfoutput>;
			</cfif>
		  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=no,copyhistory=no,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top);
		}
		
		function doConlisTagActividad_#Attributes.name#(){
			<cfset funcionT="">
			<cfif isdefined('Attributes.funcionT') and Len(Trim(Attributes.funcionT))>
				<cfset funcionT="&funcionT=#Attributes.funcionT#">
			</cfif>
			<cfset columnas="">
			<cfif isdefined('Attributes.columnas') and Len(Trim(Attributes.columnas))>
				<cfset funcionT="&columnas=#Attributes.columnas#">
			</cfif>
			CMPid = document.<cfoutput>#Attributes.formName#</cfoutput>.<cfoutput>#Attributes.name#</cfoutput>.value;
			ESidsolicitud = document.<cfoutput>#Attributes.formName#</cfoutput>.<cfoutput>#Attributes.name#</cfoutput>.value;
			
			if(!CMPid)
				CMPid = <cfoutput>#Attributes.CMPid#</cfoutput>;
			popUpWindow_#Attributes.name#("/cfmx/sif/Utiles/ProcesosGarantiasC.cfm?name=#Attributes.name#&ultimoNivel=#Attributes.ultimoNivel#&CMPid="+CMPid+"#funcionT##columnas#", '#Attributes.name#', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width=700,height=750');
		
		}
		
		function fnBuscarDatos_#Attributes.name#(){
			codAE = document.#Attributes.formName#.#Attributes.name#_Act;
			valores = document.#Attributes.formName#.#Attributes.name#_Valores;
			if(codAE.value.length > 0 && valores.value.length > 0)
				document.getElementById('ProcesosGarantiasC_#Attributes.name#').src="/cfmx/sif/Utiles/ProcesosGarantiasC.cfm?form=#Attributes.formName#&name=#Attributes.name#&nameId=#Attributes.nameId#&valores="+valores.value+"&CEcodigo=#session.CEcodigo#&Ecodigo=#session.Ecodigo#&CMPid="+CMPid+"&CMPid=#Attributes.CMPid#";
			else if(codAE.value.length > 0)
				document.getElementById('ProcesosGarantiasC_#Attributes.name#').src="/cfmx/sif/Utiles/ProcesosGarantiasC.cfm?form=#Attributes.formName#&name=#Attributes.name#&nameId=#Attributes.nameId#&Ecodigo=#session.Ecodigo#&CMPid="+CMPid+"";
			else{
				document.#Attributes.formName#.#Attributes.nameId#.value = "";
				document.#Attributes.formName#.#Attributes.name#.value = "";
				document.getElementById('#Attributes.name#_arbol').innerHTML = "";
			}
		}
		
		function traerDatos_#Attributes.name#(obj){
			<cfset funcionT="">
			<cfif isdefined('Attributes.funcionT') and Len(Trim(Attributes.funcionT))>
				<cfset funcionT="&funcionT=#Attributes.funcionT#">
			</cfif>
			traerDatos_#Attributes.name#_popup(obj.value,"#funcionT#");
		}
		
		function traerDatos_#Attributes.name#_popup(valor,funcion){
			document.getElementById('ifrCambioDatos_#Attributes.name#').src = "/cfmx/sif/Utiles/ProcesosGarantiasC.cfm?codigo="+valor+"&formName=#Attributes.form#&name=#Attributes.name#&ultimoNivel=#Attributes.ultimoNivel#&CMPid="+CMPid+"&funcionT="+funcion;
		}
		
	</script>
	</cfoutput>