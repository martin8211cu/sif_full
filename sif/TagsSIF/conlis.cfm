<cfsilent>
<cfif ThisTag.ExecutionMode NEQ "START">
	<cfreturn>
</cfif>
<!--- TAG CONLIS VERSION 2

		DESCRIPCIÓN DE LOS PARÁMETROS

		1	Campos es requerido, corresponde a los campos que va a pintar el tag en la pantalla que lo invoque.
			Nota:Si tengo el conlis en un ciclo y lo repito de forma dinamica para que sirva la asignacion de los campos hay que ponerlos asi; campos="Cmayor_#variable#=Cmayor, Cdescripcion_#variable#=Cdescripcion"   
		2	Desplegables (S,N,), indica cuales de los campos van a ser desplegables (text) y cuales no (hidden) en la pantalla que lo invoque.
		3	Size (int,int,), indica el tamaño de los objetos desplegables en la pantalla que lo invoque.
		4	Values, ValuesArray[] (any,any,) indica el valor de los objetos en la pantalla que lo invoque, Se adicionó Values Array, para soportar los valores que puedan contener comas, como por ejemplo las descripciones, se recomienda el uso de un arreglo para pasar los valores, el uso sería crear un arreglo, agregar los valores y pasar el arreglo al tag a través de este parámetro (valuesArray).
		5	Title, indica el título del Conlis.
		6	Tabla es requerido, indica la sección del from del Query que se realizará para el mostrar el Conlis. ***
		7	Columna es requerido, indica la sección del select del Query que se realizará para el mostrar el Conlis. ***
		8	Filtro, indica la sección del where del Query que se realizará para el mostrar el Conlis. ***
		9	Desplegar, indica cuales campos desplegar en la lista del Conlis.
		10	Etiquetas, indica las Etiquetas de las Columnas de la lista del Conlis.
		11	Formatos, indica los Formatos de las Columnas de la lista del Conlis.
		12	Align, Indica el justificado de las Columnas de la lista del Conlis.
		13	Asignar, indica cuales a campos debe asignarles valor en la pantalla que lo invoca. Los campos pueden ser campos pintados por el conlis a través del parámetro campos, o pueden ser pintados en la pantalla pero no por el conlis, pero SI tienen que pertenecer al mismo form.
		14	Asignarformatos, formato para los datos que asigna el conlis.
		15	MaxRows, cantidad de columnas a mostrar por el conlis.
		16	MaxRowsQuery, cantidad de columnas a traer por el query.
		17	Cortes, cortes para la lista del conlis.
		18	Totales, totales para la lista del conlis.
		19	Totalgenerales, totales generales para la lista del conlis.
		20	Conexion, DSN para la consulta para llenar el conlis.
		21	Form, form donde residiran los campos a asignar, y pintar por el conlis, por defecto form1.
		22	Debug, para debuguear el Conlis.
		23 showEmptyListMsg, mostrar mensaje de nohay registros
		24 EmptyListMsg, mensaje de no hay registros
		26 Modificables, Los campos identificados como modificables admiten escritura y buscan por dicho campo en el evento on blur los demás datos asignables, Actualmente tiene uin problema cuando el valor que se quiere utilizar para buscar es un texto que contenga acentuación o algún otro tipo de caracter extraño, porque los valores no llegan bien al archivo que hace la busqueda.
		27 Funcion Funcion a ejecutar al cerrar el conlis o traer el dato al digitar.
		27B Fparams Parametros de la función a ejecutar
		*** EN LOS PARÁMETROS DEL SELECT MUCHAS VECES SE REQUIERE TOMAR DATOS DE LA PANTALLA DONDE RESIDE EL CONLIS, PARA ESTE EFECTO SE ADICIONÓ UNA FUNCIONALIDAD PARA LEER ESTOS DATOS ANTES DE LEVANTAR EL CONLIS Y UTILIZARLOS EN LA CONSULTA DEL MISMO. LA SINTAXIS QUE DEBE UTILIZARSE ES LA SIGUIENTE:
		28	left
		29	top
		30	width
		31	height

		32 alt 				se utiliza para colocar un alt en cada input y permite disparar errores más descriptivos
		33 permiteNuevo		se utiliza para permitir el llenado del campo en un formulario de alta sin que se borre lo digitado al realizar el onblur
		34 onfocus
		35 onkeyup
		36 onchange
		37 onkeydown
		38 onkeypress
		39 onblur
		40 funcionValorEnBlanco
		
		SINTAXIS $campo,tipo$
		
		$CAMPO,TIPO$, EJEMPLO SELECT * FROM PAIS WHERE IDIOMA = $IDIOMA,INT$
		
		DONDE IDIOMA ES UN CAMPO VARIABLE POR EL USUARIO, CON VALORES ENTEROS QUE RESIDE EN EL FORM  QUE INVOCA EL CONLIS. 


	Ejemplo 1 (Ojo existen comentarios entre lineas, que no correrían si se toma el ejemplo y se pone en la pantalla, para ver el ejemplo corriendo se requiere quitar los comentarios y debe introducirse el tag dentro de un form llamado form1, además deben existir los siguientes campos en el form: Mnombre, EMtipocambio, EMfecha, Bid, Ocodigo. Esto porque el ejemplo asigna los primeros 2 valores, y toma datos de los otros 3):
	
			<cf_conlis 
			-----El título se muestra en el Conlis y en el onMouseOver de la Imágen que levanta el Conlis.
			title="Lista de Cuentas Bancarias"
			-----Campos que van a ser pintados por el tag en la pantalla donde se coloque.
			campos = "CBid, CBcodigo, CBdescripcion, Mcodigo" 
			-----Indica cuales de los campos que van a ser pintados en la panalla van a ser visibles (TextBox) y cuales No (Hidden).
			desplegables = "N,S,S,N" 
			-----Indica cuales campos van a ser modificables y cuales no (readonly), cuando hay campos modificables, se presenta la funcionalidad busqueda al salir del campo en que se digitó, mejor conocido como TAG, y cuando no hay campos modificables, únicames se muestra una lista de selección, mejor conocido como conlis, cuando hay funcionalidad TAG, también hay conlis. Los campos modificables deben ser desplegables, sino son desplegables, se omite funcionalidad de modificable.
			modificables = "N,S,N,N"
			-----Tamaño de los objetos desplegables, el tamaño asignado a los objetos no desplegables se omite.
			size = "0,0,40,0"
			-----Valores iniciales de los campos pintados por el tag.
			valuesarray="#Lvar_valuesArray#" 
			-----Tabla para el query, como se observa puede llevar una sintaxis compleja que involucre joins, subqueries, parámetros que cambian dinámicamente en el form donde reside el tag(ver uso de sintaxis $campo,tipo$), variables de coldfusion que serán asignadas en el servidor cuando se este generando el html, que será retornado al cliente.
			tabla="CuentasBancos cb
				inner join Monedas m 
					on cb.Mcodigo = m.Mcodigo
				inner join Empresas e
					on e.Ecodigo = cb.Ecodigo
				left outer join Htipocambio tc
					on cb.Ecodigo = tc.Ecodigo
					and cb.Mcodigo = tc.Mcodigo
					and tc.Hfecha = (
						select max(tc1.Hfecha) 
						from Htipocambio tc1 
						where tc1.Ecodigo = tc.Ecodigo
						and tc1.Mcodigo = tc.Mcodigo
						and tc1.Hfecha <=  $EMfecha,date$
					)"
			-----Columnas a retornar por el query, como se obserba, al igual que la tabla puede llevar una sintaxis compleja.
			columnas="cb.CBid, cb.CBcodigo, cb.CBdescripcion, cb.Mcodigo, 
						m.Mnombre,
						round(
							coalesce(
							(	case 
								when cb.Mcodigo = e.Mcodigo then 1.00 
								else tc.TCcompra 
								end
							)
							, 1.00)
						,2) as EMtipocambio"
			-----filtro del query, , como se obserba, al igual que la tabla puede llevar una sintaxis compleja.
			filtro="cb.Ecodigo = #Session.Ecodigo# and cb.Bid = $Bid,numeric$ and cb.Ocodigo = $Ocodigo,numeric$ order by Mnombre, Hfecha"
			and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			-----campos del query a desplegar la lista del Conlis.
			desplegar="CBcodigo, CBdescripcion"
			-----etiquetas de la lista del Conlis.
			etiquetas="C&oacute;digo, Descripci&oacute;n"
			-----formatos de los campos a desplegar en la lista del Conlis.
			formatos="S,S"
			-----alineamiento de los campos de la lista del Conlis.
			align="left,left"
			-----cortes de la lista del Conlis
			cortes="Mnombre"
			-----campos a asignar cuando se seleccione un item del Conlis, como se observa se pueden asignar mas campos de los pintados por el tag, esto implica que estos campos deben existir en la pantalla donde se pinta el tag.
			asignar="CBid, CBcodigo, CBdescripcion, Mcodigo, Mnombre, EMtipocambio"
			-----formatos de los valores a asignar a los campos cuando se seleccione un item del Conlis.
			asignarformatos="S,S,S,S,S,M">
			-----puden existir mas parámetros no utilizados en este ejemplo, ver sección de DESCRIPCIÓN DE LOS PARÁMETROS para ver la totalidade los posibles parámetros.

	* Modificado por Ing. Óscar Bonilla Calderón, 02/AGO/2006
	*
	* Mejoras al conlis:
	*	- Implementa el <CF_enterKey>
	*		los campos del filtro automátido siempre harán un enterAction='submit'
	*	- Implementa el control de lecturas pendientes <cf_IFramesStatus>
	*	- si hay más de un resultado, se invoca al WindowsPopup para que el usuario escoja uno de los resultados obtenidos
	*	- facilidad para utilizar nombres de campo diferentes en el form y en el query
	*		campos	="CampoColumnaIgual,CampoEnForm=ColumnaEnQuery,..."
	*		asignar	="CampoColumnaIgual,CampoEnForm=ColumnaEnQuery,..."
	*	- permite realizar un TraerInicial con un TraerFiltro fijo, en lugar de utilizar values o valuesArray
	*	- no requiere llenar todos los parámetros de lista, se llenan con defaults (antes daba error)
	*	- Por default, no traeDatos si no se modifica el campo. Si se quiere que siempre lea los valores:
	*		traerDatoOnBlur="true"
	*	- FuncionValorEnBlanco: puede o no tener parámetros, 
	*	  	y se ejecuta tanto cuando se deja el valor en blanco, o cuando no se encuentran datos
	*	  	y se ejecuta tanto cuando permiteNuevo es verdadero o falso
	*	- El atributo enterAction cambia el comportamiento del <enter> para todos los CAMPOS del conlis con respecto al enterActionDefault
	*	- Se creo una JS función para encender y apagar el readOnly de todos los CAMPOS del conlis, tanto readonly, borde y tabindex:
	*		setReadOnly_FORM_PRIMERCAMPO(true/false)
	*
 --->
 <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron Registros " XmlFile="/commons/generales.xml" returnvariable="LB_NoSeEncontraronRegistros"/> 

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
<cfparam name="Attributes.EmptyListMsg" 			type="string" default="--- #LB_NoSeEncontraronRegistros# ---">
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

