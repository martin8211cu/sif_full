<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Detalle de Beca</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaDeTipoDeBeca" Default="Lista De Tipo De Beca" XmlFile="/rh/generales.xml" returnvariable="LB_ListaDeTipoDeBeca"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaDeEmpleados" Default="Lista De Empleados" XmlFile="/rh/generales.xml" returnvariable="LB_ListaDeEmpleados"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Simbolo" Default="Simbolo" XmlFile="/rh/generales.xml" returnvariable="LB_Simbolo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaDeMonedas" Default="Lista De Monedas" XmlFile="/rh/generales.xml" returnvariable="LB_ListaDeMonedas"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="C&oacute;digo" XmlFile="/rh/generales.xml" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion"/>  
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" XmlFile="/rh/generales.xml" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Empleado" Default="Empleado" XmlFile="/rh/generales.xml" returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estado" Default="Estado" XmlFile="/rh/generales.xml" returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Beca" Default="Beca" XmlFile="/rh/generales.xml" returnvariable="LB_Beca"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="dentificaci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Identificacion"/>

<cfset readonly = "true">
<cfset modo = "CAMBIO">
<cfparam name="url.version" default="0">
<cfif isdefined('url.RHEBEid') and len(trim(url.RHEBEid)) gt 0>
    <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetEBE" returnvariable="rsEBeca">
        <cfinvokeargument name="RHEBEid" 		value="#url.RHEBEid#">
    </cfinvoke>
    <cfparam name="RHDBEversion" default="#url.version#">
<cfelse>
	<script language="javascript1.2" type="text/javascript">
		window.close();
	</script>
</cfif>
<cfoutput>
<script language="javascript1.2" type="text/javascript">

	function fnVisivilidadDiv(name){
		cdiv = document.getElementById("ContenedorDiv");
		divs = cdiv.getElementsByTagName('div');
		for(i=0;i<divs.length;i++){
			if(divs[i].id == "div_"+name){
				divs[i].style.display="";
			}
			else
				divs[i].style.display="none";
		}
	}
	
	function fnHabilitarInput(v, name, tipo) {
		obj = eval("document.form2.RHDCBtipoValor_" + name);
		if(tipo == 2){
			objM = eval("document.form2.Miso4217" + name);
			objI = document.getElementById("img_form2_Mcodigo" + name);
		}else if(tipo == 4)
			objI = document.getElementById("img_form2_RHDCBtipoValor_" + name);
		if(v){
			if(obj){
				obj.disabled=false;
				obj.focus();
			}
			if((tipo == 2) && objM){
				objM.disabled=false;
			}
			if((tipo == 2 || tipo == 4) && objI)
				objI.style.display="";
		}else{
			if(obj)
				obj.disabled=true;
			if((tipo == 2) && objM)
				objM.disabled=true;
			if((tipo == 2 || tipo == 4) && objI)
				objI.style.display="none";
		}
	}
	function funcCerrar(){
		window.close();
	}

