<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Parentesco" Default="Parentesco" returnvariable="LB_Parentesco"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_de_Corte" Default="Fecha de Corte" returnvariable="LB_Fecha_de_Corte"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Edad_Desde" Default="Edad Desde" returnvariable="LB_Edad_Desde"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Edad_de_Corte" Default="Edad de Corte" returnvariable="LB_Edad_de_Corte"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tipo_de_Corte" Default="Tipo de Corte" returnvariable="LB_Tipo_de_Corte"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Rangos_de_Edad" Default="Rangos de Edad" returnvariable="LB_Rangos_de_Edad"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Annos_Cumplidos" Default="A&ntilde;os Cumplidos" returnvariable="LB_Annos_Cumplidos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Annos_Sin_Cumplir" Default="A&ntilde;os Sin Cumplir" returnvariable="LB_Annos_Sin_Cumplir"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ordenar_por" Default="Ordenar por" returnvariable="LB_Ordenar_por"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Ceedula" Default="C&eacute;dula" returnvariable="CMB_Ceedula"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Nombre" Default="Nombre" returnvariable="CMB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Luego_por" Default="Luego por" returnvariable="LB_Luego_por"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_NombrePariente" Default="Nombre Pariente" returnvariable="CMB_NombrePariente"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_SexoPariente" Default="Sexo Pariente" returnvariable="CMB_SexoPariente"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_EdadPariente" Default="Edad Pariente" returnvariable="CMB_EdadPariente"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Formato" Default="Formato" returnvariable="LB_Formato"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Flashpaper" Default="Flashpaper" returnvariable="CMB_Flashpaper"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_PDF" Default="PDF" returnvariable="CMB_PDF"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_Excel" Default="Excel" returnvariable="CMB_Excel"/>
<cfquery name="rsParentescos" datasource="#session.dsn#">
	select Pid, Pdescripcion
	from RHParentesco
</cfquery>
<!--- No se traducen porque esto es un catálogo con mantenimiento en PSO entonces es responsabilidad del usuario dar de alta las descripciones en el idioma apropiado.
<cfloop query="rsParentescos">
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="CMB_#Pdescripcion#" Default="#Pdescripcion#" returnvariable="CMB_#Pdescripcion#"/>
	<cfset QuerySetCell(rsParentescos, "Pdescripcion", Evaluate("CMB_#Pid#"),rsParentescos.CurrentRow)>
</cfloop>--->
<cffunction name="fnselected" returntype="string">
	<cfargument name="value1" required="yes">
	<cfargument name="value2" required="yes">				
	<cfset selected = iif(arguments.value1 eq arguments.value2,DE("selected"),DE(""))>
	<cfreturn selected>
