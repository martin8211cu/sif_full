
<cfif isdefined("Url.empresa") and Len(Trim(Url.empresa))>
	<cfparam name="Form.empresa" default="#Url.empresa#">
</cfif>
<cfif isdefined("Form.empresa") and Len(Trim(Form.empresa))>
	<cfset LvarEmpresa = Form.empresa>
<cfelse>
	<cfset LvarEmpresa = Session.Ecodigo>
</cfif>
<cfif isdefined("Url.negociado") and Len(Trim(Url.negociado))>
	<cfparam name="Form.negociado" default="#Url.negociado#">
</cfif>
<cfif isdefined("Form.negociado") and Len(Trim(Form.negociado))>
	<cfset LvarNegociado = Form.negociado>
<cfelse>
	<cfset LvarNegociado = 0>
</cfif>
<cfif isdefined("Url.id") and Len(Trim(Url.id))>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.sql") and Len(Trim(Url.sql))>
	<cfparam name="Form.sql" default="#Url.sql#">
</cfif>
<cfif isdefined("Url.formName") and Len(Trim(Url.formName))>
	<cfparam name="Form.formName" default="#Url.formName#">
</cfif>
<html>
<head>
<title>Lista de Componentes Salariales</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>
<cfquery name="rsSalarioBase" datasource="#Session.DSN#">
select CSid as CampoSalarioBase, CSusatabla as usatabla
from ComponentesSalariales
where CSsalariobase = 1
and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfset usaEstructuraSalarial = rsSalarioBase.usatabla>
<cfif isdefined("Form.id") and isdefined("Form.sql")>
	<!--- VERIFICA SI SE SELECCIONÓ UN COMPONENTE Y TIENE REGLAS --->
	<cfif isdefined('form.CSid') and LEN(TRIM(form.CSid)) GT 0 and (( form.sql eq 4 and form.CSusatabla EQ 2) or form.CSusatabla EQ 3 or form.CSusatabla EQ 4)>
		<cfif (isdefined('form.DRCid') and LEN(TRIM(form.DRCid))) or (isdefined('form.Antig') and len(trim(form.Antig)))>
			<cfinclude template="ConlisCompSalarial-sql#Form.sql#.cfm">
			<cfinclude template="ConlisCompSalarial-lista#Form.sql#.cfm">
		<cfelse>
			<cfinclude template="ReglaComponenteSalarial.cfm">
		</cfif>
	<cfelse>
		<cfinclude template="ConlisCompSalarial-sql#Form.sql#.cfm">
		<cfinclude template="ConlisCompSalarial-lista#Form.sql#.cfm">
	</cfif>
    <cfoutput>
	<form name="formFiltro" action="ConlisCompSalarial.cfm" method="post">
    	<input name="sql" type="hidden" value="#form.sql#">
        <input name="id" type="hidden" value="#form.id#">
		<input name="formName" type="hidden" value="#form.formName#">
        <table width="100%" border="0" cellspacing="0" cellpadding="2">
          <tr>
            <td class="tituloAlterno" colspan="3">Seleccione el Componente Salarial que desea Agregar</td>
          </tr>
          <tr>
            <td><input name="filtroCompSal" type="text" value="<cfif isdefined('form.filtroCompSal') and LEN(TRIM(form.filtroCompSal))>#form.filtroCompSal#</cfif>" size="40"></td>
            <td>
                <select name="filtroMetodoCS">
                	<option value="-1" <cfif isdefined('form.filtroMetodoCS') and form.filtroMetodoCS EQ -1>selected</cfif>>Todos</option>
                    <option value="0" <cfif isdefined('form.filtroMetodoCS') and form.filtroMetodoCS EQ 0>selected</cfif>>Monto Fijo</option>
                    <option value="1" <cfif isdefined('form.filtroMetodoCS') and form.filtroMetodoCS EQ 1>selected</cfif>>Usa Tabla</option>
                    <option value="2" <cfif isdefined('form.filtroMetodoCS') and form.filtroMetodoCS EQ 2>selected</cfif>>Usa M&eacute;todo de C&aacute;lculo</option>
                    <option value="3" <cfif isdefined('form.filtroMetodoCS') and form.filtroMetodoCS EQ 3>selected</cfif>>Usa Regla</option>
                    <option value="4" <cfif isdefined('form.filtroMetodoCS') and form.filtroMetodoCS EQ 4>selected</cfif>>Usa M&eacute;todo de C&aacute;lculo y Regla</option>
                </select>
            </td>
            <td><input name="FiltroCS" value="Filtrar" type="button" onClick="javascript: document.formFiltro.submit();"></td>
          </tr>
        </table>
    </form>
    </cfoutput>
	<br>

	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaQuery"
	 returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsComponentes#"/>
		<cfinvokeargument name="desplegar" value="CSdescripcion, Comportamiento"/>
		<cfinvokeargument name="etiquetas" value="Componente Salarial, M&eacute;todo de C&aacute;lculo"/>
		<cfinvokeargument name="formatos" value="S,S"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
		<cfinvokeargument name="formName" value="listaComponentes"/>
		<cfinvokeargument name="MaxRows" value="15"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="EmptyListMsg" value="No quedan ning&uacute;n componente salarial por agregar"/>
		<cfif rsComponentes.recordCount EQ 0>
			<cfinvokeargument name="botones" value="Cerrar"/>
		</cfif>
        <!--- <cfinvokeargument name="filtrar_automatico" value="true">
        <cfinvokeargument name="mostrar_filtro" value="true"> --->
	</cfinvoke>

	<cfif rsComponentes.recordCount EQ 0>
		<script language="javascript" type="text/javascript">
			function funcCerrar() {
				window.close();
				return false;
			}
		</script>
	</cfif>

</cfif>
</body>
</html>