</script>
<cf_htmlReportsHeaders irA="" FileName="repBecas#url.RHEBEid#.xls" title="Tipos de Becas" back="false" download="false">
<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
        <cfquery datasource="#Session.DSN#" name="rsEmpleado">
            select a.DEid,
                   a.Ecodigo,
                   a.Bid,
                   a.NTIcodigo, 
                   a.DEidentificacion, 
                   a.DEnombre, 
                   a.DEapellido1, 
                   a.DEapellido2, 
                   b.NTIdescripcion

            
            from DatosEmpleado a
                inner join NTipoIdentificacion b
                    on a.NTIcodigo = b.NTIcodigo

            
            where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEBeca.DEid#">
        </cfquery>
        <form name="form2" method="post" action="RegBecas-sql.cfm">
        <tr>
            <td colspan="3" bgcolor="##EEEEEE" align="right" style="border-top: 1px solid darkgray; border-bottom: 1px solid darkgray ">
                <cf_botones formName="form2" values="Cerrar" names="Cerrar" modo="#modo#" align="right">            </td>
        </tr>
        <tr>
        	<td>&nbsp;</td>
            <td colspan="2">
                <cfinclude template="/rh/expediente/consultas/frame-infoEmpleado.cfm">            </td>
        </tr>
        <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetDBE" returnvariable="rsDBeca">
            <cfinvokeargument name="RHEBEid" 		value="#url.RHEBEid#">
            <cfinvokeargument name="RHDBEversion" 	value="#RHDBEversion#">
        </cfinvoke>
        <cfquery name="rsSelectCE" datasource="#session.dsn#">
            select ecb.RHECBid, RHECBdescripcion, RHECBesMultiple
            from RHTipoBecaConceptos tbc
                inner join RHEConceptosBeca ecb
                    on ecb.RHECBid = tbc.RHECBid
            where tbc.RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEBeca.RHTBid#">
        </cfquery>
        <cfif rsSelectCE.recordcount gt 0>
            <tr class="#Session.preferences.Skin#_thcenter">
            	<td>&nbsp;</td>
               	<td colspan="2">Conceptos</td>
            </tr>
        </cfif>
        <cfset NombreConceptos = "">
        <cfloop query="rsSelectCE">
            <tr>
            	<td>&nbsp;</td>
                <td align="right" valign="top">#rsSelectCE.RHECBdescripcion#&nbsp;&nbsp;</td>
                <cfquery name="rsSelectCD" datasource="#session.dsn#">
                    select RHDCBid, RHDCBdescripcion, RHDCBtipo, RHDCBnegativos
                    from RHDConceptosBeca
                    where RHECBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectCE.RHECBid#">
                    order by RHDCBdescripcion
                </cfquery>
                <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <cfif rsSelectCE.RHECBesMultiple eq 1>
                        <cfloop query="rsSelectCD">
                            <cfquery name="rsExiste" dbtype="query">
                                select RHEBEid, RHTBDFid, RHDCBid, RHDBEvalor
                                from rsDBeca
                                where RHDCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectCD.RHDCBid#">
                                and RHTBDFid is null
                            </cfquery>
                            <cfset checked = "">
             				<cfif rsExiste.recordcount gt 0>
                                <cfset checked = "checked">
                            </cfif>
                            <cfset NombreConceptos = NombreConceptos & "RHDCBid_#rsSelectCD.RHDCBid#" & ",">
                            <tr>
                                <td width="3%">
                                    <input type="checkbox" name="RHDCBid_#rsSelectCD.RHDCBid#" id="RHDCBid_#rsSelectCD.RHDCBid#" onclick="fnHabilitarInput(this.checked,'RHDCBid_#rsSelectCD.RHDCBid#',#rsSelectCD.RHDCBtipo#);" #checked# disabled>
                                </td>
                                <td>#rsSelectCD.RHDCBdescripcion#</td>
                                <td><cfset fnDibujarTipo("RHDCBid_#rsSelectCD.RHDCBid#", -1, rsSelectCD.RHDCBtipo, -1, rsSelectCD.RHDCBnegativos, rsExiste.RHDBEvalor,-1)></td>
                            </tr>
                        </cfloop>
                     <cfelse>
                        <tr>
                            <td valign="top" width="5%" nowrap>
                                <cfset RHDCBidSel = "">
                                <cfset RHDCBtipoSel = "">
                                <cfset RHDCBnegativosSel = "">
                                <cfset RHDBEvalorSel = "">
                                <select name="RHECBid_#rsSelectCE.RHECBid#" id="RHECBid_#rsSelectCE.RHECBid#" disabled>
                                    <option value="" selected></option>
                                    <cfloop query="rsSelectCD">
                                        <cfquery name="rsExiste" dbtype="query">
                                            select RHEBEid, RHTBDFid, RHDCBid, RHDCBtipo, RHDCBnegativos, RHDBEvalor
                                            from rsDBeca
                                            where RHDCBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectCD.RHDCBid#">
                                            and RHTBDFid is null
                                        </cfquery>
                                        <cfset selected = "">
                                        <cfif rsExiste.recordcount gt 0>
                                            <cfset selected = "selected">
                                            <cfset RHDCBidSel = rsExiste.RHDCBid>
                                            <cfset RHDCBtipoSel = rsExiste.RHDCBtipo>
											<cfset RHDCBnegativosSel = rsExiste.RHDCBnegativos>
                                            <cfset RHDBEvalorSel = rsExiste.RHDBEvalor>
                                        </cfif>
                                        <option value="#rsSelectCD.RHDCBid#" #selected#>#rsSelectCD.RHDCBdescripcion#</option>
                                    </cfloop>
                                </select>
                            </td>
                            <td>&nbsp;</td>
                            <td>
                            <cfif len(trim(RHDCBidSel)) gt 0>
                           		<cfset fnDibujarTipo("RHDCBid_#RHDCBidSel#", -1, RHDCBtipoSel, -1, RHDCBnegativosSel, RHDBEvalorSel,-1)>
                            </cfif>
                            </td>
                       </tr>
                    </cfif>
                </table></td>
            </tr>
        </cfloop>
        <cfquery name="rsSelectEBF" datasource="#session.dsn#">
            select RHTBEFid,RHTBEFcodigo,RHTBEFdescripcion
            from RHTipoBecaEFormatos
            where RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEBeca.RHTBid#">
			order by RHTBEFcodigo asc
        </cfquery>
        <cfset NombreDetalles = "">
        <cfloop query="rsSelectEBF">
            <tr class="#Session.preferences.Skin#_thcenter">
            	<td>&nbsp;</td>
                <td colspan="2">#rsSelectEBF.RHTBEFdescripcion#</td>
            </tr>
            <cfquery name="rsSelectDBF" datasource="#session.dsn#">
                select RHTBDFid, RHTBEFid, RHTBDForden, RHTBDFetiqueta, RHTBDFfuente, RHTBDFnegrita, RHTBDFitalica, RHTBDFsubrayado, RHTBDFtamFuente, RHTBDFcolor,
                        RHTBDFcapturaA, BMUsucodigo, ts_rversion, RHECBid, RHTBDFnegativos, RHTBDFcapturaB
                from RHTipoBecaDFormatos
                where RHTBEFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectEBF.RHTBEFid#">
                order by RHTBDForden
            </cfquery>
            <cfloop query="rsSelectDBF">
                <cfquery name="rsExiste" dbtype="query">
                    select RHEBEid, RHTBDFid, RHDCBid, RHDBEvalor
                    from rsDBeca
                    where RHTBDFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectDBF.RHTBDFid#">
                </cfquery>
                <cfset style = "style='font:#rsSelectDBF.RHTBDFfuente#;font-size:#rsSelectDBF.RHTBDFtamFuente#px;color:###trim(rsSelectDBF.RHTBDFcolor)#">
  				<cfif rsSelectDBF.RHTBDFnegrita eq 1>
                    <cfset style = style & ";font-weight:bold">
                </cfif>
  				<cfif rsSelectDBF.RHTBDFitalica eq 1>
                    <cfset style = style & ";font-style:italic">
                </cfif>
  				<cfif rsSelectDBF.RHTBDFsubrayado eq 1>
                    <cfset style = style & ";text-decoration:underline">
                </cfif>
                <cfset style = style & "'">
                
                <tr>
                	<td>&nbsp;</td>
                    <td colspan="2">
                        <font style="#style#">#rsSelectDBF.RHTBDFetiqueta#:</font>                    </td>
                </tr>
                <tr>
                	<td>&nbsp;</td>
                    <td colspan="2">
                        <cfset NombreDetalles = NombreDetalles & "RHTBDFid_#rsSelectDBF.RHTBDFid#,">
                        <cfset fnDibujarTipo("RHTBDFid_#rsSelectDBF.RHTBDFid#", iif(len(trim(rsSelectDBF.RHECBid)) eq 0, -1, rsSelectDBF.RHECBid), rsSelectDBF.RHTBDFcapturaA, iif(len(trim(rsSelectDBF.RHTBDFcapturaB)) eq 0, -1, rsSelectDBF.RHTBDFcapturaB), rsSelectDBF.RHTBDFnegativos, rsExiste.RHDBEvalor, iif(len(trim(rsExiste.RHDCBid)) eq 0, -1, rsExiste.RHDCBid))>                   	</td>
                </tr>
            </cfloop>
        </cfloop>
        <cfif isdefined('Auto') and not ListFind('10,15,50',rsEBeca.RHEBEestado)>
        	<tr class="#Session.preferences.Skin#_thcenter"><td colspan="3">Otros Detalles</td></tr>
           	<tr>
           	  <td colspan="3"><table width="98%" border="0" cellpadding="0" cellspacing="0">
                <cfif ListFind('30,70',rsEBeca.RHEBEestado)>
                  <tr>
                    <td width="5%" nowrap><strong>Sesion:&nbsp;</strong></td>
                    <td colspan="2"><cfif rsEBeca.RHEBEestado eq '30'>
                      #rsEBeca.RHEBEsesionJef#
                          <cfelse>
                      #rsEBeca.RHEBEsesionCom#
                    </cfif></td>
                  </tr>
                  <tr>
                    <td colspan="3">&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="5%" nowrap><strong>Articulo:&nbsp;</strong></td>
                    <td colspan="2"><cfif rsEBeca.RHEBEestado eq '30'>
                      #rsEBeca.RHEBEarticuloJef#
                          <cfelse>
                      #rsEBeca.RHEBEarticuloCom#
                    </cfif></td>
                  </tr>
                  <tr>
                    <td colspan="3">&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="5%" nowrap><strong>Fecha:&nbsp;</strong></td>
                    <td colspan="2"><cfif rsEBeca.RHEBEestado eq '30'>
                      #LSdateFormat(rsEBeca.RHEBEfechaJef,'dd/mm/yyyy')#
                          <cfelse>
                      #LSdateFormat(rsEBeca.RHEBEfechaCom,'dd/mm/yyyy')#
                    </cfif></td>
                  </tr>
                  <tr>
                    <td colspan="3">&nbsp;</td>
                  </tr>
                </cfif>
                <cfif ListFind('20,40,60',rsEBeca.RHEBEestado)>
                  <tr>
                    <td width="5%" nowrap><strong>Justificacion:&nbsp;</strong></td>
                    <td colspan="2"><cfif rsEBeca.RHEBEestado eq '20'>
                      #rsEBeca.RHEBEjustificacionJef#
                          <cfelseif rsEBeca.RHEBEestado eq '40'>
                      #rsEBeca.RHEBEjustificacionVic#
                      <cfelse>
                      #rsEBeca.RHEBEjustificacionCom#
                    </cfif></td>
                  </tr>
                  <tr>
                    <td colspan="3">&nbsp;</td>
                  </tr>
                </cfif>
                <cfif ListFind('70',rsEBeca.RHEBEestado)>
                  <cf_dbfunction name="OP_concat"	returnvariable="_CAT">
                  <cfquery name="rsFiadores" datasource="#session.dsn#">
                    select coalesce(DEnombre,RHFnombre) #_CAT# ' ' #_CAT# coalesce(DEapellido1,RHFapellido1) #_CAT# ' ' #_CAT#  coalesce(DEapellido2,RHFapellido2) as nombre,
                    coalesce(DEidentificacion, RHFcedula) as indentificacion
                    from RHFiadoresBecasEmpleado fb
                    left outer join DatosEmpleado d
                    on d.DEid = fb.DEid
                    left outer join RHFiadores f
                    on f.RHFid = fb.RHFid
                    where RHEBEid =
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEBEid#">
                  </cfquery>
                  <tr>
                    <td colspan="3"><strong>Fiadores:</strong></td>
                  </tr>
                  <tr>
                    <td nowrap colspan="3"><table width="100%" border="0" cellspacing="1" cellpadding="1">
                        <cfloop query="rsFiadores">
                          <tr>
                            <td>#rsFiadores.indentificacion# - #rsFiadores.nombre#</td>
                          </tr>
                        </cfloop>
                    </table></td>
                  </tr>
                  <tr>
                    <td colspan="3">&nbsp;</td>
                  </tr>
                  <tr>
                    <td><strong>Acuerdo:</strong></td>
                  </tr>
                  <tr>
                    <td style="border:1px" colspan="5">#rsEBeca.RHEBEacuerdo#</td>
                  </tr>
                </cfif>
              </table></td>
           	</tr>
        </cfif>
        <tr>
            <td colspan="3" bgcolor="##EEEEEE" align="right" style="border-top: 1px solid darkgray; border-bottom: 1px solid darkgray ">
            	<cf_botones formName="form2" values="Cerrar" names="Cerrar" modo="#modo#" align="right">            </td>
        </tr>
        </form>
	</table>
