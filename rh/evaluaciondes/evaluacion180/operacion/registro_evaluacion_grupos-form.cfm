<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElGrupoYaExiste"
	Default="El Grupo ya existe."
	returnvariable="MSG_ElGrupoYaExiste"/>
<cfif isdefined("url.GREid") and not isdefined("form.GREid")>
	<cfset form.GREid = url.GREid >
</cfif>
<cfparam name="Lvar_Calificada" default="0">
<cfset modo = 'ALTA'>
<cfif isdefined("form.GREid") and len(trim(form.GREid))>
	<cfset modo = 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select GREnombre, ts_rversion
		from RHGruposRegistroE
		where GREid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GREid#">
	</cfquery>
	
	<cfquery name="rsCalificadosJ" datasource="#session.DSN#">
		select distinct 1
		from RHGruposRegistroE a
		inner join RHCFGruposRegistroE b
			on b.GREid = a.GREid	
		inner join RHRegistroEvaluadoresE c
			on c.REid = a.REid
			and REEfinalj = 1 
		inner join LineaTiempo lt 
			on lt.Ecodigo = c.Ecodigo 
			and lt.DEid = c.DEid 
			and getDate() between lt.LTdesde and lt.LThasta 
		inner join RHPlazas p 
			on p.RHPid = lt.RHPid 
			and p.CFid = b.CFid
		where a.GREid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GREid#">
			and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<cfquery name="rsCalificadosE" datasource="#session.DSN#">
		select distinct 1
		from RHGruposRegistroE a
		inner join RHCFGruposRegistroE b
			on b.GREid = a.GREid	
		inner join RHRegistroEvaluadoresE c
			on c.REid = a.REid
			and REEfinale = 1 
		inner join LineaTiempo lt 
			on lt.Ecodigo = c.Ecodigo 
			and lt.DEid = c.DEid 
			and getDate() between lt.LTdesde and lt.LThasta 
		inner join RHPlazas p 
			on p.RHPid = lt.RHPid 
			and p.CFid = b.CFid
		where a.GREid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GREid#">
			and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<cfif rsCalificadosE.RecordCount>
		<cfset Lvar_Calificada = 1>
	<cfelseif rsCalificadosJ.RecordCount>
		<cfset Lvar_Calificada = 1>
	<cfelse>
		<cfset Lvar_Calificada = 0>
	</cfif>
</cfif>

<cfoutput>
<form name="form1" action="registro_evaluacion_grupos-sql.cfm" method="post" style="margin:0;">
	<input type="hidden" name="REid" value="#form.REid#">
	<input type="hidden" name="sel" value="4">	
	<input type="hidden" name="Estado" value="<cfif isdefined("form.Estado") and form.Estado EQ 1>#form.Estado#<cfelse>0</cfif>">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="GREid" value="#form.GREid#">
	</cfif>
	
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right"><strong><cf_translate key="LB_Grupo">Grupo</cf_translate>:</strong>&nbsp;</td>
			<td>
				<input type="text" name="GREnombre" id="GREnombre" size="50" 
					tabindex="1" maxlength="50" value="<cfif modo neq 'ALTA'>#data.GREnombre#</cfif>">
			</td>
		</tr>
		
		<tr> 
			<td colspan="2" align="center">
				<cfif modo EQ "ALTA">
					<!--- <cfif isdefined("form.Estado") and form.Estado EQ 0> --->
						<cf_botones values="Agregar" names="Alta" tabindex="3">
					<!--- </cfif>					 --->
				<cfelse>	
					<!--- <cfif isdefined("form.Estado") and form.Estado EQ 0> --->
						<cf_botones values="Modificar,Eliminar,Nuevo" names="Cambio,Baja,Nuevo"  tabindex="3">
					<!--- </cfif> --->					
				</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
					<cf_botones values="Anterior,Siguiente" names="Anterior,Siguiente" tabindex="3">
			</td>
		</tr>
	</table>

	<cfif modo neq 'ALTA' and isdefined("data.ts_rversion")>
		<cfset ts = "">
		<cfinvoke 	component="sif.Componentes.DButils"
					method="toTimeStamp"
					returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
	</cfif>

</form>
</cfoutput>

<cf_qforms>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<script type="text/javascript">
	objForm.GREnombre.required = true;
	objForm.GREnombre.description = '<cfoutput>#LB_Descripcion#</cfoutput>';
	
	function funcBaja(){
		var calif = <cfoutput>#Lvar_Calificada#</cfoutput>;
		var mensaje = "";
		if (calif == 1){
			mensaje = "El Grupo tiene Centros funcionales donde hay empleados calificados desea eliminarlo?";
		}else{
			mensaje = "Desea eliminar el grupo?";
		}
		if ( confirm(mensaje) ){
			objForm.GREnombre.required = false;	
			return true;
		}
		return false;
	}
	
	function funcSiguiente(){
		objForm.GREnombre.required = false;
		document.form1.sel.value = '5';
	}
	function funcAnterior(){
		objForm.GREnombre.required = false;
		document.form1.sel.value = '3';
	}
	
</script>

