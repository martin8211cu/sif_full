<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif> <!--- modo cambio --->
<cfset mens="">
<cfif isdefined("Form.Mensaje")>
	<cfset mens="CAMBIO">
</cfif>
<cfset Msg_Err="">
<cfif isdefined("Form.Msg_Err")>
	<cfset Msg_Err="#Form.Msg_Err#">
</cfif>
<cfset vs_CtaErr = "">
<cfif isdefined("Form.Msg_Err") and Msg_Err neq "" >
	<cfset vs_CtaErr = "#Form.CPCCmascara#">
</cfif>
<cfif isdefined("url.CPfiltro") and url.CPfiltro eq "S" >
	<cfset Form.CPfiltro = "S">
</cfif>
<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo = t.Translate('LB_Titulo','Configuraci&oacute;n de Cuentas de Presupuesto Comprometidas Automáticamente')>
<cfset LB_CtasPre = t.Translate('LB_CtasPre','Cuentas de presupuesto')>
<cfset CMB_Enero 	= t.Translate('CMB_Enero','Enero','/sif/generales.xml')>
<cfset CMB_Febrero 	= t.Translate('CMB_Febrero','Febrero','/sif/generales.xml')>
<cfset CMB_Marzo 	= t.Translate('CMB_Marzo','Marzo','/sif/generales.xml')>
<cfset CMB_Abril 	= t.Translate('CMB_Abril','Abril','/sif/generales.xml')>
<cfset CMB_Mayo 	= t.Translate('CMB_Mayo','Mayo','/sif/generales.xml')>
<cfset CMB_Junio 	= t.Translate('CMB_Junio','Junio','/sif/generales.xml')>
<cfset CMB_Julio 	= t.Translate('CMB_Julio','Julio','/sif/generales.xml')>
<cfset CMB_Agosto 	= t.Translate('CMB_Agosto','Agosto','/sif/generales.xml')>
<cfset CMB_Septiembre = t.Translate('CMB_Septiembre','Septiembre','/sif/generales.xml')>
<cfset CMB_Octubre = t.Translate('CMB_Octubre','Octubre','/sif/generales.xml')>
<cfset CMB_Noviembre = t.Translate('CMB_Noviembre','Noviembre','/sif/generales.xml')>
<cfset CMB_Diciembre = t.Translate('CMB_Diciembre','Diciembre','/sif/generales.xml')>
<cfset LB_Mensual = t.Translate('LB_Mensual','Mensual')>
<cfset LB_Bimestral = t.Translate('LB_Bimestral','Bimestral')>
<cfset LB_Trimestral = t.Translate('LB_Trimestral','Trimestral')>
<cfset LB_Cuatrimestral = t.Translate('LB_Cuatrimestral','Cuatrimestral')>
<cfset LB_Semestral = t.Translate('LB_Semestral','Semestral')>
<cfset LB_Anual = t.Translate('LB_Anual','Anual')>
<cfset LB_Linea = t.Translate('LB_Linea','Linea')>
<cfset LB_Descripcion = t.Translate('LB_Descripcion','Descripción')>
<cfset LB_Cuenta = t.Translate('LB_Cuenta','Cuenta')>
<cfset LB_Noseencontrarondatos = t.Translate('LB_Noseencontrarondatos','No se encontraron datos')>
<cfset BTN_Aplicar = t.Translate('BTN_Aplicar','Aplicar','/sif/generales.xml')>
<cfset BTN_VerError = t.Translate('BTN_VerError','Ver Error')>
<cfset LB_ExistenCambiosNoApl = t.Translate('LB_ExistenCambiosNoApl','Existen cambios no aplicados en las cuentas con compromiso automático')>

