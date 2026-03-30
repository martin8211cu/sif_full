<cfif isdefined("url.imprimir") and isdefined("url.EOidorden") and len(trim(url.EOidorden))>
<!--- *1* --->
	<cfoutput>
		<script language="javascript1.2" type="text/javascript">
			var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}
		
			function imprime() {				
				var params ="";		
				<cfif isdefined("url.tipoImpresion") and len(trim(url.tipoImpresion))>
					params ="&tipoImpresion=1";			
				</cfif>			
				popUpWindow("/cfmx/sif/cm/operacion/imprimeOrden.cfm?EOidorden=#url.EOidorden#" + params,250,200,650,400);
			}
			imprime();
		</script>
	</cfoutput>
</cfif>

<cf_templateheader title="Ordenes de Compra ">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Ordenes de Compra '>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	    		<tr>
     				 <td>
						<cfinclude template="ordenCompra-filtroglobal.cfm">

						<cfset navegacion = "">
						<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero)) >
							<cfset navegacion = navegacion & "&fEOnumero=#form.fEOnumero#">
						</cfif>
						<cfif isdefined("form.fEOnumero2") and len(trim(form.fEOnumero2)) >
							<cfset navegacion = navegacion & "&fEOnumero=#form.fEOnumero2#">
						</cfif>
						<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
							<cfset navegacion = navegacion & "&fObservaciones=#form.fObservaciones#">
						</cfif>
						<cfif isdefined("Form.fEOfecha") and len(trim(form.fEOfecha))>
							<cfset navegacion = navegacion & "&fEOfecha=#form.fEOfecha#">
						</cfif>
						<cfif isdefined("Form.SNcodigoF") and len(trim(Form.SNcodigoF)) >
							<cfset navegacion = navegacion & "&SNcodigoF=#form.SNcodigoF#">
						</cfif>
						<cfinclude template="../../Utiles/sifConcat.cfm">
						<cfquery name="rsLista" datasource="#session.DSN#">
							select 	a.EOidorden, a.Ecodigo, a.EOnumero, a.SNcodigo, 
									a.CMCid, a.Mcodigo, a.Rcodigo, a.CMTOcodigo, 
									a.EOfecha, a.Observaciones, a.EOtc, a.EOrefcot, 
									a.Impuesto, a.EOdesc, a.EOtotal, a.Usucodigo, 
									a.EOfalta, a.Usucodigomod, a.fechamod, a.EOplazo, 
									a.NAP, a.NRP, a.NAPcancel, a.EOporcanticipo, a.EOestado, 
									b.Mnombre, c.CMCnombre, d.Rdescripcion, e.SNnombre, 
									f.CMTOcodigo#_Cat#'-'#_Cat#f.CMTOdescripcion  as descripcion,
									case 
										when f.CMTOte = 1 and a.EOdiasEntrega is null then '<font color=''##FF0000''>*</font>'
										when f.CMTOtransportista = 1 and a.CRid is null then '<font color=''##FF0000''>*</font>'
										when f.CMTOtipotrans = 1 and a.EOtipotransporte is null then '<font color=''##FF0000''>*</font>'
										when f.CMTOincoterm = 1 and a.CMIid is null then '<font color=''##FF0000''>*</font>'
										when f.CMTOlugarent = 1 and a.EOlugarentrega is null then '<font color=''##FF0000''>*</font>'
									end as asterisco,
									case 
										when f.CMTOte = 1 and a.EOdiasEntrega is null then EOidorden
										when f.CMTOtransportista = 1 and a.CRid is null then EOidorden
										when f.CMTOtipotrans = 1 and a.EOtipotransporte is null then EOidorden
										when f.CMTOincoterm = 1 and a.CMIid is null then EOidorden
										when f.CMTOlugarent = 1 and a.EOlugarentrega is null then EOidorden
									end as marca
							from EOrdenCM a
								left outer join Monedas b on a.Ecodigo = b.Ecodigo and a.Mcodigo = b.Mcodigo
								left outer join CMCompradores c on a.Ecodigo = c.Ecodigo and a.CMCid = c.CMCid
								left outer join Retenciones d on a.Ecodigo = d.Ecodigo and a.Rcodigo = d.Rcodigo
								left outer join SNegocios e on a.Ecodigo = e.Ecodigo and a.SNcodigo = e.SNcodigo
								left outer join CMTipoOrden f on a.Ecodigo =f.Ecodigo and a.CMTOcodigo = f.CMTOcodigo
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and a.CMCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.compras.comprador#">
								and a.EOestado = 10
								and EOidorden not in (
											Select dr.EOidorden
											from EDocumentosRecepcion dr
											where dr.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									)
								and EOidorden not in (
											Select ed.EOidorden
											from EDocumentosI ed
											where ed.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												and ed.EOidorden is not null
									)											
								
								<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero)) and isdefined("form.fEOnumero2") and len(trim(form.fEOnumero2))>
								
									and a.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero2#">
								<cfelseif isdefined("form.fEOnumero") and len(trim(form.fEOnumero))>
									and a.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero#">
								<cfelseif isdefined("form.fEOnumero2") and len(trim(form.fEOnumero2))>
									and a.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero2#">
								</cfif>
								
								<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
									and upper(Observaciones) like  upper('%#form.fObservaciones#%')
								</cfif>
								
								<cfif isdefined("Form.SNcodigoF") and len(trim(Form.SNcodigoF)) >
									and e.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigoF#">
								</cfif>
				
								<cfif isdefined("Form.fEOfecha") and len(trim(Form.fEOfecha)) >
									and EOfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fEOfecha)#">
								</cfif>
							order by descripcion,EOnumero
						</cfquery>
			
						<cfinvoke 
								component="sif.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="cortes" value="descripcion"/>
							<cfinvokeargument name="desplegar" value="asterisco, EOnumero, Observaciones, SNnombre, EOfecha, Mnombre, EOtotal"/>
							<cfinvokeargument name="etiquetas" value=" , N&uacute;mero, Descripci&oacute;n, Proveedor, Fecha, Moneda, Total"/>
							<cfinvokeargument name="formatos" value="V,V,V,V,D,V,M"/>
							<cfinvokeargument name="align" value="left,left,left,left,center,left,right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="ordenCompra_cambioFP.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="EOidorden"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="radios" value="N"/>
						</cfinvoke>
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>