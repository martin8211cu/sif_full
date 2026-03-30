<cfset modo = "ALTA">
<cfif isdefined("form.RHCEid") and len(trim(form.RHCEid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select a.RHCEid, a.RHCErequisito, a.RHCELimiteInf, a.RHCELimiteSup, a.ts_rversion,a.RHECGid,b.RHECGcodigo,b.RHECGdescripcion
		from RHCalificacionExp a
		left outer join RHECatalogosGenerales b
			on  a.RHECGid = b.RHECGid
			and a.Ecodigo = b.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCEid#">
	</cfquery>
</cfif>

<cfoutput>
<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<form name="formCalificaE" action="CalificacionExperiencia-sql.cfm" method="post">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="right"><strong><cf_translate  key="LB_ValoresDelPuesto">Valores del Puesto</cf_translate>:&nbsp;</strong></td>
			<td>
				<cfset ArrayCAT=ArrayNew(1)>
				<cfif isdefined("data.RHECGid") and len(trim(data.RHECGid))>
					<cfset ArrayAppend(ArrayCAT,data.RHECGid)>
					<cfset ArrayAppend(ArrayCAT,data.RHECGcodigo)>
					<cfset ArrayAppend(ArrayCAT,data.RHECGdescripcion)>
				</cfif>

				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Valores_del_Puesto"
				Default="Valores del Puesto"
				returnvariable="LB_Valores_del_Puesto"/>

				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_codigo"
				Default="C&oacute;digo"
				returnvariable="LB_codigo"/>


				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Descripcion"
				Default="Descripci&oacute;n"
				returnvariable="LB_Descripcion"/>


				<cf_conlis
					Campos="RHECGid,RHECGcodigo,RHECGdescripcion"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,30"
					tabindex="1"
					ValuesArray="#ArrayCAT#"
					Title="#LB_Valores_del_Puesto#"
					Tabla="RHECatalogosGenerales"
					Columnas="RHECGid,RHECGcodigo,RHECGdescripcion"
					Filtro=" Ecodigo = #Session.Ecodigo# and  RHECGid not in (select coalesce(RHECGid,-1) from RHCalificacionExp  where Ecodigo = #Session.Ecodigo#   )  "
					Desplegar="RHECGcodigo,RHECGdescripcion"
					Etiquetas="#LB_codigo#,#LB_Descripcion#"
					filtrar_por="RHECGcodigo,RHECGdescripcion"
					Formatos="S,S"
					Align="left,left"
					form="formCalificaE"
					Asignar="RHECGid,RHECGcodigo,RHECGdescripcion"
					Asignarformatos="S,S,S"/>

			</td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_RequisitoDelPuesto#:&nbsp;</strong></td>
			<td><input type="text" name="RHCErequisito" size="50" maxlength="200" value="<cfif modo neq 'ALTA'>#trim(data.RHCErequisito)#</cfif>" onfocus="this.select();" tabindex="1"></td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_LimiteInferior#:&nbsp;</strong></td>
			<td>
				<cfset Lvar_LimInf = ''>
				<cfif isdefined('data.RHCELimiteInf')><cfset Lvar_LimInf = data.RHCELimiteInf></cfif>
				<cf_monto name="RHCELimiteInf" size="10" decimales="0" value="#Lvar_LimInf#"  tabindex="1">&nbsp;#LB_Annos#
			</td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_LimiteSuperior#:&nbsp;</strong></td>
			<td>
				<cfset Lvar_LimSup = ''>
				<cfif isdefined('data.RHCELimiteSup')><cfset Lvar_LimSup = data.RHCELimiteSup></cfif>
				<cf_monto name="RHCELimiteSup" size="10" decimales="0" value="#Lvar_LimSup#"  tabindex="1">&nbsp;#LB_Annos#
			</td>
		</tr>
		<!--- Botones --->
		<tr><td colspan="2"><cf_botones modo="#modo#"  tabindex="1"></td></tr>
	</table>

	<cfif modo neq 'ALTA'>
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="RHCEid" value="#trim(data.RHCEid)#">
	</cfif>
</form>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Valores_del_Puesto"
Default="Valores del Puesto"
returnvariable="LB_Valores_del_Puesto"/>

</cfoutput>



<cf_qforms objForm="objForm" form='formCalificaE'>
	<cf_qformsrequiredfield args="RHCErequisito, #LB_RequisitoDelPuesto#">
	<cf_qformsrequiredfield args="RHCELimiteInf, #MSG_LimiteInferior#">
	<cf_qformsrequiredfield args="RHCELimiteSup, #MSG_LimiteSuperior#">
	<cf_qformsrequiredfield args="RHECGid, #LB_Valores_del_Puesto#">
</cf_qforms>