<cf_templatecss>
<cfoutput>
<form action="CPComprAutPerMes-SQL.cfm" method="post" name="form1" onSubmit="return validar();">
	<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
        <tr><td>&nbsp;</td></tr>
    	<tr>
	      	<td colspan="5" align="center" class="tituloListas">#LB_Titulo#</td>
    	</tr>
		<tr>
        	<td colspan="4">
            	<table border="0">
        			<tr>
                        <td>&nbsp;</td>
                        <td nowrap>
                            #LB_CtasPre#:
                        </td>

                        <td>
                            <cf_CuentaPresupuesto name="CPformato" CPdescripcion="CPdescripcion" >
                        </td>
						<td>
							<select id="CPFiltro" name="CPFiltro">
								<option value="" >Mostrar todos</option>
								<option value="S" <cfif isdefined('form.CPFiltro') and form.CPFiltro EQ 'S' >selected</cfif>>Pendientes de Aplicar</option>
							</select>
						</td>
                        <td>

						<input type="submit" name="btnFiltrar" value="Filtrar"/>


<!---                        <td>
                        <input
                            name="CPdescripcion"
                            type="text"
                            id="CPdescripcion"
                            size="60"
                            maxlength="60"
                            readonly="readonly">
						</td>
--->
                        <input type="hidden" name="CPPid" id="CPPid" value="<cfoutput>#form.CPPid#</cfoutput>">
						</td>
					</tr>
				</table>
			</td>

       	</tr>
		<tr>
			<td colspan="5" align="center"><cfinclude template="../../portlets/pBotones.cfm"></td>

		</tr>
        <tr>
        	<cfif Msg_Err neq "">
                <td>&nbsp;</td>
                <td>#Msg_Err##vs_CtaErr#</td>
            </cfif>
        </tr>
	</table>
        <!--- Para Borrado desde la lista --->
        <input type="hidden" name="CPCCid" value="">
        <!---<input type="hidden" name="CPPid" value="#Form.CPPid#">--->
		<input type="hidden" name="BorrarD" value="">
		<!--- --------------------------- --->

</form>
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
		<cfquery name="MensAplCompromiso" datasource="#Session.DSN#">
			select * from MensAplCompromiso where Ecodigo =
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfif MensAplCompromiso.recordCount gt 0>
		<tr align="center">
			<td> <input type="submit" name="btnVerError" value="#BTN_VerError#"
				onClick="location.href='CPConsultaError.cfm?CPPid=#Form.CPPid#';">
			</td>
		</tr>
		</cfif>
</table>

<cfquery name="rsComprAut" datasource="#session.dsn#">
            select CPCompromiso
			from CPparametros
			where Ecodigo = #session.Ecodigo#
				and CPPid = #Form.CPPid#
</cfquery>

<cfif (rsComprAut.recordCount GT 0 and rsComprAut.CPCompromiso eq 'True') >
<form action="CPComprObligatorio.cfm" method="post" name="sql">
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
	<tr>
		<td>
			&nbsp
		</td>
		<td>
			<input type="submit" name="btnCCompObl" value="Cuentas compromiso obligatorio" onClick="javascript: location.href='CPComprObligatorio.cfm?CPPid=#Form.CPPid#';"/>
		</td>
	</tr>
</table>
</form>
</cfif>

</cfoutput>
<cfinclude template="../../Utiles/sifConcat.cfm">

<cfquery name="rsCuentas" datasource="#Session.DSN#">
select count(*) as CuentasNA
from CPresupuestoComprAut a
inner join CPresupuestoComprAutD d
			on a.CPCCid=d.CPCCid
where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    and a.CPPid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
	and a.CPcambioAplicado = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
	and d.CPComprMod <> d.CPComp_Anterior
</cfquery>


