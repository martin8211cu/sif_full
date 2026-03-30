<!---
<cfquery name="def" datasource="asp">
	select '' as RHPcodigo
</cfquery>
--->
<cfset def = QueryNew("RHPcodigo") >

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.nameMar" default="AFMcodigo" type="string"> <!--- Nombre del Código de la Marca --->
<cfparam name="Attributes.nameMod" default="AFMMcodigo" type="string"> <!--- Nombre del Código del Modelo --->
<cfparam name="Attributes.keyMar" default="AFMid" type="string"> <!--- Nombre de la llave identity de la tabla de Marcas --->
<cfparam name="Attributes.keyMod" default="AFMMid" type="string"> <!--- Nombre de la llave identity de la tabla de Modelos --->
<cfparam name="Attributes.descMar" default="AFMdescripcion" type="string"> <!--- Nombre de la Descripción de la Marca --->
<cfparam name="Attributes.descMod" default="AFMMdescripcion" type="string"> <!--- Nombre de la Descripción del Modelo --->
<cfparam name="Attributes.orientacion" default="V" type="string"> <!--- Orientacion V=Vertical, <> V = Horizontal --->
<cfparam name="Attributes.frameMar" default="frMarcas" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.frameMar" default="frMarcas" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.tabindexMar" default="" type="string"> <!--- número del tabindex para el campo de Marca --->
<cfparam name="Attributes.tabindexMod" default="" type="string"> <!--- número del tabindex para el campo del Modelo --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.altMar" default="" type="string"> <!--- Mensaje para el evento de MouseOver para la Marca --->
<cfparam name="Attributes.altMod" default="" type="string"> <!--- Mensaje para el evento de MouseOver para el Modelo --->
<cfparam name="Attributes.Modificable" default="true" type="boolean">
<cfparam name="Attributes.Aid" default="-1" type="string"> <!---Se agrega atributo del Aid del Activo se ocupa en ActivoFijo/Cambio Valores Activo RVD 04/06/2014--->
<cfparam name="Attributes.funcionMar" default="funcModificarMDef" type="string"><!---Se agrega llamado a esta función para cambio solicitado en AF/CambioValoresActivo
RVD 04/06/2014--->
<cfparam name="Attributes.funcionMod" default="funcModificarModDef" type="string"><!---Se agrega llamado a esta función para cambio solicitado en AF/CambioValoresActivo
RVD 04/06/2014--->

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.nameMar#</cfoutput>(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed)
				popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.nameMar#</cfoutput>(e,opc) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisMarcaMod<cfoutput>#Attributes.nameMar#</cfoutput>(opc);
		}
	}
	//Llama el conlis
	function doConlisMarcaMod<cfoutput>#Attributes.nameMar#</cfoutput>(opc) {
		<cfoutput>
			var params ="";

			if(opc == 1){
			// Conlis de Marcas
				params = "?form=#Attributes.form#&name=#Attributes.nameMar#&desc=#Attributes.descMar#&key=#Attributes.keyMar#&conexion=#Attributes.conexion#&nameMod=#Attributes.nameMod#&descMod=#Attributes.descMod#&keyMod=#Attributes.keyMod#&funcionMar=#Attributes.funcionMar#&Aid=#Attributes.Aid#";

				popUpWindow#Attributes.nameMar#("/cfmx/sif/Utiles/ConlisMarcas.cfm"+params,250,200,650,400);
			}else{
				//Conlis de Modelos
				params = "?form=#Attributes.form#&nameMod=#Attributes.nameMod#&descMod=#Attributes.descMod#&keyMod=#Attributes.keyMod#&funcionMod=#Attributes.funcionMod#&Aid=#Attributes.Aid#&conexion=#Attributes.conexion#&marca=" + document.#Attributes.form#.#Evaluate('Attributes.descMar')#.value + "&codMarca=" + document.#Attributes.form#.#Evaluate('Attributes.keyMar')#.value;

				popUpWindow#Attributes.nameMar#("/cfmx/sif/Utiles/ConlisModelos.cfm"+params,250,200,650,400);
			}
		</cfoutput>
	}

	function TraeModelo<cfoutput>#Attributes.nameMod#</cfoutput>(dato) {
		<cfoutput>
			if (dato!="") {
				if(document.#Attributes.form#.#Evaluate('Attributes.nameMar')#.value == ''){
					alert('Error, primeramente debe elegir la Marca');
					document.#Attributes.form#.#Evaluate('Attributes.nameMod')#.value = '';
					document.#Attributes.form#.#Evaluate('Attributes.nameMar')#.focus();
				}else{
					TraeMarcaMod#Attributes.nameMar#(dato, 2);
				}
			}else{
				eval("document.#Attributes.form#.#Attributes.keyMod#.value = ''");
				eval("document.#Attributes.form#.#Attributes.nameMod#.value = ''");
				eval("document.#Attributes.form#.#Attributes.descMod#.value = ''");
			}
		</cfoutput>

		return
	}
		//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#Attributes.nameMod#</cfoutput>(e,opc) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			validaDoConlis<cfoutput>#Attributes.nameMod#</cfoutput>(opc);
		}
	}

	function validaDoConlis<cfoutput>#Attributes.nameMod#</cfoutput>(){
		<cfoutput>
			if(document.#Attributes.form#.#Evaluate('Attributes.nameMar')#.value == ''){
				alert('Error, primeramente debe elegir la Marca');
				document.#Attributes.form#.#Evaluate('Attributes.nameMod')#.value = '';
				document.#Attributes.form#.#Evaluate('Attributes.nameMar')#.focus();
			}else{
				doConlisMarcaMod#Attributes.nameMar#(2);
			}
		</cfoutput>
	}

	<cfif Attributes.funcionMar EQ "funcModificarMDef">
	<cfoutput>
		function funcModificarMDef(Aid, AFMid){<!---Se agrega Función para Cambio de Valores de Activo Fijo por Garantía RVD 04/06/2014--->

		}
	</cfoutput>
	</cfif>

	<cfif Attributes.funcionMod EQ "funcModificarModDef">
	<cfoutput>
		function funcModificarModDef(Aid, AFMMid){<!---Se agrega Función para Cambio de Valores de Activo Fijo por Garantía RVD 04/06/2014--->

		}
	</cfoutput>
	</cfif>

	//Obtiene la descripción con base al código
	function TraeMarcaMod<cfoutput>#Attributes.nameMar#</cfoutput>(dato, opc) {
		<cfoutput>
			var params ="";

			if(opc == 1){	//Marcas
				params = "&keyMod=#Attributes.keyMod#&nameMod=#Attributes.nameMod#&descMod=#Attributes.descMod#&key=#Attributes.keyMar#&name=#Attributes.nameMar#&desc=#Attributes.descMar#&conexion=#Attributes.conexion#&ecodigo=#Session.Ecodigo#";

				if (dato!="") {
					document.all["#Attributes.frameMar#"].src="/cfmx/sif/Utiles/sifMarcaModQuery.cfm?dato="+dato
							+ "&form="+'#Attributes.form#'
							+ "&opc=1"
							+ params;
				}else{
					eval("document.#Attributes.form#.#Attributes.keyMar#.value = ''");
					eval("document.#Attributes.form#.#Attributes.nameMar#.value = ''");
					eval("document.#Attributes.form#.#Attributes.descMar#.value = ''");

					eval("document.#Attributes.form#.#Attributes.keyMod#.value = ''");
					eval("document.#Attributes.form#.#Attributes.nameMod#.value = ''");
					eval("document.#Attributes.form#.#Attributes.descMod#.value = ''");
				}
			}else{	//Modelos
				params = "&keyMod=#Attributes.keyMod#&nameMod=#Attributes.nameMod#&descMod=#Attributes.descMod#&conexion=#Attributes.conexion#&ecodigo=#Session.Ecodigo#";
				document.all["#Attributes.frameMar#"].src="/cfmx/sif/Utiles/sifMarcaModQuery.cfm?dato="+dato
						+ "&datoPadre="+ eval('document.#Attributes.form#.#Attributes.keyMar#.value')
						+ "&form="+'#Attributes.form#'
						+ "&opc=2"
						+ params;
			}
		</cfoutput>

		return;
	}
