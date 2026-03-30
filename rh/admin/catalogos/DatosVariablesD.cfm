<cfinvoke Key="MSG_ListaDeFactores" Default="Lista de Factores" returnvariable="MSG_ListaDeFactores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_NoSeEncontraronFactores" Default="No se econtraron Factores" returnvariable="MSG_NoSeEncontraronFactores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ListaDeSubfactores" Default="Lista de Subfactores" returnvariable="MSG_ListaDeSubfactores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeEncontraronSubfactores" Default="No se econtraron subfactores" returnvariable="MSG_NoSeEncontraronSubfactores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Factor" Default="Factor" returnvariable="MSG_Factor"component="sif.Componentes.Translate" method="Translate"/>
<cfset vValor = '' >
<cfif dmodo EQ "CAMBIO">		
	<cfquery name="rsDetalle" datasource="#Session.DSN#">
		select 	a.RHDDVlinea,
				a.RHEDVid,
				a.RHDDVcodigo,
				a.RHDDVdescripcion,
				a.RHDDVvalor,
				a.RHDDVorden,				
				a.ts_rversion,
				a.RHDDVvaloracion as valor,
				a.EIid,
                a.RHHFid,
                a.RHHSFid,
                a.RHECgrado
		from RHDDatosVariables a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHEDVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEDVid#">
		  and a.RHDDVlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDDVlinea#">
	</cfquery>
	<cfset vValor = rsDetalle.valor >
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" 
		artimestamp="#rsDetalle.ts_rversion#" 
		returnvariable="tsD">
	</cfinvoke>
</cfif>

