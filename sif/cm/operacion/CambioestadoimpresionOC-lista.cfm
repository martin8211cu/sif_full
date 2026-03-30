<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cf_templateheader title="Cambio de estado de impresi&oacute;n de OC">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cambio de estado de impresi&oacute;n de OC'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">

			<cfset ValuesComprador = ArrayNew(1)>
			<cfset ValuesTipoOC= ArrayNew(1)>
			
			<!---====== Filtros de fecha por defecto ======---->
			<cfset vd_fechadesde = LSDateFormat(CreateDate(year(now()), month(DateAdd("m",-1,now())), 1),'dd/mm/yyyy')>
			<cfset vd_fechahasta = LSDateFormat(CreateDate(year(now()), month(now()), day(now())),'dd/mm/yyyy')>

			<!---****  Si los filtros vienen por URL (cambio de pagina) los carga en el form ---->
			<cfif isdefined("url.fESnumeroD") and not isdefined("form.fESnumeroD") >
				<cfset form.fESnumeroD = url.fESnumeroD >
			</cfif>
			
			<cfif isdefined("url.fESnumeroH") and not isdefined("form.fESnumeroH") >
				<cfset form.fESnumeroH = url.fESnumeroH >
			</cfif>
			
			<cfif isdefined("url.fechaD") and not isdefined("form.fechaD") >
				<cfset form.fechaD = url.fechaD >
			</cfif>			
					
			<cfif isdefined("url.fechaH") and not isdefined("form.fechaH") >
				<cfset form.fechaH = url.fechaH >
			</cfif>

			<cfif isdefined("url.LEstado") and not isdefined("form.LEstado") >
				<cfset form.LEstado = url.LEstado >
			</cfif>
			
			<cfif isdefined("url.CMCcodigo") and not isdefined("form.CMCcodigo") >
				<cfset form.CMCcodigo = url.CMCcodigo >
			</cfif>
			
			<cfif isdefined("url.CMCnombre") and not isdefined("form.CMCnombre") >
				<cfset form.CMCnombre = url.CMCnombre >
			</cfif>
			
			<cfif isdefined("url.CMCid") and not isdefined("form.CMCid") >
				<cfset form.CMCid = url.CMCid >
			</cfif>
			
			<cfif isdefined("url.CMCcodigo") and not isdefined("form.CMCcodigo") >
				<cfset form.CMCcodigo1 = url.CMCcodigo >
			</cfif>
			
			<cfif isdefined("url.CMCnombre") and not isdefined("form.CMCnombre") >
				<cfset form.CMCnombre = url.CMCnombre >
			</cfif>
			
			<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo") >
				<cfset form.SNcodigo = url.SNcodigo >
			</cfif>
			
			<cfif isdefined("url.CMTOcodigo") and not isdefined("form.CMTOcodigo") >
				<cfset form.CMTOcodigo = url.CMTOcodigo >
			</cfif>
			
			<cfif isdefined("url.CMTOdescripcion") and not isdefined("form.CMTOdescripcion") >
				<cfset form.CMTOdescripcion = url.CMTOdescripcion >
			</cfif>
						
			<!--- *********************** Asigna a la variable navegacion los filtros  *******************************--->
			<cfset navegacion = "">
			<cfif isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD)) >
				<cfset navegacion = navegacion & "&fESnumeroD=#form.fESnumeroD#">
			</cfif>
			
			<cfif isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH)) >
				<cfset navegacion = navegacion & "&fESnumeroH=#form.fESnumeroH#">
			</cfif>

			<cfif isdefined("Form.fechaD") and len(trim(form.fechaD)) >
				<cfset navegacion = navegacion & "&fechaD=#form.fechaD#">
			</cfif>
			
			<cfif isdefined("Form.fechaH") and len(trim(form.fechaH)) >
				<cfset navegacion = navegacion & "&fechaH=#form.fechaH#">
			</cfif>

			<cfif isdefined("Form.LEstado") and len(trim(form.LEstado))>
				<cfset navegacion = navegacion & "&LEstado=#form.LEstado#">
			</cfif>
			
			<cfif isdefined("Form.CMCcodigo") and len(trim(form.CMCcodigo))>
				<cfset navegacion = navegacion & "&CMCcodigo=#form.CMCcodigo#">
			</cfif>
			
			<cfif isdefined("Form.CMCnombre") and len(trim(form.CMCnombre))>
				<cfset navegacion = navegacion & "&CMCnombre=#form.CMCnombre#">
			</cfif>
			
			<cfif isdefined("Form.CMCid") and len(trim(form.CMCid))>
				<cfset navegacion = navegacion & "&CMCid=#form.CMCid#">
			</cfif>
			
			<cfif isdefined("Form.SNcodigo") and len(trim(form.SNcodigo))>
				<cfset navegacion = navegacion & "&SNcodigo=#form.SNcodigo#">
			</cfif>
			
			<cfif isdefined("form.CMTOcodigo") and len(trim(form.CMTOcodigo))>
				<cfset navegacion = navegacion & "&CMTOcodigo=#form.CMTOcodigo#">
				<cfquery name="rsTipoOrden" datasource="#session.DSN#">
					select CMTOcodigo, CMTOdescripcion
					from CMTipoOrden
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMTOcodigo#">
				</cfquery>
				<cfif isdefined("rsTipoOrden") and rsTipoOrden.RecordCount NEQ 0>
					<cfset ArrayAppend(ValuesTipoOC, rsTipoOrden.CMTOcodigo)>
					<cfset ArrayAppend(ValuesTipoOC, rsTipoOrden.CMTOdescripcion)>					
				</cfif>
			</cfif>
			
			<cfif isdefined("form.CMTOdescripcion") and len(trim(form.CMTOdescripcion)) eq 0 >
				<cfset navegacion = navegacion & "&CMTOdescripcion=#form.CMTOdescripcion#">
			</cfif>
			<!-----
			<cfif not isdefined("form.CMCid1") or len(trim(form.CMCid1)) eq 0 >
				<cfset form.CMCid1 = session.compras.comprador >
			</cfif>
			----->

			<cfif  isdefined("form.CMCid") and  len(trim(form.CMCid)) gt 0 >
				<cfquery name="rsComprador" datasource="#session.DSN#" >
					select CMCid, CMCcodigo, CMCnombre
					from CMCompradores
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
				</cfquery>
				<cfif isdefined("rsComprador") and rsComprador.RecordCount NEQ 0>
					<cfset ArrayAppend(ValuesComprador, rsComprador.CMCid)>
					<cfset ArrayAppend(ValuesComprador, rsComprador.CMCcodigo)>
					<cfset ArrayAppend(ValuesComprador, rsComprador.CMCnombre)>
				</cfif>
			</cfif>

		<form name="form1" action="">
			<table width="99%" align="center" border="0" cellspacing="2" cellpadding="1" class="areaFiltro">
				<tr>      				
					<td width="15%" align="right" nowrap class="fileLabel" >
						<label for="SNcodigo"><strong>Del Comprador:&nbsp;</strong></label>
					</td>
					<td width="1%" nowrap>																									
						<cf_conlis 
							campos="CMCid,CMCcodigo,CMCnombre"
							asignar="CMCid,CMCcodigo,CMCnombre"
							size="0,10,25"
							desplegables="N,S,S"
							modificables="N,S,N"						
							title="Lista de Compradores"
							tabla="CMCompradores a "
							columnas="CMCid,CMCcodigo,CMCnombre"
							filtro="a.Ecodigo = #Session.Ecodigo# "
							filtrar_por="CMCcodigo,CMCnombre"
							desplegar="CMCcodigo,CMCnombre"
							etiquetas="C&oacute;digo, Nombre"
							valuesArray="#ValuesComprador#"
							formatos="S,S"
							align="left,left"								
							asignarFormatos="S,S,S"
							form="form1"
							showEmptyListMsg="true"
							EmptyListMsg=" --- No se encontraron registros --- "
						/> 						             
					</td>
					<td width="1%">&nbsp;</td>
					<td width="15%" align="right" nowrap><label for="fESnumeroH"><strong>Del N&uacute;mero:&nbsp;</strong></label></td>
					<td nowrap width="15%">		
						<input type="text" name="fEsnumeroD" size="10" maxlength="100" value="<cfif isdefined('form.fESnumeroD')><cfoutput>#form.fESnumeroD#</cfoutput></cfif>" onBlur="javascript:fm(this,0)" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" > &nbsp;<!---</td>--->
					</td>
					<td width="5%" align="right" nowrap><label for="fESnumeroH"><strong>Al N&uacute;mero:&nbsp;</strong></label></td>
					<td nowrap width="15%">
						<input type="text" name="fEsnumeroH" size="10" maxlength="100" value="<cfif isdefined('form.fESnumeroH')><cfoutput>#form.fESnumeroH#</cfoutput></cfif>" onBlur="javascript:fm(this,0)" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"> &nbsp;
					</td>	
					<td width="50">&nbsp;</td>						
				</tr>	
				<tr>
					<td nowrap align="right" class="fileLabel" width="5%"><label for="fTipoSolicitud"><strong>Tipo:</strong></label></td>
					<td nowrap width="15%">	
						<cf_conlis 
							campos="CMTOcodigo, CMTOdescripcion"
							asignar="CMTOcodigo, CMTOdescripcion"
							size="10,25"
							desplegables="S,S"
							modificables="S,N"						
							title="Lista de Tipos de Orden de Compra"
							tabla="CMTipoOrden a "
							columnas="CMTOcodigo, CMTOdescripcion"
							filtro="a.Ecodigo = #Session.Ecodigo# "
							filtrar_por="CMTOcodigo, CMTOdescripcion"
							desplegar="CMTOcodigo, CMTOdescripcion"
							etiquetas="C&oacute;digo, Descripci&oacute;n"
							formatos="S,S"
							align="left,left"								
							asignarFormatos="S,S"
							form="form1"
							valuesArray="#ValuesTipoOC#"
							showEmptyListMsg="true"
							EmptyListMsg=" --- No se encontraron registros --- "
						/>              						
					</td>
					<td width="1%">&nbsp;</td>
					<td  nowrap align="right" width="5%"><strong>Fecha Desde:&nbsp;</strong></td>
					<td width="15%" align="left">						
						<cfif isdefined('form.fechaD')>							
							<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="#form.fechaD#">
						<cfelse>
							<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="#vd_fechadesde#">
						</cfif>
					</td>
					<td nowrap align="right" width=""><strong>Fecha Hasta:&nbsp;</strong></td>
					<td width="15%" align="left" nowrap>
						<cfoutput>
						<cfif isdefined('form.fechaH')>
							<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="#form.fechaH#">
						<cfelse>
							<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="#vd_fechahasta#">
						</cfif>
						</cfoutput>
					</td>
					<td align="center" rowspan="3" valign="top" width="5%"><input type="submit" name="btnFiltro"  value="Filtrar"></td>
					<td width="1%">&nbsp;</td>	
				</tr>				
				<tr>					
					<td align="right"  nowrap width="5%"><label for="CMCid"><strong>Proveedor:&nbsp;</strong></label></td>					
					<td colspan="3" width="15%">
						<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
							<cf_sifsociosnegocios2 idquery="#form.SNcodigo#" form="form1">
						<cfelse>
							<cf_sifsociosnegocios2 form="form1">
						</cfif>							
					</td>					
					<td width="1%">&nbsp;</td>	
				</tr>			
			</table>
		</form>			
		<cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery name="rsLista" datasource="#session.DSN#">
			select  a.EOidorden, a.EOnumero, a.Ecodigo, a.EOfecha, a.Observaciones,a.EOtotal,
					a.CMTOcodigo,a.EOestado,
					c.CMTOcodigo#_Cat#'-'#_Cat#c.CMTOdescripcion as CMTOdescripcion,							   	
					d.Mnombre, e.SNnumero					
			from EOrdenCM a
					inner join CMTipoOrden c 			
						on c.Ecodigo = a.Ecodigo 
						and c.CMTOcodigo = a.CMTOcodigo
					inner join Monedas d
						on a.Mcodigo = d.Mcodigo 
						and a.Ecodigo = d.Ecodigo
					inner join SNegocios e
						on a.SNcodigo = e.SNcodigo
						and a.Ecodigo = e.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.EOestado = 10  				<!----======== Ordenes que esten aplicadas =====----->
				and exists ( select 1				<!----======== Ordenes que no hayan sido surtidas ========----->
							 from DOrdenCM do
							 where do.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
							   and do.EOidorden = a.EOidorden
							   and do.DOcantsurtida = 0)			
			<cfif isdefined("form.CMCid") and len(trim(form.CMCid)) >
				and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
			</cfif>
			
			<cfif isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD)) and (isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH))) >
				<cfif form.fESnumeroD  GT form.fESnumeroH>
					and a.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
					and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
				<cfelseif form.fESnumeroD EQ form.fESnumeroH>
					and a.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
				<cfelse>
					and a.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
					and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
				</cfif>
			</cfif>
			
			<cfif isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD)) and not (isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH))) >
				and a.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
			</cfif>
			
			<cfif isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH)) and not (isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD))) >
				and a.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
			</cfif>
			
			<cfif isdefined("form.CMTOcodigo") and len(trim(form.CMTOcodigo)) >
				and a.CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMTOcodigo#">
			</cfif>						

			<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo)) >
				and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			</cfif>

			<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and isdefined("Form.fechaH") and len(trim(Form.fechaH))>
				<cfif form.fechaD EQ form.fechaH>
					and a.EOfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
				<cfelse>
					and a.EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
				</cfif>
			<cfelseif isdefined("vd_fechadesde") and not isdefined("form.fechaD") and isdefined("vd_fechahasta") and not isdefined("Form.fechaH")>
				and a.EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(vd_fechadesde)#">
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(vd_fechahasta)#">
			</cfif>

			<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and not ( isdefined("Form.fechaH") and len(trim(Form.fechaH)) )>
				and a.EOfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
			</cfif>

			<cfif isdefined("Form.fechaH") and len(trim(Form.fechaH)) and not ( isdefined("Form.fechaD") and len(trim(Form.fechaD)) )>
				and a.EOfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
			</cfif>
			
			order by CMTOdescripcion,EOnumero
		</cfquery>						
		
		<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="cortes" value="CMTOdescripcion"/>
				<cfinvokeargument name="desplegar" value="EOnumero, Observaciones,  EOfecha, SNnumero, Mnombre, EOtotal"/>
				<cfinvokeargument name="etiquetas" value="N&uacute;mero, Observaciones , Fecha, Proveedor, Moneda, Total"/>
				<cfinvokeargument name="formatos" value="V, V, D, V,  V, M"/>
				<cfinvokeargument name="align" value="left, left, left, left,  left, right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<!----<cfinvokeargument name="irA" value="CambioestadoimpresionOC-SQL.cfm"/>---->
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="EOidorden"/>
				<cfinvokeargument name="funcion" value="funcPopUp"/>
				<cfinvokeargument name="fparams" value="EOidorden"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/> 				
				<!----<cfinvokeargument name="MaxRows" value="1"/> --->
		</cfinvoke>