<cfquery name="rsLineas" datasource="#Session.DSN#">
select
    a.CPCCid,
    a.CPCCdescripcion,
    a.CPCCmascara,
    a.Cmayor,
    a.Ecodigo,
    b.CPPid,
    b.CPPtipoPeriodo,
    b.CPPfechaDesde,
    b.CPPfechaHasta,
    'Presupuesto ' #_Cat#
        case b.CPPtipoPeriodo when 1 then '#LB_Mensual#' when 2 then '#LB_Bimestral#' when 3 then '#LB_Trimestral#' when 4 then '#LB_Cuatrimestral#' when 6 then '#LB_Semestral#' when 12 then '#LB_Anual#' else '' end
            #_Cat# ' de ' #_Cat#
        case {fn month(b.CPPfechaDesde)} when 1 then '#CMB_Enero#' when 2 then '#CMB_Febrero#' when 3 then '#CMB_Marzo#' when 4 then '#CMB_Abril#' when 5 then '#CMB_Mayo#' when 6 then '#CMB_Junio#' when 7 then '#CMB_Julio#' when 8 then '#CMB_Agosto#' when 9 then '#CMB_Septiembre#' when 10 then '#CMB_Octubre#' when 11 then '#CMB_Noviembre#' when 12 then '#CMB_Diciembre#' else '' end
            #_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(b.CPPfechaDesde)}">
            #_Cat# ' a ' #_Cat#
        case {fn month(b.CPPfechaHasta)} when 1 then '#CMB_Enero#' when 2 then '#CMB_Febrero#' when 3 then '#CMB_Marzo#' when 4 then '#CMB_Abril#' when 5 then '#CMB_Mayo#' when 6 then '#CMB_Junio#' when 7 then '#CMB_Julio#' when 8 then '#CMB_Agosto#' when 9 then '#CMB_Septiembre#' when 10 then '#CMB_Octubre#' when 11 then '#CMB_Noviembre#' when 12 then '#CMB_Diciembre#' else '' end
            #_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(b.CPPfechaHasta)}">
    as Periodo, a.CPcambioAplicado
from CPresupuestoComprAut a
    inner join CPresupuestoPeriodo b
        on b.CPPid = a.CPPid
where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    and a.CPPid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
    <cfif isdefined('form.CPcuenta') and form.CPcuenta NEQ ''>
    	and a.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
    </cfif>
	<cfif isdefined('form.CPFiltro') and form.CPFiltro EQ 'S'>
    	and a.CPcambioAplicado = 0
    </cfif>
</cfquery>
<cfif isdefined('form.CPFiltro') and form.CPFiltro EQ 'S'>
	<cfset navegacion = "&CPFiltro=#form.CPFiltro#" />
<cfelse>
	<cfset navegacion = "" />
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>&nbsp;</tr>
    <cfif rsLineas.RecordCount gt 0>
        <cfinvoke component="sif.Componentes.pListas"
                method="pListaQuery"
                returnvariable="pListaRet">
            <cfinvokeargument name="query" value="#rsLineas#"/>
            <cfinvokeargument name="desplegar" value="CurrentRow,CPCCdescripcion,CPCCmascara"/>
            <cfinvokeargument name="etiquetas" value="#LB_Linea#,#LB_Descripcion#,#LB_Cuenta#"/>
            <cfinvokeargument name="formatos" value="S,S,S"/>
            <cfinvokeargument name="align" value="left,left,left"/>
            <cfinvokeargument name="ajustar" value="N"/>
            <cfinvokeargument name="keys" value="CPCCid"/>
            <cfinvokeargument name="irA" value="CPCompromisoAutD.cfm"/>
            <cfinvokeargument name="showEmptyListMsg" value="yes"/>
            <cfinvokeargument name="formName" value="ListaCtas"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
        </cfinvoke>
		<cfoutput>
        <tr>
        	<td>
            	<cfif rsCuentas.CuentasNA gt 0>
                	#LB_ExistenCambiosNoApl#
                </cfif>
            </td>
        </tr>
        <tr align="center">
        	<td>
			<input type="submit" name="btnAplicar" value="#BTN_Aplicar#"
            onClick="javascript: location.href='CPAplicaCompAutPerMes.cfm?CPPid=#Form.CPPid#';">
            </td>
        </tr>
		</cfoutput>
    <cfelse>
		<cfoutput>
        <tr>
            <td width="1%">&nbsp;</td>
            <td align="center" colspan="4">--- #LB_Noseencontrarondatos# ----</td>
            <td width="1%">&nbsp;</td>
        </tr>
		</cfoutput>
    </cfif>
</table>

<cfoutput>
<script language="javascript" type="text/javascript">
	function validar(form){
		var CPformato  = new Number(document.form1.CPformato.value);

		//alert(document.form1.btnCCompObl.value);
		if (document.form1.botonSel.value == "")
		{
			if (document.form1.btnFiltrar.value != "")
			{
				return true;
			}
		}

		if (CPformato == "") {
			document.form1.botonSel.value = '';
			alert ("No ha escogido ninguna cuenta");
			return false;
		}
	}

</script>
</cfoutput>
