<cfset modocambio = isdefined("Form.ACLid") and len(trim(Form.ACLid)) GT 0>
<cfif modocambio>
	<cfquery name="rsForm" datasource="#session.dsn#">
    	select a.*,b.ACAfechaIngreso, a.ACLmontoAhorros - a.ACLmontoCreditos as diferencia, b.DEid
		from ACLiquidacion a
		inner join ACAsociados b
			on b.ACAid = a.ACAid
		where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACLid#">
    </cfquery>
	<cfquery name="rsDFormAportes" datasource="#session.DSN#">
		select a.*,c.ACATdescripcion
		from ACDLiquidacion a
		inner join ACAportesAsociado b
			on b.ACAAid = a.ACAAid
		inner join ACAportesTipo c
			on c.ACATid = b.ACATid
		where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACLid#">
		  and a.ACAAid is not null
	</cfquery>
	<cfquery name="rsDFormCreditos" datasource="#session.DSN#">
		select a.*,c.ACCTdescripcion
		from ACDLiquidacion a
		inner join ACCreditosAsociado b
			on b.ACCAid = a.ACCAid
		inner join ACCreditosTipo c
			on c.ACCTid = b.ACCTid
		where ACLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACLid#">
		  and a.ACCAid is not null
	</cfquery>
	<cfset form.ACAid = rsForm.ACAid>
	
</cfif>
<style>
   <!--- Bordes linea  arriba --->
   .Lin_TOP {
     border-top-width: 1px;
     border-top-style: solid;
     border-top-color: #000000;
     border-right-style: none;
     border-bottom-style: none;
     border-left-style: none;
    }

