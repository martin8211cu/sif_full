<cfsilent>
<cfif ThisTag.ExecutionMode NEQ "START">
	<cfreturn>
</cfif>

<cfparam name="Attributes.campos" 					type="string">									<!--- REQUERIDO Forma: CampoEnForm=ColumnaEnQuery O CampoYColumna --->
<cfparam name="Attributes.desplegables" 			type="string" default="">						<!--- DEFAULT S,S,S... --->
<cfparam name="Attributes.size" 					type="string" default="">						<!--- DEFAULT 20,20,20... --->

<cfparam name="Attributes.values" 					type="string" default="">						<!--- DEFAULT ,,... --->
<cfparam name="Attributes.traerInicial" 			type="boolean" default="no">					<!--- ejecuta traeXXX al cargar el form --->
<cfparam name="Attributes.traerFiltro" 				type="string" default=""> 						<!--- con un filtro fijo que solo se ejecuta la primera vez --->

<cfparam name="Attributes.title" 					type="string" default="Lista">					<!--- DEFAULT Lista --->
<cfparam name="Attributes.tabla" 					type="string">									<!--- REQUERIDO --->
<cfparam name="Attributes.columnas" 				type="string">									<!--- REQUERIDO --->
<cfparam name="Attributes.filtro" 					type="string" default="">						<!--- DEFAULT --->
<cfparam name="Attributes.desplegar" 				type="string" default="#Attributes.columnas#">	<!--- DEFAULT Todas las columnas --->
<cfparam name="Attributes.filtrar_por" 				type="string" default="#Attributes.desplegar#">	<!--- DEFAULT Attributes.desplegar --->
<cfparam name="Attributes.filtrar_por_delimiters"	type="string" default=",">						<!--- DEFAULT coma (,) --->
<cfparam name="Attributes.etiquetas" 				type="string" default="#Attributes.desplegar#">	<!--- DEFAULT Nombres de las columnas --->
<cfparam name="Attributes.formatos" 				type="string" default="">						<!--- DEFAULT S,S,S... --->
<cfparam name="Attributes.align" 					type="string" default="">						<!--- DEFAULT left,left,left... --->
<cfparam name="Attributes.asignar" 					type="string" default="">						<!--- DEFAULT Todas las columnas, Forma: CampoEnForm=ColumnaEnQuery O CampoYColumna --->
<cfparam name="Attributes.asignarformatos" 			type="string" default="">						<!--- DEFAULT S,S,S... --->
<cfparam name="Attributes.MaxRows" 					type="numeric" default="20">					<!--- DEFAULT 20 --->
<cfparam name="Attributes.MaxRowsQuery" 			type="numeric" default="200">					<!--- DEFAULT 200 --->
<cfparam name="Attributes.Cortes" 					type="string" default="">						<!--- DEFAULT Ninguno --->
<cfparam name="Attributes.totales" 					type="string" default="">						<!--- DEFAULT Ninguna Columna --->
<cfparam name="Attributes.totalgenerales" 			type="string" default="">						<!--- DEFAULT Ninguna Columna --->
<cfparam name="Attributes.conexion" 				type="string" default="">						<!--- DEFAULT #session.dsn# --->
<cfparam name="Attributes.form" 					type="string" default="form1">					<!--- DEFAULT form1 --->
<cfparam name="Attributes.objForm" 					type="string" default="objForm">					<!--- DEFAULT objForm --->
<cfparam name="Attributes.debug" 					type="boolean" default="false">					<!--- DEFAULT No --->
<cfparam name="Attributes.showEmptyListMsg"			type="boolean" default="false">					<!--- DEFAULT False --->
<cfparam name="Attributes.EmptyListMsg" 			type="string" default="--- No se encontraron Registros ---">
<cfparam name="Attributes.modificables" 			type="string" default="">						<!--- DEFAULT N,N,N... --->
<cfparam name="Attributes.funcion" 					type="string" default="">						<!--- Funcion a ejecutar ejemplo con ANA V. --->
<cfparam name="Attributes.fparams" 					type="string" default="">						<!--- Parámetros de la función a ejecutar, ejemplo com Angélica. --->

<cfparam name="Attributes.requeridos" 				type="string" default="">						<!--- DEFAULT N,N,N... --->
<cfparam name="Attributes.tabindex" 				type="numeric" default="0">						<!--- DEFAULT 0 --->

<cfparam name="Attributes.left" 					type="numeric" default="250">					<!--- DEFAULT 250 --->
<cfparam name="Attributes.top" 						type="numeric" default="200">					<!--- DEFAULT 200 --->
<cfparam name="Attributes.width" 					type="numeric" default="650">					<!--- DEFAULT 650 --->
<cfparam name="Attributes.height" 					type="numeric" default="550">					<!--- DEFAULT 550 --->

