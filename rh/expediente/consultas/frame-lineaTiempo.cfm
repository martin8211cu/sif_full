<cfparam name="width" default="800">
<cfparam name="height" default="125">
<cfquery name="LineaTiempo" datasource="#Session.DSN#">
	select LTid, LTdesde as desde, LTsalario
	from LineaTiempo
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	<cfif Session.cache_empresarial EQ 0>
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfif>
	order by LTdesde desc
</cfquery>

<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height) {
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function Graficar(LTid) {
		popUpWindow('grafico-componentes.cfm?LTid='+LTid,250,200,650,500);
	}
	
	function go(item) {
		<cfoutput query="LineaTiempo">
			if ("#LSDateFormat(desde, 'dd/mm/yyyy')#"==item) {
				Graficar(#LTid#)
				return;
			}
		</cfoutput>
	}
	
	function procesar(valor){
	}
	
</script>
<cfif LineaTiempo.RecordCount gt 0>
	<!--- Navegacion de la lista --->
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfparam name="PageNum_rs" default="1">
	
	<!--- HASTA: (case a.LThasta when '61000101' then 'Indefinido' else convert(varchar,a.LThasta,103) end) as hasta  --->
	<cfquery name="rsRHParametros" datasource="#session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  and Pcodigo = 80
	</cfquery>
	<cfparam name="rsRHParametros.Pvalor" default="30">
	<cfquery name="rs" datasource="#session.DSN#" result="rsresult">
		select 	a.LTid, 
				a.LTdesde as desde, 
			  	a.LThasta as hasta, 
				a.LTsalario as SalarioNominal, 
				((a.LTsalario/coalesce(<cf_dbfunction name="to_float" args="t.FactorDiasSalario">,<cfqueryparam cfsqltype="cf_sql_float" value="#rsRHParametros.Pvalor#">))*30) as SalarioMensual,
				((a.LTsalario/coalesce(<cf_dbfunction name="to_float" args="t.FactorDiasSalario">,<cfqueryparam cfsqltype="cf_sql_float" value="#rsRHParametros.Pvalor#">))*360) as SalarioAnual,
				((a.LTsalario/coalesce(<cf_dbfunction name="to_float" args="t.FactorDiasSalario">,<cfqueryparam cfsqltype="cf_sql_float" value="#rsRHParametros.Pvalor#">))*1) as SalarioDiario,
				p.RHPdescripcion, 
				cf.CFdescripcion
		
		from LineaTiempo a 
		
		inner join TiposNomina t
		on t.Ecodigo = a.Ecodigo
		and t.Tcodigo = a.Tcodigo
		
		inner join RHPlazas p
		    inner join CFuncional cf
			on cf.CFid = p.CFid
			
		    inner join RHPuestos e
			on e.RHPcodigo = p.RHPpuesto
			and e.Ecodigo = p.Ecodigo
	    on p.RHPid = a.RHPid 
		
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	    order by LTdesde desc
	</cfquery>
	
	<cfquery name="rsMin" dbtype="query">
		select min(SalarioNominal) as MinSalarioNominal 
		from rs
	</cfquery>
	<cfquery name="rsMax" dbtype="query">
		select max(SalarioNominal) as MaxSalarioNominal 
		from rs
	</cfquery>
	
	<cfset MaxRows_rs = 6>
	
	<cfset StartRow_rs    = Min( (PageNum_rs-1) * MaxRows_rs + 1, Max(rs.RecordCount, 1) )>
	<cfset StartRow_lista = StartRow_rs + (1-PageNum_rs) >
	<cfif StartRow_lista lte 1>
		<cfset StartRow_lista = 1>
	</cfif>
	
	<cfset EndRow_rs=Min(StartRow_rs+MaxRows_rs-1,rs.RecordCount)>
	<cfset TotalPages_rs=Ceiling(rs.RecordCount/MaxRows_rs)>

	<cfset QueryString_rs=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>

	<cfif Find("sel=1", QueryString_rs, 1 ) eq 0 >
		<cfset QueryString_rs = QueryString_rs & "&DEid=#form.DEid#&sel=1">
	</cfif>
	
	<cfif isdefined("form.regresar") and len(trim(form.regresar)) and Find("Regresar", QueryString_rs, 1 ) eq 0 >
		<cfset QueryString_rs = QueryString_rs & "&Regresar=#form.Regresar#" & "&o=#form.o#" >
	</cfif>
	
	<cfset tempPos=ListContainsNoCase(QueryString_rs,"PageNum_rs=","&")>
	<cfif tempPos NEQ 0>
		<cfset QueryString_rs=ListDeleteAt(QueryString_rs,tempPos,"&")>
	</cfif>
	<!--- fin --->

<table width="75%" align="center" border="0" cellpadding="0" cellspacing="0">
  <tr>
  	<td nowrap align="center">
		<table width="100%" cellpadding="3" cellspacing="0">
			<tr>
				<td class="tituloListas"><cf_translate key="Desde">Desde</cf_translate></td>
				<td class="tituloListas"><cf_translate key="Hasta">Hasta</cf_translate></td>
				<td class="tituloListas"><cf_translate key="Centro_Funcional">Centro Funcional</cf_translate></td>
				<td class="tituloListas"><cf_translate key="Plaza">Plaza</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="Salario_Nombramiento">Salario Nombramiento</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="Salario_Mensual">Salario Mensual</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="Salario_Anual">Salario Anual</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="Salario_Diario">Salario Diario</cf_translate></td>
			</tr>
			
			<!--- Query para manejar resultados--->
			<cfset rsResultado = QueryNew("LTid,desde,desde2,LTsalario")>
			<cfset arreglo     = ArrayNew(1)>

			<cfset index = 0 >
			<cfoutput query="rs" startrow="#StartRow_lista#" maxrows="#MaxRows_rs#">
				<cfset index = index + 1 >
				<tr onClick="javascript:Graficar('#rs.LTid#');" 
					class="<cfif rs.CurrentRow MOD 2>
							 listaNon
						   <cfelse>listaPar</cfif>" 
					onmouseover="style.backgroundColor='##E4E8F3';" 
					onmouseout="style.backgroundColor='<cfif rs.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
					<td nowrap ><a href="javascript:Graficar('#rs.LTid#');" class="style2">#LSdateFormat(rs.desde,'dd/mm/yyyy')#</a></td>
					<td nowrap ><a href="javascript:Graficar('#rs.LTid#');" 
								   class="style2"><cfif LSDateFormat(rs.hasta,'dd/mm/yyyy') neq '01/01/6100'>
								   #LSDateFormat(rs.hasta,'dd/mm/yyyy')#<cfelse>Indefinido</cfif></a></td>
					<td nowrap ><a href="javascript:Graficar('#rs.LTid#');" class="style2">#rs.CFdescripcion#</a></td>
					<td nowrap ><a href="javascript:Graficar('#rs.LTid#');" class="style2">#rs.RHPdescripcion#</a></td>
					<td nowrap align="right" >
						<a href="javascript:Graficar('#rs.LTid#');" class="style2">#LSNumberFormat(rs.SalarioNominal, ',L.00')#</a>
					</td>
					<td nowrap align="right" >
						<a href="javascript:Graficar('#rs.LTid#');" class="style2">#LSNumberFormat(rs.SalarioMensual, ',L.00')#</a>
					</td>
					<td nowrap align="right" >
						<a href="javascript:Graficar('#rs.LTid#');" class="style2">#LSNumberFormat(rs.SalarioAnual, ',L.00')#</a>
					</td>
					<td nowrap align="right" >
						<a href="javascript:Graficar('#rs.LTid#');" class="style2">#LSNumberFormat(rs.SalarioDiario, ',L.00')#</a>
					</td>
				</tr>

				<!--- Agrega la fila procesada --->
				<cfset arreglo[index] = ArrayNew(1) >
				<cfset arreglo[index][1] = rs.LTid >
				<cfset arreglo[index][2] = LSDateFormat(rs.desde,'dd/mm/yyyy') >
				<cfset arreglo[index][3] = LSDateFormat(rs.desde, 'dd/mm/yyyy') >
				<cfset arreglo[index][4] = rs.SalarioNominal>
				
			</cfoutput>

			<cfloop from="#ArrayLen(arreglo)#" to="1" index="i" step="-1">
				<cfset fila = QueryAddRow(rsResultado, 1)>
				<cfset tmp  = QuerySetCell(rsResultado, "LTid",      arreglo[i][1]) >
				<cfset tmp  = QuerySetCell(rsResultado, "desde",     arreglo[i][2] )>
				<cfset tmp  = QuerySetCell(rsResultado, "desde2",    arreglo[i][3])>
				<cfset tmp  = QuerySetCell(rsResultado, "LTsalario", arreglo[i][4]) >
			</cfloop>

			<cfoutput>
				<tr>
					<td align="center" colspan="7">
						<table width="50%" align="center">
							<tr>
								<td width="23%" align="center">
									<cfif PageNum_rs GT 1>
										<a href="#CurrentPage#?PageNum_rs=1#QueryString_rs#">
											<img src="/cfmx/rh/imagenes/First.gif" border=0></a>
									</cfif>
								</td>
								<td width="31%" align="center">
									<cfif PageNum_rs GT 1>
										<a href="#CurrentPage#?PageNum_rs=#Max(DecrementValue(PageNum_rs),1)##QueryString_rs#">
											<img src="/cfmx/rh/imagenes/Previous.gif" border=0></a>
									</cfif>
								</td>
								<td width="23%" align="center">
									<cfif PageNum_rs LT TotalPages_rs>
										<a href="#CurrentPage#?PageNum_rs=#Min(IncrementValue(PageNum_rs),TotalPages_rs)##QueryString_rs#">
											<img src="/cfmx/rh/imagenes/Next.gif" border=0></a>
									</cfif>
								</td>
								<td width="23%" align="center">
									<cfif PageNum_rs LT TotalPages_rs>
										<a href="#CurrentPage#?PageNum_rs=#TotalPages_rs##QueryString_rs#">
											<img src="/cfmx/rh/imagenes/Last.gif" border=0></a>
									</cfif>
								</td>
							</tr>
						</table>	
					</td>	
				</tr>
			</cfoutput>
	</table>
	</td>
  </tr>

  <tr><td nowrap align="center">&nbsp;</td></tr>
  <tr><td nowrap align="center">&nbsp;</td></tr>

	<cfif LineaTiempo.RecordCount gt 1>
	  <tr>
		<td nowrap align="center">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="Fecha"
			Default="Fecha"
			returnvariable="Fecha"/>					
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="Salario"
			Default="Salario"
			returnvariable="Salario"/>					

			<cfset Lvar_Min = 0.00>
			<cfset Lvar_Min = 1000000.00>

			<cfif rsMin.recordcount GT 0 and len(trim(rsMin.MinSalarioNominal)) GT 0>
				<cfset Lvar_Min = rsMin.MinSalarioNominal>
			</cfif>
			
			<cfif rsMax.recordcount GT 0 and len(trim(rsMax.MaxSalarioNominal)) GT 0>
				<cfset Lvar_Max = rsMax.MaxSalarioNominal>
			</cfif>
			
			<cfchart 
				format="flash"
				chartWidth="800" 
				chartHeight="250"
				scaleFrom=#Lvar_Min#
				scaleTo=#Lvar_Max#
				gridLines=6
				labelFormat="number"
				xAxisTitle="#Fecha#"
				yAxisTitle="#Salario#"
				show3D="yes"
				yOffset="0"
				url="javascript: go('$ITEMLABEL$');">
				<cfchartseries 
					type="line" 
					query="rsResultado" 
					valueColumn="LTsalario" 
					itemColumn="desde"/>
			</cfchart>
		</td>
	  </tr>  
  </cfif>
  
</table>

<cfelse>
<table width="75%" align="center" border="0" cellpadding="0" cellspacing="0">
	<tr><td align="center">--- <cf_translate key="MSG_NoSeEncontraronRegistros">No se encontraron Registros</cf_translate> ---</td></tr>
	<tr><td align="center">&nbsp;</td></tr>
</table>
	
</cfif>