</style>
<cfoutput>
<form action="LiquidacionAsociados-sql.cfm" method="post" name="form1">
	<cfif modocambio>
	    <input type="hidden" name="ACAid" value="#rsForm.ACAid#" />
		 <input type="hidden" name="DEid" value="#rsForm.DEid#" />
		<input type="hidden" name="ACLid" value="#rsForm.ACLid#" />
        <cfset ts = "">	
        <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
                <cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
        </cfinvoke>
        <input type="hidden" name="ts_rversion" value="#ts#">
    </cfif>
    <table align="center" width="800" border="0" cellspacing="0" cellpadding="0">
		<cfif modocambio>
		<cfset Lvar_Activo = 1>
		<tr><td><cfinclude template="../portlets/pAsociado.cfm"></td></tr>	
		<cfelse>
		<tr>
			<td align="right" width="30%"><strong>#LB_Asociado#&nbsp;:&nbsp;</strong></td>
			<td>
				<cf_conlis
				   campos="ACAid,DEid,DEidentificacion,Nombre"
				   desplegables="N,N,S,S"
				   modificables="N,N,S,N"
				   size="0,0,20,40"
				   title="#LB_ListaDeEmpleados#"
				   tabla="DatosEmpleado a
						inner join ACAsociados b
							on b.DEid = a.DEid"
				   columnas="b.ACAid,a.DEid, a.DEidentificacion , {fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )},  ' ' )}, a.DEnombre)} as Nombre"
				   filtro="a.Ecodigo = #session.Ecodigo# 
				   			and ACAestado = 1	  
							and ACAid not in(select ACAid from ACLiquidacion where ACLestado = 0)
				   			order by DEidentificacion"
				   desplegar="DEidentificacion,Nombre"
				   filtrar_por="a.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )},  ' ' )}, a.DEnombre)}"
				   filtrar_por_delimiters="|"
				   etiquetas="#LB_Identificacion#,#LB_Empleado#"
				   formatos="S,S"
				   align="left,left"
				   asignar="ACAid,DEid,DEidentificacion,Nombre"
				   asignarformatos="S,S,S"
				   showemptylistmsg="true"
				   emptylistmsg="-- #LB_NoSeEncontraronRegistros# --"
				   tabindex="1"> 
			</td>
		</tr>
		</cfif>
 		<tr><td>&nbsp;</td></tr>
 	</table>
	<cfif modocambio>
		<table width="800" cellpadding="0" cellspacing="0" align="center">
			<tr>
				<td width="450">
					<table width="450" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td colspan="4">
								<strong><cf_translate key="LB_Estado">Estado</cf_translate>:</strong>
								<cfif rsForm.ACLestado EQ 1><cf_translate key="LB_Aplicada">Aplicada</cf_translate><cfelse><cf_translate key="LB_EnProceso">En Proceso</cf_translate></cfif>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td nowrap="nowrap"><cf_translate key="LB_FechaDeLiquidacion"><strong>Fecha de Ingreso:</strong></cf_translate></td>
							<td>#LSDateFormat(rsForm.ACAfechaIngreso,'dd/mm/yyyy')#</td>
							<td nowrap="nowrap"><cf_translate key="LB_FechaDeLiquidacion"><strong>Fecha de Liquidaci&oacute;n:</strong></cf_translate></td>
							<td>
								<cfset Lvar_Fecha = rsForm.ACLfecha>
								<cfif rsForm.ACLestado NEQ 1>
								<cf_sifcalendario name="ACLfecha" value="#LSDateFormat(Lvar_Fecha,'DD/MM/YYYY')#">
								<cfelse>
								#LSDateFormat(Lvar_Fecha,'DD/MM/YYYY')#
								</cfif>
							</td>
						</tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr><td colspan="4"></td></tr>
						<tr>
							<td colspan="4" align="center">
								<table align="center" width="400" border="1" cellpadding="2" cellspacing="0">
									<!--- ENCABEZADO --->
									<tr class="TituloListas">
										<td width="300"><cf_translate key="LB_Aporte">Aporte</cf_translate></td>
										<td width="100" align="right"><cf_translate key="LB_Monto">Monto</cf_translate></td>
									</tr>
									<cfloop query="rsDFormAportes">
									<tr>
										<td>#ACATdescripcion#</td>
										<td align="right">#LSCurrencyFormat(ACDLmonto,'none')#</td>
									</tr>
									</cfloop>
									<tr class="Lin_TOP">
										<td align="right"><strong><cf_translate key="LB_Total">Total</cf_translate></strong></td>
										<td align="right">#LSCurrencyFormat(rsForm.ACLmontoAhorros,'none')#</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td colspan="4">
								<table align="center" width="400" border="1" cellpadding="2" cellspacing="0">
									<!--- ENCABEZADO --->
									<tr class="TituloListas">
										<td width="300"><cf_translate key="LB_Creadito">Cr&eacute;dito</cf_translate></td>
										<td width="100" align="right"><cf_translate key="LB_Monto">Monto</cf_translate></td>
									</tr>
									<cfloop query="rsDFormCreditos">
									<tr>
										<td>#ACCTdescripcion#</td>
										<td align="right">#LSCurrencyFormat(ACDLmonto,'none')#</td>
									</tr>
									</cfloop>
									<tr class="Lin_TOP">
										<td align="right"><strong><cf_translate key="LB_Total">Total</cf_translate></strong></td>
										<td align="right">#LSCurrencyFormat(rsForm.ACLmontoCreditos,'none')#</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td colspan="4">
								<table align="center" width="400" border="1" cellpadding="2" cellspacing="0">
									<tr>
										<td width="300	"><strong><cf_translate key="LB_Diferencia">Diferencia</cf_translate></strong></td>
										<td width="100" align="right">#LSCurrencyFormat(rsForm.Diferencia,'none')#</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td colspan="4">&nbsp;</td></tr>
					</table>
				</td>
				<td valign="top">
					<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
					<table width="350" cellpadding="5" cellspacing="0">
						<tr>
							<td class="ayuda">
								<strong><cf_translate key="ProcesoLiquidacion">Proceso de Liquidaci&oacute;n</cf_translate></strong><br>
								1. Verificaci&oacute;n de la informaci&oacute;n relacionada con el Asociado, en lo que se refiere a los Aportes y Cr&eacute;ditos.<br><br>	
								2. Verificaci&oacute;n del Pago de los Cr&eacute;ditos del Asociado (Diferencia).<br><br>	
								3. Aplicaci&oacute;n de la Liquidaci&oacute;n. Proceso de Liquidaci&oacute;n de Aportes y Cancelaci&oacute;n de Cr&eacute;ditos.<br><br>
								4. Inactivaci&oacute;n del Asociado.<br><br>
							</td>
						</tr>
					</table>
					<cf_web_portlet_end>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
		<cfif rsForm.ACLestado NEQ 1  >
      		<cf_botones modo="CAMBIO" exclude="Cambio" include="Recalcular,Aplicar,Regresar">
		<cfelse>
			<cf_botones values="Regresar">
		</cfif>
	<cfelse>
		<cf_botones values="Generar">
	</cfif>
</form>
</cfoutput>
<cf_qforms>
	<cfif not modocambio>
	<cf_qformsrequiredfield args="ACAid,#LB_Asociado#">
	</cfif>
<!---     <cf_qformsrequiredfield args="ACAAid,#LB_Aporte#">
    <cf_qformsrequiredfield args="ACARfecha,#LB_Fecha#">
    <cf_qformsrequiredfield args="ACARmonto,#LB_Monto#">
    <cf_qformsrequiredfield args="ACARreferencia,#LB_Referencia#"> --->
</cf_qforms>
<script language="javascript" type="text/javascript">
	function funcNuevo(){
		document.form1.ACLid.value = "";
		document.form1.action = "LiquidacionAsociados.cfm";
	}
	function funcRegresar(){
		document.form1.ACLid.value = "";
		document.form1.action = "LiquidacionAsociados-Lista.cfm";
	}
</script>