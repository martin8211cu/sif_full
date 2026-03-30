<cfset def = QueryNew("ACcodigo") >
<cfparam name="Attributes.filtro" 	default="" 					type="string">
<cfparam name="Attributes.Conexion" default="#Session.DSN#" 	type="String"> 	<!--- Nombre de la conexión --->
<cfparam name="Attributes.Ecodigo" 	default="#Session.Ecodigo#" type="integer"> <!--- Codigo de la empresa --->
<cfparam name="Attributes.value" 	default="-1" 				type="integer"> <!--- valor por defecto --->

<cfset rsFPCCconcepto = QueryNew("ID","VarChar")>
<cfset QueryAddRow(rsFPCCconcepto, 10)>
<cfset QuerySetCell(rsFPCCconcepto, "ID", "1", 1)><!---Otros--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "2", 2)><!---Concepto Salarial--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "3", 3)><!---Amortización de prestamos--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "4", 4)><!---Financiamiento--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "5", 5)><!---Patrimonio--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "6", 6)><!---Ventas--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "F", 7)><!---Activos--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "S", 8)><!---Servicio--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "A", 9)><!---Articulos de Inventario--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "P", 10)><!---Obras en Proceso--->
<cfset ListFPCCconceptoCon = "S,A,P"><!--- Lista de conceptos que requieren el "FPCCTablaC"--->
<cfset ListFPCCconceptoSin = "1,2,3,4,5,f"><!--- Lista de conceptos que no requieren el "FPCCTablaC" --->

<cfif LEN(TRIM(Attributes.filtro))>
	<cfset Attributes.filtro = 'and '&Attributes.filtro>
</cfif>
<cfset longuitud=30>
<cf_dbfunction name="sPart" 	args="FPCCdescripcion,1,#longuitud#" 	returnvariable="Spart_Desc">
<cf_dbfunction name="length"	args="FPCCdescripcion" 					returnvariable="Len_Desc">
<cf_dbfunction name="length"	args="FPCdescripcion" 					returnvariable="Len_Desc2">
<cf_dbfunction name="sPart" 	args="FPCdescripcion,1,#longuitud#"		returnvariable="Spart_Desc2">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
	<cfset rsPadre=Attributes.query>