</cfoutput>

<cffunction name="fnDibujarTipo" access="private" output="yes">
    <cfargument name="Name" 			type="string" 	required="true">
    <cfargument name="RHECBid" 			type="numeric" 	required="true">
    <cfargument name="RHTBDFcapturaA" 	type="numeric" 	required="true">
    <cfargument name="RHTBDFcapturaB" 	type="numeric" 	required="true">
    <cfargument name="RHTBDFnegativos"  type="boolean"  required="true">
    <cfargument name="RHDBEvalor"  		type="string"  	required="true">
    <cfargument name="RHDCBid" 			type="numeric" 	required="true">

    <cfset valorA = ""> 
	<cfif Arguments.RHTBDFcapturaA eq 5>
    	<cfset valorA = Arguments.RHDCBid>
    <cfelseif Arguments.RHTBDFcapturaA neq -1>
    	<cfif Arguments.RHTBDFcapturaB neq -1 and Arguments.RHTBDFcapturaB neq 5 and ListLen(Arguments.RHDBEvalor, '##') eq 2>
    		<cfset valorA = ListgetAt(Arguments.RHDBEvalor,1,'##')>
        <cfelse>
        	<cfset valorA = Arguments.RHDBEvalor>
        </cfif>
    </cfif>
    <cfset valorB = ""> 
	<cfif Arguments.RHTBDFcapturaB eq 5>
        <cfset valorB = Arguments.RHDCBid>
	<cfelseif Arguments.RHTBDFcapturaB neq -1>
		<cfif Arguments.RHTBDFcapturaA neq -1 and Arguments.RHTBDFcapturaA neq 5 and ListLen(Arguments.RHDBEvalor, '##') eq 2>
        	<cfset valorB = ListgetAt(Arguments.RHDBEvalor,2,'##')>
        <cfelse>
       		<cfset valorB = Arguments.RHDBEvalor>
        </cfif> 
    </cfif>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td <cfif Arguments.RHTBDFcapturaA eq 1>width="50%"<cfelse>width="5%"</cfif>>
				<cfset fnPintarTipo(Arguments.Name, Arguments.RHECBid, Arguments.RHTBDFcapturaA, Arguments.RHTBDFnegativos, valorA)>
            </td>
        <cfif Arguments.RHTBDFcapturaB neq -1>
        	<td>&nbsp;</td>
            <td>
				<cfset fnPintarTipo("B_" & Arguments.Name, Arguments.RHECBid, Arguments.RHTBDFcapturaB, Arguments.RHTBDFnegativos, valorB)>
            </td>
        </cfif>
        </tr>
    </table>
