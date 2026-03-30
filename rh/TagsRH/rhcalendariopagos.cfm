<!--- OPARRALES 2019-01-09
	- Modificacion para parametro de MostrarTodos las nominas (Aplicadas y No Aplicadas)
 --->
<!--- <cf_sifmaskstring form="filtro" name="CPcodigo" formato="****-**-***" size="15" maxlenght="11" mostrarmascara="false"> --->
<cfset def = QueryNew('dato')>

<cfparam name="Attributes.Historicos" 			default="false" type="boolean"> <!--- Indica si se va a trabajar con las tablas Históricas --->
<cfparam name="Attributes.Conlis" 				default="true" 	type="boolean"> <!--- Indica si se va a permitir abrir un conlis --->
<cfparam name="Attributes.Desc" 				default="true" 	type="boolean"> <!--- Indica si se va a mostrar la descripcion --->
<cfparam name="Attributes.Tcodigo" 				default="true" 	type="boolean"> <!--- Indica si se va a permitir seleccionar el Tcodigo--->
<cfparam name="Attributes.index" 				default="0" 	type="numeric"> <!--- Número de objeto en la pantalla, para manejar varios tags en la pantalla --->
<cfparam name="Attributes.form" 				default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" 				default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.frame" 				default="FRCalPago" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.orientacion" 			default="15" 	type="numeric"> <!--- 1= horizontal y 2= vertical... knrs--->
<cfparam name="Attributes.size" 				default="10" 	type="numeric"> <!--- Tamaño del campo de texto del Código --->
<cfparam name="Attributes.descsize" 			default="30" 	type="numeric"> <!--- Tamaño del campo de texto de la Descripción --->
<cfparam name="Attributes.Contabilizado" 		default="false" type="boolean"> <!--- Indica si se va a trabajar con nominas contabilizadas --->
<cfparam name="Attributes.Excluir" 				default="" 		type="string"> <!--- Indica cual tipo de nomina se excluye (0=Normal, 1=Especia, 2-Anticipo) --->
<cfparam name="Attributes.pintaRCDescripcion"	default="false" type="boolean"><!----Pinta en la descripcion de la relacion de calculo (RCDescripcion de RCalculoNomina/HRCalculoNomina)---->
<cfparam name="Attributes.conMes" 				default="false" type="boolean"> <!---indica si se va a filtrar por mes, si es positivo, el form debe incluir un campo con el nombre 'mes#index#' de donde sera consultado el mes... knrs--->
<cfparam name="Attributes.conPeriodo" 			default="false" type="boolean"> <!---indica si se va a filtrar por mes, si es positivo, el form debe incluir un campo con el nombre 'periodo#index#' de donde sera consultado el periodo... knrs--->
<cfparam name="Attributes.AgregarEnLista" 		default="false" type="boolean"><!--- permite agregar calendarios de pago a una lista por medio del boton (+) --->
<cfparam name="Attributes.MostrarTodos" 		default="false" type="boolean"><!--- Permite mostrar Nominas pendientes y aplicadas --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<cfif Attributes.Tcodigo>
	<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
		select ltrim(rtrim(Tcodigo)) as Tcodigo, Tdescripcion
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
</cfif>

<cfif Attributes.AgregarEnLista>
	<cf_importJquery>
	<cfif trim(Attributes.index) eq 0>
		<cfset index=1>
	</cfif>
</cfif>


