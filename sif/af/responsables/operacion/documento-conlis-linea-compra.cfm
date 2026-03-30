<!---►►variables de traduccion◄◄--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Linea"
    Key="LB_Linea"
    Default="Línea"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Descripcion"
    Key="LB_Descripcion"
    Default="Descripción"
    XmlFile="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Cantidad"
    Key="LB_Cantidad"
    Default="Cantidad"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_CantidadSurtida"
    Key="LB_CantidadSurtida"
    Default="Cantidad Surtida"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="BTN_Filtrar"
    Key="BTN_Filtrar"
    Default="Filtrar"
    XmlFile="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="BTN_Limpiar"
    Key="BTN_Limpiar"
    Default="Limpiar"
    XmlFile="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="MSG_SocioDeNegocios"
    Key="MSG_SocioDeNegocios"
    Default="Socio de Negocios"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="MSG_MonedaDeLaOrden"
    Key="MSG_MonedaDeLaOrden"
    Default="Moneda de la Orden"/>
<!---►►Paso de variables◄◄--->                     
<cfif isdefined("url.SNcodigo")  and len(trim(url.SNcodigo))>
	<cfparam name="form.SNcodigo" default="#url.SNcodigo#">
</cfif>
<cfif isdefined("url.Mcodigo")  and len(trim(url.Mcodigo))>
	<cfparam name="form.Mcodigo" default="#url.Mcodigo#">
</cfif>
<cfif isdefined("url.EOnumero")  and len(trim(url.EOnumero))>
	<cfparam name="form.EOnumero" default="#url.EOnumero#">
</cfif>
<cfif isdefined("url.Observaciones")  and len(trim(url.Observaciones))>
	<cfparam name="form.Observaciones" default="#url.Observaciones#">
</cfif>
<cfif isdefined("url.DOobservaciones")  and len(trim(url.DOobservaciones))>
	<cfparam name="form.DOobservaciones" default="#url.DOobservaciones#">
</cfif>
<cfif isdefined("url.DOdescripcion")  and len(trim(url.DOdescripcion))>
	<cfparam name="form.DOdescripcion" default="#url.DOdescripcion#">
</cfif>
<cfif isdefined("url.documentoOri")  and len(trim(url.documentoOri))>
	<cfparam name="form.documentoOri" default="#url.documentoOri#">
</cfif>
<!---►►Agregar lineas de la Orden de compra a la Pantalla de Documentos de Responsabilidad◄◄--->
<cfif isdefined('form.btnAgregar_Lineas')>
	<cfset EOnumero 	 = "">
    <cfset DOconsecutivo = "">
    <cfset DOlinea 	     = "">
    <cfset EOidorden 	     = "">
    <cfloop index="LvarLin2" list="#Form.chk#" delimiters=",">
		<cfset Lineas 		 = ListToArray(LvarLin2, "|")>
        <cfset EOnumero 	 = ListAppend(EOnumero,Lineas[1])>
        <cfset DOconsecutivo = ListAppend(DOconsecutivo,Lineas[2])>
        <cfset DOlinea 	     = ListAppend(DOlinea,Lineas[3])>
        <cfset EOidorden     = ListAppend(EOidorden,Lineas[4])>
    </cfloop>
	<cfset AEOnumero 	  = ListToArray(EOnumero, ",")>
	<cfset ADOconsecutivo = ListToArray(DOconsecutivo, ",")>
    <cfset ADOlinea 	  = ListToArray(DOlinea, ",")>
    <cfset AEOidorden 	  = ListToArray(EOidorden, ",")>
	<script language="javascript" type="text/javascript">
		Agregar_Lineas();
		function Agregar_Lineas(){
			if (window.opener != null) {
				<cfoutput>
					<cfif isdefined("EOnumero") and len(trim(EOnumero))>
						window.opener.document.form1.EOidorden.value = #AEOidorden[1]#;
						<cfloop from="1" to="#listLen(EOnumero)#" index="i">
							window.opener.AgregarDoc('','','#AEOnumero[i]#','#ADOconsecutivo[i]#','#ADOlinea[i]#',true);
						</cfloop>		
					</cfif>
				</cfoutput>
			}
			window.close();
		}
	</script>