</script>

<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
	<!--- Para la Marca --->
	<cfset nameMar = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.nameMar')#')#')">
	<cfset descMar = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.descMar')#')#')">
	<cfset keyMar = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.keyMar')#')#')">
	<!--- Para el Modelo --->
	<cfset nameMod = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.nameMod')#')#')">
	<cfset descMod = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.descMod')#')#')">
	<cfset keyMod = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.keyMod')#')#')">
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="50%" nowrap>
		<cfoutput>
			<table width="" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td nowrap>
					<input
						<cfif Attributes.altMar NEQ ''>
							alt="#Attributes.altMar#"
						</cfif>
						type="hidden"
						name="#Attributes.keyMar#"
						value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#keyMar#')#</cfif>">
						<input type="text"
							name="#Attributes.nameMar#" id="#Attributes.nameMar#2"
							<cfif len(trim(Attributes.tabindexMar)) GT 0> tabindex="#Attributes.tabindexMar#" </cfif>
							value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#nameMar#')#</cfif>"
							<cfif Attributes.Modificable>
							onkeyup="javascript:conlis_keyup_#Attributes.nameMar#(event,1);"
							onBlur="javascript: TraeMarcaMod#Attributes.nameMar#(document.#Attributes.form#.#Evaluate('Attributes.nameMar')#.value,1); " onFocus="this.select()"
							<cfelse>
							readonly="true" class="cajasinbordeb"
							</cfif>
							size="10"
							maxlength="10">
				</td>
				<td nowrap>
					<input type="text"
						name="#Attributes.descMar#" id="#Attributes.descMar#"
						tabindex="-1" readonly="true" <cfif not Attributes.Modificable> class="cajasinbordeb"</cfif>
						value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#descMar#')#</cfif>"
						size="#Attributes.size#"
						maxlength="80">
					<cfif Attributes.Modificable>
				</td>
				<td>
					<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Marcas" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisMarcaMod#Attributes.nameMar#(1);'></a>
					</cfif>
				</td>
			</tr>
			</table>
	</td>
	<cfif Attributes.orientacion EQ 'V'>
		</tr>
		<tr>
	</cfif>
    <td width="50%" nowrap>
		<table width="" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td nowrap>

				<input
				<cfif Attributes.altMod NEQ ''>
					alt="#Attributes.altMod#"
				</cfif>
				type="hidden"
				name="#Attributes.keyMod#"
				tabindex="1"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#keyMod#')#</cfif>">
      	<input type="text"
					name="#Attributes.nameMod#" id="#Attributes.nameMod#2"
					<cfif len(trim(Attributes.tabindexMod)) GT 0> tabindex="#Attributes.tabindexMod#" </cfif>
					value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#nameMod#')#</cfif>"
					<cfif Attributes.Modificable>
					onkeyup="javascript:conlis_keyup_#Attributes.nameMod#(event);"
					onBlur="javascript: TraeModelo#Attributes.nameMod#(document.#Attributes.form#.#Evaluate('Attributes.nameMod')#.value);"  onFocus="this.select()"
					<cfelse>
					readonly="true" class="cajasinbordeb"
					</cfif>
					size="10"
					maxlength="10"
					tabindex="1">
				</td>
				<td nowrap>
				<input type="text"
					name="#Attributes.descMod#" id="#Attributes.descMod#"
					tabindex="-1" readonly="true" <cfif not Attributes.Modificable> class="cajasinbordeb"</cfif>
					value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#descMod#')#</cfif>"
					size="#Attributes.size#"
					maxlength="80">
				<cfif Attributes.Modificable>
				</td>
				<td>
				<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Modelos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: validaDoConlis<cfoutput>#Attributes.nameMod#</cfoutput>();'></a>
				</td>
				</cfif>
				</tr>
			</table>
    	</td></cfoutput>

  </tr>
</table>

<iframe
		name="<cfoutput>#Attributes.frameMar#</cfoutput>"
		marginheight="0"
		marginwidth="0"
		frameborder="0"
		height="0"
		width="0"
		scrolling="auto"
		src=""
		style="display:none;">
</iframe>
