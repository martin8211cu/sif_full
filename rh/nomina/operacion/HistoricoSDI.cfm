<!---<cf_dump var = "#form#">--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>


<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_templatecss>

<cf_navegacion name="RHHmes">
<cf_navegacion name="RHHperiodo">

<form name="form1" action="HistoricoSDI_sql.cfm" method="post">
<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
<!---
	RHHfuente:
		0 indefinido
		1 Automatico (Proceso interno que afecte SDI) ej. Accion de Nombramiento
		2 Manual (SDI Bimestral)
		3 SDI por Aniversario
		4 Accion de Aumento (comportamiento = 6)
 --->
<cfquery name="rsLista" datasource="#session.DSN#">
	SELECT distinct
		a.DEid,
		c.DEidentificacion,
		c.DEnombre #_CAT# ' ' #_CAT# c.DEapellido1 #_CAT# ' ' #_CAT# c.DEapellido2 as NombreEmp,
		a.RHHmonto,
		<cf_dbfunction name="date_format"	args="a.RHHfecha,dd/mm/yyyy hh:mi:ss" >,
		a.RHHperiodo,
		case when a.RHHmes = 1 then 'Enero'
			 when a.RHHmes = 2 then 'Febrero'
			 when a.RHHmes = 3 then 'Marzo'
			 when a.RHHmes = 4 then 'Abril'
			 when a.RHHmes = 5 then 'Mayo'
			 when a.RHHmes = 6 then 'Junio'
			 when a.RHHmes = 7 then 'Julio'
			 when a.RHHmes = 8 then 'Agosto'
			 when a.RHHmes = 9 then 'Setiembre'
			 when a.RHHmes = 10 then 'Octubre'
			 when a.RHHmes = 11 then 'Noviembre'
			 else 'Diciembre' end as RHHmes,
		case
			when a.RHHfuente = 1 then 'Nombramiento'
			when a.RHHfuente = 2 then 'Bimestral'
			when a.RHHfuente = 3 then 'Aniversario'
			when a.RHHfuente = 4 then 'Aumento'
			else 'Indefinido' end as RHHfuente,
		a.Ecodigo,
		a.RHHfecha,
		a.BMUsucodigo,
		a.BMfecha,
		b.Usulogin,
        a.RHHaplicado
	FROM RHHistoricoSDI a
		inner join Usuario b
			on b.Usucodigo = a.BMUsucodigo
		inner join DatosEmpleado c
			on c.DEid = a.DEid
	where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHHfuente <> 3
    <cfif isdefined('form.RHHmes') and len(trim(form.RHHmes))>
    and a.RHHmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHHmes#">
    <cfelseif isdefined('form.RHHmes1') and len(trim(form.RHHmes1))>
    and a.RHHmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHHmes1#">
    </cfif>
    <cfif isdefined('form.RHHperiodo') and len(trim(form.RHHperiodo))>
    and a.RHHperiodo =<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHHperiodo#">
    <cfelseif isdefined('form.RHHperiodo1') and len(trim(form.RHHperiodo1))>
    and a.RHHperiodo =<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHHperiodo1#">
    </cfif>

    <cfif isdefined("form.filtro_NombreEmp") and len(trim(form.filtro_NombreEmp))>
    	and UPPER(c.DEnombre #_CAT# ' ' #_CAT# c.DEapellido1 #_CAT# ' ' #_CAT# c.DEapellido2) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCASE(form.filtro_NombreEmp)#%">
    </cfif>
    <cfif isdefined("form.filtro_DEidentificacion") and len(trim(form.filtro_DEidentificacion))>
    	and upper(c.DEidentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCASE(form.filtro_DEidentificacion)#%">
    </cfif>
	order by RHHaplicado asc,RHHperiodo desc
</cfquery>

<cfif rsLista.RHHaplicado EQ 0>
	<cfset txBotones = 'Eliminar,Aplicar,Regresar'>
<cfelse>
	<cfset txBotones = 'Regresar'>
</cfif>

<input type="hidden" name="RHHmes1" value="<cfoutput>#form.RHHmes#</cfoutput>"  />
<input type="hidden" name="RHHperiodo1" value="<cfoutput>#form.RHHperiodo#</cfoutput>"  />


<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<cfinvoke component="sif.Componentes.TranslateDB"
			method="Translate"
			VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
			Default="Hist&oacute;rico del C&aacute;lculo Salario Base de Cotizaci&oacute;n"
			VSgrupo="103"
			returnvariable="nombre_proceso"/>
			<cf_web_portlet_start titulo="#nombre_proceso#">
				<cfset Regresar = "Acciones-lista.cfm">
				<cfinclude template="/rh/portlets/pNavegacion.cfm">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top"><td>&nbsp;</td></tr>
					<tr valign="top"><td>
						<cfoutput>
						<table width="100%" border="0" cellpadding="2" cellspacing="2">
							<tr valign="top">
								<td align="right"><strong>Usuario:</strong></td>
								<td>#rsLista.Usulogin#</td>
								<td align="right"><strong>Fecha de Corrida:</strong></td>
								<td>#LSDateFormat(rsLista.BMfecha,'dd/mm/yyyy')#</td>
								<td align="right"><strong>Fecha de Calculo:</strong></td>
								<td>#LSDateFormat(rsLista.RHHfecha,'dd/mm/yyyy')#</td>
							</tr>
							<tr valign="top">
								<td align="right"><strong>Periodo:</strong></td>
								<td>#rsLista.RHHperiodo#</td>
								<td align="right"><strong>Mes:</strong></td>
								<td>#rsLista.RHHmes#</td>
								<td align="right"><!--- <strong>Fuente:</strong --->&nbsp;</td>
								<td><!--- #rsLista.RHHfuente# --->&nbsp;</td>
							</tr>
						</table>
						</cfoutput>
					</td></tr>
					<tr valign="top">
						<td align="center">
							<cfinvoke
								component="rh.Componentes.pListas"
								method=	"pListaQuery"
								returnvariable="pListaEmpl">
								<cfinvokeargument name="query" value="#rsLista#"/>
								<cfinvokeargument name="usaAJAX" value="false">
								<cfinvokeargument name="datasource" value="#session.DSN#">
								<cfinvokeargument name="desplegar" value="DEidentificacion,NombreEmp,RHHmonto,RHHfuente,"/>
								<cfinvokeargument name="etiquetas" value="Identificacion,Nombre,Monto,Fuente"/>
								<cfinvokeargument name="align" value="left,left,left,left"/>
								<cfinvokeargument name="formatos" value="S,S,M,S"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="keys" value="RHHfecha,RHHfuente,RHHperiodo,RHHmes"/>
                               	<cfinvokeargument name="Botones" value="#txBotones#"/>
                                <cfinvokeargument name="FormName" value="form1"/>
                                <cfinvokeargument name="incluyeForm" value="true"/>
                                <cfinvokeargument name="MaxRows" value="15"/>
                                <cfinvokeargument name="navegacion" value="#navegacion#"/>
                                <cfinvokeargument name="mostrar_filtro" value="true"/>
                                <cfinvokeargument name="showLink" value="false"/>
                                <cfinvokeargument name="irA" value="HistoricoSDI.cfm"/>
                         	</cfinvoke>
						</td>
					</tr>
					<tr valign="top"> <td>&nbsp;</td></tr>
				</table>
			<cf_web_portlet_end>
		</td>
	</tr>
</table>
</form>
<cf_templatefooter>

