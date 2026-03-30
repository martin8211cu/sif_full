<cfparam name="url.Ecodigo_f" default="#session.Ecodigo#">
<cfparam name="form.Ecodigo_f" default="#url.Ecodigo_f#">
<!---    Combo de tipos de solicitud de compra --->
<cfquery name="rsTiposOrden" datasource="#session.DSN#">
	select CMTOcodigo, CMTOdescripcion
	from 	CMTipoOrden
	where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo_f#">
</cfquery>

<!--- Proveduria Corporativa --->
<cfset lvarProvCorp = false>
<cfset lvarFiltroEcodigo = Session.Ecodigo>
<cfquery name="rsProvCorp" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo=#session.Ecodigo#
	and Pcodigo=5100
</cfquery>
<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
	<cfset lvarProvCorp = true>
	<cfquery name="rsEProvCorp" datasource="#session.DSN#">
        select EPCid
        from EProveduriaCorporativa
        where Ecodigo = #session.Ecodigo#
         and EPCempresaAdmin = #session.Ecodigo#
    </cfquery>
    <cfif rsEProvCorp.recordcount eq 0>
    	<cfthrow message="El Catálogo de Proveduría Corporativa no se ha configurado">
    </cfif>
    <cfquery name="rsDProvCorp" datasource="#session.DSN#">
        select DPCecodigo as Ecodigo, Edescripcion
        from DProveduriaCorporativa dpc
        	inner join Empresas e
            	on e.Ecodigo = dpc.DPCecodigo
        where dpc.Ecodigo = #session.Ecodigo#
         and dpc.EPCid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsEProvCorp.EPCid)#" list="yes">)
       	union
        select e.Ecodigo, e.Edescripcion
        from Empresas e
        where e.Ecodigo = #session.Ecodigo#
        order by 2
    </cfquery>
