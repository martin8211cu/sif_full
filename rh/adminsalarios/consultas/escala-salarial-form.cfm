<cfif isdefined("url.ESid") and not isdefined("form.ESid")>
	<cfset form.ESid = url.ESid >
</cfif>
<cfif isdefined("url.DESlinea") and not isdefined("form.DESlinea")>
	<cfset form.DESlinea = url.DESlinea >
</cfif>

<cfquery name="niveles" datasource="#session.DSN#">
	select a.DESlinea, 
		   a.ESid,
		   a.DESnivel,
		   a.DESptodesde,
		   a.DESptohasta,
		   a.DESsalmin,
		   a.DESsalmax,
		   a.DESsalprom
	from RHDEscalaSalHAY a
	
	where a.ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESid#">
	order by a.DESnivel
</cfquery>

<cfquery name="escala" datasource="#session.DSN#">
	select EScodigo, ESdescripcion
	from RHEscalaSalHAY
	where ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESid#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
</cfquery>

<cfoutput>
	<table width="100%" cellpadding="3" cellspacing="0" >
		<tr>
			<td>
				<cf_EncReporte
					Titulo="Valoraci&oacute;n HAY vs Escala Salarial"
					Color="##E3EDEF"
					filtro1="#trim(escala.EScodigo)# - #escala.ESdescripcion#"
					cols= "8"
				>			
			</td>
		</tr>
	</table>

	<table width="99%" align="center" cellpadding="0" cellspacing="0" style="border:1px solid black;" >
		<tr>
			<td valign="top">
				<table width="100%" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td bgcolor="##DADADA"></td>
						<td colspan="5" bgcolor="##DADADA" ></td>
						<td colspan="3" bgcolor="##DADADA" align="center"><strong><font size="2">Colaboradores</font></strong></td>
					</tr>
					<tr>
						<td bgcolor="##DADADA"></td>
						<td bgcolor="##DADADA" style="padding:4px;"><strong><font size="2">Nivel</font></strong></td>
						<td  bgcolor="##DADADA" align="right"><strong><font size="2">Rango inferior</font></strong></td>
						<td  bgcolor="##DADADA" align="right"><strong><font size="2">Rango superior</font></strong></td>
						<td  bgcolor="##DADADA" align="right"><strong><font size="2">Puestos</font></strong></td>
						<td  bgcolor="##DADADA" align="right"><strong><font size="2">Colaboradores</font></strong></td>
						<td bgcolor="##DADADA"  align="right"><strong><font size="2">Bajo el rango</font></strong></td>
						<td bgcolor="##DADADA" align="right"><strong><font size="2">Dentro del rango</font></strong></td>
						<td bgcolor="##DADADA" align="right"><strong><font size="2">Sobre el rango</font></strong></td>
					</tr>

					<cfset rango1 = 0 >
					<cfset rango2 = 0 >
					<cfset rango3 = 0 >

					<cfloop query="niveles">
						<tr <cfif not (isdefined('form.DESlinea') and form.DESlinea eq niveles.DESlinea)>onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif niveles.currentrow mod 2>listaNon<cfelse>listaPar</cfif>';"</cfif> title="Consultar detalle" onClick="javascript:procesar('#niveles.DESlinea#');" style="cursor:hand; padding:3px;" <cfif isdefined('form.DESlinea') and form.DESlinea eq niveles.DESlinea>bgcolor='##AADBF2'<cfelse>class="<cfif niveles.currentrow mod 2>listaNon<cfelse>listaPar</cfif>"</cfif> >
							<td><cfif isdefined('form.DESlinea') and form.DESlinea eq niveles.DESlinea><img src="/cfmx/rh/imagenes/addressGo.gif" border="0"></cfif></td>
							<td><font size="2">#trim(niveles.DESnivel)#</font></td>
							<td align="right"><font size="2">#LSNumberFormat(niveles.DESptodesde,',9')#</font></td>
							<td align="right"><font size="2">#LSNumberFormat(niveles.DESptohasta,',9')#</font></td>
							
							<!--- Cantidad de puestos por rango --->
							<cfquery name="puestos" datasource="#session.DSN#">
								select a.HYERVid, a.RHPcodigo, ptsTotal
								from HYDRelacionValoracion a
								
								inner join HYERelacionValoracion b
								on b.HYERVid=a.HYERVid
								and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								
								and b.HYERVfecha = ( select max(z.HYERVfecha) 
													 from HYERelacionValoracion z, HYDRelacionValoracion y  
													 where y.HYERVid=z.HYERVid
													 and y.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
													 and y.RHPcodigo=a.RHPcodigo)
								and b.HYERVid = ( select max(z.HYERVid) 
													 from HYERelacionValoracion z, HYDRelacionValoracion y  
													 where y.HYERVid=z.HYERVid
													 and y.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
													 and y.RHPcodigo=a.RHPcodigo
													 and z.HYERVfecha = b.HYERVfecha )
								where ptsTotal between <cfqueryparam cfsqltype="cf_sql_numeric" value="#niveles.DESptodesde#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#niveles.DESptohasta#">
								order by a.RHPcodigo
							</cfquery>

							<td align="right"><font size="2">#LSNumberFormat(puestos.recordcount,',9')#</font></td>
			
							<cfset valores = QuotedValueList(puestos.RHPcodigo) >
							 
							<cfif len(trim(valores)) >
								<cfquery name="personas" datasource="#session.DSN#">
									select count(1) as total 
									from LineaTiempo 
									where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between LTdesde and LThasta
									and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
									and RHPcodigo in (#preservesinglequotes(valores)#)
								</cfquery>
								<cfset vTotal =  personas.total >
							<cfelse>
								<cfset vTotal =  0 >
							</cfif>
							<td align="right"><font size="2">#LSNumberFormat(vtotal,',9')#</font></td>
							
							<cfif len(trim(valores)) >
								<cfquery name="personas" datasource="#session.DSN#">
									select count(1) as total 
									from LineaTiempo 
									where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between LTdesde and LThasta
									and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
									and RHPcodigo in (#preservesinglequotes(valores)#)
									and LTsalario < <cfqueryparam cfsqltype="cf_sql_money" value="#niveles.DESsalmin#"> 
								</cfquery>
								<cfset vTotalDebajo =  personas.total >
							<cfelse>
								<cfset vTotalDebajo =  0 >
							</cfif>
							<cfif isdefined("form.DESlinea") and form.DESlinea eq niveles.DESlinea>
								<cfset rango1 = vTotalDebajo >
							</cfif>
							<td align="right"><font size="2">#LSNumberFormat(vTotalDebajo,',9')#</font></td>
			
							<cfif len(trim(valores)) >
								<cfquery name="personas" datasource="#session.DSN#">
									select count(1) as total 
									from LineaTiempo 
									where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between LTdesde and LThasta
									and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
									and RHPcodigo in (#preservesinglequotes(valores)#)
									and LTsalario between <cfqueryparam cfsqltype="cf_sql_money" value="#niveles.DESsalmin#"> and <cfqueryparam cfsqltype="cf_sql_money" value="#niveles.DESsalmax#"> 
								</cfquery>
								<cfset vTotalDebajo =  personas.total >
							<cfelse>
								<cfset vTotalDebajo =  0 >
							</cfif>
							<cfif isdefined("form.DESlinea") and form.DESlinea eq niveles.DESlinea>
								<cfset rango2 = vTotalDebajo >
							</cfif>
							<td align="right"><font size="2">#LSNumberFormat(vTotalDebajo,',9')#</font></td>
							
							<cfif len(trim(valores)) >
								<cfquery name="personas" datasource="#session.DSN#">
									select count(1) as total 
									from LineaTiempo 
									where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between LTdesde and LThasta
									and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
									and RHPcodigo in (#preservesinglequotes(valores)#)
									and LTsalario > <cfqueryparam cfsqltype="cf_sql_money" value="#niveles.DESsalmax#"> 
								</cfquery>
								<cfset vTotalDebajo =  personas.total >
							<cfelse>
								<cfset vTotalDebajo =  0 >
							</cfif>
							<cfif isdefined("form.DESlinea") and form.DESlinea eq niveles.DESlinea>
								<cfset rango3 = vTotalDebajo >
							</cfif>
							<td align="right"><font size="2">#LSNumberFormat(vTotalDebajo,',9')#</font></td>
						</tr>
					</cfloop>
					<tr><td></td></tr>
				</table>
			</td>	
		</tr>
	</table>



	<form name="form1" method="post">
		<input type="hidden" name="ESid" value="#form.ESid#">
		<input type="hidden" name="DESlinea" value="">
	</form> 

	<script type="text/javascript" language="javascript1.2">
		function procesar(nivel){
			document.form1.DESlinea.value = nivel;
			document.form1.submit();
		}
	</script> 
</cfoutput>	

<cfif isdefined('form.DESlinea') and len(trim(form.DESlinea))>
	<cfinclude template="detNivelSalarial-form.cfm">
</cfif>