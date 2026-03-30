<cfinvoke key="LB_Mapeo" default="Mapeo" returnvariable="LB_Mapeo" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="LB_Periodo" default="Per&iacute;odo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="LB_Mes" default="Mes" returnvariable="LB_Mes" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="LB_Nivel" default="Nivel" returnvariable="LB_Nivel" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="LB_Seleccionar" default="Seleccionar" returnvariable="LB_Seleccionar" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="CMB_Enero" default="Enero" returnvariable="CMB_Enero" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="CMB_Febrero" default="Febrero" returnvariable="CMB_Febrero" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="CMB_Marzo" default="Marzo" returnvariable="CMB_Marzo" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="CMB_Abril" default="Abril" returnvariable="CMB_Abril" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="CMB_Mayo" default="Mayo" returnvariable="CMB_Mayo" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="CMB_Junio" default="Junio" returnvariable="CMB_Junio" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="CMB_Julio" default="Julio" returnvariable="CMB_Julio" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="CMB_Agosto" default="Agosto" returnvariable="CMB_Agosto" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="CMB_Septiembre" default="Septiembre"	returnvariable="CMB_Septiembre"	component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="CMB_Octubre" default="Octubre" returnvariable="CMB_Octubre" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="CMB_Noviembre" default="Noviembre" returnvariable="CMB_Noviembre" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="CMB_Diciembre" default="Diciembre" returnvariable="CMB_Diciembre" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="LB_IncluirSaldosCeros" default="Informaci&oacute;n con Saldo Cero" returnvariable="LB_IncluirSaldosCeros" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="LB_MapeoCuentasSAT" default="Mapeo SAT" returnvariable="LB_MapeoCuentasSAT" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="LB_Version" default="Version" returnvariable="LB_Version" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="LB_UltimoNivel" default="Ultimo Nivel" returnvariable="LB_UltimoNivel" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="LB_Local" default="Local" returnvariable="LB_Local" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>
<cfinvoke key="LB_Informe" default="Informe" returnvariable="LB_Informe" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-form_CE.xml"/>


<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select distinct Speriodo
	from CGPeriodosProcesados
	where Ecodigo = #session.Ecodigo#
	order by Speriodo desc
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsNivelDef">
    select Pvalor as valor
    from Parametros
    where Ecodigo = #Session.Ecodigo#
    	and Pcodigo = 10
</cfquery>

<cfquery datasource="#session.DSN#" name="rsNivelCatContable">
	select Pvalor
	from Parametros
	where Pcodigo = 200080
    	and Ecodigo = #Session.Ecodigo#
</cfquery>

<!---SML 16042015. Inicio Moneda Local y Moneda Local--->

<!---Moneda Local--->

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
	from Empresas a, Monedas b
	where a.Ecodigo = #Session.Ecodigo#
		and a.Mcodigo = b.Mcodigo
</cfquery>

<cfif isdefined('rsMonedaLocal') and rsMonedaLocal.RecordCount GT 0>
	<cfset varMonedaLocal = #rsMonedaLocal.Mcodigo#>
	<cfset LvarMonedaLocal = #rsMonedaLocal.Mnombre#>
<cfelse>
	<cfset varMonedaLocal = -2>
	<cfset LvarMonedaLocal = "">
</cfif>

<!---Moneda Informe--->
<cfquery datasource="#session.DSN#" name="rsMonedaInforme">
	select Pvalor
	from Parametros
	where Pcodigo = 3900
    	and Ecodigo = #Session.Ecodigo#
</cfquery>

<cfif isdefined('rsMonedaInforme') and rsMonedaInforme.RecordCount GT 0>
	<cfquery datasource="#Session.DSN#" name="rsget_monedaI">
		select Mcodigo,Mnombre from Monedas
		where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedaInforme.Pvalor#">
	</cfquery>

    <cfif isdefined('rsget_monedaI') and rsget_monedaI.RecordCount GT 0>
    	<cfset varMonedaInforme = #rsget_monedaI.Mcodigo#>
    	<cfset LvarMonedaInforme = #rsget_monedaI.Mnombre#>
    <cfelse>
    	<cfset varMonedaInforme = -4>
    	<cfset LvarMonedaInforme = "">
    </cfif>
<cfelse>
	<cfset varMonedaInforme = -4>
    <cfset LvarMonedaInforme = "">
</cfif>