<cfelse>
	<cfquery datasource="#Attributes.Conexion#" name="rsPadre">
		select 	FPCCid, FPCCcodigo, #Spart_Desc#  #_Cat# case when #Len_Desc# > #longuitud# then '...' else '' end  as FPCCdescripcion, FPCCidPadre, FPCCconcepto, FPCCTablaC,
		(select count(1) from FPCatConcepto as hijos where hijos.Ecodigo = #Attributes.Ecodigo# and hijos.FPCCidPadre = FPCatConcepto.FPCCid) as cantHijos
		from FPCatConcepto as FPCatConcepto
		where Ecodigo = #Attributes.Ecodigo# and FPCCidPadre is null
		#preservesinglequotes(Attributes.filtro)#
		order by FPCCcodigo, FPCCdescripcion
	</cfquery>
</cfif>

<cfif Attributes.value NEQ -1>
	<cfquery datasource="#Attributes.Conexion#" name="rsConcepto">
		select 	FPCCid, FPCCcodigo, FPCCdescripcion
		from FPCatConcepto
		where Ecodigo = #Attributes.Ecodigo# and FPCCid = #Attributes.value#
		order by FPCCcodigo, FPCCdescripcion
	</cfquery>
</cfif>
<cfif isdefined('Attributes.selecionadoCAT') and NOT LEN(Attributes.selecionadoCAT)>
	<cfset Attributes.selecionadoCAT = -1>
</cfif>
<cfparam name="Attributes.selecionadoCAT" 	default="-1" 		type="float"> 	<!--- categoria selecionado por defecto --->
<cfset padreSelecionadoCAT = fnGetCategoriaAbsoluta(Attributes.selecionadoCAT,Attributes.Ecodigo).FPCCid>
<cfparam name="Attributes.selecionadoCON" 	default="-1" 		type="float"> 	<!--- Concepto selecionado por defecto --->
<!--- Parámetros del TAG --->
<cfparam name="Attributes.form"  			default="form1" 	type="String"> 	<!--- Nombre del form --->
<cfparam name="Attributes.name"  			default="concepto" 	type="string"> 
<cfparam name="Attributes.name2" 			default="categoria" type="string"> 

<cfparam name="Attributes.tabindex" 		default="" 			type="string"> 	<!--- número del tabindex --->
<cfparam name="Attributes.onBlur" 			default="" 			type="string"> 	<!--- función en el evento onBlur --->
<cfparam name="Attributes.onChange" 		default="" 			type="string"> 	<!--- función en el evento onChange --->
<cfparam name="Attributes.image" 			default="true" 		type="boolean"> <!--- Visualizar el image del calendario --->
<cfparam name="Attributes.style" 			default="" 			type="string">
<cfparam name="Attributes.enterAction"  	default="" 			type="string">
<cfparam name="Attributes.readOnly" 		default="false" 	type="boolean">
<cfparam name="Attributes.metodo" 			default="form" 		type="string">
<cfparam name="Attributes.irA" 				default="#GetFileFromPath(GetTemplatePath())#" type="string">
<cfparam name="Attributes.popup" 			default="false" 	type="boolean">
<cfparam name="Attributes.mostrarConceptos" default="false" 	type="boolean">
<cfparam name="Attributes.desIrA" 			default="false" 	type="boolean">

<cfparam name="Attributes.query"			default="#def#"		type="query"> 	<!--- consulta por defecto --->

<cfparam name="Attributes.funcionT" 		default=""			type="string"> 	<!--- Funcion a ejecutar al final del proceso --->
<cfparam name="rsConcepto.recordcount" 		default="0"			type="integer" >
<cfparam name="Attributes.titulo" 			default="Concepto Ingresos y Egresos" type="string">
<cfparam name="Attributes.mostrarAyuda" 	default="true" 		type="boolean">
<cfparam name="Attributes.color" 			default="##CCCCCC" 	type="string">
<cfparam name="Attributes.ultimoNivel" 		default="false" 	type="boolean">
<cfparam name="Attributes.mostrarFiltro"	default="false" 	type="boolean">
<cfparam name="Attributes.MaxRows" 			default="10"		type="integer" >

<cfif Attributes.mostrarConceptos>
	<cfset Attributes.ultimo = true>
</cfif>

<cfif Attributes.value NEQ -1>
	<cfquery datasource="#Attributes.Conexion#" name="rsConcepto">
		select 	FPCCid, FPCCcodigo, FPCCdescripcion
		from FPCatConcepto
		where Ecodigo = #Attributes.Ecodigo# and FPCCid = #Attributes.value#
		order by FPCCcodigo, FPCCdescripcion
	</cfquery>
</cfif>

<cfparam name="Request.jsTree" default="false">
<cfif Request.jsTree EQ false>
	<cfset Request.jsTree = true>
	<cfif Attributes.mostrarAyuda>
		<style>
			#layer1 {
				position: absolute;
				visibility: hidden;
				width: 400px;
				height: 90px;
				background-color: #ccc;
				border: 1px solid #000;
				padding: 10px;
			}
			#close {
				float: right;
			}
		</style>
	</cfif>
	<link href="xtree/xtree.css" rel="stylesheet" type="text/css">
	<script language="JavaScript" src="/cfmx/sif/js/xtree/xtree.js"></script>
</cfif>
<cfif not Attributes.popup>
	<cfif Attributes.mostrarAyuda>
		<script type="text/javascript" src="/cfmx/sif/js/popupDiv.js"></script>
		<div id="layer1" onmouseout="setVisible('layer1')">
		  <p>
			<table border="0" cellspacing="0" cellpadding="0" onmouseout="setVisible('layer1')"><tr>
				<td>
					<input type="image" src="/cfmx/sif/imagenes/MasterDetail.gif" name="ImgPadre"/> Nivel superior, no se han definido los atributos del concepto.
				</td>
				</tr>
			<tr>
				<td>
					<input type="image" src="/cfmx/sif/imagenes/Script.gif" name="ImgPadre"/> Nivel inferior, se han definido los atributos del concepto.
				</td>
			</tr>
			<tr>
				<td>
					<input type="image" src="/cfmx/sif/imagenes/Documentos.gif" name="ImgPadre"/> Nivel de concepto, el objeto es un concepto.
				</td>
			</tr></table>
			</p>
		 </div>
	</cfif>
