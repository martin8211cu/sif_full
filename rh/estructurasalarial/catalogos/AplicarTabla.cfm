<cfparam name="form.RHVTid" default="17">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ListaCat" default="Lista de Categor&iacute;as" returnvariable="LB_ListaCat" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="MSG_ListaCat" default="No se Encontraron Categor&iacute;as" returnvariable="MSG_ListaCat" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="MSG_Monto" default="Monto" returnvariable="MSG_Monto" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="MSG_Aplicar" default="Desea aplicar la tabla salarial?" returnvariable="MSG_Aplicar" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="MSG_AplicarC" default="Desea aplicar la copia de la tabla salarial?" returnvariable="MSG_AplicarC" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="MSG_AplicarV" default="Esta apunto de aplicar una tabla salarial con una vigencia ya existente, esto podr�a generar montos retroactivos a pagar en proximas n�minas. Esta seguro que desea continuar?" returnvariable="MSG_AplicarV" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="LB_Aplicado" default="Aplicado" returnvariable="LB_Aplicado" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Pendiente" default="Pendiente" returnvariable="LB_Pendiente"   xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_VigenciaSustituidaConsulta" default="Vigencia Sustituida s�lo consulta" returnvariable="LB_VigenciaSustituidaConsulta" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<!--- VARIABLES URL --->
<cfif isdefined('url.RHVTid') and not isdefined("form.RHVTid")><cfset form.RHVTid = url.RHVTid></cfif>
<cfif isdefined('url.RHTTidL') and not isdefined("form.RHTTidL")><cfset form.RHTTidL = url.RHTTidL></cfif>
<!--- FIN VARIABLES URL --->
<!--- VARIABLES LOCALES --->
<cfset Lvar_TablaT = false>
<cfset Lvar_sufijo = ''>
<!--- FIN VARIABLES LOCALES --->