<cfoutput>
<table align="center" width="98%" cellspacing="0" cellpadding="0" border="0" >
	<cfif dmodo neq 'ALTA'>
		<input type="hidden" name="ts_rversionD" value="#tsD#">
		<input type="hidden" name="RHDDVlinea" value="#rsDetalle.RHDDVlinea#">
	</cfif> 
	<tr><td width="17%" nowrap>&nbsp;</td></tr>
	<tr>	
		<td nowrap align="right"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</strong></td>
		<td width="8%" nowrap>
			<input type="text" name="RHDDVcodigo" tabindex="1" size="15" maxlength="10" value="<cfif (dmodo EQ "CAMBIO")>#rsDetalle.RHDDVcodigo#<cfelse></cfif>"  alt="El campo Código"></td>		
	</tr>

	<tr>
		<td width="9%" align="right" nowrap><strong><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</strong></td>
		<td width="66%" nowrap>
		<input type="text" name="RHDDVdescripcion" tabindex="1" size="40" value="<cfif (dmodo EQ "CAMBIO")>#rsDetalle.RHDDVdescripcion#<cfelse></cfif>" alt="El campo Descripción"></td>		
	</tr>

	<tr>
		<td nowrap align="right">&nbsp;</td>	
		<td nowrap colspan="5">
			<textarea name="RHDDVvalor" id="RHDDVvalor" tabindex="1" rows="5" style="width: 100%"><cfoutput><cfif dmodo EQ 'CAMBIO'>#rsDetalle.RHDDVvalor#</cfif></cfoutput></textarea>
		</td>	
	</tr>

	<tr>
		<td nowrap align="right"><strong><cf_translate key="LB_Numero_Poliza" XmlFile="/rh/generales.xml">Número Póliza</cf_translate>:&nbsp;</strong></td>
		<td nowrap colspan="5">
			<cf_inputNumber name="RHDDVvaloracion" tabindex="1" value="#vValor#" size="15" enteros="7" decimales="0" comas="false" >
		</td>	
	</tr>

	<cfquery name="rs_exportador" datasource="sifcontrol">
		select EIid, EIcodigo, EIdescripcion 
		from EImportador 
		where EImodulo like 'rh.%' 
		  and EIexporta = 1
	</cfquery>
	<tr>
		<td nowrap align="right"><strong><cf_translate key="LB_Script_de_Exportacion" >Script de Exportaci&oacute;n</cf_translate>:&nbsp;</strong></td>
		<td>
			<select name="EIid" tabindex="1">
				<option value="">- <cf_translate key="CMB_Ninguno">Ninguno</cf_translate> -</option>
				<cfloop query="rs_exportador">
					<option value="#rs_exportador.EIid#" 
						<cfif isdefined("rsDetalle") and trim(rsDetalle.EIid) eq trim(rs_exportador.EIid) >
							selected
						</cfif> >
						#rs_exportador.EIcodigo# - #rs_exportador.EIdescripcion#
					</option>
				</cfloop>
			</select>
		</td>
	</tr>
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="675" default="" returnvariable="UsaGrados"/>
    <cfif len(trim(UsaGrados)) eq 0>
		<cfset UsaGrados = false>
	</cfif>
	<tr <cfif Not UsaGrados>style="display:none"</cfif>>
        <td nowrap align="right"><strong><cf_translate key="LB_Factor">Factor</cf_translate></strong>:&nbsp;</td>
        <td>
            <cfif dmodo neq 'ALTA' and LEN(TRIM(rsDetalle.RHHFid))>
                <cfquery name="rsFactor" datasource="#session.DSN#">
                    select RHHFid,RHHFcodigo,RHHFdescripcion
                    from RHHFactores
                    where RHHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RHHFid#">
                </cfquery>
                <cfset vArrayFactor=ArrayNew(1)>
                <cfset ArrayAppend(vArrayFactor,rsFactor.RHHFid)>
                <cfset ArrayAppend(vArrayFactor,rsFactor.RHHFcodigo)>
                <cfset ArrayAppend(vArrayFactor,rsFactor.RHHFdescripcion)>
            <cfelse><cfset vArrayFactor=ArrayNew(1)></cfif>
            <cf_conlis
                campos="RHHFid,RHHFcodigo,RHHFdescripcion"
                desplegables="N,S,S"
                modificables="N,S,N"
                size="0,10,25"
                title="#MSG_ListaDeFactores#"
                tabla="RHHFactores"
                columnas="RHHFid,RHHFcodigo,RHHFdescripcion"
                desplegar="RHHFcodigo,RHHFdescripcion"
                filtrar_por="RHHFcodigo,RHHFdescripcion"
                etiquetas="#LB_Codigo#, #LB_Descripcion#"
                formatos="S,S"
                align="left,left"
                asignar="RHHFid,RHHFcodigo,RHHFdescripcion"
                asignarformatos="S, S, S"
                showEmptyListMsg="true"
                EmptyListMsg="-- #MSG_NoSeEncontraronFactores# --"
                tabindex="1"
                valuesArray="#vArrayFactor#"
                funcion="fnLimpiar()"
                funcionValorEnBlanco="fnLimpiar()">
        </td>
    </tr>
    <tr <cfif Not UsaGrados>style="display:none"</cfif>>
        <td nowrap align="right"><strong><cf_translate key="LB_SubFactor">Subfactor</cf_translate></strong>:&nbsp;</td>
        <td>
            <cfif dmodo neq 'ALTA' and LEN(TRIM(rsDetalle.RHHFid)) and LEN(TRIM(rsDetalle.RHHSFid))>
                <cfquery name="rsSFactor" datasource="#session.DSN#">
                    select RHHSFid,RHHSFcodigo,RHHSFdescripcion
                    from RHHSubfactores
                    where RHHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RHHFid#">
                      and RHHSFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RHHSFid#">
                </cfquery>
                <cfset vArraySFactor=ArrayNew(1)>
                <cfset ArrayAppend(vArraySFactor,rsSFactor.RHHSFid)>
                <cfset ArrayAppend(vArraySFactor,rsSFactor.RHHSFcodigo)>
                <cfset ArrayAppend(vArraySFactor,rsSFactor.RHHSFdescripcion)>
            <cfelse><cfset vArraySFactor=ArrayNew(1)></cfif>
            <cf_conlis
                campos="RHHSFid,RHHSFcodigo,RHHSFdescripcion"
                desplegables="N,S,S"
                modificables="N,S,N"
                size="0,10,25"
                title="#MSG_ListaDeSubfactores#"
                tabla="RHHSubfactores"
                columnas="RHHSFid,RHHSFcodigo,RHHSFdescripcion"
                filtro="RHHFid = $RHHFid,numeric$"
                desplegar="RHHSFcodigo,RHHSFdescripcion"
                filtrar_por="RHHSFcodigo,RHHSFdescripcion"
                etiquetas="#LB_Codigo#, #LB_Descripcion#"
                formatos="S,S"
                align="left,left"
                asignar="RHHSFid,RHHSFcodigo,RHHSFdescripcion"
                asignarformatos="S, S, S"
                showEmptyListMsg="true"
                EmptyListMsg="-- #MSG_NoSeEncontraronSubfactores# --"
                tabindex="1"
                valuesArray="#vArraySFactor#">
        </td>
    </tr>
    <cfif dmodo neq 'ALTA'><cfset Lvar_Grado = rsDetalle.RHECgrado><cfelse><cfset Lvar_Grado = ''></cfif>
    <tr <cfif Not UsaGrados>style="display:none"</cfif>>
        <td nowrap align="right"><strong><cf_translate key="LB_Grado">Grado</cf_translate></strong>:&nbsp;</td>
        <td><cf_inputNumber name="RHECgrado" tabindex="1" value="#Lvar_Grado#" size="3" enteros="2" decimales="0" comas="false" ></td>
    </tr>
</table>
<script language="JavaScript1.2" type="text/javascript">
	objForm = new qForm("form1");
	objForm.RHHFid.description="#MSG_Factor#";
	
	function fnLimpiar(){
		document.form1.RHHSFid.value = "";
		document.form1.RHHSFcodigo.value = "";
		document.form1.RHHSFdescripcion.value = "";
	}
</script>
</cfoutput>	