</cfif>
<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cf_templateheader title="Consulta de Órdenes de Compra ">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Órdenes de Compra '>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">

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
			
			<cfif isdefined("url.CMCnombre1") and not isdefined("form.CMCnombre1") >
				<cfset form.CMCnombre1 = url.CMCnombre1 >
			</cfif>
			
			<cfif isdefined("url.CMCid1") and not isdefined("form.CMCid1") >
				<cfset form.CMCid1 = url.CMCid1 >
			</cfif>
			
			<cfif isdefined("url.CMCcodigo1") and not isdefined("form.CMCcodigo1") >
				<cfset form.CMCcodigo1 = url.CMCcodigo1 >
			</cfif>
			
			<cfif isdefined("url.CMCnombre1") and not isdefined("form.CMCnombre1") >
				<cfset form.CMCnombre1 = url.CMCnombre1 >
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
			
			<cfif isdefined("Form.CMCcodigo1") and len(trim(form.CMCcodigo1))>
				<cfset navegacion = navegacion & "&CMCcodigo1=#form.CMCcodigo1#">
			</cfif>
			
			<cfif isdefined("Form.CMCnombre1") and len(trim(form.CMCnombre1))>
				<cfset navegacion = navegacion & "&CMCnombre1=#form.CMCnombre1#">
			</cfif>
			
			<cfif isdefined("Form.CMCid1") and len(trim(form.CMCid1))>
				<cfset navegacion = navegacion & "&CMCid1=#form.CMCid1#">
			</cfif>
			
			<cfif isdefined("Form.CMCcodigo1") and len(trim(form.CMCcodigo1))>
				<cfset navegacion = navegacion & "&CMCcodigo1=#form.CMCcodigo1#">
			</cfif>
			
			<cfif isdefined("Form.CMCnombre1") and len(trim(form.CMCnombre1))>
				<cfset navegacion = navegacion & "&CMCnombre1=#form.CMCnombre1#">
			</cfif>
			
			<cfif isdefined("Form.SNcodigo") and len(trim(form.SNcodigo))>
				<cfset navegacion = navegacion & "&SNcodigo=#form.SNcodigo#">
			</cfif>
			
			<cfif isdefined("form.CMTOcodigo") and len(trim(form.CMTOcodigo)) eq 0 >
				<cfset navegacion = navegacion & "&CMTOcodigo=#form.CMTOcodigo#">
			</cfif>
			
			<cfif isdefined("form.CMTOdescripcion") and len(trim(form.CMTOdescripcion)) eq 0 >
				<cfset navegacion = navegacion & "&CMTOdescripcion=#form.CMTOdescripcion#">
			</cfif>
            <cfif isdefined("form.Ecodigo_f") and len(trim(form.Ecodigo_f)) eq 0 >
				<cfset navegacion = navegacion & "&Ecodigo_f=#form.Ecodigo_f#">
			</cfif>
			<cfif not isdefined("form.CMCid1") or len(trim(form.CMCid1)) eq 0 and not isdefined("btnFiltro")>
				<cfset form.CMCid1 = session.compras.comprador >
			</cfif>
			<cfif  isdefined("form.CMCid1") and  len(trim(form.CMCid1)) gt 0 >
				<cfquery name="rsComprador" datasource="#session.DSN#" >
					select CMCid, CMCcodigo, CMCnombre
					from CMCompradores
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
				</cfquery>
			</cfif>

		<!--- Estado default --->
		<cfparam name="form.LEstado" default="1">

		<form name="form1" action="">
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
				<tr>      				
					<td align="right" class="fileLabel" nowrap >
						<label for="SNcodigo"><strong>Del Comprador:&nbsp;</strong></label>
					</td>
					<td nowrap>																
						<cfoutput>
							<input type="text" name="CMCcodigo1" maxlength="10" value="<cfif isdefined("rsComprador")>#trim(rsComprador.CMCcodigo)#</cfif>" size="10" onBlur="javascript:comprador(this.value);" >
							<input type="text" name="CMCnombre1" id="CMCnombre1" tabindex="1" readonly value="<cfif isdefined("rsComprador") >#rsComprador.CMCnombre#</cfif>" size="40" maxlength="80">
							<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores();'></a>
							<input type="hidden" name="CMCid1" id="CMCid1" value="<cfif isdefined("rsComprador") >#rsComprador.CMCid#</cfif>" >
						</cfoutput>																								
					</td>
					<td width="3">&nbsp;</td>
					<td nowrap align="right"><label for="fESnumeroH"><strong>Del N&uacute;mero:&nbsp;</strong></label></td>
					<td nowrap>		
						<input type="text" name="fEsnumeroD" size="10" maxlength="100" value="<cfif isdefined('form.fESnumeroD')><cfoutput>#form.fESnumeroD#</cfoutput></cfif>" onBlur="javascript:fm(this,0)" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" > &nbsp;<!---</td>--->
					</td>
					<td nowrap align="right"><label for="fESnumeroH"><strong>Al N&uacute;mero:&nbsp;</strong></label></td>
					<td nowrap>
						<input type="text" name="fEsnumeroH" size="10" maxlength="100" value="<cfif isdefined('form.fESnumeroH')><cfoutput>#form.fESnumeroH#</cfoutput></cfif>" onBlur="javascript:fm(this,0)" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"> &nbsp;
					</td>	
					<td width="1">&nbsp;</td>						
				</tr>	
				<tr>
					<td nowrap align="right" class="fileLabel"><label for="fTipoSolicitud"><strong>Tipo:</strong></label></td>
					<td nowrap>	
						<cfoutput>																			
						<input name="CMTOcodigo" type="text" value="<cfif isDefined("form.CMTOcodigo")><cfoutput>#form.CMTOcodigo#</cfoutput></cfif>" 
							id="CMTOcodigo" size="5" maxlength="5" tabindex="-1" onblur="javascript:traerTOrden(this.value,1);">
						<input name="CMTOdescripcion" type="text" id="CMTOdescripcion" value="<cfif isDefined("form.CMTOdescripcion")><cfoutput>#form.CMTOdescripcion#</cfoutput></cfif>" size="40" readonly>
						<a href="##" tabindex="-1">
						<img src="../../imagenes/Description.gif" alt="Lista de tipos de Órdenes" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisTOrdenes();">
						</a>        											
						</cfoutput>
					</td>
					<td width="3">&nbsp;</td>
					<td  nowrap align="right"><strong>Fecha Desde:&nbsp;</strong></td>
					<td width="16" align="right">
						<cfif isdefined('form.fechaD')>
							<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="#form.fechaD#">
						<cfelse>
							<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="">
						</cfif>
					</td>
					<td nowrap align="right"><strong>Fecha Hasta:&nbsp;</strong></td>
					<td width="23" align="right" nowrap>
						<cfif isdefined('form.fechaH')>
							<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="#form.fechaH#">
						<cfelse>
							<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="">
						</cfif>
					</td>
					<td width="1">&nbsp;</td>	
				</tr>
				<tr>
					<td class="fileLabel" nowrap align="right"><label for="LEstado"><strong>Estado:&nbsp;</strong></label></td>
					<td nowrap>								
						<select name="LEstado" id="LEstado">
							<option value="" >- No especificado -</option>
							<option value="1" <cfif isdefined('form.LEstado') and form.LEstado EQ 1>selected</cfif>>Pendientes de Sutir</option>
							<option value="0" <cfif isdefined('form.LEstado') and form.LEstado EQ 0>selected</cfif>>Pendiente</option>
							<option value="5" <cfif isdefined('form.LEstado') and form.LEstado EQ 5>selected</cfif>>Pendiente Vía Proceso</option>
							<option value="7" <cfif isdefined('form.LEstado') and form.LEstado EQ 7>selected</cfif>>Pendiente O.C. Directa</option>
							<option value="-7" <cfif isdefined('form.LEstado') and form.LEstado EQ -7>selected</cfif>>En proceso de firmas</option>
							<option value="-8" <cfif isdefined('form.LEstado') and form.LEstado EQ -8>selected</cfif>>Rechazada por el aprobador</option>							
							<option value="8" <cfif isdefined('form.LEstado') and form.LEstado EQ 8>selected</cfif>>Pendiente Vía Contrato</option>
							<option value="-10" <cfif isdefined('form.LEstado') and form.LEstado EQ -10>selected</cfif>>Pendiente de Aprobación Presupuestal</option>
							<option value="10" <cfif isdefined('form.LEstado') and form.LEstado EQ 10>selected</cfif>>Aplicadas</option>
							<option value="55" <cfif isdefined('form.LEstado') and form.LEstado EQ 55>selected</cfif>>Canceladas Parcialmente Surtidas</option>
							<option value="60" <cfif isdefined('form.LEstado') and form.LEstado EQ 60>selected</cfif>>Canceladas</option>
							<option value="70" <cfif isdefined('form.LEstado') and form.LEstado EQ 70>selected</cfif>>Anuladas</option>
						</select>
					</td>								
					<td width="3">&nbsp;</td>
					<td align="right"  nowrap><label for="CMCid"><strong>Proveedor:&nbsp;</strong></label></td>					
					<td>
						<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
							<cf_sifsociosnegocios2 idquery="#form.SNcodigo#" form="form1" Ecodigo="#form.Ecodigo_f#">
						<cfelse>
							<cf_sifsociosnegocios2 form="form1" Ecodigo="#form.Ecodigo_f#">
						</cfif>							
					</td>
					<td align="center" colspan="2"><input type="submit" name="btnFiltro"  value="Filtrar"></td>
					<td width="1">&nbsp;</td>	
				</tr>	
                <cfif lvarProvCorp>
                    <td align="right" nowrap><strong>Empresa: </strong></td>
                    <td colspan="7">
                        <select name="Ecodigo_f" id="Ecodigo_f" onchange="this.form.submit();">
                            <cfloop query="rsDProvCorp">
                                <option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif isdefined('form.Ecodigo_f') and form.Ecodigo_f eq rsDProvCorp.Ecodigo> selected</cfif>><cfoutput>#rsDProvCorp.Edescripcion#</cfoutput></option>		
                            </cfloop>	
                        </select></td>
                  </cfif>		
			</table>
		</form>			
		<cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery name="rsLista" datasource="#session.DSN#" maxrows="405">
			select  a.EOidorden, a.EOnumero, a.Ecodigo, a.EOfecha, a.Observaciones,a.EOtotal,
					a.CMTOcodigo,a.EOestado,
					c.CMTOcodigo#_Cat#'-'#_Cat#c.CMTOdescripcion as CMTOdescripcion,							   	
					Coalesce(d.Mnombre,'No Existe') as Mnombre, e.SNnumero,
					case when a.EOestado = 10 
							then '<img 	src="OrdenesCompra-email.gif" 
										style="cursor:pointer" 
										onclick="location.href=&quot;OrdenesCompra-email.cfm?EOidorden='
												#_Cat#
												<cf_dbfunction name="to_char" datasource="#session.DSN#" args="a.EOidorden">
												#_Cat#
												'&Ecodigo=#form.Ecodigo_f#&quot;" 
										border="0" width="37" height="12">'
							else '  ' end as dibujo
			from EOrdenCM a
					LEFT OUTER join CMTipoOrden c 			
						on c.Ecodigo = a.Ecodigo 
						and c.CMTOcodigo = a.CMTOcodigo
                        
					LEFT OUTER join Monedas d
						on a.Mcodigo = d.Mcodigo 
						
					LEFT OUTER join SNegocios e
						on a.SNcodigo = e.SNcodigo
						and a.Ecodigo = e.Ecodigo
                        
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo_f#">
							
			<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) >
				and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
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

			<cfif isdefined("form.LEstado") and len(trim(form.LEstado))  >
				<cfif form.LEstado neq 1 >
					and a.EOestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.LEstado#">
				<cfelse>
					and (select count(1)
						 from DOrdenCM do
						 where do.EOidorden = a.EOidorden
						   and do.DOcantidad > do.DOcantsurtida 
						) > 0
				</cfif>	
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
			</cfif>

			<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and not ( isdefined("Form.fechaH") and len(trim(Form.fechaH)) )>
				and a.EOfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
			</cfif>

			<cfif isdefined("Form.fechaH") and len(trim(Form.fechaH)) and not ( isdefined("Form.fechaD") and len(trim(Form.fechaD)) )>
				and a.EOfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
			</cfif>
			
			order by CMTOdescripcion,EOnumero
		</cfquery>						
		
        <cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                <cfinvokeargument name="query" 		value="#rsLista#"/>
                <cfinvokeargument name="cortes" 	value="CMTOdescripcion"/>
                <cfinvokeargument name="desplegar" 	value="EOnumero, Observaciones,  EOfecha, SNnumero, Mnombre, EOtotal, dibujo"/>
                <cfinvokeargument name="etiquetas" 	value="N&uacute;mero, Observaciones , Fecha, Proveedor, Moneda, Total, &nbsp;"/>
                <cfinvokeargument name="formatos" 	value="V, V, D, V,  V, M, IMG "/>
                <cfinvokeargument name="align" 		value="left, left, left, left,  left, right, right"/>
                <cfinvokeargument name="ajustar" 	value="N"/>
                <cfinvokeargument name="irA" 		value="OrdenesCompra-vista.cfm "/>
                <cfinvokeargument name="showEmptyListMsg" value="true"/>
                <cfinvokeargument name="keys" 		value="EOidorden"/>
                <cfinvokeargument name="funcion" 	value="doConlis"/>
                <cfinvokeargument name="fparams" 	value="EOidorden"/>
                <cfinvokeargument name="navegacion" value="#navegacion#"/> 	
                <cfinvokeargument name="UsaAjax" 	value="no"/> 	
        </cfinvoke>


