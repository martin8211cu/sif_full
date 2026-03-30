<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_CODIGO" default="C&oacute;digo" xmlfile="/rh/generales.xml" returnvariable="LB_CODIGO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_DESCRIPCION" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SalarioBase" default="Salario Base" returnvariable="LB_SalarioBase" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Orden" default="Orden" returnvariable="LB_Orden" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_NoSeHanAgregadoComponentesAEsteGrupo" default="-- No se han agregado Componentes a este Grupo. --" returnvariable="MSG_NoSeHanAgregadoComponentesAEsteGrupo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_REGRESAR" default="Regresar" returnvariable="BTN_REGRESAR"  component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_METODOS" default="M&eacute;todos" returnvariable="BTN_METODOS" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_REGLAS" default="Reglas" returnvariable="BTN_REGLAS" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSN_CodigoDeComponenteSalarial" Default="Código de Componente Salarial." returnvariable="MSN_CodigoDeComponenteSalarial" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DigiteLaDescripcion" Default="Descripción" returnvariable="MSG_DigiteLaDescripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_Comportamiento" Default="Comportamiento" returnvariable="MSG_Comportamiento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ComponenteSalarial" Default="Componente Salarial" returnvariable="MSG_ComponenteSalarial" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_SalarioBase" Default="Salario Base" returnvariable="MSG_SalarioBase" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DebeSeleccionarUnComponenteParaPoderDarMantenimientoASusMetodos" Default="Debe seleccionar un Componente, para poder dar mantenimiento a sus métodos" returnvariable="MSG_DebeSeleccionarUnComponenteParaPoderDarMantenimientoASusMetodos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ConceptoSAT" default="Concepto SAT" returnvariable="MSG_ConceptoSAT" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<!---
	Nombre: formComponentes.cfm
	Descripción: Formulario de Componentes Salariales
--->
<!--- Parámetros iniciales --->

<!--- Averiguar si hay que utilizar la tabla salarial --->
<cfquery name="rsTipoTabla" datasource="#Session.DSN#">
	select CSusatabla
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and CSsalariobase = 1
</cfquery>
<cfif rsTipoTabla.recordCount GT 0>
	<cfset usaEstructuraSalarial = rsTipoTabla.CSusatabla>
<cfelse>
	<cfset usaEstructuraSalarial = 0>
</cfif>

<cfif isdefined("url.RHCAid") and not isdefined("form.RHCAid")><cfset form.RHCAid = url.RHCAid></cfif>
<cfif isdefined("url.CSid") and not isdefined("form.CSid")><cfset form.CSid = url.CSid></cfif>
<cfif isdefined("url.PAGENUMPADRE") and not isdefined("form.PAGENUMPADRE")><cfset form.PAGENUMPADRE = url.PAGENUMPADRE></cfif>
<cfif isdefined("url.PAGENUM") and not isdefined("form.PAGENUM")><cfset form.PAGENUM = url.PAGENUM></cfif>
<cfif isdefined("form.GenerarNV") and isdefined("form.PAGENUM") and not isdefined("form.PAGENUMPADRE")><cfset form.PAGENUMPADRE = form.PAGENUM><cfset form.PAGENUM = 1></cfif>
<cfif isdefined("url.fCSdescripcion") and not isdefined("form.fCSdescripcion")><cfset form.fCSdescripcion = url.fCSdescripcion></cfif>
<cfif isdefined("url.fCScodigo") and not isdefined("form.fCScodigo")><cfset form.fCScodigo = url.fCScodigo></cfif>

<!--- DATOS DEL FILTRO --->
<cfset filtro="">
<cfif isdefined('form.fCScodigo') and LEN(TRIM(form.fCScodigo))>
	<cfset filtro = filtro & " and upper(CScodigo) like '%#ucase(form.fCScodigo)#%' " >
</cfif>
<cfif isdefined('form.fCSdescripcion') and LEN(TRIM(form.fCSdescripcion))>
	<cfset filtro = filtro & " and upper(CSdescripcion) like '%#ucase(form.fCSdescripcion)#%' " >
</cfif>
<!--- FIN DATOS DEL FILTRO --->

<!--- <cfparam name="form.PAGENUM" type="numeric" default="1">
<cfparam name="form.PAGENUMPADRE" type="numeric" default="1"> --->
<cfparam name="form.fCScodigo" type="string" default="">
<cfparam name="form.fCSdescripcion" type="string" default="">
<cfset MODO = "ALTA"><cfif isdefined("form.CSid")><cfset MODO = "CAMBIO"></cfif>