<cfparam name="Attributes.enterAction" 	default="" 		   type="string">							<!--- Cambia el enterAction default del cf_onEnter: submit, tab, none --->
<cfparam name="Attributes.tamanoLetra" 	default="-1" 		type="string">	
<cfparam name="Attributes.MAXCONLISES" 		default="25" 		type="numeric">	
<cfparam name="Attributes.checkboxes" 		default="N" 		type="string">
<cfparam name="Attributes.Valores" 			default="" 		   type="string">	
<cfparam name="Attributes.TranslateDataCols" 					default=""	   type="string">	
<cfparam name="Attributes.AgregarEnLista" 					default="false"	   type="boolean">	
<cfparam name="Attributes.ListaIdDefault" 	default="" 				type="string"><!--- Se pinta en lista los id indicados en este parametros, siempre que exista AgregarEnlista="true" --->
<cfparam name="Attributes.mensajeValoresRequeridos" 	default=""	type="string">
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
<cfset Attributes.Campos 		= ArrayToList(LvarArrayCampos)>
<cfset Attributes.CamposCols 	= ArrayToList(LvarArrayCols)>
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
		<cf_errorCode	code = "50590" msg = "ERROR EN LA DEFINICION DEL CF_CONLIS: Los Siguientes Parámetros son excluyentes: values/valuesarray, traerInicial.">
	<cfelseif len(trim(Attributes.traerFiltro)) EQ 0>
		<cf_errorCode	code = "50591" msg = "ERROR EN LA DEFINICION DEL CF_CONLIS: Los Siguientes Parámetros deben definirse juntos: traerInicial, traerFiltro.">
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
				<cf_errorCode	code = "50592"
								msg  = "ERROR EN LA DEFINICION DEL CF_CONLIS: Si hay una columna requerida '@errorDat_1@', sólo puede haber un único campo modificable que corresponda a dicha columna."
								errorDat_1="#Attributes.desplegararray[LvarRequeridoIdx]#"
				>
			</cfif>
			<cfset LvarRequeridoIdx = listFind(Attributes.requeridos,"S")>
			<cfset LvarCampoIdx = listFind(Attributes.CamposCols,Attributes.desplegararray[LvarRequeridoIdx])>
			<cfif LvarCampoIdx EQ 0 OR Attributes.desplegablesArray[LvarCampoIdx]&Attributes.modificablesArray[LvarCampoIdx] NEQ "SS">
				<cf_errorCode	code = "50593"
								msg  = "ERROR EN LA DEFINICION DEL CF_CONLIS: Si hay una columna requerida '@errorDat_1@', debe corresponder al único campo modificable."
								errorDat_1="#Attributes.desplegararray[LvarRequeridoIdx]#"
				>
			</cfif>
		<cfelseif Lvar_nModificables NEQ 0>
			<cf_errorCode	code = "50594" msg = "ERROR EN LA DEFINICION DEL CF_CONLIS: Si hay mas de una columna requerida, no puede haber campos modificables.">
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
	<cf_errorCode	code = "50595" msg = "ERROR EN LA DEFINICION DEL CF_CONLIS: Los Siguientes Parámetros deben concordar en longitud de items con campos: desplegables, size, values.">
