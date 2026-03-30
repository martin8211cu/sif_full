<cfparam name="width" default="800">
<cfparam name="height" default="125">
<cfquery name="LineaTiempo_1" datasource="#Session.DSN#">
	select LTid, LTdesde as desde, LTsalario
		from LineaTiempo
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	<cfif Session.cache_empresarial EQ 0>
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfif>
	order by LTdesde
</cfquery>

<cfset LineaTiempo = QueryNew("LTid, desde, LTsalario") >
<cfloop query="LineaTiempo_1">
	<cfset QueryAddRow(LineaTiempo, 1)>
	<cfset QuerySetCell(LineaTiempo,"LTid",LineaTiempo_1.LTid) >
	<cfset QuerySetCell(LineaTiempo,"desde",LSDateFormat(LineaTiempo_1.desde,'dd/mm/yyyy')) >
	<cfset QuerySetCell(LineaTiempo,"LTsalario",LineaTiempo_1.LTsalario) >
</cfloop>

<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height) {
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,
	  menubar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function Graficar(LTid) {
		popUpWindow('grafico-componentes.cfm?LTid='+LTid,250,200,650,500);
	}
	function go(item) {
		<cfoutput query="LineaTiempo">
			if ("#desde#"==item) {
				Graficar(#LTid#)
				return;
			}
		</cfoutput>
	}
</script>
<cfif LineaTiempo.RecordCount gt 0>
<table width="75%" align="center" border="0" cellpadding="0" cellspacing="0">
  <tr>
  	<td nowrap align="cente r">
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaEmpl">
				<cfinvokeargument name="tabla" value="LineaTiempo a, TiposNomina b, Oficinas c, Departamentos d, RHPuestos e, RHPlazas f, RegimenVacaciones g"/>
				<cfinvokeargument name="columnas" value="convert(varchar,DEid) DEid, convert(varchar,LTid) LTid, convert(varchar,a.LTdesde,103) desde, (case a.LThasta when '61000101' then 'Indefinido' else convert(varchar,a.LThasta,103) end) hasta, b.Tdescripcion, c.Odescripcion, d.Ddescripcion, e.RHPdescpuesto, f.RHPdescripcion, g.Descripcion, a.LTsalario"/>
				<cfinvokeargument name="desplegar" value="desde, hasta, Tdescripcion, Odescripcion, Ddescripcion, RHPdescpuesto, RHPdescripcion, Descripcion, LTsalario"/>
				<cfinvokeargument name="etiquetas" value="Desde, Hasta, T. Nómina, Oficina, Departamento, Puesto, Plaza, R. Vacaciones, Salario"/>
				<cfinvokeargument name="formatos" value="S, S, S, S, S, S, S, S, M"/>
				<cfinvokeargument name="formName" value="listalineaTiempo"/>
				<cfinvokeargument name="filtro" value="a.Tcodigo = b.Tcodigo and a.Ocodigo = c.Ocodigo and a.Ecodigo = c.Ecodigo and a.Dcodigo = d.Dcodigo and a.Ecodigo = d.Ecodigo and a.RHPcodigo = e.RHPcodigo and a.Ecodigo = e.Ecodigo and a.RHPid = f.RHPid and a.RVid = g.RVid and a.DEid = #Form.DEid# order by LTdesde"/> 
				<cfinvokeargument name="align" value="center, center, left, left, left, left, left, left, right"/>
				<cfinvokeargument name="funcion" value="Graficar"/>
				<cfinvokeargument name="fparams" value="LTid"/>
				<cfinvokeargument name="MaxRows" value="30"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
	</td>
  </tr>
  <tr>
  	<td nowrap align="center">&nbsp;
	
	</td>
  </tr>
  <tr>
  	<td nowrap align="center">
		<cfchart 
			format="flash" 
			chartWidth="#width#" 
			chartHeight="#height#"
			scaleFrom=0 
			scaleTo=10 
			gridLines=3 
			labelFormat="number"
			xAxisTitle="Fecha"
			yAxisTitle="Salario"
			show3D="yes"
			yOffset="0.4"
			url="javascript: go('$ITEMLABEL$');">
			<cfchartseries 
				type="line" 
				query="LineaTiempo" 
				valueColumn="LTsalario" 
				itemColumn="desde"
			/>
		</cfchart>
	</td>
  </tr>  
</table>
</cfif>