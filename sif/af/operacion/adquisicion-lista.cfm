<cf_navegacion name="Pagina">

<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- ARREGLA EL NÚMERO DE PÁGINA CUANDO CAMBIO LOS FILTROS --->
<cfset fixPagina("Filtro_EAcpidtrans")>
<cfset fixPagina("Filtro_EAcpdoc")>
<cfset fixPagina("Filtro_EAFecha")>
<cfset fixPagina("Filtro_EAcantidad")>
<cfset fixPagina("Filtro_EAdescripcion")>
<!--- LIMPIA LOS PARAMETROS CUANDO VIENE DEL LINK PRINCIPAL DEL PROCESO --->
<cfif isdefined("url.m")>
	<cfset clearParam("Filtro_EAcpidtrans")>
	<cfset clearParam("Filtro_EAcpdoc")>
	<cfset clearParam("Filtro_EAFecha")>
	<cfset clearParam("Filtro_EAcantidad")>
	<cfset clearParam("Filtro_EAdescripcion")>
	<cfset clearParam("FILTRO_FECHASMAYORES")>
	<cfset clearParam("Pagina",1)>
</cfif>
<!--- SUBIR A SESSION LAS VARIABLES DE LOS FILTROS DE ESTA PANTALLA  --->
<cfset setParam("Filtro_EAcpidtrans")>
<cfset setParam("Filtro_EAcpdoc")>
<cfset setParam("Filtro_EAFecha")>
<cfset setParam("Filtro_EAcantidad")>
<cfset setParam("Filtro_EAdescripcion")>
<cfset setParam("FILTRO_FECHASMAYORES")>
<cfset setParam("Pagina")>
<!--- BAJAR DE SESSION LAS VARIABLES DE LOS FILTROS DE ESTA PANTALLA  --->
<cfset getParam("Filtro_EAcpidtrans")>
<cfset getParam("Filtro_EAcpdoc")>
<cfset getParam("Filtro_EAFecha")>
<cfset getParam("Filtro_EAcantidad")>
<cfset getParam("Filtro_EAdescripcion")>
<cfset getParam("FILTRO_FECHASMAYORES")>
<cfset getParam("Pagina")>
<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfif len(trim(form.Pagina)) eq 0>
	<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
	<cfset form.Pagina = 1>
</cfif>
<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
    <cfset LvarPar = '_Aux'>
</cfif>