<fieldset>
<table border="0" cellspacing="0" cellpadding="0" width="100%"><tr>
	<td>
	<cfoutput>
	<form name="conceptosForm" action="#Attributes.irA#" method="#Attributes.metodo#">
		<input type="hidden" name="#Attributes.name#" 	id="#Attributes.name#" 	value="">
		<input type="hidden" name="#Attributes.name2#" 	id="#Attributes.name2#" value="">
	</form>
	</cfoutput>
	</td>
	</tr>

	<cfif Attributes.mostrarAyuda>
		<tr>
			<td align="left">
				<img border='0' width="12" height="12" src='/cfmx/sif/imagenes/help_small.gif' onmouseover="setVisible('layer1',10)" title="Ayuda"/>
			</td>
		</tr>
	</cfif>
	<tr><td >&nbsp;</td></tr>
	<cfif Attributes.mostrarFiltro>
	<tr>
		<td>
			<fieldset><legend>Búsqueda</legend>
				<cfif Attributes.mostrarConceptos>
					<cfquery datasource="#session.dsn#" name="rsQuery">
						select FPCid, FPCCid, FPCcodigo, #Spart_Desc2#  #_Cat# case when #Len_Desc2# > #longuitud# then '...' else '' end  as FPCdescripcion
						from FPConcepto
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.Ecodigo#">
						<cfif isdefined('form.filtro_FPCcodigo') and len(trim(form.filtro_FPCcodigo)) gt 0>
						and lower(FPCcodigo) like lower('%#trim(form.filtro_FPCcodigo)#%')
						</cfif>
						<cfif isdefined('form.filtro_FPCdescripcion') and len(trim(form.filtro_FPCdescripcion)) gt 0>
						and lower(FPCdescripcion) like lower('%#trim(form.filtro_FPCdescripcion)#%')
						</cfif>
						<cfif (not isdefined('form.filtro_FPCcodigo') or not len(trim(form.filtro_FPCcodigo)) gt 0) and ( not isdefined('form.filtro_FPCdescripcion') or not len(trim(form.filtro_FPCdescripcion)) gt 0)>
						and 0 != 0
						</cfif>
					</cfquery>
					<cfset desplegar="FPCcodigo,FPCdescripcion">
					<cfset fparams ="FPCid,FPCCid">
					<cfset formatos="S,S">
					<cfset etiquetas="Código,Descripción">
					<cfset align="left,left">
					<cfset keys="FPCid">
				<cfelse>
					<cfquery name="rsTipo" datasource="#session.DSN#">
						select '-1' as value, '-- Ninguno --' as description, -1 ord from dual
						union
						select 'I' as value, 'Ingreso' as description, 1 ord from dual
						union 
						select 'G' as value, 'Egresos' as description, 2 ord from dual
						union
						select '0' as value, '-- todos --' as description, 0 ord from dual
						order by ord
					</cfquery>
					<cfquery name="rsConcepto" datasource="#session.DSN#">
						select '-1' as value, '-- Ninguno --' as description, -1 ord from dual
						union
						select 'F' as value, 'Activo Fijo' as description, 1 ord from dual
						union 
						select 'A' as value, 'Artículos Inventario' as description, 2 ord from dual
						union
						select 'S' as value, 'Gastos o Servicio' as description, 3 ord from dual
						union
						select 'P' as value, 'Obras en Proceso' as description, 4 ord from dual
						union
						select '2' as value, 'Concepto Salarial' as description, 5 ord from dual
						union
						select '3' as value, 'Amortización de Prestamos' as description, 6 ord from dual
						union
						select '1' as value, 'Otros' as description, 7 ord from dual
						union
						select '4' as value, 'Financiamiento' as description, 8 ord from dual
						union
						select '5' as value, 'Patrimonio' as description, 9 ord from dual
						union
						select '6' as value, 'Ventas' as description, 10 ord from dual
						union
						select '0' as value, '-- todos --' as description, 0 ord from dual
						order by ord
					</cfquery>
					<cfquery datasource="#session.dsn#" name="rsQuery">
						select 	FPCCid, FPCCcodigo, FPCCdescripcion, case FPCCtipo when 'I' then 'Ingreso' when 'G' then 'Egreso' else 'Otro' end FPCCtipo,
							case FPCCconcepto
								when 'F' then 'Activo Fijo'
								when 'A' then 'Artículos Inventario'
								when 'S' then 'Gastos o Servicio'
								when 'P' then 'Obras en Proceso'
								when '2' then 'Concepto Salarial'
								when '3' then 'Amortización de Prestamos'
								when '1' then 'Otros'
								when '4' then 'Financiamiento'
								when '5' then 'Patrimonio'
								when '6' then 'Ventas'
								else 'Otro' end FPCCconcepto
						from FPCatConcepto
						where Ecodigo = #Attributes.Ecodigo#
						<cfif isdefined('form.filtro_FPCCcodigo') and len(trim(form.filtro_FPCCcodigo)) gt 0>
						and lower(FPCCcodigo) like lower('%#trim(form.filtro_FPCCcodigo)#%')
						</cfif>
						<cfif isdefined('form.filtro_FPCCdescripcion') and len(trim(form.filtro_FPCCdescripcion)) gt 0>
						and lower(FPCCdescripcion) like lower('%#trim(form.filtro_FPCCdescripcion)#%')
						</cfif>
						<cfif isdefined('form.filtro_FPCCtipo') and len(trim(form.filtro_FPCCtipo)) gt 0 and form.filtro_FPCCtipo neq '-1' and form.filtro_FPCCtipo neq '0'>
						and FPCCtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.filtro_FPCCtipo)#">
						</cfif>
						<cfif isdefined('form.filtro_FPCCconcepto') and len(trim(form.filtro_FPCCconcepto)) gt 0 and form.filtro_FPCCconcepto neq '-1' and form.filtro_FPCCconcepto neq '0'>
						and FPCCconcepto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.filtro_FPCCconcepto)#">
						</cfif>
						<cfif (not isdefined('form.filtro_FPCCcodigo') or not len(trim(form.filtro_FPCCcodigo)) gt 0) and ( not isdefined('form.filtro_FPCCdescripcion') or not len(trim(form.filtro_FPCCdescripcion)) gt 0 and ( not isdefined('form.filtro_FPCCtipo') or not len(trim(form.filtro_FPCCtipo)) gt 0 or form.filtro_FPCCtipo eq '-1')) and ( not isdefined('form.filtro_FPCCconcepto') or not len(trim(form.filtro_FPCCconcepto)) gt 0 or form.filtro_FPCCconcepto eq '-1')>
						and 0 != 0
						</cfif>
						order by FPCCcodigo, FPCCdescripcion
					</cfquery>
					<cfset desplegar="FPCCcodigo,FPCCdescripcion,FPCCtipo,FPCCconcepto">
					<cfset fparams ="FPCCid">
					<cfset formatos="S,S,S,S">
					<cfset etiquetas="Código,Descripción,Tipo,Inidicador Auxiliar">
					<cfset align="left,left,center,center">
					<cfset keys="FPCCid">
				</cfif>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
					 <cfinvokeargument name="query" 			value="#rsQuery#">
					 <cfinvokeargument name="conexion" 			value="#Attributes.Conexion#">
					 <cfinvokeargument name="desplegar" 		value="#desplegar#">
					 <cfinvokeargument name="etiquetas" 		value="#etiquetas#">
					 <cfinvokeargument name="formatos" 			value="#formatos#">
					 <cfinvokeargument name="mostrar_filtro" 	value="true">
					 <cfinvokeargument name="checkboxes" 		value="N">
					 <cfinvokeargument name="formName" 			value="Filtro#Attributes.name#">
					 <cfinvokeargument name="form_method" 		value="post">
					 <cfinvokeargument name="irA" 				value="#Attributes.irA#">
					 <cfinvokeargument name="funcion" 			value="fnSumbit_#Attributes.name#">
					 <cfinvokeargument name="fparams" 			value="#fparams#">
					 <cfinvokeargument name="MaxRows" 			value="#Attributes.MaxRows#">
					 <cfinvokeargument name="keys" 				value="#keys#">
					 <cfinvokeargument name="usaAJAX" 			value="true">
					 <cfif isdefined('rsTipo')>
						 <cfinvokeargument name="rsFPCCtipo" 	value="#rsTipo#">
					 </cfif>
					 <cfif isdefined('rsConcepto')>
						 <cfinvokeargument name="rsFPCCconcepto" value="#rsConcepto#">
					 </cfif>
				</cfinvoke>
			</fieldset>
		</td>
	</tr>
	</cfif>
	<tr>
		<td>
			<div id="arbol<cfoutput>#Attributes.name#</cfoutput>"></div>
		</td>