<cfparam name="Attributes.alt"		 				type="string" default="">						<!--- DEFAULT Attributes.campos --->
<cfparam name="Attributes.permiteNuevo"		 		type="boolean" default="false">					<!--- DEFAULT false --->
<cfparam name="Attributes.closeOnExit" 				type="boolean" default="false">					<!--- DEFAULT false --->

<cfparam name="Attributes.onfocus" 					type="string" default="">						<!--- funciones adicionales asociadas  --->
<cfparam name="Attributes.onkeyup" 					type="string" default="">						<!--- funciones adicionales asociadas  --->
<cfparam name="Attributes.onblur"					type="string" default="">						<!--- funciones adicionales asociadas  --->
<cfparam name="Attributes.onchange" 				type="string" default="">						<!--- funciones adicionales asociadas  --->
<cfparam name="Attributes.onkeydown" 				type="string" default="">						<!--- funciones adicionales asociadas  --->
<cfparam name="Attributes.onkeypress" 				type="string" default="">						<!--- funciones adicionales asociadas  --->
<cfparam name="Attributes.readonly" 				type="boolean" default="no">					<!--- indica si todos los campos son de solo lectura  --->

<cfparam name="Attributes.traerDatoOnBlur"  		type="boolean" default="no">
<cfparam name="Attributes.funcionValorEnBlanco"  	type="string" default="">						<!--- 
																										funcion con/sin parametros que se ejecuta 
																										si se deja el CAMPO en blanco o no existe el valor digitado
																									--->

<cfparam name="Attributes.enterAction" 		default="" 		type="string">							<!--- Cambia el enterAction default del cf_onEnter: submit, tab, none --->
<cfparam name="Attributes.tamanoLetra" 		default="-1" 		type="string">	
</cfsilent>
<!--- 
	INICIALIZA EL CONTROL DE IFramesStatus para la forma
--->
<cfif not isdefined("request.IFramesStatus.#Attributes.form#")><CF_IFramesStatus form="#Attributes.form#" action="initForm"></cfif>
<cfsilent>

<!--- 
	ASIGNA VALORES DEFAULT
--->
<cfif len(trim(Attributes.conexion)) eq 0 and isdefined("session.dsn") and len(trim(session.dsn))>
	<cfset Attributes.conexion = session.dsn>
</cfif>

<!--- ATTRIBUTES DE LOS CAMPOS DE LA PANTALLA --->

<!--- Campos es obligatorio --->
<!--- Determina la equivalencia de campos del form y las columnas del conlis --->
<!--- Campos="campoEnForm=columnaEnConlis, campoYcolumna,..." --->
<cfset LvarArrayCampos = arrayNew(1)>
<cfset LvarArrayCols = arrayNew(1)>
<cfset LvarIdx = 1>
<cfset LvarFuncionTraerInicial = "">
<cfloop index="LvarCampoCol" list="#Attributes.Campos#">
	<cfset LvarEquivalencia = ListToArray("#LvarCampoCol#=*","=")>
	<cfset LvarArrayCampos[LvarIdx] = trim(LvarEquivalencia[1])>
	<cfif LvarEquivalencia[2] EQ "*">
		<cfset LvarArrayCols[LvarIdx] = trim(LvarEquivalencia[1])>
	<cfelse>
		<cfset LvarArrayCols[LvarIdx] = trim(LvarEquivalencia[2])>
	</cfif>
	<cfset LvarIdx = LvarIdx + 1>
</cfloop>
<cfset Attributes.Campos = ArrayToList(LvarArrayCampos)>
<cfset Attributes.CamposCols = ArrayToList(LvarArrayCols)>
<cfset Attributes.camposarray 	= listToArray(Attributes.campos)>
<cfset Attributes.colsarray 	= listToArray(Attributes.camposCols)>
<cfset LvarCamposArrayN 		= arrayLen(Attributes.camposarray)>

<!--- Alt: Rellena los alts faltantes con 'Campos(I)' --->
<cfset sbCompletaArray("alt", Attributes.camposArray, LvarCamposArrayN)>

<!--- Rellena los size faltantes con '20' --->
<cfset sbCompletaArray("size","20",LvarCamposArrayN)>

<!--- Rellena los desplegables faltantes con 'S=Si' --->
<cfset sbCompletaArray("desplegables","S",LvarCamposArrayN)>

<!--- Rellena los modificables faltantes con 'N=No' y los ajusta cuando no son desplegables--->
<cfset sbCompletaArray("modificables","N",LvarCamposArrayN)>
<cfloop index="item" from="1" to="#LvarCamposArrayN#">
	<cfif Attributes.desplegablesarray[item] NEQ "S">
		<cfset Attributes.modificablesarray[item] = "N">
	</cfif>