<script language="JavaScript" type="text/javascript">
	<cfif Attributes.Conlis>
	function doConlisCalPagos<cfoutput>#index#</cfoutput>() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		<cfoutput>
			var parametros = 'f=#Attributes.form#&historicos=#Attributes.historicos#&p1=CPid#index#&p2=CPcodigo#index#&p3=CPdescripcion#index#&p4=Tcodigo#index#&Contabilizado=#Attributes.Contabilizado#&Excluir=#Attributes.Excluir#&pintaRCDescripcion=#Attributes.pintaRCDescripcion#';
			<cfif Attributes.Tcodigo>
				parametros += '&vTcodigo=' + document.#Attributes.form#.Tcodigo#trim(index)#.value;
			</cfif>
			<cfif Attributes.conMes>
				parametros += '&vMes=' + document.#Attributes.form#.mes#trim(index)#.value;
			</cfif>
			<cfif Attributes.conPeriodo>
				parametros += '&vPeriodo=' + document.#Attributes.form#.periodo#trim(index)#.value;
			</cfif>
				parametros += '&MostrarTodos=#Attributes.MostrarTodos#';
			var nuevo = window.open('/cfmx/rh/Utiles/ConlisCalPagos.cfm?' + parametros ,'ListaCalPagos','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>

		nuevo.focus();
	}

	function ResetCalPagos<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#.CPid#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.CPcodigo#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.CPdescripcion#index#</cfoutput>.value = "";
	}
	</cfif>

	function TraeCalPago<cfoutput>#index#</cfoutput>() {
		window.ctlid = document.<cfoutput>#Attributes.form#</cfoutput>.CPid<cfoutput>#index#</cfoutput>;
		window.ctlcod = document.<cfoutput>#Attributes.form#</cfoutput>.CPcodigo<cfoutput>#index#</cfoutput>;
		window.ctldesc = document.<cfoutput>#Attributes.form#</cfoutput>.CPdescripcion<cfoutput>#index#</cfoutput>;
		if (document.<cfoutput>#Attributes.form#.CPcodigo#index#</cfoutput>.value != "") {
			var CPcodigo = document.<cfoutput>#Attributes.form#</cfoutput>.CPcodigo<cfoutput>#index#</cfoutput>.value;
			var Tcodigo = document.<cfoutput>#Attributes.form#</cfoutput>.Tcodigo<cfoutput>#index#</cfoutput>.value;
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			var params = "historicos=<cfoutput>#Attributes.historicos#</cfoutput>&CPcodigo=" + CPcodigo;
			params += '&Contabilizado=<cfoutput>#Attributes.Contabilizado#</cfoutput>';
			<cfif LEN(TRIM(Attributes.Excluir))>
			params += '&Excluir=<cfoutput>#Attributes.Excluir#</cfoutput>';
			</cfif>
			<cfif LEN(TRIM(Attributes.pintaRCDescripcion))>
			params += '&pintaRCDescripcion=<cfoutput>#Attributes.pintaRCDescripcion#</cfoutput>';
			</cfif>
			<cfif Attributes.Tcodigo>
				params +=  '&vTcodigo=' + <cfoutput>document.#Attributes.form#.Tcodigo#index#.value</cfoutput>;
			</cfif>
				params += '&MostrarTodos=<cfoutput>#Attributes.MostrarTodos#</cfoutput>';
			fr.src = "/cfmx/rh/Utiles/rhcalpagosquery.cfm?"+params;
		} else {
			ResetCalPagos<cfoutput>#index#</cfoutput>();
		}
		return true;
	}

		<cfif Attributes.AgregarEnLista>
			function AgregarCalendarioLista<cfoutput>#index#</cfoutput>(){
					var existe = 0;

					if($('#ListaTcodigoCalendario<cfoutput>#index#</cfoutput>').length){
						$('input.ListaTcodigoCalendario<cfoutput>#index#</cfoutput>').each(function() {
							if($('#CPid<cfoutput>#index#</cfoutput>').val() == $(this).val()){ existe=1;}
						});
					}
					if(existe == 1){
						alert("<cf_translate key='LB_ElCalendarioYaSeEncuentraAgregado' xmlFile='/rh/generales.xml'>Este Calendario ya se encuentra agregado</cf_translate>");
					}
					else{
						if($('#CPcodigo<cfoutput>#index#</cfoutput>').val() == ''){
							alert("<cf_translate key='LB_DebeSeleccionarUnCalendario' xmlFile='/rh/generales.xml'>Debe seleccionar un Calendario</cf_translate>");
						}
						else{
						   $('#ListaCalendarios<cfoutput>#index#</cfoutput>').append("<tr><td nowrap='nowrap'><input class='<cfoutput>ListaTcodigoCalendario#index#</cfoutput>' type='hidden' id='<cfoutput>ListaTcodigoCalendario#index#</cfoutput>' name='<cfoutput>ListaTcodigoCalendario#index#</cfoutput>' value="+$('#CPid<cfoutput>#index#</cfoutput>').val()+">"+$('#<cfoutput>CPcodigo#index#</cfoutput>').val()+" - " +$('#CPdescripcion<cfoutput>#index#</cfoutput>').val()+ "<img src='/cfmx/plantillas/Sapiens/css/images/btnEliminar.gif' onclick='QuitarCalendarioLista<cfoutput>#index#</cfoutput>(this)' ></td></tr>");
						   $('#Tcodigo<cfoutput>#index#</cfoutput>').val("");
						   $('#Tdescripcion<cfoutput>#index#</cfoutput>').val("");
						   $('#CPcodigo<cfoutput>#index#</cfoutput>').val("");
						   $('#CPdescripcion<cfoutput>#index#</cfoutput>').val("");
						   $('#CPid<cfoutput>#index#</cfoutput>').val("");
						}
					}
			}
			function QuitarCalendarioLista<cfoutput>#index#</cfoutput>(elemento){
				$(elemento).parent().parent().remove();
			}
		</cfif>