<!--- CONSULTAS --->
	<!--- CONSULTA SI HAY UNA TABLA DE TRABAJO PARA MODIFICAR --->
	<cf_translatedata name="get" tabla="ComponentesSalariales" col="CSdescripcion" returnvariable="LvarCSdescripcion">
	<cfquery name="rsMontosCat" datasource="#session.DSN#">
		select RHCcodigo,b.RHCdescripcion,a.RHMCid, RHMCmontoAnt,
            coalesce(a.RHMCmonto - a.RHMCmontoAnt,0.00) as RHMCmonto,
            coalesce(a.RHMCmonto,0.00) as RHMCpropuesto,
			 CScodigo, #LvarCSdescripcion# as CSdescripcion
		from RHMontosCategoriaT a
		inner join RHCategoria b
			on b.RHCid = a.RHCid
		inner join ComponentesSalariales cs
			on a.CSid=cs.CSid	
		where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
		  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and RHMCmonto > 0.00
		order by RHCcodigo
        <!---order by <cf_dbfunction name="to_number" args="RHCcodigo">--->
    </cfquery>
    
    <cfif rsMontosCat.RecordCount EQ 0>
        <cfquery name="rsMontosCat" datasource="#session.DSN#">
            select RHCcodigo,b.RHCdescripcion,a.RHMCid,RHMCmontoPorc, RHMCmontoAnt,
            coalesce(RHMCmonto-RHMCmontoAnt,0.00) as RHMCmonto,
            coalesce(RHMCmonto,0.00) as RHMCpropuesto,
			 CScodigo, #LvarCSdescripcion# as CSdescripcion
            from RHMontosCategoria a
            inner join RHCategoria b
                on b.RHCid = a.RHCid
			inner join ComponentesSalariales cs
				on a.CSid=cs.CSid	
            where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
              and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHMCmonto > 0.00
		order by RHCcodigo
        <!---order by <cf_dbfunction name="to_number" args="RHCcodigo">--->
        </cfquery>
    <cfelse>
    	<!--- INDICADOR DE QUE SE ESTA UTILIZANDO TABLA DE TRABAJO --->
    	<cfset Lvar_TablaT = true>
        <cfset Lvar_sufijo = 'T'>
	</cfif>
    
    
    
	<!--- VERIFICA SI TIENE UNA TABLA BASE--->
	<cf_translatedata name="get" tabla="RHVigenciasTabla" col="RHVTdescripcion" returnvariable="LvarRHVTdescripcion">
	<cfquery name="rsVerifTB" datasource="#session.DSN#">
		select RHVTtablabase,RHVTcodigo, #LvarRHVTdescripcion# as RHVTdescripcion,RHVTfecharige,RHVTfechahasta,RHVTdocumento,RHVTestado,
			case RHVTestado when 'A' then '#LB_Aplicado#' when 'P' then '#LB_Pendiente#' when 'C' then '#LB_VigenciaSustituidaConsulta#' else RHVTestado end as Estado
		from RHVigenciasTabla
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
	</cfquery>
	<cfquery name="rsVerif" datasource="#Session.DSN#">
		select  count(1) as Cont
		from RHMontosCategoria#Lvar_sufijo# a
		inner join RHVigenciasTabla b
			on b.RHVTid = a.RHVTid
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
		  <cfif not len(trim(Lvar_sufijo))>
		  	and ((RHMCmontoFijo > 0 or RHMCmontoPorc > 0) 
		  <cfelse>
		  	and ((RHMCmontoFijo > 0 or RHMCmontoPorc > 0) 
		  </cfif>
		  or (select count(1) from RHVigenciasTabla where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and RHVTid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">) = 0) <!--- o si es la primera vez que se agrega la tabla--->
          <cfif not Lvar_TablaT>
		  and b.RHVTestado = 'P'
          </cfif> 
	</cfquery>
	<cfif rsVerif.Cont GT 0>
    	<cfif not Lvar_TablaT>
        
    
   	       <!---se valida la vigencia de la tabla si es igual a una exitente mayor se lee cual version es para actualizar la informacion como una copia de version--->
            <cfquery name="rsExisteVigencia" datasource="#session.DSN#">
                select count(1) as cantRegistros , a.RHVTid
                from RHVigenciasTabla a
                where  RHVTfecharige  <= (select max(RHVTfecharige ) 
                                            from RHVigenciasTabla b					
                                            where b.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
                                            and b.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
                                           )
                    and a.RHTTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
                    and a.RHVTestado = 'A'
                group by  a.RHVTid  
            </cfquery>
            
            <cfif rsExisteVigencia.cantRegistros EQ 0>
				<cfset Lvar_botones = "Anterior,Aplicar">
				<cfset Lvar_botonesN = "Anterior,Aplicar">
            <cfelse>
                <cfset Lvar_botones = "Anterior,AplicarV">
				<cfset Lvar_botonesN = "Anterior,Aplicar">
            </cfif>
		
        <cfelse>
			<cfset Lvar_botones = "Anterior,AplicarC">
			<cfset Lvar_botonesN = "Anterior,Aplicar Copia">
            <cfsavecontent variable="EVAL_RIGHT">
                <table width="100%"  border="0" cellspacing="2" cellpadding="0" class="Ayuda">
                    <tr>
                        <td nowrap="nowrap" valign="top"><strong>Aplicar Copia:</strong></td>
                        <td><cf_translate key="MSG_CrearCopia">Aplica la copia de la vigencia seleccionada.</cf_translate></td>
                    </tr>
                </table>
        	</cfsavecontent>
        </cfif>
	<cfelse>
		<cfset Lvar_botones = "Anterior">
        <cfset Lvar_botonesN = "Anterior">
	</cfif>
<!--- FIN CONSULTA --->

<form action="AplicarTabla-sql.cfm" method="post" name="formAT">
	<input name="SEL" type="hidden" value="" />
	<input name="modo" type="hidden" value="" />
	<input name="modov" type="hidden" value="<cfif isdefined('form.modov') and LEN(TRIM(form.modov))><cfoutput>#form.modov#</cfoutput></cfif>" />
	<input name="RHTTid" type="hidden" value="<cfif isdefined('form.RHTTid')><cfoutput>#form.RHTTid#</cfoutput></cfif>" />
	<input name="RHVTid" type="hidden" value="<cfif isdefined('form.RHVTid')><cfoutput>#form.RHVTid#</cfoutput></cfif>" />
	<input name="RHVTfecharige" type="hidden" value="<cfif isdefined('rsVerifTB')><cfoutput>#rsVerifTB.RHVTfecharige#</cfoutput></cfif>" />
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
				<td><cfif LEN(TRIM(rsVerifTB.RHVTfechahasta)) and rsVerifTB.RHVTfechahasta LT '01/01/2100'><cfoutput><cf_locale name="date" value="#rsVerifTB.RHVTfechahasta#"/></cfoutput><cfelse><cf_translate key="LB_Indefinido" xmlFile="/rh/generales.xml">Indefinido</cf_translate></cfif></td>
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
			<cfif not Lvar_TablaT>
			<tr><td colspan="4" ><input name="chkRelAum" type="checkbox" checked="checked" /><strong><cf_translate key="LB_GenerarRelAumento">Generar Relaci&oacute;n de Aumento</cf_translate></strong></td></tr>
			</cfif>
            <tr><td>&nbsp;</td></tr>
            
            
			<cfif Lvar_TablaT>
            	<tr><td colspan="4" align="center" style="color:##FF0000; font-size:14px; ">SE ESTA MOSTRANDO UNA COPIA DE LA TABLA</td></tr>
            </cfif>
            
		</table>
	</cfoutput>
	<table width="90%" cellpadding="2" cellspacing="0" align="center" border="0">
		<tr><td><cf_botones names="#Lvar_botones#" values="#Lvar_botonesN#" formName="formAT"></td></tr>
		<tr>
			<td>
				<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center">
					<tr bgcolor="#CCCCCC" height="20">
						<td align="center"><strong><cf_translate key="LB_Categoria">Categor&iacute;a</cf_translate></strong></td>
						<td align="center"><strong><cf_translate key="LB_Componente">Componente</cf_translate></strong></td>
						<td align="center"><strong><cf_translate key="LB_MontoAnterior">Monto Anterior</cf_translate></strong></td>
						<td align="center"><strong><cf_translate key="LB_Aumento" xmlFile="/rh/generales.xml">Aumento</cf_translate></strong></td>
						<td align="center"><strong><cf_translate key="LB_MontoPropuesto">Monto Propuesto</cf_translate></strong></td>
					</tr>
					<cfset encabezadoCategoria=''>
					<cfoutput query="rsMontosCat">
						<cfif trim(encabezadoCategoria) neq trim(rsMontosCat.RHCcodigo)><tr><td colspan="10"><hr/></td></tr></cfif>
						<tr>
							<td><strong><cfif trim(encabezadoCategoria) neq trim(rsMontosCat.RHCcodigo)><u>#rsMontosCat.RHCcodigo#</u> - #rsMontosCat.RHCdescripcion#<cfelse>&nbsp;</cfif></strong></td>
							<cfset encabezadoCategoria=trim(rsMontosCat.RHCcodigo)>
							<td align="left"><u>#rsMontosCat.CScodigo#</u> - #rsMontosCat.CSdescripcion#</td>
							<td align="right"><cf_inputNumber name="RHMCmontoAnt#rsMontosCat.RHMCid#" value="#rsMontosCat.RHMCmontoAnt#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;"></td>
							<td align="right"><cf_inputNumber name="RHMCmonto#rsMontosCat.RHMCid#" value="#rsMontosCat.RHMCmonto#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;"></td>
							<td align="right"><cf_inputNumber name="RHMCpropuesto#rsMontosCat.RHMCid#" value="#rsMontosCat.RHMCpropuesto#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;"></td>
						</tr>
					</cfoutput>
				</table>
			</td>
		</tr>
		<tr><td><cf_botones names="#Lvar_botones#" values="#Lvar_botonesN#" formName="formAT"></td></tr>
	</table>
</form>


<script>
	
	function funcAnterior(){
		document.formAT.SEL.value = "3";
		document.formAT.action = "tipoTablasSal.cfm";
		return true;
	}
	
	function funcAplicar(){
		if(confirm('<cfoutput>#MSG_Aplicar#</cfoutput>')){
			return true;
		}
		return false;
	}
	
	function funcAplicarC(){
		if(confirm('<cfoutput>#MSG_AplicarC#</cfoutput>')){
			return true;
		}
		return false;
	}

	function funcAplicarV(){
		if(confirm('<cfoutput>#MSG_AplicarV#</cfoutput>')){
			return true;
		}
		return false;
	}

</script>