<!---SML 16042015. Final Moneda Local y Moneda Local--->

<cfset nivelDef="#ArrayLen(ListtoArray(rsNivelDef.valor, '-'))#">
<cfset LvarNiveles = nivelDef>

<cfoutput>
    <form name="form1" action="SQLBalComprobacionCE.cfm" style="margin:0;" method="post" onsubmit="return validar();">
    	<input type="hidden" name="hdNivelDef" id="hdNivelDef" value="#LvarNiveles#"/>
        <input type="hidden" name="hdMonedaLocal" id="hdMonedaLocal" value="#varMonedaLocal#"/>
        <input type="hidden" name="hdMonedaInforme" id="hdMonedaInforme" value="#varMonedaInforme#"/>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" >
		 	<tr>
            	<td align="center" width="100%">
                	<table width="90%">
                    	<tr>
                        	<td colspan="5">
                            </td>
                        </tr>
                        <cfif isdefined('url.Errores') and url.Errores EQ 'true'>
                        <tr>
                        	<td colspan="4" style="font-size:24px;">
                            	<strong>Errores durante la generación de Balanza de Comprobación SAT</strong>
                            </td>
                            <td>
                            	<input type="submit" id="btnRegresar" name="btnRegresar" value="Regresar" class="btnAnterior"/>
                            </td>
                        </tr>
                         <cfquery name="selectError" datasource="#session.dsn#">
                			SELECT Descripcion
                			FROM ErrorProceso
                			WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    			AND Spcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SPcodigo#">
								and Usucodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">
            			</cfquery>

                        <tr>
                        	<td colspan="5">
                            	<cfinvoke
             					component="sif.Componentes.pListas"
             					method="pListaQuery"
             					returnvariable="pListaRet">
                					<cfinvokeargument name="query" 				value="#selectError#"/>
                					<cfinvokeargument name="desplegar" 			value="Descripcion"/>
                                    <cfinvokeargument name="etiquetas" 			value="Descripci&oacute;n"/>
                                    <cfinvokeargument name="formatos" 			value="V"/>
                                    <cfinvokeargument name="align" 				value="left"/>
                                    <cfinvokeargument name="ajustar" 			value="S"/>
                                    <cfinvokeargument name="incluyeform"		value="false"/>
                                    <cfinvokeargument name="formname" 			value="form1"/>
                                    <cfinvokeargument name="maxrows" 			value="40"/>
									<cfinvokeargument name="showlink" 			value="no"/>
                                    <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
            					</cfinvoke>
                            </td>
                        </tr>
                        <cfelse>
                    	<tr>
                        	<td colspan="2" align="right">
                        	  <strong>#LB_Mapeo# : </strong>
                      	  	</td>
                            <td colspan="2">
                            	<div id="contenedor_Mapeo">
                                    <cf_conlis
                                        Campos="Id_Agrupador, CAgrupador, Descripcion"
                                        Desplegables="N,S,S"
                                        Modificables="N,S,N"
                                        Size="0,10,50"
                                        tabindex="1"
                                        Title="#LB_MapeoCuentasSAT#"
                                        Tabla="CEAgrupadorCuentasSAT "
                                        Columnas="Id_Agrupador, CAgrupador, Descripcion"
                                        Filtro= "Status = 'Activo'"
                                        Desplegar="CAgrupador, Descripcion"
                                        Etiquetas="#LB_Codigo#, #LB_Nombre#"
                                        filtrar_por="CAgrupador, Descripcion"
                                        Formatos="S,S,S"
                                        Align="left,left"
                                        form="form1"
                                        Asignar="Id_Agrupador, CAgrupador, Descripcion"
                                        Asignarformatos="S,S,S"
                                        />
                                </div>
                            </td>
                            <td width="20%">
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="2" align="right">
                        	  <strong>#LB_Periodo# : </strong>
                      	  	</td>
                            <td width="20%">
                            	<select name="periodo" tabindex="2" id="periodo">
					  				<option value="" selected>--- #LB_Seleccionar# ---</option>
                                <cfloop query = "rsPeriodos">
									<option value="#rsPeriodos.Speriodo#">#rsPeriodos.Speriodo#</option>
								</cfloop>
					 			</select>
                            </td>
                            <td width="20%">
                            </td>
                            <td width="20%">
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="2" align="right">
                        	  <strong>#LB_Mes# : </strong>
                      	  	</td>
                            <td width="20%">
                            	<select name="mes" size="1" tabindex="3" id="mes">
                                	<option value="" selected>--- #LB_Seleccionar# ---</option>
					  				<option value="1">#CMB_Enero#</option>
					  				<option value="2"> #CMB_Febrero#</option>
					  				<option value="3"> #CMB_Marzo#</option>
					  				<option value="4"> #CMB_Abril#</option>
					  				<option value="5"> #CMB_Mayo#</option>
					  				<option value="6"> #CMB_Junio#</option>
					  				<option value="7"> #CMB_Julio#</option>
					  				<option value="8"> #CMB_Agosto#</option>
					  				<option value="9"> #CMB_Septiembre#</option>
					  				<option value="10"> #CMB_Octubre#</option>
					  				<option value="11"> #CMB_Noviembre#</option>
					  				<option value="12"> #CMB_Diciembre#</option>
								</select>
                            </td>
                            <td width="20%">
                            </td>
                            <td width="20%">
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="2" align="right">
                        	  <strong>#LB_Nivel# : </strong>
                      	  	</td>
                            <td width="20%">
                            	<select name="nivel" id="nivel" size="1" tabindex="4">
								<!---<cfloop index="i" from="2" to="#LvarNiveles#">--->
                                	<cfif isdefined('rsNivelCatContable') and rsNivelCatContable.Pvalor NEQ -1>
				  					<option value="#rsNivelCatContable.Pvalor#" selected>#rsNivelCatContable.Pvalor#</option>
                                    <cfelse>
                                    <option value="#rsNivelCatContable.Pvalor#" selected>#LB_UltimoNivel#</option>
                                    </cfif>
								<!---</cfloop>--->
                                <!---	<option value="-1" <cfif isdefined('rsNivelCatContable') and rsNivelCatContable.Pvalor EQ -1>selected</cfif>>#LB_UltimoNivel#</option>--->
			  					</select>
                            </td>
                            <td width="20%">
                            </td>
                            <td width="20%">
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="2" align="right">
                        	  <strong>#LB_Moneda# : </strong>
                      	  	</td>
                            <td width="20%">
                            	<table width="100%">
                                	<tr>
                                    	<td width="10%">
                                        	<input type="radio" name="rdMoneda"  value="-2" checked="checked"/>
                                        </td>
                                        <td width="90%" align="left">
                                        	 <strong>#LB_Local# #LvarMonedaLocal#</strong>
                                        </td>
                                    </tr>
                                    <tr>
                                    	<td width="10%">
                                        	<input type="radio" name="rdMoneda"  value="-4" <cfif isdefined('rsMonedaInforme') and rsMonedaInforme.RecordCount GT 0><cfelse> disabled </cfif>/>
                                        </td>
                                        <td width="90%">
                                        	 <strong>#LB_Informe# #LvarMonedaInforme#</strong>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td width="20%">
                            </td>
                            <td width="20%">
                            </td>
                         </tr>
                         <tr>
                       	   <td colspan="2" align="right">
                      	  	</td>
                          <td colspan="2">
                            	<input type="checkbox" id="chkSaldoCeros" name="chkSaldoCeros" tabindex="5"/>
                            	<strong>#LB_IncluirSaldosCeros#</strong>
                            </td>
                            <td width="20%">
                            </td>
                        </tr>
                        <tr>
                        	<td width="20%" align="right">

                      	  	</td>
                            <td colspan="3" align="center">
                            	<cf_botones name= "Generar" values = "Generar">
                            </td>
                            <td width="20%">
                            </td>
                        </tr>
                        </cfif>
                    </table>
                </td>
            </tr>
		</table>
    </form>

<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js" type="text/javascript"></script>
<script language="javascript" src="/cfmx/sif/js/qForms/qforms.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">

	objForm = new qForm("form1");

	function validar(){
		var msj = "Se presentaron los siguientes errores: \n";
		var  res = true;
		if(document.form1.CAgrupador.value==""){
			msj = msj + " -El campo Mapeo es requerido \n";
			res = false;
		}
		if(document.form1.periodo.value==""){
			msj = msj + " -El campo Periodo es requerido \n";
			res = false;
		}
		if(document.form1.mes.value==""){
			msj = msj + " -El campo Mes es requerido \n";
			res = false;
		}

		if(res == false)
		{
			alert(msj);
		}

		return res;
	}

</script>
</cfoutput>