<!--- Consultas --->
<cfquery name="rsGComponentes" datasource="#Session.DSN#">
	select RHCAcodigo, RHCAdescripcion
	from RHComponentesAgrupados
	where RHCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCAid#">
</cfquery>
<cfif (MODO NEQ "ALTA")>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select a.CSid, rtrim(ltrim(a.CScodigo)) as CScodigo,
			   a.CSdescripcion, a.CSusatabla, a.CSsalariobase, a.ts_rversion,
				 coalesce(b.CIid, 0) as CIid, b.CIcodigo, b.CIdescripcion, a.CScomplemento, a.CSorden, CSpagohora, CSpagodia,
				 CSclave, CScodigoext,CSreplica
				 ,CSsalarioEspecie, CSsalarioEspecieQuin,coalesce(a.RHCSATid,b.RHCSATid) as RHCSATid,CSexcluyeCB
		from ComponentesSalariales a
		left join CIncidentes b
		  on a.Ecodigo = b.Ecodigo and
			 a.CIid = b.CIid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">
	</cfquery>
	<cfset ts = "">
	<cfinvoke
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
	</cfinvoke>
</cfif>

<!--- Parametro 530, Sincronizar componentes con Conceptos de Pago --->
<cfquery name="sincroniza" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  	  and Pcodigo = 530
</cfquery>
<!--- VERIFICA PARAMETRO PARA MOSTRAR CLAVE Y CODIGO UTILIZADO EN PROCESO DE INTERFAZ CON SAP (OE) --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2010" default="" returnvariable="InterfazCatalogos"/>

<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(ltrim(CScodigo)) as CScodigo
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- VERIFICA SI LA EMPRESA ES DE GUATEMALA PARA MOSTRAR OTROS DATOS --->
<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select 1
	from Empresa e
		inner join Direcciones d
		on d.id_direccion = e.id_direccion
		and Ppais = 'GT'
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>
<!--- JavaScript --->
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript" type="text/javascript">
	function lockConcepto(tf) {
		var a = document.getElementById("trConceptos");
		if (a) {
			a.style.display = (tf ? "none" : "");
		}
	}
</script>
<!--- Tabla de Encabezado con info del Grupo de Componentes --->


<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td width="40%" class="tituloListas" >&nbsp;</td>
		<td width="200" align="center" class="tituloListas"><cfoutput><strong>#rsGComponentes.RHCAcodigo#&nbsp;#rsGComponentes.RHCAdescripcion#</strong></cfoutput></td>
		<td width="40%" class="tituloListas" >&nbsp;</td>
		</tr>
</table>
<!--- Tabla que contiene la lista y el Formulario --->