</cfif>
<!---►►Funciones javascrip◄◄--->
<script language="javascript" type="text/javascript">
	function funcAgregar_Lineas(){
		return confirm('Esta seguro que desea asociar las lineas de las OC seleccionadas al documento de Responsabilidad.?');
	}
</script>

<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo)) and isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>

	<cfset filtro = "">
	<cfset navegacion = "&SNcodigo=#Form.SNcodigo#&Mcodigo=#Form.Mcodigo#">
	<cfif isdefined("Form.EOnumero") and Len(Trim(Form.EOnumero)) NEQ 0 and Form.EOnumero GT 0>
		<cfset filtro = filtro & " and a.EOnumero = " & Form.EOnumero >
		<cfset navegacion = navegacion & "&EOnumero=" & Form.EOnumero>
	</cfif>	
	<cfif isdefined("Form.Observaciones") and Len(Trim(Form.Observaciones)) NEQ 0>
		<cfset filtro = filtro & " and upper(Observaciones) like '%" & UCase(Form.Observaciones) & "%'">
		<cfset navegacion = navegacion & "&Observaciones=" & Form.Observaciones>
	</cfif>
	<cfif isdefined("Form.DOobservaciones") and Len(Trim(Form.DOobservaciones)) NEQ 0>
		<cfset filtro = filtro & " and upper(a.DOobservaciones) like '%" & UCase(Form.DOobservaciones) & "%'">
		<cfset navegacion = navegacion & "&DOobservaciones=" & Form.DOobservaciones>
	</cfif>
	<cfif isdefined("Form.DOdescripcion") and Len(Trim(Form.DOdescripcion)) NEQ 0>
		<cfset filtro = filtro & " and upper(a.DOdescripcion) like '%" & UCase(Form.DOdescripcion) & "%'">
		<cfset navegacion = navegacion & "&DOdescripcion=" & Form.DOdescripcion>
	</cfif>	
    <cfif isdefined("Form.documentoOri") and Len(Trim(Form.documentoOri)) NEQ 0>
    	<cfset navegacion = navegacion & "&documentoOri=" & Form.documentoOri>
    </cfif>
	<cf_dbfunction name="to_char" args="a.EOnumero" returnvariable="Lvar_EOnumero">
	<cf_dbfunction name="concat" args="#Lvar_EOnumero#+' - '+b.Observaciones" returnvariable="Lvar_Orden" delimiters="+">
	<cfquery name="rsLista" datasource="#session.DSN#">
		select  a.EOnumero, 
			a.DOconsecutivo, 
			b.SNcodigo, 
			a.EOidorden, 
			a.DOlinea, 
			b.EOestado, 
			a.DOcantsurtida + 
			  coalesce(
			  (
			  	select sum(ddr.DDRcantordenconv)
				from DDocumentosRecepcion ddr
					inner join EDocumentosRecepcion edr
						inner join TipoDocumentoR tdr
							on tdr.TDRcodigo = edr.TDRcodigo
							and tdr.Ecodigo   = edr.Ecodigo
						on edr.EDRid = ddr.EDRid
				where ddr.DOlinea = a.DOlinea
					and edr.EDRestado < 1
					and tdr.TDRtipo = 'R'
			  ), 0) as DOcantsurtida,  a.DOcantidad,  a.DOdescripcion,
			  #preservesinglequotes(Lvar_Orden)# as Orden
		from EOrdenCM b
			inner join DOrdenCM a
				on a.EOidorden=b.EOidorden
				and a.CMtipo = 'F'
			inner join Impuestos i 
				on a.Icodigo = i.Icodigo 
				and a.Ecodigo = i.Ecodigo                   
			inner join CMTipoOrden e
				on e.CMTOcodigo = b.CMTOcodigo
				and e.Ecodigo    = b.Ecodigo 
		where b.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		  and b.Mcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		  and b.EOestado = 10
          <cfif isdefined("Form.documentoOri") and Len(Trim(Form.documentoOri)) NEQ 0>
              and not exists (
                            select 1 
                              from EAadquisicion 
                              where 
                               EAcpdoc		= '#Form.documentoOri#'
                               and Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
                               and SNcodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
                        )
           <cfelse>
              and (a.DOcantidad - a.DOcantsurtida) > 0
           </cfif>
			#preservesinglequotes(filtro)#
		order by a.EOnumero, a.DOconsecutivo
	</cfquery>	
