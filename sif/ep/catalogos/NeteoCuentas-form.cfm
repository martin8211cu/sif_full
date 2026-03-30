<cfset tipoCuenta = "1">

<cfif isdefined("form.ID_Neteo") and len(trim(form.ID_Neteo))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		SELECT ID_Neteo,TipoAplica
		FROM CGEstrProgCtasNeteo a
		where ID_Neteo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_Neteo#">
			and  ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_Estr#">
	</cfquery>

	<cfquery name="rsFormD" datasource="#session.dsn#">
		SELECT ID_Neteo
			,a.ID_Estr
			,Cuenta1
			,Cuenta2
	        <cfif rsForm.TipoAplica EQ "1"> ,c1.Cformato <cfelse> , p1.CPformato </cfif> Cformato1
	        <cfif rsForm.TipoAplica EQ "1"> ,c2.Cformato <cfelse> , p2.CPformato </cfif> Cformato2
			<cfif rsForm.TipoAplica EQ "1"> ,c1.Cdescripcion <cfelse> , p1.CPdescripcion </cfif> Cdescripcion1
		    <cfif rsForm.TipoAplica EQ "1"> ,c2.Cdescripcion <cfelse> , p2.CPdescripcion </cfif> Cdescripcion2
		    ,a.ts_rversion
		FROM CGEstrProgCtasNeteo a
		 	<cfif isdefined("rsForm.TipoAplica") and rsForm.TipoAplica EQ "1">
			 	left join CContables c1
					on a.Cuenta1 = c1.Ccuenta
				left join CContables c2
					on a.Cuenta2 = c2.Ccuenta
			<cfelse>
				left join CPresupuesto p1
					on a.Cuenta1 = p1.CPcuenta
				left join CPresupuesto p2
					on a.Cuenta2 = p2.CPcuenta
			</cfif>
		where ID_Neteo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_Neteo#">
			and  ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_Estr#">
	</cfquery>

	<cfset modo = "CAMBIO">
	<cfset tipoCuenta = rsForm.TipoAplica>
<cfelse>
	<cfset modo = "ALTA">
	<cfif isdefined("Url.t_cuenta") and Len(Trim(Url.t_cuenta))>
		<cfset tipoCuenta = Url.t_cuenta>
	</cfif>
</cfif>

<cfset LB_Titulo = t.Translate('LB_Titulo','Cuentas a Netear')>
<cfset LB_Codigo = t.Translate('LB_Codigo','C&oacute;digo')>
<cfset LB_TipoAplica = t.Translate('LB_TipoAplica','Aplica para')>
<cfset LB_Descripcion = t.Translate('LB_Descripcion','Cuenta')>
<cfset LB_Meses = t.Translate('LB_Meses','Mes anterior')>
<cfset LB_Cierres = t.Translate('LB_Cierres','Mes cierre año anterior')>
<cfset LB_Grupos = t.Translate('LB_Grupos','Grupos de Grupo')>
<cfset LB_Nota = t.Translate('LB_Nota','Nota')>
<cfset LB_Grupo = t.Translate('LB_Grupo','Grupo Padre')>
<cfset LB_ReferenciaNota = t.Translate('LB_ReferenciaNota','Referencia Nota')>
<cfset LB_GrupoCuentasNinguno = t.Translate('LB_GrupoCuentasNinguno','Ninguno')>