<table width="100%"  border="0" cellspacing="0" cellpadding="1">
  <tr>
    <td valign="top">
		<form name="filtro" action="" method="post">
			<cfoutput>
			<input name="RHCAid" type="hidden" value="#form.RHCAid#" />
			<input name="PAGENUM" type="hidden" value="#form.PAGENUM#" />
			<input name="PAGENUMPADRE" type="hidden" value="#form.PAGENUMPADRE#" />
			<table width="100%" cellpadding="3" cellspacing="0">
				<tr class="tituloListas">
					<td><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
					<td colspan="2"><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
				</tr>
				<tr>
					<td>
						<input name="fCScodigo" type="text" size="5" value="<cfif isdefined('form.fCScodigo')>#form.fCScodigo#</cfif>" />
					</td>
					<td>
						<input name="fCSdescripcion" type="text" size="40" value="<cfif isdefined('form.fCSdescripcion')>#form.fCSdescripcion#</cfif>" />
					</td>
					<td align="right"><cf_botones names="filtro" values="Filtrar"></td>
			</table>
			</cfoutput>
		</form>
		<!--- Lista --->
		<cfset navegacion = "">
		<cfset checked = "<img src=''/cfmx/rh/imagenes/checked.gif'' border=''0''>">
		<cfset unchecked = "<img src=''/cfmx/rh/imagenes/unchecked.gif'' border=''0''>">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "PAGENUM=" & Form.PAGENUM>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "PAGENUMPADRE=" & Form.PAGENUMPADRE>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHCAid=" & Form.RHCAid>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fCScodigo=" & Form.fCScodigo>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fCSdescripcion=" & Form.fCSdescripcion>
		<cfinvoke
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="ComponentesSalariales"/>
			<cfinvokeargument name="columnas" value="CAid as RHCAid1, CSid, CScodigo, CSdescripcion, CSorden
				, CSsalariobase,  case CSsalariobase when 1 then '#checked#' else '#unchecked#' end as CSsalariobaseimg
				,  #form.PAGENUMPADRE# as PAGENUMPADRE, #form.RHCAid# as RHCAid"/>
			<cfinvokeargument name="desplegar" value="CScodigo, CSdescripcion, CSsalariobaseimg, CSorden"/>
			<cfinvokeargument name="etiquetas" value="#LB_CODIGO#, #LB_DESCRIPCION#,#LB_SalarioBase#,#LB_Orden#"/>
			<cfinvokeargument name="formatos" value="V, V, V, V"/>
			<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# and CAid = #Form.RHCAid# #filtro# order by CSsalariobase desc, CScodigo, CSdescripcion"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="align" value="left, left, center, center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="Componentes.cfm"/>
			<cfinvokeargument name="keys" value="CSid"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="EmptyListMsg" value="#MSG_NoSeHanAgregadoComponentesAEsteGrupo#"/>
		</cfinvoke>
		</td>
		<td valign="top">&nbsp;&nbsp;&nbsp;</td>
    <td valign="top">




		<!--- Mantenimiento --->
		<form action="SQLComponentes.cfm" name="form1" method="post" onsubmit="JAVASCRIPT:__finalizar();">
			<cfif modo neq 'ALTA'>
				<input type="hidden" name="CIid" value="<cfoutput>#rsForm.CIid#</cfoutput>" />
			</cfif>
		<table width="100%"  border="0" cellspacing="0" cellpadding="1">
		<tr>
		<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="right"><strong><cfoutput>#LB_CODIGO#</cfoutput>&nbsp;:</strong></td>
			<td>
			<input name="CScodigo" type="text" value="<cfif MODO neq 'ALTA'><cfoutput>#Trim(rsForm.CScodigo)#</cfoutput></cfif>" tabindex="1" size="5" maxlength="5" onfocus="javascript:this.select();" alt="El C&oacute;digo de Acci&oacute;n" >
			</td>
		</tr>
		<tr>
			<td align="right"><strong><cfoutput>#LB_DESCRIPCION#</cfoutput>&nbsp;:</strong></td>
			<td><input name="CSdescripcion" type="text" tabindex="1" value="<cfif MODO neq 'ALTA'><cfoutput>#rsForm.CSdescripcion#</cfoutput></cfif>" size="70" maxlength="80" onfocus="javascript:this.select();" alt="La Descripci&oacute;n" ></td>
		</tr>
		<tr>
			<td align="right"><strong><cf_translate key="LB_Comportamiento">Comportamiento</cf_translate>:</strong></td>
			<td>
				<select name="CSusatabla" id="CSusatabla" tabindex="1" onchange="javascript: if (window.funcCSusatabla) funcCSusatabla(this);">
					<option value="0" <cfif MODO neq 'ALTA' and rsForm.CSusatabla eq 0>selected</cfif>><cf_translate key="CMB_MontoFijo">Monto Fijo</cf_translate></option>
					<option value="1" <cfif MODO neq 'ALTA' and rsForm.CSusatabla eq 1>selected</cfif>><cf_translate key="CMB_UsaTabla">Usa Tabla</cf_translate></option>
					<option value="2" <cfif MODO neq 'ALTA' and rsForm.CSusatabla eq 2>selected</cfif>><cf_translate key="CMB_MetodoDeCalculo">M&eacute;todo de C&aacute;lculo</cf_translate></option>
					<cfif usaEstructuraSalarial>
						<option value="3" <cfif MODO neq 'ALTA' and rsForm.CSusatabla eq 3>selected</cfif>><cf_translate key="CMB_Regla">Regla</cf_translate></option>
						<option value="4" <cfif MODO neq 'ALTA' and rsForm.CSusatabla eq 4>selected</cfif>><cf_translate key="CMB_CalRegla">M&eacute;todo de C&aacute;lculo y Regla</cf_translate></option>
					</cfif>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right"><strong><cf_translate key="LB_Complemento">Complemento</cf_translate>:</strong></td>
			<td colspan="3">
				<input name="CScomplemento" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsForm.CScomplemento)#</cfoutput></cfif>" size="50" maxlength="100" style="text-align:left" onkeyup="if(snumber_2(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onblur="javascript:fm_2(this,0);" onfocus="javascript:this.select();"  >
			</td>
		</tr>

		<tr>
			<td nowrap align="right"><strong><strong><cf_translate key="LB_OrdenDeCalculo">Orden de C&aacute;lculo</cf_translate>:</strong></td>
			<td colspan="3">
				<input type="text" name="CSorden" tabindex="1"
				size="15"
				maxlength="18"
				onfocus="this.value=qf(this); this.select();"
				onblur="javascript: fm(this,0);"
				onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
				value="<cfif MODO NEQ "ALTA"><cfoutput>#LSNumberFormat(rsForm.CSorden,'9')#</cfoutput><cfelse>10</cfif>">
			</td>
		</tr>
        <tr>
        	<cfoutput>
			<td align="right" ><strong>#MSG_ConceptoSAT#:</strong></td>
            <td colspan="3">
                <cfquery name="rsConceptoSAT" datasource="#session.DSN#">
                    select RHCSATid,RHCSATcodigo,RHCSATdescripcion from dbo.RHCFDIConceptoSAT
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    and RHCSATtipo = 'P'
                    order by RHCSATcodigo
                </cfquery>
                <select name="ConceptoSAT" id="ConceptoSAT">
                    <option value=0>-<cf_translate key="LB_seleccionar" xmlfile="/rh/generales.xml">seleccionar</cf_translate> -</option>
                    <cfloop query="rsConceptoSAT">
                        <option value="#rsConceptoSAT.RHCSATid#" <cfif modo NEQ "ALTA" and rsConceptoSAT.RHCSATid eq rsForm.RHCSATid>selected</cfif> >#rsConceptoSAT.RHCSATcodigo# #rsConceptoSAT.RHCSATdescripcion#</option>
                    </cfloop>
                </select>
            </td>
            </cfoutput>
        </tr>
		<cfif rsEmpresa.RecordCount NEQ 0 OR (LEN(TRIM(InterfazCatalogos)) and InterfazCatalogos EQ 1)>
			<cfoutput>
			<tr>
				<td align="right" width="25%"><strong><cf_translate  key="LB_Clave">Clave</cf_translate>:</strong></td>
				<td>
					<input name="CSclave" type="text" size="6" tabindex="1" maxlength="4" value="<cfif MODO NEQ 'ALTA'>#rsForm.CSclave#</cfif>" />
				</td>
			</tr>
			<tr>
				<td align="right" width="25%"><strong><cf_translate  key="LB_CodigoExterno">C&oacute;digo Externo</cf_translate>:</strong></td>
				<td><input name="CScodigoext" type="text" size="6" maxlength="10" tabindex="1" value="<cfif MODO NEQ 'ALTA'>#TRIM(rsForm.CScodigoext)#</cfif>" /></td>
			</tr>
			</cfoutput>
		</cfif>

		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="1%" valign="baseline">
							<input name="CSexcluyeCB" id="CSexcluyeCB" tabindex="1" type="checkbox" <cfif MODO neq 'ALTA' and rsForm.CSexcluyeCB eq 1>checked</cfif> value="checkbox">
						</td>
						<td valign="middle">
							<label for="CSexcluyeCB">
								<strong>
									<cfoutput><cf_translate key="CHK_SalarioBase">Excluye Componente Base</cf_translate></cfoutput>
								</strong>
							</label>
						</td>
					</tr>
				</table>

			</td>
		</tr>

		<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="1%" valign="baseline"><input name="CSsalariobase" id="CSsalariobase" tabindex="1" type="checkbox" <cfif MODO neq 'ALTA' and rsForm.CSsalariobase eq 1>checked</cfif> value="checkbox" onclick="javascript: lockConcepto(this.checked); pagos(this);"></td>
					<td valign="middle"><label for="CSsalariobase"><strong><cfoutput><cf_translate key="CHK_SalarioBase">Salario Base</cf_translate></cfoutput></strong></label></td>
				</tr>
			</table>
		</td></tr>

		<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="1%" valign="baseline"><input name="CSpagohora" id="CSpagohora" tabindex="1" type="checkbox" <cfif MODO neq 'ALTA' and rsForm.CSpagohora eq 1>checked</cfif> <cfif MODO neq 'ALTA' and rsForm.CSsalariobase eq 1>disabled="disabled"</cfif>  value="checkbox" ></td>
					<td valign="middle"><label for="CSpagohora"><strong><cf_translate key="CHK_ConsideradoParaCalculoDePagosPorHora">Considerado para c&aacute;lculo de pagos por hora</cf_translate></strong></label></td>
				</tr>
			</table>
		</td></tr>

		<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="1%" valign="baseline"><input name="CSpagodia" id="CSpagodia" tabindex="1" type="checkbox" <cfif MODO neq 'ALTA' and rsForm.CSpagodia eq 1>checked</cfif> <cfif MODO neq 'ALTA' and rsForm.CSsalariobase eq 1>disabled="disabled"</cfif> value="checkbox" ></td>
					<td valign="middle"><label for="CSpagodia"><strong><cf_translate key="CHK_ConsideradoParaCalculoDePagosPorDia">Considerado para c&aacute;lculo de pagos por d&iacute;a</cf_translate></strong></label></td>
				</tr>
			</table>
		</td></tr>

				<cfif modo neq 'ALTA'>
			<cfquery name="ligados" datasource="#session.DSN#">
				select CIcodigo, CIdescripcion
				from CIncidentes
				where CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
				and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CIid#">
			</cfquery>
		</cfif>
		<tr id="trConceptos">
			<td nowrap></td>
			<td nowrap>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="1%" valign="baseline"><input onclick="javascript: ModoSalarioEspecie(this)" name="CSdesglosar" id="CSdesglosar" <cfif modo neq 'ALTA'>disabled="disabled"</cfif> <cfif modo neq 'ALTA' and ligados.recordcount gt 0>checked="checked"</cfif>  tabindex="1" type="checkbox" value="checkbox"></td>
						<td valign="middle"><label for="CSdesglosar"><strong>&nbsp;<cf_translate key="CHK_DesglozarPagoEnIncidencias">Desglozar pago en incidencias</cf_translate></strong></label></td>
					</tr>
				</table>
			</td>
		</tr>
		<cfif modo neq 'ALTA' and ligados.recordcount GT 0>
			<tr>
				<td></td>
				<td >
					<cfoutput>
					<strong><cf_translate key="CHK_ConceptoIncidenteAsociado">Concepto Incidente asociado</cf_translate>: #trim(ligados.CIcodigo)# - #trim(ligados.CIdescripcion)#</strong>
					</cfoutput>
				</td>
			</tr>
		</cfif>
		<cfif usaEstructuraSalarial>
        	<tr>
                <td>&nbsp;</td>
                <td>
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="1%" valign="baseline"><input name="CSreplica" id="CSreplica" tabindex="1" type="checkbox" <cfif MODO neq 'ALTA' and rsForm.CSreplica eq 1>checked</cfif> <cfif MODO neq 'ALTA' and rsForm.CSsalariobase eq 1>disabled="disabled"</cfif>  value="checkbox" ></td>
                            <td valign="middle"><label for="CSreplica"><strong><cf_translate key="CHK_ReplicarCambioRecargos">Replicar Cambio en ampliaciones</cf_translate></strong></label></td>
                        </tr>
                    </table>
                </td>
           	</tr>
        </cfif>
		<td>&nbsp;</td>
		<td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="1%" valign="baseline"><input onclick="javascript: ModoSalarioEspecieQuincena(this)" name="CSsalarioEspecie" id="CSsalarioEspecie" tabindex="1" type="checkbox" <cfif MODO neq 'ALTA' and rsForm.CSsalarioEspecie eq 1>checked</cfif> value="checkbox" ></td>
					<td valign="middle" title="Refleja en monto del componente, sin que el mismo sea tomado en cuenta en los calculos de las cargas."><label for="CSsalarioEspecie"><strong><cf_translate key="CHK_SalarioEspecie">Salario Especie</cf_translate></strong></label> <strong><label title="Refleja en monto del componente, sin que el mismo sea tomado en cuenta en los calculos de las cargas.">?</label></strong></td>
                    <td width="1%" valign="baseline"><input name="salarioEspeciePrimera" id="salarioEspeciePrimera" type="checkbox" <cfif MODO neq 'ALTA' and rsForm.CSsalarioEspecieQuin eq 1>checked</cfif> value="checkbox"></td>
					<td valign="middle"><label for="lblsalarioEspeciePrimera"><strong><cf_translate key="CHK_SalarioEspeciePrimera">Primera Quincena</cf_translate></strong></label></td>
                    <td width="1%" valign="baseline"><input name="salarioEspecieSegunda" id="salarioEspecieSegunda" type="checkbox" <cfif MODO neq 'ALTA' and rsForm.CSsalarioEspecieQuin eq 2>checked</cfif> value="checkbox"></td>
					<td valign="middle"><label for="lblsalarioEspecieSegunda"><strong><cf_translate key="CHK_SalarioEspecieSegunda">Segunda Quincena</cf_translate></strong></label></td>
				</tr>
			</table>
		</td></tr>


		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center">
			<input name="RHCAid" type="hidden" value="<cfoutput>#Form.RHCAid#</cfoutput>">
			<input name="PAGENUMPADRE" type="hidden" value="<cfoutput>#Form.PAGENUMPADRE#</cfoutput>">
			<input name="PAGENUM" type="hidden" value="<cfoutput>#Form.PAGENUM#</cfoutput>">
			<cfif (MODO neq "ALTA")>
				<input type="hidden" name="CSid" value="<cfoutput>#rsForm.CSid#</cfoutput>">
				<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
			</cfif>

			<cfif (MODO neq "ALTA") and (ListFind("2",rsForm.CSusatabla) or (ListFind("1",rsForm.CSusatabla) and rsForm.CSsalariobase NEQ 1))>
				<cf_botones modo="#MODO#" tabindex="1" include="Regresar" includevalues="#BTN_REGRESAR#,#BTN_METODOS#">
			<cfelseif  (MODO neq "ALTA") and (ListFind("3",rsForm.CSusatabla) or ListFind("4",rsForm.CSusatabla)) and rsForm.CSsalariobase NEQ 1>
				<cf_botones modo="#MODO#" tabindex="1" include="Regresar,Reglas" includevalues="#BTN_REGRESAR#,#BTN_REGLAS#">
			<cfelse>
				<cf_botones modo="#MODO#" tabindex="1" include="#BTN_REGRESAR#">
			</cfif>
		</td></tr>
		</table>
		<br>
		<table width="0%" align="center" border="0" cellspacing="0" cellpadding="2" class="Ayuda">
			<tr>
				<td width="400" valign="top">
				<cf_translate key="AYUDA_Desglozar">
					 <strong>Desglozar : </strong>&nbsp; Esta opci&oacute;n genera autom&aacute;ticamente un concepto incidente de tipo importe y lo asocia al componente.  En el c&aacute;lculo de la n&oacute;mina estos componentes se ver&aacute;n reflejados como incidencias.
				 </cf_translate>
				 </td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td width="400" valign="top">
					<cf_translate key="AYUDA_Comportamiento">
						<strong>Comportamiento : </strong>&nbsp;          permitir&aacute; al usuario determinar como desea que se presente el componente, en la captura dentro de la acci&oacute;n de personal.
						Dos comportamientos especiales son: <strong>Usa Tabla</strong>, permitir&aacute; asociar este componente con un detalle de tabla salarial, <strong>M&eacute;todo de C&aacute;lculo</strong>, permitir&aacute; asociar un detalle al componente, con el cual podr&aacute; determinar  un c&aacute;lculo especial por medio de un Concepto de Pago Incidente tipo c&aacute;lculo.
					</cf_translate>
					</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td width="400" valign="top">
					<cf_translate key="AYUDA_SalarioBase">
						<strong>Salario Base : </strong>&nbsp; Identificar&aacute; este componente como un concepto de salario base. Si marca este componente como salario base, el actual ser&aacute; desmarcado. Este componente ser&aacute; el &uacute;nico de este tipo para toda la empresa sin importar el grupo.
					</cf_translate>
				</td>
			</tr>
			<cfif (MODO neq "ALTA") and (ListFind("2",rsForm.CSusatabla) or (ListFind("1",rsForm.CSusatabla) and rsForm.CSsalariobase NEQ 1))>
			<tr><td>&nbsp;</td></tr>
			</cfif>
		</table>
		</form>
		</td>
  </tr>