</cfif>
<html>
	<head>
		<title>Lista de Ordenes de Compra</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<cf_templatecss>
		<!--- Se define función para asignar valores al form que invoca esta pantalla y cerrar la pantalla --->
        <!---En realidad esta funcion no se va a ocupar, porque ahora se basa todo en el campo DOlineas, el cual va a contener la
        lista de todas las lineas de OC seleccionadas--->
		<script language="JavaScript" type="text/javascript">
			<!--//
				function Asignar(EOidorden, EOnumero, DOlinea, DOconsecutivo) {
					if (window.opener != null) {
						window.opener.document.form1.EOidorden.value = EOidorden;
						window.opener.document.form1.EOnumero.value = EOnumero;  <!--No se Graba en el Doc en transito-->
						window.opener.document.form1.DOlinea.value = DOlinea;
						window.opener.document.form1.DOconsecutivo.value = DOconsecutivo; <!--No se Graba en el Doc en transito-->
						window.close();
					}
				}
			//-->
		</script>
	</head>
	<body>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<!--- Se pinta sección con filtros para el form, dado el volumen de información que se maneja para las 
					estructuras involucradas se da un manejo especial en el pintado de está lista no utilizando el componente
					de listas con los parámetros para pintar filtros y filtrar automáticamente. --->
					<cfoutput>
						<form style="margin:0;" name="form1" method="post" action="documento-conlis-linea-compra.cfm">
							<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
								<tr>
									<td width="10%" align="right" nowrap><strong><cf_translate key="LB_Socio">Socio</cf_translate>:&nbsp;</strong></td>
									<td width="40%">
										<cfif isdefined("Form.SNcodigo")>
										  	<cf_sifsociosnegocios2 idquery="#Form.SNcodigo#" sntiposocio="P" tabindex="1">
										<cfelse>
											<cf_sifsociosnegocios2 sntiposocio="P" tabindex="1">
										</cfif>
									</td>
									<td width="10%" align="right" nowrap><strong><cf_translate key="LB_Moneda">Moneda</cf_translate>:&nbsp;</strong></td>
									<td width="40%">
										<cfif isdefined("Form.Mcodigo")>
											<cfquery name="rsQueryMonedas" datasource="#session.dsn#">
												select Mcodigo, Miso4217, Mnombre
												from Monedas
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
												and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
											</cfquery>
											<cf_sifmonedas query="#rsQueryMonedas#" tabindex="1">
										<cfelse>
											<cf_sifmonedas tabindex="1">
										</cfif>
									</td>
								</tr>
								<tr>
									<td width="10%" align="right" nowrap><strong><cf_translate key="LB_NumeroOrden">N&uacute;mero Orden</cf_translate>:&nbsp;</strong></td>
									<td width="40%"> 
										<cfif isdefined("Form.EOnumero")>
											<cf_monto name="EOnumero" value="#Form.EOnumero#" decimales="0" tabindex="1">
										<cfelse>
											<cf_monto name="EOnumero" decimales="0" tabindex="1">
										</cfif>
										
									</td>
									<td width="10%" align="right" nowrap><strong><cf_translate key="LB_DescripcionOrden">Descripci&oacute;n Orden</cf_translate>:&nbsp;</strong></td>
									<td width="40%"> 
										<input name="Observaciones" type="text" id="desc" size="40" maxlength="80" tabindex="1" 
											value="<cfif isdefined("Form.Observaciones")>#Form.Observaciones#</cfif>" 
											onFocus="javascript:this.select();">
									</td>
								</tr>
								<tr>
									<td width="10%" align="right" nowrap><strong><cf_translate key="LB_DescripcionLinea">Descripci&oacute;n l&iacute;nea</cf_translate>:&nbsp;</strong></td>
									<td width="40%">
										<input name="DOdescripcion" type="text" id="DOdescripcion" size="35" maxlength="255" tabindex="1"
											value="<cfif isdefined("Form.DOdescripcion")>#Form.DOdescripcion#</cfif>"
											onFocus="javascript:this.select();">
									</td>
									<td align="right" nowrap><strong><cf_translate key="LB_Observaciones">Observaciones</cf_translate>:&nbsp;</strong></td>
								  	<td width="40%"> 
										<input name="DOobservaciones" type="text" id="DOobservaciones" size="35" maxlength="255" tabindex="1"
											value="<cfif isdefined("Form.DOobservaciones")>#Form.DOobservaciones#</cfif>"
											onFocus="javascript:this.select();">
									</td>
								</tr>
							</table>
							<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
								<tr align="right">
									<cfif isdefined("Form.documentoOri") and Len(Trim(Form.documentoOri)) NEQ 0>
                                    	<input type="hidden" name="documentoOri" value="<cfoutput>#Form.documentoOri#</cfoutput>">
                                    </cfif>
									<td width="100%"></td>
									<td><input name="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>"></td>
									<td><input name="btnlimpiar" type="reset"  id="btnlimpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>"></td>
								</tr>
							</table>
						</form>
					</cfoutput>
					<!--- Se requiere que en todo momento esta lista este pintada para un único socio de negocios y una única moneda para disminuir del volumen de información --->
					
					<cf_qforms>
						<cf_qformsrequiredfield args="SNcodigo, #MSG_SocioDeNegocios#">
						<cf_qformsrequiredfield args="Mcodigo, #MSG_MonedaDeLaOrden#">
					</cf_qforms>
				</td>
			</tr>	
			<tr>
				<td>
					<!--- Pintado de la lista. Restringido para que solo se pinte cuando se encuentra definido el socio y la moneda --->
					<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))
						and isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
						
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet"> 
								<cfinvokeargument name="query" 				value="#rsLista#"/> 
								<cfinvokeargument name="desplegar" 			value="DOconsecutivo, DOdescripcion, DOcantidad , DOcantsurtida"/> 
								<cfinvokeargument name="Cortes" 			value="Orden"/>
								<cfinvokeargument name="etiquetas" 			value="#LB_Linea#, #LB_Descripcion#, #LB_Cantidad#, #LB_CantidadSurtida#"/> 
								<cfinvokeargument name="formatos" 			value="S,S,M,M"/> 
								<cfinvokeargument name="align" 				value="left,left,right,right"/> 
								<cfinvokeargument name="ajustar" 			value="N"/>
								<cfinvokeargument name="keys" 				value="EOnumero, DOconsecutivo, DOlinea, EOidorden"/>
								<cfinvokeargument name="funcion" 			value="Asignar"/>
								<cfinvokeargument name="fparams" 			value="EOidorden, EOnumero, DOlinea, DOconsecutivo"/>
								<cfinvokeargument name="irA" 				value="documento-conlis-linea-compra.cfm"/>				
								<cfinvokeargument name="maxrows" 			value="8"/> 
								<cfinvokeargument name="maxrowsquery" 		value="500"/> 
								<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
								<cfinvokeargument name="showEmptyListMsg" 	value="yes"/>
                                <cfinvokeargument name="checkboxes" 		value="S"/>
                                <cfinvokeargument name="botones" 			value="Agregar_Lineas"/>
							</cfinvoke>
					<cfelse>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
							<tr>
								<td align="center"><cf_translate key="MSG_DebeDefinirPrimeroElSocioDeNegociosYLaMoneda">Debe definir primero el Socio de Negocios y la Moneda</cf_translate>.</td>
							</tr>
						</table>
					</cfif>
				</td>
			</tr>
		</table>
	</body>
</html>