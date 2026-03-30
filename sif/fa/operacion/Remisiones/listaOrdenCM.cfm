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
				popUpWindow("/cfmx/sif/cm/operacion/imprimeOrden.cfm?EOidorden=#url.EOidorden#&primeravez=ok" + params,250,200,650,400);
			}
			imprime();
		</script>
	</cfoutput>
</cfif>
<cfset lvarProvCorp = false>
<cfparam name="form.Ecodigo_f" default="#Session.Ecodigo#">
<cfquery name="rsProvCorp" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 5100
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
<cf_templateheader title="Remisiones">
	<cfinclude template="../../../portlets/pNavegacionCM.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Ordenes de Compra '>
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	    		<tr>
     				 <td>
						<cfinclude template="ordenCompra-filtroglobal.cfm">
						<cfset navegacion = "">
						<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero)) >
							<cfset navegacion = navegacion & "&fEOnumero=#form.fEOnumero#">
						</cfif>
						<cfif isdefined("form.fEOnumero2") and len(trim(form.fEOnumero2)) >
							<cfset navegacion = navegacion & "&fEOnumero2=#form.fEOnumero2#">
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
						<!----Verificar si esta encendido el parámetro de múltiples contratos---->
						<cfquery name="rsParametro_MultipleContrato" datasource="#session.DSN#">
							select Pvalor 
							from Parametros 
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
							  and Pcodigo = 730 
						</cfquery>
						<cfif isdefined("rsParametro_MultipleContrato") and rsParametro_MultipleContrato.Pvalor EQ 1>
							<!----Verificar que el usuario logueado sea un usuario autorizador de OC's---->
							<cfquery name="rsUsuario_autorizado" datasource="#session.DSN#"><!---Maxrows="1" El maxrows es porque aun no se ha indicado si un Usuario puede ser autorizado por mas de 1 comprador---->
								select CMCid from CMUsuarioAutorizado
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							</cfquery>
							<cfif rsUsuario_autorizado.RecordCount NEQ 0>
								<cfset vnCompradores = valueList(rsUsuario_autorizado.CMCid)>
								<cfif isdefined("session.compras.comprador") and len(trim(session.compras.comprador))>
									<cfset vnCompradores = vnCompradores &','& session.compras.comprador>
								</cfif>							
							</cfif>
						</cfif>
                        <cfinclude template="../../../Utiles/sifConcat.cfm">
						<cfquery name="rsMontoComprador" datasource="#session.dsn#">
						  Select 
						      CMCmontomax, Mcodigo
						  from CMCompradores cm
						   where cm.Usucodigo = #session.Usucodigo# 
						   and cm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						</cfquery>
						
						 <cfquery datasource="#session.dsn#" name="rsHtc">
								select coalesce(TCventa,0) as TCventa 
								from Htipocambio 
								where Mcodigo = #rsMontoComprador.Mcodigo# 
								  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between Hfecha and Hfechah 
						</cfquery>
						<cfif rsHtc.recordcount eq 0>
							<cfset LvarTC = 1>
						<cfelse>
							<cfset LvarTC = rsHtc.TCventa>
						</cfif>
						
						<cfquery name="rsLista" datasource="#session.DSN#" maxrows="120">
							select 	a.EOidorden, a.Ecodigo, a.EOnumero, a.SNcodigo, 
									a.CMCid, a.Mcodigo, a.Rcodigo, a.CMTOcodigo, 
									a.EOfecha, a.Observaciones, a.EOtc, a.EOrefcot, 
									a.Impuesto, a.EOdesc, a.EOtotal, a.Usucodigo, 
									a.EOfalta, a.Usucodigomod, a.fechamod, a.EOplazo, 
									a.NAP, a.NRP, a.NAPcancel, a.EOporcanticipo, a.EOestado, 
									b.Mnombre, c.CMCnombre, e.SNnombre, 
									f.CMTOcodigo#_Cat#'-'#_Cat#f.CMTOdescripcion  as descripcion,
									case 
										when f.CMTOte = 1 and a.EOdiasEntrega is null then '<font color=''##FF0000''>*</font>'
										when f.CMTOtransportista = 1 and a.CRid is null then '<font color=''##FF0000''>*</font>'
										when f.CMTOtipotrans = 1 and a.EOtipotransporte is null then '<font color=''##FF0000''>*</font>'
										when f.CMTOincoterm = 1 and a.CMIid is null then '<font color=''##FF0000''>*</font>'
										when f.CMTOlugarent = 1 and a.EOlugarentrega is null then '<font color=''##FF0000''>*</font>'
										when a.EOestado = -7  then '<font color=''##FF0000''>En autorizacion jefe CM</font>'
                                        when a.EOestado = -8  then '<font color=''##900''>Rechazada por jefe CM</font>'
										when a.EOestado = 9  then '<font color=''##009900''>Autorizada por jefe CM</font>'
										when a.EOestado = 0 and a.Mcodigo <> #rsMontoComprador.Mcodigo# and (a.EOtotal * a.EOtc) >  (#rsMontoComprador.CMCmontomax# * #LvarTC#) then '<font color=''##FF0000''>Exceso en monto</font>'
										when a.EOestado = 0 and a.Mcodigo = #rsMontoComprador.Mcodigo# and a.EOtotal  >  #rsMontoComprador.CMCmontomax# then '<font color=''##FF0000''>Exceso en monto</font>'
										else ' '
									end as asterisco,
									case 
										when f.CMTOte = 1 and a.EOdiasEntrega is null then EOidorden
										when f.CMTOtransportista = 1 and a.CRid is null then EOidorden
										when f.CMTOtipotrans = 1 and a.EOtipotransporte is null then EOidorden
										when f.CMTOincoterm  = 1 and a.CMIid is null then EOidorden
										when f.CMTOlugarent  = 1 and a.EOlugarentrega is null then EOidorden
										when a.EOestado 	 = -7  then EOidorden
                                        when a.EOestado      = -8  then EOidorden
										else 0 
									end as marca,
									case 
										when a.EOestado = 0 and a.Mcodigo <> #rsMontoComprador.Mcodigo# and (a.EOtotal * a.EOtc) >  #rsMontoComprador.CMCmontomax# then 0 
										when a.EOestado = 0 and a.Mcodigo = #rsMontoComprador.Mcodigo# and a.EOtotal  >  #rsMontoComprador.CMCmontomax# then 0
										else 1
									end as puede,
									(( 
										select d.Rdescripcion
										from Retenciones d 
										where d.Ecodigo = a.Ecodigo 
										  and d.Rcodigo = a.Rcodigo
									)) as Rdescripcion, a.Ecodigo as Ecodigo_f
							from ERemisionesFA a
								inner join Monedas b on b.Mcodigo = a.Mcodigo
								inner join CMCompradores c on c.CMCid = a.CMCid
								inner join SNegocios e on e.Ecodigo = a.Ecodigo and e.SNcodigo = a.SNcodigo
								inner join CMTipoOrden f on a.Ecodigo =f.Ecodigo and a.CMTOcodigo = f.CMTOcodigo
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo_f#">
							  and a.EOestado in (0,1,2,3,4,5,6,7,8,9,-7,-8,-10)
								<!----Si el usuario logueado es usuario autorizado y NO es un comprador---->
								<cfif isdefined("vnCompradores") and len(trim(vnCompradores))>
									<!----and a.CMCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsUsuario_autorizado.CMCid#">---->
									and a.CMCid in (#vnCompradores#)
								<cfelse>
									<cfif isdefined("session.compras.comprador") and len(trim(session.compras.comprador))>
									and a.CMCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.compras.comprador#">
									</cfif>	
								</cfif>								
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
									and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoF#">
								</cfif>
								<cfif isdefined("Form.fEOfecha") and len(trim(Form.fEOfecha)) >
									and a.EOfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fEOfecha)#">
								</cfif>
							order by descripcion,EOnumero
						</cfquery>

						<!---Si el parámetro de multiples contratos y el usuario es UsuarioAutorizado---->
						<cfif isdefined("rsUsuario_autorizado") and rsUsuario_autorizado.RecordCount NEQ 0>
							<!---Verificar si es comprador---->
							<cfquery name="rsEsComprador" datasource="#session.DSN#">
								select Usucodigo 
								from CMCompradores 
								where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							</cfquery>
						</cfif>			
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
							<cfinvokeargument name="irA" value="ordenCompra.cfm"/>
							<cfif isdefined("rsEsComprador") and rsEsComprador.RecordCount EQ 0>							
								<cfinvokeargument name="botones" value="Aplicar"/>
							<cfelse>
								<cfinvokeargument name="botones" value="Nuevo,Aplicar"/>
							</cfif>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="EOidorden,puede,Ecodigo_f"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="radios" value="S"/>
							<cfinvokeargument name="maxrows" value="15"/>
							<cfinvokeargument name="inactivecol" value="marca"/>
						</cfinvoke>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td nowrap >
						<strong>Nota:</strong> <font style="color:#FF0000;"> Los registros marcados por un asterisco (*) en rojo, estan incompletos y no pueden ser Aplicados.<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						Debe de ir al mantenimiento y completar los datos requeridos para poder aplicar al Orden Compra.</font>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript1.2" type="text/javascript">
	function funcNuevo(){document.lista.ECODIGO_F.value = <cfoutput>#form.Ecodigo_f#</cfoutput>;}
	function funcAplicar(){
		var continuar = false;
		var continuar2 = false;
		
		if (document.lista.chk) {
			if (document.lista.chk.checked)
			 {
				continuar = document.lista.chk.checked;
				continuar2 = fnPuede(document.lista.chk); 
			
				<!---return fnPuede(document.lista.chk);--->
			}
			else {
				for (var k = 0; k < document.lista.chk.length; k++) {
					if (document.lista.chk[k].checked) {	
						continuar = true;
						continuar2 = fnPuede(document.lista.chk[k]);
						break;
					}
				}
			}
			if (!continuar) {alert('Debe seleccionar un Pedido'); }
		}
		else {
			alert('No se han seleccionado Pedidos)		}         
		if ( continuar && continuar2 ){	
		
		    continuar = true; 	
			document.lista.action = 'ordenCompra-sql.cfm';			
			document.lista.submit();
		}	
		else
		{
		   continuar = false;
		}
		return continuar;
	}
	function fnPuede(o)
	{
	  
		var LvarKeys = o.value.split("|");			
		if (LvarKeys[1] == 1)
			return true;
		else
			return confirm('¿Si aplica este Pedido, se generara una jerarquía de aprobación, desea Continuar?');
	}
</script>