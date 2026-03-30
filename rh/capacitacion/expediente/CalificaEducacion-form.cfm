<cfset modoCalifEdu = "ALTA">
<cfif isdefined("form.RHECEid") and len(trim(form.RHECEid))>
	<cfset modoCalifEdu = "CAMBIO">
</cfif>
<cfif modoCalifEdu neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">		
		select RHECEid,DEid,a.RHCEDid,RHCEDNivel,RHECEnota,RHECEfdesde,RHECEfhasta,RHECEaplicada,a.ts_rversion
		from RHEmpleadoCalificaEd a
		inner join RHCalificaEduc b
			on b.RHCEDid = a.RHCEDid
			and b.Ecodigo = a.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and RHECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECEid#">
	</cfquery>
</cfif>
<cfoutput>
<form name="formCalifEdu" action="CalificaEducacion-sql.cfm" method="post">
	<input type="hidden" name="DEid" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">
	<input name="sel" type="hidden" value="1">
	<input type="hidden" name="o" value="3">		
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td colspan="100%">&nbsp;</td></tr>
    	<tr>
			<td width="25%" align="right"><strong>#LB_Nivel#:&nbsp;</strong></td>
			<td width="75%">
				<cfset ArrayTIT=ArrayNew(1)>
				<cfif  modoCalifEdu neq 'ALTA' and isdefined("data.RHCEDid") and len(trim(data.RHCEDid))>
					<cfset ArrayAppend(ArrayTIT,data.RHCEDid)>
					<cfset ArrayAppend(ArrayTIT,data.RHCEDNivel)>
				</cfif>
                <cfinvoke component="sif.Componentes.Translate"	method="Translate"
				Key="LB_ListaNotas" Default="Lista de Notas" returnvariable="LB_ListaNotas"/>	
				<cf_conlis
					Campos="RHCEDid,RHCEDNivel,RHCEDPeso"
					Desplegables="N,S,N"
					Modificables="N,N,N"
					Size="0,50,0"
					tabindex="1"
					form="formCalifEdu"
					ValuesArray="#ArrayTIT#" 
					Title="#LB_ListaNotas#"
					Tabla="RHCalificaEduc"
					Columnas="RHCEDid,RHCEDNivel,RHCEDPeso"
					Filtro="Ecodigo = #Session.Ecodigo#"
					Desplegar="RHCEDNivel,RHCEDPeso"
					Etiquetas="#LB_Notas#"
					filtrar_por="RHCEDNivel,RHCEDPeso"
					Formatos="S"
					Align="left"
					Funcion="cargapeso"
					Asignar="RHCEDid,RHCEDNivel,RHCEDPeso"
					Asignarformatos="S,S,S"/>
			</td>
		</tr>
		<tr>
			<td width="25%" align="right"><strong>#LB_Nota#:&nbsp;</strong></td>
			<td width="75%">
				<cfset Lvar_Nota = 0>
				<cfif modoCalifEdu NEQ 'ALTA'><cfset Lvar_Nota = data.RHECEnota></cfif>
				<cf_monto name="RHECEnota" size="5" decimales="2" value="#Lvar_Nota#">%
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<cfif  modoCalifEdu neq 'ALTA' and data.RHECEaplicada EQ 1>
					<cfset Lvar_Incluir = ''>
					<cfset Lvar_Excluir = 'Baja,Cambio'>
				<cfelseif  modoCalifEdu neq 'ALTA' and data.RHECEaplicada EQ 0>
					<cfset Lvar_Incluir = 'Aplicar'>
					<cfset Lvar_Excluir = ''>
				<cfelse>
					<cfset Lvar_Incluir = ''>
					<cfset Lvar_Excluir = ''>
				</cfif>
				<cf_botones modo="#modoCalifEdu#" exclude="#Lvar_Excluir#" include="#Lvar_Incluir#"></td>
			</tr>
	</table>
	<cfif modoCalifEdu neq 'ALTA'>
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="RHECEid" value="#data.RHECEid#">
		<input type="hidden" name="tab" value="4">
	</cfif>

</form>
<cf_qforms objForm="objFormCE" form='formCalifEdu'>
	<cf_qformsrequiredfield args="RHCEDid, #LB_Nivel#">
	<cf_qformsrequiredfield args="RHECEnota, #LB_Nota#">
</cf_qforms>
<script language="javascript1.2" type="text/javascript">
	function cargapeso(){
		document.formCalifEdu.RHECEnota.value = document.formCalifEdu.RHCEDPeso.value
	}
</script>
</cfoutput>
	
	