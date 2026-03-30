<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ListaCat" default="Lista de Categor&iacute;as" returnvariable="LB_ListaCat" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="MSG_ListaCat" default="No se Encontraron Categor&iacute;as" returnvariable="MSG_ListaCat" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="MSG_Monto" default="Monto" returnvariable="MSG_Monto" component="sif.Componentes.Translate" method="Translate"/>			
<!--- FIN VARIABLES DE TRADUCCION --->
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<!--- VARIABLES URL --->
<cfif isdefined('url.RHVTid') and not isdefined("form.RHVTid")><cfset form.RHVTid = url.RHVTid></cfif>
<cfif isdefined('url.RHVTidL') and not isdefined("form.RHVTidL")><cfset form.RHTTid = url.RHVTidL></cfif>
<!--- FIN VARIABLES URL --->
<!--- VARIABLES LOCALES --->
<cfset Lvar_TablaT = false>
<!--- FIN VARIABLES LOCALES --->
<!--- VARIABLES FORM --->
<cfif isdefined('form.RHVTidL') and LEN(TRIM(form.RHVTid)) EQ 0>
	<cfset form.RHVTid = form.RHVTidL>
</cfif>
<!--- FIN VARIABLES FORM --->

<!--- CONSULTAS --->
	<!--- CONSULTA SI HAY UNA TABLA DE TRABAJO PARA MODIFICAR --->
	<cfquery name="rsMontosCat" datasource="#session.DSN#">
		select RHCcodigo,RHCmontoFijo as RHMCmontoFijo,a.RHMCid,RHCmontoAnt as RHMCmontoAnt, RHCmontoAnt + RHCmontoFijo as RHMCmonto
		from RHMontosCategoriaT a
		inner join RHCategoria b
			on b.RHCid = a.RHCid
		where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
		  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by RHCcodigo
    </cfquery>
    <cfif rsMontosCat.RecordCount EQ 0>
        <cfquery name="rsMontosCat" datasource="#session.DSN#">
            select RHCcodigo,RHMCmontoFijo,a.RHMCid,RHMCmontoAnt, RHMCmontoAnt + RHMCmontoFijo as RHMCmonto
            from RHMontosCategoria a
            inner join RHCategoria b
                on b.RHCid = a.RHCid
            where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
              and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  order by RHCcodigo
            <!---order by <cf_dbfunction name="to_number" args="RHCcodigo">--->
        </cfquery>
    <cfelse>
    	<!--- INDICADOR DE QUE SE ESTA UTILIZANDO TABLA DE TRABAJO --->
    	<cfset Lvar_TablaT = true>
	</cfif>
	<!--- VERIFICA SI TIENE UNA TABLA BASE--->
	<cfquery name="rsVerifTB" datasource="#session.DSN#">
		select RHVTtablabase,RHVTcodigo, RHVTdescripcion,RHVTfecharige,RHVTfechahasta,RHVTdocumento,RHVTestado,
			case RHVTestado when 'A' then 'Aplicado' when 'P' then 'Pendiente' else RHVTestado end as Estado
		from RHVigenciasTabla
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
	</cfquery>
	<!--- SI NO EXISTE UNA TABLA DE REFERENCIA DEBE PERMITIR INGRESAR LOS MONTOS INCIALES DE SALARIO BASE --->
	<cfif LEN(TRIM(rsVerifTB.RHVTtablabase))>
		<cfset Lvar_ModificaT= false>
	<cfelse>
		<cfset Lvar_ModificaT= true>
	</cfif>
	<cfset Lvar_botones = 'Anterior,Modificar,Siguiente'>
    <cfset Lvar_botonesN = 'Anterior,Modificar,Siguiente'>
	<cfif rsVerifTB.RHVTestado EQ 'A'>
    	<cfif Lvar_TablaT>
        	<cfset Lvar_ModificaT= true>
			<cfset Lvar_botones = 'Anterior,ModificarA,Eliminar,Siguiente'>
            <cfset Lvar_botonesN = 'Anterior,Modificar Copia,Eliminar Copia,Siguiente'>
            <cfset Lvar_botonesF = ',,return confirm("Desea eliminar la tabla?");,'>
            <cfsavecontent variable="EVAL_RIGHT">
                <table width="100%"  border="0" cellspacing="2" cellpadding="0" class="Ayuda">
                    <tr>
                        <td nowrap="nowrap" valign="top"><strong>Modificar Copia:</strong></td>
                        <td><cf_translate key="MSG_CrearCopia">Modifica la copia de la vigencia seleccionada</cf_translate></td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td nowrap="nowrap" valign="top"><strong>Eliminar Copia:</strong></td>
                        <td><cf_translate key="MSG_CrearCopia">Elimina la copia de la vigencia seleccionada, manteniendo la tabla original</cf_translate></td>
                    </tr>
                </table>
        	</cfsavecontent>
        <cfelse>
			<cfset Lvar_botones = 'Anterior,ModificarA,Siguiente'>
            <cfset Lvar_botonesN = 'Anterior,Crear copia,Siguiente'>
            <cfset Lvar_botonesF = ',return confirm("Desea modificar la tabla aplicada?");,'>
            <cfsavecontent variable="EVAL_RIGHT">
                <table width="100%"  border="0" cellspacing="2" cellpadding="0" class="Ayuda">
                    <tr>
                        <td nowrap="nowrap" valign="top"><strong>Crear Copia:</strong></td>
                        <td><cf_translate key="MSG_CrearCopia">Crear una copia de la vigencia seleccionada</cf_translate></td>
                    </tr>
                </table>
        	</cfsavecontent>
        </cfif>

	</cfif>