</script>

<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<cfif Attributes.Tcodigo>
		<td <cfif Attributes.orientacion EQ 2>colspan="3"</cfif>>
			<cfoutput>
			<cfif not len(trim(index))><!---CarolRS. se agrego el atributo: query="#Attributes.query#" --->
				<cf_rhtiponomina index="0" onChange='ResetCalPagos#index#' form="#Attributes.form#" query="#Attributes.query#">
			<cfelse>
				<cf_rhtiponomina index="#index#" onChange='ResetCalPagos#index#' form="#Attributes.form#" query="#Attributes.query#">
			</cfif>
			</cfoutput>

			<!---<select name="Tcodigo<cfoutput>#index#</cfoutput>" onChange="javascript: ResetCalPagos<cfoutput>#index#</cfoutput>();">
				<cfoutput query="rsTiposNomina">
					<option value="#Tcodigo#"
					<cfif isdefined("Attributes.query") and isdefined("Attributes.query.Tcodigo#index#") and Trim(Evaluate("Attributes.query.Tcodigo#index#")) EQ Trim(Tcodigo)>
						selected
					</cfif>
					>#Tdescripcion#</option>
				</cfoutput>
			</select>--->
		</td>
		<cfif Attributes.orientacion EQ 2>
		</tr><tr>
		</cfif>
	</cfif>
	<cfoutput>
		<td>
			<input type="hidden" id="CPid#index#" name="CPid#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.CPid#index#")>#Evaluate("Attributes.query.CPid#index#")#</cfif>">
			<input type="text"
				name="CPcodigo#index#" id="CPcodigo#index#"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.CPcodigo#index#")>#Evaluate("Attributes.query.CPcodigo#index#")#</cfif>"
				onblur="javascript: TraeCalPago#index#();"
				size="#Attributes.size#">
		</td>


		<cfif Attributes.Desc>
			<td nowrap>
				<input type="text"
					name="CPdescripcion#index#" id="CPdescripcion#index#"
					tabindex="-1"
					value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.CPdescripcion#index#")>#Evaluate("Attributes.query.CPdescripcion#index#")#</cfif>"
					maxlength="80"
					readonly='true'
					size="#Attributes.descsize#"
					>
			</td>
		</cfif>

		<cfif Attributes.Conlis>
			<td nowrap>
				<a href="javascript: doConlisCalPagos#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Calendarios de Pagos" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>
			</td>
		</cfif>
		<cfif Attributes.AgregarEnLista>
		<td>
			<input type="button" onclick="AgregarCalendarioLista<cfoutput>#index#</cfoutput>()" value="+" class="btnNormal" />
		</td>
		</cfif>
</cfoutput>
	</tr>
	<cfif Attributes.AgregarEnLista>
	<tr>
		<td colspan="5">
			<table id="ListaCalendarios<cfoutput>#index#</cfoutput>">
			</table>
		</td>
	</tr>
	</cfif>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" style="display:none" marginheight="0" marginwidth="0" frameborder="1" height="0" width="0" scrolling="auto" src=""></iframe>
