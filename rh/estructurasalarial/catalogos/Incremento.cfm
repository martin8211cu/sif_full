<!--- VARIABLES DE TRADUCCION --->
<cfset t=createObject("component", "sif.Componentes.Translate")>
<cfset LB_ListaCat = t.Translate('LB_ListaCat','Lista de Categorías')>
<cfset MSG_ListaCat = t.Translate('MSG_ListaCat','No se Encontraron Categorías')>
<cfset MSG_Monto = t.Translate('MSG_Monto','Monto','/rh/generales.xml')>
<cfset LB_APLICADO = t.Translate('LB_APLICADO','Aplicado','/rh/generales.xml')>
<cfset LB_Pendiente = t.Translate('LB_Pendiente','Pendiente','/rh/generales.xml')>
<cfset LB_VigenciaSustituidaSoloConsulta = t.Translate('LB_VigenciaSustituidaSoloConsulta','Vigencia sustituida sólo consulta')>
<cfset LB_DeseaModificarLaTablaAplicada = t.Translate('LB_DeseaModificarLaTablaAplicada','Desea modificar tabla aplicada')>
<cfset LB_ElAumentoPorcentualAplicaSobre = t.Translate('LB_ElAumentoPorcentualAplicaSobre','El aumento porcentual aplica sobre')>
<cfset LB_BaseYAumentoFijo = t.Translate('LB_BaseYAumentoFijo','Base y aumento fijo')>
<cfset LB_SoloSobreLaBaseMasAumentoFijo = t.Translate('LB_SoloSobreLaBaseMasAumentoFijo','Sólo sobre la base más el aumento fijo')>
<cfset LB_DeseaCrearUnaCopiaDeLaTablaAplicada = t.Translate('LB_DeseaCrearUnaCopiaDeLaTablaAplicada','Desea crear una copia de la tabla aplicada')>
<cfset LB_DeseaEliminarLaCopia = t.Translate('LB_DeseaEliminarLaCopia','Desea eliminar la copia')>
<cfset LB_SeEstaMostrandoUnaCopiaDeLaTabla = t.Translate('LB_SeEstaMostrandoUnaCopiaDeLaTabla','Se está mostrando una copia de la tabla')>
<cfset LB_DeseaEliminarLaTabla = t.Translate('LB_DeseaEliminarLaTabla','Desea eliminar la tabla')>
<cfset LB_ModificarCopia = t.Translate('LB_ModificarCopia','Modificar copia')>
<cfset LB_ModificaLaCopiaDeLaVigenciaSeleccionada = t.Translate('LB_ModificaLaCopiaDeLaVigenciaSeleccionada','Modificar la copia de la vigencia seleccionada')>
<cfset LB_EliminarCopia = t.Translate('LB_EliminarCopia','Eliminar copia')>
<cfset LB_EliminaLaCopiaDeLaVigenciaSeleccionada_ManteniendoLaTablaOriginal = t.Translate('LB_EliminaLaCopiaDeLaVigenciaSeleccionada_ManteniendoLaTablaOriginal','Eliminar copia de la vigencia seleccionada, manteniendo la tabla original')>

<!--- FIN VARIABLES DE TRADUCCION --->
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<!--- VARIABLES URL --->
<cfif isdefined('url.RHVTid') and not isdefined("form.RHVTid")><cfset form.RHVTid = url.RHVTid></cfif>
<cfif isdefined('url.RHVTidL') and not isdefined("form.RHVTidL")><cfset form.RHTTid = url.RHVTidL></cfif>
<!--- FIN VARIABLES URL --->
<!--- VARIABLES LOCALES --->
<cfset Lvar_TablaT = false>
<!--- FIN VARIABLES LOCALES --->
<!--- VARIABLES FORM --->
<cfif isdefined('form.RHVTidL') and LEN(TRIM(form.RHVTid)) EQ 0>
	<cfset form.RHVTid = form.RHVTidL>