<!--- FIN CONSULTA --->
<cfset filtro = ''>
<cfset navegacion = "RHTTid=" & Form.RHTTid>
<cfparam name="form.PAGENUM" type="numeric" default="1">
<cfparam name="form.PAGENUMPADRE" default="1">

	<form action="IncrementoFijo-sql.cfm" method="post" name="formIF">
		<input name="SEL" type="hidden" value="" />
		<input name="modo" type="hidden" value="" />
		<input name="modov" type="hidden" value="<cfif isdefined('form.modov') and LEN(TRIM(form.modov))><cfoutput>#form.modov#</cfoutput></cfif>" />
		<input name="RHTTid" type="hidden" value="<cfif isdefined('form.RHTTid')><cfoutput>#form.RHTTid#</cfoutput></cfif>" />
		<input name="RHVTid" type="hidden" value="<cfif isdefined('form.RHVTid')><cfoutput>#form.RHVTid#</cfoutput></cfif>" />
		<input name="RHVTidL" type="hidden" value="<cfif isdefined('form.RHVTidL')><cfoutput>#form.RHVTidL#</cfoutput></cfif>" />
		<input name="RHVTtablabase" type="hidden" value="<cfif isdefined('rsVerifTB') and LEN(TRIM(rsVerifTB.RHVTtablabase))><cfoutput>#rsVerifTB.RHVTtablabase#</cfoutput></cfif>" />
		<cfoutput>
		<table width="80%" cellpadding="2" cellspacing="0" align="center" border="0">
			<tr>
				<td nowrap><strong>&nbsp;</strong></td>
				<td><strong><cf_translate key="LB_Rige">Rige</cf_translate></strong></td>
				<td><strong><cf_translate key="LB_Hasta">Hasta</cf_translate></strong></td>
				<cfif LEN(TRIM(rsVerifTB.RHVTtablabase))><td><strong><cf_translate key="LB_TablaBase">Tabla Base</cf_translate></strong></td></cfif> 
			</tr>
			<tr>
				<td nowrap><strong>&nbsp;</strong></td>
				<td><cf_locale name="date" value="#rsVerifTB.RHVTfecharige#"/></td>
				<td><cfif LEN(TRIM(rsVerifTB.RHVTfechahasta)) and rsVerifTB.RHVTfechahasta LT '01/01/2100'><cfoutput><cf_locale name="date" value="#rsVerifTB.RHVTfechahasta#"/></cfoutput><cfelse>Indefinido</cfif></td>
				<cfif LEN(TRIM(rsVerifTB.RHVTtablabase))><td>#rsVerifTB.RHVTtablabase#</td></cfif> 
			</tr>
			<tr>
				<td nowrap><strong>&nbsp;</strong></td>
				<td nowrap ><strong><cf_translate key="LB_DocAuto">Documento que autoriza</cf_translate></strong></td>
				<td nowrap><strong><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></strong></td>
				<td nowrap><strong><cf_translate key="LB_Estado">Estado</cf_translate></strong></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><cfoutput>#HTMLEditFormat(rsVerifTB.RHVTdocumento)#</cfoutput></td>
				<td><cfoutput>#HTMLEditFormat(rsVerifTB.RHVTdescripcion)#</cfoutput></td>
				<td><cfoutput>#HTMLEditFormat(rsVerifTB.Estado)#</cfoutput></td>
			</tr>
            <tr><td>&nbsp;</td></tr>
            <cfif Lvar_TablaT>
            	<tr><td colspan="4" align="center" style="color:##FF0000; font-size:14px; ">SE ESTA MOSTRANDO UNA COPIA DE LA TABLA</td></tr>
            </cfif>
		</table>
		</cfoutput>
		<table width="85%" cellpadding="2" cellspacing="0" align="center" border="0">
			<tr><td colspan="5" nowrap="nowrap"><cf_botones names="#Lvar_botones#" values="#Lvar_botonesN#"></td></tr>
			<tr bgcolor="#CCCCCC">
				<td>&nbsp;</td>
				<td><strong><cf_translate key="LB_Categoria">Categor&iacute;a</cf_translate></strong></td>
				<td><strong><cf_translate key="LB_SalarioBase">Salario Base</cf_translate></strong></td>
				<td><strong><cf_translate key="LB_IncrementoF">Incremento Fijo</cf_translate></strong></td>
				<td><strong><cf_translate key="LB_SalarioBaseFinal">Salario Base Final</cf_translate></strong></td>
			</tr>
			<cfoutput query="rsMontosCat">
				<tr>
					<td>&nbsp;</td>
					<td>#rsMontosCat.RHCcodigo#</td>
					<td><cf_inputNumber name="RHMCmontoAnt#rsMontosCat.RHMCid#" value="#rsMontosCat.RHMCmontoAnt#" decimales="2" modificable="#Lvar_ModificaT#" tabindex="1" onblur="SumaMonto(this,RHMCmontoFijo#rsMontosCat.RHMCid#,#rsMontosCat.RHMCid#)"></td>
					<td><cf_inputNumber name="RHMCmontoFijo#rsMontosCat.RHMCid#" value="#rsMontosCat.RHMCmontoFijo#" decimales="2" modificable="true" tabindex="1" onblur="SumaMonto(RHMCmontoAnt#rsMontosCat.RHMCid#,this,#rsMontosCat.RHMCid#)"></td>
					<td><cf_inputNumber name="RHMCmonto#rsMontosCat.RHMCid#" value="#rsMontosCat.RHMCmonto#" decimales="2" modificable="false" tabindex="1"></td>
				</tr>
			</cfoutput>
			<tr><td colspan="5">
            <cf_botones names="#Lvar_botones#" values="#Lvar_botonesN#" formName="formIF"></td></tr>
		</table>
	</form>


<script>
	
	function SumaMonto(valor1,valor2,id){
		var monto = 'document.formIF.RHMCmonto' + id;
		eval(monto).value = fm(Number(qf(valor1.value)) + Number(qf(valor2.value)),2);
		return true;
	}	
	
	function funcSiguiente(){
		document.formIF.SEL.value = "4";
		document.formIF.action = "tipoTablasSal.cfm";
		return true;
	}
		function funcAnterior(){
		document.formIF.SEL.value = "2";
		document.formIF.action = "tipoTablasSal.cfm";
		return true;
	}
	
	function funcModificarA(){
		<cfif not Lvar_TablaT>
		if (confirm("Desea modificar la tabla aplicada?")){
			return true;
			}
			return false;
		</cfif>
		}
	function funcModificarA(){
		<cfif not Lvar_TablaT>
		if (confirm("Desea crear una copia de la tabla aplicada?")){
			return true;
			}
			return false;
		</cfif>
		}
	function funcEliminar(){
		if (confirm("Desea eliminar la copia?")){
			return true;
			}
			return false;
		}

</script>