</cfloop>
<!--- Valores iniciales en pantalla: values/valuesarray o traerFiltro --->
<!--- Verifica traer inicial: excluyente con values/valuesarray, incluyente con traerFiltro --->
<cfif Attributes.traerInicial>
	<cfif Attributes.values NEQ "" OR fnExistsArray("valuesArray")>
		<cf_throw message="ERROR EN LA DEFINICION DEL CF_CONLIS: Los Siguientes Parámetros son excluyentes: values/valuesarray, traerInicial." errorcode="3005">
	<cfelseif len(trim(Attributes.traerFiltro)) EQ 0>
		<cf_throw message="ERROR EN LA DEFINICION DEL CF_CONLIS: Los Siguientes Parámetros deben definirse juntos: traerInicial, traerFiltro." errorcode="3010">
	</cfif>
<cfelse>
	<cfset Attributes.traerFiltro = "">
</cfif>
<!--- Rellena los values faltantes con '' --->
<cfset sbCompletaArray("values","",LvarCamposArrayN)>

<!--- Asignar: es opcional, si no indica se asigna Campos --->
<!--- Determina la equivalencia de campos a asignar en el form y las columnas del conlis --->
<!--- Asignar="campoEnForm=columnaEnConlis, campoYcolumna,..." --->
<cfif Attributes.Asignar EQ "">
	<cfset Attributes.asignar		= Attributes.campos>
	<cfset Attributes.asignarCols	= Attributes.camposCols>
	<cfset LvarAsignarN 			= LvarCamposArrayN>
<cfelse>
	<cfset LvarArrayCampos = arrayNew(1)>
	<cfset LvarArrayCols = arrayNew(1)>
	<cfset LvarIdx = 1>
	<cfloop index="LvarCampoCol" list="#Attributes.asignar#">
		<cfset LvarEquivalencia = ListToArray("#LvarCampoCol#=*","=")>
		<cfset LvarArrayCampos[LvarIdx] = trim(LvarEquivalencia[1])>
		<cfif LvarEquivalencia[2] EQ "*"> 
			<cfset LvarPos = listFind(Attributes.Campos,trim(LvarEquivalencia[1]),",")>
			<cfif LvarPos GT 0>
				<cfset LvarArrayCols[LvarIdx] = listGetAt(Attributes.CamposCols,LvarPos,",")>
			<cfelse>
				<cfset LvarArrayCols[LvarIdx] = trim(LvarEquivalencia[1])>
			</cfif>
		<cfelse>
			<cfset LvarArrayCols[LvarIdx] = trim(LvarEquivalencia[2])>
		</cfif>
		<cfset LvarIdx = LvarIdx + 1>
	</cfloop>
	<cfset Attributes.Asignar = ArrayToList(LvarArrayCampos)>
	<cfset Attributes.AsignarCols = ArrayToList(LvarArrayCols)>
	<cfset LvarAsignarN = LvarIdx - 1>
</cfif>

<!--- Rellena los asignarFormatos faltantes con 'S=String' --->
<cfset sbCompletaArray("asignarformatos","S",LvarAsignarN)>


<!--- ATTRIBUTES DE LAS COLUMNAS DEL PLIST --->

<!--- Desplegar es requerido, si no se coloca se asigna columnas --->
<cfset Attributes.desplegarArray=ListToArray(Attributes.desplegar)>
<cfset LvarDesplegarArrayN = arrayLen(Attributes.desplegarArray)>

<!--- Rellena los formatos faltantes con 'S=String' --->
<cfset sbCompletaArray("formatos","S",LvarDesplegarArrayN)>
<cfset Attributes.formatos = ArrayToList(Attributes.formatosArray)>

<!--- Rellena los aligns faltantes con 'left' --->
<cfset sbCompletaArray("align","left",LvarDesplegarArrayN)>
<cfset Attributes.align = ArrayToList(Attributes.alignarray)>

<!--- Rellena los requeridos faltantes con 'N=No requerido' --->
<cfset sbCompletaArray("requeridos","N",LvarDesplegarArrayN)>
<cfset Attributes.requeridos = ArrayToList(Attributes.requeridosarray)>

<cfset Lvar_nRequeridos = 0>
<cfloop list="#Attributes.requeridos#" index="item">
	<cfif trim(item) EQ "S">
		<cfset Lvar_nRequeridos = Lvar_nRequeridos + 1>
	</cfif>
</cfloop>
<!--- 
	Si hay columnas requeridas se debe cumplir las siguientes reglas:
	.	Puede no haber ningun campo modificable (sólo sirve la imagen)
	.	Si solo hay una columna requerida, puede haber solo 1 campo modificable que corresponda al requerido
	.	Si solo hay mas de una columna requerida, no puede haber campos modificables