<!---<iframe name="fr" id="frCompradores" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>---->

<script language='JavaScript' type='text/JavaScript' src='/cfmx/sif/js/qForms/qforms.js'></script>
<script language='javascript' type='text/JavaScript' >
<!--//
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	/*//Conlis Ordenes de compra (Pantalla que se muestra al dar click sobre la lista)
	function doConlis(valor) {
		var params ="";
		popUpWindow("/cfmx/sif/cm/consultas/OrdenesCompra-vista.cfm?EOidorden="+valor,10,10,1000,550);
	}*/
	function funcPopUp(prn_valor) {
		var params ="";
		popUpWindow("/cfmx/sif/cm/operacion/CambioestadoimpresionOC-PopUp.cfm?EOidorden="+prn_valor,160,195,650,300);
	}

	<cfif isdefined("Regresar")>
		function funcRegresar(){
			location.href = "<cfoutput>#Regresar#</cfoutput>";
			return true;
		}
	</cfif>
	
	/*//Conlis de compradores 
	function doConlisCompradores() {	
		var params = "";
			params = "?formulario=form1&CMCid=CMCid1&CMCcodigo=CMCcodigo1&desc=CMCnombre1";
		popUpWindow("/cfmx/sif/cm/consultas/ConlisCompradoresConsulta.cfm"+params,250,200,650,400);
	}
	
	function comprador(value){
		if ( value !='' ){
			document.getElementById("frCompradores").src = "/cfmx/sif/cm/consultas/CompradoresConsulta.cfm?formulario=form1&CMCcodigo="+value+"&opcion=1";
		}
		else{
			document.form1.CMCid1.value = '';
			document.form1.CMCcodigo1.value = '';
			document.form1.CMCnombre1.value = '';
		}
	}*/
//-->
</script>

		<cf_web_portlet_end>
	<cf_templatefooter>