</cffunction>

<cffunction name="fnPintarTipo" access="private" output="yes">
    <cfargument name="Name" 			type="string" 	required="true">
    <cfargument name="RHECBid" 			type="numeric" 	required="true">
    <cfargument name="RHTBDFcaptura" 	type="numeric" 	required="true">
    <cfargument name="RHTBDFnegativos"  type="boolean"  required="true">
    <cfargument name="RHDBEvalor"  		type="string"  	required="true">
    <cfif Arguments.RHDBEvalor eq 'null'>
    	<cfset Arguments.RHDBEvalor = "">
    </cfif>
	<cfif Arguments.RHTBDFcaptura eq 1>
        <textarea name="RHDCBtipoValor_#Arguments.Name#" id="RHDCBtipoValor_#Arguments.Name#" rows="2" style="width: 100%;" disabled>#Arguments.RHDBEvalor#</textarea>
    <cfelseif ListFind('2,3',Arguments.RHTBDFcaptura)>
        <cfset negativos = "false">
        <cfif Arguments.RHTBDFnegativos eq 1>
            <cfset negativos = "true">
        </cfif>
        
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <cfif Arguments.RHTBDFcaptura eq 2>
                    	<cfif ListLen(Arguments.RHDBEvalor, '|') eq 2>
                    		<cfset monto = ListGetAt(Arguments.RHDBEvalor,1,'|')>
                        <cfelse>
                        	<cfset monto = 0>
                        </cfif>
                        <cf_monto name="RHDCBtipoValor_#Arguments.Name#" form = "form2" value="#replace(monto,',','','ALL')#" size="12" decimales="2" negativos="#negativos#" readonly="true">
                    <cfelse>
                        <cf_inputNumber name="RHDCBtipoValor_#Arguments.Name#" form = "form2" value="#Arguments.RHDBEvalor#" enteros="10" codigoNumerico="yes" readonly="true">
                    </cfif>
                </td>
            <cfif Arguments.RHTBDFcaptura eq 2>
            	<cfif ListLen(Arguments.RHDBEvalor, '|') eq 2>
					<cfset Mcodigo = ListGetAt(Arguments.RHDBEvalor,2,'|')>
                <cfelse>
                	<cfquery name="rsMonedaEmpresa" datasource="#Session.DSN#">
                        select Mcodigo from Empresas 
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    </cfquery>
                    <cfset Mcodigo = rsMonedaEmpresa.Mcodigo>
                </cfif>
                <cfset Mcodigo = iif(Mcodigo eq 'null',-1,Mcodigo)>
                <cfquery name="rsMoneda" datasource="#session.dsn#">
                    select Mcodigo, Miso4217
                    from Monedas
                    where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
                </cfquery>
                <td>&nbsp;</td>
                <td>
                	<cfset valuesArray = ArrayNew(1)>
					<cfset ArrayAppend(valuesArray, rsMoneda.Mcodigo)>
                  	<cfset ArrayAppend(valuesArray, rsMoneda.Miso4217)>
                    <cf_conlis
                        campos="Mcodigo#Arguments.Name#, Miso4217#Arguments.Name#"
                        desplegables="N,S"
                        modificables="N,S"
                        size="0,5"
                        title="#LB_ListaDeMonedas#"
                        tabla="Monedas"
                        columnas="Mcodigo as Mcodigo#Arguments.Name#, Mnombre as Mnombre#Arguments.Name#, Miso4217 as Miso4217#Arguments.Name#, Msimbolo as Msimbolo#Arguments.Name#"
                        filtro="Ecodigo = #session.Ecodigo#"
                        desplegar="Miso4217#Arguments.Name#, Mnombre#Arguments.Name#, Msimbolo#Arguments.Name#"
                        filtrar_por="Miso4217 | Mnombre | Msimbolo"
                        filtrar_por_delimiters="|"
                        etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_Simbolo#"
                        formatos="S,S,S"
                        align="left,left,left"
                        asignar="Mcodigo#Arguments.Name#, Miso4217#Arguments.Name#"
                        asignarformatos="S,S"
                        showEmptyListMsg="true"
                        form = "form2"
                        valuesArray="#valuesArray#"
                        tabindex = "3"
                        readonly="true"
                    >
                </td>
            </cfif>
            </tr>
        </table>
    <cfelseif Arguments.RHTBDFcaptura eq 4>
    	<cfif len(trim(Arguments.RHDBEvalor)) gt 0 and IsDate(Arguments.RHDBEvalor)>
			<cfset fecha = Arguments.RHDBEvalor>
        <cfelseif Arguments.RHDBEvalor neq 'null'>
			<cfset fecha = LSDateFormat(Now(),'DD/MM/YYYY')>
        </cfif>
        <cf_sifcalendario name="RHDCBtipoValor_#Arguments.Name#" value="#fecha#" form = "form2"  readonly="true">
    <cfelseif Arguments.RHTBDFcaptura eq 5>
        <cfquery name="rsConcepto" datasource="#session.dsn#">
            select RHDCBid, RHDCBcodigo, RHDCBdescripcion
            from RHEConceptosBeca e
                inner join RHDConceptosBeca d
                    on d.RHECBid = e.RHECBid
            where e.RHECBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHECBid#">
            order by RHDCBdescripcion, RHDCBcodigo
        </cfquery>
        <select name="RHDCBtipoValor_#Arguments.Name#" id="RHDCBtipoValor_#Arguments.Name#" disabled>
        	<option value="" selected></option>
            <cfloop query="rsConcepto">
                <option value="#rsConcepto.RHDCBid#" <cfif Arguments.RHDBEvalor eq rsConcepto.RHDCBid>selected</cfif>>#trim(rsConcepto.RHDCBcodigo)#-#rsConcepto.RHDCBdescripcion#</option>
            </cfloop>
        </select>
    </cfif>
</cffunction>

</cfoutput>
</body>
</html>