--->
<cfif Lvar_nRequeridos NEQ 0>
	<cfset Lvar_nModificables = 0>
	<cfloop index="item" from="1" to="#ArrayLen(Attributes.modificablesArray)#" >
		<cfif Attributes.modificablesArray[item] EQ "S">
			<cfset Lvar_nModificables = Lvar_nModificables + 1>
		</cfif>
	</cfloop>
	
	<cfif Lvar_nModificables NEQ 0>
		<cfif Lvar_nRequeridos EQ 1>
			<cfif Lvar_nModificables GT 1>
				<cf_throw message="ERROR EN LA DEFINICION DEL CF_CONLIS: Si hay una columna requerida '#Attributes.desplegararray[LvarRequeridoIdx]#', sólo puede haber un único campo modificable que corresponda a dicha columna." errorcode="3015">
			</cfif>
			<cfset LvarRequeridoIdx = listFind(Attributes.requeridos,"S")>
			<cfset LvarCampoIdx = listFind(Attributes.CamposCols,Attributes.desplegararray[LvarRequeridoIdx])>
			<cfif LvarCampoIdx EQ 0 OR Attributes.desplegablesArray[LvarCampoIdx]&Attributes.modificablesArray[LvarCampoIdx] NEQ "SS">
				<cf_throw message="ERROR EN LA DEFINICION DEL CF_CONLIS: Si hay una columna requerida '#Attributes.desplegararray[LvarRequeridoIdx]#', debe corresponder al único campo modificable." errorcode="3020">
			</cfif>
		<cfelseif Lvar_nModificables NEQ 0>
			<cf_throw message="ERROR EN LA DEFINICION DEL CF_CONLIS: Si hay mas de una columna requerida, no puede haber campos modificables." errorcode="3025">
		</cfif>
	</cfif>
</cfif>

<!--- 
	Si hay funcion con fparams y traerDatoOnBlur está apagado se debe cumplir las siguientes condiciones, 
	en caso contrario el traerDatoOnBlur se enciende automáticamente para mantener compatibilidad con versiones pasadas:
	.	fparams puede estar vacío
	.	todos los datos del fparams deben estar en asignarCols (son columnas del Plist)
--->
<cfset LvarFparamsCamposValue = "">
<cfif NOT Attributes.traerDatoOnBlur AND Attributes.funcion NEQ "" AND Attributes.fparams NEQ "">
	<cfloop index="item" list="#Attributes.fparams#">
		<cfset LvarPto = listFindNoCase(Attributes.AsignarCols, item)>
		<cfif LvarPto EQ 0>
			<cfset Attributes.traerDatoOnBlur = true>
			<cfbreak>
		</cfif>
		
		<cfset listAppend(LvarFparamsCamposValue,"document.#Attributes.form#.#trim(listGetAt(Attributes.Asignar,LvarPto))#.value")>
	</cfloop>	
</cfif>


<!--- VALIDA LONGITUD DE LOS ARREGLOS --->
<cfif LvarCamposArrayN 	lt arraylen(Attributes.desplegablesarray)
	OR LvarCamposArrayN	lt arraylen(Attributes.sizearray)
	OR LvarCamposArrayN	lt arraylen(Attributes.valuesarray)>
	<cf_throw message="ERROR EN LA DEFINICION DEL CF_CONLIS: Los Siguientes Parámetros deben concordar en longitud de items con campos: desplegables, size, values." errorcode="3030">
</cfif>


<!--- EL TAG CONLIS MANEJA LOS PARÁMETROS HACIA EL CONLIS POR MEDIO DE ESTRUCTURAS EN LA SESSION, PARA SABER CUAL ESTRUCTURA CORRESPONDE A UN CONSECUTIVO ESPECÍFICO SE LLEVA UN CONSECUTIVO EN LA SESSION --->
<cfset MAXCONLISES = 25>
<cfif NOT isdefined("Session.Conlises.Identity") OR len(trim(Session.Conlises.Identity)) EQ 0>
	<cfset Session.Conlises.Identity = 1>
<cfelseif Session.Conlises.Identity GTE 1 and Session.Conlises.Identity LT MAXCONLISES>
	<cfset Session.Conlises.Identity = Session.Conlises.Identity + 1>
<cfelse>
	<cfset Session.Conlises.Identity = 1>
</cfif>
<!--- NO SE PERMITEN MAS #MAXCONLISES# POR REQUEST --->
<cfif NOT isdefined("Request.Conlises.Identity") OR len(trim(Request.Conlises.Identity)) EQ 0>
	<cfset Request.Conlises.Identity = 1>
<cfelseif Request.Conlises.Identity GTE 1 and Request.Conlises.Identity LT MAXCONLISES>
	<cfset Request.Conlises.Identity = Request.Conlises.Identity + 1>
<cfelse>
	<cf_throw message="ERROR EN LA EJECUCION DEL CF_CONLIS: No se permiten más de #MAXCONLISES# conlis en el Request" errorcode="3035">
</cfif>

<cfif Attributes.form NEQ "form1">
	<cfset LvarFuncion1 = "_#Trim(Attributes.form)#_#Trim(Attributes.camposarray[1])#">
<cfelse>
	<cfset LvarFuncion1 = "#Trim(Attributes.camposarray[1])#">
