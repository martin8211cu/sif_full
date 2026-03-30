<!--- Parametros necesarios--->
<cfparam name="Attributes.name" 			default="actividad" 				type="string">
<cfparam name="Attributes.nameId" 			default="#Attributes.name#Id" 		type="string">
<cfparam name="Attributes.Ecodigo" 			default="#session.Ecodigo#" 		type="numeric">
<!--- Verifica si esta activo la opcion de Actividad empresarial, si esta activa dibuja los campos --->
<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="getParametroActividad" Ecodigo="#Attributes.Ecodigo#" returnvariable="Activo"></cfinvoke>


<cfif activo>
	<!--- Parametros necesarios solamente cuando esta activado el bit de activdad --->
	<cfparam name="Attributes.formName" 		default="form1" 					type="String">
	<cfparam name="Attributes.etiqueta" 		default="Actividad Empresarial:" 	type="string">
	<cfparam name="Attributes.valores" 			default=""							type="string">
	<cfparam name="Attributes.idActividad" 		default="-1"						type="string">
	<cfparam name="Attributes.left" 			default="100" 						type="integer">
	<cfparam name="Attributes.top" 				default="200" 						type="integer">
	<cfparam name="Attributes.width" 			default="815" 						type="integer">
	<cfparam name="Attributes.height" 			default="400" 						type="integer">
	<cfparam name="Attributes.CEcodigo" 		default="#session.CEcodigo#" 		type="numeric">
	<cfparam name="Attributes.separador" 		default="-" 						type="string">
	<cfparam name="Attributes.mostrarActividad"	default="true" 						type="boolean">
	<cfparam name="Attributes.readonly"			default="false" 					type="boolean">
    <cfparam name="Attributes.disabled"			default="" 					        type="string">  <!--- disabled="disabled = true", no editables---->
	<cfparam name="Attributes.style" 			default="" 							type="string">	<!--- style asociado a la caja de texto --->
	<cfparam name="Attributes.MostrarTipo" 		default="" 							type="string">  <!--- G gastos I ingresos--->
    <cfparam name="Attributes.funcion" 			default="" 							type="string">  <!--- Funcion a ejecutar al selecionar una actividad --->
	
    <cfif NOT LEN(TRIM(Attributes.funcion))>
    	<CFSET Attributes.funcion = 'func'& Attributes.name>
    </cfif>

	<cfif len(trim(Attributes.MostrarTipo)) and not listfind('G,I',Attributes.MostrarTipo)>
		<cfthrow message="Valores permitidos en el tag de actividades campo='MostrarTipo' valores= G: Gasto ó I: Ingreso">
	</cfif>
	<cfset color = "##FFFFFF">
	<cfset msg   = Attributes.valores>
	<cfset hayError = false>
	<cfset rsActE.FPAECodigo = "">
	<cfset idAct = Attributes.idActividad>
	<cfset valor = ListChangeDelims(Attributes.valores, ',',Attributes.separador) >
	<cfset arrayDesc = "">
	<cfif len(trim(Attributes.idActividad)) and Attributes.idActividad gt 0 and  len(trim(valor))>
		<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetActividad" returnvariable="rsActE">
			<cfinvokeargument name="FPAEid"			value="#Attributes.idActividad#">
		</cfinvoke>
		<cfif rsActE.recordcount>
			<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="GetNivel" returnvariable="rsActNiveles">
				<cfinvokeargument name="FPAEid"			value="#rsActE.FPAEid#">
			</cfinvoke>
			<cfset catidref = "">
			<cfset arrayDesc = "#rsActE.FPAEDescripcion#|">
			<cfif rsActNiveles.RecordCount eq listlen(valor)>
				<cfloop query="rsActNiveles">
					<cfif FPADDepende eq "C">
						<cfquery datasource="#session.dsn#" name="rsCatE">
							select PCEempresa 
							from PCECatalogo 
							where PCEcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCEcatid#">
							and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.CEcodigo#">
						</cfquery>
						<cfquery datasource="#session.dsn#" name="rsConc">
							select PCDcatid,PCEcatid,PCDvalor,PCDdescripcion,PCEcatidref
							from PCDCatalogo 
							where <cfif isdefined('rsCatE.PCEempresa') and LEN(TRIM(rsCatE.PCEempresa)) and rsCatE.PCEempresa>
								Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Attributes.Ecodigo#"> and
								  </cfif>
								PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCEcatid#">
								and PCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(valor, currentRow)#">
						</cfquery>
						<cfif rsConc.recordcount>
							<cfset catidref = rsConc.PCEcatidref>
							<cfset arrayDesc &= "#rsConc.PCDdescripcion#|">
						<cfelse>
							<cfset fnDetener("##FF0000","-- Valor inválido --","",true)>
							<cfbreak>
						</cfif>
					<cfelseif FPADDepende eq "N">
						<cfif len(trim(catidref))>
							<cfquery datasource="#session.dsn#" name="rsCatE">
								select PCEempresa 
								from PCECatalogo 
								where PCEcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#catidref#">
								and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.CEcodigo#">
							</cfquery>
							<cfquery datasource="#session.dsn#" name="rsConc">
								select PCDcatid,PCEcatid,PCDvalor,PCDdescripcion,PCEcatidref
								from PCDCatalogo 
								where <cfif rsCatE.PCEempresa>
									Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Attributes.Ecodigo#"> and
									  </cfif>
									PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#catidref#">
									and PCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(valor, currentRow)#">
							</cfquery>
							<cfif not rsConc.recordcount>
								<cfset fnDetener("##FF0000","-- #catidref# -- #ListGetAt(valor, currentRow)#","",true)>
								<cfbreak>
							</cfif>
							<cfset catidref = rsConc.PCEcatidref>
							<cfset arrayDesc &= "#rsConc.PCDdescripcion#|">
						<cfelse>
							<cfset fnDetener("##FF0000","-- Error de dependencia --","",true)>
							<cfbreak>
						</cfif>
					<cfelse>
						<cfset fnDetener("##FF0000","-Dependencia no implemetanda-","",true)>
					</cfif>
				</cfloop>
			<cfelse>
				<cfset fnDetener("##FF0000","- Cantidad Inválida -","",true)>
			</cfif>
		<cfelse>
			<cfset fnDetener("##FF0000","- Datos incorrectos -","",true)>
		</cfif>
	</cfif>
	
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
	<style>
		.arbol {
			position: absolute;
			visibility: hidden;
			width: 400px;
			height: 100px;
			background-color: #ccc;
			border: 1px solid #000;
			padding: 10px;
		}
	</style>
	
	<cfoutput>
	<table border="0" cellpadding="0" cellspacing="0">
		<tr><td colspan="3">
				<div id="#Attributes.name#_arbol" class="arbol" style="overflow:auto;" onmouseout="setVisible('#Attributes.name#_arbol')">
				 </div>
		</td></tr>
		<tr>
		<td>#Attributes.etiqueta#&nbsp;</td>
			<td nowrap="nowrap">
				<cfif Attributes.mostrarActividad>
					<cfset type="text">
				<cfelse>
					<cfset type="hidden">
				</cfif>
				<input name="#Attributes.name#_Act" 	id="#Attributes.name#_Act" 	style="display:inline"	value="#rsActE.FPAECodigo#" size="5" type="#type#" onblur="fnBuscarDatos_#Attributes.name#()" style="background-color:#color#;#Attributes.style#" <cfif Attributes.readonly>readonly</cfif>/>
				<input name="#Attributes.name#_Valores" id="#Attributes.name#_Valores" style="display:inline"	value="#msg#" size="30" type="text" onblur="fnBuscarDatos_#Attributes.name#()" style="background-color:#color#;#Attributes.style#" <cfif Attributes.readonly>readonly</cfif>/>
				<input name="#Attributes.name#" 		id="#Attributes.name#" 			value="#Attributes.valores#" 	type="hidden"/>
				<input name="#Attributes.nameId#" 		id="#Attributes.nameId#" 		value="<cfif idAct gt 0>#idAct#</cfif>" type="hidden"/>
				<input name="#Attributes.name#_Tipo" 	id="#Attributes.name#_Tipo" 	value="#Attributes.MostrarTipo#" type="hidden"/>
				<iframe name="iframeActividadEmpresa_#Attributes.name#" id="iframeActividadEmpresa_#Attributes.name#" marginheight="0" marginwidth="10" frameborder="0" height="200" width="500" scrolling="auto" style="display:none"></iframe>
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
				<a onclick="setVisible('#Attributes.name#_arbol')" id = "hrefa_#Attributes.name#" tabindex="-1">
					<img src="/cfmx/sif/imagenes/filterhelp.gif" 
						alt="Lista de Cuentas Financieras" 
						name="imagenas" 
						id = "imga_#Attributes.name#"
						width="18" height="14" 
						border="0" align="absmiddle" 
					>
				</a>
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
		  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=no,copyhistory=no,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top);
		}
		
		function doConlisTagActividad_#Attributes.name#(){
			<cfset param = "name=#Attributes.name#&form=#Attributes.formName#">
			MostrarTipo = document.#Attributes.formName#.#Attributes.name#_Tipo.value;
			param = "";
			if(MostrarTipo.length)
				param = "&MostrarTipo="+MostrarTipo;
			popUpWindow_#Attributes.name#('/cfmx/sif/Utiles/ActividadEmpresa.cfm?<cfoutput>#param#</cfoutput>'+param,#Attributes.left#,#Attributes.top#,#Attributes.width#,#Attributes.height#);
		}
		
		function asignarCodigos_#Attributes.name#(idAct, arrayValores, arrayDesc){
			mostrarArbol_#Attributes.name#(arrayValores, arrayDesc);
			act = document.#Attributes.formName#.#Attributes.name#_Act;
			act.value = arrayValores.shift();
			act.style.background = "##FFFFFF";
			arrayValores = arrayValores.join('#Attributes.separador#');
			
			valores = document.#Attributes.formName#.#Attributes.name#_Valores;
			valores.value = arrayValores;
			valores.style.background = "##FFFFFF";
			
			valores = document.#Attributes.formName#.#Attributes.name#;
			valores.value = arrayValores;
			actId = document.#Attributes.formName#.#Attributes.nameId#;
			actId.value = idAct;
			
			if (window.#Attributes.funcion#)
				  #Attributes.funcion#();
		    }
		
		function mostrarArbol_#Attributes.name#(arrayValores, arrayDesc){
			tree#Attributes.name# = new WebFXTree(arrayValores[0]+' - '+arrayDesc[0],'','explorer');
			padre#Attributes.name# = tree#Attributes.name#;
			for (i=1;i<arrayValores.length;i++){
				LvarSIS = new WebFXTreeItem(arrayValores[i]+' - '+arrayDesc[i],'',padre#Attributes.name#);
				padre#Attributes.name# = LvarSIS;
			}
			contenedor = document.getElementById('#Attributes.name#_arbol');
			contenedor.innerHTML = '';
			contenedor.innerHTML = '<div align="center">Estructura de la Actividad Empresarial</div><br>' + tree#Attributes.name#;
			tree#Attributes.name#.expandAll();
		}
		
		function fnBuscarDatos_#Attributes.name#(){
			codAE = document.#Attributes.formName#.#Attributes.name#_Act;
			valores = document.#Attributes.formName#.#Attributes.name#_Valores;
			if(codAE.value.length > 0 && valores.value.length > 0)
				document.getElementById('iframeActividadEmpresa_#Attributes.name#').src="/cfmx/sif/Utiles/iframeActividadEmpresa.cfm?form=#Attributes.formName#&name=#Attributes.name#&nameId=#Attributes.nameId#&codActividad="+codAE.value+"&valores="+valores.value+"&separador=#Attributes.separador#&CEcodigo=#session.CEcodigo#&Ecodigo=#session.Ecodigo#";
			else if(codAE.value.length > 0)
				document.getElementById('iframeActividadEmpresa_#Attributes.name#').src="/cfmx/sif/Utiles/iframeActividadEmpresa.cfm?form=#Attributes.formName#&name=#Attributes.name#&nameId=#Attributes.nameId#&codActividad="+codAE.value+"&Ecodigo=#session.Ecodigo#";
			else{
				document.#Attributes.formName#.#Attributes.nameId#.value = "";
				document.#Attributes.formName#.#Attributes.name#.value = "";
				document.getElementById('#Attributes.name#_arbol').innerHTML = "";
			}
		}
		
		<cfif len(trim(Attributes.idActividad)) and Attributes.idActividad neq -1 and not hayError>
		arrayValores = '#rsActE.FPAECodigo##Attributes.separador##Attributes.valores#'.split('#Attributes.separador#');
		arrayDesc = '#arrayDesc#'.split('|');
		mostrarArbol_#Attributes.name#(arrayValores, arrayDesc);
		<cfelse>
		contenedor = document.getElementById('#Attributes.name#_arbol');
		contenedor.innerHTML = '';
		contenedor.innerHTML = '<div align="center">Estructura de la Actividad Empresarial</div>';
		</cfif>
	</script>
	</cfoutput>
	
	<cffunction name="fnDetener" access="private" output="true">
		<cfargument  name="estado" 	type="string" 	required="yes">
		<cfargument  name="mensaje" type="string" 	required="yes">
		<cfargument  name="valor" 	type="string" 	required="yes">
		<cfargument  name="error" 	type="boolean" 	required="yes">
		<cfargument  name="id" 	type="numeric" 	required="no" default="-1">
		<cfset color = Arguments.estado>
		<cfset msg = Arguments.mensaje>
		<cfset Attributes.value = Arguments.valor>
		<cfset hayError = Arguments.error>
		<cfset idAct = Arguments.id>
	</cffunction>
<cfelse>

	<cfoutput>
		<input type="hidden" name="#Attributes.name#" 		id="#Attributes.name#" 		value=""/>
		<input type="hidden" name="#Attributes.nameId#" 	id="#Attributes.nameId#" 	value=""/>
	</cfoutput>
	
</cfif>