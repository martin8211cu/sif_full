<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<form  action="" method="post" name="form1" id="form1">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select llave as DEid
			from UsuarioReferencia
			where Ecodigo= #session.Ecodigo#
			and STabla	= 'DatosEmpleado'
		</cfquery>
		<cfset LvarDEID=#rsSQL.DEid#>
		<cfquery name="rsPer" datasource="#Session.DSN#">
            select distinct Eperiodo
            from EContables
            where Ecodigo = #Session.Ecodigo#
        </cfquery>
        <cfquery name="rsMeses" datasource="sifControl">
            select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
            from Idiomas a, VSidioma b 
            where a.Icodigo = '#Session.Idioma#'
                and a.Iid = b.Iid
                and b.VSgrupo = 1
            order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
        </cfquery>
			<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">

				<tr>
				  <td nowrap="nowrap" align="right" width="40%"><strong>Empleado : </strong></td>
				  <td align="left"> 
					  <cf_conlis title="LISTA DE EMPLEADOS"
					campos = "DEid, DEidentificacion, DEnombre" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,15,34"
					asignar="DEid, DEidentificacion, DEnombre"
					asignarformatos="S,S,S"
					tabla="DatosEmpleado"
					columnas="DEid, DEidentificacion, DEnombre #LvarCNCT#' '#LvarCNCT# DEapellido1 #LvarCNCT#' '#LvarCNCT# DEapellido2 as DEnombre"
					filtro="Ecodigo = #Session.Ecodigo#"
					desplegar="DEidentificacion, DEnombre"
					etiquetas="Identificacin,Nombre"
					formatos="S,S"
					align="left,left"
					showEmptyListMsg="true"
					EmptyListMsg=""
					form="form1"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="DEidentificacion,DEnombre"
					index="1"			
					funcion="funcCambiaDEid"
					fparams="DEid"
					/>   
				 	</td>
				</tr>
                <cfoutput>
				<tr>
					<td align="right" valign="top" nowrap="nowrap"><strong>Tipo : </strong></td>
					<td align="left" valign="top"nowrap="nowrap">
						<select name="AFTRtipo" id="AFTRtipo" tabindex="1">
                            <option value="-1">TODOS</option>
                            <option value="1">Anticipos</option>
                            <option value="2">Liquidaciones</option>
						</select>			
				  </td>
				</tr>
                <cfset periodo="#get_val(30).Pvalor#">
			   	<cfset mes="#get_val(40).Pvalor#">
                <tr>
					<td align="right" nowrap="nowrap"><strong>Periodo Inicial : </strong></td>
					<td>
                      <select name="periodoini">
                        <cfloop query="rsPer">
                          <option value="#Eperiodo#" <cfif isdefined("periodo") and periodo eq Eperiodo>selected</cfif>>#Eperiodo#</option>
                        </cfloop>
                      </select>
                    </td>						
				</tr>
				<tr>
					<td align="right" nowrap="nowrap"><strong>Mes Inicial : </strong></td>
					<td>
                          <select name="mesini">
                            <cfloop query="rsMeses">
                              <option value="#VSvalor#"<cfif  isdefined("mes") and  mes eq VSvalor>selected</cfif>>#VSdesc#</option>
                            </cfloop>
                          </select>
                        </td>
				</tr>
                <tr>
					<td align="right" nowrap="nowrap"><strong>Periodo Final : </strong></td>
					<td>
                      <select name="periodofin">
                        <cfloop query="rsPer">
                          <option value="#Eperiodo#" <cfif isdefined("periodo") and periodo eq Eperiodo>selected</cfif>>#Eperiodo#</option>
                        </cfloop>
                      </select>
                    </td>						
				</tr>
				<tr>
					<td align="right" nowrap="nowrap"><strong>Mes Final : </strong></td>
					<td>
                          <select name="mesfin">
                            <cfloop query="rsMeses">
                              <option value="#VSvalor#"<cfif  isdefined("mes") and  mes eq VSvalor>selected</cfif>>#VSdesc#</option>
                            </cfloop>
                          </select>
                        </td>
				</tr>
                </cfoutput>
				<tr><td align="center" colspan="5"><input type="button" value="Consultar" name="Generar" id="Generar" onclick="return sbSubmit(this);"/></td></tr>
			</table>
	
	</form>
<script language="javascript">
	function sbSubmit()
	{
		document.form1.action = "GEReportes_formMovimientos.cfm";
		document.form1.submit();	
	}
</script>

<cffunction name="get_val" access="public" returntype="query">
	<cfargument name="valor" type="numeric" required="true" default="<!--- Código del Parámetro --->">
	<cfquery datasource="#Session.DSN#" name="rsget_val">
		select ltrim(rtrim(Pvalor)) as Pvalor from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#valor#">
	</cfquery>
	<cfreturn #rsget_val#>
</cffunction>