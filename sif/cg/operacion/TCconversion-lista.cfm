<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Meses"
	Default="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre"
	XmlFile="/commons/generales.xml"
	returnvariable="LB_Meses"/>
		 		  			   
<cfset VarMeses = ListToArray( #LB_Meses#, "," ) >		

<cfset filtro="">
<cfif isdefined('form.FiltroPeriodo') and len(trim(form.FiltroPeriodo)) GT 0>
	<cfset filtro= filtro & "and tc.Speriodo = "&#form.FiltroPeriodo#>
</cfif>
<cfif isdefined('form.FiltroMes') and len(trim(form.FiltroMes)) GT 0>
	<cfset filtro= filtro & "and tc.Smes = "&#ListFind(Ucase(LB_Meses),Ucase(form.FiltroMes))#>
</cfif>
<cfif isdefined('form.FiltroFecha') and len(trim(form.FiltroFecha)) GT 0>
	<cf_dbfunction name="date_format" args="tc.BMfecha,DD/MM/YYYY" returnvariable="VFFecha1">
	<cfset filtro=filtro &  "and " &  #VFFecha1#  & " = '" & #form.FiltroFecha#&"'">
</cfif>

<cfquery name="rsParamTCpres" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 1150
</cfquery>
	
<cfif (rsParamTCpres.recordcount eq 0 or rsParamTCpres.Pvalor eq 'N') and isdefined('LvarTCPres')>
	<cf_errorCode	code = "0" msg = "No se ha defindo el parametro Tipos de cambio de conversion en control de presupuesto de Parametros Adicionales">
</cfif>
<!---Poner si es contable o de presupuesto--->
<cfquery name="rsTCconversion" datasource="#Session.dsn#">
	select  distinct tc.Speriodo, 
					 case tc.Smes
					 	when 1 then '#VarMeses[1]#'
					 	when 2 then '#VarMeses[2]#'
					 	when 3 then '#VarMeses[3]#'												
					 	when 4 then '#VarMeses[4]#'
					 	when 5 then '#VarMeses[5]#'
					 	when 6 then '#VarMeses[6]#'																		
					 	when 7 then '#VarMeses[7]#'						
					 	when 8 then '#VarMeses[8]#'						
					 	when 9 then '#VarMeses[9]#'						
					 	when 10 then '#VarMeses[10]#'						
					 	when 11 then '#VarMeses[11]#'						
					 	when 12 then '#VarMeses[12]#'	
					end as SMes,				 																										
					 <cf_dbfunction name="to_date"	args="BMfecha"> as fecha
	from HtiposcambioConversion  tc
	where tc.Ecodigo = #Session.Ecodigo#
		  #PreserveSingleQuotes(filtro)#
		  <cfif isdefined('LvarTCPres')>
		  	and TCtipo = 1
		  <cfelseif isdefined('LvarTCConta')>	
		  	and TCtipo = 0		  	
		  </cfif>
	order by tc.Speriodo desc, tc.Smes desc
</cfquery>		
<cfquery name="rsParamConversion" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 660
</cfquery>
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
            select Mcodigo 
            from Empresas 
            where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfif rsParamConversion.recordcount eq 0 or (len(trim(rsParamConversion.Pvalor)) eq 0)>
	<cf_errorCode	code = "0" msg = "No se ha defindo el parametro Conversión de Moneda de Estados Financieros para esta empresa">
</cfif>
<cfquery name="rsMonedaConversion" datasource="#Session.DSN#">
	select Mcodigo, {fn concat ( {fn concat ( {fn concat ( Mnombre, ' (' )}, Miso4217)}, ') ')} as Mnombre
	from Monedas
	where Ecodigo = #Session.Ecodigo#
	and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParamConversion.Pvalor#">
</cfquery>
	
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select Mcodigo, Mnombre #_Cat# ' (' #_Cat# Miso4217 #_Cat# ') ' as Mnombre
	 from Monedas
	where Ecodigo = #Session.Ecodigo#
	<cfif isdefined('LvarTCPres')>
		and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedaLocal.Mcodigo#">
		and Mcodigo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParamConversion.Pvalor#">
	</cfif>
	order by Miso4217
</cfquery>
	
<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>
<cfif isdefined('LvarTCPres')>
	<cfset action  = "TipoCambioConversionPresupuesto.cfm">
<cfelse>
	<cfset action  = "TCconversion.cfm">
</cfif>	
  
<form name="form1" method="post" action="<cfoutput>#Action#</cfoutput>" style="margin:0;">

	<cfif isdefined('LvarTCPres')>
		<input type="hidden" name="LvarTCPres" value="<cfoutput>#LvarTCPres#</cfoutput>">
	<cfelseif isdefined('LvarTCConta')>	
		<input type="hidden" name="LvarTCConta" value="<cfoutput>#LvarTCConta#</cfoutput>">
	</cfif>
		
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
		<tr>
			<td>Per&iacute;odo Presupuestal</td>
			<td>Mes Presupuestal</td>
			<td>Fecha de Modificaci&oacute;n</td>
			<td colspan="2">
				<input type="submit" name="bFiltrar" value="Filtrar" class="btnFiltrar"/>
			</td>
		</tr>
		<tr>
			<td>
				<input type="text" name="FiltroPeriodo" value="<cfif isdefined('FiltroPeriodo')><cfoutput>#FiltroPeriodo#</cfoutput></cfif>"/>
			</td>
			<td>
				<input type="text" name="FiltroMes" value="<cfif isdefined('FiltroMes')><cfoutput>#FiltroMes#</cfoutput></cfif>"/>
			</td>
			<td>
				<cfif isdefined('form.FiltroFecha') and trim(form.FiltroFecha) GT 0>
					<cf_sifcalendario form="form1" name="FiltroFecha" value="#form.FiltroFecha#">
				<cfelse>
					<cf_sifcalendario form="form1" name="FiltroFecha" value="">
				</cfif>  
			</td>
			
		</tr>
	</table>
</form>	
<table width="100%">	
	<tr>
		<td style="max-width:40%" width="40%">
            <cfinvoke 
                 component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                    <cfinvokeargument name="query" 				value="#rsTCconversion#"/>
                    <cfinvokeargument name="desplegar" 			value="Speriodo,SMes,fecha"/>
                    <cfinvokeargument name="etiquetas" 			value="Per&iacute;odo <br/>Presupuestal, Mes<br/> Presupuestal, Fecha de <br> Modificaci&oacute;n"/>
                    <cfinvokeargument name="formatos" 			value="V,V,D"/>
                    <cfinvokeargument name="align" 				value="left, left, left"/>
                    <cfinvokeargument name="ajustar" 			value="S"/>
                    <cfinvokeargument name="irA" 				value="#action#"/>				
                    <cfinvokeargument name="keys" 				value="Speriodo, SMes"/>
                    <cfinvokeargument name="maxrows" 			value="20"/>
                    <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                    <cfinvokeargument name="inactivecol"	 	value="IDcontableinactivar"/>
            </cfinvoke>
        </td>
    	<td valign="top" align="center">
        <cfif isdefined('form.AgregarTC')>
	
				<cfif not isdefined('form.CPPid')>
                    <cfquery name="rdCPPid" datasource="#session.DSN#">
                        select max(CPPid) as CPPid  from CPresupuestoPeriodo
                            where Ecodigo = #session.Ecodigo#
                    </cfquery>
                    
                    <cfset form.CPPid =  rdCPPid.CPPid>
                </cfif>
                
                <form name="form2" method="post" action="../../cg/operacion/TCconversion-sql.cfm" style="margin: 0;">
                    <input type="hidden" name="AgregarTC" value="<cfoutput>#form.AgregarTC#</cfoutput>">
                    <input type="hidden" name="LB_Meses" value="<cfoutput>#LB_Meses#</cfoutput>">
                    <cfif isdefined('LvarTCPres')>
                        <input type="hidden" name="LvarTCPres" value="<cfoutput>#LvarTCPres#</cfoutput>">
                    <cfelseif isdefined('LvarTCConta')>	
                        <input type="hidden" name="LvarTCConta" value="<cfoutput>#LvarTCConta#</cfoutput>">
                    </cfif>
                    
                    <table width="400"  border="0" cellspacing="0" cellpadding="2" align="center">
                        <tr>
                            &nbsp;
                        </tr>
                        <tr>	
                            <td nowrap>
                                Per&iacute;odo Presupuestario:
                            </td>
                            <td colspan="3">
                                <cf_cboCPPid value="#form.CPPid#" onChange="document.forms['form2'].action='TipoCambioConversionPresupuesto.cfm'; document.forms['form2'].submit();">
								<cfif len(trim(form.CPPId)) eq 0>
									<cf_errorCode	code = "0" msg = "No se han definido per&iacute;odos presupuestarios para esta empresa ">
								</cfif>	
                            </td>
                        </tr>
                        <tr>
                            <cfquery name="rsMeses" datasource="#session.dsn#">
                                select a.CPCano as ano, a.CPCmes,
                                        case a.CPCmes
                                            when 1 then '#VarMeses[1]#'
                                            when 2 then '#VarMeses[2]#'
                                            when 3 then '#VarMeses[3]#'												
                                            when 4 then '#VarMeses[4]#'
                                            when 5 then '#VarMeses[5]#'
                                            when 6 then '#VarMeses[6]#'																		
                                            when 7 then '#VarMeses[7]#'						
                                            when 8 then '#VarMeses[8]#'						
                                            when 9 then '#VarMeses[9]#'						
                                            when 10 then '#VarMeses[10]#'						
                                            when 11 then '#VarMeses[11]#'						
                                            when 12 then '#VarMeses[12]#'
                                        end as mes
                                  from CPmeses a
                                 where a.Ecodigo = #session.ecodigo#
                                   and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
                                   and (
                                        select count(1)
                                          from HtiposcambioConversion  tc
                                         where tc.Ecodigo = a.Ecodigo
                                          <cfif isdefined('LvarTCPres')>
                                            and TCtipo = 1
                                          <cfelseif isdefined('LvarTCConta')>	
                                            and TCtipo = 0		  	
                                          </cfif>
                                          and tc.Speriodo 	= a.CPCano
                                          and tc.Smes		= a.CPCmes							  
                                        ) = 0
                                 order by 1,2
                            </cfquery>
                        <cfif rsMeses.recordcount GT 0>
                            <td nowrap>
                                Mes:
                            </td>
                            <td colspan="3">
                                <select name="Mes">
                                    <cfoutput query="rsMeses"> 
                                           <option value="#rsMeses.ano#|#rsMeses.CPCmes#">#rsMeses.ano# - #rsMeses.mes#</option>
                                   </cfoutput>	
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Agregar todos los meses:
                            </td>
                             <td>
                                <input name="meses" type="checkbox" value="0" onchange="javascript: fnmeses(this);" />
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="4">
                                   <input name="InsertarTC"type="submit" value="Agregar" onclick="document.form2.submit();">	
                            </td>
                        </tr>
                    <cfelse>
                        <tr>
                            <td align="center" colspan="4">
                                   Todos los meses del Periodo han sido agregados
                            </td>
                        </tr>
                    </cfif>
                    </table> 
                </form>
            </cfif>
			<cfif isdefined('LvarTCPres') and not isdefined('form.AgregarTC')>
                <form name="form3" method="post" action="TipoCambioConversionPresupuesto.cfm" style="margin:0;">
                        <table  cellpadding="0" cellspacing="0" border="0" style="width:100%">
                            <tr>
                                <td  align="center">
                                   <input name="AgregarTC" style="" type="submit" value="Agregar" >	
                                </td>
                            </tr>
                        </table>					
                </form>
            </cfif>	
        </td>
</table>
<script type="text/javascript" language="javascript">
function fnmeses(meses){
	if(meses.checked){
		document.form2.Mes.disabled="disabled";
	}
	else{
		document.form2.Mes.disabled="";
	}
}
</script>

<cfparam name="url.Speriodo" default="">
<cfparam name="form.Speriodo" default="#url.Speriodo#">
<cfparam name="url.Smes" default="">
<cfparam name="form.Smes" default="#url.Smes#">
<cfif isdefined('url.LvarInsertarTC')>
	<cfset form.Smes = VarMeses[form.Smes]>
</cfif>
<cfif isdefined('form.Speriodo') and len(trim(form.Speriodo)) GT 0 and isdefined('form.SMes') and len(trim(form.SMes)) GT 0 >
	<cfinclude template="TCconversion-form.cfm">	
</cfif>
