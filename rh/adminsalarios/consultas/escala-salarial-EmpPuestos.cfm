



<cfif  isdefined("url.DESlinea") and len(trim(url.DESlinea))  and isdefined("url.RHPcodigo")  and len(trim(url.RHPcodigo))>
	<cfset Notamin = 0>
	<cfset NotaMax = 0>
	<cfquery name="Rsnota" datasource="#session.DSN#">
		select 
			a.DESsalmin as salariomin_nivel ,
			a.DESsalmax as salariomax_nivel ,
			a.DESnivel,
			a.DESptodesde,
			a.DESptohasta,
			b.EScodigo, 
			b.ESdescripcion,
			c.salmin as salariomin_puesto ,
			c.salmax  as salariomax_puesto,
			case when  c.salmin is null then 0  else 1 end tiene
		from  RHDEscalaSalHAY a
			inner join RHEscalaSalHAY  b
				on a.ESid=b.ESid
				and  b.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			left outer join RHNivelesPuestoHAY  c
				on a.DESlinea=c.DESlinea
				and  c.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.RHPcodigo#">
		where  a.DESlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DESlinea#">
	</cfquery>
	
	<!--- Verifica si el puesto selecionado tiene o no una excepcion  --->
	<!--- Para tomar correctamente el salario mínimo y máximo         --->
	
	<cfif Rsnota.tiene eq 0>
		<cfset Notamin = Rsnota.salariomin_nivel>
		<cfset NotaMax = Rsnota.salariomax_nivel>
	<cfelse>
		<cfset Notamin = Rsnota.salariomin_puesto>
		<cfset NotaMax = Rsnota.salariomax_puesto>
	</cfif>
	
	<cfquery name="RsPuesto" datasource="#session.DSN#">
		select RHPcodigo,RHPdescpuesto
		from RHPuestos 
		where  RHPcodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#url.RHPcodigo#">
		and Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	</cfquery>
	<cfquery name="RsEmpleados" datasource="#session.DSN#">
		select a.LTsalario as salario,  DEnombre  || ' ' || DEapellido1 || ' ' ||  DEapellido2 as nombre,DEidentificacion,
		case when  a.LTsalario  between <cfqueryparam cfsqltype="cf_sql_float" value="#Notamin#">  and <cfqueryparam cfsqltype="cf_sql_float" value="#NotaMax#"> then  0  
		when  a.LTsalario  < <cfqueryparam cfsqltype="cf_sql_float" value="#Notamin#">  then  -1  
		when  a.LTsalario  > <cfqueryparam cfsqltype="cf_sql_float" value="#NotaMax#"> then  1   
		end as est_salario
		from LineaTiempo a
		inner join DatosEmpleado  b
				on a.DEid=b.DEid
				and a.Ecodigo  =b.Ecodigo 
		where getdate() between a.LTdesde and a.LThasta
		and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.RHPcodigo#">
		and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by DEidentificacion,DEapellido1,DEapellido2,DEnombre
	</cfquery>
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
	<cfoutput>			

		<table width="100%" cellpadding="3" cellspacing="0" bgcolor="##FAFAFA">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center" colspan="2" >
					<cf_EncReporte
							Titulo=""
							Color="##E3EDEF"
							Filtro1="Detalle de la escala salarial para el puesto : #RsPuesto.RHPcodigo#-#RsPuesto.RHPdescpuesto#"
							cols= "3"
						>
				</td>
			</tr>
			<tr>
				<td align="left" width="70%" nowrap ><font size="1"><strong>Escala salarial:</strong>&nbsp;#trim(Rsnota.EScodigo)# - #Rsnota.ESdescripcion#</font></td>
				<td rowspan="7" valign="middle">
					<table width="100%" cellpadding="3" cellspacing="0" border="0" >
						<tr>
							<td>
								<table width="100%" cellpadding="3" cellspacing="0" border="0" style="border:1px solid gray; " >
									<tr>
										<td align="center" colspan="2" ><strong>Indicador Salarial</strong></td>
									</tr>
									<tr>
										<td width="1%" align="left" valign="middle" ><img src="/cfmx/rh/imagenes/verde_ok.JPG"></td>
										<td  width="99%" align="left" valign="middle" >&nbsp;En el rango</td>
									</tr>
									<tr>
										<td width="1%" align="left" valign="middle" ><img src="/cfmx/rh/imagenes/Azul_up.gif"></td>
										<td width="99%" align="left" valign="middle" >&nbsp;Por encima del rango</td>
									</tr>
									<tr>
										<td width="1%" align="left" valign="middle" ><img src="/cfmx/rh/imagenes/rojo_down.gif"></td>
										<td  width="99%" align="left" valign="middle" >&nbsp;Por debajo del rango</td>
									</tr>
								</table>
							</td>
						<tr>
					</table>
				</td>
			</tr>
			<tr><td align="left" ><font size="1"><strong>Nivel de detalle:</strong>&nbsp;#trim(Rsnota.DESnivel)#</font></td></tr>
			<tr><td align="left" ><font size="1"><strong>Rango de salarios del nivel:</strong>&nbsp;[#LSNumberFormat(Rsnota.salariomin_nivel,'____,.__')# - #LSNumberFormat(Rsnota.salariomax_nivel,'____,.__')#]</font></td></tr>		
  		    <tr><td align="left" ><font size="1"><strong>Rango de puntos del nivel:</strong>&nbsp;[#LSNumberFormat(Rsnota.DESptodesde,'____,9')#&nbsp;-&nbsp;#LSNumberFormat(Rsnota.DESptohasta,'____,9')#]</font></td></tr>		
			<!--- <tr><td align="left" ><font size="1"><strong>Puesto:</strong>&nbsp;#RsPuesto.RHPcodigo#-#RsPuesto.RHPdescpuesto#</font></td></tr> --->
			<tr><td align="left" ><font size="1"><strong>Puntos HAY del puesto:</strong>&nbsp;#LSNumberFormat(url.PTSTOTAL,'____,9')#</font></td></tr>
			<tr><td align="left" ><font size="1"><strong>Salario inferior del puesto:</strong>&nbsp;#LSNumberFormat(Notamin,'____,.__')#</font></td></tr>
			<tr><td align="left" ><font size="1"><strong>Salario superior del puesto:</strong> &nbsp;#LSNumberFormat(NotaMax,'____,.__')#</font></td></tr>
			<tr><td align="left" >&nbsp;</td></tr>

			<tr><td align="center" ><font size="2"><strong>Lista de empleados</strong></font></td></tr>
		</table>		

		<table width="100%" cellpadding="3" cellspacing="0" bgcolor="##FAFAFA">
			<tr>
				<td width="10%" class="tituloListas" align="left"><strong>Identificaci&oacute;n</strong></td>
				<td width="60%" class="tituloListas" align="left"><strong>Empleado</strong></td>
				<td width="25%" class="tituloListas"  align="right"><strong>Salario</strong></td>
				<td width="5%"  class="tituloListas" align="left" >&nbsp;</td>
			</tr>			
			<cfif RsEmpleados.recordcount gt 0>
				<cfloop query="RsEmpleados">
				<tr>
					<td align="left" >#RsEmpleados.DEidentificacion#</td>
					<td align="left" >#RsEmpleados.nombre#</td>
					<td align="right" >#LSNumberFormat(RsEmpleados.salario,'____,.__')#</td>
					<td align="right" >
					<cfif RsEmpleados.est_salario eq 0>
						<img src="/cfmx/rh/imagenes/verde_ok.JPG" >
					<cfelseif  RsEmpleados.est_salario eq 1>
						<img src="/cfmx/rh/imagenes/Azul_up.gif" >							
					<cfelseif  RsEmpleados.est_salario eq -1>
						<img src="/cfmx/rh/imagenes/rojo_down.gif" >
					</cfif>
					</td>
				</tr>
				</cfloop>	
			<cfelse>	
			<td colspan="3" align="center"><strong>-- No se encontraron empleados para el puestos seleccionado --</strong></td>		
			</cfif>
			<td colspan="3" align="center"><strong>-- Fin del reporte --</strong></td>		
		</table>
	</cfoutput>
</cfif>