<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
<iframe name="fr" id="frCompradores" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>

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

	//Conlis Ordenes de compra (Pantalla que se muestra al dar click sobre la lista)
	function doConlis(valor) {
		var params ="";
		popUpWindow("/cfmx/sif/cm/consultas/OrdenesCompra-vista.cfm?Ecodigo=<cfoutput>#form.Ecodigo_f#</cfoutput>&EOidorden="+valor,10,10,1000,550);
	}

	<cfif isdefined("Regresar")>
		function funcRegresar(){
			location.href = "<cfoutput>#Regresar#</cfoutput>";
			return true;
		}
	</cfif>
	
	//Conlis de compradores 
	function doConlisCompradores() {	
		var params = "";
			params = "?formulario=form1&CMCid=CMCid1&CMCcodigo=CMCcodigo1&desc=CMCnombre1&Ecodigo=<cfoutput>#form.Ecodigo_f#</cfoutput>";
		popUpWindow("/cfmx/sif/cm/consultas/ConlisCompradoresConsulta.cfm"+params,250,200,650,400);
	}
	
	function comprador(value){
		if ( value !='' ){
			document.getElementById("frCompradores").src = "/cfmx/sif/cm/consultas/CompradoresConsulta.cfm?formulario=form1&CMCcodigo="+value+"&opcion=1&Ecodigo=<cfoutput>#form.Ecodigo_f#</cfoutput>";
		}
		else{
			document.form1.CMCid1.value = '';
			document.form1.CMCcodigo1.value = '';
			document.form1.CMCnombre1.value = '';
		}
	}
	
	//Funcion del conlis de tipos de orden
	function doConlisTOrdenes() {
		popUpWindow("../operacion/conlisTOrdenesSolicitante.cfm?formulario=form1&Ecodigo=<cfoutput>#form.Ecodigo_f#</cfoutput>",250,150,550,400);
	}
	
	//Funcion para traer datos del tipo de orden cuando estos fueron digitados por el usuario
	function traerTOrden(value){
	  if (value!=''){	
	   document.getElementById("fr").src = '../operacion/traerTOrdenesSolicitante.cfm?formulario=form1&Ecodigo=<cfoutput>#form.Ecodigo_f#</cfoutput>&CMTOcodigo='+value;
	  }
	  else{
	   document.form1.CMTOcodigo.value = '';
	   document.form1.CMTOdescripcion.value = '';
	  }
	 }	

//-->
</script>

		<cf_web_portlet_end>
	<cf_templatefooter>