</cfif>


<!--- EL TAG CONLIS MANEJA LOS PARÁMETROS HACIA EL CONLIS POR MEDIO DE ESTRUCTURAS EN LA SESSION, PARA SABER CUAL ESTRUCTURA CORRESPONDE A UN CONSECUTIVO ESPECÍFICO SE LLEVA UN CONSECUTIVO EN LA SESSION --->
<cfset MAXCONLISES = attributes.MAXCONLISES>
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
<cfelseif Request.Conlises.Identity GTE 1 and Request.Conlises.Identity LT (MAXCONLISES+50)>
	<cfset Request.Conlises.Identity = Request.Conlises.Identity + 1>
<cfelse>
	<cf_errorCode	code = "50596"
					msg  = "ERROR EN LA EJECUCION DEL CF_CONLIS: No se permiten más de @errorDat_1@ conlis en el Request"
					errorDat_1="#MAXCONLISES#"
	>
</cfif>

<cfif Attributes.form NEQ "form1">
	<cfset LvarFuncion1 = "_#Trim(Attributes.form)#_#Trim(Attributes.camposarray[1])#">
<cfelse>
	<cfset LvarFuncion1 = "#Trim(Attributes.camposarray[1])#">
</cfif>
<!--- DEFINE ESTRUCTURA CON PARAMETROS PARA CONLIS --->
<!--- VERSION 1.1 PARAMETROS POR ESTRUCTURA EN LA SESSION --->
<cfinvoke component="sif.Componentes.Translate" 	method="Translate" 	Key="MSG_ElValorDe" 	Default="El valor de" xmlfile="/rh/generales.xml"	returnvariable="MSG_ElValorDe"/>
<cfinvoke component="sif.Componentes.Translate" 	method="Translate" 	Key="MSG_esRequeridoParaRealizarEstaAccion" xmlfile="/rh/generales.xml"	Default="es requerido para realizar esta acción" 	returnvariable="MSG_esRequeridoParaRealizarEstaAccion"/>
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
								if (document.#Attributes.form#.#name#.value=='' || document.#Attributes.form#.#name#.value==undefined){
									if (window.#Attributes.objForm# && #Attributes.objForm#.#name#) description = #Attributes.objForm#.#name#.description;
									else if (document.#Attributes.form#.#name#.alt) description = document.#Attributes.form#.#name#.alt;
									else description = '#name#';
									if('#trim(Attributes.mensajeValoresRequeridos)#'!=''){description='#trim(Attributes.mensajeValoresRequeridos)#'}
									alert(description + ' #MSG_esRequeridoParaRealizarEstaAccion#.'); 
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
	StructInsert(Conlis, "checkboxes", Attributes.checkboxes);
	StructInsert(Conlis, "TranslateDataCols", Attributes.TranslateDataCols);
	
	
	if (Attributes.checkboxes == 'S'){
		StructInsert(Conlis, "botones", "Agregar");
		StructInsert(Conlis, "showLink", 'false');
		StructInsert(Conlis, "Valores", Attributes.Valores);
		
	}else if (Attributes.checkboxes == 'N'){
		StructInsert(Conlis, "showLink", 'true');
		StructInsert(Conlis, "botones", "");
		StructInsert(Conlis, "Valores","");
	}
	StructInsert(Conlis, "sufijoFuncion", "#LvarFuncion1#");
	
	for(i in Attributes){
		if ( mid(i,1,2) == 'rs'){
			StructInsert(Conlis, i, evaluate("attributes."&i));
		}
	}
	
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
		  popUpWin#LvarFuncion1# = open(URLStr, 'popUpWin#LvarFuncion1#', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
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
			popUpWindow#LvarFuncion1#('/cfmx/sif/Utiles/ConlisPopUp.cfm?c=#Session.Conlises.Identity#'+conlisArgs,#Attributes.left#,#Attributes.top#,#Attributes.width#,#Attributes.height#);
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
						document.getElementById('frame#LvarFuncion1#').src = '/cfmx/sif/Utiles/ConlisPopUp.cfm?query=1&c=#Session.Conlises.Identity#&CampoOnTrae=#Trim(Attributes.camposarray[item])#'+conlisArgs;
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
	<div style="display: inline-block; white-space: nowrap;" id="Conlis_Table_#Attributes.tabindex#">
			<cfloop from="1" to="#LvarCamposArrayN#" index="item">
				<cfif Attributes.form NEQ "form1">
					<cfset LvarFuncionItem = "_#Trim(Attributes.form)#_#Trim(Attributes.camposarray[item])#">
				<cfelse>
					<cfset LvarFuncionItem = "#Trim(Attributes.camposarray[item])#">
				</cfif>

				
					<cfif Attributes.desplegablesarray[item] EQ "S">
						<input style="font-size:#Attributes.tamanoLetra#px;" type="text" id="#Trim(Attributes.camposarray[item])#" name="#Trim(Attributes.camposarray[item])#"
							value="<cfif len(Attributes.valuesarray[item])>#HTMLEditFormat(Trim(Attributes.valuesarray[item]))#</cfif>" <cfif Attributes.sizearray[item] GT 0>size="#Attributes.sizearray[item]#"</cfif> 
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
						<input type="hidden" id="#Trim(Attributes.camposarray[item])#"  name="#Trim(Attributes.camposarray[item])#" value="<cfif not IsBinary(Attributes.valuesarray[item]) and len(trim(Attributes.valuesarray[item]))>#HTMLEditFormat(Trim(Attributes.valuesarray[item]))#</cfif>" alt="#Attributes.altarray[item]#">
					</cfif>
				
			</cfloop>

			<cfif not Attributes.readonly>
			

				<a href="javascript:doConlis#LvarFuncion1#();" tabindex="-1" id="img#LvarFuncion1#">
					<img src="/cfmx/sif/imagenes/Description.gif"
						alt="#Attributes.title#"
						name="imagen#LvarFuncion1#"
						width="18" height="14"
						border="0" align="absmiddle">
				</a>		
		
			</cfif>
			<cfif Attributes.checkboxes eq 'S'>
				
					<input type="hidden" id="ValuesChecked"  name="ValuesChecked" value="">
				
			</cfif>
			<cfif attributes.AgregarEnLista>
           
				<button type="button" class="btn btn-default btn-add" onclick="fnAgregarEnLista#Attributes.tabindex#()">+</button>
           
			</cfif>
		
		<cfif attributes.AgregarEnLista>
			<cfif len(trim(Attributes.ListaIdDefault))>
					<cfset LvarConlisFiltroListaDefault=''><cfset LvarConlisEL=''>
					<cfloop from="1" to="#LvarCamposArrayN#" index="item">
						<cfif Attributes.desplegablesarray[item] EQ "N">
							<cfset LvarConlisFiltroListaDefault=listGetAt(Attributes.Columnas, item)>
							<cfset LvarConlisEL='#Trim(Attributes.camposarray[item])#'>
							<cfbreak>
						</cfif>
					</cfloop>
					 
					<cfquery datasource="#attributes.conexion#" name="rslistaDefaultConlis">
						select 1<cfloop list="#attributes.Columnas#" index="item">,#item#</cfloop>
						from #preserveSingleQuotes(attributes.tabla)#
						where #LvarConlisFiltroListaDefault# in (#Attributes.ListaIdDefault#)
					</cfquery>
				<cfif rslistaDefaultConlis.recordcount>
					<cfloop query="rslistaDefaultConlis">			
						<tr>
							<cfset position=0>
							<cfloop list="#attributes.Desplegables#" index="i"><cfset position+=1><td><cfif i eq 'N'><input type="hidden" id="Lista#LvarConlisEL#" name="Lista#LvarConlisEL#" value="#evaluate(listGetAt(attributes.Asignar, position))#"><cfelse>#evaluate(listGetAt(attributes.Asignar, position))#</cfif></td></cfloop>
							<td><i class="fa fa-times fa-1x" style="color:red" onclick="$(this).parent().parent().remove()"></i></td>
						</tr>	
					</cfloop>			
				</cfif>

			</cfif>
		</cfif>	
	</div>

		<iframe id="frame#LvarFuncion1#" name="frame#LvarFuncion1#" marginheight="0" marginwidth="0" frameborder="0" 
			<cfif Attributes.debug>
				height="60" width="600" scrolling="yes" style="display:yes"
			<cfelse>
				height="0" width="0" scrolling="no" style="display:none"
			</cfif>
		></iframe>
	<cfif Attributes.traerInicial>
		<script language="javascript">
		//traerInicial
		<cfif trim(conlisArgs) NEQ "">
			function traeInicial#LvarFuncionItem#()
			{
				var conlisArgs = '';
				#conlisArgs#
				document.getElementById('frame#LvarFuncion1#').src = '/cfmx/sif/Utiles/ConlisPopUp.cfm?query=1&c=#Session.Conlises.Identity#&CampoOnTrae=*traerInicial*'+conlisArgs;
			}
			traeInicial#LvarFuncionItem#();
		<cfelse>
			document.getElementById('frame#LvarFuncion1#').src = '/cfmx/sif/Utiles/ConlisPopUp.cfm?query=1&c=#Session.Conlises.Identity#&CampoOnTrae=*traerInicial*';
		</cfif>
		</script>
	</cfif> 
	<cfif attributes.AgregarEnLista>
		<script>
            <cfset LvarConlisEL=''><cfloop from="1" to="#LvarCamposArrayN#" index="item"><cfif Attributes.desplegablesarray[item] EQ "N"><cfset LvarConlisEL='#Trim(Attributes.camposarray[item])#'><cfbreak></cfif></cfloop> 
            function fnAgregarEnLista#Attributes.tabindex#(){
            <cfloop from="1" to="#LvarCamposArrayN#" index="item">var Lvar_#Trim(Attributes.camposarray[item])#=$("###Trim(Attributes.camposarray[item])#").val();</cfloop>if (fnAgregarEnListaReadyadd#Attributes.tabindex#()){$("##Conlis_Table_#Attributes.tabindex#").append('<tr><cfloop from="1" to="#LvarCamposArrayN#" index="item"><td><cfif Attributes.desplegablesarray[item] EQ "S">'+Lvar_#Trim(Attributes.camposarray[item])#+'<cfelse><input type="hidden" id="Lista#Trim(Attributes.camposarray[item])#" name="Lista#Trim(Attributes.camposarray[item])#" value="'+Lvar_#Trim(Attributes.camposarray[item])#+'"></cfif></td></cfloop><td><i class="fa fa-times fa-1x" style="color:red" onclick="$(this).parent().parent().remove()"></i></td></tr>');}<cfloop from="1" to="#LvarCamposArrayN#" index="item">$("###Trim(Attributes.camposarray[item])#").val('');</cfloop>
            }
            function fnAgregarEnListaReadyadd#Attributes.tabindex#(){
            var LvarAdd=true;if($("###LvarConlisEL#").val()!=''){if($("##Lista#LvarConlisEL#").length > 0){$("input[name=Lista#LvarConlisEL#]").each(function(){if ( $(this).val()==$("###LvarConlisEL#").val() ){LvarAdd=false;alert('<cf_translate key="LB_YaSeAgregoEsteElemento" xmlFile="/rh/generales.xml">Ya se Agregó este Elemento</cf_translate>');}})}}else{LvarAdd=false;alert('<cf_translate key="LB_SeleccioneElementoAntesDeAgregar" xmlFile="/rh/generales.xml">Seleccione un elemento antes de agregar</cf_translate>');}return LvarAdd;  
            }
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