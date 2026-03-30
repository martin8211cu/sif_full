<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 13-10-2005.
		Motivo: Modifica la lista para que pueda difereciar entre códigos de transacción del banco iguales pero con distinto BTid.
		Esto por que se debe permitir N transacciones "mías" a solo 1 del Banco.
	Modificado por Hector Garcia Beita.
		Fecha: 22-07-2011.
		Motivo: Se agregan variables de redirección para los casos en que el 
		fuente sea llamado desde la opción de tarjetas de credito mediante includes
		con validadores segun sea el caso
		
 --->
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
	<!--- <cf_translate key="LB_SIFBancos" XmlFile="/sif/generales.xml">SIF - Bancos</cf_translate> --->
	<cf_templateheader title="#Request.Translate('LB_SIFBancos','SIF - Bancos','/sif/generales.xml')#">

<cf_templatecss>
<link href="../../css/rh.css" rel="stylesheet" type="text/css">

<!---
	Validador para los casos en que la transaccion se realiza
	desde la opcion de bancos o desde tarjetas de credito. 
	#LvarPagina# Variable de redireccion segun sea el caso
--->
<cfset LvarPaginaBanco = "Bancos.cfm">
<cfset LvarPaginaIr = "TBEquivalentes.cfm">
<cfset LvarBTtce = 0>
<cfif isdefined("LvarTCETBEEquivalentes")>
    <cfset LvarPaginaBanco = "TCEBancos.cfm">
	<cfset LvarBTtce = 1>
    <cfset LvarPaginaIr = "TCETransaccionesBancoEquiva.cfm">
</cfif>

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->

function limpiar(){
	document.filtro.fBTEcodigo.value = '';
	document.filtro.fBTEdescripcion.value = '';
	document.filtro.fBTransaccion.value = '';
	}
</script>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_EquivalenciasDeTiposDeTransaccion"
					Default="Equivalencias de Tipos de Transacción"
					returnvariable="LB_EquivalenciasDeTiposDeTransaccion"/>

                <cf_web_portlet_start titulo="#LB_EquivalenciasDeTiposDeTransaccion#">
					<cfinclude template="/home/menu/pNavegacion.cfm">
					<cfif isdefined("url.Bid") and len(trim(url.Bid)) and not isdefined("form.Bid")>
						<cfset form.Bid = url.Bid>
					</cfif>
					
					<cfif not isdefined("Form.Bid")>
                    
						<!---Redireccion Banco o TCEBanco (Tarjetas de Credito)--->
						<cflocation addtoken="no" url="#LvarPaginaBanco#">
					</cfif>
					<cfif not isdefined('modo')>
						<cfset modo = 'ALTA'>
					</cfif>
					<cfif  isdefined('modo') and modo EQ 'ALTA'>
						<cfset form.BTEcodigo = ''>
					</cfif>
						<table width="100%" border="0">
							<tr> 
								<td valign="top" width="40%">
									<cfquery name="rslista" datasource="#session.DSN#">
										select a.BTEcodigo, a.BTEdescripcion, a.Bid, a.BTid, 
											{fn concat(b.BTcodigo,{fn concat(' ', b.BTdescripcion)})} as BTdescripcion
										from BTransaccionesEq a 
											inner join TransaccionesBanco tb
											on tb.Bid = a.Bid
											and tb.BTEcodigo = a.BTEcodigo
											inner join BTransacciones b
											on  a.BTid = b.BTid										
										where 	a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
											and tb.BTEtce = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarBTtce#">
		
										order by a.BTid
									</cfquery>
									<cfset navegacion = "">
									<cfif isdefined("Form.Bid") and len(trim(form.Bid))>
										<cfset navegacion = navegacion & "&Bid=#Form.Bid#">
									</cfif>
									 <cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Codigo"
										Default="C&oacute;digo"
										XmlFile="/sif/generales.xml"
										returnvariable="LB_Codigo"/>
										
									 <cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Descripcion"
										Default="Descripci&oacute;n"
										XmlFile="/sif/generales.xml"
										returnvariable="LB_Descripcion"/>

									 <cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_EquivaleteA"
										Default="Equivalente a"
										returnvariable="LB_EquivalenteA"/>

									<cfinvoke 
										 component="sif.Componentes.pListas"	
										 method="pListaQuery"
										 returnvariable="pListaRet">
											<cfinvokeargument name="query" value="#rslista#"/>
											<cfinvokeargument name="desplegar" value="BTEcodigo, BTEdescripcion, BTdescripcion"/>
											<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_EquivalenteA#"/>
											<cfinvokeargument name="formatos" value=""/>
											<cfinvokeargument name="filtro" value=""/>
											<cfinvokeargument name="navegacion" value="#navegacion#"/>
											<cfinvokeargument name="align" value="left, left, left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="checkboxes" value="N"/>
                                            
											<!---Redireccion TBEquivalentes o TCETransaccionesBancoEquiva(Tarjetas de Credito)--->
											<cfinvokeargument name="irA" value="#LvarPaginaIr#"/>
                                            
											<cfinvokeargument name="keys" value="BTEcodigo, BTid, BTEdescripcion"/>
											<cfinvokeargument name="showEmptyListMsg" value="true"/>
										</cfinvoke>
								  </td>
								  <td valign="top" width="60%"><cfinclude template="formTBEquivalentes.cfm"></td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
						</table> 
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>