</cfif>
<!--- FIN VARIABLES FORM --->


<!--- CONSULTAS --->

<!--- Tipo de Redondeo Escalas--->
<cfquery name="rs" datasource="#session.DSN#">
    select Pvalor
    from RHParametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
      and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="125">
</cfquery>

<!--- Tipo de Redondeo Escalas 
	0 = Sin Redondeo
	1 = al mas cercano
	2 = hacia arriba
--->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="125" default="0" returnvariable="vTipoRedondeoEscalas"/>


<!---20150115 - ljs se agraga la validacion para mostrar o no la escala salarial al tipo de cambio --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2696" default="0" returnvariable="lvarMostrarTC"/>

<!--- VERIFICA SI TIENE UNA TABLA BASE--->
	<cf_translatedata name="get" tabla="RHVigenciasTabla" col="a.RHVTdescripcion" returnvariable="LvarRHVTdescripcion">
	<cfquery name="rsVerifTB" datasource="#session.DSN#"> 
		select a.RHVTtablabase,a.RHVTcodigo, #LvarRHVTdescripcion# as RHVTdescripcion,a.RHVTfecharige,a.RHVTfechahasta,a.RHVTdocumento,a.RHVTestado,
			case a.RHVTestado when 'A' then '#LB_Aplicado#' when 'P' then '#LB_Pendiente#'  when 'C' then '#LB_VigenciaSustituidaSoloConsulta#' else a.RHVTestado end as Estado
            ,coalesce(b.Miso4217,'') Mnombre, coalesce(RHVTtipocambio,1) RHVTtipocambio
            ,coalesce(RHVTtipoformula,1) as RHVTtipoformula
		from RHVigenciasTabla a
        	left join Monedas  b
            on a.Mcodigo = b.Mcodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
	</cfquery>
    
    <cfset LvarTC = #rsVerifTB.RHVTtipocambio#>



	<!--- CONSULTA SI HAY UNA TABLA DE TRABAJO PARA MODIFICAR --->
	<cf_translatedata name="get" tabla="ComponentesSalariales" col="CSdescripcion" returnvariable="LvarCSdescripcion">
	<cfquery name="rsMontosCat" datasource="#session.DSN#">
		select RHCcodigo,b.RHCdescripcion,RHMCmontoFijo, a.RHMCid, RHMCmontoAnt, (RHMCmontoAnt/#LvarTC#) mtoAntTC, RHMCmonto - RHMCmontoAnt as RHMCaumento, RHMCmonto, (RHMCmonto/#LvarTC#) RHMCmontoFtc, a.RHMCmontoPorc,
				CScodigo, #LvarCSdescripcion# as CSdescripcion,(RHMCmontoAnt/#LvarTC#) mtoAntTC,(RHMCmonto/#LvarTC#) RHMCmontoFtc, #LvarTC# as tipocambio
		from RHMontosCategoriaT a
		inner join RHCategoria b
			on b.RHCid = a.RHCid
		inner join ComponentesSalariales cs
				on a.CSid=cs.CSid	
		where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
		  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by RHCcodigo
        <!---order by <cf_dbfunction name="to_number" args="RHCcodigo">---->
    </cfquery>
    <cfif rsMontosCat.RecordCount EQ 0>
        <cfquery name="rsMontosCat" datasource="#session.DSN#">
            select RHCcodigo,b.RHCdescripcion,RHMCmontoFijo,a.RHMCid,RHMCmontoAnt, (RHMCmontoAnt/#LvarTC#) mtoAntTC, RHMCmonto, 
            (RHMCmonto/#LvarTC#) RHMCmontoFtc, a.RHMCmontoPorc,RHMCmonto - RHMCmontoAnt as RHMCaumento,
					CScodigo, #LvarCSdescripcion# as CSdescripcion, #LvarTC# as tipocambio
            from RHMontosCategoria a
            inner join RHCategoria b
                on b.RHCid = a.RHCid
			inner join ComponentesSalariales cs
				on a.CSid=cs.CSid	
            where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
              and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  order by RHCcodigo
            <!---order by <cf_dbfunction name="to_number" args="RHCcodigo">--->
        </cfquery>
    <cfelse>
    	<!--- INDICADOR DE QUE SE ESTA UTILIZANDO TABLA DE TRABAJO --->
    	<cfset Lvar_TablaT = true>
	</cfif>
 
	<!--- SI NO EXISTE UNA TABLA DE REFERENCIA DEBE PERMITIR INGRESAR LOS MONTOS INCIALES DE SALARIO BASE --->
	<cfif LEN(TRIM(rsVerifTB.RHVTtablabase))>
		<cfset Lvar_ModificaT= false>
	<cfelse>
		<cfset Lvar_ModificaT= true>
	</cfif>
	<cfset Lvar_botones = 'Anterior,Modificar,Siguiente'>
    <cfset Lvar_botonesN = 'Anterior,Modificar,Siguiente'>

    <cfif rsVerifTB.RHVTestado EQ 'C'>
    	<cfset Lvar_botones = 'Anterior,Siguiente'>
	    <cfset Lvar_botonesN = 'Anterior,Siguiente'>
    </cfif>
	<cfif rsVerifTB.RHVTestado EQ 'A'>
    	<cfif Lvar_TablaT>
        	<cfset Lvar_ModificaT= true>
			<cfset Lvar_botones = 'Anterior,ModificarA,Eliminar,Siguiente'>
            <cfset Lvar_botonesN = 'Anterior,Modificar Copia,Eliminar Copia,Siguiente'>
            <cfset Lvar_botonesF = ',,return confirm("#LB_DeseaEliminarLaTabla#?");,'>
            <cfsavecontent variable="EVAL_RIGHT">
            	<cfoutput>
                <table width="100%"  border="0" cellspacing="2" cellpadding="0" class="Ayuda">
                    <tr>
                        <td nowrap="nowrap" valign="top"><strong>#LB_ModificarCopia#:</strong></td>
                        <td><cf_translate key="MSG_CrearCopia">#LB_ModificaLaCopiaDeLaVigenciaSeleccionada#</cf_translate></td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td nowrap="nowrap" valign="top"><strong>#LB_EliminarCopia#:</strong></td>
                        <td><cf_translate key="MSG_CrearCopia">#LB_EliminaLaCopiaDeLaVigenciaSeleccionada_ManteniendoLaTablaOriginal#</cf_translate></td>
                    </tr>
                </table>
                </cfoutput>
        	</cfsavecontent>
        <cfelse>
			<cfset Lvar_botones = 'Anterior,ModificarA,Siguiente'>
            <cfset Lvar_botonesN = 'Anterior,Crear copia,Siguiente'>
            <cfset Lvar_botonesF = ',return confirm("#LB_DeseaModificarLaTablaAplicada#?");,'>
            <cfsavecontent variable="EVAL_RIGHT">
                <table width="100%"  border="0" cellspacing="2" cellpadding="0" class="Ayuda">
                    <tr>
                        <td nowrap="nowrap" valign="top"><strong><cf_translate key="BTN_Crear_Copia" xmlFile="/rh/generales.xml">Crear Copia</cf_translate>:</strong></td>
                        <td><cf_translate key="MSG_CrearCopia">Crear una copia de la vigencia seleccionada</cf_translate></td>
                    </tr>
                </table>
        	</cfsavecontent>
        </cfif>

	</cfif>

<!--- FIN CONSULTA --->
<cfset filtro = ''>
<cfset navegacion = "RHTTid=" & Form.RHTTid>
<cfparam name="form.PAGENUM" type="numeric" default="1">
<cfparam name="form.PAGENUMPADRE" default="1">

	<form action="Incremento-sql.cfm" method="post" name="formIF">
		<input name="SEL" type="hidden" value="" />
		<input name="modo" type="hidden" value="" />
		<input name="modov" type="hidden" value="<cfif isdefined('form.modov') and LEN(TRIM(form.modov))><cfoutput>#form.modov#</cfoutput></cfif>" />
		<input name="RHTTid" type="hidden" value="<cfif isdefined('form.RHTTid')><cfoutput>#form.RHTTid#</cfoutput></cfif>" />
		<input name="RHVTid" type="hidden" value="<cfif isdefined('form.RHVTid')><cfoutput>#form.RHVTid#</cfoutput></cfif>" />
		<input name="RHVTidL" type="hidden" value="<cfif isdefined('form.RHVTidL')><cfoutput>#form.RHVTidL#</cfoutput></cfif>" />
		<input name="RHVTtablabase" type="hidden" value="<cfif isdefined('rsVerifTB') and LEN(TRIM(rsVerifTB.RHVTtablabase))><cfoutput>#rsVerifTB.RHVTtablabase#</cfoutput></cfif>" />
        <input name="tc"  id="tc" type="hidden" value="<cfoutput>#LvarTC#</cfoutput>" />
        
		<cfoutput>
		<table width="90%" cellpadding="2" cellspacing="0" align="center" border="0">
			<tr>
				<td nowrap><strong>&nbsp;</strong></td>
				<td><strong><cf_translate key="LB_Rige">Rige</cf_translate></strong></td>
				<td><strong><cf_translate key="LB_Hasta">Hasta</cf_translate></strong></td>
				<cfif LEN(TRIM(rsVerifTB.RHVTtablabase))><td><strong><cf_translate key="LB_TablaBase">Tabla Base</cf_translate></strong></td><cfelse><td>&nbsp;</td></cfif>
                <td><strong><cf_translate key="LB_Moneda">Moneda</cf_translate></strong></td>
			</tr>
			<tr>
				<td nowrap><strong>&nbsp;</strong></td>
				<td><cf_locale name="date" value="#rsVerifTB.RHVTfecharige#"/></td>
				<td><cfif LEN(TRIM(rsVerifTB.RHVTfechahasta)) and rsVerifTB.RHVTfechahasta LT '01/01/2100'><cfoutput><cf_locale name="date" value="#rsVerifTB.RHVTfechahasta#"/></cfoutput><cfelse>Indefinido</cfif></td>
				<cfif LEN(TRIM(rsVerifTB.RHVTtablabase))><td>#rsVerifTB.RHVTtablabase#</td><cfelse><td>&nbsp;</td></cfif> 
                <cfif LEN(TRIM(rsVerifTB.Mnombre))><td>#rsVerifTB.Mnombre#</td></cfif> 

			</tr>
			<tr>
				<td nowrap><strong>&nbsp;</strong></td>
				<td nowrap ><strong><cf_translate key="LB_DocAuto">Documento que autoriza</cf_translate></strong></td>
				<td nowrap><strong><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></strong></td>
				<td nowrap><strong><cf_translate key="LB_Estado">Estado</cf_translate></strong></td>
                <td nowrap><strong><cf_translate key="LB_TipoDeCambio" xmlFile="/rh/generales.xml">Tipo Cambio</cf_translate></strong></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><cfoutput>#HTMLEditFormat(rsVerifTB.RHVTdocumento)#</cfoutput></td>
				<td><cfoutput>#HTMLEditFormat(rsVerifTB.RHVTdescripcion)#</cfoutput></td>
				<td><cfoutput>#HTMLEditFormat(rsVerifTB.Estado)#</cfoutput></td>
                <td><cfoutput>#LsNumberFormat(rsVerifTB.RHVTtipocambio,'999,999.99')#</cfoutput></td>
			</tr>
            <tr><td>&nbsp;</td></tr>
            <cfif Lvar_TablaT>
            	<tr><td colspan="5" align="center" style="color:##FF0000; font-size:14px; ">#LB_SeEstaMostrandoUnaCopiaDeLaTabla#</td></tr>
            </cfif>
             <cfif rsVerifTB.RHVTestado EQ 'C'>
            	<tr><td colspan="5" align="center" style="color:##FF0000; font-size:14px; ">#LB_SeEstaMostrandoUnaTablaQueFueSustituidaEnLaMismaVigencia#</td></tr>
            </cfif>
            
            
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="6" align="left" bordercolor="999999">
					<table>
						<tr>
							<td  colspan="6" align="left"><strong>#LB_ElAumentoPorcentualAplicaSobre#:</strong></td></tr>
						<tr>
							<td colspan="6" align="left">&nbsp;&nbsp;&nbsp;
								<input  onclick="javascript:actualizarGlobal();" type="radio"  name="formularCalculo" value="1" <cfif isdefined('rsVerifTB') and #rsVerifTB.RHVTtipoformula# EQ 1>checked </cfif>/>#LB_BaseYAumentoFijo#
							</td>
						</tr>
						<tr>
							<td colspan="6" align="left">&nbsp;&nbsp;&nbsp;
							<input  onclick="javascript:actualizarGlobal();" type="radio"  name="formularCalculo" value="2" <cfif isdefined('rsVerifTB') and #rsVerifTB.RHVTtipoformula# EQ 2>checked</cfif>/>#LB_SoloSobreLaBaseMasAumentoFijo#
						</td>
						</tr>
					</table>	
				<td>	
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
		</cfoutput>
		
	
		<table  width="100%" cellpadding="2" cellspacing="0" align="center" border="0">
        	
			<tr><td colspan="10" nowrap="nowrap"><cf_botones names="#Lvar_botones#" values="#Lvar_botonesN#"></td></tr>
			<tr bgcolor="#CCCCCC">
				<td>&nbsp;</td>
				<td align="center"><strong><cf_translate key="LB_Categoria">Categoría</cf_translate></strong></td>
				<td align="center"><strong><cf_translate key="LB_Componente">Componente</cf_translate></strong></td>
				<td align="center"><strong><cf_translate key="LB_Monto" xmlFile="/rh/generales.xml">Monto</cf_translate></strong></td>
                <cfif lvarMostrarTC> <!---se muestra los montos convertidos al tipo de cambio parametro 2296--->
	                <cfoutput><td align="center"><strong><cf_translate key="LB_Monto" xmlFile="/rh/generales.xml">Monto</cf_translate> #rsVerifTB.Mnombre#</strong></td></cfoutput>
                </cfif>
				<td align="center"><strong><cf_translate key="LB_Fijo" xmlFile="/rh/generales.xml">Fijo</cf_translate></strong></td>
				<td align="center"><strong><cf_translate key="LB_Porcentual" xmlFile="/rh/generales.xml">Porcentual</cf_translate></strong></td>
				<td align="center"><strong><cf_translate key="LB_Aumento" xmlFile="/rh/generales.xml">Aumento</cf_translate></strong></td>
				<td align="center"><strong><cf_translate key="LB_MontoFinal">Monto Final</cf_translate></strong></td>
                <cfif lvarMostrarTC> <!---se muestra los montos convertidos al tipo de cambio parametro 2296--->
					<cfoutput><td align="center"><strong><cf_translate key="LB_MontoFinal">Monto Final</cf_translate> #rsVerifTB.Mnombre#</strong></td></cfoutput>
                </cfif>
			</tr>
			<tr bgcolor="#CCCCCC"><br />
	            <cfif lvarMostrarTC> <!---se muestra los montos convertidos al tipo de cambio parametro 2296--->
                    <td colspan="5">&nbsp;</td>
                <cfelse>
                    <td colspan="4">&nbsp;</td>
                </cfif>
				<td align="center" ><cf_inputNumber name="IncrementoFijoGlobal" value="0.00" decimales="2" enteros="8" modificable="true" tabindex="1" onBlur="javascript:aumentoGlobal(1)"></td>
				<td align="center" ><cf_inputNumber name="IncrementoPorcentualGlobal" value="0.00" decimales="2" enteros="3" modificable="true" tabindex="1" onBlur="javascript:aumentoGlobal(2)"></td>
				<td align="center" colspan="2">&nbsp;</td>
                <td align="center" colspan="2">&nbsp;</td>
			</tr>
            
			<cfset encabezadoCategoria=''>
			
			<cfoutput query="rsMontosCat">
				<cfif trim(encabezadoCategoria) neq trim(rsMontosCat.RHCcodigo)><tr><td colspan="10"><hr/></td></tr></cfif>
				<tr>
					<td>&nbsp;</td>
					<td><strong><cfif trim(encabezadoCategoria) neq trim(rsMontosCat.RHCcodigo)><u>#rsMontosCat.RHCcodigo#</u> - #rsMontosCat.RHCdescripcion#<cfelse>&nbsp;</cfif></strong></td>
					<cfset encabezadoCategoria=trim(rsMontosCat.RHCcodigo)>
					
					<td align="left"><u>#rsMontosCat.CScodigo#</u> - #rsMontosCat.CSdescripcion#</td>
					<td align="right"><cf_inputNumber name="RHMCmontoAnt#rsMontosCat.RHMCid#" value="#rsMontosCat.RHMCmontoAnt#" decimales="2"  enteros="8" modificable="#Lvar_ModificaT#" tabindex="1"></td>
					<cfif lvarMostrarTC> <!---se muestra los montos convertidos al tipo de cambio parametro 2296--->
                    	<td align="right"><cf_inputNumber name="RHMCmontoAntTC#rsMontosCat.RHMCid#" value="#rsMontosCat.mtoAntTC#" decimales="2"  enteros="8" modificable="#Lvar_ModificaT#" tabindex="1"></td>
                    </cfif>
                    <td align="right"><cf_inputNumber name="RHMCmontoFijo#rsMontosCat.RHMCid#" value="#rsMontosCat.RHMCmontoFijo#" decimales="2" enteros="8" modificable="true" negativos="true"  tabindex="1" onblur="calcularMontos(RHMCmontoAnt#rsMontosCat.RHMCid#,RHMCmontoFijo#rsMontosCat.RHMCid#,RHMCmontoPorc#rsMontosCat.RHMCid#,#rsMontosCat.RHMCid#)"></td>
					<td align="center"><cf_inputNumber name="RHMCmontoPorc#rsMontosCat.RHMCid#" value="#rsMontosCat.RHMCmontoPorc#" decimales="2" enteros="2" modificable="true" tabindex="1" onblur="calcularMontos(RHMCmontoAnt#rsMontosCat.RHMCid#,RHMCmontoFijo#rsMontosCat.RHMCid#,RHMCmontoPorc#rsMontosCat.RHMCid#,#rsMontosCat.RHMCid#)"></td>
					<td align="right"><cf_inputNumber name="RHMCaumento#rsMontosCat.RHMCid#" value="#rsMontosCat.RHMCaumento#" decimales="2"  enteros="8" modificable="false" tabindex="1"></td>
					<td align="right"><cf_inputNumber name="RHMCmonto#rsMontosCat.RHMCid#" value="#rsMontosCat.RHMCmonto#" decimales="2"  enteros="8" modificable="false" tabindex="1"></td>
                    <cfif lvarMostrarTC> <!---se muestra los montos convertidos al tipo de cambio parametro 2296--->
	                    <td align="right"><cf_inputNumber name="RHMCmontoFtc#rsMontosCat.RHMCid#" value="#rsMontosCat.RHMCmontoFtc#" decimales="2"  enteros="8" modificable="false" tabindex="1"></td>
					</cfif>
				</tr>
			</cfoutput>
			<tr><td colspan="10">
            <cf_botones names="#Lvar_botones#" values="#Lvar_botonesN#" formName="formIF"></td></tr>
		</table>
	</form>

<script>
	
	function calcularMontos(montoInicial,montoFijo, porcentaje,id){
		var monto = 'document.formIF.RHMCmonto' + id;
		var aumento = 'document.formIF.RHMCaumento' + id;
		var aumentotc = 'document.formIF.RHMCmontoFtc' + id;
		
		var ftc = document.formIF.tc.value
		
 		if (document.formIF.formularCalculo[0].checked){
			eval(aumento).value = fm(   (     (    (Number(qf(montoInicial.value)) + Number(qf(montoFijo.value)) ) *   Number(qf(porcentaje.value))  /100  )  +  Number(qf(montoFijo.value))   ) ,2);//((SB+F)*%)+F
		}else{
			eval(aumento).value = fm(   (     ( Number(qf(montoInicial.value)) *   Number(qf(porcentaje.value)) )/100  +  Number(qf(montoFijo.value))   ) ,2);//(SB*%)+F
		}

		<!--- Redondeo al más cercano --->
		<cfif vTipoRedondeoEscalas EQ 1>
			eval(monto).value = fm((Math.round(Number(qf(eval(aumento).value))) + Number(qf(eval(montoInicial).value))),2); //aumento
			<cfif lvarMostrarTC>
				eval(aumentotc).value =  fm((Math.round(Number(qf(eval(aumento).value))) + Number(qf(eval(montoInicial).value))) /ftc,2);  //aumento
			</cfif>
		<!--- Redondeo hacia arriba --->
		<cfelseif vTipoRedondeoEscalas EQ 2>
			eval(monto).value = fm((Math.ceil(Number(qf(eval(aumento).value))) + Number(qf(eval(montoInicial).value))),2); //aumento
			<cfif lvarMostrarTC>
				eval(aumentotc).value = fm((Math.ceil(Number(qf(eval(aumento).value))) + Number(qf(eval(montoInicial).value)))/ftc,2);  //aumento
			</cfif>
		<!--- Sin redondeo --->
		<cfelse>
			eval(monto).value = fm((Number(qf(eval(aumento).value)) + Number(qf(eval(montoInicial).value))),2); //aumento
			<cfif lvarMostrarTC>
				eval(aumentotc).value = fm((Number(qf(eval(aumento).value)) + Number(qf(eval(montoInicial).value)))/ftc,2); //aumento
			</cfif>
		</cfif>
				
		return true;
	}	
	
	function funcSiguiente(){
		document.formIF.SEL.value = "4";
		document.formIF.action = "tipoTablasSal.cfm";
		return true;
	}
		function funcAnterior(){
		document.formIF.SEL.value = "2";
		document.formIF.action = "tipoTablasSal.cfm";
		return true;
	}
	
	function funcModificarA(){
		<cfif not Lvar_TablaT>
		if (confirm("<cfoutput>#LB_DeseaModificarLaTablaAplicada#</cfoutput>?")){
			return true;
			}
			return false;
		</cfif>
		}
		
	function actualizarGlobal(){
		var montoInicial = '';
		var montoFijo = '';
		var porcentaje = '';
		var aumento = '';
		var monto = '';
		
		<cfoutput query="rsMontosCat">
			montoInicial = 'document.formIF.RHMCmontoAnt' + #rsMontosCat.RHMCid#;
			montoFijo = 'document.formIF.RHMCmontoFijo' + #rsMontosCat.RHMCid#;
			porcentaje = 'document.formIF.RHMCmontoPorc' + #rsMontosCat.RHMCid#;
			monto = 'document.formIF.RHMCmonto' + #rsMontosCat.RHMCid#;
			aumento = 'document.formIF.RHMCaumento' + #rsMontosCat.RHMCid#;
			aumentotc = 'document.formIF.RHMCmontoFtc' + #rsMontosCat.RHMCid#;
			
			if (document.formIF.formularCalculo[0].checked){
				eval(aumento).value = fm(   (     (    (Number(qf(eval(montoInicial).value)) + Number(qf(eval(montoFijo).value)) ) *   Number(qf(eval(porcentaje).value))  /100  )  +  Number(qf(eval(montoFijo).value))   ) ,2);//((SB+F)*%)+F
			}else{
				eval(aumento).value = fm(   (     ( Number(qf(eval(montoInicial).value)) *   Number(qf(eval(porcentaje).value)) )/100  +  Number(qf(eval(montoFijo).value))   ) ,2);//(SB*%)+F
			}
		
			<!---Redondeo al más cercano--->
			<cfif vTipoRedondeoEscalas EQ 1>
				eval(monto).value =  fm(   ( Math.round(Number(qf(eval(aumento).value))) +   Number(qf(eval(montoInicial).value))     ) ,2);//aumento
				<cfif lvarMostrarTC>
					eval(aumentotc).value =  fm(   ( Math.round(Number(qf(eval(aumento).value))) +   Number(qf(eval(montoInicial).value))     )/#rsMontosCat.tipocambio# ,2);  //aumento	
				</cfif>
			<!---Redondeo hacia arriba--->
			<cfelseif vTipoRedondeoEscalas EQ 2>
				eval(monto).value =  fm(   ( Math.ceil(Number(qf(eval(aumento).value))) +   Number(qf(eval(montoInicial).value))     ) ,2);//aumento
				<cfif lvarMostrarTC>
					eval(aumentotc).value =  fm(   ( Math.ceil(Number(qf(eval(aumento).value))) +   Number(qf(eval(montoInicial).value))     )/#rsMontosCat.tipocambio# ,2);  //aumento	
				</cfif>
			<!---Sin redondeo--->
			<cfelse>
				eval(monto).value =  fm(   ( Number(qf(eval(aumento).value)) +   Number(qf(eval(montoInicial).value))     ) ,2);//aumento
				<cfif lvarMostrarTC>
					eval(aumentotc).value =  fm(   ( Number(qf(eval(aumento).value)) +   Number(qf(eval(montoInicial).value))     )/#rsMontosCat.tipocambio# ,2);  //aumento	
				</cfif>
			</cfif>
		</cfoutput>

		return true;
	}	
	
	function aumentoGlobal(tipo){
		var RHMCmontoFijo = '';
		var RHMCmontoPorc = '';
		var RHMCmontoFijoPropuesto = document.formIF.IncrementoFijoGlobal.value;
		var RHMCmontoPorcPropuesto = document.formIF.IncrementoPorcentualGlobal.value;
		<cfoutput query="rsMontosCat">
		montoFijo = 'document.formIF.RHMCmontoFijo' + #rsMontosCat.RHMCid#;
		porcentaje = 'document.formIF.RHMCmontoPorc' + #rsMontosCat.RHMCid#;
		
		if (tipo == 1){
			eval(montoFijo).value =  qf(RHMCmontoFijoPropuesto)
		}else{
			eval(porcentaje).value = qf(RHMCmontoPorcPropuesto)
		}
		</cfoutput>
	
		actualizarGlobal();
	
		return true;
	}
	
	function funcModificarA(){
		<cfif not Lvar_TablaT>
		if (confirm("<cfoutput>#LB_DeseaCrearUnaCopiaDeLaTablaAplicada#</cfoutput>?")){
			return true;
			}
			return false;
		</cfif>
		}
	function funcEliminar(){
		if (confirm("<cfoutput>#LB_DeseaEliminarLaCopia#</cfoutput>?")){
			return true;
			}
			return false;
		}
		

</script>