</cffunction>
<cfoutput>
<cfset Lvar_Res = iif(FindNoCase('Res', CurrentPage),DE("Res"),DE(""))>
<form action="hijosEmpleados#Lvar_Res#-sql.cfm" method="#iif(FindNoCase('Res', CurrentPage),DE('Post'),DE('Get'))#" name="form1" style="margin:0">
	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="margin:0">
	  <tr>
		<td  align="right" nowrap><strong>#LB_Parentesco#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<cfif rsParentescos.recordcount gt 0>
				<cfparam name="Form.Pid" default="#rsParentescos.Pid#">
				<select name="Pid">
					<cfloop query="rsParentescos">
						<option value="#rsParentescos.Pid#" #fnselected(Form.Pid,rsParentescos.Pid)#>#rsParentescos.Pdescripcion#</option>
					</cfloop>
				</select>
			<cfelse>
				<input type="hidden" name="Pid" />
				NA
			</cfif>
		</td>
	  </tr>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Fecha_de_Corte#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<cfparam name="Form.FechaHasta" default="#LSDateFormat(Now(),'dd/mm/yyyy')#">
			<cf_sifcalendario name="FechaHasta" value="#Form.FechaHasta#">
		</td>
	  </tr>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Edad_Desde#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<cfparam name="Form.EdadDesde" default="0">
			<cf_inputNumber name="EdadDesde" value="#Form.EdadDesde#" enteros="2">
		</td>
	  </tr>
	   <tr>
		<td  align="right" nowrap><strong>#LB_Edad_de_Corte#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<cfparam name="Form.EdadHasta" default="12">
			<cf_inputNumber name="EdadHasta" value="#Form.EdadHasta#" enteros="2">
		</td>
	  </tr>
	  <cfif FindNoCase('Res', CurrentPage) gt 0>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Rangos_de_Edad#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<cfparam name="Form.EdadRangos" default="2">
			<cf_inputNumber name="EdadRangos" value="#Form.EdadRangos#" enteros="2">
		</td>
	  </tr>
	  <cfelse>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Tipo_de_Corte#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<cfparam name="Form.TipoCorte" default="5">
			<select name="TipoCorte">
				<option value="1" #fnselected(Form.TipoCorte,1)#>#LB_Annos_Cumplidos#</option>
				<option value="2" #fnselected(Form.TipoCorte,2)#>#LB_Annos_Sin_Cumplir#</option>
			</select>
		</td>
	  </tr>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Ordenar_por#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<cfparam name="Form.OrderBy" default="2">
			<select name="OrderBy">
				<option value="1" #fnselected(Form.OrderBy,1)#>#CMB_Ceedula#</option>
				<option value="2" #fnselected(Form.OrderBy,2)#>#CMB_Nombre#</option>
			</select>
		</td>
	  </tr>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Luego_por#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<cfparam name="Form.ThenOrderBy" default="5">
			<select name="ThenOrderBy">
				<option value="3" #fnselected(Form.ThenOrderBy,3)#>#CMB_NombrePariente#</option>
				<option value="4" #fnselected(Form.ThenOrderBy,4)#>#CMB_SexoPariente#</option>
				<option value="5" #fnselected(Form.ThenOrderBy,5)#>#CMB_EdadPariente#</option>
			</select>
		</td>
	  </tr>
	  <tr>
		<td  align="right" nowrap><strong>#LB_Formato#&nbsp;:&nbsp;</strong>&nbsp;</td>
		<td>
			<cfparam name="Form.formato" default="flashpaper">
			<select name="formato">
				<option value="flashpaper" #fnselected(Form.formato,'flashpaper')#>#CMB_Flashpaper#</option>
				<option value="pdf" #fnselected(Form.formato,'pdf')#>#CMB_PDF#</option>
				<option value="excel" #fnselected(Form.formato,'excel')#>#CMB_Excel#</option>
			</select>
		</td>
	  </tr>
	  </cfif>
	</table>
	<cf_botones values="Consultar,Limpiar">
</form>
<script language="javascript" type="text/javascript">
	function vEdadHasta(){
		if (objForm._allowSubmitOnError) return;
		if (this.value<2||this.value>100) this.error="#JSStringFormat('La Edad Maaxima debe estar entre 2 y 100')#";
	}
	function vEdadRangos(){
		if (objForm._allowSubmitOnError) return;
		if (objForm.EdadHasta.getValue()%this.value>0) this.error="#JSStringFormat('El Rango de Edad debe ser un submultiplo de la Edad Maaxima')#";
	}
</script>
</cfoutput>
<cf_qforms>
	<cf_qformsrequiredfield args="Pid,#LB_Parentesco#">
	<cf_qformsrequiredfield args="FechaHasta,#LB_Fecha_de_Corte#">
	<cf_qformsrequiredfield args="EdadHasta,#LB_Edad_de_Corte#,vEdadHasta">
	<cfif FindNoCase('Res', CurrentPage) gt 0>
		<cf_qformsrequiredfield args="EdadRangos,#LB_Rangos_de_Edad#,vEdadRangos">
	<cfelse>
		<cf_qformsrequiredfield args="TipoCorte,#LB_Tipo_de_Corte#">
		<cf_qformsrequiredfield args="OrderBy,#LB_Ordenar_por#">
		<cf_qformsrequiredfield args="ThenOrderBy,#LB_Luego_por#">
		<cf_qformsrequiredfield args="formato,#LB_Formato#">
	</cfif>
</cf_qforms>