<cfoutput>
	<fieldset>
	<legend><strong>#LB_Titulo#</strong>&nbsp;</legend>
		<form action="NeteoCuentas-sql.cfm" method="post" name="formNeteo" <!--- onSubmit="javascript: return Valida();" --->>

			<table width="80%" align="center" border="0" >
				<tr>
					<td align="left"><strong>#LB_TipoAplica#:</strong></td>
                    <td>
                    	<select id="Tipoaplica" tabindex="1"
							onchange="javascript: submit();" name="Tipoaplica">
							<option value="1" <cfif tipoCuenta EQ "1" > selected </cfif>>Cuentas Contables</option>
							<option value="2" <cfif tipoCuenta EQ "2"> selected </cfif>>Cuentas Presupuesto</option>
						</select>

                    </td>
				</tr>

					<cfset ValuesArray1=ArrayNew(1)>
					<cfset ValuesArray2=ArrayNew(1)>
					<cfif  isdefined("rsFormD") >
							<cfset ArrayAppend(ValuesArray1,rsFormD.Cuenta1)>
							<cfset ArrayAppend(ValuesArray1,rsFormD.Cformato1)>
							<cfset ArrayAppend(ValuesArray1,rsFormD.Cdescripcion1)>
							<cfset ArrayAppend(ValuesArray2,rsFormD.Cuenta2)>
							<cfset ArrayAppend(ValuesArray2,rsFormD.Cformato2)>
							<cfset ArrayAppend(ValuesArray2,rsFormD.Cdescripcion2)>
					</cfif>

				<cfif tipoCuenta EQ "1">

					<tr>
						<td align="left"><strong>#LB_Descripcion#:</strong></td>
	                    <td>
	                    	<cf_conlis title="Lista de Cuentas Contables"
								campos = "Cuenta1, CFormato1, Cdescripcion1"
								desplegables = "N,S,S"
								modificables = "N,S,N"
								size = "0,40,50"
								ValuesArray="#ValuesArray1#"
								tabla="(select Cmayor, Cmovimiento, Ecodigo, Ccuenta Cuenta1,  Cformato Cformato1, Cdescripcion Cdescripcion1 from CContables) t
										inner join CGEstrProgCtaM epcm
											on t.Cmayor = epcm.CGEPCtaMayor
											and epcm.ID_Estr = #Form.fID_Estr#
										left join (select Cuenta from (
												select Cuenta1 Cuenta from CGEstrProgCtasNeteo
												where TipoAplica = 1
												union all
												select Cuenta2 Cuenta from CGEstrProgCtasNeteo
												where TipoAplica = 1
											) as cc) c
										on t.Cuenta1 = c.Cuenta"
								columnas="t.Cuenta1,  t.Cformato1, t.Cdescripcion1"
								filtro="t.Cmovimiento='S' and c.Cuenta is null and t.Ecodigo = #Session.Ecodigo# order by t.Cformato1, Cdescripcion1"
								desplegar="Cformato1, Cdescripcion1"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"
								asignar="Cuenta1, CFormato1, Cdescripcion1"
								asignarformatos="S,S,S"
								showEmptyListMsg="true"
								debug="false"
								form="formNeteo"
								tabindex="1">

	                    </td>
					</tr>
					<tr>
						<td align="left"><strong>#LB_Descripcion#:</strong></td>
						<td colspan="2">
							<cf_conlis title="Lista de Cuentas Contables"
								campos = "Cuenta2, CFormato2, Cdescripcion2"
								desplegables = "N,S,S"
								modificables = "N,S,N"
								size = "0,40,50"
								ValuesArray="#ValuesArray2#"
								tabla="(select Cmayor, Cmovimiento, Ecodigo, Ccuenta Cuenta2,  Cformato Cformato2, Cdescripcion Cdescripcion2 from CContables) t
										inner join CGEstrProgCtaM epcm
											on t.Cmayor = epcm.CGEPCtaMayor
											and epcm.ID_Estr = #Form.fID_Estr#
										left join (select Cuenta from (
												select Cuenta1 Cuenta from CGEstrProgCtasNeteo
												where TipoAplica = 1
												union
												select Cuenta2 Cuenta from CGEstrProgCtasNeteo
												where TipoAplica = 1
											) as cc) c
										on t.Cuenta2 = c.Cuenta"
								columnas="t.Cuenta2,  t.Cformato2, t.Cdescripcion2"
								filtro="t.Cmovimiento='S' and c.Cuenta is null and t.Ecodigo = #Session.Ecodigo# order by t.Cformato2, Cdescripcion2"
								desplegar="Cformato2, Cdescripcion2"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"
								asignar="Cuenta2, CFormato2, Cdescripcion2"
								asignarformatos="S,S,S"
								showEmptyListMsg="true"
								debug="false"
								form="formNeteo"
								tabindex="1">
						</td>
					</tr>
				<cfelse>
					<tr>
						<td align="left"><strong>#LB_Descripcion#:</strong></td>
	                    <td>
	                    	<cf_conlis title="Lista de Cuentas Contables"
								campos = "Cuenta1, Cformato1, Cdescripcion1"
								desplegables = "N,S,S"
								modificables = "N,S,N"
								size = "0,40,50"
								ValuesArray="#ValuesArray1#"
								tabla="(select Cmayor, CPmovimiento, Ecodigo, CPcuenta Cuenta1,  CPformato Cformato1, CPdescripcion Cdescripcion1 from CPresupuesto) t
										inner join CGEstrProgCtaM epcm
											on t.Cmayor = epcm.CGEPCtaMayor
											and epcm.ID_Estr = #Form.fID_Estr#
										left join (select Cuenta from (
												select Cuenta1 Cuenta from CGEstrProgCtasNeteo
												where TipoAplica = 2
												union all
												select Cuenta2 Cuenta from CGEstrProgCtasNeteo
												where TipoAplica = 2
											) as cc) c
										on t.Cuenta1 = c.Cuenta"
								columnas="t.Cuenta1,  t.Cformato1, t.Cdescripcion1"
								filtro="t.CPmovimiento='S' and c.Cuenta is null and t.Ecodigo = #Session.Ecodigo# order by t.Cformato1, Cdescripcion1"
								desplegar="Cformato1, Cdescripcion1"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"
								asignar="Cuenta1, Cformato1, Cdescripcion1"
								asignarformatos="S,S,S"
								showEmptyListMsg="true"
								debug="false"
								form="formNeteo"
								tabindex="1">

	                    </td>
					</tr>
					<tr>
						<td align="left"><strong>#LB_Descripcion#:</strong></td>
						<td colspan="2">
							<cf_conlis title="Lista de Cuentas Contables"
								campos = "Cuenta2, Cformato2, Cdescripcion2"
								desplegables = "N,S,S"
								modificables = "N,S,N"
								size = "0,40,50"
								ValuesArray="#ValuesArray2#"
								tabla="(select Cmayor, CPmovimiento, Ecodigo, CPcuenta Cuenta2,  CPformato Cformato2, CPdescripcion Cdescripcion2 from CPresupuesto) t
										inner join CGEstrProgCtaM epcm
											on t.Cmayor = epcm.CGEPCtaMayor
											and epcm.ID_Estr = #Form.fID_Estr#
										left join (select Cuenta from (
												select Cuenta1 Cuenta from CGEstrProgCtasNeteo
												where TipoAplica = 2
												union all
												select Cuenta2 Cuenta from CGEstrProgCtasNeteo
												where TipoAplica = 2
											) as cc) c
										on t.Cuenta2 = c.Cuenta"
								columnas="t.Cuenta2,  t.Cformato2, t.Cdescripcion2"
								filtro="t.CPmovimiento='S' and c.Cuenta is null and t.Ecodigo = #Session.Ecodigo# order by t.Cformato2, Cdescripcion2"
								desplegar="Cformato2, Cdescripcion2"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"
								asignar="Cuenta2, Cformato2, Cdescripcion2"
								asignarformatos="S,S,S"
								showEmptyListMsg="true"
								debug="false"
								form="formNeteo"
								tabindex="1">
						</td>
					</tr>
				</cfif>
				<tr valign="baseline">
					<td colspan="2" align="center" nowrap>
						<cfif isdefined("form.ID_Neteo")>
							<cf_botones values="Eliminar,Nuevo" tabindex="7">
						<cfelse>
							<cf_botones values="Agregar" tabindex="7">
						</cfif>
					</td>
				</tr>
			</table>

			<cfset ts = "">
            <cfif modo NEQ "ALTA">
                <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsFormD.ts_rversion#" returnvariable="ts">
                </cfinvoke>
                <input type="hidden" name="ID_Neteo" value="#rsFormD.ID_Neteo#" >
				<input type="hidden" name="ID_Estr" value="#rsFormD.ID_Estr#">
                <input type="hidden" name="ts_rversion" value="#ts#" >
			<cfelseif modo EQ "ALTA">
				<input type="hidden" name="ID_Estr" value="#rsTiposRep.ID_Estr#">
            </cfif>
			<iframe name="ifrCambioVal" id="ifrCambioVal" marginheight="0" marginwidth="10" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<!---<cf_qforms form="form4">--->
	<cf_qforms form="formNeteo">
	<script language="javascript1" type="text/javascript">
		objForm.Cuenta1.required=true;
		objForm.Cuenta2.required=true;

	</script>
</cfoutput>