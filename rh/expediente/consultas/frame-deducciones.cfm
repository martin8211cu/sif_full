

<cfquery name="rsDeduccion" datasource="#Session.DSN#">
	select a.DEid,
		   a.Did, 
		   a.Ddescripcion, 
		   a.SNcodigo, 
		   b.SNnombre,
	       case a.Dmetodo when 0 then '<cf_translate key="Porcentaje">Porcentaje</cf_translate>' when 1 then '<cf_translate key="Valor">Valor</cf_translate>' end as Dmetodo, 
		   a.Dvalor,
		   Dfechaini,
		   Dfechafin,
		   a.Dreferencia,
		   7 as o,
		   1 as sel

	from DeduccionesEmpleado a

	inner join SNegocios b
	on a.Ecodigo=b.Ecodigo 
	and a.SNcodigo=b.SNcodigo 

	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between a.Dfechaini and a.Dfechafin
		<!--- 20100831 LZ. Se Despliegan las Deducciones cuyo Saldo sean mayor a Cero y Se controle ese Saldo o bien las que ControlSaldo este inactivo. Adicional Solo las Deducciones Activas. --->
		and ((a.Dsaldo > 0 and a.Dcontrolsaldo=1) or (a.Dcontrolsaldo=0))
		and a.Dactivo=1
		<!---- 20100831 LZ. Fin --->
	  <cfif isdefined('form.DdescripcionFiltro') and form.DdescripcionFiltro NEQ "">
			and upper(Ddescripcion) like Upper('%#UCase(Form.DdescripcionFiltro)#%')
 	  </cfif>

	  <cfif isdefined('form.DfechainiFiltro') and form.DfechainiFiltro NEQ "">
			and Dfechaini >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DfechainiFiltro)#">
 	  </cfif>	  

	order by Ddescripcion
</cfquery>

<cf_templatecss>

<cfif rsDeduccion.recordCount GT 0>
 	<cfoutput>
		<script type="text/javascript" language="JavaScript">
			function showDetalleDeduccion(deduccion,empleado) {
				document.listaDeduccion.Did.value = deduccion;
				document.listaDeduccion.DEid.value = empleado;
				document.listaDeduccion.action = '/cfmx/rh/expediente/consultas/DetalleDeducciones.cfm';
				document.listaDeduccion.submit();
			}
		</script>

		<form name="listaDeduccion" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0">
			<input type="hidden" name="o" value="<cfif isdefined('Form.o')><cfoutput>#Form.o#</cfoutput></cfif>">
			<input type="hidden" name="sel" value="<cfif isdefined('Form.sel')><cfoutput>#Form.sel#</cfoutput></cfif>">
			<input type="hidden" name="DEid" value="<cfif isdefined('Form.DEid')><cfoutput>#Form.DEid#</cfoutput></cfif>">
			<input type="hidden" name="ViewMode" value="<cfif isdefined('Form.ViewMode')><cfoutput>#Form.ViewMode#</cfoutput></cfif>">
			<input type="hidden" name="Did" value="">
		
		<input type="hidden" name="Regresar" value="#GetFileFromPath(GetTemplatePath())#">
		<table width="100%" cellpadding="2" cellspacing="0">		
		<tr> 
		  <td class="tituloListas" align="left" nowrap><cf_translate key="Deduccion">Deducci&oacute;n</cf_translate></td>
		  <td class="tituloListas" nowrap><cf_translate key="Metodo">M&eacute;todo</cf_translate></td>
		  <td class="tituloListas" nowrap><cf_translate key="Referencia">Referencia</cf_translate></td>
		  <td class="tituloListas" align="right" nowrap><cf_translate key="Valor">Valor</cf_translate></td>
  		  <td class="tituloListas" align="center" nowrap><cf_translate key="FechaInicial">Fecha Inicial</cf_translate></td>
  		  <td class="tituloListas" align="center" nowrap><cf_translate key="FechaFinal">Fecha Final</cf_translate></td>
		</tr>
		<cfloop query="rsDeduccion">
			<cfif (currentRow Mod 2) eq 1>
				<cfset color = "Non">
			<cfelse>
				<cfset color = "Par">
			</cfif>
			<tr onClick="javascript: showDetalleDeduccion('#Did#','#DEid#');" style="cursor: pointer;" onMouseOver="javascript: style.color = 'red'" onMouseOut="javascript: style.color = 'black'">
			  <td class="lista#color#" align="left" nowrap>#Ddescripcion#</td>
			  <td class="lista#color#" nowrap>#Dmetodo#</td>
			  <td class="lista#color#" nowrap>#Dreferencia#</td>
			  <td class="lista#color#" align="right" nowrap>#LSCurrencyFormat(Dvalor,'none')#</td>
			  <td class="lista#color#" align="center" nowrap>#LSDateFormat(Dfechaini, 'dd/mm/yyyy')#</td>
			  <td class="lista#color#" align="center" nowrap>#LSDateFormat(Dfechafin,'dd/mm/yyyy')#</td>
			</tr>
		</cfloop>
		</table>
		</form>
	</cfoutput>
<cfelse> 
	<cf_translate key="MSG_ElEmpleadoNoTieneDeduccionesAsociadasActualmente">El empleado no tiene deducciones asociadas actualmente</cf_translate>
</cfif>
