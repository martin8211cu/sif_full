
<cfquery name="rsNiveles" datasource="#session.DSN#">
	Select rhe.ESid, 
			DESlinea, 
			DESnivel,
			DESptodesde,
			DESptohasta,
			DESsalmin,
			DESsalmax
	from RHEscalaSalHAY rhe
		inner join RHDEscalaSalHAY rhde
			on rhde.ESid=rhe.ESid
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and DESlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DESlinea#">
</cfquery>

<cfif isdefined('rsNiveles') and rsNiveles.recordCount GT 0>
	<cfquery name="rsPuestoNiv" datasource="#session.DSN#">
		select a.HYERVid, a.RHPcodigo, RHPdescpuesto,a.ptsTotal
		from HYDRelacionValoracion a
			
			inner join HYERelacionValoracion b
				on b.HYERVid=a.HYERVid
					and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and b.HYERVfecha = ( select max(z.HYERVfecha) 
								 from HYERelacionValoracion z 
								 inner join HYDRelacionValoracion y 
								 on y.HYERVid=z.HYERVid
								 and y.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								 and y.RHPcodigo=a.RHPcodigo)
			
					and b.HYERVid = ( select max(z.HYERVid) 
								 from HYERelacionValoracion z 
								 inner join HYDRelacionValoracion y 
								 on y.HYERVid=z.HYERVid
								 and y.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								 and y.RHPcodigo=a.RHPcodigo
								 and z.HYERVfecha = b.HYERVfecha)
			inner join RHPuestos p
				on p.Ecodigo=b.Ecodigo
					and p.RHPcodigo=a.RHPcodigo
		where a.ptsTotal between <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNiveles.DESptodesde#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNiveles.DESptohasta#">
	</cfquery>
</cfif>


<table width="99%" border="0" cellpadding="0" cellspacing="0" align="center">
  <tr>
    <td width="73%" valign="top">
		<table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid black;">
			<tr><td>
			<cfoutput>
				<table width="100%" cellpadding="3" cellspacing="0" bgcolor="##DADADA">
					<tr><td ><font size="2"><strong>Detalle del Nivel #trim(rsNiveles.DESnivel)#</strong></font></td></tr>
					<tr><td style="border-bottom:1px solid gray"><font size="2"><strong>Rango de Salarios: #LSNumberFormat(rsNiveles.DESsalmin,",9.00")# - #LSNumberFormat(rsNiveles.DESsalmax,",9.00")#</strong></font></td></tr>
				</table>
				
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
					<tr>
						<td colspan="2" width="64%" bgcolor="##EAEAEA" ><strong><font size="2">Puesto</font></strong></td>
						<td width="36%" bgcolor="##EAEAEA" ><strong><font size="2">Puntaje M&aacute;ximo</font></strong></td>			
					</tr>
					<cfif isdefined('rsPuestoNiv') and rsPuestoNiv.recordCount GT 0>
						<cfloop query="rsPuestoNiv">
							<tr style="cursor:hand; padding:3px;"  onClick="javascript:procNivel('#rsPuestoNiv.RHPcodigo#','#rsPuestoNiv.ptsTotal#');" class="<cfif rsPuestoNiv.currentrow mod 2>listaNon<cfelse>listaPar</cfif>" onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif rsPuestoNiv.currentrow mod 2>listaNon<cfelse>listaPar</cfif>';">
								<td>&nbsp;</td>
								<td><font size="2">#trim(rsPuestoNiv.RHPcodigo)#-#trim(rsPuestoNiv.RHPdescpuesto)#</font></td>
								<td><font size="2">#rsPuestoNiv.ptsTotal#</font></td>				
							</tr>
						</cfloop>
					<cfelse>
							<tr class="<cfif rsNiveles.currentrow mod 2>listaNon<cfelse>listaPar</cfif>">
								<td colspan="3" align="center">&nbsp;</td>				
							</tr>		
							<tr class="<cfif rsNiveles.currentrow mod 2>listaNon<cfelse>listaPar</cfif>">
								<td colspan="3" align="center"><strong>-- No se encontraron puestos para el nivel seleccionado --</strong></td>				
							</tr>
							<tr class="<cfif rsNiveles.currentrow mod 2>listaNon<cfelse>listaPar</cfif>">
								<td colspan="3" align="center">&nbsp;</td>				
							</tr>				
					</cfif>
					<tr>
						<td colspan="3" align="center">&nbsp;</td>				
					</tr>				
				</table>
				
				<script language="javascript" type="text/javascript">
					function procNivel(puesto,puntaje){
						var width = 700;
						var height = 500;
						var top = (screen.height - height) / 2;
						var left = (screen.width - width) / 2;				
	
						var nuevo = open("/cfmx/rh/adminsalarios/consultas/escala-salarial-EmpPuestosImp.cfm?ESid=<cfoutput>#form.ESid#&DESlinea=#form.DESlinea#</cfoutput>&RHPcodigo=" + puesto + "&ptsTotal=" + puntaje, 'popUpWin2','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
						nuevo.focus();
					}
				</script>	
			</cfoutput>	
			</td></tr>
		</table>
	</td>
    <td width="27%" align="center" valign="top">
		<table width="100%" cellpadding="0" cellspacing="0" align="center">
			<tr><td align="center"><strong>Comparativo de Personas por Rango</strong></td></tr>
			<tr><td align="center">
				<cfchart chartwidth="200" format="png" chartheight="200" show3d="yes" showBorder="yes">
					  <cfchartseries type="pie"  >
						<cfchartdata item="Por debajo del rango" value="#rango1#">
						<cfchartdata item="Dentro del rango" value="#rango2#">
						<cfchartdata item="Por encima del rango" value="#rango3#">
					  </cfchartseries>
				</cfchart>
			</td></tr>
		</table>
	</td>
  </tr>
</table>