</tr></table></fieldset>
<cfelse>
<table border="0" cellspacing="0" cellpadding="0">
	<tr><cfoutput>
		<td nowrap> 
			<input 	type="hidden" name="#Attributes.name#" id="#Attributes.name#" value="<cfif rsConcepto.recordcount>#rsConcepto.FPCCid#</cfif>">
			<input 	name="#Attributes.name#_codigo" id="#Attributes.name#_codigo" type="text"
					style="text-transform:uppercase"
					tabindex="#Attributes.tabindex#" 
					onBlur="javascript:traerDatos_#Attributes.name#(this);"
					value="<cfif rsConcepto.recordcount>#rsConcepto.FPCCcodigo#</cfif>">
		</td>
		<td nowrap>
			<input 	type="text" name="#Attributes.name#_descripcion" id="#Attributes.name#_descripcion" 
					maxlength="80" 
					tabindex="-1"
					readonly
					style="border:solid 1px ##CCCCCC; background:inherit;"
					value="<cfif rsConcepto.recordcount>#rsConcepto.FPCCdescripcion#</cfif>"
					size="30">
		</td>
		<cfif Attributes.image>
		<td nowrap="nowrap">
			<a href="javascript:doConlisTagConceptos_#Attributes.name#();" id = "hhref_#Attributes.name#" tabindex="-1">
				<img src="/cfmx/sif/imagenes/Magnifier.gif" 
					alt="Lista de Cuentas Financieras" 
					name="imagen" 
					id = "img_#Attributes.name#"
					width="18" height="14" 
					border="0" align="absmiddle" 
				>
			</a>	
		</td>
		</cfif>
		<td nowrap="nowrap">
			<iframe name="ifrCambioDatos_#Attributes.name#" id="ifrCambioDatos_#Attributes.name#" marginheight="0" marginwidth="10" frameborder="0" height="0" width="0" scrolling="auto"></iframe>	
		</td>
	</cfoutput></tr>