<!--- JavaScript --->
<script language="JavaScript">
	<!--//
	// Marcar todos los documentos disponibles para aplicar
		function Marcar(c) {
			if (c.checked) {
				for (counter = 0; counter < document.form1.chk.length; counter++)
				{
					if ((!document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
						{  document.form1.chk[counter].checked = true;}
				}
				if ((counter==0)  && (!document.form1.chk.disabled)) {
					document.form1.chk.checked = true;
				}
			}
			else {
				for (var counter = 0; counter < document.form1.chk.length; counter++)
				{
					if ((document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
						{  document.form1.chk[counter].checked = false;}
				};
				if ((counter==0) && (!document.form1.chk.disabled)) {
					document.form1.chk.checked = false;
				}
			};
		}
	// Cambia el Action del Form
		function changeFormActionforDetalles() {
			document.form1.action = '<cfoutput>adquisicion-detalles#LvarPar#.cfm</cfoutput>';
		}
	// Aplicar
		function algunoMarcado(Accion){
			var aplica = false;
			if (document.form1.chk) {
				if (document.form1.chk.value) {
					aplica = document.form1.chk.checked;
				} else {
					for (var i=0; i<document.form1.chk.length; i++) {
						if (document.form1.chk[i].checked) { 
							aplica = true;
							break;
						}
					}
				}
			}
			if (aplica) {
				return (confirm("¿Está seguro de que desea "+Accion+" los documentos seleccionadas?"));
			} else {
				alert('Debe seleccionar al menos un documento');
				return false;
			}
		}
		function funcAplicar() {
			if (algunoMarcado("Aplicar"))
				document.form1.action = "<cfoutput>adquisicion-crsql#LvarPar#.cfm</cfoutput>";
			else
				return false;
		}
		function funcPreparar_Relacion() {
			if (algunoMarcado("Preparar"))
				document.form1.action = "<cfoutput>adquisicion-crsql#LvarPar#.cfm</cfoutput>";
			else
				return false;
		}
		function funcImportar() {
			<cfset LvarAction = '../importar/importarAdquisicion.cfm'>
			<cfif isdefined("session.LvarJA") and not session.LvarJA>    
				<cfset LVarAction = '../importar/importarAdquisicion_Aux.cfm'>
			</cfif>
			document.form1.action = "<cfoutput>#LvarAction#</cfoutput>";
			
		}
		//Llama el conlis
		function AdquisicionesPendientes() {
			popUpWindowIns("/cfmx/sif/af/operacion/popUp-EAdq.cfm",window.screen.width*0.20 ,window.screen.height*0.20,window.screen.width*0.60 ,window.screen.height*0.60);
		}
		
		var popUpWinIns = 0;
		function popUpWindowIns(URLStr, left, top, width, height){
			if(popUpWinIns){
				if(!popUpWinIns.closed) popUpWinIns.close();
			}
			popUpWinIns = open(URLStr, 'popUpWinIns', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,scrolling=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		}
	//-->		
</script>

<cfset LvarBotones = ''>
<cfset img1 = '<input name="imageField" type="image" src="../../imagenes/find.small.png" width="16" height="16" border="0"  onclick="changeFormActionforDetalles();">'>
<cfset img2 = '<img src="../../imagenes/Cferror.gif" height="16" width="16" alt="Este registro se encuentra incompleto">'>

<cfset LvarBotones = 'Aplicar,Importar,Preparar_Relacion'>
<cfset LvarIrA = '/cfmx/sif/af/operacion/adquisicion-cr.cfm'>

<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarBotones = 'Aplicar,Preparar_Relacion'>
	<cfset LvarIrA = '/cfmx/sif/af/operacion/adquisicion-cr_JA.cfm'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarBotones = 'Importar,Preparar_Relacion'>
	<cfset LvarIrA = '/cfmx/sif/af/operacion/adquisicion-cr_Aux.cfm'>
</cfif>


<!--- Pintado de la lista --->
<cf_templateheader title="Activos Fijos">
			<!--- Procedimiento AF_AdquisicionActivos.
			Revisa Cuentas por Pagar y se trae los Activos Fijos. 
			Inserta en las tablas de EAadquisicion, DAadquisicion, DSActivosAdq la información incompleta de CXP. --->
            <cftry>       
                <cfinvoke component="sif.Componentes.AF_AdquisicionActivos" method="AF_AdquisicionActivos" returnvariable="rsFacturas">
                    <cfinvokeargument name="Ecodigo"   value="#Session.Ecodigo#">
                    <cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#">
                    <cfinvokeargument name="Modulo"    value="Adquisicion">	
                    <cfinvokeargument name="Debug" 	   value="false">
                </cfinvoke>
                <cfcatch type="any">
                    <cfthrow message="#cfcatch.message#">
                </cfcatch>
            </cftry>
            <cftry>
            	<cfinvoke component="sif.Componentes.AF_AdquisicionActivos" method="AF_VerificaErrores" returnvariable="rsFacturas2">
                </cfinvoke>
               	<cfset msg = "">
                <cfif isdefined("rsFacturas2") and rsFacturas2.recordcount gt 0>
                	<cfswitch expression="#rsFacturas2.TipoError#"> 
                        <cfcase value="1"> 
                            <cfset msg  = "No se encontraron Documentos de Responsabilidad de Activos Fijos (Vales) registrados para: Documento '#rsFacturas2.Documento#'">
                        </cfcase> 
                        <cfcase value="2"> 
                            <cfset msg  = "No se encontro el Documento de Responsabilidad de Activo Fijos (Vale) registrados para: Documento '#rsFacturas2.Documento#' Linea: '#rsFacturas2.Linea#' Cantidad '#rsFacturas2.Cantidad#' Total Linea '#rsFacturas2.Moneda#s #numberFormat(rsFacturas2.TotalLin,',.00')#' Monto Unitario Local '#numberFormat(rsFacturas2.MontoUnit,',.00')#' #rsFacturas2.OC#.">
                        </cfcase> 
                        <cfcase value="3"> 
                            <cfset msg  = "El monto ('#rsFacturas2.MonedaLoc#s #rsFacturas2.Monto#') del Documento: '#rsFacturas2.Documento#', es mayor que la suma de los montos ('#rsFacturas2.MonedaLoc#s #rsFacturas2.MontoVales#') de los Documentos de Responsabilidad asociados.">
                        </cfcase> 
                        <cfcase value="4"> 
                            <cfset msg  = "El monto ('#rsFacturas2.MonedaLoc#s #rsFacturas2.MontoVales#') del Documento de Responsabilidad, es mayor que el monto ('#rsFacturas2.MonedaLoc#s #rsFacturas2.Monto#') del Documento: '#rsFacturas2.Documento#'.">
                        </cfcase> 
                        <cfcase value="5"> 
                            <cfset msg  = "Los Documentos de Responsabilidad de Activos Fijos (Vales) registrados para el Documento '#rsFacturas2.Documento#' no contienen lineas de detalle">
                        </cfcase> 
                    </cfswitch>
                    <cf_jnotify Titulo="Adquisiciones Pendientes" Tipo="Alerta" Texto="#msg# <br /><p style='color:##900'>Existen #rsFacturas2.recordcount# adquisiciones pendientes de aplicar</p><a href='javascript:AdquisicionesPendientes()' style='color:##03C'>Ver Pendientes</a>">	
                </cfif>
                
                <cfcatch type="any">
                    <cf_jnotify Titulo="Adquisiciones Pendientes" Tipo="Alerta" Texto="#cfcatch.message#">
                </cfcatch>
            </cftry>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Activos en Proceso de Adquisici&oacute;n'>
	
		<cfoutput>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
                            <cfinvokeargument name="tabla" 	  value="EAadquisicion b"/>
                            <cfinvokeargument name="columnas" value="b.Ecodigo,b.Ocodigo,b.SNcodigo, 
                                									 b.EAcpidtrans,b.EAcpdoc,b.EAcplinea,
                                                                     b.Aid,b.EAPeriodo,b.EAmes, 
                                									 b.EAFecha,b.Mcodigo,b.EAtipocambio,
                                									 b.Ccuenta,b.EAdescripcion,b.EAcantidad,
                                									 b.EAtotalori,b.EAtotalloc,b.EAstatus,
                                									'#img1#' as img1,
                                									case b.EAstatus when 0 then '#PreserveSingleQuotes(img2)#' else '' end as img2"/>
                            <cfinvokeargument name="desplegar" 				value="EAcpidtrans, EAcpdoc, EAFecha, EAcantidad, EAdescripcion, img1, img2"/>
                            <cfinvokeargument name="etiquetas" 				value="Transacción, Documento, Fecha, Cantidad, Descripción, , "/>
                            <cfinvokeargument name="formatos" 				value="V, V, D, I, S, US, US"/>
                            <cfinvokeargument name="filtro" 				value="b.Ecodigo = #session.Ecodigo# and b.EAstatus != 2"/>
                            <cfinvokeargument name="align" 					value="left, left, left, left, left, rigth, rigth"/>
                            <cfinvokeargument name="ajustar" 				value="N"/>
                            <cfinvokeargument name="irA" 					value="#LvarIrA#"/>
                            <cfinvokeargument name="checkboxes" 			value="S"/>
                            <cfinvokeargument name="keys" 					value="EAcpidtrans, EAcpdoc, EAcplinea"/>
                            <cfinvokeargument name="formname" 				value="form1"/>
                            <cfinvokeargument name="incluyeform" 			value="true"/>
                            <cfinvokeargument name="botones" 				value="#LvarBotones#"/>
                            <cfinvokeargument name="mostrar_filtro" 		value="true"/>
                            <cfinvokeargument name="filtrar_automatico" 	value="true"/>
                            <cfinvokeargument name="filtrar_por" 			value="b.EAcpidtrans, b.EAcpdoc, b.EAFecha, b.EAcantidad, b.EAdescripcion, '', ''"/>
                            <cfinvokeargument name="showEmptyListMsg" 		value="true"/>
                            <cfinvokeargument name="HideButtonsOnEmptyList" value="true"/>
						</cfinvoke>
					</td>
				</tr>
			</table>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>

<!---►►PILOTO PARA UTILIZAR EN COMPONENTES DE LISTAS: MANEJO DE VARIABLES DEL COMPONENTE DE LISTAS EN SESSION:
	  FUNCIONES PARA SUBIR Y BAJAR DE SESSION LAS VARIABLES DE LOS FILTROS DE ESTA PANTALLA◄◄◄--->
<cffunction name="getParam" access="private">
	<cfargument name="p" required="true">
		<cfif (isdefined("session.ListaAdq.#Arguments.p#") and len(trim(Evaluate("session.ListaAdq.#Arguments.p#"))) GT 0)
                and not (isdefined("form.#Arguments.p#") and len(trim(Evaluate("form.#Arguments.p#"))) GT 0)
                and not (isdefined("url.#Arguments.p#") and len(trim(Evaluate("url.#Arguments.p#"))) GT 0)>
            <cfset Evaluate("form.#Arguments.p#=session.ListaAdq.#Arguments.p#")>
            <cfset Evaluate("form.H#Arguments.p#=session.ListaAdq.#Arguments.p#")>
        </cfif>
</cffunction>
<cffunction name="setParam" access="private">
	<cfargument name="p" required="true">
        <cfif (isdefined("form.#Arguments.p#"))>
            <cfset Evaluate("session.ListaAdq.#Arguments.p#=form.#Arguments.p#")>
        <cfelseif (isdefined("url.#Arguments.p#"))>
            <cfset Evaluate("session.ListaAdq.#Arguments.p#=url.#Arguments.p#")>
        </cfif>
</cffunction>
<cffunction name="fixPagina" access="private">
	<cfargument name="p" required="true">
		<cfif 	isdefined("form.#Arguments.p#") and isdefined("form.H#Arguments.p#") 
            and Evaluate("form.#Arguments.p#") neq Evaluate("form.H#Arguments.p#")>
            <cfset form.Pagina=1>
            <cfset url.Pagina=1>
            <cfif (isdefined("session.ListaAdq.Pagina"))>
                <cfset Evaluate("session.ListaAdq.Pagina=1")>
            </cfif>
        </cfif>
</cffunction>
<cffunction name="clearParam" access="private">
    <cfargument name="p" required="true">
    <cfargument name="d" required="false" default="">
		<cfif (isdefined("session.ListaAdq.#Arguments.p#"))>
            <cfset Evaluate("session.ListaAdq.#Arguments.p#='#Arguments.d#'")>
        </cfif>
</cffunction>