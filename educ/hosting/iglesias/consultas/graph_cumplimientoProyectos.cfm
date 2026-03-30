<cfset form.tipo = 3>
<cfif not isdefined("form.fTipo") >
	<cfset form.fTipo = "mm">
</cfif>
<cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0>
	<cfparam name="width" default="300">
<cfelse>
	<cfparam name="width" default="600">
</cfif>
<cfparam name="height" default="300">
<cfquery name="rsQryCumpProy" datasource="#session.dsn#">
	select a.MEDproyecto, MEDnombre, isnull(MEDmeta,0) as MEDmeta, isnull(sum(MEDimporte),0) as MEDcumplido
	from MEDDonacion a, MEDProyecto b

	where MEDmeta <> 0
	  and a.MEDproyecto=b.MEDproyecto
	  and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	<cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0 >
	  and b.MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fMEDproyecto#">
	</cfif>
	<cfif isdefined("form.fMes") and len(trim(form.fMes)) gt 0 >
	  and datepart(mm, MEDfecha)=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fMes#">
	</cfif>
	<cfif isdefined("form.fAno") and len(trim(form.fAno)) gt 0 >
	  and datepart(yy, MEDfecha)=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fAno#">
	</cfif>
	group by a.MEDproyecto, MEDnombre, MEDmeta
</cfquery>