</cfif>
<!--- DEFINE ESTRUCTURA CON PARAMETROS PARA CONLIS --->
<!--- VERSION 1.1 PARAMETROS POR ESTRUCTURA EN LA SESSION --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" 	Key="LB_ElValorDe" Default="El valor de"	returnvariable="LB_ElValorDe"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	Key="LB_EsRequeridoParaRealizarEstaAccion" Default="es requerido para realizar esta acción"	returnvariable="LB_EsRequeridoParaRealizarEstaAccion"/>	
<cfscript>
	agregados = '';
	function prepare(data){
		data = replace(replace(replace(data, '\n', ' ','all'),'\t', ' ','all'),'  ', ' ','all');
		start = 1;
		end = 1;
		enciclado = 1;
		continuar = (find('$',data,1) gt 0);
		while (continuar) {
			start = find('$',data,start);
			if (start lte 1 or enciclado gt 50) break;
			end = find('$',data,start+1);
			namearr=ListToArray(mid(data,start+1,end-start-1));
			name=namearr[1];
			if (ListFind(agregados, name) eq 0) {
				agregados = ListAppend(agregados,name);
				conlisArgs = conlisArgs &
							"	if (!document.#Attributes.form#.#name#){
									alert('Error en atributos del Conlis. El Campo #name# no existe en el form.');
									limpia#LvarFuncion1#();
									return;
								}
								if (document.#Attributes.form#.#name#.value==''){
									if (window.#Attributes.objForm# && #Attributes.objForm#.#name#) description = #Attributes.objForm#.#name#.description;
									else if (document.#Attributes.form#.#name#.alt) description = document.#Attributes.form#.#name#.alt;
									else description = '#name#';
									alert('#LB_ElValorDe# ' + description + ' #LB_EsRequeridoParaRealizarEstaAccion#.');
									limpia#LvarFuncion1#();
									return;
								}
								conlisArgs = conlisArgs + '&#name#=' + document.#Attributes.form#.#name#.value;
								";
			}
			start = end + 1;
			enciclado = enciclado + 1;
		}
		return data;
	}
	if (not isdefined("Session.Conlises.Conlis")){
		Session.Conlises.Conlis = ArrayNew(1);
		ArrayResize(Session.Conlises.Conlis, MAXCONLISES);
	}
	conlisArgs = "";
	Conlis = StructNew();
	StructInsert(Conlis, "title", Attributes.title);
	StructInsert(Conlis, "tabla", prepare(Attributes.tabla));
	StructInsert(Conlis, "columnas", prepare(Attributes.columnas));
	StructInsert(Conlis, "filtro", prepare(Attributes.filtro));
	StructInsert(Conlis, "desplegar", Attributes.desplegar);
	StructInsert(Conlis, "filtrar_por", Attributes.filtrar_por);
	StructInsert(Conlis, "filtrar_por_delimiters", Attributes.filtrar_por_delimiters);
	StructInsert(Conlis, "traerFiltro", Attributes.traerFiltro);
	StructInsert(Conlis, "etiquetas", Attributes.etiquetas);
	StructInsert(Conlis, "formatos", Attributes.formatos);
	StructInsert(Conlis, "align", Attributes.align);
	StructInsert(Conlis, "asignar", Attributes.asignar);
	StructInsert(Conlis, "asignarCols", Attributes.asignarCols);
	StructInsert(Conlis, "asignarformatos", ArrayToList(Attributes.asignarformatosArray));
	StructInsert(Conlis, "MaxRows", Attributes.MaxRows);
	StructInsert(Conlis, "MaxRowsQuery", Attributes.MaxRowsQuery);
	StructInsert(Conlis, "Cortes", Attributes.Cortes);
	StructInsert(Conlis, "totales", Attributes.totales);
	StructInsert(Conlis, "totalgenerales", Attributes.totalgenerales);
	StructInsert(Conlis, "conexion", Attributes.conexion);
	StructInsert(Conlis, "form", Attributes.form);
	StructInsert(Conlis, "debug", Attributes.debug);
	StructInsert(Conlis, "funcion", Attributes.funcion);
	StructInsert(Conlis, "fparams", Attributes.fparams);
	StructInsert(Conlis, "requeridos", Attributes.requeridos);
	StructInsert(Conlis, "showEmptyListMsg", Attributes.showEmptyListMsg);
	StructInsert(Conlis, "EmptyListMsg", Attributes.EmptyListMsg);
	StructInsert(Conlis, "funcionValorEnBlanco", Attributes.funcionValorEnBlanco);
	StructInsert(Conlis, "sufijoFuncion", "#LvarFuncion1#");
	
	Session.Conlises.Conlis[Session.Conlises.Identity] = Conlis;
</cfscript>
</cfsilent>
<cfoutput>
	<!-- CF_conlis: "#Attributes.form#": "#Attributes.campos#" -->
	<script language="JavaScript">
		var popUpWin#LvarFuncion1#=null;
		function popUpWindow#LvarFuncion1#(URLStr, left, top, width, height)
		{
		  if(popUpWin#LvarFuncion1#)
		  {
			if(!popUpWin#LvarFuncion1#.closed) popUpWin#LvarFuncion1#.close();
		  }
		  popUpWin#LvarFuncion1# = open(URLStr, 'popUpWin#LvarFuncion1#', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		  if (! popUpWin#LvarFuncion1# && !document.popupblockerwarning) {
			alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
			document.popupblockerwarning = 1;
		  }
		  else
		  	if(popUpWin#LvarFuncion1#.focus) popUpWin#LvarFuncion1#.focus();
		}
		
		function doConlis#LvarFuncion1#(x)
		{
			var conlisArgs = '';
			#conlisArgs#
			popUpWindow#LvarFuncion1#('/cfmx/rh/Reclutamiento/curriculumExterno/Utiles/ConlisPopUp.cfm?c=#Session.Conlises.Identity#'+conlisArgs,#Attributes.left#,#Attributes.top#,#Attributes.width#,#Attributes.height#);
			<cfif Attributes.closeOnExit>
			if (x) popUpWin#LvarFuncion1#.focus();
			//window.onfocus=closePopup#LvarFuncion1#;
			</cfif>
		}
		<cfif Attributes.closeOnExit>
		function closePopup#LvarFuncion1#() {
			if(popUpWin#LvarFuncion1#){
				if(!popUpWin#LvarFuncion1#.closed) popUpWin#LvarFuncion1#.close();
				popUpWin#LvarFuncion1# = null;
			}
		}
		</cfif>
		
		<cfloop from="1" to="#LvarCamposArrayN#" index="item">
			<cfif Attributes.form NEQ "form1">
				<cfset LvarFuncionItem = "_#Trim(Attributes.form)#_#Trim(Attributes.camposarray[item])#">
			<cfelse>
				<cfset LvarFuncionItem = "#Trim(Attributes.camposarray[item])#">
			</cfif>

			<cfif Attributes.modificablesarray[item] EQ "S">
				function trae#LvarFuncionItem#(pValue, doTraer)
				{
					if (doTraer == false) return;

					if (pValue.replace(/\s+/,"") != "")	
					{
						limpia#LvarFuncion1# (document.#Attributes.form#.#Trim(Attributes.camposarray[item])#);
						var conlisArgs = '';
						#conlisArgs#
						conlisArgs = conlisArgs + '&filtro_#Trim(Attributes.colsarray[item])#=' + escape(pValue);
						<cfif Attributes.permiteNuevo>
							conlisArgs = conlisArgs + '&permiteNuevo=1';
						</cfif>
						<cf_IFramesStatus form=#Attributes.form# campo="#Trim(Attributes.camposarray[item])#" action="jsAppend">
						document.getElementById('frame#LvarFuncion1#').src = '/cfmx/rh/Reclutamiento/curriculumExterno/Utiles/ConlisPopUp.cfm?query=1&c=#Session.Conlises.Identity#&CampoOnTrae=#Trim(Attributes.camposarray[item])#'+conlisArgs;
					} 
					else 
					{ 
					<cfif not Attributes.permiteNuevo>
						if (window.reset#LvarFuncion1#) 
						{
							reset#LvarFuncion1#();
						}
						limpia#LvarFuncion1#();
					</cfif>

					<cfif len(trim(Attributes.funcionValorEnBlanco))>
						<cfset LvarFuncionValorEnBlanco = Attributes.funcionValorEnBlanco>
						<cfset LvarPto = find("(",LvarFuncionValorEnBlanco)>
						<cfif LvarPto EQ 0>
							<cfset LvarPto = len(LvarFuncionValorEnBlanco) + 1>
							<cfset LvarFuncionValorEnBlanco = LvarFuncionValorEnBlanco & "()">
						</cfif>
						if (window.#mid(LvarFuncionValorEnBlanco,1,LvarPto-1)#) 
						{
							#LvarFuncionValorEnBlanco#;
						}
					</cfif>
					}
				}
			</cfif>

		</cfloop>

		function setReadOnly_#Trim(Attributes.form)#_#Trim(Attributes.camposarray[1])#(pReadOnly)
		{
	<cfif not Attributes.readonly>
		<cfset arCampos = Attributes.camposarray>
		<cfloop from="1" to="#LvarCamposArrayN#" index="item"><cfif not Attributes.readonly and Attributes.modificablesarray[item] EQ "S">
			if (pReadOnly)
			{
				document.#Attributes.form#.#trim(arCampos[item])#.tabIndex 			= -1;
				document.#Attributes.form#.#trim(arCampos[item])#.readOnly			= true;
				document.#Attributes.form#.#trim(arCampos[item])#.style.border		= "solid 1px ##CCCCCC";
				document.#Attributes.form#.#trim(arCampos[item])#.style.backGround	= "inherit";
			}
			else
			{
				document.#Attributes.form#.#trim(arCampos[item])#.tabIndex 			= #Attributes.tabindex#;
				document.#Attributes.form#.#trim(arCampos[item])#.readOnly			= false;
				document.#Attributes.form#.#trim(arCampos[item])#.style.border		= window.Event ? "" : "inset 2px";
				document.#Attributes.form#.#trim(arCampos[item])#.style.backGround	= "";
			}
		</cfif></cfloop>
			document.getElementById("img#LvarFuncion1#").style.display = pReadOnly ? "none" : "";
	</cfif>
			return;
		}

		function limpia#LvarFuncion1#(pInput)
		{
		<cfset arAsignar = ListToArray(Attributes.asignar)>
		<cfloop from="1" to="#ArrayLen(arAsignar)#" index="item">
			if (
					document.#Attributes.form#.#trim(arAsignar[item])#
				&&	document.#Attributes.form#.#trim(arAsignar[item])# != pInput
				)
				document.#Attributes.form#.#trim(arAsignar[item])#.value = '';
		</cfloop>
		}	
		
		function conlis_keyup_#LvarFuncion1#(e) {
			var keycode = e.keyCode ? e.keyCode : e.which;
			if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
				doConlis#LvarFuncion1#();
			}
		}
	</script>
	<!--- PINTA TODOS LOS CAMPOS --->
	<table width="1%" border="0" cellspacing="0" cellpadding="0" style="border:0px;">
		<tr>
			<cfloop from="1" to="#LvarCamposArrayN#" index="item">
				<cfif Attributes.form NEQ "form1">
					<cfset LvarFuncionItem = "_#Trim(Attributes.form)#_#Trim(Attributes.camposarray[item])#">
				<cfelse>
					<cfset LvarFuncionItem = "#Trim(Attributes.camposarray[item])#">
				</cfif>

				<td>
					<cfif Attributes.desplegablesarray[item] EQ "S">
						<input 
							style="font-size:#Attributes.tamanoLetra#px;"
						
							type="text" name="#Trim(Attributes.camposarray[item])#"
							value="<cfif len(Attributes.valuesarray[item])>#Trim(Attributes.valuesarray[item])#</cfif>" <cfif Attributes.sizearray[item] GT 0>size="#Attributes.sizearray[item]#"</cfif> 
						<cfif not Attributes.readonly and Attributes.modificablesarray[item] EQ "S">
							tabindex="#Attributes.tabindex#"
							<cfif Attributes.traerDatoOnBlur>
								#fnOnEvent ("",	"onfocus",		"this.select();")#
								#fnOnEvent ("",	"onblur",		"if (this.readOnly) return; trae#LvarFuncionItem#(this.value, true);")#
							<cfelse>
								#fnOnEvent ("",	"onfocus",		"Lvar#Trim(Attributes.camposarray[item])#_valueOri = this.value; this.select();")#
								#fnOnEvent ("var LvarChanged = (Lvar#Trim(Attributes.camposarray[item])#_valueOri != this.value);",
												"onblur",		"if (this.readOnly) return; Lvar#Trim(Attributes.camposarray[item])#_valueOri = ''; trae#LvarFuncionItem#(this.value, LvarChanged);")#
							</cfif>
							#fnOnEvent ("",	"onchange",		"")#
							<cfif Attributes.enterAction NEQ "">
								<cfset LvarEnterAction = "CF_onEnterAction = '#Attributes.enterAction#';">
							<cfelse>
								<cfset LvarEnterAction = "">
							</cfif>
							#fnOnEvent (LvarEnterAction,	"onkeydown",	"")#
							#fnOnEvent (LvarEnterAction,	"onkeypress",	"")#
							#fnOnEvent ("",	"onkeyup",		"conlis_keyup_#LvarFuncion1#(event);")#
						<cfelse>
							tabindex="-1"
							readonly
							style="border:solid 1px ##CCCCCC; background:inherit;"
						</cfif>
							alt="#Attributes.altarray[item]#"
							title="#Attributes.altarray[item]#"
						>
					<cfelse>
						<input type="hidden" name="#Trim(Attributes.camposarray[item])#" value="<cfif not IsBinary(Attributes.valuesarray[item]) and len(trim(Attributes.valuesarray[item]))>#Attributes.valuesarray[item]#</cfif>" alt="#Attributes.altarray[item]#">
					</cfif>
				</td>
			</cfloop>

			<cfif not Attributes.readonly>
			<td>

				<a href="javascript:doConlis#LvarFuncion1#();" tabindex="-1" id="img#LvarFuncion1#">
					<img src="/cfmx/rh/imagenes/Description.gif"
						alt="#Attributes.title#"
						name="imagen#LvarFuncion1#"
						width="18" height="14"
						border="0" align="absmiddle">
				</a>		
			</td>
			</cfif>

		</tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td>
		<iframe id="frame#LvarFuncion1#" name="frame#LvarFuncion1#" marginheight="0" marginwidth="0" frameborder="0" 
			<cfif Attributes.debug>
				height="60" width="600" scrolling="yes" style="display:yes"
			<cfelse>
				height="0" width="0" scrolling="no" style="display:none"
			</cfif>
		></iframe>
	</td>
	</tr>
	</table>
	<cfif Attributes.traerInicial>
		<script language="javascript">
		//traerInicial
		<cfif trim(conlisArgs) NEQ "">
			var conlisArgs = '';
			#conlisArgs#
			document.getElementById('frame#LvarFuncion1#').src = '/cfmx/rh/Reclutamiento/curriculumExterno/Utiles/ConlisPopUp.cfm?query=1&c=#Session.Conlises.Identity#&CampoOnTrae=*traerInicial*'+conlisArgs;
		<cfelse>
			document.getElementById('frame#LvarFuncion1#').src = '/cfmx/rh/Reclutamiento/curriculumExterno/Utiles/ConlisPopUp.cfm?query=1&c=#Session.Conlises.Identity#&CampoOnTrae=*traerInicial*';
		</cfif>
		</script>
	</cfif>
</cfoutput>

<cffunction name="fnOnEvent" output="yes" access="private">
	<cfargument name="prev"		type="string" required="yes">
	<cfargument name="event" 	type="string" required="yes">
	<cfargument name="post"		type="string" required="yes">
	
	<cfset var LvarEvento 		= "">
	<cfset var LvarPrevFunction = trim(Arguments.prev)>
	<cfset var LvarFunction 	= trim(Attributes[Arguments.event])>
	<cfset var LvarPostFunction = trim(Arguments.post)>
	
	<cfif LvarPrevFunction & LvarFunction & LvarPostFunction NEQ "">
		<cfif mid(LvarFunction,1,11) NEQ "javascript:">
			<cfset LvarEvento = "#Arguments.event#=""javascript:">
		<cfelse>
			<cfset LvarEvento = "#Arguments.event#=""">
		</cfif>
		<cfif LvarPrevFunction NEQ "">
			<cfset LvarEvento = LvarEvento & LvarPrevFunction>
			<cfif right(LvarPrevFunction,1) NEQ ";">
				<cfset LvarPrevFunction = LvarPrevFunction & ";">
			</cfif>
		</cfif>
		<cfif LvarFunction NEQ "">
			<cfif NOT find("(",LvarFunction)>
				<cfset LvarFunction = LvarFunction & "(event);">
			<cfelseif right(LvarFunction,1) NEQ ";">
				<cfset LvarFunction = LvarFunction & ";">
			</cfif>
			<cfset LvarEvento = LvarEvento & LvarFunction>
		</cfif>
		<cfif LvarPostFunction NEQ "">
			<cfset LvarEvento = LvarEvento & LvarPostFunction>
		</cfif>
		<cfset LvarEvento = LvarEvento & '"'>
	</cfif>

	<cfreturn LvarEvento>
</cffunction>

<cffunction name="fnExistsArray" output="false" access="private" returntype="boolean">
	<cfargument name="arrayName" type="string" required="yes">

	<cfreturn
		 	   	isDefined	("Attributes.#Arguments.arrayName#")
			AND isArray		(Attributes[Arguments.arrayName])
			AND arrayLen	(Attributes[Arguments.arrayName]) GT 0
	>
</cffunction>

<cffunction name="sbCompletaArray" access="private" output="false">
	<cfargument name="attName" type="string" 	required="yes">
	<cfargument name="default" type="any" 		required="yes">
	<cfargument name="arrayN" type="numeric" 	required="yes">

	<cfset var LvarListName		= Arguments.attName>
	<cfset var LvarArrayName	= "#LvarListName#array">
	<cfset var LvarArrayN		= 0>
	
	<!--- Si no existe el Array, lo crea con los valores del List, si no tiene prioridad el Array --->
	<cfif  NOT fnExistsArray(LvarArrayName)>
		<cfset Attributes[LvarArrayName] = listToArray(Attributes[LvarListName])>
	</cfif>
	<cfset LvarArrayN = arrayLen(Attributes[LvarArrayName])>

	<!--- Ajusta Blancos de los valores existentes --->
	<cfloop index="item" from="1" to="#LvarArrayN#">
		<cfif NOT isbinary(Attributes[LvarArrayName][item])>
			<cfset Attributes[LvarArrayName][item] = trim(Attributes[LvarArrayName][item])>
		</cfif>
	</cfloop>
	<!--- Completa el Array con el valor default --->
	<cfloop index="item" from="#LvarArrayN+1#" to="#Arguments.arrayN#">
		<cfif isArray(Arguments.default)>
			<cfset arrayAppend(Attributes[LvarArrayName], Arguments.default[item])>
		<cfelse>
			<cfset arrayAppend(Attributes[LvarArrayName], trim(Arguments.default))>
		</cfif>
	</cfloop>	
</cffunction>
		