</table>
<!--- JavaScript:Virus --->
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSN_El"
	Default="El"
	returnvariable="MSN_El"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSN_NoPuedeExistirOtroComponenteSalarialConElMismoCodigo"
	Default=" ya existe, no puede existir otro Componente Salarial con el mismo Código."
	returnvariable="MSN_NoPuedeExistirOtroComponenteSalarialConElMismoCodigo"/>


	function _Field_isCodeExistence(){
		if (this.obj.value != "") {
			<cfoutput query="rsCodigos">
				if (this.obj.value=="#Trim(rsCodigos.CScodigo)#"
				<cfif MODO neq "ALTA">
					&& this.obj.value != "#Trim(rsForm.CScodigo)#"
				</cfif>
				){
					this.error = "#MSN_El#" + this.description + " #MSN_NoPuedeExistirOtroComponenteSalarialConElMismoCodigo#";
				}
			</cfoutput>
		}
	}

	_addValidator("isCodeExistence", _Field_isCodeExistence);

	/*Descriciones*/
	<cfoutput>



		objForm.CScodigo.description="#JSStringFormat('#MSN_CodigoDeComponenteSalarial#')#";
		objForm.CSdescripcion.description="#JSStringFormat('#MSG_DigiteLaDescripcion#')#";
		objForm.CSusatabla.description="#JSStringFormat('#MSG_Comportamiento#')#";
		objForm.CSsalariobase.description="#JSStringFormat('#MSG_SalarioBase#')#";
		<cfif modo neq 'ALTA'>
		objForm.CIid.description="#JSStringFormat('#MSG_ComponenteSalarial#')#";
		</cfif>
	</cfoutput>

	/* Reglas de CSsalariobase
	1. Debe existir SIEMPRE 1 registro con este campo marcado.
	2. No se puede borrar el registro que tenga este campo marcado.
	*/
	<cfif rsCodigos.RecordCount eq 0>
		objForm.CSsalariobase.obj.checked = true;
		objForm.CSsalariobase.obj.disabled = true;
	<cfelseif rsCodigos.RecordCount gt 0 and MODO neq 'ALTA' and rsForm.CSsalariobase eq 1>
		objForm.CSsalariobase.obj.disabled = true;
		objForm.Baja.obj.disabled = true;
	</cfif>


	<!---
 	  *** modificado por danim, 03-ene-2005, para que sea posible marcar un componente
	  *** que no es salario base como tal.
	  RHDACCIO
	<cfif (MODO NEQ "ALTA") And (rsForm.CSsalariobase neq 1) >
		objForm.CSsalariobase.obj.disabled = true;
	</cfif>
	--->

	/* Reglas de CSusatabla
	1. No se puede modificar.
	*/
	<cfif MODO EQ "CAMBIO">
	objForm.CSusatabla.obj.disabled = true;
	</cfif>

	/*Validaciones Especiales*/
	objForm.CScodigo.validateCodeExistence();

	/*Validaciones en OnBlur*/
	objForm.CScodigo.validate = true;

	/*Focus*/
	objForm.CScodigo.obj.focus();

	function funcRegresar(){
		deshabilitarValidacion();
		objForm.obj.action = "GComponentes.cfm";
		objForm.PAGENUM.obj.value = objForm.PAGENUMPADRE.getValue();
		return true;
	}

	/*Funciones JavaScript*/

	function deshabilitarValidacion(){
		objForm.CScodigo.required = false;
		objForm.CSdescripcion.required = false;
		objForm.CSusatabla.required = false;
	}

	function habilitarValidacion(){
		objForm.CScodigo.required = true;
		objForm.CSdescripcion.required = true;
		objForm.CSusatabla.required = true;
	}

	function __finalizar(){

		//objDA.style.display = 'none';
		objForm.CScodigo.obj.disabled = false;
		objForm.CSusatabla.obj.disabled = false;
		objForm.CSsalariobase.obj.disabled = false;
		objForm.CSpagohora.obj.disabled = false;
		objForm.CSpagodia.obj.disabled = false;
		objForm.CSsalarioEspecie.obj.disabled = false;

	}

	function LimpiarCTA() {
	}



	function funcMetodos(){
		if (!objForm.CSid || objForm.CSid.getValue() == '') {
			alert("<cfoutput>#JSStringFormat('#MSG_DebeSeleccionarUnComponenteParaPoderDarMantenimientoASusMetodos#')#</cfoutput>");
			return false;
		}
		deshabilitarValidacion();
		objForm.obj.action = "Metodos.cfm";
		return true;
	}


	function funcReglas(){
		deshabilitarValidacion();
		objForm.obj.action = "ReglasComponentes.cfm";
		return true;
	}


	function funcCSusatabla(o){
		if (o.value==2){
			objForm.CSsalariobase.obj.checked = false;
			objForm.CSsalariobase.obj.disabled = true;
		}else{
			objForm.CSsalariobase.obj.disabled = false;
		}
	}

	function pagos(obj){
		if (obj.checked){
			document.form1.CSpagohora.checked = true;
			document.form1.CSpagodia.checked = true;
			document.form1.CSpagohora.disabled = true;
			document.form1.CSpagodia.disabled = true;
		}
		else{
			document.form1.CSpagohora.disabled = false;
			document.form1.CSpagodia.disabled = false;
		}
	}


	/*Campos Requeridos*/
	habilitarValidacion();
	<cfif modo EQ "CAMBIO">
		lockConcepto(document.form1.CSsalariobase.checked);
	</cfif>

	//-->


	/* VALIDACION DE CAMPOS NUMERICOS */
	function fm_2(campo,ndec){
		var s = "";
		if (campo.name){
			s=campo.value
		}
		else{
			s=campo
		}

		if( s=='' && ndec>0 ){
			s='0'
		}

	   var nc=""
	   var s1=""
	   var s2=""

		if (s != '') {
			str = new String("")
			str_temp = new String(s)
			t1 = str_temp.length
			cero_izq = false

			if (t1 > 0) {
				for(i=0;i<t1;i++) {
					c = str_temp.charAt(i)
					str += c
				}
			}

			t1 = str.length
			p1 = str.indexOf(".")
			p2 = str.lastIndexOf(".")

			if ((p1 == p2) && t1 > 0){

				if (p1>0){
					str+="00000000"
				}
				else{
					str+=".0000000"
				}

				p1 = str.indexOf(".")
				s1 = str.substring(0,p1)
				s2 = str.substring(p1+1,p1+1+ndec)
				t1 = s1.length
				n = 0

				for(i=t1-1;i>=0;i--) {
					c=s1.charAt(i)
					if (c == ".") { flag=0;nc="."+nc;n=0 }

					if (c>="0" && c<="9") {
					if (n < 2) {
					   nc = c+nc;
					   n++;
					}
					else {
						n=0
						nc=c+nc
						if (i > 0){
							nc = nc
						 }
					}
				}
			}
			if (nc != "" && ndec > 0)
				nc+="."+s2
			}
			else {ok=1}
		}

		if(campo.name) {
			if(ndec>0) {
				campo.value=nc
			}
			else {
				campo.value=qf(nc)
			}
		}
		else {
			return nc
		}
	}

	function snumber_2(obj,e,d){
		str= new String("")
		str= obj.value
		var tam=obj.size
		var t=Key(e)
		var ok=false

		if(tam>d) {tam=tam-d}
		if(tam>1) {tam=tam-1}

		if(t==9 || t==8 || t==13 || t==20 || t==27 || t==45 || t==46)  return true;

		// acepta guiones
		//if(t==109 || t==189)  return true;

		if(t>=16 && t<=20) return false;
		if(t>=33 && t<=40) return false;
		if(t>=112 && t<=123) return false;
		if(!ints(str,tam)) obj.value=str.substring(0,str.length-1)
		if(!decimals(str,d)) obj.value=str.substring(0,str.length-1)

		if(t>=48 && t<=57)  ok=true
		if(t>=96 && t<=105) ok=true
		//if(d>=0) {if(t==188) ok=true} //LA COMA

		if(d>0)
		{
		if(t==110) ok=true
		if(t==190) ok=true
		}

		if(!ok){
			str=fm_2(str,d)
			obj.value=str
		}

		return true
	}

	function funcLC(m)
	{
		if (m==	true){
			var LvarMet= document.getElementById('met');
			LvarMet.style.display = '';
		}
		if (m==	false){
			var LvarMet= document.getElementById('met');
			LvarMet.style.display = 'none';
		}
	}


	function ModoSalarioEspecie(chk){
		if( chk.checked ){
			document.form1.CSsalarioEspecie.disabled = false ;
		}
		else{
			document.form1.CSsalarioEspecie.checked = false;
			document.form1.CSsalarioEspecie.disabled = true;
		}
	}

	ModoSalarioEspecie( document.getElementById('CSdesglosar') );


	function ModoSalarioEspecieQuincena(chk){
		if( chk.checked ){
			document.form1.salarioEspeciePrimera.disabled = false ;
			document.form1.salarioEspecieSegunda.disabled = false ;
		}
		else{
			document.form1.salarioEspeciePrimera.checked = false;
			document.form1.salarioEspeciePrimera.disabled = true;
			document.form1.salarioEspecieSegunda.checked = false;
			document.form1.salarioEspecieSegunda.disabled = true;
		}
	}

	ModoSalarioEspecieQuincena( document.getElementById('CSsalarioEspecie') );

</script>