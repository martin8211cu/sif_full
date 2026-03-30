

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Contratos" Default= "Contratos" XmlFile="listaContratos.xml" returnvariable="LB_Contratos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Moneda" Default= "Moneda" XmlFile="listaContratos.xml" returnvariable="LB_Moneda"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Total" Default= "Total" XmlFile="listaContratos.xml" returnvariable="LB_Total"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Numero" Default= "N&uacute;mero" XmlFile="listaContratos.xml" returnvariable="LB_Numero"/>

<cfif isdefined("url.imprimir") and isdefined("url.ctcontid") and len(trim(url.ctcontid))>
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
    popUpWindow("/cfmx/sif/contratos/operacion/imprimeContrato.cfm?ctcontid=#url.ctcontid#&primeravez=ok" + params,250,200,650,400);
   }
   imprime();
  </script>
 </cfoutput>
</cfif>

<cfparam name="form.Ecodigo" default="#Session.Ecodigo#">

<cf_templateheader title=#LB_Contratos#>
	<cfinclude template="../../portlets/pNavegacionCM.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=#LB_Contratos#>
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	    		<tr>
     				 <td>
						<cfinclude template="Contrato-filtroglobal.cfm">
						<cfset navegacion = "">
						<cfif isdefined("form.fCTCnumContrato") and len(trim(form.fCTCnumContrato)) >
							<cfset navegacion = navegacion & "&fCTCnumContrato=#form.fCTCnumContrato#">
						</cfif>
                        <cfif isdefined("form.fCTCnumContrato2") and len(trim(form.fCTCnumContrato2)) >
							<cfset navegacion = navegacion & "&fCTCnumContrato2=#form.fCTCnumContrato2#">
						</cfif>
						<cfif isdefined("form.fDescripciones") and len(trim(form.fDescripciones)) >
							<cfset navegacion = navegacion & "&fDescripciones=#form.fDescripciones#">
						</cfif>
						<cfif isdefined("Form.fFecha") and len(trim(form.fFecha))>
							<cfset navegacion = navegacion & "&fFecha=#form.fFecha#">
						</cfif>
						<cfif isdefined("Form.SNcodigoF") and len(trim(Form.SNcodigoF)) >
							<cfset navegacion = navegacion & "&SNcodigoF=#form.SNcodigoF#">
						</cfif>
						
                        <cfinclude template="../../Utiles/sifConcat.cfm">
				
						<cfquery name="rsLista" datasource="#session.DSN#" maxrows="120">
                                 select a.CTCnumContrato,a.CTCdescripcion,a.CTfecha, a.CTmonto,d.Mnombre,b.SNnombre, b.SNcodigo,a.CTContid, a.Ecodigo 
                                 from CTContrato a
                                    inner join SNegocios b
                                        on a.SNid = b.SNid
                                        and a.Ecodigo = b.Ecodigo
                                    inner join CTTipoContrato c
                                        on a.CTTCid = c.CTTCid
                                        and a.Ecodigo = c.Ecodigo
                                    inner join Monedas d
                                        on a.CTMcodigo = d.Mcodigo
                                        and a.Ecodigo = d.Ecodigo
                                    inner join CTFundamentoLegal e
                                        on a.CTFLid = e.CTFLid
                                        and a.Ecodigo = e.Ecodigo
                                    inner join CTProcedimientoContratacion f
                                        on a.CTPCid = f.CTPCid
                                        and a.Ecodigo = f.Ecodigo
                                    inner join CTCompradores g
                                        on a.CTCid = g.CTCid
                                        and a.Ecodigo = g.Ecodigo
                                    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
                                    and g.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                                    and a.CTCestatus = 0					
								<cfif isdefined("form.fCTCnumContrato") and len(trim(form.fCTCnumContrato)) 
								  and isdefined("form.fCTCnumContrato") and len(trim(form.fCTCnumContrato2))>
									and upper(a.CTCnumContrato) between upper('#form.fCTCnumContrato#')
                                    and upper('#form.fCTCnumContrato2#')
                                    
								<cfelseif isdefined("form.fCTCnumContrato") and len(trim(form.fCTCnumContrato))>
									and upper(a.CTCnumContrato) >= upper('#form.fCTCnumContrato#')
								<cfelseif isdefined("form.fCTCnumContrato2") and len(trim(form.fCTCnumContrato2))>
									and upper(a.CTCnumContrato) <= upper('#form.fCTCnumContrato2#')
								</cfif>
								<cfif isdefined("form.fDescripciones") and len(trim(form.fDescripciones)) >
									and upper(CTCdescripcion) like  upper('%#form.fDescripciones#%')
								</cfif>
								<cfif isdefined("Form.SNcodigoF") and len(trim(Form.SNcodigoF)) >
									and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoF#">
								</cfif>
								<cfif isdefined("Form.fFecha") and len(trim(Form.fFecha)) >
									and a.CTfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fFecha)#">
								</cfif>
							order by CTCnumContrato
						</cfquery>
						<cfinvoke 
								component="sif.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="CTCnumContrato, CTCdescripcion, SNnombre, CTfecha, Mnombre, CTmonto"/>
							<cfinvokeargument name="etiquetas" value=" #LB_Numero# , #LB_Descripcion#, #LB_Proveedor#, #LB_Fecha#, #LB_Moneda#, #LB_Total#"/>
							<cfinvokeargument name="formatos" value="V,V,V,D,V,M"/>
							<cfinvokeargument name="align" value="left,left,left,left,center,left,right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="registroContratos.cfm"/>
						    <cfinvokeargument name="botones" value="Nuevo,Aplicar"/>
             				<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="CTContid,Ecodigo"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="radios" value="S"/>
							<cfinvokeargument name="maxrows" value="15"/>
						</cfinvoke>
                        
                        
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
	
				<tr><td>&nbsp;</td></tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript1.2" type="text/javascript">

	function funcNuevo(){document.lista.ECODIGO.value = <cfoutput>#form.Ecodigo#</cfoutput>;}
	function funcAplicar(){
		var continuar = false;
		var continuar2 = false;
		
		if (document.lista.chk) {
			if (document.lista.chk.checked)
			 {
				continuar = document.lista.chk.checked;
				continuar2 = document.lista.chk; 
			
			}
			else {
				for (var k = 0; k < document.lista.chk.length; k++) {
					if (document.lista.chk[k].checked) {	
						continuar = true;
						continuar2 = document.lista.chk[k];
						break;
					}
				}
			}
			if (!continuar) {alert('Debe seleccionar un Contrato'); }
		}
		else {
			alert('No se han seleccionado Contratos a Aplicar')		}         
		if ( continuar && continuar2 ){	
		
		    continuar = true; 	
			document.lista.action = 'contratos-sql.cfm';			
			document.lista.submit();
		}	
		else
		{
		   continuar = false;
		}
		return continuar;
	}
</script>