<cfquery name="rsQryCumpProyDetail" datasource="#session.dsn#">
	select datepart(#form.fTipo#, MEDfecha) as MEDfecha, isnull(sum(MEDimporte),0) as MEDcumplido
	<cfif isdefined("form.fTipo") and form.fTipo eq 'mm' >
		,case datepart(mm, MEDfecha) 
			when 1 then 'Enero' 
			when 2 then 'Febrero' 
			when 3 then 'Marzo' 
			when 4 then 'Abril' 
			when 5 then 'Mayo' 
			when 6 then 'Junio' 
			when 7 then 'Julio' 
			when 8 then 'Agosto' 
			when 9 then 'Setiembre' 
			when 10 then 'Octubre' 
			when 11 then 'Noviembre' 
			when 12 then 'Diciembre' 
		end as mes
	</cfif>
	from MEDDonacion a, MEDProyecto b

	where MEDmeta <> 0
	  and a.MEDproyecto=b.MEDproyecto
	  and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	<cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0 >
	  and b.MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fMEDproyecto#">
	</cfif>
	<cfif isdefined("form.fMes") and len(trim(form.fMes)) gt 0 >
	  and datepart(mm, MEDfecha)=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fMes#">
	</cfif>
	<cfif isdefined("form.fAno") and len(trim(form.fAno)) gt 0 >
	  and datepart(yy, MEDfecha)=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fAno#">
	</cfif>
	group by datepart(#form.fTipo#, MEDfecha)
</cfquery>
<script language="javascript1.4" type="text/javascript">
	function Chart_OnClick(theItem){
		<cfoutput query="rsQryCumpProy">
			if ('#MEDnombre#' == theItem){
				document.filtro.fMEDproyecto.value = #MEDproyecto#;
				document.filtro.submit();
				return;
			}
		</cfoutput>
	}
</script>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Cumplimiento de Proyectos
</cf_templatearea>
<cf_templatearea name="body">
		<cfset navBarItems = ArrayNew(1)>
		<cfset navBarLinks = ArrayNew(1)>
		<cfset navBarStatusText = ArrayNew(1)>
			
		<cfset ArrayAppend(navBarItems,'Donaciones')>
		<cfset ArrayAppend(navBarLinks,'/cfmx/hosting/iglesias/donacion.cfm')>
		<cfset ArrayAppend(navBarStatusText,'Menú de Donaciones')>
		<cfset Regresar = "/cfmx/hosting/iglesias/donacion.cfm">
		<cfinclude template="../pNavegacion.cfm">

		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td nowrap>&nbsp;</td>
		  </tr>
		  <tr>
			<td nowrap><div align="center"><strong>Gráficos de Cumplimiento de Proyectos con Meta</strong>
			<br><em>Haga click en las barras o seleccione un proyecto para ver información específica del Proyecto.</em></div></td>
		  </tr>
		  <tr>
			<td nowrap>&nbsp;</td>
		  </tr>
		  <tr>
			<td nowrap><cfinclude template="filtro.cfm"></td>
		  </tr>
		  <tr>
			<td nowrap>&nbsp;</td>
		  </tr>
		<tr>
			<td nowrap align="center"><!--- Gráfico de cumplimiento de Proyectos --->
				<cfif rsQryCumpProy.RecordCount gt 0>
				  <table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
				  <tr>
					<cfoutput>
					<td align="center">
						Porcentaje de Cumplimiento
						<cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0>
							del proyecto <br><strong>#rsQryCumpProy.MEDnombre#</strong><br>
						<cfelse>
							de <strong>todos los Proyectos con Meta</strong>
						</cfif>
						durante 
						<cfif isdefined("form.fMes") and len(trim(form.fMes)) gt 0 >
							<strong><cfswitch expression="#form.fMes#" >
								<cfcase value="1">Enero</cfcase>
								<cfcase value="2">Febrero</cfcase>
								<cfcase value="3">Marzo</cfcase>
								<cfcase value="4">Abril</cfcase>
								
								<cfcase value="5">Mayo</cfcase>
								<cfcase value="6">Junio</cfcase>
								<cfcase value="7">Julio</cfcase>
								<cfcase value="8">Agosto</cfcase>
								
								<cfcase value="9">Setiembre</cfcase>
								<cfcase value="10">Octubre</cfcase>
								<cfcase value="11">Noviembre</cfcase>
								<cfcase value="12">Diciembre</cfcase>
							</cfswitch></strong>
							del
						<cfelse>
							el
						</cfif>
						<cfif isdefined("form.fAno") and len(trim(form.fAno)) gt 0 >
						  <strong>#form.fAno#</strong>.
						<cfelse>
						  <strong>#DatePart("yyyy", Now())#</strong>.
						</cfif>			
					</td>
					<cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0>
					<td align="center">
						Historia de Cumplimiento de las Donaciones
						<cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0>
							del proyecto <br><strong>#rsQryCumpProy.MEDnombre#</strong><br>
						<cfelse>
							de <strong>todos los Proyectos con Meta</strong>
						</cfif>
						durante 
						<cfif isdefined("form.fMes") and len(trim(form.fMes)) gt 0 >
							<strong><cfswitch expression="#form.fMes#" >
								<cfcase value="1">Enero</cfcase>
								<cfcase value="2">Febrero</cfcase>
								<cfcase value="3">Marzo</cfcase>
								<cfcase value="4">Abril</cfcase>
								
								<cfcase value="5">Mayo</cfcase>
								<cfcase value="6">Junio</cfcase>
								<cfcase value="7">Julio</cfcase>
								<cfcase value="8">Agosto</cfcase>
								
								<cfcase value="9">Setiembre</cfcase>
								<cfcase value="10">Octubre</cfcase>
								<cfcase value="11">Noviembre</cfcase>
								<cfcase value="12">Diciembre</cfcase>
							</cfswitch></strong>
							del
						<cfelse>
							el
						</cfif>
						<cfif isdefined("form.fAno") and len(trim(form.fAno)) gt 0 >
						  <strong>#form.fAno#</strong>
						<cfelse>
						  <strong>#DatePart("yyyy", Now())#</strong>
						</cfif>
						visto por 
						<cfswitch expression="#form.fTipo#">
							<cfcase value="mm">
								<strong>mes</strong>.
							</cfcase>
							<cfcase value="wk">
								<strong>semana</strong>.
							</cfcase>
						</cfswitch>
					</td>
					</cfif>
					</cfoutput>
				  </tr>
				  <tr>
				    <td align="center">&nbsp;</td>
				    <td align="center">&nbsp;</td>
				    </tr>
				  <tr>
					<td align="center">
						<cfchart gridlines="5"
								 xaxistitle="Proyecto" 
								 yaxistitle="Meta vrs Cumplido" 
								 scalefrom="0" 
								 scaleto="100" 
								 show3d="yes" 
								 showborder="yes" 
								 showlegend="yes"
								 chartwidth="#width#"
								 chartHeight="#height#"
								 xOffset="0.07"
								 yOffset="0.07"
								 url="javascript:Chart_OnClick('$ITEMLABEL$');">
							<cfchartseries
								type="bar"
								query="rsQryCumpProy" 
								valuecolumn="MEDcumplido" 
								serieslabel="Cumplido" 
								itemcolumn="MEDnombre">
							<cfchartseries
								type="bar"
								query="rsQryCumpProy" 
								valuecolumn="MEDmeta" 
								serieslabel="Meta"
								itemcolumn="MEDnombre">
						</cfchart>
					</td>
					<cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0>
					  <td align="center">
						<cfif form.fTipo eq 'mm'>
							<cfset titulo = "Mes">
							<cfset itemcolumn = "mes">
						<cfelse>
							<cfset titulo = "Semana">
							<cfset itemcolumn = "MEDfecha">
						</cfif>
	
						<cfchart gridlines="5"
							 xaxistitle="#titulo#" 
							 yaxistitle="Donado" 
							 scalefrom="0" 
							 scaleto="100" 
							 show3d="yes" 
							 showborder="yes" 
							 showlegend="no"
							 chartwidth="#width#"
							 chartHeight="#height#"
							 xOffset="0.07"
							 yOffset="0.07" >
						<cfchartseries
							type="line"
							query="rsQryCumpProyDetail" 
							valuecolumn="MEDcumplido" 
							serieslabel="" 
							itemcolumn="#itemcolumn#"  >
						</cfchart>
					  </td>
					</cfif>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
					<cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0>
					<td>&nbsp;</td>
					</cfif>
				  </tr>
				  <tr>
				    <td align="center"><em>
						Porcentaje de Cumplimiento
					</em></td>
				    <cfif isdefined("form.fMEDproyecto") and len(trim(form.fMEDproyecto)) gt 0>
					<td align="center"><em>
						Historia del Proyecto
					</em></td>
					</cfif>
			      </tr>
  				  <tr>
				    <td>&nbsp;</td>
				    <td>&nbsp;</td>
			      </tr>
			  </table>
			  <cfelse>
				<b>No se encontraron Resultados</b>
			  </cfif>
			</td>
		  </tr>
		  <tr>
			<td nowrap>&nbsp;</td>
		  </tr>
		  <!---<tr>
			<td nowrap align="center"><!--- Tabla de Proyectos e Historia de Proyectos --->
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td nowrap>&nbsp;</td>
					<td nowrap>&nbsp;</td>
					<td nowrap align="right"><strong>Meta</strong></td>
					<td nowrap align="right"><strong>Cumplido</strong></td>
					<td nowrap align="right"><strong>Faltante</strong></td>
					<td nowrap align="right"><strong>Excedido</strong></td>
					<td nowrap>&nbsp;</td>
				  </tr>
				  <cfoutput query="rsQryCumpProy">
				  <tr class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
					<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="left" width="18" height="18" nowrap>
						<cfif MEDproyecto eq form.MEDproyecto>
							<img src="/cfmx/sif/imagenes/addressGo.gif" width="18" height="18">
						</cfif>
					</td>
					<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="left" nowrap onclick="javascript: Procesar(#MEDproyecto#);"><a href="javascript:Procesar(#MEDproyecto#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#MEDnombre#</a></td>
					<td align="right"class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="left" nowrap onclick="javascript: Procesar(#MEDproyecto#);"><a href="javascript:Procesar(#MEDproyecto#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#LSCurrencyFormat(MEDmeta, 'none')#</a></td>
					<td align="right"class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="left" nowrap onclick="javascript: Procesar(#MEDproyecto#);"><a href="javascript:Procesar(#MEDproyecto#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#LSCurrencyFormat(MEDcumplido, 'none')#</a></td>
					<td align="right"class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="left" nowrap onclick="javascript: Procesar(#MEDproyecto#);"><a href="javascript:Procesar(#MEDproyecto#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#LSCurrencyFormat(iif(MEDmeta-MEDcumplido lt 0,0,MEDmeta-MEDcumplido), 'none')#</a></td>
					<td align="right"class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>align="left" nowrap onclick="javascript: Procesar(#MEDproyecto#);"><a href="javascript:Procesar(#MEDproyecto#);" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1">#LSCurrencyFormat(iif(MEDmeta-MEDcumplido lt 0,(MEDmeta-MEDcumplido)*-1,0), 'none')#</a></td>
					<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="left" width="18" height="18" nowrap>&nbsp;</td>
				  </tr>
				  </cfoutput>
			  </table>
			</td>
		</tr>
		--->
</table>
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="../pMenu.cfm">
</cf_templatearea>
</cf_template>