</table>
</cfif>
<script language="JavaScript" type="text/javascript">
		
	<cfif not Attributes.popup>
		var icon = '/cfmx/sif/js/xtree/images/blank.png';
		var tree<cfoutput>#Attributes.tabindex#</cfoutput> = new WebFXTree(" ",'','explorer',icon,icon);
		webFXTreeHandler.idPrefix = "PCG-";
		<cfset pintarCAT = false>
		<cfset pintarCON = false>
		 var ArrayPadres   = new  Array();
		 var ArrayIDPadres = new  Array();
		<cfoutput query="rsPadre">
			<cfset funcion="">
			<cfif not Attributes.mostrarConceptos>
				<cfset funcion="javascript:fnSumbit_#Attributes.name#(#rsPadre.FPCCid#);">
			<cfelse>
				<cfset funcion="?FPCCid=#rsPadre.FPCCid#">
			</cfif>
			<cfif Attributes.ultimoNivel and (ListFind(ListFPCCconceptoCon, rsPadre.FPCCconcepto) and len(trim(rsPadre.FPCCTablaC))) OR (ListFind(ListFPCCconceptoSin, FPCCconcepto) and rsPadre.cantHijos EQ 0)>
				<cfset funcion="javascript:fnSumbit_#Attributes.name#(#rsPadre.FPCCid#);">
			</cfif>
			<cfif Attributes.desIrA>
				<cfset funcion ="">
			</cfif>
			<cfif (ListFind(ListFPCCconceptoCon, rsPadre.FPCCconcepto) and len(trim(rsPadre.FPCCTablaC))) OR (ListFind(ListFPCCconceptoSin, rsPadre.FPCCconcepto) and rsPadre.cantHijos EQ 0)>
				<cfset icon = '/cfmx/sif/imagenes/Script.gif'>
			<cfelse>
				<cfset icon = '/cfmx/sif/imagenes/MasterDetail.gif'>
			</cfif>	
			var LvarSIS = new WebFXTreeItem("#rsPadre.FPCCcodigo#: #rsPadre.FPCCdescripcion#","#funcion#",tree#Attributes.tabindex#,"#icon#","#icon#");
			<cfif rsPadre.cantHijos GT 0 and NOT Attributes.mostrarConceptos>
				ArrayPadres.push(LvarSIS.id);
				ArrayIDPadres.push(#rsPadre.FPCCid#);
			</cfif>
			<cfif Attributes.selecionadoCAT eq rsPadre.FPCCid>
				var idExpandirCAT = LvarSIS.id;
				<cfset pintarCAT = true>
			</cfif>
			<cfif padreSelecionadoCAT eq  rsPadre.FPCCid>
				<cfset fnGetHijos(rsPadre.FPCCid,Attributes.Ecodigo,Attributes.Conexion)>
				<cfif Attributes.mostrarConceptos>
					var LvarMOD = LvarSIS;
					<cfset fnGetConceptos(rsPadre.FPCCid,Attributes.Conexion)>
				</cfif>
			</cfif>
		</cfoutput>
		<cfoutput>
		contenedor = document.getElementById('arbol#Attributes.name#');
		contenedor.innerHTML = tree#Attributes.tabindex#;
		tree#Attributes.tabindex#.collapseAll();
		tree#Attributes.tabindex#.expand();
		
		 for (var i = 0; i < ArrayPadres.length; i++) 
     	 {
            document.getElementById(ArrayPadres[i]+'-plus').src = "/cfmx/sif/js/xtree/images/Lplus.png";
			<cfif not Attributes.desIrA>
			document.getElementById(ArrayPadres[i]+'-plus').setAttribute("onclick","fnSumbit_#Attributes.name#("+ArrayIDPadres[i]+")"); 
     	 	</cfif>
		 }
		
		<cfif pintarCAT>
			webFXTreeHandler.expand(document.getElementById(idExpandirCAT)); 
			var expandir =  new Array();
			getIdPadreSuperior(0,idExpandirCAT);
			expandir.reverse();
			for (i=0;i<expandir.length-1;i++)
				webFXTreeHandler.expand(document.getElementById(expandir[i])); 
			function getIdPadreSuperior(i,idHijo){
				expandir[i]= idHijo.replace('-cont','');
				hijo = document.getElementById(idHijo);
				padre = hijo.parentNode;
				if(padre.id == "webfx-tree-object-2-cont"){//Este es el padre absoluto
					return idHijo.replace('-cont',''); 
				}
				else
					return getIdPadreSuperior(++i,padre.id);
			}
		</cfif>
		<cfif pintarCAT and not pintarCON>
			div = document.getElementById(idExpandirCAT);
			div.style.backgroundColor = '##CCCCCC';
		</cfif>
		<cfif pintarCON>
			div = document.getElementById(idExpandirCON);
			div.style.backgroundColor = '##CCCCCC';
		</cfif>
		function fnSumbit_#Attributes.name#(valor1, valor2){
			document.conceptosForm.#Attributes.name#.value = valor1;
			if(valor2)
				document.conceptosForm.#Attributes.name2#.value = valor2;
			document.conceptosForm.submit();
		}
		</cfoutput>
	<cfelse>
		<cfoutput>
		var popup_#Attributes.name# = false;
		function doConlisTagConceptos_#Attributes.name#(){
			if(popup_#Attributes.name#)
			{
				if(!popup_#Attributes.name#.closed) popup_#Attributes.name#.close();
			}
			<cfset funcion="">
			<cfif isdefined('Attributes.funcionT') and Len(Trim(Attributes.funcionT))>
				<cfset funcion="&funcionT=#Attributes.funcionT#">
			</cfif>	
			popup_#Attributes.name# = open
				("/cfmx/sif/Utiles/ConceptoGatosIngresos.cfm?name=#Attributes.name#&tabindex=#Attributes.tabindex##funcion#&filtro=#Attributes.filtro#&titulo=#Attributes.titulo#&mostrarAyuda=#Attributes.mostrarAyuda#&ultimoNivel=#Attributes.ultimoNivel#", '#Attributes.name#', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width=420,height=350');
		}
		
		function traerDatos_#Attributes.name#(obj){
			<cfset funcion="">
			<cfif isdefined('Attributes.funcionT') and Len(Trim(Attributes.funcionT))>
				<cfset funcion="&funcionT=#Attributes.funcionT#">
			</cfif>
			traerDatos_#Attributes.name#_popup(obj.value,"#funcion#");
		}
		
		function traerDatos_#Attributes.name#_popup(valor,funcion){
			document.getElementById('ifrCambioDatos_#Attributes.name#').src = "/cfmx/sif/Utiles/ConceptoGatosIngresos.cfm?codigo="+valor+"&formName=#Attributes.form#&name=#Attributes.name#&filtro=#Attributes.filtro#&ultimoNivel=#Attributes.ultimoNivel#"+funcion;
		}
		</cfoutput>
	</cfif>
</script>
<cffunction name="fnGetHijos" returntype="query" access="private" output="true">
  	<cfargument name='idPadre'		type='numeric' 	required='true'>
	<cfargument name='Ecodigo'		type='numeric' 	required='no' default="#session.Ecodigo#">	
	<cfargument name='Conexion'		type='string' 	required='no' default="#session.dsn#">	
		
   <cfquery datasource="#Arguments.Conexion#" name="Arguments.rsSQL">
		select 	FPCCid, FPCCcodigo, #Spart_Desc#  #_Cat# case when #Len_Desc# > #longuitud# then '...' else '' end  as FPCCdescripcion, FPCCidPadre, FPCCconcepto, FPCCTablaC,
		(select count(1) from FPCatConcepto as hijos where hijos.Ecodigo = #Arguments.Ecodigo# and hijos.FPCCidPadre = padre.FPCCid) as cantHijos
		from FPCatConcepto padre
		where padre.Ecodigo = #Arguments.Ecodigo# and padre.FPCCidPadre = #Arguments.idPadre#
		#preservesinglequotes(Attributes.filtro)#
		order by padre.FPCCcodigo, padre.FPCCdescripcion
	</cfquery>
	<cfloop query="Arguments.rsSQL">
		<cfset funcion ="">
		<cfif not Attributes.mostrarConceptos>
			<cfset funcion ="javascript:fnSumbit_#Attributes.name#(#Arguments.rsSQL.FPCCid#);">
		</cfif>
		<cfif Attributes.ultimoNivel and (ListFind(ListFPCCconceptoCon, arguments.rsSQL.FPCCconcepto) and len(trim(Arguments.rsSQL.FPCCTablaC))) OR (ListFind(ListFPCCconceptoSin, Arguments.rsSQL.FPCCconcepto) and Arguments.rsSQL.cantHijos EQ 0) and not Attributes.mostrarConceptos>
			<cfset funcion="javascript:fnSumbit_#Attributes.name#(#Arguments.rsSQL.FPCCid#);">
		</cfif>
		<cfif Attributes.desIrA>
			<cfset funcion ="">
		</cfif>
		<cfif (ListFind(ListFPCCconceptoCon, Arguments.rsSQL.FPCCconcepto) and len(trim(Arguments.rsSQL.FPCCTablaC))) OR (ListFind(ListFPCCconceptoSin, Arguments.rsSQL.FPCCconcepto) and Arguments.rsSQL.cantHijos EQ 0)>
			<cfset icon = '/cfmx/sif/imagenes/Script.gif'>
		<cfelse>
			<cfset icon = '/cfmx/sif/imagenes/MasterDetail.gif'>
		</cfif>
		<cfif arguments.rsSQL.cantHijos gt 0>
			var treeTemp#arguments.rsSQL.FPCCid# = LvarSIS;
			var LvarMOD = new WebFXTreeItem("#Arguments.rsSQL.FPCCcodigo#: #Arguments.rsSQL.FPCCdescripcion#","#funcion#",LvarSIS,"#icon#","#icon#");
			<cfif Attributes.selecionadoCAT eq Arguments.rsSQL.FPCCid>
				var idExpandirCAT = LvarMOD.id;
				<cfset pintarCAT = true>
			</cfif>
			LvarSIS = LvarMOD;
			<cfset fnGetHijos(Arguments.rsSQL.FPCCid,Arguments.Ecodigo,Arguments.Conexion)>
			LvarSIS = treeTemp#Arguments.rsSQL.FPCCid#;
		<cfelse>
			var LvarMOD = new WebFXTreeItem("#Arguments.rsSQL.FPCCcodigo#: #Arguments.rsSQL.FPCCdescripcion#","#funcion#",LvarSIS,"#icon#","#icon#");
			<cfif Attributes.selecionadoCAT eq Arguments.rsSQL.FPCCid>
				var idExpandirCAT = LvarMOD.id;
				<cfset pintarCAT = true>
			</cfif>
			<cfif Attributes.mostrarConceptos>
				<cfset fnGetConceptos(Arguments.rsSQL.FPCCid,Arguments.Conexion)>
			</cfif> 
		</cfif>
	</cfloop>
	<cfreturn Arguments.rsSQL>
</cffunction>

<!--- Pintado de los conceptos pertenecientes a la clasificación--->
<cffunction name="fnGetConceptos"   returntype="void" access="private" output="true">
  	<cfargument name='FPCCid'		type='numeric' 	required='yes'>
	<cfargument name='Conexion'		type='string' 	required='no' default="#session.dsn#">	
	
	<cfquery name="rsConceptos" datasource="#Arguments.Conexion#">
		select FPCid, FPCCid, FPCcodigo, #Spart_Desc2#  #_Cat# case when #Len_Desc2# > #longuitud# then '...' else '' end  as FPCdescripcion, ts_rversion
			from FPConcepto
		where FPCCid = #Arguments.FPCCid#
	</cfquery>
	
	<cfloop query="rsConceptos">
		<cfset funcion ="javascript:fnSumbit_#Attributes.name#(#rsConceptos.FPCid#,#rsConceptos.FPCCid#);">
		<cfif Attributes.desIrA>
			<cfset funcion ="">
		</cfif>
		var icon = '/cfmx/sif/imagenes/Documentos.gif';
		webFXTreeConfig.tIcon='/cfmx/sif/js/xtree/images/T.png';
		webFXTreeConfig.lIcon='/cfmx/sif/js/xtree/images/L.png';
		var LvarMODC = new WebFXTreeItem("#replace(rsConceptos.FPCcodigo,'"','''','ALL')#: #replace(rsConceptos.FPCdescripcion,'"','''','ALL')#","#funcion#",LvarMOD,icon,icon);
		<cfif Attributes.selecionadoCON eq rsConceptos.FPCid>
			var idExpandirCON = LvarMODC.id;
			<cfset pintarCON = true>
		</cfif>
	</cfloop>
	
</cffunction>
	
<!--- Obtiene la categoria padre absoluta de la rama del arbol selecionada --->
<cffunction name="fnGetCategoriaAbsoluta" returntype="query" access="private">
  	<cfargument name='FPCCid'		type='numeric' 	required='true'>
	<cfargument name='Ecodigo'		type='numeric' 	required='no' default="#session.Ecodigo#">	
	<cfargument name='Conexion'		type='string' 	required='no' default="#session.dsn#">	
			
	<cfquery datasource="#Arguments.Conexion#" 	name="rsPath">
		select FPCCpath
		from FPCatConcepto 
		where FPCCid = #Arguments.FPCCid#
	</cfquery>
	<cfif Arguments.FPCCid neq -1 and (rsPath.recordcount eq 0 or not len(trim(rsPath.FPCCpath))) ><!--- Valor por deafualt -1, con este valor no se debe de obtener el padre por lo que no se debe de enviar el error. --->
		<cfthrow message="El path de las clasificaciones no ha sido generado, debe de ir al catálago de Clasifiaciones de Conceptos y generarlo, Proceso Cancelado.">
	</cfif>
	<cfif Arguments.FPCCid eq -1>
		<cfset defQuery = QueryNew("FPCCid")>
		<cfset QueryAddRow(defQuery)>
		<cfset QuerySetCell(defQuery,'FPCCid',-1)>
		<cfreturn defQuery>
	</cfif>
	<cfset path = listGetAt(rsPath.FPCCpath,1,'/')><!--- Se obtiene el 1° valor del path, ya que este corresponde con el codigo del padre absoluto --->
	<cfquery datasource="#Arguments.Conexion#" name="rsPadreAbsoluto">
		select FPCCid, Ecodigo, FPCCcodigo, FPCCdescripcion, FPCCtipo, FPCCconcepto, FPCCcomplementoC, FPCCcomplementoP,
		  FPCCidPadre, BMUsucodigo, ts_rversion, FPCCTablaC, FPCCExigeFecha, FPCCpath
		from FPCatConcepto 
		where FPCCcodigo = '#path#' <!--- El path coincide con el codigo de la clasificación --->
		  and Ecodigo = #Arguments.Ecodigo#
	</cfquery>
	<cfreturn rsPadreAbsoluto>
	
</cffunction>

